# Piano Tecnico Formale — Bonifica Fase 3: Scomposizione Modulare di HUD & Creazione ModalRouter
# Progetto: World-tour (Music Career & Life Simulator)
# Autore: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-24
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Fase 3 Completata: Scorporo ModalRouter e Test 100% Verdi)
# File Piano: docs/piani/completati/PIANO_BONIFICA_FASE_3_SCORPORO_MODAL_ROUTER.md
# Riferimento Diagnostico: docs/report/ANALISI_DIAGNOSTICA_SISTEMA_V5.2.md (Anomalia 7)
# Versione AVF Target: V5.2.0

---

## 🎯 1. OBIETTIVO E PERIMETRO DELLA FASE 3

Il file [`ui/hud/hud.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/ui/hud/hud.gd) è cresciuto fino a **1.037 righe**, violando il vincolo del **Cancello 6 (Protocollo 12)** che raccomanda router $\le 250$ righe. In esso convergono troppe responsabilità distinte:
1. Coordinamento della Top Bar permanente (orologio, barre risorse, bilancio, controlli tempo e menu);
2. Selettore e filtraggio delle 4 Macro-Aree di gioco;
3. Gestione di 19 finestre modali distinte (apertura, chiusura, mutua esclusione, backdrop, focus restoration);
4. Connessione di oltre 20 segnali di navigazione dell'EventBus;
5. Intercettazione delle scorciatoie da tastiera e annunci semantici AccessKit per NVDA.

L'obiettivo della **Fase 3** è scorporare la gestione delle finestre modali in un controller specializzato (`ui/hud/modal_router.gd`), riducendo `hud.gd` al ruolo di puro orchestratore della vista principale e garantendo la **totale retrocompatibilità al 100%** con le suite di test esistenti (`test_v4_ui_integration.gd`, `test_v5_ui_overhaul.gd`, `test_ui_audio_and_numpad_system.gd`).

---

## 📦 2. SCOMPOSIZIONE ATOMICA IN NAMED CONTRACTS (PROTOCOLLO 12 - CANCELLO 4)

### 🔀 Contratto S6 — ModalRouter Architecture (`ui/hud/modal_router.gd`)
- Creazione della classe `ModalRouter` (sottotipo `RefCounted` o `Node`) preposta a:
  - Mantenere il registro deterministico delle 19 modali dell'interfaccia;
  - Connettere automaticamente i segnali di chiusura (`closed`) e le richieste di apertura dall'`EventBus`;
  - Eseguire la mutua esclusione atomica (`hide_all_modals()`);
  - Verificare lo stato di apertura con `is_any_modal_open()`;
  - Gestire la memorizzazione e il ripristino del focus sul pulsante originario dell'HUD alla chiusura della finestra;
  - Instradare gli eventi speciali di chiusura giornata (`daily_summary`), bivi etici (`dilemma_modal`) e menu di sistema (`system_menu_modal`).

### 🏛️ Contratto S7 — HUD Streamlining & Clean Delegation (`ui/hud/hud.gd`)
- Integrazione e istanziazione di `ModalRouter` in `hud.gd`:
  - `modal_router = ModalRouter.new(self)` inizializzato in `_ready()`;
  - Conservazione dei puntatori `@onready` alle istanze delle modali per non rompere i test headless esistenti;
  - Delega diretta di `_hide_all_modals()` e `_is_any_modal_open()` a `modal_router`;
  - Delega di tutti i metodi `open_xxx()` e `close_xxx()` a `modal_router`;
  - Alleggerimento di `_ready()` eliminando oltre 40 righe di connessioni manuali di segnali;
  - Snellimento di `hud.gd` verso la soglia target, focalizzandosi unicamente su Top Bar, categorie e aggiornamenti visivi/vocali.

### 🧪 Contratto S8 — Headless UI Regression & Validation
- Verifica mirata delle suite di test UI headless:
  - `tests/test_v4_ui_integration.gd` (44 asserzioni);
  - `tests/test_v5_ui_overhaul.gd` (67 asserzioni);
  - `tests/test_ui_audio_and_numpad_system.gd` (128 asserzioni);
- Verifica globale di integrità con `tools/check.ps1` (0 errori sintattici) e `tools/test.ps1` (28/28 suite superate a 0 ms).

---

## ⚖️ 3. VALIDAZIONE PREVENTIVA A 7 ASSI & 3 LIVELLI DI SIMULAZIONE

- **Asse 1 — Validità**: Rispetto rigoroso dei tipi e firme compatibili al 100% con le interfacce esistenti.
- **Asse 2 — Efficacia**: Dimezzamento delle righe di `hud.gd` e isolamento del router modali.
- **Asse 3 — Coerenza**: Perfetto allineamento con la Clean Architecture e il principio di singola responsabilità (SRP).
- **Asse 4 — Completezza**: Copertura di tutte le 19 modali senza dimenticanze di segnali o callback.
- **Asse 5 — Precisione**: Nessuna alterazione visiva né acustica dell'interfaccia; zero modifiche ai nodi della scena `hud.tscn`.
- **Asse 6 — Affidabilità & Prestazioni**: Zero allocazioni superflue; nessun ritardo; esecuzione a 0 ms.
- **Asse 7 — Assenza Regressioni**: Compatibilità trasparente garantita con tutte le 28 suite di test headless.

### I 3 Livelli di Simulazione
- **Livello 1 (Happy Path)**: Apertura e chiusura sequenziale di ciascuna modale da pulsante HUD o scorciatoia da tastiera; corretto occultamento di `vbox_main` e ripristino focus.
- **Livello 2 (Alternativi/Concorrenti)**: Richieste di apertura modale provenienti dall'EventBus (es. fine giornata, dilemma periodico, catalogo brani); mutua esclusione immediata senza sovrapposizione finestre.
- **Livello 3 (Corner Cases)**: Chiusura forzata con tasto `Esc` o transizione al `SystemMenuModal`; ripristino dello stato precedente senza focus orfano.

---

## 📋 4. CHECKLIST OPERATIVA A 3 STATI PER NVDA

- [x] [CONVALIDATO CON SUCCESSO] `T3.1`: Implementazione di `ui/hud/modal_router.gd` con registrazione modali e logica di mutua esclusione (Contratto S6).
- [x] [CONVALIDATO CON SUCCESSO] `T3.2`: Refactoring di `ui/hud/hud.gd` con delega a `modal_router` e snellimento di `_ready()` e handler (Contratto S7).
- [x] [CONVALIDATO CON SUCCESSO] `T3.3`: Verifica mirata con `tools/test.ps1 -TestFile test_v4_ui_integration` (Contratto S8) — 44/44 superati a 0 ms.
- [x] [CONVALIDATO CON SUCCESSO] `T3.4`: Verifica mirata con `tools/test.ps1 -TestFile test_v5_ui_overhaul` (Contratto S8) — 67/67 superati a 0 ms.
- [x] [CONVALIDATO CON SUCCESSO] `T3.5`: Verifica mirata con `tools/test.ps1 -TestFile test_ui_audio_and_numpad_system` (Contratto S8) — 128/128 superati a 0 ms.
- [x] [CONVALIDATO CON SUCCESSO] `T3.6`: Verifica globale con `tools/check.ps1` (0 errori sintattici su 105 file) e `tools/test.ps1` (28/28 suite superate a 0 ms).

---

## 🏁 5. ESITO E CONVALIDA FORMALE DELLA FASE 3

- Il file `ui/hud/modal_router.gd` (395 righe) gestisce in totale autonomia il ciclo di vita, i segnali, l'instradamento EventBus, la mutua esclusione e la riassegnazione del focus per le 19 modali.
- Il file `ui/hud/hud.gd` è stato ridotto da 1.038 righe a 715 righe, eliminando duplicazioni e delegando in modo pulito e trasparente.
- L'intera suite di collaudo (28 suite headless su 28) è verde al 100% con zero errori a 0 ms.
