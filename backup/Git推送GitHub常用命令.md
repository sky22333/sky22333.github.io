### 先在github创建一个仓库，然后本地CD到项目目录


### 初始化本地仓库
```
git init
```
### 创建并切换到`main`分支
```
git checkout -b main
```
### 确保本地分支是`main`
```
git checkout main
```
### 添加并提交新的更改
```
git add .
git commit -m "add"
```
### 关联远程仓库
```
git remote add origin https://github.com/your-username/your-repo.git
```
### 推送到仓库
```
git push origin main
```
`main`为分支名

输入用户名和key密钥即可推送完成
#### 操作完成后清除Git存储凭据
```
git config --global --unset credential.helper
```


### 配置提交用户
```
# 全局配置
git config --global user.name "admin123"
git config --global user.email "admin123@admin.com"

# 查看
git config --list
```

## 项目添加子模块
`ddns-go` 为例，项目根目录执行。
```
git submodule add https://github.com/jeessy2/ddns-go.git
git commit -m "添加子模块"
```
然后提交并推送即可

#### 更新所有子模块
项目根目录执行
```
git submodule update --remote --merge
```

#### 删除子模块
```
git submodule deinit -f ddns-go
git rm -f ddns-go
rm -rf .git/modules/ddns-go
rm -rf ddns-go
git commit -m "删除子模块"
```
#### 锁定子模块到某个提交
```
cd ddns-go
git checkout <commit-hash>
cd ..
git add ddns-go
git commit -m "锁定子模块版本"
```


## 🎈同步上游仓库某一个提交

#### 1：获取上游更新
```
git fetch upstream
```
> 合并上游所有更新`git merge upstream/main` main为本地分支

#### 2：确认上游仓库中是否包含目标提交
```
git branch -r --contains 提交哈希
```

#### 3：使用 -m 选项进行同步指定的提交
```
git cherry-pick -m 1 提交哈希
```
这里的`-m 1`表示选择合并的提交中的第一个父提交的更改。

如果不是合并的提交则去掉`-m 1`

多个`提交哈希`用空格隔开


#### 4：（可选）如果有冲突则找到冲突文件修改

标记所有冲突已解决
```
git add .
```
继续之前因冲突而中止的提交
```
git cherry-pick --continue
```
#### 5：然后就可以推送到远程仓库了
本地dev分支推送到远程dev分支
```
git push origin refs/heads/dev:refs/heads/dev
```

（可选）放弃提交
```
git cherry-pick --abort
```


## 🎈合并有冲突的请求

获取全部请求
```
git fetch origin 'refs/pull/*/head:refs/pull/origin/*'
```
切换到主分支
```
git checkout main
```
合并指定的请求（1为#后面的编号）
```
git merge refs/pull/origin/1
```
查看冲突
```
git status
```
> 将显示冲突的文件用`vim`打开，删除你不要的代码然后保存文件，或者`vscode`可视化选择。

标记所有冲突已解决
```
git add .
```
完成合并
```
git commit -m "合并分支1"
```
推送到`main`分支
```
git push origin main
```


## 🎈清除所有提交历史
```
# 删除 Git 版本管理
rm -rf .git

# 重新初始化 Git
git init

# 创建并切换分支（可忽略）
git checkout -b main

# 添加所有文件
git add .

# 提交所有文件
git commit -m "update"

# 重新关联仓库
git remote add origin https://github.com/your-username/your-repo.git

# 强制推送覆盖远程历史
git push --force origin main
```

## 🎈回滚
执行回滚操作后无法恢复

回滚到上一次提交
> 命令结尾的数字代表前几次
```
git reset --hard HEAD~1
```

强制推送
```
git push origin main --force
```

或者回滚到指定提交
> `6038e0a`是提交哈希值的前七位
```
git reset --hard 6038e0a
```

## win系统更改已登录的账户
```
控制面板 \ 用户帐户 \ 凭据管理器
```
选择`Windows凭据`，找到`github.com`域名相关的凭据，然后编辑或者删除。


## Git走代理
```
git config --global http.proxy socks5://127.0.0.1:10808
git config --global https.proxy socks5://127.0.0.1:10808
```

默认会配置在`C:\Users\用户名\.gitconfig`文件里