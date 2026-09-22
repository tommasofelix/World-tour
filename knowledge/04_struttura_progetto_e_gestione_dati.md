# Struttura del progetto e gestione dei dati

## Struttura di governance

- `GEMINI.md`: router per l’AI primaria.
- `AGENTS.md`: router locale per Codex.
- `knowledge/`: contratti e conoscenza specifica.
- `docs/strategie/attive/`: analisi strategiche correnti.
- `docs/piani/attivi/`: piani tecnici autorizzati.
- `docs/piani/completati/`: piani chiusi con evidenza.
- `docs/report/`: registri, audit e report.
- `docs/idee/`: proposte non ancora autorizzate.
- `docs/manuali/`: guide operative validate.

## Confini dei dati

- Contenuto pubblico: documentazione agnostica, codice del progetto e configurazioni portabili approvate.
- Contenuto locale: preferenze personali, percorsi macchina, log diagnostici, cache e configurazioni dell’editor.
- Contenuto riservato: credenziali, segreti, dati personali e documenti del Master Hub privato.

I contenuti locali o riservati non devono essere copiati nel repository. I percorsi persistenti devono essere relativi o risolti tramite variabili d’ambiente.

## Stato applicativo e struttura del codice (Godot 4.7)

L'albero del codice sorgente adotta la Clean Architecture disaccoppiata in Godot 4:

- `project.godot`: file di configurazione radice (1920x1080, stretch canvas_items, aspect keep).
- `core/`: costanti centralizzate di bilanciamento (`constants.gd`), enumerazioni globali (`enums.gd`), algoritmi matematici puri deterministici (`formulas.gd`).
- `data/`: modelli di dati runtime in `data/models/` e definizioni statiche in `data/definitions/`.
- `systems/`: motori logici di dominio indipendenti dalla UI (`TimeSystem`, `PlayerSystem`, `ActionSystem`, `MusicSystem`, `ConcertSystem`, `EconomySystem`).
- `autoload/`: moduli singleton globali (`event_bus.gd` disaccoppiato a segnali, `game_manager.gd`, `save_manager.gd`, `accessibility_manager.gd`).
- `ui/`: interfacce visive a layer differenziati in `ui/common/`, `ui/hud/`, `ui/menus/`.
- `tests/`: test unitari automatici eseguibili in modalità headless (`test_formulas.gd`).
- `tools/`: script di automazione PowerShell per lo sviluppo e il collaudo CLI-First (`check.ps1`, `test.ps1`, `run.ps1`).
