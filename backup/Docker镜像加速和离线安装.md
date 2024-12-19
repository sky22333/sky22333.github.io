# Docker Hub 镜像加速

国内从 Docker Hub 拉取镜像有时会遇到困难，此时可以配置镜像加速器。


### 安装Docker
官方安装脚本：

```
curl -fsSL https://get.docker.com | sh
```
>会以插件的形式自动安装`docker compose`    输入`docker compose version`查看版本

国内安装脚本  [(说明)](https://linuxmirrors.cn/other/)

```
bash <(curl -sSL https://gitee.com/SuperManito/LinuxMirrors/raw/main/DockerInstallation.sh)
```

或者使用阿里云源
```
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```


<details>
  <summary>手动离线安装Docker</summary>
  
####  下载 Docker:

[官方文件下载地址——下载后上传到root目录](https://download.docker.com/linux/static/stable/x86_64/)

[清华大学下载地址](https://mirrors.tuna.tsinghua.edu.cn/docker-ce/)

```
tar xzvf docker-26.1.3.tgz     # 替换版本号
sudo mv docker/* /usr/local/bin/
```
#### 创建 Docker 服务文件
```
sudo vim /etc/systemd/system/docker.service
```
添加以下内容
```
[Unit]
Description=Docker Application Container Engine
After=network-online.target firewalld.service
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/local/bin/dockerd
ExecReload=/bin/kill -s HUP $MAINPID
Restart=always
RestartSec=2
StartLimitBurst=3
StartLimitInterval=60s
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
```

#### 启动并启用 Docker 服务
```
sudo chmod +x /etc/systemd/system/docker.service
sudo systemctl daemon-reload
sudo systemctl start docker
sudo systemctl enable docker.service
```
#### 查看版本
```
docker -v
```




</details>


<details>
  <summary>手动离线安装Docker-compose</summary>
  

### 国内环境手动安装Docker-compose

[点这里手动下载文件](https://github.com/docker/compose/releases) 上传到服务器的`/usr/local/bin`目录

重命名为docker-compose
```
sudo cp docker-compose-linux-x86_64 /usr/local/bin/docker-compose
```
增加执行权限
```
chmod +x /usr/local/bin/docker-compose
```
验证安装
```
docker-compose --version
```

###  注意：
由于是以二进制文件安装的`docker-compose`，所以运行命令有所变化，运行示例
```
docker-compose up -d
```

区别在于中间的`-`，官方安装脚本是以插件形式安装的`docker-compose`，所以中间不需要`-`



---

</details>




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
        "https://docker.1ms.run",
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


#### 如果您当前有正在运行的容器不方便重启Docker服务，则不用设置环境也可以直接使用，用法示例：
```
docker pull docker.1panel.live/library/mysql:5.7
```
说明：`library`是一个特殊的命名空间，它代表的是官方镜像。如果是某个用户的镜像就把`library`替换为镜像的用户名。


### Docker Desktop 配置

对于电脑的`Docker Desktop`用户，点击右上角`设置`，找到`Docker Engine`然后修改配置，修改后的示例：
```
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false,
  "registry-mirrors": [
    "https://docker.1ms.run",
    "https://hub.rat.dev",
    "https://docker.1panel.live"
  ]
}
```
然后点击右下角的`Apply & restart`保存并重启即可。


### 检查加速是否生效

查看docker系统信息 `docker info`，如果从结果中看到了你配置的加速地址，说明配置成功。

```console
Registry Mirrors:
 [...]
 https://docker.1panel.live
```


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
Environment="HTTP_PROXY=http://127.0.0.1:1080"
Environment="HTTPS_PROXY=http://127.0.0.1:1080"
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
国外服务器拉取镜像后打包压缩到本地，然后传输到国内服务器，`mysql`为例
#### A服务器压缩保存Docker镜像
```
docker save mysql > mysql.tar
```
#### 传送到B服务器
```
scp mysql.tar root@192.168.12.23:/home
```
然后输入B服务器root密码

#### B服务器加载Docker镜像

```
cd /home
```

```
docker load < mysql.tar
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
## Docker最新稳定加速源列表

提供者 | 镜像加速地址 | 说明 | 加速类型
--- | --- | --- | ---
[耗子面板](https://hub.rat.dev/) | `https://hub.rat.dev` | 无限制 | Docker Hub
[1panel](https://1panel.cn/docs/user_manual/containers/setting/) | `https://docker.1panel.live` | 无限制 | Docker Hub
[1panel](https://1panel.cn/docs/user_manual/containers/setting/) | `https://proxy.1panel.live` | 无限制 | Docker Hub
[rainbond](https://docker.rainbond.cc) | `https://docker.rainbond.cc` | cf-workers驱动 | Docker Hub
[毫秒镜像](https://docker.1ms.run) | `https://docker.1ms.run` | 国内CDN & 有黑名单 | Docker Hub
[DaoCloud](https://github.com/DaoCloud/public-image-mirror) | `https://docker.m.daocloud.io` |白名单和限流 | Docker Hub
[华为云](https://console.huaweicloud.com/swr/#/swr/dashboard) | `https://***.mirror.swr.myhuaweicloud.com` | 需登录分配 | Docker Hub
[南京大学](https://doc.nju.edu.cn/) | `https://ghcr.nju.edu.cn` | 国内CDN & ghcr加速 | ghcr.io
[飞牛NAS](https://www.fnnas.com/) | `https://docker.ketches.cn` | cf-workers驱动 | Docker Hub

