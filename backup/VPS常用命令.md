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

`sudo ufw allow 端口号`

`sudo ufw allow 起始端口:结束端口`

`sudo ufw enable`   #  重启ufw防火墙

###  关闭端口：
`sudo ufw deny 端口号`

###  只允许指定IP连接22端口：
`sudo ufw allow from 192.168.1.100 to any port 22`      #  多IP用英文的逗号分开

###  文件类型转换：

`mv config.txt config.json`

`mv shell.txt shell.sh`


###  开启虚拟内存：

```
sudo fallocate -l 3G /swapfile && sudo chmod 700 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile && echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```


###  防火墙

`firewall-cmd --state`                          # 查看防火墙状态    


`systemctl stop firewalld.service`                # 停止防火墙    


`systemctl disable firewalld.service`             # 禁止防火墙开机自启

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


使用该脚本会将 `Pagermaid-Pyro``` 安装至 ```/var/lib/pagermaid` 目录下。



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