# World-tour — Master Roadmap & Coordinatore dei Piani Operativi

- Autori del progetto: Luca & Holy Diver
- Assistenti: Antigravity (AI Primaria) & OpenAI Codex GPT (AI Ausiliaria)
- Posizione file: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md)
- Stato: Coordinatore attivo di Governance e Roadmap

---

## 1. PRINCIPIO GUIDA E REGOLE DI GATING

Questo documento è il punto centrale di coordinamento operativo del progetto **World-tour**.  
Orchestra i sottopiani tematici specializzati, definisce la roadmap di implementazione e traccia lo stato reale delle attività con gating deterministico a tre stati:
- `[ ]`: Attività pianificata e aperta (non ancora iniziata).
- `[/]`: Attività autorizzata e in lavorazione.
- `[x]`: Attività completata e verificata con evidenza empirica osservabile.

*Divieto assoluto di spunta preventiva prima dell'effettivo collaudo tecnico e manuale.*

---

## 2. MAPPA DEI SOTTOPIANI TEMATICI (PER COMPETENZE)

Il materiale del Game Design Document originario è stato organizzato e disaccoppiato in 8 sottopiani tematici specialistici:

1. **[`SP-01`: Game Design, Visione e Progressione](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/01_game_design_visione_e_progressione.md)**  
   *Competenze*: Game Design, Creative Direction, Narrative & Worldbuilding.  
   *Oggetto*: Fantasia del giocatore, High concept, 8 stadi di carriera (da "Nessuno" a "Superstar") e macro-roadmap da V1 a V5.

2. **[`SP-02`: Simulazione Vita, Gestione Tempo e Routine](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/02_simulazione_vita_tempo_e_routine.md)**  
   *Competenze*: Core Mechanics, Life Simulation, Ergonomia & Pacing.  
   *Oggetto*: Orologio giornaliero (600s), stati IDLE/BUSY, Pausa Dinamica automatica nei menu, triade risorse (Tempo, Energia, Denaro, Stress, Morale), trasporti e ciclo di Fine Giornata.

3. **[`SP-03`: Sistema Musicale, Abilità e Creazione Brani](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/03_sistema_musicale_abilita_e_creazione_brani.md)**  
   *Competenze*: Music Crafting System, Audio/Musical Design.  
   *Oggetto*: Le 7 abilità musicali, 6 generi di partenza, pipeline di creazione brani in 5 fasi, attributi musicali, calcolo del Quality Score e formati disco (Singolo, EP, Album).

4. **[`SP-04`: Concerti, Locali, Pubblico e Fanbase](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/04_concerti_locali_pubblico_e_fanbase.md)**  
   *Competenze*: Live Events Design, PR & Audience Simulation.  
   *Oggetto*: Tipologie di locali (garage, pub, piccolo club), selezione scaletta brani, calcolo del Concert Score, affluenza spettatori, conversione in fan stabili e cassa della serata.

5. **[`SP-05`: Economia, Carriera, Band e Industria](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/05_economia_carriera_band_e_industria.md)**  
   *Competenze*: Economy Simulation, Social & Relational Systems, Narrative Events.  
   *Oggetto*: Flussi economici (entrate/uscite fisse), 6 fasi di indipendenza economica, dinamiche di band (personalità, affinità, conflitti), etichette Indie vs Major, manager ed eventi etici.

6. **[`SP-06`: Formule Matematiche e Bilanciamento](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/06_formule_matematiche_e_bilanciamento.md)**  
   *Competenze*: Mathematical Modeling, Game Balancing, Algorithmic Design.  
   *Oggetto*: Tutte le formule matematiche del gioco (progressione XP a salita esponenziale, rendimenti marginali decrescenti, freno da stress/morale, formule pubblico e conversione fan, costanti centralizzate).

7. **[`SP-07`: Architettura Software, Sistemi e Modello Dati](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/07_architettura_software_sistemi_e_modello_dati.md)**  
   *Competenze*: Software Architecture, Systems Engineering, Data Modeling.  
   *Oggetto*: Clean Architecture, albero cartelle, EventBus disaccoppiato a segnali, macchina a stati globale (GameManager), modello dati runtime (PlayerData, CalendarData, SongData, VenueData) e salvataggio atomico JSON.

8. **[`SP-08`: Accessibilità Vocale, Tastiera e Simmetria Universale](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/08_accessibilita_vocale_interfaccia_e_simmetria.md)**  
   *Competenze*: Accessibility Engineering, Screen Reader Integration, Universal UX.  
   *Oggetto*: Principio di Simmetria Universale (Luca con tastiera/NVDA e Holy Diver con grafica moderna e mouse), modulo AccessibilityManager (`nvdaControllerClient.dll`/SAPI), scorciatoie 1–9, sonificazione e volumi di sicurezza (0.7f–0.8f con ducking).

9. **[`SP-09`: Calendario Sistemico, Agenda, Cicli Temporali e Programmazione Eventi](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/09_calendario_sistemico_agenda_e_cicli_temporali.md)**  
   *Competenze*: Systems Engineering, Life Simulation, Dynamic World Pacing.  
   *Oggetto*: Scansione multi-livello del tempo (giorni della settimana da Lunedì a Domenica, mese convenzionale a 28 giorni, 4 stagioni, anno di carriera), modello `CalendarEventData` e motore `ScheduleSystem` per la gestione dell'agenda impegni della band, scadenze discografiche, serate live e programmazione dei locali.

---

## 3. ROADMAP SEQUENZIALE OPERATIVA (CHECKBOX SPUNTABILI)

### FASE 0: Organizzazione Sistemica & Allineamento Multi-AI
- [x] `F0.1`: Analisi esplorativa completa del corpus originario di 9.357 righe.
- [x] `F0.2`: Redazione del Rapporto di Analisi e Consolidamento in [`docs/report/ANALISI_E_CONSOLIDAMENTO_WORLD_TOUR.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/report/ANALISI_E_CONSOLIDAMENTO_WORLD_TOUR.md).
- [x] `F0.3`: Scorporo della documentazione negli 8 sottopiani tematici in `docs/piani/attivi/sottopiani/`.
- [x] `F0.4`: Creazione del Master Roadmap Coordinator in [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md).
- [x] `F0.5`: Aggiornamento del report di sessione e sincronizzazione delle direttive per OpenAI Codex GPT in [`AGENTS.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/AGENTS.md).
- [x] `F0.6`: Decisione e approvazione definitiva con Luca e Holy Diver sulla formula temporale (pausa dinamica) e sullo stack (Godot 4 + bridge vocale NVDA).
- [x] `F0.7`: Revisione e ottimizzazione approfondita di tutti gli 8 sottopiani tematici (`SP-01` $\rightarrow$ `SP-08`) applicando il Protocollo a 3 Lenti (Gameplay, Tecnica, Godot 4 & Simmetria).

---

### FASE 1: Preparazione Ambiente & Fondamenta del Progetto
- [x] `F1.1`: Definizione ed installazione dell'ambiente runtime prescelto sulla macchina di sviluppo (Godot Engine v4.7.2 win64 verificato).
- [x] `F1.2`: Inizializzazione della struttura ad albero del codice (`core/`, `data/`, `systems/`, `autoload/`, `ui/`, `tests/`, `tools/`) e `project.godot`.
- [x] `F1.3`: Creazione del modulo `Constants` con tutte le costanti di bilanciamento matematico di [`SP-06`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/06_formule_matematiche_e_bilanciamento.md) e `core/enums.gd`.
- [x] `F1.4`: Implementazione della classe pura `Formulas` con suite di test headless (`tests/test_formulas.gd`, 24 test passati su 24).
- [x] `F1.5`: Creazione del modulo `EventBus` (`autoload/event_bus.gd`) per il disaccoppiamento totale a segnali/eventi.

---

### FASE 2: Vertical Slice V1.0 — Il Ciclo Vitale Minimo (Core Loop)
- [x] `F2.1`: Implementazione delle classi del Modello Dati base (`PlayerData`, `CalendarData`, `ActionData`).
- [x] `F2.2`: Implementazione del `TimeSystem` (giornata a 600s, decremento timer, stati IDLE/BUSY, controlli Pausa/Play/Velocità).
- [x] `F2.3`: Implementazione della Pausa Dinamica automatica all'apertura dei menu di navigazione.
- [x] `F2.4`: Implementazione del modulo bridge `AccessibilityManager` (comunicazione vocale con NVDA e navigazione 100% tastiera).
- [x] `F2.5`: Creazione della prima azione funzionante: "Allenamento Rapido" (10s, consumo energia, guadagno XP).
- [x] `F2.6`: Implementazione del ciclo di Fine Giornata (`EndDaySystem` e schermata Daily Summary).
- [x] `F2.7`: Implementazione della persistenza di base (`SaveManager`, salvataggio e caricamento JSON atomico).
- [x] `F2.8`: **Collaudo Funzionale del Ciclo Vitale**: Verifica del loop completo (Avvio $\rightarrow$ Allenamento $\rightarrow$ Fine Giornata $\rightarrow$ Salvataggio $\rightarrow$ Riavvio). Superato con collaudo congiunto NVDA/Monitor e 67/67 test automatizzati.

---

### FASE 2.5: Ponte Architetturale — Localizzazione (i18n) & Main Menu Simmetrico
- [x] `F2.5.1`: Creazione dei dizionari di traduzione bilingue speculari (`localization/it.json` e `localization/en.json`).
- [x] `F2.5.2`: Implementazione dell'Autoload `LocalizationManager` con rilevamento lingua OS, gestione `TranslationServer` e segnale `language_changed`.
- [x] `F2.5.3`: Estensione persistenza a doppio livello: configurazione globale in `user://settings.json` e salvataggio preferenza nella scheda giocatore (`PlayerData.language`).
- [x] `F2.5.4`: Implementazione della schermata `MainMenu` (Avvio Rapido, Impostazioni, Esci) con pannello Impostazioni e selettore lingua `OptionButton`.
- [x] `F2.5.5`: Aggiornamento dell'HUD per navigazione bidirezionale con pulsante "Menu Principale" e allineamento dinamico delle etichette AccessKit.
- [x] `F2.5.6`: **Collaudo Funzionale della Fase 2.5**: Convalidato con 96/96 test automatizzati headless e collaudo reale positivo da parte di Luca (NVDA) e Holy Diver.

---

### FASE 3: Vertical Slice V1.1 — Il Ciclo Creativo (Music Crafting)
- [x] `F3.1`: Implementazione completa delle 7 abilità in `SkillSystem` con curve di livello.
- [x] `F3.2`: Pipeline a 5 stadi di creazione brani in `MusicSystem` (Genere, Composizione, Testo, Produzione, Qualità).
- [x] `F3.3`: Gestione del catalogo brani del giocatore (stati Bozza, Prodotto, Rilasciato).
- [x] `F3.4`: Meccanismo di rilascio del primo Singolo musicale.
- [x] `F3.5`: Test funzionale del ciclo creativo e verifica feedback vocale per NVDA (convalidato con 125 test, collaudo in-game e risoluzione revisioni RRU-01, RRU-02 e RRU-03).
- [x] `F3.6`: **Chiusura Ufficiale Fase 3**: Collaudo congiunto superato da Luca e Tom, archiviazione revisioni RRU-02/RRU-03 e transizione a Fase 4.

---

### FASE 4: Vertical Slice V1.2 — Il Palco dal Vivo (Live Performance)
- [x] `F4.1`: Definizione del catalogo dei locali iniziali (`VenueData`: Garage, Pub, Piccolo Club, Club di Tendenza con bilanciamento affitto, capacità e requisiti).
- [x] `F4.2`: Schermata e pannello di preparazione live (`LiveConcert`: selezione locale, prezzo biglietto, soundcheck e selettore scaletta da 1 a 4 brani pronti/pubblicati).
- [x] `F4.3`: Motore di simulazione concerti (`ConcertSystem`: calcolo affluenza su popolarità e prezzo biglietto, stage events con bivi Carisma/Performance, closer bonus con tratti `STAGE_BEAST` e `CULT_CLASSIC`, conversione fan ed economia).
- [x] `F4.4`: Test funzionali e suite automatizzata (`tests/test_concert_system.gd`: 53 test unitari/integrazione superati, copertura 100% headless, AccessKit e scorciatoie da tastiera 'L', '1', '2', 'Esc').
- [x] `F4.5`: **Chiusura Ufficiale Fase 4**: Collaudo congiunto superato da Luca e Tom, risoluzione e archiviazione anomalia `RRU-04` (isolamento AccessKit HUD e backdrop opaco modali), 5 suite test su 5 superate con 0 errori e transizione a Fase 5.

---

### FASE 5: Vertical Slice V1.3 — Economia, Carriera e Rilascio MVG
- [x] `F5.1`: Modulo `EconomySystem` (`systems/economy_system.gd`: spese fisse vitto/alloggio 25 €, registro transazioni, autonomia economica residua, lavori ordinari di sussistenza e meccanica del "Salto nel vuoto").
- [x] `F5.2`: Modulo `CareerSystem` (`systems/career_system.gd`: matrice degli status da Beginner a Superstar con promozioni automatiche basate su fan, popolarità e singoli rilasciati).
- [x] `F5.3`: Rifinitura estetica, velocità scalabile e Starter Pack (`ui/economy/economy_bank.tscn`, pulsanti HUD Velocità `T` 1x/2x/3x con annuncio NVDA, Bilancio `B`, e starter pack di 10 canzoni multi-genere con tratti speciali per testing immediato).
- [x] `F5.4`: Collaudo manuale congiunto (Luca con NVDA/tastiera, Holy Diver con monitor/mouse): superato con risoluzione dei 5 feedback (starter pack brani, durata giornata personalizzabile con default a 5 min, riepilogo giornaliero DailySummary, layout barra superiore HUD e scheda unica di creazione brani).
- [x] `F5.5`: Tag Git e archiviazione del piano di completamento della V1.0 Minimum Viable Game (6 suite di test su 6 superate al 100%, 0 errori).

---

### FASE 6: Identità Artistica & Espansione V2.0 (The Musician's Life & Band System)
- [x] `F6.1`: **L'Identità del Musicista & Scheda Personaggio (Opzione 1)**: Protagonista pronto per i test (Alex, Chitarra Elettrica, Autodidatta, Carismatico, 7 abilità a Liv. 10), integrazione bisogni vitali (Stress e Morale) e riquadro riassuntivo artistico nell'HUD, pulsante `Personaggio (C)` e scorciatoia `C`, modale ad alto contrasto `CharacterSheet` con matrice dinamica delle 7 abilità e annuncio vocale per NVDA (convalidato con 35/35 file verificati e 6/6 test suite).
- [x] `F6.2`: **Sistema Band, Reclutamento & Dinamiche Umane**: Reclutamento compagni di band (Basso, Batteria, Tastiere, Chitarra Ritmica), bacheca audizioni (30 €), 4 personalità distinte, indicatori vitali di gruppo (Affinità Umana, Rispetto Musicale, Tensione Interna), sinergia palco (-15% a +25%), gestione delle politiche di incasso (Revenue Split: Equa 25%, Leader 40%, Predatoria 70%) e rischio abbandono su tensione critica (> 85%). Modale dedicata `BandHub` e tasto rapido `G`.
- [x] `F6.3`: **Formati Discografici Estesi (EP & LP)**: Modulo `AlbumSystem` (`systems/album_system.gd`) e modale `AlbumCreator` (`ui/album/album_creator.tscn`), supporto compilazione EP (3-5 tracce) e LP (6-10 tracce), selezione concept artistico, stile artwork e traccia trainante (lead single). Calcolo qualità complessiva, recensioni della critica musicale (1.0 - 5.0 stelle ⭐), vendite Day 1, conversione fan/reputazione e ripartizione incassi con la band. Tasto rapido `P` e visualizzazione discografia in `SongCatalog`.
- [x] `F6.4`: **Lifestyle, Alloggi & Royalties a Catalogo**: 4 categorie di residenza (`HousingData`: Stanzetta 15€, Appartamento condiviso con la Band 25€ con canone ripartito tra coinquilini e dinamiche relazionali, Loft con sala prove 50€, Villa con studio 150€), integrazione in `EconomyBank` con possibilità di trasloco, incasso automatico royalties passive giornaliere a catalogo con decadimento fisiologico in `EndDaySystem` e riepilogo notturno completo in `DailySummary`.
- [x] `F6.5`: **Suite di Test Automatizzati V2.0**: 8 suite di test su 8 superate al 100% in modalità headless (`test_band_system.gd` e `test_album_system.gd` con 105 test dedicati superati con 0 errori).
- [x] `F6.6`: **Chiusura Ufficiale Fase 6 & Risoluzione Catalogo Album**: Collaudo congiunto superato da Luca (NVDA/tastiera) e Holy Diver (monitor/mouse), risoluzione sincronizzazione e visibilità dischi nel catalogo con separazione rigida delle sezioni e tasti rapidi `A` (Album/EP) e `S` (Brani), vocalizzazione della tracklist, 8/8 suite di test a 0 errori e chiusura formale della V2.0.

---

### FASE 7: L'Industria Musicale, Manager, Contratti & Bivi Etici (Versione 3.0)
- [x] `F7.1`: **Modello Dati Industria & Contratti (`ContractData`, `ManagerData`, `DilemmaData`)**: Definizione strutture dati per tipologia di contratto (Autoproduzione, Indie, Major), anticipi liquidi immediati, tracciamento del debito di recupero (*Recoupment*), percentuale royalties (45% indie vs 15% major), obblighi di consegna dischi e 3 profili di manager (Amico Fidato, Professionista Indipendente, Squalo dell'Industria).
- [x] `F7.2`: **Sottosistema Industria e Negoziazione (`IndustrySystem`)**: Modulo di gestione delle offerte contrattuali in base a Reputazione e Fan, calcolo del recoupment passivo su vendite e royalties, e impatto del manager su concerti (cachet e provvigione) e stress notturno.
- [x] `F7.3`: **Sistema dei Bivi Etico-Narrativi (`DilemmaSystem`)**: Motore di eventi periodici a bivio (es. spot commerciale vs integrità artistica, ghostwriting, pay to play, sponsorizzazioni controverse, plagio, liti con la major) con effetti deterministici su Morale, Denaro, Fan, Reputazione e Tensione della band.
- [x] `F7.4`: **Dashboard Industria, Contratti & Accessibilità NVDA (`ui/industry/`)**: Interfaccia a schede ad alto contrasto per Holy Diver e procedura 100% accessibile da tastiera per Luca con tasto rapido `K`, navigazione schede con `1` e `2`, lettura riga per riga di clausole e percentuali prima della firma e finestra di risoluzione dei bivi morali.
- [x] `F7.5`: **Suite di Test Headless & Collaudo Congiunto V3.0**: Nuove suite di test automatizzate headless per `IndustrySystem` (60 test superati) e `DilemmaSystem` (5 blocchi superati), test di regressione sulle 8 suite esistenti (10/10 suite superate con 0 errori) e collaudo reale con NVDA.
- [x] `F7.6`: **Chiusura Ufficiale Fase 7 (Versione 3.0)**: Approvazione congiunta di Luca (NVDA/tastiera) e Holy Diver (monitor/mouse), 53 file verificati senza errori di compilazione, archiviazione formale della V3.0 e transizione a Fase 8.

---

### FASE 8: Il Mondo Dinamico, Tour Interurbani, Festival Estivi & Social Media (Versione 4.0)
- [x] `F8.1`: **Mappa Geografica & Sistema delle Città (`CityData`, `TravelSystem`)**: Rete di 6 città (Milano, Bologna, Roma, Napoli, Londra, Berlino) con affinità di genere musicale, matrice di viaggio (costi denaro, fatica energia, stress), penetrazione territoriale della fanbase (85% locale, 15% riverbero nazionale), locali specifici per metropoli, modale `TravelModal` ad alto contrasto con tasto rapido `V` e tasti numerici `1`..`6`, lettura vocale lineare per NVDA, integrazione in `GameManager`, `ConcertSystem`, `LiveConcert` e `SaveManager`. Convalidato con 64/64 test dedicati e 12/12 suite complessive superate con 0 errori.
- [x] `F8.2`: **Pianificazione & Gestione del Tour (`TourSystem`, `TourData`)**: Modulo di organizzazione tappe live consecutive su calendario di sistema, logistica trasporti con 3 classi di veicolo (Furgone Scassato economico con rischio guasto, Van Professionale bilanciato, Tour Bus di Lusso rigenerante), meccanica Hype progressivo a catena (+5% per show eccellente con riverbero sull'affluenza), impatto su stanchezza, stress e dinamiche della band (affinità, rispetto musicale, tensione interna e reputazione). Modale `TourModal` ad alto contrasto con tasto rapido `O`, preset di tournée `1`..`3`, avanzamento con `Spazio`/`Invio` e sintesi vocale lineare per NVDA. Convalidato con 65/65 test dedicati e 13/13 suite di test a 0 errori.
- [x] `F8.3`: **I Grandi Festival Estivi (`FestivalEvent`, `FestivalSystem`)**: Stagione dei grandi festival all'aperto nei mesi estivi (Mesi 4-6 / Giorni 85-168) sulle 6 metropoli continentali, 3 slot orari di esibizione (Pomeriggio, Tramonto, Headliner), influenza del Manager su requisiti reputazione e cachet garantito, moltiplicatore vendite merch intensivo (x2.5 - x5.5), meccanica "Rubare la Scena" (*Steal the Show*) contro le band rivali sul cartellone (+30% fan e bonus reputazione/morale), sincronizzazione su `ScheduleSystem` e modale `FestivalModal` accessibile con tasto rapido `F` e numeri `1`..`6`. Convalidato con 70/70 test dedicati e 14/14 suite headless a 0 errori.
- [x] `F8.4`: **Social Media, Fan Engagement & Viralità (`SocialMediaSystem`, `SocialPostData`)**: Canali social della band ("BandFeed"), 4 tipologie di contenuto (Clip delle Prove, Teaser Brano, Vita da Band/Backstage, Post Provocatorio/Meme), algoritmo di visualizzazioni su carisma e popolarità, meccanica di viralità procedurale, conversione follower in fan reali di gioco (con penetrazione locale nella città corrente tramite `TravelSystem`), gestione polemiche online (*shitstorm*) a 3 bivi strategici (0=Ignora, 1=Scuse formali, 2=Raddoppia la posta / Double Down), moltiplicatore `social_buzz` [1.0x - 2.50x] sull'affluenza dei concerti in `ConcertSystem`, decadimento fisiologico notturno del 10% in `EndDaySystem`, modale `SocialModal` accessibile con tasto rapido `Y`, tasti `1`..`4`, `A`/`B`/`C` e sintesi vocale lineare per NVDA. Convalidato con 65/65 test dedicati e 15/15 suite complessive a 0 errori.
- [x] `F8.5`: **Artisti Rivali & Classifiche Musicali (`RivalSystem`, `ChartSystem`, `RivalData`, `ChartEntryData`)**: Catalogo di 10 band rivali continentali distribuite sulle 6 metropoli europee con generi e popolarità dinamica; simulazione settimanale ogni Domenica notte (`EndDaySystem`); compilazione della Top 10 Singoli e Top 10 Album; algoritmo di stream/vendite del giocatore potenziato da qualità dei brani, fan e social buzz; tracciamento debutti (`NEW`), variazioni posizioni (`▲`, `▼`, `=`), picchi e settimane di permanenza; evento trionfale per la conquista del #1 con bonus popolarità, fan e morale; modale `ChartModal` ad alto contrasto con tasto rapido HUD `H`, tasti `1` (Singoli), `2` (Album), `R` (Rivale), `Esc` e vocalizzazione sequenziale lineare al 100% per NVDA; persistenza atomica in `SaveManager`. Convalidato con 54/54 test dedicati e 16/16 suite headless del progetto a 0 errori.
- [x] `F8.6`: **Dashboard Tour & Accessibilità NVDA (`ui/hud/`, `ui/tour/`, `ui/social/`)**: Centralizzazione atomica della visibilità modali nell'HUD con `_hide_all_modals()` e guardia predittiva `_is_any_modal_open()` su tutte le 15 finestre del gioco; eliminazione di sovrapposizioni e focus leaks; blindatura della coesistenza dei 15 tasti rapidi HUD (`C`, `G`, `K`, `L`, `M`, `N`, `B`, `A`, `V`, `O`, `F`, `Y`, `H`, `T`, `P`); isolamento del backdrop per Holy Diver e annunci vocali lineari al 100% per NVDA. Convalidato con la nuova suite headless `test_v4_ui_integration.gd` (44 test) e 17/17 suite complessive del progetto a 0 errori.
- [ ] `F8.7`: **Suite di Test Headless Globale & Collaudo Congiunto V4.0**: Collaudo congiunto definitivo della Versione 4.0 con Luca (NVDA/tastiera) e Holy Diver (monitor/mouse), verifica di non regressione e chiusura formale della V4.0.

---

### ROADMAP DI ESPANSIONE (V2.0 – V5.0)
- [x] `V2.0`: Sistema Band, reclutamento musicisti, dinamiche relazionali, creazione EP e Album, lifestyle e royalties di catalogo (completato e convalidato al 100%).
- [x] `V3.0`: Industria musicale, manager, etichette Indie vs Major, contratti ed eventi narrativi a bivi morali (completato e convalidato al 100%).
- [/] `V4.0`: Mondo dinamico, mercati musicali fluttuanti, festival estivi, tour interurbani, artisti rivali e social media (in lavorazione).
- [ ] `V5.0`: Endgame e Superstar mondiale, concerti negli stadi, mega-produzioni, premi alla carriera e Legacy finale.
