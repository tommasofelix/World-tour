# Archivio delle revisioni validate — World-tour

Le revisioni vengono archiviate qui soltanto dopo risoluzione verificata e accettazione del relativo criterio di chiusura. Le voci più recenti devono essere inserite in cima.

## Revisioni archiviate

### RRU-04 — Trasparenza Finestre Modali e Interferenza Lettura AccessKit/NVDA con HUD Sottostante

- Stato: `[x] RISOLTA E VALIDATA`.
- Data di chiusura: `2026-09-22`.
- Componente: `ui/hud/hud.gd`, `ui/music/song_catalog.tscn`, `ui/music/song_creator.tscn`, `ui/concert/live_concert.tscn`.
- Sintomo osservato: Durante l'apertura delle schede/modali di gioco (Catalogo, Creazione brano, Concerti), lo screen reader NVDA leggeva le etichette dell'HUD sottostante ("Giorno 1", "Allenamento", "Pausa", ecc.), e visivamente la trasparenza dei margini/pannelli mostrava i comandi dell'HUD a monitor.
- Evidenza: `VBoxMain` nell'HUD manteneva `visible = true`, esponendo i suoi nodi all'albero UIA/AccessKit; assenza di fondale a tutto schermo (`Backdrop`) e assenza di `StyleBoxFlat` opaco su `PanelMain`.
- Causa radice: Compenetrazione di visibilità tra HUD e modali sia nel rendering grafico che nell'albero UIA di Godot 4 AccessKit.
- Soluzione applicata:
  1. Toggle sistemico di `$VBoxMain.visible = false` in `ui/hud/hud.gd` all'apertura delle modali e ripristino a `true` alla chiusura con focus sul pulsante relativo.
  2. Aggiunta del nodo `Backdrop: ColorRect` (100% schermo, colore opaco `#050508`, `mouse_filter = 0`) in tutte le modali.
  3. Applicazione di `StyleBoxFlat` solido opaco con bordo di contrasto su `PanelMain`.
- Test automatici eseguiti: 5 suite su 5 superate (53/53 test concerti, 125/125 test crafting, 43/43 test vertical slice).
- Collaudo manuale eseguito: Collaudo reale in-game confermato da Luca con NVDA (isolamento totale del focus e zero lettura sotto la scheda) e da Tom a monitor (zero trasparenze indesiderate).

### RRU-02 — Fallback Lingua OS e Inquinamento settings.json da Suite di Test

- Stato: `[x] RISOLTA E VALIDATA`.
- Data di chiusura: `2026-09-22`.
- Componente: `tests/test_localization.gd` e `autoload/localization_manager.gd`.
- Sintomo osservato: Al primo avvio in-game l'interfaccia si presentava in lingua inglese anziché in italiano.
- Evidenza: `user://settings.json` persisteva `"language": "en"` scritto dal test unitario senza teardown; `LocalizationManager` utilizzava `"en"` come fallback automatico.
- Causa radice: Mancanza di isolamento e ripristino dell'ambiente nei test automatici e logica di fallback OS permissiva.
- Soluzione applicata: Teardown obbligatorio che ripristina `{"language": "it"}` in `tests/test_localization.gd` e fallback deterministico su `DEFAULT_LOCALE = "it"` in `autoload/localization_manager.gd`.
- Test automatici eseguiti: 96/96 test superati in `test_localization.gd`, verifica fisica di `user://settings.json` con `"language": "it"`.
- Collaudo manuale eseguito: Avvio in-game con interfaccia al 100% in lingua italiana confermato da Luca e Tom.

### RRU-03 — Mancanza di Flusso per Modifica Metadati e Ripresa Lavorazione Bozze (SongDraft Editing)

- Stato: `[x] RISOLTA E VALIDATA`.
- Data di chiusura: `2026-09-22`.
- Componente: `ui/music/song_catalog.gd`, `ui/music/song_creator.gd`, `ui/music/song_creator.tscn`, `ui/hud/hud.gd`, `data/models/song_data.gd`.
- Sintomo osservato: Impossibilità di riaprire una bozza salvata per rinominarla, cambiarne genere/tema o completare gli stadi di produzione successivi.
- Evidenza: `SongCatalog` non offriva azioni per elementi `DRAFT`; `SongCreator` creava sempre un'istanza vuota `start_new_song()` con ID nuovo.
- Causa radice: Mancanza di un endpoint dedicato `edit_existing_song(song)`, del segnale `edit_song_requested` nel catalogo, del cablaggio nell'HUD e del pulsante di modifica anagrafica.
- Soluzione applicata: Aggiunta `edit_existing_song(song)` in `SongCreator`, pulsante `BtnEditInfo` per ritorno a Fase 1 da qualsiasi step avanzato, `BtnEdit` per le bozze in `SongCatalog`, segnale `edit_song_requested` cablato a `open_song_editor` nell'HUD, aggiornamento `EventBus.song_updated` e helper `get_stage_name()` in `SongData`.
- Test automatici eseguiti: 125/125 test superati in `test_music_system.gd` (con nuovo test 9 di modifica e ripresa bozze), 43/43 test in `test_vertical_slice.gd`.
- Collaudo manuale eseguito: Collaudo reale con NVDA e tastiera superato con successo da Luca e Tom (modifica titolo, ripresa composizione e produzione).

### RRU-01 — Errore Runtime Accesso Proprietà Tema in SongCatalog (_create_song_row)

- Stato: `[x] RISOLTA E VALIDATA`.
- Data di chiusura: `2026-09-22`.
- Componente: `ui/music/song_catalog.gd` (riga 90) e reazione al segnale `EventBus.song_created`.
- Sintomo osservato: Blocco interfaccia e `SCRIPT ERROR` in console durante la creazione di una nuova bozza brano nello studio.
- Evidenza: Log runtime `godot2026-09-22T12.40.56.log` e `godot2026-09-22T12.41.36.log`: `Invalid access to property or key 'theme_override_constants' on a base object of type 'HBoxContainer'`. Dettagli completi in [`docs/report/DIAGNOSTICA_TELEMETRIA_COLLAUDO_FASE_3.md`](./DIAGNOSTICA_TELEMETRIA_COLLAUDO_FASE_3.md).
- Causa radice: Chiamata non valida all'API di tema di Godot 4 (`row.theme_override_constants.separation = 15` anziché `row.add_theme_constant_override("separation", 15)`).
- Soluzione applicata: Correzione del metodo API in `ui/music/song_catalog.gd` con guardia `vbox_songs` in `refresh_catalog()`.
- Test automatici eseguiti: Estensione di `tests/test_music_system.gd` con popolazione fittizia e rendering dinamico dei brani (109/109 asserzioni superate).
- Collaudo manuale eseguito: Collaudo reale in-game superato con successo da Luca e Tom con completamento dell'intero flusso di composizione, registrazione e rilascio singolo.
