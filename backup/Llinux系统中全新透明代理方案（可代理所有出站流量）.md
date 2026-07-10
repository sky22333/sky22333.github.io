## DAE 透明代理 - 完美替代v2rayA

项目地址：https://github.com/daeuniverse/daed

## 1. 核心优势

- **内核级处理**：通过 eBPF 在内核早期阶段直接分流流量，无需全部经过用户态代理。
- **高性能**：CPU 占用低，延迟小，尤其在高并发或大量容器场景下优势明显。
- **全局透明代理**：Docker 容器或其他应用无需额外配置即可走代理。
- **精准分流**：可按进程名、容器名或 cgroup 分流，只代理需要的流量，其他流量直连。
- **管理便捷**：配合 daed 可视化管理界面，实时监控流量和规则。

---

## 2. 与 TUN 模式对比

| 特性 | TUN 模式（Clash / sing-box） | DAE（eBPF 内核代理） |
|------|---------------------------|--------------------|
| 流量路径 | 所有流量进入用户态处理 | 内核早期分流，仅必要流量进入用户态 |
| 性能 | 较低，高负载 CPU 占用明显 | 高性能，几乎无损 |
| 配置需求 | 需要应用或容器设置代理 | 应用无感知，容器自动走代理 |
| 分流精度 | 基于 IP / 端口 | 支持进程名 / 容器 / cgroup |
| 系统兼容 | 跨平台 | 仅 Linux，依赖内核版本 ≥ 5.x |

---

## 3. 与传统 iptables 透明代理对比

| 特性 | iptables / tproxy | DAE（eBPF 内核代理） |
|------|----------------|--------------------|
| 流量处理 | 内核中较晚阶段处理，需要转发到用户态 | 内核早期直接分流，性能更高 |
| 管理复杂度 | 规则复杂，易错 | 配合 daed 可视化管理，规则直观 |
| 性能 | 中等，用户态中转依然存在 | 高性能，CPU 开销低 |
| 精准分流 | 基于 IP/端口或策略 | 支持进程名 / 容器 / cgroup，按需代理 |

---

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