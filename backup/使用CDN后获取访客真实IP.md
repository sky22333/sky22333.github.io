- Cloudflare
使用Cloudflare后，在Nginx配置中相应位置添加如下代码以获取用户真实IP
```
set_real_ip_from 0.0.0.0/0;
real_ip_header CF-Connecting-IP;
```
- Gcore CDN
可参考Gcore官方博文[https://gcore.com/docs/web-security/get-an-actual-ip-addresses-of-visitors-from-the-x-forward-for-header](https://lot.pm/go/?url=https://gcore.com/docs/web-security/get-an-actual-ip-addresses-of-visitors-from-the-x-forward-for-header)
```
set_real_ip_from 0.0.0.0/0;
real_ip_header X-Forwarded-For;
```
- AWS Cloudfront
需要利用到CloudFront-Viewer-Address请求头，但该请求头默认未启用，需手动前往Cloudfront控制面板开启。开启方法可参考[如何从CloudFront上获取客户端真实IP地址](https://lot.pm/go/?url=https://blog.bitipcman.com/get-client-ip-from-cloudfront-viewer-header/)。开启后，使用以下代码获取访客真实IP。
```
set_real_ip_from 0.0.0.0/0;
real_ip_header CloudFront-Viewer-Address;
```

- Vercel
Vercel支持多个请求头转发用户IP，分别是X-Forwarded-For，X-Vercel-Forwarded-For和X-Real-Ip，其中X-Forwarded-For和X-Real-Ip内容相同，X-Vercel-Forwarded-For大部分情况下内容和X-Forwarded-For以及X-Real-Ip相同。

一般情况下用X-Vercel-Forwarded-For获取访客真实IP更保险。


- 阿里云CDN
```
set_real_ip_from 0.0.0.0/0;
real_ip_header Ali-CDN-Real-IP;
```
- 其他CDN
除CDN厂商有特殊说明外，一般情况下使用X-Forwarded-For请求头获取访客IP。