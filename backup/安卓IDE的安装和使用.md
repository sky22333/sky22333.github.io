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
│       └── gradle-wrapper.properties    ← Gradle 分发地址（构建工具下载）
├── settings.gradle                      ← Maven 仓库地址（用于第三方库下载）
├── build.gradle
└── app/
    └── build.gradle
```


### Gradle 分发地址

文件：`项目根目录/gradle/wrapper/gradle-wrapper.properties`

修改这一行：
```
distributionUrl=https\://mirrors.cloud.tencent.com/gradle/gradle-9.4.1-bin.zip
```

- 腾讯云	`https://mirrors.cloud.tencent.com/gradle/`
- 阿里云	`https://mirrors.aliyun.com/macports/distfiles/gradle/`
- 华为云	`https://mirrors.huaweicloud.com/gradle/`

### Maven 仓库地址

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
