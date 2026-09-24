# Report di Handoff & Bootstrap — Avvio Sezione 7: Grandi Festival Estivi all'Aperto
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-24
# Percorso File: docs/report/REPORT_AVVIO_SESSIONE_SEZIONE_7.md
# File di Riferimento: docs/roadmap/07_grandi_festival_estivi.md
# Baseline AVF: V4.6.0
# Priorità: P7 — Eventi Stagionali, Cartelloni Ufficiali, Slot Orari, Battle of the Bands & Steal the Show

---

## 🎯 1. OBIETTIVO DEL DOCUMENTO

Questo documento costituisce il **Report di Bootstrap & Handoff** per l'apertura ufficiale della **Sezione 7 della Roadmap Modulare** di **World-tour** ("Grandi Festival Estivi all'Aperto").
Fornisce la sintesi dei requisiti, lo stato consolidato del codebase (23 suite headless convalidate con 0 errori a 0 ms, versione AVF `V4.6.0`), e le direttrici operative per formulare il Piano Tecnico Formale (Sotto-Fase 1A).

---

## 🏛️ 2. STATO DELL'ARTE DEL CODEBASE (BASELINE DI PARTENZA)

1. **Sezioni 1, 2, 3, 4, 5 e 6 Completate e Archiviate al 100%**:
   - **Sezione 1 (Identità, Routine & Risorse)**: Creazione personaggio guidata, ciclo notte 22h, overtime progressivo, skip time, riposo anticipato, triade vitale e `RelaxModal`.
   - **Sezione 2 (Creatività Musicale & Produzione)**: 10 Temi Lirici, tratti canzone speciali, sconto studio martedì, pipeline 6 fasi in `SongCreator`, `SongCatalog` e `AlbumCreator`.
   - **Sezione 3 (La Band, Reclutamento & Dinamiche Relazionali)**: 5 ruoli strumentali, 8 personalità, bacheca audizioni con formula rifiuto, prove di gruppo e Revenue Split.
   - **Sezione 4 (Strumenti, Sala Prove, Home Studio & Upgrades Hub)**: Negozio multicategoria con comparatore e dotazione band, 5 pedali e 2 amplificatori, insonorizzazione e sub-affitto passivo sala prove, nastro analogico vs digitale, usura, muletto van e manutenzione liutaio.
   - **Sezione 5 (Concerti dal Vivo, Locali, Scaletta & Pubblico)**: Circuito a 6 locali (inclusi Centro Sociale Occupato e Teatro d'Opera Storico), disponibilità e calendario venue con occupazione procedurale e maggiorazione weekend (+20%), drammaturgia scaletta (Opener, Mid Ballad, Closer Stage Beast) e cover famose, 7 Stage Events procedurali a bivi con check abilità, banchetto Merchandising al Foyer (4 articoli) e momento Bis / Encore su score >= 85, modale `LiveConcert` (tasto `L`).
   - **Sezione 6 (Geografia, Metropoli & Tournée)**: Rete a 12 metropoli (inclusi Dublino, Parigi, Madrid, New York, Los Angeles, Tokyo), eventi cittadini temporanei (Notte Bianca, Fiera della Musica, Festival Urbano), tratte transoceaniche con Jet Lag (2 giorni, -20% efficienza energetica), Custom Tour Builder flessibile (2-8 date) con Day Off rigeneranti (+25 energia, -20 stress, -15 tensione band), interviste radiofoniche promozionali mattutine (+10% Hype, +25 fan locali), adesivi del veicolo e 4 imprevisti procedurali a bivi, modale `TravelModal` (tasto `V`) e `TourModal` (tasto `O`).
2. **Integrità del Codice & Suite Headless**:
   - **23 suite headless convalidate con 0 errori e zero regressioni** (inclusi 98 test in `test_tour_system.gd` e 64 test in `test_travel_system.gd`).
   - Watchdog timeout a 15 secondi (`tools/test.ps1`).
   - Verifica sintattica 91/91 file GDScript pulita con 0 errori (`tools/check.ps1`).
3. **Persistenza & Accessibilità**:
   - `SaveManager` blindato con serializzazione di tutti i modelli.
   - `AccessibilityManager` con gating semantico e annunci vocali lineari per NVDA.
   - Working tree Git pulito e versione AVF: **`V4.6.0`**.

---

## 🎪 3. I PILASTRI DELLA SEZIONE 7 (ROADMAP MODULARE 07)

Il documento specialistico di riferimento è [`docs/roadmap/07_grandi_festival_estivi.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/roadmap/07_grandi_festival_estivi.md).

### 7.1 Stagione Estiva Rigorosa (Mesi 4-6) & Cartelloni Ufficiali
- Stagione estiva attiva nei mesi 4, 5 e 6 (giorni 85-168 del calendario annuale).
- Grandi festival all'aperto nelle metropoli con date prestabilite, requisiti di reputazione/fan e cartelloni con band rivali.
- Influenza del Manager professionista o squalo nell'abbattere i requisiti di accesso e negoziare cachet garantiti superiori.
- Festival tematici iconici per genere musicale (Metal open air, Indie/Rock festival, Electro parade).

### 7.2 Slot Orari di Esibizione & Progressione di Cartellone
- 3 fasce orarie distinte con pubblico, pressione scenica e ricavi crescenti:
  1. *Slot Pomeridiano* (Opening Act): pubblico disperso, grande occasione per farsi notare (+fan conversion, cachet contenuto).
  2. *Slot Tramonto* (Sunset Sub-Headliner): atmosfera magica, pubblico compatto, ottimo bilanciamento visibilità e cachet.
  3. *Slot Serale / Headliner*: arena gremita, massima pressione scenica, cachet stellare, fuochi d'artificio e impatto mediatico nazionale.

### 7.3 Meccanica "Rubare la Scena" (Steal the Show) & Interazione Band Rivali
- Confronto diretto delle performance contro le band rivali presenti sullo stesso cartellone festivaliero.
- Se lo show della band supera le aspettative (Concert Score elevato e check Carisma/Performance): bonus *Steal the Show* (+30% conversione fan dagli spettatori delle altre band, risonanza mediatica e boost morale).

### 7.4 Contest Emergenti Primaverili ("Battle of the Bands")
- Competizioni primaverili (Mese 3) per band emergenti che non possiedono ancora la reputazione necessaria: vincere la battle garantisce un posto d'onore nel cartellone estivo del festival.

### 7.5 Banchetto Merchandising Intensivo & Interfaccia Accessibile
- Vendita intensiva di merchandising da grande festival (moltiplicatore x2.5 - x5.5 rispetto ai normali concerti nei club).
- Modale `FestivalModal` (tasto rapido HUD `F`) con navigazione accessibile da tastiera, annunci lineari per NVDA e zero mouse.

---

## 📋 4. PROMPT PRONTO PER LA NUOVA CHAT (AVVIO SEZIONE 7)

```text
Ciao Antigravity! Riprendiamo il pair programming su World-tour. Tutte le attività delle Sezioni 1, 2, 3, 4, 5 e 6 sono state completate, convalidate al 100% (23 suite headless a 0 errori) e interamente archiviate. Il working tree Git è pulito e la versione AVF è V4.6.0. Oggi apriamo ufficialmente la SEZIONE 7 della Roadmap Modulare: 'Grandi Festival Estivi all'Aperto' (File di riferimento: docs/roadmap/07_grandi_festival_estivi.md e docs/report/REPORT_AVVIO_SESSIONE_SEZIONE_7.md). Come da Regola 0 e governance ASTRALIS v3.0.7, procedi con la Sotto-Fase 1A: analizza i requisiti, l'integrazione con FestivalSystem, ScheduleSystem e ConcertSystem, elabora il Piano Tecnico Formale in docs/piani/attivi/ ed effettua lo Stop Obbligatorio per attendere la nostra approvazione.
```
