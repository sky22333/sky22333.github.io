### 直接贴代码

> 建议只自己使用，不要公开，否则可能被判断为涉嫌违反CF规则

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


### 增加访问限制密码认证
> 可解决涉嫌违反CF规则等问题

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


### 代理访问所有直链

通过动态传入域名的方式，例如：`https://test.workers.dev/https://api.github.com`

```
addEventListener("fetch", event => {
  event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
  const originalUrl = new URL(request.url);
  const path = originalUrl.pathname;

  // 检查是否是代理模式，例如：/https://github.com/...
  if (!path.startsWith("/http://") && !path.startsWith("/https://")) {
    return new Response("请正确传入目标地址，需要带协议头。", { status: 400 });
  }

  const targetUrl = path.slice(1) + originalUrl.search; // 构造完整目标 URL
  let url;
  try {
    url = new URL(targetUrl);
  } catch (e) {
    return new Response("无效的目标 URL", { status: 400 });
  }

  // 防爬虫：拦截常见 User-Agent
  const userAgent = request.headers.get("User-Agent") || "";
  const blockedAgents = [
    /googlebot/i, /bingbot/i, /baiduspider/i, /slurp/i,
    /duckduckbot/i, /yandex/i, /sogou/i, /exabot/i,
    /facebot/i, /facebookexternalhit/i
  ];
  if (blockedAgents.some(re => re.test(userAgent))) {
    return new Response("访问被拒绝", { status: 403 });
  }

  // 构造代理请求
  const proxyRequest = new Request(url.toString(), {
    method: request.method,
    headers: cleanHeaders(request.headers),
    body: request.method === "GET" || request.method === "HEAD" ? null : request.body,
    redirect: "follow"
  });

  try {
    const response = await fetch(proxyRequest);

    // 克隆响应头并清理 CSP、X-Frame-Options 等阻止代理的问题
    const newHeaders = new Headers(response.headers);
    newHeaders.delete("content-security-policy");
    newHeaders.delete("content-security-policy-report-only");
    newHeaders.delete("x-frame-options");
    newHeaders.set("Access-Control-Allow-Origin", "*");
    newHeaders.set("Access-Control-Allow-Headers", "*");
    newHeaders.set("Access-Control-Allow-Methods", "*");

    return new Response(response.body, {
      status: response.status,
      statusText: response.statusText,
      headers: newHeaders
    });
  } catch (err) {
    return new Response("代理请求失败: " + err.message, { status: 502 });
  }
}

// 清理 headers（避免 host、encoding 等引发问题）
function cleanHeaders(headers) {
  const newHeaders = new Headers();
  for (const [key, value] of headers.entries()) {
    const lower = key.toLowerCase();
    if (
      lower === "host" ||
      lower === "cf-connecting-ip" ||
      lower === "x-forwarded-for" ||
      lower === "x-real-ip" ||
      lower === "content-length"
    ) {
      continue;
    }
    newHeaders.set(key, value);
  }
  return newHeaders;
}
```