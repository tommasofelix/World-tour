# Piano Tecnico Operativo — Revisione Interazioni, Geometria e Accessibilità Loft NYC (ASTRALIS v3.0.7)
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-24
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Convalidato headless al 100% su 30/30 suite di test e approvato da Luca per commit e auto-apprendimento)
# File Piano: docs/piani/completati/PIANO_REVISIONE_INTERAZIONI_APPARTAMENTO.md
# Coordinatore Master: docs/todo.md

---

## 🎯 1. OBIETTIVO E PERIMETRO DELL'INTERVENTO

Risoluzione deterministica e sistematica delle 5 anomalie riscontrate nel gameplay grafico 2.5D dell'appartamento loft di New York:
1. **Punto 0 — Apertura anticipata del menu d'interazione da lontano**: Correzione del disallineamento geometrico dei nodi arredo in `apartment.tscn` e separazione tra arrivo effettivo e stallo da ostacoli in `player_alex.gd`.
2. **Punto 1 — Funzionamento del Letto**: Implementazione dei metodi mancanti in `time_system.gd` (`advance_to_next_period`, `trigger_sleep_now`) e gestione della scelta contestuale di riposo/sonno nell'HUD.
3. **Punto 2 — Interazioni fuori luogo**: Differenziazione contestuale delle azioni di Divano (relax domestico), Cucina (caffè espresso nel loft a costo zero) e Giradischi (sessione vinili da collezione e ispirazione), eliminando la generica `relax_modal` da bar/parco.
4. **Punto 3 — Stereo bistabile (Toggle On/Off)**: Implementazione dello stato a levetta per accendere e spegnere l'impianto audio con annunci e inspection box coerenti.
5. **Punto 4 — Rimozione pulsante fluttuante `[SPAZIO]`**: Bonifica del nodo `Prompt` da `interactive_prop.tscn` e del codice relativo in `interactive_prop.gd` (Contratto D0 Clean Sweep).

---

## 🛡️ 2. PROTOCOLLO 12 — I 6 CANCELLI INVIOLABILI (INNER CODEX)

- **Cancello 1 (Rifiuto Patching Euristico)**:
  - Coordinate fisiche e geometriche calcolate con precisione al pixel sul piano isometrico;
  - Nessun ritardo artificiale o timeout improprio; risoluzione alla radice dei nomi dei metodi temporali e degli stati.
- **Cancello 2 (Hardware Grounding & Zero Mouse)**:
  - 100% operativo da tastiera (Frecce, WASD, Numpad 8/2/4/6/7/9/1/3/5, Tab, Shift+Tab, Invio, Spazio, Esc);
  - Interazione speculare mouse e tastiera per Holy Diver senza dipendenze obbligatorie da mouse.
- **Cancello 3 (Hitbox, Clearance Continua & Volumi Sicuri)**:
  - Hitbox ai piedi del personaggio (Y-Sorting pulito);
  - Stand positions situate in aree libere da collisioni per evitare incastri;
  - Feedback sonori conformi al volume salvavita $\le 0.75\text{f}$ (-2.5 dB) con ducking acustico per NVDA.
- **Cancello 4 (Named Contracts D0..D5)**:
  - Scomposizione atomica delle modifiche in contratti indipendenti e verificabili.
- **Cancello 5 (Determinismo Headless)**:
  - Test seams headless a 0 ms senza dipendenze temporali né `OS.delay()`.
- **Cancello 6 (Budget Token & Anti-Bloat Normativo)**:
  - Nessuna duplicazione di logiche; codici snelli e formattazione lineare sequenziale.

---

## 📐 3. SCOMPOSIZIONE ATOMICA IN NAMED CONTRACTS

### 🧹 CONTRATTO D0: Clean Sweep & Bonifica Prompt Fluttuante `[SPAZIO]`
- [x] [CONVALIDATO CON SUCCESSO] **Rimozione nodo `Prompt` in `scenes/apartment/interactive_prop.tscn`**:
  * Eliminazione del sotto-albero `Prompt` contenente la label `[SPAZIO]`.
- [x] [CONVALIDATO CON SUCCESSO] **Bonifica codice in `scenes/apartment/interactive_prop.gd`**:
  * Rimozione della variabile `_prompt_node: CanvasItem`;
  * Rimozione dei comandi di visibilità in `_ready()`, `_on_body_entered()`, `_on_body_exited()` e `set_highlight()`;
  * La segnalazione per utenti normovedenti resta affidata all'evidenziazione luminosa dello sprite (`_sprite_node.modulate`), mentre per Luca l'accessibilità vocale è garantita dall'Inspection Box dell'HUD e da NVDA.

### 📐 CONTRATTO D1: Riallineamento Geometrico Arredi & Stand Position in `apartment.tscn`
- [x] [CONVALIDATO CON SUCCESSO] **Riallineamento delle origini dei nodi `InteractiveProp`**:
  * Calcolo e riposizionamento della coordinata radice `position` di ogni arredo per farla coincidere con la base d'appoggio sul pavimento;
  * Azzeramento degli offset interni anomali su `Sprite2D`, `TriggerShape` e `StaticBody2D` per:
    - `PropArcade`: radice centrata alla base del cabinato (`X=540, Y=-50`), forme locali centrate;
    - `PropToolbox`: radice centrata alla cassa attrezzi (`X=585, Y=-10`), forme locali centrate;
    - `PropBed`: radice centrata alla base del letto (`X=300, Y=-10`), forme locali centrate;
    - `PropWardrobe`: radice centrata all'armadio (`X=440, Y=-90`), forme locali centrate;
    - `PropKitchen`: radice centrata al banco cucina (`X=45, Y=-80`), forme locali centrate;
    - `PropCouch`: radice centrata al divano (`X=-192, Y=-75`), forme locali centrate;
    - `PropTurntable`: radice centrata al mobile giradischi (`X=-310, Y=-35`), forme locali centrate.
- [x] [CONVALIDATO CON SUCCESSO] **Definizione coordinate `stand_offset` frontali libere da ostacoli**:
  * Configurazione per ogni arredo di un punto calpestabile accessibile davanti all'oggetto, all'esterno della sua `SolidShape`, così che l'auto-walk arrivi perfettamente di fronte all'arredo.
- [x] [CONVALIDATO CON SUCCESSO] **Correzione guardia di prossimità in `apartment.gd`**:
  * In `_on_prop_clicked(prop)`: verifica della vicinanza basata sul raggio effettivo di trigger `prop.is_player_in_range` o sulla distanza dalla base reale dell'arredo, eliminando falsi positivi da posizioni disallineate.

### 🚶 CONTRATTO D2: Robustezza Auto-Walk & Protezione da Stallo in `player_alex.gd`
- [x] [CONVALIDATO CON SUCCESSO] **Separazione logica tra Arrivo Effettivo e Stallo da Ostacolo**:
  * In `_process_auto_walk(delta)`:
    - Se `dist <= 24.0` o `target_prop.is_player_in_range`: Alex è giunto a destinazione. Arresta il movimento, passa ad animazione `idle` ed esegui la callback `_auto_walk_callback.call()`.
    - Se `_stuck_timer > 0.6` oppure `_auto_walk_timer >= AUTO_WALK_MAX_DURATION`: Alex è rimasto bloccato contro un ostacolo o il tempo massimo è scaduto. Arresta il movimento, passa ad `idle` e **NON eseguire la callback di apertura menu**.
    - Emetti un avviso sonoro discreto e annuncio vocale per NVDA: *"Percorso bloccato. Avvicinati manualmente con i tasti di movimento."*.
- [x] [CONVALIDATO CON SUCCESSO] **Rilascio immediato su input manuale**:
  * Se il giocatore preme qualsiasi tasto direzionale (Frecce, WASD, Numpad) o Esc durante l'auto-walk, il cammino assistito si annulla istantaneamente e il controllo torna al 100% manuale.

### ⏰ CONTRATTO D3: Riparazione Interazione Letto & Metodi Temporali
- [x] [CONVALIDATO CON SUCCESSO] **Wrapper di compatibilità in `systems/time_system.gd`**:
  * Aggiunta metodo `advance_to_next_period() -> bool`: richiama deterministicamente `skip_to_next_period()`;
  * Aggiunta metodo `trigger_sleep_now() -> void`: richiama deterministicamente `sleep_early()`.
- [x] [CONVALIDATO CON SUCCESSO] **Gestione accessibile dell'interazione Letto in `ui/apartment_hud/apartment_hud.gd`**:
  * In `open_modal_by_prop_id("bed")`:
    - Se `calendar_data.current_period == Enums.TimePeriod.NIGHT`: avvio immediato del sonno notturno (`sleep_early()`) con annuncio vocale *"È notte fonda. Buonanotte fino a domani mattina alle 06:00."*.
    - Se periodo diurno (`MORNING`, `AFTERNOON`, `EVENING`): mostrare nell'Inspection Box e annunciare con NVDA la scelta chiara:
      *"Letto del Loft. Premi Z per dormire fino a domani mattina, X per riposare fino alla fascia successiva, oppure Esc per annullare."*.
- [x] [CONVALIDATO CON SUCCESSO] **Allineamento tasti rapidi in `scenes/apartment/apartment.gd`**:
  * Convalida dei tasti `Z` (Dormi anticipato) e `X` (Avanza fascia oraria) collegati ai metodi corretti di `GameManager.time_system`.

### 🛋️ CONTRATTO D4: Differenziazione Interazioni Domestiche & Stereo Toggle
- [x] [CONVALIDATO CON SUCCESSO] **Interazione specifica Divano (`couch`)**:
  * Rimozione dell'apertura di `relax_modal`;
  * Esecuzione immediata dell'azione domestica di relax:
    - Recupero: -12 Stress, +5 Morale, +5 Energia;
    - Annuncio NVDA: *"Ti sei disteso sul divano a riposare. Tensione e stress diminuiti."*;
    - Audio cue: `AccessibilityManager.play_cue(Enums.AudioCueType.AREA_PERSONAL)`;
    - Aggiornamento Inspection Box: *"Ti rilassi sul divano vissuto del loft. Tensione allentata e mente rigenerata!"*.
- [x] [CONVALIDATO CON SUCCESSO] **Interazione specifica Cucina (`kitchen`)**:
  * Rimozione dell'apertura di `relax_modal`;
  * Esecuzione dell'azione espresso domestico:
    - Recupero: +15 Energia, -5 Stress, 0 € di costo (espresso fatto in casa);
    - Annuncio NVDA: *"Espresso bollente preparato nella cucina del loft. Energia ripristinata!"*;
    - Audio cue: `AccessibilityManager.play_cue(Enums.AudioCueType.AREA_PERSONAL)`.
- [x] [CONVALIDATO CON SUCCESSO] **Interazione specifica Giradischi (`turntable`)**:
  * Rimozione dell'apertura di `relax_modal`;
  * Esecuzione dell'ascolto vinili da collezione:
    - Effetti: +20 Morale, -10 Stress, 35% di probabilità di guadagnare Scintilla Creativa (Ispirazione brani);
    - Annuncio NVDA dedicato e cue `AREA_CREATION`.
- [x] [CONVALIDATO CON SUCCESSO] **Gestione bistabile Stereo (Toggle On/Off)**:
  * Aggiunta variabile `var is_stereo_on: bool = false` in `ApartmentHud`;
  * Logica di attivazione:
    - Se `not is_stereo_on`: imposta `is_stereo_on = true`, applica +5 morale / -5 stress, riproduci cue audio `AREA_PERSONAL`, annuncio vocale: *"Stereo acceso. Riff rock in diffusione nello studio."*, inspection box: *"Stereo acceso! I riff rock riempiono la stanza, allontanando lo stress. Premi di nuovo per spegnere."*.
    - Se `is_stereo_on`: imposta `is_stereo_on = false`, arresta la diffusione, annuncio vocale: *"Stereo spento. Silenzio ripristinato nello studio."*, inspection box: *"Stereo spento. La stanza torna in silenzio. Premi di nuovo per accendere."*.

### 🧪 CONTRATTO D5: Suite di Test Headless & Convalida Anti-Regressione
- [x] [CONVALIDATO CON SUCCESSO] **Aggiornamento suite `tests/test_apartment_gameplay.gd`**:
  * Test assenza nodo `Prompt` fluttuante;
  * Test coordinate allineate e calcolo `stand_position` per tutti i 10 arredi;
  * Test auto-walk con gestione stallo (nessuna apertura indebita se non in range);
  * Test metodi wrapper `TimeSystem` (`advance_to_next_period`, `trigger_sleep_now`);
  * Test interazione letto (comportamento Notte vs Giorno);
  * Test interazioni domestiche differenziate per divano, cucina, giradischi;
  * Test toggle bistabile dello stereo (Off -> On -> Off).
- [x] [CONVALIDATO CON SUCCESSO] **Esecuzione headless di tutte le suite di test con Godot 4.7.2** (30/30 suite superate al 100%, 0 errori a 0 ms).

---

## 🚦 4. REGOLA 0 & CHIUSURA DEFINITIVA

Tutti i contratti D0..D5 sono stati convalidati al 100% con test headless ed autorizzati da Luca.
Il piano è formalmente archiviato tra i piani completati.
