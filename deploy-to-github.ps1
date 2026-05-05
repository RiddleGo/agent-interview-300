# Deploy to GitHub: login, create repo if needed, push
$ErrorActionPreference = "Stop"
$localPath = "d:\vibecoding\agent-interview-300"
$gh = "C:\Program Files\GitHub CLI\gh.exe"

if (-not (Test-Path $gh)) {
    Write-Host "GitHub CLI not found."
    exit 1
}

if ($env:GH_TOKEN) {
    Write-Host "Using GH_TOKEN for API and push."
    $user = & $gh api user --jq .login
    $repo = "$user/agent-interview-300"
}
else {
    & $gh auth status 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Set GH_TOKEN or run: gh auth login --web"
        exit 1
    }
    Write-Host "Using existing gh login."
    $user = & $gh api user --jq .login
    $repo = "$user/agent-interview-300"
}
$repoUrl = "https://github.com/$repo.git"

$ErrorActionPreferenceSave = $ErrorActionPreference
$ErrorActionPreference = "Continue"
$null = & $gh repo view $repo 2>&1
$repoExists = ($LASTEXITCODE -eq 0)
$ErrorActionPreference = $ErrorActionPreferenceSave
if (-not $repoExists) {
    Write-Host "Creating repo $repo ..."
    $eap = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    $null = & $gh repo create $repo --public --description "Agent algo engineer interview 300" 2>&1
    $ErrorActionPreference = $eap
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Repo created."
    }
    else {
        Write-Host "Create skipped (token lacks create_repo). Push will work if repo exists."
    }
}
else {
    Write-Host "Repo exists, skip create."
}

Push-Location $localPath
try {
    $originBefore = git remote get-url origin 2>$null
    if ($env:GH_TOKEN) {
        git remote set-url origin "https://${user}:$env:GH_TOKEN@github.com/$repo.git"
    }
    else {
        & $gh auth setup-git 2>&1 | Out-Null
        git remote set-url origin $repoUrl
    }
    git push -u origin main
    if ($LASTEXITCODE -ne 0) { exit 1 }
    git remote set-url origin $originBefore
}
finally {
    Pop-Location
}

Write-Host "Done: https://github.com/$repo"
