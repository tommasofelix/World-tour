# World-tour — Piano Tecnico Formale: Day Loop Stress Test Multi-Giorno & Blindatura Save/Load Overtime (Sotto-Fase 1A)
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Versione Target: AVF V5.8.1 — Day Loop Stress Test Multi-Giorno & Blindatura Save/Load Overtime
# Data: 26 Settembre 2026
# Percorso File: docs/piani/completati/PIANO_TECNICO_DAY_LOOP_STRESS_TEST_E_SAVE_LOAD.md
# Baseline AVF: V5.8.0 (31/31 Suite Headless Superate a 0 Errori e 0 ms)
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Sotto-Fase 1A e 1B completate con 32/32 suite headless al 100% verdi a 0 ms — Versione AVF V5.8.1)

---

## 🎯 1. OBIETTIVO ARCHITETTURALE E VISIONE GENERALE

Questo piano tecnico formalizza la blindatura architetturale del ciclo vitale giornaliero (**Day Loop**) e del sistema di persistenza atomica (**Save/Load**) in scenari complessi multi-giorno nel loft di New York, eliminando alla radice l'anomalia riscontrata durante l'analisi funzionale:

1. **RCA Anomalia Overtime Save/Load**: I flag di tracciamento dell'overtime notturno (`warned_hour_2`, `warned_hour_3`, `overtime_hour_1_applied` .. `_4_applied`, `early_sleep_taken`, `sleep_period`, `sleep_hour_offset`) in `systems/time_system.gd` sono attualmente variabili di istanza volatili non serializzate. Se il giocatore salva la partita alle 02:30 di notte e ricarica, `TimeSystem` viene re-istaziato con tutti i flag a `false`: al tick successivo `_check_overtime_and_notifications()` ri-applica ingiustamente le penalità di stress (+2, +3, +5) e ripete gli annunci vocali per NVDA.
2. **Blindatura Ciclo Multi-Giorno**: Sincronizzazione atomica di `CalendarData` e `TimeSystem`, garantendo che lo stato dell'overtime notturno venga persistito in `savegame.json`, azzerato coerentemente ad ogni inizio giornata (`reset_daily_saturation()`) e verificato in una nuova suite di test headless deterministica multi-giorno (`tests/test_multi_day_lifecycle.gd`).
3. **Resistenza Ciclo Sonno & Sblocco FSM Loft**: Verifica rigorosa della catena `EndDaySystem` $\leftrightarrow$ `DailySummary` $\leftrightarrow$ `ApartmentHud` $\leftrightarrow$ `PlayerAlex` su più giorni consecutivi per garantire che il movimento di Alex non rimanga mai congelato e che il bilancio economico/morale/energia risponda deterministicamente.

### Principi Cardine Inviolabili:
1. **Regola 0 (Default Consultivo Permanente & Stop Obbligatorio)**:
   - La presente Sotto-Fase 1A redige unicamente il piano tecnico formale.
   - È fatto divieto assoluto di modificare codice sorgente o configurazioni prima dell'approvazione esplicita di Luca (*"procedi"*, *"applica"*, *"esegui"*).
2. **Accessibilità Vocale Assoluta (Zero Mouse & NVDA)**:
   - Navigazione lineare sequenziale riga per riga per screen reader NVDA;
   - Divieto assoluto di tabelle 2D, matrici complesse o schemi ASCII; adozione esclusiva di elenchi puntati e logica "Se... Allora";
   - Volumi audio e feedback sonori congelati rigidamente tra 0.7f e 0.75f (-2.5 dB);
   - Annunci vocali discreti a mezzanotte (zero pop-up bloccanti), alle 02:00 e alle 03:00 con audio ducking attivo.
3. **Protocollo 12 (Inner Codex Pattern & Determinismo Headless)**:
   - Risoluzione deterministica delle cause radice (RCA);
   - Named Contracts D0..D3 a chiusura stagna;
   - Esecuzione headless deterministica a 0 ms senza dipendenze da tick temporali reali né `OS.delay()`.
4. **Assenza Regressioni & Retrocompatibilità (Asse 7)**:
   - Tutte le 31 suite di test preesistenti devono rimanere al 100% verdi (31/31), portando il totale a 32/32 con la nuova suite multi-giorno.

---

## 🏛️ 2. CHECKLIST DI CONVALIDA A 3 STATI (MATRICE PER NVDA)

- [x] [CONVALIDATO CON SUCCESSO] Contratto D0: Serializzazione Atomica Flag Overtime in `CalendarData` (`overtime_state`), sincronizzazione bidirezionale con `TimeSystem` e reset sicuro in `reset_daily_saturation()`.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D1: Blindatura del ciclo di fine giornata e transizione giorno (`EndDaySystem` $\leftrightarrow$ `DailySummary` $\leftrightarrow$ `ApartmentHud` $\leftrightarrow$ `PlayerAlex`) con sblocco garantito dello stato `GAMEPLAY_NORMAL`.
- [x] [CONVALIDATO CON SUCCESSO] Contratto D2: Creazione della nuova suite di test headless `tests/test_multi_day_lifecycle.gd` a 0 ms (simulazione 3 giorni, overtime progressivo, salvataggio e ricaricamento a metà giornata e a notte fonda, spese e royalties).
- [x] [CONVALIDATO CON SUCCESSO] Contratto D3: Verifica assenza regressioni con `tools/check.ps1` (118 file con 0 errori) e `tools/test.ps1` (32/32 suite verdi a 0 ms), aggiornamento Living Documentation (`docs/todo.md`, `REGISTRO_REVISIONI.md`, `BUG-029`) e incremento AVF a `V5.8.1`.

---

## ⚖️ 3. I 7 ASSI DI QUALITÀ ASTRALIS APPLICATI

- **Asse 1 — Validità**: Rispetto rigoroso dei tipi GDScript 2.0 statici, allineamento di `to_dict()` e `from_dict()` in `CalendarData` con tipi primitivi sicuri (`bool`, `int`).
- **Asse 2 — Efficacia**: Eliminazione totale del bug di ri-applicazione spuria delle penalità di stress e duplicazione annunci vocali post caricamento da salvataggio notturno.
- **Asse 3 — Coerenza**: Perfetta armonia con la Clean Architecture DDD del progetto: il modello dati `CalendarData` possiede lo stato serializzabile, mentre `TimeSystem` orchestra la simulazione logica e gli eventi.
- **Asse 4 — Completezza**: Copertura integrale di tutti i casi di transizione temporale (giorno ordinario, riposo anticipato, notte prolungata fino alle 04:00, salvataggio a metà pomeriggio, salvataggio notturno post-avvisi).
- **Asse 5 — Precisione**: Modifiche chirurgiche minime a `calendar_data.gd` e `time_system.gd`, lasciando inalterate le interfacce esterne e i contratti dei segnali di `EventBus`.
- **Asse 6 — Affidabilità & Prestazioni**: Esecuzione istantanea a 0 ms; zero allocazioni spurie di nodi o strutture pesanti; persistenza JSON deterministica.
- **Asse 7 — Assenza Regressioni**: Compatibilità retroattiva al 100% per vecchi file di salvataggio (fallback automatico a valori predefiniti sicuri se `overtime_state` è assente nel JSON) e 31/31 suite storiche verdi.

---

## 🔬 4. I 3 LIVELLI DI SIMULAZIONE PREVENTIVA

- **Livello 1 — Happy Path (Ciclo Ordinario diurno e notturno)**:
  - Il giocatore inizia il Giorno 1 alle 06:00 del mattino;
  - Svolge attività nel loft (studio, pratica, relax), l'orologio virtuale avanza fino alle 23:30;
  - A mezzanotte entra in fascia Notte senza pop-up fastidiosi; alle 00:00 riceve la prima lieve penalità fisiologica (+2 stress);
  - Alle 01:00 decide di andare a letto con il comando Dormi (tasto `Z`): il tempo si conclude, `EndDaySystem` calcola spese di sussistenza e sonno ristoratore, appare `DailySummary`, premendo `Invio` si passa al Giorno 2 alle 06:00 del mattino con Alex perfettamente sbloccato e pronto all'azione.
- **Livello 2 — Percorsi Alternativi & Concorrenti (Salvataggio a Notte Fonda)**:
  - Il giocatore prosegue le sue sessioni nel loft fino alle 02:30 di notte;
  - Riceve gli avvisi discreti delle 02:00 e accumula lo stress progressivo previsto (+2 a 00:00, +3 a 01:00, +5 a 02:00 = totale 10 stress);
  - Il giocatore preme `Esc`, seleziona "Salva Partita" ed esce dal gioco;
  - Riapre il gioco e seleziona "Carica Partita": la partita si riposiziona esattamente alle 02:30 del mattino;
  - Al tick temporale successivo: i flag `overtime_hour_1_applied`, `_2_applied`, `_3_applied` e `warned_hour_2` risultano già `true` dal dizionario deserializzato;
  - **Risultato osservabile**: Nessuna penalità spuria applicata, nessuno stress raddoppiato, nessun annuncio vocale duplicato.
- **Livello 3 — Corner Cases & Limiti Estremi (Chiusura Forzata alle 04:00 & Multi-Day Stress)**:
  - Il giocatore rifiuta di dormire fino al limite invalicabile delle 04:00 (`remaining_seconds <= 0.0`);
  - `TimeSystem` emette l'avviso delle 03:00, applica il malus massimo (+10 stress) e alle 04:00 scatena `EventBus.day_ended`;
  - Il sonno è contratto al minimo (solo 2 ore virtuali di riposo): recupero parziale di energia, zero bonus riposo anticipato;
  - La transizione al nuovo giorno azzera completamente tutti i flag di overtime in `CalendarData`, consentendo al nuovo giorno di iniziare pulito alle 06:00 senza ereditare lo stato notturno del giorno precedente.

---

## 🛡️ 5. SPECIFICA DETTAGLIATA DEI NAMED CONTRACTS (D0..D3)

---

### CONTRATTO D0: Serializzazione Atomica Flag Overtime in `CalendarData` e Sincronizzazione con `TimeSystem`

#### Obiettivo Tecnico:
Rendere lo stato dell'overtime notturno persistente e atomico attraverso il modello dati `CalendarData`, collegandolo in modo trasparente a `TimeSystem`.

#### Modifiche a `data/models/calendar_data.gd`:
- Aggiunta della struttura dati `overtime_state: Dictionary`:
  ```gdscript
  var overtime_state: Dictionary = {
      "warned_hour_2": false,
      "warned_hour_3": false,
      "overtime_hour_1_applied": false,
      "overtime_hour_2_applied": false,
      "overtime_hour_3_applied": false,
      "overtime_hour_4_applied": false,
      "early_sleep_taken": false,
      "sleep_period": Enums.TimePeriod.MORNING,
      "sleep_hour_offset": 0
  }
  ```
- Metodo `reset_overtime_state()`:
  Reimposta tutti i valori del dizionario `overtime_state` ai loro default di inizio giornata.
- Integrazione in `reset_daily_saturation()`:
  Invocazione di `reset_overtime_state()` per garantire che all'alba (`remaining_seconds = day_duration`) lo stato notturno sia vergine.
- Aggiornamento `to_dict()` e `from_dict()`:
  - `to_dict()`: include `"overtime_state": overtime_state.duplicate(true)`;
  - `from_dict(dict)`: estrae `"overtime_state"` se presente; se assente (vecchi salvataggi legacy), invoca `reset_overtime_state()` per retrocompatibilità robusta a prova di crash.

#### Modifiche a `systems/time_system.gd`:
- Proprietà o metodi di sincronizzazione con `calendar_data`:
  - In `_init(p_calendar, p_player)`: chiamata a `sync_from_calendar()`;
  - In `sync_from_calendar()`: popola i campi locali di `TimeSystem` leggendo da `calendar_data.overtime_state`;
  - In `_sync_to_calendar()`: scrive i campi locali dentro `calendar_data.overtime_state`;
  - In `_check_overtime_and_notifications()`: quando imposta un flag a `true`, aggiorna sia la variabile locale che `calendar_data.overtime_state`;
  - In `sleep_early()`: aggiorna `early_sleep_taken`, `sleep_period` e `sleep_hour_offset` sincronizzandoli subito in `calendar_data.overtime_state`;
  - In `reset_daily_overtime()`: azzera sia i campi locali che `calendar_data.reset_overtime_state()`.

---

### CONTRATTO D1: Blindatura Ciclo Fine Giornata & Transizione Giorno

#### Obiettivo Tecnico:
Assicurare che la catena di transizione tra fine giornata, modale di riepilogo notturno e alba del giorno successivo avvenga senza intoppi di sincronizzazione, sbloccando deterministicamente Alex e aggiornando l'HUD.

#### Punti di Controllo:
1. `systems/end_day_system.gd`:
   - Calcolo coerente delle spese di vita (vitto e alloggio);
   - Accredito corretto di royalties catalogo e sub-affitto sala prove;
   - Decadimento fisiologico del 10% del `social_buzz` in `SocialMediaSystem`;
   - Reset della saturazione temporale tramite `calendar_data.reset_daily_saturation()`;
   - Emissione sicura dei segnali `EventBus.daily_summary_ready(summary)` e `EventBus.day_started(new_day)`.
2. `ui/apartment_hud/apartment_hud.gd`:
   - Apertura di `daily_summary_modal` su ricezione di `daily_summary_ready`;
   - Chiusura della modale su ricezione del segnale `day_advanced`;
   - Ripristino dello stato `GAMEPLAY_NORMAL` e sblocco immediato del movimento in `PlayerAlex`.

---

### CONTRATTO D2: Nuova Suite di Test Headless Multi-Giorno `tests/test_multi_day_lifecycle.gd`

#### Obiettivo Tecnico:
Creare una suite di test headless deterministica che simula un ciclo completo di 3 giornate virtuali consecutive con eventi eterogenei e salvataggi intermedi a 0 ms.

#### Casi di Test Inclusi:
1. **Test 1 — Ciclo Giorno 1 Regolare (06:00 -> 23:30 -> Mezzanotte -> Sonno ordinario)**:
   - Avanzamento del tempo fino a sera;
   - Entrata in fascia Notte;
   - Attivazione del sonno a mezzanotte con `sleep_early()` / `trigger_sleep_now()`;
   - Esecuzione `process_day_end()` e `advance_to_next_day()`;
   - Verifica transizione a Giorno 2, ore 06:00, orologio ripristinato a 300s, flag overtime azzerati.
2. **Test 2 — Giorno 2 con Overtime Notturno Profondo (00:00 -> 04:00)**:
   - Avanzamento progressivo ora per ora (00:00, 01:00, 02:00, 03:00, 04:00);
   - Verifica accumulo esatto dello stress (+2, +3, +5, +10 = totale 20);
   - Verifica flag avvisi delle 02:00 e 03:00 attivi;
   - Chiusura forzata alle 04:00 e sonno ristretto.
3. **Test 3 — Blindatura Save & Reload a Notte Fonda (Risoluzione Bug Overtime)**:
   - Posizionamento del tempo alle 02:30 di notte del Giorno 2 (dopo avviso 02:00 e +10 stress cumulato);
   - Salvataggio dello stato tramite `SaveManager.save_game()` su file di test o simulazione dizionario `to_dict()`;
   - Ricaricamento tramite `SaveManager.load_game()` o `from_dict()`;
   - Avanzamento di 1 tick temporale: verifica che lo stress del giocatore rimanga IDENTICO e che `warned_hour_2` e `overtime_hour_3_applied` non vengano ri-eseguiti.
4. **Test 4 — Transizione Economica, Spese e Royalties Multi-Giorno**:
   - Verifica addebito giornaliero delle spese di sussistenza;
   - Verifica accredito automatico royalties di catalogo;
   - Verifica decadimento giornaliero del 10% del `social_buzz`.
5. **Test 5 — Sblocco FSM & Movimento Protagonista**:
   - Simulazione ricezione `daily_summary_ready` ed emissione `day_advanced`;
   - Verifica che `player.is_movement_locked` torni a `false` e la velocità sia `Vector2.ZERO`.

---

### CONTRATTO D3: Verifica Regressioni, Living Documentation & Chiusura AVF

#### Obiettivo Tecnico:
Validare l'intero progetto su tutte le suite headless ed aggiornare la documentazione attiva.

#### Attività di Verifica:
- Esecuzione `tools/check.ps1` (117+ file verificati con 0 errori sintattici);
- Esecuzione `tools/test.ps1` (portando le suite da 31/31 a 32/32 convalidate al 100% con 0 fallimenti e 0 ms);
- Registrazione del bug risolto `BUG-023: Deserializzazione e ri-applicazione spuria flag overtime notturno al caricamento salvataggio` in `knowledge/09_registro_bug_e_soluzioni.md`;
- Aggiornamento della roadmap in `docs/todo.md` e changelog in `CHANGELOG.md`;
- Avanzamento della versione AVF a `V5.8.1`.

---

## 🛑 STOP OBBLIGATORIO (GATING REGOLA 0)

In conformità rigorosa con la **Regola 0 (Default Consultivo Permanente)** e il **Framework ASTRALIS v3.0.7**, la stesura del presente piano conclude la **Sotto-Fase 1A**.

Nessuna modifica al codice sorgente né creazione di nuovi file di test verrà intrapresa senza l'esplicito comando di Luca (*"procedi"*, *"applica"*, *"esegui"*).
