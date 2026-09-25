# Registro Attivo delle Revisioni & Affinamenti Post-Collaudo (RRU)
# Progetto: World-tour (Music Career Simulator)
# Autore: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Percorso: docs/report/REGISTRO_REVISIONI.md
# Archivio Storico: docs/report/archivio/ARCHIVIO_REVISIONI.md
# Framework: ASTRALIS v3.0.7

Questo documento costituisce il **Registro Attivo Snello** del progetto World-tour. Ospita *esclusivamente* le revisioni confermate ancora aperte (`[APERTA / IN TELEMETRIA]`), in lavorazione (`[IN LAVORAZIONE]`) o in corso di verifica. A collaudo positivo confermato da Luca con NVDA, le voci vengono trasferite nell'**Archivio Storico delle Revisioni** ([`ARCHIVIO_REVISIONI.md`](./archivio/ARCHIVIO_REVISIONI.md)), mantenendo questo file sempre leggero e rapido da consultare con la sintesi vocale.

---

## 📋 REVISIONI ATTIVE IN CORSO

### 🟢 RRU-22 — Ricostruzione Planimetria Isometrica Modulare & Blindatura Anti-Freeze Runtime
- **Stato**: `[CONVALIDATA / ARCHIVIATA]`
- **Data Rilevamento**: 2026-09-24
- **Problema Riscontrato (Esperienza Utente NVDA & Holy Diver)**:
  1. Appartamento visivamente disconnesso: pavimento composto da tessere slegate; pareti a diverse altezze; arredi disallineati nel vuoto.
  2. Blocco / freeze del gioco dovuto a slittamento HUD a coordinate negative (-1049, -2161) con modali fuori schermo in pausa FSM.
- **Evidenza Telemetrica / Log**:
  - Risolto: offset HUD ripristinati a Full Rect; nodi arredi resi concentrici rispetto alle radici mondiali.
  - Risolto: ricalibrazione hitbox per evitare deadlock del collider solido prima dell'Area2D trigger; stand-point calpestabile per auto-walk.
  - Risolto: mouse hover con cursore a manina e click sinistro con auto-walk per Holy Diver (The Sims style).
  - Risolto: ricalibrazione collisione tavolino e promozione cassa monitor a Stereo interattivo (+5 morale, -5 stress).
- **Causa Radice**: Offset locali spuri dei nodi figli rispetto alla radice in Godot editor 2D, collider solido più largo del trigger raggio 48, HUD offset fuori schermo.
- **Soluzione di Affinamento (PRAPI - Convalidata)**:
  1. Normalizzazione concentrica dei 10 arredi interattivi con Y-Sorting matematico.
  2. Hitbox clearance estesa di 25-35 px oltre i corpi solidi.
  3. Cursore a manina e click sinistro mouse per Holy Diver.
  4. Ricalibrazione tavolino e stereo interattivo.
  5. Centratura HUD e 68/68 test dedicati superati con 0 errori.
- **Piano Tecnico di Riferimento**: [`docs/piani/completati/PIANO_GAMEPLAY_GRAFICO_APPARTAMENTO.md`](../piani/completati/PIANO_GAMEPLAY_GRAFICO_APPARTAMENTO.md)
- **Esito Collaudo**: `[x] [CONVALIDATO CON SUCCESSO]` da Luca (NVDA) e Holy Diver (monitor/mouse); 30/30 suite di test headless convalidate con 0 errori a 0 ms. Release V5.4.0.

---

### 🟡 RRU-29 — Ottimizzazione Sistemica Collegamento Azioni-Skill & Studio Selettivo 31 Abilità
- **Stato**: `[/] [IMPLEMENTATA — IN ATTESA DI CONVALIDA MANUALE (FASE 2)]`
- **Data Rilevamento**: 2026-09-25
- **Problema Riscontrato (Esperienza Utente NVDA)**:
  1. Azioni di studio nel Loft NYC precedentemente hardcodate su singole abilità fisse (es. divano solo Teoria, maestro solo Chitarra, accademia solo Teoria), impedendo la scelta mirata del percorso di crescita del personaggio.
  2. Pratica strumentale ("Scale e riff") vincolata alla sola chitarra elettrica, escludendo canto, basso, batteria, tastiere, fiati, archi e armonica.
  3. Alcune competenze e azioni del sistema non erano collegate in modo ottimale (es. cassa attrezzi su chiave spuria anziché `tech_live_sound`/`tech_lutherie`).
  4. Necessità di bilanciare e differenziare i 4 metodi di apprendimento (Manuale, Accademia, Maestro Privato, Pratica/Ascolto) con requisiti, tetti massimi (Cap) e rendimenti XP coerenti.
- **Evidenza Telemetrica / Log**:
  - `ApartmentInteractions` definisce `couch_study_manual` (tipo `study_picker`, metodo `MANUAL`), `guitar_mentor_lesson` (tipo `study_picker`, metodo `MENTOR`), `door_academy_course` (tipo `study_picker`, metodo `ACADEMY`) e `guitar_practice` (tipo `practice_picker`).
  - Implementati con successo i due selettori accessibili: `InstrumentPracticePicker` (8 discipline Ramo 2) e `SkillStudyPicker` (31 competenze con filtri rapidi di ramo).
  - Validazione deterministica `validate_study_eligibility(skill_id, method)` attiva su `PlayerData`.
- **Causa Radice**: Implementazione iniziale V5.7.0 focalizzata sul modello dati `PlayerData` e sui primi 4 metodi di studio come prototipo statico; estesa con successo verso la selezione dinamica universale (V5.8.0).
- **Soluzione di Affinamento (PRAPI - Convalidata Headless)**:
  1. Componente `InstrumentPracticePicker`: 8 discipline strumentali/vocali del Ramo 2, evidenziazione `[PRINCIPALE]`, tasti 1..8, Frecce, Invio, Esc e annunci vocali.
  2. Componente `SkillStudyPicker`: 31 competenze sui 6 rami, filtri rapidi G, S, A, P, T, B, 0, verifica idoneità in tempo reale con motivazione vocale di blocco.
  3. Validazione propedeuticità e cap: Manuale (fino a Grado 2), Accademia (richiede Grado 1, fino a Grado 3), Maestro Privato (richiede Grado 1, fino a Grado 5), Pratica (Ramo 2).
  4. Riconnessione azioni Loft NYC in `ApartmentInteractions` e router in `ApartmentHud` con stato `GAMEPLAY_BUSY`, barra inspection e attribuzione XP precisa.
  5. Vincolo contestuale Chitarra: rimossa la tendina `InstrumentPracticePicker` dall'arredo del loft; "Scale e riff alla chitarra" e "Lezione di chitarra col Maestro" configurate come azioni dirette con durata per la sola `skill_guitar` a 0 sottomenu intermedi.
  6. Sanificazione `BottomLeftDialogue` & Sincronizzazione 1:1 NVDA: introdotto `clear_inspection()`, occultamento automatico del pannello durante le modali, sincronizzazione 1:1 tra testo visivo ed emissione vocale ed eliminazione annunci duplicati in `_on_hud_action_completed`. Conservati i selettori 31 skill su Divano e Porta per consentire a Luca di continuare i test.
- **Documento Strategico di Riferimento**: [`docs/strategie/sessione_approfondimento_gameplay/STRATEGIA_OTTIMIZZAZIONE_AZIONI_SKILL_E_STUDIO_SELETTIVO.md`](../strategie/sessione_approfondimento_gameplay/STRATEGIA_OTTIMIZZAZIONE_AZIONI_SKILL_E_STUDIO_SELETTIVO.md)
- **Piano Tecnico di Riferimento**: [`docs/piani/attivi/PIANO_TECNICO_OTTIMIZZAZIONE_AZIONI_SKILL_E_STUDIO_SELETTIVO.md`](../piani/attivi/PIANO_TECNICO_OTTIMIZZAZIONE_AZIONI_SKILL_E_STUDIO_SELETTIVO.md)
- **Report di Sessione & File Correlati**: [`docs/report/REPORT_SESSIONE_OTTIMIZZAZIONE_AZIONI_E_SKILL.md`](./REPORT_SESSIONE_OTTIMIZZAZIONE_AZIONI_E_SKILL.md)
- **Esito Collaudo**: `[/] [IMPLEMENTATO — IN ATTESA DI CONVALIDA MANUALE]` (172/172 asserzioni superate in `test_skills_and_loft_study_system.gd`, 377/377 in `test_apartment_gameplay.gd`, 31/31 suite headless al 100% verdi a 0 ms, 117 file GDScript verificati con 0 errori. In attesa di collaudo pratico NVDA di Luca per la Fase 2).

---

### 🟡 RRU-30 — Sincronizzazione 1:1 Testo-Voce (TTS) & Risoluzione Freeze BottomLeftDialogue
- **Stato**: `[APERTA / IN ANALISI]`
- **Data Rilevamento**: 2026-09-25
- **Problema Riscontrato (Esperienza Utente NVDA)**:
  1. Box visivo `BottomLeftDialogue` bloccato sul testo iniziale o su vecchi messaggi di azione senza aggiornarsi dinamicamente.
  2. Discrepanza totale tra la sintesi vocale NVDA (che leggeva formule generiche o messaggi non pertinenti) e il testo renderizzato a schermo.
  3. L'indicatore `[Spazio] Chiudi` non congedava la notifica alla pressione del tasto.
- **Evidenza Telemetrica / Log**:
  - `ActionSystem._complete_action()` emetteva autonomamente `AccessibilityManager.announce()` divergente rispetto a `ApartmentHud._on_hud_action_completed()`.
  - Negli arredi domestici diretti (Cucina, Divano, Giradischi, Stereo), testo parlato disallineato dal testo mostrato a schermo.
- **Causa Radice**: Assenza di un metodo unificato di dispatch per `BottomLeftDialogue`; concorrenza tra annunci TTS di sistema e messaggi locali dell'HUD; mancata cattura dei tasti di congedo (`Spazio`/`Esc`).
- **Soluzione di Affinamento (PRAPI - Proposta)**:
  1. Contratto D1: Canale unificato `display_dialogue(text, speaker, hint, should_announce, is_interrupt)` con parità letterale 1:1 tra visivo e vocale.
  2. Contratto D2: Stato base permanente del Diario di Bordo visibile durante il movimento libero, senza azzeramenti arbitrari né buffer obsoleti.
  3. Contratto D3: Disattivazione degli annunci concorrenti in `ActionSystem` per le azioni coordinate dall'HUD.
  4. Contratto D4: Gestione del congedo attivo con `[Spazio]` o `[Esc]`.
- **Piano Tecnico di Riferimento**: [`docs/piani/attivi/PIANO_TECNICO_DISALLINEAMENTO_TESTO_VOCE_BOTTOM_LEFT_DIALOGUE.md`](../piani/attivi/)
- **Esito Collaudo**: `[ ] [DA AVVIARE]` (Piano tecnico approvato in attesa di autorizzazione esecutiva Fase 1B).


---

## 📐 Modello di Voce Standard RRU (ASTRALIS v3.0.7)

### 🟡 RRU-XX — [Titolo Sintetico della Revisione]
- **Stato**: `[APERTA / IN TELEMETRIA]` | `[IN LAVORAZIONE]` | `[IN VERIFICA]`
- **Data Rilevamento**: AAAA-MM-GG
- **Problema Riscontrato (Esperienza Utente NVDA)**: [Descrizione esatta del comportamento riscontrato durante il test e motivo del disorientamento o anomalia]
- **Evidenza Telemetrica / Log**: [Eventuale riga di log, timestamp, eccezione o dump correlato]
- **Causa Radice**: [Diagnosi tecnica verificata del motivo per cui il comportamento si è verificato]
- **Soluzione di Affinamento (PRAPI)**: [Modifiche chirurgiche da implementare nel codice, nodi UI, parametri o stringhe I18N]
- **Piano Tecnico di Riferimento**: [`docs/piani/attivi/[NOME_PIANO].md`](../piani/attivi/)
- **Report di Sessione & File Correlati**: [`docs/report/REPORT_SESSIONE_[TASK].md`](./)
- **Esito Collaudo**: [In attesa di collaudo]
