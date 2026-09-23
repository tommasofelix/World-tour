# World-tour — Roadmap Modulare: Sezione 2

- File di origine: `docs/roadmap.md`
- Titolo: Creatività Musicale, Scrittura Brani & Produzione Discografica
- Priorità Operativa: P2 - Loop Discografico

---

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

