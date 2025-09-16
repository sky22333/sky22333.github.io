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

### win系统内置的TCP端口转发

- 查看是否开启 IPv4 转发（0代表关闭，1代表开启）
```
reg query HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters /v IPEnableRouter
```

- 开启 IPv4 转发（需要重启生效）
```
reg add HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters /v IPEnableRouter /t REG_DWORD /d 1 /f
```


- 将本机所有网卡 54321 端口的请求转发到 192.168.1.101:54321
```
netsh interface portproxy add v4tov4  listenaddress=0.0.0.0 listenport=54321 connectaddress=192.168.1.101 connectport=54321
```

- 删除本机上监听 172.16.0.4:8080 转发的规则
```
netsh interface  portproxy delete v4tov4 listenaddress=172.16.0.4 listenport=8080
```
- 查看端口监听状态
```
netstat -ano | find "54321"
```

- 显示系统中的转发规则列表
```
netsh interface portproxy show all
```

- 查看portproxy设置
```
netsh interface portproxy dump
```

- 删除指定的转发规则
```
netsh interface portproxy delete v4tov4 listenport=54321 listenaddress=0.0.0.0
```
- 清除所有端口转发规则
```
netsh interface portproxy reset
```
- 展示系统中的所有转发规则
```
netsh interface  portproxy show  v4tov4
```