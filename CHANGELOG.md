# Changelog — World-tour

Le modifiche rilevanti sono registrate in ordine cronologico inverso. Una voce documentale non equivale a un rilascio applicativo.

## Non rilasciato

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
