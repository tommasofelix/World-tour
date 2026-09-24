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
