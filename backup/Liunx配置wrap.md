[其他系统安装](https://pkg.cloudflareclient.com/)

debian系统安装：

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
