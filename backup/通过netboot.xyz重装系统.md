## 云服务器环境网络重装系统

- 1：查看系统信息并备份，安装新系统的时候可能会用到
```
# 查看系统盘
df -h /

# 查看网络配置
ip a

# 查看是否支持uefi
ls /sys/firmware/efi
```
- 2：下载 netboot.xyz 启动镜像（iPXE引导器）
```
wget https://boot.netboot.xyz/ipxe/netboot.xyz.img
```
- 3：将镜像DD写入整块系统盘（记得替换你实际的系统盘，会覆盖原系统，请确保重要数据已备份）
```
dd if=netboot.xyz.img of=/dev/vda bs=4M
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

> 如果重装成功，结束后会自动进入新系统，需要注意的是新系统一般没有开启root用户的ssh权限，需要用普通用户ssh连接，然后切换为root用户后再修改。`Alpine`系统默认是安装在内存中的，进入系统后需要执行`setup-alpine`命令安装到硬盘。
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
      - ./assets:/assets   # 存放资源，可以直接通过HTTP端口访问
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

此时，这些文件会自动被容器内的 Nginx 代理，可以通过 `http://192.168.1.10:80/debian/linux` 访问。

浏览器访问：`http://192.168.1.10:3000` 进入 `netboot.xyz` 可视化控制台。

点击`Menus`，修改`boot.cfg`文件：

- 第8行：将`boot.netboot.xyz/3.0.1` 改为 `http://192.168.1.10:80/menus`
- 第9行新增：`set custom_url http://192.168.1.10:80/menus/custom.ipxe`
- 第14行：将`https://github.com/netbootxyz` 改为 `http://192.168.1.10:80`


然后编辑 `custom.ipxe`（如果没有则新建）。

填入以下内容：

```
#!ipxe

# 这里的 ${next-server} 变量会自动获取当前 DHCP 中指向的服务器 IP
set server_url http://${next-server}:80/debian

kernel ${server_url}/linux initrd=initrd.gz
initrd ${server_url}/initrd.gz
boot
```

记得点击右上角保存。

- 使配置可公开访问：
```
cp -r ./config/menus/ ./assets/
```

完成后建议重启一次`netbootxyz`容器

没问题的话，客户端机器进入bios将PXE网络启动改为第一个启动项即可。

### Windows

对于安装Windows系统，可以使用 https://github.com/ipxe/wimboot 来直接加载 Windows 安装程序。

微软官方的`Windows ISO`镜像文件中，解压后`sources`目录下有一个核心文件`boot.wim`。这个`boot.wim`本质上就是一个微型的 `Windows PE`环境，可以用来启动并运行Windows安装程序。

## Windows DHCP服务器

Windows系统可以使用开源的 [DnsServer](https://github.com/TechnitiumSoftware/DnsServer) 来部署DHCP服务器，这是一个强大的DNS服务端，支持DHCP，支持响应PXE报文，并且使用简单。

下载地址：https://download.technitium.com/dns/DnsServerSetup.zip

下载后双击安装程序，安装完成后会自动以服务模式后台运行，管理面板通过 `http://127.0.0.1:5380` 访问。

然后访问 `DHCP` - `Scopes` - 下面的`Bootstrap Server`区域来设置引导文件地址等信息。

### 具体步骤


假设你的局域网网段是 `192.168.1.x`，主路由器（网关）是 `192.168.1.1`，运行 netboot.xyz Docker 的电脑 IP 是 `192.168.1.10`。请根据你的实际网络情况替换这些 IP。

### 第一部分：基础网络分配（让设备能联网）

* **Name (名称)**: 随意填写，例如 `Netboot-LAN`。
* **Starting Address (起始地址)**: `192.168.1.100` （选择一段空闲的 IP 作为 DHCP 地址池起点）。
* **Ending Address (结束地址)**: `192.168.1.200` （地址池终点）。
* **Subnet Mask (子网掩码)**: `255.255.255.0`。
* **Lease Time (租约时间)**: 保持默认即可（通常是 1 Days）。
* **Ping Check (Ping 检查)**: 建议 **不勾选**
* **Router Address (路由器地址/网关)**: `192.168.1.1` （你真实路由器的 IP，**非常重要**，否则客户端获取 IP 后无法上网）。
* **DNS Servers**: 勾选 **Use This DNS Server**。这会让获取到 IP 的客户端使用 Technitium 作为 DNS 服务器。

### 第二部分：PXE 引导设置（让设备找到 netboot.xyz）

向下滚动找到 **Bootstrap** 相关的选项，这是引导成功的核心：

* **Bootstrap Server Address (siaddr)**: 填写 **运行 netboot.xyz Docker 容器的那台宿主机的 IP 地址**（例如 `192.168.1.10`）。
    * *注意：这里填的是 TFTP 服务器的地址，即你的 Docker 宿主机。*
* **Bootstrap Server Host Name (sname/Option 66)**: 留空即可。大多数现代 PXE 客户端只需要上面的 IP 地址就能找到 TFTP 服务器。
* **Boot File Name (file/Option 67)**: 根据你要引导的设备类型填写：
    * 如果你主要引导较新的电脑或虚拟机（UEFI 模式）：填写 `netboot.xyz.efi`
    * 如果你需要引导老旧的传统 BIOS 电脑：填写 `netboot.xyz.kpxe`

### 第三部分：其他选项（保持默认）
---

**关键提示：**
确保关闭了你主路由器上的 DHCP 服务器功能（或者确保主路由器分配的 IP 段与 Technitium 完全不重合，且主路由器不支持响应 PXE 请求）。