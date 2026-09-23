# 10 — Standard Piani Tecnici, Verifiche & Living Documentation ASTRALIS (v3.0.7)

Questo documento definisce gli standard formali per la progettazione, redazione, verifica e archiviazione dei piani tecnici e della Living Documentation nell'ecosistema ASTRALIS.

---

## 🏛️ 1. I 12 Protocolli Operativi Ufficiali ASTRALIS

Ogni attività all'interno del progetto rientra in uno dei 12 protocolli operativi standard:

1. **Protocollo Progettazione** *(Fase 0 & Sotto-Fase 1A)*:
   - Scopo: Definire il modello mentale, i requisiti e l'architettura logica prima di modificare codice;
   - Output: Strategia logico-cognitiva in `docs/strategie/` o Piano Tecnico in `docs/piani/attivi/` con i contratti denominati D0..DN e Stop Obbligatorio.
2. **Protocollo Validazione** *(7 Assi di Qualità + Matrice di Simulazione a 3 Livelli)*:
   - Scopo: Certificare preventivamente la solidità del piano;
   - Assi: Validità, Efficacia, Coerenza, Completezza, Precisione NVDA, Affidabilità/Prestazioni, Assenza Regressioni;
   - Livelli: Happy Path (1), Alternative Paths (2), Corner Cases (3).
3. **Protocollo Esecuzione** *(Sotto-Fase 1B / Deploy Fase 2)*:
   - Scopo: Tradurre il piano validato in codice, compilazione ed esecuzione dei test automatici headless a 0 ms.
4. **Protocollo Telemetria & Monitoraggio in Tempo Reale** *(Fase 2)*:
   - Scopo: Ispezione dal vivo dei log applicativi durante il collaudo di Luca con NVDA, estraendo solo il segnale utile e registrando tempestivamente eventuali anomalie nel `REGISTRO_REVISIONI.md`.
5. **Protocollo Revisione & Affinamento Post-Implementazione (PRAPI)**:
   - Scopo: Gestire in modo chirurgico il feedback emerso in collaudo;
   - *Strategia dei Buffer di Rifinitura (Resequencing)*: Le rifiniture minori e le revisioni non bloccanti vengono formalmente accodate a valle del ciclo principale in un buffer dedicato, preservando l'inerzia dello sviluppo.
6. **Protocollo Chiusura** *(Fase 3)*:
   - Scopo: Consolidamento del lavoro a collaudo positivo confermato;
   - Passaggi: Commit semantico Git, calcolo nuova versione AVF (`V.A.R[.M]`), archiviazione del piano in `docs/piani/completati/` e formulazione della Domanda Ponte Obbligatoria.
7. **Protocollo Auto-Apprendimento Continuo** *(Fase 4)*:
   - Scopo: Capitalizzare le lezioni apprese su Doppio Binario:
     - *Binario A (Locale)*: Aggiornamento delle schede `knowledge/` del progetto;
     - *Binario B (Globale)*: Aggiornamento dei moduli universali nel Master Hub.
8. **Protocollo Aggiornamento & Migrazione Stack**:
   - Scopo: Gestire avanzamenti di versione dell'engine (Godot) o delle librerie con verifica di compatibilità e rollback garantito.
9. **Protocollo Diagnosi & Risoluzione Bug Sistemici**:
   - Scopo: Root Cause Analysis (RCA) deterministica per anomalie concorrenti, isolando log e test seams prima di intervenire.
10. **Protocollo Configurazione & Ambiente di Sviluppo**:
    - Scopo: Manutenzione delle automazioni PowerShell (`tools/`), setup CLI e portabilità delle variabili d'ambiente.
11. **Protocollo Pulizia, Bonifica & Rifinitura (Dead Code Purge)**:
    - Scopo: Eliminazione di logiche morte o superate con la Strategia a 5 Barriere, Contratto D0 Clean Sweep e Canone 7 (D41 Guard: commit di sicurezza preventivo).
12. **Protocollo Dialettica Ingegneristica & Auto-Revisione Avversariale (Inner Codex)**:
    - Scopo: Revisione critica autonoma basata sul rispetto dei 6 Cancelli Inviolabili.

---

## 🛡️ 2. Protocollo 12 — I 6 Cancelli Inviolabili (Inner Codex Pattern)

Prima di proporre o validare qualsiasi modifica tecnica, l'assistente DEVE sottoporre il piano all'audit preventivo dei 6 Cancelli:
- **Cancello 1 (Rifiuto Patching Euristico)**: Divieto di workaround fragili, ritardi artificiali o pesi fittizi. Risoluzione rigorosa della causa radice;
- **Cancello 2 (Hardware Grounding & Zero Mouse)**: Interazione completa e naturale da tastiera, disaccoppiando l'input grezzo da controlli di guardia reattivi;
- **Cancello 3 (Hitbox, Clearance Continua & Volumi Sicuri)**: Rispetto dei vincoli geometrici e limiti tassativi sui volumi audio (0.7f–0.8f max con ducking);
- **Cancello 4 (Named Contracts D0..DN / S1..SN)**: Scomposizione deterministica delle modifiche in contratti numerati atomici;
- **Cancello 5 (Determinismo Headless)**: Test unitari eseguibili a 0 ms senza dipendenze grafiche o temporali (`OS.delay()`);
- **Cancello 6 (Budget Token & Anti-Bloat Normativo)**: File router `GEMINI.md` e `AGENTS.md` sotto il limite di sicurezza di 250 righe, collegamenti relativi standard.

---

## 📋 3. Matrice di Gating a 3 Stati per NVDA

Ogni checklist di piano o roadmap adotta la convenzione a 3 stati:
- `- [ ] [DA AVVIARE]`: Attività pianificata ma non ancora iniziata;
- `- [/] [IMPLEMENTATO — IN ATTESA DI CONVALIDA]`: Modifica apportata o codice compilato, in attesa di test o collaudo formale (spunta parziale);
- `- [x] [CONVALIDATO CON SUCCESSO]`: Spunta definitiva concessa **esclusivamente POST-CONVALIDA** formale.
  - Per la Sotto-Fase 1A: Approvazione esplicita del piano da parte di Luca;
  - Per la Sotto-Fase 1B: Suite di test headless al 100% verde (exit code 0);
  - Per la Fase 2: Collaudo manuale reale in-game confermato da Luca con NVDA.

---

## 🏛️ 4. Anatomia dei Named Contracts (D0..DN)

Nei piani tecnici complessi, le modifiche sono organizzate in contratti numerati:
- **Contratto D0 — Clean Sweep Obbligatorio**: Bonifica preventiva o contestuale di residui, campi deprecati, codice morto o discrepanze della documentazione precedente;
- **Contratti D1..DN — Modifiche Strutturali & Dominio**: Contratti di dati, logica di sistema o refactoring di classi;
- **Contratti S1..SN — Contratti di Superficie & UI**: Interfaccia visiva, albero dei controlli, wiring segnali EventBus e annunci vocali AccessKit.

---

## 📜 5. Igiene Documentale & Living Documentation

1. **Single Source of Truth**: Ogni informazione tecnica vive in un solo luogo; gli altri documenti vi fanno riferimento tramite link relativi standard Markdown.
2. **Ordine Cronologico Inverso per i Log**: Nei registri delle revisioni (`REGISTRO_REVISIONI.md`, `ARCHIVIO_REVISIONI.md`) e nei report di sessione, le voci più recenti sono collocate sempre in cima, consentendo a Luca di ascoltare le ultime novità senza scorrere il testo storico.
3. **Budget Router & Dislocazione**: I router (`GEMINI.md`, `AGENTS.md`) contengono solo regole sintetiche e indici; i dettagli risiedono nelle schede `knowledge/`.
