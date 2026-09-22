# Sottopiano 07 — Architettura Software, Sistemi e Modello Dati

- ID Sottopiano: `SP-07`
- Versione: 1.1 — Ottimizzata per Clean Architecture, Sistemi Godot 4 e Persistenza Sicura
- Tema: Architettura a Layer, Disaccoppiamento EventBus, Macchina a Stati Globale, Modelli Dati e Salvataggio Atomico
- Competenze di riferimento: Software Architecture, Systems Engineering, Data Modeling, Godot 4 Engine
- Documento sorgente: [`docs/piani/attivi/World Tour .md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/World%20Tour%20.md) (Righe 6786–8091, 8092–9288, 9289–9356)
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md)

---

## 1. PRINCIPI ARCHITETTURALI FONDAMENTALI (CLEAN ARCHITECTURE)

L'architettura software del progetto World-tour in Godot 4 adotta i canoni della **Clean Architecture** e del **Domain-Driven Design**:
1. **La Logica di Dominio è Indipendente dalla UI**: Tutti i sistemi logici (tempo, statistiche, brani, concerti, finanza) operano unicamente su classi dati pure e comunicano tramite segnali, senza mai fare riferimento a nodi grafici, sprite o bottoni a schermo.
2. **Inversione delle Dipendenze**: I nodi della UI ascoltano i segnali dell'EventBus per aggiornarsi; la UI non invoca mai direttamente metodi interni dei sistemi che alterino lo stato del gioco.
3. **Estendibilità a Risorse (`Data-Driven`)**: Nuovi strumenti, generi musicali, azioni o locali possono essere aggiunti come semplici file di definizione (`.tres` o JSON) senza dover riscrivere una riga di codice applicativo.

---

## 2. STRUTTURA DELLE CARTELLE DEL PROGETTO GODOT 4

```
res://
├── core/                           # Invarianti, costanti e formule pure
│   ├── constants.gd                # Parametri centralizzati (SP-06)
│   ├── formulas.gd                 # Algoritmi matematici puri (SP-06)
│   └── enums.gd                    # Stati, generi, fasce orarie e status carriera
├── data/                           # Modelli dati runtime e definizioni statiche
│   ├── models/                     # Classi dati runtime (Player, Calendar, Song, Venue)
│   └── definitions/                # Risorse statiche (.tres per azioni, background, locali)
├── systems/                        # Motori logici di dominio
│   ├── time_system.gd              # Orologio 600s, fasce orarie e stati temporali
│   ├── player_system.gd            # Salute, energia, stress, morale e abilità
│   ├── action_system.gd            # Convalida, avvio, timer e interruzione azioni
│   ├── music_system.gd             # Stadi di creazione canzoni e traits
│   ├── concert_system.gd           # Soundcheck, scaletta, score live e box office
│   └── economy_system.gd           # Bilancio, stipendi sussistenza e spese fisse
├── autoload/                       # Istanze globali gestite (Singletons)
│   ├── event_bus.gd                # Bus eventi disaccoppiato a segnali
│   ├── game_manager.gd             # Macchina a stati globale (FSM)
│   ├── save_manager.gd             # Persistenza atomica JSON con schema versionato
│   └── accessibility_manager.gd    # Bridge vocale NVDA/SAPI e focus tastiera
├── ui/                             # Sottosistema di presentazione (separato)
│   ├── hud/                        # Barra temporale, orologio, indicatori risorse
│   ├── career/                     # Dashboard di carriera e matrice status (SP-01)
│   ├── studio/                     # Banco di missaggio e catalogo brani (SP-03)
│   ├── concert/                    # Palco live e selezione scaletta (SP-04)
│   ├── economy/                    # Cassa e bilancio finanziario (SP-05)
│   └── common/                     # Dialoghi modali, bottoni accessibili e temi
└── tests/                          # Test unitari e verifiche automatiche
    └── test_formulas.gd            # Stress test formule matematiche
```

---

## 3. LA MACCHINA A STATI GLOBALE (`GAME MANAGER`)

Il ciclo di vita dell'applicazione è governato da una macchina a stati esplicita (`res://autoload/game_manager.gd`):

```gdscript
enum GameState {
    BOOT,                   # Inizializzazione configurazioni e audio
    MAIN_MENU,              # Menu principale (Nuova Partita, Carica, Opzioni, Esci)
    CHARACTER_CREATION,     # Scelta anagrafica, background e strumento iniziale
    GAMEPLAY_IDLE,          # Mondo attivo, orologio che scorre, giocatore libero
    GAMEPLAY_BUSY,          # Azione in corso con blocco azioni concorrenti
    GAMEPLAY_PAUSED,        # Simulazione temporale congelata
    DAILY_SUMMARY,          # Schermata riepilogativa a mezzanotte
    GAME_OVER               # Fine partita per bancarotta o burnout
}
```

---

## 4. IL BUS DEGLI EVENTI (`EVENT BUS`)

Tutti i componenti comunicano unicamente emettendo o ascoltando segnali in `res://autoload/event_bus.gd`:

```gdscript
# Segnali Temporali & Calendario
signal time_ticked(remaining_seconds: float, time_str: String, period: int)
signal day_ended(day_number: int)
signal day_started(day_number: int)
signal pause_toggled(is_paused: bool)
signal speed_changed(new_speed: float)

# Segnali Azioni
signal action_started(action: ActionData)
signal action_progress(elapsed: float, duration: float)
signal action_completed(action: ActionData, rewards: Dictionary)
signal action_canceled(action: ActionData)

# Segnali Musicali & Live
signal song_created(song: SongData)
signal concert_resolved(result: ConcertResultData)
signal stage_event_triggered(event_data: Dictionary)

# Segnali Economia & Carriera
signal money_changed(new_balance: float, delta: float, reason: String)
signal career_status_unlocked(new_tier: int)
signal game_over_triggered(reason: String)

# Segnali di Accessibilità & UI
signal speak_requested(text: String, interrupt: bool)
signal ui_focus_changed(control_name: String, control_value: String)
```

---

## 5. SISTEMA DI PERSISTENZA ATOMICA (`SAVE MANAGER`)

1. **Formato File**: File JSON leggibile con marcatore di versione schema:
   `user://savegame.json`
2. **Gating di Sicurezza**: Il salvataggio è permesso **esclusivamente** negli stati stabili `GAMEPLAY_IDLE` o `DAILY_SUMMARY`. È formalmente bloccato durante `GAMEPLAY_BUSY` per prevenire corruzioni di timer o stati incompleti.
3. **Scrittura Atomica a Prova di Crash**:
   - I dati vengono prima serializzati su un file temporaneo `user://savegame.tmp`.
   - Se la scrittura e la chiusura hanno successo, il file viene rinominato atomicamente in `user://savegame.json`.
   - Se si verifica un'interruzione, il file di salvataggio originale rimane intatto al 100%.

---

## 6. DESIGN VISIVO IN GODOT 4 & ARCHITETTURA A LAYER DIFFERENZIATI NELLA STESSA UI

L'interfaccia utente di World-tour adotta il principio della **Simmetria Universale Bi-Direzionale** strutturandosi su tre layer paralleli, complementari e sinergici che condividono lo stesso stato applicativo:

### 6.1 Layer Visivo & Mouse (Per Holy Diver e Utenti Normovedenti)
- **Scena Master (`res://scenes/main.tscn`)**:
  - `SceneManager`: Controller che gestisce le transizioni con dissolvenza morbida tra Menu, Creazione Personaggio e Gameplay.
  - Risoluzione nativa 1920x1080 con stretch mode `canvas_items` e aspect `keep`, garantendo perfetta resa su monitor moderni.
  - Tema unificato `res://ui/theme_world_tour.tres` con contrasti cromatici certificati WCAG AAA e piena ergonomia mouse (hover, drag, click).
  - Indicatore visivo di focus (*Glow* luminoso ambra/ciano) che consente a Holy Diver di seguire visivamente la navigazione da tastiera di Luca.

### 6.2 Layer Semantico UIA & AccessKit (Per Luca e Screen Reader NVDA — Zero Mouse)
- **Supporto Nativo AccessKit (Godot 4.7.2)**:
  - Ogni nodo `Control` espone le proprietà native `accessibility_name`, `accessibility_description` e `accessibility_live`.
  - Mappatura automatica nell'albero Windows UI Automation (UIA): NVDA legge nativamente controlli, ruoli e valori senza bisogno di wrapper grafici invasivi.
  - Albero di focus lineare e deterministico navigabile via `Tab`, `Shift+Tab`, `Frecce` e `Invio`.
  - Scorciatoie rapide a cifra singola (`1`–`9`) e tasti globali mnemonici (`T`, `R`, `K`, `M`, `B`, `Spazio`).

### 6.3 Layer Acustico & Sonificazione (Ponte Sinergico Condiviso)
- Modulo `AccessibilityManager`: emissione di audio cues distintivi per eventi chiave (inizio/fine azione, avvisi emergenza).
- Regola di **Anti-Mascheramento Acustico**: volume massimo bloccato a **0.7f – 0.8f** con audio ducking automatico durante il parlato di NVDA.

---

## 7. CHECKPOINT DI CONFORMITÀ (GATING)

- [ ] `SP-07.1`: Struttura ad albero creata in Godot 4 con file script base di ciascun layer.
- [ ] `SP-07.2`: `EventBus` implementato come Autoload con tutti i segnali definiti.
- [ ] `SP-07.3`: Macchina a stati `GameManager` implementata con transizioni sicure.
- [ ] `SP-07.4`: `SaveManager` con scrittura atomica JSON e blocco salvataggio in stato BUSY.
- [ ] `SP-07.5`: `AccessibilityManager` con auto-aggancio del focus sui nodi UI e test da tastiera.
