# tools/test.ps1 — Esegue i test unitari di World-tour in modalità Headless
[CmdletBinding()]
param(
    [string]$TestFile,
    [int]$TimeoutSeconds = 15
)

$ProjectRoot = Resolve-Path "$PSScriptRoot\.."
$GodotCandidates = @(
    $env:GODOT_BIN,
    "$env:OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe",
    "$env:USERPROFILE\OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe"
)

$GodotExe = $null
foreach ($cand in $GodotCandidates) {
    if ($cand -and (Test-Path $cand)) {
        $GodotExe = $cand
        break
    }
}

if (-not $GodotExe) {
    Write-Error "Eseguibile di Godot non trovato."
    exit 1
}

# Pulizia preventiva processi orfani Godot per prevenire deadlock
Get-Process | Where-Object { $_.ProcessName -like "*Godot*console*" } | Stop-Process -Force -ErrorAction SilentlyContinue

$TestsToRun = @()
if ($TestFile) {
    $Resolved = Resolve-Path $TestFile -ErrorAction SilentlyContinue
    if (-not $Resolved) {
        $Resolved = Resolve-Path "$ProjectRoot\tests\$TestFile" -ErrorAction SilentlyContinue
    }
    if (-not $Resolved) {
        $Resolved = Resolve-Path "$ProjectRoot\tests\$TestFile.gd" -ErrorAction SilentlyContinue
    }
    if (-not $Resolved) {
        $Resolved = Resolve-Path "$ProjectRoot\tests\$TestFile.tscn" -ErrorAction SilentlyContinue
    }
    if ($Resolved) {
        $TestsToRun += $Resolved.Path
    } else {
        Write-Error "File di test non trovato: $TestFile"
        exit 1
    }
} else {
    $TestsToRun = Get-ChildItem -Path "$ProjectRoot\tests" -Filter "test_*.gd" | ForEach-Object { $_.FullName }
}

if ($TestsToRun.Count -eq 0) {
    Write-Host "Nessun file di test trovato in '$ProjectRoot\tests'." -ForegroundColor Yellow
    exit 0
}

Write-Host "=== ESECUZIONE TEST UNITARI HEADLESS (GODOT 4.7) ===" -ForegroundColor Cyan
Write-Host "Totale suite individuate: $($TestsToRun.Count) | Watchdog timeout: ${TimeoutSeconds}s`n" -ForegroundColor DarkGray
$Failures = 0
$Successes = 0
$CurrentIndex = 0

foreach ($test in $TestsToRun) {
    $CurrentIndex++
    $TestRel = Split-Path $test -Leaf
    Write-Host "[$CurrentIndex/$($TestsToRun.Count)] Esecuzione test: $TestRel..." -ForegroundColor Yellow
    
    $matchingScene = $test -replace '\.gd$', '.tscn'
    $targetRun = ""
    if (Test-Path $matchingScene) {
        $targetRun = ($matchingScene -replace [regex]::Escape($ProjectRoot.Path + "\"), "res://") -replace '\\', '/'
    } else {
        $targetRun = "-s " + (($test -replace [regex]::Escape($ProjectRoot.Path + "\"), "res://") -replace '\\', '/')
    }
    
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $GodotExe
    $psi.Arguments = "--path `"$($ProjectRoot.Path)`" --headless $targetRun"
    $psi.UseShellExecute = $false
    
    $proc = [System.Diagnostics.Process]::Start($psi)
    $finishedInTime = $proc.WaitForExit($TimeoutSeconds * 1000)
    
    if (-not $finishedInTime) {
        Write-Host "[TIMEOUT CRITICO] Il test ha superato ${TimeoutSeconds}s ed è stato terminato: $TestRel" -ForegroundColor Red
        try { $proc.Kill() } catch {}
        $Failures++
        continue
    }
    
    if ($proc.ExitCode -eq 0) {
        Write-Host "[OK] Test superato: $TestRel" -ForegroundColor Green
        $Successes++
    } else {
        Write-Host "[FALLITO] Test con errori (ExitCode $($proc.ExitCode)): $TestRel" -ForegroundColor Red
        $Failures++
    }
}

Write-Host "`n=== RIEPILOGO TEST ===" -ForegroundColor Cyan
Write-Host "Superati: $Successes" -ForegroundColor Green
Write-Host "Falliti:  $Failures" -ForegroundColor $(if ($Failures -gt 0) { "Red" } else { "Green" })

if ($Failures -gt 0) {
    exit 1
}
exit 0
