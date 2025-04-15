直接贴代码
```
addEventListener("fetch", event => {
  let url = new URL(event.request.url);
  url.hostname = "hub.docker.com"; // 修改成需要代理的网站

  // 构建新的请求头，传递原请求头，并处理必要的字段
  let headers = new Headers(event.request.headers);
  headers.set('X-Forwarded-For', event.request.headers.get('cf-connecting-ip') || 'unknown'); // 如果在 Cloudflare 环境中，可以添加客户端 IP

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