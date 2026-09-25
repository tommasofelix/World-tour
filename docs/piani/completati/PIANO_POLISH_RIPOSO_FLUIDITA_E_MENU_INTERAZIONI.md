# World-tour — Piano Tecnico Polish Riposo, Fluidità Movimento & Menu Interazioni (Fase 1A & 1B)
# Autore: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Versione Target: AVF V5.6.4 — Polish Ergonomia, Fluidità Cinetica & Tipografia Accessibile
# Data: 25 Settembre 2026
# Stato: Convalidato con Successo e Archiviato (Fase 3)

Questo piano tecnico formalizza gli interventi di rifinitura e risoluzione dei tre punti segnalati per il Gameplay Grafico 2.5D del Loft di New York:
1. Riposo breve a tempo reale (5 secondi con FSM `GAMEPLAY_BUSY`, barra progresso e avanzamento orario solo a completamento);
2. Eliminazione del "mini stop" all'avvicinamento degli arredi, garantendo un movimento fluido e ininterrotto con Frecce e Numpad senza perdere la vocalizzazione NVDA;
3. Restyle del Menu Interazioni: rimozione totale delle texture a pergamena, layout testuale pulito ad alto contrasto e ingrandimento del font a 14-16 px per una leggibilità immediata.

---

## 🏛️ CHECKLIST DI CONVALIDA A 3 STATI (MATRICE PER NVDA)

- [x] [CONVALIDATO CON SUCCESSO] Contratto D0: Clean sweep residui e pre-caching audio cue procedurali in `AudioCueSystem` a 0 ms.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D1: Fluidità cinetica continua in `player_alex.gd` e disaccoppiamento input/sintesi vocale.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D2: Riposo breve calibrato a 5 secondi con FSM `GAMEPLAY_BUSY` e avanzamento differito in `ApartmentHud`.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D3: Restyle tipografico del Menu Interazioni con rimozione pergamena e font ingrandito.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D4: Suite di test headless in `test_apartment_gameplay.gd`, 30/30 test verdi e Living Documentation.

---

## 🛡️ CONTRATTI DI IMPLEMENTAZIONE DETTAGLIATI

### Contratto D0: Clean Sweep & Pre-Caching Audio Cue Procedurali a 0 ms
- File target: `systems/audio_cue_system.gd`
- Causa dell'hitch: La sintesi procedurale dello stream audio di `HOTSPOT_PROXIMITY` (2646 campioni audio generati con funzioni trigonometriche in GDScript) viene eseguita la prima volta che Alex entra nell'area di un arredo, congelando il thread principale per decine di millisecondi.
- Modifica:
  - In `AudioCueSystem._ready()`: pre-generare e registrare in `_stream_cache` tutti gli earcon procedurali (incluso `HOTSPOT_PROXIMITY`, `COLLISION_BUMP`, `AREA_PERSONAL`, ecc.).
  - All'ingresso di Alex in qualsiasi area, `play_cue()` recupera immediatamente lo stream già allocato con tempo di accesso pari a 0 ms, eliminando ogni hitch o calo di framerate.

### Contratto D1: Fluidità Cinetica Continua & Disaccoppiamento Input/TTS
- File target: `scenes/apartment/player_alex.gd`, `autoload/accessibility_manager.gd`, `scenes/apartment/apartment.gd`
- Causa del mini stop: Quando Alex si avvicina a un arredo, l'invocazione di `AccessibilityManager.announce()` chiama `DisplayServer.tts_stop()` e `DisplayServer.tts_speak()`. Sotto Windows 11 le chiamate COM a SAPI possono bloccare temporaneamente il frame rate. Durante questo freeze, `_physics_process()` perde campioni di tastiera e azzera istantaneamente la velocità prima di ripartire.
- Modifica:
  - In `player_alex.gd`: blindare la funzione di movimento `_physics_process()` assicurando che l'ingresso nelle aree di trigger degli arredi non alteri in alcun modo il vettore cinetico né azzeri la velocità di camminata (210 px/s).
  - In `accessibility_manager.gd`: proteggere la chiamata a `DisplayServer.tts_stop()` con una guardia anti-spam e un buffer di timing che eviti interruzioni COM sincrone ravvicinate mentre il giocatore è in movimento continuo.
  - In `apartment.gd`: assicurare che l'evento `_on_player_entered_prop()` aggiorni le label e l'annuncio vocale senza provocare alcuna ricalibrazione del controller del giocatore né modificare lo stato della FSM (che rimane `GAMEPLAY_IDLE`).

### Contratto D2: Riposo Breve Calibrato a 5 Secondi & FSM BUSY
- File target: `scenes/apartment/apartment_interactions.gd`, `ui/apartment_hud/apartment_hud.gd`
- Causa del riposo istantaneo: In `ApartmentHud`, il ramo `match action.type` per `"advance_period"` eseguiva direttamente `GameManager.time_system.advance_to_next_period()` senza valutare se `duration_seconds > 0.0` e senza passare da `_run_action_with_duration()`.
- Modifica:
  - In `apartment_interactions.gd`: aggiornare l'azione `bed_rest` impostando esplicitamente `duration_seconds: 5.0` (invece di 8.0) e preservando `type: "advance_period"`, `energy_delta: 15`, `stress_delta: -5`.
  - In `apartment_hud.gd`:
    - Nel ramo `"advance_period"`, se `action.get("duration_seconds", 0.0) > 0.0`: invocare `_run_action_with_duration(action)`.
    - L'azione avvia il countdown di 5 secondi, attiva lo stato `GAMEPLAY_BUSY`, mostra la notifica ("In corso: Riposo breve (5s)...") e permette la cancellazione atomica con `Esc`.
    - In `_connect_events()`: connettere `EventBus.action_completed` al metodo di chiusura `_on_hud_action_completed(action_id, rewards)`.
    - In `_on_hud_action_completed()`: verificare se l'azione conclusa è di tipo `advance_period` (o id `bed_rest`); in tal caso invocare `GameManager.time_system.advance_to_next_period()`, applicare i benefici all'energia e allo stress ed emettere l'annuncio vocale di risveglio per NVDA. Se invece Luca preme `Esc`, l'azione si interrompe e il tempo rimane congelato.

### Contratto D3: Restyle Tipografico Menu Interazione (Zero Immagini & Testo Ingrandito)
- File target: `ui/interaction_menu/interaction_menu.gd`, `ui/interaction_menu/interaction_menu.tscn`
- Causa della scarsa leggibilità: Il menu usava texture a pergamena disegnate (`interazione_corta/media/lunga.png`) e font da 8 px per le opzioni e 10 px per il titolo.
- Modifica:
  - Rimuovere il caricamento delle immagini di sfondo a pergamena (`BackgroundTexture.texture = null` e `visible = false`).
  - Sostituire lo sfondo con un pannello scuro sobrio ad alto contrasto (`StyleBoxFlat` colore `#11121a` con bordo sottile oro/rame `#c49a45`), conforme a WCAG AAA.
  - Ingrandire il titolo dell'arredo a **16 px** (colore bianco/oro brillante `#ffe066`).
  - Ingrandire il font delle opzioni pulsante da 8 px a **14-16 px**.
  - Allargare il menu da 320 px a **480-500 px** con margini interni ampliati, in modo che il testo ingrandito si disponga su righe chiare con `AUTOWRAP_WORD_SMART` senza troncature.
  - Conservare integralmente la navigazione da tastiera: Frecce Su/Giù, numeri 1..9, Numpad 1..9, Invio/Spazio per selezionare, Esc per chiudere, con annunci vocali completi per NVDA.

### Contratto D4: Convalida Headless & Living Documentation
- File target: `tests/test_apartment_gameplay.gd`, `docs/todo.md`, `knowledge/01_accessibilita_vocale_e_interazione_tastiera.md`, `knowledge/09_registro_bug_e_soluzioni.md`, `CHANGELOG.md`
- Modifica:
  - Implementati nuovi test unitari e di integrazione in `test_apartment_gameplay.gd`:
    * Test durata riposo breve (5s con FSM `GAMEPLAY_BUSY`, blocco movimento e avanzamento periodo orario a completamento);
    * Test annullamento riposo breve con tasto `Esc` (nessun avanzamento orario, ripristino `GAMEPLAY_IDLE`);
    * Test menu interazione testuale pulito con font ingrandito e assenza di texture grafiche;
    * Test fluidità movimento e persistenza velocità durante l'avvicinamento agli arredi.
  - Esecuzione completa delle 30 suite con 0 errori (100% verde).
  - Avanzamento versione AVF a **V5.6.4** e aggiornamento della Living Documentation.
