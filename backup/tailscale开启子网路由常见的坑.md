## immortalwrt部署tailscale并开启子网路由常见的坑

`192.168.3.0/24`根据自己需求更改，添加子网路由后，`192.168.3.0/24`网段的所有设备都能直接访问tailscale中的其他设备，无需安装tailscale

开启子网路由：
```
tailscale up --advertise-routes=192.168.3.0/24 --accept-routes --reset
```
开启后，在`tailscale`后台找到你路由器设备，点击右侧菜单(三个点)，选择`Edit route settings...`，勾选`192.168.3.0/24`，点击`Save`。

然后输入以下命令查看是否存在你广播的IP段
```
tailscale status --json | grep advertisedRoutes
或者
tailscale status --self --peers=false
```
如果这个时候你看不到你广播的网段，就说明广播失败了。反之则是成功。

### 坑点一
子网路由功能依赖`iptables`，immortalwrt默认防火墙一般不是这个，需要安装`iptables`

### 坑点二
immortalwrt默认不会让 LAN 网段流量被转发到`tailscale0`，需要手动加。

### 坑点三
需要启用 IP 转发，有时候没启用。

### 坑点四
开启了严格的反向路径过滤
```
cat /proc/sys/net/ipv4/conf/all/rp_filter
cat /proc/sys/net/ipv4/conf/tailscale0/rp_filter
cat /proc/sys/net/ipv4/conf/default/rp_filter
```
如果发现均返回2，说明开启了严格的反向路径过滤，需要关闭。