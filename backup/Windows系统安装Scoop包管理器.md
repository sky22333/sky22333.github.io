# Scoop 包管理器安装教程

 Windows 系统中安装 Scoop 包管理器，并配置清华大学镜像源。适合安装各种开发环境，以及版本管理。

## 步骤 1：启用 PowerShell 执行策略

在安装 Scoop 之前，您需要允许 PowerShell 执行本地脚本。

1.  打开 PowerShell（以管理员身份运行）。
2.  执行以下命令：

    ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```

    当提示时，输入 `A` 并按回车键确认。

## 步骤 2：配置清华镜像源 (可选，推荐)

在安装 Scoop 之前配置镜像源，可以加速后续的下载。

1.  在 PowerShell 中执行以下命令，设置 Scoop 的下载源为清华大学镜像：

    ```powershell
    $env:SCOOP_REPO='https://mirrors.tuna.tsinghua.edu.cn/git/scoop/scoop.git'
    [Environment]::SetEnvironmentVariable('SCOOP_REPO', $env:SCOOP_REPO, 'User' )
    ```

    同时，为了加速软件下载，您也可以设置 `SCOOP_MIRRORS` 环境变量：

    ```powershell
    $env:SCOOP_MIRRORS='https://mirrors.tuna.tsinghua.edu.cn/scoop/'
    [Environment]::SetEnvironmentVariable('SCOOP_MIRRORS', $env:SCOOP_MIRRORS, 'User' )
    ```

    **注意：** 如果您已经安装了 Scoop，需要先卸载再重新安装，或者手动修改 Scoop 的配置文件来更改源。

## 步骤 3：安装 Scoop

现在您可以安装 Scoop 了。

1.  在同一个 PowerShell 窗口中，执行以下命令：

    ```powershell
    irm get.scoop.sh | iex
    ```

    这将下载并执行 Scoop 的安装脚本。

## 步骤 4：验证安装

安装完成后，您可以验证 Scoop 是否已成功安装。

1.  执行以下命令：

    ```powersorshell
    scoop help
    ```

    如果显示 Scoop 的帮助信息，则表示安装成功。

## 步骤 5：添加常用 bucket (可选)

为了能够安装更多软件，您可以添加一些常用的 bucket。

1.  执行以下命令添加 `extras` bucket：

    ```powershell
    scoop bucket add extras
    ```

## 常用命令示例

*   **搜索软件：** `scoop search <软件名>`
*   **安装软件：** `scoop install <软件名>`
*   **更新软件：** `scoop update <软件名>`
*   **更新所有软件：** `scoop update *`
*   **卸载软件：** `scoop uninstall <软件名>`



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