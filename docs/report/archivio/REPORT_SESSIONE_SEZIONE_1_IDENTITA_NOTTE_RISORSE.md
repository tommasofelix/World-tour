# Report di Sessione Operativa — Sezione 1: Identità, Routine & Risorse Vitali
# Data: 2026-09-23
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7
# Percorso: docs/report/REPORT_SESSIONE_SEZIONE_1_IDENTITA_NOTTE_RISORSE.md
# Stato: [x] Convalidato con Successo

---

## 1. SINTESI ESECUTIVA

In data 2026-09-23 è stata completata l'intera **Sezione 1** della Roadmap Modulare di **World-tour** suddivisa in tre sotto-fasi operative:
1. **Sezione 1.1**: Creazione Personaggio, anagrafica duale (nome reale / nome d'arte), selettore età (16-60), 6 strumenti musicali principali, 5 background con attributi di partenza, 5 tratti caratteriali e biforcazione Main Menu tra *Nuova Partita* e *Modalità Test / Avvio Rapido*.
2. **Sezione 1.2**: Filosofia della Notte con estensione del ciclo giornaliero a 22 ore virtuali (06:00 – 04:00), eliminazione totale di pop-up bloccanti a mezzanotte, overtime progressivo non forfettario (+2, +3, +5, +10 di stress per ora notturna), avvisi vocali discreti NVDA alle 02:00 e 03:00, e controlli di navigazione temporale rapida con tasto *Aspetta (X)* e *Dormi (Z)* con bonus sonno ristoratore.
3. **Sezione 1.3**: Triade fisiologica delle Risorse Vitali (Energia, Stress, Morale), rilevamento stati critici di Burnout Fisico (< 15% energia, durata raddoppiata per azioni ordinarie, azioni di recupero esenti) e Panico psicologico ($\ge$ 80% stress), verifica preventiva dei fondi monetari disponibili prima di avviare azioni a pagamento, e modale ad alto contrasto `RelaxModal` accessibile con tasto HUD `R` con attività diurne (Caffè al bar, Passeggiata al parco, Ascolto disco con 35% chance Scintilla Creativa).

Tutti i sistemi sono stati convalidati empiricamente al 100% in modalità headless tramite console Godot (266 asserzioni superate su 6 suite, 0 errori).

---

## 2. MODIFICHE AL CODICE SORGENTE ED ASSET DI PROGETTO

### File di Sistema & Dati Modificati
- [`core/constants.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/core/constants.gd):
  * Aggiunte costanti per l'orario a 22 ore (`VIRTUAL_HOURS_PER_DAY = 22.0`).
  * Parametri overtime progressivo (`OVERTIME_STRESS_HOUR_1..4`).
  * Parametri bonus riposo anticipato serale e notturno.
  * Costanti fisiologiche di recupero attivo (`RECOVERY_COFFEE_*`, `RECOVERY_WALK_*`, `RECOVERY_MUSIC_*`).
  * Soglie critiche (`ENERGY_BURNOUT_THRESHOLD = 15`, `STRESS_PANIC_THRESHOLD = 80`, `MORALE_CREATIVE_BLOCK_THRESHOLD = 20`).
- [`data/models/action_data.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/data/models/action_data.gd):
  * Estensione con campi polimorfici per attività di recupero (`is_recovery`, `energy_delta`, `stress_delta`, `morale_delta`, `money_cost`, `inspiration_chance`).
- [`data/models/calendar_data.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/data/models/calendar_data.gd):
  * Ricalibrazione orario virtuale scalato su 22 ore con modulo 24 (`(6 + hour_offset) % 24`).
  * Helper `get_virtual_hour()` e `get_hour_offset()`.
  * Soglie fasce orarie: Mattina (06-12), Pomeriggio (12-18), Sera (18-00), Notte/Overtime (00-04).
- [`data/models/player_data.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/data/models/player_data.gd):
  * Campi `stage_name` ed `age`.
  * Metodo `get_effective_name()`.
- [`systems/action_system.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/systems/action_system.gd):
  * Controllo fondi disponibili in `can_start_action()` con rifiuto motivato.
  * Applicazione raddoppio durata per Burnout (<15% energia) su azioni ordinarie ed esenzione per azioni di recupero.
  * Rilevamento stato di Panico ($\ge$ 80% stress) con allarme vocale NVDA.
  * Risoluzione atomica delle risorse (denaro, energia, stress, morale) e roll casuale Scintilla Creativa per l'ascolto musicale.
- [`systems/time_system.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/systems/time_system.gd):
  * Gestione overtime notturno silenzioso a 00:00 e 01:00.
  * Avvisi vocali discreti NVDA alle 02:00 e 03:00.
  * Metodi `skip_to_next_period()` e `sleep_early()`.
- [`systems/end_day_system.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/systems/end_day_system.gd):
  * Calcolo bonus sonno ristoratore ed eliminazione stress per riposo anticipato.

### File Interfaccia Utente (UI) Modificati e Creati
- [`ui/relax/relax_modal.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/ui/relax/relax_modal.gd) & [`.tscn`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/ui/relax/relax_modal.tscn):
  * Modale ad alto contrasto con tasti rapidi `1`, `2`, `3`, `Esc`.
  * Hook semantici `AccessibilityManager` con costi, benefici e tasti da tastiera.
  * Guardie di connessione sicure `not btn.pressed.is_connected()`.
- [`ui/hud/hud.tscn`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/ui/hud/hud.tscn) & [`ui/hud/hud.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/ui/hud/hud.gd):
  * Pulsanti Top Bar `BtnWait` ("Aspetta (X)") e `BtnSleep` ("Dormi (Z)").
  * Pulsante Area 1 `BtnRelax` ("Relax (R)").
  * Istanziazione e gestione modale `RelaxModal` con tasto rapido `R`.
  * Mappatura tasti `X`, `Z`, `R` in `_unhandled_input()`.
- [`ui/character_creation/character_creation.tscn`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/ui/character_creation/character_creation.tscn) & [`character_creation.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/ui/character_creation/character_creation.gd):
  * Schermata creazione guidata completa 100% da tastiera.
- [`ui/main_menu/main_menu.tscn`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/ui/main_menu/main_menu.tscn) & [`main_menu.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/ui/main_menu/main_menu.gd):
  * Biforcazione "Nuova Partita" vs "Avvio Rapido (Test)".

---

## 3. RISULTATI TEST SUITE AUTOMATIZZATI HEADLESS (266 / 266 SUPERATI)

Tutti i test seams sono stati eseguiti con `Godot_v4.7.2-stable_win64_console.exe --headless --quit`:
1. `tests/test_vital_resources_system.tscn`: **37 / 37 superati (100% verde)**
2. `tests/test_time_night_system.tscn`: **28 / 28 superati (100% verde)**
3. `tests/test_character_creation.tscn`: **39 / 39 superati (100% verde)**
4. `tests/test_vertical_slice.tscn`: **65 / 65 superati (100% verde)**
5. `tests/test_v5_ui_overhaul.tscn`: **67 / 67 superati (100% verde)**
6. `tests/test_localization.tscn`: **30 / 30 superati (100% verde)**

---

## 4. CONFORMITÀ ACCESSIBILITÀ & SIMMETRIA UNIVERSALE

- **Zero Mouse**: Ogni funzione è eseguibile e testabile unicamente tramite tastiera (tasti `1`..`3`, `X`, `Z`, `R`, `Esc`, Tab e frecce).
- **Driver AccessKit Nativo**: Etichette semantiche, ruoli accessibili e descrizioni d'aiuto esposte direttamente a Windows UI Automation per NVDA.
- **Volumi di Sicurezza**: Feedback sonori posizionati rigidamente tra `0.7f` e `0.8f` per non coprire mai la voce della sintesi vocale.
