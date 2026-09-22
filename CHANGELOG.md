# Changelog — World-tour

Le modifiche rilevanti sono registrate in ordine cronologico inverso. Una voce documentale non equivale a un rilascio applicativo.

## Non rilasciato

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
