### Docker部署哪吒监控

创建相关文件：
```
cd /homoe && mkdir -p template data
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
grpchost: grpc.example.com # 被控端连接域名(前端不开CDN可去掉这个配置)
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

（可选）对于`国内被控机`请替换国内脚本
```
https://gitee.com/naibahq/scripts/raw/main/install.sh
```

---

[项目地址](https://github.com/naiba/nezha)