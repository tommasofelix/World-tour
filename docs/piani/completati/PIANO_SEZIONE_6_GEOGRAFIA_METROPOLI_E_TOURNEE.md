# Piano Tecnico Operativo — Sezione 6: Geografia, Metropoli & Tournée
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-24
# Stato: [x] [COMPLETATO E CONVALIDATO AL 100%] (Chiusura Tecnica & AVF V4.6.0)
# File Piano: docs/piani/completati/PIANO_SEZIONE_6_GEOGRAFIA_METROPOLI_E_TOURNEE.md
# File di Riferimento: docs/roadmap/06_geografia_metropoli_e_tournee.md & docs/report/REPORT_AVVIO_SESSIONE_SEZIONE_6.md
# Coordinatore Master: docs/todo.md
# Versione AVF: V4.6.0

---

## 🎯 1. OBIETTIVO E PERIMETRO DELLA SEZIONE 6

La **Sezione 6 della Roadmap Modulare** governa l'evoluzione del pilastro **Geografia, Metropoli & Tournée** di *World-tour*.
L'obiettivo è trasformare lo spostamento territoriale e la tournée in un'esperienza gestionale, strategica e drammaturgica completa, superando la semplice schermata di trasferimento per abbracciare un **ecosistema geografico globale a 12 metropoli, eventi cittadini temporanei, logistica transoceanica con fusi orari e jet lag, pianificazione libera di tournée con giornate di riposo (Day Off), interviste promozionali radiofoniche, personalizzazione del mezzo con adesivi delle città e imprevisti on the road a scelte multiple**, articolato in 5 pilastri strategici:

1. **Espansione della Rete delle Città & Nuove Metropoli Mondiali (`CityData`, `Enums.CityId`, `TravelSystem`)**:
   - Rete attuale (6 città):
     * Milano (Italia): Moda e industria discografica. Affinità Pop (+25%), Rock (+15%), Elettronica (+20%). Rep. richiesta: 0.0.
     * Bologna (Italia): Scena universitaria e alternativa. Affinità Indie (+30%), Rock (+20%). Rep. richiesta: 0.0.
     * Roma (Italia): Città eterna e grandi arene. Affinità Pop (+15%), Rock (+20%), Indie (+20%). Rep. richiesta: 0.0.
     * Napoli (Italia): Calore mediterraneo e crossover. Affinità Hip Hop (+30%), Rock (+15%), Pop (+15%). Rep. richiesta: 0.0.
     * Londra (Regno Unito, Europea): Capitale internazionale del rock. Affinità Rock (+30%), Indie (+25%), Pop (+10%). Rep. richiesta: 30.0.
     * Berlino (Germania, Europea): Avanguardia underground e clubbing. Affinità Elettronica (+35%), Metal (+25%), Rock (+15%). Rep. richiesta: 30.0.
   - Espansione con 6 Nuove Metropoli Iconiche (Totale 12 città):
     * Dublino (Irlanda, Europea): Culla del folk, del cantautorato e del rock celtico. Affinità Rock (+30%), Indie (+25%), Pop (+15%). Rep. richiesta: 25.0. Locali dedicati: `Temple Bar Pub` (cap. 50), `Whelan's Live Stage` (cap. 220), `Olympia Theatre Dublin` (cap. 600).
     * Parigi (Francia, Europea): Capitale della chanson, dell'eleganza pop e dell'electro-house francese (French Touch). Affinità Elettronica (+30%), Pop (+25%), Indie (+20%). Rep. richiesta: 35.0. Locali dedicati: `Caveau de la Huchette` (cap. 60), `La Cigale Rock Hall` (cap. 300), `L'Olympia Paris` (cap. 750).
     * Madrid (Spagna, Europea): Energia latina, ritmi iberici, pop sanguigno e rock alternativo. Affinità Pop (+25%), Rock (+25%), Hip Hop (+20%). Rep. richiesta: 30.0. Locali dedicati: `Malasaña Underground Bar` (cap. 55), `Sala El Sol` (cap. 240), `La Riviera Concerts` (cap. 700).
     * New York (Stati Uniti, Intercontinentale Oltreoceano): La capitale culturale del mondo, patria del boom bap hip-hop, del punk e della pop music globale. Affinità Hip Hop (+30%), Rock (+25%), Pop (+25%). Rep. richiesta: 60.0 (Status Superstar / Nazionale consolidato). Locali leggendari: `CBGB Reborn Basement` (cap. 80), `Bowery Ballroom` (cap. 350), `Madison Music Arena` (cap. 1200).
     * Los Angeles (Stati Uniti, Intercontinentale Oltreoceano): La città degli angeli, capitale del glamour, dell'hard rock da Sunset Strip e delle mega-produzioni pop. Affinità Pop (+30%), Rock (+25%), Elettronica (+20%). Rep. richiesta: 65.0. Locali mitici: `Sunset Strip Bar` (cap. 90), `The Troubadour Club` (cap. 400), `The Forum Live Pavilion` (cap. 1400).
     * Tokyo (Giappone, Intercontinentale Oltreoceano): Metropoli futuristica, capitale asiatica delle tendenze, synth-pop, visual rock ed elettronica frenetica. Affinità Elettronica (+35%), Rock (+30%), Pop (+25%). Rep. richiesta: 70.0. Locali d'avanguardia: `Shibuya Underground Club` (cap. 100), `Shinjuku Loft` (cap. 450), `Budokan Music Dome` (cap. 1500).

2. **Eventi Cittadini Temporanei (`TravelSystem`, `ScheduleSystem`, `CalendarData`)**:
   - Ogni metropoli può ospitare eventi temporanei programmati o ciclici che trasformano la vita musicale locale per una giornata:
     * *Notte Bianca* (`WHITE_NIGHT`): I locali e le piazze della città brulicano di gente. Effetti: affluenza concerti raddoppiata (+100%), conversione fan aumentata del +50%, visibilità locale moltiplicata.
     * *Fiera Internazionale della Musica* (`MUSIC_EXPO`): Grande meeting dell'industria discografica. Effetti: requisiti di accesso alle etichette discografiche e ai manager ridotti del 20%, e bonus +5.0 reputazione su qualsiasi concerto eseguito in città durante la fiera.
     * *Festival Culturale Urbano* (`STREET_CULTURE_FEST`): Celebrazione della musica indipendente. Effetti: affluenza aumentata del +35% specificamente per pub, garage e piccoli club, con vendita merchandising maggiorata del +30%.
   - Annuncio vocale dedicato per NVDA all'apertura della mappa viaggi e integrazione con il calendario.

3. **Matrice Logistica Globale, Mezzi di Trasporto, Voli Transoceanici & Jet Lag (`TravelSystem`)**:
   - Distinzione delle tipologie di viaggio per distanze e modalità:
     * *Tratte Nazionali Italiane*: Spostamenti veloci in treno o autostrada (costo 35 - 110 €, energia 14 - 32, stress 5 - 14).
     * *Tratte Europee Continentali*: Spostamenti aerei o treni europei tra Italia, Regno Unito, Germania, Irlanda, Francia e Spagna (costo 140 - 280 €, energia 25 - 45, stress 12 - 22).
     * *Tratte Intercontinentali Oltreoceano*: Voli a lungo raggio verso New York, Los Angeles e Tokyo (costo 750 - 1.250 €, energia 45 - 60, stress 22 - 35).
   - Meccanica del *Jet Lag*: viaggiare su tratte transoceaniche (dall'Europa all'America o all'Asia) applica al protagonista e alla band lo status temporaneo **Jet Lag** per 2 giorni virtuali (`jet_lag_days = 2` in `PlayerData`). Durante il jet lag, il recupero energetico dalle normali attività di riposo è ridotto del 20%, a meno che non si conceda un *Day Off* ristoratore o non si dorma a bordo di un veicolo confortevole.

4. **Pianificazione Flessibile della Tournée (Custom Tour Builder), Day Off & Interviste Radio (`TourSystem`, `TourModal`)**:
   - Oltre ai 3 preset storici (Mini-Tour 3 Città, Giro d'Italia Rock, Tour Europeo), viene introdotto il **Costruttore di Tour Personalizzato**:
     * Il giocatore definisce il titolo del tour, il mezzo di trasporto e un itinerario libero da 2 a 8 tappe nelle città sbloccate per reputazione.
     * Possibilità di inserire esplicitamente **Giornate di Riposo (Day Off)** tra un concerto e l'altro nell'agenda del tour:
       - Il *Day Off* azzera il rischio di burnout da viaggio: la band si ferma nella città, recupera +25 punti energia, abbatte lo stress di -20 punti, riduce la tensione interna di -15 punti e aumenta il morale di +10 punti!
     * Azione *Intervista Promozionale Radiofonica* (`Promo Radio Interview`):
       - Disponibile la mattina del concerto nella città della tappa attiva.
       - Consuma 15 punti energia e mezza giornata.
       - Conferisce un boost immediato del +10% all'Hype della data e accresce la visibilità territoriale locale del +15%.
   - Meccanica degli *Adesivi di Viaggio sul Mezzo* (`visited_city_stickers: Array[int]`):
     * Ogni città visitata o completata in tournée conferisce alla band l'adesivo iconico del territorio, che viene applicato sul retro del veicolo come diario di bordo e letto vocalmente da NVDA.

5. **Gestione della Stanchezza On the Road & 4 Imprevisti di Viaggio Procedurali a Bivi (`TourSystem`)**:
   - Durante il trasferimento da una tappa alla successiva, il sistema calcola la probabilità di un imprevisto on the road (parametrata sulla classe del mezzo: 25% su Rusty Van, 10% su Pro Van, 2% su Luxury Bus).
   - I 4 Grandi Scenari di Viaggio con bivi di scelta:
     1. *Foratura in Autostrada sotto la Pioggia*:
        - Scelta 1: Chiama soccorso stradale celere (-120 €, zero fatica, nessun ritardo).
        - Scelta 2: Cambio ruota fai-da-te sotto il diluvio (0 €, -20 energia, +15 stress, +5 tensione band).
        - Scelta 3: Cerca gommista aperto in statale (-40 €, -10 energia, lieve ritardo).
     2. *Sosta in Autogrill alle 03:00*:
        - Scelta 1: Caffè e chiacchiere con un fan o musicista notturno al bancone (-10 €, +10 energia, +5 morale).
        - Scelta 2: Discussione notturna nell'abitacolo (check Carisma: se superato +5 intesa band, se fallito +10 tensione).
        - Scelta 3: Riposo veloce sui sedili reclinati (+10 energia).
     3. *Motel Economico Lungo la Statale*:
        - Scelta 1: Stanza economica da 30 € (rumorosa e condizionatore guasto: -5 morale, riposo incompleto).
        - Scelta 2: Upgrade a camera confortevole (-90 €, riposo perfetto: -15 stress, +20 energia).
        - Scelta 3: Situazione comica / misteriosa della stanza (la band scherza sull'albergo assurdo: +15 morale, -10 tensione).
     4. *Smarrimento del Percorso / Deviazione Stradale*:
        - Scelta 1: Guida ad intuito e mappa cartacea (-15 energia, arrivo appena in tempo per il soundcheck).
        - Scelta 2: Pedaggio tangenziale veloce (-35 €, arrivo puntuale e riposato).
        - Scelta 3: Chiedi indicazioni al benzinaio locale (+5 morale per la simpatia dei residenti).
   - Risoluzione deterministica con tasti `1`, `2`, `3` e lettura lineare per NVDA.

---

## 🏛️ 2. ANALISI ARCHITETTURALE E MODELLI DATI

### 2.1 Modello Dati `CityData` & `core/enums.gd`
- In `core/enums.gd`:
  * Espansione `enum CityId`:
    ```gdscript
    enum CityId {
        MILANO = 0,
        BOLOGNA = 1,
        ROMA = 2,
        NAPOLI = 3,
        LONDRA = 4,
        BERLINO = 5,
        DUBLINO = 6,
        PARIGI = 7,
        MADRID = 8,
        NEW_YORK = 9,
        LOS_ANGELES = 10,
        TOKYO = 11
    }
    ```
  * Aggiunta `enum RoadDilemmaType`:
    ```gdscript
    enum RoadDilemmaType {
        FLAT_TIRE = 0,
        HIGHWAY_REST_STOP = 1,
        BUDGET_MOTEL = 2,
        LOST_ROUTE = 3
    }
    ```
  * Aggiunta `enum CityEventType`:
    ```gdscript
    enum CityEventType {
        NONE = 0,
        WHITE_NIGHT = 1,
        MUSIC_EXPO = 2,
        STREET_CULTURE_FEST = 3
    }
    ```
  * Aggiornamento del router di localizzazione `get_city_name(city_id: int) -> String` e helper per eventi e imprevisti.
- In `data/models/city_data.gd`:
  * Estensione del catalogo predefinito `get_all_cities()` per istanziare le 12 città con nazione, descrizione, percentuali di affinità di genere musicale, flag `is_international`, requisito reputazione e locali associati (`venues: Array[VenueData]`).

### 2.2 Eventi Cittadini Temporanei in `TravelSystem` & `ScheduleSystem`
- `TravelSystem` mantiene un registro deterministico o ciclico degli eventi cittadini attivi basato sul giorno di calendario (`day_number`):
  * Metodo `get_active_event_for_city(city_id: int, day_number: int) -> Dictionary`:
    - Ritorna `{ "type": CityEventType, "name": String, "description": String, "audience_mult": float, "fan_mult": float, "rep_bonus": float }`.
  * La Notte Bianca si ripete periodicamente su una metropoli a rotazione (es. ogni 14 giorni).
  * La Fiera della Musica ricorre una volta a stagione nei grandi centri discografici (Milano, Londra, Berlino, New York).
  * Integrazione automatica con `ConcertSystem`: se si suona in una città con evento attivo, i moltiplicatori di affluenza e reputazione vengono applicati e vocalizzati.

### 2.3 Matrice Logistica Globale, Voli Transoceanici & Meccanica Jet Lag in `TravelSystem`
- `calculate_travel_cost(from_city_id: int, to_city_id: int) -> Dictionary`:
  * Calcolo deterministico della tratta (Nazionale, Europea Continentale, Intercontinentale Oltreoceano).
  * Determinazione del flag `is_transoceanic: bool`.
  * Ritorno di `{ "money_cost": float, "energy_cost": int, "stress_cost": int, "is_transoceanic": bool, "time_hours": int }`.
- Applicazione dello status Jet Lag:
  * In `travel_to()`: se `is_transoceanic == true`, impostazione di `player_data.jet_lag_days = 2`.
  * In `EndDaySystem` (o durante il cambio giorno): decremento automatico di `jet_lag_days` fino a 0.
  * Annuncio vocale chiaro per NVDA: "Attenzione: viaggio transoceanico completato. La band risente del jet lag per i prossimi 2 giorni (-20% recupero energetico)."

### 2.4 Personalizzazione Mezzi di Trasporto & Diario Adesivi in `TourData` e `TourSystem`
- In `data/models/player_data.gd`:
  * Array `visited_city_stickers: Array[int] = []` per salvare gli ID delle città visitate/conquistate.
  * Campo `vehicle_custom_name: String = ""` per il nome battezzato del furgone/bus.
- In `TourSystem`:
  * Metodo `award_city_sticker(city_id: int) -> bool`: registra il nuovo adesivo se non presente ed emette la notifica vocale.
  * Metodo `get_vehicle_diary_speech() -> String`: descrizione lineare per NVDA di tutti gli adesivi applicati sul mezzo.

### 2.5 Custom Tour Builder, Day Off & Interviste Radiofoniche in `TourSystem`
- In `data/models/tour_data.gd`:
  * Ogni elemento di `stops: Array[Dictionary]` supporta il flag `is_day_off: bool`.
  * Tracciamento `radio_interviews_done: int = 0`.
- In `TourSystem`:
  * `can_plan_custom_tour(...)` e `plan_custom_tour(...)`: supporta da 2 a 8 tappe liberamente scelte dal giocatore.
  * `advance_to_next_stop()`: se la tappa è un Day Off, non richiede viaggio verso una nuova venue, ma esegue il riposo della band (+25 energia, -20 stress, -15 tensione, +10 morale).
  * `do_radio_interview()`: azione mattutina attivabile prima dello show serale (-15 energia, +10% hype, +15% fan locali).

### 2.6 Imprevisti di Viaggio On The Road a Bivi in `TourSystem`
- Struttura imprevisti in `TourSystem`:
  * Metodo `check_and_trigger_road_dilemma(vehicle_type: int) -> Dictionary`.
  * Metodo `resolve_road_dilemma_choice(dilemma_type: int, choice_index: int) -> Dictionary`:
    - Esegue le modifiche a denaro, energia, stress, morale e tensione band.
    - Restituisce la descrizione narrativa dell'esito.

### 2.7 Interfacce Utente `TravelModal` (tasto `V`) e `TourModal` (tasto `O`)
- In `TravelModal`:
  * Organizzazione lineare delle 12 città con filtro rapido a 3 fasce: `1` Italia (4), `2` Europa (5), `3` Oltreoceano (3).
  * Indicatore chiaro degli eventi cittadini attivi.
  * Hook di accessibilità AccessKit e navigazione 100% Zero Mouse.
- In `TourModal`:
  * Schermata di pianificazione con possibilità di scegliere preset o creare itinerario personalizzato con pulsante "Aggiungi Day Off".
  * Schermata del tour attivo con log tappe (evidenziando concerti e day off), pulsante Intervista Radiofonica e pannello dedicato per gli imprevisti di viaggio con scelte `1`, `2`, `3`.

---

## 📋 3. SCOMPOSIZIONE ATOMICA IN NAMED CONTRACTS (ASTRALIS PROTOCOLLO 12)

- **Contratto D0 (Clean Sweep & Pre-Flight Baseline Verification)**:
  Verifica pulizia del working tree Git e convalida 100% verde di tutte le 23 suite headless del progetto a 0 errori (già convalidato: 23 suite su 23 superate, 0 fallimenti).
- **Contratto D1 (Espansione Catalogo Città & Nuove Metropoli in `Enums` e `CityData`)**:
  Espansione dell'enum `Enums.CityId` a 12 città (aggiunta di `DUBLINO`, `PARIGI`, `MADRID`, `NEW_YORK`, `LOS_ANGELES`, `TOKYO`), definizione dei modelli `CityData` per le 6 nuove metropoli con generi affini, descrizioni, requisiti di reputazione internazionale e cataloghi locali dedicati (`VenueData`).
- **Contratto D2 (Eventi Cittadini Temporanei & Notte Bianca in `TravelSystem` e `ScheduleSystem`)**:
  Modello e logica per eventi cittadini temporanei (`CityEventType`): Notte Bianca (+100% affluenza, +50% fan), Fiera Internazionale della Musica (networking discografico, -20% requisiti etichette/manager, +5.0 reputazione), Festival di Strada (+35% affluenza piccoli locali). Integrazione temporale con `CalendarData`.
- **Contratto D3 (Matrice Logistica Globale, Tratte Intercontinentali & Jet Lag in `TravelSystem`)**:
  Espansione della matrice delle distanze e costi per tutte le coppie di città (nazionali, europee continentali, intercontinentali oltreoceano). Meccanica del Jet Lag su tratte transoceaniche (durata 2 giorni, riduzione efficienza recupero energetico) con annuncio vocale per NVDA.
- **Contratto D4 (Personalizzazione Mezzi di Trasporto & Adesivi di Viaggio in `TourSystem` e `TourData`)**:
  Tracciamento degli adesivi delle città visitate dalla band (`visited_city_stickers: Array[int]`), diario visivo/narrativo della tournée, branding della livrea del mezzo e resa vocale lineare per NVDA.
- **Contratto D5 (Custom Tour Builder, Day Off & Interviste Radiofoniche in `TourSystem`)**:
  Pianificazione tournée flessibile da 2 a 8 tappe con selezione tappe personalizzate (oltre ai 3 preset storici); supporto per giornate di riposo (Day Off) tra concerti consecutivi per recupero attivo di energia/morale e azzeramento burnout; azione Intervista Radiofonica la mattina del concerto per boost Hype (+10%) e visibilità locale (+15%).
- **Contratto D6 (Imprevisti di Viaggio Procedurali & Bivi On the Road in `TourSystem`)**:
  Motore di imprevisti durante gli spostamenti tra tappe: 4 scenari realistici e narrativi (Foratura sotto la pioggia, Autogrill alle 03:00, Motel economico, Smarrimento percorso) con 3 scelte strategiche (tasti `1`, `2`, `3`) su Denaro, Energia, Stress, Morale e Tensione Band; supporto test deterministico a 0 ms.
- **Contratto D7 (Interfaccia Grafica e Accessibilità Tastiera/NVDA in `TravelModal` e `TourModal`)**:
  Aggiornamento di `TravelModal` (tasto HUD `V`) per navigare le 12 città (con raggruppamento geografico Italia / Europa / Oltreoceano, eventi cittadini attivi e indicazione jet lag) e di `TourModal` (tasto HUD `O`) con selettore Day Off, interviste radiofoniche, diario adesivi e pannello imprevisto di viaggio a bivi.
- **Contratto D8 (Suite di Test Headless Dedicate & Zero Regressioni: 23+ Suite a 0 Errori)**:
  Espansione e consolidamento di `tests/test_travel_system.gd` e `tests/test_tour_system.gd` con decine di nuove asserzioni a copertura di tutti i contratti D1..D7, mantenendo il 100% verde su tutte le 23+ suite senza rallentamenti o dipendenze temporali.

---

## 🛡️ 4. VALIDAZIONE PREVENTIVA SUI 7 ASSI ASTRALIS

1. **Asse 1 — Validità**: Tipizzazione statica GDScript 2.0 al 100%, rispetto rigoroso delle signature dei metodi, enum centralizzati in `core/enums.gd`.
2. **Asse 2 — Efficacia**: Risoluzione diretta di tutte le esigenze della Sezione 6 della Roadmap Modulare e delle indicazioni di Game Design di Luca (12 città, eventi temporanei, jet lag, custom tour, day off, imprevisti narrativi).
3. **Asse 3 — Coerenza**: Perfetto allineamento con la Clean Architecture di World-tour, EventBus a segnali, modelli puri disaccoppiati e controller UI accessibili.
4. **Asse 4 — Completezza**: Copertura di tutti i casi limite (viaggio con fondi o energia insufficienti, jet lag cumulativo, tour interrotto prima della fine, imprevisti risolti con risorse a zero).
5. **Asse 5 — Precisione**: Modifiche chirurgiche su `TravelSystem` e `TourSystem` senza sporcare o frammentare i contratti consolidati delle Fasi 1–5.
6. **Asse 6 — Affidabilità & Prestazioni**: Determinismo a 0 ms headless, nessun delay artificiale o `OS.delay()`, gestione memoria senza leak.
7. **Asse 7 — Assenza Regressioni & Prevenzione Anomalie**: Preservazione integrale della suite di 23 test storici e compatibilità garantita dei salvataggi JSON.

---

## 🧪 5. I 3 LIVELLI DI SIMULAZIONE DI COLLAUDO

- **Livello 1 (Happy Path)**:
  La band di Alex ha raggiunto una buona reputazione (45.0) e decide di espandere la propria carriera all'estero: apre la mappa viaggi (`V`), nota che a Parigi è in corso la *Notte Bianca*, viaggia a Parigi e suona a *La Cigale* ottenendo il doppio dell'affluenza. Successivamente, apre il pannello tour (`O`), progetta una tournée a 4 tappe (Milano -> Dublino -> Day Off -> Londra) con il Van Professionale; durante la giornata di Day Off la band si rilassa e recupera energia e morale; la mattina del concerto a Londra Alex rilascia un'intervista alla BBC Radio locale aumentando l'Hype della data; conclude il tour con un successo trionfale guadagnando gli adesivi di Parigi, Dublino e Londra sul furgone.
- **Livello 2 (Percorsi Alternativi & Concorrenti)**:
  Alex tenta un tour a basso budget con il *Furgone Scassato* per risparmiare denaro. Durante lo spostamento notturno tra Bologna e Roma, scatta l'imprevisto della *Foratura in Autostrada sotto la Pioggia*. Alex decide di risparmiare denaro cambiando la ruota da solo insieme alla band: la riparazione riesce, ma il gruppo consuma 20 energia e accumula stress e tensione. Arrivati a Roma, Alex preferisce far riposare la band anziché fare interviste promozionali, salvaguardando la voce e l'energia per la sera.
- **Livello 3 (Corner Cases & Limiti Estremi)**:
  Alex tenta di viaggiare a New York senza avere la reputazione minima richiesta (60.0): il sistema rifiuta il viaggio spiegando chiaramente il requisito mancante. Quando finalmente raggiunge la reputazione necessaria, prenota il volo per Tokyo: il viaggio transoceanico consuma 55 energia e 1.100 €, applicando lo stato *Jet Lag* per 2 giorni. Durante il jet lag, se Alex tenta di allenarsi o suonare senza aver prima recuperato, il sistema calcola la minore efficienza energetica; una sosta in autogrill alle 03:00 con discussione interna testa la tenuta psicologica della band con tensione elevata.

---

## 🛑 6. CRITERI DI ACCETTAZIONE & STATO CONVALIDA

- [x] [CONVALIDATO CON SUCCESSO] Approvazione esplicita del Piano Tecnico da parte di Luca ("procedi", "applica", "esegui").
- [x] [CONVALIDATO CON SUCCESSO] Stop Obbligatorio rispettato prima di toccare codice sorgente o configurazioni (Sotto-Fase 1B).
- [x] [CONVALIDATO CON SUCCESSO] Esecuzione dei Contratti D0..D8 in Sotto-Fase 1B post-approvazione.
- [x] [CONVALIDATO CON SUCCESSO] Esecuzione dell'intera suite di test headless (23/23 suite superate a 0 errori e 0 ms).
- [x] [CONVALIDATO CON SUCCESSO] Fase 2: Deploy Provvisorio & Collaudo Manuale NVDA da parte di Luca superato con successo.
- [x] [CONVALIDATO CON SUCCESSO] Fase 3: Chiusura Tecnica, Living Documentation, Git Commit locale & Disciplina AVF (V4.6.0).
