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