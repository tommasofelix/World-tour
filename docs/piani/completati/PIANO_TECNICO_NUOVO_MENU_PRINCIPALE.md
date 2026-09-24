# Piano Tecnico Operativo — Restyle Grafico & Accessibilità del Menu Principale (ASTRALIS v3.0.7)
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-24
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Collaudato con esito eccezionale in-game con NVDA da Luca e 29/29 suite headless verdi)
# File Piano: docs/piani/completati/PIANO_TECNICO_NUOVO_MENU_PRINCIPALE.md
# Coordinatore Master: docs/todo.md

---

## 🎯 1. OBIETTIVO E PERIMETRO DELL'INTERVENTO

Implementazione della nuova interfaccia grafica e accessibile per il Menu Principale (`res://ui/main_menu/main_menu.tscn`), fedele al concept visuale in pixel art 16/32-bit retrò arcade e perfettamente integrata con i canoni di accessibilità vocale per lo screen reader NVDA e navigazione da tastiera senza mouse (**Zero Mouse**).

### Elementi Costitutivi del Nuovo Menu
1. **Sfondo Panoramico (`background_menu_clean.png`)**:
   - Crepuscolo cittadino con cielo pulito per il logo;
   - Folla viva e diversificata: gruppo punk con creste colorate e giacche borchiate a sinistra, musicisti jazz con sassofono e contrabbasso a destra, pubblico sullo sfondo;
   - Insegne al neon retro-illuminate: "MUSIC SHOP", "STAGE", "GIGS";
   - Strada centrale che sfuma prospetticamente in un pentagramma musicale luminoso;
   - Pentagramma circolare scintillante in primo piano sul selciato con chiave di violino e note musicali, completamente sgombro e visibile.
2. **Logo Titolo Superiore (`game_title.png`)**:
   - Scritta "WORLD TOUR" con finitura oro lucida e neon arcade retrò, note musicali e globo terrestre stilizzato.
3. **Struttura dei 4 Pulsanti Neon Verticali**:
   - 1. **"NUOVA PARTITA"**: Avvio creazione e personalizzazione personaggio.
   - 2. **"CARICA PARTITA"**: Caricamento atomico dell'ultimo salvataggio con `SaveManager`.
   - 3. **"IMPOSTAZIONI"**: Configurazione lingua e durata giornata con isolamento modale e tasto Escape.
   - 4. **"ESCI AL DESKTOP"**: Uscita pulita dal gioco tramite `get_tree().quit()`.
4. **Tipografia & Stile Neon**:
   - Font retrò arcade `PressStart2P.ttf` integrato;
   - Bordo e alone neon ciano (#38bdf8) nello stato normale e con focus/hover;
   - Bagliore neon magenta/fucsia (#f43f5e) allo stato premuto;
   - Sfumatura disabilitata quando nessun file di salvataggio è presente.

---

## 🛡️ 2. PROTOCOLLO 12 — I 6 CANCELLI INVIOLABILI (INNER CODEX)

- **Cancello 1 (Rifiuto Patching Euristico)**:
  - Posizionamento dinamico e ancoraggio percentuale responsivo a 1920x1080 (modalità canvas_items);
  - Nessun pixel hardcoded fragile;
  - Controllo deterministico dell'esistenza del salvataggio con `SaveManager.has_savegame()`.
- **Cancello 2 (Hardware Grounding & Zero Mouse)**:
  - 100% operativo da sola tastiera (Frecce Su/Giù, Tab/Shift-Tab, Invio, Spazio, Numpad 8/2);
  - Navigazione ciclica continua tra i 4 pulsanti;
  - Tasto Escape per chiudere istantaneamente il pannello Impostazioni.
- **Cancello 3 (Hitbox, Clearance Continua & Volumi Sicuri)**:
  - Dimensioni minime dei pulsanti adeguate per click e visibilità;
  - Separazione verticale pulita (12px) per lasciare libero il pentagramma luminoso;
  - Segnali acustici con volume protetto $\le 0.75\text{f}$ e ducking durante la voce di NVDA.
- **Cancello 4 (Named Contracts D0..D3)**:
  - Scomposizione atomica delle modifiche in contratti indipendenti.
- **Cancello 5 (Determinismo Headless)**:
  - Test seams headless a 0 ms senza dipendenze temporali né `OS.delay()`.
- **Cancello 6 (Budget Token & Anti-Bloat Normativo)**:
  - Controller del menu compatto ($\le 200$ righe);
  - Chiavi i18n perfettamente speculari in `it.json` ed `en.json`.

---

## 📐 3. SCOMPOSIZIONE ATOMICA IN NAMED CONTRACTS

### 🧹 CONTRATTO D0: Clean Sweep & Preparazione Risorse
- [x] [CONVALIDATO CON SUCCESSO] Generazione dello sfondo pulito `res://assets/img/menu/menu_img/background_menu_clean.png` (strada e cielo puliti, pentagramma e folla intatti);
- [x] [CONVALIDATO CON SUCCESSO] Allineamento chiavi dizionario bilingue `it.json` ed `en.json` con `MENU_LOAD_GAME`, `MENU_LOAD_GAME_DESC`, `MENU_LOAD_GAME_NO_SAVE`, `MENU_QUIT_DESKTOP`, `MENU_QUIT_DESKTOP_DESC`;
- [x] [CONVALIDATO CON SUCCESSO] Verifica e aggancio del font `res://assets/img/font_text/press_start_2p/PressStart2P.ttf`.

### 🎨 CONTRATTO D1: Refactoring Scena `main_menu.tscn`
- [x] [CONVALIDATO CON SUCCESSO] Inserimento di `TextureRect` per lo sfondo `background_menu_clean.png` a tutto schermo;
- [x] [CONVALIDATO CON SUCCESSO] Inserimento di `TextureRect` per il logo `game_title.png` centrato in alto;
- [x] [CONVALIDATO CON SUCCESSO] Creazione del contenitore `VBoxMenu` con i 4 pulsanti `BtnNewGame`, `BtnLoadGame`, `BtnSettings`, `BtnQuit`;
- [x] [CONVALIDATO CON SUCCESSO] Conservazione del nodo `BtnQuickStart` (nascosto per compatibilità test preesistenti e debug);
- [x] [CONVALIDATO CON SUCCESSO] Styling neon dei bottoni (normale ciano, focus/hover ciano brillante, pressed magenta, font PressStart2P via `menu_theme.tres`);
- [x] [CONVALIDATO CON SUCCESSO] Aggiornamento `PanelSettings` con stile neon cyberpunk e layout accessibile.

### ⚙️ CONTRATTO D2: Controller `main_menu.gd` & Accessibilità NVDA
- [x] [CONVALIDATO CON SUCCESSO] Connessione segnale per `BtnLoadGame` con invocazione atomica di `SaveManager.load_game()` e transizione asincrona;
- [x] [CONVALIDATO CON SUCCESSO] Disabilitazione controllata e annuncio vocale se nessun salvataggio è presente;
- [x] [CONVALIDATO CON SUCCESSO] Aggancio `AccessibilityManager.hook_control_accessibility()` su tutti i controlli per NVDA;
- [x] [CONVALIDATO CON SUCCESSO] Navigazione ciclica continua con `focus_neighbor_top` e `focus_neighbor_bottom`;
- [x] [CONVALIDATO CON SUCCESSO] Gestione tasto Escape per uscire da Impostazioni e scorciatoia `KEY_T` per avvio rapido in debug.

### 🧪 CONTRATTO D3: Test Suite Headless & Verifica Regressioni
- [x] [CONVALIDATO CON SUCCESSO] Creazione della suite `tests/test_main_menu.gd` e `tests/test_main_menu.tscn` (33/33 test superati);
- [x] [CONVALIDATO CON SUCCESSO] Esecuzione con `tools/test.ps1` su tutte le 29 suite del progetto (29/29 superate, 0 errori a 0 ms);
- [x] [CONVALIDATO CON SUCCESSO] Zero regressioni sull'intero ecosistema di gioco.
