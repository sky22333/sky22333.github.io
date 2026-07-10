### alpine系统是一个超级轻量级系统，非常适合低配机器

首先将系统DD为alpine系统
```
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh
```
```
chmod +x reinstall.sh && ./reinstall.sh alpine
```
> 这里会让你设置新密码，完成后就可以重启系统开始安装
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
| `rc-service docker start`   | 启动指定服务                            |
| `rc-service docker stop`    | 停止指定服务                            |
| `rc-service docker restart` | 重启指定服务                            |
| `rc-service docker status`  | 查看服务的当前状态                      |
| `rc-update add docker` | 将服务添加到开机自启列表                 |
| `rc-update del docker` | 删除服务的开机自启设置                  |
| `rc-update show`                    | 列出所有已启用的服务                    |
| `rc-service docker log`     | 查看服务日志（如果服务支持日志功能）    |
| `rc-service all start`              | 启动所有服务                            |
| `rc-service all stop`               | 停止所有服务                            |

并且`rc-service`可以简化为`service`，例如`rc-service docker start`和`service docker start`效果是一样的。

如果需要使用web服务，我推荐使用`caddy`，并且`caddy`已经添加到官方apk仓库里了，可以直接安装
```
apk add caddy
```

### OpenRC 服务启动x-ui示例

路径`/etc/init.d/x-ui`

`x-ui`就是配置文件，写入以下内容
```
#!/sbin/openrc-run

name="x-ui"
description="x-ui service managed by OpenRC"

# 二进制路径
command="/usr/local/bin/x-ui"
# 没有启动参数
command_args=""

# 守护进程模式
command_background=true

# PID 文件
pidfile="/run/x-ui.pid"

# 自动重启设置
respawn_delay=5  # 出错后等待 5 秒重启
respawn_max=0    # 无限次重启

# 服务依赖
depend() {
    need net
    use logger
}

# 启动前检查
start_pre() {
    :
}

# 停止服务
stop() {
    ebegin "Stopping $RC_SVCNAME"
    start-stop-daemon --stop --pidfile $pidfile || eend $?
}

# 重启服务
restart() {
    stop
    start
}
```
增加执行权限
```
chmod +x /etc/init.d/x-ui
```
 然后使用前面的管理服务的命令启动