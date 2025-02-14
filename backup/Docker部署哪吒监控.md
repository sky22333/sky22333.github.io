### Docker部署哪吒监控

### v1版本
`docker-compose.yaml`配置
```
services:
  dashboard:
    image: ghcr.io/nezhahq/nezha
    restart: always
    ports:
      - "8008:8008"
    volumes:
      - ./data:/dashboard/data
```

`caddy`反代配置
```
example.com {
    reverse_proxy /proto.NezhaService/* h2c://127.0.0.1:8008
    
    reverse_proxy /* 127.0.0.1:8008
}
```

⚠️必须修改面板后台Agent对接地址，填`example.com:443`，并选中`使用 TLS 连接`

> 如果套了`cf`，则网络配置需要开启`grpc`选项


> 国内被控机替换脚本地址：`https://gitee.com/naibahq/scripts/raw/main/agent/install.sh`


后台路径 `/dashboard`
默认用户名密码 `admin` `admin`



### 配置多`oauth2`登录



```
oauth2:
  Gitee:
    clientid: "your id"
    clientsecret: "your secret"
    endpoint:
      authurl: "https://gitee.com/oauth/authorize"
      tokenurl: "https://gitee.com/oauth/token"
    scopes:
      - user_info
    userinfourl: "https://gitee.com/api/v5/user"
    useridpath: "id"
  GitHub:
    clientid: "your id"
    clientsecret: "your secret"
    endpoint:
      authurl: "https://github.com/login/oauth/authorize"
      tokenurl: "https://github.com/login/oauth/access_token"
    userinfourl: "https://api.github.com/user"
    useridpath: "id"
  Cloudflare:
    clientid: "your id"
    clientsecret: "your secret"
    endpoint:
      authurl: "https://XXXX.cloudflareaccess.com/cdn-cgi/access/sso/oidc/XXX/authorization"
      tokenurl: "https://XXX.cloudflareaccess.com/cdn-cgi/access/sso/oidc/XXX/token"
    scopes:
      - openid
      - profile
    userinfourl: "https://XXX.cloudflareaccess.com/cdn-cgi/access/sso/oidc/XXX/userinfo"
    useridpath: "sub"
```








---

### v0版本

创建相关文件：
```
cd /home && mkdir -p template data
```

`docker-compose.yml`配置

```
services:
  nezha:
    image: ghcr.io/naiba/nezha-dashboard:v0.20.13
    container_name: nezha
    restart: always
    ports:
      - "8080:80"
      - "5555:5555"
    volumes:
      - ./data:/dashboard/data
      - ./template:/dashboard/resource/template
```


在`data`目录添加`config.yaml`配置
```
debug: false
language: zh-CN
site:
    brand: 服务器监控
    cookiename: nezha-dashboard
    theme: server-status
    dashboardtheme: default
    customcode: ""
    customcodedashboard: ""
    viewpassword: ""
oauth2:
    type: github
    admin: github用户名
    admingroups: ""
    clientid: 验证ID
    clientsecret: 验证密钥
    endpoint: ""
    oidcdisplayname: OIDC
    oidcissuer: ""
    oidclogouturl: ""
    oidcregisterurl: ""
    oidcloginclaim: sub
    oidcgroupclaim: groups
    oidcscopes: openid,profile,email
    oidcautocreate: false
    oidcautologin: false
httpport: 80
grpcport: 5555
grpchost: grpc.example.com # 被控端连接域名(前端不开CDN可去掉这个这里的域名)
proxygrpcport: 0 # 被控端连接域名套CF需改成443
tls: false # 被控端连接域名套CF需改成true
enableplainipinnotification: false
disableswitchtemplateinfrontend: false
enableipchangenotification: false
ipchangenotificationtag: default
cover: 0
ignoredipnotification: ""
location: Asia/Shanghai
ignoredipnotificationserverids: {}
maxtcppingvalue: 1000
avgpingcount: 2
dnsservers: ""
```

`oauth2`回调URL示例：
```
https://example.com/oauth2/callback
```

`caddy`配置示例
```
# 前端域名
example.com {
    encode zstd gzip
    reverse_proxy localhost:8080
}

# 被控端连接域名(前端不开CDN可去掉这个配置)
grpc.example.com {
    reverse_proxy {
        to localhost:5555
        transport http {
            versions h2c 2
        }
    }
}
```


---

将面板中复制所得的指令中的sh的raw文件url替换成
```
https://cdn.jsdelivr.net/gh/sky22333/shell@main/nezha/install.sh
```
其他参数不变，然后去被控机安装即可。

---

[官方项目地址](https://github.com/nezhahq/nezha)
