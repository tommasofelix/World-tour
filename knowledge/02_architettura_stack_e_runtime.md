# 02 — Architettura, Stack e Runtime (ASTRALIS v3.0.7)

## Stack Ufficiale e Runtime Adottato (Confermato al 2026-09-23)

- **Motore di Gioco**: Godot Engine v4.7.2.stable.official.ed1daf0bf (64-bit per Windows 11).
- **Linguaggio Applicativo**: GDScript 2.0 (tipizzazione statica forte, lambda, annotazioni `@export`, `@onready`).
- **Architettura Software**: Clean Architecture disaccoppiata (Domain-Driven Design), EventBus a segnali, pattern Resource per i dati e FSM globale (`GameManager`).
- **Driver di Accessibilità**: Native AccessKit (`--accessibility-driver accesskit`, modalità `--accessibility auto` o `always`), integrato direttamente in Windows UI Automation (UIA) per NVDA.
- **Canale Sonoro & Speech**: SAPI / audio cues con volume massimo calibrato a `0.7f–0.8f`, ducking automatico e protezione da mascheramento vocale.

---

## Ambiente Disponibile e Strumenti Rilevati

- **Percorso Eseguibili Motore**: `$env:OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\`
  - `Godot_v4.7.2-stable_win64_console.exe`: wrapper CLI con reindirizzamento I/O standard, impiegato per validazione sintattica, test headless deterministici e automazione PowerShell.
  - `Godot_v4.7.2-stable_win64.exe`: ambiente grafico con editor visivo per composizione scene, layout e styling.
- **Controllo Versione**: Git 2.45.2 per Windows.
- **Python**: Python 3.12.0 disponibile per script di utility e validazione dati.
- **Screen Reader di Riferimento**: NVDA (in `C:\Program Files\NVDA`).

---

## Protocollo 12 — Cancello 5: Determinismo Headless a 0 ms & Suite di Test

Tutti i sistemi di logica pura (`core/`, `systems/`, `data/`) sono isolati dal rendering grafico e progettati per essere testati senza albero di scena (`SceneTree`) tramite test seams deterministici.

1. **Assenza Totale di Latenze Artificiali**: Divieto di impiegare `OS.delay()`, timer di sleep o yield fittizi nei runner di test. Ogni asserzione viene calcolata ed emessa istantaneamente (tempo medio di esecuzione: 0–15 ms per suite).
2. **Le 20 Suite di Test Headless Validate (Exit Code 0)**:
   - `test_formulas.gd`: formule matematiche, curve XP e bilanciamento;
   - `test_time_system.gd`: orologio, routine giornaliera, passaggio giorno;
   - `test_player_system.gd`: attributi, energia, stress, morale, progressione;
   - `test_music_system.gd`: creazione brani, quality score, composizione e bozze;
   - `test_concert_system.gd`: concerti live, affluenza, scaletta e incassi;
   - `test_economy_system.gd`: flussi finanziari, spese, contratti e royalties;
   - `test_localization.gd`: dizionari bilingue, fallback deterministico e pulizia setting;
   - `test_save_manager.gd`: serializzazione atomica JSON, integrità salvataggi;
   - `test_vertical_slice.gd`: catena completa gameplay e cicli fine giornata;
   - `test_character_creation.gd`: creazione guidata, background e tratti iniziali (Sez. 1.1);
   - `test_time_night_system.gd`: filosofia della notte su 22h, overtime e skip time (Sez. 1.2);
   - `test_vital_resources_system.gd`: triade risorse, burnout, panico e recupero attivo (Sez. 1.3);
   - `test_upgrades_system.gd`: lifestyle, insonorizzazione, strumenti e home studio;
   - `test_v5_ui_overhaul.gd`: architettura UI a 5 sezioni, navigazione macro-aree e modali;
   - Ulteriori suite per i sottosistemi di band, etichette, tour interurbani, festival estivi, social media e classifiche.

3. **Pattern Closure Container & Guardie Segnali nei Test Headless di Interfaccia**:
   - In GDScript 4, la cattura di variabili locali scalari o nulle all'interno di lambda passate a `connect()` avviene per valore; per verificare l'emissione dei segnali nei test runner occorre impiegare un contenitore reference (`var received: Array = []` e `func(arg): received.append(arg)`).
   - Quando si istanziano controlli grafici con `add_child(inst)` all'interno del metodo `_ready()` del test runner, Godot 4 invoca `_ready()` sul figlio immediatamente e in modo sincrono; è fatto divieto di richiamare manualmente `inst._ready()` e tutti i collegamenti a segnali nei nodi UI devono essere protetti da `if not btn.pressed.is_connected(_handler)`.

---

## Comandi Operativi di Riferimento

- **Verifica Versione del Motore**:
  ```powershell
  & "$env:OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --version
  ```
- **Controllo Sintattico Headless Senza Grafica (CLI-First)**:
  ```powershell
  & "$env:OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --check-only -s <percorso_script.gd>
  ```
- **Esecuzione Suite di Test Unitari Headless**:
  ```powershell
  & "$env:OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless -s tests/test_formulas.gd
  ```
- **Avvio del Gioco con Accessibilità Forzata e Console Attiva**:
  ```powershell
  & "$env:OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --path . --accessibility always --accessibility-driver accesskit
  ```

---

## Vincoli di Portabilità e Rollback

- **Nessun Percorso Assoluto Cablato**: Utilizzo esclusivo di percorsi engine virtuali (`res://`, `user://`) nel codice GDScript o variabili d'ambiente PowerShell negli script di automazione (`tools/`).
- **Isolamento della Logica dai Nodi Visivi**: I moduli in `core/` e `systems/` devono operare come classi pure (`RefCounted`), garantendo testabilità totale ed esecuzione headless.
