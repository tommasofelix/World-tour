# World-tour — Roadmap Modulare: Sezione 3

- File di origine: `docs/roadmap.md`
- Titolo: La Band, Reclutamento, Dinamiche Relazionali & Revenue Split
- Priorità Operativa: P3 - Loop Sociale/Band

---

## 3. LA BAND, RECLUTAMENTO & DINAMICHE RELAZIONALI

### 3.1 Reclutamento Compagni, Bacheca Audizioni & Ruoli
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo band: `systems/band_system.gd` e modale `BandHub` (`ui/band/band_hub.tscn`), tasto rapido HUD `G`.
  - Massimo 3 compagni reclutabili (`Constants.MAX_BAND_MEMBERS` = 3) per formare un quartetto completo insieme ad Alex.
  - 4 Ruoli Strumentali (`Enums.BandRole`):
    1. Basso (Garantisce groove e stabilità ritmica al gruppo)
    2. Batteria (Dà ritmo, potenza sonora ed energia live)
    3. Tastiere (Aggiunge atmosfera, armonie complesse e sfumature)
    4. Chitarra Ritmica (Costruisce il muro di suono e compattezza)
  - Bacheca annunci audizioni con costo di 30.0 € per provino (`BAND_AUDITION_FEE`).
  - Generazione procedurale dei candidati con nome, età, livello abilità strumento e profilo psicologico.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Audizioni con domande attitudinali al musicista per saggiare la compatibilità caratteriale prima di ingaggiarlo.
  - Possibilità di assumere turnisti a gettone per un singolo concerto o sessione studio senza vincoli associativi.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
    ## 3.1 Reclutamento Compagni, Bacheca Audizioni & Ruoli

La **Band** rappresenta uno dei principali sistemi di evoluzione della carriera dell'artista. Il giocatore può passare dalla condizione di artista solista alla formazione di un gruppo musicale stabile, reclutando progressivamente nuovi membri attraverso un sistema di audizioni.

Il sistema è gestito attraverso:

* `systems/band_system.gd`
* `ui/band/band_hub.tscn` — interfaccia principale della Band Hub;
* tasto rapido HUD **`G`**.

La formazione massima prevista è composta da **4 musicisti complessivi**:

**Alex + massimo 3 compagni reclutati**

---

### 3.1.1 Numero massimo di membri

La costante:

`Constants.MAX_BAND_MEMBERS = 3`

definisce il numero massimo di compagni che il giocatore può reclutare.

Poiché Alex rappresenta il personaggio principale, il limite permette di arrivare a una formazione completa di:

**1 protagonista + 3 membri = 4 musicisti**

Il limite evita inoltre che la gestione della band diventi eccessivamente complessa nelle prime versioni del gioco.

---

## 3.1.2 Bacheca Audizioni

Il reclutamento avviene attraverso una **Bacheca delle Audizioni**.

Il giocatore può pubblicare o consultare annunci per trovare musicisti interessati a entrare nella propria formazione.

Ogni provino ha un costo di:

`BAND_AUDITION_FEE = 30,0 €`

Il costo rappresenta la spesa necessaria per organizzare l'audizione e permette di trasformare il reclutamento in una vera decisione economica.

Il ciclo base è:

**Bacheca → Audizione → Candidato → Valutazione → Reclutamento / Rifiuto**

Il giocatore non riceve quindi automaticamente un membro della band: deve prima valutare il candidato e decidere se procedere con il reclutamento.

---

## 3.1.3 Generazione procedurale dei candidati

I candidati alle audizioni vengono generati proceduralmente.

Ogni candidato dispone almeno delle seguenti informazioni:

* **Nome**
* **Età**
* **Livello dell'abilità strumentale**
* **Profilo psicologico**

Questo permette di generare musicisti differenti senza dover definire manualmente ogni possibile componente della band.

Due candidati che ricoprono lo stesso ruolo possono quindi avere caratteristiche completamente differenti.

Esempio concettuale:

| Candidato   | Età |    Abilità | Profilo       |
| ----------- | --: | ---------: | ------------- |
| Candidato A |  21 |       Alta | Ambizioso     |
| Candidato B |  29 |      Media | Collaborativo |
| Candidato C |  35 | Molto alta | Esigente      |

La scelta non deve quindi basarsi esclusivamente sul livello tecnico.

Un musicista molto bravo potrebbe infatti avere caratteristiche personali differenti rispetto a un candidato tecnicamente meno preparato.

---

## 3.1.4 Ruoli strumentali

Il sistema prevede quattro ruoli principali attraverso `Enums.BandRole`.

### 1. Basso

Il bassista garantisce:

* groove;
* stabilità ritmica;
* collegamento tra batteria e armonia;
* solidità della sezione ritmica.

### 2. Batteria

Il batterista contribuisce a:

* ritmo;
* potenza sonora;
* energia delle esibizioni live;
* solidità della performance.

### 3. Tastiere

Il tastierista aggiunge:

* atmosfere;
* armonie;
* pad e texture;
* maggiore varietà sonora.

### 4. Chitarra Ritmica

Il chitarrista ritmico contribuisce a:

* compattezza dell'arrangiamento;
* muro di suono;
* supporto armonico;
* potenza della sezione strumentale.

### 5. Cantante

Il cantante rappresenta il ruolo vocale principale della band e può essere ricoperto da Alex oppure da un compagno reclutato attraverso la Bacheca delle Audizioni.

Il cantante contribuisce a:

* interpretazione vocale;
* presenza scenica;
* comunicazione con il pubblico;
* riconoscibilità dell'identità della band;
* qualità delle performance live e delle registrazioni.

Se Alex ricopre già il ruolo di cantante, il giocatore può utilizzare gli slot disponibili per reclutare bassista, batterista, tastierista o chitarrista ritmico.

Se invece Alex non ricopre il ruolo vocale principale, il giocatore può reclutare un cantante come membro della band. In questo caso il ruolo del cantante deve essere considerato nella composizione complessiva della formazione, mantenendo comunque il limite massimo di **4 musicisti**.

Il cantante può essere valutato attraverso caratteristiche specifiche, tra cui:

* **Tecnica vocale**
* **Estensione**
* **Controllo**
* **Interpretazione**
* **Presenza scenica**
* **Affidabilità durante le esibizioni**
* **Compatibilità con lo stile musicale della band**

Un cantante con una tecnica elevata può migliorare la qualità delle registrazioni, mentre un cantante con una forte presenza scenica può aumentare il coinvolgimento del pubblico durante i concerti.

Il profilo psicologico del cantante può inoltre influenzare la direzione artistica della band. Un membro molto ambizioso potrebbe desiderare maggiore visibilità e un ruolo centrale nelle decisioni creative, mentre un cantante più collaborativo potrebbe adattarsi meglio alle scelte del gruppo.

Il ruolo del cantante può quindi avere un'importanza particolare anche nelle future meccaniche di:

* morale della band;
* compatibilità caratteriale;
* reputazione;
* popolarità;
* gestione dei concerti;
* divisione dei ricavi;
* conflitti interni.

Il principio progettuale è:

> **Il cantante non è soltanto la voce della band, ma anche uno dei principali elementi dell'identità pubblica del gruppo.**

---

## 3.1.5 Composizione della formazione

Il sistema permette quindi di costruire progressivamente la formazione.

Un possibile percorso è:

**Artista solista**

↓

**Primo reclutamento**

↓

**Secondo reclutamento**

↓

**Terzo reclutamento**

↓

**Band completa da 4 membri**

La band non deve necessariamente essere completata immediatamente.

Il giocatore può iniziare a lavorare con una formazione parziale e successivamente cercare altri musicisti.

Questo permette di trasformare la costruzione della band in una progressione della carriera anziché in un semplice requisito da completare una volta.

---

## 3.1.6 Valutazione del candidato

Durante l'audizione il giocatore deve poter confrontare almeno due dimensioni fondamentali:

### Competenza musicale

Rappresentata dal livello dell'abilità strumentale del candidato.

Determina il potenziale contributo tecnico del musicista alla band.

### Profilo personale

Rappresentato dal profilo psicologico generato per il candidato.

Questa caratteristica prepara il terreno alle future meccaniche di **compatibilità caratteriale**, nelle quali la personalità dei membri potrà influenzare la vita quotidiana della band.

In questo modo il reclutamento non si riduce alla ricerca del valore numerico più alto.

Il principio progettuale è:

> **Il musicista migliore tecnicamente non è necessariamente il membro più adatto alla band.**
>
> ### Livello complessivo della band
>
> Oltre al livello individuale dei singoli musicisti, la band dispone di un **livello complessivo** che rappresenta la qualità, l'esperienza e la solidità raggiunte dal gruppo.
>
> Il livello della band può dipendere da diversi fattori:
>
> * livello medio dei membri;
> * esperienza accumulata insieme;
> * numero di prove effettuate;
> * qualità delle esibizioni;
> * risultati ottenuti durante concerti e registrazioni;
> * reputazione della band;
> * livello di coesione interna;
> * stabilità della formazione.
>
> Il livello complessivo non deve quindi essere calcolato esclusivamente come media delle abilità individuali. Una band composta da musicisti molto talentuosi, ma appena riuniti e poco affiatati, potrebbe avere un livello effettivo inferiore rispetto a una formazione tecnicamente meno forte ma molto coesa.
>
> Un possibile modello concettuale è:
>
> **Livello Band = livello medio dei membri + esperienza condivisa + coesione + reputazione**
>
> Il valore risultante può essere utilizzato per determinare quali musicisti siano interessati a unirsi alla formazione.
>
> Un musicista di livello **56**, ad esempio, potrebbe essere poco propenso a entrare in una band di livello **20**, soprattutto se la formazione presenta anche:
>
> * poca coesione;
> * bassa reputazione;
> * scarsa esperienza live;
> * obiettivi artistici poco ambiziosi;
> * compensi insufficienti;
> * membri con livelli molto inferiori;
> * incompatibilità con il profilo personale del candidato.
>
> Il livello della band deve quindi influenzare sia la disponibilità dei candidati sia la difficoltà del reclutamento.
>
> Una band emergente potrebbe attirare principalmente musicisti principianti o intermedi, mentre una band più affermata potrebbe ricevere candidature da professionisti di livello superiore.
>
> ---
>
> ### Rifiuto del candidato
>
> Il reclutamento non deve essere un'azione garantita.
>
> Dopo l'audizione, il candidato può:
>
> * accettare immediatamente;
> * accettare a determinate condizioni;
> * richiedere un compenso maggiore;
> * chiedere un ruolo più importante nella band;
> * rifiutare l'offerta;
> * preferire un'altra band;
> * rimandare la decisione.
>
> Il rifiuto può dipendere da diversi fattori:
>
> * livello della band troppo basso;
> * differenza eccessiva tra il livello del candidato e quello della formazione;
> * scarsa coesione;
> * incompatibilità caratteriale;
> * reputazione insufficiente;
> * genere musicale non gradito;
> * obiettivi artistici differenti;
> * compenso o divisione dei ricavi non soddisfacenti;
> * numero di membri già presenti;
> * presenza di un leader o cantante incompatibile;
> * condizioni di lavoro poco interessanti;
> * disponibilità limitata del candidato;
> * preferenza per una carriera solista;
> * interesse già ricevuto da un'altra band.
>
> Il giocatore dovrebbe quindi ricevere una motivazione generale del rifiuto, senza necessariamente conoscere tutti i valori interni utilizzati dal sistema.
>
> Esempi di messaggi:
>
> > “Il candidato ritiene che la band non sia ancora abbastanza affermata.”
>
> > “Il candidato non si sente compatibile con l'attuale formazione.”
>
> > “Il candidato cerca un progetto con obiettivi artistici più ambiziosi.”
>
> > “Il candidato considera insufficiente il compenso proposto.”
>
> > “Il candidato preferisce unirsi a una band con maggiore esperienza.”
>
> Questo rende il reclutamento più credibile e impedisce che la Bacheca delle Audizioni diventi un semplice elenco di membri acquistabili.
>
> ---
>
> ### Possibilità di unirsi a una band già esistente
>
> Il giocatore può anche scegliere di non creare una band propria e di unirsi a una formazione già esistente.
>
> Nel mondo di gioco possono essere presenti band generate proceduralmente o create da altri personaggi.
>
> Il giocatore può ricevere offerte oppure candidarsi spontaneamente presso una band già formata.
>
> Il ciclo può essere:
>
> **Band esistente → Candidatura → Valutazione → Offerta → Accettazione / Rifiuto**
>
> La band interessata può valutare:
>
> * livello musicale del giocatore;
> * ruolo strumentale;
> * reputazione;
> * popolarità;
> * esperienza live;
> * compatibilità caratteriale;
> * disponibilità;
> * stile musicale;
> * aspettative economiche;
> * obiettivi personali.
>
> Anche in questo caso la band può rifiutare il giocatore.
>
> Una formazione di livello elevato potrebbe non accettare un musicista ancora inesperto, mentre una band emergente potrebbe essere più disponibile a reclutare nuovi membri.
>
> ---
>
> ### Ruolo del giocatore all'interno di una band esistente
>
> Quando il giocatore entra in una band già creata, Alex non ne diventa necessariamente il leader.
>
> Il ruolo può dipendere dalla struttura della formazione:
>
> * membro ordinario;
> * co-leader;
> * principale autore;
> * cantante principale;
> * strumentista di supporto;
> * membro temporaneo;
> * sostituto;
> * leader della band, se la formazione viene successivamente riorganizzata.
>
> La band può avere già:
>
> * un nome;
> * un genere musicale;
> * una reputazione;
> * una storia;
> * una gerarchia interna;
> * obiettivi artistici;
> * contratti;
> * rapporti tra i membri;
> * una divisione dei ricavi;
> * un calendario di prove e concerti.
>
> Entrando in una band esistente, il giocatore accetta quindi una struttura già avviata e deve adattarsi alle sue regole.
>
> ---
>
> ### Vantaggi e svantaggi dell'unirsi a una band esistente
>
> **Vantaggi**
>
> * accesso immediato a una formazione completa;
> * possibilità di suonare in concerti già organizzati;
> * maggiore reputazione iniziale;
> * minori costi di reclutamento;
> * possibilità di imparare da musicisti più esperti;
> * accesso a una rete di contatti già sviluppata.
>
> **Svantaggi**
>
> * minore controllo sulle decisioni artistiche;
> * possibile divisione dei ricavi;
> * necessità di adattarsi al genere della band;
> * rischio di conflitti interni;
> * possibilità di essere sostituiti;
> * minore libertà nella scelta dei membri;
> * dipendenza dagli obiettivi del leader.
>
> Il giocatore deve quindi scegliere tra due percorsi principali:
>
> **Creare una band propria**
> → maggiore controllo
> → crescita più lenta
> → possibilità di scegliere i membri
> → responsabilità organizzativa più elevata
>
> **Unirsi a una band esistente**
> → accesso più rapido alla carriera di gruppo
> → minore controllo
> → possibilità di entrare in formazioni già affermate
> → dipendenza dalle decisioni degli altri membri
>
> ---
>
> ### Evoluzione della band e cambi di formazione
>
> Il livello della band può cambiare nel tempo in base agli eventi della carriera.
>
> Può aumentare grazie a:
>
> * prove regolari;
> * concerti riusciti;
> * pubblicazione di brani;
> * crescita della reputazione;
> * miglioramento dei membri;
> * maggiore coesione;
> * permanenza stabile della formazione.
>
> Può diminuire a causa di:
>
> * abbandono di un membro;
> * conflitti interni;
> * concerti falliti;
> * lunghi periodi di inattività;
> * stress elevato;
> * sostituzioni frequenti;
> * problemi economici;
> * calo della reputazione.
>
> La sostituzione di un membro può inoltre ridurre temporaneamente la coesione, anche quando il nuovo musicista è tecnicamente più forte.
>
> Il sistema deve quindi distinguere tra:
>
> **Forza individuale**
> → quanto è bravo il singolo musicista
>
> **Forza complessiva**
> → quanto è efficace la band nel suo insieme
>
> **Coesione**
> → quanto i membri lavorano bene insieme
>
> Questi valori possono influenzarsi reciprocamente, ma non devono essere considerati equivalenti.
>
> ---
>
> ## Decisioni confermate
>
> * La band possiede un livello complessivo separato dal livello dei singoli membri.
> * Il livello della band dipende da abilità, esperienza, coesione, reputazione e risultati.
> * Un candidato di livello elevato può rifiutare una band troppo debole o poco affermata.
> * I candidati possono rifiutare il reclutamento per incompatibilità caratteriale, differenze di livello, compenso, genere musicale o altri fattori.
> * Il reclutamento non è garantito dopo l'audizione.
> * Il giocatore può candidarsi a una band già esistente.
> * Il giocatore può ricevere offerte da band già create.
> * Le band esistenti possono accettare o rifiutare il giocatore.
> * Entrando in una band esistente, Alex potrebbe non essere il leader.
> * Il giocatore può scegliere tra la creazione di una band propria e l'ingresso in una formazione già avviata.
> * Il livello della band e la coesione devono essere considerati valori distinti.
> * La composizione della band può cambiare nel tempo, influenzando livello, reputazione e coesione.

---

# Direttrici di Espansione & Idee di Gameplay

### Audizione attitudinale

Una futura versione potrebbe trasformare l'audizione in una vera interazione.

Prima del reclutamento, il giocatore potrebbe porre alcune domande al candidato, ad esempio relative a:

* ambizione;
* disponibilità a viaggiare;
* rapporto con gli altri membri;
* aspettative economiche;
* atteggiamento verso il successo;
* disponibilità a lavorare molto;
* preferenza per attività live o studio.

Le risposte potrebbero fornire informazioni aggiuntive sul profilo psicologico del musicista.

---

### Compatibilità caratteriale

Il profilo psicologico potrebbe successivamente diventare una caratteristica gameplay vera e propria.

Possibili conseguenze:

**Compatibilità alta**
→ collaborazione migliore
→ morale della band più stabile
→ minore probabilità di conflitti

**Compatibilità bassa**
→ tensioni interne
→ morale ridotto
→ discussioni
→ possibili problemi durante prove, tour o registrazioni

Questa meccanica si collegherebbe direttamente al sistema di **Morale, Stress ed Energia** già presente nel gioco.

---

### Turnisti

Una futura alternativa al reclutamento permanente potrebbe essere rappresentata dai **turnisti**.

Il giocatore potrebbe assumere un musicista professionista pagando un compenso per:

* un singolo concerto;
* una sessione di registrazione;
* un tour;
* un evento specifico.

Il turnista non diventerebbe un membro permanente della band e non parteciperebbe quindi necessariamente alla gestione interna del gruppo.

Il sistema introdurrebbe una scelta tra:

**Membro permanente**
→ investimento a lungo termine
→ rapporto personale
→ possibile divisione dei ricavi

**Turnista**
→ costo immediato
→ nessun vincolo associativo
→ soluzione flessibile per concerti o sessioni specifiche

---

## Decisioni confermate

* Il sistema Band è gestito da `systems/band_system.gd`.
* La gestione della band è accessibile tramite `BandHub`.
* Il tasto rapido HUD è **`G`**.
* Alex è il protagonista e può reclutare massimo **3 compagni**.
* La formazione massima è quindi di **4 musicisti**.
* Sono presenti quattro ruoli:

  * Basso
  * Batteria
  * Tastiere
  * Chitarra Ritmica
* Il costo di ogni audizione è **30,0 €**.
* I candidati vengono generati proceduralmente.
* Ogni candidato dispone di nome, età, abilità strumentale e profilo psicologico.
* Il profilo del candidato costituisce la base per future meccaniche di compatibilità.
* Sono previste future audizioni attitudinali.
* Sono previsti futuri turnisti a gettone.


### 3.2 Psicologia dei Membri: 4 Personalità Distinte
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Le 4 personalità modellate in `Enums.BandPersonality`:
    1. `RELIABLE` (L'Affidabile): Calmo, puntuale, abbassa la tensione del gruppo, non crea drammi, performance costante.
    2. `PERFECTIONIST` (Il Perfezionista): Alza la qualità delle esecuzioni in studio e live, ma accumula tensione se il gruppo sbaglia o non prova abbastanza.
    3. `WILD_PARTY` (L'Animale da Festa): Carismatico e trascinante sul palco, alza la presenza scenica, ma porta rischio di ritardi, postumi da sbronza e imprevisti.
    4. `EGO_ARTIST` (L'Ego Smisurato): Musicista di enorme talento tecnico, ma permaloso sulla scaletta, geloso della visibilità del leader e intransigente sui compensi.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Ulteriori sfumature psicologiche (es. Il Mercenario che suona solo per soldi, L'Ansioso da Palco che rischia il blocco prima di un grande concerto).
  - Eventi relazionali casuali tra i membri (es. due membri che si innamorano o che litigano per motivi extra-musicali).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: ## 3.2 Psicologia dei Membri: 4 Personalità Distinte

Ogni membro della band possiede una personalità definita attraverso `Enums.BandPersonality`.

La personalità non rappresenta solamente un'etichetta descrittiva, ma costituisce la base per determinare il comportamento del musicista all'interno della formazione.

Due membri con lo stesso livello musicale possono quindi avere un impatto completamente diverso sulla band.

Il sistema attualmente prevede **4 personalità principali**:

1. `RELIABLE` — L'Affidabile
2. `PERFECTIONIST` — Il Perfezionista
3. `WILD_PARTY` — L'Animale da Festa
4. `EGO_ARTIST` — L'Ego Smisurato

### 3.2.5 Nuove Personalità

Per ampliare la varietà dei membri reclutabili, il sistema può includere ulteriori personalità oltre alle quattro principali già definite.

Ogni nuovo profilo dovrebbe introdurre vantaggi specifici, comportamenti riconoscibili e possibili svantaggi, evitando di trasformarsi in un semplice modificatore numerico.

---

### `MERCENARY` — Il Mercenario

Il Mercenario considera la band principalmente come un'opportunità professionale.

È caratterizzato da:

* forte interesse per il denaro;
* scarsa fedeltà emotiva alla formazione;
* attenzione ai compensi;
* disponibilità a cambiare band per un'offerta migliore;
* comportamento pragmatico.

Può essere molto affidabile quando il compenso è adeguato, ma diventare insoddisfatto se:

* la band guadagna poco;
* i pagamenti sono in ritardo;
* il suo contributo non viene ricompensato;
* altri membri ricevono una quota maggiore.

Il Mercenario può aumentare la professionalità della band, ma rende la stabilità del gruppo più dipendente dalla situazione economica.

---

### `STAGE_ANXIOUS` — L'Ansioso da Palco

L'Ansioso da Palco è un musicista preparato, ma particolarmente vulnerabile alla pressione delle esibizioni.

È caratterizzato da:

* forte stress prima dei concerti;
* paura di sbagliare;
* difficoltà durante i grandi eventi;
* bisogno di preparazione e rassicurazione;
* rendimento variabile in base al contesto.

Può esibirsi molto bene in piccoli locali o durante prove familiari, ma avere difficoltà quando:

* aumenta la dimensione della venue;
* il pubblico è numeroso;
* il concerto è particolarmente importante;
* la band non ha provato abbastanza.

Una preparazione adeguata e un'elevata Affinità con gli altri membri possono ridurre i suoi problemi.

---

### `VISIONARY` — Il Visionario

Il Visionario è orientato alla sperimentazione e alla ricerca di nuove idee.

È caratterizzato da:

* creatività elevata;
* interesse per suoni insoliti;
* desiderio di innovare;
* propensione a cambiare arrangiamenti;
* scarsa tolleranza verso la ripetizione.

Può contribuire alla creazione di brani originali e aumentare la reputazione artistica della band.

Può però generare conflitti quando:

* gli altri membri preferiscono formule più tradizionali;
* la band deve rispettare una scaletta rigida;
* le prove vengono considerate troppo ripetitive;
* le sue idee vengono rifiutate.

Il Visionario può quindi aumentare il potenziale creativo, ma anche la Tensione Artistica.

---

### `NATURAL_LEADER` — Il Leader Naturale

Il Leader Naturale tende spontaneamente a prendere il controllo delle decisioni.

È caratterizzato da:

* forte iniziativa;
* capacità organizzativa;
* sicurezza;
* propensione a guidare gli altri;
* desiderio di avere un ruolo centrale.

Può migliorare:

* coordinamento delle prove;
* puntualità;
* organizzazione dei concerti;
* gestione delle emergenze;
* disciplina della formazione.

Può però entrare in conflitto con Alex o con altri membri dotati di un forte Ego.

Se il suo ruolo non viene riconosciuto, può sviluppare frustrazione e aumentare la Tensione Interna.

---

### `LONE_WOLF` — Il Solitario

Il Solitario preferisce lavorare in autonomia e mantiene una certa distanza dagli altri membri.

È caratterizzato da:

* indipendenza;
* scarsa necessità di socializzare;
* concentrazione sul proprio ruolo;
* difficoltà nelle attività di gruppo;
* ridotta partecipazione alla vita sociale della band.

Può essere molto produttivo durante:

* studio individuale;
* composizione;
* preparazione tecnica;
* registrazioni separate.

Tuttavia, può sviluppare una bassa Affinità se viene costretto a partecipare continuamente ad attività collettive.

Il Solitario non crea necessariamente conflitti diretti, ma può rendere più difficile costruire una forte coesione umana.

---

### `DIPLOMAT` — Il Diplomatico

Il Diplomatico è particolarmente efficace nella gestione dei conflitti.

È caratterizzato da:

* capacità di ascolto;
* pazienza;
* equilibrio;
* disponibilità al compromesso;
* attenzione alle esigenze degli altri.

Può contribuire a:

* ridurre la Tensione;
* migliorare l'Affinità;
* facilitare le discussioni;
* evitare che piccoli problemi diventino conflitti gravi;
* mediare tra membri incompatibili.

Il suo contributo musicale potrebbe non essere eccezionale, ma la sua presenza può aumentare la stabilità complessiva della formazione.

---

### `COMPETITIVE` — Il Competitivo

Il Competitivo vuole sempre dimostrare di essere il migliore.

È caratterizzato da:

* forte ambizione;
* desiderio di primeggiare;
* elevata motivazione;
* confronto costante con gli altri;
* reazione negativa alle sconfitte.

Può aumentare il livello generale della band perché spinge gli altri membri a migliorare.

Può però generare problemi quando:

* un altro membro riceve più attenzione;
* commette un errore davanti al pubblico;
* perde un confronto musicale;
* viene escluso da una parte importante del brano.

Il Competitivo può aumentare il Rispetto Musicale, ma anche la Tensione tra membri rivali.

---

### `PEACEMAKER` — Il Pacificatore

Il Pacificatore cerca di mantenere un ambiente sereno e collaborativo.

È caratterizzato da:

* atteggiamento positivo;
* disponibilità ad aiutare;
* bassa aggressività;
* capacità di incoraggiare gli altri;
* forte attenzione al morale del gruppo.

Può ridurre gli effetti negativi di:

* concerti falliti;
* critiche;
* stanchezza;
* discussioni;
* periodi di scarso successo.

Il rischio è che possa evitare i problemi invece di affrontarli direttamente, lasciando irrisolti i conflitti più profondi.

---

### `INNOVATOR` — L'Innovatore Tecnico

L'Innovatore è interessato soprattutto alla tecnologia e alla sperimentazione degli strumenti.

È caratterizzato da:

* interesse per effetti e attrezzatura;
* attenzione alla qualità del suono;
* entusiasmo per nuove tecnologie;
* capacità di migliorare setup e arrangiamenti;
* propensione a modificare continuamente la strumentazione.

Può migliorare:

* qualità delle registrazioni;
* resa sonora live;
* efficienza dello studio;
* valore tecnico dei brani.

Può però aumentare i costi della band e creare tensione quando gli altri membri considerano inutili o troppo costosi i suoi investimenti.

---

### `FAME_HUNGRY` — L'Assetato di Fama

L'Assetato di Fama è motivato principalmente dalla popolarità e dalla visibilità pubblica.

È caratterizzato da:

* forte desiderio di successo;
* attenzione ai social;
* interesse per interviste e apparizioni;
* bisogno di riconoscimento;
* ambizione elevata.

Può aumentare:

* promozione della band;
* coinvolgimento del pubblico;
* presenza sui social;
* opportunità commerciali;
* interesse dei media.

Può però diventare frustrato se:

* la band rimane sconosciuta;
* riceve poca attenzione;
* un altro membro diventa il volto principale del gruppo;
* la crescita della popolarità è troppo lenta.

---

### `TRADITIONALIST` — Il Tradizionalista

Il Tradizionalista preferisce metodi collaudati e generi musicali riconoscibili.

È caratterizzato da:

* rispetto per la tradizione;
* disciplina;
* preferenza per strutture musicali classiche;
* diffidenza verso i cambiamenti improvvisi;
* forte coerenza artistica.

Può aumentare la stabilità del sound della band e ridurre gli errori durante le esibizioni.

Può però entrare in conflitto con:

* Visionari;
* Innovatori;
* membri che vogliono cambiare genere;
* proposte troppo sperimentali.

La sua presenza può rendere la band più coerente, ma meno flessibile.

---

### `EMOTIONAL` — L'Emotivo

L'Emotivo vive la musica in modo molto intenso e personale.

È caratterizzato da:

* forte sensibilità;
* grande coinvolgimento nei testi;
* reazioni emotive agli eventi;
* capacità di trasmettere sentimenti al pubblico;
* vulnerabilità alle critiche.

Può aumentare l'impatto emotivo delle performance e migliorare la connessione con il pubblico.

Può però subire fortemente:

* recensioni negative;
* litigi;
* concerti falliti;
* rifiuto delle proprie idee;
* perdita di un membro della band.

La sua stabilità dipende molto dall'Affinità e dal supporto degli altri componenti.

---

### `WORKAHOLIC` — Il Maniaco del Lavoro

Il Maniaco del Lavoro vuole provare, registrare e migliorare continuamente.

È caratterizzato da:

* grande disciplina;
* elevata produttività;
* disponibilità a fare ore extra;
* forte orientamento al risultato;
* difficoltà a concedersi pause.

Può aumentare rapidamente:

* XP della band;
* preparazione;
* qualità delle registrazioni;
* Sinergia Palco.

Tuttavia, può accumulare Stress e generare conflitti con i membri che preferiscono un ritmo più rilassato.

Se la band non segue i suoi standard di impegno, può diventare impaziente o critico.

---

### `FREE_SPIRIT` — Lo Spirito Libero

Lo Spirito Libero rifiuta regole rigide e strutture troppo organizzate.

È caratterizzato da:

* spontaneità;
* creatività improvvisa;
* comportamento imprevedibile;
* forte individualità;
* difficoltà a rispettare programmi fissi.

Può produrre momenti musicali originali e performance memorabili.

Può però causare:

* ritardi;
* cambiamenti improvvisi;
* problemi con la scaletta;
* difficoltà durante le prove;
* incomprensioni con i membri più disciplinati.

La sua presenza aumenta la varietà della band, ma riduce la prevedibilità della gestione quotidiana.

---

### `MENTOR` — Il Mentore

Il Mentore tende ad aiutare e formare i membri meno esperti.

È caratterizzato da:

* pazienza;
* esperienza;
* disponibilità a insegnare;
* atteggiamento protettivo;
* forte senso di responsabilità.

Può aumentare la crescita degli altri membri durante:

* prove;
* sessioni individuali;
* registrazioni;
* preparazione dei concerti.

Può però diventare frustrato se gli altri non ascoltano i suoi consigli o se il suo contributo viene ignorato.

La sua presenza è particolarmente utile nelle formazioni composte da membri con livelli di esperienza molto diversi.

---

### `REBEL` — Il Ribelle

Il Ribelle mette in discussione le regole e l'autorità.

È caratterizzato da:

* forte indipendenza;
* rifiuto delle imposizioni;
* atteggiamento provocatorio;
* desiderio di distinguersi;
* scarsa tolleranza verso il controllo.

Può spingere la band a prendere decisioni coraggiose e a evitare la stagnazione.

Può però aumentare la Tensione quando:

* Alex impone troppe regole;
* la band segue una direzione troppo commerciale;
* gli altri membri non accettano le sue idee;
* viene escluso dalle decisioni importanti.

Il Ribelle può essere una fonte di innovazione, ma anche di instabilità.

---

## 3.2.6 Elenco aggiornato delle personalità

Il sistema può quindi includere almeno le seguenti personalità:

1. `RELIABLE` — L'Affidabile
2. `PERFECTIONIST` — Il Perfezionista
3. `WILD_PARTY` — L'Animale da Festa
4. `EGO_ARTIST` — L'Ego Smisurato
5. `MERCENARY` — Il Mercenario
6. `STAGE_ANXIOUS` — L'Ansioso da Palco
7. `VISIONARY` — Il Visionario
8. `NATURAL_LEADER` — Il Leader Naturale
9. `LONE_WOLF` — Il Solitario
10. `DIPLOMAT` — Il Diplomatico
11. `COMPETITIVE` — Il Competitivo
12. `PEACEMAKER` — Il Pacificatore
13. `INNOVATOR` — L'Innovatore Tecnico
14. `FAME_HUNGRY` — L'Assetato di Fama
15. `TRADITIONALIST` — Il Tradizionalista
16. `EMOTIONAL` — L'Emotivo
17. `WORKAHOLIC` — Il Maniaco del Lavoro
18. `FREE_SPIRIT` — Lo Spirito Libero
19. `MENTOR` — Il Mentore
20. `REBEL` — Il Ribelle

Queste personalità permettono di creare formazioni molto diverse tra loro, con combinazioni capaci di influenzare:

* Affinità;
* Rispetto;
* Tensione;
* XP della band;
* qualità delle prove;
* Sinergia Palco;
* stabilità economica;
* creatività;
* popolarità;
* gestione degli eventi relazionali.

Le personalità dovrebbero essere trattate come sistemi comportamentali, non come semplici bonus permanenti. Ogni profilo dovrebbe avere condizioni nelle quali eccelle e situazioni nelle quali può creare problemi alla formazione.

---

### 3.2.1 RELIABLE — L'Affidabile

L'Affidabile rappresenta il membro più stabile della formazione.

È caratterizzato da:

* comportamento calmo;
* puntualità;
* affidabilità;
* basso livello di conflittualità;
* atteggiamento collaborativo.

La sua presenza contribuisce a mantenere stabile il gruppo e a ridurre la tensione interna.

In termini di gameplay, rappresenta un membro sul quale il giocatore può fare affidamento durante:

* prove;
* registrazioni;
* concerti;
* trasferte;
* periodi di forte stress.

Il suo contributo principale non è necessariamente un aumento diretto della qualità musicale, ma la **stabilità della formazione**.

---

### 3.2.2 PERFECTIONIST — Il Perfezionista

Il Perfezionista è un musicista estremamente attento alla qualità dell'esecuzione.

La sua presenza può aumentare la qualità delle performance:

* in studio;
* durante le prove;
* nei concerti live.

Il rovescio della medaglia è rappresentato dalla maggiore sensibilità agli errori e alla preparazione insufficiente.

Se la band:

* sbaglia frequentemente;
* prova poco;
* affronta un concerto senza preparazione;
* mantiene standard qualitativi inferiori alle aspettative;

il Perfezionista può accumulare tensione.

Questa personalità introduce quindi un rapporto diretto tra **qualità richiesta** e **stabilità emotiva** del membro.

---

### 3.2.3 WILD_PARTY — L'Animale da Festa

L'Animale da Festa è il membro più orientato alla vita sociale e alla dimensione spettacolare della carriera.

È caratterizzato da:

* forte carisma;
* elevata energia sul palco;
* capacità di trascinare il pubblico;
* propensione alla vita notturna.

Il suo comportamento può però creare problemi organizzativi.

Tra i possibili rischi:

* ritardi;
* postumi da alcol;
* mancata puntualità alle prove;
* imprevisti;
* conseguenze negative legate alla vita notturna.

Questa personalità crea quindi un compromesso tra:

**maggiore energia e carisma live**

e

**maggiore imprevedibilità nella gestione quotidiana**.

---

### 3.2.4 EGO_ARTIST — L'Ego Smisurato

L'Ego Smisurato rappresenta un musicista con un livello tecnico molto elevato, ma con esigenze personali altrettanto importanti.

Può essere particolarmente sensibile a:

* posizione nella scaletta;
* visibilità;
* attenzione del pubblico;
* ruolo creativo;
* compensi;
* riconoscimento del proprio contributo.

Può inoltre manifestare gelosia nei confronti del leader o degli altri membri che ricevono maggiore attenzione.

Questa personalità introduce quindi un rapporto diretto tra **talento individuale** e **gestione dell'ego**.

Un membro estremamente talentuoso può essere una risorsa musicale importante, ma allo stesso tempo aumentare la complessità della gestione della band.

---

## 3.2.5 Personalità e comportamento della band

Le personalità diventano particolarmente importanti quando vengono combinate tra loro.

La stessa formazione può quindi avere comportamenti molto diversi a seconda dei membri presenti.

Esempio concettuale:

**Affidabile + Perfezionista**

→ formazione disciplinata e orientata alla qualità.

**Affidabile + Animale da Festa**

→ equilibrio tra stabilità e vita sociale.

**Perfezionista + Ego Smisurato**

→ elevato potenziale musicale, ma maggiore rischio di tensioni.

**Animale da Festa + Ego Smisurato**

→ formazione molto carismatica ma potenzialmente difficile da gestire.

La personalità di ogni membro deve quindi essere considerata insieme alle caratteristiche degli altri componenti.

---

# Direttrici di Espansione & Idee di Gameplay

### Nuove personalità

In futuro potranno essere aggiunti ulteriori archetipi, ad esempio:

* **Il Mercenario** — interessato principalmente al denaro;
* **L'Ansioso da Palco** — particolarmente vulnerabile alla pressione dei grandi concerti;
* **Il Visionario** — fortemente orientato alla sperimentazione;
* **Il Leader Naturale** — tende a voler prendere decisioni per il gruppo;
* **Il Solitario** — preferisce lavorare individualmente;
* **Il Diplomatico** — particolarmente efficace nella gestione dei conflitti.

Questi profili dovrebbero introdurre comportamenti differenti, evitando semplici bonus numerici.

---

### Eventi relazionali

Una futura espansione potrebbe introdurre eventi casuali tra i membri.

Esempi:

* due membri diventano particolarmente amici;
* due membri entrano in conflitto;
* nasce una relazione sentimentale;
* un membro si sente escluso;
* gelosia per la popolarità di un altro componente;
* discussioni per questioni economiche;
* amicizie nate durante un tour.

Questi eventi potrebbero modificare **Affinità, Rispetto e Tensione** e collegarsi direttamente al sistema descritto nella sezione 3.3.

---

## Decisioni confermate

* Ogni membro possiede una personalità tramite `Enums.BandPersonality`.
* Sono attualmente presenti quattro personalità.
* `RELIABLE` privilegia stabilità e affidabilità.
* `PERFECTIONIST` privilegia la qualità ma può accumulare tensione.
* `WILD_PARTY` aumenta il potenziale spettacolare ma introduce imprevedibilità.
* `EGO_ARTIST` combina elevato talento tecnico con maggiori esigenze personali.
* Le personalità devono interagire con la gestione complessiva della band.
* Sono previste future personalità aggiuntive.
* Sono previsti futuri eventi relazionali casuali.

## Spazio per i dettagli di Luca

-----------------------------------------------------------------------------------------------------------------------------


### 3.3 Indicatori Vitali di Gruppo: Affinità, Rispetto & Tensione Critica
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - I 3 indicatori [0 - 100%]:
    - Affinità Umana (La chimica personale e l'amicizia tra i membri).
    - Rispetto Musicale (La stima professionale verso le capacità di Alex e degli altri).
    - Tensione Interna (Il livello di attrito e conflittualità).
  - Soglie di tensione:
    - Livello Sicuro: < 40% (`BAND_TENSION_SAFE`).
    - Livello di Allerta: > 70% (`BAND_TENSION_WARNING`).
    - Livello Critico: > 85% (`BAND_TENSION_CRITICAL`). A questo livello, ogni evento negativo o concerto andato male può innescare l'abbandono immediato del membro.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Riunioni di chiarimento e cene di gruppo per sbollire la rabbia e riconciliare i membri prima di un tour.
  - Ultimatum posti dai membri ("O cacci lui, o me ne vado io").
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 3.4 Prove di Gruppo, Sala Prove Insonorizzata & Sinergia Live
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Metodo `hold_rehearsal_session()` in `BandSystem`:
    - Consumo energia di Alex: 15 punti.
    - Generazione stress legata all'insonorizzazione della sala: Garage +10 stress, Pannelli base +7, Isolamento pro +4, Master Studio 0 stress.
    - Incremento Affinità (+3/+5), incremento Rispetto (+4/+6), riduzione drastica della Tensione (-8/-15 punti).
  - Moltiplicatore speciale al Mercoledì: +20% guadagno XP per la band (`Constants.WEDNESDAY_BAND_XP_MULT`).
  - Sinergia Palco: Valore dinamico calcolato da [-15% a +25%] che va a moltiplicare il punteggio complessivo dei concerti dal vivo.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Creazione di cori e armonie vocali durante le prove.
  - Sessioni di composizione collettiva dove la band contribuisce alla stesura di nuovi pezzi.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
  - ## 3.4 Prove di Gruppo, Sala Prove Insonorizzata & Sinergia Live

Le **prove di gruppo** rappresentano il principale strumento attraverso cui la band migliora la propria preparazione musicale e rafforza i rapporti interni.

Il sistema è implementato all'interno di `BandSystem` attraverso il metodo:

`hold_rehearsal_session()`

Una sessione di prova produce contemporaneamente effetti su:

* Energia;
* Stress;
* Affinità;
* Rispetto;
* Tensione;
* esperienza/XP della band;
* futura efficacia nelle performance live.

La prova non deve quindi essere considerata solamente come un'attività per aumentare l'esperienza musicale: rappresenta un'attività di **preparazione e consolidamento della formazione**.

---

## 3.4.1 Costo energetico della prova

Una sessione di prova comporta un consumo di:

**15 punti Energia di Alex**

Questo costo rappresenta l'impegno fisico e mentale richiesto dalla sessione.

La prova deve quindi essere inserita nella gestione generale delle risorse vitali del protagonista.

Il giocatore deve bilanciare:

**Prove → miglioramento della band**

con:

**Prove → consumo di Energia**

---

## 3.4.2 Sala prove e insonorizzazione

Il livello della sala prove influenza lo **Stress generato durante la sessione**.

Sono presenti quattro livelli di insonorizzazione:

| Sala                         | Stress generato |
| ---------------------------- | --------------: |
| **Garage**                   |             +10 |
| **Pannelli base**            |              +7 |
| **Isolamento professionale** |              +4 |
| **Master Studio**            |               0 |

Una sala migliore permette quindi di effettuare sessioni più confortevoli e riduce il costo psicologico della prova.

Il percorso di miglioramento è:

**Garage → Pannelli base → Isolamento pro → Master Studio**

L'investimento nella sala prove rappresenta quindi un miglioramento infrastrutturale con effetti diretti sulla gestione delle risorse vitali.

---

## 3.4.3 Effetti sulla coesione della band

Una sessione di prova non produce solamente esperienza musicale.

In base alla configurazione della sessione, può generare:

* **Affinità +3 / +5**
* **Rispetto +4 / +6**
* **Tensione -8 / -15**

Le prove rappresentano quindi uno dei principali strumenti attraverso cui il giocatore può migliorare contemporaneamente i rapporti interni della formazione.

Il principio è:

> **Una band che suona insieme impara a suonare insieme.**

La pratica permette infatti ai membri di conoscersi meglio, sincronizzarsi e costruire una maggiore fiducia reciproca.

---

## 3.4.4 Bonus del Mercoledì

Il sistema prevede un bonus speciale per le sessioni effettuate il **Mercoledì**.

Costante:

`Constants.WEDNESDAY_BAND_XP_MULT`

Il bonus aumenta del **20% il guadagno di XP della band**.

Il Mercoledì diventa quindi una giornata particolarmente interessante per programmare le prove.

Questa meccanica si collega al sistema generale del calendario e introduce una piccola componente di pianificazione:

**Mercoledì → prova → +20% XP**

---

## 3.4.5 Sinergia Palco

La preparazione della band viene trasferita direttamente alle performance live attraverso il parametro **Sinergia Palco**.

La Sinergia Palco è un valore dinamico compreso tra:

**-15% → +25%**

Il valore viene applicato come moltiplicatore al punteggio complessivo dei concerti dal vivo.

Una band ben preparata e affiatata può quindi ottenere un risultato migliore durante un concerto, mentre una formazione poco sincronizzata può subire una penalizzazione.

Il concetto fondamentale è:

> **Il talento dei singoli musicisti non è sufficiente: la band deve imparare a suonare come un'unica formazione.**

---

## 3.4.6 Collegamento tra prove e concerto

Il ciclo generale diventa:

**Prova**

→ XP Band ↑

→ Affinità ↑

→ Rispetto ↑

→ Tensione ↓

→ preparazione ↑

→ **Sinergia Palco ↑**

→ **Punteggio Concerto modificato**

Le prove assumono quindi un valore strategico soprattutto prima di:

* concerti importanti;
* grandi venue;
* tour;
* eventi speciali;
* registrazioni importanti.

Il giocatore deve decidere quanto tempo e quante risorse investire nella preparazione della band.

---

# Direttrici di Espansione & Idee di Gameplay

### Cori e armonie vocali

Le prove potrebbero permettere alla band di sviluppare:

* cori;
* seconde voci;
* armonizzazioni;
* intro vocali;
* finali corali.

Queste caratteristiche potrebbero successivamente influenzare la qualità delle registrazioni e delle esibizioni live.

---

### Composizione collettiva

Una futura espansione potrebbe permettere alla band di lavorare insieme alla scrittura di nuovi brani.

Ogni membro potrebbe contribuire con competenze differenti:

* riff;
* melodie;
* testi;
* arrangiamenti;
* armonie;
* produzione.

Questo permetterebbe di introdurre il concetto di **brano nato dalla band**, distinguendolo dalle canzoni composte principalmente da Alex.

---

### Prove speciali prima dei grandi concerti

In futuro potrebbero essere introdotte sessioni di preparazione dedicate a un evento specifico.

Esempio:

**Grande concerto tra 2 giorni**

→ prova generale

→ consumo maggiore di Energia

→ aumento della preparazione

→ possibile incremento della Sinergia Palco

→ esibizione.

Questo renderebbe la preparazione un elemento strategico della pianificazione della carriera.

---

## Decisioni confermate

* Il sistema delle prove è gestito da `BandSystem`.
* Il metodo utilizzato è `hold_rehearsal_session()`.
* Una prova consuma **15 Energia** di Alex.
* Lo Stress generato dipende dal livello di insonorizzazione della sala:

  * Garage: +10;
  * Pannelli base: +7;
  * Isolamento pro: +4;
  * Master Studio: 0.
* Le prove aumentano l'Affinità di **+3/+5**.
* Le prove aumentano il Rispetto di **+4/+6**.
* Le prove riducono la Tensione di **-8/-15**.
* Il Mercoledì è presente un bonus del **+20% agli XP della band** tramite `WEDNESDAY_BAND_XP_MULT`.
* La Sinergia Palco varia tra **-15% e +25%**.
* La Sinergia Palco modifica il punteggio complessivo dei concerti.
* Sono previste future meccaniche per cori, armonie e composizione collettiva.



### 3.5 Politiche di Incasso (Revenue Split) & Riconoscimenti
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Le 3 politiche in `Enums.RevenueSplit`:
    1. `EQUAL_SPLIT` (Paritaria): 25% a testa su tutti i membri. Genera rispetto e abbassa la tensione, ma riduce il guadagno netto di Alex.
    2. `LEADER_BALANCED` (Equilibrata): 40% ad Alex (fondatore/leader) e 20% a ciascuno dei 3 compagni. Assetto stabile e generalmente accettato.
    3. `LEADER_PREDATORY` (Predatoria): 70% ad Alex e 10% a testa ai compagni. Massimizza i profitti del leader, ma genera accumulo continuo di tensione e malcontento.
  - Applicata automaticamente su: incassi dei concerti, royalties degli album, vendite merch e anticipi discografici.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Ripartizione personalizzata percentuale per ciascun membro in base all'anzianità nel gruppo.
  - Sciopero della band se la politica predatoria viene mantenuta troppo a lungo con contratti importanti.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
  - ## 3.5 Politiche di Incasso (Revenue Split) & Riconoscimenti

La gestione economica della band non riguarda solamente quanto denaro viene generato, ma anche **come gli incassi vengono distribuiti tra i membri**.

Il sistema `RevenueSplit` permette al giocatore di scegliere una politica economica per la formazione.

La scelta ha conseguenze che vanno oltre il semplice guadagno individuale di Alex: influenza infatti anche il **Rispetto, la Tensione Interna e la stabilità della band**.

Le tre politiche sono definite attraverso `Enums.RevenueSplit`.

---

## 3.5.1 EQUAL_SPLIT — Politica Paritaria

La politica **Paritaria** prevede una divisione completamente equa degli incassi.

Con una formazione completa di quattro membri:

| Membro     | Percentuale |
| ---------- | ----------: |
| Alex       |         25% |
| Compagno 1 |         25% |
| Compagno 2 |         25% |
| Compagno 3 |         25% |

Ogni membro riceve quindi la stessa quota.

### Effetti principali

**Vantaggi:**

* elevato senso di equità;
* maggiore riconoscimento dei membri;
* aumento del Rispetto;
* riduzione della Tensione;
* forte stabilità interna.

**Svantaggio:**

* Alex riceve una quota inferiore rispetto alle politiche nelle quali, in quanto fondatore/leader, mantiene una percentuale maggiore.

Questa politica rappresenta una band nella quale il progetto musicale viene considerato un'impresa realmente condivisa.

---

## 3.5.2 LEADER_BALANCED — Politica Equilibrata

La politica **Equilibrata** riconosce ad Alex una quota maggiore in quanto fondatore e leader, mantenendo comunque una distribuzione significativa per gli altri membri.

La ripartizione è:

| Membro     | Percentuale |
| ---------- | ----------: |
| Alex       |         40% |
| Compagno 1 |         20% |
| Compagno 2 |         20% |
| Compagno 3 |         20% |

Il totale è quindi:

**40% + 20% + 20% + 20% = 100%**

### Effetti principali

* Alex mantiene una quota superiore;
* i membri ricevono comunque una percentuale significativa;
* la struttura viene considerata generalmente stabile;
* rappresenta un compromesso tra leadership e partecipazione economica.

Questa politica costituisce quindi un modello intermedio tra la completa parità e una forte concentrazione dei ricavi sul leader.

---

## 3.5.3 LEADER_PREDATORY — Politica Predatoria

La politica **Predatoria** concentra la maggior parte degli introiti sul leader.

La ripartizione è:

| Membro     | Percentuale |
| ---------- | ----------: |
| Alex       |         70% |
| Compagno 1 |         10% |
| Compagno 2 |         10% |
| Compagno 3 |         10% |

Totale:

**70% + 10% + 10% + 10% = 100%**

### Effetti principali

Il principale vantaggio è economico:

* Alex massimizza il proprio guadagno personale;
* il leader può accumulare più rapidamente capitale da reinvestire nella propria carriera.

La conseguenza è però un progressivo deterioramento dei rapporti interni:

* aumento della Tensione;
* malcontento dei membri;
* possibile diminuzione della stabilità della band;
* maggiore probabilità di conflitti futuri.

La politica predatoria introduce quindi un vero **trade-off economico**:

> **più denaro immediato per Alex → maggiore costo relazionale nel lungo periodo.**

---

## 3.5.4 Entrate soggette al Revenue Split

La politica selezionata viene applicata automaticamente alle principali entrate generate dalla band.

Attualmente comprende:

### Incassi dei concerti

Il ricavo generato da una performance live viene suddiviso secondo il `RevenueSplit` attivo.

### Royalties degli album

Le royalties generate dalle pubblicazioni della band vengono distribuite secondo la stessa politica.

### Vendite Merch

Gli introiti derivanti dal merchandising vengono sottoposti alla ripartizione prevista.

### Anticipi discografici

Gli anticipi ricevuti attraverso accordi discografici vengono anch'essi distribuiti secondo il modello economico della band.

Il principio generale è:

**Entrata della Band → Revenue Split → Quota individuale → Accredito**

In questo modo il giocatore non deve effettuare manualmente la divisione per ogni fonte di reddito.

---

## 3.5.5 Revenue Split e stabilità della Band

Il `RevenueSplit` deve essere considerato insieme agli indicatori descritti nella sezione 3.3.

In particolare:

**Politica economica → percezione di equità → Tensione → stabilità della formazione**

Una politica percepita come equa può contribuire alla stabilità del gruppo, mentre una distribuzione fortemente sbilanciata può creare progressivamente malcontento.

Il sistema introduce quindi una conseguenza importante:

> **La massimizzazione del profitto personale non è necessariamente priva di costi.**

Il giocatore deve decidere quale rapporto desidera instaurare con i propri compagni e accettare le conseguenze economiche e relazionali della scelta.

---

## 3.5.6 Riconoscimento del contributo dei membri

La distribuzione economica è inoltre collegata al concetto di **riconoscimento**.

Un membro che contribuisce alla crescita della band può considerare la propria quota economica come una forma di riconoscimento del proprio valore.

Questo diventa particolarmente importante per personalità come:

* **Ego Artist**, sensibile alla propria posizione e al riconoscimento;
* **Perfezionista**, orientato alla qualità e al contributo professionale.

Una politica economica molto sbilanciata può quindi avere conseguenze differenti a seconda della personalità del membro.

---

# Direttrici di Espansione & Idee di Gameplay

### Ripartizione personalizzata

Una futura versione potrebbe permettere al giocatore di definire manualmente la percentuale di ogni membro.

Esempio:

**Alex 45% — Bassista 25% — Batterista 20% — Tastierista 10%**

Il sistema dovrebbe comunque verificare che:

**Somma delle percentuali = 100%**

La quota potrebbe inoltre essere negoziata individualmente con ciascun membro.

---

### Anzianità nel gruppo

La percentuale potrebbe tenere conto dell'**anzianità** del musicista.

Un membro presente nella band da molti anni potrebbe avere maggiore potere contrattuale rispetto a un musicista appena reclutato.

Questo introdurrebbe una progressione interna:

**Nuovo membro → quota iniziale**

↓

**Anni nella band → maggiore esperienza/riconoscimento**

↓

**Nuova negoziazione del contratto**

---

### Sciopero della Band

Una futura espansione potrebbe introdurre lo **sciopero della band**.

Se una politica fortemente sbilanciata viene mantenuta per troppo tempo, soprattutto durante una fase di grande successo economico, i membri potrebbero decidere di sospendere temporaneamente le attività.

Possibili conseguenze:

* concerti rinviati;
* sessioni di registrazione bloccate;
* aumento della Tensione;
* richiesta di rinegoziazione;
* rischio di abbandono.

Questo trasformerebbe il Revenue Split in una vera meccanica di **gestione contrattuale della band**.

---

## Decisioni confermate

* Il sistema utilizza `Enums.RevenueSplit`.
* Sono presenti tre politiche:

  * `EQUAL_SPLIT`;
  * `LEADER_BALANCED`;
  * `LEADER_PREDATORY`.
* `EQUAL_SPLIT`: **25% a testa**.
* `LEADER_BALANCED`: **40% Alex + 20% ciascun compagno**.
* `LEADER_PREDATORY`: **70% Alex + 10% ciascun compagno**.
* Le percentuali vengono applicate automaticamente alle entrate della band.
* Le entrate attualmente interessate sono:

  * concerti;
  * royalties degli album;
  * merchandising;
  * anticipi discografici.
* La politica economica influenza anche gli equilibri interni della formazione.
* La politica predatoria genera un accumulo di Tensione e malcontento.
* Sono previste future ripartizioni personalizzate.
* È prevista una futura meccanica di anzianità e rinegoziazione.
* È previsto un possibile sistema di sciopero della band.


-----------------------------------------------------------------------------------------------------------------------------

