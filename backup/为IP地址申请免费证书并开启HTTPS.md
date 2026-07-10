## 🔵打开免费申请IP SSL证书的网站


**https://zerossl.com/**

**1：打开后首页就直接输入你要申请的IP，点击“Next Step"进入下一步。**

**2：输入注册邮箱和密码（邮箱可以随便填，不会验证真实性）**

**3：免费版IP SSL证书有效期是3个月。需要在第二项里手动选择下。否则是默认的1年付费版。**

## 🔵验证申请IP所有权

**1：下载`Auth`验证文件**

**2：在网站目录里创建`/.well-known/pki-validation/`目录，以`caddy`为例**
```
mkdir -p /var/www/.well-known/pki-validation
```
```
http://123.123.123.123 {
    root * /var/www
    encode zstd gzip
    file_server
}
```

**3：将刚刚下载的验证文件上传到`/var/www/.well-known/pki-validation/`目录里**

**4：启动`caddy`，访问你的公网IP，如果能看到验证文件，则代表成功**

## 🔵生成SSL证书

**然后`zerossl`网站里点击验证，验证成功后下载`zip`证书压缩包，上传到服务器`/etc/caddy`目录，并使用`unzip`命令解压**


## 🔵合并证书文件

**在`/etc/caddy`目录下执行如下命令：**

```
cd /etc/caddy
```
```
cat certificate.crt ca_bundle.crt > fullchain.crt
```

## 🔵启动站点

**`caddy`为例**
```
https://123.123.123.123 {
    root * /var/www
    encode zstd gzip
    file_server

    tls /etc/caddy/fullchain.crt /etc/caddy/private.key
}
```
**`/var/www`为站点目录，`123.123.123.123`为示例`IP地址`，请根据自己情况替换。**

**使用`nginx`的话思路也一样。**
