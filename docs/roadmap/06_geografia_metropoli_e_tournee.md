# World-tour — Roadmap Modulare: Sezione 6

- File di origine: `docs/roadmap.md`
- Titolo: Geografia, Metropoli & Tournée
- Priorità Operativa: P6 - Espansione Territoriale

---

## 6. GEOGRAFIA, METROPOLI & TOURNÉE

### 6.1 Rete delle 6 Città Europee & Affinità Musicali di Scena
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/city_data.gd`.
  - Modulo di viaggio: `systems/travel_system.gd` e modale `TravelModal` (`ui/travel/travel_modal.tscn`), tasto rapido HUD `V`.
  - Le 6 Metropoli Continentali (`Enums.CityId`):
    1. Milano (Italia): Capitale della moda e dell'industria discografica, affinità Rock ed Elettronica (+20%).
    2. Bologna (Italia): Capitale universitaria e culla alternativa, forte affinità Indie e Rock (+25%).
    3. Roma (Italia): Città eterna, grandi arene, affinità Pop e Rock d'autore (+20%).
    4. Napoli (Italia): Calore mediterraneo, passione viscerale, affinità Hip Hop e crossover (+25%).
    5. Londra (Regno Unito, Internazionale): Patria del Rock e della New Wave, affinità Rock e Metal (+30%), richiede reputazione minima 40.0.
    6. Berlino (Germania, Internazionale): Capitale dell'avanguardia underground, affinità Elettronica ed Industrial (+35%), richiede reputazione minima 45.0.
  - Sintesi vocale con descrizione completa delle affinità e locali premendo i tasti `1`..`6`.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Inserimento di nuove città iconiche (Dublino per il Folk/Rock celtico, Parigi per la Chanson e l'Electro-House, Madrid, New York, Los Angeles, Tokyo).
  - Eventi cittadini temporanei (es. Notte Bianca con concerti in tutte le piazze, Fiera Internazionale della Musica).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
  - # 6.1 Rete delle 6 Città Europee & Affinità Musicali di Scena

La rete geografica rappresenta il livello di espansione territoriale della carriera dell'artista.

Il giocatore non opera all'interno di una singola città, ma può spostarsi tra differenti metropoli, ognuna caratterizzata da una propria identità culturale e musicale.

La città non determina obbligatoriamente il genere dell'artista: rappresenta piuttosto un **contesto favorevole** per determinati stili musicali.

Un artista Rock può quindi nascere a Napoli e un artista Hip Hop può affermarsi a Berlino. Le affinità di scena modificano le opportunità e la risposta del pubblico, ma non impongono una direzione artistica.

## Dettagli Tecnici & Meccaniche Già Implementate

### Modello Dati

Le informazioni relative alle città sono definite attraverso:

* `data/models/city_data.gd`

Il sistema permette di associare a ogni città:

* identificativo univoco;
* nazione;
* caratteristiche descrittive;
* generi musicali maggiormente affini;
* bonus di affinità;
* eventuali requisiti di reputazione;
* locali disponibili nella città.

### Modulo di Viaggio

Il trasferimento tra città è gestito da:

* `systems/travel_system.gd`
* Modale `TravelModal`:

  * `ui/travel/travel_modal.tscn`
* Tasto rapido HUD:

  * `V`

Il viaggio rappresenta quindi un sistema separato rispetto alla semplice selezione di una venue.

Il giocatore deve poter decidere **quando e dove spostare la propria carriera**, tenendo conto della città nella quale vuole esibirsi o sviluppare la propria presenza musicale.

## Le 6 Metropoli della Rete

### 1. Milano — Italia

**Identità:** capitale della moda e dell'industria discografica.

**Affinità musicali:**

* Rock
* Elettronica

**Bonus di affinità:** `+20%`

Milano rappresenta uno dei principali poli commerciali e professionali della rete italiana.

La città è particolarmente adatta ad artisti che vogliono sviluppare una dimensione più professionale e orientata all'industria musicale.

---

### 2. Bologna — Italia

**Identità:** città universitaria e importante centro della scena alternativa.

**Affinità musicali:**

* Indie
* Rock

**Bonus di affinità:** `+25%`

Bologna rappresenta una scena maggiormente legata alla musica alternativa e alla cultura underground.

Può diventare un ambiente particolarmente interessante per artisti emergenti che vogliono costruire una fanbase prima di puntare ai grandi circuiti commerciali.

---

### 3. Roma — Italia

**Identità:** città storica con grandi arene e forte tradizione musicale.

**Affinità musicali:**

* Pop
* Rock d'autore

**Bonus di affinità:** `+20%`

Roma rappresenta una delle destinazioni più importanti per la crescita nazionale dell'artista.

La presenza di venue di dimensioni maggiori permette inoltre di collegare la città alla progressione verso concerti sempre più importanti.

---

### 4. Napoli — Italia

**Identità:** città caratterizzata da forte energia culturale e musicale.

**Affinità musicali:**

* Hip Hop
* Crossover

**Bonus di affinità:** `+25%`

Napoli offre un ambiente particolarmente favorevole agli artisti che combinano generi differenti.

Il concetto di crossover è importante perché incoraggia il giocatore a sperimentare contaminazioni musicali invece di rimanere necessariamente all'interno di un singolo genere.

---

### 5. Londra — Regno Unito

**Identità:** capitale internazionale storicamente associata al Rock e alla New Wave.

**Affinità musicali:**

* Rock
* Metal

**Bonus di affinità:** `+30%`

**Requisito minimo di reputazione:** `40.0`

Londra rappresenta il primo grande salto internazionale della rete.

L'accesso non è immediato: il requisito di reputazione obbliga il giocatore a costruire prima una carriera sufficientemente solida.

Il bonus di affinità rende inoltre la città particolarmente interessante per determinati generi, senza impedire ad artisti di altri generi di entrarvi e costruire comunque la propria scena.

---

### 6. Berlino — Germania

**Identità:** capitale dell'avanguardia underground e della sperimentazione elettronica.

**Affinità musicali:**

* Elettronica
* Industrial

**Bonus di affinità:** `+35%`

**Requisito minimo di reputazione:** `45.0`

Berlino rappresenta uno dei principali poli internazionali per la sperimentazione musicale.

L'elevata affinità con Elettronica e Industrial rende la città particolarmente interessante per artisti orientati verso sonorità sperimentali e produzioni elettroniche.

Il requisito di reputazione `45.0` la colloca inoltre in una fase avanzata della progressione geografica.

## Tabella Riassuntiva

| Città   | Paese       | Affinità                 | Bonus | Reputazione minima |
| ------- | ----------- | ------------------------ | ----: | -----------------: |
| Milano  | Italia      | Rock / Elettronica       |  +20% |                  0 |
| Bologna | Italia      | Indie / Rock             |  +25% |                  0 |
| Roma    | Italia      | Pop / Rock d'autore      |  +20% |                  0 |
| Napoli  | Italia      | Hip Hop / Crossover      |  +25% |                  0 |
| Londra  | Regno Unito | Rock / Metal             |  +30% |               40.0 |
| Berlino | Germania    | Elettronica / Industrial |  +35% |               45.0 |

## Affinità Musicale di Scena

L'affinità musicale rappresenta la predisposizione di una determinata scena cittadina verso alcuni generi.

Il bonus non dovrebbe essere interpretato come un semplice moltiplicatore permanente applicato a qualsiasi attività.

A livello di design, può influenzare progressivamente elementi come:

* risposta del pubblico;
* crescita della fanbase locale;
* efficacia dei concerti;
* interesse verso determinati generi;
* opportunità locali;
* eventi musicali;
* reputazione all'interno della scena.

Il principio fondamentale rimane:

> **La città favorisce uno stile, ma non lo impone.**

Questo permette al giocatore di costruire una carriera non convenzionale.

## Sintesi Vocale e Accessibilità

Il sistema include una descrizione completa delle città accessibile tramite sintesi vocale.

Premendo i tasti:

**`1` → `6`**

il giocatore può selezionare direttamente una delle sei città.

La descrizione vocalizzata deve fornire almeno:

* nome della città;
* paese;
* identità della scena;
* generi con maggiore affinità;
* percentuale di bonus;
* eventuale requisito di reputazione;
* informazioni relative ai locali disponibili.

Questo permette di utilizzare il sistema geografico senza dipendere esclusivamente da elementi grafici o dalla mappa.

## Direttrici di Espansione & Idee di Gameplay

### Nuove Città Iconiche

La rete può essere ampliata progressivamente mantenendo lo stesso modello dati.

Possibili destinazioni:

* **Dublino** → Folk / Rock celtico
* **Parigi** → Chanson / Electro-House
* **Madrid** → Pop / Flamenco / Latin
* **New York** → Hip Hop / Rock / Pop
* **Los Angeles** → Pop / Rock / Entertainment
* **Tokyo** → J-Pop / Rock / Elettronica

L'espansione geografica dovrebbe essere progressiva: nuove città possono richiedere livelli di reputazione sempre maggiori e introdurre nuove scene musicali.

### Eventi Cittadini Temporanei

Una possibile evoluzione consiste nell'introduzione di eventi che modificano temporaneamente l'attività musicale di una città.

Esempi:

**Notte Bianca**

Una notte speciale nella quale vengono organizzati concerti ed eventi in numerose piazze della città.

Possibili conseguenze:

* maggiore affluenza;
* più opportunità di esibizione;
* incremento temporaneo della visibilità;
* maggiore concorrenza tra artisti.

**Fiera Internazionale della Musica**

Grande evento dedicato all'industria musicale.

Potrebbe riunire:

* artisti;
* produttori;
* locali;
* manager;
* professionisti dell'industria;
* media.

Potrebbe quindi rappresentare un'occasione per ottenere opportunità professionali oltre al semplice concerto.

## Principio di Design

La mappa mondiale dovrebbe diventare progressivamente una **mappa delle opportunità musicali**, non soltanto una schermata per viaggiare.

Ogni città dovrebbe avere una propria identità riconoscibile e offrire al giocatore motivi concreti per visitarla.

L'obiettivo finale è creare una progressione del tipo:

**Scena locale → espansione nazionale → scena internazionale → circuito mondiale**

senza impedire al giocatore di seguire un percorso personale e imprevedibile.



### 6.2 Matrice di Viaggio, Costi Logistici & Mezzi di Trasporto
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Matrice delle distanze e costi chilometrici tra le 6 città (viaggi nazionali economici da 30-80 €, viaggi internazionali con traghetto/treno da 150-250 €).
  - Consumo energetico e stress da viaggio calibrati sul tragitto.
  - Le 3 Tipologie di Veicolo per Tournée (`Enums.TourVehicleType`):
    1. `RUSTY_VAN` (Furgone Scassato): Costo noleggio nullo/bassissimo, ma genera +15 stress a tappa e presenta probabilità di guasto meccanico imprevisto.
    2. `PRO_VAN` (Van Professionale): Costo equilibrato (500 € a tour), genera solo +5 stress a tappa, affidabile.
    3. `LUXURY_BUS` (Tour Bus di Lusso): Costo elevato (2.000 € a tour), cuccette per riposare, zero stress aggiunto, rigenera leggermente il morale tra una tappa e l'altra.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Viaggi aerei intercontinentali con gestione del jet lag.
  - Personalizzazione grafica del furgone della band con logo e adesivi delle città visitate.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
  - # 6.2 Matrice di Viaggio, Costi Logistici & Mezzi di Trasporto

Il sistema di viaggio gestisce lo spostamento dell'artista e della band tra le diverse città della rete geografica.

Il viaggio non rappresenta solamente un cambio di posizione sulla mappa: comporta **costi economici, consumo di energia e aumento dello stress**, trasformando la logistica in una componente concreta della gestione della carriera.

## Dettagli Tecnici & Meccaniche Già Implementate

### Matrice delle Distanze

Il sistema utilizza una matrice delle distanze tra le 6 città disponibili.

Il costo del viaggio viene determinato in funzione del tragitto effettuato.

La rete è caratterizzata da:

* viaggi nazionali relativamente economici;
* collegamenti internazionali più costosi;
* costi proporzionati alla distanza e alla tipologia di spostamento.

Indicativamente:

| Tipologia             | Costo indicativo |
| --------------------- | ---------------: |
| Viaggi nazionali      |          30–80 € |
| Viaggi internazionali |        150–250 € |

Questi valori rappresentano il costo logistico di base e possono essere integrati successivamente con ulteriori fattori.

### Impatto sulle Risorse

Ogni viaggio produce conseguenze sulle risorse del personaggio.

In particolare:

* **Energia** → diminuisce in funzione della durata del tragitto;
* **Stress** → aumenta in funzione della durata e delle condizioni di viaggio;
* **Denaro** → diminuisce in base al costo del trasferimento.

Ne consegue che una tournée geograficamente molto dispersiva può risultare economicamente e fisicamente più impegnativa rispetto a una serie di concerti concentrati nella stessa area.

## Mezzi di Trasporto per la Tournée

Il sistema prevede tre tipologie principali di veicolo attraverso:

`Enums.TourVehicleType`

### 1. `RUSTY_VAN` — Furgone Scassato

Il mezzo più economico disponibile.

**Caratteristiche:**

* costo di noleggio nullo o molto basso;
* `+15` Stress per tappa;
* probabilità di guasto meccanico imprevisto.

Rappresenta la soluzione tipica delle prime tournée, quando il budget della band è ancora limitato.

Il risparmio economico viene compensato da una maggiore fatica e da un rischio logistico superiore.

### 2. `PRO_VAN` — Van Professionale

Soluzione intermedia pensata per una band ormai sufficientemente strutturata.

**Costo:**

`500 € / tour`

**Caratteristiche:**

* `+5` Stress per tappa;
* maggiore affidabilità;
* costi ancora sostenibili per una tournée di medie dimensioni.

Rappresenta un compromesso tra investimento economico e qualità della trasferta.

### 3. `LUXURY_BUS` — Tour Bus di Lusso

Soluzione dedicata alle tournée più importanti.

**Costo:**

`2.000 € / tour`

**Caratteristiche:**

* cuccette per il riposo;
* `0` Stress aggiuntivo;
* leggera rigenerazione del Morale tra una tappa e l'altra.

Il Tour Bus trasforma gli spostamenti in una vera parte della vita della band, riducendo drasticamente l'impatto fisico delle trasferte.

## Principio di Design

La scelta del mezzo dovrebbe rappresentare un vero compromesso:

**risparmiare denaro → aumentare il costo fisico e il rischio**

**investire denaro → migliorare comfort e affidabilità**

In questo modo anche una band con pochi soldi può affrontare una tournée, ma dovrà gestire con maggiore attenzione energia, stress e possibili imprevisti.

## Direttrici di Espansione & Idee di Gameplay

### Viaggi Aerei Intercontinentali

Con l'introduzione di città extraeuropee potrebbero essere aggiunti:

* voli intercontinentali;
* costi significativamente superiori;
* tempi di trasferimento più lunghi;
* differenze di fuso orario;
* jet lag;
* recupero energetico modificato.

Il jet lag potrebbe interagire direttamente con il sistema temporale già esistente, rendendo particolarmente impegnative le tournée internazionali.

### Personalizzazione del Mezzo

Il furgone o il tour bus potrebbero diventare elementi visivi permanenti della band.

Possibili personalizzazioni:

* logo della band;
* colori;
* adesivi;
* sponsor;
* città visitate;
* grafiche legate agli album;
* decorazioni speciali ottenute durante eventi o tournée.

Il veicolo diventerebbe così una sorta di **diario visivo della carriera**.

-----------------------------------------------------------------------------------------------------------------------------

### 6.3 Pianificazione del Tour Multi-Tappa & Hype a Catena
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo tour: `systems/tour_system.gd` e modale `TourModal` (`ui/tour/tour_modal.tscn`), tasto rapido HUD `O`.
  - Strutturazione di tournée a tappe concatenate (es. Tour Italiano 3 tappe, Tour Europeo 5 tappe).
  - Meccanica dell'Hype Progressivo a Catena: Ogni concerto concluso con successo eccellente conferisce un accumulo di +5% di Hype, che si riflette come moltiplicatore sull'affluenza di pubblico delle date successive.
  - Sincronizzazione automatica con l'agenda del calendario (`ScheduleSystem`).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Possibilità di inserire giornate di riposo (Day Off) tra due date consecutive per recuperare energia ed evitare il burnout.
  - Interviste promozionali alle stazioni radio locali la mattina stessa del concerto.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
    # 6.3 Pianificazione del Tour Multi-Tappa & Hype a Catena

Il sistema delle tournée permette di trasformare una serie di concerti indipendenti in un'unica **campagna live multi-tappa**.

Il giocatore può quindi progettare un percorso composto da più date, collegando diverse città e organizzando una vera tournée nazionale o internazionale.

## Dettagli Tecnici & Meccaniche Già Implementate

### Modulo Tour

Il sistema è gestito da:

* `systems/tour_system.gd`
* Modale `TourModal`:

  * `ui/tour/tour_modal.tscn`
* Tasto rapido HUD:

  * `O`

Il modulo permette di creare una sequenza ordinata di concerti.

Esempi:

* **Tour Italiano** → 3 tappe;
* **Tour Europeo** → 5 tappe.

Ogni tappa mantiene le proprie caratteristiche:

* città;
* venue;
* data;
* prezzo;
* concerto;
* logistica.

La tournée diventa quindi un contenitore organizzativo che coordina più eventi live.

## Sincronizzazione con il Calendario

La pianificazione della tournée è sincronizzata automaticamente con:

`ScheduleSystem`

Questo permette di integrare le date del tour con il resto della vita dell'artista.

Una data di concerto inserita nella tournée occupa quindi il relativo spazio temporale nel calendario e deve essere considerata insieme alle altre attività programmate.

Questo è particolarmente importante quando il giocatore combina:

* concerti;
* viaggi;
* attività musicali;
* prove;
* interviste;
* eventi;
* recupero;
* vita personale.

## Hype Progressivo a Catena

Uno degli elementi caratteristici del sistema è la meccanica di **Hype Progressivo a Catena**.

Quando un concerto della tournée viene concluso con un risultato eccellente, viene accumulato:

**`+5% Hype`**

L'Hype accumulato agisce come moltiplicatore sull'affluenza delle date successive.

Il concetto è quindi:

**Concerto riuscito → Hype ↑ → maggiore attenzione → pubblico potenziale ↑ → concerto successivo**

La tournée diventa così un sistema dinamico nel quale il risultato di una data può influenzare direttamente le successive.

### Esempio Concettuale

Una tournée parte con un determinato livello di Hype.

Se la prima data viene completata con successo eccellente:

**Hype +5%**

La seconda data beneficia del nuovo livello di Hype.

Se anche la seconda data ottiene un risultato eccellente:

**Hype +5%**

La terza data parte quindi con un Hype superiore rispetto alla prima.

Questo crea una progressione a catena senza rendere ogni concerto completamente indipendente dagli altri.

## Rischio della Tournée

La meccanica dell'Hype introduce naturalmente anche un elemento di gestione del rischio.

Una tournée molto lunga permette di accumulare progressivamente attenzione, ma espone contemporaneamente l'artista a:

* maggiore consumo di energia;
* aumento dello stress;
* maggiori costi logistici;
* trasferimenti frequenti;
* problemi con la band;
* possibili imprevisti;
* rischio di arrivare alle ultime date in condizioni peggiori.

La tournée deve quindi essere progettata tenendo insieme **successo live e sostenibilità fisica**.

## Direttrici di Espansione & Idee di Gameplay

### Giornate di Riposo — Day Off

Il giocatore potrebbe inserire manualmente una giornata di riposo tra due concerti consecutivi.

Un Day Off permetterebbe di:

* recuperare Energia;
* ridurre Stress;
* migliorare Morale;
* diminuire il rischio di Burnout;
* recuperare dopo trasferte particolarmente lunghe.

Il costo principale sarebbe la perdita di una potenziale data disponibile.

Il riposo diventerebbe quindi una vera scelta di gestione della tournée, non semplicemente un tempo morto.

### Interviste Promozionali

La mattina del concerto potrebbe essere possibile partecipare a interviste presso:

* radio locali;
* emittenti musicali;
* podcast;
* programmi televisivi;
* media online.

Le interviste potrebbero fornire un incremento temporaneo di:

* Hype;
* visibilità;
* reputazione locale;
* interesse verso il concerto.

Dovrebbero però consumare una parte della giornata e, potenzialmente, Energia.

Il giocatore dovrebbe quindi decidere se sfruttare la mattina per promuovere il concerto oppure conservarla per il riposo e la preparazione della performance.

## Principio di Design

Una tournée dovrebbe essere percepita come una **campagna completa**, non come una semplice lista di concerti.

Il giocatore deve poter costruire una strategia:

> **Pianifico le date → organizzo gli spostamenti → gestisco le energie → suono → aumento l'Hype → affronto la tappa successiva.**

Il sistema collega quindi direttamente:

**Geografia + Logistica + Concerti + Calendario + Risorse + Hype**

creando uno dei principali sistemi di progressione della carriera avanzata.

-----------------------------------------------------------------------------------------------------------------------------

## Stato di Implementazione & Convalida (V4.6.0)
- **Stato**: [x] [COMPLETATO E CONVALIDATO AL 100%]
- **Piano di Riferimento**: [`docs/piani/completati/PIANO_SEZIONE_6_GEOGRAFIA_METROPOLI_E_TOURNEE.md`](../piani/completati/PIANO_SEZIONE_6_GEOGRAFIA_METROPOLI_E_TOURNEE.md)
- **Suite di Test Headless**: 23/23 suite a 0 errori (`test_tour_system.gd` con 98 test, `test_travel_system.gd` con 64 test).
- **Data Convalida & Release AVF**: 2026-09-24 — Versione AVF `V4.6.0`.
### 6.4 Gestione della Stanchezza On the Road & Imprevisti di Viaggio
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Calcolo della fatica cumulativa della band lungo le tappe consecutive.
  - Aumento della tensione interna tra i membri se il veicolo è angusto e si viaggia per giorni senza riposo.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Eventi narrativi casuali di viaggio: Foratura gomma in autostrada sotto la pioggia, sosta in autogrill alle tre di notte con incontri bizzarri, motel economico con aria condizionata rotta o stanze infestate, smarrimento del percorso senza navigatore.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
    # 6.4 Gestione della Stanchezza On the Road & Imprevisti di Viaggio

La vita in tournée introduce una nuova dimensione gestionale: la **fatica cumulativa**.

Una singola trasferta può essere facilmente sostenibile, ma una sequenza di concerti e viaggi ravvicinati può progressivamente mettere sotto pressione l'intera band.

Il sistema deve quindi rappresentare il principio secondo cui:

> **Una tournée non stanca solamente durante il concerto: anche viaggiare, dormire male e stare continuamente in movimento ha un costo.**

## Dettagli Tecnici & Meccaniche Già Implementate

### Fatica Cumulativa della Band

Il sistema calcola la fatica accumulata dalla band lungo le tappe consecutive della tournée.

La stanchezza non viene quindi considerata esclusivamente come conseguenza dell'ultima attività effettuata, ma come un fenomeno **cumulativo**.

Una sequenza del tipo:

**Concerto → viaggio → concerto → viaggio → concerto**

può portare progressivamente la band in condizioni peggiori rispetto a una tournée caratterizzata da intervalli di recupero.

La fatica può interagire con i sistemi già esistenti relativi a:

* Energia;
* Stress;
* Morale;
* Tensione della band;
* qualità delle performance;
* necessità di riposo.

Questo rende particolarmente importante la pianificazione delle date e dei trasferimenti.

### Spazi Ristretti e Tensione Interna

Il comfort del mezzo di trasporto influenza anche i rapporti tra i membri.

Quando la band:

* viaggia per molti giorni consecutivi;
* utilizza un veicolo angusto;
* non dispone di giornate di riposo;
* accumula stanchezza;

la **Tensione Interna** può aumentare.

Questo crea una connessione diretta con il sistema psicologico della band già definito nelle sezioni precedenti.

Un viaggio particolarmente lungo può quindi trasformarsi in un problema non solo fisico, ma anche relazionale.

### Interazione con il Tipo di Veicolo

Il sistema si integra naturalmente con le tre categorie di veicolo definite nel 6.2:

| Veicolo           | Impatto sulla tournée                                             |
| ----------------- | ----------------------------------------------------------------- |
| Furgone Scassato  | Maggiore stress e maggiore esposizione agli imprevisti            |
| Van Professionale | Compromesso tra costi e comfort                                   |
| Tour Bus di Lusso | Comfort elevato e possibilità di recupero durante gli spostamenti |

La scelta del mezzo assume quindi un valore strategico anche sulla durata della tournée.

Un mezzo economico può essere sufficiente per poche date locali, mentre una tournée lunga può rendere molto più importante il comfort degli spostamenti.

## Direttrici di Espansione & Idee di Gameplay

### Eventi Narrativi Casuali di Viaggio

Una possibile evoluzione del sistema consiste nell'introduzione di **eventi casuali durante gli spostamenti**.

Gli eventi dovrebbero essere brevi episodi narrativi che interrompono temporaneamente il normale flusso della tournée.

L'obiettivo non è semplicemente punire il giocatore, ma trasformare i viaggi in momenti imprevedibili della vita della band.

### Foratura in Autostrada sotto la Pioggia

La band sta viaggiando verso la prossima città quando una gomma si fora durante un temporale.

Possibili conseguenze:

* ritardo nell'arrivo;
* aumento dello Stress;
* costo per la riparazione;
* rischio di arrivare tardi al soundcheck;
* eventuale necessità di modificare il programma della giornata.

Il giocatore potrebbe trovarsi davanti a una scelta:

**pagare subito un servizio di assistenza → costo maggiore, tempo risparmiato**

oppure:

**tentare una soluzione economica → meno denaro speso, maggiore rischio di ritardo.**

### Autogrill alle Tre di Notte

Durante un trasferimento notturno la band decide di fermarsi in un autogrill alle 03:00.

Potrebbero verificarsi piccoli eventi narrativi:

* incontro con un fan;
* incontro con un altro musicista;
* situazione comica;
* discussione tra membri della band;
* acquisto imprevisto;
* occasione per recuperare leggermente il morale.

L'evento potrebbe quindi avere conseguenze positive, negative o semplicemente narrative.

### Motel Economico

La band decide di risparmiare scegliendo un motel economico.

Possibili situazioni:

* aria condizionata rotta;
* camere rumorose;
* letti scomodi;
* servizio pessimo;
* stanza sorprendentemente migliore del previsto;
* incontro con personaggi particolari.

La qualità dell'alloggio potrebbe influenzare direttamente il recupero durante la notte.

Questo permetterebbe di collegare il sistema di viaggio a quello già esistente di **Energia, Stress e Morale**.

### Motel "Misterioso"

Versione più ironica dell'evento precedente.

La band arriva in un motel economico e qualcosa non torna.

Possibili sviluppi:

* rumori durante la notte;
* televisione che si accende da sola;
* membro della band convinto che la stanza sia infestata;
* fuga notturna dalla camera;
* morale che sale per la situazione assurda oppure crolla per la notte insonne.

L'evento può rimanere prevalentemente narrativo, evitando di trasformare il gioco in un horror.

### Smarrimento del Percorso

Il veicolo perde il percorso verso la destinazione.

Possibili cause:

* navigatore non disponibile;
* errore di percorso;
* deviazione stradale;
* segnale GPS assente;
* scelta sbagliata dell'autista.

Possibili conseguenze:

* aumento del tempo di viaggio;
* maggiore consumo di Energia;
* aumento dello Stress;
* arrivo in ritardo;
* costo logistico aggiuntivo.

Un evento di questo tipo potrebbe essere particolarmente interessante durante le prime fasi della carriera, quando la band utilizza mezzi economici e dispone di meno risorse.

## Sistema di Scelte negli Imprevisti

Gli eventi futuri potrebbero utilizzare una struttura a scelta multipla.

Esempio:

> **03:17 — Foratura sulla strada per Berlino**
>
> La gomma del van è completamente a terra e il prossimo concerto è domani sera.
>
> **A.** Chiami l'assistenza → -150 €, tempo di attesa ridotto.
>
> **B.** Provate a ripararla da soli → nessun costo, ma rischio di perdere tempo.
>
> **C.** Cercate un'officina → costo variabile, possibile deviazione.

La conseguenza non dovrebbe essere sempre immediatamente evidente.

In questo modo gli imprevisti diventano piccole decisioni gestionali invece di semplici finestre che applicano automaticamente una penalità.

## Principio di Design

Gli imprevisti devono creare **storie**, non solamente punizioni.

Un buon evento di viaggio dovrebbe poter essere ricordato dal giocatore come:

> "Ti ricordi quella volta che stavamo andando a Londra e siamo rimasti bloccati sotto la pioggia per tre ore?"

La tournée dovrebbe quindi produrre anche una sorta di **memoria narrativa della carriera**, nella quale concerti, viaggi, problemi e situazioni assurde contribuiscono alla storia della band.



----------------------------------------------------------------------------------------------------------------------------

