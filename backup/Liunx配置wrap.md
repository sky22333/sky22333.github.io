[其他系统安装](https://pkg.cloudflareclient.com/)


## Docker版基于warp的sk5代理

[项目地址](https://hub.docker.com/r/monius/docker-warp-socks)

#### 1：普通部署 
```
docker run --restart=always -itd \
    --name warp_socks_v5 \
    -p 127.0.0.1:9091:9091 \
    ghcr.io/mon-ius/docker-warp-socks:v5
```
此时你的9091端口的所有流量将通过WARP出站

查看你的warp的IP：`curl -x "socks5h://127.0.0.1:9091" -fsSL "https://ip.sb"`


#### 2：WARP Plus 账户
```
docker run --privileged --restart=always -itd \
    --name warp_socks_plus \
    -e WGCF_LICENSE_KEY=你的plus密钥 \
    --cap-add NET_ADMIN \
    --cap-add SYS_MODULE \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    --sysctl net.ipv4.conf.all.src_valid_mark=1 \
    -v /lib/modules:/lib/modules \
    -p 127.0.0.1:9091:9091 \
    monius/docker-warp-socks
```
运行`curl -x "socks5h://127.0.0.1:9091" -fsSL "https://www.cloudflare.com/cdn-cgi/trace"` 看到`plus`则表示WARP Plus密钥应用成功。

#### 3：sk5增加密码

```
docker run --privileged --restart=always -itd \
    --name warp_socks_passwd \
    -e SOCK_USER=用户名 \
    -e SOCK_PWD=密码 \
    --cap-add NET_ADMIN \
    --cap-add SYS_MODULE \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    --sysctl net.ipv4.conf.all.src_valid_mark=1 \
    -v /lib/modules:/lib/modules \
    -p 9091:9091 \
    monius/docker-warp-socks
```
验证是否成功`curl -U "用户名:密码" -x "socks5h://127.0.0.1:9091" -fsSL "https://ifconfig.co"`


#### 4：自定义wireguard配置
```
docker run --privileged --restart=always -itd \
    --name warp_socks \
    --cap-add NET_ADMIN \
    --cap-add SYS_MODULE \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    --sysctl net.ipv4.conf.all.src_valid_mark=1 \
    -p 127.0.0.1:9091:9091 \
    -v /lib/modules:/lib/modules \
    -v ~/wireguard/:/opt/wireguard/:ro \
    monius/docker-warp-socks
```
创建`wireguard`目录，并创建`danted.conf`文件填入你的`wireguard`配置



## apt包安装：

```
curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
```
```
echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
```
```
sudo apt-get update && sudo apt-get install cloudflare-warp -y
```

注册客户端：

```
warp-cli registration new
```

开启代理模式：

```
warp-cli mode proxy
```

启动wrap：

执行此命令前必须`开启代理模式`否则机器可能失联
```
warp-cli connect
```


wrap将代理本地的`40000`端口

更改代理端口：`warp-cli proxy port 40000`

配置文件：`cd /var/lib/cloudflare-warp`

查看代理IP：
```
curl -x "socks5://127.0.0.1:40000" ipinfo.io
```



开启全局代理：
```
export ALL_PROXY=socks5://127.0.0.1:40000
```
关闭全局代理：
```
unset ALL_PROXY
```



关闭wrap：
```
warp-cli disconnect
```

###  一键脚本
```
bash <(wget -qO- https://gitlab.com/yishijie/warp-sh/raw/main/warp.sh) menu
```