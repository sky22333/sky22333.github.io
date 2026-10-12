# 介绍
OpenWrt 是一个 基于 Linux 的路由器操作系统，专门为嵌入式设备（路由器、NAS、小型网关设备等）设计。

本篇教程基于`immortalwrt`，immortalwrt 是基于 openwrt 开发的优化版本，是专门针对中国大陆环境优化的版本。国内用户基本都使用这个版本。

项目地址：https://github.com/immortalwrt/immortalwrt

# immortalwrt 在线构建

官方提供的网页在线构建叫`ImageBuilder`，不是编译源码，而是借助官方的服务器资源，使用预编译好的SDK，快速选择包然后生成固件。优点是构建很快，缺点是自定义程度不是很高，但是常用的配置都可以自定义，例如提前安装插件，配置网口信息和防火墙什么的。

官方在线编译地址：https://firmware-selector.immortalwrt.org

## 必备软件
```
openssh-sftp-server curl luci-theme-argon luci-i18n-homeproxy-zh-cn luci-i18n-ttyd-zh-cn luci-i18n-diskman-zh-cn luci-i18n-filemanager-zh-cn luci-i18n-package-manager-zh-cn luci-i18n-firewall-zh-cn
```

当你安装一个插件包时，他会自动下载所需的软件和依赖，所以只需添加对应插件的汉化包即可。

ImmortalWrt软件包查询（注意替换实际的版本和设备架构）：

带luci界面的包：https://downloads.immortalwrt.org/releases/25.12.2/packages/x86_64/luci/index.json

不带luci界面的包：https://downloads.immortalwrt.org/releases/25.12.2/packages/x86_64/packages/index.json

## 初始化构建脚本

```
# 首次启动初始化脚本
# 路径：/rom/etc/uci-defaults/
# 取消注释即可启用

# Wi-Fi 名称和密码
# wlan_name="ImmortalWrt"
# wlan_password="12345678"

# 后台及 SSH 管理员密码
# root_password="admin"

# LAN 地址（25.12+ 必须使用 CIDR 格式）
# lan_ip_address="192.168.2.1/24"

# PPPoE 宽带账号和密码
# pppoe_username=""
# pppoe_password=""

# 记录执行日志
exec >/tmp/setup.log 2>&1

# 设置管理员密码
if [ -n "$root_password" ]; then
  (echo "$root_password"; sleep 1; echo "$root_password") | passwd > /dev/null
fi

# 设置 LAN 地址
if [ -n "$lan_ip_address" ]; then
  uci set network.lan.ipaddr="$lan_ip_address"
  uci commit network
fi

# 设置 Wi-Fi
if [ -n "$wlan_name" -a -n "$wlan_password" -a ${#wlan_password} -ge 8 ]; then
  uci set wireless.@wifi-device[0].disabled='0'
  uci set wireless.@wifi-iface[0].disabled='0'
  uci set wireless.@wifi-iface[0].encryption='psk2'
  uci set wireless.@wifi-iface[0].ssid="$wlan_name"
  uci set wireless.@wifi-iface[0].key="$wlan_password"
  uci commit wireless
fi

# 设置 PPPoE 拨号
if [ -n "$pppoe_username" -a "$ppoe_password" ]; then
  uci set network.wan.proto=pppoe
  uci set network.wan.username="$pppoe_username"
  uci set network.wan.password="$pppoe_password"
  uci commit network
fi

echo "All done!"
```

构建完成后下载对应的固件包刷入系统即可。

# immortalwrt 基于源码编译

使用干净的`Debian 12`或者`ubuntu 22.04`系统，国外网络通畅，有40G以上的空闲存储空间。注意源码编译很费时间，4H8G的配置需要大约2小时以上才能编译好。

### 1：安装依赖
```
sudo apt update -y
sudo apt full-upgrade -y
sudo apt install -y \
  ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
  bzip2 ccache clang cmake cpio curl device-tree-compiler ecj fastjar flex gawk gettext \
  gcc-multilib g++-multilib git gperf haveged help2man intltool libc6-dev-i386 libelf-dev \
  libglib2.0-dev libgmp-dev libltdl-dev libmpc-dev libmpfr-dev libncurses-dev libpython3-dev \
  libreadline-dev libssl-dev libtool libyaml-dev lld llvm lrzsz genisoimage \
  ninja-build p7zip-full patch pkgconf python3 python3-pip python3-ply python3-docutils \
  python3-pyelftools qemu-utils re2c rsync scons squashfs-tools subversion swig texinfo \
  uglifyjs unzip wget nano xmlto xxd zlib1g-dev upx zstd
```

### 2：下载对应tags的源码（以`v24.10.4`为例）

后续步骤建议切换为普通用户，不要用root用户编译。
```
git clone -b v24.10.4 --single-branch --filter=blob:none https://github.com/immortalwrt/immortalwrt
```
### 3：进入项目目录
```
cd immortalwrt
```
### 4：获取最新软件包清单
```
./scripts/feeds update -a
```
### 5：安装软件包符号链接
```
./scripts/feeds install -a
```
### 6：配置固件信息
```
make menuconfig
```
这一步很重要，前三个选项分别是`目标系统` - `子架构` - `目标机型`。根据你的实际设备来选。

然后第四个选项`Target Images`是修改固件配置的，其中`Root filesystem partition size`是`根文件系统分区大小`建议修改，根据你设备的存储空间来选择，这里的值就是最大存储空间。

其他配置都是可选的，其中`luci`选项中可以预安装一些插件包。

来自某大佬的详细说明：https://youtu.be/czUW52M62Sw?t=2432

### 7：修改LAN口IP地址等等信息

可以在这里查看默认值：https://github.com/immortalwrt/immortalwrt/blob/master/package/base-files/files/bin/config_generate
```
nano package/base-files/files/bin/config_generate
```
### 8：编译固件

单线程编译
```
make -j1 V=s
```
或者多线程编译
```
make -j$(nproc --ignore=1)
```

编译出来的固件在`bin`目录下


### 9：重新编译说明

如果需要重新编译 则执行`make distclean`清理一些残留和工具链等等，然后再从第四步重新开始。

---

# VirtualBox虚拟机运行immortalwrt

1：选择`x86/64`型号，编译后，下载`COMBINED (EXT4)`格式的镜像，并解压到下载目录

2：在文件目录下打开 PowerShell

- 将镜像转换成VDI格式
```
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" convertfromraw `
    "immortalwrt-24.10.4-f726c678216d-x86-64-generic-ext4-combined.img" `
    "immortalwrt.vdi" `
    --format VDI
```

3：打开VirtualBox，新建虚拟机，OS选择`Linux`，然后选择`Other Linux`，然后指定虚拟硬盘，选择`使用已有的虚拟硬盘文件`，选择`immortalwrt.vdi`文件，然后点击完成，然后设置里找到网络，选择`桥接网卡`，勾选`Virtual Cable Connected`，注意你的openwrt系统的`LAN`口IP地址要和电脑在同一网段。网关和DNS也要和电脑的一致。

系统内修改网络配置的命令：
```
vi /etc/config/network
```
```
/etc/init.d/network restart
```

4：浏览器进入`LAN`口IP地址，密码是初始化脚本中设置的密码。

# X86主机设备将镜像写入到硬盘

先将镜像烧录到U盘，然后使用U盘启动进入到openwrt系统，然后使用DD命令写入镜像，就可以拔掉U盘运行openwrt系统了。

#### 查看U盘和目标硬盘
```
lsblk -f
```
> 例如 U 盘是 `/dev/sdb`  硬盘是 `/dev/sda` 
#### 如果目标硬盘有被挂载则需要卸载，例如之前装了系统之类的
```
umount /dev/sda1
umount /dev/sda2
umount /dev/sda3
```
#### 检查是否卸载成功
```
mount | grep sda
```
> 如果返回为空就代表卸载成功了
#### 写入镜像（注意替换实际的U盘和硬盘）
```
dd if=/dev/sdb of=/dev/sda bs=4M conv=fsync
```
> 如果没报错，并且看到了两行数字就代表成功了

#### 强制刷新缓存
```
sync
```

### 命令解释：

`if=/dev/sdb` ：输入源，U 盘设备

`of=/dev/sda` ：输出目标，硬盘/闪存设备

`bs=4M` ：每次写入 4M，提高速度

`conv=fsync` ：写完后刷新缓存，确保数据落盘

`sync` ：再次确保所有数据写入完成