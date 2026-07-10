## 服务器配置SSH密钥登录

> 适用于`Debian`和`Ubuntu`系统



### 生成`ED25519`类型的 SSH 密钥对

```
ssh-keygen -t ed25519
```
>一路回车即可，生成的`id_ed25519`文件为私钥，使用这个连接服务器，`id_ed25519.pub`文件为公钥。


### 然后进入存储SSH密钥的目录，并配置公钥
```
cd ~/.ssh
cat id_ed25519.pub >> authorized_keys
```


### 修改SSH配置文件
```
sudo vim /etc/ssh/sshd_config
```
### 找到对应的配置然后修改
```
# 修改SSH服务端口
Port 2222

# 启用公钥认证
PubkeyAuthentication yes

# 指定存储公钥的文件位置(增加此项)
AuthorizedKeysFile .ssh/authorized_keys

# 禁止使用空密码登录
PermitEmptyPasswords no

# 禁止使用密码认证登录
PasswordAuthentication no
```

### 重启SSH服务
```
sudo systemctl restart ssh
```
