# Changelog — World-tour

Le modifiche rilevanti sono registrate in ordine cronologico inverso. Una voce documentale non equivale a un rilascio applicativo.

## Non rilasciato

### 2026-09-22 — Chiusura Fase 5: Vertical Slice V1.3 — Economia, Carriera e Rilascio MVG (V1.0)
- Realizzato il modulo [`systems/economy_system.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/systems/economy_system.gd) con spese fisse di vitto e alloggio (25 € a notte), calcolo dell'autonomia economica residua (*Runway* in giorni), registro analitico delle transazioni, 3 lavori ordinari di sussistenza (Commesso, Cameriere, Magazziniere) e meccanica del "Salto nel vuoto" (licenziamento volontario).
- Realizzato il motore di progressione di carriera [`systems/career_system.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/systems/career_system.gd) con 8 status da *Sconosciuto* a *Superstar Mondiale* e promozioni automatiche al termine di concerti o pubblicazione singoli.
- Introdotta la velocità scalabile (1x, 2x, 3x) nel `TimeSystem`, con pulsante HUD `BtnSpeed` (T) e annuncio vocale immediato per NVDA.
- Aggiunta la durata della giornata personalizzabile con default a **5 minuti** (300s) e opzioni 10, 15, 20 minuti, selezionabile nel pannello Impostazioni e memorizzata in `user://settings.json`.
- Creata la modale accessibile [`ui/summary/daily_summary.tscn`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/ui/summary/daily_summary.tscn) collegata a `EndDaySystem` per la notifica e lettura notturna di spese, saldo e sonno ristoratore.
- Riorganizzato il layout dell'HUD: controlli operativi di sistema (Velocità, Pausa, Salva, Menu) posizionati nella barra superiore insieme a Tempo, Energia e Saldo; barra centrale riservata alle attività di gameplay.
- Rinnovato [`ui/music/song_creator.tscn`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/ui/music/song_creator.tscn) in una **Scheda Unica Integrata** con tutti i parametri artistici, opzioni studio (Home vs Pro), pulsante "Produci Tutto (65 Energia)" e avanzamento a tappe.
- Popolato automaticamente lo Starter Pack di 10 canzoni di prova (2 bozze, 5 prodotte con tratti `STAGE_BEAST` e `CULT_CLASSIC`, 3 singoli rilasciati).
- Creata la suite `tests/test_economy_system.gd` portando il totale a 6 suite di test su 6 superate al 100% con 0 fallimenti. Rilascio del Minimum Viable Game (V1.0 MVG).

### 2026-09-22 — Chiusura Fase 4: Vertical Slice V1.2 — Il Palco dal Vivo (Live Performance & Concert Loop)
- Implementato [`systems/concert_system.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/systems/concert_system.gd) per la simulazione completa dei concerti dal vivo (selezione da 1 a 4 brani pronti/pubblicati, soundcheck, imprevisti di palco a scelta multipla con check Carisma/Performance, closer bonus con tratti speciali, affluenza, incassi e conversione fan).
- Creato il catalogo dei locali starter [`data/models/venue_data.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/data/models/venue_data.gd) con 4 venue bilanciate (Garage, Pub, Piccolo Club, Club di Tendenza).
- Creata l'interfaccia concerti accessibile [`ui/concert/live_concert.tscn`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/ui/concert/live_concert.tscn) con navigazione 100% tastiera (`L`, `1`, `2`, `Esc`).
- Risolta l'anomalia `RRU-04` sull'isolamento di AccessKit per l'HUD sottostante e aggiunta di backdrop opachi antiriflesso (`#050508`).
- Creata la suite `tests/test_concert_system.gd` con 53 test unitari/integrazione passati al 100%.
- Creato il modello runtime del brano musicale [`data/models/song_data.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/data/models/song_data.gd) con le 5 fasi di produzione, calcolo del `quality_score`, tratti emergenti e persistenza atomica.
- Implementato [`systems/skill_system.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/systems/skill_system.gd) con gestione delle 7 abilità artistiche, soglie di crescita esponenziali basate su `Formulas.calculate_xp_for_level`, Level Cap a 99 ed emissione `EventBus.skill_leveled_up`.
- Realizzato il motore di produzione discografica [`systems/music_system.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/systems/music_system.gd) (Concept, Composizione, Testi, Registrazione Home vs Pro Studio a 50€, Missaggio e Mastering con Quality Score ed estrazione tratti speciali, rilascio singolo con fan, reputazione e royalty).
- Esteso [`data/models/player_data.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/data/models/player_data.gd) con il catalogo brani `songs: Array[SongData]` e metodi di filtraggio (`get_drafts`, `get_produced_songs`, `get_released_singles`).
- Aggiornato [`core/enums.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/core/enums.gd) con `SongStatus`, `SongStage` e `SongTrait`.
- Create le interfacce utente simmetriche ed accessibili per la musica: Catalogo Brani (`ui/music/song_catalog.tscn`) e Studio di Creazione Guidata (`ui/music/song_creator.tscn`) con scorciatoie dedicate `M` ed `N`.
- Aggiornato l'HUD (`ui/hud/hud.tscn`, `ui/hud/hud.gd`) con pulsanti integrati e focus loop circolare continuo.
- Estesi i dizionari multilingua (`localization/it.json` e `localization/en.json`) con tutti i termini musicali, generi, temi e descrizioni semantiche AccessKit.
- Risolto e validato il bug `RRU-01` (`BUG-001`) relativo all'API di override del tema in Godot 4.
- Implementata la suite di test unitari `tests/test_music_system.gd` portando il totale dei test automatici superati a 109 asserzioni su `test_music_system` e 248+ test complessivi nel progetto (100% passati).
- Eseguito con esito positivo il collaudo pratico in-game congiunto da parte di Luca (NVDA e tastiera) e Tom a monitor.

### 2026-09-22 — Chiusura Fase 2.5: Sistema di Localizzazione (i18n) & Main Menu Simmetrico
- Creati i dizionari di localizzazione bilingue (`localization/it.json` e `localization/en.json`) con 49 chiavi speculari per menu, impostazioni, HUD e annunci.
- Implementato l'Autoload `LocalizationManager` con rilevamento lingua OS (`OS.get_locale_language()`), registrazione in `TranslationServer` e segnale `language_changed`.
- Esteso `PlayerData` con il campo `language` per il salvataggio della lingua nella scheda personaggio.
- Implementati `save_settings()` e `load_settings()` in `SaveManager` per la persistenza delle impostazioni globali in `user://settings.json`.
- Creata la schermata del Menu Principale (`ui/main_menu/main_menu.tscn`, `ui/main_menu/main_menu.gd`) con 3 pulsanti (Avvio Rapido, Impostazioni, Esci) e pannello Impostazioni per cambio lingua immediato da tastiera o mouse.
- Aggiornato l'HUD di gioco (`ui/hud/hud.tscn`, `ui/hud/hud.gd`) con pulsante "Menu Principale" per il flusso bidirezionale con salvataggio automatico.
- Aggiunta la suite di test automatizzati `tests/test_localization.gd` portando i test superati da 67 a 96/96 (100% verde).
- Eseguito con successo il collaudo congiunto a video e con screen reader NVDA.

### 2026-09-22 — Chiusura Fase 2: Vertical Slice V1.0 (Core Loop Vitale)
- Implementati i modelli dati runtime in `data/models/` (`PlayerData`, `CalendarData`, `ActionData`) con serializzazione e deserializzazione atomica.
- Realizzato il motore temporale `TimeSystem` con orologio giornaliero da 600 secondi (24 ore virtuali), fasce orarie e velocità 1x/2x/5x.
- Realizzata la macchina a stati globale `GameManager` (`BOOT`, `IDLE`, `BUSY`, `PAUSED`, `DAILY_SUMMARY`) con Pausa Dinamica.
- Realizzato `AccessibilityManager` con integrazione AccessKit, cattura automatica del focus, navigazione tastiera circolare, scorciatoie globali (`Spazio`, `1-3`, `T`, `R`, `K`) e sonificazione con volume calibrato a 0.75f con ducking.
- Implementato `ActionSystem` con prima azione "Allenamento Rapido" (10s, 15 energia, +5 stress, XP con rendimenti marginali decrescenti).
- Implementato `EndDaySystem` con passaggio a `DAILY_SUMMARY`, spese fisse giornaliere di sussistenza (25€), sonno ristoratore (+70 energia, -15 stress) e reset orologio.
- Implementato `SaveManager` con salvataggio JSON atomico (`.tmp` -> `.json`) e blocco di sicurezza durante gli stati `BUSY`.
- Creata l'interfaccia HUD simmetrica (`ui/hud/hud.tscn`, `ui/hud/hud.gd`) e configurata come scena principale in `project.godot`.
- Estesa la suite di test con `tests/test_vertical_slice.gd` (43 test) portando il totale a 67/67 test superati con successo.
- Creato il runner headless di validazione sintattica globale `tools/check_syntax.tscn` e aggiornati `tools/check.ps1` e `tools/test.ps1`.
- Eseguito con esito positivo il primo collaudo reale congiunto: accessibilità 100% Zero Mouse con NVDA per Luca ed ergonomia visiva ad alto contrasto per Holy Diver (Tom).

### 2026-09-22 — Chiusura Fase 1: Fondamenta e Sistemi Base (Godot 4.7.2)

- Inizializzato il progetto Godot 4.7.2 con supporto nativo ad AccessKit (`--accessibility-driver accesskit`) per piena accessibilità con NVDA e UI Automation.
- Creata l'alberatura modulare del codice (`core/`, `data/`, `systems/`, `autoload/`, `ui/`, `tests/`, `tools/`).
- Implementato il modulo centralizzato di costanti ed enumerazioni (`core/constants.gd`, `core/enums.gd`).
- Implementata la classe pura `core/formulas.gd` e convalidata con suite di test unitari headless (`tests/test_formulas.gd`, 24/24 test superati con successo).
- Implementato e registrato come Autoload il bus degli eventi a segnali disaccoppiati (`autoload/event_bus.gd`).
- Aggiunti gli script PowerShell di automazione CLI-First in `tools/` (`check.ps1`, `test.ps1`, `run.ps1`).
- Archiviato con successo il piano tecnico operativo in `docs/piani/completati/PIANO_FASE_1_FONDAMENTA_E_SISTEMI_BASE.md`.

### 2026-09-21 — Inizializzazione della governance

- Aggiunta la baseline pubblica e minimale di ASTRALIS.
- Aggiunti i router locali `GEMINI.md` e `AGENTS.md`.
- Aggiunte la knowledge base iniziale e la struttura documentale.
- Aggiunte protezioni per dati personali, segreti e artefatti locali.
- Nessuna funzionalità applicativa, build, test o versione di prodotto dichiarata.
