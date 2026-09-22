# World-tour

Simulatore di Carriera Musicale e di Vita (*Music Career & Life Simulator*). Progetto orientato all'accessibilità universale (Zero Mouse con NVDA) e all'eccellenza grafica in Godot Engine 4.x.

## Governance ASTRALIS

Il progetto adotta una baseline documentale pubblica e minimale di [ASTRALIS Framework](https://github.com/Nemex81/astralis-framework), derivata dal ramo ufficiale `main` al commit `d28d1f95159f2d4c48916381c3aeb3f1fd4b7d8f`.

L’integrazione riguarda esclusivamente governance, accessibilità e tracciabilità del lavoro. Non certifica l’esistenza di funzionalità, build, test o rilasci applicativi.

## Navigazione

- [`GEMINI.md`](./GEMINI.md): hub di contesto per l’AI primaria.
- [`AGENTS.md`](./AGENTS.md): direttive locali per OpenAI Codex.
- [`knowledge/`](./knowledge/): conoscenza specifica e contratti operativi del progetto.
- [`docs/strategie/attive/`](./docs/strategie/attive/): strategie approvate o in valutazione.
- [`docs/piani/attivi/`](./docs/piani/attivi/): piani tecnici autorizzati.
- [`docs/report/REGISTRO_REVISIONI.md`](./docs/report/REGISTRO_REVISIONI.md): revisioni aperte e collaudi in corso.
- [`CHANGELOG.md`](./CHANGELOG.md): modifiche documentate senza attribuire rilasci non avvenuti.

## Stato tecnico

- **Dominio applicativo**: Simulazione di vita e carriera musicale (percorsi Live, Studio, Lifestyle).
- **Linguaggi e framework**: Godot Engine 4.7.2 win64, GDScript 2.0, Clean Architecture e AccessKit nativo (Windows UI Automation per NVDA).
- **Build, test ed esecuzione**:
  - Validazione sintattica: `powershell -File tools/check.ps1`
  - Test unitari headless: `powershell -File tools/test.ps1`
  - Esecuzione gioco: `powershell -File tools/run.ps1`
- **Fase attiva**: Fase 2 e Fase 2.5 completate (Vertical Slice V1.0 e Localizzazione/Main Menu convalidati e collaudati con successo); in preparazione Fase 3 (Vertical Slice V1.1 — Il Ciclo Creativo / Music Crafting).

## Riservatezza

Il repository è pubblico. Profili personali, percorsi macchina, credenziali, configurazioni locali e contenuti del Master Hub privato non devono essere versionati.
