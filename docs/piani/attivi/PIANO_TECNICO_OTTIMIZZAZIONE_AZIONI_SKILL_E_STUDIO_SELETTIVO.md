# World-tour — Piano Tecnico Formale: Ottimizzazione Sistemica Azioni, Competenze & Studio Selettivo (Sotto-Fase 1A)
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA), Thomas & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Versione Target: AVF V5.8.0 — Catalogo 31 Competenze Canoniche, Pratica Multi-Strumento & Due Selettori per NVDA
# Data: 25 Settembre 2026
# Percorso File: docs/piani/attivi/PIANO_TECNICO_OTTIMIZZAZIONE_AZIONI_SKILL_E_STUDIO_SELETTIVO.md
# File di Riferimento:
#   - GEMINI.md & AGENTS.md (Hub di Governance & Regola 0)
#   - knowledge/00_consuetudini_operative_e_sinergia_assistente.md (12 Protocolli ASTRALIS & Gating Semantico)
#   - knowledge/01_accessibilita_vocale_e_interazione_tastiera.md (Standard NVDA Zero Mouse & Volumi Sicuri 0.7f-0.8f)
#   - knowledge/02_architettura_stack_e_runtime.md (Architettura & Determinismo Headless a 0 ms)
#   - docs/report/REGISTRO_REVISIONI.md (Voce Attiva RRU-29)
#   - docs/report/REPORT_SESSIONE_OTTIMIZZAZIONE_AZIONI_E_SKILL.md (Report di Sessione)
#   - docs/strategie/sessione_approfondimento_gameplay/STRATEGIA_OTTIMIZZAZIONE_AZIONI_SKILL_E_STUDIO_SELETTIVO.md
# Baseline AVF: V5.7.1 (31/31 Suite Headless Superate a 0 Errori e 0 ms)
# Stato: [/] [IN LAVORAZIONE] (Sotto-Fase 1A completata: Piano Tecnico Formale redatto — STOP OBBLIGATORIO prima del codice)

---

## 🎯 1. OBIETTIVO ARCHITETTURALE E VISIONE GENERALE

Questo piano tecnico formalizza la seconda tranche evolutiva dedicata all'Albero delle Abilità di **World-tour**, focalizzandosi sull'**ottimizzazione sistemica del collegamento tra azioni e competenze**, sull'inclusione di tutte le discipline strumentali e vocali nell'allenamento quotidiano nel Loft NYC, e sull'implementazione dei **due selettori interattivi accessibili a scelta singola per NVDA (Zero Mouse)**.

### Principi Cardine Inviolabili:
1. **Regola 0 (Default Consultivo Permanente & Stop Obbligatorio della 1A)**:
   - La presente Sotto-Fase 1A redige unicamente il Piano Tecnico Formale.
   - È fatto divieto assoluto di modificare codice sorgente o configurazioni prima dell'approvazione esplicita di Luca e Thomas (*"procedi"*, *"applica"*, *"esegui"*).
2. **Accessibilità Vocale Assoluta (Zero Mouse & NVDA)**:
   - Nessun menu o selettore deve richiedere il mouse o visualizzazioni grafiche 2D complesse.
   - Navigazione lineare sequenziale riga per riga (Frecce, Numpad 8/2, numeri diretti e tasti rapidi ramo).
   - Annunci vocali immediati per NVDA con indicazione di nome competenza, grado a stelle e idoneità/requisiti.
3. **Inclusività Totale & Zero Abilità Orfane**:
   - Espansione del Ramo 2 da 5 a 8 competenze con l'aggiunta di `skill_horns` (Fiati/Sax), `skill_strings` (Archi/Violino) e `skill_harmonica` (Armonica/Folk), portando l'Albero a 31 abilità canoniche complessive.
   - L'azione quotidiana "Scale e riff" non è più hardcodata sulla sola chitarra ma permette di scegliere liberamente quale strumento o canto allenare.
4. **Protocollo 12 & Determinismo Headless**:
   - Risoluzione deterministica delle cause radice (RCA);
   - Named Contracts D0..D6 a chiusura stagna;
   - Esecuzione headless deterministica a 0 ms senza dipendenze da tick temporali reali né `OS.delay()`;
   - Tutte le 31 suite di test preesistenti devono rimanere al 100% verdi (31/31) portando la nuova suite a convalidare la 32ª suite verde.

---

## 🏛️ 2. CHECKLIST DI CONVALIDA A 3 STATI (MATRICE PER NVDA)

- [ ] [DA AVVIARE] Contratto D0: Clean sweep residui, bonifica chiavi spurie (`live_performance`), sincronizzazione retrocompatibile del dizionario legacy `skills` in `data/models/player_data.gd`.
- [ ] [DA AVVIARE] Contratto D1: Estensione del modello dati in `PlayerData` con le 3 nuove competenze canoniche del Ramo 2 (`skill_horns`, `skill_strings`, `skill_harmonica`), aggiornamento a 31 abilità e logica di idoneità metodo studio/pratica (`validate_study_eligibility(skill_id, method_type)`).
- [ ] [DA AVVIARE] Contratto D2: Creazione del componente UI accessibile `InstrumentPracticePicker` per la pratica multi-strumento e vocale nel Loft (8 discipline, indicazione strumento principale, 100% Zero Mouse per NVDA).
- [ ] [DA AVVIARE] Contratto D3: Creazione del componente UI accessibile `SkillStudyPicker` per lo studio selettivo universale (31 competenze, filtri per ramo `G,S,A,P,T,B`, lettura lineare gradi a stelle e guardie di cap metodo).
- [ ] [DA AVVIARE] Contratto D4: Aggiornamento del catalogo azioni in `scenes/apartment/apartment_interactions.gd` e del router in `ui/apartment_hud/apartment_hud.gd` per agganciare i nuovi selettori a Divano, Letto, Porta, Chitarra e Cassa Attrezzi.
- [ ] [DA AVVIARE] Contratto D5: Espansione della suite di test headless dedicata `tests/test_skills_and_loft_study_system.gd` per convalidare le 31 abilità, i 2 selettori, i vincoli di idoneità e l'allenamento multi-strumento a 0 ms con 0 errori (32/32 suite verdi).
- [ ] [DA AVVIARE] Contratto D6: Aggiornamento della Living Documentation (`docs/todo.md`, `knowledge/01_accessibilita_vocale_e_interazione_tastiera.md`, `knowledge/02_architettura_stack_e_runtime.md`, `CHANGELOG.md`), chiusura revisione RRU-29 e avanzamento versione AVF a `V5.8.0`.

---

## ⚖️ 3. I 7 ASSI DI QUALITÀ ASTRALIS APPLICATI

- **Asse 1 — Validità**: Contratti tipizzati in GDScript 2.0 statico, tipi espliciti per metodi e ritorni (`Dictionary`, `Array[Dictionary]`, `String`, `int`, `float`), gestione sicura dei dizionari.
- **Asse 2 — Efficacia**: Risoluzione radicale delle azioni hardcodate; il giocatore può finalmente forgiare la propria identità musicale scegliendo liberamente materie di studio e strumenti da praticare.
- **Asse 3 — Coerenza**: Perfetta armonia con la Clean Architecture di World-tour, l'EventBus, il pattern FSM `GAMEPLAY_BUSY` e i contratti consolidati di `ApartmentInteractions`.
- **Asse 4 — Completezza**: Copertura integrale di tutte le 31 competenze, degli 8 strumenti/voce, dei 4 metodi di apprendimento, dei tetti massimi (Cap) e di tutti i messaggi di rifiuto o errore.
- **Asse 5 — Precisione**: Modifiche chirurgiche e modulari senza alterare il funzionamento delle altre 19 modali dell'appartamento né la fluidità cinetica di Alex a 210 px/s.
- **Asse 6 — Affidabilità & Prestazioni**: Nessuna allocazione pesante nel loop di processo; menu istantanei con pre-caching audio a 0 ms e volumi salvavita (<= 0.75f).
- **Asse 7 — Assenza Regressioni & Protezione Legacy**: Preservazione trasparente del dizionario `skills` storico e di tutti i getter/setter legacy; 31 suite storiche al 100% operative.

---

## 🔬 4. I 3 LIVELLI DI SIMULAZIONE PREVENTIVA

- **Livello 1 — Happy Path (Flusso Lineare Ottimale)**:
  - Il giocatore interagisce con la postazione chitarra e sceglie "Scale e riff": si apre `InstrumentPracticePicker`; Alex seleziona `Canto & Tecnica Vocale`; parte l'azione da 10s; al completamento riceve +20 XP in `skill_vocals` con annuncio vocale chiaro di NVDA;
  - Il giocatore va al Divano e seleziona "Studio su manuale teorico": si apre `SkillStudyPicker`; preme `S` per saltare al Ramo Strumenti, sceglie `Fiati, Tromba & Sassofono` (attualmente a Grado 0); il manuale la sblocca a Grado 1 Principiante (+35 XP);
  - Il giocatore va alla Porta del Loft e seleziona "Lezione in Accademia": sceglie `Teoria Musicale & Armonia` (a Grado 1); l'azione costa 30.00 € e conferisce +50 XP portandola a Grado 2 Praticante;
  - Raggiunto il Grado 2 in Teoria, sblocca l'accesso alle competenze propedeutiche `Composizione Ballate` e `Inni da Stadio`.
- **Livello 2 — Percorsi Alternativi & Concorrenti**:
  - Tentativo di studiare in Accademia una competenza a Grado 0 (Non Appresa): l'azione viene rifiutata con annuncio: *"L'Accademia richiede le basi teoriche: sblocca prima il Grado 1 leggendo il rispettivo Manuale"*;
  - Tentativo di studiare da Manuale una competenza già arrivata a Grado 2: rifiutata con annuncio: *"Hai appreso tutte le nozioni teoriche di questo manuale. Per raggiungere il Grado 3 frequenta l'Accademia o un Maestro Privato"*;
  - Tentativo di fare lezione in Accademia con una competenza già a Grado 3: rifiutata con annuncio: *"L'Accademia forma fino al Grado 3 Professionista. Per raggiungere i gradi superiori ingaggia un Maestro Privato"*;
  - Tentativo di fare una lezione privata senza disporre dei 50.00 € necessari: azione inibita con indicazione del saldo mancante.
- **Livello 3 — Corner Cases & Limiti Estremi**:
  - Tentativo di superare il Grado 5: XP bloccati al tetto massimo (Cap Maestro Leggendario, XP congelati);
  - Interruzione con tasto `Esc` durante la selezione: il selettore si chiude istantaneamente, Alex torna in `GAMEPLAY_IDLE`, nessun denaro, energia o tempo viene consumato;
  - Chiamata da vecchi test storici su `player.get_skill_level("composition")` o `player.add_skill_xp("composition", 15.0)`: sincronizzazione automatica bidirezionale senza eccezioni o valori nulli.

---

## 🛡️ 5. SPECIFICA DETTAGLIATA DEI NAMED CONTRACTS (D0..DN)

---

### CONTRATTO D0: Clean Sweep & Bonifica Chiavi Spurie del Modello Dati
- **File**: `data/models/player_data.gd`
- **Obiettivo**:
  - Bonificare la chiave orfana/spuria `live_performance` reindirizzandola in modo trasparente a `tech_live_sound` o `stage_presence`;
  - Estendere `LEGACY_SKILL_MAP` con le nuove chiavi per garantire che qualsiasi chiamata storica a `get_skill_level()` o `add_xp_to_skill()` trovi sempre corrispondenza deterministica;
  - Assicurare che il dizionario legacy `skills` rimanga intatto per non intaccare nessuna delle 31 suite di test attive.

---

### CONTRATTO D1: Modello Dati a 31 Competenze Canoniche & Validatore di Idoneità
- **File**: `data/models/player_data.gd`
- **Obiettivo**:
  - Aggiungere al Ramo 2 (`instrumental_technique`) in `_init_skill_tree()` le 3 nuove competenze:
    * `skill_horns`: `{"name": "Fiati, Tromba & Sassofono", "branch": "instrumental_technique", "grade": 0, "xp": 0.0, "is_unlocked": false}`
    * `skill_strings`: `{"name": "Archi, Violino & Violoncello", "branch": "instrumental_technique", "grade": 0, "xp": 0.0, "is_unlocked": false}`
    * `skill_harmonica`: `{"name": "Armonica a Bocca & Strumenti Folk", "branch": "instrumental_technique", "grade": 0, "xp": 0.0, "is_unlocked": false}`
  - Implementare il metodo formale di validazione idoneità:
    ```gdscript
    enum StudyMethodType { MANUAL, ACADEMY, MENTOR, PRACTICE }
    func validate_study_eligibility(skill_id: String, method: int) -> Dictionary:
        # Restituisce: {"is_eligible": bool, "reason": String, "code": String}
    ```
    * *Regola Manuale*: Idonea se `grade < 2`; se `grade >= 2`, rifiuta indicando necessità di Accademia/Maestro;
    * *Regola Accademia*: Richiede `grade >= 1` (rifiuta Grado 0) e `grade < 3`; se `grade >= 3`, rifiuta indicando necessità di Maestro Privato;
    * *Regola Maestro*: Richiede `grade >= 1` (rifiuta Grado 0) e `grade < 5`; se `grade >= 5`, rifiuta indicando maestria massima raggiunta;
    * *Regola Pratica*: Idonea per discipline del Ramo 2 con `grade < 5`.

---

### CONTRATTO D2: Componente UI Accessibile `InstrumentPracticePicker` (Ramo 2)
- **File**: `ui/interaction_menu/instrument_practice_picker.gd` (e `.tscn` o istanziazione dinamica integrata)
- **Obiettivo**:
  - Menu verticale ad alto contrasto per la selezione dello strumento o voce da allenare;
  - Presenta gli 8 strumenti/voce del Ramo 2;
  - Evidenzia lo strumento primario di Alex (`[STRUMENTO PRINCIPALE]`);
  - Segnala sempre disponibile il Canto; per gli altri mostra il grado a stelle corrente;
  - Navigazione da tastiera completa: Frecce Su/Giù, Numpad 8/2, numeri diretti 1..8, Invio/Spazio per confermare, Esc per chiudere;
  - Vocalizzazione lineare NVDA tramite `AccessibilityManager.announce()` ad ogni spostamento di focus.

---

### CONTRATTO D3: Componente UI Accessibile `SkillStudyPicker` (31 Abilità)
- **File**: `ui/interaction_menu/skill_study_picker.gd` (e `.tscn` o istanziazione dinamica)
- **Obiettivo**:
  - Finestra accessibile a tutta altezza con clamping viewport 1920x1080 per lo studio mirato;
  - Accoglie tutte le 31 competenze suddivise nei 6 rami;
  - Tasti rapidi di salto ramo per NVDA:
    * `G` -> Cultura Generi (7 abilità)
    * `S` -> Strumenti & Voce (8 abilità)
    * `A` -> Composizione & Armonia (6 abilità)
    * `P` -> Palco & Spettacolo (4 abilità)
    * `T` -> Studio & Liuteria (3 abilità)
    * `B` -> Business & Media (3 abilità)
  - Per ciascuna competenza, visualizza ed enuncia:
    `[Indice] [Nome] — [Stelle Grado] — [Stato Idoneità per il Metodo Attivo]`
  - Intercetta la conferma con Invio: se idonea emette il segnale `skill_selected(skill_id, method_type)` e chiude il menu; se non idonea pronuncia la motivazione di blocco.

---

### CONTRATTO D4: Aggiornamento Catalogo Interazioni Loft NYC & Router HUD
- **File**: `scenes/apartment/apartment_interactions.gd` e `ui/apartment_hud/apartment_hud.gd`
- **Obiettivo**:
  - In `apartment_interactions.gd`:
    * `guitar_practice` ("Scale e riff") configurata con tipo `"practice_picker"`;
    * `couch_study_manual` configurata con tipo `"study_picker"`, metodo `MANUAL`;
    * `door_academy_course` configurata con tipo `"study_picker"`, metodo `ACADEMY`;
    * `guitar_mentor_lesson` configurata con tipo `"study_picker"`, metodo `MENTOR`;
    * `toolbox_check` aggiornata con `xp_skill: "tech_live_sound"`;
    * `toolbox_maintain` aggiornata con `xp_skill: "tech_lutherie"`, `xp_amount: 15.0`.
  - In `apartment_hud.gd`:
    * Gestione dell'apertura dei due selettori in corrispondenza delle azioni selezionate;
    * Chiusura sicura e avvio dell'azione in `ActionSystem` con durata, stato `GAMEPLAY_BUSY`, barra inspection e attribuzione XP precisa alla skill scelta;
    * Ripristino del movimento di Alex in `GAMEPLAY_IDLE` alla fine o in caso di annullamento (`Esc`).

---

### CONTRATTO D5: Suite di Test Headless Dedicata & Zero Errori a 0 ms
- **File**: `tests/test_skills_and_loft_study_system.gd`
- **Obiettivo**:
  - Espansione della suite di test per coprire:
    1. Presenza e correttezza delle 31 competenze canoniche (8 nel Ramo 2);
    2. Verifica delle nuove competenze `skill_horns`, `skill_strings`, `skill_harmonica`;
    3. Validazione deterministica delle guardie di idoneità per i 4 metodi (`validate_study_eligibility`);
    4. Verifica apertura e funzionamento logico di `InstrumentPracticePicker` e attribuzione XP corretta per tutte le 8 discipline;
    5. Verifica apertura e funzionamento logico di `SkillStudyPicker` e rispetto dei Cap di Grado 2 (manuale) e Grado 3 (accademia);
    6. Aggiornamento delle azioni alla Cassa Attrezzi su `tech_live_sound` e `tech_lutherie`;
    7. Convalida del passaggio globale da 31 a 32 suite di test headless superate al 100% con 0 errori a 0 ms.

---

### CONTRATTO D6: Living Documentation, Registro Revisioni & AVF V5.8.0
- **File**: `docs/todo.md`, `CHANGELOG.md`, `docs/report/REGISTRO_REVISIONI.md`, schede di `knowledge/`
- **Obiettivo**:
  - Aggiornamento della roadmap in `docs/todo.md` (attività `F9.15` registrata);
  - Chiusura formale della revisione `RRU-29` in `REGISTRO_REVISIONI.md` con esito convalidato;
  - Aggiornamento del registro versioni ad **AVF V5.8.0**;
  - Domanda Ponte obbligatoria per l'avvio della Fase 4 (Auto-Apprendimento & Consolidamento Hub).

---

## 🛑 6. STOP OBBLIGATORIO DELLA SOTTO-FASE 1A (REGOLA 0)

In conformità rigorosa al framework **ASTRALIS v3.0.7** e alla **Regola 0**:
- La presente Sotto-Fase 1A si conclude con la redazione di questo Piano Tecnico Formale;
- È fatto **divieto assoluto di creare o modificare file di codice sorgente prima dell'approvazione esplicita di Luca e Thomas** (*"procedi"*, *"applica"*, *"esegui"*).
