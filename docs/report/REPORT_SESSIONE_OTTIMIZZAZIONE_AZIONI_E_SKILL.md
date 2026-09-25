# Report di Sessione Specialistica — Ottimizzazione Sistemica Azioni, Competenze & Studio Selettivo (Fase 0)
# Progetto: World-tour (Music Career Simulator)
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA), Thomas & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-25
# Percorso File: docs/report/REPORT_SESSIONE_OTTIMIZZAZIONE_AZIONI_E_SKILL.md
# Riferimenti Normativi:
#   - GEMINI.md & AGENTS.md (Hub di Governance & Regola 0)
#   - docs/report/REGISTRO_REVISIONI.md (Voce Attiva RRU-29)
#   - docs/strategie/sessione_approfondimento_gameplay/STRATEGIA_OTTIMIZZAZIONE_AZIONI_SKILL_E_STUDIO_SELETTIVO.md
# Baseline AVF: V5.7.1 (31/31 Suite Headless Superate a 0 Errori e 0 ms)
# Modalità Operativa: Analitico-Consultiva Permanente (Zero Modifiche al Codice Sorgente di Produzione)

---

## 🎯 1. MANDATO RICEVUTO DA LUCA & PERIMETRO DELL'ANALISI

In data 25 Settembre 2026, lo sviluppatore senior Luca ha impartito la seguente direttiva di ricerca e progettazione per il simulatore musicale **World-tour**:
1. **Collegamento Efficace e Coerente Azioni <-> Skill**: Rivedere l'intero impianto di gioco per garantire sinergia, inclusività ed equilibrio tra le azioni a disposizione del giocatore e le 31 competenze dell'Albero delle Abilità (ispirato all'archetipo storico di Popomundo e della Popoguida).
2. **Differenziazione dei Metodi di Studio & Allenamento**: Disciplinare in modo coerente e bilanciato l'incremento di abilità attraverso i 4 canali:
   - *Manuali e Libri di Testo*;
   - *Corsi in Accademia / Conservatorio*;
   - *Lezioni Private con il Maestro / Mentore a Domicilio*;
   - *Pratica Individuale & Esperienza Empirica sul Campo*.
3. **Predisposizione dei Due Selettori a Scelta Singola (L'Intuizione di Luca)**: Nel caso di studio da manuale, accademia o maestro privato, predisporre come test un elenco a scelta singola contenente l'elenco completo delle 31 abilità presenti nel sistema (`SkillStudyPicker`), e per la pratica quotidiana alla postazione musicale l'elenco delle 8 discipline strumentali e vocali (`InstrumentPracticePicker`), consentendo al giocatore di scegliere liberamente e deliberatamente la skill da allenare con lettura lineare per screen reader NVDA.
4. **Modalità Operativa Rigorosamente Consultiva (Regola 0)**: Redigere il documento di approfondimento strategico in `docs/strategie/`, aggiornare il registro revisioni in `docs/report/` e formulare in chat un riepilogo sintetico e strutturato senza toccare codice di produzione prima del comando esplicito di Luca (*"passa alla fase 1"* / *"procedi"*).

---

## 🔍 2. DIAGNOSI DELL'ATTUALE ARCHITETTURA (STATO DELL'ARTE)

L'analisi diagnostica del codebase alla release **V5.7.1** evidenzia i seguenti punti di forza e aree di perfezionamento:

### Punti di Forza Consolidati:
- In `data/models/player_data.gd` sono già stati integrati con successo:
  * I 4 Attributi Fisiologici Innati (`musicality`, `intelligence`, `stamina`, `charm`);
  * I 6 Rami Canonici (`genre_mastery`, `instrumental_technique`, `songwriting_harmony`, `stage_showmanship`, `engineering_hardware`, `industry_business`);
  * Le 28 Competenze Specialistiche di base con progressione a 5 Gradi di Padronanza (Stelle 1-5);
  * Il motore di propedeuticità ad albero deterministico ("Se... Allora");
  * La Scheda Personaggio a due sezioni tabulate (`CharacterSheet`) con navigazione e lettura vocale continua per NVDA.

### Aree di Disallineamento Riscontrate:
1. **Azioni nel Loft Hardcodate su Singole Abilità**:
   - In `scenes/apartment/apartment_interactions.gd`, l'azione `couch_study_manual` allena unicamente `comp_theory`; l'azione `door_academy_course` allena unicamente `comp_theory`; l'azione `guitar_mentor_lesson` allena unicamente `skill_guitar`. Il giocatore non ha alcuna facoltà di scegliere quale materia studiare sul divano, quale corso seguire in conservatorio o quale strumento/tecnica farsi insegnare dal maestro!
2. **Chiavi Spurie e Competenze Disconnesse**:
   - Alla cassa attrezzi (`toolbox`), l'azione `toolbox_check` allena una chiave spuria `live_performance` (non appartenente ai 6 rami canonici); l'azione `toolbox_maintain` non assegna alcun XP, privando l'abilità `tech_lutherie` di un punto d'allenamento naturale.
   - L'azione `couch_jam` allena la chiave legacy `composition` invece delle competenze canoniche `comp_riffs` o `comp_theory`.
3. **Mancanza di Differenziazione dei Tetti Massimi (Cap) per Metodo di Studio**:
   - Attualmente non vi è un blocco esplicito che impedisca di portare una competenza a Grado 5 leggendo solo manuali sul divano, o che limiti l'accademia istituzionale al Grado 3 come avviene nei conservatori reali.

---

## 💡 3. LA SOLUZIONE ARCHITETTURALE: I 4 PILASTRI SISTEMICI

### Pilastro A — Disciplina Rigorosa dei 4 Metodi di Studio & Cap di Maestria:

1. **Studio su Manuale / Libro (Autoapprendimento Teorico)**:
   - *Scopo Unico*: È l'**unico metodo autorizzato a sbloccare una competenza da Grado 0 (Non Appresa) a Grado 1 (Principiante)**!
   - *Range di Efficacia*: Dal Grado 0 al Grado 2 (Praticante).
   - *Tetto Massimo (Cap)*: **Grado 2**. Oltre il Grado 2, il manuale da solo non basta più: serve il confronto pratico con docenti o mentori.
   - *Costo & Fisiologia*: `0.0 €`, `-12 Energia`, `+4 Stress`, `+2 Morale`, `+35.0 XP` base (scalati da `intelligence`).
2. **Corsi in Accademia / Conservatorio (Formazione Istituzionale Formale)**:
   - *Requisito*: Competenza **già sbloccata ad almeno Grado 1** (le basi devono essere già assimilate dal manuale).
   - *Range di Efficacia*: Dal Grado 1 al Grado 3 (Professionista).
   - *Tetto Massimo (Cap)*: **Grado 3**. L'accademia forma ottimi professionisti di mestiere, ma non può formare fuoriclasse assoluti o virtuosi leggendari da stadio.
   - *Costo & Fisiologia*: `30.00 €`, `-18 Energia`, `0 Stress`, `+5 Morale`, `+50.0 XP` base.
3. **Lezioni Private col Maestro NPC (Mentore a Domicilio / Virtuosismo d'Élite)**:
   - *Requisito*: Competenza **già sbloccata ad almeno Grado 1**.
   - *Range di Efficacia*: Dal Grado 1 al Grado 5 (Maestro Leggendario). È il canale d'eccellenza per superare il Grado 3 e conquistare il Grado 4 (Virtuoso) e il Grado 5 (Maestro Leggendario).
   - *Tetto Massimo (Cap)*: **Grado 5**.
   - *Costo & Fisiologia*: `50.00 €` (o `75.00 €`), `-22 Energia`, `+8 Stress`, `+10 Morale`, `+80.0 XP` intensivi.
4. **Pratica Individuale & "Learning by Doing" (Esperienza Empirica Multi-Strumento)**:
   - *Pratica Strumentale & Vocale Domestica*: `guitar_practice` ("Scale e riff") non è più hardcodata sulla sola chitarra! Consente di selezionare e allenare qualsiasi strumento del Ramo 2: Chitarra Elettrica (`skill_guitar`), Canto & Tecnica Vocale (`skill_vocals`), Basso Elettrico (`skill_bass`), Batteria & Percussioni (`skill_drums`), Tastiere & Synth (`skill_keyboards`) e strumenti futuri; assegna `+20.0 XP` costanti a costo zero (`-10 Energia`, `+3 Stress`, `+5 Morale`).
   - *Ascolto Vinili*: I 7 vinili tematici al giradischi assegnano `+25.0 XP` passivi alla competenza del genere ascoltato, con abbattimento stress (`-10`) e rigenerazione morale (`+20`).
   - *Live & Creazione*: Concerti dal vivo assegnano XP a palco e strumenti; composizione assegna XP a teoria, testi e riff; interviste assegnano XP ai media; setup chitarra assegna XP a liuteria.

---

### Pilastro B — I Due Selettori a Scelta Singola per NVDA (`SkillStudyPicker` & `InstrumentPracticePicker`):

1. **Il Selettore dello Studio Generale (`SkillStudyPicker` — 28 Abilità)**:
   - Attivato da: *"Studio su manuale teorico"* (Divano/Letto), *"Lezione in Accademia"* (Porta), *"Lezione col Maestro"* (Chitarra);
   - Mostra tutte le 28 competenze canoniche raggruppate per ramo;
   - Espone grado a stelle e filtro di idoneità rispetto al metodo scelto;
   - Navigabile con Frecce, Numpad e tasti rapidi ramo (`G`, `S`, `A`, `P`, `T`, `B`).

2. **Il Selettore di Pratica Strumentale & Vocale (`InstrumentPracticePicker` — Ramo 2)**:
   - Attivato da: *"Scale e riff"* (Postazione musicale / Chitarra nel Loft);
   - Mostra l'elenco delle discipline strumentali e vocali del sistema (Chitarra, Canto, Basso, Batteria, Tastiere);
   - Evidenzia lo `[STRUMENTO PRINCIPALE]` scelto dal giocatore nella creazione del personaggio;
   - La voce (Canto) è sempre accessibile senza requisiti di hardware; gli altri strumenti indicano la disponibilità;
   - Selezionando la disciplina desiderata e premendo Invio, parte la sessione da 10 secondi in `GAMEPLAY_BUSY`, accreditando `+20.0 XP` direttamente all'abilità scelta!

---

## 📊 4. DOCUMENTI PRODOTTI & STATO DI GOVERNANCE

Nella presente sessione sono stati prodotti e aggiornati:
1. **Documento di Approfondimento Strategico (Fase 0)**:
   [`docs/strategie/sessione_approfondimento_gameplay/STRATEGIA_OTTIMIZZAZIONE_AZIONI_SKILL_E_STUDIO_SELETTIVO.md`](../strategie/sessione_approfondimento_gameplay/STRATEGIA_OTTIMIZZAZIONE_AZIONI_SKILL_E_STUDIO_SELETTIVO.md)
   *Analisi integrale di 7 sezioni con matrice esaustiva di tutte le 31 competenze, regole dei 4 metodi e specifiche dei selettori.*
2. **Piano Tecnico Formale (Sotto-Fase 1A)**:
   [`docs/piani/attivi/PIANO_TECNICO_OTTIMIZZAZIONE_AZIONI_SKILL_E_STUDIO_SELETTIVO.md`](../piani/attivi/PIANO_TECNICO_OTTIMIZZAZIONE_AZIONI_SKILL_E_STUDIO_SELETTIVO.md)
   *Piano dettagliato con contratti atomici D0..D5 validato sui 7 Assi di Qualità e approvato da Luca.*
3. **Aggiornamento del Registro Revisioni (`REGISTRO_REVISIONI.md`)**:
   *Revisione `RRU-29 — Ottimizzazione Sistemica Collegamento Azioni-Skill & Studio Selettivo 31 Abilità` aggiornata a `[/] [IMPLEMENTATA — IN ATTESA DI CONVALIDA MANUALE (FASE 2)]`.*
4. **Changelog & Versionamento AVF**:
   *Rilascio documentale V5.8.0 registrato in `CHANGELOG.md` e `project.godot`.*

---

## 🚦 5. ESITO SOTTO-FASE 1B & PASSAGGIO ALLA FASE 2 (COLLAUDO NVDA)

L'implementazione tecnica della Sotto-Fase 1B è stata completata con successo:
- **Contratto D0**: Catalogo competenze esteso a 31 abilità in `PlayerData` (8 discipline nel Ramo 2).
- **Contratto D1**: Motore di convalida idoneità `validate_study_eligibility(skill_id, method)` con tetti di grado e annunci vocali.
- **Contratto D2**: Componente `InstrumentPracticePicker` per "Scale e riff" (tasti `1`..`8`, Frecce, Invio, Esc).
- **Contratto D3**: Componente `SkillStudyPicker` per studio selettivo (tasti ramo `G, S, A, P, T, B, 0`, Frecce, Invio, Esc).
- **Contratto D4**: Riconnessione arredi Loft NYC (`ApartmentInteractions`) e instradamento HUD (`ApartmentHud`) con FSM `GAMEPLAY_BUSY`.
- **Contratto D5**: Test suite `test_skills_and_loft_study_system.gd` espansa a 171 asserzioni verdi; **31/31 suite headless superate a 0 errori e 0 ms** (`tools/test.ps1`); 117/117 file GDScript verificati (`tools/check.ps1`).

Lo stato attuale è pronto per il **Collaudo Manuale Diretto di Luca con Screen Reader NVDA (Fase 2)** nel Loft NYC.

