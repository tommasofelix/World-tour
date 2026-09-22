# Diagnostica Telemetria e Analisi Log — Collaudo Fase 3 (Music Crafting)
# Data: 22 Settembre 2026
# Ambiente: Godot Engine v4.7.2.stable.official.ed1daf0bf - Windows 11 (Vulkan Forward+ NVIDIA RTX 5060)

---

## 1. File di Log Analizzati

Durante la sessione di collaudo interattivo in-game condotta da Luca e Tom, il runtime di Godot ha generato i seguenti file di telemetria e log utente in `$env:APPDATA\Godot\app_userdata\World Tour\logs\`:

1. `godot2026-09-22T12.38.48.log` (3.102 bytes)
   - Contesto: Esecuzione delle suite di test unitari automatici da terminale.
   - Esito: Tutti i test headless superati con exit code 0.
2. `godot2026-09-22T12.39.00.log` (151 bytes)
   - Contesto: Avvio sessione grafica Forward+ Vulkan.
3. `godot2026-09-22T12.40.56.log` (699 bytes)
   - Contesto: Prima sessione di collaudo in-game dall'HUD.
   - Anomalia: `SCRIPT ERROR` critico registrato durante la creazione di una bozza.
4. `godot2026-09-22T12.41.36.log` (699 bytes)
   - Contesto: Seconda sessione di collaudo in-game.
   - Anomalia: Medesimo `SCRIPT ERROR` rilevato sul secondo tentativo.

---

## 2. Evidenza Telemetrica & Stack Trace

I log `12.40.56` e `12.41.36` riportano identica traccia di errore:

```text
Godot Engine v4.7.2.stable.official.ed1daf0bf - https://godotengine.org
Vulkan 1.4.341 - Forward+ - Using Device #0: NVIDIA - NVIDIA GeForce RTX 5060

SCRIPT ERROR: Invalid access to property or key 'theme_override_constants' on a base object of type 'HBoxContainer'.
   at: _create_song_row (res://ui/music/song_catalog.gd:90)
   GDScript backtrace (most recent call first):
       [0] _create_song_row (res://ui/music/song_catalog.gd:90)
       [1] refresh_catalog (res://ui/music/song_catalog.gd:81)
       [2] <anonymous lambda> (res://ui/music/song_catalog.gd:37)
       [3] create_draft (res://systems/music_system.gd:37)
       [4] _on_btn_action_pressed (res://ui/music/song_creator.gd:153)
```

---

## 3. Analisi della Causa Radice (Root Cause Analysis)

1. **Trigger Operativo**:
   L'utente ha aperto lo Studio di Creazione Brano (`SongCreator`), compilato il titolo/genere e premuto il pulsante per avviare la composizione (`_on_btn_action_pressed`).
2. **Catena Reattiva EventBus**:
   - `SongCreator` invoca `MusicSystem.create_draft(...)`.
   - `MusicSystem.create_draft` genera l'oggetto `SongData` e notifica il sistema emettendo `EventBus.song_created.emit(...)`.
   - Il componente `SongCatalog` (in ascolto globale su `EventBus.song_created`) riceve l'evento ed esegue `refresh_catalog()`.
3. **Punto di Rottura**:
   - In `refresh_catalog()`, essendo ora presente un brano nel catalogo, viene invocato `_create_song_row(1, song)`.
   - Alla riga 90 di `ui/music/song_catalog.gd` è presente l'istruzione:
     `row.theme_override_constants.separation = 15`
   - In Godot 4 GDScript, `Control` e `Container` non espongono `theme_override_constants` come membro scrivibile con notazione ad albero. L'override delle costanti di tema a runtime richiede l'invocazione dell'API:
     `row.add_theme_constant_override("separation", 15)`
   - Il tentativo di accesso a una proprietà inesistente su `HBoxContainer` ha causato l'interruzione immediata dello script, bloccando l'interfaccia.

4. **Perché i test precedenti non lo avevano rilevato**:
   - Il test `test_music_system.gd` istanziava la scena `song_catalog.tscn`, ma in assenza di brani nel catalogo durante quel frame, il ciclo `for` su `filtered_songs` non veniva percorso e la funzione `_create_song_row` non veniva eseguita.
   - Il parser sintattico statico di Godot non segnala l'accesso puntato su oggetti derivati se la proprietà non è formalmente tipizzata con restrizioni rigide.

---

## 4. Piano di Risoluzione e Correzione Chirurgica

1. **Modifica a `ui/music/song_catalog.gd` (riga 90)**:
   Sostituire:
   ```gdscript
   row.theme_override_constants.separation = 15
   ```
   con:
   ```gdscript
   row.add_theme_constant_override("separation", 15)
   ```
2. **Estensione della Suite di Test (`tests/test_music_system.gd`)**:
   Aggiungere nel test di istanziazione UI la popolazione fittizia di un brano in `player_data` e la chiamata esplicita a `cat_inst.refresh_catalog()`, verificando l'effettiva creazione del nodo riga e l'assenza di eccezioni.
