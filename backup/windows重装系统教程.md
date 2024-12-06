### windows重装系统之U盘引导

微软官网系统镜像下载：https://www.microsoft.com/zh-cn/software-download/windows11

1：下载`Windows 11 安装媒体`并执行程序写入到U盘

2：开机重复按`F2`或者`F12`或者`DELETE`键 进入BIOS界面

3：U盘引导，`UEFI` ——> 对应`GPT`磁盘分区格式

4：将U盘改为第一启动项，然后保存并重启

5：第一个分区默认就是C盘，建议分区200G：填`204806`MB，剩下的空间全给第二个分区即可


---
### windows重装系统之本地重装

1：微软官网下载`Windows 11 磁盘映像 (ISO)`

2：打开下载的文件点击`5etup`按提示重装即可

3：如果提示不满足要求，则在当前目录下执行`.\setup.exe /product server`命令即可跳过检测

4：回到安装页面后选择`继续执行受限设备`，创建账户时可以创建本地账户，名称最好用纯英文

---

### 安装界面绕过联网

1：安装界面按`Shift + F10`，打开命令窗口

2：执行`oobe\bypassnro`命令

3：执行命令后，系统会自动重启并跳过联网步骤，你可以继续安装并创建本地账户。


### 磁盘分区格式

如果磁盘分区格式不对，可以按`Shift + F10`，打开命令窗口，更改磁盘存储格式：
```
diskpart                     # 进入磁盘管理
list disk                    # 列出所有磁盘
select disk 0                # 选择要操作的磁盘，0 是磁盘编号
clean                        # 清除磁盘上的所有分区和数据
convert gpt                  # 将磁盘转换为 GPT 分区格式
exit                         # 退出
```

完成以上步骤后，硬盘已被格式化并转换为 **UEFI** 的 **GPT** 分区格式。然后刷新可以继续进行操作系统安装。


驱动器0，即表示第一块物理磁盘，该类型索引从0开始

分区1、2、3编号，即第一个分区……依次排列，分区从1开始索引编号。


### 报错解决

报错信息：这台电脑不符合安装此版本的 Windows 所需的最低系统要求。

绕过`TPM`检查命令：
```
reg load HKLM\temp C:\Windows\System32\Config\SOFTWARE
reg add "HKLM\temp\Microsoft\Windows\CurrentVersion\Setup" /v BypassTPMCheck /t REG_DWORD /d 1 /f
reg unload HKLM\temp
```
绕过`Secure Boot`检查命令：
```
reg load HKLM\temp C:\Windows\System32\Config\SOFTWARE
reg add "HKLM\temp\Microsoft\Windows\CurrentVersion\Setup" /v BypassSecureBootCheck /t REG_DWORD /d 1 /f
reg unload HKLM\temp
```


### 备注：

1：`win+R`运行`msinfo32`查看BIOS引导模式，或者`cmd`命令运行`bcdedit`查看引导模式，如果是`\WINDOWS\system32\winload.efi`则是`UEFI`引导

2：重装系统时有的机器需要进入`UEFI BIOS`固件设置，关闭安全启动`Secure Boot`选项（导致此原因可能是由于系统镜像不是官方来源）

3：如果启动时有多个系统，可以`win+R`运行`msconfig`查看`引导`选项卡，删掉不需要的。


### 系统激活代码

`PowerShell`脚本命令：
```
irm https://get.activated.win | iex
```

旧命令：`irm https://massgrave.dev/get | iex`

执行命令可以看到激活选项。选择 `[1] HWID` 用于 `Windows` 激活。选择 `[2] Ohook` 用于 `Office` 激活。


[开源地址](https://github.com/massgravel/Microsoft-Activation-Scripts)


### 新机软件安装

- v2rayN：https://github.com/2dust/v2rayN/releases/download/7.2.3/v2rayN-windows-64-SelfContained-With-Core.7z

- chorme浏览器：https://www.google.com/chrome/

- 7z解压工具：https://www.7-zip.org/

- vscode：https://code.visualstudio.com/

- 驱动总裁：https://www.sysceo.com/dc

- obs：https://obsproject.com/

- git：https://git-scm.com/downloads

- SSH工具：https://www.hostbuf.com/

- SSH工具：https://www.hexhub.cn/

- todesk远程工具：https://www.todesk.com/

- deskin远程工具：https://www.deskin.io/zht

- 图吧工具箱：https://www.tbtool.cn/

- 文件搜索：https://www.listary.net/

- 文件备份和同步：https://freefilesync.org/

- host管理工具：https://github.com/oldj/SwitchHosts

- 火绒安全软件：https://www.huorong.cn/

- 致美化：https://zhutix.com/

###  装机启动盘

- 微PE：https://www.wepe.com.cn/

- [ventoy](https://github.com/ventoy/Ventoy)：https://www.ventoy.net/ 支持存放多个系统

- [rufus](https://github.com/pbatard/rufus)：https://rufus.ie/zh/ 支持openwrt



### 官方Windows启动盘文件结构
```
/
├── boot/              <- 启动文件
├── efi/               <- UEFI 启动文件（适用于 UEFI 模式）
├── sources/           <- 安装源文件
│   ├── install.wim    <- 安装镜像文件
│   ├── boot.wim       <- 启动映像
├── autorun.inf        <- 自动运行配置文件
└── setup.exe          <- 安装程序
```
可以在启动盘中创建`driver`文件夹，驱动压缩包放至`driver`目录下，并将其解压，然后安装系统界面可以加载驱动程序，最好是将驱动解压缩并按硬件类别放置在子文件夹中。