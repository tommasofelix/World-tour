# Archivio delle revisioni validate — World-tour

Le revisioni vengono archiviate qui soltanto dopo risoluzione verificata e accettazione del relativo criterio di chiusura. Le voci più recenti devono essere inserite in cima.

## Revisioni archiviate

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
