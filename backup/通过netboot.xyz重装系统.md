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

- 国内服务器

`netboot.xyz`项目拉取镜像是在各大镜像官网拉取的，国内服务器下载会很慢，可以加载自己的ipxe脚本，然后脚本里使用国内镜像源。

可以在第6步中，选择`ipxe shell`加载自己的脚本，命令示例：
```
dhcp

chain https://example.com/embed.ipxe
```
---

### 手搓PXE服务

- 安装dnsmasq

编辑 `/etc/dnsmasq.conf` 配置DHCP和TFTP服务，重要环节，要和PXE客户端（要装系统的设备）在同一局域网。

```
# ProxyDHCP + TFTP 不影响已存在的DHCP服务器
# 关闭 DNS
port=0

# 日志
log-dhcp
log-facility=/var/log/dnsmasq.log

# 改1：你的局域网段
dhcp-range=192.168.1.0,proxy

# 改2：本机 IP
dhcp-option=option:tftp-server,192.168.1.10

# ==================== TFTP （放IPXE固件）====================
enable-tftp
tftp-root=/etc/tftp

# ==================== PXE 引导 ====================
pxe-service=x86PC,       "PXE BIOS",             netboot.xyz-undionly.kpxe
pxe-service=X86-64_EFI,  "PXE UEFI x64",         netboot.xyz-snponly.efi
pxe-service=ARM64_EFI,   "PXE UEFI ARM64",       netboot.xyz-arm64-snponly.efi
```

### netboot.xyz的IPXE固件下载地址

| 架构 | 文件名 | 下载地址 | 说明 |
| :--- | :--- | :--- | :--- |
| **Legacy (PCBIOS)** | `netboot.xyz-undionly.kpxe` | `https://boot.netboot.xyz/ipxe/netboot.xyz-undionly.kpxe` | 传统 BIOS DHCP 引导文件，通用网卡驱动|
| **UEFI x86_64** | `netboot.xyz-snponly.efi` | `https://boot.netboot.xyz/ipxe/netboot.xyz-snponly.efi` | UEFI 引导文件，仅从链式加载设备启动|
| **UEFI ARM64** | `netboot.xyz-arm64-snponly.efi` | `https://boot.netboot.xyz/ipxe/netboot.xyz-arm64-snponly.efi` | ARM64 UEFI 引导文件，仅从链式加载设备启动|

### netboot.xyz本地钩子

`netboot.xyz`官方固件启动后会自动调用`local-vars.ipxe`脚本，如果存在的话。

判断脚本是否存在：
他会自动扫描你tftp目录里的`local-vars.ipxe`脚本，你需要提前创建并放到tftp目录。如果没有的话他会走自己菜单的逻辑。并且是根据`DHCP`响应里的`server`信息找到你的tftp的IP地址。

### 编译自己的IPXE固件

当然你也可以从 [IPXE官方项目地址](https://github.com/ipxe/ipxe) 自行编译，这样你就可以将自己的ipxe启动脚本内置进去。

### ipxe脚本示例
ipxe脚本是核心步骤，从这里定义去哪里下载镜像，其他资源，和如何启动。

可根据自己情况修改，本地镜像文件则需要你启动一个HTTP服务，然后将镜像文件放进去，供客户端下载，适合离线环境。
```
#!ipxe
# ==================== iPXE 网络安装菜单 ====================
# 包含 Debian 12 安装 + Windows PE 安装

# 镜像文件托管地址（本地和高校镜像站二选一）
set server_ip http://192.168.1.10
set debian_mirror http://mirrors.cernet.edu.cn

# ==================== 菜单界面 ====================
:start
menu iPXE Network Install Menu
item debian    Debian 12 Automated Install
item winpe     Windows PE Install (Load boot.wim)
item shell     Enter iPXE Shell
item reboot    Reboot
choose --default debian --timeout 10000 option

goto ${option}

# ==================== Debian 12 安装 ====================
:debian
echo Starting Debian 12 automated installation...

kernel ${debian_mirror}/debian/dists/bookworm/main/installer-amd64/current/images/netboot/debian-installer/amd64/linux
initrd ${debian_mirror}/debian/dists/bookworm/main/installer-amd64/current/images/netboot/debian-installer/amd64/initrd.gz

imgargs linux initrd=initrd.gz auto=true priority=critical
boot

goto start

# ==================== Windows PE 安装 ====================
:winpe
echo Loading Windows PE...
kernel ${server_ip}/winpe/wimboot
initrd ${server_ip}/winpe/sources/boot.wim boot.wim

boot

goto start

# ==================== 进入 iPXE 命令行 ====================
:shell
echo Entering iPXE Shell...
shell

goto start

# ==================== 重启 ====================
:reboot
echo Rebooting...
reboot
```
然后在IPXE环境里下载并运行脚本
```
dhcp

chain http://example.com/embed.ipxe
```
建议使用http协议，因为https模块默认没有内置，需要编译时加进去，并且固件里的根证书只覆盖了常见的场景。

### PXE 客户端启动链路
```
开机
  │
  ▼
DHCP (路由器)
  │ 分配 IP/网关/DNS
  ▼
ProxyDHCP (dnsmasq)
  │ 附加 TFTP 地址 + 引导文件名
  ▼
TFTP (dnsmasq)
  │ 下载 iPXE 固件
  ▼
iPXE 环境启动
  │
  ▼
HTTP 加载 menu.ipxe 脚本（需要手动加载，除非自己编译固件让他自动加载）
  │
  ▼
menu.ipxe 菜单（这里的运行链路是本教程的脚本里定义的）
  ├── Debian  → HTTP (CERNET) → 下载 kernel + initrd → 安装
  ├── WinPE   → HTTP (自建)   → 下载 wimboot + wim  → 安装
  ├── Shell   → 进入命令行
  └── Reboot  → 重启
```


### 客户端机器装Windows

对于安装Windows系统，可以使用 https://github.com/ipxe/wimboot 来直接加载 Windows 安装程序。

微软官方的`Windows ISO`镜像文件中，解压后`sources`目录下有一个核心文件`boot.wim`。这个`boot.wim`本质上就是一个微型的 `Windows PE`环境，可以用来启动并运行Windows安装程序。

### 编译自己的IPXE固件

- 安装依赖
```
sudo apt update
sudo apt install -y build-essential liblzma-dev mtools mkisofs syslinux gcc-aarch64-linux-gnu wget tar git
```
- 下载源码
```
git clone https://github.com/ipxe/ipxe.git
```
- 进入`src`目录

- 编辑`config/general.h`文件（可选）
这个文件定义了固件的功能，常用的功能默认已经启用了，有些高级功能被注释了，如果需要启用就取消注释，一般默认的就够用了。

- 创建内置脚本`embed.ipxe`放到当前目录

- 编译命令

三种BIOS架构
```
# Legacy BIOS
make bin/undionly.kpxe EMBED=embed.ipxe

# UEFI x86_64
make bin-x86_64-efi/ipxe.efi EMBED=embed.ipxe

# UEFI ARM64
make CROSS_COMPILE=aarch64-linux-gnu- bin-arm64-efi/ipxe.efi EMBED=embed.ipxe
```

编译后的产物在`bin`目录