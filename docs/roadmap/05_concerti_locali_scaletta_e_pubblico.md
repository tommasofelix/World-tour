# World-tour — Roadmap Modulare: Sezione 5

- File di origine: `docs/roadmap.md`
- Titolo: Concerti dal Vivo, Locali, Scaletta & Pubblico
- Priorità Operativa: P5 - Performance Live

---

## 5. CONCERTI DAL VIVO, LOCALI, SCALETTA & PUBBLICO

### 5.1 Il Circuito dei Locali: Dal Garage ai Club di Tendenza
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/venue_data.gd`.
  - Catalogo locali base:
    1. `venue_garage` (Garage / Cantina): Capienza 15 spettatori, affitto 0 €, requisiti 0, prezzo equo 0 €.
    2. `venue_pub` (Pub / Birreria di Periferia): Capienza 60 spettatori, affitto 50 €, requisiti popolarità 5.0, prezzo equo 5.0 €.
    3. `venue_small_club` (Piccolo Club Underground): Capienza 180 spettatori, affitto 250 €, requisiti popolarità 20.0, prezzo equo 12.0 €.
    4. `venue_trendy_club` (Club di Tendenza): Capienza 450 spettatori, affitto 700 €, requisiti popolarità 40.0, prezzo equo 22.0 €.
  - Locali dedicati presenti all'interno di ciascuna delle 6 città della rete geografica.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Centri Sociali / Spazi Occupati con pubblico underground molto partecipe ma poco incline a pagare biglietti cari.
  - Teatri d'Opera storici per concerti acustici raffinati con biglietti a prezzo premium.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
    # 5.1 Il Circuito dei Locali: Dal Garage ai Club di Tendenza

Il sistema dei locali rappresenta il primo vero percorso di crescita live dell'artista: il giocatore parte da ambienti estremamente piccoli e poco costosi e, aumentando popolarità, pubblico e capacità economica, può accedere progressivamente a venue più grandi e prestigiose.

L'obiettivo è rendere la carriera live una progressione concreta: **non basta avere una buona canzone, bisogna essere abbastanza conosciuti da riempire il locale giusto e sostenere economicamente il concerto**.

## Dettagli Tecnici & Meccaniche Già Implementate

### Modello Dati

Il sistema dei locali è definito attraverso:

* `data/models/venue_data.gd`

Ogni venue contiene i parametri necessari per determinare la propria accessibilità e sostenibilità economica, tra cui:

* capacità massima;
* costo di affitto;
* requisiti di popolarità;
* prezzo equo del biglietto;
* identificativo univoco;
* collegamento alla rete geografica delle città.

### Catalogo Base delle Venue

| ID                  | Locale                      | Capienza | Affitto | Popolarità richiesta | Prezzo equo |
| ------------------- | --------------------------- | -------: | ------: | -------------------: | ----------: |
| `venue_garage`      | Garage / Cantina            |       15 |     0 € |                    0 |         0 € |
| `venue_pub`         | Pub / Birreria di Periferia |       60 |    50 € |                  5.0 |         5 € |
| `venue_small_club`  | Piccolo Club Underground    |      180 |   250 € |                 20.0 |        12 € |
| `venue_trendy_club` | Club di Tendenza            |      450 |   700 € |                 40.0 |        22 € |

### Progressione della Carriera Live

Le venue costituiscono una progressione naturale:

**Garage → Pub → Piccolo Club → Club di Tendenza**

Il Garage rappresenta il punto di partenza assoluto: nessun requisito di popolarità e nessun costo di affitto, ma una capienza estremamente limitata.

Il Pub introduce invece il primo vero rischio economico: il concerto richiede un investimento, ma permette di raggiungere un pubblico più numeroso e iniziare a costruire una reputazione locale.

Il Piccolo Club Underground rappresenta il passaggio alla dimensione professionale, mentre il Club di Tendenza introduce un pubblico molto più ampio, costi significativamente maggiori e una maggiore aspettativa da parte degli spettatori.

### Rete Geografica

I locali sono distribuiti all'interno delle **6 città della rete geografica** del gioco.

Questo permette di separare due concetti:

* **tipo di venue** → dimensione, capacità e costo del locale;
* **posizione geografica** → città nella quale il concerto viene organizzato.

La crescita dell'artista può quindi avvenire sia aumentando la dimensione delle venue disponibili sia espandendosi progressivamente verso altre città.

## Direttrici di Espansione & Idee di Gameplay

### Centri Sociali / Spazi Occupati

Possibile categoria di venue alternativa ai locali commerciali.

Caratteristiche ipotizzate:

* pubblico prevalentemente underground;
* forte partecipazione emotiva;
* costi di accesso ridotti;
* maggiore tolleranza verso artisti emergenti;
* prezzo del biglietto generalmente basso;
* possibile incremento della reputazione all'interno di determinati ambienti musicali.

Potrebbero diventare particolarmente interessanti per artisti che puntano su generi o scene di nicchia.

### Teatri d'Opera Storici

Venue di fascia completamente diversa, pensata per eventi più raffinati e particolari.

Possibili caratteristiche:

* capienza medio-alta;
* affitto molto elevato;
* requisiti di popolarità elevati;
* biglietti premium;
* maggiore importanza della qualità musicale e della reputazione;
* possibilità di organizzare concerti acustici o performance speciali.

Un teatro potrebbe quindi non essere semplicemente una venue "più grande", ma rappresentare una tipologia completamente diversa di esperienza live.

## Principio di Design

La progressione delle venue dovrebbe evitare di trasformarsi in una semplice scala numerica.

L'obiettivo è creare **ambienti con identità differenti**, nei quali cambiano:

* pubblico;
* costi;
* prezzo sostenibile;
* aspettative;
* atmosfera;
* prestigio;
* rischio economico;
* possibilità di crescita della fanbase.

In questo modo il giocatore non sceglie solamente "il locale più grande disponibile", ma deve valutare quale venue sia realmente adatta alla fase della propria carriera.

----------------------------------------------------------------------------------------------------------------------


### 5.2 Preparazione Live: Soundcheck, Prezzo Biglietto & Scaletta
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo live: `systems/concert_system.gd` e modale `LiveConcert` (`ui/concert/live_concert.tscn`), tasto rapido HUD `L`.
  - Configurazione: Selezione locale, impostazione prezzo biglietto, soundcheck pre-concerto.
  - Selezione scaletta: Da 1 a 4 brani scelti tra le canzoni prodotte o rilasciate della band.
  - Moltiplicatori affluenza legati ai giorni della settimana (`Constants`):
    - Venerdì: +50% affluenza (`WEEKEND_FRIDAY_AUDIENCE_MULT` = 1.50).
    - Sabato: +100% affluenza (`WEEKEND_SATURDAY_AUDIENCE_MULT` = 2.00) e +50% conversione fan (`WEEKEND_SATURDAY_FAN_MULT` = 1.50).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Ordine drammaturgico della scaletta: Apripista esplosivo, momento intimo a metà concerto, gran finale.
  - Possibilità di suonare cover famose di altre band per scaldare il pubblico nei locali difficili.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
    # 5.2 Preparazione Live: Soundcheck, Prezzo Biglietto & Scaletta

Il sistema di preparazione live rappresenta il momento nel quale il giocatore costruisce concretamente il concerto prima dell'inizio della performance.

Non viene quindi simulato soltanto il risultato finale: il giocatore deve prendere alcune decisioni fondamentali riguardanti **venue, prezzo del biglietto, soundcheck e scaletta**.

Queste scelte influenzano direttamente l'esperienza del pubblico e l'economia dell'evento.

## Dettagli Tecnici & Meccaniche Già Implementate

### Modulo Live

Il sistema è gestito da:

* `systems/concert_system.gd`
* Modale `LiveConcert`:

  * `ui/concert/live_concert.tscn`
* Tasto rapido HUD:

  * `L`

Il flusso di preparazione permette di configurare il concerto prima dell'esecuzione.

### Selezione del Locale

Il giocatore deve innanzitutto scegliere la venue nella quale esibirsi.

La scelta determina i principali vincoli economici e logistici del concerto:

* capienza massima;
* costo di affitto;
* requisiti di popolarità;
* prezzo equo del biglietto;
* pubblico potenzialmente raggiungibile.

La venue diventa quindi uno dei principali elementi strategici della preparazione dell'evento.

### Prezzo del Biglietto

Il giocatore può impostare direttamente il prezzo del biglietto.

Il sistema utilizza il concetto di **prezzo equo** associato alla venue come riferimento.

Il prezzo scelto può quindi influenzare la capacità del concerto di convertire l'interesse del pubblico in presenze effettive.

Questo crea un compromesso naturale:

**prezzo basso → maggiore accessibilità**

**prezzo alto → maggiore ricavo potenziale per spettatore**

Il giocatore deve quindi trovare un prezzo compatibile con la propria popolarità e con il tipo di pubblico della venue.

### Soundcheck

Prima del concerto è previsto un **soundcheck pre-concerto**.

Il soundcheck rappresenta una fase tecnica separata dalla performance vera e propria e costituisce la preparazione dell'artista e della band all'evento.

In prospettiva, questo sistema può diventare uno dei punti nei quali le abilità tecniche, l'attrezzatura e la qualità della venue interagiscono maggiormente.

### Selezione della Scaletta

La scaletta può contenere:

**da 1 a 4 brani**

selezionati tra le canzoni prodotte o rilasciate dalla band.

Questo permette di costruire concerti brevi nelle prime fasi della carriera, aumentando progressivamente la varietà del repertorio disponibile.

La scelta dei brani può diventare successivamente un elemento strategico legato a:

* qualità delle canzoni;
* popolarità dei singoli;
* genere musicale;
* energia del brano;
* caratteristiche del pubblico;
* posizione del brano nella scaletta.

### Bonus del Giorno della Settimana

L'affluenza è influenzata dal giorno nel quale viene organizzato il concerto.

| Giorno                   |    Modificatore |
| ------------------------ | --------------: |
| Venerdì                  |  +50% affluenza |
| Sabato                   | +100% affluenza |
| Sabato – conversione fan |            +50% |

Costanti implementate:

* `WEEKEND_FRIDAY_AUDIENCE_MULT = 1.50`
* `WEEKEND_SATURDAY_AUDIENCE_MULT = 2.00`
* `WEEKEND_SATURDAY_FAN_MULT = 1.50`

Il sabato rappresenta quindi una finestra particolarmente importante per gli eventi live, mentre il venerdì costituisce un incremento intermedio.

## Direttrici di Espansione & Idee di Gameplay

### Ordine Drammaturgico della Scaletta

La scaletta potrebbe diventare un vero strumento di progettazione dello spettacolo.

Una possibile struttura:

**1. Apripista esplosivo**
Un brano energico per catturare immediatamente l'attenzione.

**2. Parte centrale**
Brani che mantengono il coinvolgimento del pubblico.

**3. Momento intimo**
Ballad, brano acustico o canzone emotiva per modificare il ritmo dello spettacolo.

**4. Gran Finale**
Il brano più conosciuto o spettacolare della serata.

Questo permetterebbe di introdurre in futuro un concetto di **flow della scaletta**, nel quale l'ordine dei brani può avere un effetto sulla performance complessiva.

### Cover di Artisti Famosi

Una possibile meccanica futura è permettere alla band di eseguire **cover di brani famosi di altri artisti**.

Le cover potrebbero essere particolarmente utili nei locali difficili o durante le prime fasi della carriera, quando il repertorio originale del giocatore è ancora limitato.

Possibili caratteristiche:

* maggiore riconoscibilità immediata;
* aumento dell'interesse del pubblico;
* possibilità di utilizzare una cover come "brano sicuro";
* minore contributo alla costruzione dell'identità artistica originale;
* eventuali costi o limitazioni legati ai diritti.

La cover non dovrebbe necessariamente essere sempre superiore a un brano originale: il suo valore potrebbe dipendere dal contesto, dal pubblico e dalla notorietà della canzone.

## Principio di Design

La preparazione del concerto dovrebbe diventare una fase decisionale vera e propria.

Il giocatore dovrebbe arrivare alla performance avendo risposto a quattro domande:

> **Dove suono?**
> **Quanto faccio pagare?**
> **Come preparo il live?**
> **Quali canzoni porto sul palco?**

In questo modo il concerto non viene trattato come una semplice azione "clicca e aspetta", ma come un piccolo evento da organizzare.

------------------------------------------------------------------------------------------------------------------------


### 5.3 Motore del Concerto: Stage Events Procedurali & Bivi
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Algoritmo di affluenza calcolato su: Popolarità, prezzo rispetto al prezzo equo del locale, giorno della settimana e moltiplicatore `social_buzz`.
  - Calcolo del Concert Score in `core/formulas.gd`:
    - Presenza scenica (30%), Carisma (25%), Qualità media brani in scaletta (25%), Energia residua (10%), Variazione casuale (+/- 5.0).
  - Eventi di palco procedurali (`Enums.StageEventType`):
    - `BROKEN_STRING` (Corda spezzata): Bivio tra cambiare chitarra al volo o improvvisare col carisma.
    - `AUDIO_FEEDBACK` (Fischio monitor): Bivio tra sfuriata col fonico o battuta simpatica al microfono.
    - `ENTHUSIASTIC_FAN` (Fan che invade il palco): Bivio tra abbraccio/duetto scenico o chiamata della sicurezza.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Nuovi imprevisti: Blackout elettrico a metà ritornello, cori da stadio spontanei della folla, rissa tra il pubblico che minaccia di interrompere lo show, stage diving / crowd surfing riuscito o disastroso.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 5.4 Chiusura Show (Closer Bonus), Merchandising & Conversione Fan
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Closer Bonus: Se l'ultimo brano in scaletta possiede il tratto `STAGE_BEAST`, scatta un bonus immediato del +15% sul punteggio finale del concerto.
  - Formula conversione fan esponenziale: `Formulas.calculate_fan_conversion = base_conversion * ((concert_score / 50.0) ^ 2.2)`. Se presente un brano con tratto `CULT_CLASSIC`, la conversione raddoppia (x2.0).
  - Ripartizione territoriale: I fan conquistati vengono assegnati per l'85% alla città in cui si è tenuto il concerto e per il 15% come riverbero nazionale/globale.
  - Incasso sbigliettamento: Biglietti venduti per prezzo, al netto del costo di affitto del locale, spartito con la band secondo il `RevenueSplit`.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Banchetto del merchandising allestito nel foyer (scelta dei prodotti da stampare: magliette, cappellini, adesivi, poster autografati, plettri personalizzati).
  - Momento bis / encore richiesto a gran voce dal pubblico se il punteggio del concerto supera 85 punti.
- **Spazio per i Dettagli di Luca**:
  - Disponibilità e Calendario delle Venue

Prima di confermare un concerto, il sistema deve verificare se il locale è disponibile nella data selezionata.

Ogni venue dispone di un proprio calendario degli eventi, nel quale possono essere presenti:

concerti di altri artisti;
eventi speciali;
serate tematiche;
manutenzione o chiusure temporanee;
appuntamenti già prenotati dalla band.

Il locale può quindi trovarsi in uno dei seguenti stati:

Libero → la prenotazione può essere effettuata;
Prenotato → la data è già occupata da un altro evento;
Chiuso → il locale non è disponibile per motivi organizzativi;
In attesa di conferma → la richiesta del giocatore non è ancora stata finalizzata.

Nel calendario della venue il giocatore dovrebbe poter visualizzare chiaramente le date disponibili e quelle già occupate. Una data non disponibile non deve poter essere selezionata oppure deve mostrare un messaggio esplicativo, ad esempio:

“Questo locale è già occupato da un altro appuntamento.”

La disponibilità dovrebbe essere verificata nuovamente al momento della conferma definitiva, così da evitare sovrapposizioni nel caso in cui più eventi vengano programmati nello stesso periodo.

Questa meccanica introduce un ulteriore elemento strategico: i locali più prestigiosi potrebbero avere calendari molto più affollati, costringendo il giocatore a prenotare con maggiore anticipo o ad accettare date meno favorevoli.

Inoltre, le date più richieste, come il venerdì e soprattutto il sabato, potrebbero essere occupate più rapidamente oppure avere costi di affitto maggiori.

La scelta della venue diventa quindi legata non solo alla capienza e al prestigio, ma anche alla reale possibilità di trovare uno spazio libero nel momento desiderato.

---

