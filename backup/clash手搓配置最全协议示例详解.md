### clash手搓配置全部协议示例，附带详细注释说明，小白也会手搓

---
---

- 🔵本地配置，`Clash Verge`为例：

打开`Clash Verge` → 订阅 → 新建 → 类型选择`Local` → 名称自定义 → 点击保存 → 右键点击该配置 → 编辑文件 → 复制配置 → 修改保存

---
---

- 🔵云端配置：

1：部署一个站点，站点目录里创建`clash.yaml`文件

2：使用`caddy`代理站点目录，例如你的`clash.yaml`配置放在`/var/www`下，增加相应的权限

3：则`caddy`可以这样配置：
```
example.com {
    root * /var/www
    encode zstd gzip
    file_server
}
```

4：部署完成后就可以远程拉取订阅，订阅地址示例：
```
https://example.com/clash.yaml
```


5：如果你已经有一个现成的站点，则直接将`clash.yaml`配置放在站点目录即可，其他同理。

6：为了节点的安全起见，建议手动本地配置，如果你想分享给你的好友拉取订阅，拉取配置成功后可以将`clash.yaml`文件的读取权限全部取消。

---
---


- 🔵15个协议配置示例

```
#（一区）=============================（clash配置）
#dns可自行修改
port: 7890
allow-lan: true
mode: rule
log-level: info
unified-delay: true
global-client-fingerprint: chrome
dns:
  enable: true
  listen: :53
  ipv6: true
  enhanced-mode: fake-ip
  fake-ip-range: 198.18.0.1/16
  default-nameserver: 
    - 223.5.5.5
    - 8.8.8.8
  nameserver:
    - https://dns.alidns.com/dns-query
    - https://doh.pub/dns-query
  fallback:
    - https://1.0.0.1/dns-query
    - tls://dns.google
  fallback-filter:
    geoip: true
    geoip-code: CN
    ipcidr:
      - 240.0.0.0/4


#（二区）==============================（代理协议）
#当前所有协议节点配置模版，按需求修改，如某协议节点不用，则无需删除，确保三区代理分流中没有该name节点名称即可
proxies:
#==============================（shadowsocks节点）
- name: shadowsocks节点                                       # 可自定义名称
  type: ss
  server: 1.2.3.4                                            # 服务器IP
  port: 8388                                                 # 服务器端口
  cipher: chacha20-ietf-poly1305                             # 加密方式，可根据需求更改
  password: yourpassword                                     # 密码
  udp: true                                                  # 是否启用UDP，可选

#==============================（SOCKS5节点）
- name: socks5节点                                            # 可自定义名称
  type: socks5
  server: 1.2.3.4                                            # 服务器IP
  port: 9527                                                 # 服务器端口
  username: yourusername                                     # 用户名（如果需要）
  password: yourpassword                                     # 密码（如果需要）
  udp: true                                                  # 是否启用UDP，可选

#==============================（vless-reality-vision节点）
- name: vless-reality-vision节点               #可自定义名称
  type: vless
  server: 1.2.3.4                             #解析的域名或IP
  port: 12345                                 #自定义的端口
  uuid: f897325d-053d-45d1-899c-566692331f8   #自定义的uuid
  network: tcp
  udp: true
  tls: true
  flow: xtls-rprx-vision
  servername: www.tesla.com                   #自定义的第三方域名
  reality-opts: 
    public-key: 4CiE7y7ZPBXIZWzMwphuSH7qdZyisNjD3CDQGjmilmI    #自定义的public-key
    short-id: a8c031ce                        #自定义的short-id
  client-fingerprint: chrome                  #自定义的浏览器指纹

#==============================（vless-reality-grpc节点）
- name: vless-reality-grpc节点                  #可自定义名称
  type: vless
  server: 1.2.3.4                               #解析的域名或IP
  port: 12345                                   #自定义的端口
  uuid: 335ec5dd-61b1-4413-980e-5e009968f633    #自定义的uuid
  network: grpc
  tls: true
  udp: true
  flow:
  client-fingerprint: chrome                    #自定义的浏览器指纹
  servername: www.tesla.com                     #自定义的第三方域名
  grpc-opts:
    grpc-service-name: "abcd"                  #" "内自定义的字符
  reality-opts:
    public-key: Aqp9oy2EFi4NNfRMZa3I3HdGhHbOIiSDZ8L28UCF73k    #自定义的public-key
    short-id: 24410d1c                          #自定义的short-id

#==============================（vless-xtls-rprx-vision节点）
- name: vless-xtls-rprx-vision节点              #可自定义名称
  type: vless
  server: example.com                      #解析的域名
  port: 12345                                  #自定义的端口
  uuid: 5f74f86b-3ee8-44f4-adc4-6666be3d315    #自定义的uuid
  network: tcp
  tls: true
  udp: true
  flow: xtls-rprx-vision
  client-fingerprint: chrome

#==============================（vless-ws-tls节点）
- name: vless-ws-tls节点                           #可自定义名称
  type: vless
  server: example.com                          #解析的域名或者优选域名IP
  port: 12345                                      #自定义的端口
  uuid: 3cc9a51c-db76-4ad2-a76b-8cb993bddb73       #自定义的uuid
  udp: true
  tls: true
  network: ws
  servername: abc.abcd.eu.org                     #sni域名，与下面的host一致
  ws-opts:
    path: "/?ed=2560"                              #" "内自定义的path路径
    headers:
      Host: abc.abcd.eu.org                       #host域名，与上面的servername一致

#==============================（vless-ws节点）
- name: vless-ws节点                               #可自定义名称
  type: vless
  server: example.com                          #解析的域名或者优选域名IP
  port: 8880                                       #自定义的端口
  uuid: 77a571fb-4fd2-4b37-8596-1b7d9728bb5c       #自定义的uuid
  udp: true
  tls: false
  network: ws
  servername: abc.abcd.eu.org                     #sni域名，与下面的host一致
  ws-opts:
    path: "/?ed=2560"                              #" "内自定义的path路径
    headers:
      Host: abc.abcd.eu.org                       #host域名，与上面的servername一致

#==============================（vmess-ws-tls节点）
- name: vmess-ws-tls节点                           #可自定义名称
  type: vmess
  server: example.com                          #解析的域名或者优选域名IP
  port: 12345                                      #自定义的端口
  uuid: 3cc9a51c-db76-4ad2-a76b-8cb993bddb73       #自定义的uuid
  alterId: 0
  cipher: auto
  udp: true
  tls: true
  network: ws
  servername: abc.abcd.eu.org                     #sni域名，与下面的host一致
  ws-opts:
    path: "/?ed=2560"                              #自定义的path路径
    headers:
      Host: abc.abcd.eu.org                       #host域名，与上面的servername一致

#==============================（vmess-ws节点）
- name: vmess-ws节点                               #可自定义名称
  type: vmess
  server: example.com                          #解析的域名或者优选域名IP
  port: 8880                                       #自定义的端口
  uuid: 77a571fb-4fd2-4b37-8596-1b7d9728bb5c       #自定义的uuid
  alterId: 0
  cipher: auto
  udp: true
  tls: false
  network: ws
  servername: abc.abcd.eu.org                     #sni域名，与下面的host一致
  ws-opts:
    path: "/?ed=2560"                              #" "内自定义的path路径
    headers:
      Host: abc.abcd.eu.org                       #host域名，与上面的servername一致

#==============================（trojan-tcp-tls节点）
- name: trojan-tcp-tls节点                         #可自定义名称
  type: trojan
  server: example.com                          #解析的域名
  port: 12345                                      #自定义的端口
  password: 123456789                              #自定义的密码
  client-fingerprint: chrome
  udp: true
  sni: example.com                             #sni域名，与上面server地址一致
  alpn:
    - h2
    - http/1.1
  skip-cert-verify: false

#==============================（hysteria2证书节点）
- name: hysteria2证书节点                            #可自定义名称
  type: hysteria2 
  server: example.com                            #解析的域名
  port: 12345                                        #自定义的端口，不支持多端口
  password: 123456                                   #自定义的密码
  obfs: salamander                                   #obfs混淆开启，未开启请删除此行
  obfs-password: 123456                              #obfs混淆密码，未开启请删除此行
  alpn:
    - h3
  sni: example.com                               #sni域名，与上面server地址一致 
  skip-cert-verify: false
  fast-open: true

#==============================（hysteria2自签节点）
- name: hysteria2自签节点                             #可自定义名称
  type: hysteria2                                      
  server: 1.2.3.4                                     #服务器本地IP
  port: 12345                                         #自定义的端口，不支持多端口
  password: 123456                                    #自定义的密码 
  obfs: salamander                                    #obfs混淆开启，未开启请删除此行 
  obfs-password: 123456                               #obfs混淆密码，未开启请删除此行     
  alpn:
    - h3
  sni: www.bing.com                                    #自签证书
  skip-cert-verify: true
  fast-open: true
    
#==============================（tuic-V5证书节点）
- name: tuic-V5证书节点                              #可自定义名称
  server: example.com                          #解析的域名或IP
  port: 12345                                      #自定义的端口
  type: tuic
  uuid: a806923b-737c-4581-8b13-56666f911866       #自定义的uuid
  password: a806923b-737c-4581-8b13-56666f911866   #自定义的密码
  alpn: [h3]
  disable-sni: true
  reduce-rtt: true
  udp-relay-mode: native
  congestion-controller: bbr
  sni: example.com                            #sni域名，与上面server地址一致     
  skip-cert-verify: false


#==============================（tuic-V5自签节点）
- name: tuic-V5自签节点                              #可自定义名称
  server: 1.2.3.4                                   #服务器本地IP
  port: 12345                                       #自定义的端口
  type: tuic
  uuid: a806923b-737c-4581-8b13-56666f911866       #自定义的uuid
  password: a806923b-737c-4581-8b13-56666f911866   #自定义的密码
  alpn: [h3]
  disable-sni: true
  reduce-rtt: true
  udp-relay-mode: native
  congestion-controller: bbr
  sni: www.bing.com                                 #自签证书   
  skip-cert-verify: true
  

#==============================（warp-wireguard节点）  
- name: warp-wireguard节点                                   #可自定义名称
  type: wireguard         
  server: 162.159.193.10                                     #可自定义优选对端IP，与下面port的端口相对应
  port: 2408                                                 #可自定义优选对端IP，与上面server的IP相对应
  ip: 172.16.0.2
  ipv6: 2606:4700:190:814e:7de3:5ddb:9d3e:9359               #与private-key相对应，如删除本行，表示仅IPV4
  public-key: bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
  private-key: gK3C8ijdVlT7sd5fsdf5ssdfgsdfgsdfgobT2U+rgHo=  #获取private-key，私key
  udp: true



#（三区）==============================（代理分流）
#分流组可自行创建添加，proxies参数下的name节点名称，按需求自行增减，确保出现的name节点名称在二区代理协议中可查找
proxy-groups:
- name: 负载均衡
  type: load-balance
  url: https://cp.cloudflare.com/generate_204
  interval: 300
  strategy: round-robin
  proxies:
    - warp-wireguard节点                                  #自定义添加协议的name字段
    - vless-ws-tls节点
    - vless-ws节点

- name: 自动选择
  type: url-test
  url: https://cp.cloudflare.com/generate_204
  interval: 300
  tolerance: 50
  proxies:
    - vless-reality-vision节点                            #自定义添加协议的name字段
    - vless-reality-grpc节点
    
- name: 🌍选择代理节点
  type: select
  proxies:
    - 负载均衡                                            #自定义添加协议的name字段
    - 自动选择
    - DIRECT
    - shadowsocks节点
    - socks5节点
    - vless-reality-vision节点                                    
    - vless-reality-grpc节点
    - vless-xtls-rprx-vision节点
    - vless-ws-tls节点
    - vless-ws节点
    - vmess-ws-tls节点
    - vmess-ws节点
    - trojan-tcp-tls节点
    - hysteria2证书节点
    - hysteria2自签节点
    - tuic-V5证书节点
    - tuic-V5自签节点 
    - warp-wireguard节点

# ==============================（常见流量处理方式）==============================
# DIRECT: 流量直接连接，无需代理。
# PROXY/选择代理节点: 流量通过指定的代理节点转发。
# REJECT: 拒绝特定流量。

# ==============================（常见匹配规则类型）==============================
# GEOIP: 根据 IP 的地理位置匹配流量（例如，来自特定国家或地区的流量）。
# DOMAIN-SUFFIX: 基于域名后缀（如 example.com）匹配流量。
# DOMAIN-KEYWORD: 基于域名中的关键词匹配流量。
# IP-CIDR: 根据 IP 范围匹配流量。
# MATCH: 匹配所有流量，通常作为默认策略。

#==============================（四区）==============================（代理规则示例）
rules:
  - GEOIP,LAN,DIRECT                        # 局域网流量直连
  - GEOIP,CN,DIRECT                         # 中国大陆流量直连
  - DOMAIN-SUFFIX,google.com,🌍选择代理节点  # 针对特定域名的流量使用代理
  - DOMAIN-KEYWORD,facebook,🌍选择代理节点   # 针对包含特定关键词的域名使用代理
  - DOMAIN-SUFFIX,youtube.com,🌍选择代理节点 # 针对 YouTube 流量使用代理
  - DOMAIN-SUFFIX,instagram.com,🌍选择代理节点 # 针对 Instagram 流量使用代理
  - IP-CIDR,192.168.0.0/16,DIRECT           # 指定 IP 范围的流量直连
  - IP-CIDR,10.0.0.0/8,DIRECT               # 指定 IP 范围直连
  - GEOIP,US,🌍选择代理节点                 # 针对美国地区的流量使用代理
  - GEOIP,JP,🌍选择代理节点                 # 针对日本地区的流量使用代理
  - MATCH,🌍选择代理节点                    # 其他所有流量走代理
```


---

- 🔵客户端多入站对应多出站配置示例

```
# 客户端多入站对应多出站配置示例
# 基本配置
port: 7890                # HTTP 代理端口
socks-port: 7891          # 全局 SOCKS5 代理端口
allow-lan: true           # 允许局域网连接
mode: rule                # 规则模式
log-level: info           # 日志级别
external-controller: :9090 # 外部控制器端口

# 监听器配置
listeners:
  - name: "SOCKS5 Inbound 1"
    type: socks
    port: 7891                            # 入站端口
    rule: "FINAL,🇺🇸 VLESS美国"  # 将所有流量转发到美国 VLESS 节点

  - name: "SOCKS5 Inbound 2"
    type: socks
    port: 7892                         # 入站端口
    rule: "FINAL,🇯🇵 SS日本"     # 将所有流量转发到日本 Shadowsocks 节点

  - name: "SOCKS5 Inbound 3"
    type: socks
    port: 7893                           # 入站端口
    rule: "FINAL,🇬🇧 HY2英国"    # 将所有流量转发到英国 Hysteria2 节点

  - name: "SOCKS5 Inbound 4"
    type: socks
    port: 7894                            # 入站端口
    rule: "FINAL,🇭🇰 香港reality" # 将所有流量转发到香港 REALITY 节点

# 代理配置
proxies:
  - name: 🇺🇸 VLESS美国
    type: vless
    server: www.example1.com  # 服务器地址
    port: 443                 # 服务器端口
    uuid: e0256bbf-8aa2-4e51-96b4-c022f029564a  # 用户 UUID
    tls: true                 # 启用 TLS
    servername: example1.com  # TLS SNI
    network: ws               # 使用 WebSocket
    ws-opts:
      path: /path             # WebSocket 路径
      headers:
        Host: example1.com    # WebSocket Host 头
    udp: true                 # 启用 UDP

  - name: 🇯🇵 SS日本
    type: ss
    server: www.example2.com  # 服务器地址
    port: 8388                # 服务器端口
    cipher: aes-256-gcm       # 加密方式
    password: your_password   # 密码
    udp: true                 # 启用 UDP

  - name: 🇬🇧 HY2英国
    type: hysteria2
    server: www.example3.com  # 服务器地址
    port: 443                 # 服务器端口
    password: your_password   # 密码
    alpn:
      - h3                    # ALPN 协商协议
    sni: example3.com         # SNI
    skip-cert-verify: false   # 是否跳过证书验证
    hopinterval: 10           # Hop 间隔

  # VLESS REALITY XTLS Vision 节点
  - name: 🇭🇰 香港reality
    type: vless
    server: example4.com      # 服务器地址
    port: 443                 # 服务器端口
    uuid: 12345678-1234-1234-1234-123456789012  # 用户 UUID
    network: tcp              # 使用 TCP
    tls: true                 # 启用 TLS
    udp: true                 # 启用 UDP
    flow: xtls-rprx-vision    # 使用 XTLS Vision 流控
    client-fingerprint: chrome # 客户端指纹
    servername: www.swift.com  # REALITY 伪装域名
    reality-opts:
      public-key: yourPublicKey    # REALITY 公钥
      short-id: yourShortId        # REALITY short-id

# 代理组配置
proxy-groups:
  - name: 🚀 节点选择
    type: select              # 选择类型，允许手动选择
    proxies:
      - 🇺🇸 VLESS美国
      - 🇯🇵 SS日本
      - 🇬🇧 HY2英国
      - 🇭🇰 香港reality
      - DIRECT                # 直连选项

# 规则配置
rules:
  - MATCH,🚀 节点选择         # 匹配所有流量，转发到节点选择组

# 其他规则配置
```

---
---


### 参数讲解


| 参数名称(全局配置)                | 作用                                                         |
|-------------------------|--------------------------------------------------------------|
| mixed-port              | HTTP(S) 和 SOCKS4(A)/SOCKS5 代理服务共用一个端口              |
| allow-lan               | 设置为 true 以允许局域网的连接（可用来共享代理）              |
| bind-address            | 仅当 allow-lan 为 true 时有效                                |
| ipv6                    | 当设置为 false 时, 解析器不会将主机名解析为 IPv6 地址          |
| mode                    | Clash 路由工作模式                                           |
| log-level               | 日志级别: info / warning / error / debug / silent            |
| external-controller     | RESTful Web API 监听地址                                     |
| secret                  | RESTful API 的口令(可选)                                     |
| dns                     | DNS 服务设置                                                 |
| proxies                 | 代理节点                                                     |
| proxy-groups            | 策略组                                                       |
| rules                   | 分流规则                                                     |

| 参数名称(DNS配置)                 | 作用                                                        |
|------------------------|-------------------------------------------------------------|
| enable                 | 是否启动自定义dns模块                                        |
| prefer-h3              | 是否优先使用 DOH 的 http/3                                  |
| use-hosts              | 是否查询配置中的 hosts                                       |
| use-system-hosts       | 是否查询系统 hosts                                           |
| respect-rules          | dns 连接跟随 rules，需配置proxy-server-nameserver           |
| listen                 | DNS 服务监听，仅支持 udp                                     |
| ipv6                   | 是否解析 IPV6, 如为 false, 则回应 AAAA 的空解析              |
| enhanced-mode          | DNS 处理模式                                                |
| fake-ip-range          | fakeip 下的 IP 段设置                                        |
| fake-ip-filter         | fakeip 过滤，以下地址不会下发 fakeip 映射用于连接            |
| default-nameserver     | 默认 DNS, 用于解析nameserver中的加密 dns                    |
| nameserver-policy      | 指定域名查询的解析服务器，可使用 geosite                    |
| nameserver             | 默认的域名解析服务器                                        |
| proxy-server-nameserver| 代理节点域名解析服务器                                       |
| fallback               | 后备域名解析服务器                                           |
| fallback-filter        | 后备域名解析服务器筛选                                       |
| geoip                  | 是否启用 fallback filter                                     |
| geoip-code             | 可选值为 国家缩写                                           |
| geosite                | 可选值为 geosite 内包含的集合                               |
| ipcidr                 | 书写内容为 IP/掩码                                          |
| domain                 | 这些域名被视为已污染，匹配到这些域名，会直接使用 fallback解析|

| 参数名称(策略组配置)             | 作用                                                       |
|--------------------|------------------------------------------------------------|
| name               | 策略组的名字                                               |
| type               | 策略组的类型                                               |
| proxies            | 引入代理节点或其他策略组                                    |
| url                | 健康检查测试地址                                           |
| interval           | 健康检查间隔，如不为 0 则启用定时测试，单位为秒            |
| lazy               | 懒惰状态，默认为true,未选择到当前策略组时，不进行测试      |
| timeout            | 健康检查超时时间，单位为毫秒                               |
| max-failed-times   | 最大失败次数，超过则触发一次强制健康检查                   |
| tolerance          | 节点切换容差，单位 ms                                      |

> 策略组是我们选择哪个网站选用什么方式连接的前置条件，简而言之就是给你的节点如何分流进行分组。


| 匹配方式(分流规则)             | 匹配内容                                                   | 举例                          |
|--------------------|------------------------------------------------------------|-------------------------------|
| DOMAIN             | 匹配完整域名                                               | ad.com                        |
| DOMAIN-SUFFIX      | 匹配域名后缀                                               | google.com                    |
| DOMAIN-KEYWORD     | 使用域名关键字匹配                                         | google                        |
| DOMAIN-REGEX       | 域名正则表达式匹配                                         | ^abc.*com                     |
| GEOSITE            | 匹配 Geosite 内的域名                                      | youtube                       |
| IP-CIDR/IP-CIDR6   | 匹配 IP 地址范围                                           | 127.0.0.0/8                   |
| IP-SUFFIX          | 匹配 IP 后缀范围                                           | 8.8.8.8/24                    |
| IP-ASN             | 匹配 IP 所属 ASN                                           | 13335                         |
| GEOIP              | 匹配 IP 所属国家代码                                       | CN                            |
| SRC-GEOIP          | 匹配来源 IP 所属国家代码                                   | cn                            |
| SRC-IP-ASN         | 匹配来源 IP 所属 ASN                                       | 9808                          |
| SRC-IP-CIDR        | 匹配来源 IP 地址范围                                       | 192.168.1.201/32              |
| SRC-IP-SUFFIX      | 匹配来源 IP 后缀范围                                       | 192.168.1.201/8               |
| DST-PORT           | 匹配请求目标端口范围                                       | 80                            |
| SRC-PORT           | 匹配请求来源端口范围                                       | 7777                          |
| IN-PORT            | 匹配入站端口,可用端口范围                                  | 7890                          |
| IN-TYPE            | 匹配入站类型                                               | SOCKS/HTTP                    |
| IN-USER            | 匹配入站用户名，支持使用 / 分隔多个用户名                  | linuxdo                       |
| IN-NAME            | 匹配入站名称                                               | ss                            |
| PROCESS-PATH       | 使用完整进程路径匹配                                       | D:\chrome.exe                 |
| PROCESS-PATH-REGEX | 使用进程路径正则表达式匹配                                 | *bin/wget                     |
| PROCESS-NAME       | 使用进程匹配，在Android平台可以匹配包名                    | chrome.exe                    |
| PROCESS-NAME-REGEX | 使用进程名称正则表达式匹配，在Android平台可以匹配包名      | curl$                         |
| UID                | 匹配 Linux USER ID                                         | 1001                          |
| NETWORK            | 匹配tcp或者udp                                             | udp                           |
| DSCP               | 匹配DSCP标记 (仅限 tproxy udp 入站)                        | 4                             |
| RULE-SET           | 引用规则集合，需配置rule-providers                         | providername                  |
| AND/OR/NOT         | 逻辑规则，需要注意括号的使用                               | ((DOMAIN,baidu.com),(NETWORK,UDP)) |
| SUB-RULE           | 匹配至子规则,需要注意括号的使用                            | (NETWORK,tcp)                 |
| MATCH              | 匹配所有请求，无需条件                                     |                               |

> 分流规则最终决定了哪个网站选用什么方式连接，通过不同的匹配策略自由地选择自己的分流规则。
> 
> 优先级按照从上到下的顺序匹配，上面的优先级高于下面。