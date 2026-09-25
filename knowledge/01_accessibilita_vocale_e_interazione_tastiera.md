# 01 — Accessibilità Vocale, Interazione da Tastiera & Canale Audio (v3.0.7)

## Stato del Runtime & Accessibilità Attiva
- **Motore & Driver**: Godot Engine 4.7.2 win64 con driver di accessibilità nativo AccessKit (`--accessibility-driver accesskit`, flag `--accessibility always`).
- **Bridge di Sistema**: Integrazione diretta con Windows UI Automation (UIA), esponendo l'albero dei nodi `Control` a NVDA senza intermediari esterni.
- **Canale Speech & Audio**: Modulo `AccessibilityManager` (singleton autoload) per annunci vocali diretti SAPI/NVDA e gestione dei cue sonori.
- **Modalità Operativa**: **100% Tastiera (Zero Mouse)**.

---

## 1. Contratti Permanenti di Navigazione & Focus

1. **Zero Mouse Assoluto**: Ogni schermata, modale, sottomenu o azione deve essere raggiungibile, azionabile e verificabile esclusivamente tramite tastiera (tasti freccia, Tab, Shift+Tab, Invio, Spazio, Esc e tastierino numerico).
2. **Linearità Sequenziale per NVDA**:
   - I menu e i nodi UI devono rispettare l'ordine logico di fruizione nell'albero di scena;
   - Divieto assoluto di informazioni affidate unicamente a differenze cromatiche, animazioni visive o icone prive di testo accessibile;
   - I messaggi e gli errori devono essere testuali, espliciti e annunciabili direttamente dallo screen reader.
3. **Persistenza & Preservazione del Focus**:
   - Il focus da tastiera non deve mai perdersi nel vuoto dopo il completamento di un'azione, la chiusura di una modale o il passaggio di turno;
   - Alla chiusura di una finestra di dialogo o scheda, il focus deve essere riposizionato deterministicamente sul controllo che ha scatenato l'apertura.

---

## 2. Standard di Sonificazione & Volumi di Sicurezza ASTRALIS

1. **Volumi di Sicurezza Anti-Mascheramento (0.7f – 0.8f)**:
   - I volumi di musica di sottofondo, effetti ambientali ed effetti sonori dell'interfaccia devono essere congelati a un valore massimo compreso rigorosamente tra **`0.7f` e `0.8f`** (mai 1.0f pieno);
   - Questa soglia di sicurezza garantisce che il volume di sistema della sintesi vocale di NVDA / SAPI sovrasti sempre con chiarezza qualsiasi emissione sonora del gioco.
2. **Audio Ducking Automatico**:
   - Quando il gioco emette un annuncio vocale prioritario, narrazione o notifica di stato, il bus audio della musica deve abbassarsi istantaneamente (ducking a ~0.3f) per poi risalire gradualmente al termine del parlato.
3. **Transiente Acuto Penetrativo per Segnali Critici**:
   - Gli allarmi di sistema, notifiche di errore o condizioni limite (es. energia azzerata, orario di fine giornata imminente) devono utilizzare campioni sonori dotati di attacco istantaneo e spettro acuto metallico ad alta frequenza, escludendo toni morbidi che verrebbero mascherati dal parlato concorrente.

---

## 3. Pattern Architetturale di Isolamento Modale (Validato in RRU-04)

Durante lo sviluppo è emersa la problematica della lettura concorrente AccessKit tra finestre modali sovrapposte e l'HUD di gioco sottostante (registrata e risolta con successo in RRU-04).

**Regola Architetturale Obbligatoria per Tutte le Modali**:
1. **Occultamento Preventivo dell'HUD**: All'apertura di qualsiasi finestra modale o scheda di lavoro a tutto schermo (Catalogo Brani, Creazione Canzone, Modale Concerti), l'HUD principale deve impostare deterministicamente `$VBoxMain.visible = false`, rimuovendo i propri nodi dall'albero UIA e prevenendo che NVDA legga elementi sottostanti con le frecce.
2. **Backdrop Solido Opaco**: Ogni modale deve integrare alla radice un nodo `Backdrop: ColorRect` a copertura totale dello schermo con colore opaco (`#050508`) e `mouse_filter = 0`, isolando la visuale grafica sia per gli utenti vedenti che per la gerarchia di input.
3. **Ripristino Deterministico**: Alla chiusura della modale, `$VBoxMain.visible = true` viene ripristinato e il focus viene riassegnato al pulsante chiamante con `grab_focus()`.

---

## 4. Criteri di Validazione dell'Accessibilità

Nessuna nuova schermata o componente UI può essere dichiarato conforme sulla sola base del codice. Sono tassativamente richiesti:
1. **Verifica Tecnica del Grafo di Focus**: Controllo delle proprietà `focus_neighbor_*`, `focus_mode = FOCUS_ALL` e assenza di nodi fantasma;
2. **Ispezione UIA / AccessKit**: Verifica dell'annuncio corretto del nome accessibile (`accessible_name`) e del ruolo (`accessible_role`);
3. **Collaudo Manuale Reale di Luca con NVDA**: Prova pratica in-game con screen reader attivo e zero interazione mouse, con verifica della totale fluidità del percorso cognitivo.

---

## 5. Sistema di Navigazione da Tastierino Numerico (Numpad Navigation System)

Per consentire l'utilizzo ergonomico e rapido del gioco con la sola mano destra sul tastierino numerico della tastiera estesa (Zero Mouse), `AccessibilityManager` e i controller dell'interfaccia implementano uno schema canonico di mapping universale:
1. **Navigazione a Croce Ortogonale**:
   - `KP_8`: Navigazione in alto (`ui_up`);
   - `KP_2`: Navigazione in basso (`ui_down`);
   - `KP_4`: Navigazione a sinistra (`ui_left`);
   - `KP_6`: Navigazione a destra (`ui_right`).
2. **Azionamento & Selezione**:
   - `KP_ENTER` / `KP_0`: Attivazione del controllo corrente (`ui_accept`).
3. **Interrogazione dello Stato**:
   - `KP_5`: Annuncio vocale immediato dello stato, del testo e della descrizione accessibile del controllo correntemente focalizzato.
4. **Salto a Blocchi Logici**:
   - `KP_7`: Salto al blocco logico precedente dell'interfaccia (es. da Azioni a Macro-Aree o da Macro-Aree a Top Bar);
   - `KP_9`: Salto al blocco logico successivo.
5. **Macro-Aree Tematiche**:
   - `KP_1`..`KP_4`: Selezione diretta delle 4 Macro-Aree di gioco (Area 1: Hub Personale, Area 2: Creazione, Area 3: Carriera, Area 4: Upgrades).
6. **Controlli Runtime & Sicurezza**:
   - `KP_ADD` (+): Aumento velocità virtuale (1x, 2x);
   - `KP_SUBTRACT` (-): Pausa / Riprendi simulazione temporale;
   - `KP_DECIMAL` (Punto / Canc del Numpad): Silenziamento istantaneo dell'annuncio vocale corrente e arresto dei cue sonori (`silence()`).
7. **Guardia Campi di Digitazione**:
   - Se il controllo focalizzato è un campo di inserimento testo (`LineEdit`, `TextEdit`), i tasti del tastierino inseriscono le rispettive cifre numeriche senza intercettazione da parte dei comandi di navigazione.

---

## 6. Sintesi Procedurale di Earcons in Memoria (`AudioCueSystem`)

1. **Zero File Binari Esterni**:
   - I segnali audio di interfaccia (Earcons / Audio Cues) vengono sintetizzati proceduralmente in memoria a runtime in formato standard PCM 16-bit mono a 22.050 Hz (`AudioStreamWAV`).
   - Questo approccio elimina il rischio di file binari `.wav` mancanti o corrotti, evita il rigonfiamento del repository Git e garantisce la perfetta esecuzione a 0 ms nei test headless.
2. **Volumi di Sicurezza & Caching**:
   - Il volume base è congelato deterministicamente a `0.75f` (-2.5 dB `AUDIO_MAX_VOLUME_DB`).
   - Gli stream generati sono indicizzati in una cache dizionario interna per azzerare il carico CPU dopo il primo ascolto.
3. **Ducking Dinamico al 40%**:
   - All'emissione di qualsiasi sintesi vocale da parte di `AccessibilityManager.announce()` o `speak()`, `AudioCueSystem.set_ducking(true)` attenua il volume al 40% (`AUDIO_DUCKING_RATIO = 0.40`), ripristinandolo a fine parlato o su silenziamento.
4. **Protezione Dummy Audio Driver nei Runner Headless**:
   - Nei test eseguiti con `--headless`, il driver audio fittizio di Godot 4 non consuma i frame di riproduzione. L'invocazione di `play()` su `AudioStreamPlayer` viene protetta da `if DisplayServer.get_name() != "headless":`, mentre la generazione e caching dello stream, il calcolo dei volumi e il ducking rimangono convalidati al 100% prevenendo memory leak nel registro ObjectDB dell'engine.

---

## 7. Disaccoppiamento Gerarchico dell'Input: Autoload vs Controller di Scena

1. **Segregazione dei Ruoli di Input**:
   - Gli Autoload globali (come `AccessibilityManager`) sono riservati esclusivamente all'accessibilità di sistema e all'orientamento universale: gestione del tastierino numerico Numpad e tasto di emergenza per silenziamento immediato (`silence()`).
   - È fatto divieto di mappare tasti alfanumerici della tastiera principale (`1`..`4`, `T`, `R`, `C`, `Space`, ecc.) all'interno degli Autoload.
2. **Prevenzione del Mascheramento (Input Shadowing)**:
   - In Godot, un Autoload che consuma eventi tramite `_unhandled_input` può intercettare o mascherare prematuramente comandi destinati all'interfaccia attiva (`HUD` o finestre modali).
   - Mantenendo i tasti contestuali unicamente nei controller di scena e proteggendoli con guardie `if _is_any_modal_open(): return`, si garantisce che la digitazione e i comandi di navigazione fluiscano linearmente senza interferenze o conflitti di priorità.

---

## 8. Pattern "Zero Focus Drop" per Controlli Inattivi & Focus Chaining Ciclico (Validato in V5.3.0)

1. **Il Principio di Zero Focus Drop**:
   - In Godot Engine, impostare la proprietà nativa `disabled = true` su un `Button` provoca la perdita di focusabilità da tastiera (il controllo viene saltato durante la navigazione con frecce e Tab).
   - Per un utente non vedente che esplora una schermata sequenzialmente con screen reader NVDA, la scomparsa invisibile di un pulsante (come "Carica Partita" in assenza di salvataggi) crea disorientamento cognitivo e fa credere che la funzionalità manchi del tutto dal gioco.
   - **Canone Operativo**: Il controllo deve rimanere focalizzabile (`focus_mode = FOCUS_ALL`). La sua descrizione semantica via `AccessibilityManager.hook_control_accessibility()` viene arricchita dinamicamente per informare esplicitamente lo screen reader (es. *"Carica Partita, Pulsante. Nessun salvataggio trovato su disco"*). Se azionato, il pulsante non crasha e vocalizza un feedback informativo chiaro senza alterare la FSM di gioco.

2. **Focus Chaining Ciclico Bidirezionale (Anello Continuo Zero Mouse)**:
   - Nei menu e pannelli, i controlli devono formare una catena chiusa tramite `focus_neighbor_top` e `focus_neighbor_bottom`:
     - Dal primo elemento ("Nuova Partita"), premendo freccia Su si salta all'ultimo elemento ("Esci al Desktop");
     - Dall'ultimo elemento, premendo freccia Giù si torna al primo.
   - Questo meccanismo azzera i vicoli ciechi e consente una navigazione rapida e circolare adatta a sessioni prolungate senza mouse.

---

## 9. Clearance Geometrica Anti-Overlap & Focus Isolation per HUD Sovrimpressi (Validato in V5.5.0)

1. **Prevenzione Focus Drop su Controlli Secondari Sovrimpressi (`focus_mode = FOCUS_NONE`)**:
   - Quando un HUD perimetrale o un dock sovrimpresso risiede su un `CanvasLayer` sopra una scena esplorabile (come il Loft NYC), i pulsanti dell'HUD non devono intercettare il ciclo logico da tastiera di `Tab` e `Shift+Tab`.
   - Assegnando esplicitamente `focus_mode = Control.FOCUS_NONE` a tutti i pulsanti del dock e ai controlli del tempo, il tasto `Tab` rimane dedicato al 100% alla navigazione degli arredi interattivi della stanza, mentre i pulsanti dell'HUD restano azionabili direttamente tramite shortcut dedicati (`1`..`5`, `P`, `V`, `Z`, `X`) per Luca e tramite click sinistro per Holy Diver.

2. **Canone della Clearance Geometrica Orizzontale a 3 Blocchi**:
   - In un layout Full HD 1920x1080 con tre blocchi orizzontali sulla stessa fascia (es. Dialogo a sinistra, Dock al centro, Info a destra), la clearance tra l'estremità destra del primo blocco e l'estremità sinistra del secondo deve essere `>= 80 pixel` (ideale 100–120 px).
   - Nelle test suite headless deve essere sempre inserita un'asserzione geometrica esplicita (`assert_true(dialogue_right < dock_left)`) a 0 ms per impedire regressioni visive in caso di aggiunta di pulsanti o variazioni di testo.

