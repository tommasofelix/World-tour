# World-tour — Roadmap Globale di Approfondimento del Gioco

- Autori del progetto: Luca & Holy Diver
- Assistente AI: Antigravity (Senior AI Pair Programmer)
- Stack di riferimento: Godot Engine 4.7.2 win64, GDScript 2.0, Clean Architecture & AccessKit nativo
- Posizione file: `docs/roadmap.md`
- Stato del progetto: Fondamenta V1.0 – V4.0 e prime espansioni V5.0 (F9.0, F9.1) convalidate con 19 suite di test headless a 0 errori e collaudo NVDA al 100%.

---

## INTRODUZIONE & GUIDA ALLA COMPILAZIONE

Questo documento rappresenta la **Mappa Completa di Approfondimento** di World-tour.  
È organizzato in 12 Sezioni tematiche, ciascuna suddivisa in Sotto-sezioni gerarchiche.  

Per ogni sotto-sezione sono indicati con la massima precisione:
1. **Dettagli Tecnici & Meccaniche Già Implementate**: Il codice reale presente nel repository, le classi GDScript, le costanti numeriche, le formule matematiche e i tasti rapidi già operativi e testati.
2. **Direttrici di Espansione & Idee di Gameplay**: Le evoluzioni previste dal game design.
3. **Spazio per i Dettagli di Luca**: Un'area libera e strutturata dove Luca può aggiungere le sue note, regole di gioco, varianti, dialoghi, nuove formule o indicazioni specifiche.

Tutto il testo è formattato in modo strettamente lineare e sequenziale per la lettura ottimale tramite lo screen reader NVDA (senza grafici 2D, senza tabelle complesse, senza frecce direzionali).

---

## 1. IDENTITÀ DEL MUSICISTA, PERSONAGGIO & ROUTINE DI VITA

### 1.1 Anagrafica del Protagonista, Strumenti & Tratti Distintivi
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/player_data.gd`.
  - Dati anagrafici attuali: Nome predefinito "Alex", età 20 anni, strumento principale Chitarra Elettrica (`Enums.SkillType.INSTRUMENT`), background "Autodidatta", tratto iniziale "Carismatico".
  - Schermata modale ad alto contrasto: `ui/character/character_sheet.tscn` e `.gd`.
  - Tasto rapido HUD: Tasto `C` (vocalizzazione istantanea scheda con abilità e risorse).
  - Status di carriera: Scala da 0 a 7 gestita in `systems/career_system.gd` (`Enums.CareerTier`: Nobody, Bedroom Musician, Busker, Local Artist, Underground Hero, Indie Sensation, National Star, Global Superstar).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Scelta iniziale del background con impatto su attributi di partenza (es. Accademico di Conservatorio: +Strumento e +Composizione, ma -Carisma iniziale; Ribelle Punk: +Presenza scenica e +Resistenza allo stress, ma -Produzione; Producer Elettronico da Cameretta: +Produzione e +Composizione, ma 0 Presenza scenica).
  - Tratti caratteriali secondari sbloccabili (es. Perfezionista Ossessivo, Animale da Palco, Insonne Creativo, Timido nei Dialoghi).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 1.2 Orologio Giornaliero, Fasce Orarie & Ciclo di Fine Giornata
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo orologio: `systems/time_system.gd`.
  - Durata della giornata virtuale: Configurabile su 4 preset (`Constants.DAY_DURATION_SECONDS` = 300.0s [5 min], 600.0s [10 min], 900.0s [15 min], 1200.0s [20 min]).
  - 4 Fasce orarie (`Enums.TimePeriod`): Mattina (06:00 - 12:00), Pomeriggio (12:00 - 18:00), Sera (18:00 - 24:00), Notte / Overtime (00:00 - 06:00, durata 120s con accumulo di stress penalizzante `OVERTIME_STRESS_PENALTY` = 20).
  - Stati del gioco (`Enums.GameState`): GAMEPLAY_IDLE (libero), GAMEPLAY_BUSY (azione in corso), GAMEPLAY_PAUSED (congelato).
  - Pausa Dinamica automatica all'apertura di qualsiasi finestra modale.
  - Velocità di simulazione scalabile: Tasto `T` cicla tra 1x, 2x, 3x con annuncio NVDA. Tasto `Spazio` mette in Pausa/Play.
  - Ciclo Fine Giornata (`systems/end_day_system.gd`) e modale `DailySummary` (`ui/hud/daily_summary.tscn`): A mezzanotte calcolo automatico spese fisse, canone affitto, royalties passive, decadimento social buzz (-10%) e ripristino fisiologico notturno (`SLEEP_STANDARD_ENERGY` = 70, `SLEEP_STANDARD_STRESS_RELIEF` = 15).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Possibilità di saltare direttamente alla fascia oraria successiva o a sera quando non ci sono impegni.
  - Eventi notturni casuali durante il sonno (sogni ispiratori che regalano un'idea per un riff, insonnia da ansia pre-concerto).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 1.3 Triade Risorse Vitali: Energia, Stress & Morale
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Energia residua: [0 - 100%]. Soglia di burnout a 15% (`Constants.ENERGY_BURNOUT_THRESHOLD`). Sotto questa soglia le azioni richiedono il doppio del tempo e cala la qualità.
  - Stress accumulato: [0 - 100%]. Soglia di panico a 80% (`Constants.STRESS_PANIC_THRESHOLD`). Agisce come freno matematico esponenziale sull'efficacia delle azioni.
  - Morale dell'artista/band: [0 - 100%]. Influisce sulla probabilità di colpi di genio creativi e sull'affluenza ai live.
  - Indicatori visivi ad alto contrasto e vocalizzazione dinamica con tasto `I` (annuncio istantaneo barra superiore).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Meccaniche di recupero attivo durante il giorno (prendere un caffè al bar per recuperare energia temporanea a scapito di un lieve stress successivo, passeggiata al parco per abbassare lo stress, ascoltare un disco capolavoro per alzare il morale).
  - Effetti del morale a terra: rischio di blocco creativo totale nella scrittura brani.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 1.4 Le 7 Abilità Musicali & Formule Matematiche XP
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo abilità: `systems/skill_system.gd`.
  - Le 7 abilità (`Enums.SkillType`):
    1. Strumento (Esecuzione e tecnica esecutiva)
    2. Composizione (Armonia, riff e melodie)
    3. Scrittura Testi (Poetica, metrica e rime)
    4. Produzione (Sound engineering e missaggio)
    5. Presenza Scenica (Coinvolgimento e tenuta del palco)
    6. Carisma (Magnetismo e comunicazione)
    7. Senso degli Affari (Negoziazione, contratti e bilancio)
  - Curva XP esponenziale in `core/formulas.gd`: `Formulas.calculate_required_xp(level) = round(50.0 * (level ^ 1.35))`.
  - Rendimenti marginali decrescenti nello stesso giorno (`Constants.SATURATION`): 1a sessione 100% XP, 2a sessione 70% XP, 3a sessione 40% XP.
  - Azione Allenamento Rapido: Consumo 10 energia, guadagno 10 XP base.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Albero dei Talenti / Perk sbloccabili a soglie (Livello 25, 50, 75, 100) per ciascuna abilità (es. Carisma 50 sblocca "Ipnotizzatore di Folle"; Produzione 50 sblocca "Orecchio Assoluto").
  - Corsi privati di musica avanzati con maestri illustri a pagamento.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 1.5 Lifestyle, Spazio Vitale & Spese di Sussistenza
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo economico: `systems/economy_system.gd`.
  - Spesa giornaliera vitto base: `Constants.DAILY_FOOD_EXPENSE` = 10.0 €.
  - 4 Categorie di Alloggio (`Enums.HousingTier`):
    1. Stanzetta singola: Canone 15.0 €/giorno (`RENT_BEDROOM`).
    2. Appartamento con la Band: Canone 25.0 €/giorno totali (`RENT_SHARED_FLAT`), ripartito automaticamente tra i coinquilini della band (es. se la band è al completo paga circa 6.25 € a testa), con bonus affinità e recupero morale notturno.
    3. Loft con sala prove: Canone 50.0 €/giorno (`RENT_LOFT_STUDIO`), annulla lo stress delle prove casalinghe.
    4. Villa con studio di registrazione: Canone 150.0 €/giorno (`RENT_LUXURY_VILLA`), massimo recupero morale notturno (+12 morale) e azzeramento stress.
  - Gestione traslochi integrata nella schermata Upgrades (`UpgradesModal`, tasto `U`).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Alloggi di proprietà (possibilità di acquistare l'immobile per eliminare il canone giornaliero di affitto).
  - Arredamenti e strumenti di comfort domestico (TV, console per videogiochi, collezione di vinili rari, impianto stereo Hi-Fi).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

## 2. CREATIVITÀ MUSICALE, SCRITTURA BRANI & PRODUZIONE DISCOGRAFICA

### 2.1 Pipeline Creativa a 5 Stadi & Generi Musicali
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo di creazione: `systems/music_system.gd` e modale `ui/song_creator/song_creator.tscn`.
  - Tasto rapido HUD: Tasto `N` (Nuovo Brano) e Tasto `M` (Catalogo Brani).
  - I 6 Generi Musicali (`Enums.MusicalGenre`): Rock, Pop, Metal, Hip Hop, Elettronica, Indie.
  - I 5 Stadi di lavorazione (`Enums.SongStage`):
    1. Concept (Scelta del Genere, Titolo e Ispirazione)
    2. Composizione (Accordi e melodie basati sull'abilità Composizione)
    3. Scrittura Testo (Lirica e metrica basate su Scrittura Testi)
    4. Registrazione (Esecuzione vocale/strumentale basata su Strumento e Hardware Studio)
    5. Missaggio/Produzione (Qualità sonora basata su Produzione e Studio di registrazione)
  - Stati del brano (`Enums.SongStatus`): DRAFT (bozza), PRODUCED (master finito), RELEASED (pubblicato sul mercato).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Tematiche liriche a scelta (es. Rabbia sociale, Amore maledetto, Nostalgia giovanile, Fuga dalla realtà, Satira politica) con bonus di affinità verso determinati generi e determinate città.
  - Minigioco opzionale da tastiera per trovare il riff perfetto o la rima baciata.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 2.2 Algoritmo di Calcolo del Quality Score & Tratti Canzone
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Formula in `core/formulas.gd` (`calculate_song_quality`):
    - Peso Composizione: 25% (`SONG_SKILL_WEIGHT_COMP` = 0.25).
    - Peso Testo: 20% (`SONG_SKILL_WEIGHT_LYRICS` = 0.20).
    - Peso Esecuzione Strumento: 25% (`SONG_SKILL_WEIGHT_EXECUTION` = 0.25).
    - Peso Produzione Sonora: 20% (`SONG_SKILL_WEIGHT_PRODUCTION` = 0.20).
    - Variazione casuale controllata: intervallo +/- 4.0 punti.
    - Punteggio finale Quality Score clampato tra 1.0 e 100.0.
  - I 5 Tratti Speciali Canzone (`Enums.SongTrait`):
    1. `EARWORM` (Tormentone): +25% di streaming e ascolti nei primi 30 giorni di uscita.
    2. `CULT_CLASSIC` (Pezzo Cult): Converte il doppio dei fan ai concerti dal vivo (moltiplicatore x2.0).
    3. `STAGE_BEAST` (Bomba dal Vivo): +15% di Concert Score se posizionato come brano di chiusura nella scaletta.
    4. `AUDIOPHILE_GEM` (Gemma per Audiofili): Recensioni entusiastiche della critica specializzata (richiede Produzione >= 70).
    5. `ROUGH_DIAMOND` (Diamante Grezzo): Eccellente composizione ma resa grezza a causa di registrazione low-fi.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Nuovi tratti speciali (es. Ballata Strappalacrime, Inno da Stadio, Riff Epico, Pezzo Troppo Complesso per la Radio).
  - Interazione tra i tratti e le recensioni dei magazine musicali.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 2.3 Studio di Registrazione: Casalingo vs Professionale & Hardware
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Se si registra a casa (`use_pro_studio == false`): Il tetto massimo esecutivo di default era bloccato a 60, ma con l'integrazione di `UpgradeData.StudioHardwareTier` viene progressivamente innalzato:
    - Microfono base: Cap 60, Bonus 0.
    - Microfono a condensatore USB (400 €): Cap 75, Studio Bonus +5.
    - Preamplificatore valvolare (1.200 €): Cap 90, Studio Bonus +10.
    - Banco analogico & Mastering Suite (3.500 €): Cap rimosso a 100, Studio Bonus +15.
  - Se si affitta uno Studio Professionale: Costo variabile in denaro, ma garantisce resa esecutiva al 100% e bonus produzione.
  - Sconto del 20% per la prenotazione studio al Martedì (`Constants.TUESDAY_STUDIO_DISCOUNT`).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Diversi studi di registrazione commerciali con nomi e tariffe distinte (es. Studio Underground economico di periferia, Studio Storico analogico, Abbey Road style super-studio con tariffe a 4 zeri).
  - Ingegneri del suono con personalità e stili di missaggio unici.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 2.4 Formati di Rilascio: Singoli, EP ed Album LP
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo album: `systems/album_system.gd` e modale `AlbumCreator` (`ui/album/album_creator.tscn`), tasto rapido HUD `P`.
  - Singolo: Rilascio di 1 brano standalone per fare da trampolino iniziale.
  - EP (Extended Play): Da 3 a 5 brani (`ALBUM_EP_MIN_TRACKS` = 3, `ALBUM_EP_MAX_TRACKS` = 5). Costo di stampa e distribuzione base: 80.0 €.
  - LP (Long Play / Album Completo): Da 6 a 10 brani (`ALBUM_LP_MIN_TRACKS` = 6, `ALBUM_LP_MAX_TRACKS` = 10). Costo di produzione base: 200.0 €.
  - 3 Concept Artistici (`Enums.AlbumConcept`):
    1. CONCEPTUAL: Album tematico concettuale (+Recensioni della critica).
    2. COMMERCIAL_HIT: Orientato alle hit radiofoniche (+Vendite e stream immediati).
    3. RAW_UNDERGROUND: Registrazione grezza e verace (+Fedeltà dei fan live).
  - 4 Stili di Copertina / Artwork (`Enums.ArtworkStyle`): Minimalista, Retro Psichedelico, Dark Metal, Street Graffiti.
  - Selezione del singolo di traino (Lead Single).
  - Recensioni della critica simulate da 1.0 a 5.0 stelle, vendite Day 1 e riverbero sulla reputazione.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Uscita di singoli promozionali distanziati nel tempo prima dell'uscita del disco.
  - Ristampe deluxe con tracce demo e versioni acustiche.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 2.5 Catalogo Musicale, Vendite Day 1 & Royalties Passive
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Schermata di visualizzazione catalogo: `ui/catalog/song_catalog.tscn` e `.gd`, tasto rapido HUD `M`.
  - Tasti dedicati interni: `A` per filtrare Album ed EP, `S` per filtrare Singoli e Brani.
  - Vocalizzazione tracklist completa per NVDA.
  - Incasso automatico royalties a mezzanotte (`EndDaySystem`):
    - Tasso base per singolo, moltiplicatore EP 35% (`ALBUM_EP_ROYALTY_RATE`), moltiplicatore LP 60% (`ALBUM_LP_ROYALTY_RATE`).
    - Decadimento fisiologico nel tempo compensato dalla crescita della popolarità complessiva.
    - Se presente una band attiva, ripartizione automatica delle royalties secondo il `RevenueSplit` concordato.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Flussi di cassa separati tra vendite fisiche (CD, Vinili, Cassette) e streaming digitale (Spotify style).
  - Contratti di licenza per brani usati come colonna sonora in film, videogiochi o spot pubblicitari.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

## 3. LA BAND, RECLUTAMENTO & DINAMICHE RELAZIONALI

### 3.1 Reclutamento Compagni, Bacheca Audizioni & Ruoli
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo band: `systems/band_system.gd` e modale `BandHub` (`ui/band/band_hub.tscn`), tasto rapido HUD `G`.
  - Massimo 3 compagni reclutabili (`Constants.MAX_BAND_MEMBERS` = 3) per formare un quartetto completo insieme ad Alex.
  - 4 Ruoli Strumentali (`Enums.BandRole`):
    1. Basso (Garantisce groove e stabilità ritmica al gruppo)
    2. Batteria (Dà ritmo, potenza sonora ed energia live)
    3. Tastiere (Aggiunge atmosfera, armonie complesse e sfumature)
    4. Chitarra Ritmica (Costruisce il muro di suono e compattezza)
  - Bacheca annunci audizioni con costo di 30.0 € per provino (`BAND_AUDITION_FEE`).
  - Generazione procedurale dei candidati con nome, età, livello abilità strumento e profilo psicologico.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Audizioni con domande attitudinali al musicista per saggiare la compatibilità caratteriale prima di ingaggiarlo.
  - Possibilità di assumere turnisti a gettone per un singolo concerto o sessione studio senza vincoli associativi.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 3.2 Psicologia dei Membri: 4 Personalità Distinte
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Le 4 personalità modellate in `Enums.BandPersonality`:
    1. `RELIABLE` (L'Affidabile): Calmo, puntuale, abbassa la tensione del gruppo, non crea drammi, performance costante.
    2. `PERFECTIONIST` (Il Perfezionista): Alza la qualità delle esecuzioni in studio e live, ma accumula tensione se il gruppo sbaglia o non prova abbastanza.
    3. `WILD_PARTY` (L'Animale da Festa): Carismatico e trascinante sul palco, alza la presenza scenica, ma porta rischio di ritardi, postumi da sbronza e imprevisti.
    4. `EGO_ARTIST` (L'Ego Smisurato): Musicista di enorme talento tecnico, ma permaloso sulla scaletta, geloso della visibilità del leader e intransigente sui compensi.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Ulteriori sfumature psicologiche (es. Il Mercenario che suona solo per soldi, L'Ansioso da Palco che rischia il blocco prima di un grande concerto).
  - Eventi relazionali casuali tra i membri (es. due membri che si innamorano o che litigano per motivi extra-musicali).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 3.3 Indicatori Vitali di Gruppo: Affinità, Rispetto & Tensione Critica
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - I 3 indicatori [0 - 100%]:
    - Affinità Umana (La chimica personale e l'amicizia tra i membri).
    - Rispetto Musicale (La stima professionale verso le capacità di Alex e degli altri).
    - Tensione Interna (Il livello di attrito e conflittualità).
  - Soglie di tensione:
    - Livello Sicuro: < 40% (`BAND_TENSION_SAFE`).
    - Livello di Allerta: > 70% (`BAND_TENSION_WARNING`).
    - Livello Critico: > 85% (`BAND_TENSION_CRITICAL`). A questo livello, ogni evento negativo o concerto andato male può innescare l'abbandono immediato del membro.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Riunioni di chiarimento e cene di gruppo per sbollire la rabbia e riconciliare i membri prima di un tour.
  - Ultimatum posti dai membri ("O cacci lui, o me ne vado io").
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 3.4 Prove di Gruppo, Sala Prove Insonorizzata & Sinergia Live
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Metodo `hold_rehearsal_session()` in `BandSystem`:
    - Consumo energia di Alex: 15 punti.
    - Generazione stress legata all'insonorizzazione della sala: Garage +10 stress, Pannelli base +7, Isolamento pro +4, Master Studio 0 stress.
    - Incremento Affinità (+3/+5), incremento Rispetto (+4/+6), riduzione drastica della Tensione (-8/-15 punti).
  - Moltiplicatore speciale al Mercoledì: +20% guadagno XP per la band (`Constants.WEDNESDAY_BAND_XP_MULT`).
  - Sinergia Palco: Valore dinamico calcolato da [-15% a +25%] che va a moltiplicare il punteggio complessivo dei concerti dal vivo.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Creazione di cori e armonie vocali durante le prove.
  - Sessioni di composizione collettiva dove la band contribuisce alla stesura di nuovi pezzi.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 3.5 Politiche di Incasso (Revenue Split) & Riconoscimenti
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Le 3 politiche in `Enums.RevenueSplit`:
    1. `EQUAL_SPLIT` (Paritaria): 25% a testa su tutti i membri. Genera rispetto e abbassa la tensione, ma riduce il guadagno netto di Alex.
    2. `LEADER_BALANCED` (Equilibrata): 40% ad Alex (fondatore/leader) e 20% a ciascuno dei 3 compagni. Assetto stabile e generalmente accettato.
    3. `LEADER_PREDATORY` (Predatoria): 70% ad Alex e 10% a testa ai compagni. Massimizza i profitti del leader, ma genera accumulo continuo di tensione e malcontento.
  - Applicata automaticamente su: incassi dei concerti, royalties degli album, vendite merch e anticipi discografici.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Ripartizione personalizzata percentuale per ciascun membro in base all'anzianità nel gruppo.
  - Sciopero della band se la politica predatoria viene mantenuta troppo a lungo con contratti importanti.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

## 4. STRUMENTI MUSICALI, SALA PROVE, HOME STUDIO & UPGRADES HUB

### 4.1 Negozio Strumenti Multicategoria & Comparatore
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/upgrade_data.gd`.
  - Schermata modale: `ui/upgrades/upgrades_modal.tscn` e `.gd`, tasto rapido HUD `U`.
  - 5 Famiglie Strumentali:
    1. Chitarre (Chitarra Elettrica Entry-Level, Vintage Solid Body, Custom Shop Master Signature)
    2. Bassi (Basso 4 Corde Starter, Basso Attivo Pro, Signature Vintage)
    3. Batterie (Kit Elettronico Compatto, Batteria Acustica in Betulla, Master Custom Touring Kit)
    4. Microfoni / Voce (Microfono Dinamico Base, Microfono da Palco Wireless, Condensatore Valvolare Gold)
    5. Tastiere / Synth (Tastiera MIDI Base, Workstation 88 Tasti Pesati, Sintetizzatore Analogico Iconico)
  - 4 Tier di Qualità (0: Starter, 1: Semi-Pro, 2: Pro Vintage, 3: Master Signature).
  - Comparatore dinamico di statistiche: Calcola e visualizza per NVDA la differenza con lo strumento posseduto (+Tecnica Strumento, +Carisma Scenico, +Sinergia Band).
  - Vantaggi estesi a tutta la band quando Alex equipaggia i suoi musicisti.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Pedali d'effetto singoli e pedalboard (Overdrive, Distorsione High-Gain, Chorus, Delay a nastro, Wah-Wah).
  - Amplificatori valvolari storici con caratteristiche sonore distinte (calore valvolare britannico vs pulito americano cristallino).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 4.2 Insonorizzazione della Sala Prove & Trattamento Acustico
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - I 4 Livelli di Trattamento (`UpgradeData.RehearsalTier`):
    - Livello 0: Garage Rumoroso (Costo 0 €, Stress prova +10).
    - Livello 1: Pannelli Fonoassorbenti Base (Costo 300 €, Stress prova +7, -30% affaticamento).
    - Livello 2: Insonorizzazione Professionale (Costo 800 €, Stress prova +4, +5% affinità band).
    - Livello 3: Studio Acustico Perfetto & Lounge (Costo 2.000 €, Stress prova azzerato a 0, +8 morale, massima coesione).
  - Pulsante diretto "Fai una Prova con la Band" integrato direttamente nella scheda Upgrades per un ciclo d'azione rapido.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Possibilità di affittare la propria sala prove ad altre band locali per generare entrate passive quando non la si usa.
  - Reclami dei vicini e multe dei vigili urbani se si prova ad alto volume senza insonorizzazione.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 4.3 Hardware Home Studio & Tecnologie Audio Casalinghe
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - I 4 Livelli di Studio Hardware (`UpgradeData.StudioHardwareTier`):
    - Livello 0: Microfono Integrato Base (Cap massimo esecuzione 60, Bonus produzione 0).
    - Livello 1: Microfono a Condensatore & Interfaccia USB (Costo 400 €, Cap esecuzione 75, Studio Bonus +5).
    - Livello 2: Preamplificatore Valvolare & Monitor da Studio (Costo 1.200 €, Cap esecuzione 90, Studio Bonus +10).
    - Livello 3: Banco Mixer Analogico & Suite Mastering (Costo 3.500 €, Cap rimosso a 100, Studio Bonus +15).
  - Impatto matematico diretto nel metodo `record_tracks()` di `MusicSystem`.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Scelta tra registrazione in analogico su nastro magnetico (più costosa, suono caldo con bonus al genere Rock/Indie) e registrazione digitale in alta definizione (suono chirurgico, ideale per Pop/Elettronica/Metal).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 4.4 Usura, Setup Liuteria & Manutenzione Strumentale
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Gli strumenti acquistati mantengono le loro statistiche nel salvataggio permanente (`SaveManager`).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Sistema di usura delle corde e dell'elettronica dopo un certo numero di concerti dal vivo o ore di prove.
  - Visite dal liutaio di fiducia per rettifica tasti, cambio corde ed intonazione per prevenire corde rotte sul palco.
  - Strumenti di riserva ("Muletti") da portare nel baule durante i live.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

## 5. CONCERTI DAL VIVO, LOCALI, SCALETTA & PUBBLICO

### 5.1 Il Circuito dei Locali: Dal Garage ai Club di Tendenza
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/venue_data.gd`.
  - Catalogo locali base:
    1. `venue_garage` (Garage / Cantina): Capienza 15 spettatori, affitto 0 €, requisiti 0, prezzo equo 0 €.
    2. `venue_pub` (Pub / Birreria di Periferia): Capienza 60 spettatori, affitto 50 €, requisiti popolarità 5.0, prezzo equo 5.0 €.
    3. `venue_small_club` (Piccolo Club Underground): Capienza 180 spettatori, affitto 250 €, requisiti popolarità 20.0, prezzo equo 12.0 €.
    4. `venue_trendy_club` (Club di Tendenza): Capienza 450 spettatori, affitto 700 €, requisiti popolarità 40.0, prezzo equo 22.0 €.
  - Locali dedicati presenti all'interno di ciascuna delle 6 città della rete geografica.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Centri Sociali / Spazi Occupati con pubblico underground molto partecipe ma poco incline a pagare biglietti cari.
  - Teatri d'Opera storici per concerti acustici raffinati con biglietti a prezzo premium.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 5.2 Preparazione Live: Soundcheck, Prezzo Biglietto & Scaletta
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo live: `systems/concert_system.gd` e modale `LiveConcert` (`ui/concert/live_concert.tscn`), tasto rapido HUD `L`.
  - Configurazione: Selezione locale, impostazione prezzo biglietto, soundcheck pre-concerto.
  - Selezione scaletta: Da 1 a 4 brani scelti tra le canzoni prodotte o rilasciate della band.
  - Moltiplicatori affluenza legati ai giorni della settimana (`Constants`):
    - Venerdì: +50% affluenza (`WEEKEND_FRIDAY_AUDIENCE_MULT` = 1.50).
    - Sabato: +100% affluenza (`WEEKEND_SATURDAY_AUDIENCE_MULT` = 2.00) e +50% conversione fan (`WEEKEND_SATURDAY_FAN_MULT` = 1.50).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Ordine drammaturgico della scaletta: Apripista esplosivo, momento intimo a metà concerto, gran finale.
  - Possibilità di suonare cover famose di altre band per scaldare il pubblico nei locali difficili.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 5.3 Motore del Concerto: Stage Events Procedurali & Bivi
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Algoritmo di affluenza calcolato su: Popolarità, prezzo rispetto al prezzo equo del locale, giorno della settimana e moltiplicatore `social_buzz`.
  - Calcolo del Concert Score in `core/formulas.gd`:
    - Presenza scenica (30%), Carisma (25%), Qualità media brani in scaletta (25%), Energia residua (10%), Variazione casuale (+/- 5.0).
  - Eventi di palco procedurali (`Enums.StageEventType`):
    - `BROKEN_STRING` (Corda spezzata): Bivio tra cambiare chitarra al volo o improvvisare col carisma.
    - `AUDIO_FEEDBACK` (Fischio monitor): Bivio tra sfuriata col fonico o battuta simpatica al microfono.
    - `ENTHUSIASTIC_FAN` (Fan che invade il palco): Bivio tra abbraccio/duetto scenico o chiamata della sicurezza.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Nuovi imprevisti: Blackout elettrico a metà ritornello, cori da stadio spontanei della folla, rissa tra il pubblico che minaccia di interrompere lo show, stage diving / crowd surfing riuscito o disastroso.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 5.4 Chiusura Show (Closer Bonus), Merchandising & Conversione Fan
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Closer Bonus: Se l'ultimo brano in scaletta possiede il tratto `STAGE_BEAST`, scatta un bonus immediato del +15% sul punteggio finale del concerto.
  - Formula conversione fan esponenziale: `Formulas.calculate_fan_conversion = base_conversion * ((concert_score / 50.0) ^ 2.2)`. Se presente un brano con tratto `CULT_CLASSIC`, la conversione raddoppia (x2.0).
  - Ripartizione territoriale: I fan conquistati vengono assegnati per l'85% alla città in cui si è tenuto il concerto e per il 15% come riverbero nazionale/globale.
  - Incasso sbigliettamento: Biglietti venduti per prezzo, al netto del costo di affitto del locale, spartito con la band secondo il `RevenueSplit`.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Banchetto del merchandising allestito nel foyer (scelta dei prodotti da stampare: magliette, cappellini, adesivi, poster autografati, plettri personalizzati).
  - Momento bis / encore richiesto a gran voce dal pubblico se il punteggio del concerto supera 85 punti.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

## 6. GEOGRAFIA, METROPOLI & TOURNÉE

### 6.1 Rete delle 6 Città Europee & Affinità Musicali di Scena
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/city_data.gd`.
  - Modulo di viaggio: `systems/travel_system.gd` e modale `TravelModal` (`ui/travel/travel_modal.tscn`), tasto rapido HUD `V`.
  - Le 6 Metropoli Continentali (`Enums.CityId`):
    1. Milano (Italia): Capitale della moda e dell'industria discografica, affinità Rock ed Elettronica (+20%).
    2. Bologna (Italia): Capitale universitaria e culla alternativa, forte affinità Indie e Rock (+25%).
    3. Roma (Italia): Città eterna, grandi arene, affinità Pop e Rock d'autore (+20%).
    4. Napoli (Italia): Calore mediterraneo, passione viscerale, affinità Hip Hop e crossover (+25%).
    5. Londra (Regno Unito, Internazionale): Patria del Rock e della New Wave, affinità Rock e Metal (+30%), richiede reputazione minima 40.0.
    6. Berlino (Germania, Internazionale): Capitale dell'avanguardia underground, affinità Elettronica ed Industrial (+35%), richiede reputazione minima 45.0.
  - Sintesi vocale con descrizione completa delle affinità e locali premendo i tasti `1`..`6`.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Inserimento di nuove città iconiche (Dublino per il Folk/Rock celtico, Parigi per la Chanson e l'Electro-House, Madrid, New York, Los Angeles, Tokyo).
  - Eventi cittadini temporanei (es. Notte Bianca con concerti in tutte le piazze, Fiera Internazionale della Musica).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 6.2 Matrice di Viaggio, Costi Logistici & Mezzi di Trasporto
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Matrice delle distanze e costi chilometrici tra le 6 città (viaggi nazionali economici da 30-80 €, viaggi internazionali con traghetto/treno da 150-250 €).
  - Consumo energetico e stress da viaggio calibrati sul tragitto.
  - Le 3 Tipologie di Veicolo per Tournée (`Enums.TourVehicleType`):
    1. `RUSTY_VAN` (Furgone Scassato): Costo noleggio nullo/bassissimo, ma genera +15 stress a tappa e presenta probabilità di guasto meccanico imprevisto.
    2. `PRO_VAN` (Van Professionale): Costo equilibrato (500 € a tour), genera solo +5 stress a tappa, affidabile.
    3. `LUXURY_BUS` (Tour Bus di Lusso): Costo elevato (2.000 € a tour), cuccette per riposare, zero stress aggiunto, rigenera leggermente il morale tra una tappa e l'altra.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Viaggi aerei intercontinentali con gestione del jet lag.
  - Personalizzazione grafica del furgone della band con logo e adesivi delle città visitate.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 6.3 Pianificazione del Tour Multi-Tappa & Hype a Catena
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo tour: `systems/tour_system.gd` e modale `TourModal` (`ui/tour/tour_modal.tscn`), tasto rapido HUD `O`.
  - Strutturazione di tournée a tappe concatenate (es. Tour Italiano 3 tappe, Tour Europeo 5 tappe).
  - Meccanica dell'Hype Progressivo a Catena: Ogni concerto concluso con successo eccellente conferisce un accumulo di +5% di Hype, che si riflette come moltiplicatore sull'affluenza di pubblico delle date successive.
  - Sincronizzazione automatica con l'agenda del calendario (`ScheduleSystem`).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Possibilità di inserire giornate di riposo (Day Off) tra due date consecutive per recuperare energia ed evitare il burnout.
  - Interviste promozionali alle stazioni radio locali la mattina stessa del concerto.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 6.4 Gestione della Stanchezza On the Road & Imprevisti di Viaggio
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Calcolo della fatica cumulativa della band lungo le tappe consecutive.
  - Aumento della tensione interna tra i membri se il veicolo è angusto e si viaggia per giorni senza riposo.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Eventi narrativi casuali di viaggio: Foratura gomma in autostrada sotto la pioggia, sosta in autogrill alle tre di notte con incontri bizzarri, motel economico con aria condizionata rotta o stanze infestate, smarrimento del percorso senza navigatore.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

## 7. GRANDI FESTIVAL ESTIVI ALL'APERTO

### 7.1 Stagione Estiva dei Festival (Mesi 4-6) & Cartelloni
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/festival_event.gd`.
  - Modulo festival: `systems/festival_system.gd` e modale `FestivalModal` (`ui/festival/festival_modal.tscn`), tasto rapido HUD `F`.
  - Stagione estiva rigorosa: Attiva durante i mesi estivi (Mesi 4, 5 e 6 / Giorni dall'85 al 168 del calendario).
  - Cartelloni ufficiali organizzati nelle 6 metropoli europee con date fisse, requisiti minimi di reputazione e cachet garantito.
  - Influenza del Manager: Se si dispone di un manager professionista o squalo, i requisiti di accesso vengono abbattuti e il cachet garantito aumenta sensibilmente.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Grandi festival tematici leggendari (es. Download Fest per il Metal, Glastonbury / Primavera Sound per l'Indie, Love Parade / Awakenings per l'Elettronica).
  - Contest per band emergenti ("Battle of the Bands") in primavera per conquistare l'accesso ai festival estivi.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 7.2 I 3 Slot Orari di Esibizione: Apertura, Tramonto, Headliner
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - I 3 Slot orari (`Enums.FestivalSlot`):
    1. `OPENING_AFTERNOON` (Slot Pomeridiano di Apertura): Ore 15:00 - 17:00. Sole cocente, pubblico ancora scarso e dispersivo, serve grande fatica per scaldare la folla.
    2. `SUNSET_SLOT` (Slot al Tramonto / Golden Hour): Ore 18:30 - 20:30. Atmosfera magica, folla stipata, ottima visibilità e cachet raddoppiato.
    3. `HEADLINER_NIGHT` (Headliner Notturno): Ore 22:00 - 00:00. Il palco principale, massimo prestigio, folla oceanica, giochi di luce spettacolari e cachet faraonico.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Palchi secondari / Tende underground dove il pubblico è più ristretto ma estremamente appassionato.
  - Conflitto di orari con una band leggendaria che suona contemporaneamente su un altro palco.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 7.3 Meccanica Competitiva "Rubare la Scena" (*Steal the Show*)
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Algoritmo di confronto diretto: La performance di Alex e compagni viene confrontata con le band rivali presenti sullo stesso cartellone del festival.
  - Se il punteggio del concerto supera le aspettative di oltre il 20%, scatta l'evento "Hai Rubato la Scena!":
    - Bonus immediato del +30% sui nuovi fan convertiti.
    - Balzo straordinario della reputazione nazionale.
    - Impennata del morale al 100% per tutta la band.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Mosse sceniche estreme per rubare la scena (es. arrampicarsi sulle impalcature del palco, assolo di chitarra in mezzo alla folla, duetto improvvisato con un ospite illustre).
  - Reazioni invidiose delle band rivali nel backstage dopo lo show.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 7.4 Moltiplicatori Merchandising Intensivo & Sponsorizzazioni
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Moltiplicatore vendite merch intensivo: Data la presenza di migliaia di persone radunate nell'area festival, le entrate dalla vendita di magliette e gadget passano da x2.5 fino a x5.5 rispetto a un locale standard.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Stand di merchandising esclusivo con grafica creata appositamente per il festival.
  - Sponsorizzazioni di bibite energetiche, birre o marchi di streetwear che offrono bonus in denaro se la band cita il marchio o indossa i loro vestiti sul palco.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

## 8. SOCIAL MEDIA, FAN ENGAGEMENT & VIRALITÀ (BANDFEED)

### 8.1 Piattaforma Social BandFeed & 4 Tipologie di Post
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/social_post_data.gd`.
  - Modulo social: `systems/social_media_system.gd` e modale `SocialModal` (`ui/social/social_modal.tscn`), tasto rapido HUD `Y`.
  - Le 4 Tipologie di Contenuto (`Enums.SocialPostType`):
    1. `PRACTICE_CLIP` (Clip delle Prove): Video brevi di Alex e compagni mentre provano in sala. Alta credibilità musicale.
    2. `TRACK_TEASER` (Teaser di un Brano): Anteprima di 15 secondi di un singolo o disco in arrivo. Genera attesa e hype per il rilascio.
    3. `BEHIND_THE_SCENES` (Dietro le Quinte / Vita da Band): Scorci informali della vita in furgone, pause caffè e scherzi nel backstage. Aumenta l'affetto dei fan.
    4. `PROVOCATION` (Post Provocatorio / Meme): Meme ironico o presa di posizione tagliente contro il sistema o l'industria. Alto potenziale virale ma rischio shitstorm.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Dirette live streaming interattive dove rispondere alle domande dei fan in tempo reale.
  - Teaser con countdown prima dell'uscita di un video musicale ufficiale.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 8.2 Algoritmo di Visualizzazioni, Viralità & Conversione Follower
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Calcolo delle visualizzazioni: Funzione di Carisma, Popolarità attuale e base di follower preesistente.
  - Meccanica di viralità procedurale: Probabilità che un post esploda e raggiunga un pubblico 10x superiore alla norma.
  - Conversione follower in fan fisici: I follower digitali vengono convertiti in veri fan paganti legati alla città corrente (tramite `TravelSystem`), aumentando la penetrazione locale del gruppo.
  - Indicatore dinamico `social_buzz` [1.0x - 2.50x]: Moltiplicatore che incrementa l'affluenza di pubblico nei concerti live successivi.
  - Decadimento notturno: A mezzanotte in `EndDaySystem` il `social_buzz` decade fisiologicamente del 10%, richiedendo attività social costante per mantenere l'hype alto.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Campagne di sponsorizzazione a pagamento sui social (investire 100-500 € per spingere un post e raggiungere non-follower).
  - Algoritmi di tendenza che cambiano periodicamente (es. settimana in cui i video di assoli vanno più virali dei meme).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 8.3 Gestione delle Crisi Reputazionali & Shitstorm a 3 Bivi
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Quando un post provocatorio o un evento live finisce al centro di una bufera mediatica online, scatta l'interfaccia di crisi con 3 scelte strategiche:
    - Bivio 0 (`Ignora`): Si lascia sgonfiare la polemica senza intervenire. Impatto neutro, l'attenzione svanisce col tempo ma si perde un po' di carisma.
    - Bivio 1 (`Scuse Formali`): Comunicato stampa di scuse istituzionali. Recupera reputazione tra gli addetti ai lavori e rassicura la casa discografica, ma delude i fan punk/ribelli provocando un calo di morale.
    - Bivio 2 (`Raddoppia la Posta / Double Down`): Attacco frontale contro i critici. Esplosione di visualizzazioni virali e idolatria da parte della fanbase più estrema (+Fan e +Carisma), ma rischio di cancellazione date da parte dei gestori di club perbenisti (-Reputazione e cancellazione di un live).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Interventi del manager che cerca di strappare il telefono di mano ad Alex per impedirgli di twittare di notte.
  - Interviste tv di riparazione o speciali radiofonici dedicati al dibattito generato.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 8.4 Fandom Territoriale vs Globale & Relazione con i Fan Club
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Tracciamento della fanbase diviso metropoli per metropoli e calcolo del totale nazionale/europeo.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Fondazione del Fan Club Ufficiale della band con elezione del presidente del fan club.
  - Raduni annuali con i fan e sessioni di autografi esclusive.
  - Lettere e regali bizzarri ricevuti dai fan più ossessivi via posta.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

## 9. L'INDUSTRIA MUSICALE, CONTRATTI & MANAGEMENT

### 9.1 I 3 Modelli Produttivi: Autoproduzione, Indie, Major
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/contract_data.gd`.
  - Modulo industria: `systems/industry_system.gd` e dashboard `ui/industry/industry_dashboard.tscn`, tasto rapido HUD `K`.
  - I 3 Livelli Contrattuali (`Enums.ContractType`):
    1. `SELF_RELEASED` (Autoproduzione): Zero vincoli, 100% royalties all'artista (`CONTRACT_SELF_ROYALTY_RATE` = 1.00), ma zero anticipi liquidi e tutti i costi a carico di Alex.
    2. `INDIE_LABEL` (Etichetta Indipendente): Anticipo modesto (default 8.000 € `CONTRACT_INDIE_ADVANCE_DEFAULT`), royalties al 45% (`CONTRACT_INDIE_ROYALTY_RATE` = 0.45), obbligo di 2 album (`CONTRACT_INDIE_ALBUMS_REQ` = 2), grande libertà artistica.
    3. `MAJOR_LABEL` (Major Multinazionale): Anticipo enorme (default 60.000 € `CONTRACT_MAJOR_ADVANCE_DEFAULT`), royalties solo al 15% (`CONTRACT_MAJOR_ROYALTY_RATE` = 0.15), obbligo di 3 album (`CONTRACT_MAJOR_ALBUMS_REQ` = 3), vincolo di qualità minima 65.0 punti (`CONTRACT_MAJOR_MIN_QUALITY`) e forte pressione dai dirigenti A&R.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Fondazione di una propria etichetta discografica indipendente nell'endgame, mettendo sotto contratto altre giovani band emergenti.
  - Clausole di distribuzione fisica esclusiva nei negozi di dischi di tutto il continente.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 9.2 Anticipi Liquidi, Debito di Recupero (Recoupment) & Royalties
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Meccanismo del Recoupment: L'anticipo incassato alla firma costituisce un debito contabile verso l'etichetta.
  - Tutte le royalties generate dalle vendite e dallo streaming dei brani vengono automaticamente trattenute dall'etichetta per estinguere il debito di recupero.
  - Solo una volta azzerato il debito, le royalties nette riprendono a essere versate sul conto bancario della band.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Rinegoziazione del contratto discografico in caso di successo straordinario (minacciare di non consegnare il master se non alzano le royalties al 25%).
  - Riscatto dei Master originali delle canzoni per rientrare in possesso dei propri diritti a vita.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 9.3 Figure di Management: Amico Fidato, Professionista, Squalo
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/manager_data.gd`.
  - I 3 Profili di Manager (`Enums.ManagerType`):
    1. `TRUSTED_FRIEND` (L'Amico Fidato): Quota ingaggio 50 €, provvigione solo 10%, moltiplicatore cachet live 1.10x, zero stress generato (anzi alleggerisce lo stress di 1.0 punto). Poche connessioni di alto livello.
    2. `PRO_INDIE` (Il Professionista Indipendente): Quota ingaggio 400 €, provvigione 15%, moltiplicatore cachet live 1.25x, apre le porte dei club migliori, riduce lo stress organizzativo di 2.5 punti.
    3. `INDUSTRY_SHARK` (Lo Squalo dell'Industria): Quota ingaggio 2.000 €, provvigione 22%, moltiplicatore cachet live 1.50x, accesso garantito ai festival estivi, ma genera continuo stress notturno (+4.0 stress a notte) con telefonate e richieste pressanti.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Possibilità di licenziare il manager in caso di divergenze, con gestione della penale di rescissione.
  - Tradimento del manager: rischio che uno squalo scappi con una parte degli incassi se la band non ha un avvocato.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 9.4 Bivi Etico-Narrativi dell'Industria
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/dilemma_data.gd` e modulo `systems/dilemma_system.gd`.
  - Eventi periodici a scelta multipla con impatti deterministici su: Soldi, Reputazione, Fan, Morale, Stress e Tensione Band.
  - Le 4 Categorie di Bivio (`Enums.DilemmaCategory`):
    1. `COMMERCIAL_ETHICS` (Etica Commerciale): Es. Offerta da 5.000 € per cedere una propria canzone a uno spot di un marchio inquinante o di fast food.
    2. `BAND_INTERNAL` (Conflitti Interni): Es. L'etichetta propone ad Alex di abbandonare la band per lanciarsi come solista.
    3. `MEDIA_SCANDAL` (Scandali e Gossip): Es. Pagare un ufficio stampa per inventare una finta lite con una celebrità per finire sui giornali.
    4. `ARTISTIC_INTEGRITY` (Integrità Artistica): Es. Richiesta del direttore artistico di modificare il testo di un brano ritenuto "troppo politico" per farlo passare in radio.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Bivi a catena (conseguenze a lungo termine: es. la band rifiuta lo spot e anni dopo un'associazione ambientalista organizza un concerto tributo a loro favore).
  - Cause legali per plagio da difendere in tribunale.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

## 10. ARTISTI RIVALI, HIT PARADE & CLASSIFICHE MUSICALI

### 10.1 Il Catalogo delle 10 Band Rivali Continentali
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/rival_data.gd` e modulo `systems/rival_system.gd`.
  - Le 10 Band Rivali con città, generi, carriera, singoli ed album attivi:
    1. `The Chrome Shadows`: Milano, Rock/Elettronica, Tier Indie Sensation, Singolo "Neon Mirage", Album "Overdrive City".
    2. `I Ribelli del Pratello`: Bologna, Indie/Rock, Tier Local Artist, Singolo "Portici Rossi", Album "Sottovoce EP".
    3. `Colosseo Sound Machine`: Roma, Pop/Rock melodico, Tier Indie Sensation, Singolo "Travertino Beat", Album "Tramonto Imperiale".
    4. `Vesuvio Posse`: Napoli, Hip Hop/Crossover, Tier Indie Sensation, Singolo "Fumo e Lava", Album "Spaccanapoli Sound".
    5. `Royal Camden Vanguard`: Londra, Metal/Hard Rock, Tier National Star, Singolo "Thames Riot", Album "Crown of Rust".
    6. `Klangwerk Berlin`: Berlino, Elettronica/Industrial, Tier National Star, Singolo "Beton Tanz", Album "Nachtschicht".
    7. `The Silver Strings`: Milano, Pop Acustico, Tier Busker, Singolo "Gocce di Pioggia", Album "Sussurri Acustici".
    8. `Bologna Wave`: Bologna, Elettronica/Synthpop, Tier Local Artist, Singolo "Notte Rossa", Album "Frequenze Urbane".
    9. `London Fog`: Londra, Indie Rock/Shoegaze, Tier Indie Sensation, Singolo "Mist & Shadows", Album "Streets of London".
    10. `Berliner Mauer Beat`: Berlino, Hip Hop/Underground, Tier Local Artist, Singolo "Graffiti Wall", Album "Ostkreuz Sessions".
- **Direttrici di Espansione & Idee di Gameplay**:
  - Relazioni interpersonali con i leader dei rivali (rispetto reciproco, amicizia sincera o rivalità velenosa).
  - Possibilità di organizzare un tour congiunto a doppio cartellone (*Co-Headlining Tour*) con una band rivale amica.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 10.2 Hit Parade Settimanale: Top 10 Singoli e Top 10 Album
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/chart_entry_data.gd` e modulo `systems/chart_system.gd`.
  - Schermata modale ad alto contrasto: `ui/chart/chart_modal.tscn` e `.gd`, tasto rapido HUD `H`.
  - Tasti interni: `1` per visualizzare la Top 10 Singoli, `2` per la Top 10 Album, `R` per la scheda dettagliata del Rivale.
  - Simulazione settimanale ogni Domenica notte (`Weekday.SUNDAY`) in `EndDaySystem`.
  - Tracciamento dinamico per ogni brano/album:
    - Posizione attuale [1 - 10]
    - Posizione precedente con indicatore di movimento: Nuova entrata (`NEW`), Salita (`▲`), Discesa (`▼`), Stabile (`=`)
    - Settimane di permanenza in classifica
    - Posizione di picco storico raggiunta
- **Direttrici di Espansione & Idee di Gameplay**:
  - Allargamento della classifica a Top 20 o Top 40.
  - Classifiche separate per singolo Paese (Hit Parade Italia, Regno Unito, Germania) oltre alla classifica continentale europea.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 10.3 Algoritmo di Stream, Vendite Fisiche & Conquista del Numero 1
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Formula calcolo vendite/stream del giocatore: Basata su Quality Score del brano/disco, Fanbase totale, Popolarità e moltiplicatore `social_buzz`.
  - Se il brano o l'album supera tutti i concorrenti e raggiunge la posizione #1:
    - Scatta l'evento trionfale "Hai conquistato il Primo Posto in Classifica!".
    - Bonus straordinario a reputazione (+15.0), incremento fan e morale al 100%.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Competizione feroce per la "Canzone di Natale" o il "Tormentone Estivo dell'Anno".
  - Meccaniche di boicottaggio o guerre di streaming tra fandom rivali.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 10.4 Faide tra Artisti, Dissing & Riconoscimenti Speciali
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Livello di rivalità tracciato in `RivalData`: 0 = Neutro/Rispetto a distanza, 1 = Competizione accesa, 2 = Faida mediatica aperta.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Dissing su BandFeed: Possibilità di pubblicare un brano o un post che prende di mira un rivale specifico per scalare le classifiche grazie alla curiosità del pubblico.
  - Evento di riconciliazione sul palco durante un grande festival con duetto a sorpresa.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

## 11. ENDGAME, GRANDI STADI & LEGACY MONDIALE (FASE 9 / V5.0)

### 11.1 Scalata delle Grandi Arene & Stadi Mondiali (15.000 - 80.000 Spettatori)
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Tier di carriera finale `Enums.CareerTier.GLOBAL_SUPERSTAR` già codificato nelle costanti.
  - Apertura e pianificazione della Fase 9 in `docs/todo.md` (`F9.2`).
- **Direttrici di Espansione & Idee di Gameplay**:
  - Grandi Arene e Palasport (10.000 - 20.000 posti, es. Forum di Assago, O2 Arena di Londra).
  - Grandi Stadi Mondiali (50.000 - 80.000 spettatori, es. San Siro a Milano, Stadio Olimpico a Roma, Wembley Stadium a Londra, Olympiastadion a Berlino).
  - Costi di affitto e allestimento mastodontici (50.000 - 200.000 € a serata) con incassi milionari.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 11.2 Mega-Allestimenti Scenici, Pirotecnica & Service Professionale
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Architettura di supporto pronta per accogliere nuovi tier di produzione scenica.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Selezione del palco: Passerella a T che entra nel prato, palchi rotanti, piattaforme idrauliche sopraelevate.
  - Effetti scenici: Lanciafiamme sincronizzati col ritornello, muri di laser a 360 gradi, cannoni sparacoriandoli, maxischermi LED trasparenti ad altissima risoluzione.
  - Convoglio di 15-20 bilici e squadra di 50 roadie e tecnici audio/luci professionisti al seguito.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 11.3 Certificazioni Ufficiali: Dischi d'Oro, Platino, Diamante & Music Awards
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Tracciamento delle vendite complessive per singolo e per album già persistito in `SaveManager`.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Soglie per le Certificazioni Ufficiali:
    - Disco d'Oro: 25.000 copie / 10 milioni di stream.
    - Disco di Platino: 50.000 copie / 25 milioni di stream.
    - Disco di Diamante: 500.000 copie / 100 milioni di stream.
  - Cerimonia annuale dei "World Music Awards" con nomination per Miglior Album, Miglior Canzone, Miglior Band Live dell'Anno.
  - Consegna delle targhe dorate da appendere alle pareti del proprio loft o villa.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 11.4 Hall of Fame, Eredità Storica, Pensione Musicale & Finale di Gioco
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Stato di gioco `Enums.GameState.GAME_OVER` e condizioni di fine partita pianificate in `F9.3`.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Induzione nella "Rock and Roll Hall of Fame" al raggiungimento dei traguardi massimi di carriera.
  - Concerto d'addio finale ("The Last Waltz") che conclude la modalità carriera.
  - Schermata finale di bilancio dell'eredità artistica lasciata al mondo, con epilogo narrativo generato in base alle scelte fatte:
    - L'Icona Immortale (Grande successo e integrità artistica impeccabile)
    - Il Martire del Rock (Fedele alla musica underground fino all'ultimo respiro)
    - La Macchina da Soldi (Ricchissimo, ma ricordato solo per jingle commerciali)
    - La Cometa Fiammeggiante (Una sola hit leggendaria rimasta nella storia e poi il ritiro).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

## 12. ARCHITETTURA UI, ACCESSIBILITÀ NVDA & SOUND DESIGN

### 12.1 Architettura HUD a 5 Sezioni, Top Bar Permanente & Menu di Sistema Esc
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo centrale: `ui/hud/hud.gd` e `ui/system_menu/system_menu_modal.gd`.
  - Top Bar Fissa Permanente: Calendario, orologio, risorse vitali (Energia, Stress, Morale), saldo bancario e controlli runtime sempre visibili e ancorati in alto.
  - Risoluzione viewport nativa: 1920x1080 ad alto contrasto per Holy Diver.
  - Comportamento gerarchico del tasto `Esc`:
    - Se una modale è aperta: chiude la modale attiva e torna all'HUD principale.
    - Se nessuna modale è aperta (a riposo nell'HUD): mette la simulazione in pausa e apre il `SystemMenuModal`.
  - Voci del Menu di Sistema: 1. Riprendi Partita, 2. Salva Partita (salvataggio atomico immediato con annuncio vocale per NVDA), 3. Impostazioni & Accessibilità, 4. Torna al Menu Principale.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Scheda riassuntiva di statistiche complessive di carriera consultabile direttamente dal menu di pausa.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 12.2 Selettore a 4 Macro-Aree & Conservazione dei 15 Tasti Rapidi Diretti
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Organizzazione delle 4 Macro-Aree tematiche (Tasti numerici `1`..`4`):
    - `1` Hub Personale (Personaggio `C`, Agenda `A`, Bilancio `B`, Viaggi `V`)
    - `2` Creazione & Produzione (Catalogo `M`, Nuovo Brano `N`, Produzione Album `P`)
    - `3` Carriera & Band (Concerti `L`, Band `G`, Tour `O`, Festival `F`, Social `Y`, Classifiche `H`, Industria `K`)
    - `4` Skills & Upgrades (Alloggi, Sala Prove, Negozio Strumenti, Hardware Studio `U`)
  - Conservazione integrale di tutti i 15 tasti rapidi alfabetici diretti storici per gli utenti esperti, garantendo navigazione istantanea senza sottomenu.
  - Isolamento atomico dei backdrop e gestione anti-sovrapposizione con `_hide_all_modals()`.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Supporto per comandi Numpad per navigazione veloce riga per riga.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 12.3 Bridge AccessibilityManager, AccessKit Nativo & Zero Mouse
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Autoload bridge: `autoload/accessibility_manager.gd`.
  - Comunicazione bidirezionale con NVDA tramite controller DLL nativo o fallback SAPI sintetico.
  - AccessKit nativo di Godot 4 per l'esposizione corretta dell'albero di accessibilità del sistema operativo.
  - Modalità Zero Mouse rigorosa: ogni schermata, elenco, cursore e pulsante è pilotabile al 100% da tastiera con focus ciclico, Tab, Frecce, Invio e Spazio.
  - Modalità Live Region (`ACCESSIBILITY_LIVE_POLITE` e `ACCESSIBILITY_LIVE_ASSERTIVE`) per messaggi urgenti a schermo.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Opzione per attivare una modalità di "Descrizione Dettagliata Narrativa" per ascoltare descrizioni di lore approfondite dei locali e delle città.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 12.4 Sound Design, Priorità Acustica Anti-Mascheramento & Pausa Dinamica
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Regola aurea di coesistenza: I suoni di gioco e ambientali sono calibrati a un volume sicuro lineare compreso tra 0.7f e 0.75f (`AUDIO_SAFE_VOLUME_LINEAR` = 0.75, corrispondente a -2.5 dB `AUDIO_MAX_VOLUME_DB`).
  - Ducking acustico automatico: Il volume scende al 40% (`AUDIO_DUCKING_RATIO` = 0.40) ogni volta che la voce di NVDA o del sintetizzatore sta pronunciando un testo a schermo, eliminando qualsiasi mascheramento vocale.
  - Pausa Dinamica: All'apertura di qualsiasi menu o modale, il tempo di gioco viene congelato per consentire a Luca di ascoltare e riflettere senza ansia da timer.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Effetti sonori distintivi (Earcon / Audio Cues) per ciascuna macro-area (es. accordo di chitarra rock per l'area Live, rumore di mixer per la Produzione, campane per la domenica di classifica, applausi per la vittoria del #1).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

## 13. REGISTRO STORICO DELLE SUITE DI TEST CONVALIDATE (19/19 TEST SUITE)

A testimonianza della solidità tecnica delle fondamenta attuali, tutte le seguenti 19 suite di test automatizzati vengono eseguite in modalità headless con 0 errori:
1. `tests/test_formulas.gd`: 24 test unitari su curve XP, formule qualità brani, concert score e bilanciamento.
2. `tests/test_time_system.gd`: 15 test su orologio giornaliero, fasce orarie e stati IDLE/BUSY/PAUSED.
3. `tests/test_end_day_system.gd`: 12 test su ciclo di mezzanotte, spese fisse e riposo notturno.
4. `tests/test_save_manager.gd`: 16 test su serializzazione, persistenza JSON atomica e integrità salvataggi.
5. `tests/test_localization_manager.gd`: 29 test su rilevamento lingua, dizionari speculari e segnali di cambio lingua.
6. `tests/test_skill_system.gd`: 29 test sulle 7 abilità musicali e saturazione giornaliera.
7. `tests/test_music_system.gd`: 35 test sulla pipeline di creazione brani e calcolo qualità.
8. `tests/test_concert_system.gd`: 53 test sul motore concerti, affluenza, stage events e closer bonus.
9. `tests/test_economy_system.gd`: 22 test su sussistenza, alloggi, bancarotta e stipendi.
10. `tests/test_career_system.gd`: 18 test sulle promozioni di carriera da Nobody a Superstar.
11. `tests/test_band_system.gd`: 55 test su reclutamento band, 4 personalità, affinità, rispetto e tensione.
12. `tests/test_album_system.gd`: 50 test su formati EP e LP, concept artistici e vendite Day 1.
13. `tests/test_industry_system.gd`: 60 test su contratti Indie vs Major, anticipi, recoupment e 3 tipi di manager.
14. `tests/test_dilemma_system.gd`: 25 test sui bivi etico-narrativi e scelte morali.
15. `tests/test_travel_system.gd`: 64 test sulla rete delle 6 città, affinità di genere e costi di viaggio.
16. `tests/test_tour_system.gd`: 65 test su tournée multi-tappa, 3 classi di veicolo e accumulo Hype.
17. `tests/test_festival_system.gd`: 70 test sui festival estivi, slot orari e meccanica "Rubare la Scena".
18. `tests/test_social_media_system.gd`: 65 test su BandFeed, viralità, shitstorm e social buzz.
19. `tests/test_rival_and_chart_system.gd`: 54 test sulle 10 band rivali, Hit Parade Top 10 e conquista del #1.
20. `tests/test_v5_ui_overhaul.gd`: 44 test sull'architettura HUD a 5 sezioni, Top Bar permanente e Menu Esc.
21. `tests/test_upgrades_system.gd`: 68 test su UpgradesModal, 5 famiglie strumenti con comparatore e hardware studio.
