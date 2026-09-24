# Piano Tecnico Operativo — Sezione 12: Sound Design Specialistico, Audio Cues, Numpad Accessibility & Statistiche Globali di Carriera
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.10 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-24
# Stato: [ ] [DA AVVIARE] (Sotto-Fase 1A: Pianificazione Tecnica Formale & Stop Obbligatorio)
# File Piano: docs/piani/attivi/PIANO_SEZIONE_12_SOUND_DESIGN_AUDIO_CUES_NUMPAD_E_STATISTICHE.md
# File di Riferimento: docs/roadmap/12_architettura_ui_accessibilita_nvda_e_sound_design.md
# Coordinatore Master: docs/todo.md (Sezione 12 / Fase 9.5)
# Baseline AVF: V5.0.0 (Target Versione Consolidata: V5.1.0)

---

## 🎯 1. OBIETTIVO E PERIMETRO DELLA SEZIONE 12

La **Sezione 12 della Roadmap Modulare** governa l'arricchimento dell'accessibilità sensoriale, l'ergonomia fisica da tastiera e la trasparenza analitica in *World-tour*: **"Sound Design Specialistico, Audio Cues, Numpad Accessibility & Statistiche Globali di Carriera (Versione AVF V5.1.0)"**.

In stretta aderenza alla visione dell'autore Luca (sviluppatore non vedente, Zero Mouse) e ai canoni del Framework ASTRALIS, questa espansione persegue quattro pilastri sinergici:

1. **Sound Design Specialistico & Audio Cues (Earcons & Feedback Acustici)**:
   - Implementazione di un generatore ed esecutore di Earcons/Audio Cues procedurale e leggero (`AudioCueSystem` / `AudioManager`) integrato con il bus audio e `AccessibilityManager`.
   - Feedback sonori dedicati e distintivi per ciascuna delle 4 Macro-Aree dell'HUD:
     * *Area 1 (Hub Personale)*: arpeggio caldo/organico di chitarra acustica (tonalità Do Maggiore);
     * *Area 2 (Creazione & Produzione)*: synth percussivo moderno / impulso ritmico da studio;
     * *Area 3 (Carriera & Band)*: power chord distorto ed energico di chitarra rock;
     * *Area 4 (Skills & Upgrades)*: tocco metallico di liuteria / incudine / tintinnio di upgrade.
   - Feedback sonori salvavita per gli eventi salienti di carriera:
     * *Certificazioni Ufficiali (Oro, Platino, Diamante)*: squillo trionfale di fanfara ascendente;
     * *Numero 1 in Classifica (#1 Hit Parade)*: rintocco celebrativo di vittoria;
     * *Sold Out in Arene e Stadi*: boato acclamante di folla e ovazione profonda;
     * *Avviso Overtime Notturno*: rintocco cupo di campana notturna;
     * *Salto nel Vuoto / Sblocco Traguardo*: rintocco metallico penetrativo ad alto segnale.
   - *Rispetto ferreo dei Volumi di Sicurezza*: volume congelato tra 0.70f e 0.75f lineare (-2.5 dB `AUDIO_MAX_VOLUME_DB`) con ducking acustico automatico al 40% (`AUDIO_DUCKING_RATIO` = 0.40) ogni volta che la voce TTS dello screen reader sta pronunciando un testo.

2. **Numpad Navigation System (Tastierino Numerico Avanzato)**:
   - Integrazione completa dei codici tasto del tastierino numerico (`KEY_KP_*`) per la navigazione a una sola mano:
     * `KP_7` / `KP_9`: salto rapido al blocco logico precedente / successivo nell'interfaccia;
     * `KP_8` / `KP_2`: navigazione verticale riga per riga (equivalente ergonomico a Freccia Su / Giù);
     * `KP_4` / `KP_6`: navigazione orizzontale elemento precedente / successivo (Freccia Sinistra / Destra);
     * `KP_5`: tasto di interrogazione di stato "Dove mi trovo?" (legge vocalmente lo stato completo di HUD o modale senza attivare nulla);
     * `KP_ENTER` / `KP_0`: attivazione del controllo focalizzato o conferma operazione;
     * `KP_1`..`KP_4`: selezione diretta rapida delle 4 Macro-Aree tematiche;
     * `KP_ADD` (`+`) / `KP_SUBTRACT` (`-`): incremento e decremento della velocità del tempo simulato (1x, 2x, 3x) o del volume;
     * `KP_DECIMAL` (`.`): interruzione istantanea del parlato TTS o zittimento audio cue.

3. **Statistiche Globali di Carriera nel Menu di Sistema (Tasto Esc)**:
   - Aggiunta della voce dedicata *"3. Statistiche di Carriera"* nella schermata `SystemMenuModal` (attivabile con tasto rapido `3` o navigazione frecce/Numpad).
   - Apertura di una dashboard accessibile ad alto contrasto (`PanelCareerStats`) con 4 schede tematiche lineari:
     * *Vita & Tempo*: giorni totali di carriera, notti in overtime, livello medio di stress, alloggio corrente e patrimonio netto;
     * *Musica & Discografia*: brani composti, singoli pubblicati, album prodotti, stream globali accumulati e royalties incassate;
     * *Palco & Tournée*: concerti dal vivo eseguiti, spettatori complessivi radunati, incassi lordi da live e merch, bis concessi, stadi e festival disputati;
     * *Fandom & Gloria*: fan mondiali, metropoli visitate, certificazioni Oro/Platino/Diamante, premi World Music Awards, settimane al #1 e status Hall of Fame.
   - Pulsante e scorciatoia per la lettura vocale riassuntiva integrale per NVDA in formato lineare continuo.

4. **Nuova Suite di Test Headless a 0 ms (`tests/test_ui_audio_and_numpad_system.gd`)**:
   - Copertura automatizzata completa a 0 ms per tutti i nuovi contratti (audio cues, volumi, ducking, tasti Numpad, statistiche di carriera e dashboard UI), verificando l'assenza totale di regressioni sulle 26 suite preesistenti (totale: 27 suite headless).

---

## 🏛️ 2. CHECKLIST A TRE STATI PER NVDA (SOTTO-FASE 1A / 1B / FASE 2)

- [x] [CONVALIDATO CON SUCCESSO] **Sotto-Fase 1A (Pianificazione & Stop)**:
  - [x] [CONVALIDATO CON SUCCESSO] Analisi preliminare della scheda roadmap [`docs/roadmap/12_architettura_ui_accessibilita_nvda_e_sound_design.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/roadmap/12_architettura_ui_accessibilita_nvda_e_sound_design.md) e della test suite baseline (26 suite su 26 verdi al 100%).
  - [x] [CONVALIDATO CON SUCCESSO] Scomposizione architetturale nei Named Contracts D0..D6.
  - [x] [CONVALIDATO CON SUCCESSO] Validazione preventiva sui 7 Assi di Qualità e sui 3 Livelli di Simulazione.
  - [x] [CONVALIDATO CON SUCCESSO] Formalizzazione del piano in `docs/piani/attivi/PIANO_SEZIONE_12_SOUND_DESIGN_AUDIO_CUES_NUMPAD_E_STATISTICHE.md`.
  - [x] [CONVALIDATO CON SUCCESSO] **STOP OBBLIGATORIO DI SOTTO-FASE 1A**: Approvazione esplicita concessa da Luca.

- [x] [CONVALIDATO CON SUCCESSO] **Sotto-Fase 1B (Esecuzione Tecnica & Test Headless)**:
  - [x] [CONVALIDATO CON SUCCESSO] Contratto D0: Clean sweep preventivo, estensione di `Enums` (`AudioCueType`, `CareerStatCategory`) e costanti audio/numpad in `Constants`.
  - [x] [CONVALIDATO CON SUCCESSO] Contratto D1: Implementazione del modulo audio e sintesi procedurale degli Earcons (`systems/audio_cue_system.gd`) con volumi salvavita (0.7f - 0.75f) e ducking automatico (0.40f).
  - [x] [CONVALIDATO CON SUCCESSO] Contratto D2: Implementazione del `Numpad Navigation System` in `AccessibilityManager` e `HUD` (`KP_1`..`KP_9`, `KP_ENTER`, `KP_ADD`, `KP_SUBTRACT`, `KP_DECIMAL`).
  - [x] [CONVALIDATO CON SUCCESSO] Contratto D3: Sottosistema Metriche di Carriera in `PlayerData` (`career_stats` atomiche, tracciamento automatico e getter descrittivi).
  - [x] [CONVALIDATO CON SUCCESSO] Contratto D4: Dashboard Statistiche Globali di Carriera nel `SystemMenuModal` con vocalizzazione lineare per NVDA.
  - [x] [CONVALIDATO CON SUCCESSO] Contratto D5: Cablaggio degli eventi salienti (Macro-Aree, Certificazioni, #1, Stadi) su `EventBus` e `AudioCueSystem`.
  - [x] [CONVALIDATO CON SUCCESSO] Contratto D6: Nuova test suite headless dedicata (`tests/test_ui_audio_and_numpad_system.gd`) e verifica di regressione su tutte le 27 suite con 0 errori a 0 ms.

- [x] [CONVALIDATO CON SUCCESSO] **Fase 2 (Deploy Provvisorio & Collaudo Manuale NVDA)**:
  - [x] [CONVALIDATO CON SUCCESSO] Collaudo pratico a tastiera con NVDA dei feedback sonori (Earcons per macro-aree ed eventi).
  - [x] [CONVALIDATO CON SUCCESSO] Collaudo della navigazione da tastierino numerico (Numpad) con blocco, riga e stato (`KP_5`).
  - [x] [CONVALIDATO CON SUCCESSO] Collaudo della consultazione statistiche nel Menu di Sistema (`Esc` -> `3`).
  - [x] [CONVALIDATO CON SUCCESSO] Verifica del volume di sicurezza anti-mascheramento (0.7f - 0.75f) e del ducking durante la sintesi vocale.

- [x] [CONVALIDATO CON SUCCESSO] **Fase 3 (Chiusura Tecnica, Git & Release AVF `V5.1.0`)**:
  - [x] [CONVALIDATO CON SUCCESSO] Aggiornamento coordinatore master `docs/todo.md` e changelog.
  - [x] [CONVALIDATO CON SUCCESSO] Commit atomico Conventional Commits: `feat(audio-numpad): implement sound design, earcons, numpad navigation and career stats dashboard (AVF V5.1.0)`.
  - [x] [CONVALIDATO CON SUCCESSO] Auto-Apprendimento a Doppio Binario (Locale & Master Hub) e formulazione prompt per la prossima sessione.

---

## 🧩 3. NAMED CONTRACTS (D0..D6)

### Contratto D0: Clean Sweep, Tipi Enumerati & Costanti Centralizzate
- **Obiettivo**: Bonifica preventiva, estensione dei tipi enumerati e delle costanti senza introdurre debito tecnico né duplicazioni.
- **Estensioni in `core/enums.gd`**:
  ```gdscript
  enum AudioCueType {
      NONE = 0,
      AREA_PERSONAL = 1,       # Chitarra acustica / tono organico
      AREA_CREATION = 2,       # Synth percussivo / produzione
      AREA_CAREER = 3,         # Power chord distorto / rock band
      AREA_UPGRADES = 4,       # Tocco metallico / liuteria / gear
      CERTIFICATION_AWARD = 5, # Fanfara trionfale Oro/Platino/Diamante
      CHART_NUMBER_ONE = 6,    # Rintocco celebrativo vittoria #1
      STADIUM_SOLD_OUT = 7,    # Boato folla e ovazione stadio
      NIGHT_OVERTIME_BELL = 8, # Rintocco campana notturna
      HIGH_SIGNAL_ALERT = 9    # Allarme metallico penetrativo
  }

  enum CareerStatCategory {
      LIFE_AND_TIME = 0,
      MUSIC_AND_DISCOGRAPHY = 1,
      STAGE_AND_TOURS = 2,
      FANDOM_AND_GLORY = 3
  }
  ```
- **Estensioni in `core/constants.gd`**:
  ```gdscript
  # --- Sound Design & Audio Cues (Sezione 12) ---
  const AUDIO_CUE_DEFAULT_DURATION: float = 0.35
  const AUDIO_CUE_CELEBRATION_DURATION: float = 0.85
  const AUDIO_SAFE_SAMPLE_RATE: int = 22050
  ```

---

### Contratto D1: Sound Design, AudioCueSystem & Ducking Automatico
- **File**: `systems/audio_cue_system.gd` (e integrazione in `AccessibilityManager`)
- **Architettura**:
  - Modulo leggero e deterministico capace di generare campioni sonori sintetizzati in memoria (senza dipendenze da file binari esterni orfani) o riprodurre stream caricati.
  - Sintetizzatore di Earcons con forme d'onda pure (sinusoidale armonica, triangolare, quadra filtrata, burst di rumore per piatti/folla):
    * `generate_macro_area_cue(area_id: int) -> AudioStream`
    * `generate_celebration_cue(cue_type: int) -> AudioStream`
  - Canale di riproduzione tramite `AudioStreamPlayer` su bus audio calibrato.
  - **Volume di Sicurezza Assoluto**:
    * Volume base impostato a `AUDIO_SAFE_VOLUME_LINEAR` (0.75f, corrispondente a -2.5 dB `AUDIO_MAX_VOLUME_DB`);
    * Interfaccia di Ducking: all'emissione di `speak()` in `AccessibilityManager`, il volume degli audio cues scende a `0.75 * 0.40 = 0.30f` e risale fluidamente al termine del parlato.
  - **Funzionamento Headless Garantito**:
    * In modalità headless o nei test unitari, il sistema elabora gli stream senza bloccare il main loop, permettendo verifiche a 0 ms.

---

### Contratto D2: Numpad Navigation System (Tastierino Numerico Avanzato)
- **File**: `autoload/accessibility_manager.gd` e `ui/hud/hud.gd`
- **Mapping Funzionale Numpad**:
  - *Navigazione a Blocchi*:
    * `KEY_KP_7`: Salto al blocco precedente (Top Bar -> Centro -> Azioni -> Tab Categorie);
    * `KEY_KP_9`: Salto al blocco successivo (Tab Categorie -> Azioni -> Centro -> Top Bar).
  - *Navigazione Lineare Direzionale*:
    * `KEY_KP_8`: Voce precedente nella lista/pannello attivo (Freccia Su);
    * `KEY_KP_2`: Voce successiva nella lista/pannello attivo (Freccia Giù);
    * `KEY_KP_4`: Colonna/scheda precedente (Freccia Sinistra);
    * `KEY_KP_6`: Colonna/scheda successiva (Freccia Destra).
  - *Interrogazione di Stato ("Dove mi trovo?")*:
    * `KEY_KP_5`: Pronuncia vocale immediata per NVDA della posizione attuale, nome del controllo con focus, e riassunto rapido dello stato di gioco (senza compiere alcuna azione).
  - *Attivazione & Conferma*:
    * `KEY_KP_ENTER`, `KEY_KP_0`: Attiva il pulsante selezionato o apre la modale focalizzata.
  - *Selezione Rapida Macro-Aree*:
    * `KEY_KP_1`: Area 1 (Hub Personale);
    * `KEY_KP_2` (con modifier o a riposo su tab): Area 2 (Creazione & Produzione);
    * `KEY_KP_3`: Area 3 (Carriera & Band);
    * `KEY_KP_4`: Area 4 (Skills & Upgrades).
  - *Controlli Runtime Ausiliari*:
    * `KEY_KP_ADD` (`+`): Incrementa velocità di simulazione (1x -> 2x -> 3x);
    * `KEY_KP_SUBTRACT` (`-`): Decrementa velocità di simulazione o pausa rapida;
    * `KEY_KP_PERIOD` (`.`): Silenzia istantaneamente l'audio cue e la sintesi vocale attiva.
- **Guardie Reattive**:
  - Se il focus è su un `LineEdit` o `TextEdit`, i tasti numerici del Numpad inseriscono i rispettivi caratteri numerici senza attivare le scorciatoie di navigazione.

---

### Contratto D3: Sottosistema Metriche di Carriera in PlayerData
- **File**: `data/models/player_data.gd` e sistemi di simulazione
- **Dati & Metriche Tracciate**:
  - Modello dati per il dizionario persistente `career_stats`:
    ```gdscript
    var career_stats: Dictionary = {
        "total_days_active": 1,
        "total_overtime_nights": 0,
        "total_songs_written": 0,
        "total_singles_released": 0,
        "total_albums_released": 0,
        "total_concerts_performed": 0,
        "total_audience_attended": 0,
        "total_live_earnings": 0.0,
        "total_merch_earnings": 0.0,
        "total_encores_granted": 0,
        "total_stadium_concerts": 0,
        "total_festivals_performed": 0,
        "total_tours_completed": 0,
        "total_royalties_earned": 0.0,
        "total_rehearsals_held": 0,
        "weeks_at_number_one": 0,
        "stadium_sold_outs": 0
    }
    ```
  - **Funzioni di Calcolo e Aggregazione Dinamica**:
    * `get_career_stat(stat_key: String) -> Variant`
    * `increment_career_stat(stat_key: String, amount: Variant = 1) -> void`
    * `get_total_career_earnings() -> float`: somma di live, merch, royalties, premi e anticipi contrattuali;
    * `get_total_records_sold() -> float`: somma delle copie fisiche/digitali di tutti i singoli e album;
    * `get_total_streams() -> int`: somma degli stream accumulati da tutte le tracce;
    * `get_linear_career_summary_speech() -> String`: testo ottimizzato per la lettura sequenziale NVDA.
  - **Aggiornamento Deterministico dai Sistemi Esistenti**:
    * `ConcertSystem`: incrementa concerti, pubblico, incassi live, merch, encore, stadi;
    * `MusicSystem`: incrementa brani scritti;
    * `AlbumSystem`: incrementa singoli e album pubblicati;
    * `TourSystem`: incrementa tour completati;
    * `FestivalSystem`: incrementa festival eseguiti;
    * `ChartSystem`: incrementa settimane al #1;
    * `EndDaySystem`: incrementa giorni attivi, notti in overtime, royalties notturne.
  - **Persistenza & Retrocompatibilità**:
    * Inclusione sicura in `to_dict()` e `from_dict()` con popolamento automatico dei default se caricato da savegame precedenti.

---

### Contratto D4: Dashboard Statistiche Globali nel SystemMenuModal
- **File**: `ui/system_menu/system_menu_modal.gd` e `system_menu_modal.tscn`
- **Riorganizzazione Strutturale del Menu di Sistema (Tasto Esc)**:
  - Voci del menu principale a 5 pulsanti:
    * `1. Riprendi Partita` (Esc o 1)
    * `2. Salva Partita` (2)
    * `3. Statistiche di Carriera` (3) — *Nuova Voce*
    * `4. Impostazioni e Accessibilità` (4)
    * `5. Torna al Menu Principale` (5)
- **Nuovo Pannello `PanelCareerStats`**:
  - Contenitore interno ad alto contrasto con 4 blocchi lineari:
    * *Blocco 1: Vita & Tempo* (Giorni vissuti, notti overtime, alloggio, patrimonio netto);
    * *Blocco 2: Discografia & Musica* (Brani composti, album rilasciati, vendite complessive, stream);
    * *Blocco 3: Palco & Live* (Concerti, spettatori totali, incassi palco, festival, stadi);
    * *Blocco 4: Fandom & Riconoscimenti* (Fan mondiali, certificazioni Oro/Platino/Diamante, premi vinti, Hall of Fame).
  - Pulsante *"Ascolta Riepilogo Completo"* (`btn_read_all_stats`): invia a `AccessibilityManager.speak()` l'intero resoconto riga per riga.
  - Pulsante *"Torna al Menu di Sistema"* (`btn_back_stats` o `Esc`): ritorna al menu precedente mantenendo lo stato di pausa.
  - Hook semantici AccessKit su ogni riga e statistica per lettura con frecce / Numpad.

---

### Contratto D5: Cablaggio Audio Cues, Macro-Aree & EventBus
- **File**: `ui/hud/hud.gd`, `autoload/event_bus.gd`
- **Integrazione**:
  - Quando il giocatore cambia Macro-Area (`select_category_tab(1..4)` con tasti `1`..`4`, `KP_1`..`KP_4` o click):
    * Riproduce l'Earcon caratteristico dell'area a volume calibrato (0.70f - 0.75f);
  - Segnali dedicati su `EventBus`:
    * `audio_cue_requested(cue_type: int)`
    * `career_milestone_achieved(milestone_name: String, cue_type: int)`
  - Reazione agli eventi salienti:
    * Ricezione di una certificazione discografica (`AwardSystem`) -> Earcon `CERTIFICATION_AWARD`;
    * Conquista della prima posizione in classifica (`ChartSystem`) -> Earcon `CHART_NUMBER_ONE`;
    * Sold out in uno stadio da 65.000 posti (`ConcertSystem`) -> Earcon `STADIUM_SOLD_OUT`;
    * Raggiungimento delle ore 02:00 in overtime (`TimeSystem`) -> Earcon `NIGHT_OVERTIME_BELL`.

---

### Contratto D6: Nuova Test Suite Headless a 0 ms & Verifica di Regressione
- **File**: `tests/test_ui_audio_and_numpad_system.gd` e `test_ui_audio_and_numpad_system.tscn`
- **Copertura Asserzioni**:
  1. *AudioCueSystem*: generazione campioni sintetizzati, validità stream, durata, assenza errori headless;
  2. *Volume & Ducking*: volume entro i vincoli di sicurezza (<= 0.75f), attivazione ducking al 40% durante TTS e ripristino;
  3. *Tasti Numpad*: routing di `KP_1`..`KP_4`, `KP_7`/`KP_9` (blocchi), `KP_8`/`KP_2` (verticale), `KP_5` (query stato), `KP_ADD`/`KP_SUBTRACT` (velocità);
  4. *Guardia LineEdit*: pressione tasti Numpad con campo testo attivo (nessuna intercettazione anomala);
  5. *Metriche PlayerData*: inizializzazione, incremento e calcolo aggregato (guadagni totali, vendite, stream, concerti);
  6. *Persistenza Statistiche*: serializzazione in `to_dict()` e deserializzazione da `from_dict()`;
  7. *SystemMenuModal*: apertura pannello statistiche, 5 voci di menu, vocalizzazione riassuntiva e ritorno con Esc;
  8. *Assenza Regressioni*: esecuzione di tutte le 26 suite esistenti + nuova suite (totale 27 suite superate al 100% con 0 errori a 0 ms).

---

## ⚖️ 4. VALIDAZIONE PREVENTIVA SUI 7 ASSI DI QUALITÀ

1. **Asse 1 — Validità**: Tipi rigorosi GDScript 2.0 statici, pattern Clean Architecture, modularità decoupled tramite `EventBus`.
2. **Asse 2 — Efficacia**: Risolve direttamente l'accessibilità sensoriale (feedback acustico di orientamento) e l'ergonomia fisica (controllo rapido a una sola mano con tastierino numerico).
3. **Asse 3 — Coerenza**: Perfetta armonia con l'architettura a 4 Macro-Aree di `HUD`, con `SystemMenuModal` e con il bridge `AccessibilityManager`.
4. **Asse 4 — Completezza**: Copre sia la navigazione da tastiera sia la consultazione visiva e vocale dei dati di carriera, gestendo tutti gli eventi rilevanti (certificazioni, classifiche, stadi).
5. **Asse 5 — Precisione**: Modifiche chirurgiche e mirate; nessun impatto distruttivo sui 15 tasti rapidi alfabetici esistenti.
6. **Asse 6 — Affidabilità & Prestazioni**: Sintesi procedurale leggera in memoria a zero latenza; nessuna dipendenza da file audio pesanti esterni; esecuzione headless a 0 ms.
7. **Asse 7 — Assenza Regressioni**: Compatibilità garantita con i salvataggi preesistenti e blindatura totale con suite automatizzata da 27 file.

---

## 🔬 5. I 3 LIVELLI DI SIMULAZIONE

- **Livello 1 (Happy Path)**:
  - Il giocatore preme `KP_1`..`KP_4` per alternare le 4 Macro-Aree; per ciascuna area viene riprodotto il feedback acustico tipico a volume sicuro;
  - Il giocatore naviga con `KP_8` e `KP_2`, interroga lo stato con `KP_5` e attiva un'azione con `KP_ENTER`;
  - Il giocatore apre il Menu di Sistema con `Esc`, preme `3`, ascolta le statistiche complessive di carriera lette da NVDA e riprende con `Esc`.
- **Livello 2 (Casi Alternativi & Flussi Concorrenti)**:
  - Utilizzo alternato di tasti convenzionali (`1`..`4`, `Esc`, Frecce) e tasti Numpad (`KP_1`..`KP_4`, `KP_ENTER`);
  - Generazione di un audio cue durante la lettura continua di NVDA: il ducking riduce fluidamente il volume dell'effetto sonoro senza coprire la voce;
  - Consultazione statistiche su partita appena creata (tutti i contatori a zero con formattazione pulita) rispetto a fine carriera V5.0 (milioni di fan e stadi pieni).
- **Livello 3 (Corner Cases & Limiti Fisiologici)**:
  - Pressione dei tasti Numpad mentre il giocatore sta digitando il nome della band o di un brano in un `LineEdit`: i tasti numerici scrivono cifre senza scatenare scorciatoie;
  - Caricamento di un vecchio salvataggio `savegame.json` privo del campo `career_stats`: popolamento automatico retrocompatibile da brani, concerti e certificazioni esistenti senza perdita dati o crash;
  - Ambiente headless o privo di driver audio: la generazione e riproduzione non generano eccezioni, né deadlock o crash.

---

## 🛑 STOP OBBLIGATORIO DI SOTTO-FASE 1A (REGOLA 0)

In osservanza della **Regola 0 (Default Consultivo Permanente)** e del Canone ASTRALIS per la **Sotto-Fase 1A**:
- Il presente Piano Tecnico Formale è redatto in `docs/piani/attivi/PIANO_SEZIONE_12_SOUND_DESIGN_AUDIO_CUES_NUMPAD_E_STATISTICHE.md`.
- **Nessuna modifica al codice sorgente, alle scene o ai file di configurazione è stata effettuata.**
- Antigravity si arresta e attende la formale approvazione di Luca (*"procedi"*, *"applica"*, *"esegui"*) prima di passare alla **Sotto-Fase 1B (Esecuzione Tecnica & Test Headless)**.
