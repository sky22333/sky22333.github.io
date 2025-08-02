### 通过gitlab流水线自动备份仓库

会自动对比提交，如果没有新的提交，则不会备份，避免空提交导致意外错误

gitlab仓库根目录新建`.gitlab-ci.yml`文件，复制粘贴以下配置，使用方法见文件注释

```
# gitlab流水线 自动备份仓库配置
# 将配置保存为 .gitlab-ci.yml 文件，放在 GitLab 仓库根目录下。
# 进入项目 → 设置 → 仓库 → 受保护分支 → 选择Developers + Maintainers两个角色
# 进入项目 → 设置 → 访问令牌 → 角色选择 Developer → 权限勾选 write_repository
# 进入项目 → 构建 → 流水线计划 → 添加定时任务

# 必填变量：
# GITHUB_REPO_URL: 需要备份的目标仓库地址（如：https://github.com/username/repo.git）
# GITLAB_USER_NAME: Git提交的用户名
# GITLAB_USER_EMAIL: Git提交的邮箱
# PROJECT_TOKEN：gitlab访问令牌（进入项目 → 设置 → CI/CD → 变量）
# 可选变量：
# GITHUB_TOKEN: GitHub 个人访问令牌（用于私有仓库或提高 API 限制）

variables:
  GITHUB_REPO_URL: "https://github.com/username/repo.git"
  GITLAB_USER_NAME: "user123456"
  GITLAB_USER_EMAIL: "123456@admin.com"

  BACKUP_BRANCH: "main" # 上游仓库分支
  GIT_STRATEGY: none
  GIT_DEPTH: 0

stages:
  - backup

backup_github_repo:
  stage: backup
  image: alpine:latest
  
  rules:
    - if: '$CI_PIPELINE_SOURCE == "schedule" && ($CI_COMMIT_REF_NAME == "main" || $CI_COMMIT_REF_NAME == "master")'
      when: always
    - if: '$CI_PIPELINE_SOURCE == "web" && ($CI_COMMIT_REF_NAME == "main" || $CI_COMMIT_REF_NAME == "master")'
      when: manual
  
  timeout: 1h
  
  before_script:
    - echo "开始备份上游仓库..."
    - apk add --no-cache git curl jq bash
    - git config --global user.name "$GITLAB_USER_NAME"
    - git config --global user.email "$GITLAB_USER_EMAIL"
    - git config --global init.defaultBranch main
    
  script:
    - WORK_DIR="/tmp/github_backup_$(date +%s)"
    - mkdir -p "$WORK_DIR"
    - cd "$WORK_DIR"
    - echo "工作目录：$WORK_DIR"
    
    - echo "正在克隆上游仓库..."
    - |
      if [ -n "$GITHUB_TOKEN" ]; then
        GITHUB_CLONE_URL=$(echo "$GITHUB_REPO_URL" | sed "s|https://|https://$GITHUB_TOKEN@|")
      else
        GITHUB_CLONE_URL="$GITHUB_REPO_URL"
      fi
    
    - git clone --branch "$BACKUP_BRANCH" --single-branch "$GITHUB_CLONE_URL" github_source
    - cd github_source
    
    - |
      if [ ! -d ".git" ]; then
        echo "错误：上游仓库克隆失败！"
        exit 1
      fi
    
    - FILE_COUNT=$(find . -type f ! -path './.git/*' | wc -l)
    - |
      if [ "$FILE_COUNT" -eq 0 ]; then
        echo "警告：检测到空仓库，跳过备份"
        exit 0
      fi
    
    - echo "检测到 $FILE_COUNT 个文件，继续备份过程"
    
    - LATEST_COMMIT=$(git rev-parse HEAD)
    - COMMIT_MESSAGE=$(git log -1 --pretty=format:"%s")
    - COMMIT_DATE=$(git log -1 --pretty=format:"%cd" --date=iso)
    
    - echo "最新提交：$LATEST_COMMIT"
    - echo "提交信息：$COMMIT_MESSAGE"
    - echo "提交时间：$COMMIT_DATE"
    
    - cd "$WORK_DIR"
    - rm -rf github_source/.git
    
    - |
      git clone "https://project_${PROJECT_TOKEN}@$CI_SERVER_HOST/$CI_PROJECT_PATH.git" gitlab_backup
      cd gitlab_backup
      cp .gitlab-ci.yml ../gitlab-ci.yml.backup 2>/dev/null || true
      cp README* ../readme.backup 2>/dev/null || true
      find . -type f ! -name '.gitlab-ci.yml' ! -name 'README*' ! -path './.git/*' ! -name '.gitignore' -delete
      find . -type d -empty ! -path './.git*' -delete 2>/dev/null || true
      cp -r ../github_source/* ./ 2>/dev/null || true
      cp -r ../github_source/.[!.]* ./ 2>/dev/null || true
      cp ../gitlab-ci.yml.backup .gitlab-ci.yml 2>/dev/null || true
      if [ -f "../readme.backup" ] && [ ! -f "README.md" ] && [ ! -f "README.rst" ] && [ ! -f "README.txt" ]; then
        cp ../readme.backup README.md 2>/dev/null || true
      fi
    
    - git add .
    - |
      if git diff --staged --quiet; then
        echo "没有检测到变更，上游仓库没有新的更新，跳过提交"
        echo "最后检查的上游仓库提交：$LATEST_COMMIT"
        exit 0
      fi
    
    - echo "检测到文件变更，开始同步到 GitLab"
    
    - |
      BACKUP_MESSAGE="同步时间 $(date '+%Y-%m-%d %H:%M:%S')"
      BACKUP_MESSAGE="$BACKUP_MESSAGE

      同步信息：
      - 上游提交哈希：$LATEST_COMMIT
      - 提交信息：$COMMIT_MESSAGE  
      - 提交时间：$COMMIT_DATE
      - 同步时间：$(date -Iseconds)
      - 文件总数：$FILE_COUNT"
      git commit -m "$BACKUP_MESSAGE"
      git push "https://gitlab-ci-token:${PROJECT_TOKEN}@$CI_SERVER_HOST/$CI_PROJECT_PATH.git" main
    
    - echo "同步完成！GitLab 仓库已更新"
    
  after_script:
    - echo "清理临时文件..."
    - rm -rf /tmp/github_backup_* 2>/dev/null || true
```