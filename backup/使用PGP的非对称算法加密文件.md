# PGP 加密使用

使用 `gpg` 工具在本地生成 PGP 密钥对，并进行文件的加密、解密、签名与验证操作。  
适用于 Linux、macOS、Windows（安装 Gpg4win）。

---

## 1. 检查 gpg 是否安装
```bash
gpg --version
```
如未安装：
- Linux: 使用 `apt install gnupg` 或 `yum install gnupg`
- macOS: 使用 `brew install gnupg`
- Windows: 安装 [Gpg4win](https://www.gpg4win.org/)

---

## 2. 生成密钥对
执行：
```bash
gpg --full-generate-key
```

交互流程：
1. **选择密钥类型**  
   选择 `1) RSA and RSA`（推荐）

2. **密钥长度**  
   输入 `4096`（推荐）

3. **有效期**  
   输入 `0` 表示永久有效

4. **用户信息**  
   - Real name: 可随意填写（如：localuser）
   - Email address: 可随意填写（如：local@secure）
   - Comment: 可留空

5. **设置私钥保护密码**
   - 可直接回车跳过

生成后可以查看：
```bash
gpg --list-keys
gpg --list-secret-keys
```

---

## 3. 导出密钥

### 导出公钥（可公开分发）
```bash
gpg --armor --export "localuser" > public.asc
```
生成的文件内容格式为：
```
-----BEGIN PGP PUBLIC KEY BLOCK-----
...
-----END PGP PUBLIC KEY BLOCK-----
```

### 导出私钥（务必妥善保管）
```bash
gpg --armor --export-secret-keys "localuser" > private.asc
```
生成的文件内容格式为：
```
-----BEGIN PGP PRIVATE KEY BLOCK-----
...
-----END PGP PRIVATE KEY BLOCK-----
```

---

## 4. 文件加密与解密

pgp是对整个文件字节流加密，支持所有文件类型，例如文档，二进制文件，音频视频等，不会破环原始文件。

这里以`demo.md`文件示例

### 加密文件（使用公钥）
```bash
gpg --encrypt --recipient "localuser" demo.md
```
生成 `demo.md.gpg`，只有对应私钥持有者能解密。

### 解密文件（使用私钥）
```bash
gpg --decrypt demo.md.gpg > demo.md
```

---

## 5. 签名与验证（可选）

### 给文件生成签名
```bash
gpg --detach-sign demo.md
```
会生成 `demo.md.sig`

### 验证文件签名
```bash
gpg --verify demo.md.sig demo.md
```

---

## 6. 常用配置优化（可选）

在 `~/.gnupg/gpg.conf` 中添加：
```
default-recipient-self
```
这样加密文件时可以直接：
```bash
gpg -e demo.md
```
无需每次输入接收人。

---

## 注意事项
- 公钥可公开，私钥必须保密
- 私钥建议离线备份（如 U 盘或密码管理工具）
- 加密后记得删除原始文件（如：`shred -u demo.md`）
- PGP 本质是 **非对称加密 + 对称加密混合**，兼顾安全性与性能
