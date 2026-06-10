# 安卓Flutter开发学习笔记

# Windows 系统手动安装 Flutter 环境

## ✅ 一、准备条件

- [Git for Windows](https://git-scm.com/install/windows)
- [Android Studio](https://developer.android.com/studio)

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

```bash
flutter doctor -v
```

检查是否识别出所有组件并显示 ✅。

---

## ✅ 四、创建和构建项目

### 1. 创建项目

```bash
flutter create myapp
cd myapp
```

### 2. 构建 APK

```bash
flutter build apk --release
```

输出文件路径：
```
build\app\outputs\flutter-apk\app-release.apk
```


## Flutter 目录结构简介

```
my_flutter_app/                    # 项目根目录
├── android/                      # Android 平台相关代码（自动生成）
├── ios/                          # iOS 平台相关代码（自动生成）
├── lib/                          # Flutter 应用主代码目录
│   ├── main.dart                 # 入口文件，应用启动点
│   ├── src/                     # 业务代码目录（可按需自定义）
│   │   ├── widgets/             # 复用 Widget 组件
│   │   ├── pages/               # 页面级 Widget（Screen）
│   │   ├── models/              # 数据模型
│   │   ├── services/            # 业务逻辑或 API 请求
│   │   ├── utils/               # 工具类函数
│   │   └── providers/           # 状态管理（如 Provider、Riverpod）
├── assets/                       # 静态资源目录（图片、字体等）
│   ├── images/                   # 图片资源
│   ├── fonts/                    # 字体资源
│   └── translations/             # 国际化资源（如 ARB 文件）
├── test/                        # 单元测试代码
├── pubspec.yaml                 # Flutter 项目配置文件，管理依赖、资源
├── analysis_options.yaml        # Dart 分析规则配置（lint 规则）
├── .gitignore                   # Git 忽略文件
├── README.md                    # 项目说明文档
└── build/                       # 构建输出目录（自动生成）
```

---

## 关键说明

- `lib/main.dart`  
  应用程序入口，通常调用 `runApp()` 启动根组件。

- `lib/src/`  
  按功能模块划分代码，方便维护和扩展。现代项目推荐做清晰分层。

- `assets/`  
  存放静态资源，需在 `pubspec.yaml` 中声明才能使用。

- `pubspec.yaml`  
  核心配置文件，声明Flutter SDK版本、依赖包、资源路径、国际化等。

- `analysis_options.yaml`  
  代码风格和静态检查配置，确保代码质量。


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


# 现代 Android 高收益优化

尽量不动核心逻辑

* **Baseline Profile**

  * 优化手段：提前编译热路径代码，减少运行时 JIT
  * 预期效果：冷启动、首次打开、页面切换明显加快
  * 改动成本：低

* **R8 Full Mode**

  * 优化手段：代码缩减、优化、混淆、资源压缩
  * 预期效果：APK 更小、Dex 更少、启动更快
  * 改动成本：低

* **ABI Split**

  * 优化手段：按 CPU 架构拆分安装包，原生实现效果不大
  * 预期效果：安装包显著减小、Native 加载更快
  * 改动成本：低

* **延迟初始化**

  * 优化手段：非必要组件延后初始化
  * 预期效果：启动耗时明显下降、首屏更快
  * 改动成本：低~中

* **ProfileInstaller**

  * 优化手段：确保 Baseline Profile 在更多设备生效
  * 预期效果：提升 Profile 覆盖率与稳定性
  * 改动成本：极低

* **Native Strip**

  * 优化手段：移除 Native 调试符号和无用信息
  * 预期效果：SO 体积显著减小、包体下降
  * 改动成本：低

* **Startup Library**

  * 优化手段：管理初始化顺序与依赖关系
  * 预期效果：减少主线程阻塞、改善启动性能
  * 改动成本：低

* **Resource Shrinking**

  * 优化手段：移除未使用资源
  * 预期效果：APK 更小、资源加载更轻
  * 改动成本：低

