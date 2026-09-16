# 一键发布：把本地改动同步到线上博客
# 用法：  .\publish.ps1 "修改说明"
# 不带说明则自动用当前时间作为提交信息
# 注意：代理端口若不是 7897，改下面 Push-Cmd 那一行

param(
  [string]$msg = ""
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host "==> 1/3 暂存所有改动" -ForegroundColor Cyan
git add -A

git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
  Write-Host "    没有新改动，跳过提交" -ForegroundColor Yellow
} else {
  if (-not $msg) {
    $msg = "update: " + (Get-Date -Format "yyyy-MM-dd HH:mm")
  }
  Write-Host "==> 2/3 提交：$msg" -ForegroundColor Cyan
  git commit -m $msg
}

Write-Host "==> 3/3 推送到 GitHub" -ForegroundColor Cyan
git -c http.proxy=http://127.0.0.1:7897 -c https.proxy=http://127.0.0.1:7897 push origin main

if ($LASTEXITCODE -eq 0) {
  Write-Host ""
  Write-Host "推送成功！Netlify 约 1 分钟后自动上线" -ForegroundColor Green
  Write-Host "线上地址：https://xdu-ai.netlify.app" -ForegroundColor Green
} else {
  Write-Host ""
  Write-Host "推送失败，请检查代理是否开启（端口 7897）" -ForegroundColor Red
}
