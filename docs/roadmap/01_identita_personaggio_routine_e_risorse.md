# World-tour — Roadmap Modulare: Sezione 1

- File di origine: `docs/roadmap.md`
- Titolo: Identità del Musicista, Creazione Personaggio, Routine & Risorse
- Priorità Operativa: P1 - Fondamenta Core Loop

---

## 1. IDENTITÀ DEL MUSICISTA, PERSONAGGIO & ROUTINE DI VITA

### 1.1 Anagrafica del Protagonista, Strumenti & Tratti Distintivi
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/player_data.gd`.
  - Dati anagrafici attuali: Nome predefinito "Alex", età 20 anni, strumento principale Chitarra Elettrica (`Enums.SkillType.INSTRUMENT`), background "Autodidatta", tratto iniziale "Carismatico".
  - Schermata modale ad alto contrasto: `ui/character/character_sheet.tscn` e `.gd`.
  - Tasto rapido HUD: Tasto `C` (vocalizzazione istantanea scheda con abilità e risorse).
  - Status di carriera: Scala da 0 a 7 gestita in `systems/career_system.gd` (`Enums.CareerTier`: Nobody, Bedroom Musician, Busker, Local Artist, Underground Hero, Indie Sensation, National Star, Global Superstar).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Scelta iniziale del background con impatto su attributi di partenza (es. Accademico di Conservatorio: +Strumento e +Composizione, ma -Carisma iniziale; Ribelle Punk: +Presenza scenica e +Resistenza allo stress, ma -Produzione; Producer Elettronico da Cameretta: +Produzione e +Composizione, ma 0 Presenza scenica).
  - Tratti caratteriali secondari sbloccabili (es. Perfezionista Ossessivo, Animale da Palco, Insonne Creativo, Timido nei Dialoghi).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
  - ### Espansione del sistema di creazione e identità del protagonista

#### 1. Personalizzazione iniziale del protagonista

* Sostituire i dati completamente predefiniti (nome "Alex", età 20 anni, chitarra elettrica, background Autodidatta e tratto Carismatico) con una schermata di creazione del personaggio.
* Permettere al giocatore di personalizzare:

  * Nome personale.
  * Nome d'arte (facoltativo e modificabile in seguito).
  * Età iniziale 
  * Strumento musicale principale.
  * Background
  * Tratti caratteriali iniziali.
* Mantenere una configurazione predefinita opzionale per consentire di iniziare rapidamente una nuova partita.

#### 2. Sistema di background liberamente selezionabili

* Permettere al giocatore di scegliere liberamente il background, senza obbligarlo a un percorso musicale o a un genere specifico.
* Ogni background deve rappresentare il contesto da cui parte il protagonista e influenzare concretamente la fase iniziale della carriera.
* I background possono modificare:

  * Abilità musicali iniziali.
  * Risorse economiche iniziali.
  * Equipaggiamento disponibile.
  * Contatti e opportunità iniziali.
  * Situazione di partenza e prime difficoltà.
    
* Il background deve influenzare il punto di partenza, ma non determinare il destino musicale del protagonista.
* Il giocatore deve poter cambiare genere, sviluppare nuove competenze e intraprendere percorsi differenti durante la carriera.
* Possibili background da sviluppare:

  * Autodidatta.
  * Studente o diplomato di conservatorio.
  * Musicista di strada.
  * Ribelle punk.
  * Producer elettronico da cameretta.
  * Altri background da valutare in base ai generi e ai contesti presenti nel gioco.
* Ogni background deve essere bilanciato attraverso vantaggi, limitazioni e opportunità, evitando che una scelta sia chiaramente superiore alle altre.

#### 3. Sistema di strumenti musicali

* Rendere lo strumento principale personalizzabile durante la creazione del personaggio.
* Valutare l'introduzione di più strumenti, tra cui:

  * Chitarra elettrica.
  * Chitarra acustica.
  * Basso.
  * Batteria.
  * Pianoforte o tastiere.
  * Voce.
  * Altri strumenti da valutare in base all'espansione dei generi musicali.
* Mantenere inizialmente la skill Strumento come competenza esecutiva principale, evitando di complicare subito il sistema con una skill separata per ogni strumento.
* Prevedere la possibilità futura di imparare strumenti secondari.
* Gli strumenti secondari potrebbero richiedere allenamento e tempo e offrire nuove possibilità nella composizione, nella produzione e nelle esibizioni dal vivo.
* Strutturare il modello dati in modo da poter introdurre strumenti secondari in futuro senza dover riprogettare completamente il sistema.

#### 4. Distinzione tra background, abilità, tratti e reputazione

* Separare chiaramente i seguenti elementi:

  * Background: contesto di provenienza del protagonista.
  * Abilità: competenze che migliorano attraverso esperienza e allenamento.
  * Tratti: predisposizioni comportamentali che influenzano alcune situazioni di gioco.
  * Reputazione: percezione del protagonista da parte del pubblico, degli addetti ai lavori e degli altri artisti.
* Evitare che il background o un tratto stabiliscano in modo permanente il livello di un'abilità o il percorso professionale del personaggio.

#### 5. Sistema di tratti caratteriali

* Permettere al giocatore di scegliere liberamente uno o più tratti iniziali, secondo un numero massimo da definire per il bilanciamento.
* Prevedere la possibilità futura di acquisire, modificare, sviluppare o sostituire alcuni tratti attraverso eventi ed esperienze di gioco.
* I tratti devono avere effetti concreti sul gameplay, evitando di essere soltanto bonus numerici passivi.
* I tratti possono influenzare attività, situazioni, interazioni sociali, stress, morale, creatività, concerti o negoziazioni.
* Ogni tratto deve essere bilanciato attraverso vantaggi, limitazioni o compromessi contestuali, quando appropriato.
* Possibili tratti da sviluppare:

  * Perfezionista.
  * Animale da palco.
  * Insonne creativo.
  * Timido nei dialoghi.
  * Carismatico.
  * Altri tratti da definire.
* Distinguere il tratto Carismatico dall'abilità Carisma:

  * Il tratto rappresenta una predisposizione iniziale o comportamentale.
  * L'abilità rappresenta una competenza che può essere sviluppata attraverso il gameplay.

#### 6. Sistema di motivazioni personali (eventuale)

* Valutare l'introduzione di una motivazione o aspirazione personale del protagonista.
* La motivazione potrebbe rappresentare un obiettivo individuale, distinto dall'obiettivo generale di diventare una superstar mondiale.
* Possibili motivazioni:

  * Vivere di musica.
  * Diventare un artista indipendente.
  * Creare una band.
  * Diventare un grande compositore.
  * Ottenere fama internazionale.
  * Costruire uno studio professionale.
* Il sistema potrebbe essere sviluppato successivamente per influenzare obiettivi secondari, eventi, dialoghi e ricompense narrative.
* Non rendere la motivazione una limitazione obbligatoria del percorso del giocatore.

#### 7. Creazione del personaggio e accessibilità

* Valutare una schermata di creazione del personaggio coerente con il supporto ad alto contrasto già presente nella scheda del protagonista.
* Garantire che le opzioni di creazione siano accessibili tramite tastiera e compatibili con la vocalizzazione NVDA.
* Mantenere la possibilità di consultare successivamente le informazioni del personaggio tramite la scheda HUD e il tasto rapido C.

#### 8. Bilanciamento e priorità di sviluppo

* Definire e bilanciare le statistiche, le risorse, gli equipaggiamenti e le opportunità associate a ogni background.
* Evitare che i background o i tratti creino combinazioni iniziali eccessivamente potenti.
* Implementare prioritariamente:

  1. Personalizzazione del nome e dello strumento principale.
  2. Sistema di background con effetti sulle condizioni iniziali.
  3. Sistema di selezione dei tratti iniziali.
  4. Distinzione tra background, tratti, abilità e reputazione.
* Rimandare a fasi successive:

  * Strumenti secondari completi.
  * Evoluzione avanzata dei tratti.
  * Motivazioni personali con conseguenze narrative.
  * Sistema approfondito di età e fasi della vita.
------------------------------------------------------------------------------------------------------------------------------

### 1.2 Orologio Giornaliero, Fasce Orarie & Ciclo di Fine Giornata
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo orologio: `systems/time_system.gd`.
  - Durata della giornata virtuale: Configurabile su 4 preset (`Constants.DAY_DURATION_SECONDS` = 300.0s [5 min], 600.0s [10 min], 900.0s [15 min], 1200.0s [20 min]).
  - 4 Fasce orarie (`Enums.TimePeriod`): Mattina (06:00 - 12:00), Pomeriggio (12:00 - 18:00), Sera (18:00 - 24:00), Notte / Overtime (00:00 - 06:00, durata 120s con accumulo di stress penalizzante `OVERTIME_STRESS_PENALTY` = 20).
  - Stati del gioco (`Enums.GameState`): GAMEPLAY_IDLE (libero), GAMEPLAY_BUSY (azione in corso), GAMEPLAY_PAUSED (congelato).
  - Pausa Dinamica automatica all'apertura di qualsiasi finestra modale.
  - Velocità di simulazione scalabile: Tasto `T` cicla tra 1x, 2x, 3x con annuncio NVDA. Tasto `Spazio` mette in Pausa/Play.
  - Ciclo Fine Giornata (`systems/end_day_system.gd`) e modale `DailySummary` (`ui/hud/daily_summary.tscn`): A mezzanotte calcolo automatico spese fisse, canone affitto, royalties passive, decadimento social buzz (-10%) e ripristino fisiologico notturno (`SLEEP_STANDARD_ENERGY` = 70, `SLEEP_STANDARD_STRESS_RELIEF` = 15).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Possibilità di saltare direttamente alla fascia oraria successiva o a sera quando non ci sono impegni.
  - Eventi notturni casuali durante il sonno (sogni ispiratori che regalano un'idea per un riff, insonnia da ansia pre-concerto).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
 1.2 Orologio Giornaliero, Fasce Orarie & Ciclo di Fine Giornata
Stato Attuale e Fondamenta Tecniche

Il sistema temporale rappresenta uno dei sistemi centrali della simulazione. Il tempo non è solamente un elemento grafico, ma influenza direttamente attività, concerti, eventi, energia, stress, economia, recupero, socialità e progressione della carriera.

I principali moduli coinvolti sono:

systems/time_system.gd
systems/end_day_system.gd
ui/hud/daily_summary.tscn

La simulazione utilizza un orologio virtuale continuo e tutti i sistemi che dipendono dal trascorrere del tempo devono fare riferimento al TimeSystem, evitando timer indipendenti e difficili da sincronizzare.

Durata della Giornata

La durata della giornata virtuale è configurabile attraverso quattro preset:

Preset	Durata reale
Short	5 minuti
Standard	10 minuti
Long	15 minuti
Extended	20 minuti

Il preset standard rimane:

600 secondi = 10 minuti reali

La durata della giornata rappresenta il tempo necessario affinché il ciclo virtuale raggiunga le 04:00, momento in cui viene effettuato il passaggio al giorno successivo.

Il preset scelto deve essere considerato una configurazione globale della partita.

Fasce Orarie

La giornata è suddivisa in quattro fasce:

Fascia	Orario	Caratteristiche
🌅 Mattina	06:00–12:00	attività quotidiane, allenamento, preparazione
☀️ Pomeriggio	12:00–18:00	lavoro, produzione, studio, attività professionali
🌆 Sera	18:00–00:00	concerti, eventi, socialità, locali
🌙 Notte / Overtime	00:00–04:00	vita notturna, concerti tardivi, feste, locali e attività extra

Il periodo 00:00–04:00 costituisce una vera e propria finestra di gameplay e non deve essere considerato semplicemente come un periodo di penalizzazione.

Il giocatore è quindi libero di:

andare a dormire;
continuare a lavorare;
partecipare a concerti;
frequentare locali;
partecipare a feste;
socializzare;
svolgere eventi notturni;
affrontare eventuali eventi casuali.

La giornata termina solamente alle 04:00.

Filosofia del Riposo

Il giocatore non è obbligato ad aspettare le 04:00 per terminare la propria giornata.

Il riposo può essere iniziato liberamente prima della fine del ciclo.

Esempio:

23:30
 ↓
Il giocatore decide di andare a dormire
 ↓
Periodo di riposo
 ↓
Recupero di energia/stress
 ↓
04:00
 ↓
Fine giornata
 ↓
Nuovo giorno

In alternativa:

23:30
 ↓
Concerto
 ↓
01:00
 ↓
Locale
 ↓
02:00
 ↓
Evento notturno
 ↓
03:15
 ↓
Rientro
 ↓
04:00
 ↓
Fine giornata

Il giocatore deve quindi poter scegliere tra recuperare prima oppure sfruttare maggiormente la notte, accettando le relative conseguenze.

Overtime

L'intervallo:

00:00 → 04:00

viene classificato come Overtime.

L'overtime rappresenta il periodo nel quale il personaggio rimane attivo oltre il normale orario di riposo.

Il sistema mantiene il parametro:

OVERTIME_STRESS_PENALTY = 20

Tale penalità deve essere interpretata come conseguenza del mancato riposo e non necessariamente applicata interamente in un singolo istante.

Evoluzione prevista

L'overtime dovrà utilizzare una penalità progressiva.

Indicativamente:

00:00 → penalità minima
01:00 → stress +
02:00 → stress ++
03:00 → stress +++
04:00 → fine giornata

La formula definitiva dovrà essere definita nel sistema di bilanciamento.

L'obiettivo è permettere al giocatore di fare occasionalmente una "tirata" notturna senza rendere automaticamente impossibile il gameplay del giorno successivo.

Stati del Gioco

Il sistema temporale utilizza tre stati principali:

GAMEPLAY_IDLE
GAMEPLAY_BUSY
GAMEPLAY_PAUSED
GAMEPLAY_IDLE

Il giocatore è libero di interagire con il mondo.

Esempi:

scegliere attività;
consultare statistiche;
utilizzare la mappa;
controllare finanze;
scegliere una destinazione;
avviare una nuova attività.
GAMEPLAY_BUSY

Il personaggio sta eseguendo un'attività.

Esempio:

Allenamento intensivo
        ↓
GAMEPLAY_BUSY
        ↓
40 secondi
        ↓
Attività completata
        ↓
GAMEPLAY_IDLE

Durante questo stato devono essere bloccate le azioni incompatibili con l'attività corrente.

GAMEPLAY_PAUSED

Il tempo di simulazione viene congelato.

Viene utilizzato:

quando il giocatore mette manualmente il gioco in pausa;
quando viene aperta una finestra modale;
quando un sistema richiede temporaneamente l'interruzione della simulazione.
Pausa Dinamica

L'apertura di qualsiasi finestra modale provoca automaticamente la pausa della simulazione.

Esempio:

Attività in corso
      ↓
Apertura modale
      ↓
GAMEPLAY_PAUSED
      ↓
Il giocatore consulta le informazioni
      ↓
Chiusura modale
      ↓
Ripresa della simulazione

Questo comportamento è fondamentale perché il gioco utilizza tempo reale.

Il tempo non deve continuare a scorrere mentre il giocatore sta leggendo informazioni o interagendo con una finestra modale.

Velocità della Simulazione

Il tasto:

T

cicla tra:

1x → 2x → 3x → 1x

Ogni modifica della velocità deve essere comunicata tramite NVDA.

Il tasto:

SPACE

gestisce:

PLAY ↔ PAUSE

La modifica della velocità influenza il tempo reale necessario per raggiungere un determinato momento, ma non modifica la durata logica delle attività.

Esempio:

Attività = 40 secondi simulati

1x → 40 secondi reali
2x → 20 secondi reali
3x → ~13,3 secondi reali

Il sistema deve mantenere comunque la coerenza del tempo simulato.

Ciclo di Fine Giornata

La giornata termina alle:

04:00

A questo momento viene avviato automaticamente:

EndDaySystem

Il sistema deve eseguire una sequenza deterministica di operazioni.

Sequenza generale
04:00
 ↓
Chiusura giornata
 ↓
Calcolo attività economiche
 ↓
Spese fisse
 ↓
Affitto
 ↓
Royalties passive
 ↓
Social Buzz decay
 ↓
Calcolo recupero notturno
 ↓
Eventi di fine giornata / eventi notturni
 ↓
Daily Summary
 ↓
Inizio nuovo giorno
 ↓
06:00

Il passaggio deve avvenire una sola volta per ogni giornata.

Economia di Fine Giornata

Durante il ciclo vengono applicate le operazioni economiche previste.

Spese Fisse

Vengono applicati i costi ricorrenti relativi alla vita e alla carriera.

Possibili esempi:

affitto;
utenze;
mantenimento;
costi della band;
manager;
servizi professionali;
eventuali abbonamenti.
Affitto

Il costo dell'alloggio viene applicato secondo la frequenza stabilita dal sistema economico.

Royalties Passive

Le canzoni pubblicate possono generare entrate anche quando il giocatore non sta svolgendo direttamente attività musicali.

Questo crea una forma di reddito passivo collegata al catalogo musicale e alla sua diffusione.

Social Buzz

Alla fine della giornata viene applicato il decadimento del Social Buzz:

Social Buzz × 0.90

equivalente a:

-10%

Il Social Buzz rappresenta l'attenzione recente del pubblico e non deve essere confuso con la popolarità complessiva dell'artista.

Il decadimento incentiva il giocatore a mantenere una presenza attiva attraverso:

concerti;
pubblicazioni;
contenuti;
eventi;
attività promozionali;
interazioni con il pubblico.
Recupero Notturno

Il sistema prevede valori standard di recupero:

SLEEP_STANDARD_ENERGY = 70
SLEEP_STANDARD_STRESS_RELIEF = 15

Il recupero deve essere applicato in relazione al riposo effettivamente effettuato.

Il giocatore può quindi scegliere di dormire prima delle 04:00 oppure rimanere attivo fino alla fine della giornata.

Evoluzione prevista

La qualità del recupero potrà dipendere da:

durata del sonno;
stress accumulato;
energia residua;
eventuale overtime;
condizioni dell'alloggio;
eventuali eventi notturni;
condizioni speciali del personaggio.

Esempio:

Basso stress
+ sonno sufficiente
= recupero elevato

mentre:

Stress elevato
+ attività fino alle 04:00
= recupero ridotto
Eventi Notturni

La finestra 00:00–04:00 permette di introdurre eventi specificamente legati alla vita notturna.

Gli eventi devono essere contestuali e non necessariamente presenti ogni notte.

Possibili categorie:

concerti;
feste;
locali;
incontri casuali;
opportunità professionali;
eventi sociali;
eventi legati alla band;
eventi legati alle relazioni;
eventi legati alla carriera.
Eventi durante il Sonno

Quando il giocatore decide di dormire possono verificarsi eventi notturni specifici.

Sogno Ispiratore

Possibile evento:

Durante il sonno...

Hai avuto un'idea musicale!

🎵 Nuova idea:
"Riff oscuro in Mi minore"

+1 Idea Musicale

L'idea potrà successivamente essere trasformata in:

riff;
melodia;
testo;
concept musicale;
elemento di una nuova canzone.
Insonnia

Con livelli elevati di stress può verificarsi:

Non riesci a dormire.

Possibili conseguenze:

Recupero energia ↓
Recupero stress ↓
Possibili penalità al giorno successivo

L'evento deve essere collegato allo stato reale del personaggio e non essere completamente casuale.

Skip Time

Quando il giocatore non ha impegni attivi o imminenti deve essere possibile accelerare il trascorrere del tempo.

Possibili opzioni:

[ Aspetta ]
[ Vai alla prossima fascia ]
[ Vai alla sera ]
[ Vai al prossimo appuntamento ]
[ Vai al giorno successivo ]

Lo skip temporale deve utilizzare il normale TimeSystem.

Non deve essere implementato semplicemente modificando manualmente l'orario.

Schema:

SKIP TIME
    ↓
TimeSystem
    ↓
EventSystem
    ↓
PlayerSystem
    ↓
EconomySystem
    ↓
EndDaySystem

In questo modo tutti i sistemi ricevono correttamente il trascorrere del tempo.

Regole dello Skip

Durante lo skip devono essere gestiti correttamente:

consumo di energia;
variazione dello stress;
eventi casuali;
eventi programmati;
appuntamenti;
attività automatiche;
cambi di fascia oraria;
cambio di giornata;
economia;
eventuale sonno.

Lo skip non deve permettere di bypassare artificialmente le conseguenze della simulazione.

Test Necessari

Il sistema temporale deve essere verificato con test specifici.

Cambio di giornata

03:59 → 04:00

EndDaySystem eseguito una sola volta.

Daily Summary mostrato correttamente.

Nuovo giorno inizializzato correttamente.

Economia applicata una sola volta.

Fasce orarie

05:59 → 06:00

11:59 → 12:00

17:59 → 18:00

23:59 → 00:00

03:59 → 04:00

Attività

Attività che attraversano le 00:00.

Attività che attraversano le 04:00.

Concerto terminato dopo mezzanotte.

Evento notturno attivo durante il cambio giornata.

Impossibilità di creare una situazione temporale incoerente.

Pausa

Apertura modale durante un'attività.

Chiusura modale.

Ripresa corretta del tempo.

Più modali consecutivi.

Pausa manuale durante un'attività.

Velocità

1x.

2x.

3x.

Cambio velocità durante un'attività.

Cambio velocità durante un evento.

Cambio velocità vicino alle 04:00.

Skip Time

Skip alla fascia successiva.

Skip alla sera.

Skip al prossimo appuntamento.

Skip attraverso mezzanotte.

Skip attraverso le 04:00.

Gestione corretta degli eventi durante lo skip.

Gestione corretta dell'economia durante lo skip.

Principi di Design

Il sistema temporale deve rispettare i seguenti principi:

Il tempo è globale.
Tutti i sistemi devono fare riferimento al TimeSystem.
La giornata termina alle 04:00.
La fascia 00:00–04:00 è parte integrante del gameplay.
Il giocatore è libero di dormire prima.
Non è necessario aspettare la fine della giornata per riposare.
La notte deve avere valore.
Concerti, eventi, locali e attività sociali possono occupare la finestra notturna.
Rimanere svegli deve avere conseguenze.
L'overtime deve aumentare progressivamente il costo in termini di stress e recupero.
Il riposo deve essere una scelta strategica.
Dormire prima permette un recupero migliore, mentre continuare le attività può generare opportunità ma aumenta i costi.
Gli eventi devono essere contestuali.
Gli eventi notturni devono dipendere, quando possibile, dalle condizioni del personaggio, dagli impegni e dalla carriera.
Lo skip deve simulare il tempo.
Non deve semplicemente saltare arbitrariamente l'orologio ignorando gli altri sistemi.
Il cambio giornata deve essere deterministico.
EndDaySystem deve essere eseguito una sola volta per ogni passaggio alle 04:00.
Il sistema deve essere compatibile con accessibilità e NVDA.
Cambi di velocità, pausa, avanzamento temporale, eventi importanti e fine giornata devono essere annunciabili correttamente.

Ricorda ogni azione occupa tempo 
-----------------------------------------------------------------------------------------------------------------------------
### 1.3 Triade Risorse Vitali: Energia, Stress & Morale
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Energia residua: [0 - 100%]. Soglia di burnout a 15% (`Constants.ENERGY_BURNOUT_THRESHOLD`). Sotto questa soglia le azioni richiedono il doppio del tempo e cala la qualità.
  - Stress accumulato: [0 - 100%]. Soglia di panico a 80% (`Constants.STRESS_PANIC_THRESHOLD`). Agisce come freno matematico esponenziale sull'efficacia delle azioni.
  - Morale dell'artista/band: [0 - 100%]. Influisce sulla probabilità di colpi di genio creativi e sull'affluenza ai live.
  - Indicatori visivi ad alto contrasto e vocalizzazione dinamica con tasto `I` (annuncio istantaneo barra superiore).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Meccaniche di recupero attivo durante il giorno (prendere un caffè al bar per recuperare energia temporanea a scapito di un lieve stress successivo, passeggiata al parco per abbassare lo stress, ascoltare un disco capolavoro per alzare il morale).
  - Effetti del morale a terra: rischio di blocco creativo totale nella scrittura brani.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
 
    ### 1.3 Triade Risorse Vitali: Energia, Stress & Morale

#### Stato Attuale e Fondamenta Tecniche

La simulazione utilizza tre risorse vitali principali:

```text
ENERGIA
STRESS
MORALE
```

Queste risorse rappresentano lo stato fisico, psicologico e motivazionale dell'artista e, in parte, della band.

Sono valori compresi tra:

```text
0 → 100
```

Le tre risorse non devono essere considerate indipendenti.

Le attività svolte dal giocatore possono modificare contemporaneamente più valori.

Esempio:

```text
Concerto
 ↓
Energia -
Stress +
Morale +
Fans +
Money +
```

Questo permette di creare decisioni con conseguenze reali invece di trasformare il gameplay in una semplice gestione di barre.

---

# Energia

L'Energia rappresenta la capacità fisica dell'artista di svolgere attività.

Range:

```text
0 → 100%
```

Parametro attuale:

```text
Constants.ENERGY_BURNOUT_THRESHOLD = 15
```

Quando l'Energia scende sotto il 15%, il personaggio entra nella condizione di **Burnout Fisico**.

### Effetti del Burnout

Quando:

```text
Energy < 15
```

le azioni vengono penalizzate.

Effetti attuali:

* durata dell'azione ×2;
* riduzione della qualità dell'attività;
* maggiore difficoltà nel mantenere una giornata produttiva.

Il sistema deve impedire che il giocatore possa ignorare completamente il proprio livello energetico.

---

# Stress

Lo Stress rappresenta la pressione accumulata dall'artista.

Range:

```text
0 → 100%
```

Parametro attuale:

```text
Constants.STRESS_PANIC_THRESHOLD = 80
```

Quando lo stress raggiunge valori molto elevati viene attivata la condizione di **Panico**.

Lo stress agisce inoltre come modificatore matematico dell'efficacia delle azioni.

La penalità deve essere progressiva e non lineare.

In generale:

```text
Stress basso
→ penalità minima

Stress medio
→ penalità moderata

Stress elevato
→ penalità significativa

Stress ≥ 80
→ stato di Panico
```

L'obiettivo è evitare che passare da 20% a 21% di stress abbia lo stesso impatto di passare da 90% a 91%.

---

# Morale

Il Morale rappresenta la motivazione, la fiducia e la condizione emotiva dell'artista/band.

Range:

```text
0 → 100%
```

Il morale influenza principalmente:

* creatività;
* probabilità di ottenere idee musicali;
* probabilità di ottenere colpi di genio;
* qualità di alcune attività creative;
* partecipazione/affluenza agli eventi live;
* dinamiche interne alla band;
* disponibilità a svolgere determinate attività.

Il morale non deve però diventare un semplice moltiplicatore universale.

Un artista con morale basso può comunque produrre musica di qualità, ma potrebbe avere maggiore difficoltà nel processo creativo.

---

# Relazione tra le Tre Risorse

Le tre risorse devono interagire tra loro.

Schema generale:

```text
             ENERGIA
                ↓
          capacità fisica
                ↓
              AZIONI
                ↑
          efficacia
                ↑
             STRESS
                ↑
          pressione
                ↑
             MORALE
```

Una rappresentazione più realistica è:

```text
              ┌───────────┐
              │  ENERGIA  │
              └─────┬─────┘
                    │
             performance
                    │
                    ↓
              ┌───────────┐
              │  AZIONE   │
              └─────┬─────┘
                    │
          ┌─────────┼─────────┐
          ↓         ↓         ↓
      Energia     Stress    Morale
          ↑         ↓         ↑
          └────── RIPOSO ─────┘
```

L'obiettivo è creare un sistema nel quale una scelta produca conseguenze su più dimensioni.

---

# Esempio di Ciclo Negativo

Una delle dinamiche che il sistema deve essere in grado di rappresentare è:

```text
Poco sonno
 ↓
Energia ↓
 ↓
Azioni più lente
 ↓
Meno attività completate
 ↓
Pressione/stress ↑
 ↓
Efficacia ↓
 ↓
Peggioramento del morale
 ↓
Minore creatività
 ↓
Ulteriore difficoltà
```

Il giocatore deve quindi poter riconoscere quando è necessario fermarsi.

---

# Esempio di Ciclo Positivo

Al contrario:

```text
Riposo
 ↓
Energia ↑
Stress ↓
 ↓
Attività più efficaci
 ↓
Buona performance
 ↓
Morale ↑
 ↓
Creatività ↑
 ↓
Migliori risultati
```

Il gioco deve quindi premiare indirettamente una buona gestione del proprio stato.

---

# Recupero Attivo

Il recupero non deve avvenire solamente attraverso il sonno.

Durante la giornata il giocatore potrà utilizzare attività di recupero attivo.

Queste attività devono avere un costo e/o una controindicazione.

Il principio generale è:

```text
Recupero immediato
+
Conseguenza secondaria
```

In questo modo il giocatore deve scegliere quale risorsa vuole sacrificare.

---

## Caffè al Bar

Possibile attività:

```text
☕ Caffè
```

Effetto:

```text
Energia ↑ temporaneamente
Stress ↑ leggermente in seguito
```

Il caffè deve quindi essere uno strumento di emergenza o di gestione temporanea, non una cura gratuita.

Possibili evoluzioni future:

* qualità del caffè;
* numero di caffè consecutivi;
* tolleranza;
* effetti temporanei;
* eventi legati al bar.

La meccanica dovrà essere bilanciata per evitare che il giocatore possa mantenere indefinitamente l'Energia tramite caffè.

---

# Passeggiata al Parco

Possibile attività:

```text
🌳 Passeggiata
```

Effetti principali:

```text
Stress ↓
Morale ↑ leggermente
Energia ↓ leggermente
```

La passeggiata rappresenta un recupero più lento ma equilibrato.

Può essere utilizzata quando il giocatore ha tempo libero e vuole recuperare senza ricorrere al sonno.

---

# Ascoltare Musica

Possibile attività:

```text
🎵 Ascolta un disco
```

Effetti:

```text
Morale ↑
Stress ↓ leggermente
Energia → invariata o leggermente ↓
```

La qualità o il contesto dell'ascolto potrebbero influenzare l'effetto.

In futuro potrebbe inoltre esistere una possibilità di ottenere:

```text
Ispirazione musicale
```

durante l'ascolto.

Questo crea una connessione naturale tra:

```text
Tempo libero
 ↓
Morale
 ↓
Ispirazione
 ↓
Composizione
```

---

# Recupero Sociale

Il sistema potrà successivamente includere attività come:

* uscire con amici;
* passare tempo con la band;
* andare al bar;
* partecipare a una festa;
* frequentare locali;
* incontrare persone importanti per la carriera.

Queste attività possono modificare:

```text
Morale
Stress
Energia
Relazioni
Fans
Opportunità
```

Il loro valore dipenderà dal contesto.

Una festa dopo una giornata tranquilla potrebbe essere positiva.

La stessa festa dopo un concerto massacrante potrebbe invece aumentare ulteriormente la fatica.

---

# Morale Basso

Il morale deve avere conseguenze concrete.

Quando il morale raggiunge valori molto bassi possono verificarsi:

* riduzione della creatività;
* minore probabilità di ottenere idee musicali;
* maggiore difficoltà nelle attività di scrittura;
* riduzione della motivazione;
* maggiore probabilità di eventi negativi legati alla band;
* possibile rifiuto di alcune attività opzionali.

---

# Blocco Creativo

Una delle conseguenze più importanti del morale basso sarà il **Blocco Creativo**.

Quando le condizioni del personaggio sono sufficientemente negative, la scrittura di nuovi brani può diventare temporaneamente inefficace.

Esempio:

```text
Morale molto basso
+
Stress elevato
 ↓
Blocco creativo
```

Possibili effetti:

```text
Scrittura brano
→ nessun progresso
```

oppure:

```text
Scrittura brano
→ progresso fortemente ridotto
```

Il blocco non deve necessariamente essere permanente.

Il giocatore deve poterlo superare attraverso:

* riposo;
* attività ricreative;
* socializzazione;
* ascolto musicale;
* concerti positivi;
* successo professionale;
* eventi narrativi;
* miglioramento del morale.

---

# Panico

Quando:

```text
Stress ≥ 80
```

il personaggio entra nella condizione di **Panico**.

Il Panico rappresenta uno stato di stress estremamente elevato e deve avere effetti temporanei.

Possibili conseguenze:

* forte riduzione dell'efficacia;
* maggiore consumo di energia;
* difficoltà nelle attività creative;
* possibilità di interrompere alcune attività;
* maggiore probabilità di eventi negativi;
* recupero più difficile finché lo stress non diminuisce.

Il sistema deve evitare di creare un "game over" automatico.

Il Panico deve essere una situazione da gestire, non una condanna.

---

# Burnout

Quando:

```text
Energy < 15
```

si attiva la condizione di Burnout.

Effetti già implementati:

```text
Durata azioni ×2
Qualità delle azioni ↓
```

In futuro potranno essere aggiunti:

* maggiore stress;
* minore morale;
* rischio di fallimento delle attività;
* necessità di riposo;
* eventi legati alla stanchezza.

---

# Interazione con il Tempo

Energia, Stress e Morale devono essere strettamente collegati al sistema temporale.

Esempio:

```text
Attività lunga
 ↓
Tempo ↑
Energia ↓
Stress ↑
```

Durante la notte:

```text
Attività oltre mezzanotte
 ↓
Overtime
 ↓
Stress ↑
 ↓
Recupero successivo ↓
```

Durante il riposo:

```text
Sonno
 ↓
Tempo trascorso
 ↓
Energia ↑
Stress ↓
```

Questo collega direttamente la triade al sistema definito nella sezione 1.2.

---

# Interazione con le Attività

Ogni attività dovrebbe definire almeno:

```text
duration
energyCost
stressChange
moraleChange
```

e, quando necessario:

```text
qualityModifier
creativeModifier
```

Esempio concettuale:

| Attività            | Tempo |      Energia |       Stress |    Morale |
| ------------------- | ----: | -----------: | -----------: | --------: |
| Allenamento leggero | breve |            - |            + |         + |
| Allenamento intenso | medio |           -- |           ++ |         + |
| Scrivere musica     | medio |            - |        + / - | variabile |
| Concerto            | lungo |          --- |           ++ |        ++ |
| Passeggiata         | breve |            - |           -- |         + |
| Caffè               | breve | + temporanea | + successivo |         0 |
| Ascoltare musica    | breve |            0 |            - |         + |

I valori definitivi devono essere gestiti dal sistema di bilanciamento e non hardcoded nei singoli sistemi.

---

# Modificatori di Efficacia

L'efficacia di un'attività deve essere determinata considerando almeno:

```text
Skill
+ Energia
+ Stress
+ Morale
+ eventuali modificatori contestuali
```

Concettualmente:

```text
Efficacia =
Base Skill
× Energy Modifier
× Stress Modifier
× Morale Modifier
× Context Modifier
```

I modificatori devono essere progettati in modo da evitare che una singola risorsa renda completamente inutili tutte le altre.

---

# Indicatori e Accessibilità

Le tre risorse devono essere sempre facilmente identificabili.

L'interfaccia deve utilizzare:

* indicatori ad alto contrasto;
* percentuali numeriche;
* stato testuale;
* aggiornamento dinamico;
* feedback accessibile.

Il tasto:

```text
I
```

permette di ottenere un annuncio istantaneo dello stato delle risorse nella barra superiore.

Esempio di annuncio NVDA:

```text
Energia 72 percento.
Stress 31 percento.
Morale 84 percento.
```

Quando una risorsa raggiunge una soglia importante, il sistema può generare un annuncio contestuale.

Esempio:

```text
"Attenzione: energia molto bassa."
```

oppure:

```text
"Stress elevato."
```

Gli annunci non devono diventare eccessivamente frequenti o disturbanti.

---

# Soglie di Stato

Le soglie devono essere utilizzate per comunicare lo stato del personaggio senza trasformare ogni variazione numerica in un evento.

### Energia

```text
100–70 → Alta
69–40  → Normale
39–16  → Bassa
15–0   → Burnout
```

### Stress

```text
0–29   → Basso
30–59  → Moderato
60–79  → Alto
80–100 → Panico
```

### Morale

```text
80–100 → Eccellente
60–79  → Buono
40–59  → Neutrale
20–39  → Basso
0–19   → Critico
```

Le soglie rappresentano principalmente stati descrittivi e di gameplay; i modificatori matematici devono poter utilizzare formule continue.

---

# Recupero e Scelte Strategiche

Il giocatore deve poter decidere quale risorsa recuperare in base alla situazione.

Esempio:

```text
Energia 20
Stress 30
Morale 70
```

Potrebbe essere conveniente riposare.

Invece:

```text
Energia 70
Stress 75
Morale 30
```

potrebbe essere più utile svolgere un'attività rilassante.

Infine:

```text
Energia 60
Stress 50
Morale 10
```

potrebbe essere necessario concentrarsi soprattutto sul recupero del morale.

Il sistema deve quindi evitare una soluzione universale del tipo:

```text
"Premi RIPOSA → tutto torna a 100."
```

---

# Interazione con la Band

Il Morale può essere applicato sia al singolo artista sia alla band.

In futuro ogni membro della band potrebbe avere:

```text
Morale individuale
Stress individuale
Energia individuale
```

mentre la band possiede un:

```text
Morale collettivo
```

Il morale , energia della band può influenzare:

* prove;
* performance;
* collaborazione;
* creatività collettiva;
* rischio di conflitti;
* qualità dei concerti.

Questo permetterà di introdurre dinamiche più profonde nella gestione della band.

---

# Principi di Design

Il sistema deve rispettare i seguenti principi:

1. **Le tre risorse sono interconnesse.**

2. **Nessuna risorsa deve essere puramente decorativa.**

3. **Le conseguenze devono essere progressive.**

4. **Le soglie critiche devono avere effetti concreti.**

5. **Il giocatore deve avere strumenti per recuperare.**

6. **Il recupero deve avere costi o compromessi.**

7. **Il sonno non deve essere l'unico metodo di recupero.**

8. **Le attività ricreative devono avere un ruolo reale nel gameplay.**

9. **Il morale deve avere un impatto concreto sulla creatività.**

10. **Il burnout non deve trasformarsi automaticamente in game over.**

11. **Il panico deve essere una condizione gestibile.**

12. **La triade deve essere collegata al sistema temporale.**

13. **Le conseguenze devono dipendere dal contesto.**

14. **I valori matematici devono essere centralizzati nella configurazione di bilanciamento.**

15. **Tutte le informazioni importanti devono essere accessibili tramite NVDA.**

---

# Spazio per i Dettagli di Luca

### Decisioni confermate

* [x] Energia: range 0–100.
* [x] Stress: range 0–100.
* [x] Morale: range 0–100.
* [x] Burnout Energia sotto il 15%.
* [x] Panico Stress sopra/sul 80%.
* [x] Burnout: azioni ×2 tempo e qualità ridotta.
* [x] Stress: penalità progressiva sull'efficacia.
* [x] Morale: influenza creatività e performance.
* [x] Morale molto basso: possibile blocco creativo.
* [x] Recupero attivo durante il giorno.
* [x] Caffè come recupero energetico temporaneo con conseguenza successiva.
* [x] Passeggiata per ridurre lo stress.
* [x] Ascoltare musica per migliorare il morale.
* [x] Possibilità di ulteriori attività sociali di recupero.
* [x] Sistema interconnesso con il tempo.
* [x] Sistema interconnesso con il sonno.
* [x] Sistema interconnesso con l'overtime.
* [x] Indicatori ad alto contrasto.
* [x] Annuncio istantaneo tramite tasto `I`.
* [x] Feedback accessibile tramite NVDA.
* [x] Recupero non limitato al sonno.
* [x] Conseguenze progressive anziché esclusivamente binarie.

Idee future

Sistema completo di qualità del sonno.

Caffè con effetti temporanei e tolleranza.

Sistema di pasti/alimentazione.

Attività ricreative avanzate.

Sistema di relazioni come strumento di recupero.

Morale individuale dei membri della band.

Morale collettivo della band.

Conflitti interni alla band legati allo stress.

Blocco creativo con eventi dedicati.

Eventi positivi che aumentano il morale.

Eventi negativi che riducono il morale.

Sistema di "giornata storta" basato sulla combinazione delle tre risorse.

Effetti cumulativi della privazione del sonno.

Eventuale sistema di dipendenze/abitudini per alcune attività di recupero, da valutare attentamente in fase di bilanciamento.

Bilanciamento completo dei modificatori.

Test automatici per tutte le soglie.

Test di interazione tra Energia, Stress e Morale.

Test accessibilità NVDA.

-----------------------------------------------------------------------------------------------------------------------------
### 1.4 Le 7 Abilità Musicali & Formule Matematiche XP
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo abilità: `systems/skill_system.gd`.
  - Le 7 abilità (`Enums.SkillType`):
    1. Strumento (Esecuzione e tecnica esecutiva)
    2. Composizione (Armonia, riff e melodie)
    3. Scrittura Testi (Poetica, metrica e rime)
    4. Produzione (Sound engineering e missaggio)
    5. Presenza Scenica (Coinvolgimento e tenuta del palco)
    6. Carisma (Magnetismo e comunicazione)
    7. Senso degli Affari (Negoziazione, contratti e bilancio)
  - Curva XP esponenziale in `core/formulas.gd`: `Formulas.calculate_required_xp(level) = round(50.0 * (level ^ 1.35))`.
  - Rendimenti marginali decrescenti nello stesso giorno (`Constants.SATURATION`): 1a sessione 100% XP, 2a sessione 70% XP, 3a sessione 40% XP.
  - Azione Allenamento Rapido: Consumo 10 energia, guadagno 10 XP base.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Albero dei Talenti / Perk sbloccabili a soglie (Livello 25, 50, 75, 100) per ciascuna abilità (es. Carisma 50 sblocca "Ipnotizzatore di Folle"; Produzione 50 sblocca "Orecchio Assoluto").
  - Corsi privati di musica avanzati con maestri illustri a pagamento.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:

    ### 1.4 Le 7 Abilità Musicali & Formule Matematiche XP

#### Stato Attuale e Fondamenta Tecniche

Il sistema delle abilità musicali rappresenta la progressione tecnica e professionale dell'artista.

Il sistema è gestito principalmente dal modulo:

```text
systems/skill_system.gd
```

Le formule matematiche di progressione sono centralizzate in:

```text
core/formulas.gd
```

Questo permette di mantenere separata la logica delle abilità dal bilanciamento matematico.

---

# Le 7 Abilità

Il gioco utilizza sette abilità principali.

```text
1. Strumento
2. Composizione
3. Scrittura Testi
4. Produzione
5. Presenza Scenica
6. Carisma
7. Senso degli Affari
```

Ogni abilità rappresenta un aspetto differente della carriera dell'artista.

---

## 1. Strumento

Rappresenta la capacità tecnica di eseguire musica attraverso lo strumento principale dell'artista.

Comprende:

* tecnica esecutiva;
* precisione;
* velocità;
* qualità dell'esecuzione dal vivo.

L'abilità può influenzare direttamente la performance musicale.

Esempi:

```text
Chitarra
Basso
Batteria
Pianoforte
Tastiere
Strumenti a fiato
```

La specializzazione dello strumento potrà essere approfondita in futuro.

---

# 2. Composizione

Rappresenta la capacità di creare la struttura musicale di un brano.

Comprende:

* armonia;
* riff;
* melodie;
* progressioni;
* arrangiamento;
* struttura del brano;
* capacità di sviluppare idee musicali.

L'abilità è particolarmente importante per la creazione di nuove canzoni.

Una maggiore Composizione può aumentare:

* qualità musicale;
* probabilità di ottenere idee valide;
* varietà delle composizioni;
* qualità di riff e melodie.

---

# 3. Scrittura Testi

Rappresenta la capacità di scrivere testi musicali.

Comprende:

* poetica;
* metrica;
* rime;
* storytelling;
* scelta delle parole;
* capacità narrativa;
* adattamento del testo alla musica.

Può influenzare la qualità lirica dei brani.

---

# 4. Produzione

Rappresenta le competenze tecniche necessarie alla produzione musicale.

Comprende:

* registrazione;
* sound engineering;
* missaggio;
* arrangiamento tecnico;
* effetti;
* qualità sonora;
* gestione dello studio.

Una Produzione elevata permette all'artista di ottenere maggiore qualità dalle registrazioni.

In futuro potrà inoltre ridurre la dipendenza da produttori esterni.

---

# 5. Presenza Scenica

Rappresenta la capacità di coinvolgere il pubblico durante una performance.

Comprende:

* presenza sul palco;
* movimento;
* controllo del palco;
* gestione dell'energia;
* interazione con il pubblico;
* capacità di mantenere l'attenzione.

Questa abilità è particolarmente importante durante i concerti.

Può influenzare:

* performance live;
* soddisfazione del pubblico;
* fama ottenuta;
* probabilità di ottenere nuovi fan;
* qualità dello spettacolo.

---

# 6. Carisma

Rappresenta il magnetismo personale dell'artista.

Comprende:

* comunicazione;
* capacità di parlare al pubblico;
* interviste;
* relazioni professionali;
* capacità di convincere gli altri;
* rapporto con fan e media.

Il Carisma può influenzare:

* pubblico;
* eventi;
* relazioni;
* opportunità;
* negoziazioni sociali;
* promozione.

Il Carisma non deve essere confuso con la Presenza Scenica.

```text
Presenza Scenica
→ "Come domini il palco."

Carisma
→ "Come conquisti le persone."
```

---

# 7. Senso degli Affari

Rappresenta la capacità dell'artista di gestire gli aspetti economici e professionali della carriera.

Comprende:

* negoziazione;
* contratti;
* gestione economica;
* investimenti;
* valutazione delle opportunità;
* gestione dei costi;
* rapporti professionali.

Questa abilità permette di rendere il personaggio non soltanto un musicista, ma anche un professionista capace di gestire la propria carriera.

Può influenzare:

* valore dei contratti;
* costi delle operazioni;
* profitti;
* negoziazioni;
* gestione della band;
* investimenti.

---

# Progressione delle Abilità

Ogni abilità possiede un proprio livello.

Il livello rappresenta la competenza complessiva raggiunta dal personaggio.

Le abilità devono essere indipendenti.

Esempio:

```text
Strumento       72
Composizione    48
Scrittura       35
Produzione      20
Presenza        61
Carisma         55
Affari          18
```

Questo permette di creare personaggi specializzati.

Un artista potrebbe essere:

```text
Ottimo musicista
+
Scarso uomo d'affari
```

oppure:

```text
Compositore eccellente
+
Scarso performer
```

oppure ancora:

```text
Musicista mediocre
+
Carisma elevatissimo
+
Ottimo senso degli affari
```

Il sistema non deve obbligare il giocatore a sviluppare tutte le abilità allo stesso livello.

---

# Formula XP

La quantità di XP necessaria per raggiungere un determinato livello utilizza una curva esponenziale.

La formula implementata in:

```text
core/formulas.gd
```

è:

```text
Formulas.calculate_required_xp(level)
=
round(50.0 × (level ^ 1.35))
```

In forma matematica:

```text
XP richiesta = round(50 × livello^1.35)
```

La curva permette di mantenere una progressione relativamente rapida ai livelli iniziali e progressivamente più impegnativa ai livelli elevati.

---

# Esempi della Curva XP

Indicativamente:

```text
Livello 1
→ 50 XP

Livello 10
→ ~1118 XP

Livello 25
→ ~3675 XP

Livello 50
→ ~13.900 XP

Livello 75
→ ~23.800 XP

Livello 100
→ ~50.000 XP
```

I valori effettivi devono sempre essere ottenuti dalla funzione centralizzata `calculate_required_xp()`.

Il documento di bilanciamento deve considerare la formula come **single source of truth**.

---

# XP e Level-Up

L'XP deve essere accumulata indipendentemente per ogni abilità.

Esempio:

```text
Composizione
XP: 850 / 1118
Livello: 10
```

Quando l'XP raggiunge la soglia richiesta:

```text
XP attuale >= XP richiesta
```

viene effettuato il level-up.

L'eventuale XP eccedente deve essere mantenuta, evitando che il giocatore perda il progresso ottenuto.

Esempio:

```text
XP richiesta: 100
XP posseduta: 95

+20 XP

→ Level Up
→ XP residua: 15
```

Questo comportamento permette di mantenere una progressione fluida.

---

# Rendimenti Marginali Decrescenti

Per evitare che il giocatore possa allenare indefinitamente la stessa abilità durante una singola giornata, è presente un sistema di saturazione.

Parametro:

```text
Constants.SATURATION
```

Le sessioni successive della stessa abilità nella stessa giornata producono meno XP.

Attualmente:

| Sessione giornaliera |                      XP ottenuta |
| -------------------- | -------------------------------: |
| 1ª                   |                             100% |
| 2ª                   |                              70% |
| 3ª                   |                              40% |
| successive           | da definire / fortemente ridotte |

Il principio è:

```text
Prima sessione
→ rendimento massimo

Seconda sessione
→ rendimento ridotto

Terza sessione
→ rendimento fortemente ridotto
```

Questo sistema impedisce strategie del tipo:

> "Alleno Strumento per tutta la giornata e domani sono Jimi Hendrix."

La crescita deve richiedere una gestione equilibrata del tempo.

---

# Interazione tra Saturazione e Tempo

La saturazione viene calcolata **all'interno della singola giornata**.

Al cambio di giornata:

```text
04:00
 ↓
EndDaySystem
 ↓
reset saturazione
 ↓
nuovo giorno
```

Il giocatore può quindi tornare ad allenarsi il giorno successivo ottenendo nuovamente il rendimento massimo iniziale.

La saturazione non rappresenta una perdita permanente della capacità di apprendere, ma una forma di **rendimenti marginali decrescenti**.

---

# Allenamento Rapido

È presente una prima attività di allenamento:

```text
Allenamento Rapido
```

Costo:

```text
10 Energia
```

Ricompensa base:

```text
10 XP
```

Schema:

```text
Allenamento Rapido
 ↓
Energia -10
 ↓
XP +10
 ↓
aggiornamento saturazione
```

L'XP effettivamente ottenuta deve essere modificata dal livello di saturazione della sessione.

Esempio:

```text
1ª sessione
10 XP × 100%
= 10 XP

2ª sessione
10 XP × 70%
= 7 XP

3ª sessione
10 XP × 40%
= 4 XP
```

I valori devono essere gestiti dal sistema di bilanciamento.

---

# Abilità e Tipologia di Attività

Non tutte le attività devono fornire XP a tutte le abilità.

Ogni attività dovrebbe definire quali abilità sviluppa.

Esempi:

```text
Allenamento chitarra
→ Strumento

Scrivere riff
→ Composizione

Scrivere testo
→ Scrittura Testi

Sessione in studio
→ Produzione

Prova live
→ Presenza Scenica

Intervista
→ Carisma

Negoziare contratto
→ Senso degli Affari
```

Alcune attività possono sviluppare più abilità contemporaneamente.

Esempio:

```text
Concerto
→ Presenza Scenica
→ Carisma
→ Strumento
```

con quantità di XP differenti.

---

# XP Contestuale

L'XP ottenuta non deve dipendere esclusivamente dal tipo di attività.

Potranno essere applicati modificatori derivanti da:

* qualità dell'attività;
* energia;
* stress;
* morale;
* insegnante;
* struttura utilizzata;
* difficoltà;
* strumenti;
* eventi;
* perk;
* bonus temporanei.

Schema:

```text
XP finale =
XP base
× Saturation Modifier
× Quality Modifier
× Context Modifier
```

In questo modo una stessa attività può produrre risultati differenti in condizioni differenti.

---

# Albero dei Talenti / Perk

Una futura espansione del sistema introduce un sistema di **Talenti/Perk**.

Le soglie principali previste sono:

```text
Livello 25
Livello 50
Livello 75
Livello 100
```

Ogni abilità avrà il proprio percorso di talenti.

Schema:

```text
ABILITÀ
   │
   ├── Lv.25 → Perk
   ├── Lv.50 → Perk
   ├── Lv.75 → Perk
   └── Lv.100 → Perk
```

I perk devono modificare concretamente il gameplay e non essere semplicemente bonus numerici.

---

# Esempio: Carisma

A una determinata soglia potrebbe essere sbloccato:

```text
"👥 Ipnotizzatore di Folle"
```

Possibili effetti:

* maggiore coinvolgimento del pubblico;
* bonus agli eventi live;
* maggiore efficacia delle interazioni con i fan;
* possibilità di ottenere risultati speciali durante i concerti.

Gli effetti definitivi devono essere bilanciati successivamente.

---

# Esempio: Produzione

A una determinata soglia potrebbe essere sbloccato:

```text
"🎚 Orecchio Assoluto"
```

Possibili effetti:

* maggiore qualità delle produzioni;
* riduzione degli errori durante il processo;
* maggiore efficacia delle sessioni di studio;
* possibilità di ottenere risultati speciali durante il mixing.

---

# Filosofia dei Perk

I perk devono principalmente introdurre **nuove possibilità**.

Preferenza:

```text
Nuova meccanica
```

rispetto a:

```text
+5% a tutto
```

Esempio:

```text
Perk debole:
+5% XP Produzione
```

Esempio più interessante:

```text
Perk:
puoi produrre autonomamente un brano senza
utilizzare un produttore esterno.
```

Il secondo modifica realmente le possibilità del giocatore.

---

# Corsi Privati

Una futura meccanica permetterà di acquistare corsi privati da maestri specializzati.

Esempio:

```text
Corso privato
       ↓
Costo denaro
       ↓
Tempo dedicato
       ↓
XP abilità
       ↓
eventuale bonus
```

I corsi devono rappresentare un'alternativa all'allenamento tradizionale.

Il vantaggio può essere:

* maggiore XP;
* accesso a tecniche speciali;
* riduzione della saturazione;
* bonus temporaneo;
* possibilità di sbloccare perk particolari.

---

# Maestri Illustri

I corsi più avanzati possono essere tenuti da maestri con caratteristiche differenti.

Ogni maestro potrebbe avere:

```text
Specializzazione
Costo
Durata
XP base
Bonus
Requisiti
```

Esempio:

```text
Maestro di Chitarra
Costo: $$$
Durata: lunga
XP Strumento: elevata
Requisito: Strumento ≥ 40
```

Questo crea un sistema di progressione economica collegato alle abilità.

---

# Rapporto tra Denaro e Crescita

La formazione avanzata deve creare una scelta:

```text
Investire denaro
→ migliorare rapidamente
```

oppure:

```text
Risparmiare denaro
→ crescita più lenta
```

Questo collega direttamente:

```text
Senso degli Affari
        ↓
Gestione del denaro
        ↓
Formazione
        ↓
Crescita delle abilità
```

In questo modo le sette abilità non devono essere sistemi completamente isolati.

---

# Specializzazione

Il sistema deve permettere al giocatore di sviluppare una propria identità.

Esempio:

```text
Rock Guitar Hero

Strumento       ██████████
Composizione    ████████
Scrittura       ██████
Produzione      ████
Presenza        █████████
Carisma         ███████
Affari          ███
```

Oppure:

```text
Producer / Songwriter

Strumento       ███
Composizione    █████████
Scrittura       ███████
Produzione      ██████████
Presenza        ███
Carisma         ████
Affari          ███████
```

Non deve esistere una distribuzione obbligatoria delle abilità.

---

# Sinergie tra Abilità

Le abilità possono interagire tra loro.

Esempi:

```text
Composizione + Scrittura Testi
→ qualità complessiva del brano
```

```text
Strumento + Presenza Scenica
→ performance live
```

```text
Carisma + Presenza Scenica
→ coinvolgimento del pubblico
```

```text
Produzione + Composizione
→ qualità della registrazione
```

```text
Carisma + Senso degli Affari
→ negoziazione professionale
```

Questo permette di evitare che il giocatore possa considerare ogni abilità come un semplice numero indipendente.

---

# Principi di Design

Il sistema delle abilità deve rispettare i seguenti principi:

1. **Le sette abilità devono avere funzioni differenti.**

2. **Nessuna abilità deve essere obbligatoriamente massimizzata.**

3. **Il giocatore deve poter creare specializzazioni differenti.**

4. **Le attività devono fornire XP coerenti con ciò che rappresentano.**

5. **La progressione deve diventare gradualmente più impegnativa.**

6. **La saturazione deve impedire il farming infinito nella stessa giornata.**

7. **Il cambio di giornata deve ripristinare il rendimento giornaliero.**

8. **L'XP deve essere centralizzata e bilanciabile.**

9. **I perk devono introdurre nuove possibilità oltre ai semplici bonus numerici.**

10. **La formazione avanzata deve essere collegata all'economia.**

11. **Le abilità devono poter interagire tra loro.**

12. **Energia, Stress e Morale devono influenzare indirettamente l'apprendimento.**

13. **Il giocatore deve poter costruire identità professionali differenti.**

14. **La progressione deve premiare la pianificazione a lungo termine.**

---

# Spazio per i Dettagli di Luca

### Decisioni confermate

* [x] Sono presenti 7 abilità.
* [x] Strumento.
* [x] Composizione.
* [x] Scrittura Testi.
* [x] Produzione.
* [x] Presenza Scenica.
* [x] Carisma.
* [x] Senso degli Affari.
* [x] XP indipendente per ogni abilità.
* [x] Formula XP: `round(50.0 × level^1.35)`.
* [x] Curva XP progressivamente crescente.
* [x] Sistema di saturazione giornaliera.
* [x] Prima sessione: 100% XP.
* [x] Seconda sessione: 70% XP.
* [x] Terza sessione: 40% XP.
* [x] Allenamento Rapido: 10 Energia → 10 XP base.
* [x] Saturazione resettata con il nuovo giorno.
* [x] Albero dei Talenti/Perk.
* [x] Soglie principali: Livello 25, 50, 75, 100.
* [x] Perk specifici per ogni abilità.
* [x] Corsi privati avanzati.
* [x] Maestri specializzati.
* [x] Formazione avanzata a pagamento.
* [x] Sinergie tra abilità.
* [x] Possibilità di specializzazione del personaggio.

Idee future

Definire tutti i perk di Livello 25.

Definire tutti i perk di Livello 50.

Definire tutti i perk di Livello 75.

Definire tutti i perk di Livello 100.

Definire se il giocatore può scegliere tra più perk oppure se il perk è automatico.

Creare un vero Skill Tree visuale.

Definire XP specifica per ogni attività.

Definire eventuali bonus XP derivanti da Energia/Morale.

Definire le penalità XP derivanti dallo Stress.

Definire il comportamento dell'XP quando si effettua un level-up.

Definire eventuali livelli massimi oltre il 100.

Definire corsi e maestri disponibili.

Definire costi e durata dei corsi.

Definire requisiti per accedere ai maestri più avanzati.

Creare attività avanzate che richiedano determinate abilità.

Creare sinergie specifiche tra abilità.

Collegare i perk ai sistemi di Concerti, Musica, Economia e Band.

Bilanciare la curva XP attraverso simulazioni.

Creare test automatici per la formula XP.

Creare test automatici per la saturazione giornaliera.

Verificare che il reset della saturazione avvenga correttamente alle 04:00.

Testare il sistema con velocità 1x, 2x e 3x.

Testare accessibilità e annunci NVDA per level-up, XP e sblocco perk.

-----------------------------------------------------------------------------------------------------------------------------

### 1.5 Lifestyle, Spazio Vitale & Spese di Sussistenza
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo economico: `systems/economy_system.gd`.
  - Spesa giornaliera vitto base: `Constants.DAILY_FOOD_EXPENSE` = 10.0 €.
  - 4 Categorie di Alloggio (`Enums.HousingTier`):
    1. Stanzetta singola: Canone 15.0 €/giorno (`RENT_BEDROOM`).
    2. Appartamento con la Band: Canone 25.0 €/giorno totali (`RENT_SHARED_FLAT`), ripartito automaticamente tra i coinquilini della band (es. se la band è al completo paga circa 6.25 € a testa), con bonus affinità e recupero morale notturno.
    3. Loft con sala prove: Canone 50.0 €/giorno (`RENT_LOFT_STUDIO`), annulla lo stress delle prove casalinghe.
    4. Villa con studio di registrazione: Canone 150.0 €/giorno (`RENT_LUXURY_VILLA`), massimo recupero morale notturno (+12 morale) e azzeramento stress.
  - Gestione traslochi integrata nella schermata Upgrades (`UpgradesModal`, tasto `U`).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Alloggi di proprietà (possibilità di acquistare l'immobile per eliminare il canone giornaliero di affitto).
  - Arredamenti e strumenti di comfort domestico (TV, console per videogiochi, collezione di vinili rari, impianto stereo Hi-Fi).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 
### 1.5 Lifestyle, Spazio Vitale & Spese di Sussistenza

#### Stato Attuale e Fondamenta Tecniche

Il sistema Lifestyle rappresenta le condizioni di vita quotidiana dell'artista.

Non riguarda solamente il denaro necessario per sopravvivere, ma anche:

* qualità dell'abitazione;
* comfort;
* recupero durante il riposo;
* rapporto con i membri della band;
* possibilità di svolgere determinate attività;
* progressione economica;
* stile di vita raggiunto durante la carriera.

Il sistema economico è gestito principalmente dal modulo:

```text
systems/economy_system.gd
```

Le spese di sussistenza vengono integrate nel ciclo giornaliero definito nella sezione 1.2.

A ogni fine giornata vengono quindi considerate le principali spese ricorrenti del personaggio.

---

# Spesa Alimentare

Il gioco prevede una spesa giornaliera minima per il vitto.

Parametro:

```text
Constants.DAILY_FOOD_EXPENSE = 10.0
```

Costo:

```text
10 € / giorno
```

La spesa rappresenta il costo base necessario per mantenere il personaggio.

Il valore viene applicato automaticamente durante il ciclo economico di fine giornata.

Schema:

```text
Fine giornata
 ↓
Spesa alimentare
 ↓
-10 €
```

Il costo del vitto è volutamente separato dal canone dell'abitazione.

In futuro il sistema potrà essere ampliato introducendo differenti livelli di alimentazione e qualità della vita.

---

# Sistema degli Alloggi

Il giocatore può vivere in differenti tipologie di abitazione.

Il sistema utilizza:

```text
Enums.HousingTier
```

Le abitazioni disponibili sono quattro.

```text
1. Stanzetta singola
2. Appartamento con la Band
3. Loft con sala prove
4. Villa con studio di registrazione
```

Ogni abitazione modifica principalmente:

* costo giornaliero;
* recupero del morale;
* recupero notturno;
* stress;
* possibilità di svolgere determinate attività;
* qualità della vita;
* rapporto con gli altri membri della band.

La progressione abitativa rappresenta quindi una forma di crescita parallela alla carriera musicale.

---

# 1. Stanzetta Singola

La Stanzetta Singola rappresenta il punto di partenza del personaggio.

Canone:

```text
RENT_BEDROOM = 15.0 € / giorno
```

È l'opzione più economica.

Caratteristiche:

```text
Costo basso
Comfort limitato
Recupero standard
Nessun vantaggio musicale significativo
```

L'abitazione permette comunque di dormire e recuperare normalmente.

Schema:

```text
Stanzetta
 ↓
Costo contenuto
 ↓
Recupero standard
 ↓
Progressione iniziale
```

È pensata per la fase iniziale della carriera, quando il denaro rappresenta una risorsa limitata.

---

# 2. Appartamento con la Band

L'Appartamento con la Band rappresenta il primo vero miglioramento dello stile di vita.

Canone totale:

```text
RENT_SHARED_FLAT = 25.0 € / giorno
```

Il costo viene automaticamente distribuito tra i membri della band.

Esempio con quattro membri:

```text
25 € ÷ 4
=
6,25 € a persona
```

Il sistema deve quindi considerare dinamicamente il numero di coinquilini effettivi.

Questo permette di collegare direttamente:

```text
Band
 ↓
Abitazione condivisa
 ↓
Divisione delle spese
```

L'appartamento introduce inoltre vantaggi legati alla convivenza.

Possibili effetti già previsti:

* bonus affinità tra i membri;
* miglioramento del recupero morale durante la notte;
* maggiore interazione con la band;
* possibilità di eventi domestici.

La casa diventa quindi anche uno spazio sociale.

---

# 3. Loft con Sala Prove

Il Loft con Sala Prove rappresenta un importante salto di qualità.

Canone:

```text
RENT_LOFT_STUDIO = 50.0 € / giorno
```

La caratteristica principale è la presenza di uno spazio dedicato alla musica.

```text
Loft
 ↓
Sala prove privata
 ↓
Attività musicali domestiche
```

Il vantaggio specifico attualmente previsto è:

```text
Prove casalinghe
→ nessuno stress aggiuntivo legato all'ambiente domestico
```

Questo rende il Loft particolarmente interessante per un artista che vuole investire molto nella propria crescita musicale.

Il giocatore paga quindi un costo maggiore per ottenere:

```text
Comfort
+
Spazio musicale
+
Migliore gestione delle attività
```

Il Loft rappresenta il passaggio da:

```text
"Ho una casa."
```

a:

```text
"Casa mia fa parte della mia carriera."
```

---

# 4. Villa con Studio di Registrazione

La Villa rappresenta il livello abitativo più avanzato attualmente previsto.

Canone:

```text
RENT_LUXURY_VILLA = 150.0 € / giorno
```

La Villa offre il massimo livello di comfort.

Effetti attualmente previsti:

```text
+12 Morale durante il recupero notturno
Stress → 0 durante il recupero
```

Il vantaggio principale è quindi legato alla qualità del recupero.

Schema:

```text
Villa
 ↓
Comfort massimo
 ↓
Recupero morale elevato
 ↓
Stress azzerato
 ↓
Migliore preparazione al giorno successivo
```

Il costo elevato impedisce però che questo vantaggio sia automaticamente accessibile nelle prime fasi della carriera.

La Villa deve rappresentare una vera conseguenza del successo economico.

---

# Confronto degli Alloggi

| Alloggio              | Canone giornaliero | Caratteristica principale                 |
| --------------------- | -----------------: | ----------------------------------------- |
| Stanzetta singola     |               15 € | Costo contenuto                           |
| Appartamento con Band |        25 € totali | Costo condiviso + affinità                |
| Loft con sala prove   |               50 € | Prove domestiche senza stress ambientale  |
| Villa con studio      |              150 € | +12 Morale e stress azzerato nel recupero |

La progressione deve quindi seguire una logica:

```text
Costo ↑
Comfort ↑
Vantaggi ↑
```

ma anche:

```text
Spese giornaliere ↑
```

In questo modo migliorare la propria abitazione rappresenta una scelta economica reale.

---

# Traslochi e Upgrade

La gestione dell'abitazione è integrata nella schermata:

```text
UpgradesModal
```

Accesso rapido:

```text
U
```

Il giocatore può quindi modificare il proprio alloggio direttamente dal sistema degli upgrade.

Schema:

```text
Tasto U
 ↓
UpgradesModal
 ↓
Scelta abitazione
 ↓
Verifica requisiti/costo
 ↓
Cambio HousingTier
```

Il cambio di abitazione deve aggiornare automaticamente i relativi effetti e il costo giornaliero.

---

# Abitazione come Sistema di Gameplay

L'alloggio non deve essere trattato come una semplice voce:

```text
Affitto = -X €
```

Deve invece rappresentare un vero investimento nello stile di vita.

Esempio:

```text
Stanzetta
↓
costo basso
↓
recupero normale

Loft
↓
costo maggiore
↓
spazio musicale
↓
maggiore efficienza

Villa
↓
costo molto elevato
↓
massimo comfort
↓
recupero superiore
```

Il giocatore deve quindi valutare:

```text
Quanto posso permettermi?
        +
Quanto mi serve?
        +
Quali vantaggi voglio ottenere?
```

---

# Relazione con Economia e Carriera

Il sistema abitativo deve essere collegato direttamente alla progressione economica.

Nelle prime fasi:

```text
Poco denaro
 ↓
Abitazione economica
 ↓
Spese contenute
```

Con la crescita della carriera:

```text
Più concerti
 ↓
Più entrate
 ↓
Più disponibilità economica
 ↓
Abitazione migliore
 ↓
Migliore qualità della vita
```

Questo crea una progressione visibile anche al di fuori delle statistiche musicali.

Il giocatore non aumenta solamente:

```text
Livello
Fans
Money
```

ma può anche vedere concretamente il proprio stile di vita migliorare.

---

# Proprietà degli Immobili

Una futura espansione permetterà di acquistare direttamente gli immobili.

Attualmente:

```text
Abitazione
→ affitto giornaliero
```

Possibile evoluzione:

```text
Acquisto immobile
 ↓
Investimento iniziale elevato
 ↓
Eliminazione del canone giornaliero
```

Questo introduce una scelta economica di lungo periodo.

Esempio concettuale:

```text
Affitto
→ costo basso iniziale
→ costo ricorrente

Acquisto
→ costo iniziale elevato
→ nessun affitto successivo
```

Il sistema potrà successivamente considerare anche:

* valore dell'immobile;
* manutenzione;
* possibilità di rivendita;
* rivalutazione;
* costi di gestione;
* immobili speciali.

---

# Arredamento e Comfort

Una futura espansione permetterà di personalizzare gli ambienti domestici.

Esempi:

```text
Televisore
Console per videogiochi
Collezione di vinili
Impianto stereo Hi-Fi
Divano
Attrezzatura musicale
Decorazioni
```

Gli oggetti non devono essere necessariamente semplici elementi estetici.

Potrebbero fornire piccoli effetti di gameplay.

Esempio:

```text
Impianto Hi-Fi
→ maggiore efficacia nell'attività "Ascoltare Musica"

Console
→ attività ricreativa
→ Morale ↑
→ Tempo ↑

Collezione di vinili
→ possibilità di ottenere ispirazione musicale

Attrezzatura musicale
→ attività di allenamento domestico
```

In questo modo l'arredamento può diventare una forma di personalizzazione funzionale.

---

# Spazio Domestico e Attività

L'abitazione può diventare progressivamente un vero hub personale.

A seconda del livello dell'immobile potranno essere disponibili attività differenti.

Esempio:

```text
Stanzetta
├── Dormire
└── Riposare

Appartamento
├── Dormire
├── Riposare
└── Socializzare con la Band

Loft
├── Dormire
├── Riposare
├── Socializzare
└── Provare musica

Villa
├── Dormire
├── Riposare
├── Socializzare
├── Provare musica
└── Registrare musica
```

Questa struttura permette all'abitazione di evolvere insieme alla carriera.

---

# Principi di Design

Il sistema Lifestyle deve rispettare i seguenti principi:

1. **L'abitazione deve avere un impatto reale sul gameplay.**

2. **I costi devono essere coerenti con il livello della carriera.**

3. **Un'abitazione più costosa deve offrire vantaggi concreti.**

4. **Il giocatore deve poter scegliere tra risparmio e comfort.**

5. **La casa deve interagire con Energia, Stress e Morale.**

6. **L'abitazione condivisa deve avere vantaggi e conseguenze sociali.**

7. **Il Loft deve avere una funzione musicale concreta.**

8. **La Villa deve rappresentare un livello avanzato dello stile di vita.**

9. **Gli upgrade domestici devono poter diventare parte della progressione.**

10. **Le spese ricorrenti devono essere integrate nel ciclo economico giornaliero.**

11. **L'acquisto futuro degli immobili deve rappresentare un investimento di lungo periodo.**

12. **Il sistema deve evitare che l'economia domestica diventi solamente una lista di costi.**

13. **Il comfort deve essere una risorsa indiretta per la gestione del personaggio.**

14.  L'affitto deve scalare ogni fine/ inizio mese

---

# Spazio per i Dettagli di Luca

### Decisioni confermate

* [x] Sistema economico gestito da `systems/economy_system.gd`.
* [x] Spesa alimentare giornaliera: 10 €.
* [x] Quattro categorie di alloggio.
* [x] Stanzetta singola:  150€/mese.
* [x] Appartamento con la Band: 120 €/mese totali.
* [x] Divisione automatica del costo dell'appartamento tra i membri della band.
* [x] Bonus affinità dell'appartamento condiviso.
* [x] Recupero morale notturno migliorato nell'appartamento condiviso.
* [x] Loft con sala prove: 50 €/giorno.
* [x] Il Loft annulla lo stress delle prove casalinghe.
* [x] Villa con studio: 600 €/mese.
* [x] Villa: +12 Morale durante il recupero notturno.
* [x] Villa: stress azzerato durante il recupero.
* [x] Gestione degli alloggi tramite `UpgradesModal`.
* [x] Tasto rapido `U` per accedere agli upgrade.
* [ ] Opzioni poi da bilanciare con il gameplay

### Idee future

* [ ] Acquisto diretto degli immobili.
* [ ] Eliminazione del canone dopo l'acquisto.
* [ ] Sistema di valore e rivendita degli immobili.
* [ ] Costi di manutenzione.
* [ ] Arredamento della casa.
* [ ] Televisione.
* [ ] Console per videogiochi.
* [ ] Collezione di vinili rari.
* [ ] Impianto stereo Hi-Fi.
* [ ] Attrezzatura musicale domestica.
* [ ] Decorazioni e personalizzazione degli ambienti.
* [ ] Oggetti domestici con effetti sul Morale.
* [ ] Oggetti domestici con effetti sulle attività.
* [ ] Eventi domestici.
* [ ] Attività disponibili in base al livello dell'abitazione.
* [ ] Registrazione musicale nella Villa.
* [ ] Ulteriori interazioni tra abitazione, band e relazioni.
* [ ] Sistema completo di qualità della vita.
* [ ] Bilanciamento tra costo dell'abitazione e vantaggi ottenuti.

-----------------------------------------------------------------------------------------------------------------------------

