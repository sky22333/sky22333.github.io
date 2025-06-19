> [debian系统apt包搜索页面](https://www.debian.org/distrib/packages.zh-cn.html)

## Snap包管理器文档

```
# 更新软件包索引，安装 snapd
sudo apt update && sudo apt install snapd -y

# 设置 snapd 服务开机自启并启动服务
sudo systemctl enable snapd && sudo systemctl start snapd
```

### 说明：

1. **安装核心组件**：在安装其他软件包之前，建议先安装核心snap组件：

```
sudo snap install core
```

2. **在线搜索包**（搜索结果右上角可以选择版本）：https://snapcraft.io/store

3. **安装特定版本示例**
> `--classic`代表赋予最高权限
```
# 特定的版本的go
sudo snap install go --classic --channel=1.24/stable

# 最新版本的docker
sudo snap install docker --classic

# 最新版本的caddy
sudo snap install caddy --classic
```
4. **查看已安装的snap**：使用以下命令查看已安装的snap：
```
snap list
```

5. **更新snap**：更新所有已安装的snap：
```
sudo snap refresh
```

6. **删除snap**：删除某个snap：
 ```
 sudo snap remove 包名
 ```
 
 
---
## win系统的winget软件管理器文档

| 操作 | 命令 | 说明 |
|------|------|------|
| 安装 winget | 无需单独安装 | winget 已预装在 Windows 10 1709 及更高版本 |
| 更新 winget | `winget upgrade winget` | 更新 winget 自身 |
| 搜索软件 | `winget search <软件名>` | 搜索可用的软件包 |
| 安装软件 | `winget install <软件名>` | 安装指定的软件包 |
| 卸载软件 | `winget uninstall <软件名>` | 卸载指定的软件包 |
| 更新软件 | `winget upgrade <软件名>` | 更新指定的软件包 |
| 更新所有软件 | `winget upgrade --all` | 更新所有已安装的软件包 |
| 列出已安装软件 | `winget list` | 显示所有已安装的软件包 |

### 说明：

1. **安装 winget**：
   - 在较新的 Windows 10 和 Windows 11 系统中，winget 已经预装。
   - 如果系统中没有 winget，可以从 Microsoft Store 安装 "应用安装程序"（App Installer）。

2. **使用管理员权限**：
   - 某些操作可能需要管理员权限，可以在命令提示符或 PowerShell 中以管理员身份运行。

3. **指定版本**：
   - 安装特定版本的软件：`winget install <软件名> --version <版本号>`

4. **静默安装**：
   - 使用 `--silent` 参数进行静默安装：`winget install <软件名> --silent`

5. **接受协议**：
   - 自动接受许可协议：`winget install <软件名> --accept-package-agreements`

6. **查看软件信息**：
   - 获取软件详细信息：`winget show <软件名>`

7. **导出已安装软件列表**：
   - 导出为 JSON 文件：`winget export -o <文件名>.json`

8. **从文件安装软件**：
   - 从导出的文件安装软件：`winget import -i <文件名>.json`

9. **设置**：
   - 管理 winget 设置：`winget settings`

10. **源管理**：
    - 添加新的软件源：`winget source add <源名称> <源URL>`
    - 列出所有源：`winget source list`

注意：某些软件可能不在 winget 的默认源中。在这种情况下，可能需要添加额外的源或使用其他安装方法。





## 常用liunx系统Homebrew包管理器文档（不支持root用户）

```
# 1. 官方安装脚本
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. 配置环境变量（bash shell）
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# 3. 验证安装
brew --version
```

### 管理命令
```
# 搜索软件包
brew search 软件名

# 安装软件包
brew install 软件名

# 更新软件源
brew update

# 升级所有已安装的包
brew upgrade

# 查看已安装的软件包列表
brew list

# 卸载软件包
brew uninstall 软件名

# 清理无用文件和旧版本
brew cleanup

# 查看软件包信息
brew info 软件名
```

### 清华镜像源安装
```
# 安装前确保系统安装了git和curl
sudo apt install -y git curl

# 克隆清华镜像安装脚本并执行安装
git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
/bin/bash brew-install/install.sh
rm -rf brew-install

# 配置环境变量，写入 ~/.bashrc，方便每次shell启动自动生效
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc

# 设置 Homebrew 镜像环境变量，写入 ~/.bashrc
echo 'export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"' >> ~/.bashrc
echo 'export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"' >> ~/.bashrc
echo 'export HOMEBREW_INSTALL_FROM_API=1' >> ~/.bashrc

# 立刻生效 ~/.bashrc 配置
source ~/.bashrc

# 验证安装
brew --version
```
