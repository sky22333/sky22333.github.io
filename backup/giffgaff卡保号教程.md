## giffgaff卡保号教程
官网：https://www.giffgaff.com/dashboard

## 保号短信
发送`hi`到`00447973000186`，这是中国移动英国（CMLink UK）客服热线。发完会收到giffgaff余额变动的通知就完成了。

## 账户信息
发送短信 `number` 到 `43430`，找回号码

发送短信 `membername` 到 `43430`，找回账户名

发送短信 `forgotten` 到 `43430`，找回账户邮箱

---

## 关闭语音信箱

这个功能默认开启，而且很贵，别人打电话进来你直接挂断也会收费，一分钟1英镑。

[访问此地址](https://support2.giffgaff.com/app/ask/International-and-Roaming/Accessing-voicemail-while-abroad/form/) 让人工客服帮你关闭

话术：
```
Hello, I am currently roaming in another country. I need your help to disable my voicemail. I have tried multiple times without success. Thank you.
```

[查看处理进度](https://www.giffgaff.com/support/questions)，如果客服回复了你，你的邮箱也能收到回复。

### 无信号或者有信号无法使用

可能是漫游到中国联通了，请手动选择运营商为中国移动。还不行的话就关闭5G，选择4G。


## 极限保号方案

1：安卓手机下载[termux](https://github.com/termux/termux-app/releases)

2：打开giffgaff卡的移动数据，然后打开漫游设置，设置仅允许`termux`应用漫游联网。

3：然后打开`termux`使用curl请求一下国外api服务，消耗一下少量流量即可。

可以使用如下命令，顺便看下IP地区是不是GB（英国）
```
curl -s https://one.one.one.one/cdn-cgi/trace
```

![Image](https://github.com/user-attachments/assets/2560e9c2-816d-4107-999d-b4ca83391fdd)
