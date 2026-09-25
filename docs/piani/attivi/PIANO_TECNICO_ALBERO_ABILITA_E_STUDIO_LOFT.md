# World-tour — Piano Tecnico Formale: Albero delle Abilità Musicali & Studio Dinamico nel Loft NYC (Sotto-Fase 1A)
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA), Thomas & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Versione Target: AVF V5.7.0 — Albero Competenze 6 Rami, 5 Gradi di Maestria & 4 Metodi di Studio nel Loft NYC
# Data: 25 Settembre 2026
# Percorso File: docs/piani/attivi/PIANO_TECNICO_ALBERO_ABILITA_E_STUDIO_LOFT.md
# File di Riferimento:
#   - GEMINI.md (Hub di Governance Locale)
#   - knowledge/00_consuetudini_operative_e_sinergia_assistente.md (12 Protocolli ASTRALIS & Regola 0)
#   - knowledge/01_accessibilita_vocale_e_interazione_tastiera.md (Standard NVDA Zero Mouse & Volumi Sicuri 0.7f-0.8f)
#   - knowledge/02_architettura_stack_e_runtime.md (Architettura & Determinismo Headless a 0 ms)
#   - docs/report/REPORT_AVVIO_SESSIONE_ALBERO_ABILITA_E_STUDIO.md (Handoff Ufficiale)
#   - docs/strategie/sessione_approfondimento_gameplay/STRATEGIA_INTEGRALE_EVOLUZIONE_GAMEPLAY_POPOMUNDO.md
#   - docs/strategie/sessione_approfondimento_gameplay/STRATEGIA_ALBERO_ABILITA_E_METODI_STUDIO.md
# Baseline AVF: V5.6.4 (30/30 Suite Headless Superate a 0 Errori e 0 ms)
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Fase 1 completata: Sotto-Fase 1A e 1B eseguite con 31/31 suite di test al 100% verdi a 0 ms — Versione AVF V5.7.0)

---

## 🎯 1. OBIETTIVO ARCHITETTURALE E VISIONE GENERALE

Questo piano tecnico formalizza la prima tranche operativa di implementazione profonda ispirata all'archetipo storico di **Popomundo** e della **Popoguida**, adattata all'architettura reattiva, modulare e nativamente accessibile di **World-tour**.

La presente Sotto-Fase 1A definisce in Named Contracts atomici (D0..DN) l'estensione del modello dati del giocatore, le regole di propedeuticità ad albero, i 4 metodi di studio tangibili negli arredi del Loft di New York e la specifica completa della nuova suite di test headless dedicata.

### Principi Cardine Inviolabili:
1. **Regola 0 (Default Consultivo Permanente & Stop Obbligatorio)**:
   - La presente Sotto-Fase 1A redige unicamente il piano tecnico formale.
   - È fatto divieto assoluto di modificare codice sorgente o configurazioni prima dell'approvazione esplicita di Luca e Thomas (*"procedi"*, *"applica"*, *"esegui"*).
2. **Accessibilità Vocale Assoluta (Zero Mouse & NVDA)**:
   - Navigazione lineare sequenziale riga per riga per screen reader NVDA.
   - Divieto assoluto di tabelle 2D, matrici complesse o schemi ASCII; adozione esclusiva di elenchi puntati e logica "Se... Allora".
   - Rispetto ferreo dei volumi di sicurezza audio congelati tra 0.7f e 0.8f, senza coprire mai la voce dello screen reader.
3. **Protocollo 12 (Inner Codex Pattern & Determinismo Headless)**:
   - Risoluzione deterministica delle cause radice (RCA);
   - Named Contracts D0..DN a chiusura stagna;
   - Esecuzione headless deterministica a 0 ms senza dipendenze da tick temporali reali né `OS.delay()`.
4. **Assenza Regressioni & Retrocompatibilità Legacy (Asse 7)**:
   - Tutte le 30 suite di test preesistenti devono rimanere al 100% verdi (30/30) senza alcuna rottura dei contratti precedenti.

---

## 🏛️ 2. CHECKLIST DI CONVALIDA A 3 STATI (MATRICE PER NVDA)

- [x] [CONVALIDATO CON SUCCESSO] Contratto D0: Clean sweep residui, mappatura trasparente di retrocompatibilità del dizionario `skills` legacy e bonifica orfana in `data/models/player_data.gd`.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D1: Estensione del modello dati in `PlayerData` con i 4 Attributi Fisiologici Innati e l'Albero delle Competenze a 6 Rami, 28 abilità e 5 Gradi di Maestria (Stelle 1-5).
- [x] [CONVALIDATO CON SUCCESSO] Contratto D2: Motore logico delle propedeuticità ad albero ("Se... Allora") e guardie di sblocco in `PlayerData`.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D3: Integrazione dei 4 Metodi di Studio negli arredi del Loft NYC in `scenes/apartment/apartment_interactions.gd` (manuali sul divano, accademia alla porta, maestro privato alla chitarra, pratica e ascolto vinili al giradischi con boost passivo di genere musicale).
- [x] [CONVALIDATO CON SUCCESSO] Contratto D4: Integrazione runtime del dispacciamento azioni in `systems/action_system.gd` e sonificazione accessibile in `ui/apartment_hud/apartment_hud.gd` con volumi sicuri 0.7f-0.8f.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D5: Creazione della nuova suite di test headless dedicata `tests/test_skills_and_loft_study_system.gd` e `tests/test_skills_and_loft_study_system.tscn` (convalida 31/31 suite verdi a 0 ms).
- [x] [CONVALIDATO CON SUCCESSO] Contratto D6: Aggiornamento della Living Documentation (`docs/todo.md`, `knowledge/01_accessibilita_vocale_e_interazione_tastiera.md`, `knowledge/02_architettura_stack_e_runtime.md`, `CHANGELOG.md`) e avanzamento versione AVF a `V5.7.0`.

---

## ⚖️ 3. I 7 ASSI DI QUALITÀ ASTRALIS APPLICATI

- **Asse 1 — Validità**: Rispetto rigoroso dei tipi GDScript 2.0 statici (`String`, `int`, `float`, `Dictionary`, `Array`), contratti espliciti e gestione coerente dei tipi di ritorno.
- **Asse 2 — Efficacia**: Risoluzione del divario tra la scheda personaggio generica e la profondità specialistica di Popomundo, offrendo percorsi di crescita differenziati e tangibili nel Loft.
- **Asse 3 — Coerenza**: Perfetta armonia con la Clean Architecture di World-tour, il pattern EventBus a segnali e il ciclo FSM `GAMEPLAY_BUSY` delle interazioni dell'appartamento.
- **Asse 4 — Completezza**: Copertura di tutti i 6 rami canonici, dei 5 gradi di maestria, dei 4 metodi di studio, di tutti i vincoli propedeutici e dei relativi fallback.
- **Asse 5 — Precisione**: Modifiche chirurgiche e modulari a `PlayerData`, `ApartmentInteractions` e `ActionSystem` senza toccare parti non correlate.
- **Asse 6 — Affidabilità & Prestazioni**: Esecuzione deterministica a 0 ms senza allocazioni pesanti a runtime né freeze di sistema.
- **Asse 7 — Assenza Regressioni & Protezione Legacy**: Preservazione integrale della struttura `skills` storica, garantendo che le 30 suite di test già attive rimangano pienamente operative.

---

## 🔬 4. I 3 LIVELLI DI SIMULAZIONE PREVENTIVA

- **Livello 1 — Happy Path (Flusso Lineare Ottimale)**:
  - Il giocatore legge un manuale sul Divano del Loft, sbloccando il Grado 1 di *Teoria Musicale*;
  - Frequenta un corso in Accademia tramite la Porta del Loft per progredire dal Grado 1 al Grado 2;
  - Raggiunto il Grado 2 di *Teoria Musicale*, sblocca l'accesso alle competenze propedeutiche *Composizione Ballate* e *Composizione Inni da Stadio*;
  - Ascolta un vinile Heavy Metal al Giradischi del Loft: rigenera Morale (+20), abbatte lo Stress (-10) e guadagna +25 XP passivi nell'abilità di genere *Heavy Metal*;
  - Ingaggia un Maestro privato per una sessione intensiva alla chitarra, raggiungendo il Grado 4: Virtuoso.
- **Livello 2 — Percorsi Alternativi & Concorrenti**:
  - Il giocatore tenta di studiare in Accademia un'abilità già arrivata al Grado 3: l'azione viene rifiutata con annuncio vocale ("L'Accademia forma fino al Grado 3 Professionista. Per raggiungere i gradi superiori ingaggia un Maestro privato");
  - Il giocatore prova a fare una lezione col Maestro privato senza disporre dei 50 € necessari: l'azione viene inibita preventivamente con messaggio chiaro sul saldo mancante;
  - Il giocatore prova ad allenare una competenza a Grado 0 tramite il Maestro: l'azione viene respinta richiedendo prima lo studio dei fondamenti tramite Manuale.
- **Livello 3 — Corner Cases & Limiti Estremi**:
  - Tentativo di superare il Grado 5: l'accumulo di XP viene bloccato al tetto massimo (Cap Grado 5: Maestro Leggendario, XP congelati a 2000.0);
  - Energia residua inferiore al costo dell'azione: l'azione viene bloccata a monte prima di attivare `GAMEPLAY_BUSY`;
  - Interruzione prematura dell'azione con tasto `Esc`: l'azione si interrompe, nessun XP o costo monetario viene scalato e lo stato torna immediatamente a `GAMEPLAY_IDLE`;
  - Chiamata ai vecchi metodi legacy `get_skill_level()` da parte di test storici: risposta immediata e corretta con valore intero legacy retrocompatibile.

---

## 🛡️ 5. SPECIFICA DETTAGLIATA DEI NAMED CONTRACTS (D0..DN)

---

### CONTRATTO D0: Clean Sweep & Retrocompatibilità Legacy del Modello Competenze

#### Obiettivo Tecnico:
Garantire la coesistenza trasparente tra il vecchio dizionario `skills` di `PlayerData` e il nuovo Albero delle Competenze a 6 rami, eliminando qualsiasi rischio di regressione per le 30 suite di test attive ed evitando campi orfani o logiche disallineate.

#### Modifiche in `data/models/player_data.gd`:
- Preservazione del dizionario storico `skills` contenente le 12 chiavi storiche:
  - `instrument`, `composition`, `songwriting`, `lyrics`, `vocals`, `guitar`, `bass`, `drums`, `production`, `performance`, `charisma`, `business`.
- Mappatura logica bidirezionale tra chiavi legacy e nuove competenze canoniche dell'Albero:
  - *Se* un sistema invoca `get_skill_level("composition")`, *allora* il valore viene sincronizzato dinamicamente con il grado dell'abilità canonica `comp_theory` (moltiplicato per il fattore di scala legacy, es. Grado 1 = 10..20, Grado 5 = 80..99);
  - *Se* un sistema invoca `add_xp_to_skill("composition", amount)`, *allora* l'XP viene distribuito sia al contatore legacy sia all'abilità dell'albero `comp_theory`;
  - *Se* vengono invocati metodi legacy su strumenti (`guitar`, `bass`, `drums`), *allora* si aggiornano coerentemente le competenze `skill_guitar`, `skill_bass`, `skill_drums`.
- Bonifica di ogni eventuale campo temporaneo orfano non registrato nella documentazione di architettura.

---

### CONTRATTO D1: Modello Dati dell'Albero a 6 Rami, 5 Gradi di Maestria & Attributi Innati

#### Obiettivo Tecnico:
Formalizzare all'interno di `PlayerData` la struttura completa dei 4 Attributi Fisiologici Innati e delle 28 Competenze suddivise nei 6 Rami Canonici, regolate dalla scala a 5 Gradi di Padronanza (Stelle 1–5).

#### 1. Gli Attributi Fisiologici Innati:
- Variabili membro in `PlayerData`:
  - `musicality: int = 50`: Musicalità (Orecchio Naturale & Istinto). Determina il tetto massimo (Cap) di qualità raggiungibile durante l'ideazione dei brani (scala 1–100);
  - `intelligence: int = 50`: Intelligenza & Memoria (Capacità di Apprendimento). Riduce i requisiti di tempo virtuale e accelera l'acquisizione di XP da studio e lezioni (scala 1–100);
  - `stamina: int = 50`: Resistenza Fisica (Stamina & Voce). Riduce il consumo energetico durante i concerti live e le tournée, proteggendo da laringiti, tendiniti e burnout (scala 1–100);
  - `charm: int = 50`: Carisma Naturale (Fascino & Magnetismo). Moltiplicatore sul gradimento del pubblico durante gli show e appeal nelle interviste con la stampa (scala 1–100).
- Metodi di accesso:
  - `get_innate_attribute(attr_id: String) -> int`
  - `modify_innate_attribute(attr_id: String, delta: int) -> void`

#### 2. La Scala dei 5 Gradi di Maestria (Stelle 1–5):
- Ciascuna competenza traccia:
  - `grade: int`: Grado di maestria attuale (da 0 a 5);
  - `xp: float`: Punti esperienza accumulati per il grado corrente;
  - `is_unlocked: bool`: Stato di sblocco della competenza.
- Soglie XP progressive per il passaggio di Grado:
  - Grado 0: Non appresa / Bloccata (0 stelle). Richiede studio del manuale base per sbloccare il Grado 1;
  - Grado 1 (★☆☆☆☆): Principiante — Conoscenza elementare (Soglia XP: 100.0);
  - Grado 2 (★★☆☆☆): Praticante — Padronanza scolastica corretta (Soglia XP: 250.0);
  - Grado 3 (★★★☆☆): Professionista — Standard di mestiere per registrazioni e palchi (Soglia XP: 500.0);
  - Grado 4 (★★★★☆): Esperto / Virtuoso — Eccellenza tecnica e bonus scenici (Soglia XP: 1000.0);
  - Grado 5 (★★★★★): Maestro Leggendario — Perfezione artistica assoluta (Soglia XP: 2000.0).

#### 3. I 6 Rami Canonici e le 28 Competenze:

##### Ramo 1: Cultura & Padronanza dei Generi (`genre_mastery`)
- `genre_rock`: Rock Classico & Hard Rock
- `genre_metal`: Heavy Metal & Extreme Metal
- `genre_blues`: Blues & Roots
- `genre_pop`: Pop & Synth-Pop
- `genre_punk`: Punk & Garage
- `genre_jazz`: Jazz & Fusion
- `genre_folk`: Folk & Musica Acustica

##### Ramo 2: Competenze Strumentali & Vocali (`instrumental_technique`)
- `skill_guitar`: Chitarra Elettrica (ritmica, assoli veloci, effettistica)
- `skill_vocals`: Canto & Tecnica Vocale (respirazione diaframmatica, estensione, voce graffiata)
- `skill_bass`: Basso Elettrico (fingerstyle, plettro, slap & groove)
- `skill_drums`: Batteria & Percussioni (timing metronomico, ghost notes, doppio pedale)
- `skill_keyboards`: Tastiere & Sintetizzatori (armonia pianistica, programmazione synth)

##### Ramo 3: Composizione, Armonia & Scrittura (`songwriting_harmony`)
- `comp_theory`: Teoria Musicale & Armonia Funzionale
- `comp_lyrics`: Scrittura Testi & Metrica Poetica
- `comp_ballads`: Composizione Ballate Emozionali (`TEARJERKER_BALLAD`)
- `comp_anthems`: Composizione Inni da Stadio (`GENERATIONAL_ANTHEM`)
- `comp_riffs`: Composizione Riff & Hook Ritmici (`EPIC_RIFF`)
- `comp_history`: Storia & Cultura Musicale del Genere

##### Ramo 4: Palco, Spettacolo & Intrattenimento (`stage_showmanship`)
- `stage_presence`: Presenza Scenica & Postura da Palco
- `stage_crowd`: Interazione col Pubblico (Crowd Control & Cori)
- `stage_improv`: Improvvisazione & Assoli Live
- `stage_athleticism`: Coordinazione Fisica & Atletismo da Palco

##### Ramo 5: Studio, Suono & Liuteria (`engineering_hardware`)
- `tech_production`: Produzione Discografica & Home Studio
- `tech_live_sound`: Tecnico del Suono Live (Live Sound Savvy)
- `tech_lutherie`: Liuteria & Manutenzione Strumentale

##### Ramo 6: Business, Media & Relazioni Industriali (`industry_business`)
- `biz_media`: Relazioni coi Media (Interviste & Reputazione)
- `biz_negotiation`: Negoziazione Contrattuale & Royalties
- `biz_marketing`: Marketing Digitale & Social Branding

#### 4. Metodi Pubblici Aggiunti in `PlayerData`:
- `get_skill_grade(skill_id: String) -> int`: restituisce il grado da 0 a 5.
- `get_skill_stars_display(skill_id: String) -> String`: restituisce la rappresentazione a stelle (es. "★★★☆☆" o "Grado 3 su 5") ottimizzata per NVDA.
- `add_skill_tree_xp(skill_id: String, amount: float) -> Dictionary`: aggiunge XP, applica il moltiplicatore dell'attributo `intelligence`, calcola il passaggio di grado, emette il segnale `EventBus.skill_leveled_up` e restituisce il report dettagliato:
  `{"success": bool, "skill_id": String, "old_grade": int, "new_grade": int, "leveled_up": bool, "current_xp": float, "required_xp": float}`.
- `get_branch_skills(branch_id: String) -> Array[Dictionary]`: restituisce l'elenco delle competenze appartenenti a un ramo specifico.
- `is_skill_unlocked(skill_id: String) -> bool`: verifica se la competenza è stata sbloccata dal Grado 0.

---

### CONTRATTO D2: Motore Logico delle Propedeuticità ad Albero ("Se... Allora")

#### Obiettivo Tecnico:
Implementare le guardie logiche deterministiche che disciplinano l'accesso alle competenze avanzate, garantendo una progressione organica ed evitando l'apprendimento disordinato.

#### Regole Logiche Determistiche:
- *Se* `comp_theory` ha un grado inferiore a 2, *allora* `comp_ballads` e `comp_anthems` non possono essere sbloccate né allenate (messaggio: *"Richiede Grado 2 in Teoria Musicale"*).
- *Se* `stage_presence` ha un grado inferiore a 2, *allora* `stage_athleticism` non può essere sbloccata né allenata (messaggio: *"Richiede Grado 2 in Presenza Scenica"*).
- *Se* una competenza è a Grado 0 (non ancora sbloccata), *allora* non può essere allenata in Accademia né con il Maestro privato; deve essere prima sbloccata a Grado 1 tramite la lettura del rispettivo Manuale di testo.
- *Se* una competenza raggiunge il Grado 3, *allora* non può più essere migliorata frequentando l'Accademia (cap massimo istituzionale: Grado 3); richiede sessioni con Maestro privato o pratica intensiva.
- *Se* una competenza raggiunge il Grado 5, *allora* ogni ulteriore accumulo di XP viene rifiutato con messaggio di completamento massimo raggiunto.

#### Metodi di Verifica in `PlayerData`:
- `can_unlock_skill(skill_id: String) -> Dictionary`:
  - Ritorna `{"can_unlock": bool, "reason": String, "missing_prereqs": Array}`.
- `get_skill_prerequisites(skill_id: String) -> Array[Dictionary]`:
  - Ritorna l'elenco dei requisiti propedeutici con rispettivo stato (es. `[{"skill_id": "comp_theory", "required_grade": 2, "current_grade": 1, "satisfied": false}]`).

---

### CONTRATTO D3: I 4 Metodi di Studio Integrati nel Loft NYC (`ApartmentInteractions`)

#### Obiettivo Tecnico:
Arricchire il catalogo delle azioni interattive degli arredi del Loft di New York con le 4 routine di apprendimento concrete, collegate al tempo virtuale, ai costi in denaro e all'ascolto musicale attivo.

#### Catalogo Nuove Azioni in `scenes/apartment/apartment_interactions.gd`:

##### 1. Metodo 1 — Manuali & Libri di Testo (Auto-apprendimento iniziale)
- **Arredo Divano (`couch`) & Letto (`bed`)**:
  - Azione `couch_study_manual`:
    - Titolo: *"Studio su manuale teorico"*
    - Descrizione: *"Leggi un testo fondamentale per apprendere le basi o sbloccare una nuova competenza da zero (-12 Energia, +4 Stress, +2 Morale)."*
    - Durata temporale: `duration_seconds: 10.0`
    - Effetti: `energy_delta: -12`, `stress_delta: 4`, `morale_delta: 2`, `money_cost: 0.0`
    - Risultato: Se la competenza target è a Grado 0, viene sbloccata a Grado 1 (Principiante); altrimenti conferisce +35 XP all'abilità.

##### 2. Metodo 2 — Corsi Accademici & Conservatorio (Formazione Istituzionale)
- **Arredo Porta d'Uscita (`door`)**:
  - Azione `door_academy_course`:
    - Titolo: *"Lezione in Accademia Musicale"*
    - Descrizione: *"Frequenta una sessione pomeridiana al conservatorio cittadino (Costo 30.00 €, -18 Energia, +5 Morale)."*
    - Durata temporale: `duration_seconds: 12.0`
    - Effetti: `energy_delta: -18`, `stress_delta: 0`, `morale_delta: 5`, `money_cost: 30.0`
    - Risultato: Allena competenze fino al Grado 3 (Professionista), conferendo +45 XP. Se l'abilità ha già raggiunto il Grado 3, blocca l'azione indicando la necessità di un Maestro privato.

##### 3. Metodo 3 — Lezioni Private col Maestro NPC (Mentore a Domicilio)
- **Arredo Chitarra (`guitar`) & Divano (`couch`)**:
  - Azione `guitar_mentor_lesson`:
    - Titolo: *"Lezione privata col Maestro"*
    - Descrizione: *"Sessione intensiva a domicilio con un maestro veterano per perfezionare la tecnica (Costo 50.00 €, -22 Energia, +8 Stress, +10 Morale)."*
    - Durata temporale: `duration_seconds: 12.0`
    - Effetti: `energy_delta: -22`, `stress_delta: 8`, `morale_delta: 10`, `money_cost: 50.0`
    - Risultato: Conferisce un consistente incremento di XP (+75 XP), ideale per accelerare dal Grado 3 verso Grado 4 (Virtuoso) e Grado 5 (Leggendario).

##### 4. Metodo 4 — Pratica Individuale & Ascolto Vinili con Boost Passivo di Genere
- **Arredo Chitarra (`guitar`)**:
  - Azione `guitar_practice` (aggiornata):
    - Oltre all'incremento XP strumentale legacy, alimenta direttamente la competenza `skill_guitar` nell'Albero a 6 rami.
- **Arredo Giradischi (`turntable`)**:
  - Oltre all'ispezione ordinaria e all'ascolto rilassante, introduzione delle sessioni di ascolto attivo per Genere Musicale:
    * Azione `turntable_listen_rock`: *"Ascolto Vinile Classic Rock"*
      - Durata: 12.0s, Morale: +20, Stress: -10, Scintilla: 35%, **Boost Passivo: +25 XP su `genre_rock`**.
    * Azione `turntable_listen_metal`: *"Ascolto Vinile Heavy Metal"*
      - Durata: 12.0s, Morale: +20, Stress: -10, Scintilla: 35%, **Boost Passivo: +25 XP su `genre_metal`**.
    * Azione `turntable_listen_blues`: *"Ascolto Vinile Blues & Roots"*
      - Durata: 12.0s, Morale: +20, Stress: -10, Scintilla: 35%, **Boost Passivo: +25 XP su `genre_blues`**.
    * Azione `turntable_listen_jazz`: *"Ascolto Vinile Jazz & Fusion"*
      - Durata: 12.0s, Morale: +20, Stress: -10, Scintilla: 35%, **Boost Passivo: +25 XP su `genre_jazz`**.
    * Azione `turntable_study`: *"Analisi Critica Missaggio"*
      - Durata: 10.0s, Morale: +5, Stress: 0, **Boost Passivo: +25 XP su `tech_production`**.

---

### CONTRATTO D4: Integrazione Runtime del Dispacciamento & Sonificazione Accessibile

#### Obiettivo Tecnico:
Aggiornare il motore di esecuzione azioni (`ActionSystem`) e il controller dell'HUD del Loft (`ApartmentHud`) per recepire le nuove azioni di studio, calcolare i level-up di grado e notificare i risultati via sintesi vocale NVDA senza violare i volumi sicuri.

#### Modifiche in `systems/action_system.gd`:
- Nel metodo `_complete_action()`:
  - Riconoscere i target skill appartenenti sia al dizionario legacy sia all'Albero delle Competenze (`genre_*`, `skill_*`, `comp_*`, `stage_*`, `tech_*`, `biz_*`);
  - Invocare `player.add_skill_tree_xp(target_skill, gained_xp)`;
  - Se l'azione ha generato un level-up di grado (da stella N a stella N+1), emettere l'evento `EventBus.skill_leveled_up` con payload contenente `skill_id`, `new_grade` e la stringa leggibile del grado.

#### Modifiche in `ui/apartment_hud/apartment_hud.gd`:
- Aggiornare il router di esecuzione azioni `execute_interaction_action()` e `_apply_action_effects()` per gestire i parametri `tree_skill_target` e `xp_amount`;
- Quando un'azione di studio o ascolto vinile si completa con successo:
  - Emettere l'annuncio vocale tramite `AccessibilityManager.announce()` specificando l'XP guadagnato, l'eventuale aumento di grado e la nuova qualifica a stelle (es. *"Sessione completata! Heavy Metal ha raggiunto il Grado 2: Praticante"*);
  - Garantire che ogni effetto sonoro o earcon associato rispetti il limite massimo di volume compreso tra 0.7f e 0.8f.

---

### CONTRATTO D5: Nuova Suite di Test Headless Dedicata & Zero Errori a 0 ms

#### Obiettivo Tecnico:
Creare la nuova suite di test automatizzati headless dedicata:
`tests/test_skills_and_loft_study_system.gd` con la rispettiva scena Godot:
`tests/test_skills_and_loft_study_system.tscn`.

#### Batteria di Verifiche della Suite (Zero Latenze Artificiali, Determinismo Assoluto):
1. **Verifica Inizializzazione Albero & Attributi Innati**:
   - Presenza e range corretto (1–100) per `musicality`, `intelligence`, `stamina`, `charm`.
   - Struttura corretta dei 6 rami e presenza di tutte le 28 competenze canoniche.
2. **Verifica Scala a 5 Gradi di Padronanza (Stelle 1–5)**:
   - Controllo progressione XP deterministica da Grado 0 a Grado 5;
   - Calcolo corretto delle soglie (100, 250, 500, 1000, 2000 XP);
   - Blocco dell'accumulo XP al raggiungimento del Grado 5 (Cap Leggendario).
3. **Verifica Regole di Propedeuticità ("Se... Allora")**:
   - Tentativo di sbloccare *Composizione Ballate* o *Inni da Stadio* con Teoria Musicale a Grado 1: esito bloccato con motivazione esplicita;
   - Sblocco convalidato quando Teoria Musicale raggiunge il Grado 2;
   - Tentativo di sbloccare *Coordinazione Fisica* con Presenza Scenica a Grado 1: esito bloccato;
   - Sblocco convalidato quando Presenza Scenica raggiunge il Grado 2.
4. **Verifica dei 4 Metodi di Studio nel Loft NYC**:
   - *Manuale sul Divano*: passaggio da Grado 0 a Grado 1 Principiante verificato;
   - *Accademia alla Porta*: avanzamento da Grado 1 a Grado 3 con costo di 30 €; blocco deterministico al superamento del Grado 3;
   - *Maestro Privato alla Chitarra*: avanzamento intensivo oltre il Grado 3 con costo di 50 €; rifiuto se i fondi sono insufficienti;
   - *Pratica Individuale*: incremento XP chitarra a costo zero.
5. **Verifica Boost Passivo all'Ascolto dei Vinili sul Giradischi**:
   - Ascolto vinile Rock Classico: aumento Morale (+20), riduzione Stress (-10) e incremento passivo di +25 XP in `genre_rock`;
   - Ascolto vinile Heavy Metal: incremento passivo di +25 XP in `genre_metal`;
   - Ascolto vinile Blues & Roots: incremento passivo di +25 XP in `genre_blues`;
   - Analisi missaggio su stereo/giradischi: incremento passivo di +25 XP in `tech_production`.
6. **Verifica Retrocompatibilità Legacy Assoluta (Zero Regressioni)**:
   - Lettura e scrittura sul dizionario storico `player.skills` e chiamate a `player.get_skill_level()` perfettamente preservate;
   - Esecuzione delle 30 suite storiche più la nuova suite dedicata (31/31 suite verdi con exit code 0 a 0 ms).

---

### CONTRATTO D6: Living Documentation & Consolidamento AVF V5.7.0

#### Obiettivo Tecnico:
Aggiornare tutti i documenti di coordinamento e conoscenza di World-tour:
- `docs/todo.md`: registrazione dell'avvio della Sezione Competenze & Metodi di Studio e aggiornamento roadmap;
- `knowledge/01_accessibilita_vocale_e_interazione_tastiera.md`: documentazione delle nuove opzioni accessibili del Loft e annunci vocali dei gradi a stelle;
- `knowledge/02_architettura_stack_e_runtime.md`: registrazione della 31-esima suite di test headless convalidata;
- `CHANGELOG.md`: registrazione formale delle nuove funzionalità sotto la versione AVF `V5.7.0`.

---

## 🚦 6. STOP OBBLIGATORIO DELLA SOTTO-FASE 1A

In rigorosa conformità alla **Regola 0 (Default Consultivo Permanente)** e al **Protocollo 12 (Inner Codex Pattern)**:
- La stesura del presente Piano Tecnico Formale conclude la **Sotto-Fase 1A**.
- Antigravity si arresta e **non modificherà alcun file di codice sorgente né eseguirà interventi di configurazione prima dell'approvazione esplicita di Luca e Thomas**.
