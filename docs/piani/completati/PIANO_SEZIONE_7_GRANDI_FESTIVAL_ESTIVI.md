# Piano Tecnico Operativo — Sezione 7: Grandi Festival Estivi all'Aperto
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-24
# Stato: [x] [CONVALIDATO CON SUCCESSO — CHIUSURA SOTTO-FASE 1B & FASE 2]
# File Piano: docs/piani/completati/PIANO_SEZIONE_7_GRANDI_FESTIVAL_ESTIVI.md
# File di Riferimento: docs/roadmap/07_grandi_festival_estivi.md & docs/report/REPORT_AVVIO_SESSIONE_SEZIONE_7.md
# Coordinatore Master: docs/todo.md
# Baseline AVF: V4.6.0 (Target Release: V4.7.0)

---

## 🎯 1. OBIETTIVO E PERIMETRO DELLA SEZIONE 7

La **Sezione 7 della Roadmap Modulare** governa l'evoluzione del pilastro **Grandi Festival Estivi all'Aperto** di *World-tour*.
L'obiettivo è trasformare la stagione estiva dei festival in un appuntamento cardinale della carriera musicale della band, creando un vero arco narrativo e strategico stagionale che collega **la primavera con i contest emergenti ("Battle of the Bands")** all'**estate con i grandi palchi all'aperto nelle 12 metropoli mondiali**, introducendo **slot orari differenziati, tipologie di palco (Main Stage vs Tenda Underground), gestione dei conflitti di orario, mosse sceniche estreme per "Rubare la Scena" (*Steal the Show*), sponsorizzazioni commerciali festivaliere, dinamiche meteo estive e merchandising intensivo**, articolato in 5 pilastri strategici:

1. **Espansione Globale del Circuito Festivaliero a 12 Metropoli Mondiali (`FestivalData`, `FestivalSystem`, `Enums.CityId`)**:
   - Espansione del catalogo predefinito da 6 a 12 Grandi Festival Estivi (Mesi 4-6, Giorni 85-168) per coprire tutte le metropoli mondiali della rete geografica (introdotte nella Sezione 6):
     * *Milano (Italia)*: **Rock in Milano Open Air** (Idroscalo Arena, Cap. 35.000, Mese 4 - Giorno 92, Generi: Rock, Elettronica, Pop; Rivale: "The Chrome Shadows", benchmark 74.0).
     * *Bologna (Italia)*: **Independent Summer Fest** (Arena Parco Nord, Cap. 20.000, Mese 5 - Giorno 120, Generi: Indie, Rock, Punk; Rivale: "I Ribelli del Pratello", benchmark 72.0).
     * *Roma (Italia)*: **Roma Rock & Live Fest** (Ippodromo delle Capannelle, Cap. 40.000, Mese 5 - Giorno 134, Generi: Rock, Pop, Cantautorato; Rivale: "Colosseo Sound Machine", benchmark 76.0).
     * *Napoli (Italia)*: **Partenope Sound Fest** (Arenile di Bagnoli, Cap. 25.000, Mese 6 - Giorno 152, Generi: Hip Hop, Rock, Pop; Rivale: "Vesuvio Posse", benchmark 75.0).
     * *Londra (Regno Unito)*: **Hyde Park & Download Calling** (Hyde Park Great Arena, Cap. 65.000, Mese 4 - Giorno 104, Generi: Rock, Metal, Indie; Rivale: "Royal Camden Vanguard", benchmark 82.0).
     * *Berlino (Germania)*: **Berlin Electronic & Heavy Gathering** (Tempelhof Airfield, Cap. 50.000, Mese 6 - Giorno 160, Generi: Elettronica, Metal, Industrial; Rivale: "Klangwerk Berlin", benchmark 80.0).
     * *Dublino (Irlanda)*: **St. Patrick & Celtic Rock Fest** (Phoenix Park Great Lawn, Cap. 45.000, Mese 4 - Giorno 100, Generi: Rock, Indie, Pop; Rivale: "Celtic Fiddle Rebels", benchmark 78.0).
     * *Parigi (Francia)*: **Festival de l'Étoile & French Touch** (Bois de Boulogne Arena, Cap. 55.000, Mese 5 - Giorno 128, Generi: Elettronica, Pop, Indie; Rivale: "Le Syndicate Neon", benchmark 81.0).
     * *Madrid (Spagna)*: **Festival Sol y Fuego** (Parque del Retiro Live Arena, Cap. 40.000, Mese 6 - Giorno 146, Generi: Rock, Pop, Hip Hop; Rivale: "Torero Electric Band", benchmark 77.0).
     * *New York (Stati Uniti)*: **Central Park Global Megafest** (Central Park Great Meadow, Cap. 70.000, Mese 5 - Giorno 116, Generi: Hip Hop, Rock, Pop; Rivale: "Gotham Underground Kings", benchmark 85.0).
     * *Los Angeles (Stati Uniti)*: **Sunset Boulevard Summer Open Air** (Hollywood Bowl Pavilion, Cap. 60.000, Mese 4 - Giorno 108, Generi: Pop, Rock, Elettronica; Rivale: "Sunset Strip Sirens", benchmark 83.0).
     * *Tokyo (Giappone)*: **Tokyo Neo Sound Festival** (Yoyogi Park Dome Open Air, Cap. 65.000, Mese 6 - Giorno 164, Generi: Elettronica, Rock, Pop; Rivale: "Neo Tokyo Cyber Syndicate", benchmark 84.0).

2. **Contest Primaverile per Band Emergenti ("Battle of the Bands") (`FestivalSystem`, `PlayerData`, `ScheduleSystem`)**:
   - Stagione Primaverile (Mese 3 / Giorni 57-84):
     Periodo dedicato alla gavetta competitiva in cui le band emergenti possono conquistarsi un posto nel cartellone estivo senza attendere di accumulare 35 o 60 punti di reputazione.
   - Requisiti: accessibile anche a formazioni con reputazione minima (>= 0.0), purché abbiano almeno 1 brano pronto o pubblicato.
   - Svolgimento: confronto live in un club della città tra la band del giocatore e una band emergente locale (es. "The Young Challengers", benchmark score 65.0).
   - Esito Vittorioso:
     * Trofeo e Pass Speciale: `player_data.battle_of_bands_pass = true`.
     * Premio in denaro immediato (+300.0 €).
     * Salto di Reputazione (+8.0 punti) e boost Morale band (+20).
     * **Effetto Gating Estivo**: Il pass abbatte i requisiti minimi di accesso: azzera il requisito reputazione per l'Opening Slot (da 15.0 a 0.0) e dimezza il requisito per il Sunset Slot (da 35.0 a 17.5), aprendo le porte dei festival estivi anche a chi parte dal basso!
   - Sincronizzazione su `ScheduleSystem`.

3. **Tipologie Palco (Main Stage vs Tenda Underground) & Conflitti di Orario (Time Clash) (`FestivalData`, `FestivalSystem`, `Enums.FestivalStageType`)**:
   - Due ambienti di esibizione distinti all'interno dell'area festival:
     * `MAIN_STAGE` (Palco Principale): palcoscenico monumentale, massima visibilità, 100% dell'affluenza prevista dello slot, riverbero nazionale.
     * `UNDERGROUND_TENT` (Tenda Underground / Stage Secondario): ambiente intimo e tellurico (capienza 50% rispetto al main stage), ideale per generi viscerali (Indie, Metal, Elettronica, Hip Hop, Punk). Se il genere del setlist è affine alla tenda:
       - +50% tasso di conversione fan (+alta fedeltà e devozione).
       - +30% vendite merchandising.
       - Tensione band ridotta (-10).
   - Meccanica Conflitto di Orari (*Time Clash*):
     * Durante lo show, una band rivale o leggendaria suona contemporaneamente su un altro palco.
     * Scelta tattica per il giocatore (3 opzioni):
       1. *Attacco Frontale e Ritmo Serrato*: brani più energici e check Fisico/Energia per attirare la folla dei curiosi (+20% affluenza rubata al palco concorrente).
       2. *Connessione Intima e Dedica ai Fedelissimi*: concentrarsi sulla qualità emotiva e musicale (+30% devozione fan, zero rischi).
       3. *Ospite a Sorpresa o Momento Virale*: check Carisma per creare l'hype del festival (viralità social e boost reputazione).

4. **Meccanica "Rubare la Scena" (*Steal the Show*) & Mosse Sceniche Estreme a Bivi (`FestivalSystem`, `Enums.FestivalExtremeMove`)**:
   - Algoritmo di confronto diretto con la band rivale sul cartellone.
   - Prima o durante il concerto, il giocatore può scegliere se tentare una **Mossa Scenica Estrema** (*Extreme Stage Move*):
     1. `STAGE_DIVING`: Salto a capofitto nella folla oceanica. Check Fisico / Carisma. Se riuscito: crowd surfing epico, folla in visibilio, +15 score concerto, +25% conversione fan. Se fallito: caduta scomposta tra le transenne, -10 morale, +10 stress.
     2. `RIGGING_CLIMB`: Arrampicata sulle impalcature e sui tralicci luci. Check Performance / Coraggio. Se riuscito: scatto fotografico iconico, +20 score concerto, boost virale immediato (+500 follower/buzz). Se fallito: richiamo furioso dei tecnici del service, multa di 150 € per violazione sicurezza.
     3. `CROWD_SOLO`: Assolo o cantato direttamente tra le prime file della folla. Check Abilità Strumento / Canto. Se riuscito: momento di culto, +15 score, standing ovation. Se fallito: plettro caduto o feedback acustico fischietto, -5 score.
     4. `REGULAR_SHOW`: Nessuna mossa rischiosa, esecuzione impeccabile e professionale dello show (zero bonus, zero rischi).
   - Backstage Drama Post-Show:
     - Se `stole_the_show == true`:
       * Trionfo eclatante: +30% fan convertiti, +6.0 reputazione, morale band al 100%, tensione abbattuta di -20 punti!
       * Reazione nel backstage della band rivale (es. "The Chrome Shadows"): bisticcio o rispetto sportivo, con annuncio vocale dedicato per NVDA.

5. **Moltiplicatore Merchandising Intensivo, Sponsorizzazioni & Meteo Estivo all'Aperto (`FestivalData`, `FestivalSystem`, `Enums.FestivalSponsorType`, `Enums.FestivalWeather`)**:
   - Moltiplicatore Merch massivo: confermato e potenziato con lo stand dedicato festival (T-shirt Festival Edition, braccialetti in tessuto, poster serigrafato). Margine da x2.5 (pomeriggio) a x5.5 (headliner notturno).
   - Sponsorizzazioni da Festival (*Festival Sponsorship*):
     * 3 sponsor commerciali con accordi a giornata di festival:
       1. `ENERGY_DRINK`: Anticipo immediato di 800 € - 1.500 €, boost energia +15, richiede esposizione logo.
       2. `CRAFT_BEER`: Fornitura per il backstage (morale +20, tensione -15) e bonus 600 € - 1.200 €.
       3. `STREETWEAR_GEAR`: Completo scenico per la band (+5 carisma) e bonus 1.000 € - 2.500 €.
     * Gating etico: se si accetta uno sponsor commerciale, check Carisma/Credibilità per non deludere i fan puristi indie/punk (-1.5 reputazione se fallito per "svendita commerciale").
   - Dinamica Meteo dei Festival all'Aperto (`FestivalWeather`):
     1. `SUNNY_HEATWAVE` (Sole Cocente / Canicola): consumo energetico aumentato (+15 fatica), ma vendite merch e bibite maggiorate (+20%).
     2. `PERFECT_MILD` (Clima Perfetto / Tramonto Ideale): condizioni ideali, nessun malus, boost resa live.
     3. `SUMMER_STORM` (Temporale Estivo Improvviso & Fango):
        - Bivio epico:
          a) *Suonare sotto il diluvio*: concerto leggendario, +25% conversione fan e rispetto della scena, ma -10% integrità strumenti per l'umidità (da riparare dal liutaio).
          b) *Pausa tecnica sotto il tendone*: show ripreso in sicurezza appena cessa la pioggia, zero danni agli strumenti.

---

## 🏛️ 2. ANALISI ARCHITETTURALE E MODELLI DATI

### 2.1 Modello Dati `FestivalData` & `core/enums.gd`
- In `core/enums.gd`:
  * Aggiunta `enum FestivalStageType`:
    ```gdscript
    enum FestivalStageType {
        MAIN_STAGE = 0,
        UNDERGROUND_TENT = 1
    }
    ```
  * Aggiunta `enum FestivalExtremeMove`:
    ```gdscript
    enum FestivalExtremeMove {
        NONE = 0,
        STAGE_DIVING = 1,
        RIGGING_CLIMB = 2,
        CROWD_SOLO = 3
    }
    ```
  * Aggiunta `enum FestivalSponsorType`:
    ```gdscript
    enum FestivalSponsorType {
        NONE = 0,
        ENERGY_DRINK = 1,
        CRAFT_BEER = 2,
        STREETWEAR_GEAR = 3
    }
    ```
  * Aggiunta `enum FestivalWeather`:
    ```gdscript
    enum FestivalWeather {
        SUNNY_HEATWAVE = 0,
        PERFECT_MILD = 1,
        SUMMER_STORM = 2
    }
    ```
  * Funzioni di localizzazione vocale per NVDA:
    - `get_festival_stage_type_name(stage_type: int) -> String`
    - `get_festival_extreme_move_name(move: int) -> String`
    - `get_festival_sponsor_type_name(sponsor: int) -> String`
    - `get_festival_weather_name(weather: int) -> String`

### 2.2 Estensione di `FestivalData` (`data/models/festival_data.gd`)
- Campi aggiuntivi:
  * `stage_type: int = Enums.FestivalStageType.MAIN_STAGE`
  * `active_sponsor: int = Enums.FestivalSponsorType.NONE`
  * `weather: int = Enums.FestivalWeather.PERFECT_MILD`
  * `time_clash_active: bool = false`
- Aggiornamento `to_dict()` e `from_dict()` per garantire la completa persistenza atomica.

### 2.3 Estensione di `PlayerData` (`data/models/player_data.gd`)
- Campi aggiuntivi:
  * `battle_of_bands_pass: bool = false`: pass speciale ottenuto vincendo la competizione primaverile.
  * `festival_trophies: Array[String] = []`: trofei dei festival vinti o delle Battle of the Bands vinte.
- Aggiornamento `to_dict()` e `from_dict()`.

### 2.4 Modulo Contest Primaverile in `FestivalSystem`
- `can_enter_battle_of_bands() -> Dictionary`:
  * Verifica se il mese corrente è Primavera (Mese 3 / Giorni 57-84).
  * Verifica se la band possiede almeno 1 brano pronto o pubblicato.
  * Verifica se la battle of the bands annuale non è già stata vinta.
- `compete_in_battle_of_bands(songs: Array, mock_score: float = -1.0) -> Dictionary`:
  * Calcolo dello score basato sul setlist e sulle abilità della band.
  * Confronto con la band emergente rivale ("The Young Challengers", benchmark score 65.0).
  * Se vittorioso: accredito premio (+300 €), reputazione (+8.0), morale (+20), attivazione `player_data.battle_of_bands_pass = true`.
  * Sincronizzazione con `ScheduleSystem` ed emissione segnale EventBus.

### 2.5 Integrazione con `ScheduleSystem` & `ConcertSystem`
- `ScheduleSystem`:
  * Già supporta `Enums.CalendarEventType.FESTIVAL`.
  * Gestione degli impegni primaverili per la Battle of the Bands e blocco sovrapposizioni nelle stesse fasce orarie.
- `ConcertSystem`:
  * La risoluzione dei festival beneficia dell'esperienza accumulata nella Sezione 5 (drammaturgia scaletta, usura strumenti, interazione band). In caso di diluvio estivo, l'usura degli strumenti viene sincronizzata con `UpgradesSystem` / `PlayerData`.

---

## 📋 3. SCOMPOSIZIONE ATOMICA IN NAMED CONTRACTS (ASTRALIS PROTOCOLLO 12)

- **Contratto D0 (Clean Sweep & Pre-Flight Baseline Verification)**:
  Verifica pulizia del working tree Git e convalida 100% verde di tutte le 23 suite headless del progetto a 0 errori (già convalidato: 23 suite su 23 superate, 0 fallimenti).
- **Contratto D1 (Espansione Enums & Localizzazione Vocale in `core/enums.gd`)**:
  Definizione degli enum `FestivalStageType`, `FestivalExtremeMove`, `FestivalSponsorType`, `FestivalWeather` e dei router di localizzazione vocale per NVDA.
- **Contratto D2 (Espansione Modelli Dati `FestivalData` & `PlayerData`)**:
  Integrazione dei nuovi campi in `FestivalData` (stage type, sponsor, weather, time clash) e in `PlayerData` (`battle_of_bands_pass`, `festival_trophies`), con serializzazione atomica in `to_dict()` e `from_dict()`.
- **Contratto D3 (Espansione Catalogo a 12 Festival Mondiali in `FestivalSystem`)**:
  Estensione del catalogo predefinito con i 6 nuovi Grandi Festival Estivi nelle metropoli mondiali (Dublino, Parigi, Madrid, New York, Los Angeles, Tokyo), con capienze, generi affini, band rivali e date di calendario.
- **Contratto D4 (Modulo Contest Primaverile 'Battle of the Bands' in `FestivalSystem` & `ScheduleSystem`)**:
  Logica di ammissione, svolgimento e premiazione della Battle of the Bands primaverile (Mese 3), con emissione del Pass Speciale che abbatte o dimezza i requisiti minimi di reputazione estivi.
- **Contratto D5 (Tipologie di Palco & Conflitto di Orari in `FestivalSystem`)**:
  Supporto per Main Stage vs Underground Tent (calcolo affluenza, gradimento generi viscerali, conversione fan maggiorata) e risoluzione a bivi del Time Clash contro palchi rivali.
- **Contratto D6 (Mosse Sceniche Estreme a Bivi & Steal the Show Avanzato in `FestivalSystem`)**:
  Check abilità deterministico per Stage Diving, Rigging Climb e Crowd Solo; modificatori punteggio, conversione fan, reazioni del pubblico e backstage drama post-show.
- **Contratto D7 (Sponsorizzazioni Festivaliere, Stand Merch & Meteo Outdoor in `FestivalSystem`)**:
  Negoziazione sponsor (Energy Drink, Craft Beer, Streetwear Gear), check credibilità contro accuse di "svendita commerciale", generazione meteo estivo (Sole cocente, Clima perfetto, Temporale estivo) e bivio temporale sotto il diluvio.
- **Contratto D8 (Controller UI `FestivalModal` & Accessibilità NVDA Zero Mouse in `ui/festival/`)**:
  Aggiornamento di `FestivalModal` (tasto rapido HUD `F`) con navigazione da tastiera per 12 metropoli, selezione palchi (`M`/`U`), slot (`P`/`T`/`H`), sponsor e mosse sceniche (`1`..`4`), tasto rapido `B` per la Battle of the Bands, annunci vocali sequenziali per NVDA e volumi congelati tra 0.7f e 0.8f.
- **Contratto D9 (Suite di Test Headless Dedicate & Blindatura Globale 24+ Suite a 0 Errori)**:
  Espansione di `tests/test_festival_system.gd` per validare al 100% tutti i contratti D1..D7 a 0 ms headless, garantendo zero regressioni sulle 23 suite preesistenti.

---

## 🛡️ 4. VALIDAZIONE PREVENTIVA SUI 7 ASSI ASTRALIS

1. **Asse 1 — Validità**: Tipizzazione statica GDScript 2.0 al 100%, rispetto rigoroso delle signature dei metodi, enum centralizzati in `core/enums.gd`.
2. **Asse 2 — Efficacia**: Risoluzione diretta di tutte le direttrici della Sezione 7 della Roadmap Modulare e delle indicazioni di Game Design di Luca (12 festival mondiali, contest primaverile Battle of the Bands, slot orari, palchi underground, mosse estreme, sponsor e meteo).
3. **Asse 3 — Coerenza**: Perfetto allineamento con la Clean Architecture di World-tour, EventBus a segnali, modelli puri disaccoppiati e controller UI accessibili.
4. **Asse 4 — Completezza**: Copertura di tutti i casi limite (candidatura senza reputazione, pass primaverile utilizzato, diluvio estivo con usura strumenti, fallimento mossa scenica con infortunio o sanzione, rifiuto sponsor).
5. **Asse 5 — Precisione**: Modifiche chirurgiche su `FestivalSystem` e `FestivalData` senza frammentare o sporcare i contratti consolidati delle Fasi 1–6.
6. **Asse 6 — Affidabilità & Prestazioni**: Determinismo a 0 ms headless, nessun delay artificiale o `OS.delay()`, gestione memoria senza leak.
7. **Asse 7 — Assenza Regressioni & Prevenzione Anomalie**: Preservazione integrale della suite di 23 test storici e compatibilità garantita dei salvataggi JSON.

---

## 🧪 5. I 3 LIVELLI DI SIMULAZIONE DI COLLAUDO

- **Livello 1 (Happy Path)**:
  La band di Alex è al Mese 3 (Primavera) con reputazione ancora modesta (10.0): si candida alla *Battle of the Bands* locale, suona il suo brano migliore e vince il contest conquistando il *Pass Speciale Battle of the Bands*, 300 € e +8 reputazione. All'arrivo dell'estate (Mese 4), Alex prenota lo Slot al Tramonto al grande festival di Dublino (*St. Patrick & Celtic Rock Fest*) grazie al pass che dimezza il requisito reputazione; sceglie la *Tenda Underground* per la forte affinità rock/indie; accetta lo sponsor del *Birrificio Artigianale*; durante lo show esegue con successo un trascinante *Stage Diving* nella folla oceanica; batte la band rivale sul cartellone rubando la scena (+30% fan, reputazione alle stelle, morale 100%).
- **Livello 2 (Percorsi Alternativi & Concorrenti)**:
  Alex decide di non partecipare alla Battle of the Bands primaverile e preferisce concentrarsi sulla registrazione in studio. Arrivata l'estate, grazie al manager professionista che riduce le soglie di reputazione, riesce comunque a strappare uno Slot Pomeridiano al *Festival de l'Étoile* di Parigi sul Main Stage. Tuttavia, durante il set si scatena un *Temporale Estivo Improvviso*: Alex sceglie eroicamente di continuare a suonare sotto la pioggia battente, infiammando il pubblico e guadagnando un immenso rispetto dai fan, ma subendo una leggera usura degli strumenti che richiederà una visita dal liutaio.
- **Livello 3 (Corner Cases & Limiti Estremi)**:
  Alex tenta di prenotare l'Headliner Notturno a New York (*Central Park Global Megafest*, requisito 60.0) con soli 20 punti reputazione e senza pass Battle of the Bands: il sistema respinge la candidatura spiegando chiaramente i requisiti mancanti. Quando ottiene i requisiti e suona a New York, tenta un'azzardata *Arrampicata sui Tralicci Luci* con punteggio Performance insufficiente: la mossa fallisce, i tecnici interrompono temporaneamente il faro e la band riceve una sanzione di 150 €, ma la tenacia del gruppo permette di salvare il concerto con un buon incasso di merchandising intensivo.

---

## 🛑 6. CRITERI DI ACCETTAZIONE & STATO CONVALIDA

- [x] [CONVALIDATO CON SUCCESSO] Approvazione esplicita del Piano Tecnico da parte di Luca ("procedi").
- [x] [CONVALIDATO CON SUCCESSO] Stop Obbligatorio rispettato prima di toccare codice sorgente o configurazioni (Sotto-Fase 1A completata).
- [x] [CONVALIDATO CON SUCCESSO] Esecuzione dei Contratti D0..D9 in Sotto-Fase 1B post-approvazione.
- [x] [CONVALIDATO CON SUCCESSO] Esecuzione dell'intera suite di test headless (23 suite superate a 0 errori e 0 ms, 123 asserzioni festival).
- [x] [CONVALIDATO CON SUCCESSO] Fase 2: Deploy Provvisorio & Collaudo Manuale NVDA da parte di Luca superato.
- [x] [CONVALIDATO CON SUCCESSO] Fase 3: Chiusura Tecnica, Living Documentation, Git Commit locale & Disciplina AVF (V4.7.0).
