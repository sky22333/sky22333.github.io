### Docker部署哪吒监控

### v1版本
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


如果域名开启了`cdn`，则复制出来的被控机脚本需要修改，并且`cf`里的网络配置需要开启`grpc`选项，修改示例：
```
curl -L https://raw.githubusercontent.com/nezhahq/scripts/main/agent/install.sh -o nezha.sh && chmod +x nezha.sh && env NZ_SERVER=你的域名:443 NZ_TLS=true NZ_CLIENT_SECRET=xxxxxxxxxxxxxxxxxxxxxx ./nezha.sh
```
> 主要修改了脚本中的域名后面的端口为`443`和`NZ_TLS=true`，其他不变。


后台路径 `/dashboard`
默认用户名密码 `admin` `admin`


---

### v0版本

创建相关文件：
```
cd /homoe && mkdir -p template data
```

`docker-compose.yml`配置

```
services:
  nezha:
    image: dapiaoliang666/nezha:v0.20.13
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
grpchost: grpc.example.com # 被控端连接域名
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
然后接着去被控机安装即可

---

[官方项目地址](https://github.com/naiba/nezha)
> 官方已经更新了v1版本，v0的镜像和脚本是我个人备份，不是官方的。