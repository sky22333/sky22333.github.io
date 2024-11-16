## 解决CF反代Docker失效的问题

**最近国内拉取镜像时发现之前的`worker`反代的`docker`用不了了，报错为`auth.docker.io/token`这个域名的问题。**

经过抓包发现，现在拉取镜像会请求三个域名，顺序是先请求了`registry-1.docker.io`得到了 `401` 的 `http` 状态码后转去访问了`auth.docker.io`得到了 `Authorization`字段以后重新请求 `registry-1.docker.io`，获取源数据后被 `307` 转发到了 `production.cloudflare.docker.com` 上。

---

> 由此看出`auth.docker.io`是用于验证鉴权的域名，`production.cloudflare.docker.com` 是用于下载镜像文件的域名，这些域名我测了一下全都被墙了。

之前的CF代码只反代了`registry-1.docker.io`，所以导致失效，既然找到问题所在就比较好解决了。


下面贴出我修改的`worker`代码：
```
import HTML from './docker.html';

export default {
  async fetch(request) {
    const url = new URL(request.url);
    const host = request.headers.get("host");
    
    const registryHost = "registry-1.docker.io";
    const authHost = "auth.docker.io";
    const productionHost = "production.cloudflare.docker.com";

    // 处理认证请求
    if (url.pathname.startsWith('/token')) {
      const headers = new Headers(request.headers);
      headers.set('host', authHost);
      
      const authUrl = `https://${authHost}${url.pathname}${url.search}`;
      const authRequest = new Request(authUrl, {
        method: request.method,
        headers: headers,
        body: request.body,
        redirect: "follow",
      });

      const response = await fetch(authRequest);
      const responseHeaders = new Headers(response.headers);
      responseHeaders.set('access-control-allow-origin', host);
      responseHeaders.set('access-control-allow-headers', 'Authorization');
      
      return new Response(response.body, {
        status: response.status,
        statusText: response.statusText,
        headers: responseHeaders,
      });
    }
    
    // 处理 registry v2 请求
    if (url.pathname.startsWith('/v2/')) {
      const headers = new Headers(request.headers);
      headers.set('host', registryHost);
      
      const registryUrl = `https://${registryHost}${url.pathname}${url.search}`;
      const registryRequest = new Request(registryUrl, {
        method: request.method,
        headers: headers,
        body: request.body,
        redirect: "follow",
      });

      const response = await fetch(registryRequest);
      const responseHeaders = new Headers(response.headers);
      responseHeaders.set('access-control-allow-origin', host);
      responseHeaders.set('access-control-allow-headers', 'Authorization');

      // 修改认证头，将认证请求指向主域名
      const wwwAuth = responseHeaders.get('www-authenticate');
      if (wwwAuth) {
        const newWwwAuth = wwwAuth
          .replace('https://auth.docker.io', `https://${host}`)
          .replace('https://auth.hub.docker.com', `https://${host}`);
        responseHeaders.set('www-authenticate', newWwwAuth);
      }

      // 修改重定向地址
      const location = responseHeaders.get('location');
      if (location) {
        const newLocation = location
          .replace('https://production.cloudflare.docker.com', `https://${host}`);
        responseHeaders.set('location', newLocation);
      }

      return new Response(response.body, {
        status: response.status,
        statusText: response.statusText,
        headers: responseHeaders,
      });
    }

    // 处理默认请求
    return new Response(HTML.replace(/{{host}}/g, host), {
      status: 200,
      headers: {
        "content-type": "text/html"
      }
    });
  }
}
```

`./docker.html`是前端文件，我就不提供了，随便让AI写下就行了，部署后记得绑定自定义域，因为默认的`worker`域名是被墙的。


---


- **基于这个思路我还写了`caddy`反代的配置，`caddy`自动配置SSL证书可太香了，并且不依赖CF，可以自己部署在服务器上。**

```
hub.example.com {
    handle /v2/* {
        reverse_proxy https://registry-1.docker.io {
            header_up Host {http.reverse_proxy.upstream.hostport}
            header_down WWW-Authenticate "https://auth.docker.io" "https://{http.request.host}"
            header_down Location "https://production.cloudflare.docker.com" "https://{http.request.host}"
        }
    }

    handle /token* {
        reverse_proxy https://auth.docker.io {
            header_up Host {http.reverse_proxy.upstream.hostport}
        }
    }

    handle /* {
        reverse_proxy https://production.cloudflare.docker.com {
            header_up Host {http.reverse_proxy.upstream.hostport}
        }
    }
}
```

> 记得第一行的`hub.example.com`替换为你的域名