
> ---
> ### **初始配置解析**
> 
> 默认的网络配置文件通常位于 `/etc/network/interfaces.d/50-cloud-init`。下面是一个双IPv6和IPv4配置的示例：
> 
> ```bash
> # 回环接口配置
> auto lo
> iface lo inet loopback
>     dns-nameservers 2606:4700:4700::1111 2001:4860:4860::8888
> 
> # IPv4基础配置
> auto eth0
> iface eth0 inet static
>     address x.x.x.x/24
>     dns-nameservers 2606:4700:4700::1111 2001:4860:4860::8888
>     gateway x.x.x.1
>     dns {'nameservers': ['2606:4700:4700::1111', '2001:4860:4860::8888'], 'search': []}
> 
> # 主IPv6配置
> iface eth0 inet6 static
>     address xxxx:xxxx:xxx:xxxx:xxxx:xxxx:xx:x/128
>     gateway xxxx:xxxx:xxx::1
> 
> # 次要IPv6配置
> iface eth0 inet6 static
>     address xxxx:xxx:xxx:xxx::xxxx:x/128
> ```
> 
> ---
> 
> ### **当前网络状态检查**
> 
> 可以使用 `ip a` 命令查看当前的网络接口状态：
> 
> ```bash
> root@server:/etc/network/interfaces.d# ip a
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>     inet 127.0.0.1/8 scope host lo
>     inet6 ::1/128 scope host noprefixroute
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
>     link/ether xx:xx:xx:xx:xx:xx brd ff:ff:ff:ff:ff:ff
>     inet x.x.x.x/24 brd x.x.255.255 scope global eth0
>     inet6 xxxx:xxx:xxx:xxx::xxxx:x/128 scope global
>     inet6 xxxx:xxxx:xxx:xxxx:xxxx:xxxx:xx:x/128 scope global
> ```
> 
> ---
> 
> ### **优化配置方案**
> 
> 以下是针对IPv4和IPv6的优化配置方案：
> 
> ```bash
> # 回环接口配置
> auto lo
> iface lo inet loopback
>     dns-nameservers 2606:4700:4700::1111 2001:4860:4860::8888
> 
> # IPv4基础配置
> auto eth0
> iface eth0 inet static
>     address x.x.x.x/24
>     dns-nameservers 2606:4700:4700::1111 2001:4860:4860::8888
>     gateway x.x.x.1
>     dns {'nameservers': ['2606:4700:4700::1111', '2001:4860:4860::8888'], 'search': []}
> 
> # 主IPv6（出口）配置
> iface eth0 inet6 static
>     address xxxx:xxxx:xxx:xxxx:xxxx:xxxx:xx:x/128
>     gateway xxxx:xxxx:xxx::1
> 
> # 次要IPv6（入口）配置 - 使用别名接口
> auto eth0:1
> iface eth0:1 inet6 static
>     address xxxx:xxx:xxx:xxx::xxxx:x/128
> ```
> 
> #### **配置说明**：
> 
> - **出口IP**：配置在主接口 `eth0`，用于出站流量。
> - **入口IP**：配置在别名接口 `eth0:1`，专用于接收入站流量。
> 
> ---
> 
> ### **应用配置**
> 
> 应用新的网络配置后，需要重启网络服务。执行以下命令：
> 
> ```bash
> systemctl restart networking
> ```
> 
> ---
> 
> ### **验证配置**
> 
> 重启网络服务后，用 `ip a` 命令检查网络状态：
> 
> ```bash
> root@server:/etc/network/interfaces.d# ip a
> [输出内容与之前类似，但注意入口地址状态变化]
>     inet6 xxxx:xxx:xxx:xxx::xxxx:x/128 scope global deprecated
> ```
> 
> #### **关键变化说明**：
> 
> - **次要IPv6地址**会显示为 `deprecated` 状态，这是预期行为。
>   - `deprecated` 状态表示该地址不会用于主动发起的出站连接，但仍可以接收入站连接。
> 
> ---
> 
> ### **TIPS**
> 
> - 怕有人看不懂，简单提一嘴IPv4，方法同样，在配置中区分出口和入口：
>   - **出口IPv4** 使用 `iface eth0 inet static`。
>   - **入口IPv4** 可使用别名接口，例如 `auto eth0:1`，并指定其IPv4地址。
> 
> 

---

鸣谢：

此文来自：https://www.nodeseek.com/post-361357-1