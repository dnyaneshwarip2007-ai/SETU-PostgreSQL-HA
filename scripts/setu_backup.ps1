$ErrorActionPreference = "Stop"

$container = "pg-replica2"
$backupDir = Join-Path $PSScriptRoot "..\backups"

New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

$status = docker inspect -f "{{.State.Status}}" $container 2>$null

if ($LASTEXITCODE -ne 0 -or $status -ne "running") {
    Write-Error "PostgreSQL container '$container' is not running."
    exit 1
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupFile = Join-Path $backupDir "setu_backup_$timestamp.sql"

docker exec $container pg_dump -U postgres -d setu_db -f /tmp/setu_backup.sql

if ($LASTEXITCODE -ne 0) {
    Write-Error "Database dump failed."
    exit 1
}

docker cp "${container}:/tmp/setu_backup.sql" $backupFile

if ($LASTEXITCODE -ne 0 -or -not (Test-Path $backupFile) -or (Get-Item $backupFile).Length -eq 0) {
    Write-Error "Backup copy failed or produced an empty file."
    exit 1
}

docker exec $container rm -f /tmp/setu_backup.sql | Out-Null

Write-Host "Backup created successfully: $backupFile" -ForegroundColor Green
