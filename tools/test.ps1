# tools/test.ps1 — Esegue i test unitari di World-tour in modalità Headless
[CmdletBinding()]
param(
    [string]$TestFile
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

$TestsToRun = @()
if ($TestFile) {
    $Resolved = Resolve-Path $TestFile -ErrorAction SilentlyContinue
    if (-not $Resolved) {
        $Resolved = Resolve-Path "$ProjectRoot\tests\$TestFile" -ErrorAction SilentlyContinue
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
$Failures = 0
$Successes = 0

foreach ($test in $TestsToRun) {
    $TestRel = Split-Path $test -Leaf
    Write-Host "`nEsecuzione test: $TestRel..." -ForegroundColor Yellow
    
    $proc = Start-Process -FilePath $GodotExe -ArgumentList @("--path", $ProjectRoot, "--headless", "-s", $test) -NoNewWindow -Wait -PassThru
    
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
