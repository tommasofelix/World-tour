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

I sottopiani tematici specialistici delle Fasi 1–8 (V1.0 – V4.0) sono stati completati, convalidati e archiviati in [`docs/piani/completati/sottopiani/`](./piani/completati/sottopiani/).  
I nuovi sottopiani per la Fase 9 (V5.0 Endgame) risiedono in [`docs/piani/attivi/sottopiani/`](./piani/attivi/sottopiani/).

### Sottopiani Archiviati e Convalidati (V1.0 – V4.0)

1. **[`SP-01`: Game Design, Visione e Progressione](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/completati/sottopiani/01_game_design_visione_e_progressione.md)** [x]  
   *Competenze*: Game Design, Creative Direction, Narrative & Worldbuilding.  
   *Oggetto*: Fantasia del giocatore, High concept, 8 stadi di carriera e macro-roadmap.

2. **[`SP-02`: Simulazione Vita, Gestione Tempo e Routine](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/completati/sottopiani/02_simulazione_vita_tempo_e_routine.md)** [x]  
   *Competenze*: Core Mechanics, Life Simulation, Ergonomia & Pacing.  
   *Oggetto*: Orologio giornaliero, stati IDLE/BUSY, Pausa Dinamica automatica nei menu, triade risorse e ciclo Fine Giornata.

3. **[`SP-03`: Sistema Musicale, Abilità e Creazione Brani](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/completati/sottopiani/03_sistema_musicale_abilita_e_creazione_brani.md)** [x]  
   *Competenze*: Music Crafting System, Audio/Musical Design.  
   *Oggetto*: Le 7 abilità musicali, generi, pipeline creazione brani, Quality Score e formati disco (Singolo, EP, Album).

4. **[`SP-04`: Concerti, Locali, Pubblico e Fanbase](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/completati/sottopiani/04_concerti_locali_pubblico_e_fanbase.md)** [x]  
   *Competenze*: Live Events Design, PR & Audience Simulation.  
   *Oggetto*: Tipologie di locali, scaletta brani, Concert Score, affluenza, conversione fan e incassi live.

5. **[`SP-05`: Economia, Carriera, Band e Industria](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/completati/sottopiani/05_economia_carriera_band_e_industria.md)** [x]  
   *Competenze*: Economy Simulation, Social & Relational Systems, Narrative Events.  
   *Oggetto*: Flussi economici, indipendenza economica, dinamiche di band, etichette Indie vs Major, manager e bivi etici.

6. **[`SP-06`: Formule Matematiche e Bilanciamento](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/completati/sottopiani/06_formule_matematiche_e_bilanciamento.md)** [x]  
   *Competenze*: Mathematical Modeling, Game Balancing, Algorithmic Design.  
   *Oggetto*: Formule matematiche del gioco (XP esponenziali, rendimenti marginali, freno stress, formule pubblico/fan).

7. **[`SP-07`: Architettura Software, Sistemi e Modello Dati](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/completati/sottopiani/07_architettura_software_sistemi_e_modello_dati.md)** [x]  
   *Competenze*: Software Architecture, Systems Engineering, Data Modeling.  
   *Oggetto*: Clean Architecture, EventBus disaccoppiato, FSM GameManager, modelli dati e salvataggio atomico JSON.

8. **[`SP-08`: Accessibilità Vocale, Tastiera e Simmetria Universale](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/completati/sottopiani/08_accessibilita_vocale_interfaccia_e_simmetria.md)** [x]  
   *Competenze*: Accessibility Engineering, Screen Reader Integration, Universal UX.  
   *Oggetto*: Principio di Simmetria Universale, bridge AccessibilityManager con NVDA/SAPI, scorciatoie e volumi sicuri (0.7f–0.8f).

9. **[`SP-09`: Calendario Sistemico, Agenda, Cicli Temporali e Programmazione Eventi](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/completati/sottopiani/09_calendario_sistemico_agenda_e_cicli_temporali.md)** [x]  
   *Competenze*: Systems Engineering, Life Simulation, Dynamic World Pacing.  
   *Oggetto*: Scansione temporale a 28 giorni per mese, 4 stagioni, modello CalendarEventData e motore ScheduleSystem.

10. **[`SP-10`: Pianificazione & Gestione del Tour](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/completati/sottopiani/10_pianificazione_e_gestione_del_tour.md)** [x]  
    *Competenze*: Core Systems Architecture, Simulation Design, Tour Management.  
    *Oggetto*: Tournée multi-tappa, logistica con 3 veicoli (Rusty Van, Pro Van, Luxury Bus), Hype progressivo e dinamiche band.

11. **[`SP-11`: I Grandi Festival Estivi](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/completati/sottopiani/11_grandi_festival_estivi.md)** [x]  
    *Competenze*: Festival Management, Outdoor Event Simulation, Merchandising.  
    *Oggetto*: Stagione estiva (mesi 4-6), 3 slot orari di esibizione, moltiplicatore merch (x2.5 - x5.5) e meccanica "Rubare la Scena".

12. **[`SP-12`: Social Media, Fan Engagement & Viralità](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/completati/sottopiani/12_social_media_fan_engagement_e_viralita.md)** [x]  
    *Competenze*: Social Media Simulation, Community Dynamics, PR Controversies.  
    *Oggetto*: Canale BandFeed, 4 tipologie post, algoritmo visualizzazioni/follower, buzz virale sui concerti e gestione polemiche.

13. **[`SP-13`: Artisti Rivali & Classifiche Musicali](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/completati/sottopiani/13_artisti_rivali_e_classifiche_musicali.md)** [x]  
    *Competenze*: Competitive Systems, Chart Tracking, Industry Dynamics.  
    *Oggetto*: 10 band rivali continentali, Hit Parade settimanale Top 10 Singoli e Top 10 Album, movimenti, picchi e conquista del #1.

14. **[`SP-14`: Riorganizzazione UI, Menu di Sistema & Macro-Aree](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/completati/sottopiani/14_riorganizzazione_ui_menu_sistema_e_macro_aree.md)** [x]  
    *Competenze*: UI/UX Engineering, Screen Reader Accessibility (NVDA Zero Mouse), Simmetria Universale.  
    *Oggetto*: Architettura HUD a 5 sezioni, Top Bar fissa, Menu di Sistema su tasto `Esc` e selettore a 4 Macro-Aree tematiche.

15. **[`SP-15`: Skills, Upgrade Hub & Strumentazione](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/completati/sottopiani/15_skills_upgrade_hub_e_strumentazione.md)** [x]  
    *Competenze*: Music Economy, Lifestyle & Housing, Instrument Crafting, Rehearsal Dynamics & Studio Gear.  
    *Oggetto*: Modello dati UpgradeData, lifestyle abitativo, sala prove insonorizzata, negozio strumenti multicategoria con comparatore e hardware home studio.

### Sottopiani Attivi in Lavorazione (Fase 9 — V5.0)

*Nessun sottopiano attivo al momento. I sottopiani SP-01..SP-15 sono interamente convalidati ed archiviati. I nuovi sottopiani per la Sezione 2 della Roadmap (Creatività Musicale & Crafting Avanzato) verranno aperti al passaggio di fase.*

---

## 3. ROADMAP SEQUENZIALE OPERATIVA (CHECKBOX SPUNTABILI)

### FASE 0: Organizzazione Sistemica & Allineamento Multi-AI
- [x] `F0.1`: Analisi esplorativa completa del corpus originario di 9.357 righe.
- [x] `F0.2`: Redazione del Rapporto di Analisi e Consolidamento in [`docs/report/archivio/ANALISI_E_CONSOLIDAMENTO_WORLD_TOUR.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/report/archivio/ANALISI_E_CONSOLIDAMENTO_WORLD_TOUR.md).
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
- [x] `F8.7`: **Suite di Test Headless Globale & Collaudo Congiunto V4.0**: Collaudo congiunto definitivo della Versione 4.0 con Luca (NVDA/tastiera) e Holy Diver (monitor/mouse), verifica di integrità complessiva su 17 suite di test headless superate al 100% (0 errori e zero regressioni); chiusura formale della Versione 4.0 e transizione a Versione 5.0.

---

### FASE 9: Architettura UI a 5 Sezioni, Menu di Sistema & Espansione V5.0 (Endgame)
- [x] `F9.0`: **Riorganizzazione Architetturale UI (Top Bar Permanente, Menu Sistema Esc & 4 Macro-Aree)**: Scorporo dell'HUD orizzontale a 15 tasti; consolidamento Top Bar fissa permanente; creazione modale `SystemMenuModal` (Riprendi, Salva Partita atomico, Impostazioni volumi/voce/lingua, Torna al Menu Principale) su tasto `Esc` a riposo; selettore 4 Macro-Aree (`1` Hub Personale, `2` Creazione & Produzione, `3` Carriera & Band, `4` Skills & Upgrade con modale `UpgradesModal`) con conservazione di tutti i 15 tasti rapidi diretti storici; suite di test `test_v5_ui_overhaul.gd`. Convalidato con 18/18 suite di test headless superate al 100% con 0 errori.
- [x] `F9.1`: **Skills, Upgrade Hub & Strumentazione (`UpgradesModal`)**: Lifestyle residenziale (alloggi), sala prove insonorizzata con mitigazione stress e azione diretta prove band, negozio strumenti multicategoria (chitarre, bassi, batterie, microfoni, tastiere) con comparatore e bonus carisma/abilità, hardware home studio/registrazione per innalzamento Quality Score; fix viewport 1920x1080 e riorganizzazione dinamica della seconda barra HUD (Città | Status | Livelli). Convalidato con la nuova suite `test_upgrades_system.gd` (68 test) e 19/19 suite headless superate al 100% con 0 errori.
- [x] `F9.1B`: **Identità Protagonista & Creazione Personaggio (Sezione 1.1)**: Schermata `CharacterCreation` con nome anagrafico, nome d'arte facoltativo, selezione età (16-60), 6 strumenti musicali principali, 5 background di provenienza con bonus/malus di partenza e 5 tratti caratteriali; integrazione in `PlayerData` (con `get_effective_name()`) e biforcazione del menu principale tra "Nuova Partita" (creazione guidata) e "Modalità Test / Avvio Rapido" (Alex pre-impostato con 10 brani e 500 €). Convalidato con 39/39 test dedicati (`test_character_creation.gd`).
- [x] `F9.1C`: **Filosofia della Notte, Overtime Progressivo, Skip Time & Riposo Anticipato (Sezione 1.2)**: Ciclo virtuale espanso a 22 ore (06:00 - 04:00); eliminazione di pop-up e interruzioni bloccanti a mezzanotte; overtime progressivo non forfettario (+2 stress a 00:00, +3 a 01:00, +5 a 02:00 con avviso vocale discreto per NVDA, +10 a 03:00 con avviso discreto finale, chiusura forzata alle 04:00); controlli HUD di navigazione temporale rapida con tasti "Aspetta (X)" per saltare alla fascia oraria successiva e "Dormi (Z)" per andare a dormire in anticipo; riconoscimento bonus sonno ristoratore ed eliminazione stress in `EndDaySystem`. Convalidato con 28/28 test dedicati (`test_time_night_system.gd`).
- [x] `F9.1D`: **Triade Risorse Vitali & Recupero Attivo Diurno (Sezione 1.3)**: Integrazione fisiologica di Energia, Stress e Morale; meccanica di Burnout (< 15% energia, durata raddoppiata per azioni ordinarie, azioni di cura esenti) e Panico psicologico (>= 80% stress); modale `RelaxModal` accessibile con tasto HUD `R` ("Relax") e opzioni rapide `1` (Caffè al bar, 2.00 €, +15 energia, +5 stress), `2` (Passeggiata al parco, gratis, -15 stress, +5 morale, -5 energia) e `3` (Ascolto disco capolavoro, gratis, +20 morale, -10 stress, 35% chance Scintilla Creativa per brano nuovo); verifica fondi disponibili; test headless dedicati `test_vital_resources_system.gd` con 37/37 asserzioni superate con 0 errori.
- [x] `F9.1E`: **Creatività Musicale, Scrittura Brani & Produzione Discografica (Sezione 2)**: 10 Temi Lirici con matrice affinità genere/città (`LyricThemeData`), estensione del Quality Score con sinergia tematica (+3.5, 0.0, -1.5), 3 nuovi tratti canzone (`GENERATIONAL_ANTHEM`, `TEARJERKER_BALLAD`, `EPIC_RIFF`), sconto del 20% il Martedì sullo Studio Professionale, calibrazione hardware home studio, rielaborazione bozze in `MusicSystem`, impatto tratti su album in `AlbumSystem`, interfacce `SongCreator`, `SongCatalog` e `AlbumCreator` potenziate con annunci vocali dinamici per NVDA. Convalidato con 65/65 test dedicati (`test_advanced_crafting_system.gd`) e 23/23 suite headless del progetto superate con 0 errori. Archiviato in `docs/piani/completati/`.
- [x] `F9.1F`: **La Band, Reclutamento, Dinamiche Relazionali & Revenue Split (Sezione 3)**: Integrazione dei 5 ruoli in `BandRole` (incluso Cantante `VOCALS` per il quartetto completo), 8 personalità psicologiche in `BandPersonality` (con `MERCENARY`, `STAGE_ANXIOUS`, `NATURAL_LEADER`, `PEACEMAKER`), bacheca audizioni con rifiuto deterministico su divario abilità/reputazione, calcolo compatibilità avanzata, boost front-man vocale su Sinergia Palco live, prove di gruppo con modificatori pacificatore/perfezionista, reazioni marcate al Revenue Split (risentimento predatorio), allineamento bilingue dizionari (259 chiavi) e accessibilità NVDA in `BandHub`. Convalidato con 58/58 test dedicati (`test_band_system.gd`) e 23/23 suite headless superate al 100% con 0 errori. Archiviato in `docs/piani/completati/`.
- [x] `F9.1G`: **Strumenti Musicali, Sala Prove, Home Studio & Upgrades Hub (Sezione 4)**: Ecosistema di progressione strumentale e infrastrutturale: negozio multicategoria con comparatore dinamico e dotazione compagni di band (`equipped_gear_tier`), sound shaping con 5 pedali iconici e 2 amplificatori (Valvolare Britannico vs Pulito Americano), insonorizzazione sala prove (Tier 0..3) con mitigazione fatica/stress, gestione eventi quiete pubblica/sanzioni vigili e sub-affitto passivo giornaliero (+20 €/+50 €), filosofia registrazione studio (Nastro Analogico a bobine vs Digitale HD), usura progressiva (-8% concerti, -3% prove), incidenti palco per usura critica (<20%) con salvataggio da muletto nel van, manutenzione liutaio (ordinaria/straordinaria), modale `UpgradesModal` (tasto `U`) espansa a 5 schede con zero conflitti di tasti e lettura lineare NVDA. Convalidato con 68 test dedicati (`test_upgrades_system.gd`) e 23/23 suite headless del progetto superate con 0 errori. Archiviato in `docs/piani/completati/`.
- [x] `F9.1H`: **Concerti dal Vivo, Locali, Scaletta & Pubblico (Sezione 5)**: Espansione circuito a 6 locali (inclusi Centro Sociale Occupato e Teatro d'Opera Storico); calendario deterministico e disponibilità venue con occupazione procedurale (La Meccanica di Luca) e maggiorazione weekend (+20% affitto ven/sab); drammaturgia scaletta con ruoli brano (Opener energico, Mid-Set ballad intimo, Closer Stage Beast e Inno Generazionale) e cover di repertorio; 7 Stage Events procedurali a bivi con check abilità Carisma/Performance; banchetto Merchandising al Foyer (4 articoli, ricavi lordi/netti e ripartizione); momento Bis / Encore su score >= 85 (mance extra +50 €, bonus fan e morale band); modale `LiveConcert` (tasto `L`) accessibile al 100% per NVDA Zero Mouse. Convalidato con 92/92 test dedicati (`test_concert_system.gd`) e 23/23 suite headless del progetto superate al 100% con 0 errori.
- [x] `F9.1I`: **Geografia, Metropoli & Tournée (Sezione 6)**: Espansione rete a 12 metropoli (Dublino, Parigi, Madrid, New York, Los Angeles, Tokyo), eventi cittadini temporanei (Notte Bianca, Fiera della Musica, Festival Urbano), tratte transoceaniche con Jet Lag temporaneo, personalizzazione veicoli e diario adesivi del furgone/bus, Custom Tour Builder flessibile (2-8 date) con Day Off rigeneranti e interviste radiofoniche promozionali, 4 imprevisti di viaggio procedurali a bivi (Foratura pioggia, Autogrill 03:00, Motel economico, Smarrimento percorso), allineamento accessibile di `TravelModal` (tasto `V`) e `TourModal` (tasto `O`). Convalidato con 98 test dedicati (`test_tour_system.gd`), 64 test (`test_travel_system.gd`) e 23/23 suite headless del progetto superate con 0 errori. Collaudo NVDA superato al 100% e archiviazione formale (V4.6.0).
- [x] `F9.1L`: **Grandi Festival Estivi all'Aperto (Sezione 7)**: Circuito espanso a 12 Grandi Festival Mondiali nelle 12 metropoli della rete; contest primaverile "Battle of the Bands" (Mese 3) con emissione del Pass speciale che azzera la reputazione minima per lo Slot Pomeridiano (0.0) e la dimezza per il Tramonto (17.5); scelta del palco tra Main Stage e Tenda Underground (+50% fan, +30% merch, distensione band -10 tensione); 4 categorie di sponsor festivalieri (Integrità, Energy Drink, Birra artigianale, Streetwear) con anticipi in denaro e benefici morali; mosse sceniche estreme a bivi ad alto rischio/rendimento (Stage Diving, Scalata Americane, Assolo tra la folla); meteo outdoor con ondata di calore e bivio temporale estivo (suonare sotto la pioggia +5 score); risoluzione conflitti di orario (Time Clash); integrazione e accessibilità da tastiera NVDA in `FestivalModal` con tasti `1`..`9`, `0`, `-`, `=`, `B`, `M`, `U`, `O`, `E`, `P`, `T`, `H`, `S`. Convalidato con 123 test dedicati (`test_festival_system.gd`) e 23/23 suite headless del progetto superate con 0 errori. Collaudo NVDA superato al 100% e archiviazione formale (V4.7.0).
- [x] `F9.1M`: **Social Media, Fanbase Digitale & Stampa Musicale Avanzata (Sezione 8)**: Tendenze settimanali algoritmiche (Clip, Teaser, Backstage, Meme con bonus +40%), sponsorizzazione post a pagamento a 3 tier (100 €, 250 €, 500 €), dirette live streaming interattive con chat live e consumo energia, delega della controversia online al Manager (`D`), modello dati `FanClubData` con tesseramento, cassa quote, livello fedeltà 1..5 e raduno annuale dei fan con introiti merchandising e bonus affluenza live, aggregazione fandom territoriale (locale/nazionale/europeo/globale) in `PlayerData`, eventi posta fan ossessivi al check notturno con regali stravaganti. Nuova modale `SocialModal` accessibile al 100% per NVDA Zero Mouse con tasti rapidi `1`..`5`, `S`, `F`, `A`..`D`, `Esc`. Convalidato con 51 test dedicati (`test_advanced_social_system.gd`) e 24/24 suite headless a 0 errori.
- [x] `F9.1N`: **L'Industria Musicale, Contratti Discografici & Management (Sezione 9)**: 3 Modelli di Produzione (Autoproduzione 100%, Indie Label 45% con 8.000 € anticipo, Major 15% con 60.000 € anticipo e soglia qualità 65); recoupment debito su royalties discografiche; clausola di distribuzione fisica esclusiva (+40% vendite, 20% trattenuta); rinegoziazione contrattuale (innalzamento al 25% su rep >= 70 o Disco d'Oro); riscatto definitivo dei master dell'album per bypassare il recoupment; dinamiche relazionali manager (fiducia 0-100, promesse con scadenze, stress notturno +4.0 e chiamate alle 02:30 dello Squalo, conflitto d'interessi con trattenuta fraudolenta del 10% sui live, avvocato dello spettacolo protettivo e penale di licenziamento); endgame con fondazione della propria etichetta indipendente (`OwnLabelData`, 25.000 € capitale, rep >= 60, regime libero), talent scouting giovani band emergenti, gestione roster (fino a 3 band) e royalties passive giornaliere di catalogo; 4 nuovi dilemmi narrativi in `DilemmaSystem`; dashboard accessibile `IndustryHub` su 3 schede (`1` Contratti, `2` Manager, `3` Propria Etichetta, tasti rapidi `R`, `M`, `D`, `L`, `F`, `S`, `Esc`/`K`) al 100% NVDA Zero Mouse. Convalidato con 106 test dedicati (`test_industry_system.gd`) e 24/24 suite headless a 0 errori e 0 ms. Archiviato (Versione AVF `V4.9.0`).
- [x] `F9.1O`: **Artisti Rivali, Hit Parade & Media Broadcaster (Sezione 10)**: Relazioni umane e affinità con le 10 band rivali continentali (`RivalRelationship`), possibilità di proporre Tour Congiunti Co-Headlining (-30% costi, +35% affluenza) o dissing mediatico su BandFeed (buzz 1.60x); espansione della Hit Parade settimanale con classifiche territoriali/nazionali per le principali metropoli (`ChartScope.NATIONAL`) e meccanica del Tormentone Stagionale estivo/invernale (+35% stream per `EARWORM` e `GENERATIONAL_ANTHEM`); sottosistema Media Broadcaster & Critica Specialistica (`MediaSystem`, `MediaOutletData`) con interviste radio/podcast/TV del mattino per innalzare l'Hype dei concerti, rassegna stampa critica con voti in stelle e commenti narrativi, e interviste di riparazione post-scandalo; modale `ChartModal` ad alto contrasto espansa su 4 schede accessibili con tasti `1`..`4`, navigazione territori e interazioni dirette al 100% NVDA Zero Mouse; persistenza atomica savegame. Convalidato con 50/50 test dedicati (`test_media_and_rivals_system.gd`) e 25/25 suite headless complessive superate con 0 errori e 0 ms. Collaudo NVDA superato al 100% e archiviazione formale (Versione AVF `V4.10.0`).
- [x] `F9.2`: **Grandi Stadi, Palasport & Mega-Eventi (Sezione 11)**: Scalata delle arene da 15.000 a 65.000 spettatori (`venue_arena_national`, `venue_mega_stadium`), allestimenti scenici professionali a 4 tier (`StageProductionTier`: Palco Base, Passerella a T con +15% fan conversion, Palco 360° con +10% capienza pagante, Mega Pirotecnica con +15 Concert Score), service audio/luci con squadra di 50 roadie e logistica da superstar integrata in `ConcertSystem`. Convalidato con test dedicati e collaudo headless a 0 ms.
- [x] `F9.3`: **Certificazioni Ufficiali, World Music Awards & Legacy Finale (Sezione 11)**: Sottosistemi `AwardSystem` e `LegacySystem`. Tracciamento deterministico Dischi d'Oro, Platino e Diamante (FIMI/RIAA) per singoli e album in `PlayerData`; cerimonia annuale World Music Awards al Mese 12 con nomination e statuette; induzione Rock and Roll Hall of Fame con requisiti da leggenda; concerto d'addio celebrativo "The Last Waltz"; 4 epiloghi narrativi di fine carriera (Icona Immortale, Martire del Rock, Macchina da Soldi, Cometa Fiammeggiante). Nuova dashboard accessibile `LegacyModal` (tasto rapido `W`) su 4 schede con lettura lineare 100% NVDA Zero Mouse.
- [x] `F9.4`: **Suite di Test Headless Globale & Collaudo Congiunto V5.0**: Nuova suite `test_endgame_and_legacy_system.gd` con 87 asserzioni. Verifica complessiva congiunta su tutte le 26 suite di test con 0 errori a 0 ms, 101 file verificati sintatticamente con 0 errori, zero regressioni e release finale V5.0.0.
- [x] `F9.5`: **Sound Design Specialistico, Audio Cues, Numpad Accessibility & Statistiche Globali di Carriera (Sezione 12 - Versione AVF V5.1.0)**: Sintesi procedurale in memoria di 9 Earcons (`AudioCueType`) in formato PCM 16-bit mono 22.050 Hz senza dipendenza da asset binari esterni; volumi congelati al valore salvavita <= 0.75f (-2.5 dB) e ducking acustico automatico al 40% durante la voce NVDA; mapping completo del tastierino numerico (`Numpad Navigation System`) per operatività ad una mano (croce direzionale, interrogazione stato `KP_5`, salto a blocchi `KP_7`/`KP_9`, silenziamento istantaneo `KP_DECIMAL`); tracciamento automatico aggregato di tutte le metriche in `PlayerData.career_stats` (vita, musica, live, gloria); dashboard integrata nel `SystemMenuModal` (tasto Esc) con lettura vocale riassuntiva continua (`R`); nuova test suite `test_ui_audio_and_numpad_system.tscn` (128 test superati) e verifica al 100% su 27/27 suite headless del progetto con 0 errori e 0 ms.

---

### ROADMAP DI ESPANSIONE (V2.0 – V5.1)
- [x] `V2.0`: Sistema Band, reclutamento musicisti, dinamiche relazionali, creazione EP e Album, lifestyle e royalties di catalogo (completato e convalidato al 100%).
- [x] `V3.0`: Industria musicale, manager, etichette Indie vs Major, contratti ed eventi narrativi a bivi morali (completato e convalidato al 100%).
- [x] `V4.0`: Mondo dinamico, mercati musicali fluttuanti, festival estivi, tour interurbani, artisti rivali e social media (completato e convalidato al 100%).
- [x] `V5.0`: Endgame e Superstar mondiale, concerti negli stadi, mega-produzioni, premi alla carriera e Legacy finale (completato e convalidato al 100%).
- [x] `V5.1.0`: Sound design specialistico, earcons procedurali a volume di sicurezza (<= 0.75f) con ducking automatico (40%), Numpad Navigation System per accessibilità con una mano, statistiche globali di carriera nel SystemMenu e 27 suite headless al 100% con 0 errori a 0 ms (completato e convalidato al 100%).
