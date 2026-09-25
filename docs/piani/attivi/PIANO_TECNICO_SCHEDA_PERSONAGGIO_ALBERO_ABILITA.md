# World-tour — Piano Tecnico Formale: Scheda Personaggio a 2 Sezioni con Albero Competenze & Attributi Innati (Sotto-Fase 1A)
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA), Thomas & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Versione Target: AVF V5.7.1 — Scheda Personaggio Tabbed: Profilo & Fisiologia (Tab 1) + Albero Competenze 6 Rami (Tab 2)
# Data: 25 Settembre 2026
# Percorso File: docs/piani/attivi/PIANO_TECNICO_SCHEDA_PERSONAGGIO_ALBERO_ABILITA.md
# Baseline AVF: V5.7.0 (31/31 Suite Headless Superate a 0 Errori e 0 ms)
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Fase 1 completata: Sotto-Fase 1A e 1B eseguite con 31/31 suite di test al 100% verdi a 0 ms — Versione AVF V5.7.1)

---

## 🎯 1. OBIETTIVO ARCHITETTURALE E VISIONE GENERALE

Questo piano tecnico formalizza l'evoluzione dell'interfaccia di consultazione del musicista (**`CharacterSheet`**, richiamabile con il tasto rapido **`C`** o tasto **`1`** / **`Numpad 1`** a riposo), riorganizzandola in una struttura a **due sezioni/schede autonome** (`Tabbed Navigation`):

1. **Scheda 1 — Profilo Artistico & Fisiologia**: Mantiene le informazioni anagrafiche, la carriera, le risorse vitali e integra formalmente i **4 Attributi Fisiologici Innati** (`musicality`, `intelligence`, `stamina`, `charm`), lasciando la schermata pulita, ordinata e priva di sovraccarichi;
2. **Scheda 2 — Albero delle Competenze (28 Abilità Canoniche in 6 Rami)**: Dedicata interamente all'Albero delle Competenze, organizzata con un sottomenu a filtro per ramo (Cultura Generi, Tecnica Strumentale, Composizione, Palco, Studio/Suono, Business) e una lista verticale navigabile riga per riga con NVDA con lettura dei gradi a stelle (`★☆☆☆☆` a `★★★★★`), XP correnti, soglie e propedeuticità sbloccate o bloccate.

### Principi Cardine Inviolabili:
1. **Regola 0 (Default Consultivo Permanente & Stop Obbligatorio)**:
   - La presente Sotto-Fase 1A redige unicamente il piano tecnico formale.
   - È fatto divieto assoluto di modificare codice sorgente o configurazioni prima dell'approvazione esplicita di Luca e Thomas (*"procedi"*, *"applica"*, *"esegui"*).
2. **Accessibilità Vocale Assoluta (Zero Mouse & NVDA)**:
   - Navigazione lineare sequenziale riga per riga per screen reader NVDA;
   - Divieto assoluto di tabelle 2D, matrici complesse o schemi ASCII; adozione esclusiva di elenchi puntati e logica "Se... Allora";
   - Ogni elemento della lista abilità è focusabile singolarmente con `AccessibilityManager.hook_control_accessibility()`, permettendo a Luca di esaminare ciascuna competenza senza dover subire la lettura simultanea di tutte le 28 abilità;
   - Tasto rapido **`R`** per lettura vocale riassuntiva continua a mani libere del ramo attivo;
   - Volumi audio e feedback sonori congelati rigidamente tra 0.7f e 0.8f.
3. **Protocollo 12 (Inner Codex Pattern & Determinismo Headless)**:
   - Risoluzione deterministica delle cause radice (RCA);
   - Named Contracts D0..DN a chiusura stagna;
   - Esecuzione headless deterministica a 0 ms senza dipendenze da tick temporali reali né `OS.delay()`.
4. **Assenza Regressioni & Retrocompatibilità (Asse 7)**:
   - Tutte le 31 suite di test preesistenti devono rimanere al 100% verdi (31/31) senza alcuna rottura dei contratti precedenti.

---

## 🏛️ 2. CHECKLIST DI CONVALIDA A 3 STATI (MATRICE PER NVDA)

- [x] [CONVALIDATO CON SUCCESSO] Contratto D0: Riorganizzazione grafica e nodi scena `ui/character/character_sheet.tscn` (Header a 2 tab `BtnTabProfile` e `BtnTabSkills`, contenitori `PanelTabProfile` e `PanelTabSkills`, scroll verticale abilità, clearance WCAG AAA).
- [x] [CONVALIDATO CON SUCCESSO] Contratto D1: Controller Scheda 1 (Profilo & Fisiologia) in `ui/character/character_sheet.gd` (visualizzazione e annuncio NVDA dei 4 attributi fisiologici innati: Musicalità, Intelligenza, Stamina, Carisma).
- [x] [CONVALIDATO CON SUCCESSO] Contratto D2: Controller Scheda 2 (Albero Competenze a 6 Rami) in `ui/character/character_sheet.gd` (filtro per ramo `current_branch`, popolamento accessibile con gradi a stelle, XP, propedeuticità e lettura vocale globale con tasto `R`).
- [x] [CONVALIDATO CON SUCCESSO] Contratto D3: Disaccoppiamento input da tastiera in `_unhandled_input` (tasti `1` e `2` per schede, tasti `G`, `S`, `A`, `P`, `T`, `B` per i 6 rami, `R` per riassunto ramo, `Esc`/`C` per chiusura sicura).
- [x] [CONVALIDATO CON SUCCESSO] Contratto D4: Blindatura headless e test di integrazione in `tests/test_character_creation.gd` o `test_skills_and_loft_study_system.gd` con verifica 31/31 suite verdi a 0 ms.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D5: Aggiornamento Living Documentation (`docs/todo.md`, `knowledge/01_accessibilita_vocale_e_interazione_tastiera.md`, `CHANGELOG.md`) e avanzamento versione AVF a `V5.7.1`.

---

## ⚖️ 3. I 7 ASSI DI QUALITÀ ASTRALIS APPLICATI

- **Asse 1 — Validità**: Rispetto rigoroso dei tipi GDScript 2.0 statici, interfacciamento con `PlayerData.get_branch_skills()` e `PlayerData.get_innate_attribute()`.
- **Asse 2 — Efficacia**: Eliminazione totale del sovraccarico cognitivo separando i dati anagrafico-vitali dalla progressione specialistica delle 28 abilità.
- **Asse 3 — Coerenza**: Perfetta continuità stilistica con il design system di World-tour (`StyleBoxFlat` scuro `#0c1527` o `#11121a`, bordo dorato `#c49a45`, font `PressStart2P.ttf` o font vettoriale standard ad alto contrasto).
- **Asse 4 — Completezza**: Copertura integrale dei 4 attributi fisiologici e di tutte le 28 abilità canoniche con i 5 gradi di maestria e vincoli propedeutici.
- **Asse 5 — Precisione**: Intervento chirurgico e circoscritto a `character_sheet.tscn` e `character_sheet.gd`, con zero impatti sui sottosistemi di gameplay o salvataggio.
- **Asse 6 — Affidabilità & Prestazioni**: Allocazione immediata a 0 ms; deallocazione pulita dei nodi figli con `queue_free()` al cambio ramo.
- **Asse 7 — Assenza Regressioni**: Compatibilità totale con le 31 suite di test storiche del progetto.

---

## 🔬 4. I 3 LIVELLI DI SIMULAZIONE PREVENTIVA

- **Livello 1 — Happy Path (Flusso Lineare Ottimale)**:
  - Il giocatore preme **`C`** nell'appartamento: si apre la Scheda Personaggio sulla **Scheda 1 (Profilo & Fisiologia)**;
  - NVDA annuncia subito la sintesi vocale: anagrafica, vitals, e i 4 attributi innati (es. "Musicalità 50, Intelligenza 50, Resistenza 50, Carisma 50");
  - Il giocatore preme il tasto **`2`**: passa istantaneamente alla **Scheda 2 (Albero Competenze)**; NVDA annuncia: *"Scheda Albero delle Competenze aperto. Ramo Cultura e Generi selezionato (7 abilità). Premi freccia giù per sfogliare o G, S, A, P, T, B per cambiare ramo."*;
  - Il giocatore preme freccia giù: NVDA legge la prima abilità focalizzata: *"Rock Classico e Hard Rock: Grado 1 Principiante ★☆☆☆☆. Esperienza: 0 su 250 XP. Pronta per l'allenamento."*;
  - Il giocatore preme **`S`**: la lista passa al ramo Tecnica Strumentale; con freccia giù legge: *"Chitarra Elettrica: Grado 1 Principiante ★☆☆☆☆. Esperienza: 35 su 250 XP."*;
  - Il giocatore preme **`Esc`**: la scheda si chiude, restituendo il focus pulito al personaggio Alex.
- **Livello 2 — Percorsi Alternativi & Concorrenti**:
  - Il giocatore naviga tra i pulsanti delle schede con `Tab` e preme `Invio`/`Spazio`: il cambio scheda si attiva regolarmente con annuncio vocale;
  - Il giocatore preme **`R`** mentre si trova nella Scheda 2: NVDA avvia la lettura continua di tutte le abilità del ramo attivo senza richiedere pressioni di tasti aggiuntivi;
  - Il giocatore preme **`A`** mentre si trova nella Scheda 1: NVDA legge l'agenda degli impegni dei prossimi 7 giorni come da comportamento storico preservato.
- **Livello 3 — Corner Cases & Limiti Estremi**:
  - Abilità con propedeuticità non soddisfatta (es. *Composizione Ballate* con Teoria a Grado 0 o 1): la riga mostra visivamente l'avviso di blocco e NVDA vocalizza chiaramente: *"Composizione Ballate: Grado 0 Non appresa ☆☆☆☆☆. Bloccata: richiede Grado 2 in Teoria Musicale & Armonia."*;
  - Abilità a Grado 5 (Cap Massimo Leggendario a 2000 XP): la riga e la voce notificano: *"Maestro Leggendario ★★★★★. Grado massimo raggiunto."*;
  - Cambio rapido e ripetuto di ramo con tasti rapidi: la lista viene pulita e ripopolata senza memory leak né duplicazione di nodi.

---

## 🛡️ 5. SPECIFICA DETTAGLIATA DEI NAMED CONTRACTS (D0..DN)

---

### CONTRATTO D0: Riorganizzazione Scena `ui/character/character_sheet.tscn`

#### Obiettivo Tecnico:
Trasformare la struttura gerarchica della scena per supportare la navigazione a schede tabulate e ampliare le dimensioni a $960 \times 620$ px con stile scuro dorato ad alto contrasto.

#### Struttura dell'Albero di Scena:
- `CharacterSheet` (`Control` a tutto schermo con `Backdrop` opaco `#050508`);
- `PanelMain` (`PanelContainer` centrato, $960 \times 620$ px):
  - `VBox` (`VBoxContainer` principale):
    - `Header` (`VBoxContainer`):
      * `LabelTitle`: "Scheda Musicista — [Nome]" (font 24 px);
      * `LabelSubtitle`: "Profilo Artistico, Status Fisiologico e Albero delle Competenze" (font 14 px);
    - `HBoxTabs` (`HBoxContainer` per la selezione schede):
      * `BtnTabProfile` (`Button`): "[1] Profilo & Fisiologia" (custom_minimum_size $240 \times 40$ px);
      * `BtnTabSkills` (`Button`): "[2] Albero Competenze (28 Abilità)" (custom_minimum_size $280 \times 40$ px);
    - `HSeparator1` (`HSeparator`);
    - `PanelTabProfile` (`VBoxContainer`, visibile di default su Tab 1):
      * `HBoxBody` (`HBoxContainer` a 2 colonne):
        - `VBoxLeft`: Dati anagrafici, strumento, background, tratto, status carriera, fan, reputazione, saldo e autonomia;
        - `VSeparator`;
        - `VBoxRight`: Sezione "Fisiologia & Attributi Innati":
          * Barre vitali (Energia, Stress, Morale);
          * HSeparator;
          * LabelAttributiInnati (Titolo);
          * LabelMusicality ("Musicalità: X / 100 — Orecchio e qualità brani");
          * LabelIntelligence ("Intelligenza: X / 100 — Apprendimento rapido XP");
          * LabelStamina ("Resistenza Fisica: X / 100 — Stamina live e voce");
          * LabelCharm ("Carisma Naturale: X / 100 — Fascino e appeal media");
    - `PanelTabSkills` (`VBoxContainer`, visibile su Tab 2):
      * `HBoxBranches` (`HBoxContainer` con i 6 pulsanti dei rami, tasti `G`, `S`, `A`, `P`, `T`, `B`):
        - `BtnBranchGenre` ("G. Generi");
        - `BtnBranchInstrument` ("S. Strumenti");
        - `BtnBranchComposition` ("A. Armonia");
        - `BtnBranchStage` ("P. Palco");
        - `BtnBranchTech` ("T. Studio");
        - `BtnBranchBusiness` ("B. Business");
      * `LabelBranchTitle` (`Label` con titolo descrittivo e numero abilità);
      * `ScrollSkillsTree` (`ScrollContainer` espanso):
        - `VBoxSkillsTreeList` (`VBoxContainer` per le righe delle abilità);
      * `LabelSkillsHint` (`Label` in basso con promemoria comandi: `[Frecce] Sfoglia  [R] Leggi Tutto  [1/2] Cambia Scheda`);
    - `HSeparator2` (`HSeparator`);
    - `HBoxBottom` (`HBoxContainer`):
      * `BtnClose` (`Button`): "Chiudi Scheda (Esc / C)".

---

### CONTRATTO D1: Controller Scheda 1 (Profilo & Fisiologia) in `character_sheet.gd`

#### Obiettivo Tecnico:
Gestire il rendering dei dati anagrafici e l'esposizione chiara e accessibile dei 4 Attributi Fisiologici Innati ricavati da `PlayerData`.

#### Implementazione Logica:
- Mantenimento delle variabili membro:
  - `var current_tab: int = 1`
- Metodo `select_tab(tab_idx: int) -> void`:
  - Se `tab_idx == 1`:
    * `panel_tab_profile.visible = true`
    * `panel_tab_skills.visible = false`
    * Aggiornamento visuale dei pulsanti (evidenziazione del tab attivo)
    * Focus automatico su `btn_tab_profile`
    * Annuncio vocale sintetico: *"Scheda Profilo e Fisiologia"*
  - Se `tab_idx == 2`:
    * `panel_tab_profile.visible = false`
    * `panel_tab_skills.visible = true`
    * Popolamento dinamico delle abilità tramite `_refresh_skills_tree()`
    * Annuncio vocale: *"Scheda Albero delle Competenze"*
- Aggiornamento della funzione `refresh_sheet()` per includere i 4 attributi:
  - `label_musicality.text = "Musicalità: %d / 100 (Orecchio e Cap Qualità)" % player.musicality`
  - `label_intelligence.text = "Intelligenza: %d / 100 (Velocità Apprendimento Studio)" % player.intelligence`
  - `label_stamina.text = "Resistenza Fisica: %d / 100 (Stamina Live e Voce)" % player.stamina`
  - `label_charm.text = "Carisma Naturale: %d / 100 (Fascino e Appeal Media)" % player.charm`
- Annuncio vocale unificato all'apertura (`open()`):
  - Include i valori dei 4 attributi innati e istruisce Luca sui tasti rapidi: *"Premi 2 per consultare l'Albero delle Competenze, A per l'agenda, Esc per chiudere."*.

---

### CONTRATTO D2: Controller Scheda 2 (Albero Competenze a 6 Rami) in `character_sheet.gd`

#### Obiettivo Tecnico:
Implementare la gestione dinamica dei 6 rami e la generazione delle righe accessibili per ciascuna delle 28 competenze canoniche.

#### Mappa dei Rami:
- `"genre_mastery"`: Cultura & Padronanza dei Generi (Rock, Metal, Blues, Pop, Punk, Jazz, Folk)
- `"instrumental_technique"`: Competenze Strumentali & Vocali (Chitarra, Canto, Basso, Batteria, Tastiere)
- `"songwriting_harmony"`: Composizione, Armonia & Scrittura (Teoria, Testi, Ballate, Inni, Riff, Storia)
- `"stage_showmanship"`: Palco, Spettacolo & Intrattenimento (Presenza, Pubblico, Improvvisazione, Atletismo)
- `"engineering_hardware"`: Studio, Suono & Liuteria (Produzione, Suono Live, Liuteria)
- `"industry_business"`: Business, Media & Relazioni Industriali (Media, Contratti, Marketing)

#### Metodo `select_branch(branch_id: String) -> void`:
1. Imposta `current_branch = branch_id`;
2. Aggiorna `label_branch_title` con il nome completo del ramo;
3. Svuota `vbox_skills_tree_list`;
4. Invoca `player.get_branch_skills(branch_id)`;
5. Per ogni abilità ricavata:
   - Crea un elemento riga interattivo (`Button` o `PanelContainer` con `focus_mode = FOCUS_ALL`);
   - Ricava lo stato sbloccato (`player.can_unlock_skill(skill_id)`);
   - Calcola la stringa di visualizzazione a stelle (`player.get_skill_stars_display(skill_id)`);
   - Calcola XP correnti e necessari per la prossima stella;
   - Compila il testo accessibile per NVDA:
     * *Se sbloccata*: `"[Nome]: [Stelle] (Grado N: [Descrizione]). XP [X] su [Y]. Pronta per studio."`
     * *Se bloccata*: `"[Nome]: Non appresa. BLOCCATA. [Motivazione del vincolo propedeutico]."`
   - Registra l'accessibilità con `AccessibilityManager.hook_control_accessibility()`;
6. All'ingresso del focus su ciascuna riga, NVDA legge la descrizione accessibile;
7. Posiziona il focus sul primo elemento della lista o sul pulsante del ramo.

#### Metodo `_read_current_branch_summary() -> void` (Tasto `R`):
- Concatena le informazioni di tutte le abilità del ramo corrente in un unico testo fluido;
- Emette l'annuncio vocale prioritario ad alta leggibilità con `AccessibilityManager.announce(text, true)`.

---

### CONTRATTO D3: Disaccoppiamento Input da Tastiera & Tasti Rapidi

#### Gestione in `_unhandled_input(event: InputEvent)`:
- `KEY_ESCAPE` / `KEY_C`: chiude la modale con `_on_btn_close_pressed()`;
- `KEY_1`, `KEY_KP_1`: se la scheda corrente non è 1, attiva `select_tab(1)`;
- `KEY_2`, `KEY_KP_2`: se la scheda corrente non è 2, attiva `select_tab(2)`;
- **Quando si è in Scheda 1**:
  - `KEY_A`: lettura agenda impegni dei 7 giorni;
- **Quando si è in Scheda 2**:
  - `KEY_G`: `select_branch("genre_mastery")` (Generi);
  - `KEY_S`: `select_branch("instrumental_technique")` (Strumenti);
  - `KEY_A`: `select_branch("songwriting_harmony")` (Armonia/Composizione);
  - `KEY_P`: `select_branch("stage_showmanship")` (Palco);
  - `KEY_T`: `select_branch("engineering_hardware")` (Studio Tecnico);
  - `KEY_B`: `select_branch("industry_business")` (Business);
  - `KEY_R`: `_read_current_branch_summary()` (Lettura vocale continua del ramo).

---

### CONTRATTO D4: Blindatura Headless & Test di Regressione

#### Obiettivo Tecnico:
Estendere la suite di test headless per verificare deterministicamente a 0 ms l'intera interfaccia di `CharacterSheet`:
1. Istanziazione della scena `character_sheet.tscn` senza errori né leak;
2. Verifica presenza dei nodi `BtnTabProfile`, `BtnTabSkills`, `PanelTabProfile`, `PanelTabSkills`;
3. Verifica transizione tra Scheda 1 e Scheda 2 tramite `select_tab()`;
4. Verifica presenza e correttezza dei valori dei 4 attributi fisiologici innati in Scheda 1;
5. Verifica selezione di tutti i 6 rami in Scheda 2 con controllo che il conteggio delle abilità per ramo coincida esattamente con le 28 canoniche;
6. Verifica lettura vocale riassuntiva `_read_current_branch_summary()`;
7. Verifica che tutte le **31 suite di test del progetto rimangano al 100% verdi con 0 errori a 0 ms**.

---

### CONTRATTO D5: Living Documentation & Consolidamento AVF V5.7.1

#### Obiettivo Tecnico:
Aggiornare la documentazione di progetto:
- `docs/todo.md`: registrazione dell'estensione della Scheda Personaggio a 2 schede con Albero Competenze;
- `knowledge/01_accessibilita_vocale_e_interazione_tastiera.md`: documentazione delle scorciatoie `1`, `2`, `G`, `S`, `A`, `P`, `T`, `B`, `R` nella Scheda Personaggio;
- `CHANGELOG.md`: registrazione della versione `V5.7.1`.

---

## 🚦 6. STOP OBBLIGATORIO DELLA SOTTO-FASE 1A

In rigorosa conformità alla **Regola 0 (Default Consultivo Permanente)** e al **Protocollo 12 (Inner Codex Pattern)**:
- La stesura del presente Piano Tecnico Formale conclude la **Sotto-Fase 1A**.
- Antigravity si arresta e **non modificherà alcun file di codice sorgente né eseguirà interventi di configurazione prima dell'approvazione esplicita di Luca e Thomas**.
