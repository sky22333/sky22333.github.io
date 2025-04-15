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


### 增加访问限制
```
addEventListener("fetch", event => {
  // 设定一个简单的用户名和密码
  const validUsername = "user";
  const validPassword = "mypassword";

  // 获取请求头中的 Authorization
  const authHeader = event.request.headers.get("Authorization");

  // 检查 Cookie 是否存在认证标记
  const cookie = event.request.headers.get("Cookie");
  const isAuthenticated = cookie && cookie.includes("authenticated=true");

  // 如果没有 Cookie 标记，且没有 Authorization 头或者它不符合 Basic Authentication 格式
  if (!isAuthenticated && (!authHeader || !authHeader.startsWith("Basic "))) {
    return event.respondWith(
      new Response("需要认证才能访问", {
        status: 401,
        headers: {
          "WWW-Authenticate": 'Basic realm="请输入用户名和密码"' // 触发浏览器认证对话框
        }
      })
    );
  }

  // 如果用户已经认证过，跳过认证步骤
  if (isAuthenticated) {
    return handleRequest(event);
  }

  // 提取并解码用户名和密码
  const base64Credentials = authHeader.split(" ")[1];
  const credentials = atob(base64Credentials);
  const [username, password] = credentials.split(":");

  // 检查用户名和密码是否正确
  if (username === validUsername && password === validPassword) {
    // 设置 Cookie，标记用户已认证，并设置 6 小时过期
    const headers = new Headers();
    headers.set('Set-Cookie', 'authenticated=true; Path=/; Max-Age=21600'); // 6 小时过期

    return event.respondWith(
      new Response("认证成功！请刷新此页面继续访问。", {
        status: 200,
        headers: headers
      })
    );
  } else {
    // 如果认证失败，返回 401 Unauthorized 并提示
    return event.respondWith(
      new Response("认证失败", {
        status: 401,
        headers: {
          "WWW-Authenticate": 'Basic realm="请输入用户名和密码"' // 触发浏览器认证对话框
        }
      })
    );
  }

  function handleRequest(event) {
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

    // 如果是爬虫或搜索引擎，返回 403 Forbidden
    if (isBot) {
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
  }
});
```