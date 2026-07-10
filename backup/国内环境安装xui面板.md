## 支持的系统

> amd64架构

- CentOS 7+
- Ubuntu 18+
- Debian 8+


## 一键安装脚本（支持纯IPV6环境和国内环境）

```
bash <(wget -qO- https://gitlab.com/yishijie/3xui/raw/main/3xui.sh)
```

## 手动安装

1. 下载压缩包 [(点击下载)](https://gitlab.com/yishijie/3xui/raw/main/x-ui-linux-amd64.tar.gz) 到本地。

2. 将压缩包上传到服务器的`root`目录

3. 然后依次执行以下命令，一行一个命令

```
cd /root
rm x-ui/ /usr/local/x-ui/ /usr/bin/x-ui -rf
tar zxvf x-ui-linux-amd64.tar.gz
chmod +x x-ui/x-ui x-ui/bin/xray-linux-* x-ui/x-ui.sh
cp x-ui/x-ui.sh /usr/bin/x-ui
cp -f x-ui/x-ui.service /etc/systemd/system/
mv x-ui/ /usr/local/
systemctl daemon-reload
systemctl enable x-ui
systemctl restart x-ui
x-ui
```
