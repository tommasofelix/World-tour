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
2. **Le 24 Suite di Test Headless Validate (Exit Code 0)**:
   - `test_formulas.gd`: formule matematiche, curve XP e bilanciamento;
   - `test_time_system.gd`: orologio, routine giornaliera, passaggio giorno;
   - `test_player_system.gd`: attributi, energia, stress, morale, progressione;
   - `test_music_system.gd`: creazione brani, quality score, composizione e bozze;
   - `test_advanced_crafting_system.gd`: crafting avanzato, 10 temi lirici, sinergie, nuovi tratti e studio pro (Sez. 2);
   - `test_band_system.gd`: gestione band, 5 ruoli (incluso cantante VOCALS), 8 personalità, bacheca audizioni con rifiuto deterministico, prove e revenue split (58 test, Sez. 3);
   - `test_concert_system.gd`: concerti live, affluenza, scaletta, sinergia palco e incassi;
   - `test_economy_system.gd`: flussi finanziari, spese, contratti e royalties;
   - `test_localization.gd`: dizionari bilingue it/en (259 chiavi perfettamente allineate), fallback deterministico e pulizia setting;
   - `test_save_manager.gd`: serializzazione atomica JSON, integrità salvataggi;
   - `test_vertical_slice.gd`: catena completa gameplay e cicli fine giornata;
   - `test_character_creation.gd`: creazione guidata, background e tratti iniziali (Sez. 1.1);
   - `test_time_night_system.gd`: filosofia della notte su 22h, overtime e skip time (Sez. 1.2);
   - `test_vital_resources_system.gd`: triade risorse, burnout, panico e recupero attivo (Sez. 1.3);
   - `test_upgrades_system.gd`: lifestyle, insonorizzazione, strumenti e home studio;
   - `test_v5_ui_overhaul.gd`: architettura UI a 5 sezioni, navigazione macro-aree e modali;
   - `test_advanced_social_system.gd`: social media avanzati, trend algoritmici settimanali, campagne sponsorizzate, live streaming, fan club, raduno annuale e deleghe manager (51 test, Sez. 8);
   - Ulteriori suite per i sottosistemi di etichette, tour interurbani, festival estivi e classifiche.

3. **Pattern Closure Container & Guardie Segnali nei Test Headless di Interfaccia**:
   - In GDScript 4, la cattura di variabili locali scalari o nulle all'interno di lambda passate a `connect()` avviene per valore; per verificare l'emissione dei segnali nei test runner occorre impiegare un contenitore reference (`var received: Array = []` e `func(arg): received.append(arg)`).
   - Quando si istanziano controlli grafici con `add_child(inst)` all'interno del metodo `_ready()` del test runner, Godot 4 invoca `_ready()` sul figlio immediatamente e in modo sincrono; è fatto divieto di richiamare manualmente `inst._ready()` e tutti i collegamenti a segnali nei nodi UI devono essere protetti da `if not btn.pressed.is_connected(_handler)`.

4. **Regola d'Oro di Esecuzione Test Headless (Invocazione da Scena `.tscn`)**:
   - I test che estendono `Node` e dipendono dagli Autoload di sistema (`EventBus`, `GameManager`, `SaveManager`, `AccessibilityManager`) **devono essere eseguiti come scene `.tscn`** (es. `godot --path . --headless res://tests/test_nome.tscn`).
   - L'invocazione diretta di file `.gd` (senza scena o con flag `-s`) su script che estendono `Node` provoca il freeze a tempo indefinito dell'engine, poiché `_ready()` non viene invocato e `quit()` non viene raggiunto.
   - Tutti gli script di test runner automatizzati (`tools/test.ps1`) integrano un watchdog timeout (15 secondi) tramite `.NET Process` per prevenire qualsiasi freeze della console di sviluppo.

5. **Pattern Quiet Day / Rest Guard nelle Macchine di Avanzamento Logistico**:
   - Nei motori di simulazione a tappe discrete (tournée, viaggi a tappe, itinerari geografici) che integrano sia spostamenti attivi sia giornate di riposo/sosta statica ("Day Off"), la funzione di avanzamento deve disaccoppiare categoricamente la sosta dal tragitto cinetico tramite una guardia predittiva prioritaria (`if cur_stop.is_day_off`).
   - L'usura del veicolo, lo stress da trasporto e il consumo energetico di viaggio devono essere saltati a monte: la sosta applica puramente e direttamente la rigenerazione psicofisica e il consolidamento relazionale del gruppo, prevenendo la diluizione o l'erosione dei benefici da parte di penalità logistiche.

6. **Pre-Flight Margining Pattern per Risorse Saturabili a Soglia Zero**:
   - Nelle suite di test deterministiche per scenari procedurali o catene di eventi che applicano decrementi su risorse limitate inferiormente da vincoli di clamping (es. `stress` limitato a `0.0` da `maxf/clampf`), ogni sotto-blocco di test che intende verificare un delta negativo deve predisporre un margine positivo sicuro prima dell'esecuzione (es. `player.stress = 30.0`).
   - Questo pattern garantisce il determinismo assoluto e previene falsi negativi dovuti all'azzeramento anticipato della risorsa da parte di asserzioni precedenti.

7. **Pattern di Decoupling nei Segnali Autoload (Evitare Dipendenze Circolari con Classi Modello)**:
   - Negli Autoload globali di broadcast ad eventi (`EventBus`), evitare di tipizzare strettamente i parametri dei segnali con nomi di classi personalizzate del modello (`class_name NomeClasse`), poiché gli Autoload vengono caricati in una fase precoce del runtime prima della risoluzione completa del registro dei tipi.
   - Utilizzare tipi base polimorfici come `RefCounted`, `Resource` o `Dictionary` nella firma del segnale dell'EventBus (`signal evento_emesso(payload: RefCounted)`), mantenendo la tipizzazione rigorosa e forte all'interno dei metodi consumatori nei singoli sistemi e controller.

8. **Rinfresco Deterministico della Class Cache Globale per Nuove Risorse in Headless (`--editor --quit`)**:
   - Quando viene creato un nuovo script su disco che dichiara un `class_name` globale, l'esecuzione ordinaria dei test in modalità headless da riga di comando (`--headless res://...`) non rigenera automaticamente il file `.godot/global_script_class_cache.cfg`.
   - Per forzare la scansione deterministica e l'aggiornamento immediato della class cache senza avviare l'interfaccia grafica o toccare il mouse, eseguire il comando headless rapido:
     `Godot_console.exe --headless --path . --editor --quit`.

9. **Pattern di Preload Script Decoupling nei Controller UI e nei Consumer Runtime**:
   - Nei controller di interfaccia (`ui/`) o nei consumer di modelli runtime, evitare l'uso diretto di annotazioni di tipo statico verso classi introdotte di recente (`var x: NuovaClasse`) prima che l'editor abbia sincronizzato la cache.
   - Impiegare sempre il pattern `const NuovaClasseScript = preload("res://data/models/nuova_classe.gd")` e annotare i parametri di ricezione con la classe base nativa `: RefCounted` o sfruttare il duck typing strutturato.
   - Questo previene qualsiasi errore di compilazione/parsing prematuro e garantisce la massima indipendenza e resilienza dell'interfaccia anche nelle sessioni di sviluppo headless continuative.

---

## Comandi Operativi di Riferimento

- **Verifica Versione del Motore**:
  ```powershell
  & "$env:OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --version
  ```
- **Controllo Sintattico Headless di Tutti i File GDScript**:
  ```powershell
  powershell -ExecutionPolicy Bypass -File tools/check.ps1
  ```
- **Esecuzione Suite di Test Headless (Singolo Test o Regressione Completa con Watchdog)**:
  ```powershell
  # Esecuzione di tutti i 23 test con watchdog a 15s e contatore NVDA:
  powershell -ExecutionPolicy Bypass -File tools/test.ps1

  # Esecuzione di un singolo test specifico:
  powershell -ExecutionPolicy Bypass -File tools/test.ps1 -TestFile test_advanced_crafting_system
  ```
- **Avvio del Gioco con Accessibilità Forzata e Console Attiva**:
  ```powershell
  powershell -ExecutionPolicy Bypass -File tools/run.ps1
  ```

---

## Vincoli di Portabilità e Rollback

- **Nessun Percorso Assoluto Cablato**: Utilizzo esclusivo di percorsi engine virtuali (`res://`, `user://`) nel codice GDScript o variabili d'ambiente PowerShell negli script di automazione (`tools/`).
- **Isolamento della Logica dai Nodi Visivi**: I moduli in `core/` e `systems/` devono operare come classi pure (`RefCounted`), garantendo testabilità totale ed esecuzione headless.
