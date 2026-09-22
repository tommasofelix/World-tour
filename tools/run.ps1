# tools/run.ps1 — Avvia World-tour con console e AccessKit attivo
[CmdletBinding()]
param(
    [switch]$Windowed,
    [string]$CustomScene
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
    Write-Error "Eseguibile di Godot non trovato. Verifica il percorso in '$env:OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\'"
    exit 1
}

Write-Host "Avvio World-tour con Godot Engine 4.7..." -ForegroundColor Cyan
Write-Host "Motore: $GodotExe" -ForegroundColor DarkGray
Write-Host "Progetto: $ProjectRoot" -ForegroundColor DarkGray
Write-Host "Accessibilità: Driver AccessKit forzato (NVDA compatibile)" -ForegroundColor Green

$ArgsList = @(
    "--path", $ProjectRoot,
    "--accessibility", "always",
    "--accessibility-driver", "accesskit"
)

if ($CustomScene) {
    $ArgsList += $CustomScene
}

& $GodotExe @ArgsList
