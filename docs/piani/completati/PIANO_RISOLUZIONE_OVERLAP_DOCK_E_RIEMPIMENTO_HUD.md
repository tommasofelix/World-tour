# Piano Tecnico Operativo — Risoluzione Overlap Dialogue-Dock, Pulsante Band & Riempimento Sezioni HUD (ASTRALIS v3.0.7)
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-25
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Convalidato headless al 100% su 30/30 suite e collaudato con successo)
# File Piano: docs/piani/completati/PIANO_RISOLUZIONE_OVERLAP_DOCK_E_RIEMPIMENTO_HUD.md
# Coordinatore Master: docs/todo.md

---

## 🎯 1. OBIETTIVO E PERIMETRO DELL'INTERVENTO

Risolvere in maniera definitiva e deterministica tre problematiche visive e funzionali riscontrate nell'HUD del Loft NYC (`ui/apartment_hud/`):
1. **Sovrapposizione Geometrica**: Risolvere l'overlap tra la finestra di ispezione a sinistra (`BottomLeftDialogue`) e il dock delle macro-categorie (`BottomCenterDock`).
2. **Pulsante Band nel Dock**: Aggiungere il quinto pulsante dedicato alla Band (`BtnDockBand`) nel dock inferiore, utilizzando l'asset `assets/img/gameplay/GUI/Elementi/band_icon.png` e collegandolo all'apertura immediata della modale `BandHubModal` (tasto rapido `5` e click mouse).
3. **Riempimento Spazi & Bilanciamento Caselle (Top Left, Top Right, Bottom Right, Bottom Left)**: Eliminare i vuoti interni e le asimmetrie all'interno di tutti i blocchi perimetrali dell'HUD. Inserire `MarginContainer` dedicati e impostare `size_flags` di espansione orizzontale e verticale in modo che testi, barre, icone e pulsanti occupino armoniosamente l'intera area di ciascun riquadro.

---

## 🛡️ 2. PROTOCOLLO 12 — I 6 CANCELLI INVIOLABILI (INNER CODEX)

- **Cancello 1 (Rifiuto Patching Euristico & Root Cause Analysis)**:
  * *Causa Radice Overlap*: `BottomLeftDialogue` aveva `offset_right = 650.0`, mentre `BottomCenterDock` con l'ancoraggio centrale a X = 960 e 5 pulsanti si estendeva a sinistra fino a X = 648 (e prima a X = 685 ma con `expand_margin` e offset asimmetrici), creando collisione visiva.
  * *Causa Radice Vuoti Interni*: Alcuni pannelli (`TopLeftProfile`, `TopRightTime`, `BottomRightInfo`) erano direttamente `PanelContainer` contenenti `VBox`/`HBox` con dimensioni minime fisse e senza espansione orizzontale/verticale, lasciando decine di pixel vuoti a destra o in basso.
- **Cancello 2 (Hardware Grounding & Zero Mouse)**:
  * Il nuovo pulsante Band è controllabile con il mouse da Holy Diver e da tastiera tramite il tasto rapido dedicato `5` (oltre allo storico `B`), con annuncio vocale immediato per NVDA.
  * Tutti i pulsanti conservano `focus_mode = FOCUS_NONE` per non intercettare `Tab` durante la navigazione arredi di Luca.
- **Cancello 3 (Hitbox, Clearance Continua & Volumi Sicuri)**:
  * Clearance orizzontale garantita: minimo **80–100 pixel di visuale libera** tra `BottomLeftDialogue` e `BottomCenterDock`, e oltre **180 pixel** tra `BottomCenterDock` e `BottomRightInfo`.
  * Allineamento del margine inferiore di tutti i blocchi a Y = 1060 (`offset_bottom = -20.0`).
  * Volumi sonori ed earcon congelati a 0.70f–0.75f (-2.5 dB) con ducking acustico al 40%.
- **Cancello 4 (Named Contracts D0..D6)**:
  * Scomposizione atomica delle modifiche in contratti mirati.
- **Cancello 5 (Determinismo Headless)**:
  * Suite di test seams a 0 ms in `tests/test_apartment_gameplay.gd` con verifica delle coordinate geometriche e funzionamento del tasto Band.
- **Cancello 6 (Budget Token & Anti-Bloat Normativo)**:
  * Modifiche chirurgiche e pulite, zero duplicazioni, percorsi relativi `res://`.

---

## 📐 3. SCOMPOSIZIONE ATOMICA IN NAMED CONTRACTS

### 📦 CONTRATTO D0: Risoluzione Geometrica Overlap Dialogue - Dock
- [/] **Ricalibrazione coordinate e larghezze su Viewport Full HD 1920x1080**:
  * **`BottomLeftDialogue`**:
    - `offset_left = 24.0`, `offset_top = -240.0`, `offset_right = 540.0`, `offset_bottom = -20.0` (larghezza = 516 px, altezza = 220 px);
    - Dimensioni ritratto: $120 \times 145$ px;
    - Dimensioni minime etichetta testo: larghezza = 350 px, altezza = 80 px (`autowrap_mode = 3`);
    - Termina esattamente alla coordinata X = 540 px.
  * **`BottomCenterDock`**:
    - Ancoraggio orizzontale centrato (`anchor_left = 0.5`, `anchor_right = 0.5`, centro su X = 960 px);
    - Larghezza totale dock a 5 pulsanti = 624 px;
    - Coordinate: `offset_left = -312.0`, `offset_top = -135.0`, `offset_right = 312.0`, `offset_bottom = -20.0`;
    - Inizia alla coordinata X = 648 px e termina a X = 1272 px.
  * **Clearance Calcolata**:
    - Distanza tra fine del dialogo (X = 540) e inizio del dock (X = 648) = **108 pixel di spazio libero e respiro visivo**.
    - Sovrapposizione completamente azzerata.

---

### 🎸 CONTRATTO D1: Integrazione Quinto Pulsante "Band" nel Dock
- [/] **Configurazione visiva e funzionale del nuovo pulsante `BtnDockBand`**:
  * Inserimento all'interno di `BottomCenterDock/Margin/HBoxDock`;
  * Asset texture: `assets/img/gameplay/GUI/Elementi/band_icon.png`;
  * Proprietà: `focus_mode = 0`, font size 11 px, `text = "5 Band"`, `tooltip_text = "Band & Reclutamento (Tasto 5 / B)"`, `expand_icon = true`, `icon_alignment = 1`, `vertical_icon_alignment = 0`;
  * Distribuzione: tutti i 5 pulsanti (`BtnDockPersonal`, `BtnDockCreation`, `BtnDockCareer`, `BtnDockTools`, `BtnDockBand`) ricevono `size_flags_horizontal = 3` (expand) per riempire equamente l'intera larghezza del dock;
  * Preload e wiring in `apartment_hud.gd`: `TEX_DOCK_BAND`, `@onready var btn_dock_band`, collegamento segnale a `_on_dock_band_pressed()` -> `open_modal(band_hub_modal)`.

---

### 👤 CONTRATTO D2: Riempimento Spazi & Bilanciamento Profilo (Top Left)
- [/] **Ristrutturazione `TopLeftProfile`**:
  * Dimensioni esterne: `offset_left = 24.0`, `offset_top = 20.0`, `offset_right = 620.0`, `offset_bottom = 200.0` (larghezza 596 px, altezza 180 px);
  * Inserimento di `MarginContainer` interno con margini 12 px (sinistra, destra, sopra, sotto);
  * Ingrandimento frame ritratto: da 110x110 a $120 \times 120$ px per eliminare il vuoto verticale a sinistra;
  * `VBox` interno con `size_flags_horizontal = 3` e `size_flags_vertical = 3`, separazione 10 px;
  * Barre vitali (`BarEnergy`, `BarStress`, `BarMorale`): altezza incrementata da 16 a 18 px con `size_flags_horizontal = 3` (riempimento orizzontale automatico verso l'etichetta del valore);
  * Risultato: il blocco risulta pieno, compatto e privo di zone vuote.

---

### ⏰ CONTRATTO D3: Riempimento Spazi & Bilanciamento Tempo/Meteo (Top Right)
- [/] **Ristrutturazione `TopRightTime`**:
  * Dimensioni esterne: `offset_left = -480.0`, `offset_top = 20.0`, `offset_right = -24.0`, `offset_bottom = 190.0` (larghezza 456 px, altezza 170 px);
  * Inserimento di `MarginContainer` interno con margini 12 px;
  * `VBoxTime` con `size_flags_vertical = 3` e separazione 12 px tra le righe;
  * Riga data (`HBoxDate`) e riga periodo (`HBoxPeriod`) con `size_flags_horizontal = 3`;
  * Riga controlli (`HBoxTimeControls`):
    - Rimossa la larghezza fissa stretta dei 3 pulsanti;
    - `BtnTimePause`, `BtnTimeSpeed` e `BtnTimeSleep` impostati con `size_flags_horizontal = 3` (expand) e altezza 38 px;
    - I 3 pulsanti si allargano automaticamente coprendo l'intera larghezza orizzontale del box, eliminando i 300 pixel di vuoto a destra.

---

### 💼 CONTRATTO D4: Riempimento Spazi & Bilanciamento Info/Economia (Bottom Right)
- [/] **Ristrutturazione `BottomRightInfo`**:
  * Dimensioni esterne: `offset_left = -460.0`, `offset_top = -200.0`, `offset_right = -24.0`, `offset_bottom = -20.0` (larghezza 436 px, altezza 180 px);
  * Inserimento di `MarginContainer` interno con margini 14 px;
  * `VBox` con `size_flags_vertical = 3` e separazione 12 px:
    - `HBoxMoney`: Icona 28x28 + Label contanti (font 15 px);
    - `HBoxFans`: Icona folla + Label fan (font 14 px);
    - `HBoxLocation`: Icona 24x24 + Label mappa (font 13 px);
    - `LabelArcadeWatermark`: posizionata armoniosamente in basso.
  * Spazio libero tra Dock e Info: $1460 - 1272 =$ **188 pixel di respiro visivo**.

---

### ⌨️ CONTRATTO D5: Mappatura Tasto Rapido 5 in `apartment.gd`
- [/] **Scorciatoia diretta da tastiera**:
  * In `scenes/apartment/apartment.gd`, gestione `KEY_5`:
    ```gdscript
    KEY_5:
        # Macro-Categoria 5: Band
        hud.open_modal(hud.band_hub_modal)
        get_viewport().set_input_as_handled()
    ```
  * Conservazione integrale di tutti i 15 tasti rapidi storici (incluso `KEY_B` per la Band).

---

### 🧪 CONTRATTO D6: Suite di Test Headless & Convalida Anti-Regressione
- [/] **Estensione asserzioni in `tests/test_apartment_gameplay.gd`**:
  * Verifica che `hud.btn_dock_band` esista ed emetta il segnale aprendo `band_hub_modal`;
  * Test deterministico di clearance geometrica: verifica che l'estremità destra di `BottomLeftDialogue` sia inferiore all'estremità sinistra di `BottomCenterDock` (`dialogue.offset_right < 960 + dock.offset_left`);
  * Esecuzione completa di `tools/check.ps1` e `tools/test.ps1` (30 suite headless a 0 errori e 0 ms).

---

## 🚦 4. REGOLA 0 & STOP OBBLIGATORIO

La Sotto-Fase 1A è formalizzata. Antigravity si arresta rigorosamente in modalità consultiva in attesa dell'esplicito comando di Luca (*"procedi"*, *"applica"*, *"esegui"*) prima di effettuare qualsiasi modifica ai file del progetto.
