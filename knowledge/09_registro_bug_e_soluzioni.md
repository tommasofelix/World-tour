# Registro dei problemi e delle soluzioni validate

Questo registro contiene soltanto problemi tecnici confermati e soluzioni con evidenza sufficiente. Le revisioni ancora aperte appartengono a [`docs/report/REGISTRO_REVISIONI.md`](../docs/report/REGISTRO_REVISIONI.md).

## Voci validate

### BUG-001 (RRU-01) — Errore Runtime Accesso Proprietà Tema in Godot 4 (HBoxContainer)

- Data e componente: `2026-09-22`, `ui/music/song_catalog.gd` (riga 90).
- Sintomo osservato: Errore di runtime `SCRIPT ERROR: Invalid access to property or key 'theme_override_constants' on a base object of type 'HBoxContainer'` con blocco del flusso creativo nello studio alla creazione di un nuovo brano.
- Evidenza riproducibile: Emissione del segnale `EventBus.song_created` con ricezione sincrona in `SongCatalog.refresh_catalog()` che tentava l'assegnazione ad albero `row.theme_override_constants.separation = 15`.
- Causa radice verificata: In Godot 4 GDScript le proprietà di override del tema sui nodi `Control` istanziati dinamicamente non sono dizionari esposti con notazione puntata.
- Soluzione applicata: Sostituzione con la funzione di sistema `row.add_theme_constant_override("separation", 15)` e aggiunta di controllo di guardia `if not vbox_songs: return` in `refresh_catalog()`.
- Test automatici eseguiti: Aggiunto test di rendering dinamico con brani popolati in `tests/test_music_system.gd` (109/109 asserzioni superate, exit code 0).
- Collaudo manuale eseguito: Superato con successo con esecuzione reale da parte di Luca (NVDA) e Tom a video.
- Misure di prevenzione delle regressioni: Tutti i controlli UI dinamici devono usare i metodi canonici `add_theme_*_override()` e i test di istanziazione devono popolare elementi fittizi per esercitare i rami interni di generazione nodi.

### BUG-002 — Cattura per Valore nelle Chiusure Lambda e Ciclo di Vita `_ready()` nei Test Headless di Interfaccia

- Data e componente: `2026-09-23`, `tests/test_vital_resources_system.gd` e `ui/relax/relax_modal.gd`.
- Sintomo osservato: Fallimento asserzione headless con `SCRIPT ERROR: Invalid access to property or key 'action_id' on a base object of type 'Nil'` ed errori di segnale `Signal 'pressed' is already connected to given callable 'Control(relax_modal.gd)::_on_btn_coffee_pressed'`.
- Evidenza riproducibile: Connessione di un segnale a una lambda con assegnazione a variabile locale scalare/null (`var received_action = null; inst.activity_selected.connect(func(act): received_action = act)`) e successiva invocazione manuale di `inst._ready()` dopo `add_child(inst)`.
- Causa radice verificata:
  1. In GDScript 4, le lambda catturano i riferimenti nulli e i tipi scalari/primitivi per valore (creando un rebinding interno alla chiusura), lasciando invariata la variabile locale esterna nello scope della funzione di test.
  2. L'invocazione di `add_child(inst)` all'interno del metodo `_ready()` di un test già innestato nella scena attiva scatena immediatamente e in modo sincrono il `_ready()` del figlio; una seconda chiamata manuale esplicita a `inst._ready()` ri-esegue le connessioni dei pulsanti generando errori `Signal already connected` se non protette da guardie.
- Soluzione applicata:
  1. Adozione del pattern **Closure Container**: catturare gli argomenti emessi tramite una collezione per riferimento (es. `var received: Array = []` e `func(act): received.append(act)`), che conserva lo stato mutato nello scope del test.
  2. Aggiunta sistematica della guardia `if btn and not btn.pressed.is_connected(_handler)` nel metodo `_ready()` di tutti i componenti UI e rimozione della chiamata ridondante a `inst._ready()` nei test runner.
- Test automatici eseguiti: 37/37 asserzioni superate in `tests/test_vital_resources_system.tscn` (exit code 0), con regressione positiva su 6 suite (266 asserzioni complessive a 0 errori).
- Misure di prevenzione delle regressioni: Nei test headless per segnali UI usare categoricamente `Array` come ricevitore di closure, e nei nodi UI proteggere sempre le connessioni da tastiera/pulsante con `not signal.is_connected()`.

### BUG-003 — Errore di Formattazione Stringhe per `%` Non Escapato e Refuso Proprietà Modello Contratto

- Data e componente: `2026-09-23`, `systems/music_system.gd` (riga 100) e `systems/industry_system.gd` (riga 253).
- Sintomo osservato:
  1. Errore di runtime `ERROR: String formatting error: unsupported format character.` all'annuncio dello sconto martedì in `MusicSystem.record_tracks()`.
  2. Errore di runtime `SCRIPT ERROR: Invalid access to property or key 'albums_delivered' on a base object of type 'RefCounted (ContractData)'` in `IndustrySystem.sign_contract()`, con conseguente fallimento delle asserzioni di firma contratto in `test_industry_system.gd`.
- Evidenza riproducibile: Esecuzione di `tests/test_advanced_crafting_system.tscn` e `tests/test_industry_system.tscn` in modalità headless.
- Causa radice verificata:
  1. In GDScript 2.0, l'operatore `%` applicato a una stringa interpreta ogni singolo `%` come inizio di uno specificatore di formato; la dicitura `"20% applicato"` conteneva `% ` (percentuale seguito da spazio), interpretato come specificatore non valido. Il carattere percentuale letterale richiede il doppio `%` (`%%`). Inoltre, la dicitura monetaria `"€"` viene preferibilmente sostituita dalla parola estesa `"euro"` per chiarezza di pronuncia NVDA.
  2. Nel modello dati `ContractData`, il campo ufficiale è denominato `delivered_albums` (`int`), mentre `industry_system.gd` tentava erroneamente di accedere alla proprietà orfana `albums_delivered`.
- Soluzione applicata:
  1. In `systems/music_system.gd`: sostituito con `"Sconto Martedì del 20%% applicato allo Studio Professionale! Spesa: %.2f euro" % studio_cost`.
  2. In `systems/industry_system.gd`: sostituito `found_contract.albums_delivered` con `found_contract.delivered_albums`.
- Test automatici eseguiti: 65/65 test superati in `test_advanced_crafting_system.gd` e 60/60 test superati in `test_industry_system.gd` (exit code 0, nessun errore residuo a console).
- Misure di prevenzione delle regressioni: Nelle stringhe formattate con `%` effettuare sempre l'escaping dei simboli percentuali con `%%` e verificare la corrispondenza dei campi dei modelli dati tramite test con copertura di tutti i rami di esecuzione.

### BUG-004 — Freeze Infinito del Runner Headless su File `.gd` Diretti e Assenza di Watchdog Timeout

- Data e componente: `2026-09-23`, `tools/test.ps1` e runtime Godot 4.7.
- Sintomo osservato: La suite di test headless si bloccava a tempo indefinito durante l'esecuzione da riga di comando o lasciava processi `Godot_v4.7.2-stable_win64_console.exe` orfani in memoria (es. PID 32208 con CPU 0%).
- Evidenza riproducibile: Lancio diretto da terminale di `godot --headless tests/test_nome.gd` oppure `godot --headless -s tests/test_nome.gd` con script estendenti `Node`.
- Causa radice verificata:
  1. In Godot 4, lanciare un file `.gd` direttamente senza flag `-s` induce l'engine a tentare di caricarlo come una risorsa scena (`PackedScene`); il caricamento fallisce silenziosamente e Godot entra nel loop di idle dell'engine senza eseguire nulla e senza uscire.
  2. Lanciare un file `.gd` che estende `Node` con `-s` fallisce poiché `-s` richiede uno script che estenda `MainLoop` o `SceneTree`. Il nodo viene istanziato fuori dall'albero, `_ready()` non viene mai invocato, `quit()` non viene mai raggiunto e il processo resta congelato all'infinito.
  3. `tools/test.ps1` utilizzava `Start-Process -Wait` senza alcun timeout: in caso di blocco dell'engine o freeze della console (QuickEdit di Windows), lo script PowerShell rimaneva appeso indefinitamente.
- Soluzione applicata:
  1. Obbligo di esecuzione dei test tramite risorsa `.tscn` dedicata (`res://tests/test_nome.tscn`), che inizializza correttamente il `SceneTree` e gli Autoload di sistema.
  2. Ristrutturazione di `tools/test.ps1` impiegando `System.Diagnostics.Process` con watchdog timeout perentorio a 15 secondi (`$proc.WaitForExit(15000)`), abbattimento forzato con `$proc.Kill()` in caso di timeout, pulizia preventiva di processi orfani all'avvio e contatore lineare `[1/23]` per NVDA.
- Test automatici eseguiti: Tutte le 23 suite di test del progetto eseguite e concluse con successo in circa 75 secondi, con 0 fallimenti e nessun freeze.
- Misure di prevenzione delle regressioni: Mai invocare file `.gd` privi di scena come target di test se estendono `Node`; dotare sempre i runner di automazione di un meccanismo di watchdog timeout non bloccante.

