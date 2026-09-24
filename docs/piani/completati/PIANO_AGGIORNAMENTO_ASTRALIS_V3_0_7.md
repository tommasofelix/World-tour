# Piano Tecnico AGG-01: Aggiornamento Governance Locale World-tour (ASTRALIS v3.0.7)
- **Tipologia:** REFACTORING GOVERNANCE / MIGRAZIONE FRAMEWORK
- **Autore:** Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
- **Revisori:** Luca & Antigravity
- **Data e Ora:** 2026-09-23
- **Stato Operativo:** [COMPLETATO E ARCHIVIATO]
- **Incremento Versione Target (AVF):** Governance Locale v3.0.7
- **Piani, Strategie & Documenti Correlati:**
  * Hub di Contesto Locale: [`GEMINI.md`](../../GEMINI.md)
  * Direttive Codex: [`AGENTS.md`](../../AGENTS.md)
  * Master Roadmap: [`docs/todo.md`](../todo.md)
  * Registro Revisioni: [`docs/report/REGISTRO_REVISIONI.md`](../report/REGISTRO_REVISIONI.md)
- **Conformità ai 6 Cancelli (Protocollo 12):** Audit preventivo sui 6 Cancelli Inviolabili superato

---

## 🗺️ Sommario Operativo & Registro di Avanzamento (Checklist con Gating di Convalida)

> **Regola Aurea di Avanzamento**:
> - `- [ ] [DA AVVIARE]`: Attività pianificata ma non ancora iniziata.
> - `- [/] [IMPLEMENTATO — IN ATTESA DI CONVALIDA]`: Codice scritto o intervento completato, in attesa di test o collaudo formale.
> - `- [x] [CONVALIDATO CON SUCCESSO]`: Spunta definitiva concessa **esclusivamente POST-CONVALIDA** (test automatici ed evidenza verificata).

- [x] **Sotto-Fase 1A — Progettazione, Named Contracts & Validazione (Stop Obbligatorio)**
  - [x] Redazione piano tecnico e requisiti di allineamento ad ASTRALIS v3.0.7 [CONVALIDATO CON SUCCESSO]
  - [x] Scomposizione in Named Contracts (D0..D4) [CONVALIDATO CON SUCCESSO]
  - [x] Audit Preventivo dei 6 Cancelli Inviolabili (Protocollo 12) [CONVALIDATO CON SUCCESSO]
  - [x] Gating di Approvazione: Via libera esplicito di Luca (*"si procedi pure"*) [CONVALIDATO CON SUCCESSO]
- [x] **Sotto-Fase 1B — Esecuzione Tecnica & Aggiornamento File**
  - [x] Contratto D0: Bonifica residui e descrizioni storiche disallineate (`knowledge/00`, `01`, `03`, `05`) [CONVALIDATO CON SUCCESSO]
  - [x] Contratto D1: Aggiornamento Router di Ingresso (`GEMINI.md` e `AGENTS.md`) ad ASTRALIS v3.0.7 [CONVALIDATO CON SUCCESSO]
  - [x] Contratto D2: Aggiornamento Moduli Core Knowledge (`knowledge/00`, `01`, `02`) [CONVALIDATO CON SUCCESSO]
  - [x] Contratto D3: Aggiornamento Moduli Operativi, Git & Living Doc (`knowledge/03`, `04`, `05`, `10`) [CONVALIDATO CON SUCCESSO]
  - [x] Contratto D4: Allineamento Struttura Modello nel Registro Revisioni (`docs/report/REGISTRO_REVISIONI.md`) [CONVALIDATO CON SUCCESSO]
  - [x] Esecuzione verifiche di igiene (0 percorsi assoluti, router < 250 righe) e test headless motore Godot (24/24 superati, exit code 0) [CONVALIDATO CON SUCCESSO]
- [x] **Fase 2 — Collaudo Manuale NVDA & Verifica Linearità**
  - [x] Verifica della lettura vocale fluida e lineare con NVDA riga per riga dei router e delle schede [CONVALIDATO CON SUCCESSO]
- [x] **Fase 3 — Chiusura Tecnica & Domanda Ponte per Fase 4**
  - [x] Consolidamento modifiche, archiviazione piano in `docs/piani/completati/` e domanda ponte [CONVALIDATO CON SUCCESSO]

---

## 📌 1. Quadro di Riferimento & Motivazione Architetturale

### 1.1 Sintesi del Requisito
Il progetto World-tour impiegava una baseline storica iniziale (`ASTRALIS main@d28d1f9`). Nel frattempo, il Master Hub universale è avanzato ad **ASTRALIS v3.0.7**, formalizzando protocolli operativi, cancelli di non-regressione, standard audio anti-mascheramento e disciplina AVF. L'obiettivo è allineare integralmente l'infrastruttura di governance locale di World-tour, rispettando la natura di repository pubblico (link relativi, zero percorsi personali, rispetto del budget $\le 250$ righe nei router).

### 1.2 Audit dei 6 Cancelli Inviolabili (Protocollo 12)
1. *Cancello 1 (Rifiuto Patching Euristico)*: Risoluzione alla radice di tutte le descrizioni obsolete e non conformi.
2. *Cancello 2 (Hardware Grounding & Zero Mouse)*: Interazione 100% da tastiera e supporto AccessKit consolidati.
3. *Cancello 3 (Hitbox & Clearance / Volumi di Sicurezza)*: Volumi audio/musica congelati tra `0.7f` e `0.8f` con ducking e allarmi con transienti metallici rapidi.
4. *Cancello 4 (Named Contracts D0..DN)*: Scomposizione atomica nei contratti D0..D4.
5. *Cancello 5 (Determinismo Headless a 0 ms)*: Suite di test headless per Godot CLI convalidate senza attese temporali fittizie.
6. *Cancello 6 (Budget Token & Anti-Bloat Normativo)*: Router `GEMINI.md` e `AGENTS.md` ampiamente sotto il tetto delle 250 righe.

---

## 🏛️ 2. Named Contracts di Implementazione

- **Contratto D0 — Clean Sweep Residui Storici**:
  - Eliminazione di ogni menzione di dominio non determinato o implementazione non avviata in `knowledge/`.
- **Contratto D1 — Router di Ingresso Master**:
  - `GEMINI.md`: Aggiornamento ad ASTRALIS v3.0.7, Regola 0, 12 Protocolli, 6 Cancelli, Audio Safety, D0 Clean Sweep, Domanda Ponte.
  - `AGENTS.md`: Aggiornamento ad ASTRALIS v3.0.7, caricamento progressivo on-demand, 6 Cancelli, zero mouse.
- **Contratto D2 — Knowledge Core**:
  - `knowledge/00_consuetudini_operative_e_sinergia_assistente.md`: Mappatura 12 protocolli, pipeline 4 fasi, 7 assi di qualità, eliminazione protetta a 5 passi.
  - `knowledge/01_accessibilita_vocale_e_interazione_tastiera.md`: Driver AccessKit nativo, isolamento modale (RRU-04), sicurezza acustica 0.7f-0.8f.
  - `knowledge/02_architettura_stack_e_runtime.md`: Determinismo headless a 0 ms e 17 suite CLI.
- **Contratto D3 — Knowledge Operativa & Git**:
  - `knowledge/03_standard_git_branching_e_commit.md`: Disciplina AVF (`V.A.R.M`), Canone 7 (D41 Guard), disaccoppiamento commit vs push.
  - `knowledge/04_struttura_progetto_e_gestione_dati.md`: Rete a 4 nodi comunicanti (Pointer Hub DRY) in `docs/`.
  - `knowledge/05_game_design_e_vertical_slice.md`: Living documentation di game design con Fasi 1–8 completate e Fase 9 attiva.
  - `knowledge/10_standard_piani_verifiche_e_living_documentation.md`: Specifica dei 12 protocolli, 3 stati per NVDA, Named Contracts, PRAPI.
- **Contratto D4 — Registri & Standard Report**:
  - `docs/report/REGISTRO_REVISIONI.md`: Modello voce allineato allo standard RRU ASTRALIS v3.0.7.
