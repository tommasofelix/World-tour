# 05 — Game Design, Progressioni di Carriera & Macro-Roadmap (v3.0.7)

## Identità del Progetto
- **Titolo di Lavoro**: World-tour (Music Career Simulator / Music Superstar Simulator).
- **Genere**: Management, Life Simulation e Carriera Musicale.
- **Piattaforma**: PC Windows 11 (Godot Engine 4.7.2 win64).
- **Accessibilità Primaria**: 100% Tastiera, Screen Reader NVDA via AccessKit nativo, Simmetria Universale per vedenti.
- **Coordinatore Master**: [`docs/todo.md`](../docs/todo.md).

---

## 1. Il Core Gameplay Loop

Il giocatore interpreta un aspirante musicista che parte dal garage di casa per scalare tutti gli stadi della carriera musicale fino al successo globale:
1. **Gestione Quotidiana della Vita**: Routine a ore, bilanciamento di Energia, Stress, Morale, Denaro, Fan e Popolarità.
2. **Sviluppo Abilità (Le 7 Abilità Musicali)**: Strumento, Canto, Composizione, Arrangiamento, Testi, Produzione e Performance Live.
3. **Pipeline Creativa di Produzione Brani**: Dalla scintilla compositiva (Bozza/Draft), attraverso arrangiamento e registrazione, fino al rilascio (Singolo, EP, Album) con calcolo deterministico del Quality Score.
4. **Attività Live & Concerti**: Dai pub underground e piccoli club locali fino ai teatri, festival estivi e grandi stadi, con selezione scaletta, interazione con il pubblico, incassi e conversione dei partecipanti in fan stabili.
5. **Dinamiche di Band & Industria Discografica**: Gestione dei membri della band, accordi contrattuali con etichette indipendenti o major, merchandise e presenza sui social media.

---

## 2. Quadro dei Sottopiani Archiviati e Convalidati (V1.0 – V4.0)

La visione di game design è stata declinata e interamente convalidata con NVDA attraverso 8 sottopiani specialistici archiviati in [`docs/piani/completati/sottopiani/`](../docs/piani/completati/sottopiani/):

1. **`SP-01`: Game Design, Visione e Progressione** [x]: High concept, 8 stadi di carriera e macro-roadmap;
2. **`SP-02`: Simulazione Vita, Gestione Tempo e Routine** [x]: Orologio giornaliero, stati IDLE/BUSY, pausa dinamica automatica nei menu e ciclo di fine giornata;
3. **`SP-03`: Sistema Musicale, Abilità e Creazione Brani** [x]: Meccaniche di composizione, calcolo punteggio brani e formati discografici;
4. **`SP-04`: Concerti, Locali, Pubblico e Fanbase** [x]: Locali, Concert Score, affluenza, scalette e conversioni live;
5. **`SP-05`: Economia, Carriera, Band e Industria** [x]: Flussi economici, indipendenza finanziaria, royalties e bivi etici con le etichette;
6. **`SP-06`: Formule Matematiche e Bilanciamento** [x]: Modelli algoritmici (XP esponenziali, curve di rendimento marginale decrescente, freno anti-stress);
7. **`SP-07`: Architettura Software, Sistemi e Modello Dati** [x]: Clean Architecture, EventBus disaccoppiato e salvataggio atomico JSON;
8. **`SP-08`: Accessibilità Vocale, Tastiera e Simmetria Universale** [x]: Bridge AccessKit/NVDA, comandi da tastiera e volumi audio di sicurezza.

---

## 3. Stato Attuale & Roadmap Attiva (Versione 5.0 Endgame)

- **Fasi 1–8**: Completate, convalidate e consolidate con 17 suite di test automatici headless a exit code 0.
- **Fase 9 Attiva (Versione 5.0: Endgame, Grandi Stadi & Superstar Mondiale)**:
  - `F9.0` (Completata [x]): Riorganizzazione della UI, menu di sistema Esc, Top Bar permanente e navigazione per 4 macro-aree (`test_v5_ui_overhaul.gd`).
  - `F9.1` (Completata [x]): Skills Upgrade Hub e gestione strumentazione da palco, lifestyle e insonorizzazione (`test_upgrades_system.gd`).
  - `F9.1B` (Completata [x] — Sez. 1.1): Creazione guidata del personaggio con 6 strumenti, 5 background, 5 tratti e modalità test rapida (`test_character_creation.gd`).
  - `F9.1C` (Completata [x] — Sez. 1.2): Filosofia della Notte su 22 ore virtuali (06:00–04:00), overtime progressivo non forfettario, skip time e riposo anticipato ristoratore (`test_time_night_system.gd`).
  - `F9.1D` (Completata [x] — Sez. 1.3): Triade risorse vitali (Energia, Stress, Morale), burnout (<15%), soglia di panico (>=80%), modale `RelaxModal` accessibile con tasto `R` e recupero attivo diurno (`test_vital_resources_system.gd`).
  - `F9.1E` (Completata [x] — Sez. 2): Creatività Musicale & Crafting Avanzato: 10 Tematiche Liriche (`LyricThemeData`), sinergia genere-tema (+3.5, 0.0, -1.5), 3 nuovi tratti canzone (`GENERATIONAL_ANTHEM`, `TEARJERKER_BALLAD`, `EPIC_RIFF`), sconto martedì 20% studio professionale, calibrazione hardware home studio, rielaborazione bozze e suite dedicata `test_advanced_crafting_system.gd` (65 test). Archiviato.
  - `F9.1F` (Completata [x] — Sez. 3): La Band, Reclutamento, Dinamiche Relazionali & Revenue Split: 5 ruoli in `BandRole` (incluso Cantante `VOCALS`), 8 personalità psicologiche (`BandPersonality`), bacheca audizioni con rifiuto deterministico basato sul divario abilità-reputazione, sinergia front-man live, prove potenziate da pacificatore/perfezionista, risentimento a quote predatorie e suite `test_band_system.gd` (58 test). Archiviato.
  - `F9.1G` (Completata [x] — Sez. 4): Strumenti Musicali, Sala Prove, Home Studio & Upgrades Hub: negozio multicategoria con comparatore e dotazione band, 5 pedali e 2 amplificatori, insonorizzazione e sub-affitto sala prove, nastro analogico vs digitale, usura, muletto van salvavita e manutenzione liutaio (`test_upgrades_hub_system.gd`, 58 test). Archiviato.
  - `F9.1H` (Completata [x] — Sez. 5): Concerti dal Vivo, Locali, Scaletta & Pubblico: catalogo espanso a 6 locali (inclusi Centro Sociale Occupato e Teatro d'Opera Storico), calendario disponibilità venue con occupazione procedurale e sovrapprezzo weekend (+20% affitto ven/sab), drammaturgia scaletta (Opener, Mid Ballad, Closer Stage Beast) e cover famose, 7 Stage Events procedurali a bivi con check abilità, banchetto Merchandising al Foyer (4 articoli) e momento Bis / Encore su score >= 85, modale `LiveConcert` (tasto `L`) e suite `test_concert_system.gd` (92 test). Archiviato.
  - Prossimi step: Apertura Sezione 6 (Economia, Lifestyle & Industria Discografica Avanzata / Grandi Stadi).
