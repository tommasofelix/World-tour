# Bozza V1

Perfetto. Costruiamo il GDD come **documento di riferimento vero e proprio**, ma volutamente modulare: deve essere abbastanza preciso da permetterci di trasformarlo in software, senza decidere oggi ogni singolo dettaglio che magari tra due settimane vorremo cambiare.

# **🎸 GAME DESIGN DOCUMENT — *Music Career Simulator***

**Versione:** 0.1 — Concept & Design  
**Genere:** Management / Life Simulation / Music Career  
**Modalità:** Single player  
**Piattaforma iniziale:** PC  
**Tecnologia prevista:** Python, con interfaccia grafica da definire  
**Obiettivo finale:** partire da artista sconosciuto e costruire una carriera musicale fino a diventare una superstar mondiale.

---

# **1\. CONCEPT**

## **1.1 High Concept**

Il giocatore interpreta un aspirante musicista che parte praticamente da zero e deve costruire la propria carriera musicale.

Può:

* scegliere dove iniziare;  
* scegliere il proprio strumento/ruolo;  
* sviluppare le proprie abilità;  
* creare musica;  
* definire progressivamente il proprio stile;  
* trovare altri musicisti;  
* fondare una band;  
* esibirsi dal vivo;  
* pubblicare singoli, EP e album;  
* costruire una fanbase;  
* gestire soldi e reputazione;  
* affrontare eventi e imprevisti;  
* espandersi in nuovi mercati;  
* diventare infine una superstar internazionale.

Il punto fondamentale è:

> **Il gioco non impone al giocatore quale artista diventare.**

Un giocatore può partire in Italia e diventare una rockstar mondiale.

Un altro può iniziare in Brasile e diventare un artista metal.

Un altro ancora può partire negli USA e trasformarsi in un artista pop/elettronico.

Il mondo influenza il punto di partenza, **non il destino**.

---

# **2\. FANTASIA DEL GIOCATORE**

Il giocatore deve percepire di vivere una vera carriera musicale.

La progressione ideale è:

NESSUNO  
   ↓  
Musicista amatoriale  
   ↓  
Artista emergente  
   ↓  
Artista locale  
   ↓  
Artista nazionale  
   ↓  
Artista internazionale  
   ↓  
Star mondiale  
   ↓  
SUPERSTAR

Il gioco deve permettere di guardare indietro e pensare:

> "Sono partito suonando davanti a 30 persone in un pub e ora sto facendo un tour mondiale."

Questa **sensazione di crescita** è uno dei pilastri del progetto.

---

# **3\. OBIETTIVO DEL GIOCATORE**

## **Obiettivo principale**

Raggiungere lo status di:

# **🌎 SUPERSTAR MONDIALE**

Per farlo il giocatore dovrà sviluppare contemporaneamente diverse dimensioni della carriera:

* abilità musicale;  
* qualità delle canzoni;  
* fanbase;  
* popolarità;  
* reputazione;  
* successo commerciale;  
* presenza internazionale;  
* capacità di organizzare una carriera professionale.

Non sarà sufficiente semplicemente accumulare denaro.

---

# **4\. CORE GAMEPLAY LOOP**

Il cuore del gioco sarà un ciclo ripetibile:

      PIANIFICA  
           ↓  
        AZIONE  
           ↓  
   ┌───────┼────────┐  
   ↓       ↓        ↓  
 TRAIN   CREATE    PERFORM  
   │       │        │  
   └───────┼────────┘  
           ↓  
        RISULTATO  
           ↓  
     SOLDI / FAN / XP  
           ↓  
       PROGRESSIONE  
           ↓  
       NUOVE OPPORTUNITÀ  
           ↓  
        PIANIFICA

Esempio concreto:

> Allenamento → aumenta Guitar Skill

↓

> Scrivi canzone → crei un brano

↓

> Prove → migliori la performance

↓

> Concerto → guadagni soldi \+ fan

↓

> Nuovi fan → maggiore popolarità

↓

> Puoi accedere a un locale più grande

↓

> Concerto più grande

↓

> più soldi/fan

↓

> puoi investire nella carriera.

---

# **5\. SISTEMA DEL TEMPO**

Sì, secondo me è **molto più interessante** del sistema "1 azione \= 1 giorno". In questo modo il tempo diventa una vera risorsa che il giocatore deve gestire, e soprattutto permette di creare una simulazione molto più naturale.

La inserirei nel GDD come un sistema fondamentale.

# **⏱️ Sistema di gestione del tempo**

## **1\. Concetto**

Ogni giornata di gioco ha una durata limitata in **tempo reale simulato**.

Per la prima versione possiamo impostare:

> **1 giornata \= 10 minuti di gioco**

Il giocatore parte, ad esempio, alle:

**08:00**

e ha a disposizione **10 minuti reali/simulati** prima della fine della giornata.

Ogni azione consuma una quantità specifica di tempo.

Quindi il giocatore deve decidere:

> **Come utilizzo i miei 10 minuti?**

---

# **2\. Il tempo è una risorsa**

Il tempo non viene consumato solamente dalle attività principali.

Viene consumato da **tutto ciò che il personaggio fa**:

🏠 Casa

 ↓

🚲 Viaggio

 ↓

🎸 Allenamento

 ↓

🚶 Spostamento

 ↓

🎧 Studio

 ↓

🚌 Viaggio

 ↓

🎤 Concerto

 ↓

🚶 Ritorno a casa

Ogni passaggio consuma tempo.

Questo significa che anche la **posizione del personaggio** diventa importante.

---

# **3\. Esempio di giornata**

Supponiamo:

> Giorno 12  
> Ore 08:00  
> Tempo disponibile: **10:00**

Il giocatore vuole andare in studio.

### **🏠 Casa → Studio**

Può scegliere:

| Trasporto | Tempo |
| ----- | ----- |
| 🚶 Piedi | 1:50 |
| 🚲 Bici | 1:30 |
| 🚌 Bus | 0:50 |
| 🚕 Taxi | 0:30 |
| 🚗 Auto | 0:35 |

Naturalmente i valori sono esempi e potranno dipendere dalla distanza e dalla città.

Il giocatore sceglie:

> 🚌 Bus → **50 secondi**

Tempo rimanente:

**9:10**

---

# **4\. Attività con durata diversa**

Una stessa attività può avere diverse modalità.

### **🎸 Studio dello strumento**

**Studio leggero**

> 10 secondi

XP: \+10

---

**Studio normale**

> 25 secondi

XP: \+25

---

**Studio attento**

> 40 secondi

XP: \+45

---

**Allenamento intensivo**

> 1:20

XP: \+100

Ma l'allenamento più lungo potrebbe consumare più:

* energia;  
* concentrazione;  
* morale;  
* ecc.

Quindi non basta scegliere sempre quello che dà più XP.

---

# **5\. Questo crea una scelta strategica**

Immaginiamo che siano le:

**17:00**

e rimangano:

> **2:00 minuti**

Il giocatore vuole fare tre cose:

🎸 Allenamento intensivo — 1:20

🍻 Bar — 0:40

🏠 Tornare a casa — 0:50

Non può farle tutte.

Deve scegliere.

Ed è proprio questo che rende interessante il sistema.

---

# **6\. Il tempo di viaggio conta davvero**

Questa è una delle idee più interessanti del sistema.

Se vivi lontano dallo studio:

Casa

 ↓

🚌 1:30

 ↓

Studio

stai sacrificando tempo.

Potresti quindi decidere di:

> pagare un taxi

e arrivare in:

0:30

ma spendere:

$30

Quindi introduciamo una scelta:

> **Tempo vs Denaro**

---

# **7\. Sistema dei trasporti**

Ogni metodo di trasporto può avere:

### **🚶 Piedi**

* costo: $0  
* tempo: alto  
* affidabilità: alta

### **🚲 Bici**

* costo: $0  
* tempo: medio  
* richiede eventualmente una bici

### **🚌 Bus**

* costo: basso  
* tempo: medio/basso  
* possibile traffico

### **🚕 Taxi**

* costo: alto  
* tempo: basso

### **🚗 Auto**

* costo: carburante/manutenzione  
* tempo: basso  
* maggiore libertà

### **🚇 Metro**

* costo: basso  
* tempo: basso  
* disponibile solo in determinate città

Questo sistema potrebbe evolvere insieme alla carriera.

---

# **8\. La posizione del personaggio**

A questo punto diventa importante introdurre:

> **Location**

Il giocatore non è semplicemente "nel gioco".

Si trova in un luogo.

Per esempio:

🏠 Casa

📍 Centro città

oppure:

🎧 Studio Sonic

📍 Downtown

oppure:

🎸 Rock Club

📍 West Side

Ogni luogo ha collegamenti con gli altri.

---

# **9\. Mappa semplificata**

Non serve inizialmente una vera mappa grafica.

Potremmo avere:

               🏟️ Arena

                   │

                   │

🏠 Casa ───── 🏙️ Centro ───── 🎸 Club

                   │

                   │

                🎧 Studio

                   │

                   │

                🚂 Stazione

Ogni collegamento possiede un tempo di viaggio.

---

# **10\. Esempio di giornata completa**

Supponiamo:

**08:00 — Casa**

Tempo:

> `10:00`

---

### **🚌 Casa → Studio**

`0:50`

Rimane:

> `09:10`

---

### **🎸 Studio leggero**

`0:10`

Rimane:

> `09:00`

\+10 XP

---

### **🎸 Studio attento**

`0:40`

Rimane:

> `08:20`

\+45 XP

---

### **🎧 Registrazione demo**

`1:30`

Rimane:

> `06:50`

---

### **🚌 Studio → Centro**

`0:50`

Rimane:

> `06:00`

---

### **🍻 Bar**

`1:00`

Rimane:

> `05:00`

Stress ↓  
Morale ↑

---

### **🚶 Centro → Casa**

`1:50`

Rimane:

> `03:10`

---

### **🎸 Allenamento a casa**

`1:00`

Rimane:

> `02:10`

---

### **🛋️ Relax**

`2:00`

Rimane:

> `00:10`

Fine giornata.

---

# **11\. Fine giornata**

Quando il timer arriva a:

> **00:00**

la giornata termina.

Il gioco esegue una fase di riepilogo:

╔══════════════════════════════╗

║       FINE GIORNATA          ║

╠══════════════════════════════╣

║ 🎸 Chitarra      \+55 XP      ║

║ 🎧 Produzione    \+20 XP      ║

║ 👥 Relazioni     \+5          ║

║ 😊 Morale        \+12         ║

║ 😰 Stress        \-8          ║

║ 💰 Denaro        \-$35        ║

╠══════════════════════════════╣

║       GIORNO 12 COMPLETATO   ║

╚══════════════════════════════╝

Poi:

> **Giorno 13 — 08:00**

---

# **12\. Ma c'è un'altra possibilità molto interessante**

Non necessariamente dobbiamo obbligare il giocatore ad aspettare **10 minuti reali**.

Il timer può essere **tempo simulato**.

Cioè:

> 10 minuti di gioco \= una giornata.

Il giocatore decide un'azione e il gioco fa avanzare immediatamente l'orologio.

Quindi:

08:00

 ↓

Studio 40 sec

 ↓

08:40

 ↓

Bus 50 sec

 ↓

09:30

 ↓

Bar 1:00

 ↓

10:30

Il giocatore non deve stare davanti allo schermo ad aspettare 40 secondi.

Questo rende il sistema molto più fluido.

---

# **13\. Azioni istantanee**

Non tutto deve necessariamente consumare molto tempo.

Potremmo avere:

### **Azioni rapide**

`5–15 sec`

* telefonare;  
* mandare un messaggio;  
* controllare notifiche;  
* ordinare qualcosa;  
* pianificare.

### **Azioni medie**

`20–60 sec`

* allenamento;  
* mangiare;  
* socializzare;  
* scrivere;  
* shopping.

### **Azioni lunghe**

`1–3 min`

* registrare;  
* concerto;  
* prove;  
* appuntamento;  
* festa.

### **Azioni molto lunghe**

`3–10 min`

* viaggio lungo;  
* tour;  
* grande evento;  
* attività particolarmente impegnative.

---

# **14\. Attività con durata variabile**

Ancora meglio: alcune azioni potrebbero essere **interrompibili**.

Per esempio:

> 🎸 Allenamento

Il giocatore può scegliere:

10 sec

20 sec

40 sec

1:00

1:30

2:00

Più tempo investi:

* più XP;  
* maggiore consumo di energia;  
* maggiore stress;  
* maggiore rendimento marginale.

Quindi:

10 sec → \+10 XP

40 sec → \+35 XP

80 sec → \+55 XP

120 sec → \+65 XP

Notiamo che l'efficienza diminuisce.

Questo impedisce di trovare una durata "migliore" da spammare sempre.

---

# **15\. Tempo \+ energia \+ denaro**

A questo punto abbiamo una **triade molto interessante**:

            ⏱️ TEMPO

             /     \\

            /       \\

           ↓         ↓

       💰 DENARO ← ⚡ ENERGIA

Per esempio:

### **Allenarsi a casa**

Tempo: alto  
Denaro: basso  
Energia: alta

### **Personal trainer**

Tempo: medio  
Denaro: alto  
Energia: alta

### **Taxi**

Tempo: basso  
Denaro: alto  
Energia: bassa

### **Autobus**

Tempo: medio  
Denaro: basso  
Energia: bassa

Il giocatore deve continuamente ottimizzare le proprie risorse.

---

# **16\. Collegamento con la vita dell'artista**

Questo sistema rende finalmente coerente la sezione che abbiamo appena aggiunto.

Per esempio:

> "Voglio andare al bar con il mio amico."

Non è semplicemente:

**\[BAR\] → evento.**

È:

Casa

 ↓

🚶 1:50

 ↓

Bar

 ↓

🍻 Socializzazione 1:00

 ↓

🚶 1:50

 ↓

Casa

Hai speso:

> **4:40 della giornata**

per quella serata.

E questo significa che non hai potuto utilizzare quel tempo per:

> 🎸 Allenarti  
> 🎧 Registrare  
> ✍️ Scrivere

Ma hai magari ottenuto:

> Stress ↓  
> Morale ↑  
> Relazione ↑

Questa è **vera scelta gestionale**.

---

# **17\. Regola fondamentale del sistema**

La metterei direttamente nel GDD:

> **Il tempo è una risorsa limitata e universale. Ogni attività, spostamento o interazione significativa consuma tempo. Il giocatore deve bilanciare tempo, denaro, energia e necessità personali per organizzare la propria giornata.**

---

# **18\. E questo apre una possibilità enorme**

In futuro potremmo rendere le giornate **progressivamente più lunghe**.

Per esempio:

### **V1**

`1 giorno = 10 minuti simulati`

### **V2**

`1 giorno = 15 minuti`

### **V3**

Possibilità di modificare la scala:

⚙️ Velocità del tempo

Rapida      5 min/giorno

Normale    10 min/giorno

Lenta      20 min/giorno

Ma per il primo prototipo terrei **10 minuti fissi**, perché è abbastanza grande da permettere diverse attività e abbastanza piccolo da costringere a fare scelte.

---

## **🧩 Quindi il gameplay loop si evolve così**

                   👤 ARTISTA

                       │

                       ↓

                  📍 LOCATION

                       │

                       ↓

                 ⏱️ TEMPO DISPONIBILE

                       │

          ┌────────────┼────────────┐

          ↓            ↓            ↓

       🎵 MUSICA    👥 SOCIAL    🌙 SVAGO

          │            │            │

          └────────────┼────────────┘

                       ↓

                  ⏱️ TEMPO −

                       │

          ┌────────────┼────────────┐

          ↓            ↓            ↓

       ⚡ Energia    😰 Stress    💰 Denaro

                       │

                       ↓

                  📈 CONSEGUENZE

                       │

                       ↓

                    CARRIERA

                       │

                       ↓

                 🌎 SUPERSTAR

**Questo sistema lo metterei tra i pilastri fondamentali del gioco**, insieme a musica, carriera, band ed economia. In particolare, ci permette di collegare quasi tutti gli altri sistemi: la distanza tra i luoghi influenza il tempo, il trasporto influenza tempo/denaro, le attività influenzano energia/stress/morale e queste condizioni influenzano a loro volta le prestazioni musicali. È una delle prime cose che avrebbe senso definire matematicamente prima di iniziare a programmare.

---

# **6\. STATISTICHE DEL PERSONAGGIO**

Per la V1 evitiamo 30 statistiche.

Partiamo con **8 statistiche principali**.

| Statistica | Funzione |
| ----- | ----- |
| 🎤 Voce | capacità vocale |
| 🎸 Strumento | abilità con lo strumento principale |
| ✍️ Songwriting | capacità di scrivere testi |
| 🎼 Composizione | qualità musicale |
| 🎭 Carisma | capacità di coinvolgere il pubblico |
| 🔥 Performance | qualità delle esibizioni |
| 🎧 Produzione | capacità di lavorare sulla produzione |
| ⭐ Popolarità | notorietà dell'artista |

### **Separazione importante**

Le prime 7 sono **abilità**.

La popolarità invece è una **conseguenza della carriera**.

Quindi:

Allenamento  
   ↓  
Skill ↑  
   ↓  
Performance migliore  
   ↓  
Concerti migliori  
   ↓  
Fan ↑  
   ↓  
Popolarità ↑

Non vogliamo che il giocatore possa semplicemente "allenarsi nella popolarità". Sarebbe un po' come fare 50 squat per diventare famoso. 😂

---

# **7\. STATISTICHE SECONDARIE**

In versioni successive possiamo aggiungere:

* energia;  
* stress;  
* salute;  
* creatività;  
* disciplina;  
* affidabilità;  
* presenza scenica;  
* originalità.

Ma **non fanno parte della V1**.

---

# **8\. SISTEMA MUSICALE**

Questo è probabilmente il sistema più caratterizzante del gioco.

Non vogliamo trattare la musica semplicemente come:

Rock \= 100  
Pop \= 80  
Metal \= 90

Vogliamo costruire una sorta di **DNA musicale**.

---

## **8.1 Generi**

Esempi iniziali:

* Rock  
* Pop  
* Metal  
* Punk  
* Blues  
* Jazz  
* Hip-Hop  
* Rap  
* Country  
* Reggae  
* Samba  
* EDM  
* Folk

La V1 potrebbe averne anche solo **5–6**.

---

## **8.2 Caratteristiche musicali**

Ogni canzone possiede attributi:

Energia  
Melodia  
Ritmo  
Originalità  
Complessità  
Commercialità  
Produzione

Esempio:

### **Canzone A**

Rock  
Energia:       85  
Melodia:       70  
Ritmo:         75  
Originalità:   60  
Commercialità: 80  
Produzione:    65  
---

# **9\. IDENTITÀ MUSICALE**

Il giocatore non seleziona semplicemente un genere.

Il suo stile evolve.

Esempio:

All'inizio:

Rock 70%  
Blues 30%

Dopo molti album:

Rock       45%  
Blues      25%  
Pop        20%  
Metal      10%

Il gioco può identificare automaticamente il sound:

> **Rock melodico con influenze blues e pop.**

Questo permette al giocatore di **plasmare la propria musica**.

---

# **10\. CREAZIONE DELLE CANZONI**

Il processo potrebbe essere:

NUOVA CANZONE  
      ↓  
Genere  
      ↓  
Stile  
      ↓  
Strumenti  
      ↓  
Composizione  
      ↓  
Testo  
      ↓  
Produzione  
      ↓  
QUALITÀ FINALE

La qualità dipende da:

* abilità del giocatore;  
* membri della band;  
* strumenti;  
* tempo investito;  
* eventuale produttore;  
* casualità controllata.

Certo. La inserirei nel GDD come **sezione ufficiale**, mantenendo il contenuto ma rendendolo coerente con la struttura del documento. Inoltre la collegherei esplicitamente ai sistemi già definiti di **abilità, tempo, energia, stress, morale, relazioni ed economia**.

### **📌 Sezione da aggiungere al GDD**

---

# **10\. VITA DELL'ARTISTA — LIFE SIMULATION**

La carriera musicale rappresenta il fulcro del gioco, ma **non costituisce l'intera vita del personaggio**.

Il giocatore deve poter decidere liberamente come utilizzare il proprio tempo, alternando attività professionali, sociali, ricreative e personali.

L'obiettivo è trasformare il gioco da semplice *Music Career Simulator* a una vera **Life/Career Simulation**, nella quale la carriera musicale e la vita personale si influenzano reciprocamente.

Il giocatore non deve essere obbligato a dedicare ogni giornata alla musica.

Può scegliere di lavorare, allenarsi e fare concerti oppure uscire, socializzare, divertirsi, riposarsi e frequentare la vita notturna.

---

## **10.1 Attività disponibili**

Il giocatore potrà progressivamente svolgere diverse categorie di attività.

### **🎵 Attività musicali**

* Allenarsi  
* Studiare uno strumento  
* Allenare la voce  
* Scrivere testi  
* Comporre musica  
* Lavorare in studio  
* Fare prove  
* Fare concerti  
* Incontrare professionisti  
* Partecipare a eventi musicali

### **👥 Attività sociali**

* Uscire con amici  
* Passare tempo con i membri della band  
* Conoscere nuove persone  
* Partecipare a feste  
* Partecipare a eventi dell'industria musicale  
* Coltivare relazioni

### **🌙 Vita notturna**

* Andare al bar  
* Andare in discoteca  
* Frequentare locali notturni  
* Frequentare strip club  
* Partecipare a feste  
* Bere  
* Socializzare

### **🛋️ Tempo personale**

* Riposarsi  
* Rilassarsi  
* Dedicarsi agli hobby  
* Passare tempo da soli  
* Recuperare energia

Queste attività non devono necessariamente avere un'utilità musicale diretta. Alcune servono semplicemente a **vivere il personaggio** e a modificare le sue condizioni personali.

---

# **10.2 Tempo e scelta delle attività**

Ogni attività richiede una determinata quantità di tempo.

Il giocatore dispone quindi di una risorsa fondamentale:

> **Il tempo.**

Esempio:

SETTIMANA 24

LUN

🎸 Allenamento

MAR

✍️ Scrittura

MER

😴 Riposo

GIO

🍻 Uscita con amici

VEN

🎤 Concerto

SAB

🕺 Nightlife

DOM

🛋️ Relax

Il giocatore non può fare tutto.

Deve quindi decidere come bilanciare:

**carriera \+ vita personale \+ recupero.**

---

# **10.3 Energia, Stress e Morale**

Per rappresentare lo stato del personaggio vengono introdotti tre parametri principali.

### **⚡ Energia**

Rappresenta le energie fisiche disponibili.

Energia: 72/100

Attività impegnative la consumano, mentre il riposo permette di recuperarla.

---

### **😰 Stress**

Rappresenta la pressione accumulata dal personaggio.

Può aumentare a causa di:

* concerti;  
* tour;  
* problemi economici;  
* conflitti nella band;  
* lavoro intenso;  
* eventi negativi.

Può diminuire attraverso:

* riposo;  
* socializzazione;  
* divertimento;  
* attività ricreative;  
* tempo libero.

---

### **😊 Morale**

Rappresenta la condizione emotiva generale del personaggio all'interno della simulazione.

Può essere influenzato da:

* successo;  
* fallimenti;  
* relazioni;  
* concerti;  
* vita sociale;  
* eventi;  
* tempo libero.

---

# **10.4 Effetti delle attività**

Le attività modificano diversi parametri contemporaneamente.

### **🎸 Allenamento**

Energia   \-20

Stress    \+5

Skill     \+XP

### **🎤 Concerto**

Energia   \-35

Stress    \+15

Morale    \+10

Fan       \+X

Soldi     \+X

### **🎧 Studio**

Energia   \-15

Stress    \+10

Song      \+XP

### **👥 Uscita con amici**

Energia   \-10

Stress    \-20

Morale    \+15

Relazioni \+10

Soldi     \-50

### **🎉 Festa**

Energia   \-25

Stress    \-30

Morale    \+25

Soldi     \-100

### **🛋️ Riposo**

Energia   \+30

Stress    \-10

I valori riportati sono **esempi di design**, non ancora definitivi.

---

# **10.5 Attività ricreative e conseguenze**

Le attività ricreative non devono essere trattate automaticamente come positive o negative.

Devono avere **vantaggi, costi e possibili conseguenze**.

Per esempio, una serata fuori può:

* ridurre lo stress;  
* aumentare il morale;  
* migliorare una relazione;  
* creare nuove conoscenze;  
* costare denaro;  
* consumare energia.

Un uso eccessivo di determinate attività può invece produrre eventi o penalità.

Esempio:

> **Hai passato troppo tempo a fare festa questa settimana.**

Possibili conseguenze:

* allenamento meno efficace;  
* minore energia;  
* concerto influenzato;  
* maggiore spesa;  
* evento casuale.

Il sistema non deve giudicare il comportamento del giocatore.

> **Il gioco deve simulare le conseguenze delle scelte, non dire al giocatore come vivere.**

---

# **10.6 Nightlife**

La vita notturna costituisce una categoria specifica di attività.

Possibili luoghi:

* 🍺 Bar  
* 🕺 Night Club  
* 🎰 Casinò  
* 💃 Strip Club  
* 🍸 Lounge  
* 🎉 Party

Questi luoghi possono offrire:

* divertimento;  
* socializzazione;  
* nuove conoscenze;  
* relazioni;  
* networking;  
* eventi casuali;  
* opportunità professionali;  
* spese;  
* consumo di energia.

Le attività possono inoltre variare in base alla città e al livello della carriera.

Un piccolo artista potrebbe avere accesso principalmente a locali locali, mentre una superstar potrebbe frequentare eventi privati e locali esclusivi.

---

# **10.7 Socialità e relazioni**

La vita sociale sarà collegata al sistema delle relazioni.

Il giocatore può decidere di passare del tempo con:

* amici;  
* membri della band;  
* professionisti;  
* conoscenti;  
* partner;  
* altri artisti.

Esempio:

> **Passare una serata con il batterista**

Relazione \+10

Morale \+5

Oppure:

> **Passare la serata da solo**

Stress \-10

Oppure:

> **Partecipare a una festa dell'industria musicale**

Costo: $500

Stress: \-5

Networking: \+20

Il networking può successivamente generare opportunità professionali.

---

# **10.8 Lifestyle**

Il comportamento del giocatore nel corso del tempo contribuisce a creare un **Lifestyle**.

Il Lifestyle non è una classe scelta all'inizio.

È un comportamento **emergente dalle azioni del giocatore**.

### **🎸 Workaholic**

Molto tempo dedicato alla carriera.

Possibili effetti:

Skill ↑

Carriera ↑

Stress ↑

Vita sociale ↓

### **🎉 Party Animal**

Grande investimento nella vita sociale e notturna.

Possibili effetti:

Morale ↑

Socialità ↑

Networking ↑

Denaro ↓

Energia ↓

### **🧘 Balanced**

Alternanza tra:

> lavoro \+ musica \+ socialità \+ riposo

Tende a mantenere maggiormente equilibrati i parametri personali.

### **🎨 Creative**

Grande quantità di tempo dedicata a:

* scrittura;  
* composizione;  
* sperimentazione;  
* ricerca musicale.

Può contribuire allo sviluppo di un'identità musicale più particolare.

**Il Lifestyle non deve bloccare il giocatore.**

Deve semplicemente descrivere il modo in cui sta vivendo la propria carriera.

---

# **10.9 Vita personale → musica**

Uno degli obiettivi più importanti di questo sistema è creare una connessione bidirezionale tra vita e musica.

Esempio:

VITA

 ↓

Esperienza

 ↓

Evento

 ↓

Ispirazione

 ↓

Creatività

 ↓

NUOVA CANZONE

 ↓

CARRIERA

Esempio narrativo:

> Il giocatore esce durante una serata libera.

↓

> Conosce una persona.

↓

> Nasce una relazione.

↓

> La relazione termina dopo qualche tempo.

↓

> Il giocatore scrive una canzone ispirata all'esperienza.

↓

> La canzone ottiene un grande successo.

In questo modo una semplice attività extra-musicale può contribuire indirettamente alla carriera.

---

# **10.10 Vita personale → eventi**

Le attività possono inoltre modificare la probabilità o il tipo di eventi futuri.

Per esempio:

Molto lavoro

      ↓

Stress elevato

      ↓

Eventi legati alla carriera

oppure:

Molte attività sociali

      ↓

Networking elevato

      ↓

Nuove conoscenze

      ↓

Opportunità

oppure:

Molto tempo libero

      ↓

Più esperienze personali

      ↓

Nuovi eventi

Questo permette al mondo di reagire al comportamento del giocatore.

---

# **10.11 Principio di design**

> **La carriera musicale è una parte della vita del personaggio, non l'intera vita.**

Il giocatore deve poter scegliere liberamente come utilizzare il proprio tempo, alternando:

🎵 Musica

👥 Socialità

🌙 Nightlife

❤️ Relazioni

🛋️ Relax

💼 Carriera

Ogni scelta può produrre:

* benefici;  
* costi;  
* nuove relazioni;  
* nuove opportunità;  
* eventi;  
* conseguenze.

Non deve esistere una singola maniera corretta di giocare.

---

# **10.12 Struttura generale aggiornata**

                        👤 ARTISTA

                            │

             ┌──────────────┴──────────────┐

             │                             │

        🎵 CARRIERA                    🧑 VITA

             │                             │

      ┌──────┼──────┐              ┌───────┼────────┐

      │      │      │              │       │        │

    MUSICA  BAND  CONCERTI       SOCIAL  NIGHTLIFE RELAX

      │      │      │              │       │        │

      └──────┴──────┘              └───────┴────────┘

             │                             │

             └──────────────┬──────────────┘

                            ↓

                       🧠 PERSONAGGIO

                            │

                 ┌──────────┼──────────┐

                 ↓          ↓          ↓

              ⚡ Energia  😰 Stress  😊 Morale

                 │          │          │

                 └──────────┼──────────┘

                            ↓

                       ESPERIENZE

                            ↓

                         CARRIERA

                            ↓

                     🌎 SUPERSTAR

---

## **🔗 Collegamento con il sistema delle abilità**

Questa sezione va quindi a completare quella precedente.

Il giocatore non migliora soltanto attraverso l'allenamento:

ATTIVITÀ

   ↓

ESPERIENZA

   ↓

┌───────────────┐

│               │

↓               ↓

SKILL        VITALE

│               │

↓               ↓

MUSICA      Energia

│           Stress

│           Morale

↓               │

CARRIERA ←──────┘

In altre parole, **il personaggio non è soltanto un musicista con delle statistiche: è una persona che cerca di costruirsi una vita mentre costruisce una carriera**.

Questa sezione diventa quindi una parte strutturale del GDD, non un'aggiunta cosmetica.

---

# **11\. CANZONI, EP E ALBUM**

Tre livelli:

### **🎵 Singolo**

1 canzone.

### **💿 EP**

3–6 canzoni.

### **💿 Album**

8–15 canzoni.

Ogni pubblicazione genera:

* streaming;  
* vendite;  
* fan;  
* reputazione;  
* popolarità;  
* eventuali recensioni.

---

# **12\. BAND**

Il giocatore inizialmente può essere un artista solista.

Successivamente può creare una band.

Ogni membro possiede:

Nome  
Ruolo  
Strumento  
Skill  
Personalità  
Affidabilità  
Relazione con il giocatore

Esempio:

Marco  
Batterista

Batteria       78  
Composizione   62  
Carisma        45  
Affidabilità   91

Personalità:  
"Perfezionista"  
---

# **13\. PERSONALITÀ DEI MEMBRI**

Questo sistema arriverà dopo la V1.

Possibili personalità:

* Ambizioso  
* Leale  
* Creativo  
* Pigro  
* Perfezionista  
* Arrogante  
* Tranquillo  
* Impulsivo  
* Opportunista

La personalità influenzerà gli eventi.

---

# **14\. RELAZIONI NELLA BAND**

Ogni membro può avere:

### **Relazione**

0–100

### **Rispetto**

0–100

### **Conflitto**

0–100

Questo permette situazioni come:

> Il chitarrista vuole maggiore libertà creativa.

oppure:

> Il batterista pensa di essere pagato troppo poco.

oppure:

> Un membro riceve un'offerta da un'altra band.

---

# **15\. CONCERTI**

La carriera live segue una progressione naturale.

🏠 Casa / prove  
      ↓  
🍺 Bar  
      ↓  
🎸 Piccolo club  
      ↓  
🎪 Festival locale  
      ↓  
🏟️ Arena  
      ↓  
🌎 Festival internazionale  
      ↓  
🏟️ Stadium  
      ↓  
🌍 World Tour

Ogni location avrà:

* capacità;  
* costo;  
* pubblico potenziale;  
* requisiti;  
* guadagno potenziale.

---

# **16\. RISULTATO DI UN CONCERTO**

Il risultato dipende da:

Performance  
\+ Carisma  
\+ Qualità musicale  
\+ Affinità col pubblico  
\+ Popolarità  
\+ Eventuale bonus band  
\+ Casualità

Risultato:

Spettatori  
Fan guadagnati  
Denaro  
Reputazione  
Popolarità  
---

# **17\. ECONOMIA**

La carriera deve avere un'economia semplice ma significativa.

## **Entrate**

* concerti;  
* streaming;  
* vendita musica;  
* merchandising;  
* sponsor;  
* royalties;  
* collaborazioni.

## **Spese**

* strumenti;  
* sala prove;  
* studio;  
* produzione;  
* musicisti;  
* manager;  
* marketing;  
* viaggi;  
* tour.

---

# **18\. DENARO**

Il denaro non deve essere un semplice punteggio.

Il giocatore deve poter fare investimenti.

Esempio:

> Hai $10.000.

Puoi:

**A)** comprare uno strumento migliore

**B)** pagare uno studio

**C)** fare marketing

**D)** conservare i soldi

Quindi:

> **Denaro \= risorsa strategica.**

---

# **19\. FANBASE**

La fanbase sarà separata dalla popolarità.

Esempio:

Fan totali: 125.000

USA       50.000  
Italia    30.000  
UK        20.000  
Brasile   15.000  
Altro     10.000

Questo permetterà di costruire una vera carriera internazionale.

---

# **20\. MONDO**

Il mondo sarà composto da:

Continenti  
   ↓  
Paesi  
   ↓  
Città  
   ↓  
Locali / Festival / Arene

Ogni paese avrà:

* mercato musicale;  
* generi più popolari;  
* dimensione del mercato;  
* pubblico potenziale;  
* costo dei tour.

---

# **21\. ORIGINE DEL PERSONAGGIO**

Il luogo iniziale fornisce un **contesto**, non una classe obbligatoria.

Esempio:

### **Brasile**

Bonus iniziali possibili:

* Samba  
* ritmi latini

### **USA**

* Rock  
* Hip-Hop  
* Pop

### **UK**

* Rock  
* Pop  
* Electronic

### **Italia**

* Pop  
* Rock  
* Cantautorato

Ma il giocatore rimane completamente libero.

---

# **22\. MERCATO DINAMICO**

Versione successiva.

Il gusto del pubblico cambia nel tempo.

Esempio:

Anno 1:

> Rock popolare.

Anno 5:

> EDM esplode.

Anno 8:

> Revival del punk.

Questo significa che il giocatore deve decidere:

> Seguo la moda oppure mantengo il mio stile?

Nessuna delle due strategie deve essere automaticamente corretta.

---

# **23\. EVENTI**

Gli eventi rappresentano la parte narrativa/procedurale del gioco.

Categorie:

### **🎵 Musicali**

* collaborazione;  
* festival;  
* opportunità discografica.

### **👥 Personali**

* conflitti;  
* nuovi membri;  
* amicizie.

### **💰 Economici**

* debiti;  
* sponsor;  
* investimento.

### **🌎 Carriera**

* tour;  
* intervista;  
* viralità;  
* contratto.

---

# **24\. EVENTI CON SCELTE**

Esempio:

> **Un importante produttore vuole lavorare con te.**

Possibili decisioni:

**A — Accetti**

Costo: $5.000  
Possibile aumento qualità.

**B — Rifiuti**

Mantieni completa indipendenza.

**C — Negozia**

Richiede una certa reputazione.

Quindi gli eventi non devono essere semplici notifiche.

Devono creare **decisioni**.

---

# **25\. CARRIERA**

La carriera avrà dei livelli.

LV 1 — Principiante  
LV 2 — Musicista  
LV 3 — Artista emergente  
LV 4 — Artista locale  
LV 5 — Artista nazionale  
LV 6 — Artista affermato  
LV 7 — Star internazionale  
LV 8 — Superstar mondiale

Ogni livello sblocca:

* nuovi locali;  
* nuove opportunità;  
* nuovi strumenti;  
* nuovi mercati;  
* nuovi professionisti;  
* nuovi eventi.

---

# **26\. REPUTAZIONE VS POPOLARITÀ**

Questa distinzione va mantenuta.

### **Popolarità**

> Quanta gente ti conosce.

### **Reputazione**

> Come vieni considerato nell'industria.

Possiamo avere:

Popolarità: 90  
Reputazione: 40

oppure:

Popolarità: 40  
Reputazione: 90

Due carriere completamente diverse.

---

# **27\. ETICHETTE DISCOGRAFICHE**

**Non V1.**

Successivamente:

### **Indie**

* Libertà  
  − Risorse

### **Major**

* Marketing  
* Distribuzione  
* Budget

− Minore controllo

Il giocatore può anche rimanere indipendente.

---

# **28\. MANAGER E STAFF**

Sistema futuro.

Possibili professionisti:

* Manager  
* Produttore  
* Booking Agent  
* PR  
* Tour Manager  
* Social Manager

Ogni professionista ha:

Skill  
Costo  
Personalità  
Esperienza  
Reputazione  
---

# **29\. SOCIAL**

Versione successiva.

Il gioco genera automaticamente eventi social:

> 📱 Il tuo nuovo video è diventato virale.

> \+50.000 follower

oppure:

> 📱 Un'intervista sta generando discussioni.

oppure:

> 📱 Un video live ha ricevuto milioni di visualizzazioni.

I social diventano quindi un altro **motore di eventi**.

---

# **30\. PROGRESSIONE**

La progressione principale sarà:

ABILITÀ  
   ↓  
MUSICA  
   ↓  
CONCERTI  
   ↓  
FAN  
   ↓  
FAMA  
   ↓  
DENARO  
   ↓  
INVESTIMENTI  
   ↓  
NUOVE OPPORTUNITÀ  
   ↓  
MUSICA MIGLIORE

È un sistema circolare.

---

# **31\. INTERFACCIA**

Per la V1 non serve una grafica enorme.

La schermata principale potrebbe essere:

╔════════════════════════════════════╗  
║        🎸 MUSIC CAREER             ║  
╠════════════════════════════════════╣  
║ Giuseppe "The Fox"                 ║  
║ Rock / Blues                       ║  
║                                    ║  
║ 💰 $8.420      ⭐ Fame 34          ║  
║ 👥 12.430 fan   📅 Week 32         ║  
╠════════════════════════════════════╣  
║                                    ║  
║ \[ Allenati \]      \[ Scrivi \]       ║  
║ \[ Concerto \]      \[ Studio \]       ║  
║ \[ Band \]          \[ Carriera \]     ║  
║                                    ║  
╚════════════════════════════════════╝

L'interfaccia potrà evolvere insieme al gioco.

---

# **32\. V1 — MINIMUM VIABLE GAME**

La V1 deve essere **piccola**.

### **Deve contenere:**

✅ Creazione personaggio  
✅ Sistema tempo  
✅ Statistiche  
✅ Allenamento  
✅ Creazione canzoni  
✅ Singoli  
✅ Concerti  
✅ Fan  
✅ Popolarità  
✅ Denaro  
✅ Progressione  
✅ Salvataggio

### **Non deve contenere:**

❌ World Tour  
❌ Etichette  
❌ Manager  
❌ Social complessi  
❌ Personalità avanzate  
❌ Rivalità  
❌ Mercato dinamico  
❌ 1000 città  
❌ Multiplayer

---

# **33\. V1 — LOOP COMPLETO**

La prima versione deve permettere di fare questo:

CREA ARTISTA  
      ↓  
SCEGLI ORIGINE  
      ↓  
ALLENATI  
      ↓  
MIGLIORA SKILL  
      ↓  
CREA CANZONE  
      ↓  
PUBBLICA  
      ↓  
SUONA LIVE  
      ↓  
GUADAGNA SOLDI  
      ↓  
GUADAGNA FAN  
      ↓  
AUMENTA POPOLARITÀ  
      ↓  
SBLOCCA NUOVI LOCALI  
      ↓  
SUONA CONCERTI PIÙ GRANDI  
      ↓  
RIPETI

Se questo è divertente, abbiamo una base solida.

---

# **34\. V2 — BAND & CARRIERA**

Aggiungiamo:

* membri della band;  
* strumenti;  
* relazioni;  
* prove;  
* EP;  
* album;  
* città;  
* più generi;  
* nuovi concerti;  
* primi eventi.

---

# **35\. V3 — INDUSTRIA MUSICALE**

Aggiungiamo:

* manager;  
* produttori;  
* etichette;  
* sponsor;  
* marketing;  
* merchandising;  
* collaborazioni;  
* streaming;  
* recensioni;  
* premi.

---

# **36\. V4 — MONDO DINAMICO**

Aggiungiamo:

* mercato musicale dinamico;  
* paesi;  
* città;  
* festival;  
* tour;  
* trend;  
* artisti rivali;  
* eventi globali;  
* social.

---

# **37\. V5 — SUPERSTAR**

L'endgame:

WORLD TOUR  
     ↓  
STADI  
     ↓  
FESTIVAL MONDIALI  
     ↓  
COLLABORAZIONI  
     ↓  
RECORD  
     ↓  
HALL OF FAME

E potremmo introdurre una cosa molto interessante:

## **Legacy**

Una volta raggiunto il massimo, il giocatore non deve necessariamente "finire".

Può:

* fondare una propria etichetta;  
* produrre altri artisti;  
* scoprire talenti;  
* continuare la carriera;  
* ritirarsi;  
* iniziare una nuova generazione.

---

# **38\. REGOLE DI DESIGN**

Queste secondo me sono **fondamentali** e le metterei proprio nel GDD.

### **Regola 1 — Libertà musicale**

Il gioco non deve obbligare il giocatore a seguire un genere.

---

### **Regola 2 — Nessuna crescita lineare obbligatoria**

Non deve esistere un'unica strada verso il successo.

---

### **Regola 3 — Le scelte devono avere conseguenze**

Le decisioni importanti devono modificare la situazione del giocatore.

---

### **Regola 4 — Il denaro non deve risolvere tutto**

Essere ricchi non deve automaticamente significare essere un grande artista.

---

### **Regola 5 — La fama non equivale alla qualità**

Un artista può essere famoso senza essere tecnicamente eccellente.

---

### **Regola 6 — Il mondo deve reagire**

Il gioco deve rispondere alle azioni del giocatore.

---

### **Regola 7 — Il caso deve creare storie, non frustrazione**

Gli eventi casuali devono essere imprevedibili ma **gestibili**.

---

### **Regola 8 — I sistemi devono essere modulari**

Ogni sistema deve poter essere modificato/esteso senza distruggere gli altri.

Questa sarà particolarmente importante visto che costruiremo il gioco progressivamente con Python e IA.

---

# **39\. ARCHITETTURA CONCETTUALE**

Senza ancora scrivere codice, possiamo già individuare i principali oggetti del gioco:

GAME  
│  
├── Player  
│  
├── Song  
│  
├── Album  
│  
├── Band  
│   └── BandMember  
│  
├── Concert  
│  
├── Venue  
│  
├── City  
│  
├── Country  
│  
├── Career  
│  
├── Economy  
│  
├── Event  
│  
└── World

E questo ci dà una cosa molto importante:

**il GDD comincia già a tradursi naturalmente in architettura software.**

---

# **40\. LA VISIONE COMPLETA**

Alla fine, vogliamo arrivare a qualcosa del genere:

                    🌎 WORLD  
                        │  
               ┌────────┴────────┐  
               │                 │  
             MERCATI           EVENTI  
               │                 │  
               └────────┬────────┘  
                        │  
                     ARTISTA  
                        │  
          ┌─────────────┼─────────────┐  
          │             │             │  
       MUSICA         BAND         CARRIERA  
          │             │             │  
       CANZONI       MEMBRI        CONCERTI  
          │             │             │  
       ALBUM         RELAZIONI       FAN  
          │             │             │  
          └─────────────┼─────────────┘  
                        │  
                   ECONOMIA  
                        │  
                 INVESTIMENTI  
                        │  
                   PROGRESSIONE  
                        │  
                   🌟 SUPERSTAR

## **🎯 Obiettivo della V1**

Non dobbiamo ancora costruire "la simulazione definitiva dell'industria musicale".

Dobbiamo dimostrare una cosa molto più semplice:

> **"È divertente prendere un artista sconosciuto, allenarlo, creare musica, fare concerti, guadagnare soldi e vedere la propria carriera crescere."**

Se quella parte funziona, abbiamo il **cuore del gioco**. Tutti gli altri sistemi — band, etichette, tour mondiali, rivalità, social, mercato dinamico — potranno essere innestati successivamente.

Il prossimo passo naturale è trasformare questo GDD in una **specifica della V1**, definendo esattamente **quali dati possiede ogni oggetto, quali azioni può fare il giocatore, come passa il tempo e soprattutto le formule matematiche di XP, qualità delle canzoni, guadagni, fan e popolarità**. È lì che il concept comincia davvero a diventare un gioco programmabile.

Sì, queste aggiunte sono molto importanti perché completano una parte che nel GDD mancava: **il punto di partenza della vita del personaggio**. Finora avevamo definito bene *cosa può diventare*, ma non abbastanza *da dove parte*.

Ti propongo di inserirle nel GDD come un nuovo sistema modulare, senza dover modificare radicalmente tutto quello che abbiamo già progettato.

## **Nuova sezione GDD — Contesto iniziale del personaggio**

### **26\. Origine e contesto di partenza**

All'inizio della partita il giocatore non deve necessariamente partire sempre dalla stessa situazione.

Il gioco genera o permette di scegliere un **contesto iniziale**, che determina le condizioni di vita del personaggio, le sue risorse iniziali, gli impegni, le opportunità e alcune difficoltà.

Il contesto **non determina il destino musicale del giocatore**: rappresenta semplicemente il punto da cui inizia la sua storia.

Il giocatore potrà quindi iniziare, ad esempio:

* ancora a scuola;  
* appena diplomato;  
* studente universitario;  
* maggiorenne che vive con i genitori;  
* giovane che vive da solo;  
* lavoratore;  
* disoccupato;  
* musicista che sta già cercando di vivere di musica;  
* studente di musica;  
* apprendista;  
* situazione economica difficile;  
* situazione familiare più favorevole.

Questo permette di avere partite molto diverse già dal primo giorno.

---

### **26.1 Età e fase della vita**

Il personaggio può iniziare in diverse fasi della vita.

**Esempi:**

| Situazione | Caratteristiche |
| ----- | ----- |
| Studente minorenne | Vive con i genitori, scuola obbligatoria, pochi soldi, molto tempo |
| Studente maggiorenne | Può avere maggiore autonomia, ma deve gestire studio e musica |
| Giovane diplomato | Nessun obbligo scolastico, può lavorare o dedicarsi alla musica |
| Universitario | Studio \+ eventuale lavoro \+ musica |
| Giovane lavoratore | Entrate regolari ma meno tempo libero |
| Musicista indipendente | Più tempo per la musica, ma entrate instabili |
| Disoccupato | Molto tempo disponibile, poche entrate |
| Studente di musica | Formazione musicale più strutturata |

Non è necessario che queste siano classi rigide. Possono essere **condizioni iniziali modificabili durante la partita**.

Per esempio:

> Scuola → diploma → lavoro → licenziamento → musicista professionista.

Oppure:

> Scuola → corso di musica → università → abbandono degli studi → carriera musicale.

---

# **27\. Situazione abitativa**

Il giocatore deve avere una **situazione abitativa**.

Possibili condizioni:

* vive con i genitori;  
* vive con parenti;  
* vive con coinquilini;  
* vive da solo;  
* vive in un appartamento economico;  
* vive in un appartamento di lusso;  
* successivamente può acquistare una casa.

La casa influenza:

* costo della vita;  
* affitto/mutuo;  
* privacy;  
* spazio disponibile per strumenti;  
* possibilità di allenarsi;  
* possibilità di invitare persone;  
* energia/stress;  
* qualità della vita.

Ad esempio:

**Vivere con i genitori**

* costo abitativo basso;  
* possibile paghetta;  
* meno libertà;  
* eventuali limitazioni sugli orari;  
* maggiore sicurezza economica.

**Vivere da solo**

* maggiore libertà;  
* maggiore privacy;  
* possibilità di organizzare liberamente la giornata;  
* affitto e bollette;  
* maggiore necessità di avere un lavoro.

Questo si collega direttamente al sistema **Economia \+ Tempo \+ Vita**.

---

# **28\. Istruzione e formazione**

Il giocatore può scegliere se investire tempo nella propria formazione.

Possibili percorsi:

### **Istruzione generale**

* scuola;  
* università;  
* corsi professionali.

### **Formazione musicale**

* lezioni di canto;  
* lezioni di chitarra;  
* pianoforte;  
* batteria;  
* teoria musicale;  
* songwriting;  
* produzione musicale;  
* sound engineering;  
* corsi di performance.

La formazione musicale può funzionare come una forma di **allenamento più efficiente ma più costosa**.

Esempio:

> Allenarsi da soli → poco costoso, crescita normale.

> Lezione con insegnante → costa denaro, consuma tempo, crescita maggiore.

> Masterclass → molto costosa, ma permette di ottenere grandi quantità di XP o bonus temporanei.

Questo permette di creare una scelta interessante:

**Tempo vs denaro vs qualità della formazione.**

---

# **29\. Lavoro e fonti di reddito**

Il giocatore non deve dipendere esclusivamente dalla musica per guadagnare denaro.

All'inizio della carriera potrebbe essere necessario avere un lavoro.

Possibili lavori:

* cameriere;  
* barista;  
* commesso;  
* fattorino;  
* impiegato;  
* insegnante di musica;  
* tecnico audio;  
* musicista freelance;  
* turnista;  
* lavori online;  
* lavori part-time;  
* lavori full-time.

Il lavoro genera **entrate**, ma consuma:

* tempo;  
* energia;  
* eventualmente stress.

Quindi nasce una delle decisioni fondamentali del gioco:

> **Lavoro per avere soldi oppure uso quel tempo per costruire la mia carriera musicale?**

Esempio:

**Part-time**

* \+$500/settimana  
* \-tempo moderato  
* \-energia moderata

**Full-time**

* \+$1.800/settimana  
* \-molto tempo  
* \-energia  
* meno tempo per musica

**Musicista freelance**

* entrate variabili;  
* più libertà;  
* esperienza musicale;  
* maggiore instabilità.

---

# **30\. Sistema di indipendenza economica**

Il personaggio può attraversare diverse fasi economiche.

### **Fase 1 — Dipendenza**

Il giocatore può ricevere:

* paghetta;  
* aiuto familiare;  
* vitto/alloggio dai genitori.

Ha poche entrate proprie.

### **Fase 2 — Primo lavoro**

Il giocatore trova un lavoro per finanziare:

* strumenti;  
* lezioni;  
* studio;  
* trasporti;  
* vita sociale.

### **Fase 3 — Lavoro \+ musica**

Il giocatore mantiene un lavoro mentre costruisce lentamente la carriera.

Questa potrebbe essere una delle fasi più importanti del gioco.

> **"Di giorno lavoro al bar, la sera suono nei locali."**

### **Fase 4 — Musica come fonte di reddito**

Concerti, streaming, vendite, royalties e altre attività musicali iniziano a generare abbastanza denaro.

### **Fase 5 — Professionista**

Il giocatore può lasciare il lavoro tradizionale e vivere principalmente di musica.

### **Fase 6 — Superstar**

Le entrate musicali diventano molto elevate e possono provenire da molte fonti:

* concerti;  
* tour;  
* streaming;  
* album;  
* merchandising;  
* sponsor;  
* royalties;  
* collaborazioni;  
* licensing;  
* ecc.

---

# **31\. Spawn casuale**

Oltre alla possibilità di scegliere il proprio punto di partenza, il gioco può offrire una modalità:

## **Random Start / Vita Casuale**

All'inizio della partita il gioco genera casualmente il contesto del personaggio.

Potresti quindi ritrovarti:

> 🇯🇵 19 anni — Osaka  
> Vive con i genitori  
> Studente  
> Chitarra livello 12  
> $350  
> Lavora part-time in un convenience store  
> Ama il rock ma non ha mai suonato dal vivo.

Oppure:

> 🇦🇺 24 anni — Melbourne  
> Vive con due coinquilini  
> Disoccupato  
> Batterista livello 28  
> $1.200  
> Ha già suonato in piccoli locali.

Oppure:

> 🇧🇷 17 anni — Rio de Janeiro  
> Vive con la famiglia  
> Studente  
> Percussioni livello 18  
> Riceve una piccola paghetta  
> Frequenta un corso musicale.

Oppure una situazione completamente diversa:

> 🇺🇸 21 anni — Detroit  
> Vive da solo  
> Lavora full-time  
> $2.800  
> Nessuna esperienza musicale professionale  
> Ma ha una forte predisposizione per il songwriting.

L'obiettivo è creare il sentimento:

> **"Non so che vita mi è capitata, vediamo cosa riesco a farne."**

---

# **32\. Origine geografica**

Il paese e la città di nascita possono influenzare il contesto iniziale senza obbligare il giocatore a seguire una determinata musica.

Il luogo può determinare:

* costo della vita;  
* mercato musicale;  
* generi più diffusi;  
* opportunità;  
* disponibilità di locali;  
* scuole musicali;  
* trasporti;  
* stipendi medi;  
* costo degli strumenti;  
* dimensione del mercato;  
* cultura musicale;  
* eventi locali.

Ma:

> **Nascere in Giappone non significa dover fare J-Pop.**

Un personaggio nato in Giappone può diventare:

* metallaro;  
* bluesman;  
* rapper;  
* jazzista;  
* punk;  
* artista elettronico;  
* cantautore;  
* ecc.

La provenienza modifica **il contesto**, non la libertà creativa.

---

# **33\. Background casuale**

Possiamo fare un ulteriore passo interessante.

Oltre a paese, età e situazione economica, il gioco potrebbe generare un **background personale**.

Per esempio:

### **Background: "Figlio di musicisti"**

Bonus:

* conoscenze musicali iniziali;  
* strumento iniziale;  
* contatti.

Svantaggi:

* aspettative familiari.

### **Background: "Autodidatta"**

Bonus:

* maggiore creatività/originalità.

Svantaggi:

* tecnica iniziale più bassa.

### **Background: "Studente modello"**

Bonus:

* disciplina;  
* apprendimento.

Svantaggi:

* meno esperienza sociale.

### **Background: "Ragazzo di strada"**

Bonus:

* esperienza sociale;  
* adattabilità;  
* networking.

Svantaggi:

* situazione economica iniziale peggiore.

### **Background: "Famiglia benestante"**

Bonus:

* capitale iniziale;  
* strumenti migliori;  
* formazione.

Svantaggi:

* meno necessità di lavorare → oppure aspettative familiari più elevate.

Questi non dovrebbero essere semplici **bonus/malus RPG**. Dovrebbero soprattutto creare **situazioni e possibilità differenti**.

---

# **34\. Generazione della partita**

A questo punto l'inizio della partita potrebbe essere strutturato così:

**GENERAZIONE PERSONAGGIO**

→ Età  
→ Paese  
→ Città  
→ Situazione familiare  
→ Situazione abitativa  
→ Situazione economica  
→ Istruzione  
→ Lavoro  
→ Formazione musicale  
→ Strumento/abilità iniziali  
→ Background  
→ Personalità  
→ Obiettivi iniziali

↓

### **GIORNO 1**

Il giocatore scopre la propria situazione e inizia a prendere decisioni.

Da quel momento tutto è dinamico.

---

## **35\. Collegamento con il sistema del tempo**

Questa è probabilmente la parte più importante.

Il **lavoro**, la **scuola**, i **corsi musicali**, la **musica**, la **vita sociale** e il **riposo** devono utilizzare lo stesso sistema temporale che abbiamo già progettato.

Quindi il gioco non avrà sistemi separati.

Avremo un'unica risorsa:

### **⏱️ TEMPO**

Il giocatore decide come utilizzarlo.

**Esempio:**

> 08:00–13:00 → scuola  
> 13:00–14:00 → pranzo  
> 14:00–16:00 → lavoro part-time  
> 16:00–17:00 → trasporto \+ pausa  
> 17:00–18:00 → lezione di chitarra  
> 18:00–19:00 → scrittura  
> 19:00–21:00 → uscita con amici  
> 21:00 → casa

Oppure:

> "Fanculo la scuola, oggi devo finire questa canzone."

😄

E questa scelta potrebbe avere conseguenze.

---

# **36\. Nuovo sistema generale: Vita → Carriera**

Con queste aggiunte possiamo definire un principio ancora più forte del gioco:

**VITA**

→ Istruzione  
→ Lavoro  
→ Casa  
→ Famiglia  
→ Relazioni  
→ Socialità  
→ Tempo libero  
→ Formazione

↓

**PERSONAGGIO**

→ Energia  
→ Stress  
→ Morale  
→ Denaro  
→ Esperienze  
→ Abilità

↓

**MUSICA**

→ Allenamento  
→ Scrittura  
→ Composizione  
→ Produzione  
→ Concerti

↓

**CARRIERA**

→ Fan  
→ Popolarità  
→ Reputazione  
→ Opportunità  
→ Successo

↓

# **🌎 WORLD SUPERSTAR**

La cosa bella è che **non esiste un percorso obbligatorio**.

Uno potrebbe diventare famoso partendo da una famiglia povera e lavorando per anni.

Un altro potrebbe avere una famiglia ricca e investire immediatamente nella musica.

Un altro ancora potrebbe essere uno studente giapponese che scopre il rock.

Un altro potrebbe nascere in Australia, lavorare in un pub e formare una band.

Un altro potrebbe iniziare già adulto, vivere da solo e cercare di trasformare la musica nel proprio secondo lavoro.

Ed è proprio questo che rende interessante la modalità **Random Start**: il gioco non ti dice *"questa è la tua storia"*. Ti dà **una situazione iniziale** e poi sei tu a costruire la storia.

# Scheda 2

# 🎸 Music Career Simulator — Roadmap di Sviluppo

Genere: Management / Life Simulation / Music Career Piattaforma: PC — Tecnologia: Python Obiettivo: partire da artista sconosciuto e diventare una superstar mondiale  
Questa roadmap riorganizza il GDD in una sequenza di versioni implementabili, dalla più semplice (V1.0, il "minimum viable game") alla visione completa (V5.0). Ogni versione è pensata per essere giocabile e testabile prima di passare alla successiva.  
---

## 🧱 V1.0 — Minimum Viable Game

Obiettivo della versione: dimostrare che è divertente prendere un artista sconosciuto, allenarlo, creare musica, fare concerti, guadagnare soldi e vedere la carriera crescere. Se questo loop funziona, il cuore del gioco è solido.

### 1\. Creazione del personaggio

* Scelta (o generazione casuale) di: età, paese, città  
* Situazione di partenza semplificata: es. studente / lavoratore / disoccupato  
* Situazione abitativa base (vive con i genitori / da solo)  
* Strumento/ruolo iniziale  
* Origine geografica come *contesto*, non come vincolo di genere musicale

### 2\. Sistema del tempo (fondamentale, va costruito subito)

* 1 giornata \= 10 minuti simulati (tempo che scorre automaticamente ad ogni azione, non tempo reale d'attesa)  
* Ogni azione/spostamento consuma tempo  
* Azioni a durata variabile (es. allenamento 10/40/80/120 sec) con rendimento marginale decrescente in XP  
* Categorie di durata: azioni rapide (5–15s), medie (20–60s), lunghe (1–3 min), molto lunghe (3–10 min)  
* Sistema di trasporto base: piedi / bus / taxi (trade-off tempo vs denaro)  
* Location minime: casa, studio, un locale per concerti  
* Riepilogo di fine giornata (XP, morale, stress, denaro)

### 3\. Statistiche del personaggio (le 8 principali)

* Voce, Strumento, Songwriting, Composizione, Carisma, Performance, Produzione  
* Popolarità (conseguenza della carriera, non allenabile direttamente)

### 4\. Sistema musicale (versione base)

* 5–6 generi iniziali  
* Attributi canzone: Energia, Melodia, Ritmo, Originalità, Commercialità, Produzione  
* Creazione canzone: Genere → Stile → Composizione → Testo → Produzione → Qualità finale  
* Pubblicazione di Singoli

### 5\. Concerti

* Progressione minima dei locali: casa/prove → bar → piccolo club  
* Risultato concerto \= Performance \+ Carisma \+ Qualità musicale \+ Popolarità \+ casualità  
* Output: spettatori, fan guadagnati, denaro, popolarità

### 6\. Economia base

* Entrate: concerti, vendita musica  
* Spese: strumenti, sala prove, studio  
* Denaro come risorsa strategica (non solo punteggio)

### 7\. Fanbase e progressione

* Fan totali (senza ancora suddivisione geografica dettagliata)  
* Livelli di carriera (almeno i primi: Principiante → Musicista → Artista emergente)  
* Salvataggio partita

### ❌ Esplicitamente ESCLUSO da V1.0

World Tour, etichette, manager, social complessi, personalità avanzate dei membri della band, rivalità, mercato dinamico, migliaia di città, multiplayer.

### 🔁 Loop completo V1.0

CREA ARTISTA → SCEGLI ORIGINE → ALLENATI → MIGLIORA SKILL →  
CREA CANZONE → PUBBLICA → SUONA LIVE → GUADAGNA SOLDI/FAN →  
AUMENTA POPOLARITÀ → SBLOCCA LOCALI PIÙ GRANDI → RIPETI

---

## 🎤 V2.0 — Band & Vita del Personaggio

Obiettivo della versione: trasformare il gioco da simulatore musicale puro a *Life/Career Simulation*, introducendo band e la vita personale come sistema che influenza la carriera.

### 1\. Band

* Creazione band (da solista a gruppo)  
* Membri con: nome, ruolo, strumento, skill, personalità (base), affidabilità, relazione col giocatore  
* Prove come attività che migliora la performance

### 2\. Relazioni nella band

* Relazione, Rispetto, Conflitto (0–100)  
* Eventi legati alla band (richiesta di libertà creativa, malcontento economico, offerte esterne)

### 3\. Pubblicazioni estese

* EP (3–6 canzoni)  
* Album (8–15 canzoni)  
* Identità musicale: mix percentuale di generi che evolve nel tempo (es. Rock 70% / Blues 30% → Rock 45% / Blues 25% / Pop 20% / Metal 10%)

### 4\. Vita dell'artista — Life Simulation

* Parametri: ⚡ Energia, 😰 Stress, 😊 Morale  
* Attività extra-musicali: sociali (uscite, feste), nightlife (bar, discoteca, locali notturni), tempo personale (relax, hobby)  
* Ogni attività ha costi/benefici su tempo, denaro, energia, stress, morale, relazioni  
* Collegamento vita → musica: esperienze personali possono ispirare nuove canzoni  
* Collegamento vita → eventi: stile di vita (lavoro intenso, vita sociale, tempo libero) influenza probabilità/tipo di eventi futuri

### 5\. Lifestyle emergente (non scelto, ma risultante dal comportamento)

* Workaholic, Party Animal, Balanced, Creative — con effetti diversi su skill/stress/socialità/denaro

### 6\. Origine e contesto di partenza (approfondito)

* Fase della vita: studente minorenne/maggiorenne, diplomato, universitario, lavoratore, disoccupato, musicista indipendente  
* Situazione abitativa con effetti su costo della vita, privacy, spazio per strumenti  
* Istruzione: generale vs formazione musicale (lezioni, masterclass) come alternativa più costosa ma più efficiente all'allenamento da soli  
* Lavoro: part-time / full-time / musicista freelance, con trade-off tempo vs denaro vs energia  
* Fasi di indipendenza economica: dipendenza → primo lavoro → lavoro+musica → musica come reddito → professionista → superstar  
* Modalità Random Start: generazione casuale di età, città, situazione economica, skill iniziali  
* Background casuale (es. "Figlio di musicisti", "Autodidatta", "Ragazzo di strada", "Famiglia benestante") con bonus/svantaggi che creano situazioni, non solo numeri

### 7\. Concerti — espansione locali

* Aggiunta di festival locali nella progressione

### 8\. Mondo — più città

* Espansione oltre la città iniziale, con mercati musicali locali differenti

---

## 🏢 V3.0 — Industria Musicale

Obiettivo della versione: introdurre i professionisti e le strutture dell'industria musicale che permettono di scalare una carriera in modo professionale.

### 1\. Manager e staff

* Manager, Produttore, Booking Agent, PR, Tour Manager, Social Manager  
* Ognuno con: skill, costo, personalità, esperienza, reputazione

### 2\. Etichette discografiche

* Indie: più libertà, meno risorse  
* Major: più marketing/budget/distribuzione, meno controllo creativo  
* Possibilità di restare indipendenti

### 3\. Economia estesa

* Nuove entrate: sponsor, royalties, collaborazioni, merchandising  
* Nuove spese: manager, marketing, tour

### 4\. Eventi con scelte strutturate

* Eventi che offrono decisioni reali (es. produttore importante: accetta / rifiuta / negozia con requisiti di reputazione)  
* Categorie: musicali, personali, economici, di carriera

### 5\. Reputazione vs Popolarità (distinzione esplicita)

* Popolarità \= quanta gente ti conosce  
* Reputazione \= come sei considerato nell'industria  
* Le due possono divergere e creare "carriere" molto diverse

### 6\. Personalità dei membri della band (sistema avanzato)

* Tratti: Ambizioso, Leale, Creativo, Pigro, Perfezionista, Arrogante, Tranquillo, Impulsivo, Opportunista  
* La personalità influenza gli eventi generati

### 7\. Concerti — espansione ulteriore

* Aggiunta di Arena nella progressione dei locali

---

## 🌍 V4.0 — Mondo Dinamico

Obiettivo della versione: far reagire il mondo di gioco alle scelte del giocatore e al tempo che passa, aggiungendo profondità geografica e sociale.

### 1\. Mercato musicale dinamico

* Il gusto del pubblico cambia negli anni (es. Rock popolare → EDM esplode → Revival del punk)  
* Scelta strategica: seguire la moda o mantenere il proprio stile (nessuna delle due "giusta" a priori)

### 2\. Mondo strutturato

* Gerarchia: Continenti → Paesi → Città → Locali/Festival/Arene  
* Ogni paese con: mercato musicale, generi popolari, dimensione mercato, pubblico potenziale, costo dei tour  
* Fanbase suddivisa per paese (es. USA 50k, Italia 30k, UK 20k...)

### 3\. Festival e tour

* Festival locali e internazionali  
* Prime forme di tour multi-città

### 4\. Artisti rivali

* NPC concorrenti che occupano lo stesso spazio di mercato/genere

### 5\. Eventi globali

* Eventi di scala mondiale che influenzano più artisti/mercati contemporaneamente

### 6\. Social (versione base)

* Eventi automatici generati dal gioco: video virale, intervista che genera discussione, live con milioni di visualizzazioni  
* I social diventano un motore aggiuntivo di eventi ed opportunità

---

## 🌟 V5.0 — Superstar / Endgame

Obiettivo della versione: offrire un vero endgame e una direzione dopo il raggiungimento del successo massimo.

### 1\. Concerti — vertice della progressione

* Festival internazionale → Stadium → World Tour

### 2\. Contenuti di endgame

* Collaborazioni di alto profilo  
* Record e premi  
* Hall of Fame

### 3\. Legacy (dopo il picco)

* Fondare una propria etichetta  
* Produrre altri artisti / scoprire nuovi talenti  
* Continuare la carriera, ritirarsi, oppure iniziare una nuova generazione (prestige/new game+)

---

## 📌 Sistemi trasversali (da tenere a mente in ogni versione)

Questi non sono "versioni" a sé ma principi che attraversano tutte le fasi:

* Il tempo è la risorsa universale: lavoro, scuola, musica, vita sociale e riposo condividono lo stesso orologio. Non ci sono sistemi temporali separati.  
* Triade Tempo / Denaro / Energia: quasi ogni scelta è un trade-off tra queste tre risorse.  
* Le 8 regole di design fondamentali (da rispettare in ogni versione):  
  1. Libertà musicale — nessun genere imposto  
  2. Nessuna crescita lineare obbligatoria  
  3. Le scelte hanno conseguenze  
  4. Il denaro non risolve tutto  
  5. La fama non equivale alla qualità  
  6. Il mondo deve reagire alle azioni del giocatore  
  7. Il caso deve creare storie, non frustrazione  
  8. I sistemi devono essere modulari (fondamentale per lo sviluppo incrementale con Python)

### Architettura concettuale di riferimento (per l'implementazione software)

GAME  
├── Player  
├── Song  
├── Album  
├── Band └── BandMember  
├── Concert  
├── Venue  
├── City  
├── Country  
├── Career  
├── Economy  
├── Event  
└── World

---

## ✅ Prossimo passo consigliato

Prima di scrivere codice per la V1.0, conviene trasformare questa roadmap in una specifica tecnica della V1: definire i dati esatti di ogni oggetto (Player, Song, Venue...), le azioni disponibili al giocatore, il funzionamento preciso del sistema del tempo, e le formule matematiche di XP, qualità delle canzoni, guadagni, fan e popolarità.

# V1.0

# **🎵 Music Superstar Simulator — Specifica Tecnica V1.0**

L'obiettivo non è ancora decidere come implementarla in Godot. Prima definiamo le **regole del gioco**, così quando passeremo al codice non ci ritroveremo con 47 variabili `fame_finale_finale2` e un progetto che piange. 😄

---

## **0\. Principio fondamentale della V1.0**

La V1 deve essere giocabile dall'inizio alla fine attraverso questo ciclo:

ARTISTA  
   ↓  
GESTISCI TEMPO / ENERGIA / DENARO  
   ↓  
ALLENATI  
   ↓  
MIGLIORA LE SKILL  
   ↓  
CREA CANZONI  
   ↓  
PUBBLICA  
   ↓  
SUONA  
   ↓  
OTTieni SOLDI \+ FAN \+ POPOLARITÀ  
   ↓  
SBLOCCA NUOVE OPPORTUNITÀ  
   ↓  
RIPETI

Ogni sistema deve avere una funzione nel loop.

Se una statistica non influenza nessuna decisione, **nella V1 non serve**.

---

# **1\. Modello dei dati**

Prima definiamo gli oggetti principali.

## **1.1 Player**

Il giocatore/artista avrà almeno:

Player  
├── Identità  
│   ├── nome  
│   ├── età  
│   ├── paese  
│   ├── città  
│   └── background  
│  
├── Situazione  
│   ├── abitazione  
│   ├── lavoro/studio  
│   └── denaro  
│  
├── Risorse  
│   ├── energia  
│   ├── stress  
│   └── morale  
│  
├── Skill  
│   ├── voce  
│   ├── strumento  
│   ├── songwriting  
│   ├── composizione  
│   ├── carisma  
│   ├── performance  
│   └── produzione  
│  
└── Carriera  
    ├── popolarità  
    ├── fan  
    ├── livello carriera  
    └── canzoni pubblicate

### **Range delle statistiche**

Per evitare numeri ingestibili:

**Skill:**

0 → 100

**Popolarità:**

0 → 100

**Energia:**

0 → 100

**Morale:**

0 → 100

**Stress:**

0 → 100

**Fan:**

0 → ∞

Il numero di fan non dovrebbe avere un limite artificiale.

---

# **2\. Background iniziale**

La creazione del personaggio deve influenzare il gameplay, ma **non determinare il destino del giocatore**.

Per esempio:

### **Background**

| Background | Effetto |
| ----- | ----- |
| Studente | meno soldi, alcune attività scolastiche |
| Lavoratore | entrata giornaliera, meno tempo |
| Disoccupato | molto tempo, pochi soldi |

### **Abitazione**

| Situazione | Effetto |
| ----- | ----- |
| Con genitori | costo abitativo basso |
| Da solo | costo maggiore |

### **Origine**

Esempio:

Paese: Brasile  
Città: Rio de Janeiro

può fornire:

Contesto culturale:  
\+ familiarità iniziale con determinati stili

ma **non**:

"Se sei brasiliano devi fare samba"

Il giocatore deve poter creare:

> Metal brasiliano, Rock giapponese, Pop italiano, Rap americano ecc.

---

# **3\. Sistema del tempo**

Esatto. Questa modifica cambia parecchio il concetto: **il tempo non viene semplicemente "scalato" quando premi un'azione**. Deve essere un vero **tempo di gioco che scorre**, e se scegli un'azione da 40 secondi, quei 40 secondi devono passare davvero.

Questa secondo me è una scelta **molto più interessante** per il tuo gioco.

## **⏱️ Sistema del tempo V1.0 — versione corretta**

Una giornata dura:

**10 minuti reali \= 1 giornata di gioco**

Quindi:

00:00 ─────────────────────────────── 10:00  
             1 GIORNATA

Il tempo scorre continuamente.

Quando il giocatore sceglie un'azione:

Allenamento rapido  
↓  
Durata: 10 secondi  
↓  
L'azione parte  
↓  
il giocatore aspetta 10 secondi  
↓  
azione completata  
↓  
può scegliere cosa fare

Quindi sì: **l'attesa è reale.**

### **📅 Calendario V1**

**Potremmo avere:**

**Data di gioco**

**├── Giorno**

**├── Settimana**

**├── Mese**

**└── Anno**

**Per esempio:**

**Anno 1**

**Mese 1**

**Settimana 2**

**Giorno 10**

**Con:**

**1 giorno \= 10 minuti reali**

**7 giorni \= 1 settimana**

**4 settimane \= 1 mese**

**12 mesi \= 1 anno**

**Quindi il calendario avanza automaticamente ogni volta che termina una giornata.**

---

# **Ma hai centrato il problema principale**

> **Cosa succede nei secondi in cui il giocatore non sta facendo niente?**

La risposta che darei per la V1 è:

## **Il tempo continua a scorrere, ma il giocatore deve avere sempre qualcosa da osservare o decidere.**

Non vogliamo assolutamente una situazione del tipo:

\[ Allenamento \]

████████████████████

...  
...  
...

"Ok, adesso cosa faccio?"

perché dopo 30 minuti il giocatore potrebbe iniziare ad allenarsi con una mazza da baseball contro il monitor.

---

# **1\. Durante un'azione il giocatore può osservare il progresso**

Supponiamo:

**Allenamento intenso — 40 secondi**

Quando clicca:

┌────────────────────────────────────┐  
│        🎸 ALLENAMENTO               │  
│                                    │  
│        Chitarra                    │  
│                                    │  
│        ███████████░░░░░░            │  
│        24 / 40 sec                  │  
│                                    │  
│        \+ XP Strumento               │  
│        \- Energia                    │  
│        \+ Stress                     │  
└────────────────────────────────────┘

Il tempo passa davvero.

Ma contemporaneamente la schermata può mostrare:

* avanzamento dell'azione  
* energia  
* stress  
* morale  
* denaro  
* fan  
* orario  
* eventi  
* notifiche

---

# **2\. Ma soprattutto: durante l'attesa devono succedere cose**

Questa è la parte che può rendere il gioco veramente interessante.

Il gioco potrebbe avere un sistema di **Eventi durante il tempo**.

Per esempio:

00:31  
↓  
Stai allenando la chitarra...  
↓  
00:37  
↓  
📱 NUOVO MESSAGGIO  
"Marco: Stasera suoniamo al bar?"

L'utente può:

\[Accetta\]  
\[Rifiuta\]

Oppure:

00:45

🎵 Hai avuto una nuova idea musicale\!

\[Salva idea\]  
\[Ignora\]

Oppure:

01:02

💰 Pagamento ricevuto: \+50€  
---

# **3\. Non tutto deve richiedere attenzione**

Questo è fondamentale.

Il gioco deve distinguere:

### **🔴 Azioni che richiedono attesa attiva**

Esempio:

Allenamento  
40 sec

Il giocatore aspetta.

### **🟡 Azioni che possono essere interrotte**

Esempio:

Allenamento lungo  
120 sec

Dopo 50 secondi il giocatore potrebbe dire:

> "Basta, voglio andare al bar."

E quindi:

\[Interrompi\]

Riceve solamente parte del beneficio.

### **🟢 Azioni automatiche**

Alcune cose possono accadere mentre il tempo passa:

Pagamento lavoro  
Recupero energia  
Messaggi  
Eventi  
Vendite  
Fan che ascoltano una canzone  
---

# **4\. E qui arriva una meccanica molto importante: la pianificazione**

Il giocatore non deve necessariamente stare **concentrato sul gioco per tutti i 10 minuti**.

Può preparare una sequenza.

Ad esempio:

08:00

Allenamento intenso  
40 sec

↓ automaticamente

Doccia  
20 sec

↓ automaticamente

Bus → studio  
50 sec

↓ automaticamente

Registrazione  
120 sec

Quindi il giocatore può dire:

> "Per i prossimi 230 secondi faccio queste cose."

Il gioco esegue la coda.

---

# **5\. Però NON farei un'automazione completa nella V1**

Perché rischiamo di trasformare il gioco in:

Premi PLAY  
↓  
il gioco gioca da solo  
↓  
torna dopo 10 minuti  
↓  
"Congratulazioni, sei Metallica"

😂

La coda dovrebbe essere **limitata**.

Per esempio:

Massimo 2-3 azioni in coda

e alcune azioni richiedono una nuova decisione.

---

# **6\. Il vero "tempo morto"**

Possiamo distinguere due situazioni.

### **Tempo morto volontario**

Il giocatore dice:

> "Non voglio fare nulla."

Allora può semplicemente:

\[Passa tempo\]

E il tempo scorre.

Questo può essere utile per:

* recuperare energia  
* aspettare un evento  
* aspettare che finisca una giornata  
* non spendere denaro

Per esempio:

PASSA TEMPO

10 sec  
30 sec  
60 sec  
---

# **7\. Tempo morto involontario**

Questo invece dobbiamo **minimizzarlo**.

Esempio:

Azione finita  
↓  
nessuna azione scelta  
↓  
il tempo continua

In questo caso il gioco potrebbe mostrare:

┌─────────────────────────────┐  
│                             │  
│        🏠 CASA              │  
│                             │  
│   Non stai facendo nulla    │  
│                             │  
│       04:37                 │  
│                             │  
│   Energia: 72               │  
│   Stress: 21                │  
│                             │  
│ \[Allenati\] \[Riposa\]         │  
│ \[Scrivi\]   \[Esci\]           │  
│                             │  
└─────────────────────────────┘

Il tempo continua.

Ma **non voglio che questa sia la situazione normale**.

Il giocatore dovrebbe avere sempre qualcosa da poter fare.

---

# **8\. Il viaggio è perfetto per "riempire" il tempo**

Questa è un'altra cosa che avevi già intuito.

Esempio:

Casa  
↓  
Bus  
↓  
Studio

Durata: 50 secondi  
Costo: €2

Durante quei 50 secondi:

🚍 In viaggio...

01:32 ──────────────── 02:22

Energia: 76  
Stress: 19  
Denaro: €143

Ma non devi necessariamente stare a fissare lo schermo.

Potrebbero comparire eventi:

📱 Instagram

Una tua canzone ha ricevuto 12 ascolti.

oppure:

🎵 Hai trovato un'idea per un ritornello.

oppure niente.

Ed è importante che **non debba succedere qualcosa ogni secondo**.

---

# **9\. Quindi il gioco dovrebbe avere un "Action State"**

Concettualmente:

PLAYER  
  │  
  ▼  
NESSUNA AZIONE  
  │  
  ├── scegli allenamento  
  │  
  ├── scegli viaggio  
  │  
  ├── scegli scrittura  
  │  
  └── scegli riposo  
          │  
          ▼  
      AZIONE IN CORSO  
          │  
          │ tempo scorre realmente  
          │  
          ├── evento?  
          │      ↓  
          │   EVENTO  
          │  
          ▼  
      AZIONE COMPLETATA  
          │  
          ▼  
   NUOVA DECISIONE

Questo è molto più solido.

---

# **10\. Una cosa che cambierei rispetto alla specifica precedente**

Prima avevamo:

> `AZIONE → tempo -= durata`

❌ **Non va più bene.**

Con la tua idea deve diventare:

> **AZIONE → parte un timer → il tempo di gioco scorre realmente → quando il timer termina l'azione viene completata.**

Quindi:

Tempo di gioco  
─────────────────────────────────────────►

00:00       00:10       00:20       00:30  
   │──────────│───────────│───────────│  
   │          │           │  
   └ Allenamento rapido ──┘  
             10 sec

E il clock globale continua contemporaneamente.

---

# **🎯 La regola fondamentale che proporrei**

**Il giocatore non deve mai aspettare semplicemente perché il gioco non ha nulla da fare.**

Durante un'azione lunga:

> **sta aspettando perché il personaggio sta facendo qualcosa.**

Durante un viaggio:

> **sta aspettando perché il personaggio sta viaggiando.**

Durante un'attività:

> **il tempo sta passando e possono verificarsi eventi.**

Se invece non vuole fare niente:

> **può volontariamente far passare il tempo.**

Questa distinzione è importantissima.

---

## **E farei anche una cosa molto interessante**

Non farei necessariamente partire **tutte le azioni immediatamente**.

Potremmo avere:

       ⏱️ 03:42

     COSA VUOI FARE?

🎸 Allenamento  
   40 sec

🎼 Scrivere canzone  
   60 sec

🚌 Andare in studio  
   50 sec \+ €2

😴 Riposare  
   60 sec

🍺 Uscire  
   90 sec \+ €10

Il giocatore sceglie → **il timer parte davvero**.

Questa meccanica può diventare il cuore del gioco: **non stai semplicemente scegliendo attività, stai decidendo come spendere i tuoi 600 secondi giornalieri.**

E questa è una risorsa molto più interessante del semplice "giorno \= \-1".

---

# **4\. Categorie delle azioni**

Definiamo quattro categorie.

| Categoria | Durata |
| ----- | ----- |
| Rapida | 5–15 s |
| Media | 20–60 s |
| Lunga | 60–180 s |
| Molto lunga | 180–600 s |

Questo ci permette di costruire facilmente nuove attività.

---

# **5\. Energia**

Ogni azione può consumare energia.

Esempio:

Allenamento leggero  
Tempo: 10 s  
Energia: \-5

Allenamento intenso  
Tempo: 40 s  
Energia: \-15

Concerto  
Tempo: 120 s  
Energia: \-30

Se:

energia \< costo

l'azione non può essere eseguita.

Questo crea una decisione:

> "Continuo ad allenarmi oppure mi riposo?"

---

# **6\. Stress e morale**

Questi due valori servono per evitare che il gioco diventi:

clicca "Allenamento"  
clicca "Allenamento"  
clicca "Allenamento"  
clicca "Allenamento"

Perché sarebbe praticamente Excel con una chitarra.

### **Stress**

Aumenta con:

* allenamenti intensi  
* concerti  
* sessioni molto lunghe  
* giornate sovraccariche

Diminuisce con:

* riposo  
* attività ricreative  
* sonno

### **Morale**

Aumenta con:

* concerti riusciti  
* aumento fan  
* pubblicazione di una buona canzone  
* eventi positivi

Diminuisce con:

* fallimenti  
* concerti pessimi  
* stress elevato  
* mancanza di denaro

---

# **7\. Rendimento marginale dell'allenamento**

Questa è una delle formule che dobbiamo definire bene.

Non vogliamo:

120 secondi \= 12 × 10 secondi

perché il giocatore potrebbe spammare continuamente sessioni lunghe.

Possiamo utilizzare:

XP \= XP\_base × durata\_effettiva × fattore\_rendimento

con un fattore che diminuisce all'aumentare della durata.

Per esempio:

| Allenamento | Tempo | XP |
| ----- | ----- | ----- |
| Rapido | 10 s | 5 |
| Medio | 40 s | 15 |
| Lungo | 80 s | 25 |
| Molto lungo | 120 s | 32 |

Quindi:

10 s → 5 XP  
40 s → 15 XP  
80 s → 25 XP  
120 s → 32 XP

Il giocatore ottiene più XP facendo sessioni lunghe, ma **non in maniera proporzionale**.

---

# **8\. Sistema XP → Skill**

Ogni skill ha:

livello 0–100  
XP interno

Possiamo usare una curva del tipo:

XP necessario \= 100 \+ (livello × 25\)

Quindi aumentare:

10 → 11

è facile.

Mentre:

80 → 81

richiede molto più lavoro.

Questo crea naturalmente una progressione:

Principiante  
████░░░░░░

Intermedio  
██████░░░░

Esperto  
█████████░

Maestro  
██████████  
---

# **9\. Sistema musicale**

Una `Song` dovrebbe essere un oggetto separato dal Player.

Song  
├── titolo  
├── genere  
├── stile  
├── energia  
├── melodia  
├── ritmo  
├── originalità  
├── commercialità  
├── produzione  
└── qualità

Tutti gli attributi:

0–100  
---

# **10\. Creazione della canzone**

La creazione sarà composta da fasi.

GENERE  
 ↓  
STILE  
 ↓  
COMPOSIZIONE  
 ↓  
TESTO  
 ↓  
PRODUZIONE  
 ↓  
QUALITÀ FINALE  
 ↓  
PUBBLICAZIONE

Importante: **non tutte queste fasi devono necessariamente essere minigiochi.**

Nella V1 possono essere semplicemente decisioni \+ consumo di tempo/denaro \+ utilizzo delle skill.

---

# **11\. Qualità della canzone**

La qualità finale non dovrebbe essere semplicemente:

media(energia, melodia, ritmo...)

Perché altrimenti basta fare la media e abbiamo finito il game design.

Possiamo invece avere:

Qualità \=  
Composizione  
\+ Songwriting  
\+ Produzione  
\+ Originalità  
\+ bonus/malus dello stile  
\+ casualità

con pesi differenti.

Ad esempio concettualmente:

30% Composizione  
20% Songwriting  
20% Produzione  
15% Originalità  
15% altri attributi

Poi normalizziamo:

0–100  
---

# **12\. Qualità ≠ successo**

Questo è **molto importante**.

Una canzone:

Qualità \= 90

non deve necessariamente significare:

\+10.000 fan

La qualità influenza la probabilità di successo, ma intervengono anche:

* popolarità dell'artista  
* genere  
* commercialità  
* performance  
* casualità  
* pubblico  
* precedente fanbase

Quindi:

QUALITÀ  
   ↓  
potenziale di successo

ma non:

QUALITÀ  
   ↓  
successo garantito  
---

# **13\. Pubblicazione**

Quando il giocatore pubblica:

Song.status \= RELEASED

La canzone entra nel catalogo dell'artista.

Ogni pubblicazione genera:

fan  
popolarità  
denaro

in funzione della qualità e della popolarità dell'artista.

---

# **14\. Concerti**

Oggetto:

Venue  
├── nome  
├── capacità  
├── requisito\_popolarità  
├── costo\_affitto  
├── prestigio  
└── durata

V1:

Casa / prove  
↓  
Bar  
↓  
Piccolo club

Potremmo anche avere:

Bar  
capacità \= 50

Piccolo Club  
capacità \= 150  
---

# **15\. Risultato del concerto**

Il risultato deve combinare:

Performance  
Carisma  
Qualità musicale  
Popolarità  
Casualità

Ma ogni elemento ha un peso.

Concettualmente:

Performance       30%  
Qualità musicale  25%  
Popolarità        20%  
Carisma           15%  
Casualità         10%

Otteniamo:

Concert Score \= 0–100  
---

# **16\. Spettatori**

Gli spettatori dipendono da:

capacità locale  
popolarità  
concert\_score

Esempio concettuale:

spettatori \=  
capacità × domanda

dove:

domanda \= funzione(popolarità, qualità, performance)

Così un artista con popolarità 5 non riempie magicamente un club da 500 persone.

---

# **17\. Fan guadagnati**

Possiamo introdurre una percentuale di conversione.

nuovi\_fan \=  
spettatori × conversion\_rate

Il `conversion_rate` dipende dal risultato del concerto.

Per esempio:

Concert Score 30  
→ pochi nuovi fan

Concert Score 70  
→ buona conversione

Concert Score 95  
→ grande conversione  
---

# **18\. Popolarità**

La popolarità deve essere **una conseguenza**, non una skill allenabile.

Quindi:

allenamento  
→ skill

canzoni  
→ qualità

concerti  
→ fan

fan \+ attività musicale  
→ popolarità

Questo mantiene coerente il sistema.

---

# **19\. Economia**

Il denaro deve essere una vera risorsa strategica.

### **Entrate**

Concerti  
Vendita musica

### **Spese**

Trasporti  
Strumenti  
Sala prove  
Studio  
Produzione

Possiamo iniziare con:

money \= 500

e permettere al giocatore di decidere:

> "Spendo 200€ per migliorare la produzione oppure tengo i soldi per poter andare al prossimo concerto?"

Questa è una **decisione di gameplay**.

---

# **20\. Fanbase**

V1:

fan\_total

Niente ancora:

fan\_brasile  
fan\_italiani  
fan\_giapponesi  
fan\_rock  
fan\_pop

Quello può arrivare dopo.

Il sistema deve semplicemente permettere:

100 fan  
↓  
250  
↓  
800  
↓  
2.000  
↓  
10.000  
---

# **21\. Livelli di carriera**

Per V1 possiamo avere:

0 — Principiante  
1 — Musicista  
2 — Artista emergente  
3 — Artista affermato

Ogni livello può avere requisiti.

Esempio:

Principiante  
↓  
Musicista  
10 skill media \+ 50 fan

Artista emergente  
1000 fan \+ 3 canzoni pubblicate

Questi valori li definiamo nella fase successiva dopo aver costruito le formule.

---

# **22\. Sistema di sblocco**

La progressione deve essere visibile.

Esempio:

PRINCIPIANTE  
│  
├── Casa  
├── Allenamento  
├── Creazione canzoni  
└── Piccoli eventi  
        ↓  
MUSICISTA  
│  
├── Bar  
├── Studio migliore  
└── Nuovi stili  
        ↓  
ARTISTA EMERGENTE  
│  
├── Club  
├── Concerti più remunerativi  
└── Produzione avanzata

Quindi il giocatore percepisce:

> "Sto diventando qualcuno."

---

# **23\. Fine giornata**

Quando il tempo arriva a:

00:00

parte automaticamente il riepilogo.

### **Daily Summary**

════════════════════  
      FINE GIORNATA  
════════════════════

Skill:  
\+12 XP Strumento  
\+8 XP Songwriting

Fan:  
\+47

Popolarità:  
\+2

Denaro:  
\+120 €

Stress:  
\+8

Morale:  
\+5

════════════════════

Poi:

NUOVO GIORNO

e vengono applicati gli effetti giornalieri.

---

# **24\. Salvataggio**

V1 deve salvare almeno:

Player  
Skills  
Money  
Energy  
Stress  
Morale  
Popularity  
Fans  
Career Level

Songs  
Released Songs

Progression  
Unlocked Venues

World  
Current Day  
Current Time

Il salvataggio deve poter ricostruire completamente lo stato della partita.

---

# **25\. Architettura concettuale**

Prima ancora del codice Godot, io separerei i sistemi così:

GAME  
│  
├── Player  
│  
├── TimeSystem  
│  
├── ActionSystem  
│  
├── SkillSystem  
│  
├── MusicSystem  
│   └── Song  
│  
├── ConcertSystem  
│   └── Venue  
│  
├── EconomySystem  
│  
├── FameSystem  
│  
├── ProgressionSystem  
│  
├── SaveSystem  
│  
└── UI

Questo è importante perché **non vogliamo un unico gigantesco script `Game.gd` da 4000 righe**.

---

# **26\. Le formule da definire prima del codice**

A questo punto abbiamo identificato le formule che dobbiamo fissare.

### **Skill**

XP ottenuti dall'azione

### **Livello**

XP necessari per salire

### **Allenamento**

XP × durata × rendimento marginale

### **Canzone**

Skill → attributi canzone → qualità

### **Concerto**

Skill \+ qualità \+ popolarità \+ casualità  
→ Concert Score

### **Spettatori**

Concert Score \+ popolarità \+ capacità venue

### **Fan**

spettatori \+ qualità concerto

### **Popolarità**

fan \+ pubblicazioni \+ concerti

### **Economia**

entrate \- spese  
---

## **🧠 E soprattutto: l'ordine corretto di sviluppo**

Non partirei direttamente da:

> "Apriamo Godot e facciamo il menu."

Prima farei questa sequenza:

FASE 1  
Definizione dati  
        ↓  
FASE 2  
Definizione regole  
        ↓  
FASE 3  
Definizione formule  
        ↓  
FASE 4  
Definizione azioni  
        ↓  
FASE 5  
Definizione progressione  
        ↓  
FASE 6  
Definizione salvataggio  
        ↓  
FASE 7  
Architettura Godot  
        ↓  
FASE 8  
Prototipo  
        ↓  
FASE 9  
UI  
        ↓  
FASE 10  
Bilanciamento

**Il prossimo documento che farei è quindi la vera e propria `V1.0 Game Rules Specification`:** una tabella precisa di **Player, Skill, Action, Song, Venue, Concert, Economy e Time**, con per ogni oggetto **campi, tipo di dato, range, valore iniziale e cosa lo modifica**.

Dopo quella, passiamo alle **formule numeriche vere**, facendo anche qualche simulazione tipo *"gioco 30 giorni da principiante: quanti soldi/fan/skill dovrei avere?"*. Quello ci permetterà di bilanciare la V1 **prima** di scrivere codice.

# Game Rules Specification

Perfetto. Facciamola **davvero come una specifica tecnica**, non come una semplice lista di idee.

Una correzione importante rispetto a prima: **il tempo sarà reale**. La giornata dura **600 secondi reali**, e quando parte un'azione il gioco entra nello stato `BUSY` per la sua durata. Il giocatore non perde il tempo istantaneamente: lo vive.

# **🎵 Music Superstar Simulator**

## **V1.0 — Game Rules Specification**

**Versione:** 1.0  
**Obiettivo:** creare un vertical slice completo e giocabile del career loop.

---

# **1\. TIME — Sistema del tempo**

Questo è il sistema centrale della V1.

## **1.1 Dati**

| Campo | Tipo | Range | Valore iniziale |
| ----- | ----- | ----- | ----- |
| `day` | int | 1 → ∞ | 1 |
| `time_remaining` | float | 0 → 600 | 600 |
| `day_duration` | const | 600 | 600 |
| `is_action_running` | bool | true/false | false |
| `current_action` | Action/null | — | null |

### **Regola fondamentale**

1 giornata \= 600 secondi reali

Il timer scorre continuamente.

10:00  
 ↓  
09:59  
 ↓  
09:58  
 ↓  
...  
 ↓  
00:01  
 ↓  
00:00  
 ↓  
NUOVO GIORNO  
---

# **2\. Action — Azioni**

Un'azione è un'attività che il personaggio può eseguire.

Ogni Action avrà:

| Campo | Tipo | Descrizione |
| ----- | ----- | ----- |
| `id` | string | identificatore |
| `name` | string | nome visualizzato |
| `duration` | float | durata in secondi |
| `energy_cost` | int | energia consumata |
| `stress_change` | int | variazione stress |
| `morale_change` | int | variazione morale |
| `money_cost` | float | costo |
| `location_required` | string | luogo necessario |
| `xp_rewards` | Dictionary | XP prodotti |
| `interruptible` | bool | può essere interrotta? |

---

# **3\. Durata delle azioni**

Le categorie rimangono:

| Categoria | Durata |
| ----- | ----- |
| Rapida | 5–15 s |
| Media | 20–60 s |
| Lunga | 61–180 s |
| Molto lunga | 181–600 s |

Ma **non significa che tutte le azioni debbano appartenere rigidamente a queste categorie**.

Sono semplicemente fasce di design.

---

# **4\. Stato `BUSY`**

Quando il giocatore seleziona un'azione:

Player  
 ↓  
Action selected  
 ↓  
Check requirements  
 ↓  
Start Action  
 ↓  
BUSY  
 ↓  
Timer  
 ↓  
Action completed  
 ↓  
IDLE

Durante `BUSY`:

il tempo continua  
l'azione continua  
il personaggio consuma risorse  
possono verificarsi eventi

Il giocatore **non può iniziare una seconda attività contemporaneamente** nella V1.

---

# **5\. Esempio concreto**

Il giocatore è a casa:

Giorno 1  
08:24

Energia: 80  
Stress: 15  
Morale: 70  
Denaro: €500

Sceglie:

> Allenamento rapido — 10 secondi

Parte:

08:24  
        ↓  
🎸 Allenamento...

████████░░░░░░░░

7 / 10 sec

Dopo 10 secondi:

08:34

\+5 XP Strumento  
\-5 Energia  
\+2 Stress

E torna disponibile:

COSA VUOI FARE?

**Il tempo è realmente passato da 08:24 a 08:34.**

---

# **6\. Tempo morto**

Qui fissiamo definitivamente la regola.

Se il giocatore non seleziona niente:

IDLE

il tempo **continua comunque a scorrere**.

Non viene congelato.

Esempio:

08:34  
IDLE

08:35  
IDLE

08:36  
IDLE

Quindi il giocatore può anche semplicemente **non fare nulla**.

Questo ha senso perché il tempo è una risorsa.

---

# **7\. `PASS TIME`**

Per evitare che il giocatore debba aspettare manualmente senza motivo, inseriamo un'azione speciale:

### **Passa tempo**

\[ Passa 10 sec \]  
\[ Passa 30 sec \]  
\[ Passa 60 sec \]

Questa non è un'attività vera e propria.

È semplicemente:

WAIT

Durante il `WAIT`:

* non guadagni XP;  
* non consumi energia;  
* il tempo passa;  
* possono verificarsi eventi temporizzati;  
* vengono applicati eventuali effetti passivi.

---

# **8\. Time Scaling**

Per la V1 io **non introdurrei ancora la possibilità di accelerare il tempo**.

Quindi:

1 secondo reale  
\=  
1 secondo di gioco

Questo rende il sistema estremamente prevedibile.

Più avanti potremo eventualmente introdurre:

x1  
x2  
x4  
PAUSA

ma non nella prima versione.

---

# **9\. PLAYER**

## **Dati anagrafici**

| Campo | Tipo | Range |
| ----- | ----- | ----- |
| `name` | string | — |
| `age` | int | 16–60 |
| `country` | string | — |
| `city` | string | — |
| `background` | enum | — |
| `housing` | enum | — |
| `instrument` | enum | — |

---

# **10\. Risorse Player**

| Campo | Tipo | Range | Iniziale |
| ----- | ----- | ----- | ----- |
| `energy` | int | 0–100 | 100 |
| `stress` | int | 0–100 | 20 |
| `morale` | int | 0–100 | 70 |
| `money` | float | ≥0 | dipende dal background |
| `fans` | int | ≥0 | 0 |
| `popularity` | float | 0–100 | 0 |

### **Energia**

0 \= esausto  
100 \= completamente riposato

### **Stress**

0 \= nessuno stress  
100 \= stress massimo

### **Morale**

0 \= pessimo  
100 \= eccellente  
---

# **11\. SKILL**

Le sette skill allenabili:

Voice  
Instrument  
Songwriting  
Composition  
Charisma  
Performance  
Production

Tutte:

0 → 100

## **Struttura**

Ogni skill avrà:

| Campo | Tipo |
| ----- | ----- |
| `level` | int |
| `xp` | float |
| `xp_to_next` | float |

Esempio:

Instrument

Level: 12  
XP: 340  
Next level: 500  
---

# **12\. Popolarità ≠ Skill**

`Popularity` è separata.

Non esisterà:

Allenamento → \+Popularity

Invece:

Canzoni  
Concerti  
Fan  
Attività della carriera  
        ↓  
   POPOLARITÀ

Questo impedisce al giocatore di diventare famoso semplicemente facendo flessioni davanti allo specchio.

---

# **13\. SONG**

Ogni canzone è un oggetto indipendente.

| Campo | Tipo | Range |
| ----- | ----- | ----- |
| `id` | string | — |
| `title` | string | — |
| `genre` | enum | — |
| `style` | enum | — |
| `energy` | int | 0–100 |
| `melody` | int | 0–100 |
| `rhythm` | int | 0–100 |
| `originality` | int | 0–100 |
| `commerciality` | int | 0–100 |
| `production` | int | 0–100 |
| `quality` | float | 0–100 |
| `status` | enum | Draft/Released |
| `release_day` | int/null | — |

---

# **14\. Generi V1**

Partirei con **6 generi**:

Rock  
Pop  
Metal  
Hip-Hop  
Electronic  
Latin

Il genere non determina completamente la canzone.

Un giocatore può creare, ad esempio:

Rock  
\+  
alta energia  
\+  
alta originalità  
\+  
produzione pesante

oppure:

Rock  
\+  
melodia elevata  
\+  
commercialità elevata  
---

# **15\. Creazione della canzone**

La canzone nasce attraverso cinque fasi:

1\. Genere/Stile  
       ↓  
2\. Composizione  
       ↓  
3\. Testo  
       ↓  
4\. Produzione  
       ↓  
5\. Calcolo qualità

Ogni fase consuma **tempo**.

Potenzialmente anche denaro.

---

# **16\. SONG QUALITY**

La qualità finale sarà:

QUALITY \=  
Composition contribution  
\+ Songwriting contribution  
\+ Production contribution  
\+ Musical attributes  
\+ Random factor

Normalizzata:

0 → 100

La formula precisa la fissiamo nella **fase Formula Specification**, dopo aver definito esattamente quanto deve pesare ogni componente.

Questa separazione è importante: prima definiamo la struttura, poi bilanciamo i numeri.

---

# **17\. VENUE**

Ogni locale è un oggetto.

| Campo | Tipo | Range |
| ----- | ----- | ----- |
| `id` | string | — |
| `name` | string | — |
| `capacity` | int | \>0 |
| `prestige` | int | 0–100 |
| `required_popularity` | float | 0–100 |
| `rental_cost` | float | ≥0 |
| `concert_duration` | float | \>0 |

---

# **18\. Venue V1**

### **Casa / sala prove**

Non è un vero concerto.

Serve come punto di partenza.

### **Bar**

Capacity: \~50

### **Piccolo Club**

Capacity: \~150

I valori sono **provvisori** e saranno bilanciati.

---

# **19\. CONCERT**

Un concerto rappresenta una singola esibizione.

| Campo | Tipo |
| ----- | ----- |
| `venue_id` | string |
| `song_ids` | Array |
| `duration` | float |
| `audience` | int |
| `performance_score` | float |
| `fans_gained` | int |
| `money_earned` | float |
| `popularity_change` | float |

---

# **20\. Concert Score**

La base sarà:

Performance  
\+  
Charisma  
\+  
Song Quality  
\+  
Popularity  
\+  
Randomness

Normalizzata:

0 → 100

Questo punteggio determina il risultato del concerto.

---

# **21\. Audience**

Il numero di spettatori non deve superare:

Venue.capacity

La domanda dipenderà principalmente da:

Popularity

con influenza di:

Song Quality  
Concert Score

Quindi:

Popularity bassa  
→ pochi spettatori

Popularity alta  
→ maggiore domanda

ma il concerto può comunque andare male.

---

# **22\. FAN**

V1 contiene un solo contatore:

fans : int

Nessuna divisione geografica.

Nessuna demografia.

Nessun:

Rock fans  
Pop fans  
Brazil fans  
Japan fans

ancora.

---

# **23\. ECONOMY**

## **Entrate**

Concerti  
Vendita musica

## **Uscite**

Studio  
Sala prove  
Trasporti  
Produzione  
Strumenti  
Affitto venue

Ogni transazione dovrebbe avere:

amount  
reason  
day

Questo ci permette in futuro di creare uno storico economico.

---

# **24\. Trasporti**

V1:

PIEDI  
BUS  
TAXI

Ogni trasporto:

| Trasporto | Tempo | Costo |
| ----- | ----- | ----- |
| Piedi | alto | €0 |
| Bus | medio | basso |
| Taxi | basso | alto |

I valori esatti verranno bilanciati.

Esempio:

Casa → Studio

Piedi: 110 sec / €0  
Bus:    50 sec / €2  
Taxi:   20 sec / €12

Questa è una vera scelta:

> Ho più tempo o più soldi?

---

# **25\. Progressione**

Livelli iniziali:

LEVEL 0  
Principiante

        ↓

LEVEL 1  
Musicista

        ↓

LEVEL 2  
Artista emergente

        ↓

LEVEL 3  
Artista affermato

I requisiti saranno basati su combinazioni di:

Fan  
Popolarità  
Canzoni pubblicate  
Skill  
Concerti  
---

# **26\. Fine giornata**

Quando:

time\_remaining \= 0

il gioco esegue:

END DAY

### **Aggiornamenti**

* recupero energia;  
* variazione stress;  
* variazione morale;  
* eventuali entrate giornaliere;  
* eventi;  
* statistiche;  
* controllo level-up;  
* salvataggio automatico.

Poi:

day \+= 1  
time\_remaining \= 600

e viene mostrato:

╔══════════════════════════╗  
║      FINE GIORNATA       ║  
╠══════════════════════════╣  
║ Giorno: 12               ║  
║                          ║  
║ XP ottenuti: \+87         ║  
║ Fan: \+124                ║  
║ Popolarità: \+1.4         ║  
║ Denaro: \+€73             ║  
║                          ║  
║ Energia: 42              ║  
║ Stress: 31               ║  
║ Morale: 76               ║  
╚══════════════════════════╝  
---

# **27\. SAVE GAME**

Il salvataggio deve contenere tutto ciò che serve per ricostruire la partita:

SAVE  
│  
├── Player  
│   ├── identity  
│   ├── resources  
│   ├── skills  
│   └── career  
│  
├── Time  
│   ├── day  
│   └── time  
│  
├── Songs  
│   └── all songs  
│  
├── Venues  
│   └── unlocked venues  
│  
└── Economy  
    └── transaction history  
---

# **28\. Regola architetturale fondamentale**

Separiamo **dati**, **regole** e **interfaccia**.

DATA  
Player  
Song  
Venue  
Concert  
Action

       ↓

SYSTEMS  
TimeSystem  
SkillSystem  
MusicSystem  
ConcertSystem  
EconomySystem  
ProgressionSystem

       ↓

UI  
Menu  
HUD  
Action Menu  
Song Creator  
Concert Screen  
Daily Summary

La UI **non deve contenere le regole del gioco**.

Per esempio, il pulsante:

\[Allenati\]

non deve decidere direttamente quanto XP dare.

Il pulsante dice semplicemente:

ActionSystem.start\_action("practice")

e sarà il sistema di gioco a determinare cosa succede.

---

# **29\. La V1 completa, quindi**

Abbiamo ora questo modello:

                        ┌──────────────┐  
                         │    PLAYER    │  
                         └──────┬───────┘  
                                │  
             ┌──────────────────┼──────────────────┐  
             ↓                  ↓                  ↓  
         SKILLS             RESOURCES          CAREER  
             │                  │                  │  
             ↓                  ↓                  ↓  
        Allenamento        Energia/Stress     Fan/Popularity  
             │                                     │  
             └──────────────┐                      │  
                            ↓                      │  
                         SONGS ←───────────────────┘  
                            │  
                            ↓  
                         CONCERT  
                            │  
                   ┌────────┴────────┐  
                   ↓                 ↓  
                 MONEY             FANS  
                   │                 │  
                   └────────┬────────┘  
                            ↓  
                       PROGRESSION  
                            │  
                            ↓  
                      NUOVI VENUE  
                            │  
                            └──────────→ LOOP

## **🔴 Ma manca ancora una cosa prima del codice**

Questa specifica definisce **la struttura**, ma non abbiamo ancora fissato i numeri definitivi.

Il prossimo documento dovrebbe essere:

# **`V1.0 Formula & Balance Specification`**

Lì fissiamo matematicamente:

1. **XP per ogni azione**  
2. **formula del rendimento marginale**  
3. **XP necessario per ogni livello**  
4. **recupero energia**  
5. **stress generato dalle azioni**  
6. **morale**  
7. **formula degli attributi della canzone**  
8. **qualità finale della canzone**  
9. **probabilità/risultato del concerto**  
10. **spettatori**  
11. **fan guadagnati**  
12. **popolarità**  
13. **guadagni dei concerti**  
14. **guadagni delle canzoni**  
15. **costi**  
16. **requisiti per sbloccare i venue**  
17. **progressione dei primi 30 giorni**

E soprattutto farei **una simulazione matematica della V1**: prendiamo un artista appena creato e simuliamo 10, 30 e 60 giorni per verificare che non succeda una cosa tipo *"Giorno 3: sono una superstar mondiale, ho 8 miliardi di fan e possiedo Wembley"*. 😄

Quello è il passaggio che trasformerebbe questa da una bella idea a un **game design realmente implementabile**.

# Formula & Balance Specification

# **V1.0 — Formula & Balance Specification**

Questo documento definisce **come funzionano matematicamente i sistemi della V1**: XP, livelli, qualità delle canzoni, concerti, fan, popolarità, energia, stress, morale, soldi e progressione.

L'obiettivo della V1 non è avere un bilanciamento perfetto, ma avere un sistema **coerente, prevedibile e facilmente modificabile**.

> **Principio fondamentale:** tutte le formule devono essere centralizzate. Non vogliamo avere numeri sparsi nel codice tipo `+17 fan` in 14 posti diversi. Altrimenti al primo bilanciamento diventiamo archeologi del nostro stesso codice. 😄

---

# **1\. Principi di bilanciamento**

La V1 deve rispettare questi principi:

### **1.1 Il giocatore deve percepire la progressione**

Ogni attività importante deve produrre almeno uno di questi risultati:

* miglioramento di una skill;  
* aumento della qualità musicale;  
* aumento dei fan;  
* aumento della popolarità;  
* guadagno di denaro;  
* sblocco di nuove possibilità.

Il giocatore deve avere la sensazione:

> **"Quello che ho fatto oggi mi ha fatto avanzare."**

---

### **1.2 Il tempo è una risorsa**

Il tempo non è semplicemente un numero che diminuisce.

Ogni attività ha:

DURATA  
ENERGIA  
STRESS  
MORALE  
DENARO  
RICOMPENSA

Un'attività molto potente deve normalmente avere un costo maggiore.

Esempio:

| Attività | Tempo | Energia | Ricompensa |
| ----- | ----- | ----- | ----- |
| Allenamento leggero | 10 sec | \-5 | poco XP |
| Allenamento intenso | 40 sec | \-15 | molto XP |
| Studio approfondito | 80 sec | \-25 | XP elevato |
| Sessione studio professionale | 180 sec | \-40 | XP molto elevato |

Quindi non deve esistere una singola attività dominante che conviene fare sempre.

---

# **2\. Sistema XP**

Le 7 skill allenabili sono:

* Voice  
* Instrument  
* Songwriting  
* Composition  
* Charisma  
* Performance  
* Production

Ogni skill possiede:

level  
xp  
xp\_to\_next  
---

## **2.1 Livello massimo**

Per la V1:

Skill Level: 1 → 100

La skill effettiva può quindi essere rappresentata come:

0 → 100

Per semplicità possiamo iniziare con:

Skill 0 \= completamente inesperto  
Skill 100 \= livello massimo

Il sistema XP serve a determinare la crescita graduale.

---

# **3\. Formula XP**

Proposta V1:

XP necessario \= 100 \+ (Level × 25\)

Esempio:

| Livello | XP necessario |
| ----- | ----- |
| 1 | 125 |
| 2 | 150 |
| 3 | 175 |
| 4 | 200 |
| 5 | 225 |
| 10 | 350 |
| 20 | 600 |
| 50 | 1350 |
| 100 | 2600 |

Questa è una **prima curva di bilanciamento**.

Non dobbiamo decidere ora che sarà definitiva.

---

# **4\. Diminishing Returns**

Questo è molto importante.

Non vogliamo che il giocatore possa semplicemente:

> "Faccio 200 volte la stessa attività e divento un dio."

Quindi introduciamo il **diminishing return**.

Più una skill è alta, meno XP ottiene dalla stessa attività.

Possiamo usare:

XP finale \= XP base × (1 \- Skill / 150\)

Esempio con attività da 20 XP:

### **Skill 10**

20 × (1 \- 10/150)  
\= 18.67 XP

### **Skill 50**

20 × (1 \- 50/150)  
\= 13.33 XP

### **Skill 90**

20 × (1 \- 90/150)  
\= 8 XP

Questo crea un comportamento interessante:

**all'inizio impari velocemente, poi migliorare diventa sempre più difficile.**

---

# **5\. Durata → ricompensa**

Le attività avranno una ricompensa base proporzionata alla loro durata.

Proposta iniziale:

| Categoria | Durata | XP base indicativo |
| ----- | ----- | ----- |
| Quick | 5–15 sec | 3–8 |
| Medium | 20–60 sec | 8–20 |
| Long | 61–180 sec | 20–45 |
| Very Long | 181–600 sec | 45–100 |

Ma attenzione:

**durata maggiore ≠ sempre migliore.**

Una sessione da 180 secondi potrebbe dare più XP, ma consumare molta energia e aumentare stress.

Quindi il giocatore deve scegliere:

> "Faccio 10 allenamenti piccoli?"

oppure:

> "Faccio una sessione seria e poi mi riposo?"

---

# **6\. Energia**

Range:

0 → 100

Valore iniziale:

100

L'energia viene consumata dalle attività.

Esempio:

| Attività | Energia |
| ----- | ----- |
| Allenamento leggero | \-5 |
| Allenamento normale | \-10 |
| Allenamento intenso | \-20 |
| Studio musicale | \-10 |
| Studio professionale | \-25 |
| Concerto | \-30 |
| Viaggio | 0 / piccolo costo |

---

## **6.1 Energia bassa**

L'energia influenza le attività.

Proposta:

Energy \> 70      → rendimento 100%  
Energy 40–70     → rendimento 90%  
Energy 20–40     → rendimento 70%  
Energy 1–20      → rendimento 50%  
Energy \= 0       → attività fisiche bloccate

Quindi arrivare a 0 non significa necessariamente:

> "Game Over."

Significa:

> "Non puoi continuare a spingere: devi recuperare."

---

# **7\. Recupero energia**

Durante il riposo:

Energy \+ X

Possiamo introdurre diversi livelli:

| Attività | Tempo | Energia |
| ----- | ----- | ----- |
| Pausa | 10 sec | \+3 |
| Relax | 30 sec | \+10 |
| Riposo | 60 sec | \+20 |
| Dormire | fine giornata | grande recupero |

Il sonno sarà collegato all'**End of Day**.

---

# **8\. Stress**

Range:

0 → 100

Valore iniziale:

20

Lo stress aumenta con:

* lavoro;  
* concerti;  
* sessioni intense;  
* problemi;  
* mancanza di riposo;  
* eventi negativi.

Diminuisce con:

* riposo;  
* socializzazione;  
* divertimento;  
* tempo libero;  
* sonno.

---

## **8.1 Effetto dello stress**

| Stress | Effetto |
| ----- | ----- |
| 0–30 | nessuna penalità |
| 31–60 | \-5% rendimento |
| 61–80 | \-15% rendimento |
| 81–100 | \-30% rendimento |

Questo crea una scelta interessante.

Puoi continuare ad allenarti anche se sei stressato, ma:

> **stai sacrificando efficienza per guadagnare tempo.**

---

# **9\. Morale**

Range:

0 → 100

Valore iniziale:

70

Il morale rappresenta quanto il personaggio sta vivendo positivamente la propria carriera.

Aumenta con:

* concerti riusciti;  
* amici;  
* divertimento;  
* successi;  
* nuove canzoni;  
* aumento dei fan.

Diminuisce con:

* fallimenti;  
* stress elevato;  
* mancanza di soldi;  
* concerti pessimi;  
* eventi negativi.

---

# **10\. Effetto morale**

Proposta:

Morale \> 70      → \+5% rendimento  
Morale 40–70     → nessun modificatore  
Morale 20–40     → \-10%  
Morale 0–20      → \-20%

Questo significa che il giocatore viene incentivato a **gestire la propria vita**, non solo a grindare skill.

---

# **11\. Efficienza complessiva**

Quando un'attività assegna XP possiamo calcolare:

XP finale \=  
XP base  
× modificatore energia  
× modificatore stress  
× modificatore morale  
× diminishing return

Questa diventa una delle formule centrali del gioco.

---

# **12\. Skill iniziali**

In fase di creazione personaggio non vogliamo che tutti partano uguali.

Esempio:

### **Cantante**

Voice        25  
Instrument   5  
Songwriting  10  
Composition  10  
Charisma     15  
Performance  15  
Production   5

### **Chitarrista**

Voice        5  
Instrument   25  
Songwriting  10  
Composition  15  
Charisma     10  
Performance  15  
Production   5

### **Producer**

Voice        5  
Instrument   10  
Songwriting  15  
Composition  20  
Charisma     5  
Performance  5  
Production   30

Questi valori sono **esempi di bilanciamento**, non ancora definitivi.

---

# **13\. Qualità della canzone**

La qualità della canzone deve dipendere dalle skill del giocatore e dalle caratteristiche della canzone.

Abbiamo:

Energy  
Melody  
Rhythm  
Originality  
Commerciality  
Production

e le skill:

Songwriting  
Composition  
Production  
---

## **13.1 Formula V1**

Proposta:

Quality \=  
Composition × 0.25  
\+ Songwriting × 0.20  
\+ Production × 0.20  
\+ Melody × 0.10  
\+ Rhythm × 0.10  
\+ Originality × 0.10  
\+ Energy × 0.05

Risultato:

0 → 100

La somma dei pesi è:

25 \+ 20 \+ 20 \+ 10 \+ 10 \+ 10 \+ 5 \= 100%  
---

# **14\. Commercialità**

La commercialità **non deve essere inclusa pesantemente nella Quality**.

Questo è importante.

Una canzone può essere:

molto bella  
ma poco commerciale

oppure:

molto commerciale  
ma mediocre

Quindi:

Quality ≠ Commercial Success

La commercialità verrà utilizzata soprattutto nel sistema di:

* vendite;  
* crescita dei fan;  
* popolarità;  
* successo del singolo.

---

# **15\. Randomness della canzone**

Non vogliamo che una formula matematica dica:

> "Hai Quality 74 → sicuramente successo."

Introduciamo una piccola componente casuale.

Per esempio:

Random Factor \= \-5 → \+5

Quindi:

Final Quality \=  
Calculated Quality \+ Random Factor

Limitando poi il risultato:

0 → 100

La casualità deve essere **piccola**.

Non vogliamo che una canzone pessima diventi improvvisamente il singolo del secolo perché il dado ha deciso di ubriacarsi.

---

# **16\. Sistema di pubblicazione**

Quando viene pubblicato un singolo:

Song.status \= Released  
Song.release\_day \= current\_day

La canzone può iniziare a generare:

* fan;  
* popolarità;  
* vendite.

Il risultato dipende da:

Quality  
Commerciality  
Popularity

più una componente casuale.

---

# **17\. Popolarità**

La popolarità è:

0 → 100

Non è una skill.

Il giocatore **non può allenare direttamente la popolarità**.

Può però influenzarla attraverso:

* concerti;  
* pubblicazioni;  
* fan;  
* eventi;  
* risultati musicali.

Questo evita una situazione assurda del tipo:

> "Mi alleno a essere famoso."

---

# **18\. Fanbase**

I fan sono un valore intero:

0 → ∞

La crescita iniziale deve essere lenta.

Esempio indicativo:

0–100 fan      → artista sconosciuto  
100–500        → piccolo pubblico  
500–1.000      → seguito iniziale  
1.000–10.000   → artista emergente

Queste fasce sono indicative e potranno essere modificate.

---

# **19\. Formula fan da un concerto**

Proposta:

Base Fans \=  
Audience × Conversion Rate

dove il Conversion Rate dipende dal risultato del concerto.

Esempio:

| Concert Score | Conversion |
| ----- | ----- |
| 0–30 | 1% |
| 31–50 | 2% |
| 51–70 | 4% |
| 71–85 | 7% |
| 86–100 | 10% |

Quindi:

100 spettatori  
× 7%  
\= 7 nuovi fan  
---

# **20\. Performance del concerto**

Il punteggio del concerto:

Performance Score \=  
Performance × 0.30  
\+ Music Quality × 0.25  
\+ Popularity × 0.20  
\+ Charisma × 0.15  
\+ Random × 0.10

Dove:

Random \= 0 → 100

Questo produce:

0 → 100  
---

# **21\. Audience**

Il numero di spettatori non deve essere sempre uguale alla capacità del locale.

Esempio:

Venue Capacity \= 150

Ma l'artista potrebbe avere:

Popularity \= 5

e quindi vendere soltanto:

30–50 biglietti

Un artista con:

Popularity \= 60

potrebbe invece riempire quasi completamente il locale.

Quindi:

Audience \=  
f(Popularity, Music Quality, Venue, Randomness)  
---

# **22\. Soldi da un concerto**

Formula semplice V1:

Gross Revenue \=  
Tickets Sold × Ticket Price

Poi:

Net Revenue \=  
Gross Revenue  
\- Venue Cost  
\- Transport Cost  
\- Other Costs

Esempio:

80 spettatori  
× €10

\= €800

Venue \= €150  
Transport \= €20

Net \= €630  
---

# **23\. Prezzo del biglietto**

Il prezzo deve dipendere dal livello del locale.

Esempio:

| Venue | Ticket |
| ----- | ----- |
| Bar | €5 |
| Small Club | €10 |
| Club | €15 |
| Arena | €30+ |

Nella V1 ci limiteremo ai primi locali.

---

# **24\. Vendite musicali**

Per la V1 non vogliamo creare subito Spotify, classifiche, royalties, streaming ecc.

Usiamo un sistema astratto.

Una canzone genera:

Sales \=  
Base Sales  
× Quality Modifier  
× Commerciality Modifier  
× Popularity Modifier

Il risultato genera:

Money  
Fans  
Popularity

Questo ci permette di simulare il successo senza costruire un'intera industria musicale già nella V1.

---

# **25\. Economia iniziale**

Il background determina il denaro iniziale.

Esempio:

| Background | Denaro |
| ----- | ----- |
| Student | €100 |
| Unemployed | €200 |
| Worker | €800 |

Sono valori iniziali modificabili.

Lo scopo è creare situazioni diverse.

Un lavoratore:

> più soldi → meno tempo.

Uno studente:

> meno soldi → più tempo.

Quindi il background non è semplicemente una scelta estetica.

---

# **26\. Sistema di trasporto**

Il trasporto deve rappresentare un trade-off:

> **tempo vs denaro**

Esempio:

| Trasporto | Tempo | Costo |
| ----- | ----- | ----- |
| Walk | 110 sec | €0 |
| Bus | 50 sec | €2 |
| Taxi | 20 sec | €12 |

Questi numeri sono puramente iniziali.

La formula economica non deve essere:

> "Taxi \= sempre migliore."

Il taxi deve essere utile quando:

* hai poco tempo;  
* hai un concerto imminente;  
* devi arrivare rapidamente.

---

# **27\. Progressione della carriera**

La progressione non deve dipendere da una sola statistica.

Per sbloccare un livello possiamo utilizzare più requisiti.

### **Beginner**

Condizione iniziale:

0 fan

### **Musician**

Esempio:

Average Skill ≥ 10  
AND  
Fans ≥ 50  
AND  
1 concerto completato

### **Emerging Artist**

Esempio:

Average Skill ≥ 20  
AND  
Fans ≥ 1.000  
AND  
3 canzoni pubblicate  
AND  
5 concerti completati

Questi numeri sono **provvisori**.

---

# **28\. Regola importante: niente grinding obbligatorio**

Un buon sistema deve permettere diversi percorsi.

Per esempio:

### **Percorso live**

Allenamento  
↓  
Concerti  
↓  
Fan  
↓  
Popolarità  
↓  
Locali migliori

### **Percorso musicale**

Songwriting  
↓  
Composizione  
↓  
Produzione  
↓  
Canzoni  
↓  
Release  
↓  
Fan

### **Percorso sociale**

Charisma  
↓  
Relazioni/Eventi  
↓  
Opportunità  
↓  
Concerti/Collaborazioni

Nella V1 il terzo percorso sarà molto più semplice, perché il sistema sociale avanzato è stato escluso.

---

# **29\. Sistema di rischio**

Le attività più importanti possono avere un piccolo rischio.

Esempio:

Concert Score

può produrre:

| Risultato | Conseguenza |
| ----- | ----- |
| 0–30 | perdita di morale |
| 31–50 | risultato mediocre |
| 51–70 | buon concerto |
| 71–85 | ottimo concerto |
| 86–100 | grande successo |

Questo rende il gioco meno deterministico.

---

# **30\. Relazione tra sistemi**

La cosa importante è che i sistemi **non devono vivere separati**.

Esempio:

ALLENAMENTO  
     ↓  
   SKILL  
     ↓  
 CANZONE  
     ↓  
 QUALITY  
     ↓  
 CONCERTO  
     ↓  
 ┌───────┼────────┐  
 ↓       ↓        ↓  
FAN   MONEY   POPULARITY  
 ↓       ↓        ↓  
CAREER ←┴────────┘

Contemporaneamente:

ATTIVITÀ  
   ↓  
TIME  
   ↓  
ENERGY  
   ↓  
STRESS  
   ↓  
MORALE  
   ↓  
EFFICIENCY

Questa è la parte veramente importante del design.

---

# **31\. Regola anti-abuso**

Ogni sistema deve avere almeno un limite.

Esempi:

**Allenamento**

diminishing returns

**Energia**

limite 0–100

**Stress**

penalità oltre determinate soglie

**Soldi**

costi ricorrenti

**Concerti**

venue requirements

**Popolarità**

crescita graduale

**Fan**

conversione proporzionale al risultato

Questo impedisce al giocatore di trovare una strategia dominante troppo facilmente.

---

# **32\. Numeri che NON fissiamo ancora**

Alcune formule devono rimanere **placeholder**.

Non conviene decidere adesso valori precisi per:

* prezzo di ogni strumento;  
* costo di ogni studio;  
* costo di ogni città;  
* guadagni delle singole canzoni;  
* crescita giornaliera dei fan;  
* probabilità degli eventi;  
* requisiti di tutte le carriere;  
* prezzi di tutti i locali;  
* costi delle produzioni;  
* numero esatto di XP per ogni attività.

Prima realizziamo il sistema.

Poi lo **playtestiamo**.

---

# **33\. Costanti centralizzate**

Nel progetto dovremo avere qualcosa concettualmente simile a:

BALANCE  
│  
├── TIME  
├── ENERGY  
├── STRESS  
├── MORALE  
├── XP  
├── SKILLS  
├── SONG  
├── CONCERT  
├── FANS  
├── POPULARITY  
├── ECONOMY  
└── PROGRESSION

In questo modo, se durante il test scopriamo:

> "I fan crescono troppo velocemente."

non dobbiamo cercare la formula in mezzo a tutto il progetto.

Cambiamo una costante.

---

# **34\. Primo obiettivo di bilanciamento**

Per la V1 vogliamo ottenere indicativamente questo ritmo:

### **Prime giornate**

Il giocatore:

crea personaggio  
↓  
si allena  
↓  
crea prima canzone  
↓  
trova primo piccolo concerto  
↓  
guadagna primi fan

Deve vedere risultati rapidamente.

---

### **Prime settimane**

Dovrebbe arrivare a:

migliori skill  
\+  
alcune canzoni  
\+  
diversi concerti  
\+  
qualche centinaio di fan  
\+  
nuovi locali  
---

### **Medio termine**

Dovrebbe iniziare a percepire:

"Ok, ora non sono più completamente sconosciuto."

e avere accesso a nuove possibilità.

---

# **35\. Regola fondamentale del bilanciamento V1**

Il gioco deve evitare due estremi.

### **Troppo facile**

allenamento  
→  
canzone  
→  
successo  
→  
fama  
→  
superstar

in pochissimo tempo.

### **Troppo lento**

allenamento  
→  
\+2 XP  
→  
allenamento  
→  
\+2 XP  
→  
allenamento  
→  
\+2 XP

per ore.

Il nostro obiettivo è:

> **progressione lenta abbastanza da avere valore, ma veloce abbastanza da essere percepita.**

---

# **36\. Struttura finale della V1 Formula Specification**

Quindi, al momento abbiamo:

V1.0 FORMULA & BALANCE  
│  
├── XP SYSTEM  
│   ├── XP requirements  
│   ├── Diminishing returns  
│   └── Activity rewards  
│  
├── PLAYER CONDITION  
│   ├── Energy  
│   ├── Stress  
│   └── Morale  
│  
├── MUSIC  
│   ├── Song Quality  
│   ├── Commerciality  
│   └── Randomness  
│  
├── CONCERT  
│   ├── Performance Score  
│   ├── Audience  
│   ├── Fans  
│   └── Revenue  
│  
├── CAREER  
│   ├── Fans  
│   ├── Popularity  
│   └── Career Levels  
│  
├── ECONOMY  
│   ├── Income  
│   ├── Expenses  
│   └── Transportation  
│  
└── BALANCE RULES  
    ├── Anti-grinding  
    ├── Anti-abuse  
    └── Progression pacing

### **Una cosa importante**

Questa **non è ancora la versione matematica definitiva**. È la nostra **baseline V1**: abbiamo deciso la struttura delle formule e dei principali valori iniziali, lasciando volutamente alcuni numeri da tarare durante il playtest.

Il prossimo documento logico sarebbe **V1.0 — Game Systems Specification**, dove prendiamo queste formule e definiamo **come devono comportarsi concretamente `TimeSystem`, `ActionSystem`, `SkillSystem`, `MusicSystem`, `ConcertSystem`, `EconomySystem`, `ProgressionSystem` e `SaveSystem`**, senza ancora scrivere codice.

# Game Systems Specification

Perfetto. A questo punto abbiamo **GDD → V1.0 Game Rules → V1.0 Formula & Balance**. Ora facciamo il passaggio più importante prima del codice: definire **come funzionano concretamente i sistemi del gioco e come comunicano tra loro**.

# **V1.0 — Game Systems Specification**

## **0\. Obiettivo del documento**

Questo documento definisce la struttura logica della V1.

Non descrive ancora:

* codice GDScript;  
* scene Godot;  
* pulsanti specifici;  
* animazioni;  
* grafica.

Descrive invece:

> **chi gestisce cosa, quali dati riceve, cosa modifica e cosa restituisce.**

L'architettura deve essere abbastanza semplice da poter essere implementata ora, ma abbastanza ordinata da poter essere ampliata in futuro.

---

# **1\. Architettura generale**

La V1 sarà divisa in tre grandi livelli:

┌──────────────────────────────┐  
│              UI              │  
│ Menu / HUD / schermate       │  
└──────────────┬───────────────┘  
               │  
               ▼  
┌──────────────────────────────┐  
│           SYSTEMS            │  
│ Time / Action / Music / etc. │  
└──────────────┬───────────────┘  
               │  
               ▼  
┌──────────────────────────────┐  
│             DATA             │  
│ Player / Song / Venue / etc. │  
└──────────────────────────────┘

La regola fondamentale:

> **La UI non decide le regole del gioco.**

Per esempio, il pulsante:

> "Allenamento intenso"

non deve decidere quanto XP dare.

Il pulsante comunica semplicemente:

start\_action("intense\_training")

e sarà `ActionSystem` a verificare:

* tempo disponibile;  
* energia;  
* luogo;  
* costi;  
* ricompense;  
* effetti.

---

# **2\. Game Manager**

Avremo un sistema centrale:

GameManager

Il suo compito è coordinare il gioco.

Non deve contenere tutte le formule.

Deve principalmente sapere:

game\_state  
current\_day  
current\_time  
player  
active\_systems

e permettere ai vari sistemi di comunicare.

Schema:

                GameManager  
                 /    |    \\  
                /     |     \\  
               ▼      ▼      ▼  
          TimeSystem ActionSystem SaveSystem  
               │         │  
               ▼         ▼  
           Player     SkillSystem  
                         │  
                         ▼  
                    MusicSystem  
                         │  
                         ▼  
                   ConcertSystem  
---

# **3\. TimeSystem**

Questo è uno dei sistemi più importanti perché **tutto il gioco gira attorno al tempo**.

## **Responsabilità**

Gestisce:

* giorno;  
* ora/minuti/secondi;  
* calendario;  
* avanzamento del tempo;  
* azioni temporizzate;  
* fine giornata;  
* eventi temporali.

---

# **4\. Calendario V1**

Inseriamo ufficialmente il calendario nella struttura V1, utilizzando per semplicità:

12 mesi  
30 giorni per mese  
7 giorni per settimana  
360 giorni per anno

Non utilizziamo ancora un calendario gregoriano reale.

È una scelta tecnica:

> vogliamo un calendario funzionale al gioco, non un simulatore dell'ufficio anagrafe. 😄

La data sarà quindi:

Year  
Month  
Day  
DayOfWeek

Esempio:

Year: 1  
Month: 3  
Day: 17  
---

# **5\. Tempo giornaliero**

Una giornata dura:

600 secondi reali

quindi:

10 minuti reali \= 1 giorno di gioco

V1:

1 secondo reale \= 1 secondo di gioco

Non introduciamo ancora accelerazioni del tempo.

---

# **6\. Stato del tempo**

Il gioco può trovarsi in due stati principali:

IDLE  
BUSY

### **IDLE**

Il giocatore può scegliere una nuova attività.

### **BUSY**

Il giocatore sta eseguendo un'attività.

Esempio:

IDLE  
 ↓  
scegli "Allenamento"  
 ↓  
BUSY  
 ↓  
10 secondi reali  
 ↓  
azione completata  
 ↓  
IDLE  
---

# **7\. Azioni che consumano tempo**

Un'azione contiene almeno:

ID  
Name  
Duration  
EnergyCost  
MoneyCost  
StressChange  
MoraleChange  
RequiredLocation  
XPRewards

Esempio concettuale:

INTENSE\_TRAINING

Duration: 40 sec  
Energy: \-15  
Stress: \+5  
Morale: 0  
XP: \+20  
---

# **8\. Regola fondamentale delle azioni**

Quando il giocatore avvia un'azione:

### **1\. Controllo**

Il sistema verifica:

tempo disponibile?  
energia sufficiente?  
soldi sufficienti?  
luogo corretto?  
altre condizioni?

### **2\. Avvio**

Se tutto è valido:

Action → BUSY

### **3\. Timer**

Parte il timer reale.

### **4\. Completamento**

Alla fine:

apply rewards  
apply costs  
update stats

### **5\. Ritorno**

BUSY → IDLE  
---

# **9\. Azioni non istantanee**

Questa distinzione è importante.

Non vogliamo:

click  
↓  
tempo \-= 40  
↓  
fine

Vogliamo:

click  
↓  
azione iniziata  
↓  
timer 40 secondi  
↓  
gioco continua  
↓  
40 secondi  
↓  
azione completata

Durante quei 40 secondi il giocatore **sta realmente aspettando l'azione**.

Il gioco può però mostrare:

* barra di progresso;  
* tempo rimanente;  
* animazione;  
* messaggi;  
* eventi;  
* cambiamenti dello stato.

---

# **10\. Passa Tempo**

Quando il giocatore non vuole fare una determinata attività:

PASS TIME

può scegliere:

10 sec  
30 sec  
60 sec

Durante questo tempo:

* nessun XP;  
* nessuna particolare attività;  
* il tempo continua;  
* possono verificarsi eventi passivi.

Serve per evitare che il giocatore sia costretto a trovare continuamente qualcosa da cliccare.

---

# **11\. Movimento e luoghi**

Il giocatore possiede:

current\_location

V1:

Home  
Studio  
Bar  
Small Club

Il movimento è un'azione temporizzata.

Esempio:

Home  
 ↓  
Bus  
 ↓  
Studio

Il viaggio consuma:

tempo  
\+  
eventuale denaro  
---

# **12\. TransportSystem**

V1:

Walk  
Bus  
Taxi

Ogni mezzo ha:

TravelTime  
Cost

Il sistema riceve:

origin  
destination  
transport

e restituisce:

duration  
cost  
---

# **13\. PlayerSystem**

Gestisce lo stato del personaggio.

Dati principali:

Identity  
Resources  
Skills  
Career  
Location

### **Identity**

Name  
Age  
Country  
City  
Background  
Housing  
Instrument

### **Resources**

Energy  
Stress  
Morale  
Money  
Fans  
Popularity  
---

# **14\. SkillSystem**

Gestisce le sette skill.

Voice  
Instrument  
Songwriting  
Composition  
Charisma  
Performance  
Production

Ogni skill contiene:

Level  
XP

Il sistema riceve:

skill\_id  
base\_xp  
activity

e calcola:

final\_xp

utilizzando:

* diminishing returns;  
* energia;  
* stress;  
* morale;  
* eventuali modificatori.

---

# **15\. SkillSystem — flusso**

Esempio:

Player  
  │  
  ▼  
"Allenamento voce"  
  │  
  ▼  
ActionSystem  
  │  
  ▼  
SkillSystem  
  │  
  ├── Skill \= Voice  
  ├── Base XP \= 20  
  ├── Energy modifier  
  ├── Stress modifier  
  ├── Morale modifier  
  └── Diminishing return  
  │  
  ▼  
Final XP  
  │  
  ▼  
Player Voice XP  
---

# **16\. Level Up**

Quando:

XP \>= XP\_to\_next

il sistema:

Level \+= 1  
XP \-= XP\_to\_next

e calcola il nuovo requisito.

Il level up può generare un evento:

SKILL\_LEVEL\_UP

che la UI può mostrare.

Esempio:

> 🎸 Instrument Level Up\!  
> Level 7 → Level 8

---

# **17\. MusicSystem**

Gestisce tutto ciò che riguarda la creazione musicale.

Responsabilità:

* creare canzoni;  
* modificarle;  
* calcolare qualità;  
* pubblicare singoli;  
* gestire lo stato delle canzoni.

---

# **18\. Song Creation**

La creazione segue:

GENRE  
 ↓  
STYLE  
 ↓  
COMPOSITION  
 ↓  
LYRICS  
 ↓  
PRODUCTION  
 ↓  
FINAL SONG

Non necessariamente ogni fase sarà una schermata separata.

Potrebbe essere rappresentata da azioni.

---

# **19\. Creazione della canzone**

Una canzone possiede:

Genre  
Style  
Energy  
Melody  
Rhythm  
Originality  
Commerciality  
Production  
Quality  
Status

Il MusicSystem utilizza anche le skill del giocatore.

Per esempio:

Composition  
Songwriting  
Production

influenzano la qualità.

---

# **20\. Quality Calculation**

Il sistema:

calculate\_song\_quality(song, player)

produce:

0 → 100

utilizzando la formula definita nella Formula & Balance Specification.

Importante:

Quality ≠ Success

Una canzone di qualità 90 può comunque avere un risultato commerciale mediocre.

---

# **21\. Release System**

Quando il giocatore decide di pubblicare:

Draft  
 ↓  
Release

Il sistema:

status \= RELEASED  
release\_day \= current\_day

e genera eventualmente:

initial\_fans  
initial\_popularity  
initial\_sales  
---

# **22\. ConcertSystem**

Gestisce:

* disponibilità del locale;  
* pubblico;  
* prezzo;  
* performance;  
* risultato;  
* fan;  
* soldi;  
* popolarità.

Il concerto richiede:

Venue  
Song(s)  
Player  
---

# **23\. Preparazione concerto**

Prima di iniziare:

Check venue requirements  
Check money  
Check location  
Check songs  
Check time

Se tutto è valido:

Concert → Scheduled/Started

Per V1 possiamo semplificare e fare il concerto come una singola azione temporizzata.

---

# **24\. Concert Resolution**

Alla conclusione:

Performance Score  
        ↓  
Audience  
        ↓  
Fans  
        ↓  
Money  
        ↓  
Popularity  
        ↓  
Concert Result

Il risultato dipende da:

Performance  
Charisma  
Music Quality  
Popularity  
Randomness  
---

# **25\. Concert Result**

Possiamo classificare internamente il risultato:

0–30     Disaster  
31–50    Poor  
51–70    Good  
71–85    Great  
86–100   Excellent

Questi nomi sono **etichette tecniche per la logica**, non livelli di carriera.

Servono per determinare:

* morale;  
* fan;  
* popolarità;  
* eventuali messaggi.

---

# **26\. AudienceSystem**

Il pubblico dipende da:

Popularity  
Venue  
Music Quality  
Randomness

ma non può superare:

Venue.capacity

Esempio:

Venue Capacity \= 150

Calculated Audience \= 93

Final Audience \= 93

Se:

Calculated Audience \= 200

allora:

Final Audience \= 150  
---

# **27\. EconomySystem**

Gestisce tutti i movimenti economici.

Non dobbiamo modificare direttamente:

player.money

da ogni sistema.

Meglio:

EconomySystem.add\_money()  
EconomySystem.remove\_money()

Così possiamo registrare ogni transazione.

---

# **28\. Transaction**

Ogni transazione può contenere:

Amount  
Type  
Reason  
Day

Esempio:

\+ €630  
Concert Revenue  
Day 12

oppure:

\- €12  
Taxi  
Day 12

Questo permetterà in futuro di creare:

* storico finanziario;  
* statistiche;  
* grafici;  
* tasse;  
* contratti;  
* stipendi.

Nella V1 ci basta lo storico base.

---

# **29\. ProgressionSystem**

Gestisce:

Career Level  
Unlocks  
Requirements

Non deve modificare direttamente le skill.

Controlla periodicamente:

fans  
popularity  
released songs  
concerts  
average skills

e determina se il giocatore ha soddisfatto i requisiti.

---

# **30\. Esempio Progression**

Emerging Artist

richiede:

Average Skill ≥ 20  
Fans ≥ 1000  
Released Songs ≥ 3  
Concerts ≥ 5

Quando tutte le condizioni sono vere:

Career Level Up

e si sbloccano nuovi contenuti.

---

# **31\. EventSystem**

Per la V1 lo terrei molto semplice.

Gli eventi possono essere:

Positive  
Negative  
Neutral

Esempi:

### **Positivo**

> Un piccolo locale ti propone di suonare.

### **Negativo**

> Hai avuto una giornata particolarmente stressante.

### **Neutro**

> Un musicista locale ti ha contattato.

Gli eventi possono essere attivati:

* durante il tempo;  
* alla fine della giornata;  
* dopo un concerto;  
* dopo una release.

---

# **32\. EndDaySystem**

Quando:

time\_remaining \<= 0

parte la sequenza:

END DAY  
   ↓  
Resolve pending effects  
   ↓  
Energy recovery  
   ↓  
Stress update  
   ↓  
Morale update  
   ↓  
Passive effects  
   ↓  
Progression check  
   ↓  
Events  
   ↓  
Autosave  
   ↓  
Day \+ 1  
   ↓  
Reset daily time  
   ↓  
Daily Summary  
---

# **33\. Daily Summary**

Alla fine della giornata mostriamo:

DAY 14 COMPLETE

Money:     €420 → €630  
Fans:      120 → 137  
Popularity: 8.4 → 9.1

Energy:    35 → 85  
Stress:    42 → 38  
Morale:    71 → 75

XP gained:  
Voice       \+12  
Performance \+18  
Songwriting \+5

Questo è importante perché il giocatore deve poter capire:

> **"Che cosa ho combinato oggi?"**

---

# **34\. SaveSystem**

Il salvataggio deve essere indipendente dalla UI.

Salviamo:

### **Player**

identity  
resources  
skills  
career  
location

### **Time**

day  
year  
month  
day\_of\_month  
time\_remaining

### **Music**

songs

### **World**

unlocked venues

### **Economy**

transactions  
---

# **35\. Data System**

I dati principali saranno separati dai sistemi.

Possiamo avere concettualmente:

PlayerData  
SongData  
VenueData  
ActionData  
ConcertData  
GameData

I sistemi lavorano sui dati.

Esempio:

SkillSystem  
      ↓  
PlayerData

non:

SkillSystem  
      ↓  
UI Label

Questo ci permette di cambiare completamente interfaccia senza riscrivere la logica.

---

# **36\. Comunicazione tramite eventi**

Per evitare che tutti i sistemi conoscano tutti gli altri, useremo eventi/segnali.

Esempio:

ActionSystem  
      │  
      │ action\_completed  
      ▼  
GameManager  
      │  
      ├── UI  
      ├── SkillSystem  
      ├── EconomySystem  
      └── EventSystem

Un altro esempio:

ConcertSystem  
      │  
      └── concert\_completed  
                  │  
                  ├── Economy  
                  ├── Fans  
                  ├── Popularity  
                  ├── Morale  
                  └── UI

Questo renderà il progetto molto più scalabile.

---

# **37\. Esempio completo: allenamento**

Vediamo tutto il percorso.

Il giocatore è:

Home  
Energy: 80  
Stress: 30  
Morale: 70  
Time: 420 sec  
Voice: Level 5

Sceglie:

> Allenamento voce intenso — 40 sec

### **ActionSystem**

controlla:

420 \>= 40 ✓  
80 \>= 15 ✓  
Home richiesto ✓

Parte:

BUSY  
40 sec

Durante l'attesa il timer scorre.

Alla fine:

Energy \= 65  
Stress \= 35

SkillSystem calcola:

Base XP  
× modifiers  
× diminishing return

e assegna XP.

Infine:

BUSY → IDLE

Il giocatore può scegliere la prossima azione.

---

# **38\. Esempio completo: concerto**

Player  
 ↓  
Travel to Club  
 ↓  
Pay transport  
 ↓  
Arrive  
 ↓  
Start Concert  
 ↓  
Concert timer  
 ↓  
Calculate Performance  
 ↓  
Calculate Audience  
 ↓  
Calculate Fans  
 ↓  
Calculate Revenue  
 ↓  
Calculate Popularity  
 ↓  
Update Morale/Stress/Energy  
 ↓  
Concert Result

Questa è una vera **catena di gameplay**.

---

# **39\. Esempio completo: creare una canzone**

Studio  
 ↓  
Create Draft  
 ↓  
Choose Genre  
 ↓  
Choose Style  
 ↓  
Composition  
 ↓  
Lyrics  
 ↓  
Production  
 ↓  
Calculate Quality  
 ↓  
Save Song  
 ↓  
Release

E poi:

Release  
 ↓  
Sales  
 ↓  
Fans  
 ↓  
Popularity  
---

# **40\. Dipendenze tra sistemi**

La mappa finale della V1 diventa:

                      GAME MANAGER  
                            │  
              ┌─────────────┼──────────────┐  
              │             │              │  
              ▼             ▼              ▼  
         TIME SYSTEM   ACTION SYSTEM   SAVE SYSTEM  
              │             │  
              │             ▼  
              │        SKILL SYSTEM  
              │             │  
              │             ▼  
              │        MUSIC SYSTEM  
              │             │  
              │             ▼  
              │       CONCERT SYSTEM  
              │             │  
              │       ┌─────┴─────┐  
              │       ▼           ▼  
              │   ECONOMY     PROGRESSION  
              │  
              ▼  
         EVENT SYSTEM

E sopra tutto:

                      UI  
                        │  
                        ▼  
                   SYSTEMS  
                        │  
                        ▼  
                      DATA  
---

# **41\. Cosa NON deve fare ogni sistema**

Questa regola ci salverà parecchio lavoro.

### **UI**

❌ non calcola XP  
❌ non modifica soldi  
❌ non decide i fan

### **TimeSystem**

❌ non calcola la qualità delle canzoni  
❌ non gestisce la carriera

### **SkillSystem**

❌ non gestisce i concerti  
❌ non gestisce i soldi

### **MusicSystem**

❌ non decide direttamente il livello carriera

### **EconomySystem**

❌ non decide quanti fan ottieni

### **ProgressionSystem**

❌ non modifica arbitrariamente le skill

Ogni sistema deve avere una **responsabilità precisa**.

---

# **42\. V1 — Core Gameplay Loop tecnico**

Alla fine, tutto converge qui:

                ┌─────────────┐  
                 │   PLAYER    │  
                 └──────┬──────┘  
                        │  
                        ▼  
                 ┌─────────────┐  
                 │   ACTION    │  
                 └──────┬──────┘  
                        │  
                        ▼  
                 ┌─────────────┐  
                 │    TIME     │  
                 └──────┬──────┘  
                        │  
                        ▼  
              ┌──────────────────┐  
              │ SKILLS / MUSIC   │  
              └────────┬─────────┘  
                       │  
                       ▼  
                 ┌─────────────┐  
                 │   RELEASE   │  
                 └──────┬──────┘  
                        │  
                        ▼  
                 ┌─────────────┐  
                 │   CONCERT   │  
                 └──────┬──────┘  
                        │  
             ┌──────────┼──────────┐  
             ▼          ▼          ▼  
           FANS       MONEY    POPULARITY  
             │          │          │  
             └──────────┼──────────┘  
                        ▼  
                 ┌─────────────┐  
                 │ PROGRESSION │  
                 └──────┬──────┘  
                        │  
                        ▼  
                 NEW CONTENT  
                        │  
                        └──────────► LOOP  
---

# **43\. Cosa abbiamo definito finora**

A questo punto il progetto ha una struttura molto più seria:

GDD  
 │  
 ├── Concept  
 ├── Gameplay  
 ├── World  
 ├── Progression  
 └── Features  
       │  
       ▼  
V1.0 GAME RULES  
 │  
 ├── Time  
 ├── Actions  
 ├── Player  
 ├── Skills  
 ├── Music  
 ├── Concerts  
 ├── Economy  
 └── Save  
       │  
       ▼  
V1.0 FORMULA & BALANCE  
 │  
 ├── XP  
 ├── Energy  
 ├── Stress  
 ├── Morale  
 ├── Song Quality  
 ├── Concert Score  
 ├── Fans  
 ├── Popularity  
 └── Economy  
       │  
       ▼  
V1.0 GAME SYSTEMS  
 │  
 ├── GameManager  
 ├── TimeSystem  
 ├── ActionSystem  
 ├── SkillSystem  
 ├── MusicSystem  
 ├── ConcertSystem  
 ├── EconomySystem  
 ├── ProgressionSystem  
 ├── EventSystem  
 └── SaveSystem  
       │  
       ▼  
    GODOT CODE

**Questo è il punto in cui siamo arrivati.**

E soprattutto: **non abbiamo ancora iniziato a programmare alla cieca**. Abbiamo prima deciso cosa deve fare il gioco, poi le regole, poi le formule e ora l'architettura.

Il prossimo documento utile è quindi **V1.0 — Data Model & Godot Project Structure**: lì definiamo esattamente **quali dati deve avere ogni oggetto (`PlayerData`, `SongData`, `VenueData`, `ActionData`...), come organizzarli nelle cartelle Godot e quali scene/script creare**. Solo dopo quello avrebbe senso iniziare a scrivere il primo codice.

# Data Model & Godot Project Structure

Perfetto. Adesso scendiamo di un livello: **come trasformiamo i sistemi in dati e in una struttura concreta di progetto Godot**.

Per questa parte ho verificato anche la documentazione ufficiale di Godot: le `Scene` sono strutture di nodi riutilizzabili, le `Resource` sono particolarmente adatte a contenere dati, e gli `Autoload` possono essere usati per sistemi/dati che devono rimanere disponibili tra le scene. ([Godot Engine documentation](https://docs.godotengine.org/en/latest/getting_started/introduction/key_concepts_overview.html?utm_source=chatgpt.com))

# **V1.0 — Data Model & Godot Project Structure**

## **1\. Obiettivo**

Dobbiamo trasformare questa idea:

> "Il giocatore ha skill, canzoni, soldi, fan, concerti..."

in una struttura concreta:

PlayerData  
SongData  
VenueData  
ActionData  
ConcertData  
GameData

e decidere **dove vivono questi dati**.

La regola sarà:

> **Data \= cosa esiste nel gioco**  
> **System \= cosa succede a quei dati**  
> **Scene/UI \= come il giocatore vede e modifica ciò che succede**

Questa separazione è perfettamente coerente con il modo in cui Godot distingue nodi/scenes e resources/dati. ([Godot Engine documentation](https://docs.godotengine.org/en/latest/getting_started/introduction/key_concepts_overview.html?utm_source=chatgpt.com))

---

# **2\. Struttura delle cartelle**

Propongo questa struttura iniziale:

res://  
│  
├── project.godot  
│  
├── scenes/  
│   ├── main/  
│   ├── menus/  
│   ├── character\_creation/  
│   ├── gameplay/  
│   ├── music/  
│   ├── concerts/  
│   └── ui/  
│  
├── scripts/  
│   ├── systems/  
│   ├── data/  
│   ├── managers/  
│   └── utilities/  
│  
├── resources/  
│   ├── actions/  
│   ├── venues/  
│   ├── genres/  
│   ├── styles/  
│   └── characters/  
│  
├── data/  
│   ├── balance/  
│   └── definitions/  
│  
├── assets/  
│   ├── textures/  
│   ├── icons/  
│   ├── audio/  
│   ├── fonts/  
│   └── music/  
│  
└── saves/

Godot considera tutto ciò che si trova nel filesystem del progetto come risorsa del progetto e utilizza `res://` come percorso della root. ([Godot Engine documentation](https://docs.godotengine.org/en/latest/tutorials/scripting/filesystem.html?utm_source=chatgpt.com))

---

# **3\. Una precisazione importante**

Non voglio creare **100 script per fare 100 cose**.

Per la V1 dobbiamo trovare il giusto equilibrio.

Ad esempio:

scripts/systems/

potrà contenere:

time\_system.gd  
action\_system.gd  
skill\_system.gd  
music\_system.gd  
concert\_system.gd  
economy\_system.gd  
progression\_system.gd  
event\_system.gd  
save\_system.gd

Ma non dobbiamo trasformare ogni piccola operazione in un sistema separato.

---

# **4\. GameData**

Alla base avremo un contenitore generale:

GameData

che rappresenta lo stato complessivo della partita.

Concettualmente:

GameData  
│  
├── Player  
├── Calendar  
├── Songs  
├── Venues  
├── Economy  
├── Career  
└── World

Quindi:

GameData  
   ├── PlayerData  
   ├── CalendarData  
   ├── SongData\[\]  
   ├── VenueData\[\]  
   └── WorldData  
---

# **5\. PlayerData**

Questo è probabilmente il dato più importante.

## **Identità**

PlayerData  
│  
├── name  
├── age  
├── country  
├── city  
├── background  
├── housing  
└── instrument  
---

# **6\. Stato del giocatore**

Poi:

PlayerData  
│  
├── energy  
├── stress  
├── morale  
├── money  
├── fans  
└── popularity

Questi sono valori **dinamici**.

Cambiano continuamente durante la partita.

---

# **7\. SkillData**

Non voglio fare:

player.voice  
player.instrument  
player.songwriting  
...

spargendo dati ovunque.

Preferisco avere una struttura concettuale:

Skills  
│  
├── Voice  
├── Instrument  
├── Songwriting  
├── Composition  
├── Charisma  
├── Performance  
└── Production

Ogni skill:

SkillData  
│  
├── level  
├── xp  
└── xp\_to\_next  
---

# **8\. Perché separare SkillData?**

Perché in futuro potremmo aggiungere:

Skill  
├── level  
├── xp  
├── xp\_to\_next  
├── training\_count  
├── specialization  
└── modifiers

senza dover riscrivere tutto.

E soprattutto il `SkillSystem` può lavorare genericamente:

add\_xp(skill, amount)

anziché avere:

add\_voice\_xp()  
add\_instrument\_xp()  
add\_songwriting\_xp()  
...  
---

# **9\. CalendarData**

Abbiamo deciso di introdurre il calendario nella V1.

Quindi:

CalendarData  
│  
├── year  
├── month  
├── day  
└── day\_of\_week

e il tempo giornaliero:

time\_remaining

oppure, meglio ancora, potremo memorizzare:

seconds\_elapsed

e calcolare il tempo rimanente.

Per evitare di avere due variabili che possono contraddirsi, preferisco:

seconds\_elapsed

come valore principale.

Poi:

seconds\_remaining \=  
600 \- seconds\_elapsed  
---

# **10\. Perché questa scelta?**

Evitiamo una situazione del genere:

seconds\_elapsed \= 500  
time\_remaining \= 250

che sarebbe logicamente impossibile.

Meglio avere **un'unica fonte di verità**.

---

# **11\. SongData**

Ogni canzone sarà un oggetto autonomo.

SongData  
│  
├── id  
├── title  
├── genre  
├── style  
│  
├── energy  
├── melody  
├── rhythm  
├── originality  
├── commerciality  
├── production  
│  
├── quality  
├── status  
└── release\_day  
---

# **12\. Stato della canzone**

V1:

DRAFT  
RELEASED

Quindi:

Song.status

determina se la canzone è ancora in lavorazione oppure è stata pubblicata.

In futuro potremo avere:

DRAFT  
RECORDED  
RELEASED  
ARCHIVED

ma non serve ora.

---

# **13\. Song ID**

Ogni canzone deve avere un identificatore unico.

Esempio:

song\_001  
song\_002  
song\_003

Non dobbiamo usare il titolo come identificatore.

Perché due canzoni potrebbero chiamarsi:

> "Forever"

e:

> "Forever"

senza che il gioco debba esplodere per la disperazione.

---

# **14\. VenueData**

Ogni locale:

VenueData  
│  
├── id  
├── name  
├── capacity  
├── prestige  
├── required\_popularity  
├── rental\_cost  
└── concert\_duration

Esempio:

Bar  
capacity \= 50  
prestige \= 10  
required\_popularity \= 0  
---

# **15\. ActionData**

Questo sarà molto importante.

Un'azione non dovrebbe essere hardcoded direttamente nell'interfaccia.

Avremo:

ActionData  
│  
├── id  
├── name  
├── duration  
├── energy\_cost  
├── stress\_change  
├── morale\_change  
├── money\_cost  
├── required\_location  
└── rewards

Esempi:

practice\_voice\_light  
practice\_voice\_intense  
write\_song  
record\_song  
relax  
travel\_bus  
travel\_taxi  
concert  
---

# **16\. Vantaggio di ActionData**

Potremo avere un menu generato automaticamente.

Il sistema legge:

ActionData

e costruisce:

\[ Allenamento leggero \]  
10 sec  
\-5 Energy

\[ Allenamento intenso \]  
40 sec  
\-15 Energy

\[ Riposo \]  
60 sec  
\+20 Energy

Quindi non dobbiamo creare manualmente la logica di ogni pulsante.

---

# **17\. Rewards**

Le ricompense di un'azione devono essere strutturate.

Concettualmente:

Rewards  
│  
├── skill\_xp  
├── money  
├── fans  
├── popularity  
├── energy  
├── stress  
└── morale

Per esempio:

Training Voice:

Voice XP \+20  
Energy \-15  
Stress \+5  
---

# **18\. ConcertData**

Un concerto concluso deve conservare il risultato.

ConcertData  
│  
├── id  
├── day  
├── venue\_id  
├── song\_ids  
│  
├── audience  
├── performance\_score  
├── fans\_gained  
├── money\_earned  
└── popularity\_change

Questo permette in futuro di creare:

> Carriera → Concerti → Storico concerti.

---

# **19\. EconomyData**

La quantità di denaro attuale appartiene al giocatore:

PlayerData.money

ma lo storico economico sarà separato.

TransactionData  
│  
├── amount  
├── type  
├── reason  
└── day

Esempio:

\+ €500  
CONCERT  
"Bar Milano"  
Day 17

oppure:

\- €12  
TRANSPORT  
"Taxi"  
Day 17  
---

# **20\. WorldData**

La V1 non avrà ancora un mondo gigantesco.

Ma dobbiamo comunque sapere cosa è stato sbloccato.

WorldData  
│  
├── unlocked\_venues  
├── unlocked\_features  
└── discovered\_locations

Per esempio:

unlocked\_venues:  
\[  
    bar\_001,  
    club\_001  
\]  
---

# **21\. CareerData**

Separiamo la carriera dai dati generali del giocatore.

CareerData  
│  
├── career\_level  
├── career\_name  
├── total\_concerts  
├── released\_songs  
└── milestones

Per esempio:

career\_level \= 2  
career\_name \= "Emerging Artist"  
---

# **22\. La struttura complessiva**

Ora possiamo visualizzare il vero modello:

GAME DATA  
│  
├── PLAYER  
│   ├── Identity  
│   ├── Resources  
│   ├── Skills  
│   └── Career  
│  
├── CALENDAR  
│   ├── Year  
│   ├── Month  
│   ├── Day  
│   └── Time  
│  
├── MUSIC  
│   └── Songs\[\]  
│  
├── WORLD  
│   └── Venues\[\]  
│  
├── CONCERTS  
│   └── History\[\]  
│  
└── ECONOMY  
    └── Transactions\[\]

Questa è la struttura dati principale della partita.

---

# **23\. Resource vs runtime data**

Qui c'è una distinzione molto importante in Godot.

Non tutto deve essere un `Resource`.

### **Dati statici**

Esempio:

Bar  
capacity \= 50  
rental\_cost \= 100

sono perfetti come dati di definizione.

### **Dati dinamici**

Esempio:

Player.money \= 573  
Player.energy \= 42  
Player.fans \= 127

sono dati della partita corrente.

Quindi:

DEFINITION  
        ↓  
Runtime Data

Le `Resource` di Godot sono pensate proprio come contenitori di dati riutilizzabili e serializzabili. ([Godot Engine documentation](https://docs.godotengine.org/it/4.x/tutorials/scripting/resources.html?utm_source=chatgpt.com))

---

# **24\. Esempio: Venue**

Potremmo avere una definizione:

resources/venues/bar.tres

che contiene:

id \= "bar\_001"  
name \= "The Old Bar"  
capacity \= 50  
prestige \= 10  
rental\_cost \= 50

Durante il gioco il `ConcertSystem` legge quei dati.

Non dobbiamo scrivere:

if venue \== "bar":  
    capacity \= 50

Questo sarebbe proprio il tipo di codice che vogliamo evitare.

---

# **25\. Struttura delle Scene**

Ora passiamo alle scene.

Godot utilizza scene composte da nodi, che possono essere riutilizzate e istanziate. Una scena può rappresentare una schermata, un personaggio, un'interfaccia o una parte del gioco. ([Godot Engine documentation](https://docs.godotengine.org/en/latest/getting_started/introduction/key_concepts_overview.html?utm_source=chatgpt.com))

Per noi:

Main  
│  
├── World  
├── UI  
└── Systems  
---

# **26\. Main Scene**

La scena principale:

scenes/main/main.tscn

potrebbe essere:

Main  
├── World  
├── UI  
└── GameController

Non dobbiamo mettere 200 nodi direttamente qui.

---

# **27\. Gameplay Scene**

La schermata principale del gioco:

scenes/gameplay/gameplay.tscn

Potrebbe avere:

Gameplay  
│  
├── Background  
├── LocationView  
├── PlayerInfo  
├── ActionPanel  
├── TimePanel  
├── NotificationPanel  
└── PauseMenu  
---

# **28\. HUD**

Il giocatore deve vedere continuamente:

Day 17  
Month 3  
Year 1

09:42

Energy 65  
Stress 32  
Morale 74

€420  
Fans 137  
Popularity 8.4

Non necessariamente tutti questi elementi contemporaneamente, ma questi sono i dati principali.

---

# **29\. Character Creation**

Scena:

scenes/character\_creation/  
    character\_creation.tscn

Passaggi:

Name  
 ↓  
Age  
 ↓  
Country  
 ↓  
City  
 ↓  
Background  
 ↓  
Housing  
 ↓  
Instrument  
 ↓  
Confirmation

Alla fine:

CharacterCreation  
       ↓  
PlayerData  
       ↓  
GameData  
       ↓  
Gameplay  
---

# **30\. Music UI**

Scena:

scenes/music/  
    song\_creator.tscn

Potrebbe contenere:

Song Creator  
│  
├── Genre  
├── Style  
├── Melody  
├── Rhythm  
├── Originality  
├── Commerciality  
├── Production  
│  
├── Quality Preview  
└── Create / Save

La UI **non calcola la qualità**.

Chiede al `MusicSystem`:

calculate\_quality()

e visualizza il risultato.

---

# **31\. Concert UI**

Scena:

scenes/concerts/  
    concert\_screen.tscn

Durante il concerto:

VENUE  
───────  
The Old Bar

Audience: 42 / 50

Performance: ███████░░░

Time: 18 sec

Alla fine:

CONCERT COMPLETE

Audience: 42  
New Fans: \+8  
Money: \+€210  
Popularity: \+0.7  
---

# **32\. Menu principale**

scenes/menus/main\_menu.tscn

V1:

NEW GAME  
LOAD GAME  
SETTINGS  
QUIT

Niente negozio, multiplayer, achievements, battle pass, NFT della chitarra del nonno. 😄

---

# **33\. Save System e scene**

Il salvataggio deve essere indipendente dalla scena.

Questo significa che:

Main Menu  
   ↓  
Gameplay  
   ↓  
Music  
   ↓  
Concert  
   ↓  
Gameplay

non deve distruggere i dati del giocatore.

Per sistemi persistenti tra scene, Godot supporta gli Autoload, che possono mantenere dati o funzionalità globalmente disponibili. ([Godot Engine documentation](https://docs.godotengine.org/en/latest/tutorials/best_practices/autoloads_versus_regular_nodes.html?utm_source=chatgpt.com))

---

# **34\. Autoload: cosa utilizzeremo**

Non voglio però fare:

20 Autoload

perché diventerebbe rapidamente difficile da gestire.

Per la V1 propongo **pochi globali**.

### **`GameManager`**

Gestisce lo stato generale della partita.

### **`SaveManager`**

Gestisce salvataggio/caricamento.

### **`EventBus`**

Gestisce alcuni segnali/eventi globali.

Possiamo eventualmente aggiungere `DataManager` se durante l'implementazione si dimostrerà necessario.

---

# **35\. GameManager**

Concettualmente:

GameManager  
│  
├── current\_game\_data  
├── current\_scene  
├── game\_state  
└── references to core systems

Stati possibili:

MAIN\_MENU  
CHARACTER\_CREATION  
PLAYING  
BUSY  
PAUSED  
DAILY\_SUMMARY

Attenzione:

`BUSY` potrebbe anche essere gestito dal `ActionSystem`; qui lo riportiamo solo come stato globale concettuale.

---

# **36\. Stati del gioco**

Propongo:

MAIN\_MENU  
     ↓  
CHARACTER\_CREATION  
     ↓  
PLAYING  
     ↓  
BUSY  
     ↓  
PLAYING  
     ↓  
DAILY\_SUMMARY  
     ↓  
PLAYING

Se apriamo un menu:

PLAYING  
   ↓  
PAUSED  
   ↓  
PLAYING  
---

# **37\. EventBus**

Immaginiamo che succeda:

concert\_completed

Non voglio obbligare `ConcertSystem` a conoscere direttamente:

* UI;  
* EconomySystem;  
* ProgressionSystem;  
* EventSystem.

Può invece emettere un evento.

Gli altri sistemi possono reagire.

Questo sfrutta il sistema di segnali di Godot, che è parte del modello scene/node dell'engine. ([Godot Engine documentation](https://docs.godotengine.org/en/latest/getting_started/introduction/key_concepts_overview.html?utm_source=chatgpt.com))

---

# **38\. Struttura definitiva proposta**

Quindi:

res://  
│  
├── scenes/  
│   ├── main/  
│   ├── menus/  
│   ├── gameplay/  
│   ├── character\_creation/  
│   ├── music/  
│   ├── concerts/  
│   └── ui/  
│  
├── scripts/  
│   ├── systems/  
│   │   ├── time\_system.gd  
│   │   ├── action\_system.gd  
│   │   ├── skill\_system.gd  
│   │   ├── music\_system.gd  
│   │   ├── concert\_system.gd  
│   │   ├── economy\_system.gd  
│   │   ├── progression\_system.gd  
│   │   └── event\_system.gd  
│   │  
│   ├── managers/  
│   │   ├── game\_manager.gd  
│   │   ├── save\_manager.gd  
│   │   └── event\_bus.gd  
│   │  
│   ├── data/  
│   │   ├── player\_data.gd  
│   │   ├── song\_data.gd  
│   │   ├── venue\_data.gd  
│   │   ├── action\_data.gd  
│   │   ├── concert\_data.gd  
│   │   └── transaction\_data.gd  
│   │  
│   └── utilities/  
│  
├── resources/  
│   ├── actions/  
│   ├── venues/  
│   ├── genres/  
│   └── styles/  
│  
├── assets/  
│   ├── textures/  
│   ├── icons/  
│   ├── audio/  
│   └── fonts/  
│  
└── saves/  
---

# **39\. Una modifica importante rispetto alla nostra architettura precedente**

Prima avevamo parlato di:

GameManager  
TimeSystem  
ActionSystem  
SkillSystem  
...

Ora abbiamo una distinzione più precisa:

MANAGERS  
    ↓  
coordinano

SYSTEMS  
    ↓  
applicano regole

DATA  
    ↓  
contengono stato

RESOURCES  
    ↓  
contengono definizioni statiche

SCENES  
    ↓  
presentano/interagiscono

Questa distinzione è molto utile perché impedisce che `GameManager` diventi il famigerato:

> **GodManager da 4.000 righe che sa fare tutto e quindi non si può più toccare senza rompere il gioco.**

---

# **40\. V1 — Schema completo**

Alla fine abbiamo:

                        GAME  
                          │  
                    GameManager  
                          │  
        ┌─────────────────┼─────────────────┐  
        │                 │                 │  
        ▼                 ▼                 ▼  
     SYSTEMS            DATA            RESOURCES  
        │                 │                 │  
        │                 │                 │  
        ▼                 ▼                 ▼  
     TimeSystem       PlayerData        VenueData  
     ActionSystem     SongData          ActionData  
     SkillSystem      CareerData        GenreData  
     MusicSystem      CalendarData      StyleData  
     ConcertSystem    ConcertData  
     EconomySystem    TransactionData  
     Progression  
     EventSystem  
        │  
        ▼  
       UI  
        │  
        ▼  
     SCENES  
---

# **41\. Il nostro primo vero "vertical slice"**

Prima di costruire tutta la V1, non farei subito:

> creazione personaggio \+ 6 generi \+ concerti \+ economia \+ salvataggi \+ eventi \+ calendario \+ 800 schermate.

Faremmo una **mini-V1 giocabile**.

Il primo vertical slice dovrebbe essere:

NEW GAME  
   ↓  
CREATE CHARACTER  
   ↓  
GAMEPLAY  
   ↓  
SEE TIME  
   ↓  
CHOOSE TRAINING  
   ↓  
WAIT REAL TIME  
   ↓  
GAIN XP  
   ↓  
ENERGY CHANGES  
   ↓  
TIME CHANGES  
   ↓  
DAY ENDS  
   ↓  
DAILY SUMMARY  
   ↓  
NEXT DAY

Se questo funziona, abbiamo già dimostrato che il **cuore temporale del gioco** funziona.

Poi aggiungiamo:

\+ Song Creation  
\+ Release  
\+ Concert  
\+ Fans  
\+ Money  
\+ Progression  
\+ Save

uno alla volta.

---

# **42\. Ordine di implementazione consigliato**

Questa sarà la roadmap tecnica:

### **FASE 1 — Foundation**

Project  
GameManager  
GameData  
PlayerData  
Main Scene

### **FASE 2 — Time**

Calendar  
TimeSystem  
ActionSystem  
Timer  
Day transition  
Daily Summary

### **FASE 3 — Player**

Energy  
Stress  
Morale  
Money  
Skills  
XP  
Level Up

### **FASE 4 — Music**

SongData  
MusicSystem  
Song Creation  
Quality  
Release

### **FASE 5 — Concert**

VenueData  
ConcertSystem  
Audience  
Performance  
Fans  
Revenue  
Popularity

### **FASE 6 — Career**

ProgressionSystem  
Career Levels  
Unlocks

### **FASE 7 — Persistence**

SaveManager  
Save  
Load  
Autosave

### **FASE 8 — Polish V1**

UI  
animations  
notifications  
sound  
balancing  
bug fixing  
---

# **43\. Criterio per passare da una fase alla successiva**

Non passeremo alla fase successiva semplicemente perché:

> "Il codice non dà errori."

Ogni fase deve avere un **test funzionale**.

Per esempio:

### **Time System**

Deve essere possibile verificare:

600 sec  
↓  
azione 10 sec  
↓  
590 sec

e realmente aspettare quei 10 secondi.

### **Skill System**

XP prima  
↓  
azione  
↓  
XP dopo

### **Day System**

0 sec remaining  
↓  
daily summary  
↓  
day \+ 1  
↓  
600 sec

Solo quando questi test passano, aggiungiamo il sistema successivo.

---

# **44\. Stato del progetto**

Quindi adesso il nostro percorso è:

✅ IDEA  
✅ GDD  
✅ V1 FEATURE SCOPE  
✅ GAME RULES  
✅ FORMULA & BALANCE  
✅ GAME SYSTEMS  
✅ DATA MODEL  
✅ PROJECT STRUCTURE  
⬜ FIRST IMPLEMENTATION

Siamo praticamente arrivati al punto in cui possiamo **aprire Godot e iniziare davvero**.

E, dato che il cuore del gioco è il sistema temporale, la prima implementazione non dovrebbe essere il menu figo o la schermata della superstar con la Ferrari.

Dovrebbe essere il piccolo prototipo:

**creo un personaggio → vedo il tempo scorrere → avvio un'azione → aspetto realmente la durata → ricevo la ricompensa → arriva la fine della giornata → parte il giorno successivo.**

Se questo nucleo è solido, tutto il resto — musica, concerti, fama, soldi, carriera — potrà appoggiarsi sopra senza dover rifare l'architettura.

