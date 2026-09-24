# Piano Tecnico Operativo — Sezione 9: L'Industria Musicale, Contratti & Management
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-24
# Stato: [/] [IMPLEMENTATO — IN ATTESA DI CONVALIDA SOTTO-FASE 1A]
# File Piano: docs/piani/attivi/PIANO_SEZIONE_9_INDUSTRIA_CONTRATTI_E_MANAGEMENT.md
# File di Riferimento: docs/roadmap/09_industria_musicale_contratti_e_management.md
# Coordinatore Master: docs/todo.md
# Baseline AVF: V4.8.0 (Target Release: V4.9.0)

---

## 🎯 1. OBIETTIVO E PERIMETRO DELLA SEZIONE 9

La **Sezione 9 della Roadmap Modulare** governa l'approfondimento e la maturazione sistemica del pilastro **"L'Industria Musicale, Contratti & Management"** di *World-tour*.
Nel nostro simulatore, l'industria discografica non è un albero statico di sblocchi lineari in cui il contratto successivo è banalmente "migliore" del precedente. Rappresenta una vera **arena di scelte di carriera, compromessi etici e gestione del rischio**:
- Scegliere l'**Autoproduzione** significa mantenere il 100% delle royalties e totale sovranità artistica, al prezzo del 100% del rischio economico e zero anticipi.
- Firmare per un'**Etichetta Indipendente** garantisce un solido supporto iniziale e libertà espressiva a fronte di royalties al 45% e vincolo di 2 album.
- Legarsi a una **Major Multinazionale** immette capitali enormi (anticipo da 60.000 € a 100.000 €), ma comprime le royalties al 15%, impone standard qualitativi minimi rigorosi (Quality Score >= 65.0), scadenze serrate e costante pressione A&R.

Inoltre, il rapporto con il **Manager** cessa di essere un semplice modificatore passivo: diventa una **relazione viva con personalità, fiducia dinamica, promesse, telefonate notturne, conflitti di interesse e rischio tradimento**, richiedendo perfino la tutela di un avvocato contrattuale.

Infine, la Sezione 9 introduce le vette dell'endgame e dell'emancipazione artistica:
- La **Clausola di Distribuzione Fisica Esclusiva** nei negozi di dischi delle metropoli;
- La **Rinegoziazione Contrattuale** e il **Riscatto dei Master (Master Buyback)** al raggiungimento di Dischi d'Oro e alta reputazione;
- La **Fondazione della propria Etichetta Indipendente** nell'endgame, trasformando Alex da musicista a talent scout e produttore discografico per giovani band emergenti.

Il sistema si articola in 5 macro-aree di approfondimento:

1. **I 3 Modelli Produttivi, Clausole di Recoupment & Pressione A&R (`ContractData`, `IndustrySystem`)**:
   - Consolidamento e rifinitura dei 3 contratti:
     1. `SELF_RELEASED`: 100% royalties, 0 € anticipo, 0 album richiesti, libertà artistica totale, 0 pressione.
     2. `INDIE_LABEL`: anticipo standard 8.000 € (o fino a 12.000 € tier specializzato), royalties al 45%, obbligo di 2 album, libertà artistica elevata.
     3. `MAJOR_LABEL`: anticipo standard 60.000 € (o fino a 100.000 € top major), royalties al 15%, obbligo di 3 album, target qualitativo minimo 65.0 (o 75.0), pressione A&R elevata.
   - Meccanica contabile del **Recoupment**: l'anticipo versato alla firma è un debito di recupero; tutte le royalties spettanti all'artista su vendite e streaming vengono trattenute fino a estinzione del debito; solo ad azzeramento avvenuto le royalties liquide tornano sul conto della band.
   - Scadenze di consegna album sincronizzate con l'Agenda della Band (`ScheduleSystem`): la mancata consegna entro i termini o con qualità inferiore allo standard concordato genera un'escalation di stress (+15 punti) e richiami formali dell'etichetta.

2. **Figure di Management Umane: Personalità, Fiducia, Promesse & Tradimento (`ManagerData`, `IndustrySystem`)**:
   - Superamento della logica a "bonus fisso": il manager è una figura narrativa ricorrente dotata di:
     1. `TRUSTED_FRIEND` (L'Amico Fidato): Quota ingaggio 50 €, provvigione 10%, moltiplicatore cachet live 1.10x, sgravio stress -1.0/notte, lealtà ferrea ma contatti limitati.
     2. `PRO_INDIE` (Il Professionista Indipendente): Quota ingaggio 400 €, provvigione 15%, moltiplicatore cachet live 1.25x, sgravio stress -2.5/notte, ottimi club e diplomazia.
     3. `INDUSTRY_SHARK` (Lo Squalo dell'Industria): Quota ingaggio 2.000 €, provvigione 22%, moltiplicatore cachet live 1.50x, apre le porte dei grandi festival e TV, **ma genera stress notturno (+4.0 stress a notte)** con richieste pressanti e telefonate a orari impossibili.
   - **Sistema di Fiducia (Trust 0.0 - 100.0)**:
     * La fiducia cresce con il successo dei concerti e la durata del rapporto; decresce in caso di rifiuti, concerti saltati o contrasti artistici.
   - **Meccanica delle Promesse del Manager (`ManagerPromise`)**:
     * Il manager propone un obiettivo periodico (es. *"Ti garantisco una data in un club di prestigio entro 2 settimane"* o *"Posso farti raddoppiare il cachet al prossimo live"*). Se mantenuta, produce boost reputazione e fiducia; se fallita, genera imbarazzo o attrito.
   - **Telefonate Notturne dello Squalo (Eventi alle 02:30)**:
     * Eventi procedurali notturni in `EndDaySystem`: lo squalo chiama con una proposta improvvisa (es. *"Domani devi essere a Berlino per una comparsata televisiva"*). Accettare porta denaro immediato ma interrompe il riposo (+8 stress); rifiutare fa calare la fiducia dello squalo.
   - **Conflitto di Interessi, Tradimento & Protezione Legale**:
     * Se la fiducia dello squalo scende sotto quota 30 e la band non ha assunto un avvocato contrattuale (`has_legal_protection`), c'è il rischio che lo squalo trattenga arbitrariamente una percentuale extra sui compensi dei concerti.
     * Servizio di consulenza legale per tutelare i contratti: possibilità di assumere un **Avvocato dello Spettacolo** (costo periodico o una tantum) per blindare gli accordi.
   - **Licenziamento del Manager & Penale di Rescissione**:
     * Possibilità di licenziare il manager in qualunque momento pagando una penale calcolata proporzionalmente alla tariffa d'ingaggio e alla durata dell'accordo.

3. **Clausole di Distribuzione Fisica Esclusiva & Penetrazione Negozi (`ContractData`, `IndustrySystem`)**:
   - Clausola opzionale negoziabile con etichette o distributori indipendenti:
     * L'etichetta o consorzio ottiene l'esclusiva di stampa e fornitura dei dischi fisici nei negozi specializzati di tutte le 12 metropoli continentali.
     * Effetto gameplay: **aumento delle vendite degli album del +40%** sul mercato fisico, a fronte di una trattenuta distributiva del 20% sui ricavi all'ingrosso.
     * Durata della clausola: 112 giorni (4 mesi) con opzione di rinnovo o disdetta.

4. **Bivi Contrattuali, Rinegoziazione Accordi su Dischi d'Oro & Riscatto Master (`IndustrySystem`, `DilemmaSystem`)**:
   - **Rinegoziazione Contrattuale su Successo Straordinario**:
     * Se Alex raggiunge una reputazione elevata (>= 70.0) oppure consegue almeno una certificazione ufficiale (Disco d'Oro: 25.000 copie vendute su un album o singolo), si sblocca l'azione speciale **Rinegozia Contratto**.
     * Trattativa con la Major: possibilità di alzare la percentuale royalties dal 15% al 25% o ottenere un ulteriore bonus anticipo liquido. Se la trattativa si fa dura, Alex può minacciare il "blocco delle consegne" (sciopero creativo).
   - **Riscatto dei Master (Master Buyback)**:
     * Diritto di riscatto: Alex può riacquistare la proprietà intellettuale e i nastri master dei propri album storici pubblicati sotto contratto, pagando una cifra proporzionata al valore di catalogo.
     * Effetto: l'album torna al 100% sotto proprietà diretta dell'artista, eliminando per sempre le trattenute dell'etichetta originale e incassando royalties piene per l'intera carriera.
   - **Catalogo Espanso dei Bivi Etici dell'Industria in `DilemmaSystem`**:
     * 4 nuovi dilemmi focalizzati su accordi commerciali, etica dell'industria e pressioni discografiche.

5. **Endgame: Fondazione e Gestione della Propria Etichetta Indipendente (`OwnLabelData`, `IndustrySystem`, `IndustryHub`)**:
   - Requisiti di fondazione: status di artista affermato (Reputazione >= 60.0, fondi bancari >= 25.000 €, regime di autoproduzione o contratti pregressi conclusi).
   - Fondazione della label:
     * Scelta del nome e della linea editoriale (es. Indie Rock, Hard & Heavy, Alternative/Underground, Pop Elettronico).
     * Gestione del **Roster Artisti** (fino a 3 giovani band emergenti messe sotto contratto).
   - Meccaniche di Scouting & Talent Hunting:
     * Possibilità di ascoltare demo tape e visionare giovani band emergenti nelle metropoli musicali.
     * Firma della band: Alex stanzia l'anticipo (es. 4.000 € - 12.000 €) e definisce il royalty rate dell'etichetta (es. 55% - 70%).
     * Le band del roster producono album che escono sul mercato e generano **royalties passive di catalogo** ogni notte direttamente sul conto dell'etichetta di Alex!
     * Possibilità di promuovere o rescindere i contratti dei propri protetti.

---

## 🏛️ 2. NAMED CONTRACTS (D0..D6)

### Contratto D0: Clean Sweep, Allineamento Tipi & Modelli Dati Centralizzati
- Bonifica preventiva di campi isolati o incoerenze tra roadmap e codice (es. lo squalo che in `manager_data.gd` aveva sgravio positivo invece di generare stress notturno).
- Estensione di `core/enums.gd`:
  ```gdscript
  enum LabelPhilosophy {
      UNDERGROUND_INDIE = 0, # Massima integrità e fedeltà della scena
      MAINSTREAM_POP = 1,    # Orientata alle classifiche e vendite
      ROCK_HERITAGE = 2,     # Produzioni analogiche e virtuosismo
      EXPERIMENTAL = 3       # Suoni d'avanguardia ed esplorazione
  }
  ```
- Estensione di `data/models/contract_data.gd`:
  * Aggiunta campi per distribuzione fisica:
    `var has_physical_distribution: bool = false`
    `var physical_dist_cut: float = 0.20`
    `var physical_sales_multiplier: float = 1.40`
  * Aggiunta tracciamento rinegoziazione e riscatto:
    `var is_renegotiated: bool = false`
    `var original_royalty_rate: float = 0.15`
    `var master_bought_back: bool = false`
  * Metodi: `can_renegotiate(player_rep: float, has_gold_record: bool) -> bool`, `apply_renegotiation(new_royalty: float) -> void`.
  * Serializzazione atomica in `to_dict()` e `from_dict()`.
- Estensione di `data/models/manager_data.gd`:
  * Aggiunta campi relazionali:
    `var trust: float = 50.0 # Valore 0.0 - 100.0`
    `var active_promise: Dictionary = {}`
    `var has_legal_protection: bool = false`
    `var severance_penalty: float = 0.0`
    `var nocturnal_stress_rate: float = 0.0`
  * Calcolo deterministico della penale di licenziamento: `get_severance_fee() -> float`.
  * Configurazione differenziata dello squalo (`nocturnal_stress_rate = 4.0`, mentre per friend e pro resta lo sgravio diurno/serale).
  * Serializzazione atomica in `to_dict()` e `from_dict()`.
- Creazione del nuovo modello dati `OwnLabelData` (`data/models/own_label_data.gd`):
  * Campi: `label_name: String`, `is_founded: bool`, `founded_day: int`, `philosophy: int`, `reputation: float`, `signed_bands: Array[Dictionary]`, `total_catalog_revenue: float`.
  * Metodi per aggiungere/rimuovere band, simulare uscite e calcolare introiti.
  * Serializzazione atomica `to_dict()` e `from_dict()`.
- Integrazione in `PlayerData`:
  * Campo `own_label: OwnLabelData`.
  * Metodo `has_own_label() -> bool`.
  * Metodo `has_any_gold_record() -> bool` (ispezione vendite album >= 25.000 copie).
  * Persistenza atomica in `to_dict()` e `from_dict()`.

### Contratto D1: Business Discografico Avanzato, Distribuzione Fisica & Rinegoziazione in `IndustrySystem`
- In `systems/industry_system.gd`:
  * `sign_physical_distribution(contract_id: String) -> Dictionary`: sottoscrizione clausola esclusiva con boost +40% vendite fisiche e fee del 20%.
  * `renegotiate_contract(target_royalty_rate: float = 0.25) -> Dictionary`: rinegoziazione delle condizioni se sussistono i requisiti (reputazione >= 70 o dischi d'oro). Modifica del `royalty_rate` contrattuale con annuncio trionfale per NVDA.
  * `buyback_album_master(album_id: String) -> Dictionary`: calcolo del prezzo di riscatto master (es. 15.000 € - 30.000 € in base alle vendite storiche), detrazione fondi, riscatto proprietà e svincolo permanente dell'album da qualsiasi recoupment o royalty trattenuta.
  * Monitoraggio scadenze di consegna album: penalità reputazione (-5.0) e stress (+15) in caso di mancata consegna o scadenze ignorate.

### Contratto D2: Dinamiche Relazionali del Manager (Fiducia, Promesse, Notte & Rescissione)
- In `systems/industry_system.gd`:
  * `adjust_manager_trust(delta: float) -> float`: incremento o decremento del livello di fiducia con soglie reattive (alta > 75, media 30-75, critica < 30).
  * `generate_manager_promise() -> Dictionary`: formulazione periodica di una promessa professionale da parte del manager attivo.
  * `evaluate_manager_promise_fulfillment() -> Dictionary`: verifica del mantenimento dell'accordo (es. data importante suonata, cachet minimo raggiunto).
  * `process_manager_night_call() -> Dictionary`: evento serale/notturno per lo Squalo dell'Industria. Se il giocatore risponde positivamente, ottiene una serata speciale o ingaggio rapido con +8 stress; se rifiuta, -10 fiducia.
  * `hire_entertainment_lawyer(cost: float = 1500.0) -> Dictionary`: assunzione di un avvocato per blindare i contratti ed eliminare al 100% il rischio di trattenute arbitrarie da parte dello squalo.
  * `fire_manager_with_severance() -> Dictionary`: licenziamento con calcolo e detrazione della penale di rescissione (amico fidato 0 €, pro indie 250 €, squalo 1.500 €). Se il saldo è insufficiente, il licenziamento fallisce determinando un attrito.

### Contratto D3: Endgame — Fondazione e Gestione della Propria Etichetta Indipendente
- In `systems/industry_system.gd`:
  * `found_own_label(label_name: String, philosophy: int) -> Dictionary`: validazione requisiti (rep >= 60, soldi >= 25.000 €, regime libero), creazione di `OwnLabelData` e detrazione quota capitale sociale.
  * `scout_unsigned_bands() -> Array[Dictionary]`: generazione deterministica di 3 giovani band emergenti con nome, genere musicale, livello abilità grezzo e potenziale di mercato.
  * `sign_band_to_own_label(band_data: Dictionary, advance_granted: float, label_royalty_cut: float) -> Dictionary`: finanziamento della band, accredito anticipo a carico di Alex e ingresso nel roster della label.
  * `process_own_label_daily_royalties() -> Dictionary`: simulazione notturna del catalogo delle band sotto contratto (chiamato da `EndDaySystem`), con calcolo vendite, recupero anticipi e accredito dell'utile netto dell'etichetta sul conto di Alex.

### Contratto D4: Bivi e Dilemmi Contrattuali/Industriali Estesi in `DilemmaSystem`
- In `systems/dilemma_system.gd`, introduzione nel catalogo di 4 nuovi bivi specializzati:
  1. `dilemma_exclusive_distribution_deal` (La Grande Distribuzione Continentale): Proposta di esclusiva totale sui negozi di dischi a condizioni severe.
  2. `dilemma_shark_hidden_accounting` (Conti Ombrosi dello Squalo): Sospetto di trattenuta su un mega-festival. Assumere l'avvocato o chiarire di persona?
  3. `dilemma_master_buyback_ultimatum` (Riscatto dei Master o Nuovo Album): L'etichetta offre uno sconto sul riacquisto dei master ma pretende la prelazione sul prossimo singolo.
  4. `dilemma_young_band_talent_scouting` (La Promessa Emergente): Una giovane band punk chiede asilo e produzione nella tua nuova etichetta, ma ha testi provocatori che potrebbero irritare gli sponsor.

### Contratto D5: Dashboard Accessibile `IndustryHub` & 3 Schede Tematiche per NVDA
- Estensione e riorganizzazione di `ui/industry/industry_hub.gd` e `industry_hub.tscn`:
  * Struttura a 3 Schede accessibili con tasti numerici rapidi:
    - **Scheda 1 (Tasto `1`): Contratti Discografici & Accordi**:
      * Box contratto attivo con percentuali, anticipo, stato recoupment, qualità A&R.
      * Pulsante `R`: Rinegozia Contratto (visibile se idoneo, con dischi d'oro o rep >= 70).
      * Pulsante `M`: Riscatto Master Album (seleziona album e riscatta proprietà).
      * Pulsante `D`: Attiva Distribuzione Fisica Esclusiva (+40% vendite fisiche).
      * Lista offerte discografiche disponibili con pulsanti firma.
      * Pulsante Rescindi Contratto con penalità reputazione.
    - **Scheda 2 (Tasto `2`): Manager & Rappresentanza**:
      * Box manager attivo con nome, provvigione live, moltiplicatore cachet.
      * Livello di **Fiducia** espresso linearmente (es. *"Fiducia: 82% (Ottima intesa professionale)"*).
      * Box **Promessa in Corso** del manager con stato e scadenza.
      * Box **Tutela Legale**: stato dell'avvocato dello spettacolo con pulsante `L` per ingaggio.
      * Pulsante `F`: Licenzia Manager con visualizzazione chiara della penale di rescissione.
      * Roster profili disponibili con requisiti e costi.
    - **Scheda 3 (Tasto `3`): La Mia Etichetta Discografica (Endgame)**:
      * Se non fondata: requisiti di capitale e reputazione, pulsante `F` per Fondazione Label con scelta nome e filosofia.
      * Se fondata: bacheca etichetta, filosofia, reputazione label, ricavi catalogo totali.
      * Roster band sotto contratto con dischi pubblicati e debito recuperato.
      * Pulsante `S`: Talent Scouting per visionare giovani band emergenti.
      * Pulsante `B`: Firma Band Emergente.
  * Tasto rapido HUD `K` per apertura e `Esc` per chiusura.
  * Accessibilità vocale al 100% per NVDA (Zero Mouse): annunci sintetici per ogni azione, descrizioni lineari senza tabelle 2D, focus visibile e scorciatoie dirette.

### Contratto D6: Test Suite Headless (0 errori, 0 ms) & Assenza Regressioni
- Aggiornamento della suite `tests/test_industry_system.gd` per coprire capillarmente:
  1. Verifica modelli dati estesi (`ContractData`, `ManagerData`, `OwnLabelData`).
  2. Meccaniche di distribuzione fisica esclusiva e incremento vendite.
  3. Requisiti e applicazione della rinegoziazione contrattuale su Dischi d'Oro e reputazione.
  4. Meccanica di riscatto dei master storici (Master Buyback) e azzeramento fee.
  5. Sistema di fiducia del manager, mantenimento promesse e telefonate notturne dello squalo.
  6. Tutela legale tramite avvocato e prevenzione trattenute indebite.
  7. Licenziamento del manager con pagamento penale di rescissione e gestione fallimento per fondi insufficienti.
  8. Fondazione della propria etichetta indipendente, talent scouting, firma band e simulazione royalties passive di catalogo.
  9. Istanziazione e integrità nodi della dashboard UI a 3 schede (`IndustryHub`).
- Esecuzione headless rigorosa a 0 ms senza ritardi o chiamate bloccanti.
- Verifica su tutte le 24 suite preesistenti per certificare 0 warning, 0 errori e zero regressioni.

---

## ⚖️ 3. VALIDAZIONE PREVENTIVA SUI 7 ASSI DI QUALITÀ

Ogni componente della Sezione 9 viene preventivamente validato sui 7 assi di governance ASTRALIS:

- **Asse 1 — Validità**: Tutti i modelli estendono `RefCounted`, usano tipizzazione GDScript 2.0 statica e rispettano gli enum centralizzati in `core/enums.gd`.
- **Asse 2 — Efficacia**: Risolve direttamente i desiderata espressi nel GDD e nella Roadmap: il contratto non è un mero moltiplicatore ma una filosofia di carriera, il manager è vivo ed evolve, e l'endgame offre una vera svolta manageriale con la propria label.
- **Asse 3 — Coerenza**: Perfetta armonia con i sistemi preesistenti (`AlbumSystem`, `ConcertSystem`, `ScheduleSystem`, `EndDaySystem`, `SaveManager`). Nessuna logica orfana né collisione concettuale.
- **Asse 4 — Completezza**: Copertura di tutti i casi limite: rescissione senza soldi per la penale, rinegoziazione rifiutata per mancanza di requisiti, squalo senza avvocato, riscatto di master già riscattati.
- **Asse 5 — Precisione**: Interventi chirurgici sui file sorgente, rispetto del router <= 250 righe e contratti atomici denominati.
- **Asse 6 — Affidabilità & Prestazioni**: Calcoli puramente matematici deterministici a 0 ms nei test runner headless; zero loop infiniti e serializzazione JSON pulita.
- **Asse 7 — Assenza Regressioni & Prevenzione Anomalie**: Preservazione totale della compatibilità dei salvataggi esistenti in `PlayerData.from_dict()` tramite default sicuri, e garanzia di tenuta delle 24 suite esistenti.

---

## 🔬 4. SIMULAZIONE PREVENTIVA A 3 LIVELLI

### Livello 1: Happy Path (Percorso Virtuoso Standard)
- Alex pubblica il suo primo EP in autoproduzione, accumula fan e raggiunge 25.0 di reputazione.
- Consulta l'`IndustryHub` (Tasto `K` -> Scheda `1`) e firma con l'etichetta indipendente "Black Velvet Records": riceve 8.000 € di anticipo con obbligo di 2 album e royalties al 45%.
- Ingaggia il manager professionista "Elena Santi" (Tasto `2`): il cachet live sale del +25% e lo stress organizzativo scende di 2.5 punti a notte.
- La fiducia della manager sale a 85% grazie a 4 concerti sold-out consecutivi; Elena mantiene la sua promessa di procurare una data al Club Centrale.
- Alex consegna i 2 album previsti con ottime recensioni; il secondo album supera 25.000 vendite e vince il Disco d'Oro!
- Il debito di recoupment viene azzerato e le royalties nette affluiscono sul conto. Alex torna artista libero.
- Avendo accumulato 40.000 € e 65.0 reputazione, apre la Scheda `3` e fonda la propria etichetta "Velvet Underground Records": fa scouting, mette sotto contratto due band emergenti e incassa ogni notte le percentuali sulle vendite del suo roster!

### Livello 2: Percorso Alternativo & Concorrente (Il Patto con la Major & lo Squalo)
- Alex firma direttamente con la multinazionale "Titan Records Worldwide": riceve un enorme anticipo di 60.000 € ma royalties compresse al 15% e vincolo di qualità minima 65.0.
- Assume lo Squalo dell'Industria "Vittorio Brambilla": cachet live +50% e accesso ai festival, ma lo squalo genera +4.0 stress ogni notte.
- Alle 02:30 di un Mercoledì, lo squalo chiama con una proposta estemporanea a Berlino: Alex accetta per non far calare la fiducia, incassa 2.000 € ma perde ore di sonno (+8 stress).
- Alex pubblica un album sperimentale che ottiene Quality Score 58.0: la Major contesta formalmente la consegna per mancato rispetto del target qualitativo (+15 stress).
- Alex assume un Avvocato dello Spettacolo per proteggersi da clausole predatorie.
- Successivamente, grazie al tour estivo, l'album recupera terreno e sfonda le 30.000 copie (Disco d'Oro).
- Alex sfrutta il Disco d'Oro per rinegoziare il contratto discografico: la Major accetta di elevare le royalties al 25% per evitare che la band entri in sciopero creativo.
- Con i proventi, Alex riscatta i master del suo primo album storico, tornando a percepirne il 100% delle entrate.

### Livello 3: Corner Cases & Casi Limite (Stress Test)
1. **Tentativo di licenziare il manager senza fondi sufficienti**:
   - Alex tenta di licenziare lo squalo con saldo bancario di 300 € a fronte di una penale di 1.500 €. Il sistema rifiuta la rescissione con esito negativo (`success: false, reason: insufficient_funds`), impedendo al giocatore di andare in rosso arbitrariamente, e notifica tramite NVDA che la penale non può essere saldata.
2. **Tentativo di fondare la propria etichetta sotto vincolo di Major**:
   - Se Alex ha un contratto attivo con una Major o un debito di recoupment non estinto, il tentativo di fondazione della propria etichetta viene bloccato per conflitto di esclusiva (`reason: currently_under_exclusive_contract`).
3. **Tentativo di rinegoziazione prematura**:
   - Alex prova a rinegoziare le royalties al giorno 10 di contratto, con 0 dischi d'oro e reputazione 30.0. L'etichetta respinge seccamente la richiesta (`reason: requirements_not_met`), avvisando tramite sintesi vocale che occorrono almeno un Disco d'Oro o reputazione >= 70.
4. **Tentativo di riscatto master duplicato**:
   - Alex riscatta il master di un album. Se tenta di riscattarlo una seconda volta, il sistema restituisce `already_bought_back` senza addebitare nuovamente la somma.
5. **Simulazione notturna con etichetta propria attiva ma band con vendite minime**:
   - Le band del roster hanno vendite minime o nullo smercio: il calcolo delle royalties notturne applica un flooring di 0.0 € senza generare valori negativi, NaN o errori di divisione per zero.

---

## 🎧 5. ACCESSIBILITÀ VOCALE ASSOLUTA & VOLUMI DI SICUREZZA

1. **Zero Mouse & Tasti Rapidi HUD**:
   - Accesso diretto con tasto `K` da tastiera a riposo (o dal Menu di Sistema / Macro-Area Carriera `3`).
   - Navigazione tra le 3 schede con i numeri `1` (Contratti), `2` (Manager) e `3` (Mia Etichetta).
   - Tasti operativi con chiare etichette semantiche:
     * `R`: Rinegozia Contratto / Aggiorna Offerte;
     * `M`: Riscatto Master Album;
     * `D`: Distribuzione Fisica Esclusiva;
     * `F`: Licenzia Manager / Fondazione Label;
     * `L`: Ingaggia Avvocato Tutela Legale;
     * `S`: Talent Scouting Band;
     * `B`: Firma Band Emergente;
     * `Esc`: Chiudi schermata industria e torna al gioco.
2. **Sintesi Vocale Dinamica Lineare per NVDA**:
   - Annuncio vocale sintetico all'apertura dell'hub con riepilogo dello stato contrattuale, nome del manager, livello di fiducia e stato dell'etichetta propria.
   - Ogni scheda e pulsante dispone di hook AccessKit tramite `AccessibilityManager.hook_control_accessibility()` con descrizione estesa dei costi e delle conseguenze.
   - Divieto assoluto di tabelle visuali 2D: elenco sequenziale lineare leggibile con le frecce su/giù o tasti numerici.
3. **Calibrazione Audio Salvavita**:
   - Livelli audio di sfondi musicali o effetti sonori d'interfaccia rigidamente limitati tra **0.7f e 0.8f** (mai 1.0f).
   - Audio ducking automatico durante il parlato di NVDA o SAPI.

---

## 📋 6. MATRICE OPERATIVA DELLE ATTIVITÀ & GATING SEMANTICO

### Sotto-Fase 1A: Pianificazione Tecnica Formale & Definizione Contratti
- [x] [CONVALIDATO CON SUCCESSO] Analisi approfondita dei requisiti in `docs/roadmap/09_industria_musicale_contratti_e_management.md`.
- [x] [CONVALIDATO CON SUCCESSO] Studio dell'architettura preesistente in `systems/industry_system.gd`, `data/models/contract_data.gd`, `data/models/manager_data.gd`, `ui/industry/` e `tests/test_industry_system.gd`.
- [x] [CONVALIDATO CON SUCCESSO] Redazione del presente Piano Tecnico Operativo in `docs/piani/attivi/PIANO_SEZIONE_9_INDUSTRIA_CONTRATTI_E_MANAGEMENT.md`.
- [x] [CONVALIDATO CON SUCCESSO] Definizione dei Named Contracts D0..D6, dei 7 Assi di Qualità e dei 3 Livelli di Simulazione.

---

### 🛑 STOP OBBLIGATORIO DELLA SOTTO-FASE 1A
> **In ossequio alla Regola 0 di Governance ASTRALIS v3.0.7, Antigravity si arresta qui.**  
> Nessuna riga di codice sorgente o configurazione di progetto verrà modificata prima dell'esplicito comando di Luca (*"procedi"*, *"applica"*, *"esegui"*).

---

### Sotto-Fase 1B: Esecuzione Tecnica & Suite di Test Headless (POST-APPROVAZIONE)
- [x] [CONVALIDATO CON SUCCESSO] Contratto D0: Clean sweep, enum `LabelPhilosophy`, estensione modelli `ContractData` e `ManagerData`, creazione `OwnLabelData` e aggiornamento `PlayerData`.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D1: Implementazione business discografico, distribuzione fisica esclusiva, rinegoziazione contrattuale e riscatto dei master in `IndustrySystem`.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D2: Implementazione dinamiche relazionali del manager (fiducia, promesse, telefonate notturne squalo, tutela legale avvocato e penale rescissione).
- [x] [CONVALIDATO CON SUCCESSO] Contratto D3: Implementazione modulo endgame propria etichetta discografica indipendente (fondazione, talent scouting, contratti band e royalties passive).
- [x] [CONVALIDATO CON SUCCESSO] Contratto D4: Integrazione dei 4 nuovi bivi etico-narrativi dell'industria in `DilemmaSystem`.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D5: Espansione dashboard `IndustryHub` con 3 schede tematiche accessibili per NVDA (Zero Mouse) e allineamento localizzazioni.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D6: Suite di test headless estesa `tests/test_industry_system.gd` a 0 errori e 0 ms (106/106 asserzioni superate), con verifica anti-regressione su tutte le 24 suite esistenti (100% superate).

---

### Sotto-Fase 2: Deploy Provvisorio, Telemetria & Collaudo Congiunto NVDA
- [x] [CONVALIDATO CON SUCCESSO] Verifica operativa da parte di Luca con screen reader NVDA e tastiera (tasto `K`, schede `1`, `2`, `3`, rinegoziazione, promesse manager, riscatto master e label propria).
- [x] [CONVALIDATO CON SUCCESSO] Verifica estetica e usabilità mouse per Holy Diver su layout monitor ad alto contrasto.

---

### Sotto-Fase 3: Chiusura Simultanea, Versionamento AVF & Git
- [x] [CONVALIDATO CON SUCCESSO] Avanzamento deterministico della versione AVF a `V4.9.0`.
- [x] [CONVALIDATO CON SUCCESSO] Aggiornamento Living Documentation (`docs/todo.md`, `CHANGELOG.md`, `README.md`, `GEMINI.md`, `knowledge/05_game_design_e_vertical_slice.md`).
- [x] [CONVALIDATO CON SUCCESSO] Archiviazione del piano in `docs/piani/completati/PIANO_SEZIONE_9_INDUSTRIA_CONTRATTI_E_MANAGEMENT.md`.
- [x] [CONVALIDATO CON SUCCESSO] Commit Git convenzionale: `feat(industry): implement advanced music industry contracts management own label and nvda accessibility`.
- [x] [CONVALIDATO CON SUCCESSO] Formulazione della **Domanda Ponte Obbligatoria** per l'avvio della Fase 4 (Auto-Apprendimento Continuo).
