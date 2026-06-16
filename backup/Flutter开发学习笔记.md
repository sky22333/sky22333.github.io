# Flutter开发学习笔记

[鸿蒙Flutter](https://atomgit.com/CPF-Flutter/flutter_flutter)

# Windows 系统手动安装 Flutter 环境

## ✅ 一、准备条件

- [Git for Windows](https://git-scm.com/install/windows)
- [Android Studio](https://developer.android.com/studio)
- Flutter插件

#### 安卓sdk：
<img width="600" alt="Image" src="https://github.com/user-attachments/assets/e3707582-cc46-4877-9936-41d6cdf8b6a1" />

---

## ✅ 二、安装 Flutter SDK

### 1. 下载 Flutter

- 下载地址：https://docs.flutter.dev/install/manual

### 2. 解压

解压到路径，例如：
```
C:\flutter
```

### 3. 配置环境变量

将以下路径添加到系统环境变量 `Path` 中：
```powershell
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\flutter\bin", "Machine")
```

然后重启终端（powershell）。

## ✅ 三、验证安装
```
flutter doctor --android-licenses
```
一路输入`y`直到完成
```bash
flutter doctor -v
```

检查是否识别出所有组件并显示 ✅。

---

## ✅ 四、创建和构建项目

### 1. 创建多平台项目

```
flutter create myapp --org io.github.name --platforms android,ios,windows,macos,linux
```

### 2. 构建 APK

```bash
flutter build apk --release
```

输出文件路径：
```
build\app\outputs\flutter-apk\app-release.apk
```

## Flutter 常用命令

| 命令 | 说明 |
|--------|--------|
| flutter doctor -v | 检查 Flutter 开发环境 |
| flutter doctor --android-licenses | 接受 Android SDK 许可证 |
| flutter config --enable-windows-desktop | 启用 Windows 桌面支持 |
| flutter devices | 查看已连接设备 |
| flutter emulators | 查看模拟器列表 |
| flutter create myapp | 创建 Flutter 项目 |
| flutter create . | 为当前项目补充缺失平台目录 |
| flutter pub get | 下载项目依赖 |
| flutter pub upgrade | 升级依赖 |
| flutter pub outdated | 检查可升级依赖 |
| flutter clean | 清理构建缓存 |
| flutter run | 运行项目 |
| flutter run -d chrome | 在 Chrome 中运行 |
| flutter run -d windows | 在 Windows 桌面运行 |
| flutter run -d android | 在 Android 设备运行 |
| flutter run --release | Release 模式运行 |
| flutter build apk | 构建 APK |
| flutter build appbundle | 构建 AAB |
| flutter build windows | 构建 Windows 程序 |
| flutter build apk --release | 构建 Release APK |
| flutter build apk --split-per-abi | 按 ABI 拆分 APK |
| flutter test | 运行单元测试 |
| flutter analyze | 静态代码检查 |
| flutter format . | 格式化代码 |
| flutter --version | 查看版本 |

---

## Docker构建安卓项目参考
```
services:
  android:
    image: mingc/android-build-box
    container_name: android
    working_dir: /workspace
    stdin_open: true
    tty: true
    volumes:
      - .:/workspace
      - ./gradle-cache:/root/.gradle
      - ./flutter-cache:/root/.pub-cache
```
- 启动：
```
docker compose up -d
```
- 进入：
```
docker exec -it android bash
```
- 启动后先检查一下环境：
```
java -version
gradle -v
flutter --version
sdkmanager --version
adb version
```

- 然后随便执行：
```
# Kotlin
./gradlew assembleDebug
./gradlew assembleRelease

# Flutter
flutter doctor -v
flutter pub get
flutter build apk --release

# Android SDK
sdkmanager --list
adb version
```

---

## 🤖Go 项目生成 Android SDK (AAR) 并在 Kotlin 调用

1. 安装 gomobile
```
go install golang.org/x/mobile/cmd/gomobile@latest
go install golang.org/x/mobile/cmd/gobind@latest
gomobile init
```
2. 编写 Go 库

- 导出函数首字母必须大写
- 一般只需暴露 Go 项目的启动、停止、重启、日志、生命周期等函数接口即可
- gomobile 生成 Android 绑定后，业务端需要使用小驼峰命名调用
- 默认会生成一个“通用 AAR”，里面会包含所有 Go 支持的多种架构，可在业务端打包时拆分abi

## Flutter多平台架构思想

说明：Flutter 负责 UI 和业务编排，Platform Adapter 负责平台差异，Native Core 负责真正运行。

```
App 启动
↓
初始化依赖注入 / 配置 / 存储
↓
注册当前平台的 RuntimeService
↓
加载 Flutter UI
↓
用户操作 UI
↓
ViewModel 处理状态与交互
↓
UseCase / Repository 执行业务逻辑
↓
调用统一 RuntimeService 接口
↓
Platform Adapter 适配当前平台
↓
调用原生内核
   Android → AAR / .so
   Windows → exe
   Linux → binary
   macOS → binary / framework
   iOS → XCFramework / NetworkExtension
↓
内核回传状态 / 日志 / 错误 / 流量统计
↓
RuntimeService 统一转换为 Dart Model / Stream
↓
ViewModel 更新状态
↓
UI 自动刷新
```

### 最简结构
```
lib/
├── main.dart
├── ui/              # 页面、组件、ViewModel
├── domain/          # Model、UseCase、抽象接口
├── data/            # Repository、Service实现
└── platform/        # Android/Windows/Linux/macOS/iOS 适配器
```

## 后端封装统一接口
```
Android / iOS： Go 内核 SDK 化，做成 AAR / XCFramework 

Windows / macOS / Linux： Go 内核 daemon 化，本地 Socket IPC调用
```

然后`Flutter`层调用统一接口

---

代码结构示例
```
core/
├─ runtime/        # 纯 Go 核心逻辑：启动、停止、reload、状态、日志
├─ api/            # 统一接口定义
├─ mobile/         # Android/iOS 导出层：AAR / XCFramework
├─ daemon/         # Windows/macOS/Linux 守护进程入口
└─ ipc/            # 桌面 IPC：Named Pipe / Unix Socket
```

其他语言思路也一样