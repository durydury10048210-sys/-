# My Machines: set git origin + agent worker debug
# Set GITHUB_REPO_URL or create origin.url with one HTTPS line.

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot

$url = $env:GITHUB_REPO_URL
if (-not $url) {
    $originFile = Join-Path $root "origin.url"
    if (Test-Path $originFile) {
        $url = (Get-Content $originFile -Raw).Trim()
    }
}

$placeholder = "YOUR_USER"
if (-not $url -or $url -match $placeholder) {
    Write-Host "Missing GitHub HTTPS URL. Set GITHUB_REPO_URL or create origin.url" -ForegroundColor Yellow
    exit 1
}

Write-Host "Setting origin..." -ForegroundColor Cyan
& "$root\set-git-remote.ps1" -RemoteUrl $url

Write-Host ""
Write-Host "Running agent worker debug..." -ForegroundColor Cyan
Set-Location $root
agent worker debug --worker-dir $root

Write-Host ""
Write-Host "Next: .\start-cursor-my-machine-worker.ps1 -RepoRoot '$root'" -ForegroundColor Green
