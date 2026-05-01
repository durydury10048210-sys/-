# AGENTS.md

## Cursor Cloud specific instructions

### Overview

This repository contains PowerShell (`.ps1`) helper scripts for registering a local Windows PC as a Cursor "My Machines" worker. There is **no application to build or run** — the scripts are the product.

### Key files

| File | Purpose |
|------|---------|
| `set-git-remote.ps1` | Sets a GitHub/GitLab HTTPS URL as the `origin` remote |
| `complete-my-machines.ps1` | Sets origin + runs `agent worker debug` for validation |
| `start-cursor-my-machine-worker.ps1` | Starts the Cursor worker process (requires Cursor Agent CLI) |
| `origin.url.example` | Example format for the `origin.url` config file |

### Development environment

- **Language:** PowerShell — install via `apt-get install -y powershell` (requires Microsoft package repo on Ubuntu 24.04).
- **Runtime:** `pwsh` (PowerShell 7.x). Verify with `pwsh --version`.
- **No dependencies to install** — there is no `package.json`, `requirements.txt`, or similar manifest.
- **No build step** — scripts are interpreted directly.

### Lint / Test / Validation

- **Syntax check all scripts:** `for f in *.ps1; do pwsh -NoProfile -Command '$ast = [System.Management.Automation.Language.Parser]::ParseFile("'$f'", [ref]$null, [ref]$errors); if ($errors.Count -gt 0) { $errors | ForEach-Object { Write-Error $_ }; exit 1 } else { Write-Host "OK: '$f'" }'; done`
- **No automated test suite exists.** Validate scripts by running them with `pwsh -NoProfile -File <script>.ps1`.
- `set-git-remote.ps1` requires `-RemoteUrl` parameter.
- `complete-my-machines.ps1` requires either `GITHUB_REPO_URL` env var or an `origin.url` file.
- `start-cursor-my-machine-worker.ps1` requires the Cursor Agent CLI (`agent`) which is an external dependency not available in the Cloud VM.

### Gotchas

- Running `set-git-remote.ps1` or `complete-my-machines.ps1` **modifies the git `origin` remote URL**. After testing, restore the original remote with `git remote set-url origin <original-url>`.
- Scripts contain Korean-language comments — this is intentional and expected.
