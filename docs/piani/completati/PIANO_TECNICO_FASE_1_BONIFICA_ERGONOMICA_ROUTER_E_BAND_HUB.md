# World-tour — Piano Tecnico Formale: Bonifica Ergonomica, Allineamento Router, Prove in BandHub & Potatura Legacy SongCreator (Fase 1 — Sotto-Fase 1A)
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Versione Target: AVF V5.9.1 — Bonifica Ergonomica, Allineamento Router & Rehearsals in BandHub
# Data: 26 Settembre 2026
# Percorso File: docs/piani/attivi/PIANO_TECNICO_FASE_1_BONIFICA_ERGONOMICA_ROUTER_E_BAND_HUB.md
# Baseline AVF: V5.9.0 (33/33 Suite Headless Superate a 0 Errori e 0 ms)
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Sotto-Fase 1B completata e convalidata con 33/33 suite headless verdi a 0 ms)

---

## 🎯 1. OBIETTIVO ARCHITETTURALE E VISIONE GENERALE

Questo piano tecnico formalizza la **Macro-Fase 1** del programma di revisione sistemica e allineamento a Popomundo, focalizzandosi sulla **bonifica ergonomica, allineamento del router e potatura dei rami secchi legacy**:
1. Risolvere la discrepanza tra click del mouse su Dock 4 (`BtnDockTools`) e la pressione del tasto `4` / `KEY_KP_4`, garantendo che entrambi aprano coerentemente `SocialModal` ("Social & Fanbase");
2. Ricollocare l'azione cruciale delle prove della band (`hold_rehearsal_session`) direttamente all'interno di `BandHub` con tasto rapido dedicato `P` ed esito vocale immediato su chimica, rispetto e padronanza live delle canzoni in repertorio (+15%), rimuovendo il pulsante fuori contesto da `UpgradesModal`;
3. Bonificare i residui storici di `open_modal_by_prop_id` in `ApartmentHud`, eliminando l'assegnazione arbitraria di risorse forfettarie a costo zero;
4. Potare definitivamente da `SongCreator` (Scheda 3) il pulsante "Produci Tutto (65 Energia)" e i bottoni di composizione/scrittura a 1-click, riservando la Scheda 3 esclusivamente all'incisione e masterizzazione delle tracce giunte al 100% e rifinite;
5. Mantenere l'integrità deterministica di tutte le 33 suite headless di test a 0 ms.

---

## 🏛️ 2. CHECKLIST DI CONVALIDA A 3 STATI (MATRICE PER NVDA)

- [x] [CONVALIDATO CON SUCCESSO] Contratto D0: Allineamento Dock 4 vs Tastiera (`BtnDockTools` -> `SocialModal`), aggiornamento tooltip in `apartment_hud.tscn` e allineamento asserzione di verifica in `test_apartment_gameplay.gd`.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D1: Integrazione Prove Band in `BandHub` (`btn_rehearse`, shortcut `KEY_P`, feedback sonoro, vocalizzazione NVDA su chimica e padronanza brani).
- [x] [CONVALIDATO CON SUCCESSO] Contratto D2: Bonifica Residui `open_modal_by_prop_id` in `ApartmentHud` (eliminazione delta fisiologici forfettari e deleghe pulite).
- [x] [CONVALIDATO CON SUCCESSO] Contratto D3: Potatura Pipeline Legacy a 4 Stadi in `SongCreator` Scheda 3 (occultamento "Produci Tutto" e pulsanti sequenziali 1-click; focus esclusivo su Home Studio vs Pro Studio per brani pronti in `RECORDING` con shortcut `I`).
- [x] [CONVALIDATO CON SUCCESSO] Contratto D4: Verifica globale con `tools/check.ps1` (119 file GDScript senza errori) e `tools/test.ps1` (33/33 suite headless verdi a 0 ms), aggiornamento Living Documentation e avanzamento AVF a `V5.9.1`.

---

## ⚖️ 3. I 7 ASSI DI QUALITÀ ASTRALIS APPLICATI

- **Asse 1 — Validità**: Piena correttezza dei tipi GDScript 2.0 statici, conformità delle firme di segnale e risoluzione sicura dei nodi UI con guardie `get_node_or_null()`.
- **Asse 2 — Efficacia**: Eliminazione totale delle discrepanze tra interazione mouse e tastiera; posizionamento logico e naturale delle prove musicali dove risiede la band.
- **Asse 3 — Coerenza**: Armonia con la Clean Architecture e con il Canone della Singola Fonte di Verità (nessuna modale assegna risorse aggirando i sistemi di dominio).
- **Asse 4 — Completezza**: Copertura di tutti i casi d'uso (click mouse su dock, tastiera standard, tastierino numerico, prove con/senza band attiva, prove con sanzione disturbo quiete pubblica).
- **Asse 5 — Precisione**: Interventi chirurgici sui controlli UI senza alterare le interfacce pubbliche dei sistemi sottostanti (`BandSystem`, `MusicSystem`).
- **Asse 6 — Affidabilità & Prestazioni**: Determinismo a 0 ms nei test headless; zero allocazioni cicliche o timer fisici bloccanti.
- **Asse 7 — Assenza Regressioni**: Mantenimento al 100% verde di tutte le 33 suite di test del progetto.

---

## 🔬 4. I 3 LIVELLI DI SIMULAZIONE PREVENTIVA

1. **Livello 1: Happy Path**:
   - L'utente preme il tasto `4` o clicca sul quarto pulsante del dock: in entrambi i casi si apre `SocialModal`.
   - L'utente apre `BandHub` (tasto `5` o `B`), preme `P` o clicca "Fai le Prove": le prove vengono eseguite, l'energia cala, la chimica migliora, la padronanza live delle canzoni sale del 15% e NVDA annuncia i dettagli.
   - L'utente apre `SongCreator`: la Scheda 3 consente l'incisione solo se il brano è nello stadio `RECORDING`.
2. **Livello 2: Flussi Alternativi e Concorrenti**:
   - L'utente preme `P` in `BandHub` quando non ha membri nella band: il sistema intercetta la condizione con eleganza ed emette il messaggio vocale *"Non hai ancora una band con cui provare. Recluta prima dei musicisti!"*, senza consumare energia.
   - L'utente apre `SongCreator` con una bozza ancora al 50%: la Scheda 3 segnala chiaramente che il brano deve prima essere completato e rifinito.
3. **Livello 3: Corner Cases & Robustezza**:
   - Energia insufficiente durante la pressione di `P` in `BandHub`: guardia preventiva e messaggio vocale chiaro.
   - Interazione con gli arredi del Loft: zero assegnazioni indebite di energia o morale tramite vecchi rami di `open_modal_by_prop_id`.

---

## 📐 5. SPECIFICA TECNICA DEI CONTRATTI ATOMICI (D0..D4)

### Contratto D0 — Allineamento Dock 4 vs Tastiera (`SocialModal`)
- **Modifica a `ui/apartment_hud/apartment_hud.gd`**:
  - Nel metodo `_on_dock_tools_pressed()`, sostituire:
    ```gdscript
    func _on_dock_tools_pressed() -> void:
        open_modal(social_modal)
    ```
- **Modifica a `ui/apartment_hud/apartment_hud.tscn`**:
  - Su `BtnDockTools`: aggiornare `tooltip_text` in `"Social & Fanbase (Tasto 4)"`.
- **Modifica a `tests/test_apartment_gameplay.gd`**:
  - A riga 264, aggiornare l'asserzione:
    ```gdscript
    if hud.btn_dock_tools:
        hud.btn_dock_tools.pressed.emit()
        assert_true(hud.social_modal.visible, "BtnDockTools apre SocialModal")
        hud.hide_all_modals()
    ```

### Contratto D1 — Ricollocazione Prove Band in `BandHub`
- **Modifica a `ui/band/band_hub.tscn`**:
  - In `PanelMain/VBox/HBoxBottom`, inserire un pulsante prima di `BtnClose`:
    - Nome nodo: `BtnRehearse`
    - Testo: `"Fai le Prove (Tasto P)"`
    - Custom minimum size: `Vector2(180, 40)`
    - Focus mode: `FocusMode.ALL`
- **Modifica a `ui/band/band_hub.gd`**:
  - Riferimento `@onready var btn_rehearse: Button = $PanelMain/VBox/HBoxBottom/BtnRehearse` (con risoluzione in `_resolve_nodes()`);
  - Connessione in `_ready()`: `btn_rehearse.pressed.connect(_on_rehearse_pressed)`;
  - Mappatura tasto in `_unhandled_input`:
    ```gdscript
    elif event.keycode == KEY_P:
        _on_rehearse_pressed()
        get_viewport().set_input_as_handled()
    ```
  - Metodo `_on_rehearse_pressed()`:
    ```gdscript
    func _on_rehearse_pressed() -> void:
        if not GameManager or not GameManager.band_system:
            return
        var res: Dictionary = GameManager.band_system.hold_rehearsal_session(true)
        if res.get("success", false):
            refresh_hub()
            AccessibilityManager.announce("Sessione di prove completata! Chimica e affinità migliorate, padronanza live delle canzoni in repertorio +15%.", true)
        else:
            AccessibilityManager.announce(res.get("message", "Impossibile svolgere le prove."), true)
    ```
  - Gancio accessibilità in `_setup_accessibility_hooks()`:
    `AccessibilityManager.hook_control_accessibility(btn_rehearse, "Fai le Prove con la Band", "Consuma energia, riduce la tensione della band, migliora l'affinità e incrementa la padronanza live delle canzoni del 15% (Tasto P).")`
- **Modifica a `ui/upgrades/upgrades_modal.gd` e `.tscn`**:
  - Disattivare o rimuovere il pulsante ridondante `BtnRehearse` nella scheda Sala Prove, sostituendolo con un testo descrittivo chiaro.

### Contratto D2 — Bonifica Residui `open_modal_by_prop_id` in `ApartmentHud`
- **Modifica a `ui/apartment_hud/apartment_hud.gd`**:
  - Sostituire le assegnazioni dirette forfettarie di risorse in `open_modal_by_prop_id`:
    - Rimuovere le assegnazioni `GameManager.player_data.energy += 15`, `stress -= 12`, `morale += 20` che scavalcavano il tempo reale e `ActionSystem`;
    - Il metodo delega pulitamente all'apertura delle modali pertinenti se richieste, senza produrre alterazioni fisiologiche non autorizzate.

### Contratto D3 — Potatura Pipeline Legacy in `SongCreator` Scheda 3
- **Modifica a `ui/music/song_creator.tscn`**:
  - Rimuovere il pulsante `BtnProduceAll` ("Produci Tutto");
  - Riconfigurare `BtnAction` come unico pulsante di registrazione: `BtnRecordMaster` ("Incidi e Finalizza Master");
  - Rimuovere `ChkBurst` da Scheda 3 (il guizzo artistico è ora gestito dal Colpo d'Ala nella Finestra Arancione).
- **Modifica a `ui/music/song_creator.gd`**:
  - Rimuovere i rami legacy `_on_btn_produce_all_pressed()` e la progressione a stadi `Enums.SongStage.CONCEPT`, `COMPOSITION`, `SONGWRITING`;
  - Scheda 3 mostra:
    - Se `current_song.stage == Enums.SongStage.RECORDING`:
      - Stato: *"Traccia completata e rifinita. Pronta per l'incisione e master."*
      - Selettore: Home Studio vs Studio Professionale (50 € con sconto martedì);
      - Pulsante *"Incidi e Finalizza Master"*: invoca in sequenza `record_tracks(current_song, use_pro)` e `mix_and_master(current_song)`.
    - Se `current_song.stage != Enums.SongStage.RECORDING`:
      - Segnalazione chiara per NVDA: *"Questa traccia è ancora in fase di scrittura. Completa prima le barre di musica e testo al 100% e la rifinitura."*

### Contratto D4 — Verifica Globale & Living Documentation
- Esecuzione `tools/check.ps1` per la validazione di tutti i file GDScript;
- Esecuzione `tools/test.ps1` per verificare il superamento delle 33 suite headless a 0 ms;
- Aggiornamento di `docs/todo.md`, `CHANGELOG.md` e archiviazione del piano in `docs/piani/completati/`.

---

## 🛑 STOP OBBLIGATORIO — GATING FASE 1A
La redazione della Sotto-Fase 1A è completata. È fatto divieto assoluto di toccare file di codice o configurazioni prima dell'esplicita conferma di Luca (*"procedi con l'implementazione"* / *"applica la fase 1"*).
