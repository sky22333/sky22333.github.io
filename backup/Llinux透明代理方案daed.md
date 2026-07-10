## DAE 透明代理

项目地址：https://github.com/daeuniverse/daed


## 部署文档

### 先开启IP转发
```
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1
```

### 安装docker
```
bash <(curl -sSL https://gitee.com/SuperManito/LinuxMirrors/raw/main/DockerInstallation.sh)
```
### 通过docker运行
```
docker run -d \
    --privileged \
    --network=host \
    --pid=host \
    --restart=always \
    -v /sys:/sys \
    -v /etc/daed:/etc/daed \
    --name=daed \
    ghcr.io/daeuniverse/daed:latest
```

然后通过`2023`端口访问面板

### 添加出站节点

<img width="1496" height="734" alt="Image" src="https://github.com/user-attachments/assets/787646a5-4970-4591-907f-85317461c6cf" />

---
---

<img width="658" height="230" alt="Image" src="https://github.com/user-attachments/assets/d3f007c4-b1ad-4ec8-b03a-ca9e41a51284" />

---
---

<img width="1409" height="1246" alt="Image" src="https://github.com/user-attachments/assets/99de7ad1-91bf-42ca-8a4b-ecf91dddc7cd" />

---
---
### 路由配置解释
<img width="867" height="697" alt="Image" src="https://github.com/user-attachments/assets/b2d995ce-628a-489e-bc23-307613cdda08" />