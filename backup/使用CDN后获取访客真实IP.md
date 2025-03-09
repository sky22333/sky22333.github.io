- **Cloudflare**
使用`Cloudflare`后，在`Nginx`配置中相应位置添加如下代码以获取用户真实IP
```
set_real_ip_from 0.0.0.0/0;
real_ip_header CF-Connecting-IP;
```
- **Gcore CDN**
可参考`Gcore`官方博文[https://gcore.com/docs/web-security/get-an-actual-ip-addresses-of-visitors-from-the-x-forward-for-header](https://lot.pm/go/?url=https://gcore.com/docs/web-security/get-an-actual-ip-addresses-of-visitors-from-the-x-forward-for-header)
```
set_real_ip_from 0.0.0.0/0;
real_ip_header X-Forwarded-For;
```
- **AWS Cloudfront**
需要利用到`CloudFront-Viewer-Address`请求头，但该请求头默认未启用，需手动前往`Cloudfront`控制面板开启。开启方法可参考[如何从CloudFront上获取客户端真实IP地址](https://lot.pm/go/?url=https://blog.bitipcman.com/get-client-ip-from-cloudfront-viewer-header/)。开启后，使用以下代码获取访客真实IP。
```
set_real_ip_from 0.0.0.0/0;
real_ip_header CloudFront-Viewer-Address;
```

- **Vercel**
`Vercel`支持多个请求头转发用户IP，分别是`X-Forwarded-For`，`X-Vercel-Forwarded-For`和`X-Real-Ip`，其中`X-Forwarded-For`和`X-Real-Ip`内容相同，`X-Vercel-Forwarded-For`大部分情况下内容和`X-Forwarded-For`以及`X-Real-Ip`相同。

一般情况下用X-Vercel-Forwarded-For获取访客真实IP更保险。


- **阿里云CDN**
```
set_real_ip_from 0.0.0.0/0;
real_ip_header Ali-CDN-Real-IP;
```
- **其他CDN**
除CDN厂商有特殊说明外，一般情况下使用`X-Forwarded-For`请求头获取访客IP。