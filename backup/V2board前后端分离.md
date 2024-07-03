> [!NOTE]
> ## 前后端分离主题部署

### `V2board`和`Xboard`步骤一样

###  当你得到一个前后端分离的主题，文件中的目录结构大概是这样的：
````
├── assets
│   ├── ArrowPathIcon-BcKBEic3.js
│   ├── CheckOutlined-kSoYgoEi.js
│   ├── Detail-CZ1NhySb.js
│   ├── Detail-CiCRNMEx.css
│   └── Home-BIEpZQVD.css
├── .DS_Store
├── config.js
├── favicon.ico
└── index.html
````

### 重点在于`config.js`这个文件，这个文件里需要填写你机场的配置信息

#### 文件内容以这个为例，自己举一反三，基本逻辑都差不多
```
window.config={
    logo: 'https://img2.imgtp.com/2023/01/11/YzU8iDJp.png', // 网站logo
    title:"一元机场", // 网站标题
    host:"https://xxxxxxx.com/", // 机场原来的域名地址
    storeHome: {
         
        下面的代码省略.......
       ............
       ..........

```

### 配置好后就用就把整个项目文件用`nginx`或者`caddy`运行起来，宝塔用户就直接把整个主题文件放在站点目录里即可。域名要用一个新域名，不能和机场原来的域名一样。(为了方便小白理解)


### 分离后的常见问题

>支付完成后跳回原来的机场界面：一般是支付回调的问题，把你机场后台的官网域名换成你的新主题域名，或者改一下支付回调

>无法登录：一般是你新主题的服务器和面板服务器之间无法连通，也可能是机场被墙了（严谨点讲是机场后端）


更多问题可以点击博客主页的右上角私聊我的TG有偿协助



一般前后端分离主题也可以不需要服务器，直接部署在CF上，只用添加`/functions/api
/[[path]].js`文件即可，文件中的配置自己研究，或者联系我有偿协助。


---

---


## 免费的万能解决方案，可解决机场的所有复杂问题，收集了多位专业运维大佬的解答，扫码查看。




![222](https://github.com/sky22333/sky22333.github.io/assets/115192496/1cb0b8d5-0782-4fd3-984c-c09f3bd457c4)



---

---

---

> [!IMPORTANT]
> ## 前后端分离原理解释

### 默认架构下，V2board 同时扮演后端和前端的角色：

对于 `/ `路径的请求，V2board 调用其模板引擎填充前端配置，并返回前端资源文件

对于 `/api/*` 路径的请求，V2board 执行相对应的逻辑，扮演后端的角色

出于对多种因素的考虑，前端主题 只支持通过前后端分离的方式部署。V2board 只需承担后端的职责，前端主题 将会作为一个静态站点担任前端：

用户的所有请求都会由部署了 前端主题 的前端站点处理

用户加载 前端主题 后，前端主题 会向部署了 V2board 的后端站点请求数据

假设 前端主题 部署在 `https://example.org`，V2board 部署在 `https://v2board.example.org`，用户的浏览器会产生类似如下的请求：

`GET https://example.org/ `- 由用户发起的请求，加载 前端主题 资源文件

`GET https://v2board.example.org/api/ `- 由 前端主题 发起的请求，从 V2board 加载数据


若您不希望使用多个域名，也可以通过使用[反向代理](https://zh.wikipedia.org/zh-cn/%E5%8F%8D%E5%90%91%E4%BB%A3%E7%90%86)

，将对于 前端主题 站点 `/api/ `路径的请求委托给 V2board 站点处理。

沿用上面的例子，通过配置反向代理，所有对于 `https://example.org/api/ `的请求都将会被委托给 `https://v2board.example.org/api/` 处理。这种情况下，用户的浏览器会产生类似如下的请求：

`GET https://example.org/` - 由用户发起的请求，加载 前端主题 资源文件

`GET https://example.org/api/` - 由 前端主题 发起的请求，从 V2board 加载数据