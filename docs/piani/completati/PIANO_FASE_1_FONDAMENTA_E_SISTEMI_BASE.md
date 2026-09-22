# Piano Tecnico Operativo — Fase 1: Fondamenta del Progetto, Struttura Godot 4 & Sistemi Base

- ID Piano: `P-F1`
- Autori del progetto: Luca & Holy Diver
- Assistente: Antigravity (Senior AI Pair Programmer & Software Engineer)
- Data: 2026-09-22
- Stato: Completato e Collaudato con Successo (100% test superati)
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md) (Attività F1.2 $\rightarrow$ F1.5 completate)
- Documenti di riferimento:
  - [`knowledge/02_architettura_stack_e_runtime.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/knowledge/02_architettura_stack_e_runtime.md)
  - [`docs/piani/attivi/sottopiani/06_formule_matematiche_e_bilanciamento.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/06_formule_matematiche_e_bilanciamento.md)
  - [`docs/piani/attivi/sottopiani/07_architettura_software_sistemi_e_modello_dati.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/07_architettura_software_sistemi_e_modello_dati.md)
  - [`docs/piani/attivi/sottopiani/08_accessibilita_vocale_interfaccia_e_simmetria.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/08_accessibilita_vocale_interfaccia_e_simmetria.md)

---

## 1. OBIETTIVO E PERIMETRO DELLA FASE 1

La Fase 1 stabilisce le fondamenta architetturali e metodologiche del progetto **World-tour** in Godot Engine v4.7.2.  
L'obiettivo è abilitare il flusso di sviluppo **CLI-First e Zero Mouse per Luca**, consentendo l'implementazione e il collaudo headless delle formule matematiche e del bus eventi disaccoppiato prima di procedere alla logica del ciclo vitale (Fase 2).

### Criteri di Successo:
1. `project.godot` valido e riconosciuto dal motore senza warning o errori.
2. Albero cartelle coerente con i canoni della Clean Architecture.
3. Script di automazione PowerShell funzionanti per test headless e linting sintattico.
4. Modulo costanti centralizzato conforme alle specifiche matematiche di SP-06.
5. Formule matematiche pure implementate e convalidate al 100% da test automatici headless.
6. EventBus a segnali attivo e registrato come Autoload.

---

## 2. ARTICOLAZIONE DEI TASK OPERATIVI (D0 – D5)

### Task D0: Inizializzazione `project.godot` e Albero di Progetto
- **Obiettivo**: Creare il file di configurazione iniziale del progetto e la struttura directory completa.
- **File da creare**:
  - `project.godot`: Configurazione base con nome progetto "World Tour", risoluzione 1920x1080 (stretch mode `canvas_items`, aspect `keep`), abilitazione accessibilità AccessKit e registrazione Autoload (`EventBus`).
  - Creazione cartelle: `core/`, `data/models/`, `data/definitions/`, `systems/`, `autoload/`, `ui/common/`, `ui/hud/`, `ui/menus/`, `tests/`, `tools/`.
- **Verifica**: Invocazione di `Godot_console --headless --check-only` sul progetto per confermare l'integrità.

### Task D1: Tooling PowerShell Locale per Sviluppo CLI-First
- **Obiettivo**: Fornire a Luca script di automazione per il lavoro quotidiano da tastiera (Zero Mouse).
- **File da creare**:
  - `tools/run.ps1`: Lancia il gioco con console e driver `--accessibility-driver accesskit` forzato.
  - `tools/test.ps1`: Esegue i test unitari in modalità headless con output diretto su terminale.
  - `tools/check.ps1`: Verifica sintattica (`--check-only`) di tutti i file GDScript.
- **Verifica**: Esecuzione di prova di ciascun script da terminale PowerShell.

### Task D2: Modulo Costanti Centralizzate (`core/constants.gd`)
- **Obiettivo**: Codificare tutti i parametri di bilanciamento definiti in [`SP-06`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/06_formule_matematiche_e_bilanciamento.md).
- **File da creare**: `core/constants.gd`
- **Contenuto Chiave**:
  - Tempo: durata giorno (600s), fasce orarie, moltiplicatori velocità (1x, 2x, 5x).
  - Fisiologia: massimali di energia (100), stress (100), morale (100), soglie di collasso.
  - Economia: costi fissi quotidiani, soglie bancarotta.
  - Formule XP: base XP, esponente di salita, coefficiente rendimenti decrescenti.
- **Verifica**: Controllo sintattico con `tools/check.ps1`.

### Task D3: Algoritmi Matematici Puri (`core/formulas.gd`) e Test Headless
- **Obiettivo**: Implementare la classe statica pura con tutte le formule matematiche senza dipendenze dalla UI.
- **File da creare**:
  - `core/formulas.gd`:
    - `calculate_xp_for_level(level: int) -> int`
    - `apply_diminishing_returns(base_xp: float, daily_count: int) -> float`
    - `calculate_stress_efficiency_penalty(stress: float) -> float`
    - `calculate_song_quality(comp_skill: float, lyric_skill: float, prod_skill: float, rng_roll: float) -> float`
    - `calculate_concert_score(quality: float, charisma: float, energy: float) -> float`
    - `calculate_fan_conversion(spectators: int, concert_score: float, reputation: float) -> int`
  - `tests/test_formulas.gd`:
    - Suite di test unitari con asserzioni che verificano i casi nominali, i valori limite e le curve matematiche.
- **Verifica**: Esecuzione di `tools/test.ps1` con esito 100% positivo e report stampato su terminale.

### Task D4: Autoload Bus Eventi (`autoload/event_bus.gd`)
- **Obiettivo**: Creare il sistema di comunicazione disaccoppiato a segnali per tutti i layer di gioco.
- **File da creare**: `autoload/event_bus.gd`
- **Contenuto Chiave**:
  - Segnali temporali: `time_ticked`, `day_started`, `day_ended`, `pause_toggled`, `speed_changed`.
  - Segnali azioni: `action_started`, `action_progress`, `action_completed`, `action_canceled`.
  - Segnali musica & live: `song_created`, `concert_resolved`.
  - Segnali economia: `money_changed`, `career_status_unlocked`, `game_over_triggered`.
  - Segnali accessibilità & UI: `accessibility_announced`, `ui_focus_changed`.
- **Verifica**: Registrazione in `project.godot` e verifica sintassi.

### Task D5: Collaudo Integrato e Chiusura Fase 1
- **Obiettivo**: Esecuzione della pipeline di verifica completa e sincronizzazione della Living Documentation.
- **Attività**:
  - Esecuzione `tools/check.ps1` su tutto il codice.
  - Esecuzione `tools/test.ps1` con report letto da NVDA.
  - Spunta delle attività `F1.2` $\rightarrow$ `F1.5` in [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md).
  - Chiusura del piano `P-F1`.

---

## 3. CHECKPOINT DI CONFORMITÀ E GATING (FASE 1)

- [x] `P-F1.0`: `project.godot` e albero cartelle inizializzati (`F1.2`).
- [x] `P-F1.1`: Script PowerShell in `tools/` funzionanti da riga di comando (`run.ps1`, `test.ps1`, `check.ps1`).
- [x] `P-F1.2`: `core/constants.gd` implementato con tutti i parametri di SP-06 (`F1.3`) e `core/enums.gd`.
- [x] `P-F1.3`: `core/formulas.gd` implementato e testato con successo da `tests/test_formulas.gd` (`F1.4`, 24/24 test passati).
- [x] `P-F1.4`: `autoload/event_bus.gd` registrato e validato (`F1.5`).
- [x] `P-F1.5`: Collaudo finale completato e `docs/todo.md` aggiornato.
