## 使用`sing-box`手搓`anytls`协议

- 客户端和服务端的`sing-box`必须要`v1.12.0`版本以上

- 该协议配合TLS使用才能发挥最大效果，所以需要一个域名解析到服务器地址。

- 以下配置需要自行去掉注释

### 服务端配置示例

`/etc/sing-box/config.json`

```
{
  "log": {
    "level": "info"
  },
  "inbounds": [
    {
      "type": "anytls",
      "tag": "anytls-in",
      "listen": "::",
      "listen_port": 8443,  // 节点端口
      "users": [
        {
          "name": "sekai", // 名称随意填写
          "password": "aHR0cHM6Ly9ibG9nLjUyMDEzMTIwLnh5ei8="  // 协议认证的密码
        }
      ],
      "tls": {
        "enabled": true,
        "acme": {
          "domain": [
            "blog.52013120.xyz"  // 你的域名，通过acme自动申请证书
          ],
          "data_directory": "/etc/sing-box/", // 域名证书存放路径
          "default_server_name": "blog.52013120.xyz", // 你的域名
          "email": "123456789admin@gmail.com" // 用于申请证书的邮箱，可随意填写
        }
      }
    }
  ],
  "outbounds": [
    {
      "type": "direct",
      "tag": "direct-out"
    }
  ],
  "route": {
    "rules": []
  }
}
```



###   客户端配置示例

可添加到`v2rayN`自定义配置，内核选`sing-box`，客户端和服务端的`sing-box`必须要`v1.12.0`版本以上

`config.json`

```
{
  "log": {
    "level": "warn",
    "timestamp": true
  },
  "inbounds": [
    {
      "type": "mixed",
      "tag": "socks",
      "listen": "127.0.0.1", 
      "listen_port": 10808 // 本地入站端口
    }
  ],
  "outbounds": [
    {
      "type": "anytls",
      "tag": "anytls-out",
      "server": "blog.52013120.xyz", // 服务端地址（你的域名）
      "server_port": 8443,  // 节点端口
      "password": "aHR0cHM6Ly9ibG9nLjUyMDEzMTIwLnh5ei8=",  // 协议认证的密码
      "tls": {
        "enabled": true,
        "server_name": "blog.52013120.xyz"  // 你的域名
      }
    }
  ],
  "route": {
    "rules": [
      {
        "inbound": ["socks"],
        "outbound": "anytls-out"
      }
    ]
  }
}
```