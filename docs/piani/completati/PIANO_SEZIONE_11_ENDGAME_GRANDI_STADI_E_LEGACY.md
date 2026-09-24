# Piano Tecnico Operativo — Sezione 11: Endgame, Grandi Stadi & Legacy Mondiale
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.10 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-24
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Convalidato con 26/26 Suite Headless, Collaudo NVDA Superato e Chiusura V5.0.0)
# File Piano: docs/piani/completati/PIANO_SEZIONE_11_ENDGAME_GRANDI_STADI_E_LEGACY.md
# File di Riferimento: docs/roadmap/11_endgame_grandi_stadi_e_legacy_mondiale.md
# Coordinatore Master: docs/todo.md (F9.2, F9.3, F9.4)
# Baseline AVF: V4.10.0 (Target Versione Consolidata: V5.0.0 / V4.11.0)

---

## 🎯 1. OBIETTIVO E PERIMETRO DELLA SEZIONE 11

La **Sezione 11 della Roadmap Modulare** governa la consacrazione finale e la conclusione della traiettoria artistica in *World-tour*: **"Endgame, Grandi Stadi, Mega-Produzioni, Premi Ufficiali & Legacy Mondiale (V5.0)"**.
In piena coerenza con la visione dell'autore Luca (sviluppatore non vedente, Zero Mouse), la scalata all'Olimpo della musica non è un semplice traguardo numerico, ma un'esperienza sistemica a 4 pilastri:

1. **Grandi Arene & Stadi Mondiali (15.000 – 80.000 Spettatori)**:
   - Integrazione delle venue di massimo livello nel catalogo di gioco ([`VenueData`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/data/models/venue_data.gd)):
     * *Palasport e Grandi Arene* (10.000 - 20.000 posti, es. Forum di Assago a Milano, O2 Arena a Londra, Madison Square Garden a New York);
     * *Mega Stadi Mondiali* (50.000 - 80.000 spettatori, es. San Siro a Milano, Stadio Olimpico a Roma, Wembley Stadium a Londra, Olympiastadion a Berlino, Tokyo Dome);
   - Requisiti di accesso proporzionati allo status di Superstar (`GLOBAL_SUPERSTAR`, popolarità >= 75%, reputazione >= 70%);
   - Affitti mastodontici (35.000 € – 180.000 €) bilanciati da incassi milionari su biglietti e merchandising.

2. **Mega-Produzioni Sceniche, Service Audio/Luci & Squadra Tecnica**:
   - Sistema di allestimento scenico professionale per Arene e Stadi (`StageProductionTier`):
     * *Palco Base Stadio*: Service standard, amplificazione per grandi masse;
     * *Passerella a T nel Prato*: Ingresso tra la folla, +15% conversione fan e +10 carisma live;
     * *Palco Centrale a 360 Gradi*: Massimizzazione della capienza (+10% spettatori paganti);
     * *Mega Pirotecnica & Effetti*: Lanciafiamme sincronizzati, laser 360°, maxi-schermi LED Ultra-HD (+15 Concert Score, -15% rischio imprevisti tecnici grazie alla squadra di 50 roadie e tecnici al seguito).

3. **Certificazioni Ufficiali (Oro, Platino, Diamante) & World Music Awards**:
   - Modello dati per il tracciamento delle certificazioni discografiche FIMI/RIAA su Singoli e Album:
     * *Disco d'Oro*: 25.000 copie / 10M stream;
     * *Disco di Platino*: 50.000 copie / 25M stream;
     * *Disco di Diamante*: 500.000 copie / 100M stream;
   - Esposizione delle targhe dorate nel loft o villa del musicista in [`PlayerData`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/data/models/player_data.gd);
   - Cerimonia annuale dei *World Music Awards* a fine anno con candidature per *Album dell'Anno*, *Canzone dell'Anno*, *Miglior Band Live* e statuetta fisica.

4. **Hall of Fame, Concerto d'Addio ("The Last Waltz") & Epiloghi di Carriera**:
   - Induzione nella *Rock and Roll Hall of Fame* al raggiungimento dei traguardi massimi;
   - Possibilità per il giocatore di continuare a giocare all'infinito o organizzare volontariamente il proprio *Concerto d'Addio ("The Last Waltz")*;
   - Generazione deterministica dell'**Epilogo Narrativo della Legacy Artistica**:
     * *L'Icona Immortale* (massimo successo commerciale + integrità impeccabile);
     * *Il Martire del Rock* (mito underground che non ha mai ceduto alle lusinghe commerciali);
     * *La Macchina da Soldi* (patrimonio immenso e major proprietaria, ma compromessi pop);
     * *La Cometa Fiammeggiante* (folgorante gloria con una manciata di capolavori storici).

---

## 🏛️ 2. CHECKLIST A TRE STATI PER NVDA (SOTTO-FASE 1A / 1B / FASE 2)

- [x] [CONVALIDATO CON SUCCESSO] **Sotto-Fase 1A (Pianificazione & Stop)**:
  - [x] Analisi preliminare della scheda roadmap [`docs/roadmap/11_endgame_grandi_stadi_e_legacy_mondiale.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/roadmap/11_endgame_grandi_stadi_e_legacy_mondiale.md) e della test suite baseline (25 suite su 25 verdi al 100%).
  - [x] Scomposizione architetturale nei Named Contracts D0..D6.
  - [x] Validazione preventiva sui 7 Assi di Qualità e sui 3 Livelli di Simulazione.
  - [x] Formalizzazione del piano in `docs/piani/attivi/PIANO_SEZIONE_11_ENDGAME_GRANDI_STADI_E_LEGACY.md`.
  - [x] **STOP OBBLIGATORIO DI SOTTO-FASE 1A**: Approvazione esplicita concessa da Luca (*"procedi"*).

- [x] [CONVALIDATO CON SUCCESSO] **Sotto-Fase 1B (Esecuzione Tecnica & Test Headless)**:
  - [x] Contratto D0: Clean sweep preventivo, estensione di `Enums` (`CertificationTier`, `StageProductionTier`, `MusicAwardCategory`, `LegacyEndingType`) e costanti di bilanciamento in `Constants`.
  - [x] Contratto D1: Espansione Venue Data ([`VenueData`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/data/models/venue_data.gd)) con Grandi Arene (Palasport 15k) e Mega Stadi Mondiali (San Siro/Wembley 65k).
  - [x] Contratto D2: Sottosistema Allestimenti Scenici & Service Tour negli Stadi in [`ConcertSystem`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/systems/concert_system.gd).
  - [x] Contratto D3: Sottosistema Certificazioni Ufficiali & Music Awards (`AwardSystem`) con tracciamento targhe e cerimonie annuali.
  - [x] Contratto D4: Gestione Hall of Fame, The Last Waltz ed Epilogo Narrativo Multiplo di fine carriera in `LegacySystem`.
  - [x] Contratto D5: Creazione interfaccia accessibile `LegacyModal` (`ui/legacy/legacy_modal.gd`, `legacy_modal.tscn`), integrazione in `HUD` con tasto rapido `W` e pulsante dedicato nell'Area 3 (Carriera e Band) 100% NVDA Zero Mouse.
  - [x] Contratto D6: Nuova test suite headless dedicata (`tests/test_endgame_and_legacy_system.gd` con 87 asserzioni) e verifica di regressione su tutte le 26 suite con 0 errori e 0 ms.

- [/] [IMPLEMENTATO — IN ATTESA DI CONVALIDA] **Fase 2 (Deploy Provvisorio & Collaudo Manuale NVDA)**:
  - [ ] Collaudo pratico a tastiera con NVDA sui concerti nelle arene/stadi, gestione allestimenti e schermata certificazioni / legacy (tasto `W`).
  - [ ] Verifica volumi sonori ed effetti conformi ai limiti di sicurezza (0.7f - 0.8f).

- [ ] [DA AVVIARE] **Fase 3 (Chiusura Tecnica, Git & Release AVF `V5.0.0`)**:
  - [ ] Aggiornamento coordinatore master `docs/todo.md` e changelog.
  - [ ] Commit atomico Conventional Commits: `feat(endgame): implement stadiums, mega stage production, music awards and legacy endings`.
  - [ ] Formulazione obbligatoria della Domanda Ponte per la Fase 4 (Auto-Apprendimento a Doppio Binario).

---

## 🧩 3. NAMED CONTRACTS (D0..D6)

### Contratto D0: Clean Sweep, Allineamento Tipi & Costanti Centralizzate
- **Obiettivo**: Bonifica preventiva, estensione dei tipi enumerati e delle costanti senza introdurre debito tecnico né duplicazioni.
- **Estensioni in `core/enums.gd`**:
  ```gdscript
  enum CertificationTier {
      NONE = 0,
      GOLD = 1,        # 25.000 copie / 10M stream
      PLATINUM = 2,    # 50.000 copie / 25M stream
      MULTI_PLATINUM = 3, # 100.000 copie / 50M stream
      DIAMOND = 4      # 500.000 copie / 100M stream
  }

  enum StageProductionTier {
      BASIC_STADIUM = 0,    # Service standard da stadio
      RUNWAY_CATWALK = 1,   # Passerella a T nel prato (+conversione fan)
      CENTER_360_STAGE = 2, # Palco a 360° (+10% capienza pagante)
      MEGA_PYRO_LASER = 3   # Pirotecnica estrema, lanciafiamme e laser 360°
  }

  enum MusicAwardCategory {
      SONG_OF_THE_YEAR = 0,
      ALBUM_OF_THE_YEAR = 1,
      BEST_LIVE_BAND = 2,
      BEST_PRODUCER = 3
  }

  enum LegacyEndingType {
      IMMORTAL_ICON = 0,    # Icona Immortale (Grande successo commerciale + integrità impeccabile)
      ROCK_MARTYR = 1,      # Martire del Rock (Fedele alla musica underground fino all'ultimo)
      MONEY_MACHINE = 2,    # Macchina da Soldi (Ricchissimo ma compromessi commerciali)
      BLAZING_COMET = 3     # Cometa Fiammeggiante (Pochi capolavori leggendari e ritiro)
  }
  ```
- **Estensioni in `core/constants.gd`**:
  ```gdscript
  # --- Endgame, Grandi Stadi & Mega-Produzioni (Sezione 11) ---
  const VENUE_TYPE_ARENA: int = 3
  const VENUE_TYPE_STADIUM: int = 4

  const CERT_GOLD_SALES: float = 25000.0
  const CERT_GOLD_STREAMS: int = 10000000
  const CERT_PLATINUM_SALES: float = 50000.0
  const CERT_PLATINUM_STREAMS: int = 25000000
  const CERT_DIAMOND_SALES: float = 500000.0
  const CERT_DIAMOND_STREAMS: int = 100000000

  const STAGE_RUNWAY_BONUS_FAN: float = 1.15
  const STAGE_360_CAPACITY_BONUS: float = 1.10
  const STAGE_PYRO_SCORE_BONUS: float = 15.0
  const STAGE_ROADIE_CREW_COUNT: int = 50
  const STAGE_ROADIE_CREW_DAILY_COST: float = 2500.0
  ```

### Contratto D1: Espansione Grandi Arene & Mega Stadi Mondiali in `VenueData`
- **File**: [`data/models/venue_data.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/data/models/venue_data.gd).
- **Nuove Venue nel catalogo `get_default_venues()`**:
  - `venue_arena_national` ("Palasport / Grande Arena", 15.000 posti, affitto 35.000 €, popolarità min. 70%, rep min. 55%, fair ticket 45.00 €);
  - `venue_mega_stadium` ("Mega Stadio Mondiale", 65.000 posti, affitto 120.000 €, popolarità min. 85%, rep min. 75%, fair ticket 70.00 €).
- Localizzazione bilingue it/en completa dei nomi e descrizioni.

### Contratto D2: Mega-Produzioni Sceniche & Allestimento in `ConcertSystem`
- **File**: [`systems/concert_system.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/systems/concert_system.gd).
- **Logica**:
  - Metodo `select_stage_production(tier: int, player_data: PlayerData) -> Dictionary`;
  - Applicazione dei bonus su capienza, Concert Score, e sicurezza tecnica;
  - Addebito dei costi di allestimento e service tecnico all'avvio del concerto.

### Contratto D3: Sottosistema Certificazioni & Music Awards (`AwardSystem`)
- **Nuovo File**: `systems/award_system.gd`.
- **Logica**:
  - `check_certifications(player_data: PlayerData) -> Array[Dictionary]`: scansiona album e singoli e assegna Dischi d'Oro, Platino e Diamante memorizzandoli in `player_data.certifications`;
  - `evaluate_annual_awards(year: int, player_data: PlayerData, rivals: Array) -> Dictionary`: cerimonia a fine anno con nomination, votazioni della giuria e statuette vinte.

### Contratto D4: Hall of Fame, The Last Waltz & Epiloghi Narrativi
- **File**: `systems/legacy_system.gd`.
- **Logica**:
  - `check_hall_of_fame_eligibility(player_data: PlayerData) -> bool`: verifica requisiti (es. carriera `GLOBAL_SUPERSTAR`, almeno 2 Dischi di Platino/Diamante, rep >= 80, 100.000+ fan);
  - `hold_last_waltz_concert(player_data: PlayerData) -> Dictionary`: concerto d'addio celebrativo con tutti i membri storici della band e rivali alleati;
  - `calculate_legacy_ending(player_data: PlayerData) -> Dictionary`: determina quale dei 4 epiloghi narrativi spetta al giocatore con bilancio dell'eredità artistica e record finali.

### Contratto D5: Interfaccia Accessibile `LegacyModal` & Integrazioni HUD
- **File**: `ui/legacy/legacy_modal.gd`, `ui/legacy/legacy_modal.tscn`, [`ui/hud/hud.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/ui/hud/hud.gd).
- Tasti rapidi dedicati, navigazione lineare a schede per certificazioni, premi, trofei e cerimonia di ritiro.
- Annunci vocali completi per NVDA e visualizzazione ad alto contrasto per Holy Diver.

### Contratto D6: Suite di Test Headless (`tests/test_endgame_and_legacy_system.gd`)
- Nuova suite con almeno 50 asserzioni deterministiche a 0 ms senza SceneTree.
- Copertura completa: prenotazione stadi, mega-produzione scenica, calcolo certificazioni oro/platino/diamante, premi annuali, induzione Hall of Fame ed epiloghi narrativi.

---

## ⚖️ 4. I 7 ASSI DI QUALITÀ ASTRALIS

- **Asse 1 — Validità**: Rispetto rigoroso dei contratti, tipi forti GDScript 2.0 e assenza di chiamate su riferimenti nulli.
- **Asse 2 — Efficacia**: Risolve organicamente l'Endgame del simulatore offrendo un traguardo epico e appagante per le decine di ore di carriera musicale.
- **Asse 3 — Coerenza**: Perfetta armonia con `ConcertSystem`, `AlbumData`, `SaveManager` e la filosofia Zero Mouse.
- **Asse 4 — Completezza**: Copre l'intera catena: stadi, allestimenti, certificazioni, premi annuali, Hall of Fame e finale narrativo.
- **Asse 5 — Precisione**: Modifiche chirurgiche senza intaccare o rompere i flussi storici dei concerti nei piccoli club o nei festival.
- **Asse 6 — Affidabilità & Prestazioni**: Esecuzione headless deterministica a 0 ms senza timer asincroni.
- **Asse 7 — Assenza Regressioni**: Le 25 suite di test preesistenti continuano a passare con 0 errori.

---

## 🔬 5. I 3 LIVELLI DI SIMULAZIONE

1. **Livello 1 (Happy Path)**: Alex raggiunge il livello Superstar Mondiale, affitta lo Stadio San Siro con palco 360° e pirotecnica, ottiene un Disco di Platino, vince il premio Album dell'Anno ed entra nella Hall of Fame con l'epilogo "L'Icona Immortale".
2. **Livello 2 (Casi Alternativi & Concorrenti)**: Alex suona solo concerti underground nei centri sociali, rifiuta le major e gli stadi, accumula zero dischi d'oro commerciali ma chiude la carriera come "Il Martire del Rock".
3. **Livello 3 (Corner Cases)**: Tentativo di prenotare uno stadio senza la popolarità/fondi necessari (rifiuto deterministico); assegnazione multipla di certificazioni sullo stesso album (idempotenza delle certificazioni); ritiro anticipato o posticipato.

---

## 🛑 STOP OBBLIGATORIO DI SOTTO-FASE 1A
In conformità alla **Regola 0 (Default Consultivo)**, il codice e i file operativi non verranno modificati fino alla tua esplicita approvazione (*"procedi"*, *"applica"*).
