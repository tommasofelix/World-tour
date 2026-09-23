# Piano Tecnico Operativo — Sezione 2: Creatività Musicale, Scrittura Brani & Produzione Discografica
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-23
# Stato: [/] [IMPLEMENTATO — SOTTO-FASE 1B COMPLETATA — SUITE HEADLESS 23/23 VERDE (100%) — IN ATTESA DI COLLAUDO MANUALE NVDA FASE 2]
# File Piano: docs/piani/attivi/PIANO_SEZIONE_2_CREATIVITA_MUSICALE_E_PRODUZIONE.md
# File di Riferimento: docs/roadmap/02_creativita_musicale_scrittura_e_produzione.md & docs/report/REPORT_AVVIO_SESSIONE_SEZIONE_2.md
# Coordinatore Master: docs/todo.md

---

## 🎯 1. OBIETTIVO E PERIMETRO DELLA SEZIONE 2

La **Sezione 2 della Roadmap Modulare** realizza l'evoluzione e il perfezionamento completo del **Loop Discografico e del Ciclo Creativo** di *World-tour*.
L'obiettivo è trasformare la composizione, la produzione e la pubblicazione musicale da semplice procedura meccanica in un'esperienza artistico-strategica ricca di scelte concrete, sfumature qualitative ed impatto permanente sulla carriera musicale del protagonista.

### Macro-Aree di Intervento:
1. **Pipeline Creativa a 5 Stadi & Espansione Tematiche Liriche**:
   - Consolidamento dei 6 generi musicali (`Rock`, `Pop`, `Metal`, `Hip Hop`, `Elettronica`, `Indie`) e dei 5 stadi di lavorazione (`Concept`, `Composizione`, `Scrittura Testo`, `Registrazione`, `Missaggio/Mastering`).
   - Introduzione del modello dati per le **Tematiche Liriche** (`LyricThemeData`), ampliando i temi da 5 a 9:
     * Temi storici: *Amore* (`love`), *Ribellione* (`rebellion`), *Malinconia* (`melancholy`), *Successo* (`success`), *Notte* (`night`).
     * Nuovi temi: *Rabbia Sociale* (`social_anger`), *Amore Maledetto* (`cursed_love`), *Nostalgia Giovanile* (`youth_nostalgia`), *Fuga dalla Realtà* (`escapism`), *Satira Politica* (`political_satire`).
   - **Matrice di Affinità Tematica-Genere**: calcolo deterministico del bonus sinergico (fino a +4.0 punti) quando la tematica risuona con lo stile del brano (es. Metal + Rabbia Sociale, Pop + Amore, Hip Hop + Satira Politica/Successo, Indie + Nostalgia Giovanile/Fuga dalla Realtà).
   - **Risonanza Territoriale**: predisposizione dell'impatto tematico sulle 6 città continentali (`CityId`).

2. **Algoritmo Quality Score & Tratti Canzone Speciali**:
   - Mantenimento e potenziamento della formula ponderata in `core/formulas.gd`:
     * Composizione: 25%
     * Scrittura Testo: 20%
     * Esecuzione Strumento: 25%
     * Produzione Sonora: 20%
     * Bonus Sinergia Tematica/Genere e Ispirazione
     * Variazione casuale controllata $\pm 4.0$ punti, clamp rigoroso [1.0, 100.0].
   - **Principio Inviolabile**: `QUALITY != COMMERCIAL SUCCESS` (la qualità tecnica fornisce la base critica, ma streaming, vendite e fan dipendono da promozione, tratti, fanbase e reputazione).
   - **Ampliamento dei Tratti Speciali Canzone (`Enums.SongTrait`)** da 5 a 8:
     * Tratti storici: `EARWORM` (+25% streaming Day 1-30), `CULT_CLASSIC` (converte x2 fan ai concerti), `STAGE_BEAST` (+15% Concert Score come pezzo di chiusura), `AUDIOPHILE_GEM` (recensioni eccellenti, req. Produzione $\ge 70$), `ROUGH_DIAMOND` (eccellente composizione con registrazione low-fi).
     * Nuovi tratti:
       - `GENERATIONAL_ANTHEM` (Inno Generazionale): +30% engagement nei live e boost permanente sulla reputazione.
       - `TEARJERKER_BALLAD` (Ballata Strappalacrime): +20% morale del pubblico e connessione emotiva nei concerti.
       - `EPIC_RIFF` (Riff Epico): +20% appeal per gli amanti del rock/metal e memorabilità scenica.

3. **Studio di Registrazione: Casalingo vs Professionale & Hardware**:
   - Integrazione completa con la progressione hardware `UpgradeData.StudioHardwareTier`:
     * Tier 0: Microfono Integrato Base (Cap 60, Bonus 0)
     * Tier 1: Microfono a Condensatore USB (400 €, Cap 75, Bonus +5)
     * Tier 2: Preamplificatore Valvolare (1.200 €, Cap 90, Bonus +10)
     * Tier 3: Banco Analogico & Mastering Suite (3.500 €, Cap 100, Bonus +15)
   - Studio Professionale a Noleggio: costo base 50.0 €, resa garantita al 100% (Cap 100, Bonus +15).
   - **Sconto del Martedì**: verifica su `CalendarData.get_weekday() == Enums.Weekday.TUESDAY`, applicando il 20% di sconto (`Constants.TUESDAY_STUDIO_DISCOUNT`, costo 40.0 € anziché 50.0 €) con vocalizzazione esplicita per NVDA.

4. **Formati Discografici (Singolo, EP, LP) & Gestione Catalogo**:
   - Singolo: rilascio rapido per primi riscontri, incremento fan e popolarità.
   - EP: 3-5 brani, costo 80.0 €, tasso royalty 35%.
   - LP / Album Completo: 6-10 brani, costo 200.0 €, tasso royalty 60%.
   - Selezione Lead Single con bonus qualità complessiva, 3 Concept artistici (`CONCEPTUAL`, `COMMERCIAL_HIT`, `RAW_UNDERGROUND`) e 4 Artwork.
   - Rielaborazione bozze (`refining`): possibilità di riaprire bozze non completate (`DRAFT`) per registrare nuovamente le tracce con migliore strumentazione o maggiori abilità.
   - Decadimento fisiologico nel tempo compensato da reputazione e royalties passive di fine giornata.

5. **Accessibilità Assoluta & Zero Mouse per NVDA**:
   - Navigazione tastiera completa, hook semantici AccessKit per tutti i campi, volumi audio congelati tra 0.7f e 0.8f.

---

## 🏛️ 2. CONTRATTI OPERATIVI NOMINATI (D0 – D4)

### Contratto D0: Data Models, Enums, Constants & Localizzazione (Clean Sweep)
- **File da modificare**:
  - `core/enums.gd`:
    * Espansione enum `SongTrait` con i 3 nuovi tratti:
      - `GENERATIONAL_ANTHEM = 6` (Inno Generazionale)
      - `TEARJERKER_BALLAD = 7` (Ballata Strappalacrime)
      - `EPIC_RIFF = 8` (Riff Epico)
  - `core/constants.gd`:
    * Aggiunta costanti di sinergia tematica e nuovi tratti:
      - `SONG_THEME_SYNERGY_HIGH: float = 3.5`
      - `SONG_THEME_SYNERGY_NEUTRAL: float = 0.0`
      - `SONG_THEME_SYNERGY_LOW: float = -1.5`
      - `TRAIT_ANTHEM_REP_BOOST: float = 2.0`
      - `TRAIT_BALLAD_MORALE_BOOST: float = 15.0`
      - `TRAIT_RIFF_LIVE_BONUS: float = 12.0`
  - `data/models/song_data.gd`:
    * Supporto per i nuovi tratti in `get_trait_name()`, `to_dict()` e `from_dict()`.
    * Aggiunta metodo helper `get_theme_name()` con stringa localizzata.
  - `localization/it.json` & `localization/en.json`:
    * Stringhe per i nuovi tratti:
      - `TRAIT_GENERATIONAL_ANTHEM`: "Inno Generazionale"
      - `TRAIT_TEARJERKER_BALLAD`: "Ballata Strappalacrime"
      - `TRAIT_EPIC_RIFF`: "Riff Epico"
    * Stringhe per le nuove tematiche liriche:
      - `THEME_SOCIAL_ANGER`: "Rabbia Sociale"
      - `THEME_CURSED_LOVE`: "Amore Maledetto"
      - `THEME_YOUTH_NOSTALGIA`: "Nostalgia Giovanile"
      - `THEME_ESCAPISM`: "Fuga dalla Realtà"
      - `THEME_POLITICAL_SATIRE`: "Satira Politica"
    * Descrizioni estese per AccessKit e screen reader.
- **File da creare**:
  - `data/models/lyric_theme_data.gd`:
    * Classe pura `LyricThemeData` che definisce i 9 temi lirici con ID, chiave di traduzione nome, descrizione, array di generi preferiti con cui genera sinergia positiva e città di risonanza.

### Contratto D1: Motore Logico MusicSystem, Formulas & AlbumSystem
- **File da modificare**:
  - `core/formulas.gd`:
    * Implementazione metodo statico `calculate_theme_genre_affinity(theme: String, genre: int) -> float`: restituisce il bonus/malus di sinergia artistica.
    * Aggiornamento del calcolo di qualità del brano `calculate_song_quality` integrando opzionalmente il bonus di affinità tematica (`theme_affinity: float = 0.0`).
  - `systems/music_system.gd`:
    * In `record_tracks(song: SongData, use_pro_studio: bool = false)`:
      - Integrazione deterministica dello sconto del Martedì: se `use_pro_studio == true`, verifica `calendar_data.get_weekday() == Enums.Weekday.TUESDAY`.
      - Calcolo costo dinamico: 40.0 € di martedì (`-20%`), 50.0 € negli altri giorni.
      - Annuncio vocale AccessKit dedicato quando lo sconto martedì viene applicato.
    * In `mix_and_master(song: SongData)`:
      - Passaggio del bonus di affinità tematica alla formula di qualità.
      - Aggiornamento di `_roll_special_trait(song)` per includere probabilistica e requisiti dei 3 nuovi tratti (`GENERATIONAL_ANTHEM`, `TEARJERKER_BALLAD`, `EPIC_RIFF`).
    * In `work_on_composition`, `work_on_lyrics`, `record_tracks`:
      - Rafforzamento del supporto alla rielaborazione di bozze esistenti (`DRAFT`) consentendo il ripasso da stadi intermedi se il giocatore desidera perfezionare la traccia con nuove abilità.
  - `systems/album_system.gd`:
    * Aggiornamento del calcolo metriche album in `calculate_album_metrics()`:
      - Integrazione dei nuovi tratti speciali delle canzoni incluse per influenzare le recensioni critiche (stelle) e le vendite iniziali.

### Contratto D2: Interfacce SongCreator, SongCatalog & AlbumCreator Evoluti
- **File da modificare**:
  - `ui/music/song_creator.gd`:
    * Espansione del selettore `OptTheme` per includere tutti i 9 temi lirici.
    * Aggiornamento automatico della descrizione semantica per NVDA con indicazione dell'affinità con il genere attualmente selezionato ("Genere Rock con Tema Rabbia Sociale: Alta Sinergia Artistica").
    * Aggiornamento dinamico dell'opzione Studio Professionale: mostra il prezzo reale calcolato in base al giorno del calendario ("Studio Professionale (40 € - Sconto Martedì 20% applicato)" vs "Studio Professionale (50 €)").
    * Hook semantici AccessKit completi per navigazione Zero Mouse.
  - `ui/music/song_catalog.gd`:
    * Visualizzazione e vocalizzazione NVDA arricchita per ogni riga: include tema lirico, tratto speciale, stato e qualità.
    * Tasti rapidi interni: `A` (Filtra Album/EP), `S` (Filtra Singoli/Brani), `N` (Nuovo Brano), `P` (Nuovo Album), `Esc` (Chiudi).
  - `ui/album/album_creator.gd`:
    * Allineamento vocalizzazioni e selezione tracce con evidenza dei nuovi tratti speciali.

### Contratto D3: Integrazione Macro-Area 2 nell'HUD & Workflow Tastiera
- **File da verificare / allineare**:
  - `ui/hud/hud.gd` e `ui/hud/hud.tscn`:
    * Conferma della perfetta coesistenza dei tasti rapidi della Macro-Area 2: `N` (Nuovo Brano / Studio), `M` (Catalogo Brani), `P` (Produzione Album).
    * Chiusura atomica con `_hide_all_modals()` e isolamento modale con `_is_any_modal_open()` per prevenire focus leaks.
    * Garanzia di volumi sonori frozen a 0.75f lineare (massimo -2.5 dB) con ducking automatico durante il parlato.

### Contratto D4: Nuova Suite di Test Headless a 0 ms & Zero Regressioni
- **File da creare**:
  - `tests/test_advanced_crafting_system.gd`
  - `tests/test_advanced_crafting_system.tscn`
- **Casi di test specifici (8 macro-blocchi)**:
  1. *Test Modello SongData & Nuovi Tratti*: serializzazione `to_dict` / `from_dict`, persistenza dei nuovi tratti (`GENERATIONAL_ANTHEM`, `TEARJERKER_BALLAD`, `EPIC_RIFF`) e temi lirici.
  2. *Test Modello LyricThemeData & Affinità*: verifica dei 9 temi e calcolo deterministico del bonus sinergico con ciascun genere musicale.
  3. *Test Sconto Martedì Studio Professionale*: verifica costo 40.0 € con `day_number` corrispondente a Martedì (`get_weekday() == 1`) e costo 50.0 € negli altri giorni; verifica blocco fondi insufficienti.
  4. *Test Cap Hardware Home Studio*: verifica tetti massimi (60, 75, 90, 100) e bonus produzione in base al tier hardware acquistato.
  5. *Test Estrazione Probabilistica Tratti*: roll dei tratti speciali con condizioni abilitanti (es. Audiophile Gem con produzione $\ge 70$, Epic Riff con composizione/chitarra elevata).
  6. *Test Perfezionamento Bozze & Resuming*: avanzamento passo-passo, salvataggio intermedio, ridenominazione e ripresa lavorazione.
  7. *Test Album con Canzoni Speciali*: inclusione di tracce con nuovi tratti in un EP/LP e verifica impatto su recensioni della critica (stelle) e vendite iniziali.
  8. *Test UI & Accessibilità Zero Mouse*: istanziazione scene `song_creator` e `song_catalog`, verifica hook AccessKit e scorciatoie da tastiera.
- **Suite di Regressione**:
  - Esecuzione di verifica su tutte le 20 suite esistenti del progetto per certificare 0 errori e zero regressioni.

---

## ⚖️ 3. PIANO DI VALIDAZIONE A 7 ASSI

1. **Asse 1 — Validità**: Rispetto rigoroso dei tipi GDScript 2.0, Clean Architecture e classi pure prive di dipendenze cicliche.
2. **Asse 2 — Efficacia**: Fornisce un ciclo creativo profondo e articolato, trasformando la scrittura dei brani in una decisione artistica e tattica con conseguenze tangibili.
3. **Asse 3 — Coerenza**: Piena armonia con `PlayerData`, `CalendarData`, `UpgradeData`, `AlbumSystem`, `Formulas` e la FSM di `GameManager`.
4. **Asse 4 — Completezza**: Copertura di tutti i flussi di gioco (home studio limitato, studio pro a prezzo pieno, sconto martedì, energia esaurita, bozze sospese e completate).
5. **Asse 5 — Precisione**: Modifiche chirurgiche e backward-compatible senza riscritture distruttive o campi orfani (Contratto D0 Clean Sweep).
6. **Asse 6 — Affidabilità & Prestazioni**: Esecuzione deterministica a 0 ms senza timer asincroni o `OS.delay()`; volumi audio congelati al livello di sicurezza 0.75f.
7. **Asse 7 — Assenza Regressioni**: Salvaguardia delle 20 suite esistenti e dei 266 test headless già convalidati.

---

## 🔬 4. I 3 LIVELLI DI SIMULAZIONE

- **Livello 1 — Happy Path (Flusso Lineare Ottimale)**:
  * Il giocatore apre lo Studio con `N`, sceglie Genere "Rock" e Tema affine "Rabbia Sociale" (+3.5 sinergia).
  * Avanza attraverso Composizione e Testo accumulando XP.
  * Decide di registrare di Martedì in Studio Professionale, beneficiando dello sconto del 20% (spesa 40 €).
  * Esegue Missaggio e Mastering ottenendo un Quality Score elevato e sbloccando il tratto `GENERATIONAL_ANTHEM`.
  * Rilascia il singolo con `M` $\rightarrow$ `BtnRelease`, verificando l'accredito di fan, reputazione e introiti.

- **Livello 2 — Flussi Alternativi e Concorrenti**:
  * Il giocatore possiede solo il Microfono Base (Tier 0, Cap 60). Registra a casa e la resa esecutiva viene limitata a 60 nonostante un'abilità strumentale pari a 80.
  * Salva la canzone come bozza (`DRAFT`).
  * Successivamente acquista il Preamplificatore Valvolare (Cap 90, +10 bonus). Riapre la bozza e ripete la registrazione, innalzando la resa a 90.
  * Tentativo di prenotare lo Studio Pro di Giovedì con 45 € a disposizione: rifiuto immediato per fondi insufficienti (costo 50 €).
  * Attesa del Martedì successivo con le stesse 45 €: prenotazione approvata con successo (costo 40 €).

- **Livello 3 — Corner Cases & Stress Testing**:
  * Tentativo di pubblicare una canzone ancora in stato `DRAFT` o fermata allo stadio `CONCEPT`: blocco deterministico con messaggio d'errore.
  * Canzone con punteggi estremi: verifica che il Quality Score rimanga rigorosamente compreso tra 1.0 e 100.0 anche con bonus massimi o malus cumulati.
  * Creazione album con brani duplicati o brani in stato `DRAFT`: blocco della validazione in `validate_album_composition()`.
  * Deserializzazione JSON da salvataggi precedenti privi dei nuovi tratti: fallback automatico a `Enums.SongTrait.NONE` senza crash né anomalie di tipo.

---

## 🛑 5. STOP OBBLIGATORIO DELLA SOTTO-FASE 1A

In conformità rigorosa alla **Regola 0 (Default Consultivo Permanente)** e alla governance ASTRALIS v3.0.7:
- La stesura del presente Piano Tecnico Operativo conclude la **Sotto-Fase 1A**.
- **Nessuna riga di codice sorgente, scena o configurazione verrà modificata** prima che Luca abbia esaminato il piano e impartito l'esplicito comando di procedere (*"procedi"*, *"applica"*, *"esegui"*).
