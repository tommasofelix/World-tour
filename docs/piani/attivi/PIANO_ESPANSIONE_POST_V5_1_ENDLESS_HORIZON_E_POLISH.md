# Piano Tecnico Operativo — Espansione Post-V5.1: Endless Horizon, Nuove Metropoli & Polish Globale (Versione AVF V5.2.0 / V6.0.0)
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.10 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-24
# Stato: [/] [IMPLEMENTATO — IN ATTESA DI CONVALIDA MANUALE] (Sotto-Fase 1B Convalidata al 100% con 28/28 Suite Headless a 0 ms)
# File Piano: docs/piani/attivi/PIANO_ESPANSIONE_POST_V5_1_ENDLESS_HORIZON_E_POLISH.md
# Coordinatore Master: docs/todo.md
# Baseline AVF: V5.1.0 (Target Versione: V5.2.0 per Polish/Balancing o V6.0.0 per Espansione Completa)

---

## 🎯 1. OBIETTIVO E PERIMETRO DELL'ESPANSIONE POST-V5.1

Con il completamento di tutte le 12 sezioni tematiche della Roadmap storica (dalle origini nel garage fino agli stadi da 65.000 spettatori, ai World Music Awards e al sound design accessibile con tastierino numerico), *World-tour* ha raggiunto una maturità ludica ed architetturale senza precedenti.
Il presente piano definisce la successiva grande era evolutiva del progetto, strutturata su due macro-direttrici complementari:

1. **Direttrice A — Lucidatura Globale & Polish (Quality Gate V5.2.0)**:
   - Bonifica formale dei piani pregressi in `attivi/` (archiviazione definitiva della Sezione 11);
   - Audit semantico bilingue delle 291 chiavi tra `localization/it.json` e `localization/en.json` con blindatura anti-fallback;
   - Stress test e bilanciamento macro-economico delle curve di costo/ricavo stadi, concerti e produzioni sceniche;
   - Calibrazione delle pause di sintesi vocale e riverbero acustico degli earcons procedurali a volume protetto (<= 0.75f).

2. **Direttrice B — Espansione Post-V5.1: Endless Horizon & World Empire (Traguardo V6.0.0)**:
   - **Modalità Carriera Infinita (Endless Sandbox)**: Superato l'epilogo di fine anno e il concerto "The Last Waltz", il giocatore può scegliere di continuare la carriera a tempo indeterminato (Anno 2, Anno 3...), mantenendo contratti, festival e classifiche dinamiche;
   - **Meccanica New Game+ (Legacy Heirs / Il Discepolo)**: Possibilità di ricominciare una nuova avventura artistica nei panni di una giovane promessa sponsorizzata dalla superstar della partita precedente, ereditando uno strumento storico, royalties passive di sussistenza e un tratto unico;
   - **Circuito Mondiale a 16 Metropoli**: Espansione dai 12 centri attuali a 16 metropoli globali con l'aggiunta del circuito Pan-Americano e Asia-Pacifico (San Paolo, Buenos Aires, Sydney, Seoul) con festival dedicati, fusi orari e jet lag transoceanico;
   - **Magnate Discografico Attivo**: Potenziamento della propria etichetta discografica indipendente (`OwnLabelData`), con produzione esecutiva di dischi per il roster di giovani band, inserimento nelle classifiche settimanali della Hit Parade e dividendi discografici periodici.

---

## 🛡️ 2. PROTOCOLLO 12 — I 6 CANCELLI INVIOLABILI (INNER CODEX)

- **Cancello 1 (Rifiuto Patching Euristico)**:
  - Nessun moltiplicatore forfettario o peso fittizio per l'Endless Mode; la continuità temporale si basa sulla progressione deterministica del calendario `CalendarData` (avanzamento dell'anno a ciclo continuo ogni 12 mesi);
  - Le nuove 4 metropoli adottano la stessa matrice rigorosa di distanze, affinità e consumi energetici di `TravelSystem`.
- **Cancello 2 (Hardware Grounding & Zero Mouse)**:
  - 100% accessibile da tastiera: nessun elemento di gioco richiede puntamento visuale;
  - Piena integrazione con il Numpad Navigation System (`KP_5` per stato, `KP_7`/`KP_9` per salto a blocchi continentali Europa/Americhe/Asia-Pacifico).
- **Cancello 3 (Hitbox, Clearance Continua & Volumi Sicuri)**:
  - Volumi sonori ed effetti congelati rigorosamente a valori $\le 0.75\text{f}$ (-2.5 dB);
  - Ducking automatico al 40% durante gli annunci vocali dello screen reader NVDA;
  - Segnali acustici ad alto contrasto per annunci critici.
- **Cancello 4 (Named Contracts D0..DN / S1..SN)**:
  - Scomposizione atomica delle attività in contratti numerati, ciascuno coperto da suite automatizzate indipendenti.
- **Cancello 5 (Determinismo Headless)**:
  - Test seams headless a 0 ms: tutti i test dell'espansione e del bilanciamento devono essere eseguiti senza ritardi temporali artificiali né `OS.delay()`.
- **Cancello 6 (Budget Token & Anti-Bloat Normativo)**:
  - Link relativi Markdown conformi allo standard;
  - Nessuna duplicazione o testo ridondante nei log.

---

## 📐 3. SCOMPOSIZIONE ATOMICA IN NAMED CONTRACTS

### 🧹 CONTRATTO D0: Clean Sweep & Polish Globale (V5.2.0 Baseline)
- **D0.1 (Archiviazione Piani)**: Trasferimento di `PIANO_SEZIONE_11_ENDGAME_GRANDI_STADI_E_LEGACY.md` da `docs/piani/attivi/` a `docs/piani/completati/` con marcatura formale `[x] [CONVALIDATO CON SUCCESSO]`;
- **D0.2 (Audit Bilingue It/En)**: Verifica riga per riga di simmetria per le 291 chiavi correnti; aggiunta di test automatico in `test_localization.gd` per impedire derive asimmetriche;
- **D0.3 (Bilanciamento Formule Stadi & Produzioni)**: Calibrazione numerica in `Formulas` e `ConcertSystem` per garantire che i costi operativi dei grandi stadi (35.000 € - 180.000 €) lascino un margine di profitto commisurato al successo dell'evento, preservando la sostenibilità dell'Endless Mode;
- **D0.4 (Audit Vocale NVDA & Earcons)**: Verifica dei buffer di timing negli annunci AccessKit durante le transizioni di schermata.

---

### 🏛️ CONTRATTO D1: Modalità Carriera Infinita & New Game+ (Endless Horizon)
- **D1.1 (Modello Dati Endless & Ciclo Annuale)**:
  - Estensione di `CalendarData` con il campo `current_year: int = 1`;
  - Al termine del Giorno 336 (Mese 12, Giorno 28), se il giocatore sceglie di proseguire, l'anno si incrementa (`current_year += 1`), il mese si resetta a 1 e il ciclo dei festival/awards riparte con nuove sfide;
- **D1.2 (Bivio Finale Espanso in `LegacySystem`)**:
  - Al Mese 12, post-concerto "The Last Waltz", il giocatore accede a tre percorsi distinti:
    1. *Ritiro Ufficiale (Epilogo Narrativo)*: Archiviazione della carriera con salvataggio nell'Albo d'Oro;
    2. *Endless Horizon (Carriera Eterna)*: La band non si scioglie, lo status di Superstar Mondiale permane e si continua a comporre, rilasciare album e suonare negli stadi;
    3. *New Game+ (L'Erede Musicale)*: Chiusura della partita corrente e generazione di un salvataggio speciale `user://new_game_plus.json` con i bonus per la nuova partita;
- **D1.3 (Sottosistema New Game+ / Legacy Heirs)**:
  - Creazione del tratto `LEGACY_DISCIPLE`: +10% XP a tutti gli strumenti, +15 rispetto iniziale reclute;
  - Eredità di 1 strumento leggendario posseduto dal mentore;
  - Rendita passiva quotidiana (15.00 € / giorno da catalogo mentore) a tutela della sussistenza iniziale;
  - Memorizzazione del nome del mentore nella scheda personaggio (`PlayerData.mentor_name`).

---

### 🌍 CONTRATTO D2: Espansione Geografica a 16 Metropoli (Circuito Pan-Americano & Asia-Pacifico)
- **D2.1 (Nuove Metropoli Mondiali in `CityData`)**:
  - `sao_paulo`: San Paolo (Brasile), affinità Metal/Hard Rock (+30% affluenza show energici), vendite merch +35%, volo intercontinentale;
  - `buenos_aires`: Buenos Aires (Argentina), affinità Alternative/Indie, +25% conversione fan;
  - `sydney`: Sydney (Australia), affinità Classic Rock/Pub Rock, Jet Lag trans-pacifico;
  - `seoul`: Seoul (Corea del Sud), affinità Pop/Electronic, bonus +50% views BandFeed e live streaming follower;
- **D2.2 (Integrazione `TravelSystem` & `TourSystem`)**:
  - Matrice costi e distanze per le nuove tratte intercontinentali;
  - Integrazione delle 4 nuove metropoli nel Custom Tour Builder;
- **D2.3 (Festival Estivi & Nuove Arene/Stadi)**:
  - Estensione del calendario festivaliero estivo a 16 grandi festival mondiali in `FestivalSystem`;
  - Nuove venue dedicate per le 4 metropoli (es. Allianz Parque/Morumbi a San Paolo, River Plate a Buenos Aires, SuperDome a Sydney, Olympic Stadium a Seoul).

---

### 🎙️ CONTRATTO D3: Magnate Discografico & Gestione Attiva Roster
- **D3.1 (Modello Dati Roster Discografico)**:
  - Estensione di `OwnLabelData` con dettagli delle band prodotte: `genre`, `current_popularity`, `lead_single_quality`, `albums_released`;
- **D3.2 (Produzione Esecutiva Brani Roster in `IndustrySystem`)**:
  - Azione accessibile da parte del giocatore per finanziare un album di una band del proprio roster (Budget Base 2.000 €, Budget Avanzato 5.000 €, Budget Top Tier 10.000 € con impatto sulla qualità finale);
- **D3.3 (Integrazione Hit Parade & Dividendi in `ChartSystem`)**:
  - Inserimento delle uscite delle band della label nella simulazione settimanale della Top 10 Singoli e Top 10 Album;
  - Calcolo deterministico delle royalties di catalogo accreditate all'etichetta del giocatore la Domenica notte in `EndDaySystem`.

---

### 🖥️ CONTRATTI DI SUPERFICIE & ACCESSIBILITÀ (S1..S3)
- **S1 (LegacyModal — Scelta Finale a 3 Vie)**:
  - Riorganizzazione della scheda finale di `LegacyModal` (tasto `W`) con opzioni numeriche dirette `1` (Ritiro & Epilogo), `2` (Continua in Carriera Infinita), `3` (Passaggio del Testimone / New Game+);
  - Annuncio vocale chiaro e lineare per NVDA senza ambiguità;
- **S2 (TravelModal & TourModal — Navigazione Continentale Espansa)**:
  - In `TravelModal` (tasto `V`) e `TourModal` (tasto `O`), navigazione lineare raggruppata per macro-aree (Europa, Americhe, Asia-Pacifico);
  - Supporto tastierino numerico (`KP_7`/`KP_9` per salto macro-regioni, `KP_5` per annuncio stato);
- **S3 (IndustryHub — Scheda Propria Etichetta Avanzata)**:
  - Terza scheda di `IndustryHub` espansa con lista band sotto contratto, pulsante `P` ("Produci Album Roster") e `D` ("Riepilogo Dividendi"), con lettura riga per riga per NVDA.

---

## 🧪 4. MATRICE DI VALIDAZIONE PREVENTIVA A 7 ASSI

- **Asse 1 — Validità**: Rispetto rigoroso dei tipi GDScript statici e coerenza di salvataggio atomico JSON in `SaveManager`;
- **Asse 2 — Efficacia**: Risoluzione diretta del limite di longevità post-Mese 12 e completamento della visione geografica mondiale;
- **Asse 3 — Coerenza**: Perfetta armonia con i pattern Clean Architecture, EventBus disaccoppiato e Numpad Navigation System;
- **Asse 4 — Completezza**: Copertura di tutti i flussi (dalla carriera infinita al New Game+ e alla produzione discografica);
- **Asse 5 — Precisione NVDA**: Zero Mouse garantito al 100%, annunci vocali lineari privi di tabelle o descrizioni grafiche superflue;
- **Asse 6 — Affidabilità & Prestazioni**: Esecuzione headless a 0 ms senza regressioni sulle 27 suite preesistenti;
- **Asse 7 — Assenza Regressioni**: Salvaguardia totale dei salvataggi esistenti con compatibilità retroattiva dei campi in `PlayerData` e `CalendarData`.

---

## 📋 5. CHECKLIST OPERATIVA A 3 STATI PER NVDA

### SOTTO-FASE 1A: Progettazione Tecnica & Gating Formale
- [x] [CONVALIDATO CON SUCCESSO] `1A.1`: Redazione del Piano Tecnico Operativo in `docs/piani/attivi/PIANO_ESPANSIONE_POST_V5_1_ENDLESS_HORIZON_E_POLISH.md`.
- [x] [CONVALIDATO CON SUCCESSO] `1A.2`: Approvazione formale da parte di Luca (autorizzazione esecuzione Sotto-Fase 1B).

### SOTTO-FASE 1B: Esecuzione Tecnica & Test Headless
- [x] [CONVALIDATO CON SUCCESSO] `1B.1`: Esecuzione Contratto D0 (Clean Sweep: archiviazione Sezione 11 in completati, audit bilingue 291 chiavi e calibrazione formule).
- [x] [CONVALIDATO CON SUCCESSO] `1B.2`: Esecuzione Contratto D1 (Modalità Carriera Infinita & New Game+ con suite dedicata `test_endless_and_ngplus_system.gd`).
- [x] [CONVALIDATO CON SUCCESSO] `1B.3`: Esecuzione Contratto D2 (Espansione a 16 Metropoli, festival estivi e travel routes con estensione suite `test_travel_system.gd` e `test_festival_system.gd`).
- [x] [CONVALIDATO CON SUCCESSO] `1B.4`: Esecuzione Contratto D3 (Magnate Discografico & Roster attivo con estensione suite `test_industry_system.gd`).
- [x] [CONVALIDATO CON SUCCESSO] `1B.5`: Esecuzione Contratti di Superficie S1..S3 (Accessibilità NVDA, pulsanti Endless/NG+ in `LegacyModal` e isolamento modali).
- [x] [CONVALIDATO CON SUCCESSO] `1B.6`: Suite di test globale a 0 ms su tutte le suite del progetto (28/28 suite verdi al 100% con 0 errori).

### FASE 2: Telemetria & Collaudo Congiunto
- [/] [IMPLEMENTATO — IN ATTESA DI CONVALIDA] `2.1`: Deploy provvisorio locale per verifica in-game con NVDA e tastiera (Zero Mouse).
- [ ] [DA AVVIARE] `2.2`: Collaudo manuale di Luca (Endless Mode, passaggio anno, nuove metropoli ed etichetta).

### FASE 3: Chiusura Tecnica, Git & AVF
- [ ] [DA AVVIARE] `3.1`: Calcolo nuova versione AVF (`V5.2.0`).
- [ ] [DA AVVIARE] `3.2`: Commit semantico e aggiornamento Living Documentation (`docs/todo.md`, schede `knowledge/`).
- [ ] [DA AVVIARE] `3.3`: Formulazione della Domanda Ponte Obbligatoria per la Fase 4.
