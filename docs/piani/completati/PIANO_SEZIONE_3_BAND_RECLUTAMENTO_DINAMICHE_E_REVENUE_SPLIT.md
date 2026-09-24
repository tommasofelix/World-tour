# Piano Tecnico Operativo — Sezione 3: La Band, Reclutamento, Dinamiche Relazionali & Revenue Split
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-23
# Stato: [x] [CONVALIDATO CON SUCCESSO ED ARCHIVIATO — SUITE HEADLESS 23/23 VERDE (100%)]
# File Piano: docs/piani/completati/PIANO_SEZIONE_3_BAND_RECLUTAMENTO_DINAMICHE_E_REVENUE_SPLIT.md
# File di Riferimento: docs/roadmap/03_band_reclutamento_dinamiche_e_revenue_split.md & docs/report/REPORT_AVVIO_SESSIONE_SEZIONE_3.md
# Coordinatore Master: docs/todo.md

---

## 🎯 1. OBIETTIVO E PERIMETRO DELLA SEZIONE 3

La **Sezione 3 della Roadmap Modulare** governa l'evoluzione del sistema **Band, Reclutamento, Dinamiche Umane e Revenue Split** di *World-tour*.
L'obiettivo è trasformare la band da un semplice moltiplicatore numerico in un **organismo sociale vivo e reattivo**, in cui ogni musicista possiede una propria identità tecnica e psicologica, la bacheca audizioni offre scelte ponderate con rifiuto/compatibilità organica, le prove rafforzano l'intesa e le scelte economiche (Revenue Split) generano conseguenze a lungo termine sul clima e sulla stabilità del gruppo.

Nel pieno rispetto della richiesta esplicita di Luca:
> **"ricorda i ruoli sono 5 aggiungi anche il cantante"**
il perimetro include formalmente **5 ruoli strumentali e vocali (`Enums.BandRole`)**:
1. `BASS` (Basso)
2. `DRUMS` (Batteria)
3. `KEYBOARDS` (Tastiere)
4. `GUITAR_RHYTHM` (Chitarra Ritmica)
5. `VOCALS` (Cantante / Voce Principale)

La formazione massima della band è costituita da:
**Alex (protagonista, leader/fondatore) + massimo 3 compagni reclutati = Quartetto completo (4 elementi attivi contemporaneamente)**.
Alex può scegliere di cantare lui stesso (reclutando 3 strumentisti) o ingaggiare un cantante front-man tra i 3 compagni (ad esempio se Alex si concentra su chitarra, basso o tastiere), garantendo massima libertà compositiva e ruolistica.

---

## 🏛️ 2. ANALISI ARCHITETTURALE & MODELLO DATI

### 2.1 I 5 Ruoli della Band (`Enums.BandRole`)
- Estensione dell'enum in `core/enums.gd`:
  * `BASS` (0): Basso (Groove, stabilità e collante ritmico).
  * `DRUMS` (1): Batteria (Ritmo, potenza sonora ed energia live).
  * `KEYBOARDS` (2): Tastiere (Atmosfere, texture, armonie e varietà).
  * `GUITAR_RHYTHM` (3): Chitarra Ritmica (Compattezza dell'arrangiamento e muro di suono).
  * `VOCALS` (4): Cantante / Voce Principale (Interpretazione vocale, carisma da front-man, appeal sul pubblico e traino delle hit).
- Aggiornamento di `data/models/band_member_data.gd` e localizzazione in `localization/it.json`:
  * Chiave `"ROLE_VOCALS": "Cantante"`.
  * Suffisso generativo procedurale: `"Voice"` o `"Front"`.

### 2.2 Ampliamento Personalità dei Membri (`Enums.BandPersonality`)
Dalle 4 personalità base ad un ventaglio esteso di 8 archetipi psicologici selezionati dalla roadmap:
1. `RELIABLE` (L'Affidabile): Calmo, puntuale, abbassa la tensione, costante nel rendimento.
2. `PERFECTIONIST` (Il Perfezionista): Alza la qualità delle prove e registrazioni, ma accumula tensione se il gruppo sbaglia o prova poco.
3. `WILD_PARTY` (L'Animale da Festa): Carismatico e trascinante nei live, ma rischio ritardi e imprevisti.
4. `EGO_ARTIST` (L'Ego Smisurato): Musicista di grandissimo talento, ma geloso della leadership e intransigente sui compensi.
5. `MERCENARY` (Il Mercenario): Pragmatico, motivato dal denaro, stabile se pagato bene, intollerante a ritardi o compensi bassi.
6. `STAGE_ANXIOUS` (L'Ansioso da Palco): Tecnicamente bravissimo, ma accumula stress nei grandi eventi se la band non è preparata.
7. `NATURAL_LEADER` (Il Leader Naturale): Organizzato, trainante, ma può entrare in attrito con Alex se non coinvolto nelle decisioni.
8. `PEACEMAKER` (Il Pacificatore): Mediatore nato, riduce la tensione tra i compagni, facilita le riconciliazioni.

### 2.3 Bacheca Audizioni & Valutazione Intelligente dei Candidati
- Costo organizzazione provino: `Constants.BAND_AUDITION_FEE = 30.0 €`.
- Generazione candidati in `refresh_candidates_pool()`:
  * Ruoli generati: garantita la presenza di almeno 1 candidato per ciascuno dei 5 ruoli (`BASS`, `DRUMS`, `KEYBOARDS`, `GUITAR_RHYTHM`, `VOCALS`), per un totale di almeno 5 candidati in bacheca.
  * Suffissi di naming: Basso ("Groove"), Batteria ("Beats"), Tastiere ("Keys"), Chitarra ("Riff"), Cantante ("Voice" / "Front").
  * Calcolo Abilità candidato: base $12 + \text{rand}(0..15) + \text{reputation} \times 1.5$, con cap $[10, 85]$.
- **Formula Matematica Accettazione / Rifiuto Candidato**:
  * Un candidato professionista/esperto non accetta di entrare in un gruppo senza credibilità artistica.
  * Soglia di Accettazione:
    $$\Delta_{\text{skill}} = \text{candidate.skill\_level} - (\text{player.reputation} \times 2.0 + 15)$$
    Se $\Delta_{\text{skill}} > 25$, il candidato rifiuta formalmente con motivazione chiara:
    `"Il candidato ritiene la band ancora troppo acerba per le sue aspettative artistiche (richiesta reputazione più alta)."`
  * Se il candidato accetta, viene calcolata l'Affinità/Compatibilità iniziale di base (50%) modulata da Personalità e Genere preferito:
    - `RELIABLE`: +20% compatibilità, -10% tensione iniziale
    - `PEACEMAKER`: +15% compatibilità, -15% tensione iniziale
    - `PERFECTIONIST`: +10% compatibilità, +5% rispetto
    - `MERCENARY`: 0% compatibilità, attento unicamente alla quota economica
    - `STAGE_ANXIOUS`: -5% compatibilità iniziale, bisognoso di prove
    - `NATURAL_LEADER`: -10% compatibilità iniziale con Alex, +10% rispetto
    - `EGO_ARTIST`: -10% compatibilità, +10% tensione iniziale
    - Corrispondenza di Genere con lo stile primario della band/Alex: +15% compatibilità se combacia, -10% se generi antitetici.

### 2.4 Indicatori Vitali di Gruppo & Chimica di Palco
- Tracciamento per ogni membro in `BandMemberData`:
  * `affinity` (0.0 - 100.0): intesa personale e amicizia.
  * `musical_respect` (0.0 - 100.0): stima tecnica e rispetto artistico.
  * `tension` (0.0 - 100.0): attriti e malcontento.
- Soglie di tensione e gestione Crisi:
  * Sicura: $< 40\%$ (`BAND_TENSION_SAFE`)
  * Allerta: $> 70\%$ (`BAND_TENSION_WARNING`)
  * Critica: $> 85\%$ (`BAND_TENSION_CRITICAL`).
  * Innesco Crisi: Se un membro raggiunge tensione $\ge 85\%$, si attiva lo stato `is_threatening_to_quit()`. Nel post-concerto (`process_post_concert_dynamics`), se il punteggio è $< 50$, scatta una crisi formale con rischio di abbandono immediato comunicato ad alto segnale per NVDA.
- **Formula Sinergia Palco**:
  $$\text{RawSynergy} = (\text{AvgAffinity} \times 0.40 + \text{AvgRespect} \times 0.60) - (\text{AvgTension} \times 0.70)$$
  $$\text{SynergyBonus} = \text{clampf}\left(\frac{\text{RawSynergy}}{100} \times 25.0 + \text{GearSynergyBonus}, -15.0, 35.0\right)$$
  - Un cantante carismatico (`VOCALS`) o con tratto `WILD_PARTY` conferisce un ulteriore boost live del $+5.0\%$ al carisma della performance.

### 2.5 Prove di Gruppo (`hold_rehearsal_session`) & Bonus Mercoledì
- Consumo di 15 Energia di Alex.
- Stress generato correlato al livello di insonorizzazione della sala prove:
  * Garage: +10 Stress
  * Pannelli base: +7 Stress
  * Isolamento pro: +4 Stress
  * Master Studio: 0 Stress
- Effetti immediati sui membri:
  * Affinità: $+4.0$ (o $+6.0$ se presente un `PEACEMAKER`)
  * Rispetto: $+5.0$ (o $+7.0$ se presente un `PERFECTIONIST`)
  * Tensione: $-8.0$ (fino a $-12.0$ in Master Studio)
- Bonus Mercoledì (`Constants.WEDNESDAY_BAND_XP_MULT` = 1.20): +20% XP per i membri della band e per Alex.

### 2.6 Revenue Split (Divisione Incassi)
- Ripartizione applicata in `ConcertSystem`, royalties e anticipi:
  * `EQUAL_SPLIT`: $1.0 / (1 + \text{num\_members})$ ciascuno (25% su quartetto completo). Effetto psicologico: Tensione $-10.0$, Rispetto $+5.0$, Affinità $+5.0$.
  * `LEADER_BALANCED`: 40% ad Alex, 20% a ciascun compagno. Se presente un `EGO_ARTIST` o `MERCENARY`, Tensione $+8.0$.
  * `LEADER_PREDATORY`: 70% ad Alex, 10% a ciascun compagno. Tensione $+20.0$, Rispetto $-12.0$, Affinità $-10.0$.
  * Se un `MERCENARY` è sottoposto a quota predatoria per più di 3 concerti, la sua tensione sale automaticamente a 90% (crisi contrattuale immediata).

---

## 📋 3. SCOMPOSIZIONE ATOMICA IN NAMED CONTRACTS (ASTRALIS CANONE 4)

- **Contratto D0 (Clean Sweep & Pre-Flight Check)**:
  Verifica della pulizia del working tree Git e validazione preventiva di non-regressione sulla baseline esistente (23 suite headless a 0 errori).
- **Contratto D1 (Enum & Modello Dati Esteso: 5 Ruoli & 8 Personalità)**:
  * In `core/enums.gd`: Aggiunta `VOCALS` a `BandRole` (5 ruoli) e dei 4 nuovi profili a `BandPersonality` (`MERCENARY`, `STAGE_ANXIOUS`, `NATURAL_LEADER`, `PEACEMAKER`).
  * In `data/models/band_member_data.gd`: Aggiornamento mapping ruoli, personalità, getter/setter, helper `is_threatening_to_quit()` e serializzazione dizionario `to_dict()`/`from_dict()`.
  * In `localization/it.json`: Aggiunte stringhe localizzate per `ROLE_VOCALS`, `PERSONALITY_MERCENARY`, `PERSONALITY_STAGE_ANXIOUS`, `PERSONALITY_NATURAL_LEADER`, `PERSONALITY_PEACEMAKER` e messaggi di audizione.
- **Contratto D2 (Bacheca Audizioni a 5 Ruoli & Rifiuto Deterministico)**:
  * In `systems/band_system.gd`: Aggiornamento di `refresh_candidates_pool()` per generare almeno 5 candidati coprendo tutti i 5 ruoli (incluso `VOCALS`).
  * Implementazione della regola di rifiuto deterministica basata su divario abilità/reputazione in `audition_candidate()` e `hire_candidate()`.
  * Calcolo della compatibilità psicologica estesa alle 8 personalità e al genere musicale.
- **Contratto D3 (Sinergia, Prove, Dinamiche Relazionali & Gestione Crisi)**:
  * In `systems/band_system.gd`: Calcolo avanzato di Sinergia Palco (con supporto al cantante e gear bonus).
  * Raffinamento delle prove con impatti specifici delle personalità (`PEACEMAKER`, `PERFECTIONIST`, `WORKAHOLIC`).
  * Dinamiche post-concerto con estrazione eventi di allarme abbandono e notifica live via EventBus.
- **Contratto D4 (Interfaccia Grafica Accessibile & Zero Mouse in `BandHub`)**:
  * In `ui/band/band_hub.gd`: Rendering dinamico delle righe candidati (5 ruoli) e membri attivi.
  * Visualizzazione trasparente delle 8 personalità e dello stato di tensione/crisi.
  * Annunci sintetici dedicati per screen reader NVDA tramite `AccessibilityManager.announce()`.
- **Contratto D5 (Suite di Test Headless Headless a 0 ms & Watchdog Verde)**:
  * In `tests/test_band_system.gd`: Estensione completa per coprire la generazione di tutti i 5 ruoli (incluso Cantante), rifiuto per divario di abilità, assunzione del cantante, impatto delle 8 personalità, calcolo sinergia live, ripartizione Revenue Split e interazione con `ConcertSystem`.
  * Verifica del superamento con 0 errori e durata istantanea.

---

## 🛡️ 4. VALIDAZIONE PREVENTIVA SUI 7 ASSI ASTRALIS

1. **Asse 1 — Validità**: Rispetto rigoroso dei tipi GDScript 2.0, nessuna chiamata non tipizzata, gestione pulita degli enum e dei clamp [0.0, 100.0].
2. **Asse 2 — Efficacia**: Risoluzione diretta del requisito dei 5 ruoli (incluso il cantante) e arricchimento organico delle dinamiche di gruppo senza scorciatoie.
3. **Asse 3 — Coerenza**: Perfetta armonia con la Clean Architecture di World-tour (EventBus a segnali, modelli in `data/models/`, sistemi in `systems/`, UI in `ui/band/`).
4. **Asse 4 — Completezza**: Copertura totale di tutti i casi limite (band piena, ruolo già occupato, fondi insufficienti per audizione, rifiuto candidato per divario di livello, abbandono per tensione critica).
5. **Asse 5 — Precisione**: Modifiche chirurgiche e mirate senza toccare file non pertinenti.
6. **Asse 6 — Affidabilità & Prestazioni**: Esecuzione headless a 0 ms senza ritardi artificiali né `OS.delay()`, thread-safe sul main loop di Godot.
7. **Asse 7 — Assenza Regressioni & Prevenzione Anomalie**: Protezione totale delle 23 suite headless preesistenti, preservando la compatibilità con concerti, economia e salvataggi.

---

## 🏁 5. CHIUSURA SOTTO-FASE 1B & ARCHIVIAZIONE

Il Piano Tecnico per la Sezione 3 è stato completato e convalidato al 100% con esito verde in tutte le 23 suite headless del progetto. Viene pertanto formalmente archiviato tra i piani completati.
