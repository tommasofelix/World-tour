# Piano Tecnico Operativo — Gameplay Grafico 2.5D, Loft NYC & Interazione Arredi (Versione AVF V5.4.0)
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.10 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-24
# Stato: [x] [CONVALIDATO CON SUCCESSO] — Sotto-Fase 1B e Collaudo Fase 2 Conclusi (Tutti i test verdi: 30/30 suite, 68/68 appartamento) — Versione AVF V5.4.0
# File Piano: docs/piani/completati/PIANO_GAMEPLAY_GRAFICO_APPARTAMENTO.md
# Coordinatore Master: docs/todo.md
# Baseline AVF: V5.3.0 (Target Versione: V5.4.0)

---

## 🎯 1. OBIETTIVO E PERIMETRO DELL'OPERA

Dopo il successo del restyle grafico del Menu Principale in pixel art retrò arcade 16/32-bit (V5.3.0) e il consolidamento delle 29 suite headless del simulatore musicale, il progetto compie il suo salto evolutivo più ambizioso: **la transizione da un gameplay a sole dashboard/HUD a un mondo esplorabile grafico 2.5D isometrico interattivo**.

### Visione Fondamentale
Il giocatore controlla **Alex** (il rocker/punk con giubbotto di pelle e cresta blu) all'interno del suo loft/appartamento di partenza a New York.  
Alex può camminare liberamente nella stanza, evitare ostacoli tramite collisioni fisiche realistiche e avvicinarsi ai diversi arredi della casa per usufruire di **tutte le funzionalità e i sistemi di simulazione già sviluppati**, integrati organicamente nel mondo di gioco.

### Accessibilità Assoluta & Simmetria Universale (Luca & Holy Diver)
Il gameplay grafico 2.5D è progettato nativamente con il principio di **Simmetria Universale**:
- **Per Holy Diver (a monitor con mouse/tastiera)**: grafica pixel art isometrica dettagliata a 16/32-bit, animazioni fluide di Alex (camminata in 4 direzioni), Y-sorting per profondità visiva, prompt grafici d'interazione in stile cyberpunk neon, inspection box narrativa in basso a sinistra e indicatori HUD vitali.
- **Per Luca (con sintesi vocale NVDA e tastiera completa — ZERO MOUSE)**:
  - **Canale Fisico**: movimento diretto tramite Frecce direzionali, WASD o Numpad (8/2/4/6/7/9/1/3), con feedback acustico discreto di collisione (bump audio a volume di sicurezza <= 0.75f) per percepire fisicamente pareti e ostacoli, e chime di prossimità all'avvicinamento di un hotspot;
  - **Canale Logico Assistito (Ciclo Hotspot)**: pressione del tasto `Tab` / `Shift+Tab` o dei tasti `Numpad 7` / `Numpad 9` per scorrere sequenzialmente tutti gli oggetti della stanza, con lettura vocale immediata di nome e funzione; pressione di `Invio`/`Spazio` per camminare automaticamente verso l'oggetto o interagire direttamente;
  - **Conservazione Inviolabile dei 15 Tasti Rapidi HUD**: tutti i tasti rapidi storici (`Esc`, `1`..`4`, `P`, `K`, `N`, `L`, `B`, `I`, `V`, `O`, `F`, `Y`, `H`, `U`, `R`, `W`) rimangono attivi a riposo per consentire l'accesso istantaneo a qualsiasi sistema senza dover necessariamente camminare.

---

## 🛡️ 2. PROTOCOLLO 12 — I 6 CANCELLI INVIOLABILI (INNER CODEX)

- **Cancello 1 (Rifiuto Patching Euristico & Root Cause Analysis)**:
  - L'ordinamento visivo e la profondità non utilizzano offset `z_index` arbitrari cablati nel codice, ma sfruttano il motore nativo di Godot 4: `y_sort_enabled = true` sia sulla radice della stanza che sui nodi figli (mobili e personaggio).
  - La scala degli sprite del personaggio (originariamente generati a risoluzione superiore ~220x520) viene calibrata con proporzioni pixel art matematiche rigorose rispetto ai mobili (~100-150px) e alla griglia isometrica.
- **Cancello 2 (Hardware Grounding & Zero Mouse)**:
  - Nessuna interazione, selezione o movimento richiede il puntatore del mouse.
  - L'interazione con gli hotspot avviene premendo `Spazio` o `Invio` quando Alex si trova nell'Area2D di trigger, oppure selezionando l'arredo dalla lista ciclica accessibile per NVDA.
- **Cancello 3 (Hitbox, Clearance Continua & Volumi Sicuri)**:
  - **Hitbox ai piedi**: Alex utilizza una `CollisionShape2D` ellittica o capsulare ristretta alla base dei piedi (non sull'intero busto), garantendo scorrimento continuo lungo pareti e bordi dei mobili senza incastri angolari.
  - **Volumi protetti**: tutti i segnali acustici (passi, urti contro pareti, chime di rilevamento hotspot) sono congelati deterministicamente al livello di sicurezza $\le 0.75\text{f}$ (-2.5 dB) con ducking al 40% durante la voce di NVDA.
- **Cancello 4 (Named Contracts D0..DN / S1..SN)**:
  - Suddivisione atomica del piano in contratti formali indipendenti e sequenziali.
- **Cancello 5 (Determinismo Headless)**:
  - Tutti i sistemi, il controller del giocatore e il router degli arredi sono coperti da suite di test headless a 0 ms senza dipendenze da loop temporali o `OS.delay()`.
- **Cancello 6 (Budget Token & Anti-Bloat Normativo)**:
  - Struttura modulare e chiara; link relativi markdown; router e controller $\le 250$ righe di codice ciascuno.

---

## 🗺️ 3. MAPPATURA HOTSPOT ARREDI <-> SISTEMI DI GIOCO ESISTENTI

Ogni elemento presente nell'appartamento di partenza (come visibile nel concept grafico e negli sprite in `assets/img/gameplay/casa/camera/stanza_iniziale`) è associato biunivocamente a un sistema di simulazione di *World-tour*:

1. **Chitarra su Supporto / Amplificatori (`chitarra_arancione.png`, `cassa_suono.png`)**:
   - *Funzioni*: Esercitazione rapida (Allenamento XP / `btn_practice`), Scrittura e composizione brani (`SongCreator`), Accordatura / Manutenzione usura liutaio;
   - *Tasto rapido alternativo*: `P` (Pratica) o `N` (Nuovo brano).
2. **Cucina & Macchina del Caffè (`cucina_semplice.png`)**:
   - *Funzioni*: Azione di recupero attivo diurno "Pausa Caffè" (+15 Energia, +5 Stress, costo 2.00 €) o preparazione spuntino;
   - *Sistema collegato*: `RelaxModal` / `PlayerData`.
3. **Divano Vissuto & Tavolino (`divanno_vissuto.png`, `tavolino.png`)**:
   - *Funzioni*: Relax passivo, recupero da stress psicologico, lettura riviste musicali, riflessione;
   - *Sistema collegato*: `RelaxModal` (opzione 2 "Passeggiata / Relax").
4. **Giradischi & Mensola Vinili (`giradischi.png`)**:
   - *Funzioni*: Ascolto disco capolavoro (-10 Stress, +20 Morale, 35% chance Scintilla Creativa per brani storici);
   - *Sistema collegato*: `RelaxModal` (opzione 3) / `MusicSystem`.
5. **Letto Singolo (`letto.png`)**:
   - *Funzioni*: "Dormi in anticipo" (Z), "Riposo / Avanza tempo" (X), Chiusura e avanzamento della giornata lavorativa;
   - *Sistema collegato*: `EndDaySystem`, `CalendarData`, `btn_sleep`, `btn_wait`.
6. **Cabinato Arcade Retrò (`arcade.png`)**:
   - *Funzioni*: Svago arcade vintage, distensione morale band, minigioco di concentrazione ritmica;
   - *Sistema collegato*: Bonus Morale e distensione stress.
7. **Scrivania, Telefono & Computer / Bacheca**:
   - *Funzioni*: Gestione Band (`BandHub`), Contratti ed etichetta discografica (`IndustryHub`), Social Media BandFeed (`SocialModal`), Hit Parade e rivali (`ChartModal`), Calendario impegni e festival (`FestivalModal`);
   - *Tasti rapidi alternativi*: `B`, `I`, `Y`, `H`, `F`.
8. **Armadio & Cassa Attrezzi (`armadio.png`, `cassa_attrezzi.png`)**:
   - *Funzioni*: Scheda del Personaggio (`CharacterSheet`), Upgrade abitazione e strumentazione da studio (`UpgradesModal`), Manutenzione corde e muletto van;
   - *Tasti rapidi alternativi*: `C`, `U`.
9. **Porta d'Uscita del Loft**:
   - *Funzioni*: Uscita sulla mappa cittadina di New York, spostamento verso i locali live (`LiveConcert`), tournée interurbana (`TourModal`) o viaggi aerei (`TravelModal`);
   - *Tasti rapidi alternativi*: `L`, `O`, `V`.

---

## 📐 4. SCOMPOSIZIONE ATOMICA IN NAMED CONTRACTS

### 🧹 CONTRATTO D0: Clean Sweep, Asset Audit & Configurazione Pixel Art
- **D0.1 (Archiviazione Piani)**: Spostamento formale di `PIANO_ESPANSIONE_POST_V5_1_ENDLESS_HORIZON_E_POLISH.md` da `docs/piani/attivi/` a `docs/piani/completati/` con marcatura definitiva `[x] [CONVALIDATO CON SUCCESSO]`;
- **D0.2 (Audit Asset Grafici)**: Verifica integrità e mappatura degli sprite in `assets/img/gameplay/casa/camera/stanza_iniziale/` e del set animazioni di Alex in `personaggio_prova/`;
- **D0.3 (Configurazione Texture Filter)**: Garanzia che tutte le texture 2D del gameplay utilizzino il filtro Nearest (senza sfuocature o anti-aliasing spurio) per preservare la nitidezza del pixel art retrò 16/32-bit.

### 🏠 CONTRATTO S1: Scena Loft Appartamento NYC, Confini & Y-Sorting
- **S1.1 (Scena Principale Loft)**: Creazione di `scenes/apartment/apartment.tscn` e `apartment.gd`:
  - Radice `Node2D` con `y_sort_enabled = true`;
  - Pavimento in legno scuro con tappeto centrale (`pavimento_legno_scuro_type_1.png` / `pavimento_legno_scuro_tappeto_type1.png`);
  - Muri perimetrali ad angolo e finestre con luce dorata (`muro_angolo_*.png`, `finestra_*.png`);
- **S1.2 (Collisioni Perimetrali)**:
  - `StaticBody2D` perimetrale con segmenti di collisione chiusi che impediscono al personaggio di uscire dai bordi calpestabili della stanza;
- **S1.3 (Telecamera 2D Calibrata)**:
  - `Camera2D` centrata sul loft, con smoothing dolce, zoom calibrato per risoluzione 1920x1080 e limiti stanza fissi (`limit_left`, `limit_top`, `limit_right`, `limit_bottom`).

### 🚶 CONTRATTO S2: Personaggio Alex — Movimento, Animazioni & Collisione ai Piedi
- **S2.1 (Nodo Player CharacterBody2D)**: Creazione di `scenes/apartment/player_alex.tscn` e `player_alex.gd`:
  - `CharacterBody2D` con `y_sort_enabled = true`;
  - `CollisionShape2D` ellittica posizionata esclusivamente alla base dei piedi per garantire clearance fluida attorno agli arredi;
- **S2.2 (Sprite Animati 4 Direzioni)**:
  - Configurazione di `AnimatedSprite2D` con gli 8 stati direzionali:
    * `idle_down` (`fermo_giu.png`), `idle_up` (`fermo_su.png`), `idle_left` (`fermo_sinistra.png`), `idle_right` (`fermo_destra.png`);
    * `walk_down` (`giu-1.png`, `giu-2.png`), `walk_up` (`in_su-1.png`, `in_su-2.png`), `walk_left` (`sisnistra-1.png`, `sinistra-2.png`), `walk_right` (`destra-1.png`, `destra-2.png`);
- **S2.3 (Controller di Movimento Multi-Periferica)**:
  - Movimento continuo con velocità calibrata (es. 200 px/s);
  - Supporto per Frecce direzionali, tasti `WASD` e croce ortogonale del tastierino numerico (`Numpad 8/2/4/6/7/9/1/3`);
  - Blocco del movimento quando una finestra modale o un dialogo è aperto (`GameManager.is_paused()` o `_is_modal_open`).

### 🛋️ CONTRATTO S3: Hotspot Interattivi (InteractiveProp) & Arredi Loft
- **S3.1 (Classe Base InteractiveProp)**: Creazione di `scenes/apartment/interactive_prop.gd`:
  - Eredita da `Area2D` con `y_sort_enabled = true`;
  - Possiede un nodo figlio `StaticBody2D` per la collisione fisica solida (impenetrabile) e `Sprite2D` per la visualizzazione dell'arredo;
  - Segnali: `interaction_triggered(prop_id: String)`, `player_entered(prop_id: String)`, `player_exited(prop_id: String)`;
  - Supporto per balloon/prompt visivo in sovrimpressione: icona interazione e nome oggetto (es. "Chitarra Acustica [Spazio]");
- **S3.2 (Istanziazione e Posizionamento Arredi)**:
  - Disposizione ordinata di tutti i 9 arredi interattivi secondo il layout del concept art allegato:
    1. Letto (`letto.png`);
    2. Cucina (`cucina_semplice.png`);
    3. Divano vissuto (`divanno_vissuto.png`) e Tavolino (`tavolino.png`);
    4. Giradischi (`giradischi.png`);
    5. Chitarre e amplificatori (`chitarra_arancione.png`, `cassa_suono.png`);
    6. Cabinato Arcade (`arcade.png`);
    7. Armadio e Cassa attrezzi (`armadio.png`, `cassa_attrezzi.png`);
    8. Scrivania e telefono;
    9. Porta d'uscita per New York.

### 🎧 CONTRATTO S4: Accessibilità Assoluta NVDA (Doppio Canale & Zero Mouse)
- **S4.1 (Feedback Acustico di Collisione Pareti/Ostacoli)**:
  - Quando Alex tenta di muoversi ma il vettore velocità viene bloccato da una collisione (`get_slide_collision_count() > 0`), viene emesso a intervalli controllati un lieve earcon attenuato (bump audio a volume $\le 0.75\text{f}$), consentendo a Luca di percepire l'orientamento spaziale e i confini della stanza;
- **S4.2 (Chime di Rilevamento Prossimità)**:
  - All'ingresso di Alex nell'area di un hotspot, emissione di un delicato chime acustico discreto e annuncio vocale leggero dello screen reader (es. *"Vicino a: Chitarra acustica"*);
- **S4.3 (Canale Logico: Scorrimento Ciclico Hotspot via Tab / Numpad)**:
  - Premendo `Tab` / `Shift+Tab` o `Numpad 7` / `Numpad 9`, il focus logico scorre in ordine lineare tutti gli arredi della stanza;
  - NVDA annuncia istantaneamente: *"Oggetto X di Y: [Nome Arredo] — [Descrizione e azione]"*;
  - Premendo `Invio` o `Spazio`:
    * Opzione 1: Alex cammina automaticamente verso l'arredo e attiva l'interazione;
    * Opzione 2: Interazione diretta istantanea con posizionamento di Alex davanti all'oggetto.

### 🎮 CONTRATTO S5: In-Game HUD Pixel Art & Integrazione con i Sistemi Esistenti
- **S5.1 (HUD In-Game Sovrimpresso fedele al Concept)**: Creazione di `ui/apartment_hud/apartment_hud.tscn`:
  - **In alto a sinistra**: Ritratto di Alex in pixel art con cresta blu, Livello di Carriera, barre colorate per Energia, Stress e Morale;
  - **In alto a destra**: Orologio di gioco, Fase della giornata, Giorno del mese e Minimappa orientativa del loft;
  - **In basso a sinistra**: Dialogue & Inspection Box narrativa in pixel art cyberpunk con font `PressStart2P.ttf`, ritratto del personaggio e testo contestuale (es. *"Chitarra acustica... ha bisogno di corde nuove. Posso sistemarla?"*);
  - **In basso a destra**: Indicatore locale ("NYC - LOFT APARTMENT") e saldo fondi liquidi ("$ 150");
- **S5.2 (Router Hotspot <-> Modali di Gioco)**:
  - L'attivazione di ciascun arredo apre la modale corrispondente già esistente e convalidata nel progetto (`SongCreator`, `RelaxModal`, `LiveConcert`, `UpgradesModal`, `BandHub`, `IndustryHub`, `SocialModal`, `FestivalModal`, `TourModal`, `TravelModal`, `DailySummary`);
  - La chiusura della modale con `Esc` o `Annulla` restituisce fluidamente il controllo al movimento di Alex nel loft senza perdite di stato;
- **S5.3 (Conservazione dei 15 Tasti Rapidi HUD Diretti)**:
  - I tasti rapidi globali dell'HUD restano pienamente attivi anche durante l'esplorazione della stanza.

### 🧪 CONTRATTO S6: Blindatura Headless, Integrazione Main Menu & Convalida Globale
- **S6.1 (Collegamento Main Menu -> Loft)**:
  - La selezione di "Nuova Partita" o "Carica Partita" nel Menu Principale esegue la transizione verso `scenes/apartment/apartment.tscn` anziché direttamente al vecchio HUD testuale;
- **S6.2 (Suite di Test Headless Dedicata)**:
  - Creazione di `tests/test_apartment_gameplay.gd` e `test_apartment_gameplay.tscn`:
    * Verifica istanziazione della stanza, pareti e arredi;
    * Test di movimento, collisioni fisiche e arresto del personaggio;
    * Test del ciclo hotspot con tasto Tab e annunci AccessKit per NVDA;
    * Test di apertura/chiusura modali e ripristino stato di movimento;
- **S6.3 (Verifica Globale a 0 Errori)**:
  - Esecuzione delle 30 suite headless complessive del progetto, con 100% superamento a 0 ms e zero regressioni.

---

## ⚖️ 5. VALIDAZIONE PREVENTIVA SUI 7 ASSI DI QUALITÀ ASTRALIS

- **Asse 1 — Validità**: Rispetto rigoroso dei tipi statici GDScript 2.0, uso dei nodi 2D standard di Godot 4 (`CharacterBody2D`, `StaticBody2D`, `Area2D`, `Camera2D`, `CanvasLayer`) e conformità Clean Architecture.
- **Asse 2 — Efficacia**: Risoluzione diretta del requisito di Luca: un gameplay grafico interattivo e vivo dove il personaggio esplora liberamente l'appartamento e accede a tutti i sistemi di gioco toccando gli arredi.
- **Asse 3 — Coerenza**: Perfetta armonia stilistica con il Menu Principale retrò arcade 16/32-bit (`PressStart2P.ttf`, temi neon, palette cromatica cyberpunk/rock del concept).
- **Asse 4 — Completezza**: Copertura integrale di movimento, collisioni, animazioni, Y-sorting, feedback sonori bump, accessibilità NVDA Zero Mouse e collegamento di tutti i sistemi di simulazione.
- **Asse 5 — Precisione**: Modifiche modulari chirurgiche; i sistemi logici core (`GameManager`, `EventBus`, `SaveManager`, `MusicSystem`, `ConcertSystem`) non subiscono alterazioni distruttive, ma vengono invocati come destinatari delle interazioni.
- **Asse 6 — Affidabilità & Prestazioni**: Rendering 2D leggero a 60 fps fissi, risorse texture ottimizzate, zero memory leak e test seams headless a 0 ms.
- **Asse 7 — Assenza Regressioni & Prevenzione Anomalie**: Tutte le 29 suite di test preesistenti continuano a girare con 0 errori a 0 ms; i salvataggi pregressi mantengono totale compatibilità.

---

## 🧪 6. I 3 LIVELLI DI SIMULAZIONE PREVENTIVA

1. **Livello 1 — Happy Path (Flusso Lineare Ottimale)**:
   - Avvio partita -> Alex compare al centro del loft -> movimento fluido con frecce/WASD/Numpad -> avvicinamento alla chitarra -> chime acustico + balloon visivo + annuncio NVDA -> pressione Spazio -> apertura modale `SongCreator` -> composizione brano -> chiusura con Esc -> Alex riprende a camminare liberamente nel loft.
2. **Livello 2 — Flussi Alternativi & Concorrenti**:
   - Alex cammina contro un muro o il retro del divano: la collisione impedisce il passaggio, emette un lieve bump sonoro senza bloccare il motore né generare jitter;
   - Luca usa il tasto `Tab` per scorrere gli arredi della stanza senza muovere Alex: ogni arredo viene annunciato con chiarezza da NVDA; premendo `Invio` Alex raggiunge l'oggetto e apre il menu;
   - Pressione diretta di un tasto rapido HUD (es. `Esc` per SystemMenu o `B` per BandHub): la modale si apre istantaneamente mettendo in pausa il movimento del giocatore.
3. **Livello 3 — Corner Cases & Condizioni Limite**:
   - Spawn o caricamento partita: Alex viene posizionato sempre in uno spazio calpestabile con clearance verificata (mai sovrapposto a mobili o collisioni);
   - Transizione notte/giorno automatica (scadenza timer giornata a mezzanotte/04:00): il ciclo di Fine Giornata (`DailySummary`) si apre in sovrimpressione sicura senza causare glitch di animazione o loop di input;
   - Tentativo di apertura modali multiple o rapide: la guardia predittiva `_is_any_modal_open()` impedisce sovrapposizioni o perdite di focus.

---

## 🚦 7. PIPELINE OPERATIVA & GATING FORMALE

- **Sotto-Fase 1A (Questo Documento)**: Stesura e validazione del Piano Tecnico Formale in `docs/piani/attivi/PIANO_GAMEPLAY_GRAFICO_APPARTAMENTO.md`.
- **🛑 STOP OBBLIGATORIO**: Attesa dell'assenso esplicito di Luca (*"procedi"*, *"applica"*, *"esegui"*) prima di creare scene, script o modificare configurazioni di progetto (Sotto-Fase 1B).
- **Sotto-Fase 1B**: Realizzazione tecnica dei Contratti D0, S1, S2, S3, S4, S5, S6 con blindatura test headless a 0 ms.
- **Fase 2**: Collaudo pratico manuale congiunto di Luca (tastiera/NVDA) e Holy Diver (monitor/mouse).
- **Fase 3**: Consolidamento Git, aggiornamento Living Documentation (`todo.md`, `CHANGELOG.md`, `README.md`) e calcolo versione AVF V5.4.0.
- **Fase 4**: Auto-Apprendimento Continuo (Doppio Binario).

---

## 🔧 8. CONTRATTI DI REVISIONE & AFFINAMENTO POST-COLLAUDO (RRU-22 — OPZIONE 2)

A seguito del primo collaudo della Fase 2 e della diagnosi approfondita con Luca e Holy Diver, vengono definiti i seguenti 4 Contratti di Rifinitura (PRAPI):

### 🧱 CONTRATTO R1: Ricostruzione Planimetrica Isometrica Rigorosa (Matrice 5x5)
- **R1.1 (Griglia Pavimento Seamless)**: Generazione ordinata di $5 \times 5$ piastrelle (25 tessere) con formula isometrica 2:1 esatta:
  $$X(u, v) = (u - v) \times 100, \quad Y(u, v) = (u + v) \times 50$$
  con $u \in [0, 4], v \in [0, 4]$. Tappeto rosso centrale (`pavimento_legno_scuro_tappeto_type1.png`) collocato nelle celle centrali e parquet scuro continuo su tutte le restanti. Zero fessure, zero buchi, perfetta continuazione visiva.
- **R1.2 (Pareti Raccordate & Finestra)**: Mura posteriori collocate lungo i vettori perimetrali superiori: vertice d'angolo a $(0, -50)$ con `muro_angolo_type2.png`, parete sinistra raccordata con finestra industriale (`finestra_type2.png`), e parete destra raccordata con mattoni a vista (`muro_destra_type2.png`).
- **R1.3 (Perimetro di Collisione Esatto)**: Tracciamento del `CollisionPolygon2D` esattamente lungo i 4 vertici estremi della griglia del pavimento: Top $(0, -50)$, Right $(500, 250)$, Bottom $(0, 450)$, Left $(-500, 250)$, impedendo categoricamente ad Alex di uscire dalla superficie piastrellata.

### 🛋️ CONTRATTO R2: Riposizionamento Arredi & Porta d'Uscita Coerente
- **R2.1 (Arredi 100% Interni al Pavimento)**: Tutti i 9 arredi ricollocati su coordinate verificate con clearance di almeno 80-120 px per il passaggio di Alex:
  - Banco di Scrittura / Chitarra Acustica & Ampli (`guitar`): $(200, 160)$
  - Divano Vissuto & Tavolino (`couch`): $(-200, 150)$
  - Caffè & Cucina (`kitchen`): $(-80, 20)$
  - Giradischi & Vinili (`turntable`): $(-170, 70)$
  - Letto Singolo (`bed`): $(180, 50)$
  - Armadio & Scheda Artista (`wardrobe`): $(80, 20)$
  - Cabinato Arcade Vintage (`arcade`): $(-60, 270)$
  - Cassa Attrezzi & Gear (`toolbox`): $(130, 240)$
  - Tavolino da Caffè (`CoffeeTable`): $(-120, 190)$
  - Cestino (`Bin`): $(-20, 80)$
  - Spawning Alex: $(0, 160)$ al centro della stanza.
- **R2.2 (Sostituzione Speaker con Grafica Porta/Uscita)**: Rimozione dell'erronea cassa acustica dalla porta; creazione e posizionamento di un asset grafico coerente per l'uscita ("ESCI A NEW YORK") sul pavimento a $(-260, 280)$.

### 🛡️ CONTRATTO R3: Blindatura Runtime Anti-Freeze & Anti-Deadlock TTS Windows
- **R3.1 (Debounce & Rate-Limit TTS in AccessibilityManager)**:
  - Deduplicazione annunci identici entro 400 ms;
  - Separazione protetta tra `DisplayServer.tts_stop()` e `DisplayServer.tts_speak()` per evitare race condition nella coda audio COM OneCore/SAPI di Windows;
  - Rimozione del polling intensivo `tts_is_speaking()` ad ogni frame in `_process()`, sostituito da gestione a timer/durata stimata.
- **R3.2 (Safety Watchdog & Cancel su Auto-Walk in PlayerAlex)**:
  - Timeout massimo di sicurezza di 2.0 secondi su `walk_to_target()`;
  - Rilevamento arresto/stallo (se la posizione rimane costante per oltre 0.35s contro un ostacolo, l'auto-walk viene concluso);
  - Interruzione immediata di auto-walk non appena il giocatore tocca un tasto di movimento manuale (Frecce, WASD, Numpad), garantendo che Luca non perda mai il controllo della tastiera.

### ⏱️ CONTRATTO R4: Integrazione Process Temporale e Azioni in ApartmentHud
- **R4.1 (Avanzamento Tempo e Azioni)**: Inserimento in `apartment_hud.gd` dell'istanza di `ActionSystem` e chiamata in `_process(delta)` a:
  - `GameManager.time_system.advance_time(delta)`
  - `action_system.update_action(delta)`
- **R4.2 (Collegamento Segnale Relax)**: Connessione di `relax_modal.activity_selected` a `action_system.start_action(action)`, garantendo la corretta risoluzione delle attività di recupero diurno senza blocchi della FSM.
