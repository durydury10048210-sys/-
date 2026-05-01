# Cursor My Machines: PC에 worker를 띄워 모바일(cursor.com/agents)에서 이 PC 환경으로 작업합니다.
# 사전: 유료 플랜에서 Cloud Agents 사용 가능, GitHub/GitLab 원격이 있는 Git 클론
# 문서: https://cursor.com/docs/cloud-agent/my-machines
#
# 사용 예:
#   .\start-cursor-my-machine-worker.ps1 -RepoRoot "D:\dev\my-app"
#   $env:CURSOR_WORKER_DIR = "D:\dev\my-app"; .\start-cursor-my-machine-worker.ps1

param(
    [string] $RepoRoot = ""
)

$ErrorActionPreference = "Stop"

if (-not $RepoRoot) {
    if ($env:CURSOR_WORKER_DIR) { $RepoRoot = $env:CURSOR_WORKER_DIR }
    else { $RepoRoot = (Get-Location).Path }
}

$gitDir = Join-Path $RepoRoot ".git"
if (-not (Test-Path $gitDir)) {
    Write-Host "Git 저장소가 아닙니다. GitHub/GitLab에 연결된 폴더에서 실행하세요." -ForegroundColor Yellow
    Write-Host "예: .\start-cursor-my-machine-worker.ps1 -RepoRoot `"D:\dev\내프로젝트`"" -ForegroundColor Yellow
    exit 1
}

Write-Host "로그인 상태 확인 중..." -ForegroundColor Cyan
& agent whoami
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$machineName = if ($env:CURSOR_WORKER_NAME) { $env:CURSOR_WORKER_NAME } else { $env:COMPUTERNAME }
Write-Host ""
Write-Host "worker 시작 (PC 표시 이름: $machineName, 레포: $RepoRoot)" -ForegroundColor Green
Write-Host "이 창을 닫지 마세요. 종료: Ctrl+C" -ForegroundColor Green
Write-Host "폰 브라우저: https://cursor.com/agents → 환경에서 이 PC 선택" -ForegroundColor Green
Write-Host ""

Set-Location $RepoRoot
& agent worker start --name $machineName --worker-dir $RepoRoot
