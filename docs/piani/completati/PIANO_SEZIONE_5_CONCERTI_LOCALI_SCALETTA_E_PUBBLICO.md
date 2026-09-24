# Piano Tecnico Operativo — Sezione 5: Concerti dal Vivo, Locali, Scaletta & Pubblico
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-23
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Sotto-Fase 1B: Esecuzione Tecnica & Suite 100% Verde a 0 Errori)
# File Piano: docs/piani/completati/PIANO_SEZIONE_5_CONCERTI_LOCALI_SCALETTA_E_PUBBLICO.md
# File di Riferimento: docs/roadmap/05_concerti_locali_scaletta_e_pubblico.md & docs/report/REPORT_AVVIO_SESSIONE_SEZIONE_5.md
# Coordinatore Master: docs/todo.md
# Versione AVF: V4.5.0

---

## 🎯 1. OBIETTIVO E PERIMETRO DELLA SEZIONE 5

La **Sezione 5 della Roadmap Modulare** governa l'evoluzione del motore **Concerti dal Vivo, Locali, Scaletta & Pubblico** di *World-tour*.
L'obiettivo è trasformare l'esibizione live in un'esperienza ricca, strategica e drammaturgica, superando il concetto di "singola azione immediata" per abbracciare un **ecosistema dinamico di disponibilità dei locali, costruzione della scaletta, imprevisti scenici, merchandise ed encore**, articolato in 5 pilastri strategici:

1. **Espansione del Circuito dei Locali (`VenueData` & `CityData`)**:
   - Locali base già operativi:
     * `venue_garage` (*Garage / Sala Prove*): Capienza 15 spettatori, affitto 0 €, requisiti pop 0, prestige 0, fair price 0 €.
     * `venue_pub` (*Pub / Birreria Locale*): Capienza 60 spettatori, affitto 50 €, requisiti pop 5.0, prestige 15, fair price 5 €.
     * `venue_small_club` (*Piccolo Club Live*): Capienza 180 spettatori, affitto 250 €, requisiti pop 20.0, prestige 40, fair price 12 €.
     * `venue_trendy_club` (*Club di Tendenza*): Capienza 450 spettatori, affitto 700 €, requisiti pop 40.0, prestige 70, fair price 22 €.
   - Nuove tipologie di venue ad identità differenziata:
     * `venue_social_center` (*Centro Sociale / Spazio Occupato*): Capienza 120 spettatori, affitto quasi simbolico (30 €), popolarità richiesta minima (8.0%), prezzo equo popolare (4.0 €), prestige 10.0%, atmosfera "Ribelle / Underground". Bonus speciale: tolleranza eccezionale verso artisti emergenti e generi alternativi (Rock, Metal, Indie, Hip-Hop), moltiplicatore reputazione underground x1.50 e incremento conversione fan del +25%.
     * `venue_opera_theatre` (*Teatro d'Opera Storico*): Capienza 800 spettatori, affitto prestigioso (1600 €), requisiti severi (popolarità minima 60.0%, reputazione minima 35.0), prezzo biglietto premium (35.0 €), prestige 90.0%, atmosfera "Raffinato / Prestigioso". Bonus speciale: richiede brani ad alta qualità media (Quality Score >= 60.0), conferisce un moltiplicatore prestigio x1.30 sulla popolarità e sulla reputazione acquisita, massimizza i ricavi da biglietti e merch.
   - Distribuzione nei cataloghi cittadini delle 6 metropoli della rete di viaggio (`CityData.get_all_cities()`).

2. **Disponibilità e Calendario delle Venue (La Meccanica di Luca)**:
   - Ciascun locale dispone di un proprio calendario di disponibilità per giorno (`day_number`), integrato con `ScheduleSystem` e `CalendarData`.
   - Stati di disponibilità giornaliera (`Enums.VenueBookingStatus`):
     * `FREE` (0): Locale libero. Prenotabile per date future o accessibile stasera.
     * `BOOKED_OTHER` (1): Locale occupato da concerti di altri artisti o serate a tema.
     * `MAINTENANCE` (2): Locale chiuso per turno di riposo, pulizie o manutenzione tecnica.
     * `BOOKED_PLAYER` (3): Data concordata e prenotata in agenda da Alex e dalla band.
   - Algoritmo deterministico e gestione anticipi: i locali prestigiosi e le serate del weekend (Venerdì e Sabato) sono molto più richiesti (occupazione procedurale 60-75% vs 20-30% nei giorni feriali).
   - Sovrapprezzo weekend: l'affitto nelle serate di Venerdì e Sabato ha una maggiorazione del +20% (`Constants.WEEKEND_RENT_SURCHARGE = 1.20`), compensata dal raddoppio del pubblico potenziale.
   - Se il locale è occupato nella data odierna, il giocatore riceve l'annuncio vocale e non può suonarvi subito, ma può prenotare una data libera futura in Agenda.

3. **Flow e Drammaturgia della Scaletta (1–4 brani)**:
   - Assegnazione dei ruoli drammaturgici ai brani inseriti in scaletta (`selected_setlist: Array[SongData]`):
     * *Opener (Posizione 1)*: Brano di apertura. Se energico (`ROCK`, `METAL`, `ELECTRONIC`), o con tratto `EPIC_RIFF`, o con qualità >= 65: bonus *Opening Hype* (+15 barra Hype iniziale e +5% Concert Score).
     * *Mid-Set (Posizioni intermedie 2 e 3)*: Sostegno del ritmo e varietà dell'esibizione.
     * *Momento Intimo / Ballad (Posizione 2 o 3)*: Se presente un brano con tratto `TEARJERKER_BALLAD`: momento emotivo intenso, abbassa lo stress della band di -5 punti e conferisce +15% conversione fan.
     * *Closer (Ultima Posizione)*: Se presente `STAGE_BEAST`: Closer Bonus del +15% su Concert Score. Se presente `GENERATIONAL_ANTHEM`: +3.0 reputazione extra e moltiplicatore fan folla x1.25.
   - Meccanica *Cover di Artisti Famosi*: possibilità per il giocatore di inserire una cover famosa di repertorio in scaletta (qualità base 65.0, scalata sull'abilità esecuzione, `is_cover = true`, zero vendite/royalties proprie ma ottimo salvagente per scaldare il pubblico nei locali ostili con catalogo iniziale ridotto).

4. **Nuovi Imprevisti di Palco Procedurali & Bivi (Totale 7 tipi in `Enums.StageEventType`)**:
   - Espansione del parco eventi live:
     * `BROKEN_STRING` (Corda Spezzata - Carisma vs Performance)
     * `AUDIO_FEEDBACK` (Fischio Monitor - Carisma vs Performance, azzerato da Soundcheck)
     * `ENTHUSIASTIC_FAN` (Fan sul Palco - Carisma vs Performance)
     * `BLACKOUT` (Calo Tensione / Blackout - Canto Unplugged con folla su Carisma vs Intrattenimento aneddoti su Performance)
     * `CROWD_CHANT` (Cori da Stadio Spontanei - Assecondare coro e groove su Carisma vs Stacco potente ritornello su Performance)
     * `PIT_FIGHT` (Rissa nel Mosh Pit - Placare animi al microfono su Carisma vs Chiamata security ed energia su Performance)
     * `STAGE_DIVING` (Tuffo dal Palco - Crowd Surfing su Carisma vs Direzione folla da bordo palco su Performance)
   - Risoluzione deterministica a bivi con attribuzione XP, delta punteggio (-8 a +12) e lettura vocale per NVDA (tasti `1` e `2`).

5. **Banchetto Merchandising & Momento Bis / Encore**:
   - *Banchetto Merchandising*:
     * 4 articoli con costi unitari e prezzi di vendita: Spille/Adesivi (costo 0.50 €, vendita 2.00 €), Magliette Band (costo 6.00 €, vendita 20.00 €), Poster Autografati (costo 2.00 €, vendita 8.00 €), Plettri da Collezione (costo 1.00 €, vendita 5.00 €).
     * Percentuale acquirenti parametrata al Concert Score (dal 10% al 45% del pubblico).
     * Incasso lordo e netto conteggiato a fine show, suddiviso con la band secondo il `RevenueSplit`, mostrato nel resoconto finale e annunciato da NVDA.
   - *Momento Bis / Encore*:
     * Se `concert_score >= 85.0`: la folla acclama a gran voce il bis!
     * Bivio: Tasto `1` Concedi Encore (-10 energia, +10% fan, +5 morale band, +50 € mance/merch extra); Tasto `2` Saluta e chiudi lo show senza consumare ulteriore energia.

---

## 🏛️ 2. ANALISI ARCHITETTURALE E MODELLI DATI

### 2.1 Modello Dati `VenueData` (`data/models/venue_data.gd`)
- Aggiunta campi:
  * `venue_type: int = 0`: tipo locale (0 Commerciale standard, 1 Social Center, 2 Opera Theatre).
  * `atmosphere: String`: atmosfera narrativa ("Grezzo", "Rumoroso", "Underground", "Prestigioso", "Ribelle", "Raffinato").
  * Serializzazione in `to_dict()` e `from_dict()`.
  * Aggiornamento del catalogo `get_default_venues()` a 6 locali.

### 2.2 Calendario delle Venue & Integrazione `ScheduleSystem` (`systems/schedule_system.gd` & `systems/concert_system.gd`)
- `Enums.VenueBookingStatus`:
  * `FREE = 0`
  * `BOOKED_OTHER = 1`
  * `MAINTENANCE = 2`
  * `BOOKED_PLAYER = 3`
- Metodi in `ConcertSystem`:
  * `get_venue_status(venue_id: String, day_number: int) -> int`
  * `book_venue_date(venue_id: String, day_number: int) -> bool`
  * Supporto per sovrapprezzo weekend `Constants.WEEKEND_RENT_SURCHARGE = 1.20`.
  * Persistenza degli override di prenotazione in `venue_status_overrides: Dictionary`.

### 2.3 Drammaturgia della Scaletta & Cover in `ConcertSystem` (`systems/concert_system.gd`)
- In `resolve_concert()`:
  * Check posizionale dei brani in `setlist`:
    - Opener: bonus energia/genere/EPIC_RIFF.
    - Mid-Set: effetto `TEARJERKER_BALLAD` (-5 stress, +15% fan conversion).
    - Closer: `STAGE_BEAST` (+15% score) e `GENERATIONAL_ANTHEM` (+3.0 rep, +25% fan).
- In `SongData`:
  * Campo `is_cover: bool = false`.
  * Metodo `create_cover_song(genre: int, player_skill: float) -> SongData`.

### 2.4 Nuovi Stage Events in `Enums` e `ConcertSystem`
- `Enums.StageEventType`:
  * Esteso da 4 a 8 valori (NONE, BROKEN_STRING, AUDIO_FEEDBACK, ENTHUSIASTIC_FAN, BLACKOUT, CROWD_CHANT, PIT_FIGHT, STAGE_DIVING).
  * Gestione bivi in `generate_stage_event()` e `resolve_stage_event_choice()`.

### 2.5 Banchetto Merchandising & Meccanica Encore
- In `ConcertSystem`:
  * `calculate_merch_sales(audience: int, score: float, charisma: float) -> Dictionary`.
  * `resolve_encore(granted: bool, current_score: float) -> Dictionary`.

### 2.6 Interfaccia `LiveConcert` (`ui/concert/live_concert.gd` & `.tscn`)
- Verifica e annuncio vocale della disponibilità del locale odierno.
- Etichette ruoli scaletta (Opener, Mid, Ballad, Closer).
- Pulsante per aggiungere Cover di repertorio.
- Pannello Evento Live allineato sui 7 imprevisti.
- Sezione intermedia Encore su score >= 85.
- Sezione Banchetto Merch nel riepilogo finale.

---

## 📋 3. SCOMPOSIZIONE ATOMICA IN NAMED CONTRACTS (ASTRALIS PROTOCOLLO 12)

- **Contratto D0 (Clean Sweep & Pre-Flight Baseline Verification)**:
  Verifica pulizia del working tree Git e convalida 100% verde di tutte le 23 suite headless del progetto a 0 errori.
- **Contratto D1 (Costanti, Enums & Modello Dati Esteso in `VenueData` ed `Enums`)**:
  Definizione di `Enums.VenueBookingStatus`, nuovi 4 `StageEventType` (`BLACKOUT`, `CROWD_CHANT`, `PIT_FIGHT`, `STAGE_DIVING`), costanti merch e weekend rent surcharge in `Constants`, estensione di `VenueData` (`SOCIAL_CENTER`, `OPERA_THEATRE`).
- **Contratto D2 (Sistema Disponibilità & Calendario Venue in `ConcertSystem` e `ScheduleSystem`)**:
  Implementazione della disponibilità deterministica per data/locale, verifica preventiva, prenotazione anticipata garantita e override di occupazione.
- **Contratto D3 (Drammaturgia Scaletta, Flow Scenico & Cover in `ConcertSystem`)**:
  Riconoscimento ruoli brano (Opener, Mid, Intimo, Closer), sinergie e tratti speciali (`EPIC_RIFF`, `TEARJERKER_BALLAD`, `STAGE_BEAST`, `GENERATIONAL_ANTHEM`), e introduzione della cover famosa di repertorio.
- **Contratto D4 (Nuovi Stage Events Procedurali & Bivi in `ConcertSystem`)**:
  Generazione e risoluzione bilanciata dei 7 imprevisti di palco con check abilità, varianti acustiche post-soundcheck, delta punteggio e premi XP.
- **Contratto D5 (Banchetto Merchandising & Momento Bis / Encore in `ConcertSystem`)**:
  Algoritmo di vendita al banchetto foyer (4 articoli), incasso lordo/netto e ripartizione band; meccanica dell'Encore/Bis su score >= 85 con consumo energia e bonus fan/morale.
- **Contratto D6 (Interfaccia Grafica Accessibile Zero Mouse in `LiveConcert` - Tasto `L`)**:
  Visualizzazione stato disponibilità venue, etichette drammaturgia scaletta, selettore cover, gestione interattiva dell'Encore e scomposizione grafica/vocale del resoconto merch.
- **Contratto D7 (Suite Headless Dedicata & Regression Testing: 23+ Suite a 0 Errori)**:
  Estensione di `tests/test_concert_system.gd` per convalidare tutti i nuovi contratti (locali, calendario venue, drammaturgia scaletta, cover, 7 eventi, merch, encore) mantenendo verde il 100% delle suite.

---

## 🛡️ 4. VALIDAZIONE PREVENTIVA SUI 7 ASSI ASTRALIS

1. **Asse 1 — Validità**: Tipizzazione statica GDScript 2.0 al 100%, rispetto delle signature dei metodi, clamping rigoroso dei punteggi.
2. **Asse 2 — Efficacia**: Soddisfa tutti i requisiti della Sezione 5 della Roadmap Modulare e le direttive specialistiche di Luca sul calendario delle venue.
3. **Asse 3 — Coerenza**: Perfetto allineamento con la Clean Architecture di World-tour, `EventBus` a segnali, modelli puri e controller UI disaccoppiati.
4. **Asse 4 — Completezza**: Copertura di tutti i casi limite (locale occupato stasera, scaletta mista originale/cover, energia insufficiente per il bis, merch con audience zero o ridotta).
5. **Asse 5 — Precisione**: Interventi chirurgici sui moduli competenti senza sporcare logiche estranee.
6. **Asse 6 — Affidabilità & Prestazioni**: Determinismo a 0 ms headless, nessun delay artificiale o `OS.delay()`.
7. **Asse 7 — Assenza Regressioni & Prevenzione Anomalie**: Preservazione integrale della suite di 23 test storici e compatibilità salvataggi JSON.

---

## 🧪 5. I 3 LIVELLI DI SIMULAZIONE DI COLLAUDO

- **Livello 1 (Happy Path)**:
  Alex consulta il Piccolo Club di venerdì: il locale è libero; seleziona una scaletta con Opener energico (`ROCK`), brano intimo centrale e Closer con `STAGE_BEAST`; esegue il soundcheck; durante lo show affronta i cori da stadio (`CROWD_CHANT`) superando il check Carisma; totalizza un punteggio di 88/100; concede il Bis al pubblico in visibilio; vende magliette e poster al banchetto merch incassando un ottimo ricavo netto ripartito con la band.
- **Livello 2 (Percorsi Alternativi & Concorrenti)**:
  Alex vuole suonare di sabato sera nel Club di Tendenza, ma il locale è già occupato da un'altra band per stasera (`BOOKED_OTHER`). Alex prenota la data per il sabato successivo in agenda (`ScheduleSystem`). Nel frattempo, per stasera sceglie il Centro Sociale Occupato: usa una cover famosa per scaldare il pubblico underground e ottiene un forte boost di reputazione (+50%) con biglietto popolare.
- **Livello 3 (Corner Cases & Limiti Estremi)**:
  Alex prova a suonare al Teatro d'Opera ma ha popolarità insufficiente (< 60%): il locale resta bloccato; durante un concerto senza soundcheck si verifica un blackout elettrico (`BLACKOUT`): fallisce il test ed è costretto a gestire la penalità; a fine show totalizza 86 punti ma ha solo 5 punti energia residua: il sistema segnala che non ha abbastanza energia per concedere il bis e Alex deve salutare il pubblico evitando il collasso.

---

## 🏁 6. ESITO SOTTO-FASE 1B & TRANSIZIONE A FASE 2

- **Stato Sotto-Fase 1B**: `[x] [CONVALIDATO CON SUCCESSO]`
- **Esito Suite Headless**: 23 suite su 23 superate con 0 fallimenti e 0 errori (100% verde).
- **Suite Specifica Sezione 5 (`test_concert_system.gd`)**: 92 asserzioni superate su 92, 0 falliti.
- **Assenza Regressioni**: `test_band_system.gd`, `test_schedule_system.gd` e `test_travel_system.gd` perfettamente allineati e superati al 100%.
- **Prossimo Passo**: Collaudato ed approvato con successo da Luca; archiviazione e chiusura con commit V4.5.0.
