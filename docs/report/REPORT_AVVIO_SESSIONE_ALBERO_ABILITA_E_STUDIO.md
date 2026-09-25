# Report di Handoff & Bootstrap — Avvio Nuova Espansione: Albero delle Abilità Musicali & Studio Dinamico
# Autori: Luca, Thomas & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-25
# Percorso File: docs/report/REPORT_AVVIO_SESSIONE_ALBERO_ABILITA_E_STUDIO.md
# File di Riferimento:
#   - docs/strategie/sessione_approfondimento_gameplay/STRATEGIA_INTEGRALE_EVOLUZIONE_GAMEPLAY_POPOMUNDO.md
#   - docs/strategie/sessione_approfondimento_gameplay/STRATEGIA_ALBERO_ABILITA_E_METODI_STUDIO.md
# Baseline AVF: V5.6.4
# Priorità: P0 — Modello Competenze 6 Rami, 5 Gradi di Maestria & 4 Metodi di Studio nel Loft NYC

---

## 🎯 1. OBIETTIVO DEL DOCUMENTO

Questo documento formalizza il **Report di Bootstrap & Handoff** per l'avvio della nuova macro-fase di gameplay profondo ispirata alle migliori meccaniche di **Popomundo** e della **Popoguida**, adattate all'architettura reattiva e nativamente accessibile di **World-tour**.

L'obiettivo immediato è la **stesura del Piano Tecnico Formale (Sotto-Fase 1A)** per la prima tranche operativa:
* **Oggetto della Tranche**: L'Albero delle Abilità a 6 rami e 5 gradi di maestria, integrato organicamente con le routine di studio e relax nel Loft NYC (manuali sul divano, lezioni del maestro a domicilio, pratica individuale e ascolto vinili al giradischi).

---

## 🏛️ 2. STATO DELL'ARTE DEL CODEBASE (BASELINE DI PARTENZA)

1. **Stato Attuale del Progetto (Baseline AVF V5.6.4)**:
   - Sezioni 1..12 e relative espansioni (Endless Horizon, New Game+, Festival Estivi, Hit Parade, Industria Discografica e Legacy) convalidate al 100%.
   - Gameplay grafico e testuale 2.5D Loft NYC con navigazione ad auto-walk, clearance hitbox, stato `GAMEPLAY_BUSY`, timer progressivi `duration_seconds` e menu di interazione dinamico a pergamena.
   - Piena conformità di sistema: **30 suite di test headless convalidate con 0 errori a 0 ms**.
   - Working tree Git pulito, totale assenza di regressioni e accessibilità nativa per NVDA (Zero Mouse).

2. **Fonti di Verità Strategiche Convalidate (Fase 0 Conclusa)**:
   - [`docs/strategie/sessione_approfondimento_gameplay/STRATEGIA_INTEGRALE_EVOLUZIONE_GAMEPLAY_POPOMUNDO.md`](../strategie/sessione_approfondimento_gameplay/STRATEGIA_INTEGRALE_EVOLUZIONE_GAMEPLAY_POPOMUNDO.md): Quadro sistemico unificato che concilia la vita della band (sale prove, repertorio, decay, setlist flow, crew da tour e saturazione di piazza) con la vita del singolo artista.
   - [`docs/strategie/sessione_approfondimento_gameplay/STRATEGIA_ALBERO_ABILITA_E_METODI_STUDIO.md`](../strategie/sessione_approfondimento_gameplay/STRATEGIA_ALBERO_ABILITA_E_METODI_STUDIO.md): Specifica formale dell'Albero delle Abilità articolato in 6 rami, 5 gradi di maestria e i 4 metodi di studio tangibili.

---

## 🌟 3. SPECIFICA DEI REQUISITI DELLA PRIMA FASE IMPLEMENTATIVA

La prima fase di sviluppo (Fase 1) si concentrerà sui seguenti contratti architetturali:

### 3.1 Estensione del Modello Dati del Giocatore (`PlayerData`)
- Distinzione tra **Attributi Fisiologici Innati** (`musicality`, `intelligence`, `stamina`, `charm`) e **Competenze Specialistiche**.
- Struttura a dizionario per le competenze articolata nei **6 Rami**:
  1. *Cultura & Padronanza dei Generi*: Rock Classico, Heavy Metal, Blues, Pop/Synth, Punk, Jazz, Folk.
  2. *Competenze Strumentali & Vocali*: Chitarra Elettrica (ritmica/assoli/pedali), Canto (respirazione diaframmatica/estensione/voce graffiata), Basso (fingerstyle/plettro/slap), Batteria (precisione/dinamiche/doppio pedale), Tastiere & Synth.
  3. *Composizione & Scrittura*: Teoria Musicale & Armonia, Scrittura Testi & Metrica, Ballate, Inni da Stadio, Riff & Hook, Storia del Genere.
  4. *Palco & Intrattenimento*: Presenza Scenica, Interazione col Pubblico, Improvvisazione Live, Coordinazione Fisica.
  5. *Studio & Liuteria*: Produzione Discografica, Tecnico del Suono Live, Liuteria & Manutenzione Strumentale.
  6. *Business & Media*: Relazioni coi Media, Negoziazione Contrattuale, Marketing Digitale.
- Scala di avanzamento deterministica per ciascuna abilità su **5 Gradi di Padronanza (Stelle 1–5)** con punti esperienza specifici.

### 3.2 I 4 Metodi di Studio Integrati nel Loft NYC (`ApartmentInteractions`)
Le interazioni con gli arredi del Loft dovranno accogliere le routine di apprendimento:
1. **Manuali & Libri di Testo**: Ordinabili tramite il PC del Loft; lettura a blocchi di 2 ore sul Divano o sul Letto per sbloccare il Grado 1 di una nuova competenza.
2. **Accademia / Conservatorio**: Accessibile tramite il PC o la mappa della metropoli; frequenza bisettimanale per portare le abilità dal Grado 1 al Grado 3.
3. **Lezioni Private con Maestro NPC**: Ingaggio a domicilio (es. 50 €/ora) per accelerare dal Grado 3 al Grado 5.
4. **Pratica Individuale & Ascolto Vinili**:
   - Esercizio alle dita/voce sul divano a costo zero per mantenere l'agilità;
   - *Ascolto al Giradischi / Stereo*: Ogni sessione di ascolto vinile rigenera Morale, riduce Stress e **conferisce un incremento progressivo passivo nella competenza del Genere Musicale ascoltato**.

### 3.3 Regole di Propedeuticità ("Se... Allora") & Verifiche Headless
- Applicazione dei prerequisiti ad albero (es. Grado 2 Teoria Musicale per sbloccare Composizione Inni o Ballate; Grado 2 Canto per Respirazione Diaframmatica).
- Creazione di una nuova test suite dedicata: `test_skills_and_loft_study_system.gd` a 0 errori e 0 ms.

---

## 🚦 4. GATING SEMANTICO: RICHIESTA DEL PIANO TECNICO FORMALE (SOTTO-FASE 1A)

In conformità rigorosa alla **Regola 0 (Default Consultivo Permanente)** e al **Protocollo 12 (Inner Codex Pattern)**:
* L'apertura della nuova chat deve essere finalizzata **esclusivamente alla stesura del Piano Tecnico Formale (Sotto-Fase 1A)** in `docs/piani/attivi/PIANO_TECNICO_ALBERO_ABILITA_E_STUDIO_LOFT.md`.
* È fatto **divieto categorico di toccare codice sorgente o configurazioni prima dell'approvazione esplicita di Luca e Thomas** (Stop Obbligatorio della Sotto-Fase 1A).

---

## 📋 5. PROSSIMO PASSO OPERATIVO

Copiare e incollare il prompt predisposto nella nuova chat per inizializzare il contesto pulito e avviare l'elaborazione del Piano Tecnico.
