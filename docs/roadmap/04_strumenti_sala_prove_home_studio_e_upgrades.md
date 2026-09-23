# World-tour — Roadmap Modulare: Sezione 4

- File di origine: `docs/roadmap.md`
- Titolo: Strumenti Musicali, Sala Prove, Home Studio & Upgrades Hub
- Priorità Operativa: P4 - Crescita Materiale

---

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

