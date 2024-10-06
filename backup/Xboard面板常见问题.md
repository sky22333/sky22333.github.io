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


### Xboard迁移Xboard出现的各种问题解决方案

一般都是数据库里的问题，进入数据库的`v2_settings`表，修改https配置，域名配置，路径配置，等等配置





### Xboard 使用前后端分离主题导致支付转跳问题处理

现象：
该问题现象通常为源站为 `a.aab.com` 主题站 `b.aab.com` 通过`b.aab.com epay`支付成功后转跳至`a.aab.com`

处理：
需要修改文件 `app/Services/PaymentService.php`

将原代码的第51行：

`'return_url' => url('/#/order/' . $order['trade_no']),`
修改为如下：

注意在后台设置的站点域名为主题站地址`b.aab.com`

`'return_url' => admin_setting('app_url'). '/#/order/' . $order['trade_no'],`
如若你是其他版本的v2board请修改为：

  `'return_url' => config('v2board.app_url') . '/#/order/' . $order['trade_no'],`
最后首部增加如下即可（只限xboard）:

`use App\Models\Setting;`