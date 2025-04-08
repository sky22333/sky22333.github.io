### `Github-Actions`默认用户变量`GITHUB_TOKEN`的提权语法

-  众所周知工作流默认用户变量`GITHUB_TOKEN`由`GitHub`自动生成并提供的，不需要你手动创建，非常方便。
-  但是默认权限很低，这意味着你无法使用它执行超出工作流范围的操作。
-  好在可以通过`permissions`来修改`GITHUB_TOKEN`的权限范围，比如允许它访问更多的仓库数据或执行更高级的操作。

> 开启工作流的仓库文件路径`.github/workflows/xxxxx.yml`

| 资源类别           | 类别说明              | 权限   | 权限说明                                                                                          | 配置语法示例                                                                                       |
|--------------------|-----------------------|------------|-----------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| **contents**        | 仓库内容（代码、文件）  | `read`     | 只读权限，允许读取仓库内容，如查看文件和提交历史。                                               | `contents: read`                                                                                 |
|                    |                       | `write`    | 写权限，允许修改、推送、更改文件。                                                               | `contents: write`                                                                                |
|                    |                       | `delete`   | 删除权限，允许删除仓库内容。                                                                     | `contents: delete`                                                                               |
| **packages**        | GitHub 容器（GHCR）     | `read`     | 只读权限，允许读取容器镜像或包。                                                                  | `packages: read`                                                                                 |
|                    |                       | `write`    | 写权限，允许推送容器镜像或其他包。                                                                | `packages: write`                                                                                |
|                    |                       | `delete`   | 删除权限，允许删除 GitHub 容器中的镜像或包。                                                      | `packages: delete`                                                                               |
| **actions**         | GitHub Actions         | `read`     | 只读权限，允许查看工作流和运行状态。                                                              | `actions: read`                                                                                  |
|                    |                       | `write`    | 写权限，允许触发、管理和更新工作流的状态。                                                        | `actions: write`                                                                                 |
|                    |                       | `delete`   | 删除权限，允许删除工作流运行历史记录。                                                             | `actions: delete`                                                                                |
| **issues**          | 问题（Issue）           | `read`     | 只读权限，允许查看、评论问题。                                                                   | `issues: read`                                                                                   |
|                    |                       | `write`    | 写权限，允许创建、编辑、关闭问题。                                                               | `issues: write`                                                                                  |
| **pull-requests**   | 拉取请求（PR）          | `read`     | 只读权限，允许查看和评论 PR。                                                                   | `pull-requests: read`                                                                             |
|                    |                       | `write`    | 写权限，允许创建、更新、合并拉取请求。                                                           | `pull-requests: write`                                                                            |
| **workflows**       | 工作流（workflow）      | `read`     | 只读权限，允许查看工作流定义和状态。                                                             | `workflows: read`                                                                                 |
|                    |                       | `write`    | 写权限，允许触发、管理、更新工作流。                                                             | `workflows: write`                                                                                |
| **commit-status**   | 提交状态                | `read`     | 只读权限，允许查看提交的状态。                                                                   | `commit-status: read`                                                                             |
|                    |                       | `write`    | 写权限，允许设置提交的状态。                                                                     | `commit-status: write`                                                                            |
| **deployments**     | 部署操作                | `read`     | 只读权限，允许查看部署的状态。                                                                   | `deployments: read`                                                                               |
|                    |                       | `write`    | 写权限，允许触发部署操作。                                                                       | `deployments: write`                                                                              |

### 示例：完整的权限配置

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: write    # 允许推送代码，修改仓库文件，也包括操作标签和Release
      packages: write    # 允许推送 Docker 镜像到 GitHub 容器注册表
      actions: read      # 允许查看工作流执行状态和日志
      workflows: write   # 允许触发和管理工作流
      issues: write      # 允许创建、编辑和关闭问题
      pull-requests: write # 允许创建和合并拉取请求