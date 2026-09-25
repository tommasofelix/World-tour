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
2. **Le 31 Suite di Test Headless Validate (Exit Code 0)**:
   - `test_formulas.gd`: formule matematiche, curve XP e bilanciamento;
   - `test_time_system.gd`: orologio, routine giornaliera, passaggio giorno;
   - `test_player_system.gd`: attributi, energia, stress, morale, progressione;
   - `test_music_system.gd`: creazione brani, quality score, composizione e bozze;
   - `test_advanced_crafting_system.gd`: crafting avanzato, 10 temi lirici, sinergie, nuovi tratti e studio pro (Sez. 2);
   - `test_band_system.gd`: gestione band, 5 ruoli (incluso cantante VOCALS), 8 personalità, bacheca audizioni con rifiuto deterministico, prove e revenue split (58 test, Sez. 3);
   - `test_concert_system.gd`: concerti live, affluenza, scaletta, sinergia palco, incassi e catalogo 8 venue;
   - `test_economy_system.gd`: flussi finanziari, spese, contratti e royalties;
   - `test_localization.gd`: dizionari bilingue it/en (296 chiavi perfettamente allineate), fallback deterministico e pulizia setting;
   - `test_save_manager.gd`: serializzazione atomica JSON, integrità salvataggi;
   - `test_vertical_slice.gd`: catena completa gameplay e cicli fine giornata;
   - `test_character_creation.gd`: creazione guidata, background e tratti iniziali (Sez. 1.1);
   - `test_time_night_system.gd`: filosofia della notte su 22h, overtime e skip time (Sez. 1.2);
   - `test_vital_resources_system.gd`: triade risorse, burnout, panico e recupero attivo (Sez. 1.3);
   - `test_upgrades_system.gd`: lifestyle, insonorizzazione, strumenti e home studio;
   - `test_v5_ui_overhaul.gd`: architettura UI a 5 sezioni, navigazione macro-aree e modali;
   - `test_ui_audio_and_numpad_system.gd`: earcons procedurali, volumi sicuri <=0.75f, ducking 40%, numpad navigation e dashboard statistiche (128 test, Sez. 12);
   - `test_endless_and_ngplus_system.gd`: espansione Endless Horizon, New Game+, 16 metropoli e roster discografico magnate (AVF V5.2.0);
   - `test_main_menu.gd`: nuovo Menu Principale pixel art retrò arcade, 4 pulsanti neon, logica atomica Carica Partita, focus chaining continuo e accessibilità NVDA (33 test, Sez. F9.7, Versione AVF `V5.3.0`);
   - `test_apartment_gameplay.gd`: gameplay grafico 2.5D Loft NYC, mouse picking con cursore a manina, interazioni oggetti (letto, chitarra, pc, stereo, snack), auto-walk deterministico con stand_offset, clearance hitbox collisioni e offset HUD Full Rect (68 test, Sez. F9.8, Versione AVF `V5.4.0`);
   - `test_advanced_social_system.gd`: social media avanzati, trend algoritmici settimanali, campagne sponsorizzate, live streaming, fan club, raduno annuale e deleghe manager (51 test, Sez. 8);
   - `test_industry_system.gd`: contratti discografici, manager, recoupment, riscatto master e propria etichetta discografica (106 test, Sez. 9);
   - `test_media_and_rivals_system.gd`: relazioni rivali approfondite (affinità, co-headlining tour, dissing buzz x1.6), Hit Parade territoriali, tormentone stagionale (x1.35 vendite/stream) e sistema Media Broadcaster con interviste radio/podcast/TV del mattino e di riparazione (50 test, Sez. 10);
   - `test_endgame_and_legacy_system.gd`: Endgame, Grandi Arene & Mega Stadi Mondiali (15k e 65k posti), allestimenti scenici a 4 tier (`StageProductionTier`), certificazioni ufficiali FIMI/RIAA (Oro, Platino, Diamante), cerimonia annuale World Music Awards al Mese 12, Rock and Roll Hall of Fame, concerto celebrativo d'addio "The Last Waltz" ed epiloghi narrativi multipli di fine carriera (87 test, Sez. 11, Versione AVF `V5.0.0`);
   - `test_skills_and_loft_study_system.gd`: Albero delle Abilità a 6 rami (28 competenze), 5 Gradi di Maestria stellari (Principiante..Maestro Leggendario), 4 attributi fisiologici innati, propedeuticità deterministiche, 4 metodi di studio negli arredi del Loft NYC (manuali, accademia, maestro privato, ascolto vinili con boost di genere) e retrocompatibilità legacy (102 test, Sez. F9.13, Versione AVF `V5.7.0`);
   - Ulteriori suite per i sottosistemi di etichette, tour interurbani, festival estivi e classifiche.
   - *Integrazione Sistemi nel Ciclo di Vita*: Registrazione di `MediaSystem`, `AwardSystem`, `LegacySystem` e dei modelli `MediaOutletData` nel ciclo di vita globale di `GameManager` e nel salvataggio atomico di `SaveManager`.

3. **Pattern Closure Container & Guardie Segnali nei Test Headless di Interfaccia**:
   - In GDScript 4, la cattura di variabili locali scalari o nulle all'interno di lambda passate a `connect()` avviene per valore; per verificare l'emissione dei segnali nei test runner occorre impiegare un contenitore reference (`var received: Array = []` e `func(arg): received.append(arg)`).
   - Quando si istanziano controlli grafici con `add_child(inst)` all'interno del metodo `_ready()` del test runner, Godot 4 invoca `_ready()` sul figlio immediatamente e in modo sincrono; è fatto divieto di richiamare manualmente `inst._ready()` e tutti i collegamenti a segnali nei nodi UI devono essere protetti da `if not btn.pressed.is_connected(_handler)`.

4. **Regola d'Oro di Esecuzione Test Headless (Invocazione da Scena `.tscn`)**:
   - I test che estendono `Node` e dipendono dagli Autoload di sistema (`EventBus`, `GameManager`, `SaveManager`, `AccessibilityManager`) **devono essere eseguiti come scene `.tscn`** (es. `godot --path . --headless res://tests/test_nome.tscn`).

5. **Importazione Deterministica delle Risorse Grafiche in Godot 4 Headless**:
   - Quando nuovi file grafici (PNG, JPEG, font TTF) vengono generati o posizionati esternamente nel repository, Godot richiede la generazione del rispettivo descrittore `.import` e della texture compilata in `.godot/imported/`.
   - Per garantire la corretta esecuzione headless ed evitare errori `No loader found for resource`, il comando CLI da eseguire prima del lancio delle suite è:
     `Godot_v4.7.2-stable_win64_console.exe --headless --editor --quit --path .`
   - Questo comando scansiona il filesystem, genera i metadati `.import` e chiude il processo con exit code 0.
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

10. **Pattern ModalRouter per la Scomposizione Modulare dei Controller di Schermata**:
    - Quando un'interfaccia grafica gestisce una molteplicità di finestre modali o sottomenu complessi (es. 19 modali nell'HUD), la gestione dei segnali, l'ascolto EventBus, la mutua esclusione atomica (`hide_all_modals()`), la visibilità del backdrop e il ripristino del focus devono essere delegati a una classe router dedicata (`ModalRouter extends RefCounted`).
    - Il controller di schermata mantiene forwarder trasparenti per non alterare l'API pubblica verso i test headless, riducendo le dimensioni del controller verso la soglia del Cancello 6 ($\le 250$ righe) e isolando le responsabilità di orchestrazione.

11. **Headless Dummy Audio Driver & ObjectDB Leak Prevention**:
    - In modalità headless, il driver audio dummy di Godot 4 non consuma campioni audio né avanza il mixer temporale; di conseguenza, la chiamata `AudioStreamPlayer.play()` instanzia un `AudioStreamPlaybackWAV` nel registro C++ dell'engine che non viene mai completato né deallocato, generando avvisi di memory leak (`ObjectDB instances leaked at exit`).
    - I sottosistemi di sonificazione devono proteggere l'invocazione di `play()` con la guardia `if DisplayServer.get_name() != "headless":`, consentendo la completa validazione headless di generazione stream in memoria, volumi sicuri e ducking a 0 ms senza sporcare il registro ObjectDB.
    - All'arresto dei suoni (`stop()`) e in `_exit_tree()`, reimpostare sempre `audio_player.stream = null` e invocare `AccessibilityManager.silence()` all'uscita delle suite di test.

12. **Pattern Gameplay Grafico 2.5D, Concentric Instances & Hitbox Clearance**:
    - **Concentric Instance Normalization (`[editable path="..."]` Discipline)**: Nelle scene istanziate modificate nell'editor visivo, tutti i nodi figli (`Sprite2D`, `TriggerShape`, `SolidShape`) devono mantenere offset locali concentrici o allineati alla base visiva rispetto alla radice del prop. Se la radice o i collider si disallineano, le collisioni fisiche e le aree di trigger si disaccoppiano dalla grafica.
    - **Hitbox Clearance Anti-Deadlock**: L'area di interazione (`TriggerShape` su `Area2D`) DEVE estendersi oltre la sagoma solida (`SolidShape` su `StaticBody2D`) di almeno 25–35 px su tutti i lati percorribili. Se `SolidShape` è pari o maggiore di `TriggerShape`, i piedi del personaggio collidono fisicamente con l'ostacolo prima di intersecare l'area di trigger, impedendo l'emissione di `body_entered` e bloccando l'interazione.
    - **Stand-Point Pattern per Auto-Walk**: La destinazione di movimento automatico (`walk_to_target`) non deve coincidere con la posizione globale del prop (spesso situata al centro dell'ostacolo solido). Ogni prop deve esporre un punto di stazionamento calcolato (`get_stand_position()` con `stand_offset`) situato nello spazio calpestabile antistante l'oggetto.
    - **Mouse Picking & Simmetria Universale (The Sims Foundation)**: Sfruttando `mouse_entered`, `mouse_exited` e `_input_event` sull'`Area2D`, gli utenti con mouse (Holy Diver) ottengono il cursore a manina (`CURSOR_POINTING_HAND`) e il click per auto-walk/interazione o menu contestuali futuri, mentre gli utenti con tastiera e screen reader (Luca) mantengono il 100% dell'operatività tramite navigazione diretta a tasti (Tab, Numpad, shortcut).

13. **Discipline di Layout e Padding: `content_margin` vs `expand_margin` in StyleBoxFlat**:
    - **Il Pericolo di `expand_margin`**: In Godot 4, l'uso di `expand_margin_*` su una risorsa `StyleBoxFlat` espande il rettangolo grafico renderizzato *fuori* dai confini geometrici del nodo `Control`. Questo altera la percezione visiva e crea sovrapposizioni o collisioni tra pannelli adiacenti che risultano invisibili al calcolo logico delle coordinate (`offset_*`), provocando sovrapposizioni parziali o artefatti di bordo.
    - **Il Canone di `content_margin`**: Per aggiungere padding interno a un `PanelContainer`, utilizzare tassativamente `content_margin_left`, `content_margin_top`, `content_margin_right` e `content_margin_bottom` sullo `StyleBoxFlat`. Questo approccio preserva la corrispondenza 1:1 tra coordinate del nodo e visuale, garantendo al contempo che i nodi figli ricevano il padding desiderato senza dover inserire nodi `MarginContainer` intermedi, proteggendo i percorsi `get_node()` da rotture.

14. **Disincaglio Sincrono dei Nodi (`remove_child + queue_free`) e Seam Zero-Regressione per Rigenerazioni UI Dinamiche e Test Headless a 0 ms**:
    - **Disincaglio Dinamico Sincrono**: Quando un container UI (`VBoxContainer`, `HBoxContainer`, `GridContainer`) viene svuotato per ricostruire un elenco (es. rami delle competenze, tracce musicali, contratti discografici), il solo metodo `queue_free()` non altera `get_child_count()` nello stesso frame di esecuzione poiché la distruzione viene accodata a fine frame. L'invocazione preventiva di `container.remove_child(child)` prima di `child.queue_free()` scollega istantaneamente il nodo dall'albero, garantendo determinismo atomico sia nei test headless a 0 ms sia in caso di selezioni rapide da tastiera.
    - **Seam Zero-Regressione nella Ristrutturazione di Scene Storiche**: Nel refactoring di un'interfaccia preesistente (es. `character_sheet.tscn`) da schermata unica a struttura multi-tab, mantenere intatta la gerarchia dei nodi del Tab 1 primario (es. `PanelMain/VBox/HBoxBody`) e inserire il Tab 2 come fratello opzionale (`PanelTabSkills`), anziché alterare i percorsi assoluti. Questo preserva al 100% le suite di test di integrazione legacy (es. `test_vertical_slice.gd`) che interrogano nodi specifici, prevenendo modifiche a cascata e salvaguardando la regressione verde.

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
