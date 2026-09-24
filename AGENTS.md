# World-tour — Direttive di Progetto per Codex / ChatGPT (ASTRALIS v3.0.7)
# Autore: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Target AI: OpenAI Codex / ChatGPT (Copilota Ausiliario e Peer Programmer - Opzionale)
# Hub di Contesto Primario: GEMINI.md
# Repository: pubblico (tommasofelix/World-tour) — Link relativi obbligatori, zero percorsi personali o segreti

Questo repository implementa il simulatore musicale **World-tour** in pair programming con **Luca**, sviluppatore completamente non vedente su Windows 11 con screen reader **NVDA** (**ZERO MOUSE**).
Tutta l'interazione con l'ambiente, il codice, la console e i log avviene tramite sintesi vocale (NVDA / SAPI), feedback acustici calibrati e comandi da tastiera completi. Formattazione rigorosamente lineare ad elenchi (divieto assoluto di tabelle o grafici 2D).

---

## ⚡ 1. REGOLA DI INGAGGIO E CARICAMENTO PROGRESSIVO (ON-DEMAND)

Per garantire la massima velocità di risposta e preservare la finestra di contesto di Codex:
- **Richieste brevi, chiarimenti o domande veloci**: usa unicamente questo file `AGENTS.md` e [`GEMINI.md`](./GEMINI.md) senza caricare la documentazione estesa.
- **Pianificazione, revisione approfondita o test**: consulta le Fonti di Verità caricando **esclusivamente da 1 a 3 schede pertinenti in `knowledge/`** (tramite l'Indice Ragionato in `GEMINI.md`).
- **Divieto di sovraccarico**: non caricare mai in massa l'intera cartella `knowledge/`, i piani archiviati in `docs/piani/completati/` o le revisioni storiche chiuse.

---

## 🏛️ 2. FONTI DI VERITÀ E REGOLE DI PROGETTO (POINTER HUB DRY)

- [`GEMINI.md`](./GEMINI.md): Hub centrale di contesto con le regole auree e i parametri del progetto.
- [`knowledge/`](./knowledge/): Base di conoscenza modulare (architettura, flussi, convenzioni e registro bug).
- [`docs/todo.md`](./docs/todo.md): Coordinatore Master e Roadmap delle fasi.
- [`docs/piani/attivi/`](./docs/piani/attivi/): Piani tecnici formali autorizzati (Sotto-Fase 1A/1B).
- [`docs/report/REGISTRO_REVISIONI.md`](./docs/report/REGISTRO_REVISIONI.md): Registro attivo delle anomalie e revisioni aperte (RRU).

---

## 🛡️ 3. VINCOLI TECNICI INVIOLABILI

1. **Regola 0 (Default Consultivo Permanente & Gating Semantico)**:
   - Non effettuare MAI modifiche autonome a file o codice senza il comando esplicito di Luca (*"procedi"*, *"applica"*, *"esegui"*).
   - Richieste come *"cosa ne pensi?"*, *"valuta"*, *"analizza"* richiedono risposte esclusivamente consultive.
   - Gating Fase 1: *"passa alla fase 1"* autorizza SOLO la stesura del piano tecnico (1A) con Stop Obbligatorio prima del codice (1B).
   - Validazione preventiva: proposta verificata sui **7 Assi di Qualità** e **3 Livelli di Simulazione**.
2. **Accessibilità Vocale & Zero Mouse**:
   - Nessuna interfaccia o funzionalità deve richiedere l'uso del mouse.
   - I volumi sonori ed effetti audio devono essere congelati a un massimo compreso tra `0.7f` e `0.8f` per non coprire mai la voce di NVDA.
3. **Protocollo 12 — Inner Codex Pattern (I 6 Cancelli Inviolabili)**:
   - *Cancello 1 (Rifiuto Patching Euristico)*: diagnosi deterministica della causa radice (RCA);
   - *Cancello 2 (Hardware Grounding)*: input diretto da tastiera, zero mouse;
   - *Cancello 3 (Hitbox, Clearance Continua & Volumi Sicuri)*: rispetto dei livelli sonori 0.7f–0.8f;
   - *Cancello 4 (Named Contracts D0..DN / S1..SN)*: scomposizione atomica delle modifiche;
   - *Cancello 5 (Determinismo Headless)*: test seams a 0 ms senza ritardi o `OS.delay()`;
   - *Cancello 6 (Budget Token & Anti-Bloat Normativo)*: router $\le 250$ righe, link relativi.
4. **Principio di Integrità Evolutiva & Bonifica dei Residui (Contratto D0 Clean Sweep)**:
   - Divieto di lasciare coesistere codice o strutture obsolete; bonifica verificata prima del rilascio.
5. **Disciplina di Versionamento AVF & Separazione Git**:
   - Calcolo deterministico della versione secondo la disciplina AVF (`V.A.R[.M]`).
   - L'autorizzazione al commit e all'aggiornamento della Living Documentation non autorizza il push remoto, che richiede assenso separato.
