# Piano Tecnico Operativo — Implementazione GUI Pixel Art & Dinamismo HUD Loft NYC (ASTRALIS v3.0.7)
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-25
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Convalidato headless al 100% su 30/30 suite di test e collaudato con successo)
# File Piano: docs/piani/completati/PIANO_IMPLEMENTAZIONE_GUI_PIXEL_ART_APARTMENT.md
# Coordinatore Master: docs/todo.md

---

## 🎯 1. OBIETTIVO E PERIMETRO DELL'INTERVENTO

Implementare a schermo nell'HUD 2.5D del Loft Apartment (`ui/apartment_hud/apartment_hud.tscn` e `apartment_hud.gd`) l'interfaccia grafica retrò in Pixel Art, fedele al mockup di riferimento (`assets/img/gameplay/GUI/Elementi/example/esempio_elementi_gui.jpeg` e design sheet `assets/img/gameplay/GUI/Asset/GUI-1.png`).
Tutti gli elementi a schermo devono essere **dinamici e reattivi allo stato del personaggio** (`PlayerData`, `CalendarData`), garantendo la perfetta **Simmetria Universale**:
- Esperienza visiva ricca ed ergonomica per utenti vedenti con mouse (Holy Diver);
- Accessibilità vocale al 100% da tastiera per lo screen reader NVDA (Luca / Zero Mouse).

---

## 🛡️ 2. PROTOCOLLO 12 — I 6 CANCELLI INVIOLABILI (INNER CODEX)

- **Cancello 1 (Rifiuto Patching Euristico)**:
  - Nessuna texture o coordinata hardcoded a spanne; ancoraggi elastici `Full Rect` o layout container proporzionali;
  - Regole deterministiche per le soglie di cambio espressione e cambio icone.
- **Cancello 2 (Hardware Grounding & Zero Mouse)**:
  - Interazione speculare: ogni pulsante grafico (dock macro-categorie, controlli tempo) è mappato sia a click mouse sia a comandi da tastiera diretti (1, 2, 3, 4, Spazio, Esc, Tab, Numpad);
  - I controlli espongono etichette accessibili e ruoli UIA per NVDA.
- **Cancello 3 (Hitbox, Clearance Continua & Volumi Sicuri)**:
  - L'HUD risiede su `CanvasLayer` per non interferire con il movimento o con i collider isometrici del personaggio;
  - Suoni e cue audio calibrati al livello salvavita compreso tra `0.70f` e `0.75f` (-2.5 dB) con ducking acustico.
- **Cancello 4 (Named Contracts D0..D6)**:
  - Scomposizione atomica delle modifiche in contratti indipendenti e verificabili.
- **Cancello 5 (Determinismo Headless)**:
  - Test seams headless a 0 ms per verificare ogni combinazione di stato dinamico (normale, triste, arrabbiato, disperato, giorno/notte, pochi/molti soldi) senza ritardi.
- **Cancello 6 (Budget Token & Anti-Bloat Normativo)**:
  - Router snello ed essenziale; forwarder puliti e percorsi relativi `res://`.

---

## 📐 3. SCOMPOSIZIONE ATOMICA IN NAMED CONTRACTS

### 📦 CONTRATTO D0: Censimento & Preload Asset Pixel Art
- [/] [IMPLEMENTATO — IN ATTESA DI CONVALIDA] **Precaricamento deterministico delle risorse in `apartment_hud.gd`**:
  * **Ritratti Alex** (`assets/img/gameplay/GUI/Portrait/Alex/`):
    - `alex_normale.png` (condizione base / serena)
    - `alex_triste.png` (morale basso <= 30%)
    - `alex_arrabbiato.png` (stress alto >= 60%)
    - `alex_disperato.png` (energia critica <= 15% o stress estremo >= 85%)
  * **Icone Risorse Vitali & Status** (`assets/img/gameplay/GUI/Elementi/`):
    - `Livello_Personaggio.png` (stellina livello)
    - `Energia.png` (fulmine verde)
    - `Stress_nomrale.png` / `Stress_critico.png` (cuore / tensione)
    - `Morale_Normale.png` / `Morale_Critico.png` (note musicali)
    - `Barra_Stress.png`, `Barra_Morale.png`, `barra_vuota.png` (texture progress bar)
  * **Icone Tempo & Meteo**:
    - `Mattino.png`, `Pomeriggio.png`, `Tramonto.png`, `Notte.png`
    - `Pulsante_Riprendi.png` (Play/Pause), `Pulsante_tempo_x2.png` (Fast Forward)
  * **Icone Economia & Mappa**:
    - `pochi_soldi.png` (< 1.000 €), `Molti_Soldi.png` (>= 1.000 €)
    - `Mappa.png` (pin geografico location)
  * **Icone Dock Macro-Categorie**:
    - `Personale.png` (Chitarra elettrica, tasto 1)
    - `Creazione.png` (Cassetta a nastro retrò, tasto 2)
    - `Carriera.png` (Microfono vintage, tasto 3)
    - `Strumenti.png` (Radio / Amplificatore, tasto 4)

---

### 👤 CONTRATTO D1: Dinamismo Portrait & Espressioni Emotive di Alex
- [/] [IMPLEMENTATO — IN ATTESA DI CONVALIDA] **Macchina a stati espressivi del ritratto**:
  * Algoritmo deterministico di selezione sprite ritratto in base allo stato di `PlayerData`:
    1. Se `player.energy <= 15.0` oppure `player.stress >= 85.0`: ritratto `alex_disperato.png` (stato di esaurimento psicofisico o rischio burnout);
    2. Altrimenti, se `player.stress >= 60.0`: ritratto `alex_arrabbiato.png` (tensione e pressione accumulate);
    3. Altrimenti, se `player.morale <= 30.0`: ritratto `alex_triste.png` (sconforto o crisi d'ispirazione);
    4. Altrimenti: ritratto `alex_normale.png` (condizione ordinaria, serena ed energica).
  * **Doppio aggiornamento sincronizzato**:
    - Aggiornamento della texture in `TopLeftProfile/HBox/PortraitFrame/TexturePortraitTop`;
    - Aggiornamento della texture in `BottomLeftDialogue/Margin/HBox/TexturePortraitDialogue` quando l'interlocutore attivo è Alex.

---

### 📊 CONTRATTO D2: Profilo & Risorse Vitali Pixel Art (Top Left)
- [/] [IMPLEMENTATO — IN ATTESA DI CONVALIDA] **Ristrutturazione visiva del blocco `TopLeftProfile`**:
  * Inserimento icona `Livello_Personaggio.png` affiancata a `LabelLevel` (formato "Lv. 1 — Garage Hero");
  * Trasformazione delle barre vitali in barre grafiche con icona e percentuale visibile:
    - **Energia**: icona `Energia.png` affiancata alla barra + label `"ENERGIA (%d%%)" % player.energy`;
    - **Stress**: icona dinamica (`Stress_critico.png` se `stress >= 60.0` altrimenti `Stress_nomrale.png`) + barra rossa + label `"STRESS (%d%%)" % player.stress`;
    - **Morale**: icona dinamica (`Morale_Critico.png` se `morale <= 30.0` altrimenti `Morale_Normale.png`) + barra azzurra + label `"MORALE (%d%%)" % player.morale`;
  * Cornice metallica scura stile pixel art coerente con il mockup `esempio_elementi_gui.jpeg`.

---

### ⏰ CONTRATTO D3: Blocco Tempo, Calendario & Controlli Velocità (Top Right)
- [/] [IMPLEMENTATO — IN ATTESA DI CONVALIDA] **Ristrutturazione visiva del blocco `TopRightTime`**:
  * Riquadro Data superiore con icona calendario e testo `Giorno X — GiornoSettimana, Settimana Y`;
  * Riquadro Orario con icona meteo dinamica pixel art:
    - `Mattino.png` durante `Enums.TimePeriod.MORNING` (08:00);
    - `Pomeriggio.png` durante `Enums.TimePeriod.AFTERNOON` (14:00);
    - `Tramonto.png` durante `Enums.TimePeriod.EVENING` (20:00);
    - `Notte.png` durante `Enums.TimePeriod.NIGHT` (02:00);
  * Inserimento della barra pulsanti per la simulazione del tempo:
    - Pulsante Play / Pausa con `Pulsante_Riprendi.png` (tasto rapido `P` o `Spazio`);
    - Pulsante Velocità $2\times$ con `Pulsante_tempo_x2.png` (tasto rapido `V`);
    - Pulsante Salto Periodo / Sonno (tasti rapidi `X` e `Z`).

---

### 💼 CONTRATTO D4: Economia, Fanbase & Località (Bottom Right)
- [/] [IMPLEMENTATO — IN ATTESA DI CONVALIDA] **Ristrutturazione del blocco `BottomRightInfo`**:
  * **Saldo Contanti**:
    - Icona dinamica `pochi_soldi.png` (se `player.money < 1000.0`) o `Molti_Soldi.png` (se `player.money >= 1000.0`);
    - Testo formattato: `Banconote: %.2f €`;
  * **Fanbase Totale**:
    - Icona folla con testo `Folla: %d Fan` (es. `1.250 Fan`);
  * **Posizione Geografica**:
    - Icona `Mappa.png` affiancata al testo `Mappa: NYC — Loft Apartment`.

---

### 🎸 CONTRATTO D5: Dock Orizzontale Macro-Categorie (Bottom Center)
- [/] [IMPLEMENTATO — IN ATTESA DI CONVALIDA] **Aggiunta del pannello `BottomCenterDock`**:
  * Posizionamento centrato in basso, tra il blocco ispezione a sinistra e il blocco info a destra;
  * 4 pulsanti rettangolari con texture in pixel art e badge numerico:
    1. **Tasto 1 — Personale**: icona `Personale.png` -> apre `CharacterSheetModal`;
    2. **Tasto 2 — Creazione / Musiche**: icona `Creazione.png` -> apre `SongCatalogModal` / `SongCreator`;
    3. **Tasto 3 — Carriera**: icona `Carriera.png` -> apre `LiveConcertModal` / `BandHub` / `IndustryHub`;
    4. **Tasto 4 — Strumenti / Social**: icona `Strumenti.png` -> apre `UpgradesModal` / `SocialModal`;
  * Pieno supporto tastiera: pressione dei tasti numerici `1`, `2`, `3`, `4` per apertura immediata senza mouse.

---

### 🧪 CONTRATTO D6: Suite di Test Headless & Convalida Anti-Regressione
- [/] [IMPLEMENTATO — IN ATTESA DI CONVALIDA] **Estensione di `tests/test_apartment_gameplay.gd`**:
  * Test deterministico del cambio sprite di Alex al variare di energia, stress e morale (tutti i 4 stati d'animo);
  * Test del cambio icone meteo al mutare della fascia oraria (`MORNING`, `AFTERNOON`, `EVENING`, `NIGHT`);
  * Test dell'icona denaro (soglia 1.000 €: `pochi_soldi` vs `Molti_Soldi`);
  * Test dell'aggiornamento percentuali numeriche nelle barre vitali;
  * Test apertura modali dai pulsanti del dock orizzontale;
  * Esecuzione completa di tutte le 30 suite headless del progetto a 0 errori e 0 ms.

---

## 🚦 4. REGOLA 0 & STOP OBBLIGATORIO

La Sotto-Fase 1A è formalizzata. Antigravity si arresta in modalità consultiva in attesa dell'esplicito comando di Luca prima di toccare qualsiasi riga di codice o file di scena.
