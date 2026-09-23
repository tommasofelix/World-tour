# Piano Tecnico Operativo — Sezione 1.3: Triade Risorse Vitali & Recupero Attivo
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-23
# Stato: [x] Convalidato con Successo (Sotto-Fase 1B Completata - 37/37 Test Headless Superati)
# Coordinatore Master: docs/todo.md

---

## 1. OBIETTIVO E PERIMETRO DELLA SEZIONE 1.3

La Sezione 1.3 della Roadmap Modulare completa la gestione del protagonista e della sua routine quotidiana attraverso:
1. **Dinamica Fisiologica della Triade (Energia, Stress, Morale)**:
   - Riconoscimento rigoroso delle soglie critiche:
     * **Burnout Fisico** (Energia < 15%): raddoppio del tempo necessario per completare azioni ordinarie e avviso vocale preventivo per NVDA.
     * **Stato di Panico** (Stress $\ge$ 80%): freno esponenziale all'efficacia delle attività e allarme vocale NVDA.
     * **Blocco Creativo** (Morale < 20%): penalità sulle performance creative.
2. **Sistema di Recupero Attivo Diurno**:
   - Fornire al giocatore scelte tattiche concrete per gestire le risorse durante il giorno senza dover attendere la notte:
     * **Caffè al Bar (2.00 €)**: recupero immediato di +15 Energia, a fronte di +5 Stress e spesa monetaria.
     * **Passeggiata Rilassante al Parco (0 €)**: scarica -15 Stress, +5 Morale, consumo minimo -5 Energia.
     * **Ascolto Disco Capolavoro (0 €)**: iniezione di +20 Morale, -10 Stress e 35% chance di generare una "Scintilla Creativa" (+15 XP Scrittura testi).
3. **Interfaccia ad Alto Contrasto & Accessibilità Vocale Assoluta (Zero Mouse)**:
   - Modale dedicata `RelaxModal` accessibile con tasto rapido HUD `R` nell'Area 1 (Hub Personale).
   - Tasti di scelta rapida numerica `1`, `2`, `3` per attivare all'istante l'attività desiderata ed `Esc` per chiudere.

---

## 2. CONTRATTI OPERATIVI NOMINATI (D0 – D4)

### Contratto D0: Parametri di Bilanciamento & Modello Dati Esteso
- **File da modificare**:
  - `core/constants.gd`:
    * Aggiunta costanti per recupero attivo:
      - `RECOVERY_COFFEE_ENERGY: int = 15`
      - `RECOVERY_COFFEE_STRESS: int = 5`
      - `RECOVERY_COFFEE_COST: float = 2.0`
      - `RECOVERY_COFFEE_DURATION: float = 5.0`
      - `RECOVERY_WALK_STRESS_RELIEF: int = 15`
      - `RECOVERY_WALK_MORALE: int = 5`
      - `RECOVERY_WALK_ENERGY_COST: int = 5`
      - `RECOVERY_WALK_DURATION: float = 10.0`
      - `RECOVERY_MUSIC_MORALE: int = 20`
      - `RECOVERY_MUSIC_STRESS_RELIEF: int = 10`
      - `RECOVERY_MUSIC_DURATION: float = 12.0`
      - `RECOVERY_MUSIC_SPARK_CHANCE: float = 0.35`
      - `RECOVERY_MUSIC_SPARK_XP: float = 15.0`
      - `MORALE_CREATIVE_BLOCK_THRESHOLD: int = 20`
  - `data/models/action_data.gd`:
    * Estensione con campi polimorfici per attività di recupero:
      - `is_recovery: bool = false`
      - `energy_delta: int = 0`
      - `stress_delta: int = 0`
      - `morale_delta: int = 0`
      - `money_cost: float = 0.0`
      - `inspiration_chance: float = 0.0`

### Contratto D1: Motore ActionSystem & Gestione Burnout / Panico
- **File da modificare**:
  - `systems/action_system.gd`:
    * In `can_start_action(action: ActionData)`:
      - Controllo fondi monetari per azioni con `money_cost > 0.0`.
      - Controllo energia solo se l'azione consuma energia (`energy_cost > 0` o `energy_delta < 0`).
    * In `start_action(action: ActionData)`:
      - Verifica Burnout (`player_data.energy < Constants.ENERGY_BURNOUT_THRESHOLD`): se l'azione non è di recupero, durata raddoppiata (`action.duration_seconds * 2.0`) e annuncio vocale per NVDA.
      - Verifica Panico (`player_data.stress >= Constants.STRESS_PANIC_THRESHOLD`): annuncio vocale di avviso per NVDA.
    * In `_complete_action()`:
      - Applicazione delta risorse (denaro, energia, stress, morale).
      - Se `action.action_id == "recovery_music"` e controllo casuale superato: assegnazione Scintilla Creativa e annuncio dedicato.

### Contratto D2: Schermata Modale RelaxModal (`ui/relax/`)
- **File da creare**:
  - `ui/relax/relax_modal.tscn`
  - `ui/relax/relax_modal.gd`
- **Architettura**:
  - Pannello centrale ad alto contrasto con bordo pronunciato.
  - Elenco pulsanti lineari:
    1. `BtnCoffee`: "Bevi un Caffè al Bar (2.00 €) [1]"
    2. `BtnWalk`: "Passeggiata Rilassante al Parco [2]"
    3. `BtnMusic`: "Ascolta un Disco Capolavoro [3]"
    4. `BtnClose`: "Chiudi / Torna all'Hub [Esc]"
  - Tasti rapidi da tastiera: `1`, `2`, `3` e `Esc`.
  - Hook completi `AccessibilityManager.hook_control_accessibility()`.

### Contratto D3: Integrazione HUD & Tasto Rapido `R`
- **File da modificare**:
  - `ui/hud/hud.tscn`:
    * Aggiunta del pulsante `BtnRelax` ("Relax (R)") in `VBoxMain/PanelCenter/HBoxActions` dell'Area 1.
    * Istanziazione nodo `RelaxModal` figlio dell'HUD.
  - `ui/hud/hud.gd`:
    * Variabili onready per `btn_relax` e `relax_modal`.
    * Gestione visibilità: visibile solo quando `current_category_tab == 1`.
    * Tasto rapido `KEY_R` in `_unhandled_input(event)`.
    * Connessione segnale di avvio azione da `RelaxModal` verso `action_system.start_action()`.

### Contratto D4: Suite di Test Headless & Zero Regressioni
- **File da creare**:
  - `tests/test_vital_resources_system.gd`
  - `tests/test_vital_resources_system.tscn`
- **Casi di test**:
  - Test 1: Verifica esecuzione Caffè (spesa 2€, +15 energia, +5 stress).
  - Test 2: Verifica esecuzione Passeggiata (-15 stress, +5 morale, -5 energia).
  - Test 3: Verifica esecuzione Ascolto Musica (+20 morale, -10 stress).
  - Test 4: Rilevamento Burnout (< 15%) e raddoppio durata azioni ordinarie.
  - Test 5: Rilevamento Panico ($\ge$ 80%) e blocco per fondi insufficienti.
  - Test 6: Navigazione e scorciatoie tastiera di `RelaxModal`.
  - Regressione: esecuzione congiunta delle suite `test_vertical_slice`, `test_time_night_system`, `test_character_creation`, `test_v5_ui_overhaul`, `test_localization`.

---

## 3. PIANO DI VALIDAZIONE A 7 ASSI

1. **Asse 1 — Validità**: Rispetto rigoroso dei tipi GDScript e Clean Architecture.
2. **Asse 2 — Efficacia**: Risolve il problema del recupero risorse durante il giorno con scelte tattiche bilanciate.
3. **Asse 3 — Coerenza**: Armonizzato con `ActionSystem`, `PlayerData`, `CalendarData` e la FSM `GameManager`.
4. **Asse 4 — Completezza**: Copertura di tutti i casi limite (denaro insufficiente, tempo residuo insufficiente, burnout attivo).
5. **Asse 5 — Precisione**: Nessun refactoring distruttivo; estensione polimorfica di `ActionData`.
6. **Asse 6 — Affidabilità & Prestazioni**: Esecuzione deterministica a 0 ms nei test headless; volumi audio protetti.
7. **Asse 7 — Assenza Regressioni**: Compatibilità totale garantita con le 19 suite di test esistenti.

---

## 4. STOP OBBLIGATORIO (REGOLA 0 - SOTTO-FASE 1A)

Questo piano tecnico formale attende la revisione e l'approvazione esplicita di Luca (*"procedi"*, *"applica"*, *"esegui"*) prima di iniziare la scrittura di codice sorgente (Sotto-Fase 1B).
