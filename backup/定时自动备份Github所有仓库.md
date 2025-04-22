- 利用`gitlab`的CI CD定时自动备份`Github`所有仓库到`gitlab`
- 防止Github账号被封禁或者丢失访问权限等问题



<html>
<body>
<!--StartFragment--><h3 class="text-lg font-bold text-text-100 mt-1 -mb-1.5" level="3">1. 必要的准备工作</h3>
<h4 class="text-base font-bold text-text-100 mt-1" level="4">创建必要的访问令牌和SSH密钥</h4>
<ol class="[&amp;:not(:last-child)_ul]:pb-1 [&amp;:not(:last-child)_ol]:pb-1 list-decimal space-y-1.5 pl-7" depth="0">
<li class="whitespace-normal break-words" index="0"><strong>GitHub Token</strong>：
<ul class="[&amp;:not(:last-child)_ul]:pb-1 [&amp;:not(:last-child)_ol]:pb-1 list-disc space-y-1.5 pl-7" depth="1">
<li class="whitespace-normal break-words" index="0">创建一个具有 <code class="bg-text-200/5 border border-0.5 border-border-300 text-danger-000 whitespace-pre-wrap rounded-[0.4rem] px-1 py-px text-[0.9rem]">repo</code> 权限的个人访问令牌（PAT）</li>
<li class="whitespace-normal break-words" index="1">访问：GitHub → Settings → Developer settings → Personal access tokens</li>
</ul>
</li>
<li class="whitespace-normal break-words" index="1"><strong>GitHub SSH 密钥</strong>：
<ul class="[&amp;:not(:last-child)_ul]:pb-1 [&amp;:not(:last-child)_ol]:pb-1 list-disc space-y-1.5 pl-7" depth="1">
<li class="whitespace-normal break-words" index="0">创建一个SSH密钥对用于访问GitHub仓库</li>
<li class="whitespace-normal break-words" index="1">运行：<code class="bg-text-200/5 border border-0.5 border-border-300 text-danger-000 whitespace-pre-wrap rounded-[0.4rem] px-1 py-px text-[0.9rem]">ssh-keygen -t rsa -b 4096 -f github_id_rsa</code></li>
<li class="whitespace-normal break-words" index="2">将公钥添加到GitHub账户</li>
</ul>
</li>
<li class="whitespace-normal break-words" index="2"><strong>GitLab API Token</strong>：
<ul class="[&amp;:not(:last-child)_ul]:pb-1 [&amp;:not(:last-child)_ol]:pb-1 list-disc space-y-1.5 pl-7" depth="1">
<li class="whitespace-normal break-words" index="0">创建一个具有API访问权限的GitLab个人访问令牌</li>
<li class="whitespace-normal break-words" index="1">访问：GitLab → Preferences → Access Tokens</li>
</ul>
</li>
<li class="whitespace-normal break-words" index="3"><strong>GitLab SSH 密钥</strong>：
<ul class="[&amp;:not(:last-child)_ul]:pb-1 [&amp;:not(:last-child)_ol]:pb-1 list-disc space-y-1.5 pl-7" depth="1">
<li class="whitespace-normal break-words" index="0">创建一个SSH密钥对用于访问GitLab仓库</li>
<li class="whitespace-normal break-words" index="1">运行：<code class="bg-text-200/5 border border-0.5 border-border-300 text-danger-000 whitespace-pre-wrap rounded-[0.4rem] px-1 py-px text-[0.9rem]">ssh-keygen -t rsa -b 4096 -f gitlab_id_rsa</code></li>
<li class="whitespace-normal break-words" index="2">将公钥添加到GitLab账户</li>
</ul>
</li>
</ol>
<h3 class="text-lg font-bold text-text-100 mt-1 -mb-1.5" level="3">2. 在GitLab中设置CI/CD变量</h3>
<p class="whitespace-pre-wrap break-words">在GitLab项目中，设置以下CI/CD变量：</p>
<ul class="[&amp;:not(:last-child)_ul]:pb-1 [&amp;:not(:last-child)_ol]:pb-1 list-disc space-y-1.5 pl-7" depth="0">
<li class="whitespace-normal break-words" index="0">访问 Settings → CI/CD → Variables，添加以下变量：</li>
</ul>

变量名 | 描述 | 是否受保护
-- | -- | --
GITHUB_TOKEN | GitHub个人访问令牌 | 是
GITHUB_SSH_PRIVATE_KEY | GitHub SSH私钥内容 | 是
GITLAB_API_TOKEN | GitLab API访问令牌 | 是
GITLAB_SSH_PRIVATE_KEY | GitLab SSH私钥内容 | 是
GITLAB_USER_NAME | 用于提交的Git用户名 | 否
GITLAB_USER_EMAIL | 用于提交的Git邮箱 | 否
</pre>
<h3 class="text-lg font-bold text-text-100 mt-1 -mb-1.5" level="3">3. 设置定时任务</h3>
<ol class="[&amp;:not(:last-child)_ul]:pb-1 [&amp;:not(:last-child)_ol]:pb-1 list-decimal space-y-1.5 pl-7" depth="0">
<li class="whitespace-normal break-words" index="0">在GitLab项目中，前往 CI/CD → Schedules</li>
<li class="whitespace-normal break-words" index="1">点击 "New schedule" 按钮</li>
<li class="whitespace-normal break-words" index="2">设置如下参数：
<ul class="[&amp;:not(:last-child)_ul]:pb-1 [&amp;:not(:last-child)_ol]:pb-1 list-disc space-y-1.5 pl-7" depth="1">
<li class="whitespace-normal break-words" index="0"><strong>描述</strong>：GitHub仓库每周镜像</li>
<li class="whitespace-normal break-words" index="1"><strong>间隔模式</strong>：自定义，设置为 <code class="bg-text-200/5 border border-0.5 border-border-300 text-danger-000 whitespace-pre-wrap rounded-[0.4rem] px-1 py-px text-[0.9rem]">0 2 * * 1</code>（每周一凌晨2点）</li>
<li class="whitespace-normal break-words" index="2"><strong>目标分支</strong>：<code class="bg-text-200/5 border border-0.5 border-border-300 text-danger-000 whitespace-pre-wrap rounded-[0.4rem] px-1 py-px text-[0.9rem]">main</code> 或 <code class="bg-text-200/5 border border-0.5 border-border-300 text-danger-000 whitespace-pre-wrap rounded-[0.4rem] px-1 py-px text-[0.9rem]">master</code>（取决于你的默认分支）</li>
<li class="whitespace-normal break-words" index="3"><strong>启用</strong>：确保勾选了这一选项</li>
</ul>
</li>
</ol>
<h3 class="text-lg font-bold text-text-100 mt-1 -mb-1.5" level="3">4. 将配置文件添加到GitLab项目</h3>
<p class="whitespace-pre-wrap break-words">将以下<code class="bg-text-200/5 border border-0.5 border-border-300 text-danger-000 whitespace-pre-wrap rounded-[0.4rem] px-1 py-px text-[0.9rem]">.gitlab-ci.yml</code>文件添加到你的GitLab项目中。你可以通过Web界面或者Git命令行来完成这一步。</p><!--EndFragment-->
</body>
</html>


`gitlab`的CI CD配置示例：
```
# .gitlab-ci.yml
# GitLab CI/CD 配置文件，用于每周一自动将 GitHub 仓库镜像到 GitLab

stages:
  - mirror

variables:
  # 设置时区为亚洲/上海
  TZ: "Asia/Shanghai"
  # 设置 Git 拉取深度，0表示完整克隆（包含所有历史记录）
  GIT_DEPTH: 0
  # 设置 Git 策略为克隆，确保每次作业都有一个干净的工作区
  GIT_STRATEGY: clone
  # 超时设置，避免长时间运行
  MIRROR_TIMEOUT: 3600

mirror_github_repos:
  stage: mirror
  image: alpine:latest
  # 仅在每周一运行
  only:
    - schedules
  # 设置最大运行时间为1小时
  timeout: 1h
  # 设置作业可重试次数和间隔
  retry:
    max: 2
    when:
      - runner_system_failure
      - stuck_or_timeout_failure
  
  before_script:
    # 安装所需的工具
    - apk update
    - apk add --no-cache git curl jq openssh-client bash
    # 配置 Git
    - git config --global user.name "${GITLAB_USER_NAME}"
    - git config --global user.email "${GITLAB_USER_EMAIL}"
    # 设置 SSH 配置
    - mkdir -p ~/.ssh
    - echo "${GITHUB_SSH_PRIVATE_KEY}" > ~/.ssh/id_rsa_github
    - echo "${GITLAB_SSH_PRIVATE_KEY}" > ~/.ssh/id_rsa_gitlab
    - chmod 600 ~/.ssh/id_rsa_github ~/.ssh/id_rsa_gitlab
    - ssh-keyscan github.com >> ~/.ssh/known_hosts
    - ssh-keyscan ${CI_SERVER_HOST} >> ~/.ssh/known_hosts
    # 创建SSH配置文件以区分不同主机的密钥
    - |
      cat > ~/.ssh/config << EOF
      Host github.com
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_rsa_github
        IdentitiesOnly yes
        
      Host ${CI_SERVER_HOST}
        HostName ${CI_SERVER_HOST}
        User git
        IdentityFile ~/.ssh/id_rsa_gitlab
        IdentitiesOnly yes
      EOF
    - chmod 600 ~/.ssh/config
    # 创建工作目录
    - mkdir -p /tmp/mirror_workspace
    - cd /tmp/mirror_workspace

  script:
    - |
      # 创建日志文件
      LOG_FILE="/tmp/mirror_log_$(date +%Y%m%d).log"
      echo "开始镜像任务: $(date)" > $LOG_FILE
      
      # 获取所有GitHub仓库（包括私有仓库）
      echo "正在获取GitHub仓库列表..." | tee -a $LOG_FILE
      REPOS=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" "https://api.github.com/user/repos?per_page=100" | jq -r '.[] | .ssh_url + "," + .name')
      if [ -z "$REPOS" ]; then
        echo "错误: 无法获取GitHub仓库列表，请检查TOKEN权限" | tee -a $LOG_FILE
        exit 1
      fi
      
      # 计数器
      TOTAL_REPOS=$(echo "$REPOS" | wc -l)
      SUCCESS_COUNT=0
      FAILED_COUNT=0
      
      echo "发现 $TOTAL_REPOS 个仓库需要镜像" | tee -a $LOG_FILE
      
      # 处理每个仓库
      echo "$REPOS" | while IFS="," read -r REPO_URL REPO_NAME; do
        echo "============================================" | tee -a $LOG_FILE
        echo "开始处理仓库: $REPO_NAME" | tee -a $LOG_FILE
        
        # 创建GitLab仓库URL
        GITLAB_URL="git@${CI_SERVER_HOST}:${CI_PROJECT_NAMESPACE}/${REPO_NAME}.git"
        
        # 检查GitLab上是否已存在该仓库
        REPO_EXISTS=$(curl -s -H "PRIVATE-TOKEN: ${GITLAB_API_TOKEN}" "${CI_API_V4_URL}/projects/${CI_PROJECT_NAMESPACE}%2F${REPO_NAME}" | jq -r '.id')
        
        # 如果仓库不存在，则创建
        if [ "$REPO_EXISTS" == "null" ]; then
          echo "GitLab上不存在该仓库，正在创建: $REPO_NAME" | tee -a $LOG_FILE
          CREATE_RESPONSE=$(curl -s -H "PRIVATE-TOKEN: ${GITLAB_API_TOKEN}" \
            -X POST "${CI_API_V4_URL}/projects" \
            -d "name=${REPO_NAME}&visibility=private")
          
          # 验证创建是否成功
          NEW_REPO_ID=$(echo $CREATE_RESPONSE | jq -r '.id')
          if [ "$NEW_REPO_ID" == "null" ]; then
            echo "创建仓库失败: $REPO_NAME, 错误: $(echo $CREATE_RESPONSE | jq -r '.message')" | tee -a $LOG_FILE
            FAILED_COUNT=$((FAILED_COUNT + 1))
            continue
          fi
          echo "仓库创建成功，ID: $NEW_REPO_ID" | tee -a $LOG_FILE
        else
          echo "GitLab上已存在该仓库，将进行更新: $REPO_NAME" | tee -a $LOG_FILE
        fi
        
        # 克隆GitHub仓库
        echo "正在克隆GitHub仓库: $REPO_NAME..." | tee -a $LOG_FILE
        if ! git clone --mirror "$REPO_URL" "/tmp/mirror_workspace/$REPO_NAME"; then
          echo "克隆失败: $REPO_NAME" | tee -a $LOG_FILE
          FAILED_COUNT=$((FAILED_COUNT + 1))
          continue
        fi
        
        # 进入仓库目录
        cd "/tmp/mirror_workspace/$REPO_NAME"
        
        # 推送到GitLab
        echo "正在推送到GitLab: $REPO_NAME..." | tee -a $LOG_FILE
        git push --mirror "$GITLAB_URL" || {
          # 处理冲突
          echo "推送失败，可能存在冲突，尝试强制更新..." | tee -a $LOG_FILE
          git fetch --prune origin
          git update-ref -d refs/remotes/origin/HEAD 2>/dev/null || true
          
          # 第二次尝试推送
          if ! git push --force --mirror "$GITLAB_URL"; then
            echo "推送失败: $REPO_NAME" | tee -a $LOG_FILE
            FAILED_COUNT=$((FAILED_COUNT + 1))
            cd ..
            continue
          fi
        }
        
        # 确保仓库是私有的
        echo "确保GitLab仓库是私有的..." | tee -a $LOG_FILE
        curl -s -H "PRIVATE-TOKEN: ${GITLAB_API_TOKEN}" \
          -X PUT "${CI_API_V4_URL}/projects/${CI_PROJECT_NAMESPACE}%2F${REPO_NAME}" \
          -d "visibility=private" > /dev/null
        
        echo "成功镜像仓库: $REPO_NAME" | tee -a $LOG_FILE
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        
        # 清理
        cd ..
        rm -rf "/tmp/mirror_workspace/$REPO_NAME"
      done
      
      # 统计并记录结果
      echo "============================================" | tee -a $LOG_FILE
      echo "镜像任务完成: $(date)" | tee -a $LOG_FILE
      echo "总仓库数: $TOTAL_REPOS" | tee -a $LOG_FILE
      echo "成功: $SUCCESS_COUNT" | tee -a $LOG_FILE
      echo "失败: $FAILED_COUNT" | tee -a $LOG_FILE
      
      # 如果有失败的仓库，退出码不为0
      if [ $FAILED_COUNT -gt 0 ]; then
        echo "有 $FAILED_COUNT 个仓库镜像失败，请查看日志" | tee -a $LOG_FILE
        exit 1
      fi

  after_script:
    # 在任务完成后上传日志文件作为构建工件
    - |
      if [ -f "/tmp/mirror_log_$(date +%Y%m%d).log" ]; then
        mkdir -p mirror_logs
        cp "/tmp/mirror_log_$(date +%Y%m%d).log" mirror_logs/
        echo "日志文件已保存，可在作业工件中查看"
      fi

  # 保存日志文件
  artifacts:
    paths:
      - mirror_logs/
    expire_in: 1 week
    when: always
```