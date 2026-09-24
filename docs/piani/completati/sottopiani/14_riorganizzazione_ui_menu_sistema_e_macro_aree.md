# Sottopiano 14 — Riorganizzazione UI, Menu di Sistema & Macro-Aree (Versione 5.0)

- ID Sottopiano: `SP-14`
- Stato: `[x] COMPLETATO E CONVALIDATO` — Riorganizzazione Architetturale Eseguita con 18/18 Suite Superate
- Versione: 1.0 — Architettura a 5 Sezioni, Top Bar Permanente, Menu di Pausa Esc e 4 Macro-Aree di Gioco
- Autore: Luca & Antigravity (Pair Programming Senior)
- Tema: Ristrutturazione dell'interfaccia utente (HUD) per superare l'affollamento orizzontale a 15 pulsanti; consolidamento della Barra Superiore Permanente; introduzione del Menu di Sistema modale su tasto `Esc` (Salvataggio, Impostazioni Audio/Voce/Lingua, Menu Principale); raggruppamento delle schermate in 4 Macro-Aree accessibili da tastiera con i tasti `1`..`4` e conservazione dei tasti rapidi diretti.
- Competenze di riferimento: UI/UX Engineering, Screen Reader Accessibility (NVDA Zero Mouse), Simmetria Universale, Godot 4 Architecture
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md)
- Hub di contesto: [`GEMINI.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/GEMINI.md)

---

## 1. VISIONE & MOTIVAZIONE ARCHITETTURALE

Con l'espansione del gioco attraverso le Fasi 1–8, l'HUD centrale è arrivato a contenere 15 pulsanti consecutivi (`BtnCharacter`, `BtnPractice`, `BtnCatalog`, `BtnNewSong`, `BtnConcert`, `BtnEconomy`, `BtnBand`, `BtnIndustry`, `BtnAgenda`, `BtnTravel`, `BtnTour`, `BtnFestival`, `BtnSocial`, `BtnChart`, `BtnAlbum`).  
Sebbene la navigazione per tasti rapidi diretti sia impeccabile per un utente esperto, questo layout presenta due criticità:
1. **Per Holy Diver (e utenti visivi)**: I 15 pulsanti in fila creano affollamento visivo orizzontale, riducendo lo spazio e l'armonia della schermata principale.
2. **Per Luca (con NVDA e navigazione lineare con Tab/Frecce)**: Scorrere 15 nodi prima di raggiungere l'azione desiderata è poco ergonomico.
3. **Mancanza di un Menu di Sistema dedicato (`Tasto Esc`)**: Premere `Esc` chiudeva le modali, ma a riposo nell'HUD non offriva un menu di pausa, salvataggio rapido e configurazione.

La soluzione consiste in un'architettura a **5 sezioni organiche**:
- **Sezione 0 (In Alto)**: Barra Superiore Fissa Permanente (Calendario, Risorse personali ed economiche, Controlli runtime).
- **Sezione di Sistema (`Tasto Esc`)**: Menu modale con Riprendi, Salva Partita, Impostazioni e Menu Principale.
- **4 Macro-Aree Tematiche Centrali**:
  - `Macro-Area 1`: Hub Personale (Personaggio `C`, Agenda `A`, Bilancio `B`, Viaggi `V`).
  - `Macro-Area 2`: Creazione & Produzione (Catalogo `M`, Nuovo Brano `N`, Produzione Album `P`).
  - `Macro-Area 3`: Carriera & Band (Concerti `L`, Band `G`, Tour `O`, Festival `F`, Social `Y`, Classifiche `H`, Industria `K`).
  - `Macro-Area 4`: Skills & Upgrade (Alloggi/Spazio vitale, Sala prove, Acquisto strumenti, Hardware studio `U`).

---

## 2. SEZIONE 0: BARRA SUPERIORE FISSA PERMANENTE (`PanelTop`)

La barra superiore rimane ancorata e visibile:
1. **Calendario Sistemico**:
   - `LabelTime`: Giorno, Orario virtuale (hh:mm), Fascia oraria (Mattina, Pomeriggio, Sera, Notte), Mese (1..12 da 28 giorni), Stagione.
2. **Indicatori Risorse Vitali**:
   - `LabelEnergy`: Energia residua in percentuale [0% - 100%].
   - `LabelStress`: Livello di stress accumulato [0% - 100%].
   - `LabelMorale`: Morale della band/artista [0% - 100%].
3. **Indicatore Economico**:
   - `LabelMoney`: Saldo liquido disponibile in Euro.
4. **Controlli Runtime & Simulazione**:
   - `BtnSpeed`: Tasto rapido `T` (cicla tra 1x, 2x, 3x con annuncio NVDA).
   - `BtnPause`: Tasto rapido `Spazio` (toggle Pausa/Play).
   - `Tasto I (Info Vocale Rapida)`: Vocalizzazione sintetica dell'intera barra superiore per NVDA senza spostare il focus.

---

## 3. SEZIONE DI SISTEMA: MENU DI PAUSA & OPZIONI (`SystemMenuModal`)

Gestito da `ui/system_menu/system_menu_modal.gd` e `.tscn`:
- **Comportamento Gerarchico di `KEY_ESCAPE` in `hud.gd`**:
  - Se una modale di gioco è aperta: `Esc` chiude la modale attiva e ripristina l'HUD.
  - Se nessuna modale di gioco è aperta: `Esc` mette il gioco in pausa e apre `SystemMenuModal`.
- **Voci del Menu di Sistema**:
  - `1. Riprendi Partita`: Chiude il menu di sistema e disattiva la pausa.
  - `2. Salva Partita`: Richiama `SaveManager.save_game()` con annuncio vocale *"Partita salvata con successo nel file savegame.json"*.
  - `3. Impostazioni & Accessibilità`: Regolazione volumi di sicurezza (0.7f-0.8f con ducking), lingua dinamica (IT/EN), sintesi vocale.
  - `4. Torna al Menu Principale`: Mostra dialogo di conferma ("Vuoi uscire al Menu Principale? I dati non salvati andranno persi. Premi Invio per confermare, Esc per annullare").

---

## 4. LE 4 MACRO-AREE DI GIOCO

### Selettore delle Macro-Aree (`HBoxCategories`)
Quattro pulsanti ad alto contrasto posti sotto la Top Bar:
- `BtnTabPersonal`: "1. Hub Personale"
- `BtnTabCreation`: "2. Creazione & Produzione"
- `BtnTabCareer`: "3. Carriera & Band"
- `BtnTabUpgrades`: "4. Skills & Upgrade"

Premendo i tasti `1`, `2`, `3`, `4` quando l'HUD ha il focus, la macro-area attiva cambia istantaneamente.  
Al cambio di macro-area:
1. Vengono mostrati esclusivamente i pulsanti dell'area selezionata in `HBoxCategoryActions`.
2. Il focus si sposta sul primo pulsante della categoria.
3. NVDA pronuncia un annuncio lineare con il nome dell'area e i comandi disponibili.

### Mappatura Dettagliata delle Schede:
1. **Macro-Area 1: Hub Personale**:
   - `BtnCharacter` ("Personaggio (C)")
   - `BtnAgenda` ("Agenda (A)")
   - `BtnEconomy` ("Bilancio (B)")
   - `BtnTravel` ("Viaggi (V)")
   - `BtnPractice` ("Allenamento Rapido (1)")
2. **Macro-Area 2: Creazione & Produzione**:
   - `BtnCatalog` ("Catalogo (M)")
   - `BtnNewSong` ("Nuovo Brano (N)")
   - `BtnAlbum` ("Produzione Album (P)")
3. **Macro-Area 3: Carriera & Band**:
   - `BtnConcert` ("Concerti (L)")
   - `BtnBand` ("Band (G)")
   - `BtnTour` ("Tournée (O)")
   - `BtnFestival` ("Festival (F)")
   - `BtnSocial` ("Social (Y)")
   - `BtnChart` ("Classifiche (H)")
   - `BtnIndustry` ("Industria (K)")
4. **Macro-Area 4: Skills, Upgrade & Strumentazione**:
   - `BtnHousing` ("Spazio Vitale & Casa")
   - `BtnRehearsal` ("Sala Prove")
   - `BtnInstruments` ("Negozio Strumenti")
   - `BtnStudioGear` ("Hardware di Registrazione")
   - Modale centralizzata: `UpgradesModal` (`ui/upgrades/upgrades_modal.tscn` con tasto rapido `U`).

---

## 5. REGOLE D'ORO DI ACCESSIBILITÀ & SIMMETRIA

1. **Zero Conflitti di Tasti**:
   - Tutti i 15 tasti mnemonici storici (`C`, `A`, `B`, `V`, `M`, `N`, `P`, `L`, `G`, `O`, `F`, `Y`, `H`, `K`, `U`) rimangono attivi come scorciatoie globali immediate in qualsiasi momento. Se premi `L`, il gioco apre i Concerti immediatamente, indipendentemente dalla macro-area selezionata a video.
2. **Zero Mouse & Lettura Lineare**:
   - Nessun menu a discesa nidificato non leggibile. Ogni selezione emette testo sintetico per NVDA via `AccessibilityManager.speak()`.
3. **Isolamento Modale**:
   - La funzione `_hide_all_modals()` garantisce che all'apertura di qualsiasi finestra (incluso `SystemMenuModal` e `UpgradesModal`), `VBoxMain` e le altre modali vengano occultate per azzerare leakage di lettura AccessKit.

---

## 6. PIANO DEI TEST AUTOMATIZZATI

- Creazione della suite `tests/test_v5_ui_overhaul.gd`:
  1. Verifica istanziazione delle 5 sezioni e delle 4 tab di categoria.
  2. Verifica cambio categoria con tasti `1`, `2`, `3`, `4` e visibilità pulsanti dedicati.
  3. Verifica apertura `SystemMenuModal` con tasto `Esc` a riposo.
  4. Verifica priorità chiusura modale con tasto `Esc` quando una finestra è aperta (non apre il menu di sistema).
  5. Verifica funzionamento dei 15 tasti rapidi diretti.
  6. Esecuzione globale delle 18 suite del progetto con zero errori.
