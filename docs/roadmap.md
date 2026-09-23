# World-tour — Roadmap Globale di Approfondimento del Gioco

- Autori del progetto: Luca & Holy Diver
- Assistente AI: Antigravity (Senior AI Pair Programmer)
- Stack di riferimento: Godot Engine 4.7.2 win64, GDScript 2.0, Clean Architecture & AccessKit nativo
- Posizione file: `docs/roadmap.md`
- Stato del progetto: Fondamenta V1.0 – V4.0 e prime espansioni V5.0 (F9.0, F9.1) convalidate con 19 suite di test headless a 0 errori e collaudo NVDA al 100%.

---

## INTRODUZIONE & GUIDA ALLA COMPILAZIONE

Questo documento rappresenta la **Mappa Completa di Approfondimento** di World-tour.  
È organizzato in 12 Sezioni tematiche, ciascuna suddivisa in Sotto-sezioni gerarchiche.  

Per ogni sotto-sezione sono indicati con la massima precisione:
1. **Dettagli Tecnici & Meccaniche Già Implementate**: Il codice reale presente nel repository, le classi GDScript, le costanti numeriche, le formule matematiche e i tasti rapidi già operativi e testati.
2. **Direttrici di Espansione & Idee di Gameplay**: Le evoluzioni previste dal game design.
3. **Spazio per i Dettagli di Luca**: Un'area libera e strutturata dove Luca può aggiungere le sue note, regole di gioco, varianti, dialoghi, nuove formule o indicazioni specifiche.

Tutto il testo è formattato in modo strettamente lineare e sequenziale per la lettura ottimale tramite lo screen reader NVDA (senza grafici 2D, senza tabelle complesse, senza frecce direzionali).

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

## 2. CREATIVITÀ MUSICALE, SCRITTURA BRANI & PRODUZIONE DISCOGRAFICA

### 2.1 Pipeline Creativa a 5 Stadi & Generi Musicali
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo di creazione: `systems/music_system.gd` e modale `ui/song_creator/song_creator.tscn`.
  - Tasto rapido HUD: Tasto `N` (Nuovo Brano) e Tasto `M` (Catalogo Brani).
  - I 6 Generi Musicali (`Enums.MusicalGenre`): Rock, Pop, Metal, Hip Hop, Elettronica, Indie.
  - I 5 Stadi di lavorazione (`Enums.SongStage`):
    1. Concept (Scelta del Genere, Titolo e Ispirazione)
    2. Composizione (Accordi e melodie basati sull'abilità Composizione)
    3. Scrittura Testo (Lirica e metrica basate su Scrittura Testi)
    4. Registrazione (Esecuzione vocale/strumentale basata su Strumento e Hardware Studio)
    5. Missaggio/Produzione (Qualità sonora basata su Produzione e Studio di registrazione)
  - Stati del brano (`Enums.SongStatus`): DRAFT (bozza), PRODUCED (master finito), RELEASED (pubblicato sul mercato).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Tematiche liriche a scelta (es. Rabbia sociale, Amore maledetto, Nostalgia giovanile, Fuga dalla realtà, Satira politica) con bonus di affinità verso determinati generi e determinate città.
  - Minigioco opzionale da tastiera per trovare il riff perfetto o la rima baciata.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 2.2 Algoritmo di Calcolo del Quality Score & Tratti Canzone
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Formula in `core/formulas.gd` (`calculate_song_quality`):
    - Peso Composizione: 25% (`SONG_SKILL_WEIGHT_COMP` = 0.25).
    - Peso Testo: 20% (`SONG_SKILL_WEIGHT_LYRICS` = 0.20).
    - Peso Esecuzione Strumento: 25% (`SONG_SKILL_WEIGHT_EXECUTION` = 0.25).
    - Peso Produzione Sonora: 20% (`SONG_SKILL_WEIGHT_PRODUCTION` = 0.20).
    - Variazione casuale controllata: intervallo +/- 4.0 punti.
    - Punteggio finale Quality Score clampato tra 1.0 e 100.0.
  - I 5 Tratti Speciali Canzone (`Enums.SongTrait`):
    1. `EARWORM` (Tormentone): +25% di streaming e ascolti nei primi 30 giorni di uscita.
    2. `CULT_CLASSIC` (Pezzo Cult): Converte il doppio dei fan ai concerti dal vivo (moltiplicatore x2.0).
    3. `STAGE_BEAST` (Bomba dal Vivo): +15% di Concert Score se posizionato come brano di chiusura nella scaletta.
    4. `AUDIOPHILE_GEM` (Gemma per Audiofili): Recensioni entusiastiche della critica specializzata (richiede Produzione >= 70).
    5. `ROUGH_DIAMOND` (Diamante Grezzo): Eccellente composizione ma resa grezza a causa di registrazione low-fi.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Nuovi tratti speciali (es. Ballata Strappalacrime, Inno da Stadio, Riff Epico, Pezzo Troppo Complesso per la Radio).
  - Interazione tra i tratti e le recensioni dei magazine musicali.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
    ### 2.2 Algoritmo di Calcolo del Quality Score & Tratti Canzone

#### Stato Attuale e Fondamenta Tecniche

Il sistema Song Quality determina la qualità complessiva di un brano in base alle principali competenze musicali dell'artista.

Il calcolo è centralizzato nel modulo:

```text
core/formulas.gd
```

attraverso la funzione:

```text
calculate_song_quality()
```

L'obiettivo è trasformare le abilità dell'artista in un valore numerico comprensibile dal resto dei sistemi.

Il risultato viene utilizzato successivamente dai sistemi legati a:

* pubblicazione;
* ascolti;
* streaming;
* recensioni;
* concerti;
* popolarità;
* successo del brano.

Il Quality Score non rappresenta però automaticamente il successo commerciale.

Principio fondamentale:

```text
QUALITY ≠ COMMERCIAL SUCCESS
```

Un brano può essere tecnicamente eccellente senza diventare necessariamente un successo commerciale.

---

# Formula del Quality Score

Il Quality Score viene calcolato combinando quattro componenti principali:

```text
Composizione
Testo
Esecuzione Strumentale
Produzione
```

I pesi attualmente implementati sono:

| Componente           | Costante                       | Peso |
| -------------------- | ------------------------------ | ---: |
| Composizione         | `SONG_SKILL_WEIGHT_COMP`       |  25% |
| Scrittura Testi      | `SONG_SKILL_WEIGHT_LYRICS`     |  20% |
| Esecuzione Strumento | `SONG_SKILL_WEIGHT_EXECUTION`  |  25% |
| Produzione           | `SONG_SKILL_WEIGHT_PRODUCTION` |  20% |

La somma dei pesi delle quattro componenti è:

```text
25% + 20% + 25% + 20%
=
90%
```

Il restante contributo deriva dalla logica complessiva della formula e dalla variazione casuale controllata.

---

# Componenti del Calcolo

## Composizione — 25%

La Composizione rappresenta la qualità della parte musicale del brano.

Influenza principalmente:

* melodie;
* riff;
* armonia;
* struttura;
* sviluppo delle idee musicali.

Un artista con una Composizione elevata avrà quindi una maggiore capacità di creare materiale musicalmente valido.

Parametro:

```text
SONG_SKILL_WEIGHT_COMP = 0.25
```

---

## Scrittura Testi — 20%

La Scrittura Testi rappresenta la qualità della componente lirica.

Influenza aspetti come:

* qualità delle parole;
* rime;
* metrica;
* struttura del testo;
* capacità narrativa.

Parametro:

```text
SONG_SKILL_WEIGHT_LYRICS = 0.20
```

---

## Esecuzione Strumentale — 25%

L'Esecuzione rappresenta la capacità tecnica dell'artista di trasformare la composizione in una performance musicale.

Parametro:

```text
SONG_SKILL_WEIGHT_EXECUTION = 0.25
```

Questa componente permette di distinguere, ad esempio:

```text
Ottima composizione
+
Esecuzione mediocre
```

da:

```text
Ottima composizione
+
Esecuzione eccellente
```

Il brano può quindi partire da una buona idea, ma la qualità finale dipende anche dalla capacità di eseguirla.

---

## Produzione Sonora — 20%

La Produzione rappresenta la qualità tecnica della registrazione.

Comprende indirettamente:

* registrazione;
* sound engineering;
* missaggio;
* resa sonora;
* qualità dello studio;
* trattamento del materiale registrato.

Parametro:

```text
SONG_SKILL_WEIGHT_PRODUCTION = 0.20
```

Questa componente è particolarmente importante per distinguere la qualità musicale dalla qualità della registrazione.

---

# Variazione Casuale Controllata

Il risultato del calcolo non è completamente deterministico.

È presente una variazione casuale controllata:

```text
± 4.0 punti
```

Questo significa che due brani creati in condizioni molto simili possono ottenere risultati leggermente differenti.

Schema concettuale:

```text
Qualità base
      +
Variazione casuale
      ↓
Quality Score finale
```

La casualità deve però rimanere contenuta.

L'obiettivo non è trasformare il sistema in una lotteria, ma introdurre una piccola componente di imprevedibilità.

Un artista molto competente deve continuare ad avere risultati mediamente superiori rispetto a uno con competenze basse.

---

# Clamp del Risultato

Il Quality Score finale viene limitato all'intervallo:

```text
1.0 → 100.0
```

Quindi:

```text
Quality < 1
→ 1.0
```

e:

```text
Quality > 100
→ 100.0
```

Questo impedisce che modificatori o variazioni casuali producano valori fuori dal range previsto.

---

# Esempio Concettuale

Supponiamo un artista con:

```text
Composizione       80
Scrittura Testi    70
Strumento          90
Produzione         60
```

Il sistema combina i valori attraverso i relativi pesi.

Successivamente viene applicata la variazione casuale controllata:

```text
Quality Base
+
Random ±4
=
Quality Finale
```

Infine:

```text
Clamp 1 → 100
```

Il valore ottenuto diventa il:

```text
QUALITY SCORE
```

del brano.

---

# Quality Score e Successo Commerciale

Il Quality Score non deve essere utilizzato come unico indicatore del successo di una canzone.

Il sistema deve mantenere separati concetti differenti:

```text
Qualità
≠
Popolarità
≠
Successo commerciale
≠
Successo dal vivo
```

Ad esempio:

```text
Brano A
Quality = 95
Streaming = medio
```

mentre:

```text
Brano B
Quality = 75
Streaming = molto alto
```

Questo permette di rappresentare una situazione realistica in cui un brano tecnicamente eccellente non diventa necessariamente un tormentone.

Allo stesso modo, un brano molto popolare non deve necessariamente avere il Quality Score più alto del gioco.

---

# Tratti Speciali delle Canzoni

Oltre al Quality Score numerico, ogni canzone può possedere uno dei cinque **Song Trait** speciali.

Enum:

```text
Enums.SongTrait
```

I cinque tratti attualmente definiti sono:

```text
EARWORM
CULT_CLASSIC
STAGE_BEAST
AUDIOPHILE_GEM
ROUGH_DIAMOND
```

I tratti introducono caratteristiche qualitative che non possono essere rappresentate solamente attraverso un numero da 1 a 100.

---

# 1. EARWORM — Tormentone

Il tratto:

```text
EARWORM
```

identifica una canzone particolarmente memorabile e facile da riascoltare.

Effetto implementato:

```text
+25% Streaming / Ascolti
```

durante i primi:

```text
30 giorni
```

dalla pubblicazione.

Schema:

```text
EARWORM
 ↓
Pubblicazione
 ↓
30 giorni
 ↓
+25% streaming/ascolti
```

Il bonus è quindi temporaneo.

Questo permette di creare brani con una forte capacità di impatto immediato senza trasformare il bonus in un vantaggio permanente.

---

# 2. CULT_CLASSIC — Pezzo Cult

Il tratto:

```text
CULT_CLASSIC
```

identifica un brano particolarmente apprezzato dal pubblico dal vivo.

Effetto:

```text
Fan convertiti ai concerti ×2.0
```

Il brano può quindi avere un'importanza superiore durante le performance rispetto a quanto suggerirebbe il semplice Quality Score.

Schema:

```text
CULT_CLASSIC
 ↓
Concerto
 ↓
Brano eseguito
 ↓
Conversione Fan ×2
```

Questo tratto crea una differenza importante tra:

```text
Successo in streaming
```

e:

```text
Successo dal vivo
```

---

# 3. STAGE_BEAST — Bomba dal Vivo

Il tratto:

```text
STAGE_BEAST
```

identifica un brano particolarmente efficace durante le esibizioni live.

Bonus:

```text
+15% Concert Score
```

ma solamente quando il brano viene utilizzato come:

```text
Brano di chiusura
```

della scaletta.

Schema:

```text
STAGE_BEAST
      ↓
Ultimo brano della scaletta?
      ↓
     SÌ
      ↓
Concert Score +15%
```

Questo introduce una componente strategica nella costruzione della scaletta.

Il giocatore non deve quindi limitarsi a scegliere le canzoni migliori, ma deve decidere **dove** inserirle.

---

# 4. AUDIOPHILE_GEM — Gemma per Audiofili

Il tratto:

```text
AUDIOPHILE_GEM
```

identifica una canzone particolarmente apprezzata dal punto di vista tecnico e sonoro.

Il tratto richiede:

```text
Produzione ≥ 70
```

e permette di ottenere:

```text
recensioni entusiaste
```

da parte della critica musicale specializzata.

Questo tratto enfatizza il rapporto tra:

```text
Produzione
+
Qualità sonora
+
Critica specializzata
```

e permette di differenziare il successo presso la critica dal successo presso il grande pubblico.

---

# 5. ROUGH_DIAMOND — Diamante Grezzo

Il tratto:

```text
ROUGH_DIAMOND
```

rappresenta una situazione particolare:

```text
Composizione eccellente
+
Registrazione low-fi
```

Il risultato è un brano con un grande potenziale musicale, ma con una resa tecnica volutamente o necessariamente grezza.

Schema:

```text
Ottima Composizione
        +
Produzione bassa
        ↓
ROUGH_DIAMOND
```

Questo tratto è particolarmente interessante perché dimostra che:

```text
Qualità dell'idea
≠
Qualità della registrazione
```

e può diventare la base per meccaniche future di:

* remaster;
* nuova registrazione;
* ristampa;
* rivalutazione critica;
* crescita postuma del brano;
* recupero di vecchie canzoni.

---

# Tratti e Identità del Brano

I Song Trait hanno una funzione differente rispetto al Quality Score.

Il Quality Score risponde principalmente alla domanda:

```text
"Quanto è ben realizzato questo brano?"
```

Il Trait risponde invece a:

```text
"Che tipo di brano è?"
```

Esempio:

```text
Quality Score = 82

Trait = EARWORM
```

oppure:

```text
Quality Score = 76

Trait = STAGE_BEAST
```

Due brani con Quality Score simili possono quindi avere comportamenti completamente differenti.

---

# Interazione con i Sistemi del Gioco

I tratti devono poter interagire con diversi sistemi.

Schema generale:

```text
SONG
 │
 ├── Quality Score
 │
 └── Song Trait
       │
       ├── Streaming
       ├── Concerti
       ├── Fan
       ├── Recensioni
       ├── Popolarità
       └── Eventi
```

Questo permette di evitare che i tratti siano semplicemente descrizioni testuali.

Devono produrre conseguenze reali.

---

# Tratti e Recensioni Musicali

Una futura espansione collegherà i Song Trait al sistema delle recensioni dei magazine musicali.

I diversi tipi di critica potrebbero reagire in maniera differente alle caratteristiche del brano.

Esempio concettuale:

```text
AUDIOPHILE_GEM
→ forte apprezzamento tecnico

ROUGH_DIAMOND
→ critica positiva sulla composizione
→ possibile critica sulla produzione

EARWORM
→ maggiore attenzione al potenziale radiofonico

STAGE_BEAST
→ forte apprezzamento della resa live

CULT_CLASSIC
→ forte risposta del pubblico
```

La recensione non dovrebbe quindi essere determinata esclusivamente dal Quality Score.

---

# Nuovi Tratti Futuri

Il sistema potrà essere ampliato con ulteriori caratteristiche.

Possibili esempi:

### Ballata Strappalacrime

Brano particolarmente efficace nel generare una risposta emotiva.

Possibili effetti:

```text
Morale pubblico ↑
Engagement ↑
Performance emotiva ↑
```

---

### Inno da Stadio

Brano progettato per essere cantato da migliaia di persone.

Possibili effetti:

```text
Concert Engagement ↑
Fan Interaction ↑
```

Potrebbe essere particolarmente efficace nei grandi stadi.

---

### Riff Epico

Brano caratterizzato da un riff particolarmente memorabile.

Possibili effetti:

```text
Live Performance ↑
Memorabilità ↑
```

---

### Pezzo Troppo Complesso per la Radio

Brano tecnicamente o strutturalmente molto complesso.

Possibili caratteristiche:

```text
Quality elevata
+
Appeal commerciale ridotto
```

Questo permetterebbe di rafforzare ulteriormente il principio:

```text
QUALITY ≠ COMMERCIAL SUCCESS
```

---

# Filosofia dei Song Trait

I tratti devono servire a creare identità e varietà.

Un brano non dovrebbe essere solamente:

```text
Quality = 84
```

ma qualcosa come:

```text
Quality = 84
Trait = STAGE_BEAST
```

In questo modo il giocatore può ricordare le proprie canzoni non solo per il punteggio, ma per il ruolo che hanno avuto nella carriera.

Esempio:

```text
"Questo non era il mio brano più ascoltato,
ma durante i concerti faceva impazzire il pubblico."
```

oppure:

```text
"Quella canzone era partita con una registrazione pessima,
ma la composizione era talmente buona che l'abbiamo
poi rifatta in studio."
```

Questo rende la discografia parte della storia emergente del giocatore.

---

# Principi di Design

Il sistema Quality Score e Song Trait deve rispettare i seguenti principi:

1. **Il Quality Score deve essere deterministico nella struttura, con una casualità controllata.**

2. **La casualità non deve annullare l'importanza delle abilità.**

3. **Il risultato deve essere sempre compreso tra 1 e 100.**

4. **I pesi devono essere centralizzati nelle configurazioni.**

5. **Quality Score e successo commerciale devono rimanere concetti distinti.**

6. **I Song Trait devono produrre effetti reali sul gameplay.**

7. **Ogni Trait deve avere una funzione riconoscibile.**

8. **I Trait devono creare differenze tra brani con Quality Score simili.**

9. **I Trait devono poter interagire con concerti, streaming, fan e recensioni.**

10. **Il sistema deve essere facilmente espandibile con nuovi Trait.**

11. **La critica musicale deve poter valutare aspetti differenti della stessa canzone.**

12. **Una canzone può diventare importante per motivi differenti dalla semplice qualità tecnica.**

---

# Spazio per i Dettagli di Luca

### Decisioni confermate

* [x] Quality Score calcolato tramite `calculate_song_quality()`.
* [x] Formula centralizzata in `core/formulas.gd`.
* [x] Composizione: peso 25%.
* [x] Scrittura Testi: peso 20%.
* [x] Esecuzione Strumentale: peso 25%.
* [x] Produzione: peso 20%.
* [x] Variazione casuale controllata: ±4.0 punti.
* [x] Quality Score finale clampato tra 1.0 e 100.0.
* [x] Cinque Song Trait principali.
* [x] `EARWORM`.
* [x] `CULT_CLASSIC`.
* [x] `STAGE_BEAST`.
* [x] `AUDIOPHILE_GEM`.
* [x] `ROUGH_DIAMOND`.
* [x] EARWORM: +25% streaming/ascolti per i primi 30 giorni.
* [x] CULT_CLASSIC: moltiplicatore ×2.0 dei fan convertiti ai concerti.
* [x] STAGE_BEAST: +15% Concert Score come brano di chiusura.
* [x] AUDIOPHILE_GEM: richiede Produzione ≥70.
* [x] ROUGH_DIAMOND: ottima composizione con resa low-fi.
* [x] Possibilità di aggiungere nuovi tratti.
* [x] Possibile interazione futura tra tratti e recensioni musicali.

### Idee future

* [ ] Definire il metodo esatto con cui vengono assegnati i Song Trait.
* [ ] Stabilire se un brano può possedere più Trait contemporaneamente.
* [ ] Definire eventuali incompatibilità tra Trait.
* [ ] Definire la probabilità di ottenere ciascun Trait.
* [ ] Collegare i Trait alle condizioni di creazione del brano.
* [ ] Implementare nuove categorie di Trait.
* [ ] Creare il sistema di recensioni dei magazine musicali.
* [ ] Differenziare critica specializzata e pubblico generale.
* [ ] Collegare i Trait agli algoritmi di streaming.
* [ ] Collegare i Trait al sistema Fan.
* [ ] Collegare i Trait alla costruzione della scaletta.
* [ ] Aggiungere eventuali effetti legati al genere musicale.
* [ ] Creare eventi narrativi legati a canzoni particolarmente importanti.
* [ ] Valutare sistemi di remaster/re-release per `ROUGH_DIAMOND`.
* [ ] Test automatici per `calculate_song_quality()`.
* [ ] Test dei limiti 1.0 e 100.0.
* [ ] Test della variazione casuale ±4.0.
* [ ] Test degli effetti dei cinque Song Trait.
* [ ] Test della durata temporale del bonus `EARWORM`.
* [ ] Test del moltiplicatore `CULT_CLASSIC`.
* [ ] Test del bonus `STAGE_BEAST` esclusivamente in chiusura.
* [ ] Test del requisito Produzione ≥70 per `AUDIOPHILE_GEM`.

  --------------------------------------------------------------------------------------------------------------------------

### 2.3 Studio di Registrazione: Casalingo vs Professionale & Hardware
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Se si registra a casa (`use_pro_studio == false`): Il tetto massimo esecutivo di default era bloccato a 60, ma con l'integrazione di `UpgradeData.StudioHardwareTier` viene progressivamente innalzato:
    - Microfono base: Cap 60, Bonus 0.
    - Microfono a condensatore USB (400 €): Cap 75, Studio Bonus +5.
    - Preamplificatore valvolare (1.200 €): Cap 90, Studio Bonus +10.
    - Banco analogico & Mastering Suite (3.500 €): Cap rimosso a 100, Studio Bonus +15.
  - Se si affitta uno Studio Professionale: Costo variabile in denaro, ma garantisce resa esecutiva al 100% e bonus produzione.
  - Sconto del 20% per la prenotazione studio al Martedì (`Constants.TUESDAY_STUDIO_DISCOUNT`).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Diversi studi di registrazione commerciali con nomi e tariffe distinte (es. Studio Underground economico di periferia, Studio Storico analogico, Abbey Road style super-studio con tariffe a 4 zeri).
  - Ingegneri del suono con personalità e stili di missaggio unici.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
    ### 2.3 Studio di Registrazione: Casalingo vs Professionale & Hardware

#### Stato Attuale e Fondamenta Tecniche

Il sistema di registrazione determina le condizioni tecniche con cui un brano viene prodotto.

Il giocatore può scegliere tra due modalità principali:

```text
STUDIO CASALINGO
STUDIO PROFESSIONALE
```

La differenza fondamentale è che il giocatore **non possiede automaticamente uno studio domestico completo all'inizio del gioco**.

Lo studio casalingo deve essere costruito progressivamente attraverso l'acquisto di hardware.

Schema:

```text
Inizio carriera
 ↓
Nessuno studio domestico completo
 ↓
Acquisto primo hardware
 ↓
Studio casalingo base
 ↓
Acquisto upgrade
 ↓
Miglioramento delle capacità di registrazione
```

Il sistema hardware è integrato con:

```text
UpgradeData.StudioHardwareTier
```

---

# Studio Casalingo

Lo studio casalingo rappresenta la possibilità di registrare musica utilizzando attrezzatura acquistata direttamente dal giocatore.

Non deve essere considerato un edificio già presente nella casa.

Il giocatore deve infatti investire progressivamente denaro per trasformare il proprio spazio abitativo in uno studio musicale.

La progressione è:

```text
Casa
 ↓
Acquisto hardware
 ↓
Studio casalingo
 ↓
Upgrade hardware
 ↓
Studio sempre più avanzato
```

Questo crea una progressione economica naturale.

---

# Nessuno Studio all'Inizio

All'inizio della carriera il giocatore non deve possedere automaticamente un setup di registrazione completo.

La situazione iniziale può essere rappresentata come:

```text
Casa
+
Nessuna attrezzatura professionale
```

Il giocatore può quindi:

* scrivere musica;
* esercitarsi;
* sviluppare le proprie abilità;
* svolgere attività quotidiane;

ma per ottenere una registrazione di qualità deve prima investire nell'attrezzatura.

Questo rende il primo acquisto hardware un vero momento di progressione.

---

# Primo Hardware

Il primo livello disponibile è:

```text
Microfono Base
```

Caratteristiche:

```text
Cap esecutivo: 60
Studio Bonus: +0
```

Questo rappresenta il setup domestico più semplice.

Il giocatore può quindi iniziare a registrare senza dover necessariamente pagare uno studio professionale, ma la qualità tecnica rimane limitata.

Schema:

```text
Microfono Base
 ↓
Registrazione domestica
 ↓
Cap 60
```

Il limite impedisce che un artista appena iniziato possa ottenere immediatamente registrazioni di livello professionale.

---

# Upgrade Hardware

Lo studio casalingo può essere migliorato acquistando componenti hardware progressivamente più avanzati.

Ogni upgrade aumenta il livello tecnico raggiungibile.

La progressione attuale è:

| Hardware                          |    Costo | Cap esecutivo | Studio Bonus |
| --------------------------------- | -------: | ------------: | -----------: |
| Microfono Base                    | iniziale |            60 |           +0 |
| Microfono a Condensatore USB      |    400 € |            75 |           +5 |
| Preamplificatore Valvolare        |  1.200 € |            90 |          +10 |
| Banco Analogico & Mastering Suite |  3.500 € |           100 |          +15 |

---

# 1. Microfono Base

Il Microfono Base rappresenta il primo livello dell'attrezzatura domestica.

```text
Cap: 60
Bonus: +0
```

È sufficiente per:

* prime demo;
* prove di registrazione;
* primi brani;
* produzioni amatoriali.

Non permette però di raggiungere una resa tecnica elevata.

---

# 2. Microfono a Condensatore USB

Costo:

```text
400 €
```

Caratteristiche:

```text
Cap: 75
Studio Bonus: +5
```

Rappresenta il primo vero investimento nella qualità della registrazione.

Il giocatore passa quindi da:

```text
Setup base
```

a:

```text
Home Studio migliorato
```

Il miglioramento deve essere percepibile anche economicamente: il giocatore deve decidere se spendere 400 € nell'attrezzatura oppure conservare il denaro per altre necessità.

---

# 3. Preamplificatore Valvolare

Costo:

```text
1.200 €
```

Caratteristiche:

```text
Cap: 90
Studio Bonus: +10
```

Questo livello rappresenta un investimento importante.

Il giocatore può raggiungere una qualità molto elevata senza essere ancora costretto ad affittare uno studio professionale.

Schema:

```text
Investimento elevato
 ↓
Qualità elevata
 ↓
Minore dipendenza dallo Studio Professionale
```

---

# 4. Banco Analogico & Mastering Suite

Costo:

```text
3.500 €
```

Caratteristiche:

```text
Cap: 100
Studio Bonus: +15
```

Questo rappresenta il massimo livello dell'attuale progressione dello studio casalingo.

Il limite tecnico viene rimosso:

```text
Cap esecutivo:
100
```

Il giocatore può quindi arrivare al massimo teorico della registrazione domestica.

La differenza rispetto allo studio professionale non deve necessariamente essere solamente numerica: lo studio professionale può offrire servizi, ingegneri, hardware specializzato e condizioni che il giocatore non può replicare completamente a casa.

---

# Progressione dello Studio Casalingo

La progressione complessiva diventa:

```text
NESSUNO STUDIO
      ↓
Microfono Base
      ↓
Microfono USB
      ↓
Preamplificatore Valvolare
      ↓
Banco Analogico & Mastering Suite
```

Questa struttura crea una vera progressione economica.

Il giocatore parte senza una struttura completa e costruisce gradualmente il proprio studio.

---

# Studio Bonus

Ogni livello hardware può fornire un:

```text
Studio Bonus
```

che viene utilizzato nei calcoli relativi alla produzione e alla registrazione.

Progressione:

```text
Microfono Base
→ +0

Microfono USB
→ +5

Preamplificatore Valvolare
→ +10

Banco Analogico & Mastering Suite
→ +15
```

Il bonus rappresenta il vantaggio tecnico ottenuto grazie alla qualità dell'attrezzatura.

Questo valore deve essere integrato con:

```text
Produzione
+
Hardware
+
Condizioni di registrazione
```

per determinare il risultato finale.

---

# Cap Esecutivo

Il sistema hardware stabilisce anche un limite massimo alla resa ottenibile durante una registrazione domestica.

Schema:

```text
Hardware
 ↓
Cap Esecutivo
 ↓
Limite massimo della resa
```

Progressione:

```text
Microfono Base
→ 60

Microfono USB
→ 75

Preamplificatore Valvolare
→ 90

Banco Analogico
→ 100
```

Questo impedisce che un giocatore con Produzione molto elevata possa ignorare completamente la qualità dell'attrezzatura.

Esempio:

```text
Produzione = 95
Hardware = Microfono Base
```

La competenza del personaggio è elevata, ma l'attrezzatura rappresenta comunque un limite concreto.

---

# Studio Professionale

In alternativa allo studio casalingo, il giocatore può affittare uno:

```text
STUDIO PROFESSIONALE
```

Lo studio professionale non richiede l'acquisto dell'attrezzatura domestica.

Il giocatore paga una tariffa per la sessione di registrazione.

Vantaggi:

```text
Resa esecutiva garantita al 100%
+
Bonus Produzione
+
Attrezzatura professionale
```

Questo crea una scelta economica:

```text
Investire nello Studio Casalingo
```

oppure:

```text
Pagare uno Studio Professionale quando serve
```

---

# Confronto tra le Due Soluzioni

| Caratteristica        | Studio Casalingo         | Studio Professionale       |
| --------------------- | ------------------------ | -------------------------- |
| Investimento iniziale | Progressivo              | Nessuno                    |
| Costo per utilizzo    | Ridotto                  | Tariffa per sessione       |
| Hardware              | Acquistato dal giocatore | Fornito dallo studio       |
| Qualità               | Dipende dagli upgrade    | Professionale              |
| Cap                   | Da 60 a 100              | 100                        |
| Bonus Produzione      | Dipende dall'hardware    | Garantito                  |
| Disponibilità         | Sempre disponibile       | Dipende dalla prenotazione |
| Progressione          | Migliorabile             | Immediata                  |

Questo crea due strategie economiche differenti.

---

# Scelta Economica

Il giocatore deve poter decidere:

```text
"Compro l'attrezzatura?"
```

oppure:

```text
"Pago uno studio ogni volta che devo registrare?"
```

Esempio:

```text
Artista emergente
 ↓
Pochi soldi
 ↓
Microfono Base
 ↓
Prime registrazioni
```

Successivamente:

```text
Più concerti
 ↓
Più denaro
 ↓
Microfono USB
 ↓
Preamplificatore
 ↓
Studio domestico avanzato
```

Oppure:

```text
Brano molto importante
 ↓
Budget disponibile
 ↓
Studio Professionale
 ↓
Registrazione di qualità elevata
```

La scelta deve quindi dipendere dal momento della carriera.

---

# Sconto del Martedì

La prenotazione di uno Studio Professionale beneficia di uno sconto specifico.

Parametro:

```text
Constants.TUESDAY_STUDIO_DISCOUNT
```

Quando la sessione viene prenotata di martedì:

```text
Costo Studio
 ↓
-20%
```

Questo introduce una piccola componente strategica nella gestione del calendario.

Esempio:

```text
Sessione normale
→ 1.000 €

Sessione martedì
→ 800 €
```

Il giocatore può quindi pianificare le registrazioni anche in funzione del costo.

---

# Studi Professionali Differenti

Una futura espansione introdurrà diversi studi commerciali.

Ogni studio potrà avere:

```text
Nome
Costo
Qualità
Bonus Produzione
Specializzazione
Disponibilità
Ingegnere
Caratteristiche particolari
```

Possibili categorie:

### Studio Underground

```text
Costo basso
Qualità buona
Ambiente underground
```

Pensato per artisti emergenti.

### Studio Storico Analogico

```text
Costo medio/alto
Attrezzatura analogica
Caratteristiche sonore particolari
```

Potrebbe essere particolarmente interessante per determinati generi.

### Super-Studio

```text
Costo molto elevato
Qualità massima
Attrezzatura eccezionale
```

Potrebbe rappresentare gli studi di fascia più prestigiosa.

---

# Ingegneri del Suono

Una futura espansione introdurrà anche gli:

```text
INGEGNERI DEL SUONO
```

Gli ingegneri non devono essere semplicemente un bonus numerico.

Ogni professionista potrebbe avere:

```text
Stile di missaggio
Specializzazione
Costo
Esperienza
Personalità
Generi preferiti
Bonus specifici
```

Esempio:

```text
Engineer A
→ Rock
→ suono aggressivo
→ bonus chitarre

Engineer B
→ Pop
→ mix molto pulito
→ bonus vocali

Engineer C
→ Metal
→ grande attenzione a batteria e chitarre
```

Questo permette al giocatore di scegliere non solo **dove** registrare, ma anche **con chi** lavorare.

---

# Studio come Investimento

Il sistema deve creare una progressione parallela:

```text
ABILITÀ
        +
HARDWARE
        +
DENARO
        ↓
QUALITÀ DELLA MUSICA
```

Un artista può quindi migliorare attraverso:

```text
Allenamento
```

ma anche attraverso:

```text
Investimento nell'attrezzatura
```

Questo rafforza il collegamento tra:

```text
Produzione
+
Economia
+
Studio
+
Qualità dei brani
```

---

# Principi di Design

Il sistema Studio deve rispettare i seguenti principi:

1. **Il giocatore non deve iniziare con uno studio domestico completo.**

2. **L'hardware deve essere acquistato progressivamente.**

3. **Ogni upgrade deve avere un costo e un beneficio concreto.**

4. **L'hardware deve influenzare il limite tecnico della registrazione.**

5. **La Produzione del personaggio non deve rendere inutile l'attrezzatura.**

6. **Lo Studio Professionale deve rappresentare un'alternativa all'investimento domestico.**

7. **Lo Studio Casalingo deve essere economicamente conveniente nel lungo periodo.**

8. **Lo Studio Professionale deve offrire qualità immediata pagando per la sessione.**

9. **Il martedì deve incentivare la pianificazione economica delle sessioni.**

10. **Gli studi futuri devono poter avere caratteristiche differenti.**

11. **Gli ingegneri del suono devono poter introdurre ulteriori scelte strategiche.**

12. **Il sistema deve collegarsi direttamente a Produzione, Economia e Quality Score.**

---

# Spazio per i Dettagli di Luca

### Decisioni confermate

* [x] Il giocatore **non parte con uno studio domestico completo**.
* [x] Lo studio casalingo viene costruito acquistando hardware.
* [x] Sistema hardware integrato con `UpgradeData.StudioHardwareTier`.
* [x] Microfono Base: Cap 60, Bonus 0.
* [x] Microfono a Condensatore USB: 400 €, Cap 75, Bonus +5.
* [x] Preamplificatore Valvolare: 1.200 €, Cap 90, Bonus +10.
* [x] Banco Analogico & Mastering Suite: 3.500 €, Cap 100, Bonus +15.
* [x] Lo Studio Professionale viene affittato pagando una tariffa.
* [x] Lo Studio Professionale garantisce resa esecutiva al 100%.
* [x] Lo Studio Professionale fornisce un bonus Produzione.
* [x] Prenotazione di martedì: sconto del 20%.
* [x] Il giocatore può scegliere tra investimento domestico e affitto di uno studio professionale.

### Idee future

* [ ] Definire il costo del Microfono Base.
* [ ] Definire se il Microfono Base viene acquistato automaticamente oppure deve essere acquistato esplicitamente.
* [ ] Definire l'interfaccia di acquisto dell'hardware.
* [ ] Definire se gli hardware sono permanenti.
* [ ] Definire eventuali costi di manutenzione.
* [ ] Aggiungere altri componenti hardware.
* [ ] Creare diversi studi professionali commerciali.
* [ ] Definire tariffe e caratteristiche di ogni studio.
* [ ] Creare studi specializzati per genere musicale.
* [ ] Creare ingegneri del suono con personalità e stili differenti.
* [ ] Collegare gli ingegneri ai generi musicali.
* [ ] Definire bonus e malus dei diversi ingegneri.
* [ ] Aggiungere prenotazioni e disponibilità degli studi.
* [ ] Integrare eventuali eventi legati alle sessioni di registrazione.
* [ ] Collegare hardware e studi ai Song Trait.
* [ ] Collegare la qualità dello studio al sistema `calculate_song_quality()`.
* [ ] Test automatici per tutti i livelli hardware.
* [ ] Test dei Cap 60, 75, 90 e 100.
* [ ] Test del bonus Produzione di ogni hardware.
* [ ] Test dello sconto del 20% del martedì.
* [ ] Test della differenza tra Studio Casalingo e Studio Professionale.

-----------------------------------------------------------------------------------------------------------------------------
### 2.4 Formati di Rilascio: Singoli, EP ed Album LP
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo album: `systems/album_system.gd` e modale `AlbumCreator` (`ui/album/album_creator.tscn`), tasto rapido HUD `P`.
  - Singolo: Rilascio di 1 brano standalone per fare da trampolino iniziale.
  - EP (Extended Play): Da 3 a 5 brani (`ALBUM_EP_MIN_TRACKS` = 3, `ALBUM_EP_MAX_TRACKS` = 5). Costo di stampa e distribuzione base: 80.0 €.
  - LP (Long Play / Album Completo): Da 6 a 10 brani (`ALBUM_LP_MIN_TRACKS` = 6, `ALBUM_LP_MAX_TRACKS` = 10). Costo di produzione base: 200.0 €.
  - 3 Concept Artistici (`Enums.AlbumConcept`):
    1. CONCEPTUAL: Album tematico concettuale (+Recensioni della critica).
    2. COMMERCIAL_HIT: Orientato alle hit radiofoniche (+Vendite e stream immediati).
    3. RAW_UNDERGROUND: Registrazione grezza e verace (+Fedeltà dei fan live).
  - 4 Stili di Copertina / Artwork (`Enums.ArtworkStyle`): Minimalista, Retro Psichedelico, Dark Metal, Street Graffiti.
  - Selezione del singolo di traino (Lead Single).
  - Recensioni della critica simulate da 1.0 a 5.0 stelle, vendite Day 1 e riverbero sulla reputazione.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Uscita di singoli promozionali distanziati nel tempo prima dell'uscita del disco.
  - Ristampe deluxe con tracce demo e versioni acustiche.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
 ## 2.4 Formati di Rilascio: Singoli, EP ed Album LP

Il sistema di rilascio discografico rappresenta il passaggio dalla semplice creazione delle canzoni alla loro **pubblicazione ufficiale sul mercato**.

Il giocatore può decidere se pubblicare un singolo, realizzare un EP oppure investire nella produzione di un album LP completo. La scelta del formato non è solamente estetica: influenza il numero di brani coinvolti, i costi di produzione e distribuzione e, progressivamente, il modo in cui il progetto musicale viene percepito dal pubblico e dalla critica.

Il sistema è gestito da:

* `systems/album_system.gd`
* `ui/album/album_creator.tscn`
* Tasto rapido HUD: **`P`**

---

### 2.4.1 Formati di rilascio

Sono previsti tre principali formati discografici:

| Formato        | Numero brani | Costo base | Funzione principale                  |
| -------------- | -----------: | ---------: | ------------------------------------ |
| **Singolo**    |            1 |          — | Pubblicazione rapida di un brano     |
| **EP**         |          3–5 |       80 € | Primo progetto discografico compatto |
| **LP / Album** |         6–10 |      200 € | Progetto musicale completo           |

#### Singolo

Il **Singolo** rappresenta il formato più semplice e accessibile.

Il giocatore seleziona un brano già completato e lo pubblica come release indipendente. È particolarmente adatto alle prime fasi della carriera, quando l'artista non dispone ancora delle risorse economiche o del repertorio necessario per realizzare un progetto più grande.

Il singolo può essere utilizzato per:

* iniziare a costruire una fanbase;
* generare i primi stream e ricavi;
* aumentare la reputazione dell'artista;
* testare la risposta del pubblico a un determinato stile musicale;
* preparare il terreno per un futuro EP o LP.

Il singolo può inoltre diventare il **Lead Single** di un progetto discografico successivo.

---

### 2.4.2 EP – Extended Play

L'**EP** richiede da **3 a 5 brani**.

Costanti:

* `ALBUM_EP_MIN_TRACKS = 3`
* `ALBUM_EP_MAX_TRACKS = 5`
* costo base di stampa/distribuzione: **80,0 €**

L'EP rappresenta una soluzione intermedia tra il singolo e l'album completo.

È particolarmente adatto quando il giocatore possiede già diversi brani validi ma non vuole ancora sostenere l'investimento necessario per un LP.

La realizzazione dell'EP richiede quindi una selezione del repertorio disponibile e permette di iniziare a costruire una vera e propria **identità discografica**.

---

### 2.4.3 LP – Long Play / Album completo

L'**LP** rappresenta il formato discografico più completo.

Richiede:

* minimo **6 brani**;
* massimo **10 brani**;
* costo base di produzione: **200,0 €**.

Costanti:

* `ALBUM_LP_MIN_TRACKS = 6`
* `ALBUM_LP_MAX_TRACKS = 10`

A differenza del singolo, un LP permette di presentare al pubblico un vero progetto musicale, nel quale la scelta e l'ordine dei brani possono contribuire alla percezione complessiva dell'opera.

Il giocatore deve quindi disporre di un repertorio sufficientemente ampio prima di poter pubblicare il progetto.

---

## 2.4.4 Concept artistico dell'album

Durante la creazione di un EP o LP il giocatore può scegliere un **Concept Artistico**, rappresentato da `Enums.AlbumConcept`.

Sono disponibili tre approcci:

### 1. CONCEPTUAL — Album concettuale

Il progetto segue una direzione tematica precisa.

**Effetto principale:**

* maggiore attenzione da parte della critica;
* possibilità di ottenere recensioni più favorevoli.

Questo formato privilegia la **coerenza artistica** rispetto alla ricerca immediata della massima popolarità.

### 2. COMMERCIAL_HIT — Commerciale

L'album viene costruito con un'impostazione orientata alla produzione di hit e brani facilmente fruibili dal grande pubblico.

**Effetto principale:**

* maggiore potenziale per vendite immediate;
* maggiore potenziale per gli stream iniziali.

Questo approccio privilegia il **successo commerciale immediato**.

### 3. RAW_UNDERGROUND — Raw / Underground

Il progetto mantiene un'impostazione più grezza, autentica e meno orientata alle logiche commerciali.

**Effetto principale:**

* maggiore fedeltà dei fan legati alle esibizioni live;
* valorizzazione dell'identità underground dell'artista.

Questo concept permette quindi di sviluppare una reputazione più legata alla **credibilità e all'autenticità**.

---

## 2.4.5 Artwork e copertina

Ogni progetto discografico dispone inoltre di un artwork.

Sono attualmente disponibili quattro stili di copertina tramite `Enums.ArtworkStyle`:

1. **Minimalista**
2. **Retro Psichedelico**
3. **Dark Metal**
4. **Street Graffiti**

L'artwork contribuisce alla personalizzazione dell'identità visiva del progetto.

Al momento gli stili rappresentano principalmente una scelta estetica; eventuali effetti gameplay associati ai diversi artwork potranno essere definiti successivamente.

---

## 2.4.6 Lead Single

Per EP e LP è possibile selezionare un **Lead Single**, cioè il brano utilizzato come principale singolo di lancio del progetto.

La scelta è importante perché il Lead Single rappresenta il primo punto di contatto tra il nuovo progetto discografico e il pubblico.

Il giocatore deve quindi valutare quale brano utilizzare come rappresentante dell'intero progetto.

Una canzone con caratteristiche fortemente commerciali potrebbe avere un comportamento differente rispetto a un brano particolarmente apprezzato dalla critica o dalla fanbase.

Il sistema permette così di introdurre una distinzione tra:

> **"Qual è il brano migliore dell'album?"**

e

> **"Qual è il brano migliore per presentare l'album al pubblico?"**

---

## 2.4.7 Recensione critica e risultati del Day 1

Dopo la pubblicazione viene simulata la risposta iniziale al progetto.

La recensione della critica viene rappresentata attraverso un valore compreso tra:

**1,0 ★ → 5,0 ★**

Parallelamente vengono calcolati i risultati iniziali del rilascio, tra cui:

* vendite del Day 1;
* stream iniziali;
* impatto sulla reputazione;
* risposta del pubblico.

La recensione e il successo commerciale non devono necessariamente coincidere.

Un progetto può quindi ricevere una buona valutazione critica senza trasformarsi automaticamente in un enorme successo commerciale.

Questo mantiene coerente il principio generale del sistema musicale:

> **Qualità artistica ≠ successo commerciale.**

---

## 2.4.8 Relazione con il resto del sistema musicale

Il sistema di rilascio non è isolato, ma rappresenta un punto di collegamento tra diversi sistemi già presenti nel gioco.

Il percorso generale è:

**Creazione brano → Registrazione → Quality Score → Selezione repertorio → Formato di rilascio → Pubblicazione → Risposta pubblico/critica → Reputazione → Fan/Stream/Vendite → Carriera**

La qualità dei singoli brani costituisce quindi una parte importante del risultato finale, ma non determina automaticamente il successo del progetto.

Anche la scelta del formato, del concept e del Lead Single contribuisce alla strategia del giocatore.

---

# Direttrici di espansione future

### Singoli promozionali pre-release

Possibilità di pubblicare uno o più singoli nelle settimane/giorni precedenti all'uscita dell'EP o LP.

Esempio:

**Singolo #1 → Singolo #2 → Pre-release → Album → Tour promozionale**

Questo permetterebbe di creare una vera e propria fase di promozione del disco.

### Deluxe Edition

Possibilità di pubblicare successivamente una versione **Deluxe** contenente materiale aggiuntivo, ad esempio:

* tracce bonus;
* demo;
* versioni acustiche;
* remix;
* versioni live;
* brani precedentemente esclusi dall'album.

La Deluxe Edition potrebbe generare una seconda ondata di stream, vendite e attenzione mediatica.

### Ciclo promozionale dell'album

In una futura espansione il rilascio potrebbe diventare un vero e proprio ciclo:

**Annuncio → Lead Single → Promozione → Pre-release → Album → Recensioni → Classifiche → Concerti/Tour → Deluxe Edition**

Questo trasformerebbe la pubblicazione di un album da una semplice operazione economica a un vero **evento della carriera dell'artista**.

---

## Decisioni confermate

* Sono disponibili tre formati: **Singolo, EP e LP**.
* L'EP contiene **3–5 brani**.
* L'LP contiene **6–10 brani**.
* L'EP ha un costo base di **80 €**.
* L'LP ha un costo base di **200 €**.
* Sono disponibili **3 Concept Artistici**.
* Sono disponibili **4 stili di Artwork**.
* EP e LP possono avere un **Lead Single**.
* La critica utilizza una valutazione da **1,0 a 5,0 stelle**.
* Il rilascio produce risultati iniziali come **Day 1, stream, vendite e impatto sulla reputazione**.
* Qualità artistica e successo commerciale rimangono sistemi distinti.
* Sono previste future meccaniche di **promozione pre-release** e **Deluxe Edition**.

  - ------------------------------------------------------------------------------------------------------------------------

### 2.5 Catalogo Musicale, Vendite Day 1 & Royalties Passive
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Schermata di visualizzazione catalogo: `ui/catalog/song_catalog.tscn` e `.gd`, tasto rapido HUD `M`.
  - Tasti dedicati interni: `A` per filtrare Album ed EP, `S` per filtrare Singoli e Brani.
  - Vocalizzazione tracklist completa per NVDA.
  - Incasso automatico royalties a mezzanotte (`EndDaySystem`):
    - Tasso base per singolo, moltiplicatore EP 35% (`ALBUM_EP_ROYALTY_RATE`), moltiplicatore LP 60% (`ALBUM_LP_ROYALTY_RATE`).
    - Decadimento fisiologico nel tempo compensato dalla crescita della popolarità complessiva.
    - Se presente una band attiva, ripartizione automatica delle royalties secondo il `RevenueSplit` concordato.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Flussi di cassa separati tra vendite fisiche (CD, Vinili, Cassette) e streaming digitale (Spotify style).
  - Contratti di licenza per brani usati come colonna sonora in film, videogiochi o spot pubblicitari.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
  - ## 2.5 Catalogo Musicale, Vendite Day 1 & Royalties Passive

Il **Catalogo Musicale** rappresenta l'archivio permanente delle produzioni pubblicate dall'artista e costituisce, allo stesso tempo, una delle principali fonti di reddito passivo nel corso della carriera.

Una volta pubblicato, un brano non termina la propria funzione nel momento del rilascio: continua a generare ascolti, vendite e royalties nel tempo.

Il sistema è gestito attraverso:

* `ui/catalog/song_catalog.tscn`
* script associato al catalogo;
* tasto rapido HUD **`M`**;
* `EndDaySystem` per la gestione degli incassi periodici.

---

### 2.5.1 Schermata Catalogo Musicale

La schermata del catalogo permette al giocatore di consultare le proprie pubblicazioni e distinguere rapidamente le diverse tipologie di release.

Sono presenti due filtri principali:

* **`A`** → Album ed EP;
* **`S`** → Singoli e brani.

Il catalogo deve permettere di visualizzare le informazioni fondamentali delle produzioni pubblicate, mantenendo una struttura leggibile anche tramite screen reader.

Per questo motivo la **tracklist completa viene vocalizzata da NVDA**, consentendo al giocatore di conoscere:

* nome del progetto;
* brani contenuti;
* tipologia di release;
* informazioni principali associate alla pubblicazione.

Il catalogo rappresenta quindi sia una schermata informativa sia la memoria storica della carriera musicale del personaggio.

---

## 2.5.2 Vendite Day 1

Ogni nuova pubblicazione produce un risultato economico iniziale durante il **Day 1**.

Il numero di vendite e/o ascolti iniziali rappresenta la risposta immediata del mercato al nuovo progetto.

Il risultato può essere influenzato dai sistemi già presenti nel gioco, tra cui:

* qualità dei brani;
* popolarità dell'artista;
* fanbase;
* reputazione;
* caratteristiche del progetto;
* eventuale Lead Single;
* concept dell'album.

Il Day 1 rappresenta quindi il **picco iniziale di attenzione** generato da una nuova pubblicazione.

Non deve però essere interpretato come l'unico indicatore del successo di un brano o di un album: un progetto con un Day 1 modesto può continuare a generare royalties nel tempo grazie alla propria longevità.

---

## 2.5.3 Royalties passive

Una volta pubblicata una produzione, il catalogo può generare **royalties passive**.

Gli incassi vengono elaborati automaticamente dall'`EndDaySystem` durante il ciclo di fine giornata.

Il flusso è:

**Brano pubblicato → ascolti/vendite → royalties maturate → fine giornata → calcolo incasso → accredito al giocatore**

Il giocatore non deve quindi riscuotere manualmente ogni singolo guadagno.

Questo introduce una componente importante della progressione economica:

> **Il lavoro svolto oggi può continuare a produrre reddito nei giorni successivi.**

---

## 2.5.4 Tasso di royalty e formato della pubblicazione

Il sistema utilizza un **tasso base per i singoli** e specifici moltiplicatori per EP e LP.

Costanti attualmente definite:

* `ALBUM_EP_ROYALTY_RATE = 35%`
* `ALBUM_LP_ROYALTY_RATE = 60%`

Gli EP e gli LP utilizzano quindi un coefficiente specifico rispetto al tasso di riferimento del singolo.

Il calcolo effettivo delle royalties viene eseguito dal sistema economico e confluisce nell'incasso di fine giornata.

È importante distinguere tra:

**royalty rate** → quanto del valore generato viene riconosciuto all'artista;

**royalty income** → quanto denaro viene effettivamente incassato.

L'importo finale dipende quindi anche dalla quantità di attività generata dal catalogo.

---

## 2.5.5 Decadimento nel tempo

Le pubblicazioni non mantengono necessariamente lo stesso livello di ascolti e vendite per tutta la loro vita.

Il sistema implementa un **decadimento fisiologico nel tempo**.

In termini concettuali:

**Nuova uscita → forte attenzione iniziale → decadimento → catalogo stabile → possibile riscoperta**

Il decadimento impedisce che un singolo brano pubblicato all'inizio della carriera continui indefinitamente a generare lo stesso reddito.

Contemporaneamente, la **crescita della popolarità complessiva dell'artista** può compensare in parte questo decadimento.

Questo crea un'interazione interessante tra vecchio e nuovo catalogo:

> più l'artista diventa famoso, maggiore può diventare il valore economico del proprio catalogo storico.

Un vecchio brano può quindi tornare ad avere rilevanza quando l'artista raggiunge un nuovo livello di popolarità.

---

## 2.5.6 Royalties e Band

Quando il giocatore fa parte di una **band attiva**, le royalties non vengono necessariamente incassate interamente dal personaggio.

Il sistema utilizza il **`RevenueSplit`** concordato tra i membri.

Il flusso diventa:

**Royalties generate → calcolo RevenueSplit → suddivisione tra membri → accredito individuale**

Questo rende la gestione della band economicamente significativa.

La creazione di una band può infatti aumentare la capacità produttiva e musicale dell'artista, ma comporta anche la necessità di **dividere determinati ricavi** secondo gli accordi stabiliti.

---

## 2.5.7 Catalogo come asset della carriera

Il catalogo musicale non deve essere considerato solamente come una lista di canzoni.

Con il progredire della carriera diventa un vero e proprio **asset economico**.

Un artista affermato può possedere decine o centinaia di brani pubblicati, ognuno dei quali può contribuire, anche in misura ridotta, agli introiti giornalieri.

Questo crea una progressione economica a lungo termine:

**Primi singoli → primi royalties → EP → LP → catalogo crescente → reddito passivo → maggiore capacità di investimento**

Il giocatore può quindi arrivare a una situazione nella quale non dipende esclusivamente dagli incassi dei concerti o dalle attività svolte durante la giornata.

---

# Direttrici di Espansione & Idee di Gameplay

### Vendite fisiche

Possibile separazione dei flussi economici tra:

* **CD**
* **Vinili**
* **Cassette**

Ogni formato potrebbe avere:

* costo di produzione;
* prezzo di vendita;
* quantità prodotta;
* margine differente;
* pubblico specifico.

Il vinile, ad esempio, potrebbe diventare particolarmente interessante per artisti con una fanbase molto fedele, mentre il digitale rimarrebbe il principale canale di distribuzione di massa.

---

### Streaming digitale

Possibile introduzione di un sistema di streaming separato dalle vendite fisiche.

Il modello potrebbe simulare una piattaforma "Spotify-style", con:

**Ascolti → Stream → Revenue → Royalties**

Gli stream potrebbero inoltre essere suddivisi per:

* brano;
* album;
* giorno;
* mercato;
* popolarità dell'artista.

Questo permetterebbe al giocatore di osservare la crescita o il declino dei propri brani nel tempo.

---

### Licenze e sincronizzazioni

Una futura espansione potrebbe introdurre i **contratti di licenza musicale**.

Un brano potrebbe essere richiesto per:

* film;
* serie TV;
* videogiochi;
* pubblicità;
* trailer;
* eventi.

Il giocatore potrebbe ricevere un'offerta economica per concedere l'utilizzo del brano.

Questo introdurrebbe un'altra forma di monetizzazione del catalogo:

**Catalogo → Offerta di licenza → Negoziazione → Contratto → Pagamento**

Le licenze potrebbero inoltre avere effetti sulla reputazione e sulla popolarità del brano, a seconda del contesto in cui viene utilizzato.

---

## Decisioni confermate

* Il catalogo è accessibile tramite **`M`**.
* **`A`** filtra Album ed EP.
* **`S`** filtra Singoli e brani.
* La tracklist completa è vocalizzata tramite **NVDA**.
* Le royalties vengono accreditate automaticamente durante la fase di fine giornata.
* Il singolo utilizza un tasso base di riferimento.
* EP: `ALBUM_EP_ROYALTY_RATE = 35%`.
* LP: `ALBUM_LP_ROYALTY_RATE = 60%`.
* Le pubblicazioni subiscono un decadimento fisiologico nel tempo.
* La crescita della popolarità può compensare parzialmente il decadimento.
* In presenza di una band, le royalties vengono suddivise attraverso `RevenueSplit`.
* Sono previste future espansioni per **vendite fisiche, streaming digitale e licenze musicali**.
-----------------------------------------------------------------------------------------------------------------------------



-----------------------------------------------------------------------------------------------------------------------------

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

## 4. STRUMENTI MUSICALI, SALA PROVE, HOME STUDIO & UPGRADES HUB

### 4.1 Negozio Strumenti Multicategoria & Comparatore
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/upgrade_data.gd`.
  - Schermata modale: `ui/upgrades/upgrades_modal.tscn` e `.gd`, tasto rapido HUD `U`.
  - 5 Famiglie Strumentali:
    1. Chitarre (Chitarra Elettrica Entry-Level, Vintage Solid Body, Custom Shop Master Signature)
    2. Bassi (Basso 4 Corde Starter, Basso Attivo Pro, Signature Vintage)
    3. Batterie (Kit Elettronico Compatto, Batteria Acustica in Betulla, Master Custom Touring Kit)
    4. Microfoni / Voce (Microfono Dinamico Base, Microfono da Palco Wireless, Condensatore Valvolare Gold)
    5. Tastiere / Synth (Tastiera MIDI Base, Workstation 88 Tasti Pesati, Sintetizzatore Analogico Iconico)
  - 4 Tier di Qualità (0: Starter, 1: Semi-Pro, 2: Pro Vintage, 3: Master Signature).
  - Comparatore dinamico di statistiche: Calcola e visualizza per NVDA la differenza con lo strumento posseduto (+Tecnica Strumento, +Carisma Scenico, +Sinergia Band).
  - Vantaggi estesi a tutta la band quando Alex equipaggia i suoi musicisti.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Pedali d'effetto singoli e pedalboard (Overdrive, Distorsione High-Gain, Chorus, Delay a nastro, Wah-Wah).
  - Amplificatori valvolari storici con caratteristiche sonore distinte (calore valvolare britannico vs pulito americano cristallino).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
  - # 4.1 Negozio Strumenti Multicategoria & Comparatore

Il **Negozio Strumenti** rappresenta il principale punto di accesso alla progressione hardware del personaggio e della band. Il sistema permette di acquistare strumenti musicali di qualità crescente, confrontarli con l'equipaggiamento attualmente posseduto e investire progressivamente nel miglioramento delle prestazioni musicali.

Il negozio è integrato nell'**Upgrades Hub**, che costituisce il centro generale per gli acquisti e i potenziamenti dell'artista.

---

## 4.1.1 Architettura Tecnica

Il sistema utilizza:

* **Modello dati:** `data/models/upgrade_data.gd`
* **Interfaccia:** `ui/upgrades/upgrades_modal.tscn`
* **Logica UI:** `ui/upgrades/upgrades_modal.gd`
* **Shortcut HUD:** `U`

L'apertura del pannello tramite `U` permette di accedere direttamente alla schermata degli acquisti e dei miglioramenti disponibili.

Il modello dati centralizza le informazioni relative agli upgrade, evitando di legare i valori degli strumenti direttamente alla UI.

---

## 4.1.2 Categorie di Strumenti

Il negozio è organizzato in **5 famiglie strumentali principali**.

### 1. Chitarre

Progressione prevista:

1. **Chitarra Elettrica Entry-Level**
2. **Vintage Solid Body**
3. **Custom Shop Master Signature**

La progressione rappresenta il passaggio da uno strumento base a strumenti professionali e infine a strumenti di livello Master.

### 2. Bassi

Progressione:

1. **Basso 4 Corde Starter**
2. **Basso Attivo Pro**
3. **Signature Vintage**

Gli upgrade possono contribuire alla qualità esecutiva e alla solidità complessiva della sezione ritmica.

### 3. Batterie

Progressione:

1. **Kit Elettronico Compatto**
2. **Batteria Acustica in Betulla**
3. **Master Custom Touring Kit**

La categoria comprende sia soluzioni compatte sia strumenti professionali destinati alle esibizioni live.

### 4. Microfoni / Voce

Progressione:

1. **Microfono Dinamico Base**
2. **Microfono da Palco Wireless**
3. **Condensatore Valvolare Gold**

Questa categoria riguarda principalmente la componente vocale e può interagire con le statistiche legate alla performance e alla presenza scenica.

### 5. Tastiere / Synth

Progressione:

1. **Tastiera MIDI Base**
2. **Workstation 88 Tasti Pesati**
3. **Sintetizzatore Analogico Iconico**

La categoria permette di rappresentare una progressione sia tecnica sia qualitativa nell'utilizzo di tastiere e sintetizzatori.

---

## 4.1.3 Tier di Qualità

Gli strumenti sono organizzati secondo **4 Tier qualitativi**:

| Tier | Categoria        | Funzione                          |
| ---: | ---------------- | --------------------------------- |
|    0 | Starter          | Equipaggiamento base              |
|    1 | Semi-Pro         | Primo investimento significativo  |
|    2 | Pro Vintage      | Equipaggiamento professionale     |
|    3 | Master Signature | Equipaggiamento di fascia massima |

Il Tier rappresenta il livello qualitativo dell'equipaggiamento e costituisce una delle variabili utilizzate dal sistema per determinare i bonus associati allo strumento.

La progressione non deve essere interpretata esclusivamente come una semplice sequenza "strumento più costoso = strumento migliore": l'obiettivo è permettere al giocatore di costruire progressivamente il proprio setup e di scegliere quando investire nel miglioramento dell'equipaggiamento.

---

## 4.1.4 Comparatore Dinamico

Uno degli elementi principali dell'Upgrades Hub è il **comparatore dinamico**.

Quando il giocatore seleziona un nuovo strumento, il sistema confronta automaticamente le sue caratteristiche con quelle dell'equipaggiamento attualmente posseduto.

Il confronto visualizza le variazioni relative alle principali statistiche:

* **Tecnica Strumento**
* **Carisma Scenico**
* **Sinergia Band**

Esempio concettuale:

> Strumento attuale → Tecnica +10
> Nuovo strumento → Tecnica +16
> Differenza → **+6**

Il sistema rende quindi immediatamente comprensibile il vantaggio dell'acquisto senza costringere il giocatore a memorizzare le statistiche degli strumenti precedenti.

---

## 4.1.5 Accessibilità e NVDA

Il comparatore è progettato per essere completamente leggibile tramite **NVDA**.

Quando viene selezionato uno strumento, l'interfaccia deve comunicare:

1. nome dello strumento;
2. categoria;
3. Tier;
4. costo;
5. statistiche principali;
6. differenze rispetto all'equipaggiamento attuale;
7. eventuali vantaggi applicati alla band.

Un esempio di annuncio concettuale:

> "Chitarra Vintage Solid Body. Tier 2. Costo 1200 euro. Tecnica Strumento più 8 rispetto all'equipaggiamento attuale. Carisma Scenico più 4. Sinergia Band più 3."

L'obiettivo è fare in modo che il confronto sia comprensibile anche senza utilizzare esclusivamente informazioni grafiche o indicatori cromatici.

---

## 4.1.6 Effetti sull'Intera Band

Un'importante caratteristica del sistema è che l'equipaggiamento acquistato dal leader può avere conseguenze anche sul rendimento complessivo della band.

Quando Alex equipaggia i propri musicisti attraverso il sistema di upgrade, i relativi vantaggi possono essere applicati alla formazione.

Questo permette di trasformare l'acquisto di strumenti da semplice elemento cosmetico a vera scelta gestionale:

**Investimento personale → miglioramento tecnico → miglioramento della band → migliori performance.**

Il sistema deve quindi mantenere separato il concetto di **strumento posseduto** da quello di **strumento equipaggiato**, così da permettere eventualmente di conservare più strumenti e cambiare setup in base all'attività.

---

# 4.1.7 Espansioni Future: Effettistica

Una futura espansione del negozio può introdurre una categoria dedicata agli **effetti per strumenti**.

Possibili prodotti:

* Overdrive
* Distorsione High-Gain
* Chorus
* Delay a nastro
* Wah-Wah

Gli effetti potrebbero modificare non soltanto statistiche numeriche, ma anche il **profilo sonoro** dell'artista.

Questo aprirebbe la possibilità di costruire setup differenti in base al genere musicale e allo stile personale.

Ad esempio:

**Rock classico**
→ Overdrive + Chorus

**Hard Rock / Metal**
→ Distorsione High-Gain + Wah-Wah

**Sound atmosferico**
→ Chorus + Delay

Questa meccanica permetterebbe di introdurre una progressione basata sulla **personalizzazione**, non soltanto sulla qualità assoluta dell'equipaggiamento.

---

# 4.1.8 Espansioni Future: Pedalboard

Gli effetti singoli potrebbero successivamente essere organizzati all'interno di una **Pedalboard**.

Il giocatore potrebbe quindi:

1. acquistare singoli pedali;
2. possederne diversi;
3. scegliere quali utilizzare;
4. costruire una configurazione personale;
5. modificarla in base al concerto o alla sessione in studio.

La pedalboard diventerebbe quindi un ulteriore livello di personalizzazione dell'equipaggiamento.

---

# 4.1.9 Espansioni Future: Amplificatori

Una seconda grande espansione riguarda gli **amplificatori**.

Potrebbero essere introdotti amplificatori valvolari storici con caratteristiche sonore differenti.

Esempi concettuali:

* **Valvolare britannico:** maggiore calore, carattere e saturazione;
* **Pulito americano:** suono più cristallino e definito.

In questo modo l'amplificatore non sarebbe semplicemente un ulteriore valore numerico, ma potrebbe contribuire alla definizione dell'identità sonora dell'artista.

---

# 4.1.10 Direzione di Design

Il sistema degli strumenti segue una filosofia di progressione a più livelli:

**Strumento → Hardware → Setup → Sound → Performance → Identità artistica**

L'obiettivo è evitare che l'equipaggiamento diventi semplicemente una lista di oggetti da acquistare.

Nel corso della carriera il giocatore dovrebbe poter costruire progressivamente il proprio **setup musicale**, passando dall'attrezzatura economica iniziale a una configurazione professionale e fortemente personalizzata.

Le future espansioni di effetti, pedalboard e amplificatori possono quindi trasformare il negozio da semplice **Upgrade Shop** a vero e proprio **Music Gear Hub**.

---

## 4.1.11 Idee e Decisioni da Definire

Restano da specificare alcuni aspetti del sistema:

* prezzi esatti dei singoli strumenti;
* valori numerici dei bonus per ogni Tier;
* eventuali differenze tra strumenti dello stesso Tier;
* possibilità di possedere più strumenti contemporaneamente;
* possibilità di vendere o permutare l'equipaggiamento;
* gestione dello strumento equipaggiato;
* eventuali strumenti esclusivi o rari;
* interazione tra strumenti e generi musicali;
* effetti degli strumenti sulla qualità delle canzoni;
* effetti sul punteggio dei concerti;
* sistema di effetti/pedalboard;
* sistema di amplificatori;
* eventuale usura o manutenzione dell'equipaggiamento.

Questi elementi possono essere sviluppati progressivamente senza modificare l'architettura di base del Negozio Strumenti.
-----------------------------------------------------------------------------------------------------------------------------

### 4.2 Insonorizzazione della Sala Prove & Trattamento Acustico
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - I 4 Livelli di Trattamento (`UpgradeData.RehearsalTier`):
    - Livello 0: Garage Rumoroso (Costo 0 €, Stress prova +10).
    - Livello 1: Pannelli Fonoassorbenti Base (Costo 300 €, Stress prova +7, -30% affaticamento).
    - Livello 2: Insonorizzazione Professionale (Costo 800 €, Stress prova +4, +5% affinità band).
    - Livello 3: Studio Acustico Perfetto & Lounge (Costo 2.000 €, Stress prova azzerato a 0, +8 morale, massima coesione).
  - Pulsante diretto "Fai una Prova con la Band" integrato direttamente nella scheda Upgrades per un ciclo d'azione rapido.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Possibilità di affittare la propria sala prove ad altre band locali per generare entrate passive quando non la si usa.
  - Reclami dei vicini e multe dei vigili urbani se si prova ad alto volume senza insonorizzazione.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
  ## 4.2 Insonorizzazione della Sala Prove & Trattamento Acustico

La **Sala Prove** rappresenta uno degli elementi fondamentali per la crescita della band. Non è soltanto un luogo dove eseguire prove musicali, ma costituisce un vero e proprio investimento infrastrutturale che influenza direttamente lo **Stress generato dalle prove**, la qualità della collaborazione tra i membri e il benessere complessivo della formazione.

Il sistema permette di migliorare progressivamente l'ambiente, passando da una semplice sala improvvisata fino a uno **Studio Acustico Perfetto & Lounge**.

---

## 4.2.1 Architettura Tecnica

Il sistema di trattamento acustico utilizza i dati definiti in:

* `UpgradeData.RehearsalTier`

Il livello della sala prove viene gestito come un **upgrade infrastrutturale** e può essere migliorato progressivamente attraverso l'Upgrades Hub.

Il livello selezionato influenza direttamente le conseguenze delle attività di prova della band.

---

## 4.2.2 Livelli di Trattamento Acustico

Sono disponibili **4 livelli di trattamento**.

| Livello | Struttura                         |   Costo | Stress Prova | Bonus                       |
| ------: | --------------------------------- | ------: | -----------: | --------------------------- |
|       0 | Garage Rumoroso                   |     0 € |          +10 | Nessuno                     |
|       1 | Pannelli Fonoassorbenti Base      |   300 € |           +7 | -30% affaticamento          |
|       2 | Insonorizzazione Professionale    |   800 € |           +4 | +5% Affinità Band           |
|       3 | Studio Acustico Perfetto & Lounge | 2.000 € |            0 | +8 Morale, massima coesione |

La progressione rappresenta un investimento graduale nell'ambiente di lavoro della formazione.

---

### Livello 0 — Garage Rumoroso

**Costo:** 0 €

È la configurazione iniziale e rappresenta una sala prove essenziale, priva di un trattamento acustico significativo.

**Stress generato dalla prova:** +10.

È una soluzione economica, ma comporta il maggiore impatto negativo sullo Stress dei musicisti.

Rappresenta quindi il classico punto di partenza di una band ancora agli inizi:

> strumenti, amplificatori e tanta voglia di suonare; acustica decisamente meno entusiasta.

---

### Livello 1 — Pannelli Fonoassorbenti Base

**Costo:** 300 €

L'installazione di pannelli fonoassorbenti permette di migliorare sensibilmente l'ambiente rispetto al garage iniziale.

**Stress generato dalla prova:** +7.

**Bonus aggiuntivo:** -30% affaticamento.

Questo livello rappresenta il primo investimento concreto nella sala prove e riduce il peso fisico delle sessioni più lunghe.

---

### Livello 2 — Insonorizzazione Professionale

**Costo:** 800 €

La sala raggiunge un livello professionale di trattamento acustico.

**Stress generato dalla prova:** +4.

**Bonus aggiuntivo:** +5% Affinità Band.

La riduzione dello Stress permette alla band di affrontare le sessioni di prova con maggiore continuità, mentre l'ambiente più confortevole favorisce anche la collaborazione tra i membri.

L'upgrade assume quindi una doppia funzione:

**miglioramento tecnico dell'ambiente + miglioramento delle dinamiche di gruppo.**

---

### Livello 3 — Studio Acustico Perfetto & Lounge

**Costo:** 2.000 €

Rappresenta il livello massimo attualmente previsto per la sala prove.

**Stress generato dalla prova:** 0.

**Bonus aggiuntivi:**

* +8 Morale;
* massima coesione della formazione.

A questo livello la sala diventa un vero ambiente professionale nel quale la band può trascorrere molto tempo senza subire lo Stress normalmente associato alle prove.

La presenza della **Lounge** introduce inoltre la possibilità di trasformare la sala in uno spazio destinato non soltanto alla musica, ma anche alla vita sociale della band.

---

## 4.2.3 Effetto Progressivo sulla Band

Il sistema segue una logica di progressione:

**Garage → trattamento base → insonorizzazione professionale → studio completo**

L'investimento non produce soltanto un vantaggio economico o estetico, ma modifica concretamente il modo in cui la band affronta le prove.

Una sala migliore permette infatti di:

* ridurre lo Stress;
* diminuire l'affaticamento;
* favorire l'Affinità;
* migliorare il Morale;
* aumentare la coesione della formazione.

Questo collega direttamente il sistema della sala prove ai sistemi già esistenti di:

* **Energia**;
* **Stress**;
* **Morale**;
* **Affinità**;
* **Rispetto**;
* **Tensione Interna**;
* **Sinergia Palco**.

La sala prove diventa quindi un investimento infrastrutturale con effetti trasversali sulla band.

---

## 4.2.4 Prova Rapida dalla Scheda Upgrades

Nella schermata degli upgrade è presente un pulsante diretto:

> **"Fai una Prova con la Band"**

Il pulsante permette di passare immediatamente dall'acquisto o dalla gestione della sala all'attività di prova.

Questa integrazione riduce il numero di passaggi necessari per eseguire una delle attività principali della band.

Il flusso diventa quindi:

**Upgrades Hub → Sala Prove → Fai una Prova con la Band → Risultato**

senza dover navigare manualmente attraverso più schermate.

---

## 4.2.5 Collegamento con il Sistema delle Prove

Il livello della sala viene utilizzato direttamente durante l'esecuzione di una prova della band.

La meccanica si integra con `BandSystem`, dove la sessione di prova determina già variazioni relative a:

* Energia di Alex;
* Stress;
* Affinità;
* Rispetto;
* Tensione;
* XP della band;
* Sinergia Palco.

Il trattamento acustico agisce quindi come **modificatore ambientale** dell'attività.

Questo permette di mantenere separati:

**Attività**
→ prova della band

**Ambiente**
→ qualità della sala

**Risultato**
→ conseguenze della prova modificate dal livello della struttura.

---

# 4.2.6 Espansione Futura: Sala Prove come Attività Commerciale

Una possibile evoluzione consiste nel permettere al giocatore di utilizzare la propria sala prove anche come **fonte di reddito passivo**.

Quando Alex e la band non utilizzano la struttura, potrebbe essere possibile affittarla ad altre band locali.

Esempio concettuale:

**Sala disponibile → prenotazione di una band esterna → affitto → entrata economica**

Il valore dell'affitto potrebbe dipendere dalla qualità della struttura.

Una sala professionale potrebbe quindi diventare non soltanto un investimento per la propria band, ma anche una piccola attività commerciale.

Questa meccanica collegherebbe direttamente:

* infrastrutture;
* economia;
* gestione del tempo;
* reputazione locale.

---

# 4.2.7 Espansione Futura: Problemi con i Vicini

Una possibile conseguenza delle sale poco insonorizzate riguarda i **rumori prodotti durante le prove**.

Se la band prova ad alto volume in una struttura con scarsa insonorizzazione, potrebbero verificarsi eventi casuali legati ai vicini.

Possibili eventi:

* reclamo informale;
* avvertimento;
* discussione con un vicino;
* intervento dei vigili urbani;
* multa.

Il rischio potrebbe dipendere da variabili come:

* livello di insonorizzazione;
* volume della prova;
* durata della sessione;
* fascia oraria;
* posizione della sala.

In questo modo l'insonorizzazione avrebbe anche una funzione di **protezione dagli eventi negativi**, oltre agli attuali bonus su Stress e dinamiche della band.

---

# 4.2.8 Direzione di Design

La Sala Prove segue la stessa filosofia generale degli altri sistemi infrastrutturali del gioco:

**Investimento → miglioramento dell'ambiente → migliori condizioni di lavoro → migliori dinamiche della band.**

Il giocatore deve quindi poter percepire concretamente la differenza tra una band che prova in un garage rumoroso e una formazione che dispone di un ambiente professionale.

L'obiettivo non è creare un semplice sistema di "upgrade numerici", ma trasformare progressivamente lo spazio della band in una vera **casa musicale**.

---

## 4.2.9 Idee e Decisioni da Definire

Restano da specificare eventuali sviluppi futuri:

* sistema di affitto della sala a band esterne;
* tariffa per le prenotazioni;
* durata delle prenotazioni;
* limite di utilizzo giornaliero;
* rischio di reclami dei vicini;
* sistema delle multe;
* influenza della fascia oraria sul rumore;
* eventuale differenza tra volume degli strumenti;
* personalizzazione estetica della sala;
* mobili e comfort della Lounge;
* distributori di bevande e cibo;
* zona relax;
* eventuale area per ascoltare e analizzare le registrazioni;
* collegamento con eventi sociali della band.

-----------------------------------------------------------------------------------------------------------------------------


### 4.3 Hardware Home Studio & Tecnologie Audio Casalinghe
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - I 4 Livelli di Studio Hardware (`UpgradeData.StudioHardwareTier`):
    - Livello 0: Microfono Integrato Base (Cap massimo esecuzione 60, Bonus produzione 0).
    - Livello 1: Microfono a Condensatore & Interfaccia USB (Costo 400 €, Cap esecuzione 75, Studio Bonus +5).
    - Livello 2: Preamplificatore Valvolare & Monitor da Studio (Costo 1.200 €, Cap esecuzione 90, Studio Bonus +10).
    - Livello 3: Banco Mixer Analogico & Suite Mastering (Costo 3.500 €, Cap rimosso a 100, Studio Bonus +15).
  - Impatto matematico diretto nel metodo `record_tracks()` di `MusicSystem`.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Scelta tra registrazione in analogico su nastro magnetico (più costosa, suono caldo con bonus al genere Rock/Indie) e registrazione digitale in alta definizione (suono chirurgico, ideale per Pop/Elettronica/Metal).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*:
  - ## 4.3 Hardware Home Studio & Tecnologie Audio Casalinghe

L'**Home Studio** rappresenta la progressione tecnologica dedicata alla registrazione domestica.

A differenza dello studio professionale, che viene utilizzato pagando una sessione, l'Home Studio è basato sull'acquisto progressivo dell'hardware.

Il giocatore può quindi investire gradualmente nel proprio setup audio, migliorando nel tempo i limiti tecnici della registrazione.

Il sistema segue una progressione:

**Hardware base → interfaccia e condensatore → preamplificazione e monitor → mixer analogico e mastering**

L'obiettivo è rendere l'Home Studio un investimento progressivo e non una struttura già completamente disponibile all'inizio della carriera.

---

## 4.3.1 Architettura Tecnica

Il sistema utilizza:

* `UpgradeData.StudioHardwareTier`
* `MusicSystem.record_tracks()`

Il livello hardware viene utilizzato direttamente durante la registrazione delle tracce.

Il metodo `record_tracks()` applica infatti i limiti e i bonus associati all'hardware posseduto, influenzando matematicamente il risultato della registrazione.

Il sistema mantiene quindi separati:

* **qualità dello strumento musicale**;
* **qualità dell'ambiente di registrazione**;
* **hardware dello studio domestico**;
* **utilizzo di uno studio professionale**.

Questa separazione permette di costruire una progressione più articolata.

---

## 4.3.2 Livelli di Studio Hardware

Sono presenti **4 livelli di hardware**.

| Livello | Hardware                                       |   Costo | Cap Esecuzione | Studio Bonus |
| ------: | ---------------------------------------------- | ------: | -------------: | -----------: |
|       0 | Microfono Integrato Base                       |     0 € |             60 |           +0 |
|       1 | Microfono a Condensatore & Interfaccia USB     |   400 € |             75 |           +5 |
|       2 | Preamplificatore Valvolare & Monitor da Studio | 1.200 € |             90 |          +10 |
|       3 | Banco Mixer Analogico & Suite Mastering        | 3.500 € |            100 |          +15 |

Il **Cap Esecuzione** rappresenta il limite massimo raggiungibile durante la registrazione utilizzando quel livello di hardware.

Il **Studio Bonus** rappresenta invece il contributo positivo dell'attrezzatura alla qualità complessiva della produzione.

---

### Livello 0 — Microfono Integrato Base

**Costo:** 0 €

**Cap massimo Esecuzione:** 60

**Studio Bonus:** 0

Rappresenta il livello tecnico minimo del sistema di registrazione domestica.

Non deve essere interpretato come uno studio professionale già posseduto dal giocatore, ma come la configurazione hardware minima disponibile prima di effettuare investimenti specifici.

Il risultato delle registrazioni rimane quindi fortemente limitato rispetto ai livelli superiori.

---

### Livello 1 — Microfono a Condensatore & Interfaccia USB

**Costo:** 400 €

**Cap Esecuzione:** 75

**Studio Bonus:** +5

È il primo vero investimento nell'Home Studio.

Il microfono a condensatore e l'interfaccia USB permettono di ottenere una registrazione sensibilmente più controllata rispetto alla configurazione base.

Questo livello rappresenta il momento in cui il giocatore inizia concretamente a costruire il proprio setup domestico.

---

### Livello 2 — Preamplificatore Valvolare & Monitor da Studio

**Costo:** 1.200 €

**Cap Esecuzione:** 90

**Studio Bonus:** +10

Il secondo upgrade introduce componenti di livello professionale.

Il preamplificatore valvolare migliora la qualità della catena di registrazione, mentre i monitor da studio permettono un ascolto più accurato del materiale prodotto.

L'Home Studio diventa quindi uno strumento realmente competitivo rispetto alle soluzioni professionali più economiche.

---

### Livello 3 — Banco Mixer Analogico & Suite Mastering

**Costo:** 3.500 €

**Cap Esecuzione:** 100

**Studio Bonus:** +15

Rappresenta il livello massimo attualmente previsto.

Il limite di esecuzione viene portato a **100**, eliminando il cap imposto dai livelli precedenti.

Il setup comprende:

* banco mixer analogico;
* strumenti di elaborazione professionale;
* suite di mastering.

L'investimento trasforma l'Home Studio in una struttura di produzione estremamente avanzata.

---

## 4.3.3 Impatto sulla Registrazione

Il livello hardware viene applicato direttamente durante la registrazione tramite:

`MusicSystem.record_tracks()`

Il sistema utilizza quindi l'hardware come uno dei fattori che determinano il risultato finale della sessione.

Concettualmente:

**Abilità dell'artista + strumento + hardware studio + produzione → risultato della registrazione**

L'upgrade hardware non sostituisce quindi le abilità del musicista.

Un artista con strumenti eccellenti ma competenze basse non ottiene automaticamente una registrazione perfetta.

Allo stesso modo, un artista molto competente può essere penalizzato da un setup domestico ancora troppo limitato.

---

## 4.3.4 Home Studio vs Studio Professionale

L'Home Studio introduce una scelta economica importante.

### Home Studio

**Vantaggi:**

* investimento permanente;
* nessun costo di affitto per ogni sessione;
* possibilità di registrare autonomamente;
* progressione hardware;
* controllo completo del proprio setup.

**Svantaggio principale:**

* richiede un investimento iniziale significativo per raggiungere livelli elevati.

### Studio Professionale

**Vantaggi:**

* accesso immediato a strumentazione professionale;
* qualità elevata senza acquistare l'intero hardware;
* possibilità di raggiungere rapidamente risultati avanzati.

**Svantaggio principale:**

* costo associato alle sessioni.

Il giocatore deve quindi decidere se:

**investire progressivamente nel proprio Home Studio**

oppure

**pagare uno studio professionale quando serve una produzione di livello superiore.**

---

# 4.3.5 Espansione Futura: Registrazione Analogica vs Digitale

Una possibile evoluzione del sistema consiste nell'introdurre due filosofie di registrazione:

### Analogico su Nastro Magnetico

La registrazione su nastro potrebbe essere:

* più costosa;
* caratterizzata da una maggiore impronta sonora;
* associata a un suono più caldo;
* particolarmente adatta a determinati generi.

Potrebbe inoltre ricevere un bonus specifico per:

* Rock;
* Indie.

L'obiettivo sarebbe rappresentare il carattere distintivo della registrazione analogica senza renderla semplicemente "migliore" della registrazione digitale.

---

### Digitale ad Alta Definizione

La registrazione digitale potrebbe invece privilegiare:

* precisione;
* pulizia;
* controllo;
* dettaglio;
* flessibilità in fase di produzione.

Potrebbe risultare particolarmente adatta a:

* Pop;
* Elettronica;
* Metal.

La differenza dovrebbe quindi essere principalmente **stilistica e contestuale**, non una semplice progressione lineare.

---

## 4.3.6 Filosofia del Sistema

L'equipaggiamento dello studio segue il principio:

**Più investimento ≠ automaticamente musica migliore.**

L'hardware aumenta le possibilità tecniche dell'artista, ma il risultato finale continua a dipendere dalle sue abilità e dagli altri sistemi musicali.

Questo permette di mantenere importante la progressione del personaggio anche nelle fasi avanzate del gioco.

L'Home Studio diventa quindi un elemento di gestione economica e artistica:

> **"Compro hardware costoso una volta, oppure continuo a pagare lo studio professionale?"**

Entrambe le strategie possono essere integrate nella carriera del giocatore.

---

## 4.3.7 Idee e Decisioni da Definire

Restano da specificare eventuali espansioni:

* registrazione analogica e digitale;
* costo delle sessioni analogiche;
* disponibilità del nastro magnetico;
* bonus precisi per genere;
* eventuali svantaggi dell'analogico;
* possibilità di acquistare più componenti separatamente;
* microfoni specializzati per voce, batteria e amplificatori;
* preamplificatori differenti;
* compressori ed equalizzatori hardware;
* plugin ed effetti digitali;
* workstation di produzione;
* possibilità di aggiornare singoli componenti invece dell'intero Tier;
* manutenzione dell'hardware;
* eventuali guasti;
* rapporto tra qualità dello studio e qualità finale del brano.
-----------------------------------------------------------------------------------------------------------------------------


### 4.4 Usura, Setup Liuteria & Manutenzione Strumentale
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Gli strumenti acquistati mantengono le loro statistiche nel salvataggio permanente (`SaveManager`).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Sistema di usura delle corde e dell'elettronica dopo un certo numero di concerti dal vivo o ore di prove.
  - Visite dal liutaio di fiducia per rettifica tasti, cambio corde ed intonazione per prevenire corde rotte sul palco.
  - Strumenti di riserva ("Muletti") da portare nel baule durante i live.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 
## 4.4 Usura, Setup Liuteria & Manutenzione Strumentale

Il sistema di equipaggiamento prevede attualmente la **persistenza permanente degli strumenti acquistati**.

Gli strumenti e i relativi dati vengono salvati tramite `SaveManager`, permettendo al giocatore di mantenere i propri investimenti anche dopo il caricamento di una partita.

Attualmente non è invece presente un sistema di deterioramento automatico degli strumenti.

L'usura e la manutenzione rappresentano quindi una possibile evoluzione futura del sistema.

---

## 4.4.1 Persistenza degli Strumenti

Gli strumenti acquistati dal giocatore vengono registrati nel salvataggio permanente tramite:

`SaveManager`

Questo permette di conservare:

* strumenti acquistati;
* equipaggiamento disponibile;
* progressione degli upgrade;
* statistiche associate agli strumenti.

L'acquisto di uno strumento rappresenta quindi un investimento permanente nella progressione del personaggio e della band.

---

# 4.4.2 Espansione Futura: Sistema di Usura

Una futura versione potrebbe introdurre un sistema di **usura progressiva**.

L'usura potrebbe aumentare in funzione dell'utilizzo dello strumento, ad esempio attraverso:

* numero di concerti;
* ore di prova;
* sessioni di registrazione;
* utilizzo particolarmente intenso.

L'obiettivo non dovrebbe essere rendere la manutenzione un fastidio continuo, ma introdurre una conseguenza gestionale credibile per l'utilizzo intensivo dell'attrezzatura.

---

## 4.4.3 Corde ed Elettronica

Per gli strumenti a corda, una possibile meccanica riguarda il deterioramento delle corde.

Dopo un certo numero di:

* prove;
* concerti;
* ore di utilizzo;

le corde potrebbero perdere progressivamente qualità.

Una manutenzione preventiva potrebbe ripristinare le condizioni ottimali dello strumento.

Un sistema analogo potrebbe essere applicato anche all'elettronica e ai componenti soggetti a maggiore utilizzo.

---

# 4.4.4 Liutaio di Fiducia

Una futura attività potrebbe permettere al giocatore di rivolgersi a un **liutaio di fiducia**.

Possibili interventi:

* rettifica dei tasti;
* cambio corde;
* regolazione dello strumento;
* intonazione;
* manutenzione generale.

La manutenzione potrebbe servire a prevenire problemi durante le attività più importanti della carriera.

Ad esempio, una manutenzione insufficiente potrebbe aumentare il rischio di inconvenienti durante un concerto.

---

## 4.4.5 Strumenti di Riserva — "Muletti"

Una futura espansione potrebbe permettere alla band di portare strumenti di riserva durante i concerti.

Questi strumenti, comunemente identificabili come **"muletti"**, avrebbero una funzione principalmente preventiva.

Esempio:

**Strumento principale → problema durante il live → sostituzione con il muletto → concerto continua**

Questo introdurrebbe una nuova scelta gestionale:

* trasportare più equipaggiamento;
* aumentare i costi logistici;
* occupare spazio nel setup;
* ridurre il rischio di interruzioni causate da problemi tecnici.

Il sistema potrebbe essere particolarmente rilevante durante:

* concerti importanti;
* tour;
* festival;
* grandi venue.

---

# 4.4.6 Direzione di Design

L'eventuale sistema di manutenzione dovrebbe seguire un principio fondamentale:

**aggiungere realismo senza trasformare il gioco in un simulatore di riparazioni.**

L'usura dovrebbe quindi avere un peso gestionale, ma non diventare un'attività obbligatoria e ripetitiva dopo ogni concerto.

La manutenzione avrebbe maggiore valore soprattutto quando il giocatore inizia a gestire:

* strumenti costosi;
* concerti importanti;
* tour;
* grandi produzioni;
* setup complessi.

In questo modo il sistema crescerebbe insieme alla carriera dell'artista.

---

## 4.4.7 Idee e Decisioni da Definire

Restano da progettare:

* velocità di usura;
* differenze di usura tra strumenti;
* soglie di manutenzione;
* costi del liutaio;
* durata degli interventi;
* possibilità di manutenzione preventiva;
* probabilità di guasto;
* conseguenze di un guasto durante un concerto;
* numero massimo di strumenti trasportabili;
* costo logistico dei muletti;
* differenze tra manutenzione ordinaria e straordinaria;
* eventuale usura dell'hardware dell'Home Studio.


-----------------------------------------------------------------------------------------------------------------------------

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

## 10. ARTISTI RIVALI, HIT PARADE & CLASSIFICHE MUSICALI

### 10.1 Il Catalogo delle 10 Band Rivali Continentali
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/rival_data.gd` e modulo `systems/rival_system.gd`.
  - Le 10 Band Rivali con città, generi, carriera, singoli ed album attivi:
    1. `The Chrome Shadows`: Milano, Rock/Elettronica, Tier Indie Sensation, Singolo "Neon Mirage", Album "Overdrive City".
    2. `I Ribelli del Pratello`: Bologna, Indie/Rock, Tier Local Artist, Singolo "Portici Rossi", Album "Sottovoce EP".
    3. `Colosseo Sound Machine`: Roma, Pop/Rock melodico, Tier Indie Sensation, Singolo "Travertino Beat", Album "Tramonto Imperiale".
    4. `Vesuvio Posse`: Napoli, Hip Hop/Crossover, Tier Indie Sensation, Singolo "Fumo e Lava", Album "Spaccanapoli Sound".
    5. `Royal Camden Vanguard`: Londra, Metal/Hard Rock, Tier National Star, Singolo "Thames Riot", Album "Crown of Rust".
    6. `Klangwerk Berlin`: Berlino, Elettronica/Industrial, Tier National Star, Singolo "Beton Tanz", Album "Nachtschicht".
    7. `The Silver Strings`: Milano, Pop Acustico, Tier Busker, Singolo "Gocce di Pioggia", Album "Sussurri Acustici".
    8. `Bologna Wave`: Bologna, Elettronica/Synthpop, Tier Local Artist, Singolo "Notte Rossa", Album "Frequenze Urbane".
    9. `London Fog`: Londra, Indie Rock/Shoegaze, Tier Indie Sensation, Singolo "Mist & Shadows", Album "Streets of London".
    10. `Berliner Mauer Beat`: Berlino, Hip Hop/Underground, Tier Local Artist, Singolo "Graffiti Wall", Album "Ostkreuz Sessions".
- **Direttrici di Espansione & Idee di Gameplay**:
  - Relazioni interpersonali con i leader dei rivali (rispetto reciproco, amicizia sincera o rivalità velenosa).
  - Possibilità di organizzare un tour congiunto a doppio cartellone (*Co-Headlining Tour*) con una band rivale amica.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 10.2 Hit Parade Settimanale: Top 10 Singoli e Top 10 Album
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/chart_entry_data.gd` e modulo `systems/chart_system.gd`.
  - Schermata modale ad alto contrasto: `ui/chart/chart_modal.tscn` e `.gd`, tasto rapido HUD `H`.
  - Tasti interni: `1` per visualizzare la Top 10 Singoli, `2` per la Top 10 Album, `R` per la scheda dettagliata del Rivale.
  - Simulazione settimanale ogni Domenica notte (`Weekday.SUNDAY`) in `EndDaySystem`.
  - Tracciamento dinamico per ogni brano/album:
    - Posizione attuale [1 - 10]
    - Posizione precedente con indicatore di movimento: Nuova entrata (`NEW`), Salita (`▲`), Discesa (`▼`), Stabile (`=`)
    - Settimane di permanenza in classifica
    - Posizione di picco storico raggiunta
- **Direttrici di Espansione & Idee di Gameplay**:
  - Allargamento della classifica a Top 20 o Top 40.
  - Classifiche separate per singolo Paese (Hit Parade Italia, Regno Unito, Germania) oltre alla classifica continentale europea.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 10.3 Algoritmo di Stream, Vendite Fisiche & Conquista del Numero 1
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Formula calcolo vendite/stream del giocatore: Basata su Quality Score del brano/disco, Fanbase totale, Popolarità e moltiplicatore `social_buzz`.
  - Se il brano o l'album supera tutti i concorrenti e raggiunge la posizione #1:
    - Scatta l'evento trionfale "Hai conquistato il Primo Posto in Classifica!".
    - Bonus straordinario a reputazione (+15.0), incremento fan e morale al 100%.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Competizione feroce per la "Canzone di Natale" o il "Tormentone Estivo dell'Anno".
  - Meccaniche di boicottaggio o guerre di streaming tra fandom rivali.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 10.4 Faide tra Artisti, Dissing & Riconoscimenti Speciali
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Livello di rivalità tracciato in `RivalData`: 0 = Neutro/Rispetto a distanza, 1 = Competizione accesa, 2 = Faida mediatica aperta.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Dissing su BandFeed: Possibilità di pubblicare un brano o un post che prende di mira un rivale specifico per scalare le classifiche grazie alla curiosità del pubblico.
  - Evento di riconciliazione sul palco durante un grande festival con duetto a sorpresa.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

## 11. ENDGAME, GRANDI STADI & LEGACY MONDIALE (FASE 9 / V5.0)

### 11.1 Scalata delle Grandi Arene & Stadi Mondiali (15.000 - 80.000 Spettatori)
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Tier di carriera finale `Enums.CareerTier.GLOBAL_SUPERSTAR` già codificato nelle costanti.
  - Apertura e pianificazione della Fase 9 in `docs/todo.md` (`F9.2`).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Grandi Arene e Palasport (10.000 - 20.000 posti, es. Forum di Assago, O2 Arena di Londra).
  - Grandi Stadi Mondiali (50.000 - 80.000 spettatori, es. San Siro a Milano, Stadio Olimpico a Roma, Wembley Stadium a Londra, Olympiastadion a Berlino).
  - Costi di affitto e allestimento mastodontici (50.000 - 200.000 € a serata) con incassi milionari.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 11.2 Mega-Allestimenti Scenici, Pirotecnica & Service Professionale
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Architettura di supporto pronta per accogliere nuovi tier di produzione scenica.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Selezione del palco: Passerella a T che entra nel prato, palchi rotanti, piattaforme idrauliche sopraelevate.
  - Effetti scenici: Lanciafiamme sincronizzati col ritornello, muri di laser a 360 gradi, cannoni sparacoriandoli, maxischermi LED trasparenti ad altissima risoluzione.
  - Convoglio di 15-20 bilici e squadra di 50 roadie e tecnici audio/luci professionisti al seguito.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 11.3 Certificazioni Ufficiali: Dischi d'Oro, Platino, Diamante & Music Awards
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Tracciamento delle vendite complessive per singolo e per album già persistito in `SaveManager`.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Soglie per le Certificazioni Ufficiali:
    - Disco d'Oro: 25.000 copie / 10 milioni di stream.
    - Disco di Platino: 50.000 copie / 25 milioni di stream.
    - Disco di Diamante: 500.000 copie / 100 milioni di stream.
  - Cerimonia annuale dei "World Music Awards" con nomination per Miglior Album, Miglior Canzone, Miglior Band Live dell'Anno.
  - Consegna delle targhe dorate da appendere alle pareti del proprio loft o villa.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 11.4 Hall of Fame, Eredità Storica, Pensione Musicale & Finale di Gioco
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Stato di gioco `Enums.GameState.GAME_OVER` e condizioni di fine partita pianificate in `F9.3`.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Induzione nella "Rock and Roll Hall of Fame" al raggiungimento dei traguardi massimi di carriera.
  - Concerto d'addio finale ("The Last Waltz") che conclude la modalità carriera.
  - Schermata finale di bilancio dell'eredità artistica lasciata al mondo, con epilogo narrativo generato in base alle scelte fatte:
    - L'Icona Immortale (Grande successo e integrità artistica impeccabile)
    - Il Martire del Rock (Fedele alla musica underground fino all'ultimo respiro)
    - La Macchina da Soldi (Ricchissimo, ma ricordato solo per jingle commerciali)
    - La Cometa Fiammeggiante (Una sola hit leggendaria rimasta nella storia e poi il ritiro).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

## 12. ARCHITETTURA UI, ACCESSIBILITÀ NVDA & SOUND DESIGN

### 12.1 Architettura HUD a 5 Sezioni, Top Bar Permanente & Menu di Sistema Esc
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo centrale: `ui/hud/hud.gd` e `ui/system_menu/system_menu_modal.gd`.
  - Top Bar Fissa Permanente: Calendario, orologio, risorse vitali (Energia, Stress, Morale), saldo bancario e controlli runtime sempre visibili e ancorati in alto.
  - Risoluzione viewport nativa: 1920x1080 ad alto contrasto per Holy Diver.
  - Comportamento gerarchico del tasto `Esc`:
    - Se una modale è aperta: chiude la modale attiva e torna all'HUD principale.
    - Se nessuna modale è aperta (a riposo nell'HUD): mette la simulazione in pausa e apre il `SystemMenuModal`.
  - Voci del Menu di Sistema: 1. Riprendi Partita, 2. Salva Partita (salvataggio atomico immediato con annuncio vocale per NVDA), 3. Impostazioni & Accessibilità, 4. Torna al Menu Principale.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Scheda riassuntiva di statistiche complessive di carriera consultabile direttamente dal menu di pausa.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 12.2 Selettore a 4 Macro-Aree & Conservazione dei 15 Tasti Rapidi Diretti
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Organizzazione delle 4 Macro-Aree tematiche (Tasti numerici `1`..`4`):
    - `1` Hub Personale (Personaggio `C`, Agenda `A`, Bilancio `B`, Viaggi `V`)
    - `2` Creazione & Produzione (Catalogo `M`, Nuovo Brano `N`, Produzione Album `P`)
    - `3` Carriera & Band (Concerti `L`, Band `G`, Tour `O`, Festival `F`, Social `Y`, Classifiche `H`, Industria `K`)
    - `4` Skills & Upgrades (Alloggi, Sala Prove, Negozio Strumenti, Hardware Studio `U`)
  - Conservazione integrale di tutti i 15 tasti rapidi alfabetici diretti storici per gli utenti esperti, garantendo navigazione istantanea senza sottomenu.
  - Isolamento atomico dei backdrop e gestione anti-sovrapposizione con `_hide_all_modals()`.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Supporto per comandi Numpad per navigazione veloce riga per riga.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 12.3 Bridge AccessibilityManager, AccessKit Nativo & Zero Mouse
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Autoload bridge: `autoload/accessibility_manager.gd`.
  - Comunicazione bidirezionale con NVDA tramite controller DLL nativo o fallback SAPI sintetico.
  - AccessKit nativo di Godot 4 per l'esposizione corretta dell'albero di accessibilità del sistema operativo.
  - Modalità Zero Mouse rigorosa: ogni schermata, elenco, cursore e pulsante è pilotabile al 100% da tastiera con focus ciclico, Tab, Frecce, Invio e Spazio.
  - Modalità Live Region (`ACCESSIBILITY_LIVE_POLITE` e `ACCESSIBILITY_LIVE_ASSERTIVE`) per messaggi urgenti a schermo.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Opzione per attivare una modalità di "Descrizione Dettagliata Narrativa" per ascoltare descrizioni di lore approfondite dei locali e delle città.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 12.4 Sound Design, Priorità Acustica Anti-Mascheramento & Pausa Dinamica
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Regola aurea di coesistenza: I suoni di gioco e ambientali sono calibrati a un volume sicuro lineare compreso tra 0.7f e 0.75f (`AUDIO_SAFE_VOLUME_LINEAR` = 0.75, corrispondente a -2.5 dB `AUDIO_MAX_VOLUME_DB`).
  - Ducking acustico automatico: Il volume scende al 40% (`AUDIO_DUCKING_RATIO` = 0.40) ogni volta che la voce di NVDA o del sintetizzatore sta pronunciando un testo a schermo, eliminando qualsiasi mascheramento vocale.
  - Pausa Dinamica: All'apertura di qualsiasi menu o modale, il tempo di gioco viene congelato per consentire a Luca di ascoltare e riflettere senza ansia da timer.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Effetti sonori distintivi (Earcon / Audio Cues) per ciascuna macro-area (es. accordo di chitarra rock per l'area Live, rumore di mixer per la Produzione, campane per la domenica di classifica, applausi per la vittoria del #1).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

## 13. REGISTRO STORICO DELLE SUITE DI TEST CONVALIDATE (19/19 TEST SUITE)

A testimonianza della solidità tecnica delle fondamenta attuali, tutte le seguenti 19 suite di test automatizzati vengono eseguite in modalità headless con 0 errori:
1. `tests/test_formulas.gd`: 24 test unitari su curve XP, formule qualità brani, concert score e bilanciamento.
2. `tests/test_time_system.gd`: 15 test su orologio giornaliero, fasce orarie e stati IDLE/BUSY/PAUSED.
3. `tests/test_end_day_system.gd`: 12 test su ciclo di mezzanotte, spese fisse e riposo notturno.
4. `tests/test_save_manager.gd`: 16 test su serializzazione, persistenza JSON atomica e integrità salvataggi.
5. `tests/test_localization_manager.gd`: 29 test su rilevamento lingua, dizionari speculari e segnali di cambio lingua.
6. `tests/test_skill_system.gd`: 29 test sulle 7 abilità musicali e saturazione giornaliera.
7. `tests/test_music_system.gd`: 35 test sulla pipeline di creazione brani e calcolo qualità.
8. `tests/test_concert_system.gd`: 53 test sul motore concerti, affluenza, stage events e closer bonus.
9. `tests/test_economy_system.gd`: 22 test su sussistenza, alloggi, bancarotta e stipendi.
10. `tests/test_career_system.gd`: 18 test sulle promozioni di carriera da Nobody a Superstar.
11. `tests/test_band_system.gd`: 55 test su reclutamento band, 4 personalità, affinità, rispetto e tensione.
12. `tests/test_album_system.gd`: 50 test su formati EP e LP, concept artistici e vendite Day 1.
13. `tests/test_industry_system.gd`: 60 test su contratti Indie vs Major, anticipi, recoupment e 3 tipi di manager.
14. `tests/test_dilemma_system.gd`: 25 test sui bivi etico-narrativi e scelte morali.
15. `tests/test_travel_system.gd`: 64 test sulla rete delle 6 città, affinità di genere e costi di viaggio.
16. `tests/test_tour_system.gd`: 65 test su tournée multi-tappa, 3 classi di veicolo e accumulo Hype.
17. `tests/test_festival_system.gd`: 70 test sui festival estivi, slot orari e meccanica "Rubare la Scena".
18. `tests/test_social_media_system.gd`: 65 test su BandFeed, viralità, shitstorm e social buzz.
19. `tests/test_rival_and_chart_system.gd`: 54 test sulle 10 band rivali, Hit Parade Top 10 e conquista del #1.
20. `tests/test_v5_ui_overhaul.gd`: 44 test sull'architettura HUD a 5 sezioni, Top Bar permanente e Menu Esc.
21. `tests/test_upgrades_system.gd`: 68 test su UpgradesModal, 5 famiglie strumenti con comparatore e hardware studio.
