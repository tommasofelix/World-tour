# Piano Tecnico Operativo — Sezione 4: Strumenti Musicali, Sala Prove, Home Studio & Upgrades Hub
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-23
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Archiviato al termine della Fase 3 — AVF V4.4.0)
# File Piano: docs/piani/completati/PIANO_SEZIONE_4_STRUMENTI_SALA_PROVE_HOME_STUDIO_E_UPGRADES.md
# File di Riferimento: docs/roadmap/04_strumenti_sala_prove_home_studio_e_upgrades.md & docs/report/REPORT_AVVIO_SESSIONE_SEZIONE_4.md
# Coordinatore Master: docs/todo.md

---

## 🎯 1. OBIETTIVO E PERIMETRO DELLA SEZIONE 4

La **Sezione 4 della Roadmap Modulare** governa l'evoluzione del sistema **Strumenti Musicali, Sala Prove, Home Studio & Upgrades Hub** di *World-tour*.
L'obiettivo è trasformare l'investimento materiale e infrastrutturale da un semplice negozio di oggetti statici in un **ecosistema dinamico di progressione hardware, artigianale e gestionale**, articolato in 5 pilastri strategici:

1. **Negozio Strumenti Multicategoria & Comparatore**:
   - 5 famiglie strumentali complete: Chitarre (`guitar`), Bassi (`bass`), Batterie (`drums`), Microfoni/Voce (`vocals`), Tastiere/Synth (`keyboards`).
   - 4 Tier di Qualità (0: Starter, 1: Semi-Pro, 2: Pro Vintage, 3: Master Signature).
   - Comparatore dinamico differenziale con vocalizzazione chiara per NVDA dei delta Tecnica, Carisma e Sinergia Band.
   - Dotazione ed equipaggiamento per l'intera band: Alex può acquistare e assegnare strumenti ai compagni di band reclutati, elevando la loro resa e la Sinergia Palco complessiva.

2. **Sound Shaping: Pedalboard & Amplificatori**:
   - Effettistica a pedale con 5 pedali iconici (Overdrive, High-Gain Distortion, Chorus, Tape Delay, Wah-Wah).
   - Pedalboard con slot attivi ed effetto sinergico sui generi musicali dei brani e dei concerti.
   - Amplificatori distinti: Testata/Cassa Valvolare Britannica (calore e saturazione per Rock e Indie) vs Pulito Americano Cristallino (headroom e nitidezza per Pop, Elettronica e Metal).

3. **Insonorizzazione Sala Prove, Quiete Pubblica & Sub-Affitto Commerciale**:
   - 4 livelli di trattamento acustico (`UpgradeData.RehearsalTier`): Garage Rumoroso (Tier 0), Pannelli Fonoassorbenti Base (Tier 1), Insonorizzazione Professionale (Tier 2), Studio Acustico & Lounge (Tier 3).
   - Riconoscimento dei bonus specifici: riduzione stress, -30% consumo energia/affaticamento prova (Tier 1), +5% affinità band (Tier 2), +8 morale e azzeramento stress (Tier 3).
   - Eventi casuali di disturbo della quiete pubblica (reclami vicini e multe vigili urbani da 150 €) per prove rumorose in sale non isolate (Tier 0 e 1); isolamento protettivo totale nei Tier 2 e 3.
   - Possibilità di sub-affittare la sala a band locali per generare entrate passive giornaliere/settimanali (+20 €/giorno per Tier 2, +50 €/giorno per Tier 3).

4. **Hardware Home Studio & Filosofia di Registrazione**:
   - 4 livelli hardware studio (`UpgradeData.StudioHardwareTier`) con tetto di esecuzione e bonus produzione.
   - Bivio metodologico di registrazione casalinga:
     * *Analogico su Nastro Magnetico*: costo bobina (25.0 €), calore analogico, bonus qualità +5.0 per Rock e Indie.
     * *Digitale High-Definition*: costo zero per tracce, massima definizione chirurgica, bonus qualità +3.0 per Pop ed Elettronica.

5. **Usura Strumentale, Manutenzione Liuteria & Strumenti di Riserva ("Muletti")**:
   - Integrità e usura progressiva dello strumento principale (da 100.0% a 0.0%) consumata da concerti (-8%) e prove (-3%).
   - Soglie di sicurezza: Allerta (< 40%) e Critica (< 20%).
   - Incidenti sul palco per usura critica (40% chance rottura corda/guasto con -15 al punteggio concerto).
   - Servizio Liutaio di Fiducia: Manutenzione Ordinaria (cambio corde, intonazione, 30 €) e Rettifica Completa Liuteria (80 €).
   - Strumento di Riserva ("Muletto nel baule"): elimina il rischio di interruzione del live in caso di incidente sul palco.

6. **Accessibilità Assoluta Zero Mouse in `UpgradesModal` (Tasto `U`)**:
   - Navigazione lineare 100% da tastiera tra le 5 schede con i tasti numerici `1`..`5`.
   - Risoluzione dei conflitti di tasti rapidi (es. `KEY_B` contestualizzato).
   - Feedback sonori e allarmi rigorosamente calibrati tra 0.7f e 0.8f.

---

## 🏛️ 2. ANALISI ARCHITETTURALE E MODELLI DATI

### 2.1 Estensione `UpgradeData` (`data/models/upgrade_data.gd`)
- **Effetti a Pedale (`PedalType`)**:
  * `OVERDRIVE`: Costo 120 €, genere affine `ROCK`, `INDIE` (+3 score, +2 carisma).
  * `HIGH_GAIN_DISTORTION`: Costo 150 €, genere affine `METAL`, `ROCK` (+4 score, +3 potenza sonora).
  * `CHORUS`: Costo 130 €, genere affine `INDIE`, `POP` (+3 armonia, +2 atmosfera).
  * `TAPE_DELAY`: Costo 180 €, genere affine `INDIE`, `ELECTRONIC` (+3 texture, +3 creatività).
  * `WAH_WAH`: Costo 140 €, genere affine `ROCK`, `POP` (+3 espressività, +3 presenza scenica).
- **Tipologia Amplificatori (`AmpType`)**:
  * `SOLID_STATE_BASIC` (Tier 0): Costo 0 €, amplificatore transistor base.
  * `BRITISH_TUBE` (Tier 1): Costo 600 €, calore valvolare britannico (+5 qualità/live per Rock e Indie).
  * `AMERICAN_CLEAN` (Tier 2): Costo 600 €, headroom cristallino (+5 qualità/live per Pop ed Elettronica).
- **Filosofia Registrazione (`RecordingPhilosophy`)**:
  * `DIGITAL_HD` (0): Nessun costo bobine, +3 qualità per Pop, Elettronica, Metal.
  * `ANALOG_TAPE` (1): Costo bobina 25 €, +5 qualità per Rock, Indie.
- **Soglie Usura & Costi Liutaio**:
  * `CONDITION_MAX`: 100.0%
  * `CONDITION_WARNING`: 40.0%
  * `CONDITION_CRITICAL`: 20.0%
  * `WEAR_PER_CONCERT`: 8.0%
  * `WEAR_PER_REHEARSAL`: 3.0%
  * `COST_LUTHIER_BASIC`: 30.0 € (cambio corde, pulizia, intonazione)
  * `COST_LUTHIER_FULL`: 80.0 € (rettifica tasti, schermatura elettronica)
  * `COST_BACKUP_INSTRUMENT`: 150.0 € (muletto di riserva da viaggio)

### 2.2 Estensione `PlayerData` (`data/models/player_data.gd`)
- Nuovi campi di persistenza con relativi getter/setter e serializzazione in `to_dict()` e `from_dict()`:
  * `var instrument_condition: Dictionary`: tracciamento usura per ciascuna delle 5 categorie (`guitar`, `bass`, `drums`, `vocals`, `keyboards`), default 100.0.
  * `var has_backup_instrument: bool = false`: possesso di uno strumento muletto nel bagagliaio del furgone/van.
  * `var owned_pedals: Array[String] = []`: lista pedali acquistati.
  * `var active_pedalboard: Array[String] = []`: fino a 3 pedali inseriti nella pedalboard attiva.
  * `var current_amp_tier: int = 0`: amplificatore attivo (0 Transistor, 1 Britannico, 2 Americano).
  * `var rehearsal_sublet_active: bool = false`: stato del sub-affitto della sala prove.
  * `var recording_philosophy: int = 0`: filosofia di registrazione predefinita (0 Digitale HD, 1 Nastro Analogico).
  * `var band_member_gear: Dictionary = {}`: tracciamento tier strumento assegnato a ciascun membro (`member_id -> tier`).
- Metodi di servizio:
  * `get_instrument_condition(category: String) -> float`
  * `apply_instrument_wear(category: String, amount: float) -> void`
  * `repair_instrument(category: String, full_service: bool) -> bool`
  * `equip_pedal(pedal_id: String) -> bool` / `unequip_pedal(pedal_id: String) -> void`
  * `get_sound_shaping_genre_bonus(genre: int) -> float`

### 2.3 Estensione `BandSystem` (`systems/band_system.gd`)
- In `hold_rehearsal_session()`:
  * Consumo energia ridotto da 15 a 10 se `rehearsal_tier >= 1` (bonus -30% affaticamento da pannelli fonoassorbenti).
  * Incremento affinità extra di +5.0% se `rehearsal_tier >= 2` (insonorizzazione professionale).
  * Incremento morale di +8 per Alex se `rehearsal_tier >= 3` (lounge e studio acustico perfetto).
  * Usura dello strumento attivo del leader (-3.0%).
  * Meccanica Quiete Pubblica:
    - Se `rehearsal_tier == 0`: 25% probabilità di evento disturbo della quiete pubblica (reclamo vicini o sanzione 150 € con annuncio vocale).
    - Se `rehearsal_tier == 1`: 10% probabilità di reclamo verbale (nessuna multa).
    - Se `rehearsal_tier >= 2`: 0% probabilità (isolamento perfetto certificato).
- In `get_band_synergy_bonus()`:
  * Integrazione dei tier strumentali assegnati ai singoli compagni reclutati (`band_member_gear`). Ogni strumento di fascia 1, 2 o 3 affidato ai compagni conferisce un boost diretto di sinergia (+2%, +4%, +6%).

### 2.4 Estensione `EndDaySystem` (`systems/end_day_system.gd`)
- Nel ciclo notturno:
  * Se `player_data.rehearsal_sublet_active` è `true` e la sala è idonea:
    - Se `rehearsal_tier == 2`: incasso passivo sub-affitto di +20.0 € / giorno.
    - Se `rehearsal_tier == 3`: incasso passivo sub-affitto di +50.0 € / giorno.
    - Notifica inserita nelle voci del riepilogo giornaliero `DailySummary` e salvata nelle statistiche economiche.

### 2.5 Estensione `MusicSystem` (`systems/music_system.gd`)
- In `record_tracks(song: SongData, use_pro_studio: bool)`:
  * Supporto per `recording_philosophy`:
    - Se `ANALOG_TAPE`:
      * Verifica disponibilità di 25.0 € per le bobine. Se disponibili, detrazione fondi ed emissione `EventBus.money_changed`.
      * Se il genere è `ROCK` o `INDIE`: bonus qualità aggiuntivo di +5.0.
      * Se i fondi non bastano: fallback automatico su digitale HD con avviso vocale.
    - Se `DIGITAL_HD`:
      * Costo zero.
      * Se il genere è `POP` o `ELECTRONIC`: bonus qualità aggiuntivo di +3.0.
  * Integrazione bonus amplificatore attivo su chitarra/basso (+3.0 se genere affine).

### 2.6 Estensione `ConcertSystem` (`systems/concert_system.gd`)
- In `resolve_concert()`:
  * Consumo usura sullo strumento principale: `-UpgradeData.WEAR_PER_CONCERT` (-8.0%).
  * Controllo Integrità & Stage Accidents:
    - Se la condizione dello strumento è $< 20.0\%$:
      - 35% probabilità di rottura corda o guasto jack/pickup durante l'esibizione.
      - Se Alex possiede il muletto (`has_backup_instrument`):
        * Incidente neutralizzato istantaneamente! Annuncio NVDA: "Corda rotta sul palco! Sostituzione fulminea con lo strumento di riserva nel baule: lo show prosegue trionfalmente!"
      - Se Alex NON ha il muletto:
        * Penalità di -15.0 punti al punteggio concerto (`concert_score`) e annuncio NVDA di allarme: "Inconveniente tecnico sul palco! Strumento guasto senza muletto di riserva: penalità al concerto!"
  * Bonus Sound Shaping su Concert Score:
    - Calcolo affinità pedali attivi nella pedalboard e amplificatore rispetto al genere musicale principale eseguito.

### 2.7 Estensione Interfaccia & Accessibilità in `UpgradesModal` (`ui/upgrades/upgrades_modal.gd`)
- Aggiornamento della navigazione a schede:
  * `1` Spazio Vitale & Alloggi
  * `2` Sala Prove & Insonorizzazione (con toggle Sub-Affitto e prova rapida)
  * `3` Negozio Strumenti & Comparatore (con selezione categorie G, B, D, V, K e assegnazione compagni)
  * `4` Hardware Studio & Filosofia Registrazione (con switch Digitale/Analogico)
  * `5` Sound Shaping & Liuteria (Pedalboard, Amplificatori, Usura strumento e riparazioni Liutaio)
- Risoluzione definitiva conflitti da tastiera.
- Lettura riga per riga di ogni parametro per screen reader NVDA tramite `AccessibilityManager.speak()`.

---

## 📋 3. SCOMPOSIZIONE ATOMICA IN NAMED CONTRACTS (ASTRALIS PROTOCOLLO 12)

- **Contratto D0 (Clean Sweep & Pre-Flight Baseline Verification)**:
  Verifica pulizia del working tree Git e convalida 100% verde di tutte le 23 suite headless del progetto a 0 errori.
- **Contratto D1 (Costanti, Enums & Modello Dati Esteso in `UpgradeData`)**:
  Aggiunta di `PedalType`, `AmpType`, `RecordingPhilosophy`, costanti usura, costi liutaio e metodi di lookup/affinità.
- **Contratto D2 (Persistenza, Usura, Pedalboard & Dotazione Band in `PlayerData`)**:
  Nuovi campi di tracciamento usura, pedali, ampli, filosofia registrazione, muletto e dotazione band, con serializzazione atomica `to_dict()` e `from_dict()`.
- **Contratto D3 (Sala Prove, Vicinato, Prove & Sub-Affitto in `BandSystem` ed `EndDaySystem`)**:
  Integrazione bonus specifici sala in `hold_rehearsal_session()`, rischio reclami vicini per sale rumorose, e accredito passivo notturno da sub-affitto in `EndDaySystem`.
- **Contratto D4 (Filosofia Registrazione Analogico/Digitale in `MusicSystem`)**:
  Integrazione scelta nastro analogico vs digitale in `record_tracks()`, gestione costo bobine e bonus genere specifici.
- **Contratto D5 (Usura Strumenti, Incidenti Palco, Muletto & Sound Shaping in `ConcertSystem`)**:
  Integrazione consumo integrità a fine live, risoluzione incidenti palco con salvataggio da muletto, e bonus sound shaping da pedalboard/ampli.
- **Contratto D6 (Interfaccia Grafica Accessibile Zero Mouse in `UpgradesModal` - Tasto `U`)**:
  Espansione dell'interfaccia a 5 schede, risoluzione collisioni tasti, pulsanti Liutaio, configurazione pedalboard, e annunci dinamici per NVDA.
- **Contratto D7 (Suite Headless Dedicata & Regression Testing: 23+ Suite a 0 Errori)**:
  Estensione di `tests/test_upgrades_system.gd` per convalidare tutti i nuovi contratti (usura, liutaio, muletto, pedali, amplificatori, nastro analogico, eventi vicinato e sub-affitto) senza alcuna regressione.

---

## 🛡️ 4. VALIDAZIONE PREVENTIVA SUI 7 ASSI ASTRALIS

1. **Asse 1 — Validità**: Rispetto rigoroso dei tipi GDScript 2.0, nessuna variabile non tipizzata, gestione accurata di clamp e dizionari.
2. **Asse 2 — Efficacia**: Risoluzione organica di tutte le specifiche di Sezione 4 della Roadmap senza scorciatoie superficiali.
3. **Asse 3 — Coerenza**: Piena armonia architetturale con il pattern Clean Architecture DDD del progetto (EventBus a segnali, modelli puri, sistemi logici e UI isolate).
4. **Asse 4 — Completezza**: Copertura esaustiva di tutti i casi limite (usura a zero, fondi insufficienti per liutaio o nastro analogico, salvataggio con e senza muletto, reclami vicini).
5. **Asse 5 — Precisione**: Interventi chirurgici sui moduli competenti senza toccare logiche estranee.
6. **Asse 6 — Affidabilità & Prestazioni**: Esecuzione deterministica headless a 0 ms senza ritardi artificiali o `OS.delay()`.
7. **Asse 7 — Assenza Regressioni & Prevenzione Anomalie**: Blindatura delle 23 suite headless storiche (nessun test fallito o alterato).

---

## 🧪 5. I 3 LIVELLI DI SIMULAZIONE DI COLLAUDO

- **Livello 1 (Happy Path)**:
  Alex acquista una chitarra Pro Vintage, un pedale Overdrive e un amplificatore valvolare britannico; suona un concerto Rock con suono brillante e guadagna bonus di concert score; poi effettua una prova nella sala Tier 2 con stress ridotto e senza reclami dei vicini.
- **Livello 2 (Percorsi Alternativi & Concorrenti)**:
  Alex assegna strumenti avanzati al proprio bassista e batterista aumentando la sinergia della band; registra un brano Indie su nastro analogico pagando la bobina e ottenendo il bonus calore; attiva il sub-affitto della sala prove ottenendo +20 €/giorno passivi.
- **Livello 3 (Corner Cases & Limiti Estremi)**:
  Alex suona con uno strumento usurato al 15% di condizione; si verifica una rottura corda sul palco: se ha il muletto di riserva lo show viene salvato istantaneamente a costo zero; se non lo ha subisce una penalità di -15 punti; prova in un garage rumoroso (Tier 0) e riceve una sanzione di 150 € per disturbo della quiete pubblica.

---

## 🛑 6. STATO SOTTO-FASE 1A: APPROVATA DA LUCA

In ottemperanza alla **Regola 0** e alla governance **ASTRALIS v3.0.7**, il presente Piano Tecnico Operativo per la Sezione 4 è stato approvato da Luca ("procedi e verifica se ci sono incongruenze nei moduli").

---

## 🚀 7. RAPPORTO DI COMPLETAMENTO SOTTO-FASE 1B (CONTRATTI D0..D7)

Tutti i contratti tecnici denominati sono stati implementati e convalidati headless con successo deterministico a 0 ms:

1. **Contratto D0 (Clean Sweep & Pre-Flight)**:
   - Convalidata la baseline a 23 suite headless.
2. **Contratto D1 (Costanti, Enums & UpgradeData)**:
   - Definiti `AmpType`, `AMP_MODELS`, 5 `PEDALS`, `RecordingPhilosophy`, costanti usura, liuteria, muletto, sub-affitto e multe vicinato in `core/constants.gd` e `data/models/upgrade_data.gd`.
3. **Contratto D2 (Persistenza, Usura & Dotazione Band in PlayerData)**:
   - Tracciamento usura 5 famiglie (`instrument_condition`), muletto (`has_backup_instrument`), pedali posseduti e pedalboard attiva a 3 slot, ampli, sub-affitto attivo, filosofia nastro/digitale e dotazione compagni di band (`equipped_gear_tier` in `BandMemberData`). Serializzazione e deserializzazione atomica blindate in `PlayerData.to_dict()` e `from_dict()`.
4. **Contratto D3 (Sala Prove, Vicinato & Sub-Affitto)**:
   - `BandSystem.hold_rehearsal_session()` integra -30% consumo energia (Tier 1), +5% affinità (Tier 2), +8 morale e stress zero (Tier 3), usura strumento (-3%) e controllo eventi disturbo quiete pubblica / sanzioni vigili per garage rumorosi (Tier 0/1).
   - `EndDaySystem.process_day_end()` accredita automaticamente le rendite passive da sub-affitto (+20 € Tier 2, +50 € Tier 3) con logging economico e annuncio NVDA.
5. **Contratto D4 (Filosofia Registrazione in MusicSystem)**:
   - `MusicSystem.record_tracks()` gestisce l'opzione Nastro Magnetico Analogico (costo bobine 25 €, +5 qualità per Rock e Indie) vs Digitale HD (+3 qualità Pop/Elettronica) e consumo usura strumento.
6. **Contratto D5 (Usura Strumento, Incidenti Palco & Muletto in ConcertSystem)**:
   - `ConcertSystem.resolve_concert()` applica usura (-8%), bonus sonoro genere da pedali/ampli, e controlla incidenti palco per condizioni critiche (< 20%): lo strumento muletto nel van neutralizza il guasto; in assenza di muletto penalità di -15 punti al concert score.
7. **Contratto D6 (Interfaccia Grafica Accessibile Zero Mouse in UpgradesModal)**:
   - Aggiornamento a 5 schede (Alloggi, Sala Prove con Sub-affitto, Strumenti con Dotazione Band, Hardware Studio con Nastro/Digitale, Sound Shaping & Liutaio con riparazioni ordinarie/straordinarie e acquisto muletto).
   - Navigazione lineare 100% da tastiera (tasti `1`..`5`), risoluzione collisione tasto `KEY_B`, e vocalizzazione dinamica NVDA per ogni azione.
8. **Contratto D7 (Convalida Headless 23/23 Suite a 0 Errori)**:
   - Estesa la suite `tests/test_upgrades_system.gd` (68 asserzioni).
   - Esecuzione integrale della suite di progetto: **23 test suite eseguite, 23 superate, 0 fallimenti**.

---

## 🏁 8. CHIUSURA FORMALE FASE 3 E COLLAUDO CONGIUNTO

- **Esito Collaudo NVDA & Monitor**: Convalidato al 100% senza difetti o regressioni.
- **Disciplina di Versionamento AVF**: Raggiunta la versione **V4.4.0** (Avanzamento Architetturale Sezione 4).
- **Archiviazione**: Il presente piano viene trasferito in `docs/piani/completati/` e la cartella `docs/piani/attivi/` è pulita per la Sezione 5.
