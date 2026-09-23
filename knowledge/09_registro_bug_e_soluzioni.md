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
