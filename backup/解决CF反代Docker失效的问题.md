## 解决CF反代Docker失效的问题

**最近国内拉取镜像时发现之前的`worker`反代的`docker`加速用不了了，报错为`auth.docker.io/token`这个域名的问题。**

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

#### 新建一个`docker.html`文件，部署后记得绑定自定义域，因为默认的`worker`域名是被墙的。



<details>
  <summary>docker.html文件的代码</summary>

```
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Docker Hub 镜像加速</title>
        <style>
        html, body {
            height: 100%;
        }
        body {
            font-family: "Roboto", "Helvetica", "Arial", sans-serif;
            font-size: 16px;
            color: #333;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
        }
        .container {
            margin: 0 auto;
            max-width: 600px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        .header {
            background-color: #438cf8;
            color: white;
            padding: 10px;
            display: flex;
            align-items: center;
        }
        h1 {
            font-size: 24px;
            margin: 0;
            padding: 0;
        }
        .content {
            padding: 32px;
            flex-grow: 1;
        }
        pre {
            background-color: #f4f4f4;
            padding: 16px;
            border-radius: 4px;
            position: relative;
            overflow: auto;
            margin-bottom: 16px;
        }
        code {
            display: block;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        .copy-button {
            position: absolute;
            top: 8px;
            right: 8px;
            padding: 4px 8px;
            background-color: #438cf8;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }
        .footer {
            padding: 5px;
            text-align: center;
            font-size: 15px;
        }
        .footer a {
            color: #438cf8;
            text-decoration: none;
        }
        </style>
        <script>
            function copyCode(button) {
                const code = button.previousElementSibling.innerText;
                navigator.clipboard.writeText(code).then(function() {
                    button.innerText = "已复制";
                    setTimeout(function() {
                        button.innerText = "复制";
                    }, 2000);
                });
            }
        </script>
    </head>
    <body>
        <div class="header">
            <h1>Docker Hub 镜像加速</h1>
        </div>
        <div class="container">
            <div class="content">
                <h2>Docker Hub 镜像加速</h2>
                <p>为了加速镜像拉取，你可以使用以下命令设置 registry mirror</p>
                <pre><code>sudo mkdir -p /etc/docker</code><button class="copy-button" onclick="copyCode(this)">复制</button></pre>
                <pre><code>sudo tee /etc/docker/daemon.json &lt;&lt;EOF
{
    "registry-mirrors": ["https://{{host}}"]
}
EOF</code><button class="copy-button" onclick="copyCode(this)">复制</button></pre>
                <pre><code>sudo systemctl daemon-reload</code><button class="copy-button" onclick="copyCode(this)">复制</button></pre>
                <pre><code>sudo systemctl restart docker</code><button class="copy-button" onclick="copyCode(this)">复制</button></pre>
                <br>
                <p>不用设置环境也可以直接使用，用法示例：</p>
                <pre><code>docker pull {{host}}/library/mysql:5.7</code><button class="copy-button" onclick="copyCode(this)">复制</button></pre>
                <p>说明：library是一个特殊的命名空间，它代表的是官方镜像。如果是某个用户的镜像就把library替换为镜像的用户名</p>
            </div>
        </div>
        <div class="footer">
            <p><a href="https://blog.52013120.xyz/post/29.html" target="_blank">代码地址</a></p>
        </div>
    </body>
</html>
```

</details>




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


- **`caddy`反代`ghcr.io`**

```
example.com {
    handle /v2/* {
        reverse_proxy https://ghcr.io {
            header_up Host {http.reverse_proxy.upstream.hostport}
            header_down WWW-Authenticate "https://ghcr.io" "https://{http.request.host}"
            header_down Location "https://pkg-containers.githubusercontent.com" "https://{http.request.host}"
        }
    }

    handle /token* {
        reverse_proxy https://ghcr.io {
            header_up Host {http.reverse_proxy.upstream.hostport}
        }
    }

    handle /* {
        reverse_proxy https://pkg-containers.githubusercontent.com {
            header_up Host {http.reverse_proxy.upstream.hostport}
        }
    }
}
```