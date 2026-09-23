# Piano Tecnico Operativo — Sezione 8: Social Media, Fan Engagement & Viralità (BandFeed)
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-24
# Stato: [x] [CONVALIDATO CON SUCCESSO — CHIUSURA SOTTO-FASE 1B & FASE 2]
# File Piano: docs/piani/completati/PIANO_SEZIONE_8_SOCIAL_MEDIA_E_FAN_ENGAGEMENT.md
# File di Riferimento: docs/roadmap/08_social_media_fan_engagement_e_viralita.md
# Coordinatore Master: docs/todo.md
# Baseline AVF: V4.7.0 (Target Release: V4.8.0)

---

## 🎯 1. OBIETTIVO E PERIMETRO DELLA SEZIONE 8

La **Sezione 8 della Roadmap Modulare** governa l'espansione e il completamento del pilastro **Social Media, Fan Engagement & Viralità (BandFeed)** di *World-tour*.
L'attività digitale della band non è un semplice mini-gioco o una vetrina estetica per accumulare bonus generici: rappresenta una vera **estensione della vita pubblica dell'artista**, una leva strategica per trasformare **l'attenzione digitale in fan fisici nelle 12 metropoli mondiali**, creare hype per le uscite discografiche e i concerti, gestire il rischio di scandali e shitstorm con l'intervento attivo del Manager, orchestrare dirette streaming con i fan e fondare il **Fan Club Ufficiale della Band**.

Il sistema si articola in 5 macro-aree di approfondimento:

1. **Piattaforma Social BandFeed, 4 Tipologie di Post & Espansione Dirette Live Streaming (`SocialMediaSystem`, `SocialModal`, `Enums.SocialPostType`)**:
   - Consolidamento delle 4 tipologie di contenuto storiche:
     1. `PRACTICE_CLIP` (Clip delle Prove): 10 energia, autenticità e credibilità musicale, boost fan puristi.
     2. `TRACK_TEASER` (Teaser di un Brano): 15 energia, promozionale, anticipazione brani con Quality Score > 60, sinergia diretta con streaming e vendite.
     3. `BEHIND_THE_SCENES` (Vita da Band / Backstage): 10 energia, familiarità e affetto dei fan; potenziato da personalità della band (`WILD_PARTY` o affinità alta).
     4. `PROVOCATION` (Post Provocatorio / Meme): 15 energia, alto buzz ma 32% rischio shitstorm.
   - **Nuova Meccanica: Diretta Live Streaming con i Fan (`LIVE_STREAM`, 25 energia)**:
     * Alex e la band accendono una diretta streaming interattiva su BandFeed.
     * Generazione di 3 domande o messaggi dei fan in chat a scelta multipla da tastiera (es. curiosità sulla scaletta, gossip sui litigi interni, messaggio di un fan sfegatato).
     * Risposte con check su Carisma o Morale della band con risvolti tangibili su affetto fan, tensione interna e buzz immediato.
   - **Nuova Meccanica: Campagna Countdown Pre-Uscita Disco (`COUNTDOWN_TEASER`)**:
     * Pianificazione di teaser a scalare (-3, -2, -1 giorni) prima della release di un Singolo o Album programmato.

2. **Algoritmo di Portata, Viralità Procedurale, Sponsorizzazioni a Pagamento & Tendenze (`SocialMediaSystem`)**:
   - Algoritmo di calcolo visualizzazioni combinato:
     `base_views = (total_followers * 0.45) + (popularity * 140.0) + randi(35, 120)`
     moltiplicato per carisma e moltiplicatore tipologia.
   - **Meccanica Campagne Social Sponsorizzate (Boost a Pagamento)**:
     * Possibilità di investire un budget a scelta (Tier 1: 100 €, Tier 2: 250 €, Tier 3: 500 €) per spingere un post oltre la cerchia organica.
     * Moltiplicatore views da x2.0 a x5.0 e penetrazione extra di follower non ancora acquisiti.
   - **Algoritmo di Tendenza Settimanale Fluttuante (Weekly Trends)**:
     * Ogni Lunedì (allineato con il ciclo settimanale di `EndDaySystem`), una specifica tipologia di post riceve il bonus "Di Tendenza" (+40% views e +50% probabilità virale).
     * Segnalazione vocale chiara per NVDA all'apertura del BandFeed sul trend corrente della settimana.
   - Conversione follower in fan fisici locali legati alla città corrente (`TravelSystem`) e moltiplicatore `social_buzz` [1.0x - 2.50x] per i concerti live con decadimento fisiologico del 10% notturno.

3. **Crisi Reputazionali, Shitstorm a 3 Bivi & Intervento del Manager (`SocialMediaSystem`, `SocialModal`, `ManagerData`)**:
   - Innesco polemica online da `PROVOCATION` o eventi critici live/backstage.
   - Matrice dei 3 Bivi Storici:
     * Bivio 0 (`Ignora`): Silenzio stampa. Nessun riverbero, lieve perdita carisma (-1) e -2% follower.
     * Bivio 1 (`Scuse Formali`): Comunicato istituzionale. Recupero reputazione (+3.5), rassicura etichette e manager, ma delude i fan punk/ribelli (-4% follower, -10 morale).
     * Bivio 2 (`Double Down / Raddoppia la Posta`): Contrattacco frontale. 50% trionfo virale (+16% follower, +4 rep, buzz 2.5x), 50% disastro (-9% follower, -7 rep, +16 stress, possibile rischio revoca live).
   - **Nuovo Bivio Condizionale: Intervento del Manager ("Frena Alex!")**:
     * Se il giocatore ha un Manager attivo (`player_data.active_manager != null`), compare una quarta opzione strategica:
       `[D] Delega al Manager / Gestione Professionale Crisi`.
     * L'effetto dipende dal profilo del manager:
       - *Amico Fidato*: difende la band con calore umano, mitiga lo stress (-8 stress) e placa i fan.
       - *Professionista Indipendente*: redige una rettifica diplomatica bilanciata (+2.0 rep, zero perdite follower).
       - *Squalo dell'Industria*: trasforma la polemica in hype cinico (+10% follower, +800 € sponsorizzazioni, ma +5 tensione band).

4. **Fandom Territoriale vs Globale, Penetrazione nelle 12 Metropoli & Fan Club Ufficiale (`PlayerData`, `SocialMediaSystem`)**:
   - Tracciamento della fanbase metropoli per metropoli (Milano, Bologna, Roma, Napoli, Londra, Berlino, Dublino, Parigi, Madrid, New York, Los Angeles, Tokyo).
   - Calcolo aggregato dinamico:
     * Fandom Nazionale (somma metropoli italiane o nazione d'origine).
     * Fandom Continentale Europeo.
     * Fandom Globale Mondiale.
   - **Fondazione del Fan Club Ufficiale della Band (`FanClubData`)**:
     * Requisiti di sblocco: almeno 1.000 fan totali e status di carriera `>= LOCAL_ARTIST`.
     * Elezione del **Presidente del Fan Club** (personaggio procedurale con nome, città di residenza, affetto e personalità: es. Fedelissimo, Organizzatore di Raduni, Storico Fan della Prima Ora).
     * Livello di Fedeltà del Fan Club (Tier 1..5): incrementa la percentuale di base garantita di biglietti venduti in qualsiasi concerto live (+5% a +25% presenze minime anche a prezzi maggiorati).
     * Raduno Annuale dei Fan (Mese 6 o Mese 12): evento speciale con meet & greet, sessione autografi, introiti merch esclusivo e max boost morale band.

5. **Interazioni Bizzarre con Fan Ossessivi & Rassegna Stampa Periodica (`SocialPostData`, `SocialMediaSystem`, `EndDaySystem`)**:
   - Pacchi e lettere misteriose ricevute per posta al mattino (es. statuetta fatta a mano, plettri portafortuna, lettere chilometriche, nastri demo inviati da fan musicisti) con bivi narrativi rapidi (Conserva in furgone/casa, Ringrazia sui social, Regala).
   - Rassegna stampa periodica e monitoraggio citazioni web per recensioni album e live.

---

## 🏛️ 2. NAMED CONTRACTS (D0..D4)

### Contratto D0: Clean Sweep & Integrità Architetturale
- Bonifica di tutti i dizionari e strutture dati non tipizzate rimaste isolate.
- Preservazione rigorosa del principio di Clean Architecture DDD, senza chiamate circolari tra `SocialMediaSystem`, `TravelSystem` e `ConcertSystem`.
- Mantenimento delle 23 suite headless esistenti con garanzia di 0 errori e 0 ms di regressione.

### Contratto D1: Modello Dati e Tipi Centralizzati (`core/enums.gd`, `SocialPostData`, `FanClubData`)
- In `core/enums.gd`:
  * Estensione di `enum SocialPostType`:
    ```gdscript
    enum SocialPostType {
        PRACTICE_CLIP = 0,     # Clip prove / backstage
        TRACK_TEASER = 1,      # Teaser di un brano o singolo
        BEHIND_THE_SCENES = 2, # Vita da band / tour
        PROVOCATION = 3,       # Post provocatorio / meme
        LIVE_STREAM = 4,       # Diretta streaming con i fan
        COUNTDOWN_TEASER = 5   # Countdown pre-uscita
    }
    ```
  * Aggiunta `enum SocialSponsorBudget`:
    ```gdscript
    enum SocialSponsorBudget {
        NONE = 0,
        LIGHT = 100,    # +100% reach
        MEDIUM = 250,   # +250% reach
        HEAVY = 500     # +500% reach
    }
    ```
  * Funzioni di supporto vocale: `get_social_post_type_name(type: int) -> String`.
- Creazione nuovo modello dati `FanClubData` (`data/models/fan_club_data.gd`):
  * `is_founded: bool = false`
  * `president_name: String = ""`
  * `president_city_id: int = Enums.CityId.MILANO`
  * `loyalty_tier: int = 1` (1..5)
  * `members_count: int = 0`
  * `annual_meeting_held: bool = false`
  * Serializzazione atomica `to_dict()` e `from_dict()`.
- Estensione `PlayerData`:
  * Campo `fan_club: FanClubData`.
  * Tracciamento metriche aggregate fandom: `get_territorial_fans_summary() -> Dictionary`.

### Contratto D2: Sottosistema `SocialMediaSystem` Potenziato
- Estensione metodi:
  * `sponsor_post(post_id: String, budget: int) -> Dictionary`: investimento pubblicitario scalato dal conto del giocatore (`player_data.modify_money(-budget)`).
  * `start_live_stream() -> Dictionary`: avvio diretta con generazione proceduralmente determinata di 3 domande dai fan e relative risposte a bivio.
  * `resolve_live_stream_choice(stream_id: String, choice_index: int) -> Dictionary`.
  * `found_fan_club(president_name: String = "") -> Dictionary`: sblocco fan club, nomina presidente procedurale ed emissione segnale EventBus.
  * `organize_fan_club_meeting() -> Dictionary`: raduno annuale con bonus morale, fedeltà e vendita gadget.
  * `get_weekly_trend_post_type() -> int`: calcolo deterministico del trend settimanale basato sul numero del giorno del calendario.
  * `resolve_controversy(choice: int) -> Dictionary`: supporto per la scelta 3 (`choice == 3`, Delega al Manager).
  * Generazione eventi posta fan ossessivi al check notturno in `process_daily_decay()`.

### Contratto D3: Dashboard & Modale `SocialModal` Accessibile per NVDA
- Estensione di `ui/social/social_modal.tscn` e `ui/social/social_modal.gd`:
  * Tasto `5`: Avvia Diretta Live Streaming (consumo 25 energia).
  * Tasto `S`: Sponsorizza ultimo post a pagamento (selezione budget 100 €, 250 €, 500 €).
  * Tasto `F`: Pannello Fan Club Ufficiale (fondazione, stato tesserati, livello fedeltà e raduno).
  * Tasto `D`: Opzione aggiuntiva nel pannello controversia (quando il manager è presente).
  * Riquadro "Tendenza della Settimana" con annuncio vocale per NVDA (es. *"Questa settimana l'algoritmo spinge le Clip delle Prove: visualizzazioni +40%"*).
  * Vocalizzazione sequenziale lineare a elenco per NVDA (Zero Mouse).

### Contratto D4: Integrazione Sistemica, Persistenza Atomica & Test Suite Headless
- Aggiornamento `SaveManager` (`autoload/save_manager.gd`) per il salvataggio/caricamento di `FanClubData` e delle nuove metriche social.
- Connessione con `ConcertSystem`: boost prevendite garantite dal livello fedeltà del Fan Club (+5% .. +25%).
- Creazione della nuova suite di test headless `tests/test_advanced_social_system.gd` con copertura al 100% delle nuove funzionalità a 0 ms.
- Esecuzione regressione completa sulle 23 suite esistenti per verificare la tenuta di tutte le feature storiche.

---

## ⚖️ 3. VALIDAZIONE PREVENTIVA A 7 ASSI

- **Asse 1 — Validità**: Rispetto rigoroso dei tipi GDScript 2.0 statici, assenza di `Variant` ambigui e null-safety verificata su tutte le classi dati.
- **Asse 2 — Efficacia**: Risolve direttamente la richiesta del GDD Sezione 8, trasformando i social da semplice clicca-e-posta a strumento organico di carriera con streaming, fan club e sponsor.
- **Asse 3 — Coerenza**: Perfettamente integrato con i sistemi esistenti (`TravelSystem`, `ConcertSystem`, `EndDaySystem`, `IndustrySystem` e `SaveManager`).
- **Asse 4 — Completezza**: Copre l'intero spettro di requisiti di `docs/roadmap/08_social_media_fan_engagement_e_viralita.md` (tipologie post, algoritmi, shitstorm, manager, fan club e fan ossessivi).
- **Asse 5 — Precisione**: Modifiche chirurgiche e modulari, senza rompere la struttura esistente di `SocialMediaSystem` o `SocialModal`.
- **Asse 6 — Affidabilità & Prestazioni**: Esecuzione headless deterministica a 0 ms, zero chiamate temporizzate asincrone e zero perdite di memoria.
- **Asse 7 — Assenza Regressioni & Prevenzione Anomalie**: Protezione totale delle 23 suite esistenti (100% passate) e compatibilità retroattiva con i salvataggi JSON.

---

## 🧪 4. SIMULAZIONE A 3 LIVELLI

- **Livello 1 (Happy Path)**:
  * Il giocatore pubblica una Clip delle Prove durante una settimana in cui le clip sono di tendenza.
  * Ottiene +40% visualizzazioni, diventa virale, converte 150 nuovi follower e 60 fan locali a Milano.
  * Investe 100 € per sponsorizzare il post, raddoppiando la portata.
  * Raggiunti 1.000 fan totali, fonda il Fan Club Ufficiale eleggendo il Presidente "Marco da Bologna", ottenendo il bonus fedeltà per i successivi concerti live.
- **Livello 2 (Casi Alternativi & Concorrenti)**:
  * Pubblicazione di un Post Provocatorio che innesca una polemica online.
  * Il giocatore ha un Manager professionista: sceglie l'opzione `[D] Delega al Manager`.
  * Il manager pubblica un comunicato diplomatico: zero perdita follower, +2 reputazione e crisi estinta senza malus di stress.
  * Il giocatore avvia una diretta streaming: risponde a 3 domande della chat, aumentando il morale della band e l'hype pre-concerto.
- **Livello 3 (Corner Cases & Boundary Conditions)**:
  * Tentativo di pubblicare o sponsorizzare senza energia o senza denaro sufficiente: rifiuto deterministico con messaggio vocale esplicito.
  * Tentativo di fondare il fan club con meno di 1.000 fan: blocco logico con notifica dei requisiti mancanti.
  * Caricamento di un vecchio salvataggio privo di `fan_club`: fallback deterministico a valori di default senza crash.

---

## 🛑 5. CRITERI DI ACCETTAZIONE & STATO CONVALIDA

- [x] [CONVALIDATO CON SUCCESSO] Approvazione esplicita del Piano Tecnico da parte di Luca ("procedi").
- [x] [CONVALIDATO CON SUCCESSO] Stop Obbligatorio rispettato prima di toccare codice sorgente o configurazioni (Sotto-Fase 1A completata).
- [x] [CONVALIDATO CON SUCCESSO] Esecuzione dei Contratti D0..D4 in Sotto-Fase 1B post-approvazione.
- [x] [CONVALIDATO CON SUCCESSO] Esecuzione dell'intera suite di test headless (24 suite superate a 0 errori e 0 ms, 51 asserzioni Sezione 8).
- [x] [CONVALIDATO CON SUCCESSO] Fase 2: Deploy Provvisorio & Collaudo Manuale NVDA da parte di Luca superato.
- [x] [CONVALIDATO CON SUCCESSO] Fase 3: Chiusura Tecnica, Living Documentation, Git Commit locale & Disciplina AVF (V4.8.0).
