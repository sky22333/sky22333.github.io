
## 使用`sing-box`手搓`anytls`协议

- 客户端和服务端的`sing-box`必须要`v1.12.0`版本以上

- 需要一个域名解析到服务器地址。

- 以下配置需要自行去掉注释

### 服务端（运行在服务器里）

`sing-box`官方`beta`版安装脚本，因为目前正式版本暂不支持`anytls`，所以需要安装`beta`版
```
curl -fsSL https://sing-box.app/install.sh | sh -s -- --beta
```

配置路径：`/etc/sing-box/config.json`

服务端节点配置：
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
          "password": "aHR0cHM6Ly9ibG9nLjUyMDEzMTIwLnh5ei8="  // 协议认证密码
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

#### 命令：

重启	             `systemctl restart sing-box`

停止	             `systemctl stop sing-box`

开启开机自启	             `systemctl enable sing-box`

查看运行状态              `systemctl status sing-box`

查看日志	             `journalctl -u sing-box --output cat -e`



---

###   客户端（运行在本地设备）


1：下载`sing-box`内核[最新`beta`版](https://github.com/SagerNet/sing-box/releases/download/v1.12.0-beta.13/sing-box-1.12.0-beta.13-windows-amd64.zip)，

2：替换`v2rayN`的sing-box内核，路径在：`v2rayN-windows-64-desktop\v2rayN-windows-64\bin\sing_box`

3：将以下配置添加到`v2rayN`的自定义配置配置文件，内核选`sing-box`，确保已经替换了最新版内核。

4：注意：由于`sing-box`内核最新版本的配置语法有很大变化，切换最新内核后，`v2rayN`的tun功能可能会失效。依赖`sing-box`内核的协议也可能会无法使用，例如`hy2`协议。可以使用`clash`系列的`gui`客户端。`v2rayN`已经有`anytls`协议的相关PR，但是目前暂未合并。`clash-verge-rev`可以直接使用。

`v2rayN`客户端节点配置示例：

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
      "password": "aHR0cHM6Ly9ibG9nLjUyMDEzMTIwLnh5ei8=",  // 协议认证密码
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


---

### 客户端`clash-verge`配置文件

```
proxies:
- name: anytls节点
  type: anytls
  server: blog.52013120.xyz  # 服务端地址（你的域名）
  port: 8443 # 节点端口
  password: "aHR0cHM6Ly9ibG9nLjUyMDEzMTIwLnh5ei8="  # 协议认证密码
  client-fingerprint: chrome
  udp: true
  idle-session-check-interval: 30
  idle-session-timeout: 30
  min-idle-session: 0
  sni: "blog.52013120.xyz"  # 你的域名
  alpn:
    - h2
    - http/1.1
  skip-cert-verify: true
```


1：`订阅`——`新建`——类型选`Local`——`名称`随便填——`确认`——右键`编辑文件`——替换以上全部文件

2：此时`代理`菜单里就可以看到该节点：

![](https://img.erpweb.eu.org/imgs/2025/05/dd3ec9aef6b648a7.png)



### 以上客户端配置为简化版本，更多分流信息可以自己研究下。