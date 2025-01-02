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


如果域名开启了`cdn`，则复制出来的被控机脚本需要修改，并且`cf`里的网络配置需要开启`grpc`选项，修改示例：
```
curl -L https://raw.githubusercontent.com/nezhahq/scripts/main/agent/install.sh -o nezha.sh && chmod +x nezha.sh && env NZ_SERVER=你的域名:443 NZ_TLS=true NZ_CLIENT_SECRET=xxxxxxxxxxxxxxxxxxxxxx ./nezha.sh
```
> 主要修改了脚本中的域名后面的端口为`443`和`NZ_TLS=true`，其他不变。


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




### 美化

放到自定义代码（样式和脚本）

<details>
  <summary>美化一</summary>
 
```
<!-- 引入霞鹜文楷字体 -->
<script>
    var link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = 'https://cdn.bootcdn.net/ajax/libs/lxgw-wenkai-screen-webfont/1.7.0/style.min.css';
    document.head.appendChild(link);
</script>
<!-- 设置页面字体 -->
<style>
    * {
        font-family: 'LXGW WenKai Screen'; /* 设置所有元素使用霞鹜文楷字体 */
    }
    h1, h2, h3, h4, h5 {
        font-family: 'LXGW WenKai Screen', sans-serif; /* 设置标题使用霞鹜文楷字体 */
    }
</style>
<script>
    window.CustomLogo = "https://img.zer02.cn/upload/202412/676fed804b61b5.30256068.jpg"; /* 自定义Logo */
    window.ShowNetTransfer  = "true"; /* 卡片显示上下行流量 */
    window.DisableAnimatedMan  = "true"; /* 关掉动画人物插图 */
    window.CustomDesc ="云监测"; /* 自定义描述 */
    window.CustomBackgroundImage="https://img.zer02.cn/upload/202412/67723c8dc5e2c0.84995785.webp"; /* 页面背景图 */
    window.CustomMobileBackgroundImage="https://t.mwm.moe/mp"; /* 手机端背景图 */
</script>
<!-- 调整02半身图 -->
<script>
var observer = new MutationObserver(function(mutationsList, observer) {
    var xpath = "/html/body/div/div/main/div[2]/section[1]/div[4]/div";
    var container = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;

    if (container) {
        observer.disconnect();
        var existingImg = container.querySelector("img");
        if (existingImg) {
            container.removeChild(existingImg);
        }
        var imgElement = document.createElement("img");
        imgElement.src = "https://img.zer02.cn/upload/202412/676fbb0c9725f9.77069239.png";  /* 02半身图 */
        imgElement.style.position = "absolute";
        imgElement.style.right = "-5px";
        imgElement.style.top = "-117px";
        imgElement.style.zIndex = "10";
        imgElement.style.width = "90px";
        container.appendChild(imgElement);
    }
});
var config = { childList: true, subtree: true };
observer.observe(document.body, config);
</script>
```

</details>



<details>
  <summary>视频背景</summary>

```
<meta name="referrer" content="no-referrer">
<div class="video-box">
  <!-- 视频背景源 -->
  <video id="myVideo" muted
    src="https://www.douyin.com/aweme/v1/play/?video_id=v0200fg10000clk1n23c77ufubooagpg&line=0&file_id=16946e5b1182485490028bc5c0bcc4b7&sign=c0c4f7a6fd4a99a7b1691dada6782081&is_play_url=1&source=PackSourceEnum_AWEME_DETAIL"
    autoplay playsinline loop>

  </video>
</div>
<style>
  :root {
    --custom-border-color: rgba(13, 11, 9, 0.1);
    --custom-background-color: rgba(13, 11, 9, 0.4);
    --custom-background-image: unset;
  }

  .dark #root {
    background-color: unset !important;
  }

  .dark .bg-card {
    background-color: var(--custom-background-color);
    backdrop-filter: blur(4px);
    border: 1px solid rgba(13, 11, 9, 0.1);
    box-shadow: 0 4px 6px rgba(13, 11, 9, 0.2);
    /* 阴影效果 */
  }

  .focus\:text-accent-foreground:focus {
    background-color: rgba(13, 11, 9, 0.5);
  }

  .dark .text-muted-foreground {
    color: #fff;
  }

  .dark\:bg-stone-700:is(.dark *) {
    --tw-bg-opacity: 0.5;
  }

  html.dark * {
    border-color: var(--custom-border-color);
  }

  html.dark body {
    color: #f4f5f6;
    background: unset;
    position: relative;
  }

  img {
    border: none;
  }

  .dark\:border-neutral-800:is(.dark *) {
    border-color: var(--custom-border-color);
  }

  .dark\:bg-stone-800:is(.dark *) {
    --tw-bg-opacity: 0.5;
    background-color: rgb(41 37 36 / var(--tw-bg-opacity, 1));
  }

  .dark\:text-stone-500:is(.dark *) {
    color: #f4f5f6;
  }

  .dark .bg-secondary {
    background-color: unset;
  }

  .dark .bg-popover {
    background-color: unset;
  }

  .dark .bg-muted {
    background-color: var(--custom-border-color);
  }

  .dark\:bg-black:is(.dark *) {
    background-color: rgba(13, 11, 9, 0.1);
  }

  .dark .bg-border {
    background-color: var(--custom-border-color);
  }

  .dark .border-input {
    border-color: var(--custom-border-color);
  }

  .dark\:text-neutral-300\/50:is(.dark *) {
    color: #999;
  }

  .dark\:text-stone-400:is(.dark *) {
    color: #fff;
  }

  div#radix-\:r4\: {
    background: rgba(0, 0, 0, 0.7);
  }

  .dark .bg-stone-800 {
    background: var(--custom-background-color);
  }

  .text-green-600 {
    color: rgb(34, 197, 94);
  }

  .bg-green-600 {
    background-color: rgb(34, 197, 94);
  }

  .dark .vps-info {
    border-radius: 12px;
    padding: 12px;
  }

  .dark .font-medium.opacity-40 {
    opacity: unset;
  }

  .dark .font-medium.opacity-50 {
    opacity: unset;
  }

  .dark .max-w-5xl.gap-4>div:first-child {
    background-color: var(--custom-background-color);
    backdrop-filter: blur(2px);
    border: 1px solid rgba(13, 11, 9, 0.2);
    box-shadow: 0 4px 6px rgba(13, 11, 9, 0.2);
    border-radius: 12px;
    padding: 12px;
  }

  img[alt="BackIcon"] {
    /* 样式规则 */
    margin-right: 12px;
  }

  .flex.items-center.gap-1.rounded-\[50px\].bg-stone-100.p-\[3px\].dark\:bg-stone-800 {
    backdrop-filter: blur(2px);
  }

  .\[\&_\.recharts-cartesian-axis-tick_text\]\:fill-muted-foreground .recharts-cartesian-axis-tick text {
    fill: #fff;
  }

  .dark\:fill-neutral-800:is(.dark *) {
    fill: #fff;
  }

  .data-\[state\=unchecked\]\:bg-input[data-state=unchecked] {
    background-color: unset;
  }

  .data-\[state\=checked\]\:bg-primary[data-state=checked] {
    background-color: var(--custom-background-color);
  }



  .video-box {
    position: fixed;
    z-index: 1;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
  }

  .video-box video {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
</style>
```


</details>




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