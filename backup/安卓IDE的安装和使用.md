## 下载地址

- Android Studio：https://developer.android.com/studio?hl=zh-cn
- 汉化包：https://github.com/sollyu/AndroidStudioChineseLanguagePack

### 汉化

1. 安装汉化包  
   `右上角设置 ⚙️` → `Plugins…` → `Plugins页面的设置 ⚙️` → `Install Plugin from Disk…` → 选择汉化包 → OK → 重启 IDE

2. 切换语言和地区  
   `右上角设置 ⚙️` → `Settings…` → `Appearance & Behavior` → `System Settings` → `Language and Region` → 语言选`简体中文`、地区选`China Mainland`→ OK → 重启 IDE

---

![设置截图](https://github.com/user-attachments/assets/56cd04c1-12c2-403c-9880-61498cb3a0a6)



## 国内镜像
```
项目根目录/
├── gradle/
│   └── wrapper/
│       └── gradle-wrapper.properties    ← Gradle 分发地址（用于构建工具下载）
├── settings.gradle                      ← Maven 仓库地址（用于依赖库下载）
├── build.gradle
└── app/
    └── build.gradle
```


### Gradle 分发地址（用于构建工具下载）

文件：`项目根目录/gradle/wrapper/gradle-wrapper.properties`

修改这一行：
```
distributionUrl=https\://mirrors.cloud.tencent.com/gradle/gradle-9.4.1-bin.zip
```

- 腾讯云	`https://mirrors.cloud.tencent.com/gradle/`
- 阿里云	`https://mirrors.aliyun.com/macports/distfiles/gradle/`
- 华为云	`https://mirrors.huaweicloud.com/gradle/`

### Maven 仓库地址（用于依赖库下载）

文件：`项目根目录/settings.gradle.kts`

修改 `repositories` 配置块：

```
pluginManagement {
    repositories {
        maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        maven { url 'https://maven.aliyun.com/repository/public' }
        maven { url 'https://maven.aliyun.com/repository/google' }
        google()
        mavenCentral()
    }
}
```

- 阿里云 public	`https://maven.aliyun.com/repository/public`
- 阿里云 google	`https://maven.aliyun.com/repository/google`
- 阿里云 gradle-plugin	`https://maven.aliyun.com/repository/gradle-plugin`

### Maven 仓库配置代理（用于依赖库下载）

文件：`项目根目录/gradle.properties`

添加：
```
# HTTP 代理
systemProp.http.proxyHost=127.0.0.1
systemProp.http.proxyPort=10808

# HTTPS 代理
systemProp.https.proxyHost=127.0.0.1
systemProp.https.proxyPort=10808

# 不走代理的地址（可选）
systemProp.http.nonProxyHosts=*.aliyun.com|*.tencent.com
```

### 缓存清理

| 目的 | 操作 |
|---|---|
| 清 IDE 缓存 | File → Invalidate Caches （使缓存失效...）|
| 清 Gradle 依赖缓存 | `~/.gradle/caches/` |
| 清 Gradle 分发 | `~/.gradle/wrapper/dists/` |
| 清构建产物 | `./gradlew clean` 或删除 `app/build` 目录 |

 **`gradlew`命令临时变量设置**
```
$env:JAVA_HOME = "IDE安装目录\jbr"
```
---

| 命令 | 作用 |
|---|---|
| `.\gradlew clean` | 清理项目（删除 build 缓存） |
| `.\gradlew build` | 完整构建（编译 + 测试 + 打包） |
| `.\gradlew assemble` | 构建全部变体 |
| `.\gradlew assembleDebug` | 构建 Debug APK |
| `.\gradlew assembleRelease` | 构建 Release APK |
| `.\gradlew test` | 运行单元测试 |
| `.\gradlew check` | 执行全部检查任务 |
| `.\gradlew lint` | 执行代码检查（Lint） |
| `.\gradlew tasks` | 查看全部可用任务 |
| `.\gradlew dependencies` | 查看依赖树 |
| `.\gradlew build --stacktrace` | 输出错误堆栈 |
| `.\gradlew build --info` | 输出详细日志 |
| `.\gradlew build --debug` | 输出调试日志 |
| `.\gradlew build --stacktrace --info` | 完整诊断（排错推荐） |

---
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

