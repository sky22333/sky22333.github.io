
 - <img src="https://media0.giphy.com/media/pylpD8AoQCf3CQ1oO2/giphy.gif" width=30 height=30>  常用代码记录<br>
#
                               
####  点击三角图标可展开内容

---

<details>
  <summary>VPS常用命令</summary>
	


### 安装node环境
```
curl https://get.volta.sh | bash
```
```
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
```
```
source ~/.bashrc
```
```
volta install node@16.0.0
```
切换node版本只需再次安装需要的版本即可自动切换



### 3xui

```
bash <(curl -Ls https://raw.githubusercontent.com/admin8800/x-ui/main/install.sh)
```

[项目地址](https://github.com/MHSanaei/3x-ui)

###  一键wrap

```
wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh [option] [lisence/url/token]
```

```
warp [option] [lisence]
```

###  一键安装docker

```
curl -fsSL https://get.docker.com | sh
```

###  查看系统内核
```
dpkg --print-architecture
```



```
uname -a
```

####  查看系统版本
```
cat /etc/os-release
```
```
lsb_release -a
```

###  VPS开启root登录并且修改密码：

一键脚本

```
wget -N --no-check-certificate https://github.com/sky22333/rootvps/raw/main/rootvps && bash rootvps
```

### ubuntu系统添加root密码，实现root用户登录
```
sudo passwd root
```

###  安装依赖：
 Debian/Ubuntu 命令：
 

```
apt update
``` 

```
apt install curl wget git zip tar iptables lsof vim sudo -y
```


 CentOS 命令：

```
yum update -y
``` 

```
yum install curl wget git zip tar iptables lsof vim sudo -y
``` 

###  一键测试路由回程：

```
wget -qO- git.io/besttrace | bash
```
### 一键测速回程线路
```
curl https://raw.githubusercontent.com/zhanghanyun/backtrace/main/install.sh -sSf | sh
```


###  一键测试流媒体解锁：

```
bash <(curl -L -s check.unlock.media)
```

 
```
bash <(curl -L -s check.unlock.media) -M 4
```

 
```
bash <(curl -L -s check.unlock.media) -M 6
```

###  查看端口占用：
```
sudo lsof -i -P -n
```
```
ss -tuln
```
```
lsof -i:端口号
```
#### 释放端口
```
kill PID数字
```

###  放行端口：

```sudo ufw allow 端口号```

```sudo ufw allow 起始端口:结束端口```

```sudo ufw enable```   #  重启ufw防火墙

###  关闭端口：
```sudo ufw deny 端口号```

###  只允许指定IP连接22端口：
```sudo ufw allow from 192.168.1.100 to any port 22```      #  多IP用英文的逗号分开

###  文件类型转换：

```mv config.txt config.json```

```mv shell.txt shell.sh```


###  开启虚拟内存：

```
sudo fallocate -l 3G /swapfile && sudo chmod 700 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile && echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```


###  防火墙

```firewall-cmd --state```                             # 查看防火墙状态    


```systemctl stop firewalld.service```                 # 停止防火墙    


```systemctl disable firewalld.service```              # 禁止防火墙开机自启

###  一键开启bbr加速

```
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
```

```
sysctl net.ipv4.tcp_congestion_control
```



###  人型自走bot乌班图脚本


```
wget https://raw.githubusercontent.com/TeamPGM/PagerMaid-Pyro/development/utils/install.sh -O install.sh && chmod +x install.sh && bash install.sh
```


使用该脚本会将 ```Pagermaid-Pyro``` 安装至 ```/var/lib/pagermaid``` 目录下。



### 久激活 Windows 系统和 Office 软件

在 Windows 8.1/10/11 上，右键单击 Windows 开始菜单并 选择 PowerShell 或终端（非 CMD）

```
irm https://massgrave.dev/get | iex
```

稍微等待一下，他会自动适配，并激活您的系统，当出现 Successful 的时候说明系统已经激活成功了


###  查看电脑wifi密码CMD命令

查看已连接过的wifi：

```
netsh wlan show profile
```

查看密码：

```
netsh wlan show profile name="WiFi名称" key=clear
```

打印到C盘：

```
netsh wlan export profile folder=C:\ key=clear
```


</details>

---




<details>
  <summary>无人直播推流脚本</summary>


### 利用GPT写的无人直播FFmpeg推流脚本


#### [点击这里查看](https://github.com/sky22333/zhibo?tab=readme-ov-file#%E5%BE%AA%E7%8E%AF%E6%8E%A8%E6%B5%81%E6%97%A0%E4%BA%BA%E7%9B%B4%E6%92%AD)

</details>

---




<details>
  <summary>代理工具SSH工具下载</summary>

  
  
  | 类型 | 名称 | 下载地址 |
| :--- | :----: | :---: |
| 安卓代理  | v2rayNG  |https://github.com/2dust/v2rayNG/releases|
| 安卓代理  | clash-meta  |https://github.com/MetaCubeX/ClashMetaForAndroid/releases|
| Win代理  | clash-verge-rev  |https://github.com/clash-verge-rev/clash-verge-rev/releases|
| Win代理  | v2rayN  |https://github.com/2dust/v2rayN/releases|
| ios代理  | 小火箭  |https://apps.apple.com/us/app/shadowrocket/id932747118|
| ios代理  | V2Box  |https://apps.apple.com/us/app/v2box-v2ray-client/id6446814690|
| mac代理  | v2rayU  |https://github.com/yanue/V2rayU/releases|
| mac代理  | V2Box  |https://apps.apple.com/us/app/v2box-v2ray-client/id6446814690|
| mac代理  | clash-verge-rev  |https://github.com/clash-verge-rev/clash-verge-rev/releases|
| Liunx代理  | v2rayA  |https://v2raya.org/docs/prologue/introduction|
| 安卓SSH  | Termius汉化  |https://github.com/alongw/Termius-zh_CN/releases|
| 安卓SSH  | termux |https://github.com/termux/termux-app/releases|
| 安卓SSH  | serverbox  |https://github.com/lollipopkit/flutter_server_box/releases|
| 安卓code  | Acode |https://acode.app|
| 电脑SSH  | tabby  |https://github.com/Eugeny/tabby/releases|
| 电脑SSH  | WindTerm  |https://github.com/kingToolbox/WindTerm/releases|
| 电脑SSH  | FinalShell  |https://www.hostbuf.com/t/988.html|
| 电脑code  | Visual Studio Code  |https://code.visualstudio.com|
| ios SSH  | ServerBox  |https://apps.apple.com/us/app/serverbox-status-tools/id1586449703|
| ios SSH  | Termius |https://apps.apple.com/us/app/termius-terminal-ssh-client/id549039908|

</details>

---

<details>
  <summary>网站收藏or服务器</summary>
    
| 类型 | 名称 | 地址 |
| :--- | :----: | :---: |
| 服务器  | vmiss  |https://app.vmiss.com|
| SK5代理  | kookeey  |https://kookeey.com|
| SK5代理 | ip2world  |https://www.ip2world.com|
| 服务器  | evoxt  |https://evoxt.com/pricing|
| 服务器 | vultr  |https://www.vultr.com|
| 服务器  | 美国无线流量  |https://my.frantech.ca/cart.php|
| 服务器  | 越南家宽  |https://my.cloudfly.vn/cloud/server|
| 服务器  | gigsgigs  |https://clientarea.gigsgigscloud.com|
| 服务器  | 朝暮云 地区多  |https://zhaomu.com|
| 服务器  | CC一刀机  |https://cloudcone.com|
| 服务器  | RN二刀机  |https://my.racknerd.com|
| 服务器  | hostvds一刀机  |https://hostvds.com|
| 学习资料  | 网站合集  |https://theporndude.com/zh|
| 学习资料  | AI画图  |https://pornpen.ai|
| 素材  | 图标素材  |https://aigei.com|
| 礼品卡  | Pockyt Shop |https://shop.pockyt.io/pc/brands/all|
| 网络测试  | ipv6测试  |https://test-ipv6.com|
| 扫描  | dns和端口扫描  |https://search.censys.io|
| 扫描  | 网络扫描  |https://fofa.info|
| 扫描  | 网络扫描  |https://www.zoomeye.org|
| 扫描  | 端口扫描  |https://www.criminalip.io|
| 学习  | 编程菜鸟教程  |https://www.runoob.com|
| api接口  | 图片和文字  |https://api.aixiaowai.cn|
| api接口  | 图片和文字  |https://developer.hitokoto.cn|
| api接口  | 诗词  |https://www.jinrishici.com|
| 图床  | 动漫和动画  |https://mikupic.com|
| 图床  | 国内高速  |https://www.freeimg.cn|
| 网盘  | 网盘资源  |https://wpzy.cc|
| 资源采集  | 影视  |https://hongniuziyuan.com|
| 资源采集  | 影视  |http://lzizy.net|
| 资源采集  | X  |https://apilj.com|
| 资源采集  | X  |https://dadizy11.com|
| 安卓软件  | APK  |https://apkpure.net|
| 安卓软件  | APK  |https://www.apkmirror.com|

</details>

---


<details>
  <summary>轻量级Liunx文件管理系统</summary>



支持实时管理liunx系统文件的项目

安装：
```
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
```

启动：
```
filebrowser -a 0.0.0.0 -r /
```

设置—用户管理—用户编辑—增加文件管理命令`unzip tar chmod`

示例`unzip you.zip`  /  `chmod -R 777 home`

</details>

---


<details>
  <summary>Liunx配置wrap</summary>
    


[其他系统安装](https://pkg.cloudflareclient.com/)

debian系统安装：

```
curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
```
```
echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
```
```
sudo apt-get update && sudo apt-get install cloudflare-warp -y
```

注册客户端：

```
warp-cli registration new
```

开启代理模式：

```
warp-cli mode proxy
```

启动wrap：

执行此命令前必须`开启代理模式`否则机器可能失联
```
warp-cli connect
```


wrap将代理本地的`40000`端口

更改代理端口：`warp-cli proxy port 40000`

配置文件：`cd /var/lib/cloudflare-warp`

查看代理IP：
```
curl -x "socks5://127.0.0.1:40000" ipinfo.io
```



开启全局代理：
```
export ALL_PROXY=socks5://127.0.0.1:40000
```
关闭全局代理：
```
unset ALL_PROXY
```



关闭wrap：
```
warp-cli disconnect
```





</details>

---
<details>
  <summary>Git推送到GitHub仓库教程</summary>

#### 先创建一个仓库，然后本地CD到项目目录
### 设置推送地址
```
git config --global user.email "你的邮箱"
git config --global user.name "你的用户名"
```
```
git remote set-url origin https://你的用户名:个人访问令牌@github.com/你的用户名/你的仓库名.git
```
### 添加并提交新的更改
```
git add .
git commit -m "描述你的更改"
```
### 推送到仓库
```
git push origin main
```
`main`为分支名

#### 操作完成后清除Git存储凭据
```
git config --global --unset credential.helper
```

</details>

---