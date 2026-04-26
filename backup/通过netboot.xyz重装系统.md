## 通过[netboot.xyz](https://github.com/netbootxyz/netboot.xyz)给云服务器重装系统

### 查看系统盘，通常为`/dev/vda`
```
lsblk
```
### 查看是否支持UEFI，有输出就代表支持
如果不支持UEFI，则安装系统的时候就不能选择UEFI
```
ls /sys/firmware/efi
```
### 下载 netboot.xyz 启动镜像（iPXE 引导器）
```
wget https://boot.netboot.xyz/ipxe/netboot.xyz.img
```
### 将镜像写入整块系统盘（记得修改实际的系统盘，会覆盖原系统，请确保重要数据已备份）
```
dd if=netboot.xyz.img of=/dev/vda bs=4M status=progress
```
### 强制将缓存写入磁盘，确保数据落盘完成
```
sync
```
### 重启服务器
```
reboot
```
### 通过VNC界面进入启动菜单，选择网络安装
```
Linux Network Installs (64-bit)
```

> 如果重装成功，结束后会自动进入新系统，需要注意的是新系统一般没有开启root用户的ssh权限，需要用普通用户ssh连接，然后切换为root用户后再修改。

---

#  自建 PXE 启动教程

服务端为Linux系统，客户端装`Debian12`系统

服务端和客户端必须要在同一局域网，服务端地址以`192.168.1.10`为例，请自行替换。

- 安装dnsmasq
```
apt install dnsmasq -y
```
- docker部署netbootxyz服务
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
      - 80:80              # Nginx HTTP 端口
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

没问题的话，客户端机器进入bios将PXE网络启动改为第一个启动项即可。

### Windows
对于安装Windows系统，可以使用 https://github.com/ipxe/wimboot 来直接加载win系统安装器。

微软官方的`Windows ISO`文件中，`sources`目录下有一个核心文件`boot.wim`。这个`boot.wim`本质上就是一个微型的 `Windows PE`环境，用来启动并运行 Windows 安装程序。