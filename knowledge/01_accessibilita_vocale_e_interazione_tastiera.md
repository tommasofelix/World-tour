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
