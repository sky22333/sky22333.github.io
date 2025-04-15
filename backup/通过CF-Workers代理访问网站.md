### 直接贴代码

> 建议只自己使用，不要公开，否则可能被判断为涉嫌钓鱼

```
addEventListener("fetch", event => {
  let url = new URL(event.request.url);
  url.hostname = "hub.docker.com"; // 修改成需要代理的网站

  // 获取请求头中的 User-Agent
  let userAgent = event.request.headers.get("User-Agent");

  // 屏蔽爬虫和搜索引擎的列表
  const blockedUserAgents = [
    /googlebot/i,
    /bingbot/i,
    /baiduspider/i,
    /slurp/i, // Yahoo
    /duckduckbot/i,
    /yandex/i,
    /sogou/i,
    /exabot/i,
    /facebot/i, // Facebook bot
    /facebookexternalhit/i
  ];

  const isBot = blockedUserAgents.some(pattern => pattern.test(userAgent));

  if (isBot) {
    // 如果是爬虫或搜索引擎，返回 403 Forbidden
    return event.respondWith(
      new Response('访问被拒绝', { status: 403 })
    );
  }

  // 构建新的请求头，传递原请求头，并处理必要的字段
  let headers = new Headers(event.request.headers);
  headers.set('X-Forwarded-For', event.request.headers.get('cf-connecting-ip') || 'unknown'); // 可以添加客户端 IP

  // 创建新的请求对象
  let request = new Request(url, {
    method: event.request.method,           // 保留原请求方法
    headers: headers,                       // 保留原请求头
    body: event.request.method === 'GET' ? null : event.request.body, // 对于 GET 请求，Body 通常是空的
    redirect: 'follow'                      // 自动跟随重定向
  });

  console.log(`请求: ${url}`);

  // 处理请求并返回响应
  event.respondWith(
    fetch(request)
      .then(response => {
        // 返回原始响应，没有缓存控制
        console.log(`响应状态: ${response.status}`);
        return response;
      })
      .catch(err => {
        // 处理请求失败的情况
        console.error('请求失败:', err);
        return new Response('请求失败', { status: 502 });
      })
  );
});
```