# 04 — Struttura del Progetto, Gestione Dati & Rete Documentale (v3.0.7)

## 1. Rete Documentale a 4 Nodi Comunicanti in `docs/` (Pointer Hub DRY)

L'ecosistema documentale di World-tour adotta la struttura a 4 nodi di ASTRALIS, disaccoppiando le fasi operative e collegando le informazioni tramite collegamenti Markdown relativi (Single Source of Truth):

1. **Strategie Logico-Cognitive (`docs/strategie/`)**:
   - `docs/strategie/attive/`: Esplorazione concettuale, dilemmi architetturali e modelli mentali per NVDA (Fase 0);
   - `docs/strategie/archiviate/`: Strategie convalidate e convertite in piani tecnici formali;
2. **Piani Tecnici Formali (`docs/piani/`)**:
   - `docs/piani/attivi/`: Piani approvati in lavorazione (Sotto-Fase 1A/1B), inclusi i sottopiani in `sottopiani/`;
   - `docs/piani/completati/`: Piani e sottopiani collaudati con successo e archiviati con evidenza;
3. **Reportistica & Telemetria (`docs/report/`)**:
   - `docs/report/REGISTRO_REVISIONI.md`: Registro snello delle anomalie e revisioni aperte (RRU);
   - `docs/report/archivio/ARCHIVIO_REVISIONI.md`: Memoria storica di tutte le anomalie risolte;
   - `docs/report/archivio/`: Report di sessione, log di collaudo e telemetria diagnostica;
4. **Manuali & Living Documentation (`docs/manuali/` & `knowledge/`)**:
   - Guide operative, manuale utente, roadmap coordinata ([`docs/todo.md`](../docs/todo.md)) e base di conoscenza permanente.

---

## 2. Confini dei Dati & Igiene per Repository Pubblico

- **Contenuto Pubblico Versionabile**: Codice sorgente GDScript, scene `.tscn`, risorse di gioco `.tres`, documentazione concettuale con link relativi, dizionari di localizzazione e suite di test.
- **Contenuto Locale Escluso dal Versionamento**: File di log runtime effimeri (`godot*.log`), cache dell'editor (`.godot/`), preferenze personali e percorsi di macchina.
- **Contenuto Riservato Inviolabile**: Credenziali, segreti e file di governance privata del Master Hub.
- **Regola di Portabilità**: Nessun file del repository pubblico deve contenere percorsi assoluti locali o dischi di macchina fisici. Tutti i collegamenti inter-documentali usano percorsi relativi standard (`./`, `../`).

---

## 3. Albero del Codice Sorgente (Godot 4.7 Clean Architecture)

La struttura del progetto separa rigorosamente logica di dominio, gestione dati e interfaccia visiva:

- `project.godot`: Configurazione radice del motore (1920x1080, stretch canvas_items, aspect keep).
- `core/`: Costanti centralizzate di bilanciamento (`constants.gd`), enumerazioni globali (`enums.gd`), algoritmi matematici deterministici e curve di rendimento (`formulas.gd`).
- `data/`:
  - `data/models/`: Modelli dati a runtime (`player_data.gd`, `song_data.gd`, `concert_data.gd`, `band_data.gd`, `economy_data.gd`);
  - `data/definitions/`: Definizioni statiche e tabelle di catalogo (generi musicali, locali, tipologie di contratti).
- `systems/`: Motori logici di dominio indipendenti dalla grafica (`TimeSystem`, `PlayerSystem`, `ActionSystem`, `MusicSystem`, `ConcertSystem`, `EconomySystem`, `TourSystem`).
- `autoload/`: Singleton globali registrati nel motore:
  - `event_bus.gd`: Disaccoppiamento asincrono a segnali tra sistemi e UI;
  - `game_manager.gd`: Macchina a stati globale (FSM) del ciclo di gioco;
  - `save_manager.gd`: Serializzazione e persistenza atomica JSON in `user://`;
  - `accessibility_manager.gd`: Bridge audio, cue sonori, gestione focus ed eventi NVDA/UIA;
  - `localization_manager.gd`: Gestione dizionari bilingue (`it`, `en`) e cambio lingua dinamico.
- `ui/`: Interfaccia grafica accessibile organizzata per contesti:
  - `ui/common/`: Controlli base riutilizzabili con focus ad alto contrasto;
  - `ui/hud/`: Barra superiore, indicatori risorse, avanzamento tempo e pulsanti principali;
  - `ui/menus/`: Menu principale, impostazioni, schermata di fine giornata e dialoghi;
  - `ui/music/`: Studio di registrazione, catalogo brani e creatore canzoni;
  - `ui/concert/`: Schermata ingaggio concerti, scaletta e riepilogo live.
- `tests/`: Le 17 suite di test unitari automatici eseguibili in modalità headless via console CLI.
- `tools/`: Script PowerShell per validazione rapida (`check.ps1`), test (`test.ps1`) e avvio accessibile (`run.ps1`).
