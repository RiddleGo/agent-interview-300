# 推送到 GitHub 的步骤

本仓库已在本地完成 **git init、add、commit**。推送到 GitHub 需要你本机完成下面步骤。

## 1. 在 GitHub 上创建仓库（若尚未创建）

1. 登录 https://github.com  
2. 点击 **New repository**  
3. 仓库名建议：`agent-interview-300`  
4. 选择 **Public**，**不要**勾选 “Add a README”（本地已有）  
5. 创建后记下仓库地址，例如：`https://github.com/你的用户名/agent-interview-300.git`

## 2. 添加远程并推送（在本地执行）

在 **PowerShell** 或 **命令提示符** 中执行（请把 `你的用户名` 换成你的 GitHub 用户名）：

```powershell
# 确保 Git 在 PATH 中（若未配置可先执行）
$env:Path = "C:\Program Files\Git\bin;" + $env:Path

cd d:\vibecoding\agent-interview-300

# 添加远程（替换 你的用户名 为实际 GitHub 用户名）
git remote add origin https://github.com/你的用户名/agent-interview-300.git

# 推送（会提示输入凭据）
git push -u origin main
```

## 3. 认证方式（重要）

**GitHub 已不再支持用账号密码进行 Git 推送**，必须使用以下之一：

### 方式 A：Personal Access Token（推荐）

1. GitHub 网页 → 右上角头像 → **Settings** → 左侧 **Developer settings** → **Personal access tokens** → **Tokens (classic)**  
2. **Generate new token (classic)**，勾选权限至少包含 **repo**  
3. 生成后**复制 token**（只显示一次）  
4. 推送时：
   - 用户名：你的 GitHub 用户名  
   - 密码：**粘贴 token**（不要用登录密码）

### 方式 B：SSH 密钥

1. 本机生成 SSH 密钥：`ssh-keygen -t ed25519 -C "dreamc60@163.com"`  
2. 将 `~/.ssh/id_ed25519.pub` 内容添加到 GitHub → Settings → SSH and GPG keys  
3. 远程改用 SSH 地址再推送：
   ```powershell
   git remote set-url origin git@github.com:你的用户名/agent-interview-300.git
   git push -u origin main
   ```

## 4. 若远程已存在且与本地冲突

若 GitHub 上已有该仓库且含提交历史，可先拉再推：

```powershell
git pull origin main --rebase
git push -u origin main
```

---

完成推送后，可删除本说明文件（或保留作备忘）：`GITHUB_推送说明.md`
