`caddy`的 [2.10.0正式版本](https://github.com/caddyserver/caddy/releases/tag/v2.10.0) 已经加入了ECH的支持

要使用`caddy`自动配置`ech`则需要编译`cloudflare dns`插件，用于caddy自动添加`DNS`记录

### 编译`caddy`并加入`cloudflare DNS`插件的支持
1：一键安装`go`环境
```
bash <(curl -sSL https://cdn.jsdelivr.net/gh/sky22333/shell@main/go.sh)
```
2：下载`xcaddy`
```
go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
```
3：编译带`cloudflare dns`插件的`caddy`
```
xcaddy build --with github.com/caddy-dns/cloudflare
```
此时你的当前目录会生成一个已经包含了`cloudflare dns`插件的`caddy`二进制文件

### 以`debug`模式测试运行
创建`/etc/caddy/Caddyfile`文件，并写入以下文件
```
{
    debug
    dns cloudflare xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    ech ech.example.com

    log {
        output stdout
        format console
        level DEBUG
    }
}

test.example.com {
    root * /tmp
    file_server browse
    encode zstd gzip
}
```
#### 配置说明
`dns cloudflare`这个配置填CF的`区域 DNS API 令牌`

`ech ech.example.com`替换你的任意二级域名，或者第三方提供的ECH配置服务域名，用于发布`ECH`公钥

`test.example.com`替换你的域名，并且解析到你的IP，不要开小黄云

`root * /tmp`这个配置代表以网页浏览文件的形式，浏览你服务器的`/tmp`目录，这里只是测试为了方便起服务

### 启动`caddy`
```
sudo ./caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
```
不出意外的话就启动成功了，然后可以访问你的域名看下是否能成功访问

并且`/root/.local/share/caddy`目录会生成一个锁文件，如果需要重新部署则需要删除这个目录

CF里也会自动添加一个类型为`HTTPS`的解析记录

### 检查`ech`是否配置成功
```
dig test.example.com TYPE65
```
执行这个命令后，在输出的信息里可以看到有如下类似的信息就代表启用成功
```
ech=AEr+DQBGlwAgACBVSsnixVAfd/Ca9HP9JTf2O+B1kynOkZIwAMASDASDQABAAIASDASDADHw9lY2guZXhhbXBsZS5jb20AAA==
```

### 生产环境
移动二进制文件
```
mv ~/caddy /usr/bin/caddy
```
创建系统服务配置
```
touch /etc/systemd/system/caddy.service
```
写入配置
```
[Unit]
Description=Caddy Web Server
Documentation=https://caddyserver.com/docs/
After=network.target network-online.target
Wants=network-online.target

[Service]
User=root
Group=root
ExecStart=/usr/bin/caddy run --environ --config /etc/caddy/Caddyfile
ExecReload=/usr/bin/caddy reload --config /etc/caddy/Caddyfile
TimeoutStopSec=5s
LimitNOFILE=1048576
LimitNPROC=512
PrivateTmp=true
ProtectSystem=full
AmbientCapabilities=CAP_NET_BIND_SERVICE
CapabilityBoundingSet=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
```
管理命令
```
# 重新加载 systemd 配置
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

# 启动 Caddy
sudo systemctl start caddy

# 设置开机启动
sudo systemctl enable caddy

# 查看运行状态
sudo systemctl status caddy
```

### 生产环境反代配置示例
```
{
	dns cloudflare xxxxxxxxxxxxxxxxxxxxx
	ech ech.example.com
}

test.example.com {
	reverse_proxy localhost:8080
}
```

重新部署记得删除：`/root/.local/share/caddy`锁文件，和CF里的`HTTPS`解析记录