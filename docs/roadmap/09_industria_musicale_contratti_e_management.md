# World-tour — Roadmap Modulare: Sezione 9

- File di origine: `docs/roadmap.md`
- Titolo: L'Industria Musicale, Contratti & Management
- Priorità Operativa: P9 - Business & Contratti

---

## 9. L'INDUSTRIA MUSICALE, CONTRATTI & MANAGEMENT

### 9.1 I 3 Modelli Produttivi: Autoproduzione, Indie, Major
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/contract_data.gd`.
  - Modulo industria: `systems/industry_system.gd` e dashboard `ui/industry/industry_dashboard.tscn`, tasto rapido HUD `K`.
  - I 3 Livelli Contrattuali (`Enums.ContractType`):
    1. `SELF_RELEASED` (Autoproduzione): Zero vincoli, 100% royalties all'artista (`CONTRACT_SELF_ROYALTY_RATE` = 1.00), ma zero anticipi liquidi e tutti i costi a carico di Alex.
    2. `INDIE_LABEL` (Etichetta Indipendente): Anticipo modesto (default 8.000 € `CONTRACT_INDIE_ADVANCE_DEFAULT`), royalties al 45% (`CONTRACT_INDIE_ROYALTY_RATE` = 0.45), obbligo di 2 album (`CONTRACT_INDIE_ALBUMS_REQ` = 2), grande libertà artistica.
    3. `MAJOR_LABEL` (Major Multinazionale): Anticipo enorme (default 60.000 € `CONTRACT_MAJOR_ADVANCE_DEFAULT`), royalties solo al 15% (`CONTRACT_MAJOR_ROYALTY_RATE` = 0.15), obbligo di 3 album (`CONTRACT_MAJOR_ALBUMS_REQ` = 3), vincolo di qualità minima 65.0 punti (`CONTRACT_MAJOR_MIN_QUALITY`) e forte pressione dai dirigenti A&R.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Fondazione di una propria etichetta discografica indipendente nell'endgame, mettendo sotto contratto altre giovani band emergenti.
  - Clausole di distribuzione fisica esclusiva nei negozi di dischi di tutto il continente.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
  - ## 9.1 I 3 Modelli Produttivi: Autoproduzione, Indie, Major

### Obiettivo del Sistema

Il sistema dell'industria musicale introduce tre differenti modelli produttivi attraverso i quali Alex può gestire la propria carriera discografica:

1. **Autoproduzione**
2. **Etichetta Indipendente**
3. **Major Multinazionale**

La scelta del modello contrattuale determina un equilibrio differente tra:

* libertà artistica;
* capitale iniziale;
* percentuale sulle royalties;
* costi sostenuti direttamente dall'artista;
* obblighi contrattuali;
* pressione dell'industria;
* controllo sulla produzione musicale.

Il sistema è quindi progettato per evitare che il contratto rappresenti semplicemente un "livello superiore" da sbloccare. I tre modelli devono creare **stili di carriera differenti**.

---

### Implementazione Tecnica

Il sistema è strutturato attraverso:

* **Modello dati:** `data/models/contract_data.gd`
* **Sistema principale:** `systems/industry_system.gd`
* **Dashboard:** `ui/industry/industry_dashboard.tscn`
* **Tasto rapido HUD:** `K`

La tipologia del contratto viene rappresentata attraverso:

`Enums.ContractType`

Sono disponibili tre modelli contrattuali.

---

# 1. `SELF_RELEASED` — Autoproduzione

### Filosofia

Alex gestisce autonomamente la propria carriera discografica senza sottoscrivere un contratto con un'etichetta.

È il modello con il massimo livello di autonomia artistica.

### Condizioni

| Parametro            |           Valore |
| -------------------- | ---------------: |
| Vincoli contrattuali |          Nessuno |
| Royalties artista    |         **100%** |
| Anticipo             |          **0 €** |
| Costi di produzione  | A carico di Alex |
| Libertà artistica    |          Massima |

La percentuale di royalties è:

`CONTRACT_SELF_ROYALTY_RATE = 1.00`

Alex mantiene quindi integralmente le royalties generate dalle proprie pubblicazioni.

Il rovescio della medaglia è che non riceve alcun anticipo dall'industria e deve sostenere personalmente i costi necessari alla produzione e alla promozione.

---

### Caratteristiche di Gameplay

L'autoproduzione è particolarmente legata alla gestione economica.

Il giocatore deve valutare direttamente:

* costo dello studio;
* hardware;
* produzione;
* promozione;
* distribuzione;
* tournée;
* marketing;
* eventuali collaboratori.

La maggiore libertà artistica viene quindi bilanciata dall'assenza del capitale iniziale fornito da un'etichetta.

Schema:

**100% royalties**

ma anche:

**100% del rischio finanziario**

---

# 2. `INDIE_LABEL` — Etichetta Indipendente

### Filosofia

L'etichetta indipendente rappresenta una soluzione intermedia tra l'autoproduzione e la grande industria.

Alex riceve un supporto economico e professionale, mantenendo però una notevole libertà creativa.

### Condizioni

| Parametro         |      Valore |
| ----------------- | ----------: |
| Anticipo standard | **8.000 €** |
| Royalties artista |     **45%** |
| Album obbligatori |       **2** |
| Libertà artistica |     Elevata |

Costanti:

* `CONTRACT_INDIE_ADVANCE_DEFAULT = 8.000`
* `CONTRACT_INDIE_ROYALTY_RATE = 0.45`
* `CONTRACT_INDIE_ALBUMS_REQ = 2`

L'anticipo permette ad Alex di affrontare investimenti che sarebbero più difficili da sostenere autonomamente.

In cambio, una parte delle royalties viene destinata all'etichetta e viene introdotto un obbligo di produzione di **2 album**.

---

### Caratteristiche di Gameplay

Il contratto Indie introduce per la prima volta un compromesso tra:

**libertà artistica ↔ supporto economico**

L'etichetta può fornire una maggiore stabilità finanziaria, mentre Alex conserva una notevole autonomia sulle proprie scelte musicali.

L'obbligo di due album introduce inoltre una prospettiva temporale più lunga rispetto all'autoproduzione.

---

# 3. `MAJOR_LABEL` — Major Multinazionale

### Filosofia

La Major rappresenta il modello industriale più strutturato.

L'artista riceve un capitale iniziale molto elevato e accede a una struttura professionale più potente, ma in cambio accetta una percentuale di royalties significativamente inferiore e maggiori obblighi.

### Condizioni

| Parametro                |       Valore |
| ------------------------ | -----------: |
| Anticipo standard        | **60.000 €** |
| Royalties artista        |      **15%** |
| Album obbligatori        |        **3** |
| Qualità minima richiesta |     **65,0** |
| Pressione A&R            |      Elevata |

Costanti:

* `CONTRACT_MAJOR_ADVANCE_DEFAULT = 60.000`
* `CONTRACT_MAJOR_ROYALTY_RATE = 0.15`
* `CONTRACT_MAJOR_ALBUMS_REQ = 3`
* `CONTRACT_MAJOR_MIN_QUALITY = 65.0`

La Major può quindi mettere immediatamente a disposizione di Alex un capitale molto superiore rispetto al contratto Indie.

Questo capitale non elimina però gli obblighi contrattuali.

---

### Qualità Minima

Ogni produzione soggetta al contratto Major deve rispettare una qualità minima di:

**65,0 punti**

Il controllo utilizza quindi il sistema di **Quality Score** già introdotto nel sistema musicale.

Questo crea una connessione diretta tra:

**Skill**

→ **Produzione del brano**

→ **Quality Score**

→ **Obblighi contrattuali**

Il giocatore non può quindi ignorare completamente la qualità delle proprie produzioni dopo aver firmato con una Major.

---

### Pressione A&R

Il rapporto con una Major introduce inoltre una maggiore pressione da parte dei dirigenti **A&R (Artists and Repertoire)**.

La pressione può rappresentare l'interesse dell'etichetta verso:

* qualità delle produzioni;
* rispetto delle scadenze;
* risultati commerciali;
* direzione artistica;
* produttività dell'artista.

Questa componente permette di differenziare ulteriormente la Major dagli altri due modelli.

---

# Confronto Strutturale

| Caratteristica              | Autoproduzione |    Indie |                  Major |
| --------------------------- | -------------: | -------: | ---------------------: |
| Anticipo                    |            0 € |  8.000 € |               60.000 € |
| Royalties artista           |       **100%** |  **45%** |                **15%** |
| Album obbligatori           |              0 |        2 |                      3 |
| Libertà artistica           |        Massima |  Elevata | Maggiormente vincolata |
| Qualità minima              |              — |        — |               **65,0** |
| Pressione A&R               |        Nessuna | Limitata |                Elevata |
| Rischio finanziario diretto |        Elevato |    Medio |              Inferiore |

La tabella rappresenta i parametri contrattuali attualmente definiti e non una graduatoria di convenienza.

---

## Il Contratto come Scelta di Carriera

I tre modelli permettono di costruire percorsi differenti.

### Autoproduzione

**Libertà → rischio finanziario → royalties elevate**

### Indie

**Capitale moderato → supporto → libertà artistica elevata → obblighi limitati**

### Major

**Grande capitale → maggiore struttura industriale → obblighi più elevati → royalties ridotte**

Questo permette al giocatore di modificare il rapporto tra **controllo artistico e struttura industriale** durante la propria carriera.

---

# Direttrici di Espansione & Idee di Gameplay

### Fondazione di una Propria Etichetta

Nell'endgame potrebbe essere introdotta la possibilità per Alex di fondare una propria **etichetta discografica indipendente**.

Il giocatore potrebbe passare da:

**Artista**

a:

**Artista + Proprietario di Label**

La label potrebbe permettere di:

* cercare giovani artisti;
* mettere sotto contratto nuove band;
* offrire anticipi;
* gestire royalties;
* finanziare produzioni;
* scoprire talenti emergenti;
* costruire un vero catalogo di artisti.

In questo modo l'industria musicale diventerebbe una nuova fase della carriera, oltre il semplice successo personale di Alex.

---

### Distribuzione Fisica Esclusiva

Una possibile clausola futura riguarda la **distribuzione fisica esclusiva**.

Un contratto potrebbe garantire all'etichetta il diritto esclusivo di distribuire album e supporti fisici presso i negozi di dischi di un determinato territorio, potenzialmente esteso a tutto il continente.

Questo potrebbe introdurre ulteriori elementi contrattuali:

* territorio coperto;
* durata dell'esclusiva;
* percentuale sulla distribuzione;
* quantità minima distribuita;
* eventuali penali;
* obiettivi di vendita.

---

### Possibili Evoluzioni Future

Il sistema contrattuale può successivamente evolversi da tre modelli fissi verso contratti realmente negoziabili.

Esempio concettuale:

**Anticipo ↔ Royalties ↔ Numero di album ↔ Libertà artistica ↔ Obiettivi ↔ Durata**

Il giocatore potrebbe quindi trovarsi davanti a contratti differenti proposti dall'industria, invece di scegliere sempre e soltanto tra tre configurazioni statiche.

--------------------------------------------------------------------------------------------------------------------------


### 9.2 Anticipi Liquidi, Debito di Recupero (Recoupment) & Royalties
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Meccanismo del Recoupment: L'anticipo incassato alla firma costituisce un debito contabile verso l'etichetta.
  - Tutte le royalties generate dalle vendite e dallo streaming dei brani vengono automaticamente trattenute dall'etichetta per estinguere il debito di recupero.
  - Solo una volta azzerato il debito, le royalties nette riprendono a essere versate sul conto bancario della band.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Rinegoziazione del contratto discografico in caso di successo straordinario (minacciare di non consegnare il master se non alzano le royalties al 25%).
  - Riscatto dei Master originali delle canzoni per rientrare in possesso dei propri diritti a vita.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 9.3 Figure di Management: Amico Fidato, Professionista, Squalo
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/manager_data.gd`.
  - I 3 Profili di Manager (`Enums.ManagerType`):
    1. `TRUSTED_FRIEND` (L'Amico Fidato): Quota ingaggio 50 €, provvigione solo 10%, moltiplicatore cachet live 1.10x, zero stress generato (anzi alleggerisce lo stress di 1.0 punto). Poche connessioni di alto livello.
    2. `PRO_INDIE` (Il Professionista Indipendente): Quota ingaggio 400 €, provvigione 15%, moltiplicatore cachet live 1.25x, apre le porte dei club migliori, riduce lo stress organizzativo di 2.5 punti.
    3. `INDUSTRY_SHARK` (Lo Squalo dell'Industria): Quota ingaggio 2.000 €, provvigione 22%, moltiplicatore cachet live 1.50x, accesso garantito ai festival estivi, ma genera continuo stress notturno (+4.0 stress a notte) con telefonate e richieste pressanti.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Possibilità di licenziare il manager in caso di divergenze, con gestione della penale di rescissione.
  - Tradimento del manager: rischio che uno squalo scappi con una parte degli incassi se la band non ha un avvocato.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
  - ## 9.3 Figure di Management: Personalità, Fiducia & Imprevisti

### Obiettivo del Sistema

Il Manager non deve essere percepito come un semplice **bonus acquistabile**.

La sua funzione è rappresentare una persona reale che entra nella carriera di Alex e che, nel tempo, può diventare:

* un alleato fondamentale;
* una presenza neutrale;
* una fonte di opportunità;
* una persona difficile da gestire;
* oppure un problema che inizialmente sembrava impossibile da prevedere.

Per questo motivo il sistema deve evitare una lettura troppo evidente del tipo:

> **Manager A = buono**
> **Manager B = medio**
> **Manager C = forte ma costoso**

Il giocatore deve invece poter pensare:

> **"Questo manager sembra interessante... ma cosa succederà davvero se gli affido la mia carriera?"**

---

## Implementazione Tecnica

Il sistema utilizza:

* **Modello dati:** `data/models/manager_data.gd`
* **Tipologia:** `Enums.ManagerType`

Sono attualmente presenti tre profili principali:

1. `TRUSTED_FRIEND`
2. `PRO_INDIE`
3. `INDUSTRY_SHARK`

Questi profili rappresentano una **tendenza comportamentale generale**, non una garanzia assoluta del comportamento futuro del personaggio.

---

# 1. `TRUSTED_FRIEND` — L'Amico Fidato

### Parametri Attuali

* Quota ingaggio: **50 €**
* Provvigione: **10%**
* Moltiplicatore cachet live: **1.10×**
* Stress generato: **-1.0**
* Poche connessioni di alto livello.

Questo manager rappresenta una persona vicina ad Alex, con un rapporto umano molto forte ma con una rete professionale relativamente limitata.

### Il lato nascosto

Il vantaggio dell'Amico Fidato non deve essere soltanto il basso costo.

La sua vera caratteristica è la **fiducia personale**.

Potrebbe:

* difendere Alex durante una discussione;
* cercare di evitare contratti troppo aggressivi;
* essere particolarmente presente nei momenti difficili;
* prendere decisioni basandosi sul rapporto personale più che sul guadagno.

Ma proprio questa natura può creare problemi.

Un manager molto protettivo potrebbe, ad esempio, rifiutare un'opportunità che considera dannosa per Alex anche quando il giocatore avrebbe preferito accettarla.

La sua rete limitata, inoltre, può diventare evidente solo quando Alex prova a entrare in determinati circuiti professionali.

---

# 2. `PRO_INDIE` — Il Professionista Indipendente

### Parametri Attuali

* Quota ingaggio: **400 €**
* Provvigione: **15%**
* Moltiplicatore cachet live: **1.25×**
* Accesso ai club migliori.
* Riduzione dello stress organizzativo: **-2.5**.

Il Professionista rappresenta il manager apparentemente più equilibrato: possiede contatti, esperienza e una buona capacità organizzativa.

Ma il termine **"Professionista" non deve significare automaticamente "prevedibile"**.

### Il lato nascosto

Questo manager potrebbe avere interessi professionali che il giocatore scopre soltanto con il tempo.

Per esempio potrebbe:

* privilegiare alcuni locali con cui ha rapporti consolidati;
* spingere Alex verso determinate scelte artistiche;
* considerare alcuni concerti più importanti di altri;
* avere rapporti personali con promoter e organizzatori;
* essere molto disponibile in alcune situazioni e sorprendentemente rigido in altre.

Il giocatore non dovrebbe conoscere necessariamente tutte queste informazioni al momento dell'ingaggio.

---

# 3. `INDUSTRY_SHARK` — Lo Squalo dell'Industria

### Parametri Attuali

* Quota ingaggio: **2.000 €**
* Provvigione: **22%**
* Moltiplicatore cachet live: **1.50×**
* Accesso garantito ai festival estivi.
* Stress notturno: **+4.0 per notte**.

È il manager con il maggior peso nell'industria e con la maggiore capacità di trasformare rapidamente la carriera di Alex.

Ma non deve essere semplicemente:

> "Paghi molto → ottieni grandi bonus."

Il vero prezzo dello Squalo dovrebbe essere **la perdita progressiva di controllo**.

### Il lato nascosto

Lo Squalo può essere estremamente efficace, ma potrebbe avere una propria agenda.

Potrebbe:

* pretendere decisioni rapide;
* spingere per concerti più redditizi;
* insistere su determinati contratti;
* telefonare durante la notte;
* creare pressione per rispettare determinati obiettivi;
* accettare opportunità che Alex non avrebbe scelto autonomamente.

Il problema non è necessariamente che faccia qualcosa di apertamente negativo.

Il problema è che **potrebbe avere una visione della carriera diversa da quella di Alex**.

---

# Informazioni Parziali sul Manager

Una delle caratteristiche fondamentali del sistema dovrebbe essere la **conoscenza incompleta**.

Quando Alex incontra un manager, il giocatore non dovrebbe necessariamente ricevere una scheda del tipo:

> Provvigione 22%
> Stress +4
> Festival garantiti
> Rischio tradimento 17%

Sarebbe troppo artificiale e renderebbe il sistema completamente risolvibile.

Il giocatore dovrebbe invece conoscere alcune informazioni:

* costo;
* provvigione;
* reputazione generale;
* alcune referenze;
* precedenti collaborazioni;
* dichiarazioni del manager.

Altri aspetti dovrebbero essere scoperti **attraverso l'esperienza**.

---

# Sistema di Fiducia

Il rapporto tra Alex e il manager potrebbe evolvere attraverso un valore interno di **Fiducia**.

La Fiducia potrebbe aumentare o diminuire in base a:

* risultati ottenuti;
* rispetto degli accordi;
* discussioni;
* successi professionali;
* decisioni prese contro il parere del manager;
* crisi reputazionali;
* gestione del denaro;
* durata della collaborazione.

La stessa figura professionale potrebbe quindi comportarsi diversamente nel tempo.

### Esempio

All'inizio:

> "Il mio manager mi sembra fantastico."

Dopo sei mesi:

> "Perché continua a spingermi verso questo tipo di contratto?"

Dopo un anno:

> "Forse lo conosco abbastanza da capire quando mi sta davvero aiutando."

Il sistema deve quindi creare una **relazione**, non soltanto applicare modificatori.

---

# Eventi Imprevedibili

Il Manager dovrebbe poter generare eventi durante la carriera.

Non necessariamente eventi negativi.

### Possibili eventi positivi

* un contatto inatteso con un promoter;
* un invito privato a un evento;
* un'opportunità per un festival;
* una collaborazione con un artista;
* un contratto interessante;
* una negoziazione particolarmente favorevole.

### Possibili eventi ambigui

* proposta molto remunerativa ma con condizioni strane;
* concerto improvviso in una città lontana;
* collaborazione con un artista sconosciuto;
* richiesta di cambiare rapidamente programma;
* invito a un evento esclusivo.

### Possibili eventi negativi

* contratto poco conveniente;
* promoter problematico;
* incomprensione economica;
* conflitto con un membro della band;
* pressione eccessiva;
* ritardo nell'organizzazione;
* controversia sulla gestione degli incassi.

La cosa importante è che **non tutti gli eventi negativi debbano essere annunciati come tali**.

---

# Il Sistema delle "Promesse"

Una possibile meccanica particolarmente adatta al sistema consiste nelle **promesse del manager**.

Durante una conversazione potrebbe dire:

> "Se firmi con me, posso provare a farti entrare in quel festival."

Oppure:

> "Conosco personalmente il proprietario di quel club."

Il gioco non dovrebbe necessariamente rivelare quanto questa promessa sia affidabile.

Potrebbe:

* riuscire;
* fallire;
* riuscire parzialmente;
* richiedere tempo;
* avere condizioni nascoste;
* aprire una nuova opportunità.

Questo introduce una componente di **fiducia e rischio** senza trasformare il sistema in una semplice tabella di statistiche.

---

# Tradimento e Conflitto di Interessi

Una possibile evoluzione riguarda i **conflitti di interesse**.

Un manager potrebbe avere rapporti economici o professionali con:

* promoter;
* locali;
* festival;
* case discografiche;
* altri artisti.

Questo potrebbe creare situazioni nelle quali non è immediatamente evidente se una proposta sia realmente nell'interesse di Alex.

### Esempio

Il manager propone:

> "Ho trovato un ottimo locale. Ti pagano meno del solito, ma è una grande occasione."

Il giocatore potrebbe accettare.

Successivamente potrebbe scoprire che:

* il locale garantiva al manager un rapporto privilegiato;
* l'esposizione era realmente importante;
* oppure l'affare era semplicemente conveniente per il manager.

Il sistema non dovrebbe sempre rivelare immediatamente quale delle tre interpretazioni sia corretta.

---

# Il Tradimento dello Squalo

Tra le evoluzioni più rischiose può essere presente il tradimento dello Squalo.

Se la band non dispone di adeguate protezioni legali, potrebbe esistere il rischio che il manager tenti di trattenere o deviare una parte degli incassi.

La probabilità e le modalità dell'evento dovrebbero però dipendere da fattori come:

* rapporto di fiducia;
* durata del contratto;
* situazione economica;
* presenza di un avvocato;
* precedenti conflitti;
* comportamento del manager.

Il tradimento non dovrebbe quindi essere un evento casuale completamente scollegato dal gameplay.

Dovrebbe essere il risultato possibile di una **relazione deteriorata**.

---

# Licenziamento del Manager

Alex deve poter interrompere il rapporto con il proprio manager.

Tuttavia, il licenziamento potrebbe comportare:

* penale di rescissione;
* perdita temporanea di alcune opportunità;
* deterioramento dei rapporti professionali;
* tempo necessario per trovare un sostituto;
* eventuali conseguenze sulla programmazione di concerti e festival.

Questo rende la scelta del manager una decisione con una certa inerzia.

Cambiare continuamente manager non dovrebbe essere necessariamente privo di conseguenze.

---

# Principio Fondamentale: Il Manager non deve avere un "Allineamento"

Il sistema dovrebbe evitare categorie semplicistiche come:

**Buono / Neutrale / Cattivo**

oppure:

**Economico / Medio / Forte**

Ogni manager dovrebbe essere una combinazione di caratteristiche potenzialmente vantaggiose e problematiche.

Un manager può essere:

* molto bravo ma invadente;
* economico ma poco influente;
* estremamente connesso ma opportunista;
* leale ma poco ambizioso;
* aggressivo nelle trattative ma stressante;
* apparentemente perfetto ma incompatibile con Alex.

Il giocatore deve quindi imparare a **conoscere il proprio manager attraverso la carriera**.

---

## Esempio di Evoluzione Narrativa

### Giorno 1

Alex assume un manager.

> "Sembra una persona seria."

### Giorno 40

Il manager ottiene un ottimo club.

> "Forse ho fatto la scelta giusta."

### Giorno 75

Arriva una proposta strana.

> "Perché insiste così tanto su questo contratto?"

### Giorno 100

Il manager ottiene un festival importante.

> "Ok, forse sa davvero quello che fa."

### Giorno 130

Una telefonata alle 02:30.

> "Domani devi essere a Berlino."

Alex deve decidere se fidarsi oppure opporsi.

Questa progressione rende il manager una **figura narrativa ricorrente**, non un semplice modificatore numerico.

---

## Direttrici di Espansione & Idee di Gameplay

### Manager con Personalità Procedurale

In futuro ogni manager potrebbe essere generato combinando diversi tratti:

* ambizione;
* lealtà;
* aggressività;
* prudenza;
* disponibilità;
* ego;
* capacità negoziale;
* rete di contatti;
* tolleranza al rischio.

Il risultato sarebbe che due manager dello stesso `ManagerType` potrebbero comportarsi in maniera diversa.

### Reputazione del Manager

Il giocatore potrebbe raccogliere informazioni indirette:

* altri artisti che ha rappresentato;
* recensioni professionali;
* voci nell'ambiente;
* successi passati;
* fallimenti passati;
* testimonianze di altri musicisti.

Anche queste informazioni potrebbero essere **incomplete o contraddittorie**.

### Manager che Cambiano

Un manager potrebbe evolvere nel tempo.

Un professionista inizialmente disponibile potrebbe diventare più esigente quando Alex raggiunge il successo.

Al contrario, un rapporto molto lungo potrebbe trasformare un manager aggressivo in un alleato estremamente fedele.

---

## Principio di Design

Il Manager deve creare **incertezza interessante**, non frustrazione casuale.

Il giocatore dovrebbe poter dire:

> **"Non potevo sapere esattamente cosa sarebbe successo, ma col senno di poi avevo degli indizi."**

Questa è la differenza tra:

**imprevedibilità**

e

**casualità ingiusta**.

L'obiettivo è che gli eventi possano sorprendere il giocatore, ma che, dopo averli vissuti, sia possibile riconoscere i segnali che li avevano preceduti.

----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------

### 9.4 Bivi Etico-Narrativi dell'Industria
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/dilemma_data.gd` e modulo `systems/dilemma_system.gd`.
  - Eventi periodici a scelta multipla con impatti deterministici su: Soldi, Reputazione, Fan, Morale, Stress e Tensione Band.
  - Le 4 Categorie di Bivio (`Enums.DilemmaCategory`):
    1. `COMMERCIAL_ETHICS` (Etica Commerciale): Es. Offerta da 5.000 € per cedere una propria canzone a uno spot di un marchio inquinante o di fast food.
    2. `BAND_INTERNAL` (Conflitti Interni): Es. L'etichetta propone ad Alex di abbandonare la band per lanciarsi come solista.
    3. `MEDIA_SCANDAL` (Scandali e Gossip): Es. Pagare un ufficio stampa per inventare una finta lite con una celebrità per finire sui giornali.
    4. `ARTISTIC_INTEGRITY` (Integrità Artistica): Es. Richiesta del direttore artistico di modificare il testo di un brano ritenuto "troppo politico" per farlo passare in radio.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Bivi a catena (conseguenze a lungo termine: es. la band rifiuta lo spot e anni dopo un'associazione ambientalista organizza un concerto tributo a loro favore).
  - Cause legali per plagio da difendere in tribunale.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

