## 各个主流编程语言的安装依赖和构建运行命令

> [!TIP]
> ## JavaScript（Node.js）💻

#### 基本代码结构
```
my-nodejs-project/
├── node_modules/
├── public/
│ └── index.html
├── src/
│ ├── index.js
│ └── App.js
├── .gitignore
├── package.json
└── webpack.config.js
```

#### 安装依赖
```
npm install
```
#### 构建打包
```
npm run build
```
#### 运行
```
npm start
```

> [!TIP]
> ## Python 💻

#### 基本代码结构
```
my-python-project/
├── .github/
├── myapp.py
├── config.py
├── requirements.txt
├── scripts/
│   └── run.sh
├── logs/
├── models/
├── services/
├── templates/
├── tests/
├── utils/
├── .dockerignore
├── .env.local
├── .gitignore
└── LICENSE
```

#### 安装依赖
```
pip install -r requirements.txt
```

#### 运行
```
python myapp.py
```

> [!TIP]
> ## Java (Spring Boot) 💻

#### 基本代码结构
```
my-springboot-project/
├── src/
│ ├── main/
│ │ ├── java/
│ │ │ └── com/
│ │ │ └── example/
│ │ │ └── MySpringBootApplication.java
│ │ └── resources/
│ │ ├── application.properties
│ │ └── static/
│ └── test/
│ └── java/
│ └── com/
│ └── example/
│ └── MySpringBootApplicationTests.java
├── .gitignore
├── build.gradle
└── pom.xml
```

#### 安装依赖和构建

#### Maven
```
mvn clean package
```
#### Gradle
```
./gradlew build
```
#### 运行构建出来的`jar`包（一般在项目的`target/you.jar`目录中）
```
java -jar target/you.jar
```

> [!TIP]
> ## Go 💻


#### 基本代码结构
```
my-go-project/
├── main.go
└── README.md
```

#### 无依赖管理工具的默认方式

#### 构建

```
go build -o app myapp
```
#### 运行构建出来的二进制文件（一般在当前目录下）
```
./myapp
```

> [!NOTE]
> ## 前端项目（React、Vue，等等） 💻

#### 基本代码结构
```
my-react-app/
├── node_modules/
├── public/
│ └── index.html
├── src/
│ ├── App.js
│ └── index.js
├── .gitignore
├── package.json
└── README.md
```


#### 安装依赖
```
npm install
```

#### 构建打包
```
npm run build
```

`React`项目默认会将构建后的文件输出到 `build` 目录，使用 `nginx`  `caddy`等等工具运行构建出来的静态文件。

`Vue`项目默认会将构建后的文件输出到 `dist` 目录，使用 `nginx`  `caddy`等等工具运行构建出来的静态文件。


## PHP 💻

基本代码机构
```
your-project/
├── index.php
├── config/
│   └── config.php
├── src/
│   ├── Controller/
│   ├── Model/
│   ├── View/
│   └── ...
├── public/
│   ├── css/
│   ├── js/
│   └── images/
├── vendor/
├── .env
├── .gitignore
├── composer.json
├── composer.lock
└── README.md
```

#### 安装依赖

如果项目使用`Composer`进行依赖管理，请在项目目录中运行`composer install`
```
cd /var/www/html/your-project
composer install
```

### 运行

安装`PHP`和`PHP-FPM` 并配置配置`nginx`，确保你的`public/index.php`是项目的入口文件，`nginx`运行目录一般都是这个目录。


> [!NOTE]
> ## Docker 💻

### 万物皆可`docker`，一般项目中有`Dockerfile`文件即可一键部署

 `Dockerfile`文件示例

```
# 使用官方的 Python 镜像作为基础镜像
FROM python:3.9-slim

# 设置工作目录
WORKDIR /app

# 复制 requirements.txt 文件并安装依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用源代码到工作目录
COPY src/ .

# 暴露应用运行的端口
EXPOSE 5000

# 运行应用
CMD ["python", "app.py"]
```


### 构建 Docker 镜像

```
docker build -t myimgname .
```

### 运行镜像

```
docker run -d -p 5000:5000 myimgname
```