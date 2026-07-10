# Scoop 包管理器安装教程

 Windows 系统中安装 Scoop 包管理器，适合安装各种开发环境，以及版本管理。

## 步骤 1：启用 PowerShell 执行策略

在安装 Scoop 之前，您需要允许 PowerShell 执行本地脚本。

1.  PowerShell 执行以下命令：

```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

当提示时，输入 `A` 并按回车键确认。

## 步骤 2：安装 Scoop

现在您可以安装 Scoop 了。

1.  在同一个 PowerShell 窗口中，执行以下命令：

```
irm get.scoop.sh | iex
```
这将下载并执行 Scoop 的安装脚本。

2. 验证安装成功
```
scoop help
```


## 步骤 3：添加常用 bucket

为了能够安装更多软件，您可以添加一些常用的 bucket。

### Scoop 常用 Bucket 列表

也就是Github仓库上的软件清单列表

- main  
  地址：https://github.com/ScoopInstaller/Main  
  说明：官方主仓库，常用软件和基础工具，默认存在，无需配置。

- extras  
  地址：https://github.com/ScoopInstaller/Extras  
  说明：较多 GUI 软件、实用工具

- versions  
  地址：https://github.com/ScoopInstaller/Versions  
  说明：多版本软件（Node.js、Python、JDK 等）


更多包搜索：https://scoop.sh/


## 添加Github加速
```
scoop bucket add main https://gh-proxy.com/https://github.com/ScoopInstaller/Main.git

scoop bucket add versions https://gh-proxy.com/https://github.com/ScoopInstaller/Versions.git

scoop bucket add extras https://gh-proxy.com/https://github.com/ScoopInstaller/Extras.git
```
如果源已经存在则需要删除
```
scoop bucket rm main
```

查看所有bucket仓库
```
scoop bucket list
```

安装的软件存放目录
```
C:\Users\<你的用户名>\scoop\
```


## 常用命令示例

*   **搜索软件：** `scoop search 软件名`
*   **安装软件：** `scoop install 软件名`
*   **更新软件：** `scoop update 软件名`
*   **更新所有软件：** `scoop update *`
*   **卸载软件：** `scoop uninstall 软件名`
*   **查看安装缓存：** `scoop cache`
*   **清理所有缓存：** `scoop cache rm *`



1. 安装多个版本（示例）
```
scoop install nodejs   # 最新稳定版
scoop install nodejs20 # 20.x 版本
scoop install nodejs18 # 18.x 版本
```
2. 查看已安装版本
```
scoop list nodejs*
```
3. 使用 scoop reset 切换版本
```
scoop reset nodejs18
```
这条命令会把 node 命令指向 nodejs18 版本。

4. 验证当前版本
```
node -v
```