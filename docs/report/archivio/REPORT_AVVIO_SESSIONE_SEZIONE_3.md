# Report di Handoff & Bootstrap — Avvio Sezione 3: La Band, Reclutamento, Dinamiche Relazionali & Revenue Split
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-23
# Percorso File: docs/report/REPORT_AVVIO_SESSIONE_SEZIONE_3.md
# File di Riferimento: docs/roadmap/03_band_reclutamento_dinamiche_e_revenue_split.md
# Priorità: P3 — Loop Sociale & Dinamiche di Band

---

## 🎯 1. OBIETTIVO DEL DOCUMENTO

Questo documento costituisce il **Report di Bootstrap / Handoff** pronto all'uso per avviare la **Sezione 3 della Roadmap Modulare** in pair programming con Antigravity.
Raccoglie la baseline tecnica consolidata, l'inventario dei sistemi esistenti e l'analisi dei requisiti specialistici per la stesura del **Piano Tecnico Formale (Sotto-Fase 1A)** nel pieno rispetto della Regola 0 e della governance ASTRALIS v3.0.7.

---

## 🏛️ 2. STATO DELL'ARTE DEL PROGETTO (BASELINE DI PARTENZA)

1. **Sezione 1 e Sezione 2 Completate e Archiviate al 100%**:
   - **Sezione 1 (Identità, Routine & Risorse)**: Creazione personaggio guidata, ciclo notte a 22h con overtime progressivo, skip time, riposo anticipato, triade risorse (Energia, Stress, Morale), stati di burnout/panico e modale `RelaxModal` (tasto `R`).
   - **Sezione 2 (Creatività Musicale & Produzione)**: 10 Temi Lirici con modello `LyricThemeData`, matrice sinergia genere-tema (+3.5, 0.0, -1.5), 3 nuovi tratti canzone (`GENERATIONAL_ANTHEM`, `TEARJERKER_BALLAD`, `EPIC_RIFF`), sconto martedì 20% studio professionale, calibrazione hardware home studio, rielaborazione bozze e annunci vocali dinamici per NVDA in `SongCreator`, `SongCatalog` e `AlbumCreator`.

2. **Integrità del Codice & Test Suite Headless (23 / 23 Suite Superate — 0 Errori)**:
   - Tutte le 23 suite di test del progetto sono convalidate con esito 100% verde:
     * `test_advanced_crafting_system.tscn` (65/65 OK)
     * `test_album_system.tscn` (61/61 OK)
     * `test_band_system.tscn` (44/44 OK)
     * `test_character_creation.tscn` (39/39 OK)
     * `test_chart_rival_system.tscn` (54/54 OK)
     * `test_concert_system.tscn` (53/53 OK)
     * `test_dilemma_system.tscn` (49/49 OK)
     * `test_economy_system.tscn` (46/46 OK)
     * `test_festival_system.tscn` (70/70 OK)
     * `test_formulas.gd` (24/24 OK)
     * `test_industry_system.tscn` (60/60 OK)
     * `test_localization.tscn` (30/30 OK)
     * `test_music_system.tscn` (125/125 OK)
     * `test_schedule_system.tscn` (73/73 OK)
     * `test_social_media_system.tscn` (65/65 OK)
     * `test_time_night_system.tscn` (28/28 OK)
     * `test_tour_system.tscn` (65/65 OK)
     * `test_travel_system.tscn` (64/64 OK)
     * `test_upgrades_system.tscn` (68/68 OK)
     * `test_v4_ui_integration.tscn` (44/44 OK)
     * `test_v5_ui_overhaul.tscn` (67/67 OK)
     * `test_vertical_slice.tscn` (65/65 OK)
     * `test_vital_resources_system.tscn` (37/37 OK)
   - Oltre 1.200 asserzioni complessive verificate, 0 fallimenti, runner headless protetto da watchdog timeout a 15 secondi in `tools/test.ps1`.

3. **Integrità Documentale & Working Tree Git**:
   - Piani attivi (`docs/piani/attivi/`): 100% pulita (Piano Sezione 2 archiviato in `docs/piani/completati/`).
   - Report attivi (`docs/report/`): pulita (Report Sezione 1 e Sezione 2 archiviati in `docs/report/archivio/`).
   - Registro Revisioni (`docs/report/REGISTRO_REVISIONI.md`): 0 anomalie aperte. Tutte le RCA storiche censite in `knowledge/09_registro_bug_e_soluzioni.md` (`BUG-001`..`BUG-004`).
   - Master Hub Globale: allineato al rilascio ASTRALIS `v3.0.9`.

---

## 👥 3. AMBITO DELLA SEZIONE 3: LA BAND, RECLUTAMENTO & DINAMICHE RELAZIONALI

Il documento specialistico di riferimento è [`docs/roadmap/03_band_reclutamento_dinamiche_e_revenue_split.md`](file:///c:/Users/nemex\OneDrive\Documenti\GitHub\World-tour\docs\roadmap\03_band_reclutamento_dinamiche_e_revenue_split.md).  
Articola l'evoluzione del sistema band in cinque macro-sottoaree:

### 3.1 Reclutamento Compagni, Bacheca Audizioni & Ruoli
- **Composizione Formazione**: Alex (protagonista) + massimo 3 compagni reclutabili (`Constants.MAX_BAND_MEMBERS` = 3) per formare un quartetto stabile (massimo 4 componenti).
- **I 4 Ruoli Strumentali complementari (`Enums.BandRole`)**:
  1. *Basso*: groove, stabilità ritmica e collante tra batteria e armonia.
  2. *Batteria*: ritmo, potenza sonora ed energia live.
  3. *Tastiere*: atmosfera, armonie complesse, pad e varietà timbrica.
  4. *Chitarra Ritmica*: compattezza dell'arrangiamento e muro di suono.
  *(Opzionale: Cantante se il protagonista si concentra esclusivamente su uno strumento).*
- **Bacheca delle Audizioni**:
  - Costo organizzazione provino: 30.0 € (`Constants.BAND_AUDITION_FEE`).
  - Generazione procedurale dei candidati: Nome, Età, Livello Abilità Strumentale e Profilo Psicologico/Caratteriale (es. Ambizioso, Collaborativo, Perfezionista, Ribelle, Mercenario).
  - Valutazione preventiva e compatibilità prima dell'ingaggio definitivo.

### 3.2 Dinamiche Umane & Indicatori Relazionali della Band
- **I Tre Indicatori Vitali di Gruppo**:
  1. *Affinità Umana (0 - 100)*: intesa personale, simpatia e coesione del gruppo fuori dal palco.
  2. *Rispetto Musicale (0 - 100)*: stima artistica e riconoscimento delle competenze tecniche ed esecutive.
  3. *Tensione Interna (0 - 100)*: attriti, divergenze creative, gelosie ed ego che logorano la convivenza.
- **Fattori di Modifica Dinamica**:
  - Concerti trionfali aumentano rispetto e affinità, riducendo la tensione.
  - Spettacoli fallimentari o disastri live accrescono la tensione e minano il rispetto.
  - Politiche economiche e decisioni morali (dilemmi) incidono direttamente sui rapporti interni.

### 3.3 Chimica di Gruppo, Sinergia Palco & Prove (Rehearsal)
- **Moltiplicatore Sinergia Palco**:
  - Calcolato combinando Affinità, Rispetto e Tensione: varia da un malus del `-15%` fino a un bonus del `+25%` sul punteggio concerto (`ConcertScore`).
- **Sessioni di Prove Band (Rehearsal)**:
  - Allenamento congiunto per consolidare l'intesa, ridurre la tensione accumulata e preparare i grandi concerti.

### 3.4 Politiche di Divisione Compensi (Revenue Split)
- **Gestione delle Politiche Economiche**:
  - `EQUAL_SPLIT` (Divisione Paritaria): 25% a testa su quartetto; massimizza il rispetto e mitiga la tensione.
  - `LEADER_MODERATE` (Quota Leader): 40% al protagonista, 20% agli altri compagni; equilibrio tra guadagno personale e stabilità.
  - `LEADER_PREDATORY` (Quota Predatoria): 70% al leader, 10% agli altri compagni; massimizza il profitto a breve termine ma scatena risentimento, crollo del rispetto e rapida escalation della tensione.

### 3.5 Crisi di Gruppo, Ultimatum & Rischio Abbandono
- **Soglia Critica di Tensione (> 85%)**:
  - Rischio concreto di lite furibonda e minaccia di abbandono da parte di uno o più componenti.
  - Opzioni di mediazione, concessioni economiche, chiarimenti o licenziamento con conseguente ricerca di un sostituto.

### 3.6 Accessibilità Assoluta Zero Mouse in `BandHub`
- Tasto rapido HUD `G` ("Band (G)").
- Navigazione riga per riga accessibile con sintesi vocale NVDA per esaminare lo stato dei compagni, le offerte della bacheca e le politiche di compenso.

---

## 📋 4. ISTRUZIONI DI AVVIO PER LA SESSIONE SUCCESSIVA

All'apertura della nuova chat/sessione su **World-tour**, Tom e Luca potranno inviare il seguente prompt per avviare direttamente la Sezione 3:

> *"Ciao Antigravity! Riprendiamo il pair programming su World-tour. Tutte le attività delle Sezioni 1 e 2 sono state completate, convalidate al 100% (23 suite headless a 0 errori) e interamente archiviate. Il working tree Git è pulito. Oggi apriamo ufficialmente la SEZIONE 3 della Roadmap Modulare: 'La Band, Reclutamento, Dinamiche Relazionali & Revenue Split' (File di riferimento: docs/roadmap/03_band_reclutamento_dinamiche_e_revenue_split.md e docs/report/REPORT_AVVIO_SESSIONE_SEZIONE_3.md). Come da Regola 0 e governance ASTRALIS, procedi con la Sotto-Fase 1A: analizza i requisiti, elabora il Piano Tecnico Formale in docs/piani/attivi/ ed effettua lo Stop Obbligatorio per attendere la nostra approvazione."*
