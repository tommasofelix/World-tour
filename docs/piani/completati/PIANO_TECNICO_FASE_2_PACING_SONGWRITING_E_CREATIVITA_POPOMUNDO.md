# World-tour — Piano Tecnico Formale: Pacing del Songwriting, Limiti Quotidiani & Sviluppo Graduale Popomundo (Fase 2 — Sotto-Fase 1A)
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Versione Target: AVF V5.10.0 — Pacing Songwriting Popomundo, Limiti 2 Sessioni & Avanzamento Temporale
# Data: 26 Settembre 2026
# Percorso File: docs/piani/attivi/PIANO_TECNICO_FASE_2_PACING_SONGWRITING_E_CREATIVITA_POPOMUNDO.md
# Baseline AVF: V5.9.1 (33/33 Suite Headless Superate a 0 Errori e 0 ms)
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Macro-Fase 2 implementata e convalidata con 33/33 test headless a 0 ms)

---

## 🎯 1. OBIETTIVO ARCHITETTURALE E VISIONE GENERALE

Questo piano tecnico formalizza la **Macro-Fase 2** del programma di revisione sistemica ispirata a **Popomundo**, focalizzandosi sul **rallentamento organico e fisiologico del songwriting**:
1. Eliminare in modo permanente la possibilità di spammare le azioni di scrittura e composizione, introducendo il limite di **massimo 2 sessioni giornaliere per componente (Musica / Testo) su ciascun brano**;
2. Introdurre la dinamica dei **Rendimenti Marginali Decrescenti**: la prima sessione del giorno garantisce il 100% della resa, mentre la seconda sessione sconta la stanchezza creativa (resa al 50%, stress maggiorato del +50%); la terza sessione viene intercettata e **respinta categoricamente a costo zero**;
3. Ricalibrare la formula di avanzamento (base ridotta a 8.0%, resa media per sessione piena 12–16%), garantendo che una canzone richieda tra i **4 e i 7 giorni virtuali** di lavoro artigianale per giungere alla Finestra di Rifinitura Arancione;
4. Integrare l'avanzamento del tempo virtuale in `SongCreator` tramite `TimeSystem` (2 ore virtuali per la musica, 1.5 ore per il testo), sincronizzando l'attività con il ciclo circadiano del gioco;
5. Fornire feedback vocali immediati e descrizioni di stato parlanti nella Scheda 1 di `SongCreator` e nelle interazioni del Loft NYC, mantenendo il 100% di accessibilità **Zero Mouse** per NVDA;
6. Mantenere l'integrità deterministica delle 33 suite headless del progetto a 0 ms.

---

## 🏛️ 2. CHECKLIST DI CONVALIDA A 3 STATI (MATRICE PER NVDA)

- [x] [CONVALIDATO CON SUCCESSO] Contratto D0: Estensione `SongData` con `daily_music_sessions`, `daily_lyrics_sessions`, helper `can_work_music_today()`, `can_work_lyrics_today()`, `reset_daily_sessions()` e serializzazione atomica;
- [x] [CONVALIDATO CON SUCCESSO] Contratto D1: Ricalibrazione formule e logica a 2 sessioni con rendimenti decrescenti al 50% e blocco a costo zero in `systems/music_system.gd`;
- [x] [CONVALIDATO CON SUCCESSO] Contratto D2: Metodo `advance_virtual_hours(hours)` in `TimeSystem` e avanzamento dell'orologio (2h musica, 1.5h testo) in `MusicSystem`;
- [x] [CONVALIDATO CON SUCCESSO] Contratto D3: Integrazione reset giornaliero sessioni brani in `EndDaySystem` e allineamento guardie nelle azioni Loft di `ApartmentInteractions`;
- [x] [CONVALIDATO CON SUCCESSO] Contratto D4: Riorganizzazione Scheda 1 `SongCreator` con annunci parlanti dello stato sessioni quotidiane e disabilitazione pulsanti saturi;
- [x] [CONVALIDATO CON SUCCESSO] Contratto D5: Aggiornamento suite `test_advanced_songwriting_system.gd`, esecuzione verifiche `check.ps1` e `test.ps1` (33/33 verdi a 0 ms) e avanzamento AVF a `V5.10.0`.

---

## ⚖️ 3. I 7 ASSI DI QUALITÀ ASTRALIS APPLICATI

- **Asse 1 — Validità**: Tipizzazione statica GDScript 2.0 per i contatori di sessione, guardie booleane deterministiche e gestione serializzazione sicura.
- **Asse 2 — Efficacia**: Eliminazione fisica dello spamming; ogni canzone richiede più giornate di dedizione prima di essere completata.
- **Asse 3 — Coerenza**: Armonia con la Clean Architecture e con l'anti-grinding esistente di `CalendarData` (reset notturno all'alba).
- **Asse 4 — Completezza**: Copertura esaustiva dei 3 stati (Sessione 1 piena, Sessione 2 stanca, Sessione 3 bloccata a costo zero), gestione burnout e salvataggio/caricamento a metà giornata.
- **Asse 5 — Precisione**: Modifiche mirate a `SongData`, `MusicSystem`, `TimeSystem` e `SongCreator`, senza alterare i sistemi a valle (concerti, classifiche, contratti).
- **Asse 6 — Affidabilità & Prestazioni**: Esecuzione deterministica headless a 0 ms; zero thread concorrenti o timer fisici bloccanti.
- **Asse 7 — Assenza Regressioni**: Compatibilità retroattiva con tutte le 33 suite di test esistenti.

---

## 🛡️ 4. I 6 CANCELLI INVIOLABILI (PROTOCOLLO 12 — INNER CODEX PATTERN)

- **Cancello 1 (Rifiuto Patching Euristico)**: Diagnosi deterministica delle cause dello spamming (base gain eccessiva, assenza di contatore giornaliero per brano). Risoluzione strutturale alla radice.
- **Cancello 2 (Hardware Grounding & Zero Mouse)**: Tasti rapidi `M`, `T`, `R` in `SongCreator` e azioni contestuali del Loft operabili al 100% da tastiera con feedback vocali per NVDA.
- **Cancello 3 (Hitbox, Clearance Continua & Volumi Sicuri)**: Nessuna alterazione geometrica nel Loft; volumi degli earcons confermati entro il range salvavita 0.70f–0.75f.
- **Cancello 4 (Named Contracts D0..DN)**: Scomposizione atomica in 6 contratti sequenziali verificabili.
- **Cancello 5 (Determinismo Headless)**: Test seams a 0 ms nei test runner; nessun ritardo simulato o `OS.delay()`.
- **Cancello 6 (Budget Token & Anti-Bloat)**: Codice essenziale, DRY, nessun commento ridondante o testo prolisso.

---

## 🔬 5. SPECIFICA TECNICA DEI NAMED CONTRACTS

### Contratto D0 — Modello Dati `SongData` & Reset Giornaliero
- **File coinvolto**: `data/models/song_data.gd`
- **Modifiche**:
  - Nuove variabili membro:
    ```gdscript
    var daily_music_sessions: int = 0
    var daily_lyrics_sessions: int = 0
    ```
  - Metodi helper:
    ```gdscript
    func can_work_music_today() -> bool:
        return daily_music_sessions < 2

    func can_work_lyrics_today() -> bool:
        return daily_lyrics_sessions < 2

    func reset_daily_sessions() -> void:
        daily_music_sessions = 0
        daily_lyrics_sessions = 0
    ```
  - Aggiornamento di `to_dict()`:
    ```gdscript
    "daily_music_sessions": daily_music_sessions,
    "daily_lyrics_sessions": daily_lyrics_sessions,
    ```
  - Aggiornamento di `from_dict()`:
    ```gdscript
    daily_music_sessions = int(dict.get("daily_music_sessions", 0))
    daily_lyrics_sessions = int(dict.get("daily_lyrics_sessions", 0))
    ```

---

### Contratto D1 — Ricalibrazione Formule & Logica a 2 Sessioni in `MusicSystem`
- **File coinvolto**: `systems/music_system.gd`
- **Modifiche a `work_on_music_progress`**:
  ```gdscript
  func work_on_music_progress(song_id: String, hours: float = 1.0) -> Dictionary:
      var song: SongData = player_data.get_song_by_id(song_id) if player_data else null
      if not song:
          return {"success": false, "reason": "song_not_found"}

      if not song.can_work_music_today():
          return {
              "success": false,
              "reason": "daily_limit_reached",
              "message": "Hai dato il massimo sulla musica di questo brano per oggi! Lascia decantare le idee fino a domani o dedicati ad un altro cantiere."
          }

      if not player_data or not player_data.consume_energy(15):
          return {"success": false, "reason": "energy_insufficient"}

      var in_burnout: bool = player_data.is_in_creative_burnout()
      var is_second_session: bool = (song.daily_music_sessions == 1)
      var rendement_mult: float = 0.50 if is_second_session else 1.0

      var stress_gain: int = (12 if in_burnout else 6) if is_second_session else (8 if in_burnout else 4)
      player_data.add_stress(stress_gain)

      var base_gain: float = 8.0
      var skill_harmony: float = float(player_data.get_skill_level("comp_theory"))
      var musicality: float = float(player_data.musicality)
      var gain: float = (base_gain + (skill_harmony * 0.20) + (musicality * 0.10)) * hours * rendement_mult
      if in_burnout:
          gain *= 0.70

      song.music_progress = clampf(song.music_progress + gain, 0.0, 100.0)
      song.comp_skill_used = maxf(song.comp_skill_used, skill_harmony)
      song.daily_music_sessions += 1

      if player_data:
          player_data.add_xp_to_skill("comp_theory", 15.0 if not is_second_session else 8.0)
          player_data.add_xp_to_skill("comp_riffs", 10.0 if not is_second_session else 5.0)

      # Avanzamento tempo virtuale di 2.0 ore se time_system è attivo
      if time_system:
          time_system.advance_virtual_hours(2.0)

      var ready_now: bool = (song.music_progress >= 100.0 and song.lyrics_progress >= 100.0 and song.polishing_status == 0)
      if ready_now:
          song.polishing_status = 1 # ORANGE
          song.polishing_hours_remaining = 36.0
          AccessibilityManager.announce("Ispirazione al vertice! Entrambe le componenti sono al 100%: %s entra nella Finestra di Rifinitura Arancione (36 ore)!" % song.title, true)

      return {
          "success": true,
          "song": song,
          "music_progress": song.music_progress,
          "gain": gain,
          "is_second_session": is_second_session,
          "polishing_status": song.polishing_status,
          "polishing_hours_remaining": song.polishing_hours_remaining
      }
  ```
- **Modifiche analoghe a `work_on_lyrics_progress`**:
  - Controllo `song.can_work_lyrics_today()`;
  - Se seconda sessione: `rendement_mult = 0.50`, stress maggiorato (5 standard, 9 burnout);
  - Guadagno base `8.0`, abilità `comp_lyrics * 0.20`, intelligenza `* 0.10`, affinità tematica;
  - Incremento `song.daily_lyrics_sessions += 1`;
  - Avanzamento tempo virtuale di 1.5 ore (`advance_virtual_hours(1.5)`).

---

### Contratto D2 — Metodo `advance_virtual_hours` in `TimeSystem`
- **File coinvolto**: `systems/time_system.gd`
- **Aggiunta metodo pubblico**:
  ```gdscript
  ## Avanza il tempo virtuale di un numero specificato di ore virtuali (es. 1.5, 2.0).
  ## Opera anche se il gioco è in pausa/modale, sincronizzando orologio e fasce orarie.
  func advance_virtual_hours(hours: float) -> void:
      if calendar_data.remaining_seconds <= 0.0:
          return
      var seconds_to_deduct: float = calendar_data.day_duration * (hours / Constants.VIRTUAL_HOURS_PER_DAY)
      calendar_data.remaining_seconds = maxf(0.0, calendar_data.remaining_seconds - seconds_to_deduct)
      calendar_data.update_period()
      _check_overtime_and_notifications()
      EventBus.time_ticked.emit(
          calendar_data.remaining_seconds,
          calendar_data.get_formatted_time_string(),
          calendar_data.current_period
      )
      if calendar_data.remaining_seconds <= 0.0:
          EventBus.day_ended.emit(calendar_data.day_number)
  ```

---

### Contratto D3 — Reset Notturno Sessioni & Allineamento Loft
- **File coinvolti**:
  - `systems/end_day_system.gd`: In `process_day_end`, nel ciclo `for s in player_data.songs:`, invocare `s.reset_daily_sessions()`;
  - `data/models/player_data.gd`: Aggiungere helper `reset_all_song_daily_sessions()` per azzeramento deterministico;
  - `scenes/apartment/apartment_interactions.gd`:
    - In `guitar_compose_crafting`: verificare che la bozza selezionata abbia `can_work_music_today()`. Se satura, visualizzare/annunciare il motivo senza avviare `ActionSystem`;
    - In `couch_write_lyrics_crafting`: verificare che la bozza selezionata abbia `can_work_lyrics_today()`. Se satura, avvisare l'utente a costo zero.

---

### Contratto D4 — Interfaccia `SongCreator` (Scheda 1) & Ergonomia NVDA
- **File coinvolto**: `ui/music/song_creator.gd`
- **Modifiche**:
  - In `_refresh_drafts_list()`:
    - Etichetta pulsante bozza:
      `"%s — [Musica: %.0f%% (%d/2)] [Testo: %.0f%% (%d/2)] %s"`
    - Vocalizzazione:
      *"Selezionato: %s. Musica al %.0f%% (%s), Testo al %.0f%% (%s)."* specificando lo stato di resa (Libera, Resa 50%, Satura per oggi);
  - In `_on_btn_draft_music_pressed()`:
    - Se l'esito è `daily_limit_reached`: annuncio immediato del messaggio di saturazione;
    - Se l'esito ha successo: annuncio dell'avanzamento, indicando se era la prima sessione piena o la seconda a resa ridotta;
  - Stessa gestione ergonomica per `_on_btn_draft_lyrics_pressed()`.

---

### Contratto D5 — Suite di Test Headless Dedicata & Living Documentation
- **File coinvolti**:
  - `tests/test_advanced_songwriting_system.gd`
  - `docs/todo.md`
  - `CHANGELOG.md`
- **Verifiche di Test**:
  - Sessione 1: resa al 100%, 15 energia, 4 stress, `daily_music_sessions == 1`;
  - Sessione 2: resa al 50%, 15 energia, 6 stress, `daily_music_sessions == 2`;
  - Sessione 3: rifiuto con reason `"daily_limit_reached"`, 0 energia, 0 stress, `daily_music_sessions == 2`;
  - Reset notturno: invocando `s.reset_daily_sessions()`, i contatori tornano a 0 e consentono nuove sessioni;
  - Avanzamento orario: verifica che `calendar_data.remaining_seconds` scali regolarmente con `advance_virtual_hours`;
  - Verifica complessiva con `tools/check.ps1` (119 file GDScript senza errori);
  - Verifica complessiva con `tools/test.ps1` (33/33 suite headless superate con 0 errori a 0 ms);
  - Aggiornamento della roadmap in `docs/todo.md` e registrazione nel `CHANGELOG.md` con avanzamento AVF a `V5.10.0`.

---

## ✅ 6. ESITO CONVALIDA & STATO DI CHIUSURA (SOTTO-FASE 1B & FASE 2)
 
Tutti i contratti D0..D5 sono stati implementati e convalidati con successo:
- Sintassi convalidata su tutti i 119 file GDScript con 0 errori (`tools/check.ps1`);
- Suite di test completata al 100% con 33/33 suite headless superate a 0 errori e 0 ms (`tools/test.ps1`);
- I limiti di 2 sessioni giornaliere per cantiere, i rendimenti decrescenti al 50%, il blocco a costo zero e l'avanzamento dell'orologio virtuale sono pienamente operativi ed ergonomici per NVDA;
- Versione AVF avanzata a `V5.10.0`.
