# Rapporto di Analisi Diagnostica Profonda & Integrità Sistemica
# Progetto: World-tour (Music Career & Life Simulator)
# Autore: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Data: 2026-09-24
# Versione di Riferimento: AVF V5.2.0
# Percorso: docs/report/ANALISI_DIAGNOSTICA_SISTEMA_V5.2.md
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)

---

## 1. INTRODUZIONE ED OBIETTIVI DELL'ANALISI

La presente analisi diagnostica profonda è stata condotta sull'intero repository di **World-tour** per verificare:
1. **Incoerenze e Anomalie**: Discrepanze di logica, configurazione, UID, risorse e documentazione;
2. **Malfunzionamenti e Conflitti Latenti**: Sovrapposizioni di tasti rapidi, leak di memoria ed eccezioni silenti;
3. **Integrità Sistemica e Modulare**: Rispetto dei confini Clean Architecture DDD, disaccoppiamento EventBus e persistenza;
4. **Efficacia ed Estendibilità**: Capacità del codice di accogliere future espansioni senza accumulo di debito tecnico;
5. **Accessibilità Vocale & Zero Mouse**: Conformità assoluta con l'interazione da tastiera e sintesi vocale NVDA.

---

## 2. QUADRO DELLA SITUAZIONE ATTUALE (BASELINE OPERATIVA)

- **Test Suite Headless**: 28 suite su 28 superate al 100% con 0 errori a 0 ms (`tools/test.ps1`).
- **Verifica Sintattica e Compilazione**: 104 file GDScript compilati con 0 errori (`tools/check.ps1`).
- **Zero Mouse Compliance**: 0 riferimenti a eventi mouse nel codice sorgente; 100% operatività da tastiera.
- **Disciplina dei Tipi (Type Safety)**: 100% delle funzioni del progetto dotate di type hint esplicito di ritorno.
- **Sincronizzazione I18N (Localizzazione)**:
  - 291 chiavi perfettamente speculari tra `localization/it.json` ed `localization/en.json`;
  - 237 chiavi statiche `tr()` nel codice tutte coperte al 100%, 0 chiavi mancanti, 0 stringhe vuote.
- **Sound Design & Volumi Sicuri**: Volume lineare congelato a `0.75f` (-2.5 dB) e ducking automatico al 40% durante la voce di NVDA.

---

## 3. ANOMALIE ED INCOERENZE IDENTIFICATE (DETTAGLIO TECNICO)

### 🔴 Anomalia 1 (Critica): Conflitto di Tasti Rapidi e Shadowing tra Autoload (`AccessibilityManager`) e Scena (`HUD`)
- **Descrizione**: Sia `autoload/accessibility_manager.gd` che `ui/hud/hud.gd` gestiscono gli eventi da tastiera in `_unhandled_input(event)`.
- **Dettaglio Conflitti**:
  - `KEY_1`, `KEY_2`, `KEY_3`: In `AccessibilityManager` regolano la velocità di simulazione (1x, 2x, 5x); in `HUD` selezionano le Macro-Aree 1, 2, 3.
  - `KEY_T`: In `AccessibilityManager` annuncia vocalmente l'orario; in `HUD` cicla la velocità di gioco (`btn_speed`).
  - `KEY_R`: In `AccessibilityManager` annuncia la triade risorse; in `HUD` apre la `RelaxModal`.
  - `KEY_K`: In `AccessibilityManager` annuncia lo status di carriera; in `HUD` apre `IndustryHub`.
  - `KEY_P`: In `AccessibilityManager` attiva/disattiva la pausa; in `HUD` apre `AlbumCreator`.
- **Causa Radice**: In `AccessibilityManager` sono rimaste registrate le scorciatoie storiche delle Fasi 2 e 2.5, che nelle Fasi 6–9 sono state riassegnate nell'HUD. Poiché l'HUD intercetta gli input e invoca `set_input_as_handled()`, i blocchi in `AccessibilityManager` rimangono codice morto (*shadowed*) oppure entrano in conflitto non deterministico a seconda dell'ordine di ricezione.
- **Impatto**: Confusione funzionale, potenziale disorientamento per Luca con NVDA e violazione del principio *Clean Sweep*.
- **Azione Correttiva Proposta**: Bonificare `AccessibilityManager._unhandled_input` rimuovendo i binding ridondanti, delegando la gestione delle scorciatoie unicamente all'HUD o a un router di input dedicato, preservando in `AccessibilityManager` solo i comandi globali di emergenza (Numpad Navigation e silenziamento).

---

### 🟡 Anomalia 2 (Avviso Engine): Mismatch di UID (`ext_resource`) nei File Scena `.tscn`
- **Descrizione**: Durante il caricamento delle scene, Godot emette avvisi del tipo:
  `WARNING: ... ext_resource, invalid UID: ... using text path instead: ...`
- **File Coinvolti**:
  1. `ui/system_menu/system_menu_modal.tscn`: riferisce `uid="uid://c5q3menu89xyz"`, mentre `system_menu_modal.gd.uid` è `uid://d3rjqtlnu71rk`.
  2. `ui/upgrades/upgrades_modal.tscn`: riferisce `uid="uid://df67upgradewt01"`, mentre `upgrades_modal.gd.uid` è `uid://b72cn1ikjbwsm`.
  3. `tests/test_v5_ui_overhaul.tscn`: riferisce `uid="uid://bv5uioverhaul01"`, mentre `test_v5_ui_overhaul.gd.uid` è `uid://dd1xjhs7gr88v`.
  4. `tests/test_upgrades_system.tscn`: riferisce `uid="uid://cf87testupgradwt01"`, mentre `test_upgrades_system.gd.uid` è `uid://witt06asvvn1`.
  5. `tests/test_ui_audio_and_numpad_system.tscn`: riferisce `uid="uid://bv5audnumpad01"`, mentre `test_ui_audio_and_numpad_system.gd.uid` è `uid://50xejq1dviqs`.
- **Causa Radice**: Assegnazione manuale di stringhe UID placeholder al momento della creazione rapida delle scene, non sincronizzate con gli UID deterministici generati dall'engine.
- **Impatto**: Nessun crash (Godot ricade correttamente sul path testuale), ma inquinamento dei log console con messaggi di warning.
- **Azione Correttiva Proposta**: Allineare gli attributi `uid` all'interno dei file `.tscn` con i rispettivi file `.gd.uid` registrati su disco.

---

### 🟡 Anomalia 3 (Ridondanza): Duplicazione del Blocco di Caricamento `ConcertSystem` in `SaveManager.gd`
- **Descrizione**: In `autoload/save_manager.gd`, all'interno del metodo `load_game()`:
  - Linee 132–137: istanziano e configurano `GameManager.concert_system`;
  - Linee 247–253: ripetono **esattamente lo stesso blocco** di codice per la seconda volta.
- **Causa Radice**: Sovrapposizione da merge incrementale durante l'estensione delle fasi senza revisione sintattica del blocco completo.
- **Impatto**: Esecuzione ridondante a runtime durante il caricamento della partita.
- **Azione Correttiva Proposta**: Eliminare il secondo blocco ridondante (linee 247–253).

---

### 🟡 Anomalia 4 (Igiene Memoria): Memory Leak in Test Exit (`AudioStreamPlaybackWAV`)
- **Descrizione**: Durante l'esecuzione verbosa della suite `test_v5_ui_overhaul.tscn`, Godot segnala:
  `WARNING: 2 ObjectDB instances were leaked at exit` (`AudioStreamWAV` e `AudioStreamPlaybackWAV`).
- **Causa Radice**: Quando una modale o un tab emette un audio cue, `audio_player.play()` avvia la riproduzione. Al termine immediato del test con `get_tree().quit(0)`, lo stream non è stato fermato con `audio_player.stop()` né dereferenziato (`audio_player.stream = null`), lasciando orfane le istanze nello stack C++ dell'audio server.
- **Impatto**: Nessun impatto a gioco avviato (il ciclo di vita dell'engine gestisce il release all'uscita), ma nei test automatici genera leak warnings.
- **Azione Correttiva Proposta**: Inserire una chiamata `AccessibilityManager.silence()` o `audio_cue_system.stop()` e azzeramento stream prima della chiusura delle suite di test.

---

### 🟡 Anomalia 5 (Residui Orfani): Directory Vuote in `ui/`
- **Descrizione**: Esistono due directory vuote nel filesystem:
  - `ui/menus/`
  - `ui/common/`
- **Causa Radice**: Strutture cartellari create nelle fasi preliminari e superate dall'architettura delle modali dedicate.
- **Impatto**: Rifiuto dei residui previsto dal Canone *Clean Sweep*.
- **Azione Correttiva Proposta**: Rimozione protetta delle due cartelle vuote previa approvazione esplicita.

---

### 🟡 Anomalia 6 (Disallineamento Documentale e Configurazione): Versionamento AVF
- **Descrizione**:
  - `project.godot`: riporta `config/version="1.0.0"`.
  - `CHANGELOG.md`: la sezione più recente è la V5.1.0 (manca la voce formale per V5.2.0 Endless Horizon / New Game+).
  - `docs/todo.md` e `GEMINI.md`: attestano la versione corrente a `V5.2.0`.
- **Causa Radice**: Mancata propagazione della release V5.2.0 in `project.godot` e in `CHANGELOG.md`.
- **Impatto**: Incoerenza tra metadati di build dell'eseguibile e Living Documentation.
- **Azione Correttiva Proposta**: Aggiornare `config/version="5.2.0"` in `project.godot` e documentare la release V5.2.0 in `CHANGELOG.md`.

---

### 🟠 Anomalia 7 (Debito Tecnico & Manutenibilità): Monoliti Architetturali e Router Oversized
- **Descrizione**: Il router principale dell'interfaccia (`ui/hud/hud.gd`) ha raggiunto le **1.037 righe di codice**.
- **Vincolo Violato**: Protocollo 12 (Cancello 6) — Budget Token & Anti-Bloat Normativo: *Router $\le 250$ righe*.
- **Altri file di dimensioni critiche**:
  - `systems/social_media_system.gd`: 1.001 righe;
  - `systems/festival_system.gd`: 972 righe;
  - `data/models/player_data.gd`: 912 righe;
  - `systems/industry_system.gd`: 872 righe;
  - `systems/tour_system.gd`: 819 righe;
  - `ui/upgrades/upgrades_modal.gd`: 758 righe.
- **Causa Radice**: In `hud.gd` convergono troppe responsabilità: gestione della Top Bar permanente, filtraggio delle Macro-Aree, instradamento di 16 modali, intercettazione di decine di scorciatoie da tastiera, ricezione di oltre 20 segnali EventBus e aggiornamento delle stringhe semantiche per NVDA.
- **Impatto sull'Estendibilità**: Aggiungere una diciassettesima finestra o una nuova meccanica richiede la modifica contemporanea di 6 punti differenti di `hud.gd`, aumentando la fragilità e il rischio di regressioni.

---

## 4. VERIFICA STRUTTURALE SISTEMICA & MODULARE

| Livello Architetturale | Componenti | Stato di Salute | Valutazione & Suggerimenti |
| :--- | :--- | :--- | :--- |
| **Core (Dominio Puro)** | `constants.gd`, `enums.gd`, `formulas.gd` | 🟢 Eccellente | Formule pure deterministiche, tipi enumerativi chiari, 0 accoppiamento. |
| **Data Models** | 23 modelli in `data/models/` | 🟢 Molto Buono | Ottima serializzazione to_dict/from_dict, deep copy su array e dizionari. |
| **Systems (Business Logic)** | 19 sistemi in `systems/` | 🟢 Molto Buono | Sistemi headless indipendenti da nodi grafici, testabili a 0 ms. Alcuni file sopra 800 righe. |
| **Autoload (Infrastruttura)** | `GameManager`, `EventBus`, `SaveManager`, `AccessibilityManager`, `LocalizationManager` | 🟡 Buono con Riserve | Necessaria pulizia scorciatoie in AccessibilityManager e fix ridondanza in SaveManager. |
| **UI Layer (AccessKit & Visual)** | HUD + 16 Modali | 🟡 Funzionale ma Monolitico | Elevata usabilità NVDA e Zero Mouse, ma `hud.gd` necessita di scomposizione modulare. |

---

## 5. PIANO DI INTERVENTO SUGGERITO (ROADMAP DI BONIFICA & ESTENDIBILITÀ)

Per garantire la massima efficacia, modularità ed estendibilità futura, si propone la seguente sequenza di interventi:

1. **Intervento 1 (Immediato — Igiene & Pulizia Zero Rischio)**:
   - Bonifica delle chiavi UID nei 5 file `.tscn` per eliminare i warning all'avvio;
   - Rimozione del blocco duplicato di `concert_system` in `SaveManager.gd`;
   - Eliminazione delle directory vuote `ui/menus/` e `ui/common/`;
   - Allineamento versione `5.2.0` in `project.godot` e aggiornamento di `CHANGELOG.md`.

2. **Intervento 2 (Architetturale — Disaccoppiamento Input & Scorciatoie)**:
   - Bonifica di `AccessibilityManager._unhandled_input`: rimuovere gli handler storici obsoleti (`1`, `2`, `3`, `T`, `R`, `K`, `P`), preservando esclusivamente le funzioni di accessibilità pura (Numpad Navigation e silenziamento audio);
   - Blindatura delle scorciatoie nell'HUD con documentazione esplicita della matrice tasti per evitare futuri conflitti.

3. **Intervento 3 (Strutturale — Scomposizione Modulare di `hud.gd`)**:
   - Scorporare la gestione delle 16 finestre modali in un controller dedicato (`ui/hud/modal_router.gd`, $\le 180$ righe), lasciando a `hud.gd` la sola orchestrazione della barra superiore e delle Macro-Aree.
   - Questo riporterà `hud.gd` all'interno dei limiti del Cancello 6 ($\le 250$ righe), rendendo l'aggiunta di nuove modali immediata ed isolata.

---

## 6. CONCLUSIONI

Il sistema **World-tour** presenta fondamenta architetturali straordinariamente solide:
- 100% dei test headless operativi a 0 ms;
- Rispetto rigoroso dell'accessibilità vocale e Zero Mouse per NVDA;
- Piena simmetria di localizzazione bilingue;
- Sound design sicuro e non invasivo.

Le anomalie riscontrate non causano crash immediati ma costituiscono debito tecnico latente (warning di engine, ridondanze, conflitti di scorciatoie e monolitismo del router UI). La loro risoluzione consentirà di blindare l'architettura in vista delle future espansioni.
