### 3xui通过api登录并保存cookie
```
curl -X POST http://127.0.0.1:2053/login \
     -H "Content-Type: application/json" \
     -d '{"username": "admin", "password": "admin"}' \
     -c cookies.txt
```

### 获取所有入站信息（qwer为面板路径）
```
curl -L -X GET http://127.0.0.1:2053/qwer/panel/api/inbounds/list -b cookies.txt
```

### 获取所有所有入站并过滤显示ID
```
curl -s -L -X GET "http://127.0.0.1:2053/qwer/panel/api/inbounds/list" -b cookies.txt | grep -o '"id":[0-9]*' | sed 's/"id"://' | sort -n | uniq
```

### 获取指定ID的入站（ID 2为例）
```
curl -X GET "http://127.0.0.1:2053/qwer/panel/api/inbounds/get/2" -b cookies.txt
```

### 删除入站（ID 2为例）
```
curl -X POST "http://127.0.0.1:2053/qwer/panel/api/inbounds/del/2" -b cookies.txt
```

### 添加入站（vless + ws）
```
curl -X POST "http://127.0.0.1:2053/qwer/panel/api/inbounds/add" \
  -b cookies.txt \
  -H "Content-Type: application/json" \
  -d '{
    "up": 0,
    "down": 0,
    "total": 0,
    "remark": "node1",
    "enable": true,
    "expiryTime": 0,
    "listen": "",
    "port": 18917,
    "protocol": "vless",
    "settings": "{\"clients\": [{\"id\": \"aeff4df1-3e30-4b5f-b6b8-635872b85aa0\",\"flow\": \"\",\"email\": \"hscqy7r3\",\"limitIp\": 0,\"totalGB\": 0,\"expiryTime\": 0,\"enable\": true,\"tgId\": \"\",\"subId\": \"ktl8jfe6bgnyon4g\",\"reset\": 0}],\"decryption\": \"none\",\"fallbacks\": []}",
    "streamSettings": "{\"network\": \"ws\",\"security\": \"none\",\"externalProxy\": [],\"tcpSettings\": {\"acceptProxyProtocol\": false,\"header\": {\"type\": \"none\"}}}",
    "tag": "inbound-18917",
    "sniffing": "{\"enabled\": false,\"destOverride\": [\"http\",\"tls\",\"quic\",\"fakedns\"],\"metadataOnly\": false,\"routeOnly\": false}",
    "allocate": "{\"strategy\": \"always\",\"refresh\": 5,\"concurrency\": 3}"
}'
```

### 添加入站（vless + grpc + reailty）
```
curl -X POST "http://127.0.0.1:2053/qwer/panel/api/inbounds/add" \
  -b cookies.txt \
  -H "Content-Type: application/json" \
  -d '{
    "up": 0,
    "down": 0,
    "total": 0,
    "remark": "node2",
    "enable": true,
    "expiryTime": 0,
    "listen": "",
    "port": 10654,
    "protocol": "vless",
    "settings": "{\"clients\": [{\"id\": \"bf7d39f5-257e-499f-acda-a9ea77b11bb4\",\"flow\": \"\",\"email\": \"y6kxqdix\",\"limitIp\": 0,\"totalGB\": 0,\"expiryTime\": 0,\"enable\": true,\"tgId\": \"\",\"subId\": \"cqeaws7i3w3z70rp\",\"reset\": 0}],\"decryption\": \"none\",\"fallbacks\": []}",
    "streamSettings": "{\"network\": \"grpc\",\"security\": \"reality\",\"externalProxy\": [],\"realitySettings\": {\"show\": false,\"xver\": 0,\"dest\": \"www.icloud.com:443\",\"serverNames\": [\"www.icloud.com\"],\"privateKey\": \"4FNf4m1nQVXcoO31xjk7noe82A7F2Dg2XEier3ogEBY\",\"minClient\": \"\",\"maxClient\": \"\",\"maxTimediff\": 0,\"shortIds\": [\"863f9613\",\"d978\",\"0f3abe\",\"79\",\"f014d5309f8954\",\"1311bf0f64f82159\",\"3d0cba0857f7\",\"c7ce204393\"],\"settings\": {\"publicKey\": \"3fFBgCb6PpNC_Kqph7UM2pXw4m1ck82ss4ov8YlmqWc\",\"fingerprint\": \"chrome\",\"serverName\": \"\",\"spiderX\": \"/\"}}}",
    "grpcSettings": "{\"serviceName\": \"\",\"authority\": \"\",\"multiMode\": false}",
    "tag": "inbound-10654",
    "sniffing": "{\"enabled\": false,\"destOverride\": [\"http\",\"tls\",\"quic\",\"fakedns\"],\"metadataOnly\": false,\"routeOnly\": false}",
    "allocate": "{\"strategy\": \"always\",\"refresh\": 5,\"concurrency\": 3}"
  }'
```

### 添加入站（ss协议）
```
curl -X POST "http://127.0.0.1:2053/qwer/panel/api/inbounds/add" \
  -b cookies.txt \
  -H "Content-Type: application/json" \
  -d '{
    "up": 0,
    "down": 0,
    "total": 0,
    "remark": "node3",
    "enable": true,
    "expiryTime": 0,
    "listen": "",
    "port": 15584,
    "protocol": "shadowsocks",
    "settings": "{\"method\": \"aes-256-gcm\",\"password\": \"pn8P4P/QQufYak532Eu4+jO2rovYatJIZPbPmzg6yw4=\",\"network\": \"tcp,udp\",\"clients\": [{\"method\": \"aes-256-gcm\",\"password\": \"WGfVnsKmHgs/xs259zTxRuya2RDvjKiU2WAqM5Sevic=\",\"email\": \"gcxfaord\",\"limitIp\": 0,\"totalGB\": 0,\"expiryTime\": 0,\"enable\": true,\"tgId\": \"\",\"subId\": \"yx89qjpbt2bo03fc\",\"reset\": 0}],\"ivCheck\": false}",
    "streamSettings": "{\"network\": \"tcp\",\"security\": \"none\",\"externalProxy\": [],\"tcpSettings\": {\"acceptProxyProtocol\": false,\"header\": {\"type\": \"none\"}}}",
    "tag": "inbound-15584",
    "sniffing": "{\"enabled\": false,\"destOverride\": [\"http\",\"tls\",\"quic\",\"fakedns\"],\"metadataOnly\": false,\"routeOnly\": false}",
    "allocate": "{\"strategy\": \"always\",\"refresh\": 5,\"concurrency\": 3}"
  }'
```



### API文档

- [API 文档](https://www.postman.com/hsanaei/3x-ui/collection/q1l5l0u/3x-ui)
- `/login` 使用 `POST` 用户名称 & 密码： `{username: '', password: ''}` 登录
- `/panel/api/inbounds` 以下操作的基础：

|  方法  | 路径                               | 操作                              |
| :----: | ---------------------------------- | --------------------------------- |
| `GET`  | `"/list"`                          | 获取所有入站                      |
| `GET`  | `"/get/id"`                       | 获取所有入站以及inbound.id        |
| `GET`  | `"/getClientTraffics/email"`      | 通过电子邮件获取客户端流量        |
| `GET`  | `"/createbackup"`                  | Telegram 机器人向管理员发送备份   |
| `POST` | `"/add"`                           | 添加入站                          |
| `POST` | `"/del/id"`                       | 删除入站                          |
| `POST` | `"/update/id"`                    | 更新入站                          |
| `POST` | `"/clientIps/email"`              | 客户端 IP 地址                    |
| `POST` | `"/clearClientIps/email"`         | 清除客户端 IP 地址                |
| `POST` | `"/addClient"`                     | 将客户端添加到入站                |
| `POST` | `"/:id/delClient/clientId"`       | 通过 clientId\* 删除客户端        |
| `POST` | `"/updateClient/clientId"`        | 通过 clientId\* 更新客户端        |
| `POST` | `"/:id/resetClientTraffic/email"` | 重置客户端的流量                  |
| `POST` | `"/resetAllTraffics"`              | 重置所有入站的流量                |
| `POST` | `"/resetAllClientTraffics/id"`    | 重置入站中所有客户端的流量        |
| `POST` | `"/delDepletedClients/id"`        | 删除入站耗尽的客户端 （-1： all） |
| `POST` | `"/onlines"`                       | 获取在线用户 （ 电子邮件列表 ）   |

\*- `clientId` 项应该使用下列数据

- `client.id`  VMESS and VLESS
- `client.password`  TROJAN
- `client.email`  Shadowsocks



### 参数解释
```
{
  "_comment": "上面是一些全局设置",
  "up": 0,  // 上传流量限制，单位为字节，0表示不限制
  "down": 0,  // 下载流量限制，单位为字节，0表示不限制
  "total": 0,  // 总流量限制，单位为字节，0表示不限制
  "remark": "node2",  // 节点备注，用于标识节点
  "enable": true,  // 是否启用此节点，true表示启用
  "expiryTime": 0,  // 过期时间，单位为秒，0表示永不过期
  "listen": "",  // 监听地址，空表示默认监听所有地址
  "port": 10654,  // 监听端口号
  "protocol": "vless",  // 协议类型，vless表示VLESS协议
  "settings": {
    "_comment": "此部分为协议相关设置",
    "clients": [
      {
        "id": "bf7d39f5-257e-499f-acda-a9ea77b11bb4",  // 客户端ID，唯一标识
        "flow": "",  // 流量控制，空表示没有流量限制
        "email": "y6kxqdix",  // 客户端的邮箱，用于标识
        "limitIp": 0,  // 限制IP，0表示不限制
        "totalGB": 0,  // 总流量限制，单位为GB，0表示不限制
        "expiryTime": 0,  // 客户端的过期时间，0表示永不过期
        "enable": true,  // 是否启用此客户端
        "tgId": "",  // TG ID，如果为空则表示没有设置
        "subId": "cqeaws7i3w3z70rp",  // 订阅ID
        "reset": 0  // 重置流量的时间，0表示不重置
      }
    ],
    "decryption": "none",  // 解密方式，none表示不使用解密
    "fallbacks": []  // 后备设置，空数组表示没有备用配置
  },
  "streamSettings": {
    "_comment": "此部分为流设置",
    "network": "grpc",  // 网络协议，grpc表示使用gRPC协议
    "security": "reality",  // 安全设置，reality表示使用Reality协议
    "externalProxy": [],  // 外部代理设置，空数组表示没有外部代理
    "realitySettings": {
      "_comment": "Reality协议设置",
      "show": false,  // 是否显示该设置
      "xver": 0,  // 协议版本号
      "dest": "www.icloud.com:443",  // 目标地址，www.icloud.com:443
      "serverNames": [
        "www.icloud.com"  // 服务器名称，用于TLS验证
      ],
      "privateKey": "4FNf4m1nQVXcoO31xjk7noe82A7F2Dg2XEier3ogEBY",  // Reality协议私钥
      "minClient": "",  // 最小客户端数，空表示没有限制
      "maxClient": "",  // 最大客户端数，空表示没有限制
      "maxTimediff": 0,  // 最大时间差，0表示不限制
      "shortIds": [
        "863f9613", "d978", "0f3abe", "79", "f014d5309f8954",
        "1311bf0f64f82159", "3d0cba0857f7", "c7ce204393"
      ],  // Reality协议的短ID列表
      "settings": {
        "publicKey": "3fFBgCb6PpNC_Kqph7UM2pXw4m1ck82ss4ov8YlmqWc",  // Reality协议的公钥
        "fingerprint": "chrome",  // 浏览器指纹，chrome表示谷歌浏览器
        "serverName": "",  // 服务器名称
        "spiderX": "/"  // 模拟爬虫的路径
      }
    }
  },
  "grpcSettings": {
    "_comment": "gRPC协议的设置",
    "serviceName": "",  // 服务名称，空表示没有指定
    "authority": "",  // 权威设置，空表示没有指定
    "multiMode": false  // 是否启用多模式，false表示关闭
  },
  "tag": "inbound-10654",  // 标签，用于标识该入站
  "sniffing": {
    "_comment": "嗅探设置",
    "enabled": false,  // 是否启用嗅探，false表示不启用
    "destOverride": [
      "http", "tls", "quic", "fakedns"  // 嗅探的目标协议
    ],
    "metadataOnly": false,  // 是否只嗅探元数据
    "routeOnly": false  // 是否只嗅探路由
  },
  "allocate": {
    "_comment": "流量分配设置",
    "strategy": "always",  // 分配策略，always表示始终分配
    "refresh": 5,  // 刷新时间，单位为秒
    "concurrency": 3  // 最大并发连接数
  }
}
```
