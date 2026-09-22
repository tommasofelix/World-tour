# Architettura, stack e runtime

## Stack Ufficiale e Runtime Adottato (Confermato al 2026-09-22)

- **Motore di Gioco**: Godot Engine v4.7.2.stable.official.ed1daf0bf (64-bit per Windows 11).
- **Linguaggio Applicativo**: GDScript 2.0 (tipizzazione statica forte, lambda, annotazioni).
- **Architettura Software**: Clean Architecture disaccoppiata (Domain-Driven Design), EventBus a segnali, pattern Resource per i dati e FSM globale (`GameManager`).
- **Driver di Accessibilità**: Native AccessKit (`--accessibility-driver accesskit`, modalità `--accessibility auto` o `always`), integrato direttamente in Windows UI Automation (UIA) per NVDA.
- **Canale Sonoro & Speech**: SAPI / audio cues con volume massimo calibrato a 0.7f–0.8f e ducking automatico.

## Ambiente Disponibile e Strumenti Rilevati

- **Percorso Eseguibili Motore**: `$env:OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\`
  - `Godot_v4.7.2-stable_win64_console.exe`: wrapper CLI con reindirizzamento I/O standard, utilizzato per validazione sintattica, test headless e automazione PowerShell.
  - `Godot_v4.7.2-stable_win64.exe`: ambiente grafico con editor visivo per composizione scene, layout e styling.
- **Controllo Versione**: Git 2.45.2 per Windows.
- **Python**: Python 3.12.0 disponibile per script di utility e validazione dati.
- **Screen Reader di Riferimento**: NVDA (in `C:\Program Files\NVDA`).

## Comandi Operativi di Riferimento

- **Verifica Versione**:
  ```powershell
  & "$env:OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --version
  ```
- **Controllo Sintattico Senza Grafica (CLI-First)**:
  ```powershell
  & "$env:OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --check-only -s <percorso_script.gd>
  ```
- **Suite di Test Unitari Headless**:
  ```powershell
  & "$env:OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless -s tests/test_formulas.gd
  ```
- **Avvio con Accessibilità e Console**:
  ```powershell
  & "$env:OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --path . --accessibility always --accessibility-driver accesskit
  ```

## Vincoli di Portabilità e Rollback

- Nessun percorso assoluto cablato nel codice sorgente: utilizzo esclusivo di percorsi relativi di Godot (`res://`, `user://`) o variabili d'ambiente PowerShell negli script di automazione (`tools/`).
- Isolamento della logica dai nodi visivi: i file `.gd` in `core/` e `systems/` devono poter essere istanziati ed eseguiti anche in modalità headless senza dipendere dall'albero di scena grafico (`SceneTree`).
