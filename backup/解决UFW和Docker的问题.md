目前新的解决方案只需要修改一个 UFW 配置文件即可，Docker 的所有配置和选项都保持默认。

修改 UFW 的配置文件 `/etc/ufw/after.rules`，在最后添加上如下规则：

    # BEGIN UFW AND DOCKER
    *filter
    :ufw-user-forward - [0:0]
    :ufw-docker-logging-deny - [0:0]
    :DOCKER-USER - [0:0]
    -A DOCKER-USER -j ufw-user-forward

    -A DOCKER-USER -j RETURN -s 10.0.0.0/8
    -A DOCKER-USER -j RETURN -s 172.16.0.0/12
    -A DOCKER-USER -j RETURN -s 192.168.0.0/16

    -A DOCKER-USER -p udp -m udp --sport 53 --dport 1024:65535 -j RETURN

    -A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 192.168.0.0/16
    -A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 10.0.0.0/8
    -A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 172.16.0.0/12
    -A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 192.168.0.0/16
    -A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 10.0.0.0/8
    -A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 172.16.0.0/12

    -A DOCKER-USER -j RETURN

    -A ufw-docker-logging-deny -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "[UFW DOCKER BLOCK] "
    -A ufw-docker-logging-deny -j DROP

    COMMIT
    # END UFW AND DOCKER

然后重启 UFW，`sudo systemctl restart ufw`。现在外部就已经无法访问 Docker 发布出来的任何端口了，但是容器内部以及私有网络地址上可以正常互相访问，而且容器也可以正常访问外部的网络。**可能由于某些未知原因，重启 UFW 之后规则也无法生效，请重启服务器。**

如果希望允许外部网络访问 Docker 容器提供的服务，比如有一个容器的服务端口是 `80`。那就可以用以下命令来允许外部网络访问这个服务：

    ufw route allow proto tcp from any to any port 80

这个命令会允许外部网络访问所有用 Docker 发布出来的并且内部服务端口为 `80` 的所有服务。

请注意，这个端口 `80` 是容器的端口，而非使用 `-p 0.0.0.0:8080:80` 选项发布在服务器上的 `8080` 端口。

如果有多个容器的服务端口为 80，但只希望外部网络访问某个特定的容器。比如该容器的私有地址为 `172.17.0.2`，就用类似下面的命令：

    ufw route allow proto tcp from any to 172.17.0.2 port 80

如果一个容器的服务是 UDP 协议，假如是 DNS 服务，可以用下面的命令来允许外部网络访问所有发布出来的 DNS 服务：

    ufw route allow proto udp from any to any port 53

同样的，如果只针对一个特定的容器，比如 IP 地址为 `172.17.0.2`：

    ufw route allow proto udp from any to 172.17.0.2 port 53

### 解释

在新增的这段规则中，下面这段规则是为了让私有网络地址可以互相访问。通常情况下，私有网络是比公共网络更信任的。

    -A DOCKER-USER -j RETURN -s 10.0.0.0/8
    -A DOCKER-USER -j RETURN -s 172.16.0.0/12
    -A DOCKER-USER -j RETURN -s 192.168.0.0/16

下面的规则是为了可以用 UFW 来管理外部网络是否允许访问 Docker 容器提供的服务，这样我们就可以在一个地方来管理防火墙的规则了。

    -A DOCKER-USER -j ufw-user-forward

例如，我们要阻止一个 IP 地址为 172.17.0.9 的容器内的所有对外连接，也就是阻止该容器访问外部网络，使用下列命令

    ufw route deny from 172.17.0.9 to any

下面的规则阻止了所有外部网络发起的连接请求，但是允许内部网络访问外部网络。对于 TCP 协议，是阻止了从外部网络主动建立 TCP 连接。对于 UDP，是阻止了所有小余端口 `32767` 的访问。为什么是这个端口的？由于 UDP 协议是无状态的，无法像 TCP 那样阻止发起建立连接请求的握手信号。在 GNU/Linux 上查看文件 `/proc/sys/net/ipv4/ip_local_port_range` 可以看到发出 TCP/UDP 数据后，本地源端口的范围，默认为 `32768 60999`。当从一个运行的容器对外访问一个 UDP 协议的服务时，本地端口将会从这个端口范围里面随机选择一个，服务器将会把数据返回到这个随机端口上。所以，我们可以假定所有容器内部的 UDP 协议的监听端口都小余 `32768`，不允许外部网络主动连接小余 `32768` 的 UDP 端口。

    -A DOCKER-USER -j DROP -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 192.168.0.0/16
    -A DOCKER-USER -j DROP -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 10.0.0.0/8
    -A DOCKER-USER -j DROP -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 172.16.0.0/12
    -A DOCKER-USER -j DROP -p udp -m udp --dport 0:32767 -d 192.168.0.0/16
    -A DOCKER-USER -j DROP -p udp -m udp --dport 0:32767 -d 10.0.0.0/8
    -A DOCKER-USER -j DROP -p udp -m udp --dport 0:32767 -d 172.16.0.0/12

    -A DOCKER-USER -j RETURN

如果一个容器在接受数据的时候，端口号没有遵循操作系统的设定，也就是说最小端口号要小余 `32768`。比如运行了一个 Dnsmasq 的容器，Dnsmasq 用于接受数据的最小端口号默认是 `1024`。那可以用下面的命令来允许 Dnsmasq 这个容器使用一个更大的端口范围来接受数据。

    ufw route allow proto udp from any port 53 to any port 1024:65535

因为 DNS 是一个非常常见的服务，所以已经有一条规则用于允许使用一个更大的端口范围来接受 DNS 数据包