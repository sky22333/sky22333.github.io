### [国旗图标](https://www.emojiall.com/zh-hans/sub-categories/J2)


### 主题目录
```
public/theme
```

### 支付插件目录
```
app/Payments
```

### 客户端适配参考目录
```
app/Http/Controllers/Client/Protocols
```

### 订阅下发文件目录
```
/www/resources/rules/custom.clash.yaml
```
[查看目录中的所有文件](https://github.com/cedar2025/Xboard/tree/5a0e59b103657ccd300204046b877f653cd2aa30/app/Protocols)


### 强制获取订阅（URL后面加上这个参数）

一般用于订阅地址输入到浏览器后无法获取订阅信息
```
&flag=meta&types=all
```

### 忘记管理员密码

可以在站点目录下执行命令找回密码
```
docker exec -it xboard-xboard-1 /bin/sh
```
```
php artisan reset:password 管理员邮箱
```
重启
```
cd /root/Xboard
```
```
docker compose restart
```
---


## Xboard迁移Xboard出现的各种问题解决方案

一般都是数据库里的问题，进入数据库的`v2_settings`表，修改https配置，域名配置，路径配置，等等配置