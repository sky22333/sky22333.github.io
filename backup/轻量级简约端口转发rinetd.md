### 轻量级简约端口转发`rinetd`适合家庭网络

安装
```
apt update
apt install rinetd -y
```

配置文件路径
```
/etc/rinetd.conf
```

转发配置示例
```
0.0.0.0 8080 192.168.1.100 80
```
```
# 开机自启
systemctl enable rinetd

# 启动
systemctl start rinetd

# 查看服务状态
systemctl status rinetd

# 停止
systemctl stop rinetd

# 重启
systemctl restart rinetd

# 实时日志
journalctl -u rinetd -f
```