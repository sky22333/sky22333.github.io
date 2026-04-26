## 云服务器环境网络重装系统

- 1：查看系统信息并备份，安装新系统的时候可能会用到
```
# 查看系统盘
lsblk

# 查看网络配置
networkctl status

# 查看是否支持uefi
ls /sys/firmware/efi
```
- 2：下载 netboot.xyz 启动镜像（iPXE引导器）
```
wget https://boot.netboot.xyz/ipxe/netboot.xyz.img
```
- 3：将镜像DD写入整块系统盘（记得替换你实际的系统盘，会覆盖原系统，请确保重要数据已备份）
```
dd if=netboot.xyz.img of=/dev/vda bs=4M status=progress
```
- 4：强制将缓存写入磁盘，确保数据落盘完成
```
sync
```
- 5：重启服务器
```
reboot
```
- 6：通过云厂商后台的服务器VNC界面进入启动菜单，选择网络安装
```
Linux Network Installs (64-bit)
```

> 如果重装成功，结束后会自动进入新系统，需要注意的是新系统一般没有开启root用户的ssh权限，需要用普通用户ssh连接，然后切换为root用户后再修改。
> 
> 如果安装失败的话可能是硬盘分区有问题或者其他设置不对，可以返回到`netboot.xyz 启动菜单`，重新选择网络安装再装一遍即可。

---

## 自建netbootxyz服务安装系统

非常适合局域网内批量装机，服务端使用Linux系统，客户端装`Debian12`系统为例。

服务端和客户端必须要在同一局域网，服务端地址以`192.168.1.10`为例，请注意替换自己实际的地址。

- 安装dnsmasq
```
apt install dnsmasq -y
```
- Docker部署netbootxyz服务
```
services:
  netbootxyz:
    image: ghcr.io/netbootxyz/netbootxyz
    container_name: netbootxyz
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ./config:/config   # 存放自动生成的配置文件和自定义菜单
      - ./assets:/assets   # 存放系统镜像安装包
    ports:
      - 3000:3000          # Web UI 端口
      - 69:69/udp          # TFTP 端口
      - 80:80              # HTTP 端口
    restart: unless-stopped
```

编辑`/etc/dnsmasq.conf`

```
# 注意替换实际的网卡名称
interface=eth0
bind-interfaces
dhcp-range=192.168.1.100,192.168.1.200,255.255.255.0,12h

# 如果有其他DHCP的话可以开启强制接管
# dhcp-authoritative

# 直接指向 Docker 容器暴露在宿主机的 TFTP 端口
dhcp-boot=tag:!efi64,netboot.xyz.kpxe,,192.168.1.10
dhcp-match=set:efi64,option:client-arch,7
dhcp-boot=tag:efi64,netboot.xyz.efi,,192.168.1.10
```
- 重启dnsmasq
```
systemctl restart dnsmasq
```
- 下载镜像文件
```
# 创建目标目录
mkdir -p ./assets/debian

# 下载 linux 内核文件
wget -P ./assets/debian https://mirrors.tuna.tsinghua.edu.cn/debian/dists/bookworm/main/installer-amd64/current/images/netboot/debian-installer/amd64/linux

# 下载 initrd.gz 初始化文件系统
wget -P ./assets/debian https://mirrors.tuna.tsinghua.edu.cn/debian/dists/bookworm/main/installer-amd64/current/images/netboot/debian-installer/amd64/initrd.gz
```

此时，这些文件会自动被容器内的 Nginx 代理，可以通过 `http://192.168.1.10:80/assets/debian/linux` 访问。

浏览器访问：`http://192.168.1.10:3000` 进入 `netboot.xyz` 可视化控制台。

点击顶部的 `Menus`，在这里你可以直接编辑 `custom.ipxe`（如果没有则新建）。

填入以下内容：

```
#!ipxe

# 这里的 ${next-server} 变量会自动获取当前 DHCP 中指向的服务器 IP
set server_url http://${next-server}:80/assets/debian

kernel ${server_url}/linux initrd=initrd.gz auto=true priority=critical
initrd ${server_url}/initrd.gz
boot
```

其中`auto=true`和`priority=critical`参数是Debian系统特有的，用于安装期间尽量减少交互，如果其他系统请去掉。

没问题的话，客户端机器进入bios将PXE网络启动改为第一个启动项即可进入系统安装界面。

### Windows

对于安装Windows系统，可以使用 https://github.com/ipxe/wimboot 来直接加载 Windows 安装程序。

微软官方的`Windows ISO`镜像文件中，解压后`sources`目录下有一个核心文件`boot.wim`。这个`boot.wim`本质上就是一个微型的 `Windows PE`环境，可以用来启动并运行Windows安装程序。