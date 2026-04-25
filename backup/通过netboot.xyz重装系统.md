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

#  内网离线 PXE 启动教程（Debian 12版）

`netboot.xyz + HTTP Server / Debian 12`

### 一、服务端IP示例
服务端为linux
```
192.168.1.10
```

### 二、安装依赖

```
sudo apt update
sudo apt install dnsmasq -y
```
### 三、目录创建
```
sudo mkdir -p /pxe/tftpboot
sudo mkdir -p /pxe/www/debian
```
### 四、下载 PXE 引导文件
```
cd /pxe/tftpboot

# 如果内网离线，需自行从有网环境下载后上传
wget https://boot.netboot.xyz/ipxe/netboot.xyz.kpxe
wget https://boot.netboot.xyz/ipxe/netboot.xyz.efi
```
### 五、iPXE 离线引导脚本
路径（一式两份）：
```
/pxe/tftpboot/boot.ipxe
/pxe/www/boot.ipxe
```
内容：
```
#!ipxe

# 定义服务器地址
set server 192.168.1.10:8000

# 加载 Debian 网络安装内核与初始化文件系统
kernel http://${server}/debian/linux initrd=initrd.gz auto=true priority=critical
initrd http://${server}/debian/initrd.gz

# 启动安装程序
boot
```
`auto=true` 和 `priority=critical` 是 Debian 安装程序特有的引导参数，用于尽量减少交互，只询问必须要配置的参数，如果是其他系统则去掉。

### 六、下载 Debian 网络安装文件
```
cd /pxe/www/debian

# 从清华镜像站下载（也可以选择其他镜像源）
wget https://mirrors.tuna.tsinghua.edu.cn/debian/dists/bookworm/main/installer-amd64/current/images/netboot/debian-installer/amd64/linux
wget https://mirrors.tuna.tsinghua.edu.cn/debian/dists/bookworm/main/installer-amd64/current/images/netboot/debian-installer/amd64/initrd.gz
```
### 七、目录结构
```
/pxe/
├── tftpboot/
│   ├── boot.ipxe        # 您创建的iPXE脚本
│   ├── netboot.xyz.efi  # UEFI引导文件
│   └── netboot.xyz.kpxe # Legacy BIOS引导文件
└── www/
    ├── boot.ipxe        # 您创建的iPXE脚本
    └── debian/
        ├── linux         # Debian安装内核
        └── initrd.gz     # 初始化文件系统
```
### 八、设置权限
```
sudo chmod -R 755 /pxe
```
### 九、启动 HTTP 服务
```
cd /pxe/www
python3 -m http.server 8000
```

### 十、dnsmasq 配置

文件： `/etc/dnsmasq.conf`
```
# 请务必替换为你的实际网卡名！
interface=eth0
bind-interfaces

# 根据你的局域网情况调整DHCP地址池
dhcp-range=192.168.1.100,192.168.1.200,255.255.255.0,12h

# 启用TFTP
enable-tftp
tftp-root=/pxe/tftpboot

# 为不同固件类型下发指定的引导文件
dhcp-boot=tag:!efi64,netboot.xyz.kpxe
dhcp-match=set:efi64,option:client-arch,7
dhcp-boot=tag:efi64,netboot.xyz.efi

# 如果你内网已有其他DHCP服务器，可取消下面这行的注释
# dhcp-authoritative
```

### 十一、重启服务
```
sudo systemctl restart dnsmasq
sudo systemctl enable dnsmasq
```
### 十二、验证
```
# 检查dnsmasq服务状态，应显示active (running)
sudo systemctl status dnsmasq

# 检查HTTP服务是否正常，应看到文件列表
curl http://192.168.1.10:8000/

# 测试关键文件是否可下载，都应返回 HTTP/1.0 200 OK
curl -I http://192.168.1.10:8000/debian/linux
curl -I http://192.168.1.10:8000/debian/initrd.gz
```
### 十三、客户端设置
```
Legacy BIOS：设置 Network Boot 或 PXE Boot 为首选启动项。

UEFI模式：在BIOS中启用 UEFI Network Stack 或 UEFI PXE Boot。
```
临时启动：开机时可通过快捷键（如F12）手动选择网络启动。

### 十四、启动成功标志
```
iPXE initialising devices...
Loading http://192.168.1.10:8000/debian/linux...
Loading http://192.168.1.10:8000/debian/initrd.gz...
```
随后便会进入 Debian 安装程序的界面。

---

# 内网离线 PXE 启动教程（Windows 11版）
`netboot.xyz + HTTP Server / Windows 11`

### 一、服务端IP示例
服务端为linux
```
192.168.1.10
```
### 二、安装依赖
```
sudo apt update
sudo apt install dnsmasq wimtools -y
```
说明：新增了 wimtools 包，它包含了处理 Windows 镜像所需的 wiminfo 等工具。

### 三、目录创建
```
sudo mkdir -p /pxe/tftpboot
sudo mkdir -p /pxe/www/win11
```
### 四、下载 PXE 引导文件与 wimboot
```
cd /pxe/tftpboot

# 1. 下载 netboot.xyz 引导文件（不变）
wget https://boot.netboot.xyz/ipxe/netboot.xyz.kpxe
wget https://boot.netboot.xyz/ipxe/netboot.xyz.efi

# 2. 下载 wimboot（这是启动 Windows PE 的关键引导器）
wget https://github.com/ipxe/wimboot/releases/latest/download/wimboot
```
### 五、iPXE 离线引导脚本
路径（一式两份，原因同 Debian 方案）：
```
/pxe/tftpboot/boot.ipxe

/pxe/www/boot.ipxe
```
内容：

```
#!ipxe

# 定义服务器地址
set server 192.168.1.10:8000

# 加载 wimboot 引导器
kernel http://${server}/wimboot
# 加载 Windows PE 镜像（从 Windows 11 ISO 中提取的 boot.wim）
initrd http://${server}/win11/boot.wim boot.wim

# 启动安装程序
boot
```


### 六、准备 Windows 11 网络安装文件
请先下载 Windows 11 官方 ISO 镜像，然后执行以下操作：

```
# 挂载 ISO（以映像在 ~/Win11.iso 为例）
sudo mkdir -p /mnt/win11iso
sudo mount -o loop ~/Win11.iso /mnt/win11iso

# 复制核心启动文件 boot.wim 到 HTTP 目录
sudo cp /mnt/win11iso/sources/boot.wim /pxe/www/win11/

# 复制 wimboot 到 HTTP 目录（与 tftpboot 中的保持一致）
sudo cp /pxe/tftpboot/wimboot /pxe/www/

# 清理挂载
sudo umount /mnt/win11iso
```
### 七、目录结构
```
/pxe/
├── tftpboot/
│   ├── boot.ipxe           # 您的 iPXE 脚本
│   ├── netboot.xyz.efi     # UEFI 引导文件
│   ├── netboot.xyz.kpxe    # Legacy BIOS 引导文件
│   └── wimboot             # Windows 引导器
└── www/
    ├── boot.ipxe           # 您的 iPXE 脚本
    ├── wimboot             # 引导器副本（HTTP 访问用）
    └── win11/
        └── boot.wim        # Windows PE 启动镜像
```
### 八、设置权限
```
sudo chmod -R 755 /pxe
```
### 九、启动 HTTP 服务
```
cd /pxe/www
python3 -m http.server 8000
```
### 十、安装 Windows 到客户端

当客户端通过 PXE 成功加载 boot.wim 后，会进入 Windows PE (WinPE) 命令提示符。由于这是离线环境，你需要在此手动执行安装：

挂载网络安装源：
```
net use Z: \\192.168.1.10\pxe\www\win11
```
启动安装程序：
```
Z:\setup.exe
```