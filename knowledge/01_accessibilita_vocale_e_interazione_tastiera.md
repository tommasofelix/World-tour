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

---

## 10. Menu Interazioni Popup a Pergamena Pixel Art & Azioni con Durata Temporale (Validato in V5.6.0)

1. **Apertura Contestuale & Annuncio Vocale Lineare**:
   - All'interazione con un arredo interattivo del loft (click del mouse o `Spazio`/`Invio` da tastiera), si apre il componente `InteractionMenu` posizionato accanto all'oggetto con clamping di sicurezza entro i margini 1920x1080 Full HD (rispettando la Top Bar e il Dock inferiore).
   - All'apertura viene emesso un cue sonoro discreto a volume salvavita (`<= 0.75f`) e un annuncio vocale completo per NVDA che include il titolo dell'arredo, il numero di opzioni e l'elenco sequenziale con scorciatoia e durata temporale (es. *"Cucina. 4 azioni disponibili: 1 Prepara espresso (5s), 2 Snack veloce (10s), ..."*).

2. **Navigazione & Scorciatoie Numeriche Immediate (Zero Mouse)**:
   - Ogni opzione è associata al tasto corrispondente sulla tastiera estesa (`1`..`9`) e sul tastierino numerico (`KP_1`..`KP_9`), consentendo l'attivazione istantanea senza navigazione preliminare;
   - In alternativa è attiva la navigazione ciclica con freccia Su / Numpad 8 e freccia Giù / Numpad 2, con conferma tramite Invio / Spazio / KP_Enter;
   - La pressione del tasto `Esc` chiude immediatamente il menu, ripristina lo stato idle e vocalizza la chiusura senza effetti collaterali.

3. **Esecuzione Azioni a Durata Temporale (`duration_seconds`)**:
   - Le azioni con durata `> 0.0` secondi bloccano il protagonista Alex nello stato `GAMEPLAY_BUSY`, impedendo doppi comandi o movimenti concorrenti mentre l'attività è in corso;
   - Il box di dialogo inferiore sinistro visualizza in tempo reale il messaggio di svolgimento e la durata;
   - NVDA riceve un annuncio vocale all'avvio con la durata stimata e un annuncio di completamento all'arrivo a termine con il riepilogo delle modifiche di stato (es. *"Espresso bevuto! Ti senti rinvigorito. Energia +10, Stress -3"*);
   - A fine azione viene riprodotto il cue di notifica posizionale e lo stato del giocatore torna a `GAMEPLAY_IDLE`.

4. **Isolamento Semantico dei Servizi Domestici**:
   - **Guardaroba**: Limitato rigorosamente al cambio look (`wardrobe_change_look` / `cambiarsi_il_look()`), escludendo scorciatoie a finestre esterne per preservare l'immersione nella vita domestica;
   - **Cassa Attrezzi**: Dedicata alla cura artigianale degli strumenti (controllo cavi/jack e manutenzione chitarra), rimuovendo collegamenti diretti all'Upgrades Hub che risiede regolarmente nel dock di carriera.

5. **Sblocco e Gestione Sincrona del Contenitore Modali (`$Modals`) (Validato in V5.6.1)**:
   - In Godot 4, se un nodo contenitore padre (`Modals: Control`) ha `visible = false`, qualsiasi finestra modale figlia (es. `SongCreator`, `LiveConcert`, `TravelModal`, `TourModal`, `FestivalModal`) impostata a `visible = true` rimane completamente invisibile a video e sorda agli eventi di input.
   - Poiché l'evento `modal_opened.emit()` blocca coerentemente il movimento del personaggio (`player.is_movement_locked = true`), l'invisibilità del contenitore causava un deadlock percettivo (il giocatore appariva congelato).
   - Canone di Governance: `ApartmentHud.open_modal()` impone deterministicamente `$Modals.visible = true` prima di attivare la modale figlia, mentre `close_modal()` e `hide_all_modals()` verificano `is_any_modal_open()` nascondendo `$Modals` solo quando non vi sono ulteriori modali aperte.

6. **Contratto di Focus per Finestre Aperte da Arredi (`open()` Grab Focus)**:
   - Ogni finestra modale deve implementare un metodo canonico `open()` che inizializza lo stato, assegna esplicitamente il focus da tastiera (`grab_focus()`) al primo controllo interattivo (es. `edit_title` in `SongCreator`, `opt_venue` in `LiveConcert`, `btn_filter_all` in `SongCatalog`), ed emette contestualmente l'annuncio vocale tramite `AccessibilityManager.announce()`.

7. **Adattamento del Testo e Autowrap nelle Pergamene Pixel Art**:
   - Nelle interfacce a pergamena pixel art con texture fisse, la larghezza standard è fissata a **320 pixel** (Short $320 \times 190$, Medium $320 \times 400$, Long $320 \times 680$) con margini interni di 20 px laterali e 28 px verticali.
   - Tutti i pulsanti di opzione utilizzano `autowrap_mode = TextServer.AUTOWRAP_WORD_SMART` e font bitmap da 8 px, impedendo qualsiasi troncamento o sbordamento visivo di testi lunghi o etichette di durata (`(%ds)`).

---

## 11. Segregazione Tasti Movimento (Zero WASD) & Flusso Ciclo Sonno / DailySummary (Validato in V5.6.2)

1. **Segregazione Inviolabile Movimento vs Scorciatoie Alfanumeriche**:
   - I tasti alfabetici WASD sono categoricamente disabilitati per la navigazione spaziale di Alex. La camminata è affidata al 100% alle Frecce Direzionali (`ui_*`) e al Tastierino Numerico (Numpad 8, 2, 4, 6 e diagonali 7, 9, 1, 3);
   - Questo previene qualsiasi sovrapposizione tra comandi di movimento e scorciatoie mnemoniche: premendo `W` per aprire l'Albo d'Oro (`LegacyModal`), Alex non avvia alcuna camminata verso l'alto dello schermo e la finestra si apre istantaneamente.

2. **Azzeramento Immediato dell'Inerzia all'Apertura Modali**:
   - All'emissione di `modal_opened`, il controller di scena `apartment.gd` impone immediatamente `player.velocity = Vector2.ZERO`, `player.is_movement_locked = true` e `player.cancel_auto_walk()`;
   - Questo garantisce che nessun movimento residuo o vettore pendente possa spostare il personaggio mentre una finestra di interazione, dialogo o modale è a schermo.

3. **Flusso Deterministico del Sonno e Ricezione Daily Summary**:
   - L'azione del sonno notturno (dal letto o dal controllo rapido nel dock) esegue `TimeSystem.trigger_sleep_now()`, che a sua volta attiva `EndDaySystem.process_day_end()`;
   - La notifica del riepilogo giornaliero transita per il segnale dedicato `EventBus.daily_summary_ready(summary_data: Dictionary)`;
   - `ApartmentHud` intercetta il dizionario, attiva la visibilità del genitore `$Modals.visible = true` e invoca `daily_summary_modal.show_summary(summary_data)` con focus immediato su `btn_next_day`;
   - Alla conferma del giorno successivo, il riepilogo si chiude, `$Modals.visible` viene ripristinato a `false` e la libertà di movimento di Alex viene ripristinata per il nuovo giorno, scongiurando qualsiasi blocco o deadlock reattivo.

---

## 12. Blindatura FSM GAMEPLAY_BUSY, Blocco Fisico Input & Zero Freeze SystemMenu (Validato in V5.6.3)

1. **Ciclo di Vita dello Stato `GAMEPLAY_BUSY`**:
   - Quando il giocatore avvia un'azione con durata temporale (routine domestica, suonare la chitarra, preparare il caffè, fare flessioni, o qualsiasi azione coordinata da `ActionSystem`), `GameManager.change_state(Enums.GameState.GAMEPLAY_BUSY)` entra in vigore;
   - All'emissione di `EventBus.action_started`, il controller di scena `apartment.gd` e l'avatar `player_alex.gd` azzerano istantaneamente la velocità (`velocity = Vector2.ZERO`), disarmano l'auto-walk e impongono `player.is_movement_locked = true`;
   - Sia in `_physics_process` che in `_unhandled_input`, la guardia reattiva `is_busy` sopprime qualsiasi comando di movimento (Frecce, Numpad, click mouse) e inibisce i tasti rapidi delle finestre modali;
   - Durante `GAMEPLAY_BUSY`, il salvataggio partita è categoricamente vietato (`SaveManager.is_save_allowed() == false`) per prevenire corruzioni di stato persistente a metà azione.

2. **Interruzione Sicura & Reversibile da Tastiera (`Esc`)**:
   - Premendo il tasto `Esc` durante lo stato `GAMEPLAY_BUSY`, l'azione in corso viene immediatamente interrotta senza consumi indebiti di energia, stress o denaro tramite `ActionSystem.cancel_action()`;
   - L'evento `EventBus.action_canceled` riporta la FSM globale in `GAMEPLAY_IDLE`, sblocca il movimento di Alex, notifica l'annuncio vocale ad alta priorità per NVDA ("Azione interrotta.") e chiude il box di ispezione.

3. **Risoluzione Definitiva Softlock Menu di Sistema (`resume_requested`)**:
   - Nel `SystemMenuModal` aperto con `Esc` a riposo, la chiusura tramite pulsante "Riprendi" o tasto `Esc` emette il segnale specializzato `resume_requested`;
   - `ApartmentHud` connette sia `resume_requested` che `closed` al metodo unificato `close_modal(system_menu_modal)`, garantendo il ripristino di `player.is_movement_locked = false`, la ripresa dell'orologio virtuale (`set_game_paused(false)`) e il ritorno a `GAMEPLAY_IDLE` senza alcun freeze.



