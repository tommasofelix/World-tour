# World-tour — Roadmap Modulare: Sezione 7

- File di origine: `docs/roadmap.md`
- Titolo: Grandi Festival Estivi all'Aperto
- Priorità Operativa: P7 - Eventi Speciali

---

## 7. GRANDI FESTIVAL ESTIVI ALL'APERTO

### 7.1 Stagione Estiva dei Festival (Mesi 4-6) & Cartelloni
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/festival_event.gd`.
  - Modulo festival: `systems/festival_system.gd` e modale `FestivalModal` (`ui/festival/festival_modal.tscn`), tasto rapido HUD `F`.
  - Stagione estiva rigorosa: Attiva durante i mesi estivi (Mesi 4, 5 e 6 / Giorni dall'85 al 168 del calendario).
  - Cartelloni ufficiali organizzati nelle 6 metropoli europee con date fisse, requisiti minimi di reputazione e cachet garantito.
  - Influenza del Manager: Se si dispone di un manager professionista o squalo, i requisiti di accesso vengono abbattuti e il cachet garantito aumenta sensibilmente.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Grandi festival tematici leggendari (es. Download Fest per il Metal, Glastonbury / Primavera Sound per l'Indie, Love Parade / Awakenings per l'Elettronica).
  - Contest per band emergenti ("Battle of the Bands") in primavera per conquistare l'accesso ai festival estivi.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
    # 7.1 Stagione Estiva dei Festival (Mesi 4-6) & Cartelloni

La stagione dei festival rappresenta uno dei principali appuntamenti annuali della carriera musicale.

A differenza dei normali concerti organizzati nelle venue, i festival sono **eventi stagionali con date prestabilite**, cartelloni ufficiali e requisiti di accesso.

La partecipazione a un festival permette all'artista di entrare in contatto con un pubblico molto più ampio e di aumentare rapidamente la propria esposizione.

Il sistema introduce inoltre una componente importante di pianificazione: **essere abbastanza famosi non significa necessariamente essere disponibili per il festival giusto, nella città giusta e nella data giusta.**

## Dettagli Tecnici & Meccaniche Già Implementate

### Modello Dati

Le informazioni relative ai festival sono definite attraverso:

* `data/models/festival_event.gd`

Il modello contiene i dati necessari per rappresentare gli eventi stagionali, tra cui:

* identificativo del festival;
* città;
* data;
* requisiti di reputazione;
* cachet garantito;
* informazioni relative al cartellone.

### Modulo Festival

La gestione degli eventi è affidata a:

* `systems/festival_system.gd`
* Modale `FestivalModal`:

  * `ui/festival/festival_modal.tscn`
* Tasto rapido HUD:

  * `F`

Il modulo permette di visualizzare e gestire gli appuntamenti disponibili durante la stagione festivaliera.

## Stagione Estiva

La stagione dei festival è rigidamente collegata al calendario di gioco.

È attiva durante:

**Mese 4 → Mese 5 → Mese 6**

corrispondenti all'intervallo:

**Giorno 85 → Giorno 168**

Al di fuori di questo periodo i festival estivi non sono disponibili.

Questo introduce una componente temporale importante: il giocatore deve arrivare alla stagione estiva con una carriera sufficientemente sviluppata per poter sfruttare le opportunità disponibili.

## Cartelloni Ufficiali

I festival sono organizzati all'interno delle **6 metropoli europee** della rete geografica.

Ogni evento possiede un proprio cartellone ufficiale e una data prestabilita.

Il giocatore può quindi consultare:

* nome del festival;
* città;
* data;
* requisito minimo di reputazione;
* cachet garantito;
* eventuali informazioni sul cartellone.

La presenza di date fisse impedisce di trattare il festival come una normale venue prenotabile liberamente.

Il giocatore deve invece **pianificare la propria carriera attorno agli appuntamenti stagionali**.

## Requisiti di Accesso

Ogni festival possiede un requisito minimo di reputazione.

Questo permette di creare una progressione naturale:

**artista emergente → piccoli eventi → festival locali → festival importanti → grandi festival internazionali**

Il requisito impedisce inoltre che un artista appena iniziato possa accedere immediatamente agli eventi più prestigiosi.

## Cachet Garantito

La partecipazione a un festival prevede un **cachet garantito**.

Questo differenzia il sistema dai normali concerti, nei quali il risultato economico dipende maggiormente da:

* affluenza;
* prezzo del biglietto;
* capienza;
* costi della venue;
* performance.

Nel festival il giocatore conosce invece anticipatamente il compenso previsto per la partecipazione.

Il cachet diventa quindi un elemento importante nella pianificazione economica della stagione.

## Influenza del Manager

La presenza di un manager professionista o di livello elevato modifica le condizioni di accesso ai festival.

In particolare, il manager può:

* ridurre i requisiti di accesso;
* aumentare sensibilmente il cachet garantito;
* facilitare l'ingresso dell'artista nei cartelloni più importanti.

Questo rende il sistema dei manager direttamente collegato alla progressione della carriera.

Un artista senza manager deve quindi costruire maggiormente la propria reputazione prima di poter accedere agli eventi più prestigiosi, mentre un manager con buoni contatti può facilitare l'accesso a opportunità professionali.

## Direttrici di Espansione & Idee di Gameplay

### Grandi Festival Tematici

Il sistema può essere ampliato introducendo festival specializzati per genere musicale.

Esempi:

* **Download Fest** → Metal / Hard Rock
* **Glastonbury / Primavera Sound** → Indie / Alternative
* **Love Parade / Awakenings** → Elettronica

I festival tematici potrebbero utilizzare le affinità musicali delle città già definite nel sistema geografico.

Un festival elettronico a Berlino, ad esempio, potrebbe rappresentare un'opportunità particolarmente interessante per un artista orientato verso quel genere.

### Festival come Vetrina Internazionale

I grandi festival potrebbero avere un'importanza superiore al semplice compenso economico.

La partecipazione potrebbe aumentare:

* reputazione;
* fan;
* visibilità internazionale;
* opportunità professionali;
* probabilità di ricevere nuove proposte;
* interesse di manager, produttori e organizzatori.

In questo modo il giocatore potrebbe decidere di accettare un festival anche quando il compenso immediato non è il principale vantaggio.

### Battle of the Bands

Durante la primavera potrebbe essere introdotto un sistema di contest dedicato alle band emergenti.

Il principio:

**Contest primaverile → vittoria/risultato positivo → accesso o candidatura a festival estivi**

Le competizioni potrebbero prevedere:

* esibizione live;
* valutazione della giuria;
* risposta del pubblico;
* confronto con altre band;
* premi;
* possibilità di ottenere uno slot nel cartellone estivo.

Questo creerebbe un vero percorso stagionale:

**Primavera → Contest → Qualificazione → Estate → Festival**

### Slot del Cartellone

Una possibile evoluzione consiste nell'introduzione di diversi livelli all'interno dello stesso festival:

* Opening Act;
* Emerging Artist;
* Main Stage;
* Special Guest;
* Headliner.

Il livello dello slot potrebbe dipendere da:

* reputazione;
* popolarità;
* genere;
* performance precedenti;
* rapporti con il management;
* risultati ottenuti nei festival precedenti.

Questo permetterebbe di trasformare la partecipazione al festival in un percorso di crescita interno allo stesso evento.

## Principio di Design

La stagione dei festival dovrebbe funzionare come un **appuntamento annuale della carriera**.

Il giocatore dovrebbe arrivare alla primavera pensando:

> **"Come preparo la mia carriera per l'estate?"**

Durante i mesi precedenti può:

* aumentare la reputazione;
* migliorare le proprie abilità;
* pubblicare nuova musica;
* organizzare concerti;
* costruire una tournée;
* migliorare la band;
* trovare un manager.

Quando arriva la stagione estiva, tutte queste attività possono tradursi in nuove opportunità.

Il festival diventa quindi il punto di convergenza di numerosi sistemi del gioco:

**Reputazione + Musica + Band + Manager + Geografia + Calendario + Economia + Live Performance**
-----------------------------------------------------------------------------------------------------------------------------


### 7.2 I 3 Slot Orari di Esibizione: Apertura, Tramonto, Headliner
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - I 3 Slot orari (`Enums.FestivalSlot`):
    1. `OPENING_AFTERNOON` (Slot Pomeridiano di Apertura): Ore 15:00 - 17:00. Sole cocente, pubblico ancora scarso e dispersivo, serve grande fatica per scaldare la folla.
    2. `SUNSET_SLOT` (Slot al Tramonto / Golden Hour): Ore 18:30 - 20:30. Atmosfera magica, folla stipata, ottima visibilità e cachet raddoppiato.
    3. `HEADLINER_NIGHT` (Headliner Notturno): Ore 22:00 - 00:00. Il palco principale, massimo prestigio, folla oceanica, giochi di luce spettacolari e cachet faraonico.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Palchi secondari / Tende underground dove il pubblico è più ristretto ma estremamente appassionato.
  - Conflitto di orari con una band leggendaria che suona contemporaneamente su un altro palco.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
    # 7.2 I 3 Slot Orari di Esibizione: Apertura, Tramonto, Headliner

All'interno di un festival, non tutte le esibizioni hanno lo stesso peso.

L'orario assegnato all'artista determina il contesto nel quale avviene la performance: quantità di pubblico presente, atmosfera, prestigio dello slot e compenso economico.

Il sistema introduce quindi tre fasce orarie principali, ciascuna con una propria identità.

## Dettagli Tecnici & Meccaniche Già Implementate

Gli slot sono definiti attraverso:

`Enums.FestivalSlot`

Sono disponibili tre fasce principali.

### 1. `OPENING_AFTERNOON` — Slot Pomeridiano di Apertura

**Orario:**

**15:00 – 17:00**

È il primo slot della giornata.

Caratteristiche:

* sole ancora molto forte;
* pubblico inizialmente ridotto;
* spettatori maggiormente dispersi nell'area del festival;
* minore prestigio rispetto agli slot successivi;
* maggiore difficoltà nel creare immediatamente coinvolgimento.

L'artista che apre il festival deve quindi lavorare maggiormente per attirare l'attenzione e iniziare a costruire l'atmosfera della giornata.

È lo slot ideale per:

* artisti emergenti;
* band che devono ancora costruire una reputazione;
* nuove proposte;
* gruppi che vogliono farsi conoscere dal pubblico del festival.

### 2. `SUNSET_SLOT` — Slot al Tramonto / Golden Hour

**Orario:**

**18:30 – 20:30**

È la fascia del tramonto e rappresenta un importante salto di prestigio.

Caratteristiche:

* atmosfera particolarmente favorevole;
* pubblico molto più numeroso;
* area del festival maggiormente affollata;
* ottima visibilità;
* condizioni sceniche più spettacolari;
* **cachet raddoppiato**.

Il Sunset Slot rappresenta quindi un punto intermedio tra artista emergente e grande nome del festival.

### 3. `HEADLINER_NIGHT` — Headliner Notturno

**Orario:**

**22:00 – 00:00**

È lo slot principale del festival.

Caratteristiche:

* palco principale;
* massimo prestigio;
* folla oceanica;
* spettacolo di luci;
* massima visibilità;
* **cachet faraonico**.

L'Headliner Night rappresenta uno degli obiettivi principali della progressione festivaliera.

Ottenere questo slot significa essere considerati uno degli artisti centrali del cartellone.

## Tabella Riassuntiva

| Slot              | Orario      | Pubblico          | Prestigio | Cachet    |
| ----------------- | ----------- | ----------------- | --------- | --------- |
| Opening Afternoon | 15:00–17:00 | Scarso/dispersivo | Basso     | Base      |
| Sunset Slot       | 18:30–20:30 | Elevato           | Alto      | 2×        |
| Headliner Night   | 22:00–00:00 | Oceanico          | Massimo   | Faraonico |

## Direttrici di Espansione & Idee di Gameplay

### Palchi Secondari e Tende Underground

Oltre al palco principale potrebbero essere presenti:

* piccoli palchi secondari;
* tende underground;
* aree acustiche;
* stage dedicati a generi specifici.

Questi ambienti potrebbero avere un pubblico numericamente inferiore ma estremamente appassionato.

Potrebbero quindi essere particolarmente adatti a:

* generi di nicchia;
* artisti sperimentali;
* band emergenti;
* performance alternative.

Il numero di spettatori non sarebbe quindi l'unico indicatore del valore di uno slot.

### Conflitto di Orari

Un'evoluzione interessante sarebbe introdurre la possibilità che due artisti si esibiscano contemporaneamente su palchi differenti.

Esempio:

> **22:00 — Main Stage:** Alex & Band
> **22:00 — Underground Stage:** Band Leggendaria

Il giocatore potrebbe quindi trovarsi davanti a un problema: una parte del pubblico deve scegliere quale spettacolo vedere.

Questo potrebbe influenzare:

* affluenza;
* conversione dei fan;
* visibilità;
* difficoltà nel "rubare la scena";
* prestigio percepito della performance.

## Principio di Design

Lo slot non dovrebbe essere solamente un valore numerico.

La domanda dovrebbe essere:

> **"Quando voglio che il pubblico mi veda?"**

Un Opening Slot può offrire l'occasione di sorprendere il pubblico partendo dal basso.

Un Sunset Slot può trasformare la performance in uno dei momenti centrali della giornata.

Un Headliner Slot rappresenta invece il momento nel quale l'artista deve dimostrare di essere pronto per il massimo livello.

## Spazio per i Dettagli di Luca

-----------------------------------------------------------------------------------------------------------------------------


### 7.3 Meccanica Competitiva "Rubare la Scena" (*Steal the Show*)
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Algoritmo di confronto diretto: La performance di Alex e compagni viene confrontata con le band rivali presenti sullo stesso cartellone del festival.
  - Se il punteggio del concerto supera le aspettative di oltre il 20%, scatta l'evento "Hai Rubato la Scena!":
    - Bonus immediato del +30% sui nuovi fan convertiti.
    - Balzo straordinario della reputazione nazionale.
    - Impennata del morale al 100% per tutta la band.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Mosse sceniche estreme per rubare la scena (es. arrampicarsi sulle impalcature del palco, assolo di chitarra in mezzo alla folla, duetto improvvisato con un ospite illustre).
  - Reazioni invidiose delle band rivali nel backstage dopo lo show.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 7.4 Moltiplicatori Merchandising Intensivo & Sponsorizzazioni
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Moltiplicatore vendite merch intensivo: Data la presenza di migliaia di persone radunate nell'area festival, le entrate dalla vendita di magliette e gadget passano da x2.5 fino a x5.5 rispetto a un locale standard.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Stand di merchandising esclusivo con grafica creata appositamente per il festival.
  - Sponsorizzazioni di bibite energetiche, birre o marchi di streetwear che offrono bonus in denaro se la band cita il marchio o indossa i loro vestiti sul palco.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

-----------------------------------------------------------------------------------------------------------------------------

