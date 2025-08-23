# NSSM 教程

**NSSM**（Non-Sucking Service Manager）用于把任意 exe 程序注册为 Windows 服务，后台运行，支持日志和自动重启。

---

## 下载 NSSM

1. 官方下载地址：https://nssm.cc/release/nssm-2.24.zip

> 建议把路径加入系统环境变量，这样命令行直接使用 `nssm`。

---

##  快速使用

假设你的 exe 为 `D:\main\main.exe`，服务名为 `123service`，启动后可以在`任务管理器`里面的`服务`查看

注册服务
```
nssm install 123service "D:\main\main.exe"
```
启动服务
```
nssm start 123service
```
停止服务
```
nssm stop 123service
```
卸载服务
```
nssm remove 123service confirm
```
- `confirm` 表示不弹窗确认，直接卸载

### 命令行帮助

```
:: 安装服务，服务名为 123service，启动程序是 D:\main\main.exe
nssm install 123service "D:\main\main.exe"

:: 设置启动参数，这里传入端口 8080
nssm set 123service AppParameters "--port=8080"

:: 设置程序工作目录，影响相对路径读取
nssm set 123service AppDirectory "D:\main"

:: 设置标准输出日志文件路径
nssm set 123service AppStdout "D:\main\123service.log"

:: 设置错误输出日志文件路径
nssm set 123service AppStderr "D:\main\123service_error.log"

:: 设置服务异常退出时自动重启
nssm set 123service Restart "yes"
```

---

## 常用配置说明

| 配置项           | 使用方式 | 说明 |
|-----------------|---------|------|
| AppParameters    | 命令行 `nssm set 123service AppParameters "--port=8080"` 或 GUI `Arguments` | 启动程序的命令行参数 |
| AppDirectory     | 命令行 `nssm set 123service AppDirectory "D:\main"` 或 GUI `Startup directory` | 程序工作目录 |
| AppStdout / AppStderr | 命令行 `nssm set 123service AppStdout "D:\main\123service.log"` 或 GUI `I/O` | 标准输出/错误输出日志文件路径 |
| Restart          | 命令行 `nssm set 123service Restart yes` 或 GUI `Shutdown` / `Restart` | 服务异常退出后是否自动重启 |

---

## 小提示

- **管理员权限**：安装/启动服务必须使用管理员权限
- **多参数**：用空格分开，多参数带空格的要用双引号

