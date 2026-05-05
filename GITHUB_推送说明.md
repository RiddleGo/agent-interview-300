# 推送到 GitHub 说明

## 一键全自动（创建仓库 + 推送）

在**能访问 GitHub 的环境**（本机若直连超时，可在家里/公司或开代理后再试）下：

1. **获取 Personal Access Token**  
   打开 https://github.com/settings/tokens → Generate new token (classic)，勾选 **repo**，生成后复制。

2. **在项目目录执行**（PowerShell）：
   ```powershell
   cd d:\vibecoding\agent-interview-300
   $env:GH_TOKEN = "粘贴你的 token"
   .\deploy-to-github.ps1
   ```
   脚本会自动：用 token 登录 gh → 若仓库不存在则创建 → 推送当前分支到 `dreamc60/agent-interview-300`。

**不设置 token 时**：若本机已运行过 `gh auth login --web` 并登录成功，也可直接运行 `.\deploy-to-github.ps1`，会使用已登录账号完成创建与推送。

---

## 国内镜像下载 GitHub CLI（若官方慢）

- 使用 gh-proxy 镜像：`https://gh-proxy.com/https://github.com/cli/cli/releases/download/v2.88.1/gh_2.88.1_windows_amd64.msi`
- 安装后新开终端执行 `gh --version` 验证。

## 当前已完成的配置

- 已生成 SSH 密钥：`C:\Users\Administrator\.ssh\id_ed25519`（私钥）与 `id_ed25519.pub`（公钥）
- 已把远程地址改为 SSH：`git@github.com:dreamc60/agent-interview-300.git`
- 已把 `github.com` 加入本机的 `known_hosts`，避免主机校验失败

## 你需要做的两步（约 1 分钟）

### 1. 把本机公钥加到 GitHub

1. 打开：<https://github.com/settings/ssh/new>
2. **Title** 随意填（例如：`vibecoding-PC`）
3. **Key** 里粘贴下面这一整行（本机公钥）：

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5HAUisoMyQ3mJYmlzkkNeB4wCtahEaQ9p3xFnLoGrO vibecoding-agent-interview-300
```

4. 点击 **Add SSH key** 保存。

### 2. 在 GitHub 上创建仓库（若尚未创建）

- 打开：<https://github.com/new?name=agent-interview-300>
- 仓库名保持 `agent-interview-300`，Public/Private 自选，**不要**勾选 “Add a README”
- 点击 **Create repository**

### 3. 在本机执行推送

在项目目录下打开 PowerShell 或 CMD，执行：

```powershell
cd d:\vibecoding\agent-interview-300
git push -u origin main
```

若一切正常，会提示 `Branch 'main' set up to track remote branch 'main' from 'origin'.` 以及对象上传进度。

---

## 若仍推送失败

- **Permission denied (publickey)**：说明公钥还未在 GitHub 添加成功，请再检查第 1 步。
- **repository not found**：说明仓库尚未创建或地址不对，请完成第 2 步并确认账号为 `dreamc60`、仓库名为 `agent-interview-300`。

完成上述步骤后，由你在本机执行一次 `git push -u origin main` 即可完成推送。
