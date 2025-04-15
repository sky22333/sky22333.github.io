### `CF-Worker`代码示例
```
// 配置用户名和密码
const USERNAME = 'admin123';
const PASSWORD = 'admin123';

// 设置一个5小时有效期的cookie
const COOKIE_EXPIRATION = 5 * 60 * 60 * 1000; // 5小时（毫秒）

// 验证用户名和密码
async function validateCredentials(username, password) {
  return username === USERNAME && password === PASSWORD;
}

// 设置会话cookie
function setSessionCookie() {
  const expires = new Date(Date.now() + COOKIE_EXPIRATION).toUTCString();
  return `session=true; Path=/; Expires=${expires}; HttpOnly; Secure; SameSite=None`;
}

// 动态设置CORS头部，请修改你的前端域名
function setCorsHeaders(response, request) {
  const allowedOrigins = ['https://example.com', 'https://admin.example.com'];
  const origin = request.headers.get('Origin');

  // 克隆响应以便修改headers
  const newResponse = new Response(response.body, response);
  
  // 设置基础CORS头
  newResponse.headers.set('Access-Control-Allow-Methods', 'POST, GET, OPTIONS');
  newResponse.headers.set('Access-Control-Allow-Headers', 'Content-Type, Cookie');
  newResponse.headers.set('Access-Control-Allow-Credentials', 'true');
  
  // 动态设置允许的Origin
  if (origin && allowedOrigins.includes(origin)) {
    newResponse.headers.set('Access-Control-Allow-Origin', origin);
  }
  
  return newResponse;
}

// 处理OPTIONS请求(CORS预检请求)
async function handleOptions(request) {
  const response = new Response(null, { status: 204 });
  return setCorsHeaders(response, request);
}

// 登录处理函数
async function loginHandler(request) {
  try {
    const formData = await request.formData();
    const username = formData.get('username');
    const password = formData.get('password');

    if (!username || !password) {
      return new Response(JSON.stringify({ message: '用户名和密码不能为空' }), { 
        status: 400 
      });
    }

    if (await validateCredentials(username, password)) {
      const headers = {
        'Set-Cookie': setSessionCookie(),
        'Content-Type': 'application/json',
      };
      return new Response(JSON.stringify({ 
        message: '登录成功',
        success: true
      }), { 
        status: 200, 
        headers 
      });
    } else {
      return new Response(JSON.stringify({ 
        message: '用户名或密码错误',
        success: false
      }), { 
        status: 401 
      });
    }
  } catch (error) {
    console.error('Login error:', error);
    return new Response(JSON.stringify({ 
      message: '服务器内部错误',
      success: false
    }), { 
      status: 500 
    });
  }
}

// 检查Session请求
async function checkSessionHandler(request) {
  try {
    const cookie = request.headers.get('Cookie');
    if (cookie && cookie.includes('session=true')) {
      return new Response(JSON.stringify({ 
        valid: true,
        message: '会话有效' 
      }), { 
        status: 200 
      });
    } else {
      return new Response(JSON.stringify({ 
        valid: false,
        message: '会话无效或已过期' 
      }), { 
        status: 401 
      });
    }
  } catch (error) {
    console.error('Session check error:', error);
    return new Response(JSON.stringify({ 
      valid: false,
      message: '会话检查失败' 
    }), { 
      status: 500 
    });
  }
}

// 主事件监听器
addEventListener('fetch', event => {
  const { request } = event;
  const url = new URL(request.url);

  // 处理OPTIONS请求
  if (request.method === 'OPTIONS') {
    return event.respondWith(handleOptions(request));
  }

  // 处理登录请求
  if (request.method === 'POST' && url.pathname === '/login') {
    return event.respondWith(
      loginHandler(request).then(response => setCorsHeaders(response, request))
    );
  }

  // 检查Session请求
  if (request.method === 'GET' && url.pathname === '/check-session') {
    return event.respondWith(
      checkSessionHandler(request).then(response => setCorsHeaders(response, request))
    );
  }

  // 其他请求返回404
  return event.respondWith(
    setCorsHeaders(new Response(JSON.stringify({ 
      message: '未找到资源' 
    }), { 
      status: 404 
    }), request)
  );
});
```


### 前端登录页示例
```
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>登录</title>
  <style>
    /* 重置默认样式 */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Arial', sans-serif;
      background-color: #f4f7fb;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
    }

    .login-container {
      background-color: white;
      padding: 40px 30px;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      width: 100%;
      max-width: 400px;
    }

    h2 {
      text-align: center;
      margin-bottom: 20px;
      font-size: 1.5rem;
      color: #333;
    }

    input {
      width: 100%;
      padding: 12px;
      margin: 10px 0;
      border: 1px solid #ccc;
      border-radius: 5px;
      font-size: 1rem;
      transition: border-color 0.3s ease;
    }

    input:focus {
      border-color: #007bff;
      outline: none;
    }

    button {
      width: 100%;
      padding: 12px;
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 5px;
      font-size: 1rem;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }

    button:hover {
      background-color: #0056b3;
    }

    .error-message {
      color: red;
      text-align: center;
      margin-top: 10px;
      display: none;
    }

    /* 响应式样式 */
    @media (max-width: 768px) {
      .login-container {
        padding: 30px 20px;
      }

      h2 {
        font-size: 1.2rem;
      }
    }

  </style>
</head>
<body>

  <div class="login-container">
    <h2>登录</h2>
    <form id="login-form">
      <input type="text" id="username" name="username" placeholder="请输入用户名" required>
      <input type="password" id="password" name="password" placeholder="请输入密码" required>
      <button type="submit">登录</button>
    </form>
    <div id="error-message" class="error-message">用户名或密码错误</div>
  </div>

  <script>
    const form = document.getElementById('login-form');
    const errorMessage = document.getElementById('error-message');
    
    // 页面加载时检查Session，请修改你的workers域名(路径不要动)
    async function checkSession() {
      try {
        const response = await fetch('https://xxxxxxxxx.workers.dev/check-session', {
          method: 'GET',
          credentials: 'include',
        });
        
        const data = await response.json();
        
        if (response.ok && data.valid) {
          window.location.href = '/';
        }
      } catch (error) {
        console.error('Session check error:', error);
        // 可以选择忽略检查错误，继续显示登录表单
      }
    }
    
    // 如果已登录，跳过登录页面
    checkSession();
    
    // 处理表单提交
    form.addEventListener('submit', async function(event) {
      event.preventDefault();
      errorMessage.style.display = 'none'; // 隐藏之前的错误信息
    
      const username = document.getElementById('username').value.trim();
      const password = document.getElementById('password').value.trim();
    
      // 简单的前端验证
      if (!username || !password) {
        errorMessage.textContent = '用户名和密码不能为空';
        errorMessage.style.display = 'block';
        return;
      }
     // 请修改你的workers域名(路径不要动)
      try {
        const response = await fetch('https://xxxxxxxxx.workers.dev/login', {
          method: 'POST',
          body: new URLSearchParams({ username, password }),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          credentials: 'include',
        });
    
        const data = await response.json();
        
        if (response.ok && data.success) {
          // 登录成功，跳转前可以存储一些用户信息
          window.location.href = './';
        } else {
          // 显示服务器返回的错误信息
          errorMessage.textContent = data.message || '登录失败';
          errorMessage.style.display = 'block';
        }
      } catch (error) {
        console.error('Login error:', error);
        errorMessage.textContent = '网络错误，请重试';
        errorMessage.style.display = 'block';
      }
    });
  </script>

</body>
</html>
```



### 其他页面检查登录状态的js代码
```
// 替换你的workers域名，路径不要动
async function checkSession() {
  const response = await fetch('https://xxxxxxxxxxxx.workers.dev/check-session', {
    method: 'GET',
    credentials: 'include',  // 确保 Cookie 被携带
  });

  if (response.ok) {
    console.log('Session is valid');
    return true;
  } else {
    console.log('Session is invalid or expired');
    return false;
  }
}

checkSession().then(isValid => {
  if (!isValid) {
    window.location.href = './login.html';  // 如果 session 无效，跳转到登录页面
  }
});
```
