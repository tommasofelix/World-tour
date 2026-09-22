# Piano Tecnico Operativo — Fase 3: Vertical Slice V1.1 (Il Ciclo Creativo)

- ID Piano: `P-F3`
- Autori del progetto: Luca & Holy Diver
- Assistente: Antigravity (Senior AI Pair Programmer & Software Engineer)
- Data: 2026-09-22
- Stato: Completato e Convalidato con successo (Verificato empiricamente con 109 test e collaudo reale in-game da parte di Luca e Tom)
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md) (Attività F3.1 $\rightarrow$ F3.5 completate)
- Documenti di riferimento:
  - [`docs/piani/attivi/sottopiani/01_game_design_visione_e_progressione.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/01_game_design_visione_e_progressione.md)
  - [`docs/piani/attivi/sottopiani/03_sistema_musicale_abilita_e_creazione_brani.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/03_sistema_musicale_abilita_e_creazione_brani.md)
  - [`docs/piani/attivi/sottopiani/06_formule_matematiche_e_bilanciamento.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/06_formule_matematiche_e_bilanciamento.md)
  - [`docs/piani/attivi/sottopiani/07_architettura_software_sistemi_e_modello_dati.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/07_architettura_software_sistemi_e_modello_dati.md)
  - [`docs/piani/attivi/sottopiani/08_accessibilita_vocale_interfaccia_e_simmetria.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/08_accessibilita_vocale_interfaccia_e_simmetria.md)

---

## 1. OBIETTIVO DEL CICLO CREATIVO (MUSIC CRAFTING)

Lo scopo della **Fase 3** è realizzare il nucleo artistico e discografico di World-tour, trasformando il personaggio da semplice musicista che esegue esercizi in un autore completo in grado di comporre, registrare, missare e pubblicare sul mercato i propri brani musicali:

$$\text{Ideazione (Genere/Tema)} \longrightarrow \text{Composizione (Riff/Accordi)} \longrightarrow \text{Scrittura Testo} \longrightarrow \text{Registrazione} \longrightarrow \text{Missaggio \& Mastering} \longrightarrow \text{Rilascio Singolo}$$

### Criteri di Accettazione e Successo:
1. **Progressione delle 7 Abilità Artistiche**: `SkillSystem` governa le 7 competenze (Voice, Instrument, Songwriting, Composition, Charisma, Performance, Production) con curve esponenziali, assegnazione XP e annunci vocali al Level Up.
2. **Pipeline di Creazione Brano in 5 Stadi**: `MusicSystem` gestisce la creazione guidata passo-passo con salvataggio delle bozze intermedie (`DRAFT`), calcolo del `Quality Score` tramite la formula convalidata di `SP-06` e generazione dei tratti emergenti (`Song Traits`).
3. **Catalogo Discografico Persistente**: Ogni brano (`SongData`) viene serializzato nella scheda personaggio (`PlayerData.songs`), visualizzabile nel Catalogo con filtri e metadati.
4. **Meccanismo di Rilascio Singolo**: Il giocatore può pubblicare un brano masterizzato sul mercato come Singolo, incrementando reputazione, popolarità e abilitando gli ascolti.
5. **Simmetria Universale & Accessibilità**: Accesso rapido da tastiera (`M` per Catalogo, `N` per Nuovo Brano), vocalizzazione NVDA lineare e ordinata, interfaccia visiva curata per Holy Diver.

---

## 2. ARTICOLAZIONE DEI TASK OPERATIVI (D0 – D6)

### Task D0: Modelli Dati & Tratti Emergenti (`data/models/song_data.gd`)
- Creazione classe `SongData`:
  - Identificativo univoco, titolo, genere (`Enums.MusicalGenre`), stato del ciclo vitale (`DRAFT`, `PRODUCED`, `RELEASED`), stadio di lavorazione (1-5).
  - Punteggi componenti: `composition_score`, `lyrics_score`, `recording_score`, `production_score`, `quality_score` finale (1.0 - 100.0).
  - Tratto speciale emergente (`NONE`, `EARWORM`, `CULT_CLASSIC`, `STAGE_BEAST`, `AUDIOPHILE_GEM`, `ROUGH_DIAMOND`).
  - Metriche economiche e di mercato: `release_day`, `plays`, `revenue`.
  - Metodi `to_dict()` e `from_dict()` per la serializzazione JSON atomica.

### Task D1: Integrazione Catalogo in `PlayerData` (`data/models/player_data.gd`)
- Aggiunta della collezione brani `songs: Array[SongData] = []`.
- Metodi helper: `add_song(song)`, `get_song_by_id(id)`, `get_drafts()`, `get_produced_songs()`, `get_released_singles()`.
- Serializzazione/deserializzazione bidirezionale in `to_dict()` e `from_dict()`.

### Task D2: Motore di Progressione Abilità (`systems/skill_system.gd`)
- Gestione delle 7 abilità con livello (1-99) ed XP accumulati.
- Calcolo del fabbisogno XP per livello tramite `Formulas.calculate_xp_for_level()`.
- Rilevamento automatico Level Up con emissione `EventBus.skill_leveled_up(skill_key, new_level)` e notifica vocale AccessKit.

### Task D3: Motore di Creazione Musicale (`systems/music_system.gd`)
- Implementazione della pipeline a 5 stadi:
  - **Stadio 1 (Concetto)**: Scelta genere, tema e titolo. Creazione bozza in catalogo.
  - **Stadio 2 (Composizione)**: Consumo energia e tempo, calcolo apporto skill `Composition`, evento bonus "Ispirazione Improvvisa".
  - **Stadio 3 (Testo)**: Consumo energia e tempo, calcolo apporto skill `Songwriting` basato sul tema scelto.
  - **Stadio 4 (Registrazione)**: Scelta studio (Home Studio gratuito con cap qualità a 60 vs Studio Professionale a pagamento con bonus +15), calcolo apporto skill `Instrument` / `Voice`.
  - **Stadio 5 (Missaggio & Mastering)**: Calcolo apporto skill `Production`, invocazione di `Formulas.calculate_song_quality()`, estrazione probabilistica del tratto emergente (`Song Traits`), passaggio a stato `PRODUCED`.
- **Rilascio Singolo (`release_single(song_id)`)**:
  - Validazione: brano in stato `PRODUCED`.
  - Transizione a `RELEASED`, registrazione `release_day`.
  - Assegnazione bonus reputazione (+1.5) e popolarità (+2.0).
  - Emissione `EventBus.song_released(song_data)`.

### Task D4: Estensione Dizionari di Localizzazione (`localization/it.json` & `en.json`)
- Aggiunta di tutte le stringhe necessarie:
  - Nomi e descrizioni dei 6 generi musicali (`GENRE_ROCK`, `GENRE_POP`, `GENRE_METAL`, `GENRE_HIPHOP`, `GENRE_ELECTRONIC`, `GENRE_LATIN`).
  - Nomi e descrizioni delle 7 abilità.
  - Nomi dei 5 temi lirici (`THEME_LOVE`, `THEME_REBELLION`, `THEME_MELANCHOLY`, `THEME_SUCCESS`, `THEME_NIGHT`).
  - Nomi e spiegazioni dei 5 tratti emergenti (`TRAIT_EARWORM`, `TRAIT_CULT_CLASSIC`, `TRAIT_STAGE_BEAST`, `TRAIT_AUDIOPHILE_GEM`, `TRAIT_ROUGH_DIAMOND`).
  - Stringhe dell'interfaccia catalogo, del wizard di creazione e dei messaggi vocali.

### Task D5: Interfacce Utente Simmetriche (`ui/music/`)
- **Catalogo Brani (`ui/music/song_catalog.tscn` / `song_catalog.gd`)**:
  - Accessibile tramite scorciatoia `M` o pulsante nell'HUD.
  - Elenco brani con filtri (Tutti, Bozze, Prodotti, Singoli Rilasciati).
  - Navigazione a tastiera circolare per Luca con lettura sintetica NVDA (Titolo, Genere, Qualità, Tratto, Stato).
  - Pulsante contestuale "Rilascia come Singolo" per i brani prodotti.
  - Grafica elegante a schede con badge colorati per Holy Diver.
- **Creazione Brano Guidata (`ui/music/song_creator.tscn` / `song_creator.gd`)**:
  - Accessibile con scorciatoia `N` o pulsante nel Catalogo.
  - Wizard step-by-step con riepilogo costi di energia, tempi e bonus studio.

### Task D6: Integrazione nell'HUD e Navigazione Globale
- In `ui/hud/hud.tscn`: aggiunti pulsanti "Catalogo Brani (M)" e "Nuova Canzone (N)".
- In `autoload/accessibility_manager.gd`: registrazione delle scorciatoie globali `M` ed `N`.
- In `project.godot`: istanziazione di `SkillSystem` e `MusicSystem` gestiti da `GameManager`.

---

## 3. PIANO DI VERIFICA E SUITE DI TEST AUTOMATIZZATI

### A. Test Unitari Headless (`tests/test_music_system.gd` & `.tscn`)
1. **Verifica Modello `SongData`**: serializzazione, stati, tratti e calcolo valori.
2. **Verifica `SkillSystem`**: progressione XP, level up al raggiungimento della soglia esponenziale, invarianti di livello max 99.
3. **Verifica Pipeline in 5 Stadi**: avanzamento bozza, consumo risorse corretto, calcolo del `Quality Score` con le formule convalidate.
4. **Verifica Tratti Emergenti**: assegnazione corretta e condizioni speciali (es. Audiophile Gem con produzione $\ge 70$).
5. **Verifica Rilascio Singolo**: cambio stato a `RELEASED`, aggiornamento statistiche del giocatore, blocco di rilasci duplicati.
6. **Verifica Persistenza Catalogo**: salvataggio e ripristino completo dei brani da `PlayerData` / `SaveManager`.

### B. Verifica Sintattica e Regressioni
- Esecuzione `tools/check.ps1`: 0 errori di compilazione su tutti i file GDScript.
- Esecuzione `tools/test.ps1`: 100% superamento di tutte le suite (`test_formulas`, `test_vertical_slice`, `test_localization`, `test_music_system`).
