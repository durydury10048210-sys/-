# Cursor My Machines: run a worker so cursor.com/agents can use this PC.
# Docs: https://cursor.com/docs/cloud-agent/my-machines
#
# Examples:
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
    Write-Host "Not a git repo. Run from a folder with GitHub/GitLab remote." -ForegroundColor Yellow
    Write-Host 'Example: .\start-cursor-my-machine-worker.ps1 -RepoRoot "D:\path\to\repo"' -ForegroundColor Yellow
    exit 1
}

Write-Host "Checking login..." -ForegroundColor Cyan
& agent whoami
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$machineName = if ($env:CURSOR_WORKER_NAME) { $env:CURSOR_WORKER_NAME } else { $env:COMPUTERNAME }
Write-Host ""
Write-Host "Starting worker (name: $machineName, repo: $RepoRoot)" -ForegroundColor Green
Write-Host "Leave this window open. Stop: Ctrl+C" -ForegroundColor Green
Write-Host "Agents: https://cursor.com/agents" -ForegroundColor Green
Write-Host ""

Set-Location $RepoRoot
& agent worker start --name $machineName --worker-dir $RepoRoot
