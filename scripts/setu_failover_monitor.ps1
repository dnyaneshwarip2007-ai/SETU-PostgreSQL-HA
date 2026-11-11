Write-Host "SETU PostgreSQL HA Failover Monitor" -ForegroundColor Cyan
Write-Host "Monitoring pg-replica2 (Primary)..." -ForegroundColor Yellow

$primary = "pg-replica2"
$standby = "pg-replica1"

while ($true) {

    $status = docker inspect -f "{{.State.Status}}" $primary 2>$null

    if ($LASTEXITCODE -eq 0 -and $status -eq "running") {
        Write-Host "$(Get-Date -Format 'HH:mm:ss') - Primary is running" -ForegroundColor Green
        Start-Sleep -Seconds 5
        continue
    }

    Write-Host "$(Get-Date -Format 'HH:mm:ss') - PRIMARY FAILURE DETECTED!" -ForegroundColor Red

    $standbyStatus = docker inspect -f "{{.State.Status}}" $standby 2>$null

    if ($LASTEXITCODE -ne 0 -or $standbyStatus -ne "running") {
        Write-Error "Standby container is unavailable. Manual recovery required."
        exit 1
    }

    $recoveryStatus = docker exec $standby psql -U postgres -tAc "SELECT pg_is_in_recovery();"

    if ($LASTEXITCODE -ne 0 -or $recoveryStatus.Trim() -ne "t") {
        Write-Error "Standby is not in recovery mode. Promotion aborted."
        exit 1
    }

    Write-Host "Promoting $standby to Primary..." -ForegroundColor Yellow

    docker exec $standby psql -U postgres -c "SELECT pg_promote();"

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Promotion command failed."
        exit 1
    }

    $newRole = docker exec $standby psql -U postgres -tAc "SELECT pg_is_in_recovery();"

    if ($LASTEXITCODE -eq 0 -and $newRole.Trim() -eq "f") {
        Write-Host "$standby is now the Primary." -ForegroundColor Green
        Write-Host "Failover completed successfully." -ForegroundColor Green
        break
    }

    Write-Error "Promotion could not be verified. Manual recovery required."
    exit 1
}
