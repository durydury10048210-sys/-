# My Machines 준비 한 번에: origin 설정 + worker 사전 점검
# 아래 중 하나로 GitHub HTTPS 주소를 넘기세요.
#   1) 환경 변수: $env:GITHUB_REPO_URL = "https://github.com/아이디/레포.git"
#   2) 파일: 이 폴더에 origin.url 을 만들고 URL 한 줄만 저장 (origin.url.example 참고)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot

$url = $env:GITHUB_REPO_URL
if (-not $url) {
    $originFile = Join-Path $root "origin.url"
    if (Test-Path $originFile) {
        $url = (Get-Content $originFile -Raw).Trim()
    }
}

if (-not $url -or $url -match "여기에GitHub아이디") {
    Write-Host "GitHub 저장소 HTTPS URL이 필요합니다." -ForegroundColor Yellow
    Write-Host '  방법 A: $env:GITHUB_REPO_URL = "https://github.com/아이디/레포.git"' -ForegroundColor Cyan
    Write-Host "  방법 B: 이 폴더에 origin.url 파일을 만들고 URL 한 줄만 적기 (origin.url.example 복사)" -ForegroundColor Cyan
    exit 1
}

Write-Host "origin 설정 중..." -ForegroundColor Cyan
& "$root\set-git-remote.ps1" -RemoteUrl $url

Write-Host "`nagent worker debug 실행..." -ForegroundColor Cyan
Set-Location $root
agent worker debug --worker-dir $root

Write-Host "`n다음: .\start-cursor-my-machine-worker.ps1 -RepoRoot `"$root`"" -ForegroundColor Green
