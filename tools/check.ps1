# tools/check.ps1 — Verifica sintattica e integrità di tutti i file GDScript
[CmdletBinding()]
param(
    [string]$TargetFile
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

$FilesToCheck = @()
if ($TargetFile) {
    $Resolved = Resolve-Path $TargetFile -ErrorAction SilentlyContinue
    if ($Resolved) {
        $FilesToCheck += $Resolved.Path
    } else {
        Write-Error "File non trovato: $TargetFile"
        exit 1
    }
} else {
    $FilesToCheck = Get-ChildItem -Path "$ProjectRoot" -Filter "*.gd" -Recurse | 
        Where-Object { $_.FullName -notmatch "\\\.godot\\" } | 
        ForEach-Object { $_.FullName }
}

if ($FilesToCheck.Count -eq 0) {
    Write-Host "Nessun file .gd da verificare." -ForegroundColor Yellow
    exit 0
}

Write-Host "=== VERIFICA SINTATTICA GDSCRIPT (GODOT 4.7) ===" -ForegroundColor Cyan
$Errors = 0
$Checked = 0

foreach ($file in $FilesToCheck) {
    $Rel = $file.Replace($ProjectRoot.Path + "\", "")
    $proc = Start-Process -FilePath $GodotExe -ArgumentList @("--path", $ProjectRoot, "--headless", "--check-only", "-s", $file) -NoNewWindow -Wait -PassThru
    $Checked++
    
    if ($proc.ExitCode -eq 0) {
        Write-Host "[OK] $Rel" -ForegroundColor Green
    } else {
        Write-Host "[ERRORE] $Rel (ExitCode $($proc.ExitCode))" -ForegroundColor Red
        $Errors++
    }
}

Write-Host "`n=== RIEPILOGO VERIFICA SINTATTICA ===" -ForegroundColor Cyan
Write-Host "File verificati: $Checked" -ForegroundColor White
Write-Host "Errori rilevati: $Errors" -ForegroundColor $(if ($Errors -gt 0) { "Red" } else { "Green" })

if ($Errors -gt 0) {
    exit 1
}
exit 0
