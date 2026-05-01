# GitHub 또는 GitLab HTTPS 원격을 origin 으로 등록합니다. (My Machines worker 필수)
# 사용 전: 웹에서 빈 저장소를 하나 만든 뒤 URL을 복사하세요.
# 예: .\set-git-remote.ps1 -RemoteUrl "https://github.com/내아이디/new-project.git"

param(
    [Parameter(Mandatory = $true)]
    [string] $RemoteUrl
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$remotes = @(git remote 2>$null)
if ($remotes -contains "origin") {
    git remote set-url origin $RemoteUrl
    Write-Host "Updated origin URL." -ForegroundColor Green
} else {
    git remote add origin $RemoteUrl
    Write-Host "Added origin." -ForegroundColor Green
}

git remote -v
Write-Host ""
Write-Host "Next: agent worker debug (check warnings)" -ForegroundColor Cyan
Write-Host "Next: .\start-cursor-my-machine-worker.ps1" -ForegroundColor Cyan
