# World-tour — Hub di Contesto & Governance Locale (GEMINI.md — ASTRALIS v3.0.7)
# Autore: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Target AI: Antigravity (Primaria) & Codex / ChatGPT (Copilota Ausiliario — vedi AGENTS.md)
# Repository: pubblico (tommasofelix/World-tour) — Link relativi obbligatori, zero percorsi personali o segreti

Questo repository implementa il simulatore musicale **World-tour** (Music Career Simulator / Life Simulation) in pair programming con **Luca**, sviluppatore completamente non vedente su Windows 11 con screen reader **NVDA** (**ZERO MOUSE**).
Tutta l'interazione con l'ambiente, il motore di gioco, la console e gli strumenti avviene tramite sintesi vocale (NVDA / SAPI), feedback sonori posizionali calibrati e tastiera completa.

Questo file costituisce l'**Hub di Contesto Locale** del progetto. Tutti i dettagli specialistici risiedono nella cartella [`knowledge/`](./knowledge/).

---

## 🏛️ 1. FONTI DI VERITÀ & RETE DOCUMENTALE (POINTER HUB DRY)

Consultare in quest'ordine e soltanto nella misura strettamente necessaria:

1. Questo file per il contesto sintetico di governance e i parametri del progetto.
2. [`knowledge/`](./knowledge/) per i contratti tecnici, lo stack e le convenzioni specialistiche.
3. [`docs/todo.md`](./docs/todo.md) per la master roadmap e il coordinamento delle fasi.
4. [`docs/piani/attivi/`](./docs/piani/attivi/) per i piani tecnici autorizzati (Sotto-Fase 1A/1B).
5. [`docs/report/REGISTRO_REVISIONI.md`](./docs/report/REGISTRO_REVISIONI.md) per il registro attivo delle anomalie (RRU).

---

## 🌟 2. LE REGOLE AUREE INVIOLABILI DEL PROGETTO

0. **Regola 0 — Default Consultivo Permanente, 12 Protocolli & Gating a 3 Stati**:
   - Modalità consultiva permanente: analizza, verifica i log, consulta le schede pertinenti e **attendi sempre la conferma esplicita di Luca prima di modificare codice o file** (*"procedi"*, *"applica"*, *"esegui"*).
   - Parole chiave consultive (*"cosa ne pensi?"*, *"valuta"*, *"come faresti?"*, *"analizza"*) impongono esclusivamente analisi e discussione architetturale.
   - *Gating Semantico Fase 1*: Comandi come *"passa alla fase 1"* autorizzano **esclusivamente la stesura del Piano Tecnico Formale (Sotto-Fase 1A)** in `docs/piani/attivi/` e impongono lo **Stop Obbligatorio** prima di toccare codice sorgente o configurazioni (Sotto-Fase 1B).
   - *Matrice a 3 Stati per NVDA*:
     - `- [ ] [DA AVVIARE]`: Attività pianificata ma non iniziata;
     - `- [/] [IMPLEMENTATO — IN ATTESA DI CONVALIDA]`: Modifica apportata o codice compilato, in attesa di test o collaudo formale (spunta parziale);
     - `- [x] [CONVALIDATO CON SUCCESSO]`: Spunta definitiva concessa **esclusivamente POST-CONVALIDA formale** (approvazione per la 1A, test suite 100% verde per la 1B, collaudo pratico NVDA per la Fase 2).
   - *Validazione Preventiva a 7 Assi*: Validità, Efficacia, Coerenza, Completezza, Precisione, Affidabilità/Prestazioni, Assenza Regressioni, testata su **3 Livelli di Simulazione** (Happy Path, Alternativi/Concorrenti, Corner Cases).
   - *Protocollo di Eliminazione Protetta a 5 Passi*: Spiegare motivazione, conseguenze, scopo, verifica dati e attendere conferma prima di qualsiasi cancellazione.

1. **Accessibilità Vocale Assoluta, Zero Mouse & Canale Audio Calibrato**:
   - Nessuna interfaccia, menu o funzionalità deve dipendere dal mouse o da riferimenti visivi (interazione 100% da tastiera).
   - **Volumi di Sicurezza Anti-Mascheramento**: Volumi di musica, effetti ambientali e suoni di gioco congelati rigorosamente tra `0.7f` e `0.8f` (mai 1.0f pieno), con audio ducking attivo durante il parlato, per non coprire mai la voce dello screen reader NVDA.
   - **Segnali di Allarme ad Alto Segnale**: Avvisi critici dotati di attacco istantaneo e spettro acuto metallico penetrativo su bus dedicato.

2. **Protocollo 12 — Inner Codex Pattern & i 6 Cancelli Inviolabili**:
   - *Cancello 1 (Rifiuto Patching Euristico)*: Risoluzione deterministica delle cause radice (RCA), divieto di forzare ritardi o pesi artificiali;
   - *Cancello 2 (Hardware Grounding & Zero Mouse)*: Disaccoppiamento tra input da periferica e guardie reattive;
   - *Cancello 3 (Hitbox, Clearance Continua & Volumi Sicuri)*: Rispetto dei vincoli geometrici e dei livelli sonori salvavita (0.7f–0.8f);
   - *Cancello 4 (Named Contracts D0..DN / S1..SN)*: Scomposizione atomica delle modifiche complesse in contratti formali denominati;
   - *Cancello 5 (Determinismo Headless)*: Test seams headless a 0 ms senza dipendenze temporali né `OS.delay()` nei test runner;
   - *Cancello 6 (Budget Token & Anti-Bloat Normativo)*: Router $\le 250$ righe, zero duplicazioni testuali, percorsi relativi.

3. **Principio di Integrità Evolutiva & Bonifica dei Residui (Contratto D0 Clean Sweep)**:
   - Quando una logica, componente, risorsa o interfaccia viene sostituita da una nuova soluzione, è fatto divieto categorico di lasciare coesistere frammenti del vecchio meccanismo (campi orfani, nodi inutilizzati, logiche concorrenti).
   - Ogni piano di refactoring prevede obbligatoriamente il contratto **D0 Clean Sweep** per bonificare i residui prima del rilascio definitivo.

4. **Rete Documentale a 4 Nodi Comunicanti in `docs/` (Pointer Hub DRY)**:
   - `docs/strategie/`: Analisi concettuali e modelli mentali (Fase 0);
   - `docs/piani/`: Piani tecnici formali attivi e archiviati (Fase 1);
   - `docs/report/`: Registro Revisioni (`REGISTRO_REVISIONI.md`), archivio storico e report di sessione (Fase 2);
   - `docs/manuali/`: Guide operative, collaudi consolidati e Living Documentation (Fase 3 & 4).

5. **Pipeline Operativa a 4 Fasi, Disciplina AVF & Domanda Ponte Obbligatoria**:
   - *Fase 1A (Piano Tecnico & Stop)* $\to$ *Fase 1B (Esecuzione Tecnica & Test Headless)* $\to$ *Fase 2 (Deploy, Telemetria & Collaudo Manuale NVDA)* $\to$ *Fase 3 (Chiusura Tecnica, Git & AVF `V.A.R[.M]`)*.
   - **Chiusura Tassativa con Domanda Ponte**: Al termine della Fase 3, l'assistente formula sempre la domanda di transizione:
     > *"Vuoi che avviamo ora la sessione formale di Auto-Apprendimento (Fase 4) per elaborare la bozza dettagliata delle regole e aggiornare le schede di conoscenza e governance?"*
   - *Fase 4 (Auto-Apprendimento Continuo a Doppio Binario)*: Binario A (Locale in `knowledge/`) e Binario B (Globale nel Master Hub).

---

## 🧭 3. INDICE RAGIONATO DELLA BASE DI CONOSCENZA LOCALE (`knowledge/`)

- [`00_consuetudini_operative_e_sinergia_assistente.md`](./knowledge/00_consuetudini_operative_e_sinergia_assistente.md): Dialogo a 2 tempi, 12 Protocolli ASTRALIS, 7 Assi di Qualità, 3 Livelli di Simulazione ed Eliminazione Protetta.
- [`01_accessibilita_vocale_e_interazione_tastiera.md`](./knowledge/01_accessibilita_vocale_e_interazione_tastiera.md): Driver nativo AccessKit, Zero Mouse, standard audio (0.7f–0.8f, ducking) e pattern di Isolamento Modale.
- [`02_architettura_stack_e_runtime.md`](./knowledge/02_architettura_stack_e_runtime.md): Stack Godot 4.7.2 win64, GDScript 2.0, Clean Architecture e test seams headless a 0 ms.
- [`03_standard_git_branching_e_commit.md`](./knowledge/03_standard_git_branching_e_commit.md): Disciplina Git locale, Versionamento AVF (`V.A.R.M`) e Canone 7 (D41 Guard).
- [`04_struttura_progetto_e_gestione_dati.md`](./knowledge/04_struttura_progetto_e_gestione_dati.md): Confini dei dati, rete documentale a 4 nodi e albero delle directory Godot.
- [`05_game_design_e_vertical_slice.md`](./knowledge/05_game_design_e_vertical_slice.md): Living Documentation di Game Design, progressione stadi di carriera, Fasi 1–8 completate e Fase 9 Endgame attiva.
- [`09_registro_bug_e_soluzioni.md`](./knowledge/09_registro_bug_e_soluzioni.md): Registro storico delle cause radice verificate e soluzioni validate con misure anti-regressione.
- [`10_standard_piani_verifiche_e_living_documentation.md`](./knowledge/10_standard_piani_verifiche_e_living_documentation.md): Specifica formale dei 12 Protocolli Operativi ASTRALIS, checklist a 3 stati, Named Contracts e PRAPI.

---

## 🎯 4. PARAMETRI DEL PROGETTO

- **Scopo & Dominio**: Music Career Simulator & Life Simulation (gestione tempo, abilità, produzione brani, concerti live, economia, etichette e fanbase).
- **Responsabili**: Luca & Holy Diver.
- **Coordinatore Operativo**: [`docs/todo.md`](./docs/todo.md).
- **Stato Attuale**: Sezioni 1..12, Espansione Post-V5.1, Gameplay Grafico 2.5D Loft NYC, Albero Competenze Popomundo (V5.7.0/V5.8.0), Day Loop Overtime (V5.8.1), Songwriting Artigianale (V5.9.0), Bonifica Router/BandHub (V5.9.1) e Pacing Songwriting con Limiti 2 Sessioni & Avanzamento Temporale (V5.10.0); 33 suite headless convalidate con 0 errori a 0 ms; Versione AVF consolidata V5.10.0.
- **Stack Ufficiale Confermato**: Godot Engine 4.7.2.stable.official.ed1daf0bf win64, GDScript 2.0, Clean Architecture DDD, EventBus a segnali e AccessKit nativo.
