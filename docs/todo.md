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
- [ ] `F5.1`: Modulo `EconomySystem` con addebito spese fisse quotidiane (alloggio, cibo, trasporti).
- [ ] `F5.2`: Sistema di sblocco e progressione livelli di carriera (da Beginner ad Artista Locale).
- [ ] `F5.3`: Rifinitura estetica e grafica (cura visiva, allineamenti, colori WCAG per Holy Diver e utenti vedenti).
- [ ] `F5.4`: Collaudo manuale congiunto (Luca con NVDA/tastiera, Holy Diver con monitor/mouse).
- [ ] `F5.5`: Tag Git e archiviazione del piano di completamento della V1.0 Minimum Viable Game.

---

### ROADMAP DI ESPANSIONE (V2.0 – V5.0)
- [ ] `V2.0`: Sistema Band, reclutamento musicisti, dinamiche relazionali, creazione EP e Album, lifestyle approfondito.
- [ ] `V3.0`: Industria musicale, manager, etichette Indie vs Major, contratti ed eventi narrativi a bivi morali.
- [ ] `V4.0`: Mondo dinamico, mercati musicali fluttuanti, festival estivi, tour interurbani, artisti rivali e social media.
- [ ] `V5.0`: Endgame e Superstar mondiale, concerti negli stadi, mega-produzioni, premi alla carriera e Legacy finale.
