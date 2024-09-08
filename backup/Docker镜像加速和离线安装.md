## Docker镜像加速和离线安装

国内从 Docker Hub 拉取镜像有时会遇到困难，此时可以配置镜像加速器。


### 安装Docker（如果安装困难可以选择手动安装）
官方脚本安装：

```
curl -fsSL https://get.docker.com | sh
```
国内机器安装脚本：

```
bash <(curl -sSL https://linuxmirrors.cn/docker.sh)
```
### （可选）离线环境或者国内机器手动安装Docker
  

#### 1：手动下载Docker软件包

[Docker软件包下载地址](https://download.docker.com/linux/static/stable/x86_64/)

上传到服务器的root目录后执行以下命令

```
tar xzvf docker-27.0.3.tgz   // 替换对应的版本号
```
```
sudo mv docker/* /usr/local/bin/
```
#### 2：创建 Docker 服务文件
```
sudo vim /etc/systemd/system/docker.service
```
添加以下内容
```
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/local/bin/dockerd
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutSec=0
RestartSec=2
Restart=always

# Note that StartLimit* options were moved from "Service" to "Unit" in systemd 229.
# Both the old, and new location are accepted by systemd 229 and up, so using the old location
# to make them work for either version of systemd.
StartLimitBurst=3

# Note that StartLimitInterval was renamed to StartLimitIntervalSec in systemd 230.
StartLimitInterval=60s

# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity

# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
TasksMax=infinity

# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes

# kill only the docker process, not all processes in the cgroup
KillMode=process

[Install]
WantedBy=multi-user.target
```

#### 3：启动并启用 Docker 服务
```
sudo chmod +x /etc/systemd/system/docker.service
sudo systemctl daemon-reload
sudo systemctl start docker
sudo systemctl enable docker
```
#### 4：查看版本
```
docker -v
```




### 安装Docker Compose

运行以下命令来下载 Docker Compose：

```
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
添加可执行权限:
```
chmod +x /usr/local/bin/docker-compose
```
查看版本:
```
docker-compose --version
```

---
#### （可选）离线环境或者国内服务器可[手动下载文件](https://github.com/docker/compose/releases)上传到`/usr/local/bin`目录，并重命名为`docker-compose`，然后增加执行权限。
一般下载`linux-x86_64`的包即可，其他型号则下载对应的

---


---

## 配置加速地址

> Ubuntu 16.04+、Debian 8+、CentOS 7+

创建或修改 `/etc/docker/daemon.json`：

```
sudo mkdir -p /etc/docker
```
```
sudo tee /etc/docker/daemon.json <<EOF
{
    "registry-mirrors": [
        "https://hub.rat.dev",
        "https://docker.1panel.live"
    ]
}
EOF
```
```
sudo systemctl daemon-reload
```
```
sudo systemctl restart docker
```


### 检查加速是否生效

查看docker系统信息 `docker info`，如果从结果中看到了如下内容，说明配置成功。

```console
Registry Mirrors:
 [...]
 https://docker.1panel.live
```

对于 Mac 和 Windows 用户，直接在 Docker Desktop 系统设置中，配置 registry-mirrors 即可。

---
## 使用代理拉取镜像

#### 创建配置文件
```
sudo mkdir -p /etc/systemd/system/docker.service.d
```
```
sudo vim /etc/systemd/system/docker.service.d/http-proxy.conf
```
#### 在文件中添加代理
```
[Service]
Environment="HTTP_PROXY=socks5://user:pass@127.0.0.1:1080"
Environment="HTTPS_PROXY=socks5://user:pass@127.0.0.1:1080"
```
#### 重启Docker
```
sudo systemctl daemon-reload
sudo systemctl restart docker
```
#### 查看环境变量
```
sudo systemctl show --property=Environment docker
```
---
## 备用方法：直接传送镜像
国外服务器拉取镜像后打包压缩到本地，然后传输到国内服务器，`myimage`为镜像名
#### A服务器保存Docker镜像
```
docker save myimage > myimage.tar
```
#### 传送到B服务器
```
scp myimage.tar root@192.0.2.0:/home
```
然后输入B服务器root密码

#### B服务器加载Docker镜像

```
cd /home
```

```
docker load < myimage.tar
```
查看镜像
```
docker images
```
---

## Docker Hub 镜像测速

拉取镜像时，可使用 `time` 统计所花费的总时间。测速前记得移除本地的镜像。

例如：`time docker pull node:latest`

## 卸载Docker
```
sudo systemctl stop docker
sudo apt-get purge docker-ce docker-ce-cli containerd.io
sudo rm -rf /etc/docker /var/lib/docker
```

---

## Docker最新稳定加速源列表——非私人

提供者 | 镜像加速地址 | 说明 | 加速类型
--- | --- | --- | ---
[耗子面板](https://hub.rat.dev/) | `https://hub.rat.dev` | 无限制 | Docker Hub
[rainbond](https://docker.rainbond.cc) | `https://docker.rainbond.cc` | 无限制 | Docker Hub
[1panel](https://1panel.cn/docs/user_manual/containers/setting/) | `https://docker.1panel.live` | 无限制 | Docker Hub
[DaoCloud](https://github.com/DaoCloud/public-image-mirror) | `https://docker.m.daocloud.io` |白名单和限流 | Docker Hub
