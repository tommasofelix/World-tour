# Piano Tecnico Formale: Risoluzione Softlock Menu di Sistema, FSM GAMEPLAY_BUSY & Blindatura Azioni (Loft NYC — V5.6.3)

- Autore: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity (AI Pair Programmer)
- Framework di riferimento: ASTRALIS v3.0.7
- Versione AVF: `V5.6.3`
- Stato del piano: `[x] COMPLETATO E CONVALIDATO AL 100%`

---

## 1. Obiettivo dell'Intervento
Risolvere la causa radice del freeze/softlock totale del gameplay manifestatosi dopo l'apertura e chiusura del Menu di Sistema (`SystemMenuModal`), implementare il vincolo fisico e logico dello stato `GAMEPLAY_BUSY` durante qualsiasi azione con durata temporale nell'appartamento (chitarra, espresso, flessioni, routine domestiche), garantire l'annullamento sicuro tramite tasto `Esc` e correggere la risoluzione delle dipendenze in `ActionSystem`.

---

## 2. Contratti Tecnici Eseguiti (D0..D4)

### Contratto D0: Risoluzione Segnale `resume_requested` di `SystemMenuModal`
- In `ui/apartment_hud/apartment_hud.gd`:
  * Connessi sia `system_menu_modal.resume_requested` che `system_menu_modal.closed` al metodo unificato `close_modal(system_menu_modal)`;
  * Sbloccato deterministico di `player.is_movement_locked = false`;
  * Disattivata la pausa temporale con `GameManager.set_game_paused(false)`;
  * Protetto `_process()` dell'HUD contro l'avanzamento temporale durante la pausa.

### Contratto D1: Controller Loft NYC & Intercettazione FSM `GAMEPLAY_BUSY`
- In `scenes/apartment/apartment.gd`:
  * Connesso `EventBus.action_started` a `_on_action_started`: azzera la velocità (`velocity = Vector2.ZERO`), disarma l'auto-walk (`cancel_auto_walk()`) e impone `player.is_movement_locked = true`;
  * Connessi `EventBus.action_completed` e `EventBus.action_canceled` a `_on_action_ended`: ripristinano la libertà di movimento (`player.is_movement_locked = false`) se non ci sono altre finestre aperte;
  * In `_unhandled_input()`: intercettata la pressione di `KEY_ESCAPE` durante `GAMEPLAY_BUSY` per invocare `action_system.cancel_action()`;
  * Inserite guardie reattive `is_busy` su click arredi e apertura menu interazione.

### Contratto D2: Blocco Reattivo su `PlayerAlex`
- In `scenes/apartment/player_alex.gd`:
  * Introdotta guardia di stato `is_busy = (GameManager.current_state == Enums.GameState.GAMEPLAY_BUSY)`;
  * In `_physics_process()`: se `is_busy`, azzera `velocity = Vector2.ZERO` ed esce immediatamente;
  * In `_unhandled_input()`: inibisce l'acquisizione di input fisici durante `is_busy`.

### Contratto D3: Risoluzione Dipendenze in `ActionSystem` & Refresh Dati HUD
- In `systems/action_system.gd`:
  * Invertito l'ordine di fallback: `if player_data: return player_data`, con ripiegamento su `GameManager.player_data` solo se nullo;
  * Stessa logica per `calendar_data`;
  * In `ui/apartment_hud/apartment_hud.gd`: garantito il refresh dei dati di `GameManager` prima di ogni azione con durata.

### Contratto D4: Suite di Test Automatizzati & Convalida
- In `tests/test_apartment_gameplay.gd`:
  * Aggiunta la sezione `test_action_busy_lifecycle_and_safety()` con 30 nuove asserzioni a 0 ms;
  * Convalida totale: 321/321 asserzioni superate a 0 errori e 0 ms;
  * 30/30 suite headless globali superate al 100% con 0 errori;
  * 114 file GDScript privi di errori sintattici.

---

## 3. Esito e Convalida
- Suite Loft NYC: 321/321 test superati.
- Suite Globale: 30/30 suite superate con 0 fallimenti.
- Verifica Sintattica: 114/114 file GDScript corretti.
- Versione AVF: `V5.6.3`.
