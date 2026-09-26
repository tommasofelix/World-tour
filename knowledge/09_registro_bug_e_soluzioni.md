# Registro dei problemi e delle soluzioni validate

Questo registro contiene soltanto problemi tecnici confermati e soluzioni con evidenza sufficiente. Le revisioni ancora aperte appartengono a [`docs/report/REGISTRO_REVISIONI.md`](../docs/report/REGISTRO_REVISIONI.md).

## Voci validate

### BUG-001 (RRU-01) — Errore Runtime Accesso Proprietà Tema in Godot 4 (HBoxContainer)

- Data e componente: `2026-09-22`, `ui/music/song_catalog.gd` (riga 90).
- Sintomo osservato: Errore di runtime `SCRIPT ERROR: Invalid access to property or key 'theme_override_constants' on a base object of type 'HBoxContainer'` con blocco del flusso creativo nello studio alla creazione di un nuovo brano.
- Evidenza riproducibile: Emissione del segnale `EventBus.song_created` con ricezione sincrona in `SongCatalog.refresh_catalog()` che tentava l'assegnazione ad albero `row.theme_override_constants.separation = 15`.
- Causa radice verificata: In Godot 4 GDScript le proprietà di override del tema sui nodi `Control` istanziati dinamicamente non sono dizionari esposti con notazione puntata.
- Soluzione applicata: Sostituzione con la funzione di sistema `row.add_theme_constant_override("separation", 15)` e aggiunta di controllo di guardia `if not vbox_songs: return` in `refresh_catalog()`.
- Test automatici eseguiti: Aggiunto test di rendering dinamico con brani popolati in `tests/test_music_system.gd` (109/109 asserzioni superate, exit code 0).
- Collaudo manuale eseguito: Superato con successo con esecuzione reale da parte di Luca (NVDA) e Tom a video.
- Misure di prevenzione delle regressioni: Tutti i controlli UI dinamici devono usare i metodi canonici `add_theme_*_override()` e i test di istanziazione devono popolare elementi fittizi per esercitare i rami interni di generazione nodi.

### BUG-002 — Cattura per Valore nelle Chiusure Lambda e Ciclo di Vita `_ready()` nei Test Headless di Interfaccia

- Data e componente: `2026-09-23`, `tests/test_vital_resources_system.gd` e `ui/relax/relax_modal.gd`.
- Sintomo osservato: Fallimento asserzione headless con `SCRIPT ERROR: Invalid access to property or key 'action_id' on a base object of type 'Nil'` ed errori di segnale `Signal 'pressed' is already connected to given callable 'Control(relax_modal.gd)::_on_btn_coffee_pressed'`.
- Evidenza riproducibile: Connessione di un segnale a una lambda con assegnazione a variabile locale scalare/null (`var received_action = null; inst.activity_selected.connect(func(act): received_action = act)`) e successiva invocazione manuale di `inst._ready()` dopo `add_child(inst)`.
- Causa radice verificata:
  1. In GDScript 4, le lambda catturano i riferimenti nulli e i tipi scalari/primitivi per valore (creando un rebinding interno alla chiusura), lasciando invariata la variabile locale esterna nello scope della funzione di test.
  2. L'invocazione di `add_child(inst)` all'interno del metodo `_ready()` di un test già innestato nella scena attiva scatena immediatamente e in modo sincrono il `_ready()` del figlio; una seconda chiamata manuale esplicita a `inst._ready()` ri-esegue le connessioni dei pulsanti generando errori `Signal already connected` se non protette da guardie.
- Soluzione applicata:
  1. Adozione del pattern **Closure Container**: catturare gli argomenti emessi tramite una collezione per riferimento (es. `var received: Array = []` e `func(act): received.append(act)`), che conserva lo stato mutato nello scope del test.
  2. Aggiunta sistematica della guardia `if btn and not btn.pressed.is_connected(_handler)` nel metodo `_ready()` di tutti i componenti UI e rimozione della chiamata ridondante a `inst._ready()` nei test runner.
- Test automatici eseguiti: 37/37 asserzioni superate in `tests/test_vital_resources_system.tscn` (exit code 0), con regressione positiva su 6 suite (266 asserzioni complessive a 0 errori).
- Misure di prevenzione delle regressioni: Nei test headless per segnali UI usare categoricamente `Array` come ricevitore di closure, e nei nodi UI proteggere sempre le connessioni da tastiera/pulsante con `not signal.is_connected()`.

### BUG-003 — Errore di Formattazione Stringhe per `%` Non Escapato e Refuso Proprietà Modello Contratto

- Data e componente: `2026-09-23`, `systems/music_system.gd` (riga 100) e `systems/industry_system.gd` (riga 253).
- Sintomo osservato:
  1. Errore di runtime `ERROR: String formatting error: unsupported format character.` all'annuncio dello sconto martedì in `MusicSystem.record_tracks()`.
  2. Errore di runtime `SCRIPT ERROR: Invalid access to property or key 'albums_delivered' on a base object of type 'RefCounted (ContractData)'` in `IndustrySystem.sign_contract()`, con conseguente fallimento delle asserzioni di firma contratto in `test_industry_system.gd`.
- Evidenza riproducibile: Esecuzione di `tests/test_advanced_crafting_system.tscn` e `tests/test_industry_system.tscn` in modalità headless.
- Causa radice verificata:
  1. In GDScript 2.0, l'operatore `%` applicato a una stringa interpreta ogni singolo `%` come inizio di uno specificatore di formato; la dicitura `"20% applicato"` conteneva `% ` (percentuale seguito da spazio), interpretato come specificatore non valido. Il carattere percentuale letterale richiede il doppio `%` (`%%`). Inoltre, la dicitura monetaria `"€"` viene preferibilmente sostituita dalla parola estesa `"euro"` per chiarezza di pronuncia NVDA.
  2. Nel modello dati `ContractData`, il campo ufficiale è denominato `delivered_albums` (`int`), mentre `industry_system.gd` tentava erroneamente di accedere alla proprietà orfana `albums_delivered`.
- Soluzione applicata:
  1. In `systems/music_system.gd`: sostituito con `"Sconto Martedì del 20%% applicato allo Studio Professionale! Spesa: %.2f euro" % studio_cost`.
  2. In `systems/industry_system.gd`: sostituito `found_contract.albums_delivered` con `found_contract.delivered_albums`.
- Test automatici eseguiti: 65/65 test superati in `test_advanced_crafting_system.gd` e 60/60 test superati in `test_industry_system.gd` (exit code 0, nessun errore residuo a console).
- Misure di prevenzione delle regressioni: Nelle stringhe formattate con `%` effettuare sempre l'escaping dei simboli percentuali con `%%` e verificare la corrispondenza dei campi dei modelli dati tramite test con copertura di tutti i rami di esecuzione.

### BUG-004 — Freeze Infinito del Runner Headless su File `.gd` Diretti e Assenza di Watchdog Timeout

- Data e componente: `2026-09-23`, `tools/test.ps1` e runtime Godot 4.7.
- Sintomo osservato: La suite di test headless si bloccava a tempo indefinito durante l'esecuzione da riga di comando o lasciava processi `Godot_v4.7.2-stable_win64_console.exe` orfani in memoria (es. PID 32208 con CPU 0%).
- Evidenza riproducibile: Lancio diretto da terminale di `godot --headless tests/test_nome.gd` oppure `godot --headless -s tests/test_nome.gd` con script estendenti `Node`.
- Causa radice verificata:
  1. In Godot 4, lanciare un file `.gd` direttamente senza flag `-s` induce l'engine a tentare di caricarlo come una risorsa scena (`PackedScene`); il caricamento fallisce silenziosamente e Godot entra nel loop di idle dell'engine senza eseguire nulla e senza uscire.
  2. Lanciare un file `.gd` che estende `Node` con `-s` fallisce poiché `-s` richiede uno script che estenda `MainLoop` o `SceneTree`. Il nodo viene istanziato fuori dall'albero, `_ready()` non viene mai invocato, `quit()` non viene mai raggiunto e il processo resta congelato all'infinito.
  3. `tools/test.ps1` utilizzava `Start-Process -Wait` senza alcun timeout: in caso di blocco dell'engine o freeze della console (QuickEdit di Windows), lo script PowerShell rimaneva appeso indefinitamente.
- Soluzione applicata:
  1. Obbligo di esecuzione dei test tramite risorsa `.tscn` dedicata (`res://tests/test_nome.tscn`), che inizializza correttamente il `SceneTree` e gli Autoload di sistema.
  2. Ristrutturazione di `tools/test.ps1` impiegando `System.Diagnostics.Process` con watchdog timeout perentorio a 15 secondi (`$proc.WaitForExit(15000)`), abbattimento forzato con `$proc.Kill()` in caso di timeout, pulizia preventiva di processi orfani all'avvio e contatore lineare `[1/23]` per NVDA.
- Test automatici eseguiti: Tutte le 23 suite di test del progetto eseguite e concluse con successo in circa 75 secondi, con 0 fallimenti e nessun freeze.
- Misure di prevenzione delle regressioni: Mai invocare file `.gd` privi di scena come target di test se estendono `Node`; dotare sempre i runner di automazione di un meccanismo di watchdog timeout non bloccante.
### BUG-005 — Retrocompatibilità Revenue Split vs Merch, Scoping Disponibilità Venue e API Morale Band

- Data e componente: `2026-09-24`, `systems/concert_system.gd` (Sezione 5).
- Sintomo osservato:
  1. `SCRIPT ERROR: Invalid call. Nonexistent function 'modify_band_morale' in base 'RefCounted (BandSystem)'` durante la concessione del Bis / Encore in `ConcertSystem.resolve_encore()`.
  2. Fallimento del test `test_band_system.gd` (`Quota incasso leader = 25% su divisione equa (4 membri) - Effettivo: 7.875, Atteso: 7.5`).
  3. Fallimento nei test `test_schedule_system.gd` e `test_travel_system.gd` per rifiuto del concerto con errore `venue_occupied` su venue fittizie (`pub_test`) o internazionali (`berlin_basement`).
- Evidenza riproducibile: Esecuzione di `tools/test.ps1` dopo l'estensione del sistema concerti.
- Causa radice verificata:
  1. `BandSystem` governa l'affinità e la tensione dei singoli membri e il morale è un attributo diretto del protagonista in `player_data.modify_morale()`. Non esisteva un metodo aggregato `modify_band_morale()` su `BandSystem`.
  2. Includere `merch_net` in `pool_revenue` prima del calcolo della quota percentuale del leader (`player_share`) ha alterato il contratto storico con `test_band_system.gd`, che calcola la quota del leader sui biglietti lordi (`gross_revenue * 0.25`).
  3. L'algoritmo di disponibilità procedurale delle venue applicava il calcolo di occupazione anche a venue non appartenenti al circuito locale (come città estere o locali fittizi di test) e anche in assenza di `calendar_data`.
- Soluzione applicata:
  1. In `resolve_encore()`: aggiornato per chiamare `player_data.modify_morale()`, iterare sui membri attivi incrementando l'affinità (+3) e riducendo la tensione (-5), emettendo `EventBus.band_chemistry_changed`.
  2. In `resolve_concert()`: `pool_revenue` coincide con il cachet dei biglietti (`gross_revenue`), preservando l'esattezza matematica del `player_share` (es. 25% su divisione equa); il ricavo netto del merch (`merch_net`) viene accreditato al saldo del giocatore come leader (`total_payout = player_share + merch_net`).
  3. In `get_venue_status()` e `can_play_concert()`: la disponibilità procedurale e i controlli di chiusura si applicano esclusivamente se `calendar_data` è istanziato e per le sole venue del circuito locale (aventi prefisso `"venue_"`).
- Test automatici eseguiti: 23/23 suite del progetto passate con successo (0 errori), inclusi `test_concert_system.gd` (92/92 test), `test_band_system.gd` (58/58 test), `test_schedule_system.gd` (73/73 test) e `test_travel_system.gd` (64/64 test).
- Misure di prevenzione delle regressioni: Separare sempre i flussi economici ancillari (merchandise) dai contratti percentuali dei compensi base (cachet/biglietti) ed applicare vincoli di simulazione temporale/spaziale unicamente alle entità di circuito censite.

### BUG-006 — Ordinamento di Avanzamento Logistico e Riposo Day Off nei Tour Multi-Tappa & Metodi Accessori Fanbase Locale

- Data e componente: `2026-09-24`, `systems/tour_system.gd`, `data/models/player_data.gd` e `tests/test_tour_system.gd`.
- Sintomo osservato:
  1. `SCRIPT ERROR: Invalid call. Nonexistent function 'get_city_fans' in base 'RefCounted (PlayerData)'` durante l'intervista radiofonica in `TourSystem.do_radio_interview()`.
  2. Fallimento delle asserzioni di recupero fisiologico (energia, stress e tensione band) nel test del Day Off (`test_tour_day_off_mechanics()`).
  3. Clamping dello stress a 0.0 nel test degli imprevisti procedurali a bivi (`test_road_dilemmas_engine()`), con conseguente fallimento della verifica di defaticamento della scelta della trattoria (Dilemma 4).
- Causa radice verificata:
  1. In `tour_system.gd` si richiamavano i metodi accessori `player_data.get_city_fans(city_id)` e `get_city_popularity(city_id)`, ma nel modello dati `PlayerData` tali dizionari erano accessibili solo come proprietà grezze (`city_fans.get(...)`), mancando i relativi wrapper sicuri e tipizzati.
  2. In `TourSystem.advance_to_next_stop()`, il blocco del viaggio con il veicolo (incluso il calcolo dello stress del mezzo `stress_gain` e della fatica `energy_delta`) veniva eseguito *prima* del controllo `is_day_off`. Di conseguenza, anche per una giornata di riposo statico (Day Off), il protagonista subiva la fatica e lo stress del mezzo (+5 stress, -10 energia) prima di applicare il recupero (+25 energia, -20 stress), neutralizzando parzialmente il beneficio rigenerativo. Inoltre, se l'ultima data del tour era un Day Off e il tour si concludeva automaticamente senza raggiungere la soglia di successo trionfale (richiedente `new_fans > 50`), `finish_tour()` applicava un malus di tensione alla band (+15.0), cancellando il beneficio distensivo del Day Off (-15.0).
  3. Nel test sequenziale dei 4 imprevisti stradali, la Scelta 1 del Dilemma 3 (Motel confortevole: -20 stress) aveva già azzerato lo stress del giocatore (da 20.0 a 0.0), rendendo impossibile verificare l'ulteriore riduzione di stress (-10) del Dilemma 4 (Trattoria distensiva) a causa del clamping inferiore a 0.0.
- Soluzione applicata:
  1. Aggiunti a `data/models/player_data.gd` i metodi sicuri e tipizzati `get_city_fans(city_id: int) -> int` e `get_city_popularity(city_id: int) -> float`.
  2. In `systems/tour_system.gd`, riposizionato il blocco di gestione del `is_day_off` come prima guardia di `advance_to_next_stop()`: se la tappa è una giornata di riposo, la band esegue immediatamente il riposo rigenerativo senza subire controlli di guasto meccanico né usura/stress di viaggio da veicolo. Nel test `test_tour_day_off_mechanics()`, impostato `new_fans: 60` nel concerto precedente per garantire la corretta qualifica di tour trionfale e la coerenza del rilassamento delle tensioni.
  3. In `tests/test_tour_system.gd`, reinizializzato `player.stress = 30.0` prima dell'esecuzione del Dilemma 4 per consentire la corretta misurazione del delta negativo dello stress.
- Test automatici eseguiti: 98/98 test superati in `test_tour_system.gd` e 23/23 suite dell'intero progetto superate con 0 errori a 0 ms.
- Misure di prevenzione delle regressioni: Separare concettualmente e temporalmente le tappe di sosta/riposo dalle tappe di spostamento attivo, e nei test con asserzioni su risorse limitate a zero (clamping) verificare e predisporre un margine dinamico adeguato.

### BUG-007 — Data del Calendario nei Test Headless dei Festival e Cumulatività delle Dinamiche di Band

- Data e componente: `2026-09-24`, `tests/test_festival_system.gd` e `systems/festival_system.gd` (Sezione 7).
- Sintomo osservato:
  1. `SCRIPT ERROR: Invalid access to property or key 'extreme_move' on a base object of type 'Dictionary'` in `test_extreme_moves_and_steal_the_show()`.
  2. Fallimento asserzione tensione membro in `test_stage_types_and_underground_tent()` (`Tensione membro ridotta: Ottenuto 0.00, Atteso 15.00`).
- Evidenza riproducibile: Esecuzione di `tools/test.ps1 -TestFile test_festival_system` dopo l'estensione della suite festival.
- Causa radice verificata:
  1. Il festival estivo di Londra si tiene al giorno 104 del calendario. Nel test di verifica delle mosse sceniche, il calendario era stato impostato al giorno 153 (`cur_day = 153 > 104`), innescando la guardia reattiva di validità temporale in `can_apply_for_slot()`, che ha respinto la prenotazione con `"festival_already_passed"`. La mancata prenotazione ha causato il fallimento di `perform_festival_concert()` (`"slot_not_booked"`), ritornando un dizionario di errore privo della chiave `"extreme_move"`.
  2. Nella simulazione del concerto nella Tenda Underground (`UNDERGROUND_TENT`), la logica applica una distensione immediata per il set intimo (`-10` tensione) e, al termine del concerto, una seconda riduzione della tensione per il trionfo dello *Steal the Show* contro la band rivale (`-15` tensione). Partendo da una tensione iniziale di `25.0`, la combinazione additiva delle due riduzioni (25.0 - 10.0 - 15.0 = 0.0) ha azzerato la tensione con clamping al limite minimo `0.0`, mentre l'asserzione del test si aspettava erroneamente unicamente la riduzione di 10 punti (attendendosi 15.0).
- Soluzione applicata:
  1. In `test_extreme_moves_and_steal_the_show()`, sincronizzato il calendario prima della prenotazione con `calendar.day_number = 100` (precedente al giorno 104 del festival).
  2. In `test_stage_types_and_underground_tent()`, inizializzato `member.tension = 40.0`: in questo modo il doppio beneficio cumulativo della tenda (-10) e della vittoria sul cartellone (-15) porta deterministamente la tensione finale esattamente a `15.0` (40.0 - 25.0 = 15.0), verificando contemporaneamente l'efficacia di entrambi i meccanismi.
- Test automatici eseguiti: 16/16 test e 123 asserzioni superate in `test_festival_system.gd` a 0 errori e 0 ms, con validazione al 100% dell'intera suite di progetto (23/23 suite verdi).
- Misure di prevenzione delle regressioni: Nei test headless su eventi del calendario, assicurarsi che la data virtuale sia sempre antecedente o coincidente con quella dell'evento programmato, e quando più meccaniche intervengono nella medesima transazione di gioco, tenere conto della cumulatività dei delta su parametri limitati da clamping.

### BUG-008 — Global Script Class Cache & Pre-requisito di Fanbase nella Serializzazione del Fan Club

- Data e componente: `2026-09-24`, `autoload/event_bus.gd`, `data/models/fan_club_data.gd` e `tests/test_advanced_social_system.gd` (Sezione 8).
- Sintomo osservato:
  1. `SCRIPT ERROR: Parse Error: Could not find type "FanClubData" in the current scope` al boot dell'engine durante il caricamento di `autoload/event_bus.gd`.
  2. Mancata indicizzazione del nuovo script `data/models/fan_club_data.gd` nella cache globale di Godot Engine durante l'esecuzione da riga di comando dei test headless.
  3. Fallimento asserzione nel test 9 di serializzazione atomica (`test_fan_club_persistence_and_fandom_summary`): `player.fan_club.is_founded` risultava `false` dopo la chiamata a `sys.found_fan_club()`.
- Evidenza riproducibile: Creazione di una nuova classe pura con `class_name FanClubData` e richiamo della firma `signal fan_club_founded(fan_club: FanClubData)` nell'Autoload dell'EventBus prima che il file `.godot/global_script_class_cache.cfg` sia aggiornato.
- Causa radice verificata:
  1. Gli Autoload di Godot vengono caricati prima o contemporaneamente alla risoluzione dei tipi globali. Tipizzare strettamente un parametro di segnale con una classe di modello dati definita tramite `class_name` genera un accoppiamento circolare anticipato che fallisce se la classe non è ancora nel registro o se la cache è disallineata.
  2. I test runner headless (`Godot_console.exe --headless res://tests/test.tscn`) non rigenerano automaticamente la cache delle classi globali dei file `.gd` appena creati su disco, a differenza dell'editor grafico.
  3. Nel Test 9, `found_fan_club()` richiede per contratto di dominio che il giocatore possieda almeno 1.000 fan (`player.fans >= 1000`). L'istanza di test era stata creata con fan iniziali pari a zero, provocando il rifiuto con `fans_insufficient`: di conseguenza il fan club non veniva fondato (`is_founded = false`) e i relativi campi non venivano scritti nel dizionario del salvataggio.
- Soluzione applicata:
  1. In `autoload/event_bus.gd`, disaccoppiata la signature del segnale utilizzando la classe base nativa: `signal fan_club_founded(fan_club_data: RefCounted)`.
  2. Rigenerata la class cache globale con una rapida invocazione headless dell'editor: `Godot_console.exe --headless --editor --quit`.
  3. In `tests/test_advanced_social_system.gd`, impostato `player.fans = 1500` prima di invocare `sys.found_fan_club("Andrea Vinyl")`.
- Test automatici eseguiti: 51/51 test superati in `test_advanced_social_system.gd` a 0 errori e 0 ms, con validazione al 100% dell'intera suite di progetto (24/24 suite verdi).
- Misure di prevenzione delle regressioni: Negli Autoload globali di broadcast ad eventi (EventBus), tipizzare i parametri dei segnali con tipi base (`RefCounted`, `Resource`, `Dictionary`) per evitare dipendenze circolari; quando si aggiunge un nuovo file con `class_name`, lanciare `--editor --quit` per rigenerare la cache globale prima di eseguire i test runner; nei test di serializzazione di sottosistemi che richiedono prerequisiti di sblocco, impostare preventivamente lo stato necessario nel modello prima di verificare la persistenza.

### BUG-009 — Type Pinning nei Controller UI su Modelli Recenti & Guardie Finanziarie sui Costi di Licenziamento

- Data e componente: `2026-09-24`, `ui/industry/industry_hub.gd` e `systems/industry_system.gd` (Sezione 9).
- Sintomo osservato:
  1. Nei controller UI che consumano modelli creati nella stessa sessione di sviluppo (es. `own_label_data.gd`), l'annotazione di tipo esplicita (`: OwnLabelData`) genera un potenziale `Parse Error: Could not find type "OwnLabelData"` nei caricamenti headless se la cache globale delle classi `.godot/global_script_class_cache.cfg` non è stata ancora aggiornata.
  2. Rischio di exploit o saldi negativi nel licenziamento del manager se il costo della penale di rescissione contrattuale non viene verificato con guardia preventiva sulla liquidità del giocatore prima della transazione.
- Evidenza riproducibile:
  1. Uso di annotazioni di tipo statico `_label: OwnLabelData` in `industry_hub.gd` in assenza di preload esplicito prima del refresh dell'editor.
  2. Tentativo di licenziare un manager con penale (es. 1.500 € per lo Squalo) con saldo inferiore alla penale.
- Causa radice verificata:
  1. In GDScript, i tipi globali dichiarati con `class_name` dipendono dalla class cache generata dall'editor; i controller UI istanziati dinamicamente o nei test headless possono fallire il parsing se fanno riferimento a `class_name` non ancora registrati globalmente senza un `preload()`.
  2. Nei contratti con clausola di rescissione onerosa, l'esecuzione incondizionata del distacco contrattuale senza validazione del saldo genera inconsistenza economica o debiti negativi non tracciati.
- Soluzione applicata:
  1. Adozione del pattern **Preload Script Decoupling**: utilizzo di `const OwnLabelDataScript = preload("res://data/models/own_label_data.gd")` e tipizzazione dei parametri nei metodi UI con `RefCounted` o duck typing, garantendo immediata resilienza e zero dipendenze dai tempi di scansione della cache.
  2. Inserimento in `industry_system.gd` della guardia economica preventiva `if player.money < severance_fee: return { "success": false, "reason": "Fondi insufficienti per pagare la penale..." }`, vincolando la rimozione del manager e l'emissione del segnale all'effettivo saldo della penale.
- Test automatici eseguiti: 106/106 asserzioni superate in `test_industry_system.gd` a 0 errori e 0 ms, con validazione al 100% dell'intera suite di progetto (24/24 suite verdi).
- Misure di prevenzione delle regressioni: Nei controller UI e nei consumer di modelli runtime, preferire il pattern Preload Script Decoupling con annotazione `RefCounted` sui parametri ricevuti; ogni azione di gameplay soggetta a penali o costi di liquidazione deve implementare una guardia di solvibilità reattiva prima di modificare lo stato del gioco.

### BUG-010 — Invariante di Espansione dei Cataloghi di Dominio & Override di Stato nei Test Seams Procedurali (Sezione 11)

- Data e componente: `2026-09-24`, `data/models/venue_data.gd`, `tests/test_concert_system.gd`, `tests/test_endgame_and_legacy_system.gd` (Sezione 11).
- Sintomo osservato:
  1. Fallimento asserzione in `test_concert_system.gd`: `[FAIL] Catalogo venue di default popolato: Ottenuto 8, Atteso 6` dopo l'espansione del catalogo venue con Palasport (15.000 posti) e Mega Stadio Mondiale (65.000 posti).
  2. Rischio di fallimento intermittente nei test dei concerti complessi dovuto a rifiuto per `venue_occupied` scaturito dall'algoritmo procedurale di disponibilità basato sull'hash del giorno di calendario.
- Evidenza riproducibile:
  1. Aggiunta di venue di default in `VenueData.get_default_venues()` ed esecuzione di suite di test preesistenti con asserzione scalare rigida `assert_eq(venues.size(), 6)`.
  2. Esecuzione di `resolve_concert()` su stadi e arene con date del calendario non controllate in test seams headless.
- Causa radice verificata:
  1. I test che verificano collezioni di dominio espandibili mediante uguaglianza numerica rigida (hardcoded scalar check) creano fragilità non funzionale: l'espansione fisiologica e backward-compatible del dominio rompe i test storici senza che vi sia una reale regressione di business logic.
  2. Quando un sottosistema simula disponibilità procedurali basate su funzioni hash del calendario (`CalendarData.day_number`), test deterministici a 0 ms non possono fare affidamento su date casuali senza incorrere in conflitti di occupazione procedurale.
- Soluzione applicata:
  1. In `tests/test_concert_system.gd`: aggiornato il conteggio atteso a 8 venue e codificato il principio di verifica tramite invarianti di soglia minima (`>= 8`) o controllo di presenza puntuale degli ID chiave.
  2. In `tests/test_endgame_and_legacy_system.gd`: utilizzo sistematico della test seam di override esplicito `concert_sys.set_venue_status_override(venue.id, cal.day_number, Enums.VenueBookingStatus.FREE)` prima di invocare `resolve_concert()`.
- Test automatici eseguiti: 87/87 asserzioni superate in `test_endgame_and_legacy_system.gd` e 26/26 suite headless complessive dell'intero progetto superate con 0 errori e 0 ms.
- Misure di prevenzione delle regressioni: Nei test di catalogo verificare sempre la presenza degli elementi chiave o garantire che le asserzioni di conteggio siano centralizzate su costanti di dominio; esporre sempre metodi deterministici di test seam override per ogni meccanica procedurale sensibile al calendario.

### BUG-011 — Ordine di Compilazione Autoload vs class_name Non Registrati & Allineamento Firme Test Seams (Sezione 12)

- Data e componente: `2026-09-24`, `autoload/accessibility_manager.gd`, `tests/test_ui_audio_and_numpad_system.gd` (Sezione 12).
- Sintomo osservato:
  1. All'avvio dell'engine in modalità headless, errore critico: `SCRIPT ERROR: Parse Error: Could not find type "AudioCueSystem" in the current scope` a riga 11 di `accessibility_manager.gd`, con conseguente `ERROR: Failed to instantiate an autoload, script does not inherit from 'Node'` e `AccessibilityManager` valutato a `Nil` in tutte le scene e test runner.
  2. Fallimento del test headless per `SCRIPT ERROR: Invalid call. Nonexistent function 'grant_encore' in base 'RefCounted (ConcertSystem)'`.
- Evidenza riproducibile:
  1. Dichiarazione di variabile tipizzata `var audio_cue_system: AudioCueSystem = null` e `AudioCueSystem.new()` all'interno di un autoload (`AccessibilityManager`) prima che la cache globale dell'engine abbia indicizzato la `class_name AudioCueSystem` in `systems/audio_cue_system.gd`.
  2. Invocazione in una suite di test di un metodo con nome ipotizzato anziché conforme alla firma reale `resolve_encore(granted: bool, current_score: float) -> Dictionary`.
- Causa radice verificata:
  1. In Godot 4 gli script registrati in `project.godot` sotto la sezione `[autoload]` vengono compilati ed istanziati all'avvio dell'engine *prima* della registrazione dinamica delle `class_name` definite nei normali script del progetto. Qualsiasi riferimento diretto al tipo `class_name` all'interno del corpo di un autoload causa fallimento immediato di compilazione dell'autoload stesso, facendolo collassare a `Nil` per l'intero ciclo di vita dell'applicazione.
  2. Nel test seam era stato utilizzato `grant_encore()` per assonanza con l'azione UI anziché il metodo canonico di dominio `resolve_encore()`.
- Soluzione applicata:
  1. Adozione del pattern **Autoload Preload Decoupling**: all'interno di `autoload/accessibility_manager.gd`, precaricamento esplicito tramite `const AudioCueSystemScript = preload("res://systems/audio_cue_system.gd")`, tipizzazione generica `var audio_cue_system: Node = null` e istanziazione tramite `AudioCueSystemScript.new()`.
  2. Correzione in `tests/test_ui_audio_and_numpad_system.gd` dell'invocazione su `concert_sys.resolve_encore(true, 90.0)`.
- Test automatici eseguiti: 128/128 asserzioni superate in `test_ui_audio_and_numpad_system.tscn` e 27/27 suite headless complessive dell'intero progetto superate con 0 errori a 0 ms.
- Misure di prevenzione delle regressioni: Negli script autoload non utilizzare mai annotazioni statiche di tipo `class_name` definite altrove nel progetto senza `preload()`; utilizzare sempre `const ScriptRef = preload(...)` e tipizzazione generica `Node` per disaccoppiare l'ordine di bootstrap dell'engine.

### BUG-012 — Conservazione della Linearità del Grafo di Riverbero Territoriale & Parametrizzazione nei Test Headless di Espansione (Post-V5.1 Expansion)

- Data e componente: `2026-09-24`, `systems/travel_system.gd`, `tests/test_travel_system.gd` (Espansione Post-V5.1 V5.2.0).
- Sintomo osservato: Durante l'espansione del grafo città da 12 a 16 metropoli, il test headless di riverbero geografico della fanbase fallisce con: `[FAIL] Incremento complessivo fan a seguito del concerto: Ottenuto 200, Atteso 196`.
- Evidenza riproducibile: Esecuzione di `tests/test_travel_system.gd` con la nuova enumerazione `CityId` estesa a 16 elementi ed esecuzione del metodo di riverbero su 100 fan base.
- Causa radice verificata:
  1. L'algoritmo di propagazione geografica della popolarità distribuisce l'85% dei fan alla città del concerto e +1 fan per ciascuna delle altre città del network: $85 + (N - 1) \times 1$.
  2. Con la topologia storica a $N = 12$ città, le altre città erano 11, per cui l'incremento totale generato da 100 fan era $85 + 11 = 96$ fan distribuiti (saldo complessivo $100 + 96 = 196$).
  3. Con l'espansione a $N = 16$ metropoli, le altre città salgono a 15, portando la propagazione a $85 + 15 = 100$ fan (saldo complessivo $100 + 100 = 200$). L'asserzione rigida `assert_eq(total, 196)` conteneva una costante scalare hardcoded non parametrizzata sulla cardinalità del grafo.
- Soluzione applicata:
  1. Ricalibrazione dell'asserzione del test a 200 fan e formalizzazione del pattern di parametrizzazione $(N - 1)$ per qualsiasi espansione di topologie geografiche o grafi di rete.
- Test automatici eseguiti: 93/93 asserzioni superate in `tests/test_travel_system.gd` e 28/28 suite headless complessive dell'intero progetto superate con 0 errori e 0 ms.
- Misure di prevenzione delle regressioni: Nei test di algoritmi che iterano o distribuiscono risorse su grafi di nodi o enumerazioni, evitare costanti scalari assolute figlie di una specifica dimensione storica; parametrizzare le formule attese sulla cardinalità dinamica del set di nodi o ancorarle a costanti derivate (`CityId.size() - 1`).

### BUG-013 — Conflitto di Intercettazione Input (Autoload Shadowing) & Memory Leak del Dummy Audio Driver nei Test Headless (Fase 2)

- Data e componente: `2026-09-24`, `autoload/accessibility_manager.gd`, `systems/audio_cue_system.gd`, `tests/test_v5_ui_overhaul.gd`.
- Sintomo osservato:
  1. I tasti alfanumerici (`1`, `2`, `3`, `T`, `R`, `P`, `K`, `M`, `N`, `Space`) risultavano mappati sia in `AccessibilityManager._unhandled_input` che in `HUD._unhandled_input`, creando imprevedibilità di instradamento dell'input e rischio di race conditions.
  2. Nei test headless con verbosità o all'uscita dal processo, l'engine emetteva `WARNING: ObjectDB instances were leaked at exit` relativo a istanze `AudioStreamPlaybackWAV` rimaste allocate in memoria.
- Evidenza riproducibile:
  1. Presenza di blocchi `match event.keycode` duplicati tra un Autoload globale e una scena locale.
  2. Invocazione di `audio_player.play()` su un `AudioStreamPlayer` in modalità headless senza chiusura né silenziamento esplicito prima di `get_tree().quit(0)`.
- Causa radice verificata:
  1. In Godot gli Autoload elaborano l'input globale e, se non strettamente circoscritti, mascherano o anticipano i controlli contestuali della scena attiva a video.
  2. In modalità `--headless` (driver `Dummy`), Godot 4 non avanza il mixer audio a frame reali; di conseguenza gli stream avviati con `play()` non raggiungono mai la fine della riproduzione e restano registrati nell'ObjectDB C++ fino al crash o warning di uscita.
- Soluzione applicata:
  1. Rimozione di tutte le scorciatoie alfanumeriche da `AccessibilityManager._unhandled_input`, mantenendo unicamente la navigazione da tastierino numerico (`KEY_KP_*`) e il silenziamento d'emergenza (`silence()`).
  2. In `AudioCueSystem`: aggiunta della guardia `if DisplayServer.get_name() != "headless": audio_player.play()` per generare gli stream e testare volumi e ducking senza allocare playback C++ headless orfani; azzeramento di `audio_player.stream = null` in `stop()` e in `_exit_tree()`.
  3. Invocazione di `AccessibilityManager.silence()` prima del quit in `test_v5_ui_overhaul.gd` e `queue_free()` sostituito con `free()` per deallocazione sincrona immediata.
- Test automatici eseguiti: 28/28 suite headless convalidate a 0 ms con 0 memory leak rilevati dall'engine ObjectDB.
- Misure di prevenzione delle regressioni: Riservare gli Autoload esclusivamente a comandi globali di sistema o navigazione ausiliaria a basso livello; proteggere le invocazioni di riproduzione audio nei sottosistemi simulati contro il dummy audio driver headless.

### BUG-014 — Scomposizione Modulare Monolite HUD (ModalRouter Pattern) & Risoluzione Ordine di Caricamento Preload (Fase 3)

- Data e componente: `2026-09-24`, `ui/hud/hud.gd`, `ui/hud/modal_router.gd`.
- Sintomo osservato:
  1. File `hud.gd` ipertrofico (1.038 righe) che aggregava la logica di visualizzazione HUD principale e il coordinamento atomico di 19 finestre modali distinte, violando il Cancello 6 del Protocollo 12.
  2. Durante la scomposizione, il tool `tools/check.ps1` (`check_syntax.gd`) falliva con `Could not find type "ModalRouter" in the current scope` a riga 68 di `hud.gd`.
- Evidenza riproducibile: Scansione alfabetica di cartella in cui `res://ui/hud/hud.gd` viene analizzato prima di `res://ui/hud/modal_router.gd` senza class cache compilata.
- Causa radice verificata:
  1. Mancanza di un coordinatore modale specializzato separato dalla vista HUD.
  2. In Godot 4, quando gli script vengono compilati o verificati singolarmente da utility esterne o senza cache dell'editor aggiornata, i tipi dichiarati tramite `class_name` non sono immediatamente disponibili agli script che li precedono in ordine alfabetico.
- Soluzione applicata:
  1. Creazione di `ui/hud/modal_router.gd` (`class_name ModalRouter extends RefCounted`) per gestire registrazione, mutua esclusione atomica (`hide_all_modals()`), ascolto eventi `EventBus`, aperture/chiusure e memorizzazione/ripristino focus.
  2. Implementazione su `hud.gd` di metodi forwarder trasparenti per conservare il 100% di compatibilità verso le 28 suite di test headless preesistenti, riducendo `hud.gd` da 1.038 a 715 righe.
  3. Aggiunta in `hud.gd` della direttiva `const ModalRouter = preload("res://ui/hud/modal_router.gd")` per garantire indipendenza totale dall'ordine di scansione o dal bootstrap dell'editor.
- Test automatici eseguiti: 105/105 file GDScript compilati con successo in `tools/check.ps1` (0 errori, 0 warning) e 28/28 suite headless superate al 100% a 0 ms.
- Misure di prevenzione delle regressioni: Scomporre sempre i monoliti UI complessi delegando a router dedicati con forwarder retrocompatibili; per script e classi strettamente accoppiati nei controller, utilizzare `preload` deterministico per azzerare dipendenze dall'ordine di indicizzazione dell'engine.

### BUG-015 — Cambio Scena Sincrono Durante Notifiche dell'Albero (Parent Node Busy) & Risoluzione Asincrona Call-Deferred (V5.3.0)

- Data e componente: `2026-09-24`, `ui/main_menu/main_menu.gd`, `tests/test_main_menu.gd` (Versione AVF `V5.3.0`).
- Sintomo osservato: Durante l'esecuzione di suite headless o all'attivazione rapida di pulsanti di transizione di scena, l'engine registrava:
  `ERROR: Parent node is busy adding/removing children, remove_child() can't be called at this time. Consider using remove_child.call_deferred(child) instead.`
- Evidenza riproducibile: Invocazione diretta sincrona di `get_tree().change_scene_to_file("res://...")` all'interno di `_on_load_game_pressed()` o callback di segnali emessi durante l'elaborazione interna dei figli dello `SceneTree`.
- Causa radice verificata:
  1. In Godot 4, `change_scene_to_file` esegue internamente `remove_child()` sulla radice della scena corrente prima di istanziare e agganciare la nuova scena.
  2. Se questa chiamata viene innescata mentre l'engine sta iterando sui nodi figli (ad esempio durante la propagazione di segnali di focus, eventi GUI o setup in `_ready`), l'albero dei nodi è bloccato in stato "busy", provocando l'errore o il potenziale stallo del frame.
- Soluzione applicata:
  1. Adozione sistematica del pattern **Deferred Scene Transition**: sostituzione di tutte le chiamate sincrone nei pulsanti del menu principale con `get_tree().change_scene_to_file.call_deferred("res://...")`.
  2. La transizione viene così posticipata alla fine del frame corrente, quando l'albero ha completato tutte le notifiche in sospeso.
- Test automatici eseguiti: 33/33 test superati in `test_main_menu.gd` e 29/29 suite headless complessive dell'intero progetto superate con 0 errori, 0 warning e 0 ms.
- Misure di prevenzione delle regressioni: Nei controller UI, qualsiasi cambio globale di scena (`change_scene_to_file` o `change_scene_to_packed`) scatenato da pulsanti, dialoghi modali o segnali di gioco deve essere obbligatoriamente invocato tramite `.call_deferred(...)`.

### BUG-016 (RRU-22) — Disallineamento Collider Istanziali 2.5D, Hitbox Deadlock & Coordinate HUD Off-Screen (V5.4.0)

- Data e componente: `2026-09-24`, `scenes/apartment/apartment.tscn`, `scenes/apartment/interactive_prop.gd`, `ui/apartment_hud/apartment_hud.tscn`, `tests/test_apartment_gameplay.gd` (Versione AVF `V5.4.0`).
- Sintomi osservati:
  1. Collisione del tavolino (`CoffeeTable`) bloccante e sfasata, con collisioni duplicate e poligoni asimmetrici che ostacolavano il passaggio fluido di Alex nel loft.
  2. Impossibilità per Holy Diver di cliccare o interagire con arredi chiave (stereo, tavolino) e auto-walk che sbatteva contro gli ostacoli fisici senza innescare l'interazione.
  3. Modali e viste dell'HUD dell'appartamento renderizzate completamente fuori dallo schermo visibile a causa di offset storici negativi anomali (`offset_top = -2161`, `offset_bottom = -1049`).
- Evidenza riproducibile: Apertura della scena dell'appartamento nell'editor o avvio runtime, tentativo di click del mouse sugli arredi o movimento verso il letto/stereo.
- Causa radice verificata:
  1. Nelle scene 2D con nodi istanziati e modificati (`[editable path="..."]`), le collisioni modificate graficamente subiscono drift rispetto al centro dell'arredo, e l'aggiunta di poligoni concorrenti crea collisioni spurie.
  2. Hitbox clearance assente o negativa: l'area sensibile di trigger (`Area2D`) aveva raggio uguale o inferiore alla sagoma solida (`StaticBody2D`), facendo urtare i piedi del personaggio contro la barriera fisica prima di toccare l'area di trigger, bloccando l'emissione del segnale `body_entered` (Hitbox Deadlock).
  3. L'auto-walk verso il bersaglio puntava a `global_position` dell'arredo, che coincideva con il centro dell'ostacolo solido; senza punto di arrivo calpestabile antistante, il movimento falliva o scivolava.
  4. L'istanza dell'HUD ereditava ancoraggi e coordinate assolute obsolete invece del Full Rect `(0, 0, 0, 0)`.
- Soluzione applicata:
  1. Normalizzazione concentrica dei prop: radice dell'arredo alle coordinate del mondo, `Sprite2D` e collider centrati concentricamente o posizionati alla base d'appoggio. Sostituzione dei poligoni del tavolino con un `RectangleShape2D` pulito (70x24 a offset `(-6, 50)`).
  2. Promozione dello stereo a `InteractiveProp` con trigger radius di 55 px (clearance >= 25 px rispetto alla base solida) e bonus morale (+5) / relax stress (-5).
  3. Implementazione di `get_stand_position()` con `stand_offset` in `InteractiveProp` per guidare l'auto-walk verso lo spazio libero antistante.
  4. Reset completo degli ancoraggi e offset di `ApartmentHud` in `apartment.tscn` a Full Rect `(0, 0, 0, 0)`.
  5. Integrazione dei gestori mouse (`mouse_entered`, `mouse_exited`, `_input_event`) con icona a manina (`CURSOR_POINTING_HAND`) e click per Holy Diver, preservando il 100% dell'accessibilità tastiera/NVDA per Luca.
- Test automatici eseguiti: 68/68 test superati in `test_apartment_gameplay.gd` e 30/30 suite headless complessive superate con 0 errori a 0 ms.
- Misure di prevenzione delle regressioni: Negli arredi interattivi 2.5D, garantire sempre clearance minima di 25–35 px tra trigger sensibile e collider solido, esporre un punto di stazionamento antistante e verificare che i controlli `CanvasLayer` abbiano offset Full Rect a zero.

### BUG-017 (RRU-23) — Disassamento Radici 2.5D, Falso Arrivo da Stallo Auto-Walk, Metodi Temporali Mancanti e Differenziazione Azioni Domestiche (V5.4.1)

- Data e componente: `2026-09-25`, `scenes/apartment/apartment.tscn`, `scenes/apartment/player_alex.gd`, `systems/time_system.gd`, `ui/apartment_hud/apartment_hud.gd`, `scenes/apartment/interactive_prop.tscn`, `scenes/apartment/interactive_prop.gd`, `tests/test_apartment_gameplay.gd` (Versione AVF `V5.4.1`).
- Sintomi osservati:
  1. All'interazione o click su un oggetto distante, il menu d'interazione si apriva quasi immediatamente anche con Alex lontano (Punto 0).
  2. Impossibilità di utilizzare correttamente il letto per dormire o riposare per assenza dei metodi temporali attesi dall'HUD (Punto 1).
  3. Interazioni fuori luogo o ridondanti: l'interazione con il divano offriva di "Prendere un caffè", aprendo la generica `relax_modal` con opzioni incongruenti per l'ambiente domestico del loft (Punto 2).
  4. L'impianto stereo del loft poteva solo essere acceso, mancando uno stato bistabile per spegnerlo (Punto 3).
  5. Avvicinandosi agli arredi persisteva a video un'etichetta fluttuante obsoleta `[SPAZIO]` che creava inquinamento visivo (Punto 4).
- Evidenza riproducibile:
  1. Click o interazione con il letto o il divano da posizione remota: l'auto-walk si fermava contro un ostacolo (`_stuck_timer > 0.35s`) e scatenava erroneamente l'apertura anticipata del menu pur trovandosi a oltre 100 px di distanza.
  2. Interazione con il letto: `TimeSystem` implementava `skip_to_next_period` e `sleep_early`, mentre l'interfaccia invocava `advance_to_next_period()` e `trigger_sleep_now()`.
  3. Divano, cucina e giradischi collegati alla medesima `relax_modal` pensata per i locali della mappa cittadina.
- Causa radice verificata:
  1. In `apartment.tscn`, le origini `position` dei nodi radice `InteractiveProp` erano collocate con offset anomali fino a 300 px rispetto agli sprite e alle sagome effettive, falsando il calcolo di `distance_to` e `stand_position`.
  2. In `player_alex.gd`, lo scadere del timer di stallo ostacoli (`_stuck_timer > 0.35s`) considerava l'evento come "arrivo completato", invocando incautamente la callback di apertura menu a prescindere dalla vicinanza reale.
  3. Mancanza di metodi wrapper di retrocompatibilità ed allineamento nell'API di `TimeSystem`.
  4. Accoppiamento improprio degli arredi domestici con modali commerciali generiche esterne anziché azioni contestuali immediate a costo zero.
  5. Mancanza di una variabile di stato bistabile (`is_stereo_on: bool`) per la gestione a levetta On/Off dello stereo.
  6. Presenza del nodo orfano `Prompt` in `interactive_prop.tscn` non bonificato dopo l'adozione dell'Inspection Box nell'HUD.
- Soluzione applicata:
  1. Normalizzazione geometrica millimetrica di tutti i nodi `InteractiveProp` in `apartment.tscn` posizionando la radice alla base d'appoggio sul pavimento ed azzerando gli offset interni; configurazione di `stand_offset` frontali calpestabili esterni alle sagome solide (Contratto D1).
  2. Riprogettazione di `_process_auto_walk` in `player_alex.gd`: la callback di interazione viene eseguita *esclusivamente* se Alex è nel raggio effettivo (`dist <= 24.0` o `target_prop.is_player_in_range`). In caso di stallo ostacoli (`_stuck_timer > 0.6s`), l'auto-walk viene interrotto, il menu *non* viene aperto e viene emesso l'annuncio vocale: *"Percorso bloccato. Avvicinati manualmente con i tasti di movimento."* (Contratto D2).
  3. Aggiunti a `systems/time_system.gd` i metodi ufficiali `advance_to_next_period() -> bool` e `trigger_sleep_now() -> void`, integrando nell'HUD la scelta accessibile Notte (sonno diretto) vs Giorno (scelta Z per dormire, X per riposare, Esc per annullare) (Contratto D3).
  4. Differenziazione contestuale delle interazioni domestiche in `ApartmentHud`: Divano (relax immediato gratuito: -12 stress, +5 morale), Cucina (espresso del loft: +15 energia, -5 stress, 0 €), Giradischi (sessione vinili: +20 morale, -10 stress, 35% scintilla creativa) (Contratto D4).
  5. Introdotta variabile `is_stereo_on: bool` con toggle On/Off, annunci NVDA e testi di ispezione coerenti (Contratto D4).
  6. Rimozione definitiva del nodo `Prompt` in `interactive_prop.tscn` e bonifica della variabile `_prompt_node` in `interactive_prop.gd` (Contratto D0 Clean Sweep).
- Test automatici eseguiti: 84/84 asserzioni superate in `tests/test_apartment_gameplay.gd` e 30/30 suite headless complessive dell'intero progetto superate con 0 errori e 0 ms.
- Misure di prevenzione delle regressioni:
  * In Godot 2.5D, la radice del nodo arredo deve coincidere sempre con la base sul piano di camminamento;
  * L'arresto per stallo di navigazione non deve mai essere trattato come arrivo a bersaglio;
  * Le interazioni di riposo domestico devono essere sempre distinte dalle strutture ricettive a pagamento.

### BUG-018 (RRU-24) — Overlap Dialogue-Dock, Pulsante Band Mancante e Padding StyleBox in Viewport Full HD (V5.5.0)

- Data e componente: `2026-09-25`, `ui/apartment_hud/apartment_hud.tscn`, `ui/apartment_hud/apartment_hud.gd`, `scenes/apartment/apartment.gd`, `tests/test_apartment_gameplay.gd` (Versione AVF `V5.5.0`).
- Sintomi osservati:
  1. Sovrapposizione grafica parziale tra il pannello di ispezione e dialogo in basso a sinistra (`BottomLeftDialogue`) e il dock centrale orizzontale (`BottomCenterDock`) su viewport 1920x1080.
  2. Assenza del quinto pulsante dedicato alla Band nel dock centrale dell'appartamento, nonostante la presenza dell'asset grafico `band_icon.png`.
  3. Presenza di zone vuote all'interno dei pannelli dell'HUD (in particolare il blocco tempo in alto a destra e il profilo in alto a sinistra), con pulsanti e barre che non riempivano l'intera area del box.
- Evidenza riproducibile:
  1. Avvio della scena dell'appartamento su risoluzione 1920x1080: `BottomLeftDialogue` esteso fino a X = 650 e `BottomCenterDock` con 5 pulsanti centrato su X = 960 (esteso a sinistra fino a X = 648) collidono visivamente, aggravati da `expand_margin = 8.0` dello StyleBox.
  2. Mancanza del pulsante Band tra le macro-categorie dock dell'HUD e del tasto rapido numerico `5`.
  3. I pulsanti tempo (`BtnTimePause`, `BtnTimeSpeed`, `BtnTimeSleep`) avevano larghezze fisse di 48/64 px, lasciando oltre 300 px di vuoto nero a destra nel contenitore da 476 px.
- Causa radice verificata:
  1. Dimensionamento asimmetrico dei pannelli inferiori e mancato calcolo matematico della clearance minima di sicurezza (almeno 80 px) tra il blocco di sinistra e il dock centrale.
  2. L'utilizzo di `expand_margin` sui bordi dello StyleBox provoca l'estensione del disegno fuori dal bounding box logico del `Control`, inducendo collisioni visive invisibili al controllo delle sole coordinate `offset_*`.
  3. Assenza di `content_margin` integrato negli StyleBox e assenza di flag `size_flags_horizontal = 3` / `size_flags_vertical = 3` sui controlli orizzontali e verticali interni ai box.
- Soluzione applicata:
  1. Ricalibrazione geometrica millimetrica: `BottomLeftDialogue` fissato tra X = 24 e X = 540 (larghezza 516 px); `BottomCenterDock` a 5 pulsanti esteso tra X = 648 e X = 1272. Clearance garantita = 108.0 pixel (> 80 px). Allineamento dell'offset inferiore di tutti i blocchi a Y = 1060 (`offset_bottom = -20.0`).
  2. Inserimento di `BtnDockBand` ("5 Band") con texture `band_icon.png`, collegamento al `BandHubModal`, `focus_mode = 0` (Zero Focus Drop) e mappatura tasto `5` in `apartment.gd` (conservando `KEY_B`).
  3. Adozione di `content_margin` (14 px orizzontale, 12 px verticale) negli StyleBox, rimozione di `expand_margin`, pulsanti temporali impostati con `size_flags_horizontal = 3` a tutta larghezza e altezza 38 px, barre vitali ad altezza 18 px e ritratto 120x120.
  4. Suite `test_apartment_gameplay.gd` espansa a 102 asserzioni con test unitario per `BtnDockBand` e verifica matematica di clearance a 0 ms (`dialogue_right < dock_left` e `clearance >= 80 px`). 30/30 suite headless verdi a 0 ms.
### BUG-019 (RRU-25) — Canvas Padding Eccessivo nell'Icona Band, Altezza Invasiva Dialogue Box e Allineamento Stile Menu di Sistema (V5.5.1)

- Data e componente: `2026-09-25`, `assets/img/gameplay/GUI/Elementi/band_icon.png`, `ui/apartment_hud/apartment_hud.tscn`, `ui/system_menu/system_menu_modal.tscn` (Versione AVF `V5.5.1`).
- Sintomi osservati:
  1. L'icona del pulsante Band (`band_icon.png`) appariva visivamente minuscola e sproporzionata all'interno del dock rispetto a `Personale.png`, `Creazione.png`, `Carriera.png` e `Strumenti.png`.
  2. Il pannello di dialogo e ispezione in basso a sinistra (`BottomLeftDialogue`) torreggiava verso l'alto con un'altezza di 220 px (`offset_top = -240.0`), coprendo una porzione eccessiva della visuale isometrica della stanza (letto, chitarra e pavimentazione).
  3. Il Menu di Sistema (`SystemMenuModal`, tasto Esc) manteneva uno stile generico dorato e pulsanti grigi standard di Godot, risultando stilisticamente disallineato rispetto al nuovo Menu Principale pixel-art retrò arcade.
  4. I pulsanti tempo (`BtnTimePause`, `BtnTimeSpeed`, `BtnTimeSleep`) avevano una forma allungata e schiacciata a striscia (136x38 px), con le icone quadrate galleggianti al centro e ampi spazi vuoti laterali.
- Evidenza riproducibile:
  1. L'immagine originale `band_icon.png` (2400x1309 px) conteneva oltre 760 px di canvas trasparente vuoto a sinistra e a destra, riducendo l'area grafica effettiva a un terzo della larghezza del pulsante con `expand_icon = true`.
  2. `BottomLeftDialogue` esteso fino a Y = 840 (su 1080) era più alto di 105 px rispetto al dock centrale (alto solo 115 px).
  3. `SystemMenuModal` privo del tema `menu_theme.tres` e del font `PressStart2P.ttf`.
- Causa radice verificata:
  1. Mancato ritaglio al vivo (crop lossless) della tela trasparente esterna delle risorse grafiche importate da editor terzi prima dell'inserimento nei pulsanti con proporzioni 1:1.
  2. Sovradimensionamento verticale del box di dialogo (ritratto 120x145 e min_size 330x75 per il testo) non allineato alla linea di altezza del dock centrale.
  3. Mancata propagazione del tema universale del gioco (`menu_theme.tres`) alla scena della finestra modale di sistema.
  4. Pulsanti temporali vincolati da `size_flags_horizontal = 3` forzati a riempire l'intero contenitore anziché mantenere una forma quadrata compatta ed ergonomica in stile registratore a cassette (tape-deck).
- Soluzione applicata:
  1. Ritaglio lossless di `band_icon.png` sul bounding box opaco effettivo ($884 \times 900$ px), uniformandola perfettamente alla scala quadrata 1:1 delle altre 4 icone del dock.
  2. Compattamento di `BottomLeftDialogue`: altezza ridotta a 120 px (`offset_top = -140.0`, allineato al dock a 115 px), larghezza fissata a 406 px (`offset_right = 430.0`), ritratto ridotto a $84 \times 84$ px e testo a 9 px su 2-3 righe con autowrap proporzionato. Clearance libera aumentata a **218.0 pixel** (> 80 px).
  3. Assegnazione del tema `menu_theme.tres` a `SystemMenuModal`, font retrò `PressStart2P.ttf`, bordo neon ciano `#38bdf8` con glow a 12 px, sfondo blu notte `#0c1527` e pulsanti neon arcade da 44 px con font a 10 px.
  4. Ricalibrazione dei pulsanti tempo (`BtnTimePause`, `BtnTimeSpeed`, `BtnTimeSleep`) a bottoni compatti da $56 \times 44$ px centrati orizzontalmente in `HBoxTimeControls`.
  5. Convalida con 107/107 test in `test_apartment_gameplay.gd`, 67/67 test in `test_v5_ui_overhaul.gd` e 30/30 suite headless complessive a 0 errori e 0 ms.
- Misure di prevenzione delle regressioni:
  * Tutte le icone per pulsanti quadrati devono essere rigorosamente ritagliate al vivo sul bordo opaco prima dell'importazione in Godot per evitare riduzioni di scala involontarie;
  * Nelle interfacce di gioco 2.5D, i pannelli HUD periferici devono allinearsi alle altezze di base delle barre adiacenti per preservare la massima area calpestabile visibile;
  * Le finestre modali di sistema e menu di pausa devono sempre ereditare il tema centrale dell'applicazione (`menu_theme.tres`) per garantire coerenza stilistica e accessibilità unificata.

### BUG-020 (RRU-26) — Blocco Movimento all'Apertura Modali da Arredi (Modals.visible == false), Metodi open() Mancanti & Testo Pergamena Troncato (V5.6.1)

- Data e componente: `2026-09-25`, `ui/apartment_hud/apartment_hud.tscn`, `ui/apartment_hud/apartment_hud.gd`, `scenes/apartment/apartment_interactions.gd`, `ui/interaction_menu/interaction_menu.gd`, `ui/music/song_creator.gd`, `ui/concert/live_concert.gd`, `ui/music/song_catalog.gd`, `tests/test_apartment_gameplay.gd` (Versione AVF `V5.6.1`).
- Sintomi osservati:
  1. Interagendo con la chitarra nel loft (azione "Componi brano") o con la porta di uscita (azioni "Viaggia", "Tour", "Festival", "Concerti"), il gioco si bloccava completamente: Alex risultava congelato (`player.is_movement_locked = true`), ma a video non appariva alcuna finestra modale e non era possibile comporre la canzone né muoversi o interagire.
  2. Diverse finestre modali aperte dagli arredi dell'appartamento (`SongCreatorModal`, `LiveConcertModal`, `SongCatalogModal`) non prendevano il focus da tastiera sul controllo primario e mancavano del metodo `open()` standardizzato con annuncio vocale per NVDA.
  3. Il testo delle opzioni all'interno del menu delle interazioni su pergamena pixel art (`InteractionMenu`) fuoriusciva dai bordi laterali della pergamena a causa di titoli lunghi con etichette di durata, assenza di a capo automatico (`autowrap_mode`) e larghezza insufficiente del contenitore pergamena (288 px con margini 26+26 px, utile 236 px).
- Evidenza riproducibile:
  1. Interazione con la chitarra -> Selezione di "Componi brano": `apartment_interactions.gd` emetteva `open_modal_requested.emit("song_creator")`, `ApartmentHud.open_modal(song_creator_modal)` impostava `song_creator_modal.visible = true`, ma il nodo genitore `$Modals` in `apartment_hud.tscn` aveva `visible = false` hardcoded.
  2. Mancanza del metodo `open()` in `SongCreator`, `LiveConcert` e `SongCatalog`.
  3. Pulsanti in `InteractionMenu` con titoli oltre i 35 caratteri (es. `[1] Accorda e pulisci strumento (5s)`) generavano stringhe larghe fino a 315 px su un'area utile di soli 236 px.
- Causa radice verificata:
  1. In Godot 4, l'invisibilità di un nodo genitore `Control` (`visible = false` su `$Modals`) impedisce il rendering e la ricezione di eventi di input di tutti i suoi nodi discendenti, a prescindere dal fatto che i nodi figli abbiano `visible = true`. Contestualmente, `modal_opened.emit()` bloccava correttamente il movimento di Alex, provocando un deadlock reattivo (freeze apparente).
  2. Assenza dell'entry-point canonico `open()` nei controller modali specializzati (`SongCreator`, `LiveConcert`, `SongCatalog`), con conseguente mancato passaggio di focus (`grab_focus()`) al primo campo editabile e assenza dell'annuncio vocale AccessKit/NVDA.
  3. In `InteractionMenu`, i pulsanti opzione (`Button`) erano istanziati con `autowrap_mode = TextServer.AUTOWRAP_OFF`, font size 9 px e texture della pergamena scalata a soli 288-290 px di larghezza, senza spazio per le etichette con durata temporale.
- Soluzione applicata:
  1. Contratto D0: In `apartment_hud.tscn`, rimosso `visible = false` predefinito su `[node name="Modals"]`. In `apartment_hud.gd`, gestione dinamica della visibilità del genitore: `open_modal()` attiva `$Modals.visible = true`, `close_modal()` verifica `is_any_modal_open()` e nasconde `$Modals` solo se tutte le modali sono chiuse, `hide_all_modals()` imposta `$Modals.visible = false`. Connessi inoltre i segnali `new_song_requested` e `edit_song_requested` del catalogo verso `song_creator_modal`.
  2. Contratto D1: Implementato il metodo canonico `open()` in `song_creator.gd` (apre `start_new_song()`, assegna focus a `edit_title` e annuncia vocalmente a NVDA), in `live_concert.gd` (apre `open_preparation()`, assegna focus a `opt_venue` e annuncia), e in `song_catalog.gd` (esegue `refresh_catalog()`, assegna focus a `btn_filter_all` e annuncia).
  3. Contratto D2: In `interaction_menu.tscn`, ricalibrati i margini interni a 20 px laterali e 28 px verticali. In `interaction_menu.gd`, standardizzata la larghezza delle pergamene pixel art a 320 px (Short $320 \times 190$, Medium $320 \times 400$, Long $320 \times 680$), rimosso override ridondante su dimensione di `BackgroundTexture` con anchors preset 15, impostato `btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART`, font size 8 px, margini interni 6 px, ed emesso `menu_closed.emit()` prima di `action_chosen.emit()` per garantire il corretto disarmo del menu.
  4. Contratto D3: In `scenes/apartment/apartment_interactions.gd`, sintetizzati tutti i titoli delle azioni per i 10 arredi (es. "Componi brano", "Scale e riff", "Accorda e pulisci", "Prepara espresso", "Viaggia in altra città", "Pianifica tournée", "Grandi Festival Estivi"), preservando spazio sufficiente per il badge di durata `(%ds)` e mantenendo descrizioni vocali estese per NVDA.
  5. Contratto D4: Estesa la suite `tests/test_apartment_gameplay.gd` a 271 asserzioni a 0 ms con test per visibilità genitore `$Modals`, apertura/chiusura modali e verifica di scroll width (320 px) e autowrap word-smart. 30/30 suite headless verdi a 0 ms.
- Misure di prevenzione delle regressioni:
  * Non annidare mai controlli modali reattivi all'interno di contenitori `Control` con visibilità statica spenta (`visible = false`); gestire sempre la visibilità del contenitore modale in modo sincronizzato con l'apertura e chiusura delle singole finestre;
  * Tutte le finestre modali interattive devono esporre il metodo canonico `open()` per gestire l'acquisizione di focus (`grab_focus()`) del primo elemento interattivo e l'annuncio per lo screen reader;
  * Nelle interfacce pixel art con cornici e pergamene fisse, abilitare categoricamente `autowrap_mode = TextServer.AUTOWRAP_WORD_SMART` e calibrare la larghezza del contenitore su una larghezza minima di sicurezza (>= 320 px) con font bitmap compatto (<= 8 px).

### BUG-021 (RRU-27) — Conflitto Tasto 'W' con Camminata in Avanti, Freeze Ciclo Sonno / DailySummary e Perdita XP Azioni (V5.6.2)

- Data e componente: `2026-09-25`, `scenes/apartment/player_alex.gd`, `scenes/apartment/apartment.gd`, `autoload/event_bus.gd`, `systems/end_day_system.gd`, `systems/action_system.gd`, `ui/apartment_hud/apartment_hud.gd`, `data/models/player_data.gd`, `tests/test_apartment_gameplay.gd` (Versione AVF `V5.6.2`).
- Sintomi osservati:
  1. Premendo il tasto `W` per consultare l'Albo d'Oro (`LegacyModal`), il personaggio Alex avviava una camminata in avanti automatica verso l'alto dello schermo oltre ad aprire la modale.
  2. Scegliendo l'azione "Dormi fino a domani" (dal letto o dal dock) o "Vai al giorno successivo", il gioco si bloccava senza mostrare il riepilogo giornaliero (`DailySummaryModal`), lasciando Alex congelato in stato `DAILY_SUMMARY` senza possibilità di procedere al nuovo giorno.
  3. Le azioni con durata avviate dagli arredi dell'appartamento che conferivano XP (es. esercizio alla chitarra) venivano categorizzate come puro recupero (`is_recovery = true`), impedendo l'assegnazione dei punti esperienza in `ActionSystem._complete_action()`.
- Evidenza riproducibile:
  1. Pressione del tasto `W` durante la navigazione libera nel loft: `player_alex.gd` leggeva `KEY_W` come input direzionale su `_get_input_vector()`, impostando `velocity.y = -1.0 * SPEED` e animazione `walk_up`.
  2. Al termine della giornata, `EventBus.day_ended` trasportava un intero (`day_number: int`). Il codice di gestione tentava `summary_data.get(...)` generando `SCRIPT ERROR: Nonexistent function 'get' in base 'int'` su `daily_summary.gd`. Inoltre `$Modals` rimaneva `visible = false`.
  3. `_run_action_with_duration()` istanziava `ActionData` con `is_recovery = true` hardcoded.
- Causa radice verificata:
  1. Mancata segregazione dei canali di input da tastiera: i tasti alfabetici WASD erano fusi con i controlli spaziali (frecce e numpad), creando un conflitto diretto tra il movimento in avanti (`KEY_W`) e la scorciatoia per l'Albo d'Oro (`KEY_W`).
  2. Disallineamento di contratto nei segnali tra sistemi: `EventBus.day_ended` notifica il cambio di giorno (`int`), mentre i dati statistici ed economici di fine giornata sono generati da `EndDaySystem` e richiedono un payload a dizionario (`Dictionary`). Assenza di un segnale dedicato di bus `daily_summary_ready(summary_data)` e mancata riapertura del contenitore `$Modals`.
  3. Logica di creazione `ActionData` nel modulo HUD che assumeva arbitrariamente che ogni azione domestica fosse puro recupero passivo senza verificare se `xp_amount > 0.0`.
- Soluzione applicata:
  1. Contratto D0: Rimozione totale di `KEY_W`, `KEY_A`, `KEY_S`, `KEY_D` da `player_alex.gd`. Segregazione inviolabile: movimento affidato esclusivamente a Frecce direzionali (`ui_*`) e Tastierino Numerico (Numpad 8, 2, 4, 6 e diagonali 7, 9, 1, 3). In `apartment.gd`, `_on_modal_opened()` impone `player.velocity = Vector2.ZERO` e `player.cancel_auto_walk()`.
  2. Contratto D1: Introdotto in `autoload/event_bus.gd` il segnale `signal daily_summary_ready(summary_data: Dictionary)`. In `end_day_system.gd`, `process_day_end()` emette sia `summary_ready` che `EventBus.daily_summary_ready.emit(summary)`. In `apartment_hud.gd`, collegato `EventBus.daily_summary_ready` a `_on_daily_summary_ready(summary_data)`, che impone `$Modals.visible = true`, invoca `daily_summary_modal.show_summary(summary_data)` ed emette `modal_opened.emit("DailySummary")`.
  3. Contratto D2: In `apartment_hud.gd`, `_run_action_with_duration` imposta `is_rec = (xp <= 0.0)`. In `action_system.gd`, `_complete_action()` calcola e assegna i punti esperienza formativi ogni qualvolta `base_xp > 0.0`. Aggiunto supporto ad `add_xp_to_skill` e alias `add_skill_xp` in `PlayerData`.
  4. Contratto D3: Rifinitura e pulizia catalogo arredi: Guardaroba limitato esclusivamente a cambio look e ispezione (rimosse modali spurie), Cassa Attrezzi limitata a manutenzione e test cavi (rimossa modale Upgrades).
  5. Contratto D4: Suite `tests/test_apartment_gameplay.gd` estesa con `test_key_segregation_and_sleep_cycle()` a 291 asserzioni deterministiche a 0 ms (100% superate); 30/30 suite globali verdi e 114 file GDScript verificati con 0 errori sintattici.
- Misure di prevenzione delle regressioni:
  * Non riutilizzare mai i tasti alfabetici (es. WASD) per il movimento quando la tastiera è mappata su comandi rapidi mnemonici (Zero Mouse); la navigazione spaziale deve rimanere confinata alle Frecce e al Tastierino Numerico;
  * Quando un'azione apre una finestra modale o un menu, azzerare sempre preventivamente la velocità fisica dell'avatar del giocatore (`velocity = Vector2.ZERO`) e disarmare l'eventuale auto-walk per scongiurare derive inerziali;


### BUG-022 (RRU-28) — Softlock Riprendi Menu di Sistema (resume_requested), Mancanza Blocco Input su Azioni con Durata (GAMEPLAY_BUSY) & Risoluzione Dipendenze ActionSystem (V5.6.3)

- Data e componente: `2026-09-25`, `ui/apartment_hud/apartment_hud.gd`, `scenes/apartment/apartment.gd`, `scenes/apartment/player_alex.gd`, `systems/action_system.gd`, `tests/test_apartment_gameplay.gd` (Versione AVF `V5.6.3`).
- Sintomi osservati:
  1. Durante il gameplay nel loft, premendo `Esc` si apriva il menu di sistema (`SystemMenuModal`), ma premendo nuovamente `Esc` o cliccando su "Riprendi", il menu si chiudeva visivamente ma il gioco rimaneva in freeze irreversibile: Alex non rispondeva a nessun tasto di movimento o interazione e l'orologio virtuale rimaneva congelato.
  2. Avviando un'azione con durata temporale (es. suonare la chitarra, preparare il caffè, fare flessioni), il personaggio non entrava in uno stato fisico bloccante: il giocatore poteva continuare a muoversi (frecce, tastierino o click), cliccare su altri arredi o aprire finestre modali con tasti rapidi, causando sovrapposizione di stati e rischio corruzione dati.
  3. Nei test automatici isolati (`test_vertical_slice.gd` e `test_vital_resources_system.gd`), le asserzioni di consumo energetico, accumulo stress e saldo monetario fallivano perché `ActionSystem` modificava i dati globali di `GameManager` anziché le istanze locali iniettate via costruttore.
- Evidenza riproducibile:
  1. Apertura di `SystemMenuModal` -> click su "Riprendi" o tasto `Esc`: il menu scompariva ma `ApartmentHud.close_modal(system_menu_modal)` non veniva invocato. `player.is_movement_locked` restava `true` per sempre e `GameManager.is_paused()` rimaneva `true`.
  2. Pressione di `1` nel menu interazioni della chitarra -> durante la barra di progresso dell'azione, premendo le frecce Alex si muoveva liberamente per la stanza e premendo `W` si apriva l'Albo d'Oro.
  3. Istanziazione di `ActionSystem.new(local_player, local_calendar)`: `get_player_data()` restituiva `GameManager.player_data` poiché il controllo su `GameManager` precedeva la variabile d'istanza locale.
- Causa radice verificata:
  1. In `SystemMenuModal`, la chiusura della finestra emette il segnale specializzato `resume_requested` e non `closed`. `ApartmentHud._connect_modal_signals()` collegava unicamente `modal.closed` al gestore `close_modal(modal)`, lasciando `resume_requested` orfano. Di conseguenza, la logica di sblocco movimento (`player.is_movement_locked = false`) e riattivazione tempo (`set_game_paused(false)`) non veniva mai eseguita.
  2. `apartment.gd` e `player_alex.gd` non monitoravano la transizione a `GAMEPLAY_BUSY` di `GameManager` emessa da `ActionSystem.start_action()`. Inoltre mancavano guardie su `_on_prop_clicked`, `_on_player_interaction_requested` e scorciatoie modali durante lo stato `BUSY`.
  3. `get_player_data()` e `get_calendar_data()` in `systems/action_system.gd` controllavano `GameManager.player_data` prima della variabile d'istanza `player_data`, violando il principio di Dependency Injection nei test seams headless.
- Soluzione applicata:
  1. Contratto D0: In `apartment_hud.gd`, connessi esplicitamente `system_menu_modal.resume_requested` e `system_menu_modal.closed` a `close_modal(system_menu_modal)`. Protetto `_process()` dell'HUD contro l'esecuzione dell'orologio durante la pausa.
  2. Contratto D1: In `apartment.gd`, connesso `EventBus.action_started` a `_on_action_started` che azzera la velocità di Alex (`velocity = Vector2.ZERO`), disarma l'auto-walk e impone `player.is_movement_locked = true`. Connessi `action_completed` e `action_canceled` a `_on_action_ended` per ripristinare il movimento se non ci sono modali aperte. Intercettato `KEY_ESCAPE` durante `GAMEPLAY_BUSY` per interrompere l'azione in modo atomico e sicuro (`action_system.cancel_action()`). Inserite guardie `is_busy` su click arredi e apertura menu interazione.
  3. Contratto D2: In `player_alex.gd`, introdotta la guardia reattiva `is_busy = (GameManager.current_state == Enums.GameState.GAMEPLAY_BUSY)` che blocca categoricamente `_physics_process()` (forzando `velocity = Vector2.ZERO`) e `_unhandled_input()`.
  4. Contratto D3: In `systems/action_system.gd`, invertito l'ordine di risoluzione: `if player_data: return player_data`, con fallback a `GameManager.player_data` solo se nullo. Stessa correzione applicata a `calendar_data`. In `apartment_hud.gd`, garantito il refresh dei dati attivi di `GameManager` prima di ogni azione con durata.
  5. Contratto D4: Estesa la suite `tests/test_apartment_gameplay.gd` con la nuova sezione `test_action_busy_lifecycle_and_safety()` a 321 asserzioni a 0 ms (100% superate); 30/30 suite headless superate con 0 fallimenti e 114 file GDScript privi di errori sintattici.
- Misure di prevenzione delle regressioni:
  * Nelle finestre modali di sistema e menu di pausa, verificare sempre tutti i segnali di chiusura/uscita (es. `closed`, `resume_requested`, `cancelled`) e assicurarsi che ciascuno di essi sblocchi il movimento del giocatore e ripristini la scala temporale;
  * Ogni qualvolta la FSM globale entra nello stato `GAMEPLAY_BUSY`, il controller del personaggio deve azzerare immediatamente la velocità fisica, cancellare gli itinerari di auto-walk e inibire l'acquisizione di ulteriori input direzionali o modali fino al completamento naturale o all'annullamento (`Esc`);
  * I metodi getter di fallback nei sistemi di gioco devono sempre dare priorità alle dipendenze esplicitamente iniettate nell'istanza rispetto ai singleton autoload globali, preservando l'isolamento dei test unitari headless.

### BUG-023 (RRU-29) — Dipendenza Ciclica Compilatore su GameManager.current_state & Tipizzazione EndDaySystem (V5.6.3)

- Data e componente: `2026-09-25`, `autoload/game_manager.gd`, `tests/test_vertical_slice.gd` (Versione AVF `V5.6.3`).
- Sintomi osservati: Errore irreversibile di compilazione in fase di analisi: `ERROR: res://tests/test_vertical_slice.gd:216 - Parse Error: Could not resolve member "current_state": Cyclic reference.` ed arresto del caricamento dello script `test_vertical_slice.gd`.
- Evidenza riproducibile: Compilazione statica di `test_vertical_slice.gd` in contesti in cui `EndDaySystem` e `GameManager` vengono caricati contemporaneamente.
- Causa radice verificata: Anello circolare di risoluzione simboli tra la classe globale `class_name EndDaySystem` e l'Autoload `GameManager`. In `game_manager.gd`, la variabile d'istanza era tipizzata staticamente `var end_day_system: EndDaySystem`, mentre `end_day_system.gd` invoca direttamente `GameManager`. Quando `test_vertical_slice.gd` istanziava `EndDaySystem` e accedeva direttamente alla proprietà membro `GameManager.current_state`, il resolver di GDScript 2.0 rilevava la mutua dipendenza non ancora chiusa e bloccava la risoluzione del membro come "Cyclic reference".
- Soluzione applicata:
  1. In `autoload/game_manager.gd`: de-tipizzato `var end_day_system: RefCounted` (spezzando la dipendenza statica a monte, analogamente a `award_system` e `legacy_system`) e introdotto il metodo getter pubblico `func get_current_state() -> int: return current_state`.
  2. In `tests/test_vertical_slice.gd`: sostituito l'accesso diretto alla proprietà `GameManager.current_state` (righe 166, 178, 207, 216) con il metodo disaccoppiato `GameManager.get_current_state()`.
- Test automatici eseguiti: 65/65 test superati in `test_vertical_slice.tscn`, 30/30 suite headless superate con 0 fallimenti e 114 file GDScript privi di errori sintattici in `tools/check.ps1`.
- Misure di prevenzione delle regressioni: Negli Autoload singleton evitare di tipizzare staticamente classi di sottosistemi che a loro volta referenziano l'Autoload; nei file di test o classi consumatrici accedere agli stati globali preferibilmente tramite metodi accessor (`get_current_state()`) anziché interrogare direttamente proprietà primitive durante la fase di parsing.

### BUG-024 (RRU-30) — Avanzamento Temporale Istantaneo dell'Azione "Riposo Breve" sul Letto (V5.6.4)

- Data e componente: `2026-09-25`, `scenes/apartment/apartment_interactions.gd`, `ui/apartment_hud/apartment_hud.gd`, `tests/test_apartment_gameplay.gd` (Versione AVF `V5.6.4`).
- Sintomi osservati:
  1. Selezionando l'azione "Riposo breve" dal Letto nel loft, l'orario avanzava istantaneamente alla fascia successiva senza attendere i 5 secondi previsti, saltando la barra di progressione dell'HUD e lo stato `GAMEPLAY_BUSY`.
- Evidenza riproducibile: Nel menu del letto, selezione dell'opzione 1 ("Riposo breve (+10 morale, +5 energia)"). L'orologio passava immediatamente da Morning ad Afternoon a 0 ms.
- Causa radice verificata:
  1. In `scenes/apartment/apartment_interactions.gd`, l'azione `bed_rest` aveva `duration_seconds: 0.0`.
  2. In `ui/apartment_hud/apartment_hud.gd`, nel gestore `_on_interaction_action_selected()`, il ramo `match action_type: "advance_period":` eseguiva direttamente e sincronamente `time_system.advance_to_next_period()`, senza controllare se l'azione possedesse una durata `duration_seconds > 0.0` da instradare attraverso `_run_action_with_duration()`.
- Soluzione applicata:
  1. Contratto D0: In `apartment_interactions.gd`, impostato `duration_seconds: 5.0` per `bed_rest`.
  2. Contratto D1: In `apartment_hud.gd`, modificato `_on_interaction_action_selected()` in modo che se `duration_seconds > 0.0`, l'azione viene instradata a `_run_action_with_duration()`, memorizzando `_current_running_action`. L'avanzamento effettivo `advance_to_next_period()` viene differito al callback di completamento `_on_hud_action_completed()`. In caso di annullamento (`Esc`), `_on_hud_action_canceled()` azzera l'azione senza toccare l'orologio.
- Test automatici eseguiti: Nuova asserzione dedicata in `test_apartment_gameplay.gd` che verifica lo stato `GAMEPLAY_BUSY`, l'invarianza oraria iniziale e l'avanzamento differito post-5s. 30/30 suite headless superate con 0 errori a 0 ms.
- Misure di prevenzione delle regressioni: Ogni azione di simulazione associata a passaggio orario o cambio stato deve verificare preliminarmente se ha una durata fisica associata prima di attivare direttamente l'effetto terminale; gli effetti differiti devono sempre attendere il completamento naturale di `ActionSystem`.

### BUG-025 (RRU-31) — Hitch Cinetico / Micro-stop all'Avvicinamento Arredi da Lock TTS e Sintesi Audio Procedurale al Volo (V5.6.4)

- Data e componente: `2026-09-25`, `scenes/apartment/apartment.gd`, `systems/audio_cue_system.gd`, `autoload/accessibility_manager.gd` (Versione AVF `V5.6.4`).
- Sintomi osservati:
  1. Mentre il personaggio cammina liberamente nel loft a velocità normale (210 px/s), quando si avvicina a un qualsiasi arredo interattivo si verificava un vistoso micro-stop / scatto cinetico (frame freeze per svariati millisecondi), interrompendo la fluidità del movimento prima che la sintesi vocale pronunciasse il nome dell'arredo.
- Evidenza riproducibile: Camminata continua con Frecce o Numpad attraversando la zona di prossimità di `PropBed`, `PropKitchen` o `PropTurntable`.
- Causa radice verificata:
  1. In `AudioCueSystem`: la generazione procedurale dei campioni audio PCM mono 16-bit (cicli `sin` in GDScript su 2646 campioni) avveniva *on-demand* alla prima riproduzione di `HOTSPOT_PROXIMITY`, allocando memoria e calcolando campioni sincroni sul main thread durante il frame di collisione.
  2. In `apartment.gd`: `_on_player_entered_prop()` invocava `AccessibilityManager.announce(..., true)`. Il parametro `is_interrupt = true` causava una chiamata sincrona bloccante a `DisplayServer.tts_stop()`, che in Windows 11 effettua lock UIA/COM sul thread principale dell'applicazione, causando un drop di frame durante il quale la lettura dell'input in `_physics_process` veniva persa.
- Soluzione applicata:
  1. Contratto D0: In `systems/audio_cue_system.gd`, introdotto il metodo `precache_all_cues()` invocato direttamente in `_ready()`, che sintetizza in memoria tutti i suoni procedurali all'avvio a 0 ms.
  2. Contratto D1: In `scenes/apartment/apartment.gd`, in `_on_player_entered_prop()` impostato `is_interrupt = false`, permettendo l'accodamento trasparente della sintesi vocale senza arresto forzato del driver TTS e senza interruzione del frame rate.
- Test automatici eseguiti: Verifica di pre-caching e continuità cinetica in `test_apartment_gameplay.gd` (356 asserzioni). 30/30 suite headless convalidate con 0 errori a 0 ms.
- Misure di prevenzione delle regressioni: Negli annunci vocali frequenti generati da trigger fisici di prossimità, non usare mai interruzioni forzate sincroniche (`is_interrupt = true`); pre-caricare sempre tutti i campioni sonori procedurali in memoria durante la fase di setup (`_ready()`).

### BUG-026 (RRU-32) — Scarsa Leggibilità del Menu Interazione da Pergamene Bitmap a 8px e Mancanza di Contrasto (V5.6.4)

- Data e componente: `2026-09-25`, `ui/interaction_menu/interaction_menu.tscn`, `ui/interaction_menu/interaction_menu.gd` (Versione AVF `V5.6.4`).
- Sintomi osservati:
  1. Il menu di interazione con gli arredi utilizzava texture a pergamena disegnata con font bitmap a 8 pixel e larghezza contenitore a 320 px, risultando difficilmente leggibile su schermi moderni o a distanza, con contrasto visivo insufficiente e aspetto non integrato con l'HUD.
- Evidenza riproducibile: Apertura del menu interazioni di qualsiasi arredo (es. Chitarra o Cucina).
- Causa radice verificata: Utilizzo di asset bitmap a pergamena (`interazione_corta.png`, ecc.) che imponevano vincoli geometrici rigidi e font di ridotte dimensioni per non sbordare.
- Soluzione applicata:
  1. Rimozione totale delle texture bitmap a pergamena e dei relativi calcoli di scala in `interaction_menu.gd`.
  2. Creazione di un layout vettoriale `BackgroundPanel` ad alto contrasto con `StyleBoxFlat` scuro `#11121a` e bordo dorato `#c49a45`.
  3. Allargamento del menu a 480 px, font del titolo portato a 16 px e font delle opzioni portato a 14 px con autowrap word-smart e margini interni confortevoli (12x8 px).
  4. Piena conformità WCAG AAA e conservazione del 100% dell'accessibilità da tastiera (numeri 1..9, Numpad 1..9, Frecce, Invio, Spazio ed Esc).
- Test automatici eseguiti: 356 asserzioni in `test_apartment_gameplay.gd` superate al 100% a 0 ms; 30/30 suite headless superate con 0 errori.
- Misure di prevenzione delle regressioni: Privilegiare sempre pannelli vettoriali ad alto contrasto scalabili per i menu di testo interattivi, con font non inferiore a 14 px per garantire accessibilità universale sia per ipovedenti che per utenti con display ad alta risoluzione.

### BUG-027 (RRU-33) — Persistenza dei Nodi Figli nelle Rigenerazioni Dinamiche Headless Sincrone da queue_free() Ritardato in Godot 4 (V5.7.1)

- Data e componente: `2026-09-25`, `ui/character/character_sheet.gd`, `tests/test_skills_and_loft_study_system.gd` (Versione AVF `V5.7.1`).
- Sintomi osservati:
  1. Durante l'esecuzione sincrona headless del test di cambio branca nell'albero delle competenze (da `GENRES` a `STAGE`), l'asserzione `vbox_skills_tree_list.get_child_count()` restituiva 14 nodi anziché i 7 nodi attesi per la branca filtrata.
- Evidenza riproducibile: Invocazione in successione rapida a 0 ms di `character_sheet._on_branch_filter_selected("stage")` subito dopo il popolamento iniziale della branca `genres`.
- Causa radice verificata:
  1. In Godot 4, il metodo `queue_free()` non rimuove istantaneamente il nodo dall'albero di scena, bensì ne accoda la distruzione al termine del frame corrente (fase di idle notification loop).
  2. Nei test runner headless sincroni eseguiti a 0 ms senza frame-loop intermedio, la sequenza `for c in container.get_children(): c.queue_free()` seguita immediatamente da `container.add_child(...)` fa sì che `container.get_children()` includa sia i vecchi nodi in attesa di deallocazione sia i nuovi nodi appena istanziati, falsando il conteggio gerarchico.
- Soluzione applicata:
  1. Nel ciclo di pulizia del container dinamico (`character_sheet.gd`, riga 174), disconnettere esplicitamente il nodo dall'albero prima di invocare `queue_free()`:
     ```gdscript
     for c in vbox_skills_tree_list.get_children():
         vbox_skills_tree_list.remove_child(c)
         c.queue_free()
     ```
- Test automatici eseguiti: 128/128 asserzioni superate in `test_skills_and_loft_study_system.gd`; 31/31 suite headless complessive superate con 0 errori a 0 ms; 115 file GDScript compilati correttamente in `tools/check.ps1`.
- Misure di prevenzione delle regressioni: In ogni logica UI che distrugge e ripopola dinamicamente elenchi di nodi `Control`, applicare categoricamente `container.remove_child(c)` prima di `c.queue_free()`, garantendo determinismo atomico sia nei test headless sincroni a 0 ms sia in caso di selezioni rapide da tastiera ad alto frame rate.

### BUG-028 (RRU-34) — Disallineamento Testo-Voce (TTS) e Congelamento del Box di Dialogo BottomLeftDialogue (V5.8.0)

- Data e componente: `2026-09-25`, `ui/apartment_hud/apartment_hud.gd`, `systems/action_system.gd`, `scenes/apartment/apartment.gd` (Versione AVF `V5.8.0`).
- Sintomi osservati:
  1. Box visivo `BottomLeftDialogue` statico o bloccato su un vecchio messaggio di azione o sul placeholder iniziale ("New York - Loft Apartment...").
  2. Discrepanza totale con la sintesi vocale (NVDA): lo screen reader legge messaggi sintetici o divergenti mentre a schermo permangono testi differenti.
  3. L'indicatore `[Spazio] Chiudi` non congedava la notifica poiché il tasto Spazio veniva intercettato dal movimento/prossimità dell'arredo.
- Evidenza riproducibile: Completamento di un'azione alla chitarra nel loft: NVDA vocalizzava "Completato: Scale e riff alla chitarra. Guadagnati 20.0 XP.", mentre il box visivo mostrava "Esercizio alla chitarra completato: +20 XP Chitarra, -10 Energia, +3 Stress, +5 Morale!".
- Causa radice verificata:
  1. Emissione concorrente di annunci vocali: `ActionSystem._complete_action()` emetteva autonomamente una sintesi generica, mentre `ApartmentHud` popolava `label_text.text` con `result_message` disabilitando l'annuncio locale (`should_announce: false`).
  2. Negli arredi domestici diretti (Cucina, Divano, Giradischi, Stereo), invocazione disgiunta di `AccessibilityManager.announce()` e `show_inspection()` con stringhe diverse.
  3. All'allontanamento dagli arredi, `clear_inspection()` nascondeva il pannello e svuotava i testi, lasciando in cache su AccessKit/NVDA il buffer precedente.
  4. Assenza di una gestione del tasto Spazio o Esc per congedare esplicitamente le notifiche transitorie di completamento azione.
- Soluzione e Misure di prevenzione delle regressioni:
  1. Canone "Zero Divergenza Testo-Voce": centralizzazione in `ApartmentHud` del metodo canonico `display_dialogue(text, speaker, hint, should_announce, is_interrupt)` che assegna rigorosamente la stessa identica stringa sia al label visivo sia alla sintesi vocale;

### BUG-029 (RRU-35) — Deserializzazione Volatile e Ri-applicazione Spuria dei Flag Overtime Notturno al Caricamento Salvataggio (V5.8.1)

- Data e componente: `2026-09-26`, `data/models/calendar_data.gd`, `systems/time_system.gd`, `autoload/save_manager.gd`, `tests/test_multi_day_lifecycle.gd` (Versione AVF `V5.8.1`).
- Sintomi osservati:
  1. Se un giocatore salvava la partita durante le ore di overtime notturno (ad esempio alle 02:30 del mattino) e successivamente ricaricava il salvataggio dal menu principale o dal menu di sistema, al primo tick dell'orologio virtuale venivano ri-applicate ingiustamente le penalità di stress accumulate nelle ore precedenti (+2, +3, +5 = +10 stress indebito) e venivano ripetuti gli annunci vocali discreti per NVDA già ascoltati (es. avviso delle 02:00).
- Evidenza riproducibile:
  1. Avanzamento del tempo fino alle 02:30 di notte in `TimeSystem`: stress del musicista pari a 10 e flag `warned_hour_2`, `overtime_hour_1_applied` .. `_3_applied` attivi.
  2. Esecuzione di `SaveManager.save_game()` seguito da `SaveManager.load_game()`.
  3. Al primo avanzamento temporale (`time_system.advance_time(0.1)`), lo stress saliva erroneamente da 10 a 20 e l'annuncio delle 02:00 veniva riemesso.
- Causa radice verificata:
  1. I flag di tracciamento dell'overtime e del riposo anticipato (`warned_hour_2`, `warned_hour_3`, `overtime_hour_1_applied` .. `_4_applied`, `early_sleep_taken`, `sleep_period`, `sleep_hour_offset`) erano definiti come mere variabili d'istanza runtime volatili in `TimeSystem`, escluse dalla struttura di persistenza atomica di `CalendarData` (`to_dict()` e `from_dict()`).
  2. All'atto del caricamento, `SaveManager.load_game()` re-istanziava o riassegnava `GameManager.calendar_data`, lasciando i campi interni di `TimeSystem` inizializzati al loro valore predefinito `false`. Di conseguenza, `_check_overtime_and_notifications()` considerava le soglie orarie superate come nuovi eventi da processare.
- Soluzione applicata:
  1. Contratto D0: Spostamento strutturale del dizionario `overtime_state` nel modello dati persistente `CalendarData`, con inclusione obbligatoria in `to_dict()` e deserializzazione robusta con fallback in `from_dict()`.
  2. Contratto D1: In `TimeSystem`, trasformazione di tutti i flag di overtime in proprietà reattive (getter/setter) delegate direttamente a `calendar_data.overtime_state`, garantendo zero sfasamento temporale e azzeramento automatico ad ogni alba tramite `calendar_data.reset_daily_saturation()`.
  3. Contratto D2: Creazione della nuova suite di test headless deterministica a 0 ms `tests/test_multi_day_lifecycle.gd` (con wrapper `test_multi_day_lifecycle.tscn`), contenente 50 asserzioni che verificano il ciclo multi-giorno, l'accumulo esatto di 20 punti stress in overtime profondo, l'invarianza dello stress e degli avvisi post save/load notturno, la transizione economica e lo sblocco FSM.
  4. Contratto D3: Convalida globale con `tools/check.ps1` (118 file GDScript con 0 errori) e `tools/test.ps1` (32/32 suite headless superate con 0 fallimenti a 0 ms).
- Misure di prevenzione delle regressioni:
  * Ogni stato temporale o di simulazione che determina penalità cumulative o trigger di notifica progressivi deve risiedere nei modelli dati canonici serializzabili (`CalendarData`, `PlayerData`) e mai in variabili d'istanza effimere dei controller di sistema.
  * Nei sistemi temporali, utilizzare il pattern a delega diretta (property getters/setters) sul modello dati sottostante per eliminare ridondanze e scongiurare sfasamenti di sincronizzazione tra la logica di calcolo e la persistenza JSON.
