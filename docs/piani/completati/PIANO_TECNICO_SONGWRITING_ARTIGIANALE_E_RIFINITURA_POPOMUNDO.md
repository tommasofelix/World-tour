# World-tour — Piano Tecnico Formale: Songwriting Artigianale, Doppia Barra, Punti Ispirazione & Finestra di Rifinitura Popomundo (Sotto-Fase 1A)
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Versione Target: AVF V5.9.0 — Songwriting Artigianale, Punti Ispirazione & Finestra di Rifinitura Popomundo
# Data: 26 Settembre 2026
# Percorso File: docs/piani/completati/PIANO_TECNICO_SONGWRITING_ARTIGIANALE_E_RIFINITURA_POPOMUNDO.md
# Baseline AVF: V5.8.1 (32/32 Suite Headless Superate a 0 Errori e 0 ms)
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Contratti D0..D5 e 5 rifiniture sistemiche validate al 100% con 33/33 suite headless verdi a 0 ms — AVF V5.9.0)

---

## 🎯 1. OBIETTIVO ARCHITETTURALE E VISIONE GENERALE

Questo piano tecnico formalizza la profonda riprogettazione del **Sistema di Canzoni e Composizione (Songwriting System)** in **World-tour**, superando il modello istantaneo "click e attendi" e implementando i principi cardine del **Pilastro 5 ("Il Processo Artigianale di Creazione del Brano")** e del **Pilastro 1 ("Ciclo Vitale del Repertorio & Padronanza Live")** definiti in `STRATEGIA_INTEGRALE_EVOLUZIONE_GAMEPLAY_POPOMUNDO.md`.

### I 5 Cardini del Nuovo Sistema:
1. **La Doppia Barra di Avanzamento (Musica 0-100% & Testo 0-100%)**:
   - La canzone nasce come progetto aperto (massimo 3 cantieri contemporanei);
   - Il musicista lavora alla parte musicale (accordi, riff, melodia) con lo strumento nel loft, influenzato da `skill_harmony`, `skill_riffs` e dall'attributo innato `Musicalità`;
   - Il musicista lavora al testo (liriche, rime, metrica) al tavolino o sul divano con gli appunti, influenzato da `skill_lyrics`, `skill_ballads`, dall'attributo innato `Intelligenza` e dall'affinità tema-genere.
2. **I Punti Ispirazione (The Muse Currency)**:
   - Riserva di punti (da 0 a 5, estendibile a 10) che il musicista accumula vivendo (ascolto vinili rari al giradischi, concerti di altre band nei locali, passeggiate al parco, sonno ristoratore);
   - I Punti Ispirazione si investono per innalzare il potenziale della canzone e per tentare il Colpo d'Ala nella fase critica.
3. **La Mitica Finestra di Rifinitura (Arancione $\to$ Verde Brillante / Masterpiece)**:
   - Quando entrambe le barre raggiungono il 100%, il brano entra nello stato **Arancione ("In Rifinitura")** per 36 ore virtuali;
   - L'autore può consolidarlo subito come traccia standard oppure tentare il **Colpo d'Ala** spendendo Punti Ispirazione: se ha successo, il brano diventa **Verde Brillante ("Masterpiece / Hit Mondiale")** con +20 al Quality Score, probabilità quasi certa di tratti leggendari (`EARWORM`, `GENERATIONAL_ANTHEM`) e longevità aumentata sul mercato.
4. **La Sindrome del Foglio Bianco & Cooldown Creativo**:
   - Sfornare un capolavoro Verde Brillante consuma lo spirito dell'artista, attivando uno **Svuotamento Creativo di 3–5 giorni virtuali** che raddoppia lo stress ed evita il grinding compulsivo di brani in catena di montaggio.
5. **Padronanza Live (Mastery 20% $\to$ 100%) & Sinergia Strumentale**:
   - Il brano registrato entra nel repertorio con il 20% di padronanza scenica e va provato in sala prove prima dei concerti;
   - Se possiede uno **Strumento Dominante** (le 8 discipline del Ramo 2) e il musicista della band che lo suona ha maestria stellare, conferisce bonus straordinari al `Concert Score`;
   - Se non viene suonato per oltre 21 giorni, comincia ad arrugginire (Decay del 5% a settimana).

---

## 🏛️ 2. CHECKLIST DI CONVALIDA A 3 STATI (MATRICE PER NVDA)

- [x] [CONVALIDATO CON SUCCESSO] Contratto D0: Estensione modelli dati `SongData` e `PlayerData` (campi doppia barra `music_progress`/`lyrics_progress`, `dominant_instrument`, `archetype`, stato rifinitura arancione/verde `polishing_status`, `polishing_hours_remaining`, `inspiration_points`, `creative_burnout_days`, `mastery_live`, `last_played_day` con persistenza atomica `to_dict`/`from_dict`).
- [x] [CONVALIDATO CON SUCCESSO] Contratto D1: Motore Logico di Composizione Artigianale in `MusicSystem` (`start_song_project`, `work_on_music`, `work_on_lyrics`, `attempt_polishing_burst`, `finalize_polishing`, decadimento orario finestra arancione e formula di qualità potenziata da Masterpiece).
- [x] [CONVALIDATO CON SUCCESSO] Contratto D2: Integrazione Arredi Loft NYC (`ApartmentInteractions` & `ApartmentHud`) con azioni contestuali a durata temporale (`GAMEPLAY_BUSY`) per comporre musica alla chitarra, scrivere testi al divano/tavolino, rifinire brani arancioni e ricaricare ispirazione al giradischi (+1 ispirazione).
- [x] [CONVALIDATO CON SUCCESSO] Contratto D3: Riorganizzazione dell'Interfaccia `SongCreator` ("Studio di Scrittura") a 3 schede con barre percentuali parlanti per NVDA, gestione cantieri aperti, pulsante Colpo d'Ala e registrazione Home Studio vs Pro Studio.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D4: Integrazione Padronanza Live (Song Mastery 20% $\to$ 100%), Sinergia Strumento Dominante e Decay a 21 giorni in `ConcertSystem` e `BandSystem`.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D5: Nuova suite di test headless `tests/test_advanced_songwriting_system.gd` a 0 ms (doppia barra, finestra arancione, colpo d'ala verde brillante, svuotamento creativo, padronanza live), verifica 33/33 suite verdi e avanzamento AVF a `V5.9.0`.

---

## ⚖️ 3. I 7 ASSI DI QUALITÀ ASTRALIS APPLICATI

- **Asse 1 — Validità**: Rispetto rigoroso dei tipi GDScript 2.0 statici, coerenza dei contratti di dizionario `to_dict()` e `from_dict()` con valori di fallback sicuri per vecchi salvataggi.
- **Asse 2 — Efficacia**: Eliminazione radicale del modello banale "click e produci", sostituito da un processo decisionale ed emotivo stratificato e gratificante.
- **Asse 3 — Coerenza**: Perfetta continuità con le 31 competenze dell'Albero delle Abilità (Ramo 2 Strumenti e Ramo 3 Composizione), gli attributi fisiologici innati e la Clean Architecture del gioco.
- **Asse 4 — Completezza**: Copertura integrale di tutti i casi d'uso (avvio cantiere, sessioni parziali, abbandono bozza, scadenza finestra arancione senza colpo d'ala, successo del verde brillante, usura repertorio).
- **Asse 5 — Precisione**: Integrazione chirurgica senza rottura dei metodi storici di `MusicSystem` utilizzati dai test preesistenti (retrocompatibilità garantita).
- **Asse 6 — Affidabilità & Prestazioni**: Esecuzione deterministica a 0 ms nei test seams headless; zero loop di attesa o delay fisici bloccanti.
- **Asse 7 — Assenza Regressioni**: Mantenimento al 100% verde di tutte le 32 suite di test storiche del progetto.

---

## 🔬 4. I 3 LIVELLI DI SIMULAZIONE PREVENTIVA

- **Livello 1 — Happy Path (Creazione Artigianale Completa di un Capolavoro)**:
  - Il giocatore ha 2 Punti Ispirazione; apre il cantiere per una nuova canzone Rock intitolata *"Neon Skyline"* con la Chitarra come strumento dominante e tema *"Ribellione Giovanile"*;
  - Nel Loft, Alex fa una sessione di chitarra (avanzamento musica sale da 0% a 35%); fa una seconda sessione (sale a 70%);
  - Sul divano con gli appunti scrive il testo (sale a 50%, poi a 100%);
  - Torna alla chitarra e completa la musica al 100%;
  - Il brano entra istantaneamente nello **Stato Arancione (Finestra di Rifinitura)** con 36 ore virtuali; NVDA suona una fanfara e annuncia l'opportunità;
  - Il giocatore spende 2 Punti Ispirazione per tentare il **Colpo d'Ala**: il tiro ha successo, il brano diventa **Verde Brillante ("Masterpiece")**;
  - Alex registra il pezzo in Home Studio con bobine a nastro analogico: il brano esce con un Quality Score di 88.5 e il tratto leggendario `EPIC_RIFF`;
  - Alex entra in **Svuotamento Creativo per 4 giorni**; il brano entra nel repertorio al 20% di padronanza live pronto per la sala prove.
- **Livello 2 — Percorsi Alternativi & Concorrenti (Chiusura Standard o Scadenza Finestra)**:
  - L'autore non ha Punti Ispirazione a sufficienza o preferisce risparmiarli: quando il brano entra in stato Arancione, seleziona "Consolida Subito";
  - Il pezzo si chiude con qualità standard (es. 55.0), senza svuotamento creativo per l'autore;
  - *Alternativa*: L'autore si distrae o parte per un tour: passano le 36 ore virtuali senza interventi; al controllo orario il brano si consolida automaticamente come standard, impedendo blocchi logici o cantieri congelati all'infinito.
- **Livello 3 — Corner Cases & Limiti Estremi (Sindrome del Foglio Bianco & Cap Cantieri)**:
  - L'autore tenta di avviare un quarto progetto mentre ha già 3 cantieri aperti: il sistema rifiuta con messaggio chiaro *"Hai già 3 progetti aperti nel cassetto. Completa o archivia una bozza prima di iniziarne un'altra."*;
  - L'autore tenta di comporre durante i 4 giorni di svuotamento creativo post-capolavoro: il sistema avvisa con chiarezza *"Sei in pieno blocco creativo da svuotamento. Consumo di stress raddoppiato e qualità penalizzata. Vuoi forzare comunque la mano?"*;
  - La band suona dal vivo una canzone appena finita (20% padronanza): il pezzo causa sbavature durante l'esecuzione; provarla in sala prove per 2 sessioni porta la padronanza al 70%, trasformandola in una colonna dello show.

---

## 🛡️ 5. SPECIFICA DEI NAMED CONTRACTS (D0..D5)

---

### CONTRATTO D0: Estensione Modelli Dati `SongData` e `PlayerData`

#### Modifiche a `data/models/song_data.gd`:
- Aggiunta campi:
  ```gdscript
  var music_progress: float = 0.0 # 0.0 - 100.0
  var lyrics_progress: float = 0.0 # 0.0 - 100.0
  var dominant_instrument: String = "guitar" # discipline Ramo 2
  var archetype: String = "standard" # anthem, ballad, riff, standard, experimental
  var complexity: int = 1 # 0: semplice, 1: standard, 2: virtuosa
  var polishing_status: int = 0 # 0: in_progress, 1: orange, 2: green_masterpiece, 3: standard
  var polishing_hours_remaining: float = 0.0
  var inspiration_invested: int = 0
  var mastery_live: float = 20.0 # 20.0 - 100.0
  var last_played_day: int = 0
  ```
- Metodi helper:
  - `is_ready_for_polishing() -> bool`: restituisce true se `music_progress >= 100.0 and lyrics_progress >= 100.0 and polishing_status == 0`;
  - `is_masterpiece() -> bool`: restituisce `polishing_status == 2`;
  - Aggiornamento di `to_dict()` e `from_dict()` con persistenza e valori di default per retrocompatibilità.

#### Modifiche a `data/models/player_data.gd`:
- Aggiunta campi:
  ```gdscript
  var inspiration_points: int = 2
  var max_inspiration_points: int = 5
  var creative_burnout_days: int = 0
  ```
- Metodi helper:
  - `add_inspiration(amount: int) -> void`: incrementa clampando a `max_inspiration_points`;
  - `consume_inspiration(amount: int) -> bool`: verifica e detrae i punti ispirazione;
  - `is_in_creative_burnout() -> bool`: restituisce `creative_burnout_days > 0`;
  - `get_active_draft_songs() -> Array[SongData]`: filtra le canzoni con `status == Enums.SongStatus.DRAFT`;
  - Aggiornamento di `to_dict()` e `from_dict()`.

---

### CONTRATTO D1: Motore di Composizione Artigianale in `MusicSystem`

#### Nuovi Metodi in `systems/music_system.gd`:
1. `start_crafting_project(title: String, genre: int, theme: String, dominant_inst: String, archetype: String, initial_inspiration: int = 0) -> Dictionary`:
   - Verifica cap di 3 cantieri aperti;
   - Se in `creative_burnout_days`, applica warning ma consente la forzatura con malus;
   - Crea `SongData` con `music_progress = 0.0`, `lyrics_progress = 0.0`, assegna `dominant_instrument` e `archetype`;
   - Se `initial_inspiration > 0`, consuma l'ispirazione da `PlayerData` e imposta `inspiration_invested`.
2. `work_on_music_progress(song_id: String, hours: float = 1.0) -> Dictionary`:
   - Consuma 15 energia, +4 stress (raddoppiato se in burnout creativo);
   - Calcola guadagno percentuale:
     $$\Delta \text{Musica} = (15.0 + \text{skill\_harmony} \times 0.25 + \text{musicality} \times 0.15) \times \text{hours}$$
   - Se raggiunge il 100% e anche il testo è al 100%, attiva `polishing_status = 1` (`POLISHING_ORANGE`) con 36 ore virtuali;
   - Assegna XP al ramo armonia/composizione.
3. `work_on_lyrics_progress(song_id: String, hours: float = 1.0) -> Dictionary`:
   - Consuma 10 energia, +3 stress;
   - Calcola guadagno percentuale:
     $$\Delta \text{Testo} = (15.0 + \text{skill\_lyrics} \times 0.25 + \text{intelligence} \times 0.15 + \text{affinity}) \times \text{hours}$$
   - Se raggiunge il 100% e anche la musica è al 100%, attiva lo stato arancione;
   - Assegna XP al ramo scrittura testi.
4. `attempt_polishing_burst(song_id: String, inspiration_spent: int) -> Dictionary`:
   - Richiede stato arancione attivo e sufficienza di punti ispirazione;
   - Probabilità di successo base 25% + (25% per ogni ispirazione oltre la prima) + bonus `Musicalità` / 200;
   - In caso di successo: `polishing_status = 2` (`POLISHED_GREEN`), +20.0 bonus qualità, `creative_burnout_days = 4`, annuncio vocale trionfale;
   - In caso di fallimento: +5.0 bonus qualità, traccia standard, zero burnout;
   - Chiude la fase di scrittura portando il brano a pronto per la registrazione (`Enums.SongStage.RECORDING`).
5. `finalize_polishing_standard(song_id: String) -> Dictionary`:
   - Chiude il brano senza spendere ispirazioni (`polishing_status = 3`), pronto per la registrazione.
6. `process_hourly_polishing_decay(delta_virtual_hours: float) -> void`:
   - Decrementa `polishing_hours_remaining` per tutti i brani arancioni; se scadono a `<= 0.0`, consolida automaticamente come standard.

---

### CONTRATTO D2: Integrazione Arredi Loft NYC (`ApartmentInteractions` & `ApartmentHud`)

#### Modifiche in `scenes/apartment/apartment_interactions.gd`:
- Alla **Chitarra** (`PropGuitar`):
  - Aggiunta opzione dinamica *"Componi Musica per [Canzone Attiva]"* (durata 6s, FSM `GAMEPLAY_BUSY`, invoca `work_on_music_progress`);
- Al **Divano** (`PropCouch`):
  - Aggiunta opzione dinamica *"Scrivi Testo per [Canzone Attiva]"* (durata 5s, FSM `GAMEPLAY_BUSY`, invoca `work_on_lyrics_progress`);
  - Se un brano è in stato arancione: opzione *"Rifinisci nel cassetto: [Canzone]"*;
- Al **Giradischi** (`PropTurntable`):
  - L'azione di ascolto vinile aggiunge sempre **+1 Punto Ispirazione** (se sotto il massimo consentito);
- Al **Letto** (`PropBed`):
  - Il risveglio all'alba dopo sonno anticipato offre il 50% di chance di donare un'Ispirazione Notturna spontanea.

---

### CONTRATTO D3: Riorganizzazione Schermata `SongCreator` ("Studio di Scrittura")

#### Modifiche a `ui/music/song_creator.tscn` e `song_creator.gd`:
- Struttura a 3 schede con tasti rapidi `1`, `2`, `3`:
  1. **Scheda 1 — Cantieri Aperti**: Elenco compatto delle 1..3 canzoni in lavorazione con indicatori sonori e testuali percentuali per NVDA (`[Musica: 60%] [Testo: 80%]`); tasti diretti `M` per musica, `T` per testo, `R` per rifinitura;
  2. **Scheda 2 — Nuovo Progetto**: Form pulito con titolo, genere, tema, selettore dello strumento dominante (8 discipline), archetipo e ispirazione iniziale;
  3. **Scheda 3 — Incisione & Master**: Registrazione Home Studio vs Studio Pro per brani al 100% con selezione nastro analogico/digitale;
- Conformità WCAG AAA ad alto contrasto e Zero Mouse per NVDA.

---

### CONTRATTO D4: Padronanza Live, Sinergia Strumentale & Decay in `ConcertSystem`

#### Modifiche a `systems/concert_system.gd` e `systems/band_system.gd`:
- Nel calcolo del `ConcertScore`:
  - Ogni brano in scaletta pesa per la sua `mastery_live` (da 0.20 a 1.00);
  - **Sinergia Strumento Dominante**: se la canzone ha come strumento dominante es. il Basso e il bassista della band ha maestria >= 3 stelle, bonus del +15% all'Engagement del pubblico per quel pezzo;
- Al termine del concerto: la `mastery_live` dei brani eseguiti cresce di +15% (fino al 100%) e `last_played_day` viene aggiornato al giorno corrente;
- In `EndDaySystem`: se un brano non viene suonato per oltre 21 giorni, perde il 5% di padronanza a settimana fino al 50%.

---

### CONTRATTO D5: Suite Headless Dedicata & Chiusura AVF `V5.9.0`

#### Nuova Suite `tests/test_advanced_songwriting_system.gd` (con wrapper `.tscn`):
- 5 sezioni di test deterministiche a 0 ms:
  1. *Test 1*: Apertura cantiere e avanzamento doppia barra (Musica e Testo) con consumi e XP corretti;
  2. *Test 2*: Attivazione stato arancione al 100% su entrambi i rami con timer 36 ore e scadenza automatica;
  3. *Test 3*: Tentativo Colpo d'Ala con Punti Ispirazione, trasformazione in Verde Brillante (+20 qualità, tratti leggendari) e attivazione svuotamento creativo per l'autore;
  4. *Test 4*: Padronanza Live (20% $\to$ 100%), sinergia strumento dominante nei concerti e arrugginimento a 21 giorni;
  5. *Test 5*: Serializzazione atomica e save/load completo di tutti i nuovi campi e riserva ispirazione.
- Verifica regressioni con `tools/check.ps1` (118+ file con 0 errori) e `tools/test.ps1` (**33/33 suite superate a 0 ms**).
- Avanzamento della versione AVF a `V5.9.0`.

---

## 🛑 STOP OBBLIGATORIO (GATING REGOLA 0)

In conformità rigorosa con la **Regola 0 (Default Consultivo Permanente)** e il **Framework ASTRALIS v3.0.7**, la stesura del presente piano conclude la **Sotto-Fase 1A**.

Nessuna modifica al codice sorgente né creazione di nuovi file di test verrà intrapresa senza l'esplicito comando di Luca (*"procedi"*, *"applica"*, *"esegui"*).
