# Strategia Correttiva e Integrazione Sistemica — Lingua di Avvio & Modifica Bozze
# Data: 22 Settembre 2026
# Riferimento Revisioni: RRU-02 (Lingua OS / Settings) & RRU-03 (Modifica Bozze Discografiche)
# Destinatari: Luca (Sviluppatore Senior) & Tom (Holy Diver)

---

## 1. INQUADRAMENTO DELLE CRITICITÀ OSSERVATE NEL COLLAUDO

Nel corso del collaudo pratico della Fase 3 (Music Crafting) sono emersi due requisiti di rifinitura e perfezionamento:

1. **Criticità 1 (RRU-02) — Mancato avvio predefinito in lingua italiana**:
   - *Sintomo*: Al primo avvio dell'applicativo tramite `tools/run.ps1`, la lingua dell'interfaccia resta in inglese invece di presentarsi in italiano.
   - *Causa Radice*: La suite di test headless `test_localization.gd` eseguita durante la Fase 1 di pre-flight scriveva fisicamente nel file persistente `user://settings.json` la coppia chiave-valore `{"language": "en"}` senza eseguire il teardown/ripristino al termine della verifica. Inoltre, la funzione `_init_language_from_system_or_settings()` di `LocalizationManager` adottava `"en"` come fallback alternativo se la stringa di sistema non corrispondeva a `"it"`, anziché ancorarsi al `DEFAULT_LOCALE = "it"`.

2. **Criticità 2 (RRU-03) — Impossibilità di modificare o riprendere una bozza di canzone salvata**:
   - *Sintomo*: Quando un brano viene salvato come bozza (`DRAFT`) e riposto nel catalogo, non esiste alcuna opzione per riaprirlo, modificarne il titolo/genere/tema o proseguire la produzione dagli stadi successivi (composizione, scrittura testi, registrazione, mastering).
   - *Causa Radice*: `SongCreator` supportava esclusivamente l'inizializzazione ex-novo (`start_new_song()`), generando ogni volta un nuovo ID canzone e azzerando le proprietà. `SongCatalog` non forniva bottoni interattivi per le bozze in elenco, limitandosi al pulsante di rilascio singolo solo per i brani già prodotti (`PRODUCED`).

---

## 2. STRATEGIA CORRETTIVA SISTEMICA E STRUTTURALE

La soluzione adotta un approccio integrativo a quattro livelli che rispetta la Clean Architecture e la Simmetria Universale (Luca con NVDA/tastiera e Tom a monitor):

### Livello A: Bonifica Persistenza & Fallback Lingua (RRU-02)
- **`tests/test_localization.gd`**:
  - Al termine del test `test_save_manager_settings()`, introduzione del teardown obbligatorio che ripristina esplicitamente `user://settings.json` allo stato di default:
    ```gdscript
    SaveManager.save_settings({"language": "it"})
    ```
- **`autoload/localization_manager.gd`**:
  - Riformulazione di `_init_language_from_system_or_settings()`:
    1. Se `user://settings.json` esiste ed è valido, usa la lingua salvata.
    2. Se non esiste o è vuoto, interroga `OS.get_locale_language()`; se vuoto, interroga `OS.get_locale()`.
    3. Se la lingua rilevata inizia per `"en"`, imposta `"en"`. In tutti gli altri casi (incluso italiano o codici non determinabili), imposta rigorosamente `DEFAULT_LOCALE` (`"it"`).
    4. Persiste l'impostazione pulita su disco.

---

### Livello B: Studio Musicale Guidato — Metodo `edit_existing_song` (RRU-03)
- **`ui/music/song_creator.gd`**:
  - Aggiunta della funzione pubblica `edit_existing_song(song: SongData) -> void`:
    - Assegna `current_song = song` (mantenendo l'ID univoco e i dati già maturati).
    - Popola lo Step 1 con i dati correnti:
      * `edit_title.text = song.title`
      * Selezione dell'indice corretto per `song.genre` in `opt_genre`.
      * Selezione dell'indice corretto per `song.theme` in `opt_theme`.
    - Determina lo step visibile in base a `song.stage`:
      * Se `song.stage == Enums.SongStage.CONCEPT`: apre Step 1 (permette di modificare titolo, genere, tema e procedere a Step 2).
      * Se `song.stage == Enums.SongStage.COMPOSITION`: apre Step 2 (composizione melodia/riff, con opzione burst).
      * Se `song.stage == Enums.SongStage.SONGWRITING`: apre Step 3 (scrittura del testo).
      * Se `song.stage == Enums.SongStage.RECORDING`: apre Step 4 (scelta studio Home vs Pro ed incisione).
      * Se `song.stage == Enums.SongStage.MIXING`: apre Step 5 (finalizzazione master).
  - Revisione di `_on_btn_action_pressed()` per Step 1:
    - Se `current_song != null`, aggiorna semplicemente titolo, genere e tema del brano esistente (`current_song.title = s_title`, ecc.) e avanza a Step 2, senza richiamare `ms.create_draft()`, scongiurando duplicazioni nel catalogo.

---

### Livello C: Catalogo Discografico Interattivo (RRU-03)
- **`ui/music/song_catalog.gd`**:
  - Aggiunta del segnale `signal edit_song_requested(song: SongData)`.
  - In `_create_song_row(index: int, song: SongData)`:
    - Se `song.status == Enums.SongStatus.DRAFT`:
      * Creazione pulsante aggiuntivo `BtnEdit` ("Modifica Bozza" / "Continua").
      * Collegamento del click su `BtnSelect` (il bottone principale della riga) e su `BtnEdit` per emettere `edit_song_requested.emit(song)`.
      * Etichetta AccessKit parlante per NVDA: *"Bozza %d: %s. Premi Invio per riprendere la lavorazione o modificare titolo e genere."*.

---

### Livello D: Cablaggio Globale HUD & Localizzazione (RRU-03)
- **`ui/hud/hud.gd`**:
  - Connessione del segnale:
    ```gdscript
    song_catalog_modal.edit_song_requested.connect(open_song_editor)
    ```
  - Implementazione del metodo `open_song_editor(song: SongData)`:
    - Chiude il catalogo brani (`close_catalog()`).
    - Mostra il modal dello studio (`song_creator_modal.visible = true`).
    - Avvia la modifica: `song_creator_modal.edit_existing_song(song)`.
    - Garantisce il mantenimento della Pausa Dinamica (`GameManager.open_menu()`).
- **`localization/it.json` & `en.json`**:
  - Aggiunte stringhe speculari:
    * `"CATALOG_BTN_EDIT"`: `"Modifica Bozza"` / `"Edit Draft"`
    * `"CATALOG_BTN_EDIT_ACC_DESC"`: `"Riprende la lavorazione del brano dallo stadio attuale o ne modifica i metadati."` / `"Resumes crafting from current stage or edits song metadata."`
    * `"CREATOR_TITLE_EDIT"`: `"Modifica & Produzione Bozza"` / `"Edit & Produce Draft"`

---

## 3. ANALISI DI CONVALIDA A 7 ASSI (GENOMA DI GOVERNANCE)

1. **Asse 1 — Validità**: Rispetto rigoroso dei tipi e delle firme; nessuna allocazione anomala, gestione sicura dei puntatori di `SongData`.
2. **Asse 2 — Efficacia**: Risolve alla radice sia l'inquinamento della lingua sia il problema funzionale del resume delle bozze.
3. **Asse 3 — Coerenza**: Mantiene intatta l'architettura a Layer Differenziati e la gestione a stati della FSM di `GameManager`.
4. **Asse 4 — Completezza**: Copre tutti e 5 gli stadi del ciclo creativo (dalla rinomina alla finalizzazione del master) e gestisce il teardown dei test.
5. **Asse 5 — Precisione**: Modifiche chirurgiche e localizzate, senza toccare file non pertinenti.
6. **Asse 6 — Affidabilità & Prestazioni**: Nessun sovraccarico computazionale, riutilizzo delle istanze dei controlli già presenti nell'albero di scena.
7. **Asse 7 — Assenza Regressioni**: Compatibilità totale retroattiva per i salvataggi esistenti e per il flusso standard di creazione da zero ("Nuovo Brano").
