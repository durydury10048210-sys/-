# GitHub 또는 GitLab HTTPS 원격을 origin 으로 등록합니다. (My Machines worker 필수)
# 사용 전: 웹에서 빈 저장소를 하나 만든 뒤 URL을 복사하세요.
# 예: .\set-git-remote.ps1 -RemoteUrl "https://github.com/내아이디/new-project.git"

param(
    [Parameter(Mandatory = $true)]
    [string] $RemoteUrl
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

if (git remote get-url origin 2>$null) {
    git remote set-url origin $RemoteUrl
    Write-Host "origin URL 을 갱신했습니다." -ForegroundColor Green
} else {
    git remote add origin $RemoteUrl
    Write-Host "origin 을 추가했습니다." -ForegroundColor Green
}

git remote -v
Write-Host "`n다음: agent worker debug  (경고 없는지 확인)" -ForegroundColor Cyan
Write-Host "다음: .\start-cursor-my-machine-worker.ps1" -ForegroundColor Cyan
