## 通过[netboot.xyz](https://github.com/netbootxyz/netboot.xyz)给云服务器重装系统

### 查看系统盘，通常为`/dev/vda`
```
lsblk
```
### 查看是否支持UEFI，有输出就代表支持
```
ls /sys/firmware/efi
```
### 下载 netboot.xyz 启动镜像（iPXE 引导器）
```
wget https://boot.netboot.xyz/ipxe/netboot.xyz.img
```
### 将镜像写入整块系统盘（会覆盖原系统，请确保重要数据已备份）
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

> 如果重装成功，结束后会自动进入新系统