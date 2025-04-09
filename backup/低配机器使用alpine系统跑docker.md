### alpine系统是一个超级轻量级系统，非常适合低配机器

下面教搭建使用alpine系统跑docker

首先将系统DD为alpine系统
```
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh
```
```
chmod +x reinstall.sh && ./reinstall.sh alpine
```
> 设置一个新密码，然后重启系统开始安装
```
reboot
```


### 进入系统

首先安装一些基础工具
```
apk update
```
```
apk add curl wget bash
```

安装docker和docker-compose
```
apk add docker docker-compose
```
启动服务并且设置开机自启
```
rc-service docker start
rc-update add docker
```

### 在 Alpine 中，系统服务是由 OpenRC 管理的

命令参考

| 命令                                | 说明                                    |
|-------------------------------------|-----------------------------------------|
| `rc-service <service-name> start`   | 启动指定服务                            |
| `rc-service <service-name> stop`    | 停止指定服务                            |
| `rc-service <service-name> restart` | 重启指定服务                            |
| `rc-service <service-name> status`  | 查看服务的当前状态                      |
| `rc-update add <service-name> default` | 将服务添加到开机自启列表                 |
| `rc-update del <service-name> default` | 删除服务的开机自启设置                  |
| `rc-update show`                    | 列出所有已启用的服务                    |
| `rc-service <service-name> log`     | 查看服务日志（如果服务支持日志功能）    |
| `rc-service all start`              | 启动所有服务                            |
| `rc-service all stop`               | 停止所有服务                            |

并且`rc-service`可以简化为`service`，例如`rc-service docker start`和`service docker start`效果是一样的。

如果需要使用web服务，我推荐使用`caddy`，并且`caddy`已经添加到官方apk仓库里了，可以直接安装
```
apk add caddy
```