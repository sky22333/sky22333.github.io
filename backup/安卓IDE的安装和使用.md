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
| `.\gradlew connectedDebugAndroidTest` | 运行设备测试（需连接设备） |
| `.\gradlew check` | 执行全部检查任务 |
| `.\gradlew installDebug` | 安装 Debug 到设备 |
| `.\gradlew uninstallDebug` | 卸载 Debug 应用 |
| `.\gradlew lint` | 执行代码检查（Lint） |
| `.\gradlew signingReport` | 查看签名信息（SHA1 / SHA256） |
| `.\gradlew tasks` | 查看全部可用任务 |
| `.\gradlew dependencies` | 查看依赖树 |
| `.\gradlew properties` | 查看 Gradle 属性 |
| `.\gradlew --version` | 查看 Gradle / Java 环境 |
| `.\gradlew build --stacktrace` | 输出错误堆栈 |
| `.\gradlew build --info` | 输出详细日志 |
| `.\gradlew build --debug` | 输出调试日志 |
| `.\gradlew build --stacktrace --info` | 完整诊断（排错推荐） |
| `.\gradlew --stop` | 停止 Gradle 后台进程 |
| `.\gradlew :app:assembleDebug` | 构建指定模块 |
| `.\gradlew :app:testDebugUnitTest` | 测试指定模块 |
| `.\gradlew ^<br>:core-runtime:test ^<br>:core-data:test ^<br>:app:assembleDebug` | 构建多个模块 |