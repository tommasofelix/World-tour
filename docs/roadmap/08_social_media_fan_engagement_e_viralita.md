# World-tour — Roadmap Modulare: Sezione 8

- File di origine: `docs/roadmap.md`
- Titolo: Social Media, Fan Engagement & Viralità (BandFeed)
- Priorità Operativa: P8 - Comunicazione & Buzz

---

## 8. SOCIAL MEDIA, FAN ENGAGEMENT & VIRALITÀ (BANDFEED)

### 8.1 Piattaforma Social BandFeed & 4 Tipologie di Post
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/social_post_data.gd`.
  - Modulo social: `systems/social_media_system.gd` e modale `SocialModal` (`ui/social/social_modal.tscn`), tasto rapido HUD `Y`.
  - Le 4 Tipologie di Contenuto (`Enums.SocialPostType`):
    1. `PRACTICE_CLIP` (Clip delle Prove): Video brevi di Alex e compagni mentre provano in sala. Alta credibilità musicale.
    2. `TRACK_TEASER` (Teaser di un Brano): Anteprima di 15 secondi di un singolo o disco in arrivo. Genera attesa e hype per il rilascio.
    3. `BEHIND_THE_SCENES` (Dietro le Quinte / Vita da Band): Scorci informali della vita in furgone, pause caffè e scherzi nel backstage. Aumenta l'affetto dei fan.
    4. `PROVOCATION` (Post Provocatorio / Meme): Meme ironico o presa di posizione tagliente contro il sistema o l'industria. Alto potenziale virale ma rischio shitstorm.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Dirette live streaming interattive dove rispondere alle domande dei fan in tempo reale.
  - Teaser con countdown prima dell'uscita di un video musicale ufficiale.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
    ## 8.1 Piattaforma Social BandFeed & 4 Tipologie di Post

### Obiettivo del Sistema

Il **BandFeed** rappresenta il social network interno al mondo di gioco attraverso cui Alex e la sua band possono costruire una presenza digitale, mantenere il rapporto con il pubblico e trasformare l'attività online in conseguenze concrete sulla carriera musicale.

Il sistema non deve essere interpretato come un semplice menu per ottenere bonus: l'attività social rappresenta una vera estensione della vita pubblica dell'artista. Un contenuto può aumentare l'affetto dei fan, creare aspettativa per una nuova uscita, aumentare l'affluenza a un concerto oppure, nel caso di contenuti provocatori, generare conseguenze negative.

---

### Implementazione Tecnica

Il sistema è strutturato attraverso:

* **Modello dati:** `data/models/social_post_data.gd`
* **Sistema principale:** `systems/social_media_system.gd`
* **Interfaccia:** `SocialModal` → `ui/social/social_modal.tscn`
* **Tasto rapido HUD:** `Y`

Il giocatore accede al BandFeed attraverso la relativa interfaccia e può scegliere quale tipologia di contenuto pubblicare.

La tipologia del post viene rappresentata tramite:

`Enums.SocialPostType`

---

### Le 4 Tipologie di Contenuto

#### 1. `PRACTICE_CLIP` — Clip delle Prove

Brevi video che mostrano Alex e i compagni durante le prove.

Esempi:

* estratto di un riff;
* prova di una parte vocale;
* sessione nella sala prove;
* breve jam della band;
* preparazione di una nuova canzone.

**Identità del contenuto:** autenticità e credibilità musicale.

Questo tipo di post comunica ai fan che la band sta realmente lavorando sulla propria musica e permette di mostrare progressi, tecnica e affiatamento senza necessariamente pubblicare materiale professionale.

---

#### 2. `TRACK_TEASER` — Teaser di un Brano

Anteprima di circa **15 secondi** relativa a un singolo o a un disco in arrivo.

Il teaser ha principalmente una funzione promozionale: permette di anticipare una nuova pubblicazione e creare aspettativa prima dell'uscita ufficiale.

Può essere utilizzato, ad esempio, per:

* anticipare un nuovo singolo;
* presentare un ritornello;
* mostrare un riff particolarmente riconoscibile;
* accompagnare una campagna promozionale;
* preparare il pubblico all'uscita di un album o EP.

Il principio fondamentale è trasformare il social network in un collegamento diretto tra **produzione musicale → promozione → pubblico → vendite/streaming**.

---

#### 3. `BEHIND_THE_SCENES` — Dietro le Quinte / Vita da Band

Contenuti informali legati alla quotidianità dell'artista e della band.

Esempi:

* vita nel furgone;
* pause caffè;
* scherzi tra i membri;
* backstage dei concerti;
* momenti durante i viaggi;
* preparazione prima di salire sul palco.

L'obiettivo è aumentare il rapporto personale tra band e pubblico.

A differenza del teaser musicale, questo contenuto non punta principalmente sulla promozione di una canzone, ma sulla costruzione dell'**affetto e della familiarità dei fan nei confronti della band**.

---

#### 4. `PROVOCATION` — Post Provocatorio / Meme

Contenuti ironici, meme oppure prese di posizione volutamente taglienti nei confronti del sistema musicale, dell'industria o di altri aspetti della scena.

È la tipologia con il maggiore potenziale di esposizione virale, ma introduce anche un rischio maggiore.

Possibili conseguenze:

* grande aumento della visibilità;
* forte crescita del `social_buzz`;
* acquisizione di nuovi follower;
* aumento dell'attenzione mediatica;
* reazioni negative;
* discussioni online;
* possibile **shitstorm**.

Il principio di design è quindi **alto rischio / alta esposizione**, evitando che la provocazione diventi automaticamente la strategia migliore.

---

### Collegamento con gli Altri Sistemi

Il BandFeed è progettato per interagire progressivamente con gli altri sistemi del gioco.

In particolare:

**Social → Follower → Fan locali → Affluenza ai concerti**

e:

**Social → Hype → `social_buzz` → Pubblico live**

Questo rende la presenza online una componente effettivamente integrata nella carriera dell'artista e non un sistema isolato.

---

### Direttrici di Espansione & Idee di Gameplay

#### Dirette Live Interattive

Introduzione di vere e proprie dirette streaming durante le quali il giocatore può:

* rispondere alle domande dei fan;
* parlare della band;
* presentare nuovi brani;
* mostrare il backstage;
* scegliere quali domande affrontare.

Le risposte potrebbero generare conseguenze diverse sulla reputazione, sull'affetto dei fan e sui rapporti interni alla band.

#### Countdown per le Uscite

Possibilità di creare una campagna social strutturata prima dell'uscita di:

* singoli;
* EP;
* album;
* videoclip ufficiali.

Il countdown potrebbe essere composto da più post distribuiti nei giorni precedenti al rilascio, trasformando la promozione in una piccola campagna narrativa.

--------------------------------------------------------------------------------------------------------------------------



### 8.2 Algoritmo di Visualizzazioni, Viralità & Conversione Follower
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Calcolo delle visualizzazioni: Funzione di Carisma, Popolarità attuale e base di follower preesistente.
  - Meccanica di viralità procedurale: Probabilità che un post esploda e raggiunga un pubblico 10x superiore alla norma.
  - Conversione follower in fan fisici: I follower digitali vengono convertiti in veri fan paganti legati alla città corrente (tramite `TravelSystem`), aumentando la penetrazione locale del gruppo.
  - Indicatore dinamico `social_buzz` [1.0x - 2.50x]: Moltiplicatore che incrementa l'affluenza di pubblico nei concerti live successivi.
  - Decadimento notturno: A mezzanotte in `EndDaySystem` il `social_buzz` decade fisiologicamente del 10%, richiedendo attività social costante per mantenere l'hype alto.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Campagne di sponsorizzazione a pagamento sui social (investire 100-500 € per spingere un post e raggiungere non-follower).
  - Algoritmi di tendenza che cambiano periodicamente (es. settimana in cui i video di assoli vanno più virali dei meme).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

## 8.2 Algoritmo di Visualizzazioni, Viralità & Conversione Follower

### Obiettivo del Sistema

Il sistema di BandFeed non considera tutti i post come equivalenti. Ogni contenuto viene sottoposto a un algoritmo che determina la quantità di pubblico raggiunta e la possibilità che il contenuto diventi virale.

L'obiettivo è creare una relazione diretta tra:

**Carisma + Popolarità + Follower → Visualizzazioni → Viralità → Nuovi follower → Fan locali → Affluenza ai concerti**

In questo modo la crescita sui social diventa una vera risorsa strategica della carriera.

---

### Calcolo delle Visualizzazioni

Il numero di visualizzazioni viene determinato combinando:

* **Carisma dell'artista**;
* **Popolarità attuale**;
* **base di follower già esistente**.

La logica permette quindi di rappresentare una crescita progressiva dell'audience:

> un artista sconosciuto parte da una base ridotta, mentre un artista già affermato dispone di un pubblico iniziale molto più grande.

Il Carisma contribuisce alla capacità del contenuto di attirare e mantenere l'attenzione, mentre la Popolarità rappresenta la notorietà generale raggiunta dall'artista.

---

### Meccanica di Viralità Procedurale

Ogni post può potenzialmente superare la propria normale portata attraverso un evento di viralità.

Il sistema determina proceduralmente la probabilità che un contenuto **“esploda”**, raggiungendo un pubblico molto superiore alla propria esposizione ordinaria.

In caso di viralità, il post può raggiungere un pubblico fino a circa **10× superiore alla norma**.

La viralità introduce quindi una componente di imprevedibilità:

**Post normale → crescita ordinaria**

**Post virale → forte espansione dell'audience**

Questo permette anche a un artista ancora relativamente piccolo di ottenere occasionalmente un'esposizione molto superiore alle proprie dimensioni attuali.

---

### Conversione dei Follower in Fan Reali

Il sistema non considera i follower esclusivamente come una statistica astratta.

Una parte dell'audience digitale viene convertita in **fan fisici**, collegati alla città nella quale l'artista si trova attualmente.

La conversione utilizza il `TravelSystem` per determinare la città corrente.

Esempio concettuale:

**Alex pubblica un post mentre si trova a Milano**

→ il post raggiunge nuovi utenti

→ una parte di questi diventa follower

→ una parte dei follower viene convertita in fan locali

→ aumenta la penetrazione della band a Milano

→ i concerti successivi a Milano possono beneficiare di una base di pubblico maggiore.

Questo crea un collegamento diretto tra **geografia, social network e mercato musicale locale**.

---

### `social_buzz` — Moltiplicatore di Hype

Il sistema utilizza l'indicatore dinamico:

`social_buzz`

Range:

**1.0× – 2.50×**

Questo valore rappresenta il livello di attenzione e fermento generato dalla presenza social della band.

Il `social_buzz` viene utilizzato come moltiplicatore per incrementare l'affluenza del pubblico nei concerti live successivi.

Di conseguenza:

**Attività social → Social Buzz → Pubblico potenziale del concerto**

Un'artista che mantiene una presenza digitale costante può quindi arrivare a un concerto con un livello di attenzione superiore rispetto a quello ottenibile esclusivamente attraverso la popolarità generale.

---

### Decadimento Notturno dell'Hype

Il `social_buzz` non è permanente.

Durante la chiusura giornaliera gestita da `EndDaySystem`, l'indicatore subisce un decadimento fisiologico del **10%**.

Formula concettuale:

`social_buzz_giorno_successivo = social_buzz × 0.90`

Questo impedisce di accumulare indefinitamente l'hype generato da un singolo post.

La conseguenza è una dinamica deliberatamente temporale:

**Pubblico → Post → Hype → Concerto**

ma anche:

**Nessuna nuova attività → Decadimento → Hype più basso**

Il giocatore deve quindi decidere quando utilizzare i social, soprattutto in prossimità di concerti, tour e nuove uscite.

---

### Relazione con il Calendario

Il decadimento del `social_buzz` rende il timing particolarmente importante.

Un post pubblicato immediatamente prima di un concerto può avere un valore strategico differente rispetto allo stesso post pubblicato molti giorni prima.

Questo permette di collegare il BandFeed a:

* calendario dei concerti;
* tour;
* festival;
* nuove uscite;
* campagne promozionali;
* spostamenti tra città.

Il social network diventa quindi una componente del **planning della carriera**, non semplicemente una fonte di bonus permanenti.

---

### Direttrici di Espansione & Idee di Gameplay

#### Campagne Social a Pagamento

Possibilità di investire denaro per aumentare artificialmente la distribuzione di un contenuto.

Budget ipotizzato:

**100€ – 500€**

L'investimento permetterebbe di raggiungere anche utenti che non seguono ancora la band.

Possibili decisioni future:

* quale post sponsorizzare;
* quanto investire;
* quale città o mercato targettizzare;
* promozione nazionale o internazionale;
* campagna breve oppure prolungata.

Questo introdurrebbe un collegamento diretto:

**Denaro → Marketing → Visibilità → Fan → Potenziale ritorno economico**

---

#### Algoritmi di Tendenza Variabili

Il comportamento dell'algoritmo potrebbe cambiare periodicamente.

Esempio:

* settimana A → i video di assoli ricevono maggiore esposizione;
* settimana B → i contenuti backstage sono favoriti;
* settimana C → i meme hanno maggiore probabilità di viralità;
* settimana D → i teaser musicali ottengono maggiore engagement.

Questo impedirebbe di trovare una singola strategia social sempre ottimale.

Il giocatore dovrebbe osservare il comportamento del pubblico e adattare la propria comunicazione.

---

### Possibili Evoluzioni Future

Una possibile evoluzione del sistema potrebbe introdurre una vera **economia dell'attenzione**, nella quale follower, engagement, viralità, popolarità e fan locali non siano semplicemente numeri indipendenti, ma elementi di una catena causale.

Schema futuro:

**Contenuto**

↓

**Visualizzazioni**

↓

**Engagement**

↓

**Follower**

↓

**Fan locali**

↓

**Social Buzz**

↓

**Affluenza ai concerti**

↓

**Incassi + Popolarità + Reputazione**

Questo permetterebbe al BandFeed di diventare uno dei principali ponti tra la dimensione digitale e quella fisica della carriera musicale.

----------------------------------------------------------------------------------------------------------------------------

### 8.3 Gestione delle Crisi Reputazionali & Shitstorm a 3 Bivi
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Quando un post provocatorio o un evento live finisce al centro di una bufera mediatica online, scatta l'interfaccia di crisi con 3 scelte strategiche:
    - Bivio 0 (`Ignora`): Si lascia sgonfiare la polemica senza intervenire. Impatto neutro, l'attenzione svanisce col tempo ma si perde un po' di carisma.
    - Bivio 1 (`Scuse Formali`): Comunicato stampa di scuse istituzionali. Recupera reputazione tra gli addetti ai lavori e rassicura la casa discografica, ma delude i fan punk/ribelli provocando un calo di morale.
    - Bivio 2 (`Raddoppia la Posta / Double Down`): Attacco frontale contro i critici. Esplosione di visualizzazioni virali e idolatria da parte della fanbase più estrema (+Fan e +Carisma), ma rischio di cancellazione date da parte dei gestori di club perbenisti (-Reputazione e cancellazione di un live).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Interventi del manager che cerca di strappare il telefono di mano ad Alex per impedirgli di twittare di notte.
  - Interviste tv di riparazione o speciali radiofonici dedicati al dibattito generato.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 
## 8.3 Gestione delle Crisi Reputazionali & Shitstorm a 3 Bivi

### Obiettivo del Sistema

Le attività social non sono prive di rischi. Un post provocatorio, una dichiarazione controversa oppure un evento avvenuto durante un concerto possono trasformarsi rapidamente in una **crisi reputazionale online**.

Quando la situazione supera una determinata soglia di attenzione, il gioco interrompe temporaneamente il normale flusso delle attività e presenta al giocatore una **Crisi Social**.

L'obiettivo non è introdurre una semplice penalità, ma creare una situazione decisionale nella quale ogni risposta produce conseguenze differenti.

Il sistema utilizza quindi una struttura a **3 bivi strategici**:

1. `Ignora`
2. `Scuse Formali`
3. `Double Down`

---

### Attivazione della Crisi

Una crisi può essere generata principalmente da:

* `PROVOCATION`, cioè un post provocatorio;
* eventi negativi collegati a un concerto;
* situazioni live che diventano oggetto di discussione online;
* eventi futuri collegati alla reputazione pubblica della band.

Quando viene attivata, viene mostrata una specifica interfaccia di crisi che comunica:

* origine della polemica;
* livello di attenzione generato;
* principali conseguenze potenziali;
* tre strategie disponibili.

La crisi diventa quindi una vera **decisione narrativa**, integrata con i sistemi Social, Reputazione, Fan, Morale e Concerti.

---

## I 3 Bivi della Crisi

### Bivio 0 — `Ignora`

Alex decide di non rispondere pubblicamente.

La strategia consiste nel lasciare che la polemica perda progressivamente attenzione senza alimentarla ulteriormente.

#### Conseguenze

* impatto immediato sostanzialmente neutro;
* la polemica si riduce progressivamente con il passare del tempo;
* nessun grande incremento di fan;
* nessun recupero reputazionale attivo;
* **leggera perdita di Carisma**.

La scelta rappresenta una strategia di contenimento passivo.

Il vantaggio è evitare di alimentare ulteriormente la crisi; lo svantaggio è rinunciare alla possibilità di controllare direttamente la narrativa pubblica.

---

### Bivio 1 — `Scuse Formali`

Alex pubblica un comunicato ufficiale nel quale riconosce la situazione e presenta delle scuse.

La comunicazione assume un tono istituzionale e professionale, con l'obiettivo di rassicurare gli operatori dell'industria musicale.

#### Conseguenze

* recupero della reputazione presso gli **addetti ai lavori**;
* maggiore rassicurazione nei confronti della casa discografica;
* riduzione della pressione professionale generata dalla crisi;
* **calo del Morale** della band;
* possibile delusione della componente più punk/ribelle della fanbase.

Questa scelta privilegia quindi la stabilità professionale rispetto alla componente più provocatoria dell'identità della band.

Il risultato è volutamente ambivalente: la crisi viene gestita in maniera più istituzionale, ma il giocatore paga questo approccio con una perdita di entusiasmo all'interno della propria fanbase più ribelle.

---

### Bivio 2 — `Raddoppia la Posta / Double Down`

Alex decide di non fare marcia indietro e risponde alla polemica con un ulteriore attacco frontale verso i critici.

La crisi viene trasformata in ulteriore spettacolo mediatico.

#### Conseguenze Positive

* forte incremento delle visualizzazioni;
* elevata probabilità di viralità;
* aumento dei fan;
* aumento del Carisma;
* rafforzamento del rapporto con la fanbase più estrema e provocatoria.

La band può quindi trasformare una crisi in una nuova ondata di attenzione.

#### Conseguenze Negative

La maggiore esposizione comporta però anche rischi concreti:

* perdita di Reputazione;
* peggioramento dei rapporti con alcuni operatori del settore;
* possibilità di cancellazione di una data;
* possibile cancellazione di un concerto da parte di un gestore di club particolarmente conservatore/perbenista.

Questa scelta dimostra quindi che **viralità e reputazione non sono necessariamente la stessa cosa**.

Un artista può diventare molto più famoso proprio mentre peggiora la propria posizione professionale.

---

## Tabella Riassuntiva

| Strategia       | Approccio              | Effetto principale                 | Rischio                                   |
| --------------- | ---------------------- | ---------------------------------- | ----------------------------------------- |
| `Ignora`        | Contenimento passivo   | La polemica si spegne nel tempo    | Perdita di Carisma                        |
| `Scuse Formali` | Gestione istituzionale | Recupero reputazione professionale | Calo Morale / delusione fan ribelli       |
| `Double Down`   | Contrattacco           | Viralità + Fan + Carisma           | Reputazione ↓ / possibile live cancellato |

La tabella non rappresenta una gerarchia di efficacia: le tre strategie sono progettate per sostenere **identità di carriera differenti**.

---

## Collegamento con gli Altri Sistemi

La crisi reputazionale è particolarmente importante perché può propagarsi attraverso più sistemi del gioco.

### Social Media

La crisi modifica:

* visualizzazioni;
* viralità;
* follower;
* `social_buzz`.

### Fan

La reazione dipende dalla natura della fanbase.

Una parte del pubblico può apprezzare l'atteggiamento ribelle, mentre un'altra può reagire negativamente.

### Reputazione

La reputazione professionale può diminuire anche quando il numero di fan aumenta.

Questo introduce una distinzione importante:

> **Essere più conosciuti non significa necessariamente essere più rispettati dall'industria.**

### Morale

Le conseguenze della crisi possono ripercuotersi anche sulla band, soprattutto quando la gestione della situazione genera forte pressione oppure contrasti sulla direzione artistica.

### Concerti

Nei casi più gravi, la crisi può avere conseguenze direttamente sul calendario:

**Shitstorm → pressione sui gestori → cancellazione di una data → modifica del programma live**

In questo modo un evento nato sui social può finire per modificare concretamente la carriera dell'artista.

---

## Direttrici di Espansione & Idee di Gameplay

### Manager vs Alex

Una possibile evoluzione consiste nell'introdurre il **Manager** come personaggio attivo durante le crisi.

Durante una situazione particolarmente delicata, il manager potrebbe cercare di impedire ad Alex di peggiorare ulteriormente la situazione.

Esempio narrativo:

> È notte fonda. Alex sta per pubblicare l'ennesimo post provocatorio. Il manager gli strappa praticamente il telefono di mano e gli dice di aspettare fino al mattino.

Il giocatore potrebbe quindi ricevere una nuova scelta:

* ascoltare il manager;
* ignorarlo;
* pubblicare comunque;
* modificare il messaggio.

Questo trasformerebbe il manager da semplice elemento economico/professionale a **figura realmente coinvolta nelle decisioni della carriera**.

---

### Interviste di Riparazione

Dopo una crisi potrebbe essere possibile organizzare un'intervista televisiva per tentare di recuperare la reputazione.

Possibili formati:

* intervista televisiva;
* conferenza stampa;
* podcast;
* speciale radiofonico;
* intervista con una rivista musicale.

La scelta del mezzo potrebbe modificare il pubblico raggiunto e il tipo di reputazione recuperata.

---

### Effetto "Ciclo della Polemica"

Una possibile evoluzione futura consiste nel permettere alla crisi di svilupparsi attraverso più fasi:

**Post controverso**

↓

**Prima reazione del pubblico**

↓

**Viralità**

↓

**Discussione mediatica**

↓

**Decisione di Alex**

↓

**Conseguenze**

↓

**Possibile seconda ondata**

Questo permetterebbe di trasformare una singola scelta social in un piccolo evento narrativo della carriera.

----------------------------------------------------------------------------------------------------------------------------

### 8.4 Fandom Territoriale vs Globale & Relazione con i Fan Club
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Tracciamento della fanbase diviso metropoli per metropoli e calcolo del totale nazionale/europeo.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Fondazione del Fan Club Ufficiale della band con elezione del presidente del fan club.
  - Raduni annuali con i fan e sessioni di autografi esclusive.
  - Lettere e regali bizzarri ricevuti dai fan più ossessivi via posta.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 
## 8.4 Fandom Territoriale vs Globale & Relazione con i Fan Club

### Obiettivo del Sistema

La popolarità di una band non viene considerata come un valore esclusivamente globale.

Il sistema distingue infatti tra **fanbase territoriale** e **fanbase complessiva**, permettendo di rappresentare una situazione molto comune nella carriera di un artista:

> una band può essere estremamente popolare in una determinata città o nazione, ma ancora relativamente sconosciuta nel resto del mondo.

Questa distinzione permette di collegare direttamente:

**Fan locali → Città → Nazione → Europa → Fandom globale**

alla progressione geografica della carriera.

---

### Implementazione Tecnica

La fanbase viene tracciata **metropoli per metropoli**.

Ogni città dispone quindi del proprio livello di seguito della band.

Il sistema può successivamente aggregare questi valori per ottenere livelli territoriali superiori:

* **Fanbase della singola città**
* **Fanbase nazionale**
* **Fanbase europea**
* **Fanbase globale**

Questa struttura permette di mantenere separati il successo locale e quello internazionale.

---

### Fandom Locale

Il valore associato alla singola metropoli rappresenta la presenza concreta della band sul territorio.

Può essere influenzato da diversi sistemi già presenti nel gioco:

* concerti effettuati nella città;
* successo dei concerti;
* attività social;
* `social_buzz`;
* viaggi;
* festival;
* eventi locali;
* permanenza prolungata dell'artista nella città;
* conversione dei follower digitali in fan fisici.

Esempio concettuale:

**Milano**

Fan locali: elevati

**Berlino**

Fan locali: bassi

**Londra**

Fan locali: medi

La band potrebbe quindi essere già una presenza importante in una determinata scena musicale senza avere ancora una fanbase internazionale equivalente.

---

### Aggregazione Nazionale ed Europea

I valori delle singole città possono essere aggregati per ottenere una visione più ampia.

Schema:

**Milano + Bologna + Roma + Napoli → Fandom italiano**

↓

**Italia + Londra + Berlino → Fandom europeo**

↓

**Europa + futuri mercati internazionali → Fandom globale**

Questa struttura diventa particolarmente importante quando il gioco introdurrà nuove città e continenti.

Un aumento della fanbase in una singola città non deve quindi tradursi automaticamente in un aumento identico della popolarità mondiale.

---

## Relazione tra Fandom e Geografia della Carriera

La distribuzione territoriale dei fan permette di creare situazioni differenti.

### Forte Fandom Locale

Una band potrebbe avere:

* molti fan a Milano;
* pochi fan nel resto d'Italia;
* pochissimi fan all'estero.

In questo caso la carriera potrebbe essere fortemente legata alla scena musicale locale.

### Fandom Nazionale

Dopo una serie di concerti, festival e campagne social, il seguito potrebbe espandersi:

**Milano → Bologna → Roma → Napoli → resto dell'Italia**

La band diventerebbe progressivamente riconoscibile a livello nazionale.

### Espansione Europea

Successivamente l'artista potrebbe sfruttare:

* tour europei;
* festival;
* social media;
* nuove uscite;
* collaborazioni;

per trasformare una fanbase nazionale in una vera presenza europea.

---

## Impatto sul Gameplay

La distinzione territoriale permette di rendere il sistema dei concerti più dinamico.

Una città con una fanbase molto sviluppata può offrire:

* maggiore pubblico potenziale;
* maggiore facilità nel riempire le venue;
* maggiore conversione dei follower;
* maggiore efficacia delle attività promozionali locali.

Al contrario, una città nella quale la band è quasi sconosciuta può richiedere:

* più concerti;
* maggiore promozione;
* investimenti social;
* tour;
* festival;
* campagne di marketing.

In questo modo il giocatore può scegliere tra due strategie molto diverse:

**Consolidare il proprio territorio**

oppure

**espandersi verso nuovi mercati.**

---

# Fan Club Ufficiale

### Direttrice di Espansione

Una futura evoluzione del sistema potrebbe introdurre il **Fan Club Ufficiale della Band**.

Il fan club rappresenterebbe una community organizzata di sostenitori particolarmente coinvolti nella carriera del gruppo.

La fondazione del fan club potrebbe diventare disponibile dopo aver raggiunto determinati requisiti di popolarità o numero di fan.

---

### Presidente del Fan Club

Il fan club potrebbe prevedere l'elezione di un **Presidente del Fan Club**.

Il presidente potrebbe diventare un vero e proprio personaggio secondario con:

* nome;
* personalità;
* città di provenienza;
* livello di fedeltà;
* influenza all'interno della community.

Nel tempo potrebbe diventare una figura ricorrente nella vita della band.

---

### Raduni Annuali

Il fan club potrebbe organizzare un grande **raduno annuale dei fan**.

Possibili attività:

* incontro con la band;
* esibizione esclusiva;
* sessione di domande e risposte;
* fotografie;
* autografi;
* anteprime di brani;
* merchandising esclusivo.

L'evento potrebbe richiedere tempo e denaro, ma aumentare significativamente il rapporto tra band e fan più fedeli.

---

### Sessioni di Autografi

Il sistema potrebbe introdurre eventi dedicati esclusivamente ai membri del fan club.

Esempi:

* firma di album;
* firma di poster;
* fotografie individuali;
* incontro backstage;
* ascolto anticipato di un nuovo brano.

Questi eventi potrebbero aumentare la **fedeltà dei fan** più che il semplice numero totale della fanbase.

---

# Fan Ossessivi & Eventi Narrativi

Una possibile componente più ironica del sistema riguarda le interazioni con i fan estremamente coinvolti.

Alex potrebbe ricevere per posta:

* lettere lunghissime;
* disegni;
* regali strani;
* oggetti completamente improbabili;
* lettere d'amore;
* richieste assurde;
* pacchi misteriosi.

Questi eventi potrebbero essere principalmente narrativi, ma occasionalmente generare conseguenze gameplay.

Ad esempio:

> "Hai ricevuto un pacco anonimo contenente una statua di 40 cm raffigurante Alex con una chitarra."

Il giocatore potrebbe decidere se:

* conservarla;
* regalarla;
* venderla;
* esporla nella propria casa;
* scoprire chi l'ha inviata.

Questo tipo di eventi contribuirebbe a dare personalità alla fanbase senza trasformare ogni interazione in una semplice modifica numerica.

---

## Evoluzione Futura del Sistema

Una possibile struttura completa potrebbe diventare:

**Follower digitali**

↓

**Fan locali**

↓

**Fan nazionali**

↓

**Fan europei**

↓

**Fan globali**

↓

**Fan Club**

↓

**Community organizzata**

↓

**Eventi esclusivi**

↓

**Fedeltà dei fan**

In questo modo la crescita dell'artista non sarebbe rappresentata soltanto dal numero totale di fan, ma anche dalla **profondità del rapporto con il pubblico**.

----------------------------------------------------------------------------------------------------------------------------

---

