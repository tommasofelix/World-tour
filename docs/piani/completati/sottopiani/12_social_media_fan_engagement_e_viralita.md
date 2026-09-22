# Sottopiano 12 — Social Media, Fan Engagement & Viralità (SocialMediaSystem)

- ID Sottopiano: `SP-12`
- Stato: `[x] Archiviato` — Completato e Convalidato al 100% con 17 test suite headless (0 errori)
- Versione: 1.0 — Canali Social della Band, Tipologie di Contenuto, Viralità Procedurale e Gestione Polemiche
- Autore: Luca & Antigravity (Pair Programming Senior)
- Tema: Canali social della band ("BandFeed" / "SoundTok"), pubblicazione di clip di prove, teaser di brani, retroscena del tour e post provocatori. Algoritmo di visualizzazioni, follower, like e commenti procedurali, hype virale a supporto delle uscite musicali e risoluzione delle polemiche online (shitstorm).
- Competenze di riferimento: Core Systems Architecture, Simulation Design, Social Media Dynamics, Accessibilità NVDA
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md)
- Hub di contesto: [`GEMINI.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/GEMINI.md)

---

## 1. VISIONE & OBIETTIVO ARCHITETTURALE

Nel panorama musicale contemporaneo, l'attività sui canali social non è un semplice accessorio, ma il motore primario del passaparola quotidiano tra un concerto e l'altro.
Il modulo **`SocialMediaSystem`** introduce:

1. **Engagement Quotidiano tra le Date Live**: Dare al giocatore un'attività rapida e strategica per interagire con il pubblico anche nei giorni senza concerti (es. Lunedì o Martedì di riposo).
2. **I 4 Formati di Pubblicazione (`Enums.SocialPostType`)**:
   - **Clip delle Prove (`PRACTICE_CLIP`)**: Mostra l'impegno tecnico e musicale. Basso costo in energia (10), zero rischi polemiche, fedeltà del pubblico consolidata.
   - **Teaser di un Brano (`TRACK_TEASER`)**: Collega una canzone bozza o prodotta dal catalogo. Genera "Song Buzz" che amplifica vendite, streaming e affluenza al rilascio.
   - **Vita da Band & Dietro le Quinte (`BEHIND_THE_SCENES`)**: Mostra la vita reale, i viaggi in furgone e il backstage. Aumenta affinità e morale, ma se la tensione della band è critica (> 70) rischia di esporre dissapori interni.
   - **Post Provocatorio / Dissing / Meme (`PROVOCATION`)**: Alto rischio, alta viralità. Può raddoppiare o triplicare i fan e le visualizzazioni in un giorno, ma con il rischio di scatenare una *shitstorm* online con danni di reputazione e stress.
3. **Metriche Social & Crescita Dinamica**:
   - **Follower**: Base fedele che cresce con il successo dei post e dei concerti.
   - **Visualizzazioni (Views)**: Scalate su follower, popolarità del musicista e tasso di viralità.
   - **Reazioni & Commenti Sintetici**: Generazione procedurale di reazioni positive, entusiaste o critiche per feedback narrativo immediato.
4. **Meccanica delle Polemiche Online (*Online Controversies*)**:
   - Se un post provocatorio fallisce o genera indignazione, la band affronta un bivio rapido di pubbliche relazioni:
     - *Ignora*: Perdita minima di follower, ma nessun compromesso artistico.
     - *Scusati pubblicamente*: Recupera la reputazione generale, ma delude i fan underground più ribelli.
     - *Raddoppia la provocazione*: Massima polarizzazione (o consacrazione di culto o attacco dei media tradizionali).

---

## 2. MODELLO DATI SOCIAL (`SocialPostData` & Metriche Canale)

File dedicato in `data/models/social_post_data.gd`:
- `id: String`: Identificativo univoco del post.
- `post_type: int`: `Enums.SocialPostType` (0 = Prove, 1 = Teaser, 2 = Backstage, 3 = Provocazione).
- `day_published: int`: Giorno del calendario di pubblicazione.
- `caption: String`: Testo / didascalia del post.
- `song_id: String`: Brano associato (opzionale, per teaser).
- `views: int`: Visualizzazioni raggiunte.
- `likes: int`: Like ricevuti.
- `shares: int`: Condivisioni virali.
- `new_followers: int`: Nuovi follower conquistati.
- `is_viral: bool`: Se il post ha superato la soglia di viralità.
- `is_controversial: bool`: Se il post ha innescato una polemica online.
- `comments_sample: Array[String]`: Campione di 2-3 commenti procedurali del pubblico.
- Serializzazione completa con `to_dict()` e `from_dict()`.

---

## 3. MOTORE DI SIMULAZIONE SOCIAL (`SocialMediaSystem`)

File dedicato in `systems/social_media_system.gd`:
- **Tracciamento Metriche**:
  - `total_followers: int`: Numero totale di follower del canale della band.
  - `weekly_buzz: float`: Indice di Hype social [1.0 - 2.5] che funge da moltiplicatore temporaneo per concerti e uscite discografiche.
  - `active_controversy: Dictionary`: Dettagli dell'eventuale polemica in corso.
  - `post_history: Array[SocialPostData]`: Registro degli ultimi post pubblicati.
- **Creazione & Pubblicazione (`publish_post(post_type, song_id = "", custom_caption = "")`)**:
  - Verifica risorse: consumo energia (10 - 20) e tempo giornaliero.
  - Calcolo visualizzazioni base: `base_views = (total_followers * 0.4) + (player.popularity * 150)`.
  - Calcolo probabilità viralità basata su carisma, genere e personalità della band (`WILD_PARTY` dà +25% viralità su backstage/meme).
  - Generazione like, condivisioni e nuovi follower (riversati anche in `PlayerData.fans`).
  - Generazione commenti testuali lineari procedurali.
  - Generazione eventuale controversia se post di tipo `PROVOCATION` (30% probabilità base).
- **Risoluzione Controversia (`resolve_controversy(choice_index)`)**:
  - 0 = Ignora: -2% follower, 0 reputazione, +5 stress.
  - 1 = Scusati: +3.0 reputazione, -5% fan underground, azzera polemica.
  - 2 = Raddoppia: 50% trionfo virale (+20% follower, +5 reputazione) / 50% disastro (-10 reputazione, +20 stress).
- **Decadimento Giornaliero del Buzz (`process_daily_decay()`)**:
  - Il buzz social diminuisce fisiologicamente del 10% a notte se non vengono pubblicati nuovi contenuti.

---

## 4. ACCESSIBILITÀ NVDA & INTERFACCIA TASTIERA

File dedicati in `ui/social/`:
- **Scorciatoia HUD**: Tasto rapido `Y` ("YouFeed / Social Media").
- **Tasti Rapidi da Tastiera**:
  - `1`: Pubblica Clip Prove (`PRACTICE_CLIP`)
  - `2`: Pubblica Teaser Brano (`TRACK_TEASER`)
  - `3`: Pubblica Vita da Band / Backstage (`BEHIND_THE_SCENES`)
  - `4`: Pubblica Post Provocatorio / Meme (`PROVOCATION`)
  - `R`: Risolvi Polemica attiva (se presente)
  - `Esc`: Chiudi finestra e torna all'HUD
- **Vocalizzazione Lineare per NVDA**:
  - Sintesi esaustiva riga per riga dello stato social, visualizzazioni, like e commenti senza tabelle ASCII complesse.
