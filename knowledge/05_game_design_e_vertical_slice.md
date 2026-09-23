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
  - Sottopiano 14 in lavorazione: Riorganizzazione della UI, menu di sistema e navigazione per macro-aree ([`docs/piani/attivi/sottopiani/14_riorganizzazione_ui_menu_sistema_e_macro_aree.md`](../docs/piani/attivi/sottopiani/14_riorganizzazione_ui_menu_sistema_e_macro_aree.md));
  - Sottopiano 15 in lavorazione: Skills Upgrade Hub e gestione strumentazione da palco ([`docs/piani/attivi/sottopiani/15_skills_upgrade_hub_e_strumentazione.md`](../docs/piani/attivi/sottopiani/15_skills_upgrade_hub_e_strumentazione.md));
  - Prossimi step: Tour mondiali negli stadi, gestione merchandising globale, contratti major superstar e status leggenda.
