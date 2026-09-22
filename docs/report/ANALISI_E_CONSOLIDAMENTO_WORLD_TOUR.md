# Rapporto di Analisi Esplorativa, Valutazione Critica e Consolidamento — World-tour

- Autori del progetto: Luca & Holy Diver
- Assistente: Antigravity (Senior AI Pair Programmer & Software Engineer)
- Data di riferimento: 2026-09-21
- Documento sorgente analizzato: [`docs/piani/attivi/World Tour .md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/World%20Tour%20.md) (9.357 righe, 174 KB)

---

## 1. SINTESI E VALUTAZIONE GENERALE DEL PROGETTO

Il progetto **World-tour** (o *Music Career Simulator* / *Music Superstar Simulator*) presenta un livello di approfondimento concettuale, matematico e sistemico straordinario. Non si tratta di una semplice idea embrionale, ma di un impianto organico che include già:
- Visione artistica e fantasia del giocatore (da "nessuno" in cameretta a rockstar/superstar negli stadi).
- Core gameplay loop ciclico (Pianifica -> Agisci -> Risultato -> Progressione).
- Modello matematico dettagliato per abilità, esperienza, rendimenti marginali decrescenti e qualità dei brani.
- Separazione concettuale rigorosa tra *Qualità* (valore artistico), *Popolarità* (fama pubblica), *Reputazione* (rispetto dell'industria) e *Fanbase* (fidelizzazione reale).
- Simulazione di vita (Life Simulation) con fabbisogno energetico, gestione di stress, morale, trasporti e indipendenza economica progressiva.
- Specifiche di sistemi modulari ad eventi (EventBus, TimeSystem, PlayerSystem, MusicSystem, ConcertSystem, EconomySystem).
- Bozza di architettura software e transizione verso Godot Engine 4.x con pattern Resource/Scene/Autoload.

### Verdetto di Valutazione
Il progetto è solido, maturo e ricco di potenziale. La visione è chiara e le formule proposte evitano con intelligenza i classici difetti dei simulatori musicali (come il grinding lineare ripetitivo o la confusione tra bravura tecnica e successo commerciale).
Tuttavia, prima di toccare il codice, emergono **sei nodi architetturali e metodologici cruciali** da sciogliere e consolidare per garantire che il software sia veramente modulare, manutenibile, scalabile e conforme al **Principio di Simmetria Universale Bi-Direzionale** (100% accessibile da tastiera e NVDA per Luca, e visivamente moderno ed elegante con il mouse per Holy Diver e i giocatori normovedenti).

---

## 2. I 5 PILASTRI DI FORZA DEL DESIGN

### 1. La Triade di Risorse Primarie (Tempo, Energia, Denaro)
Il bilanciamento tra risorse tangibili (denaro), fisiologiche (energia) e temporali (la risorsa più scarsa) crea scelte strategiche continue e ponderate:
- Il tempo speso nel trasporto (autobus vs taxi vs piedi) traduce direttamente un costo economico in risparmio temporale.
- Le attività non sono tutte uguali: allenarsi intensamente produce rendimenti decrescenti ma consuma picchi di energia e accumula stress.
- Stress e Morale fungono da modificatori di efficienza complessiva, impedendo al giocatore di comportarsi come un robot da lavoro.

### 2. Disaccoppiamento tra Qualità Musicale e Notorietà
Nel mercato reale, una canzone eccellente può passare inosservata senza promozione, mentre un brano commerciale con grande spinta può scalare le classifiche pur avendo una qualità intrinseca modesta.
Il modello di World-tour rispetta questa verità:
- La qualità della canzone dipende da abilità compositive, testo, produzione e fattori di originalità/melodia.
- Il successo commerciale e l'audience dipendono dalla popolarità pregressa, dal carisma, dalla promozione e dal contesto del locale.
- La fidelizzazione dei fan (conversione da spettatore a fan permanente) premia invece la qualità effettiva dello spettacolo.

### 3. Progressione Emergente e Anti-Grinding
La presenza di rendimenti decrescenti (diminishing returns) impedisce la strategia banale di ripetere all'infinito la stessa azione.
Inoltre, vengono formalizzati tre percorsi distinti di crescita:
- Percorso Live (concerti frequenti nei locali, crescita organica della fanbase locale).
- Percorso Studio (composizione meticolosa, affinamento della tecnica e ricerca del singolo perfetto).
- Percorso Sociale/Lifestyle (networking, presenza nei luoghi di tendenza, gestione delle relazioni e dell'immagine).

### 4. Background e Fasi di Indipendenza Economica
L'introduzione di background differenziati (figlio di musicisti, autodidatta, studente, ragazzo di strada, famiglia benestante) e di fasi realistiche di sostentamento:
- Fase 1: Dipendenza dalla famiglia.
- Fase 2: Primo lavoro estraneo alla musica.
- Fase 3: Lavoro part-time unito all'attività musicale serale.
- Fase 4: La musica comincia a coprire le spese vive.
- Fase 5: Professionismo a tempo pieno.
- Fase 6: Superstar globale con redditi da catalogo, tour e sponsor.
Questo dà al gioco un respiro narrativo ed emotivo profondo, rendendo ogni scalata differente e personale.

### 5. Architettura Disaccoppiata a Sistemi ed Eventi
La specifica tecnica individua già l'esigenza di evitare accoppiamenti rigidi tra UI e logica, proponendo un bus eventi (`EventBus`) e la separazione dei domini (`TimeSystem`, `PlayerSystem`, `MusicSystem`, `ConcertSystem`, `EconomySystem`, `SaveSystem`).

---

## 3. ANALISI DEI 6 NODI CRITICI E PROPOSTE DI MIGLIORAMENTO

### Nodo 1: Sistema del Tempo e Accessibilità Cognitiva/NVDA
- **Situazione attuale nel documento**:
  Si propone che 1 giornata duri esattamente 600 secondi di tempo reale (10 minuti), con un orologio continuo che scorre sempre, anche nello stato `IDLE` (quando il giocatore legge i menu o riflette), e con un'esclusione esplicita del tasto Pausa nella V1.
- **Rischio e criticità**:
  1. *Per Luca (e qualsiasi utente di screen reader NVDA)*: La lettura vocale dei menu, delle statistiche del personaggio, dell'inventario dei brani e dei dialoghi richiede tempo cognitivo e di sintesi vocale. Un orologio reale che continua a consumare i 600 secondi della giornata mentre si naviga nell'interfaccia penalizza duramente il giocatore non vedente.
  2. *Per il gameplay generale*: Anche per i giocatori vedenti, un simulatore gestionale/strategico che impedisce di fermarsi a pianificare genera ansia frenetica anziché godimento tattico. Inoltre, l'assenza di una pausa impedisce di gestire interruzioni della vita reale (telefono, campanello, ecc.).
- **Proposta di consolidamento**:
  - **Pausa Attiva nei Menu**: Quando si apre un menu di consultazione, un pannello di gestione o una finestra di dialogo, l'orologio si congela automaticamente.
  - **Simulazione Dinamica con Controlli Temporali**: Integrare sin dal Day 1 i tre comandi classici dei simulatori gestionali: `Pausa`, `Play (1x)`, `Avanti Veloce (2x / 5x)`.
  - **Avanzamento a Durata di Azione (Alternativa Discreta)**: Quando si avvia un'attività da 30 secondi, il tempo scorre durante l'esecuzione dell'attività (mostrando l'avanzamento e consentendo eventi istantanei), ma si ferma non appena il personaggio torna disponibile nello stato `IDLE`.

### Nodo 2: Scelta dello Stack Tecnologico & Simmetria Universale (Godot vs Python vs Web/Decoupled)
- **Situazione attuale nel documento**:
  Il documento esordisce indicando Python, per poi virare nelle sezioni successive su Godot Engine 4.x con GDScript, pianificando scene, risorse e nodi Godot.
- **Rischio e criticità**:
  1. *Accessibilità di Godot Engine*: Godot 4 renderizza la propria interfaccia tramite API grafiche proprietarie (Vulkan/OpenGL) e **non espone nativamente i controlli UI a Microsoft UI Automation (UIA) o NVDA**. Un'interfaccia standard creata in Godot risulterebbe totalmente muta per lo screen reader senza uno strato dedicato.
  2. *Esperienza di Sviluppo di Luca*: L'editor visivo di Godot non è fruibile da tastiera/screen reader. Luca può scrivere file di script (GDScript o C#) con un editor di testo accessibile (VS Code / Notepad++), ma la composizione grafica della scena, il posizionamento dei nodi e l'ispezione delle proprietà richiedono l'intervento visivo di Holy Diver o di Antigravity.
- **Proposte di consolidamento a confronto**:
  - **Soluzione A (Godot 4 con Modulo di Accessibilità Integrato — Raccomandata se Holy Diver predilige Godot)**:
    - Holy Diver progetta e cura la grafica in Godot (temi, layout, animazioni, colori conformi WCAG per gli utenti vedenti).
    - Creazione di un `AccessibilityManager` (Autoload GDScript) che intercetta la navigazione da tastiera (Tab, Frecce, Invio, Spazio, scorciatoie 1-9) e invia i testi a voce tramite:
      - Integrazione con la libreria nativa `nvdaControllerClient.dll` (per comunicare direttamente con NVDA a latenza zero), oppure sintesi SAPI/Windows Speech.
      - Feedback audio posizionale e sonificazione per le azioni principali (inizio/fine azione, livello successivo, successo concerto).
  - **Soluzione B (Clean Architecture Disaccoppiata: Core Headless + Doppia Presentazione)**:
    - Il motore logico puro (`core-engine`) viene sviluppato in modo agnostico e testabile (ad es. in Python o C#).
    - Esso espone un'interfaccia standard (o IPC / JSON) a due front-end:
      1. Un front-end accessibile nativo o web (Textual, wxPython o interfaccia Web con standard HTML/ARIA, accessibile al 100% per Luca).
      2. Un front-end grafico Godot per l'esperienza commerciale e visiva curata da Holy Diver.
  - **Soluzione C (Progetto Python nativo con GUI moderna)**:
    - Se l'obiettivo principale è la massima sinergia diretta nel codice per Luca e Holy Diver, valutare Python con framework UI che supportino l'accessibilità (es. PySide6/Qt con controlli nativi accessibili a NVDA e styling CSS per Holy Diver).

### Nodo 3: Igiene Documentale e Modularizzazione del GDD
- **Situazione attuale nel documento**:
  Il file [`docs/piani/attivi/World Tour .md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/World%20Tour%20.md) è un blocco unico di 9.357 righe in cui convivono sette stesure cronologiche successive (Bozza V1, Roadmap, Specifica V1, Game Rules, Formula Spec, Game Systems, Data Model Godot).
  Alcuni punti contengono contraddizioni ereditate (es. Python all'inizio vs Godot alla fine; tempo continuo puro vs tempo simulato).
  Inoltre, in base alla governance ASTRALIS, la cartella `docs/piani/attivi/` è destinata a piani tecnici snelli e operativi (con task numerati `D0`, `D1`, `D2`), mentre il corpus di 9.000 righe è un Game Design Document completo con specifiche di sistema.
- **Proposta di consolidamento**:
  Riorganizzare il patrimonio informativo in una struttura chiara, modulare e priva di duplicazioni (Pointer DRY):
  1. `docs/gdd/`:
     - `01_concept_e_visione.md` (High concept, fantasia, progressione V1-V5).
     - `02_gameplay_loop_e_vita.md` (Ciclo giornaliero, triade risorse, life simulation).
  2. `docs/specifiche/`:
     - `01_regole_di_gioco.md` (Azioni, stati IDLE/BUSY, luoghi, venue).
     - `02_formule_e_bilanciamento.md` (XP, curve di abilità, qualità brani, audience, economia).
     - `03_modello_dati.md` (Struttura dati: Player, Song, Venue, Calendar, Career).
     - `04_architettura_software.md` (Manager, EventBus, sistemi, persistenza).
     - `05_standard_accessibilita_e_simmetria.md` (Accessibilità NVDA, tastiera, scorciatoie e standard visivi).
  3. `docs/piani/attivi/`:
     - Un piano tecnico dedicato e compatto: `PIANO_VERTICAL_SLICE_V1.md` (focalizzato unicamente sul primo prototipo giocabile).

### Nodo 4: Analisi degli Scenari Limite e Casi d'Errore (Matrice di Simulazione a 3 Livelli)
Il documento attuale si concentra principalmente sull'Happy Path. Occorre definire formalmente il comportamento del sistema nei casi limite:
1. *Scenari di Fallimento Economico (Bancarotta)*:
   - Se il saldo scende sotto lo zero, cosa succede? Viene introdotto il pignoramento dello strumento, uno sfratto, un debito con usurai o un salvataggio da parte della famiglia con penalità di morale?
2. *Esaurimento Fisiologico (Energia a 0 / Stress a 100)*:
   - Se l'energia tocca lo zero durante un'azione, il personaggio collassa (riposo forzato di 12 ore con perdita della giornata)?
   - Se lo stress tocca 100, si manifesta un blocco artistico (impossibile comporre) o un attacco di panico prima di un concerto?
3. *Taglio delle Azioni a Fine Giornata*:
   - Se rimangono 15 secondi prima della fine del giorno e il giocatore avvia un'azione da 60 secondi:
     - L'azione viene bloccata all'avvio con avviso?
     - Oppure viene eseguita parzialmente?
     - La regola raccomandata è: non è possibile avviare un'azione la cui durata eccede il tempo residuo della giornata, a meno che non sia consentito fare "straordinari notturni" al prezzo di un fortissimo accumulo di stress.
4. *Integrità dei Dati di Salvataggio*:
   - Il salvataggio deve essere consentito **soltanto in stato IDLE o durante la schermata di riepilogo a fine giornata**, per prevenire stati corrotti derivanti dal salvataggio a metà timer di un'azione.

### Nodo 5: Perimetro e Disciplina del Primo "Vertical Slice"
L'errore più comune nello sviluppo di simulatori musicali complessi è cercare di implementare tutto contemporaneamente (menu, 50 strumenti, concerti con animazioni, 6 generi, festival).
La sezione finale del documento (righe 9289-9357) ha colto perfettamente il punto: il primo vertical slice deve essere un **nucleo minimo rigorosamente verificabile**:
- Passo 1: Creazione personaggio minimale (nome, background base, statistiche di partenza).
- Passo 2: Orologio giornaliero attivo con visualizzazione del tempo e stato IDLE/BUSY.
- Passo 3: Esecuzione di 1 singola azione di allenamento (con consumo di tempo, spesa di energia, guadagno di XP).
- Passo 4: Conclusione della giornata (raggiungimento dello zero, visualizzazione del riepilogo giornaliero, ripristino parziale dell'energia, passaggio al giorno successivo).
- Passo 5: Salvataggio e caricamento dello stato.
Tutto il resto (canzoni, concerti, etichette, band) deve essere innestato sopra questo motore solo dopo che il ciclo vitale di base funziona alla perfezione.

---

## 4. PROPOSTA DI STRUTTURAZIONE MODULARE DEL SOFTWARE

Se viene confermata la scelta di Godot Engine 4 (o un core equivalente in GDScript/Python), l'architettura deve riflettere il principio di **Clean Architecture e Separazione dei Ruoli**:

```
res:// (oppure src/)
├── core/                       # Invarianti, formule pure e configurazioni
│   ├── constants.gd            # Costanti di bilanciamento centralizzate
│   ├── formulas.gd             # Formule matematiche pure (statistiche, XP, qualità)
│   └── enums.gd                # Stati (IDLE, BUSY), generi, ruoli
├── data/                       # Risorse dati statiche e modelli dinamici
│   ├── models/                 # Classi dati runtime (Player, Song, Venue)
│   └── definitions/            # Definizioni statiche (Azioni, Background, Locali)
├── systems/                    # Sistemi logici (DIP, zero dipendenze dirette dalla UI)
│   ├── time_system.gd          # Gestione scorrimento tempo, calendari e stati
│   ├── player_system.gd        # Mutazione risorse, statistiche e abilità
│   ├── action_system.gd        # Esecuzione, convalida e timer delle azioni
│   ├── music_system.gd         # Creazione brani, calcolo qualità
│   ├── concert_system.gd       # Risoluzione concerti e pubblico
│   ├── economy_system.gd       # Transazioni, spese e incassi
│   └── progression_system.gd   # Livelli di carriera e sblocchi
├── autoload/                   # Istanze globali gestite
│   ├── event_bus.gd            # Disaccoppiamento totale a segnali
│   ├── game_manager.gd         # Macchina a stati globale (Menu, Game, Summary)
│   ├── save_manager.gd         # Serializzazione/deserializzazione JSON sicura
│   └── accessibility_manager.gd# Bridge vocale NVDA/SAPI e gestione focus tastiera
└── ui/                         # Interfacce visive accessibili (Sotto-sistema presentation)
    ├── common/                 # Componenti riutilizzabili accessibili
    ├── hud/                    # Barra temporale, stato giocatore, risorse
    ├── menus/                  # Menu principale, creazione personaggio, riepilogo
    └── panels/                 # Pannelli azioni, studio, concerti
```

---

## 6. ALLINEAMENTO MULTI-AI & ISTRUZIONI PER OPENAI CODEX GPT

In conformità al Protocollo 7 ASTRALIS (*Orchestrazione Multi-AI e Collaboratori*), questa sezione definisce il quadro operativo per la cooperazione tra **Antigravity** (AI Primaria e Pair Programmer di Luca) e **OpenAI Codex GPT** (AI Ausiliaria e Revisore).

### 6.1 Struttura Documentale e Mappa Operativa
Il piano originario monolitico [`docs/piani/attivi/World Tour .md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/World%20Tour%20.md) (9.357 righe) è stato formalmente disaccoppiato in un'architettura modulare orchestrata da un coordinatore master:

1. **Coordinatore Master della Roadmap**:
   - [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md): contiene la sequenza delle fasi (Fase 0 $\rightarrow$ Fase 5) con gating deterministico a tre stati (`[ ]`, `[/]`, `[x]`). È il punto di riferimento unico per lo stato di avanzamento reale.
2. **Gli 8 Sottopiani Tematici (per Competenze)** in [`docs/piani/attivi/sottopiani/`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/):
   - [`SP-01`: Game Design, Visione e Progressione](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/01_game_design_visione_e_progressione.md)
   - [`SP-02`: Simulazione Vita, Gestione Tempo e Routine](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/02_simulazione_vita_tempo_e_routine.md)
   - [`SP-03`: Sistema Musicale, Abilità e Creazione Brani](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/03_sistema_musicale_abilita_e_creazione_brani.md)
   - [`SP-04`: Concerti, Locali, Pubblico e Fanbase](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/04_concerti_locali_pubblico_e_fanbase.md)
   - [`SP-05`: Economia, Carriera, Band e Industria](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/05_economia_carriera_band_e_industria.md)
   - [`SP-06`: Formule Matematiche e Bilanciamento](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/06_formule_matematiche_e_bilanciamento.md)
   - [`SP-07`: Architettura Software, Sistemi e Modello Dati](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/07_architettura_software_sistemi_e_modello_dati.md)
   - [`SP-08`: Accessibilità Vocale, Tastiera e Simmetria Universale](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/08_accessibilita_vocale_interfaccia_e_simmetria.md)

### 6.2 Regole di Ingaggio per OpenAI Codex GPT
1. **Punto di Ingresso Obbligatorio**: Prima di rispondere o eseguire compiti di analisi o revisione, consultare [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md) per conoscere la fase attiva e non caricare file non pertinenti al compito circoscritto.
2. **Principio di Dialogo a 2 Tempi & Gating**: Nessuna modifica a codice o documenti senza autorizzazione esplicita ("procedi", "applica", "esegui"). Richieste come "valuta", "cosa ne pensi", "analizza" impongono sola lettura.
3. **Divieto di Spunta Preventiva**: Non modificare gli stati delle checkbox in `[x]` prima che i test tecnici e manuali siano stati effettivamente eseguiti e convalidati con esito positivo da Luca.
4. **Rispetto della Clean Architecture e del Principio di Simmetria Universale**:
   - Nessun accoppiamento diretto tra la UI e i modelli logici.
   - Ogni funzionalità proposta o modificata deve essere al 100% accessibile e navigabile da tastiera con screen reader NVDA (Zero Mouse per Luca) e perfettamente gradevole e funzionante con mouse per Holy Diver.
5. **Pointer DRY**: Evitare duplicazioni testuali; fare riferimento ai documenti di competenza tramite link relativi o `file:///`.

