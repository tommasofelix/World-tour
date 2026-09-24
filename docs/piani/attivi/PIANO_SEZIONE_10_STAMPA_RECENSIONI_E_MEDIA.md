# Piano Tecnico Operativo — Sezione 10: Artisti Rivali, Hit Parade & Media Broadcaster
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.10 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-24
# Stato: [x] [CONVALIDATO CON SUCCESSO]
# File Piano: docs/piani/attivi/PIANO_SEZIONE_10_STAMPA_RECENSIONI_E_MEDIA.md
# File di Riferimento: docs/roadmap/10_artisti_rivali_e_classifiche_musicali.md
# Coordinatore Master: docs/todo.md
# Baseline AVF: V4.9.0 (Versione Consolidata: V4.10.0)

---

## 🎯 1. OBIETTIVO E PERIMETRO DELLA SEZIONE 10

La **Sezione 10 della Roadmap Modulare** governa l'approfondimento del pilastro competitivo e mediatico di *World-tour*: **"Artisti Rivali, Hit Parade, Classifiche Musicali & Media Broadcaster (Radio, TV & Stampa Specializzata)"**.
In piena coerenza con la visione dell'autore Luca (sviluppatore non vedente, Zero Mouse), la competizione musicale e la critica non si riducono a meri numeri statici, ma diventano un **ecosistema dinamico a reazione sistemica**:
- **Le 10 Band Rivali Continentali** acquisiscono profondità psicologica, relazioni interpersonali dirette (rispetto, collaborazione, rivalità accesa o faida velenosa) e la possibilità di concordare **Tour Congiunti Co-Headlining** per sommare fanbase e condividere spese e palchi;
- **La Hit Parade Settimanale** si espande oltre la Top 10 Continentale, introducendo **Classifiche Territoriali/Nazionali** (Hit Parade Italia, Regno Unito, Germania, Francia, Spagna, USA, Giappone) e l'evento stagionale del **Tormentone Estivo / Canzone di Natale**;
- **Media Broadcaster & Critica Musicale Specializzata**: integrazione organica di **Radio Regionali, Emittenti Musicali TV, Podcast tematici e Stampa Musicale**, con interviste promozionali mattutine nei giorni di concerto per innalzare l'Hype, rassegna stampa con recensioni qualitative e conferenze stampa / interviste di riparazione dopo crisi mediatiche;
- **Dinamiche di Faida & Dissing**: pubblicazione di post provocatori o brani dissing su BandFeed per scuotere le classifiche e attirare attenzione mediatica, con rischio di controversia e reazione della band rivale.

---

## 🏛️ 2. CHECKLIST A TRE STATI PER NVDA (SOTTO-FASE 1A / 1B / FASE 2)

- [x] [CONVALIDATO CON SUCCESSO] **Sotto-Fase 1A (Pianificazione & Stop)**:
  - [x] Analisi preliminare della scheda roadmap [`docs/roadmap/10_artisti_rivali_e_classifiche_musicali.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/roadmap/10_artisti_rivali_e_classifiche_musicali.md) e della test suite baseline (24 suite su 24 verdi al 100%).
  - [x] Scomposizione architetturale nei Named Contracts D0..D6.
  - [x] Validazione preventiva sui 7 Assi di Qualità e sui 3 Livelli di Simulazione.
  - [x] Formalizzazione del piano in `docs/piani/attivi/PIANO_SEZIONE_10_STAMPA_RECENSIONI_E_MEDIA.md`.
  - [x] **STOP OBBLIGATORIO DI SOTTO-FASE 1A**: Attesa approvazione esplicita di Luca prima di scrivere codice.

- [x] [CONVALIDATO CON SUCCESSO] **Sotto-Fase 1B (Esecuzione Tecnica & Test Headless)**:
  - [x] Contratto D0: Clean sweep preventivo, estensione di `Enums` (`RivalRelationship`, `ChartScope`, `BroadcastMediaType`) e costanti di bilanciamento in `Constants`.
  - [x] Contratto D1: Espansione del Modello Dati dei Rivali (`RivalData`) con affinità relazionale, note storiche, disponibilità a tour congiunti e risposte a dissing.
  - [x] Contratto D2: Espansione di `ChartSystem` e `ChartEntryData` con supporto a Hit Parade Nazionali/Territoriali e meccanica del Tormentone Stagionale.
  - [x] Contratto D3: Sottosistema Media Broadcaster & Stampa (`MediaSystem`) per interviste radio/podcast/TV, rassegna stampa periodica e interviste di riparazione.
  - [x] Contratto D4: Integrazione Meccanica Co-Headlining Tour con Rivali e Faide/Dissing su BandFeed.
  - [x] Contratto D5: Espansione UI Accessibile `ChartModal` (tasto `H`) a 4 schede (`1` Top 10 Continentale, `2` Hit Parade Territoriali, `3` Artisti Rivali & Relazioni, `4` Media, Radio & Rassegna Stampa) al 100% NVDA Zero Mouse.
  - [x] Contratto D6: Nuova test suite headless dedicata (`tests/test_media_and_rivals_system.gd`, 50 asserzioni superate) e verifica di regressione su tutte le 25 suite con 0 errori e 0 ms.

- [x] [CONVALIDATO CON SUCCESSO] **Fase 2 (Deploy Provvisorio & Collaudo Manuale NVDA)**:
  - [x] Collaudo pratico a tastiera con NVDA su navigazione schede (`1`..`4`), lettura annunci vocali classifiche, consultazione rivali e interviste media.
  - [x] Verifica volumi sonori ed effetti conformi ai limiti di sicurezza (0.7f - 0.8f).

- [x] [CONVALIDATO CON SUCCESSO] **Fase 3 (Chiusura Tecnica, Git & Release AVF `V4.10.0`)**:
  - [x] Aggiornamento coordinatore master `docs/todo.md` e changelog.
  - [x] Commit atomico Conventional Commits: `feat(charts-media): implement rivals depth, territorial charts and media broadcast system`.
  - [x] Formulazione obbligatoria della Domanda Ponte per la Fase 4 (Auto-Apprendimento a Doppio Binario).

---

## 🧩 3. NAMED CONTRACTS (D0..D6)

### Contratto D0: Clean Sweep, Allineamento Tipi & Costanti Centralizzate
- **Obiettivo**: Bonifica preventiva, estensione dei tipi enumerati e delle costanti senza introdurre debito tecnico né duplicazioni.
- **Estensioni in `core/enums.gd`**:
  ```gdscript
  enum RivalRelationship {
      RESPECTFUL = 0,     # Rispetto reciproco e stima professionale
      NEUTRAL = 1,        # Distacco formale / Concorrenza ordinaria
      HEATED_RIVAL = 2,   # Competizione accesa e punzecchiature
      OPEN_FEUD = 3       # Faida aperta, dissing e scontro mediatico
  }

  enum ChartScope {
      CONTINENTAL = 0,    # Hit Parade Europea / Continentale
      NATIONAL = 1        # Hit Parade specifica per Nazione/Territorio
  }

  enum BroadcastMediaType {
      LOCAL_RADIO = 0,    # Radio locale della metropoli (Hype moderato, basso costo energia)
      MUSIC_TELEVISION = 1,# Emittente musicale TV (Grande impatto visivo/fama, req. Tier >= 4)
      CULTURE_PODCAST = 2, # Podcast tematico e intervista lunga (Reputazione e fedeltà fan)
      SPECIALIZED_PRESS = 3# Rassegna stampa / Rivista musicale di settore (Critica e rispetto)
  }
  ```
- **Estensioni in `core/constants.gd`**:
  ```gdscript
  # --- Media, Broadcaster & Interviste (Sezione 10) ---
  const MEDIA_INTERVIEW_RADIO_ENERGY: int = 15
  const MEDIA_INTERVIEW_RADIO_HYPE: float = 12.0
  const MEDIA_INTERVIEW_TV_ENERGY: int = 25
  const MEDIA_INTERVIEW_TV_HYPE: float = 25.0
  const MEDIA_INTERVIEW_TV_MIN_TIER: int = 4
  const MEDIA_INTERVIEW_PODCAST_ENERGY: int = 20
  const MEDIA_INTERVIEW_PODCAST_REP: float = 2.0
  const MEDIA_CO_HEADLINING_FAN_BONUS: float = 1.35
  const MEDIA_CO_HEADLINING_EXPENSE_DISCOUNT: float = 0.30
  const MEDIA_DISSING_BUZZ_MULT: float = 1.60
  ```

### Contratto D1: Espansione Modello Rivali (`RivalData`) & Relazioni Umane
- **File**: [`data/models/rival_data.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/data/models/rival_data.gd) e [`systems/rival_system.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/systems/rival_system.gd).
- **Nuove proprietà**:
  - `var relationship: int = Enums.RivalRelationship.NEUTRAL` (sostituisce ed espande `rivalry_level` con retrocompatibilità).
  - `var affinity_score: float = 50.0` (0.0 - 100.0, definisce la propensione ad accettare collaborazioni).
  - `var co_headlining_eligible: bool = false` (true se affinity >= 70.0 e rispetto reciproco).
  - `var last_dissing_day: int = 0` (traccia le frecciate subite o lanciate).
- **Nuovi metodi di logica**:
  - `interact_with_rival(rival_id: String, interaction_type: int) -> Dictionary`: gestisce complimenti pubblici, proposte di collaborazione, o frecciate mediatiche.
  - `respond_to_dissing(rival_id: String, player_track_score: float) -> Dictionary`: determina la contro-reazione del rivale su BandFeed.

### Contratto D2: Hit Parade Territoriali & Tormentone Stagionale
- **File**: [`data/models/chart_entry_data.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/data/models/chart_entry_data.gd) e [`systems/chart_system.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/systems/chart_system.gd).
- **Caratteristiche**:
  - Classifiche Territoriali: oltre alla Top 10 Continentale, compilazione di classifiche mirate per nazione/metropoli (Italia, Regno Unito, Germania, Francia, Spagna, USA, Giappone) in base alla penetrazione territoriale (`city_fans` e affinità di genere).
  - Meccanica Tormentone Estivo / Canzone delle Feste: nei mesi estivi (Mesi 4-6) e invernali (Mese 12), i singoli con tratto `EARWORM` o `GENERATIONAL_ANTHEM` ottengono un moltiplicatore stagionale extra di ascolti radio/stream (+35%).
  - Deserializzazione e backward compatibility perfetta con savegame esistenti.

### Contratto D3: Sottosistema Media Broadcaster & Critica Specialistica (`MediaSystem`)
- **Nuovo File**: `systems/media_system.gd`.
- **Modello Dati**: `data/models/media_outlet_data.gd`.
- **Meccaniche**:
  - Catalogo di emittenti e testate giornalistiche accreditate per città (es. *Radio Popolare Milano*, *BBC Radio 1 Londra*, *Rock Hard Mag*, *KEXP Podcast*).
  - **Interviste del Mattino**: durante il giorno di un concerto (o tour), Alex può spendere tempo/energia per partecipare a un'intervista radiofonica o televisiva prima dello show, incrementando l'Hype della serata e la popolarità cittadina.
  - **Rassegna Stampa & Recensioni**: aggregazione delle recensioni dei dischi e dei live da parte di critici musicali con commenti narrativi generati proceduralmente (entusiasta, purista severo, snob underground).
  - **Interviste di Riparazione**: in caso di crisi reputazionale o shitstorm, possibilità di convocare una conferenza stampa o partecipare a un'intervista chiarificatrice per arginare le perdite di fan.

### Contratto D4: Integrazione Co-Headlining Tour & Faide su BandFeed
- **File**: [`systems/tour_system.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/systems/tour_system.gd) e [`systems/social_media_system.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/systems/social_media_system.gd).
- **Co-Headlining Tour**:
  - Possibilità di invitare una band rivale amica (`co_headlining_eligible == true`) come co-headliner per una tournée:
    * Riduzione spese vive logistiche del -30% (condivisione furgone/service).
    * Boost affluenza del +35% grazie alla somma delle fanbase.
    * Condivisione dei riflettori ed eventi narrativi di backstage tra le due formazioni.
- **Faidhe & Dissing**:
  - Azione su BandFeed: lanciare una provocazione diretta verso un rivale. Aumenta il `social_buzz` istantaneo (+60%), polarizza il pubblico e può innescare una risposta in rima o un dissing-track che fa salire entrambi nelle classifiche di streaming.

### Contratto D5: Espansione Dashboard Accessibile `ChartModal` (Tasto `H`)
- **File**: [`ui/charts/chart_modal.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/ui/charts/chart_modal.gd) e `ui/charts/chart_modal.tscn`.
- **Architettura a 4 Schede Navigabili con tasti `1`, `2`, `3`, `4`**:
  - `1`: **Top 10 Continentale** (Singoli / Album, con toggle `S`/`A`).
  - `2`: **Hit Parade Territoriale** (Selettore Paese/Città con numeri o frecce, vocalizzazione chiara per NVDA).
  - `3`: **Artisti Rivali & Relazioni** (Schede rivali, stato rapporto, opzione Tour Congiunto con `T`, Dissing con `D`).
  - `4`: **Media, Radio & Stampa** (Rassegna stampa, interviste prenotabili, cronologia recensioni).
- **Accessibilità NVDA Zero Mouse**:
  - Annunci vocali lineari al 100%, zero tabelle 2D, lettura sequenziale riga per riga di posizioni, movimenti e dichiarazioni dei critici.
  - Tasti rapidi protetti: `1`..`4` per schede, `S`/`A` toggle singolo/album, `Esc`/`H` chiusura.

### Contratto D6: Suite di Test Headless Globale (25 Suite Totali)
- **Nuovo File Test**: `tests/test_media_and_rivals_system.gd`.
- **Copertura obbligatoria a 0 ms**:
  - Inizializzazione modelli `MediaOutletData`, `RivalData` esteso, `ChartEntryData`.
  - Simulazione classifiche continentali vs territoriali e determinismo dei rank.
  - Meccanica interviste mattutine (consumo energia, bonus Hype su live).
  - Co-headlining tour e calcolo sconti/fanbase aggregata.
  - Dissing su social e impatto su buzz/rivalità.
  - Test di compatibilità savegame (serializzazione e deserializzazione atomica).
  - Verifica della test suite complessiva del progetto: 25 suite su 25 superate con 0 errori.

---

## ⚖️ 4. VALIDAZIONE PREVENTIVA SUI 7 ASSI DI QUALITÀ

1. **Asse 1 — Validità**: Rispetto rigoroso dei tipi in GDScript 2.0, gestione sicura dei riferimenti null e assenza di warning statici.
2. **Asse 2 — Efficacia**: Risolve direttamente la richiesta dell'autore, integrando la stampa e i media nell'ecosistema competitivo già avviato in F8.5 senza duplicazioni né codice orfano.
3. **Asse 3 — Coerenza**: Perfetta continuità con la Clean Architecture DDD del progetto (EventBus a segnali, modelli dati in `data/models/`, logica in `systems/`, UI disaccoppiata in `ui/`).
4. **Asse 4 — Completezza**: Copre la relazione con i rivali, le classifiche multinazionali, le interviste, la rassegna critica e il salvataggio atomico su disco.
5. **Asse 5 — Precisione**: Modifiche mirate ed estensioni additive ai contratti esistenti (`ChartSystem`, `RivalSystem`, `SaveManager`) senza riscritture distruttive.
6. **Asse 6 — Affidabilità & Prestazioni**: Esecuzione deterministica headless a 0 ms, zero ritardi artificiali (`OS.delay()` vietato), consumo memoria minimo e garbage collection sicura.
7. **Asse 7 — Assenza Regressioni**: Salvaguardia totale delle 24 suite preesistenti convalidate al 100%.

---

## 🧪 5. TEST SU 3 LIVELLI DI SIMULAZIONE

- **Livello 1 (Happy Path)**:
  - Il giocatore pubblica un singolo con alto Quality Score; nella simulazione domenicale entra in Top 10 Continentale e #1 nella Hit Parade Italia.
  - Prenota un'intervista a *Radio Popolare*, ottiene +12.0 Hype e la sera registra il tutto esaurito nel locale cittadino.
- **Livello 2 (Alternativi / Concorrenti)**:
  - Il giocatore propone un Tour Congiunto a *The Chrome Shadows* (Milano): se l'affinità è >= 70, la proposta viene accettata con sconto -30% sui costi e affluenza maggiorata; se l'affinità è bassa, la band rifiuta con dichiarazione pungente.
- **Livello 3 (Corner Cases & Stress Test)**:
  - Tentativo di intervista con energia a 0 (blocco per Burnout con avviso vocale appropriato).
  - Tentativo di intervista TV senza possedere il career tier richiesto (rifiuto educato dell'emittente).
  - Salto di settimane consecutive e verifica della tenuta storica dei picchi di classifica senza memory leak o sovrapposizioni.

---

## 🛑 STOP OBBLIGATORIO DI SOTTO-FASE 1A
Come imposto dalla Regola 0 e da ASTRALIS v3.0.10, il Piano Tecnico Operativo è stato formalizzato.
**Nessuna riga di codice sorgente o configurazione verrà modificata o creata fino alla tua esplicita conferma.**
