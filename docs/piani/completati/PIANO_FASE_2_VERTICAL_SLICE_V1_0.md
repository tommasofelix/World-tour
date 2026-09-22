# Piano Tecnico Operativo — Fase 2: Vertical Slice V1.0 (Ciclo Vitale Minimo)

- ID Piano: `P-F2`
- Autori del progetto: Luca & Holy Diver
- Assistente: Antigravity (Senior AI Pair Programmer & Software Engineer)
- Data: 2026-09-22
- Stato: Completato e Convalidato con successo (Verificato empiricamente con collaudo NVDA e visivo)
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md) (Attività F2.1 $\rightarrow$ F2.8 completate)
- Documenti di riferimento:
  - [`docs/piani/attivi/sottopiani/01_game_design_visione_e_progressione.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/01_game_design_visione_e_progressione.md)
  - [`docs/piani/attivi/sottopiani/02_simulazione_vita_tempo_e_routine.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/02_simulazione_vita_tempo_e_routine.md)
  - [`docs/piani/attivi/sottopiani/06_formule_matematiche_e_bilanciamento.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/06_formule_matematiche_e_bilanciamento.md)
  - [`docs/piani/attivi/sottopiani/07_architettura_software_sistemi_e_modello_dati.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/07_architettura_software_sistemi_e_modello_dati.md)
  - [`docs/piani/attivi/sottopiani/08_accessibilita_vocale_interfaccia_e_simmetria.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/08_accessibilita_vocale_interfaccia_e_simmetria.md)

---

## 1. OBIETTIVO DEL VERTICAL SLICE V1.0

Lo scopo della **Fase 2** è realizzare il **nucleo minimo giocabile e verificabile (Core Loop vitale)** di World-tour.  
Invece di costruire schermate premature o sistemi complessi (band, concerti, etichette), ci concentriamo sull'anello fondamentale della simulazione di vita:

$$\text{Avvio/Caricamento} \longrightarrow \text{Tempo Quotidiano (600s)} \longrightarrow \text{Azione di Allenamento} \longrightarrow \text{Fine Giornata} \longrightarrow \text{Salvataggio Atomico}$$

### Criteri di Accettazione e Successo:
1. **Simmetria Universale Funzionante**: Il loop può essere completato al 100% da tastiera con screen reader NVDA (senza toccare il mouse), mentre a monitor Holy Diver dispone di una UI visiva con contrasti WCAG AAA ed evidenziazione luminosa del focus.
2. **Pausa Dinamica Attiva**: L'apertura di qualsiasi pannello o finestra modale congela immediatamente l'orologio di gioco, azzerando l'ansia temporale per la lettura vocale.
3. **Persistenza a Prova di Crash**: Salvataggio JSON atomico consentito esclusivamente in stato IDLE o Daily Summary, bloccato categoricamente durante le azioni (BUSY).
4. **Validazione Continua Headless**: Tutta la logica temporale e di stato è testabile tramite script CLI (`tools/test.ps1`) senza richiedere una finestra grafica aperta.

---

## 2. ARTICOLAZIONE DEI TASK OPERATIVI (D0 – D7)

### Task D0: Modelli Dati Runtime (`data/models/`)
- **Obiettivo**: Definire le strutture dati applicative che contengono lo stato del giocatore, del tempo e delle azioni.
- **File da creare**:
  - `data/models/player_data.gd`:
    - Nome, strumento scelto, background.
    - Risorse fisiologiche: `energy` (100), `stress` (0), `morale` (100), `money` (500.0).
    - Abilità: dizionario con i livelli delle 7 abilità (base a 10) e relativi XP accumulati.
    - Metodi: `to_dict() -> Dictionary`, `from_dict(data: Dictionary) -> void`.
  - `data/models/calendar_data.gd`:
    - Giorno corrente (1), secondo residuo nella giornata (600.0), fascia oraria corrente (`TimePeriod`).
    - Contatore azioni eseguite oggi (per saturazione diminishing returns).
    - Metodi: `to_dict()`, `from_dict()`.
  - `data/models/action_data.gd`:
    - Identificativo (`action_id`), nome descrittivo, durata in secondi, consumo di energia, accumulo di stress, XP base assegnati e abilità bersaglio.

### Task D1: Motore Temporale (`systems/time_system.gd`)
- **Obiettivo**: Gestire lo scorrere della giornata di 600 secondi con decremento proporzionale, fasce orarie e velocità variabile.
- **Specifiche Tecniche**:
  - Durata: 600 secondi reali = 24 ore di gioco (1 secondo reale = 2.4 minuti virtuali).
  - Stati temporali: `IDLE` (tempo scorre o in pausa a seconda della configurazione), `BUSY` (tempo scorre durante l'azione), `PAUSED` (tempo completamente fermo).
  - Moltiplicatori di velocità: 1x (`SPEED_NORMAL`), 2x (`SPEED_FAST`), 5x (`SPEED_ULTRA`).
  - Fasce orarie automatiche: Mattina (600s - 450s), Pomeriggio (450s - 300s), Sera (300s - 150s), Notte (150s - 0s).
  - Emissione segnale `EventBus.time_ticked(remaining_seconds, time_str, period)`.
  - Emissione segnale `EventBus.day_ended(day_number)` quando `remaining_seconds <= 0.0`.

### Task D2: Macchina a Stati Globale (`autoload/game_manager.gd`)
- **Obiettivo**: Governare il ciclo di vita dell'applicazione e le transizioni ammissibili per prevenire bug di concorrenza.
- **Specifiche Tecniche**:
  - Stati gestiti: `BOOT`, `MAIN_MENU`, `CHARACTER_CREATION`, `GAMEPLAY_IDLE`, `GAMEPLAY_BUSY`, `GAMEPLAY_PAUSED`, `DAILY_SUMMARY`, `GAME_OVER`.
  - Transizioni protette: impossibile avviare un'azione se lo stato non è `GAMEPLAY_IDLE`.
  - Integrazione Pausa Dinamica: all'invocazione di `open_menu()`, lo stato transita a `GAMEPLAY_PAUSED` e il `TimeSystem` si congela. Alla chiusura del menu si ripristina lo stato precedente.

### Task D3: Gestore Accessibilità & Simmetria (`autoload/accessibility_manager.gd`)
- **Obiettivo**: Coordinare la piena usabilità da tastiera, la vocalizzazione NVDA/AccessKit, le scorciatoie e la sonificazione.
- **Specifiche Tecniche**:
  - **Auto-Focus**: alla visualizzazione di una nuova schermata, individua il primo controllo interattivo e invoca `grab_focus()`.
  - **Scorciatoie Globali da Tastiera**:
    - `Spazio` / `P`: attiva/disattiva pausa temporale.
    - `1`, `2`, `3`: seleziona velocità 1x, 2x, 5x.
    - `T`: annuncia orario corrente e tempo residuo alla mezzanotte.
    - `R`: annuncia sinteticamente le risorse vitali (Energia, Stress, Morale, Denaro).
    - `K`: annuncia status di carriera e livello.
  - **Sonificazione & Ducking**: riproduzione di audio cues leggeri per focus, avvio azione, successo azione, fine giornata, con volume limitato a 0.75f e ducking automatico.

### Task D4: Motore di Esecuzione Azioni (`systems/action_system.gd`)
- **Obiettivo**: Validare, avviare, monitorare e completare le attività della routine quotidiana.
- **Specifiche Tecniche**:
  - Convalida preliminare:
    - Il giocatore possiede l'energia richiesta? Se no, rifiuto con annuncio vocale.
    - Il tempo residuo della giornata è sufficiente per completare l'azione? Se no, rifiuto o avviso overtime.
  - Esecuzione:
    - Transizione a `GAMEPLAY_BUSY`.
    - Decremento del timer azione con emissione di `EventBus.action_progress(action_id, elapsed, duration)`.
  - Risoluzione:
    - Calcolo del guadagno XP tramite `Formulas.calculate_training_xp()` tenendo conto dei rendimenti decrescenti di giornata e del freno da stress/morale.
    - Detrazione energia, incremento stress, aggiornamento XP del giocatore.
    - Emissione `EventBus.action_completed(action_id, rewards)`.
    - Ritorno a `GAMEPLAY_IDLE`.
  - **Prima Azione Implementata**: `"quick_practice"` (Allenamento Rapido: 10s, costo 15 energia, +5 stress, base 10 XP sullo strumento principale).

### Task D5: Ciclo di Fine Giornata (`systems/end_day_system.gd`)
- **Obiettivo**: Risolvere il passaggio tra una giornata e la successiva quando l'orologio raggiunge lo zero.
- **Specifiche Tecniche**:
  - Ascolto del segnale `EventBus.day_ended`.
  - Transizione a `DAILY_SUMMARY`.
  - Addebito spese vive giornaliere: Cibo (10€) + Alloggio/Stanza (15€).
  - Rigenerazione fisiologica del sonno: +70 Energia (max 100), -15 Stress.
  - Azzeramento del contatore di saturazione azioni per il giorno successivo (ripristino rendimento al 100%).
  - Incremento numero del giorno (`day_number + 1`) e ripristino timer a 600 secondi.
  - Presentazione del Daily Summary (interamente consultabile con tastiera ed NVDA).

### Task D6: Persistenza Atomica dei Dati (`autoload/save_manager.gd`)
- **Obiettivo**: Salvare e caricare lo stato della partita su file JSON a prova di crash.
- **Specifiche Tecniche**:
  - File target: `user://savegame.json`.
  - File temporaneo: `user://savegame.tmp`.
  - Gating: consentito unicamente in stato `GAMEPLAY_IDLE` o `DAILY_SUMMARY`. Blocca e segnala errore se invocato durante `GAMEPLAY_BUSY`.
  - Protocollo di scrittura atomica:
    1. Serializzazione del dizionario di salvataggio (versione schema, player_data, calendar_data).
    2. Scrittura su `user://savegame.tmp` e verifica chiusura file con esito positivo.
    3. Ridenominazione atomica del file temporaneo in `user://savegame.json` tramite `DirAccess`.
  - Caricamento: lettura, convalida campi minimi obbligatori e ripopolamento di `PlayerData` e `CalendarData`.

### Task D7: Suite di Test Headless & Schermata Minima Accessibile (`HUD`)
- **Obiettivo**: Collaudare l'intero ciclo vitale sia programmaticamente via CLI sia visivamente/vocalmente.
- **File da creare**:
  - `tests/test_vertical_slice.gd`:
    - Test headless che simula: creazione dati -> avvio tempo -> esecuzione di 1 azione -> avanzamento tempo a 0s -> fine giornata -> salvataggio -> reset memoria -> caricamento dal file JSON salvato -> verifica identità dei dati.
    - Eseguibile da terminale con `powershell -File tools/test.ps1`.
  - `ui/hud/hud.tscn` e `ui/hud/hud.gd`:
    - Interfaccia minima simmetrica con: etichetta orologio (con `accessibility_live`), barra/valore energia, saldo economico, pulsante "Allenamento Rapido" (scorciatoia 1), pulsante "Pausa/Riprendi" (Spazio).
    - Supporto per la navigazione con `Tab`, frecce e NVDA, e glow visivo per Holy Diver.

---

## 3. CHECKPOINT DI CONFORMITÀ E GATING (FASE 2)

- [ ] `P-F2.0`: Modelli Dati `PlayerData`, `CalendarData`, `ActionData` implementati e validati (`F2.1`).
- [ ] `P-F2.1`: `TimeSystem` funzionante con orologio 600s, stati e velocità 1x/2x/5x (`F2.2`).
- [ ] `P-F2.2`: `GameManager` FSM attivo e Pausa Dinamica automatica nei menu collaudata (`F2.3`).
- [ ] `P-F2.3`: `AccessibilityManager` con auto-focus, scorciatoie 1-9 e tasti globali (`F2.4`).
- [ ] `P-F2.4`: Azione "Allenamento Rapido" funzionante con spesa energia e incremento XP (`F2.5`).
- [ ] `P-F2.5`: `EndDaySystem` e transizione a Daily Summary con addebito spese e sonno (`F2.6`).
- [ ] `P-F2.6`: `SaveManager` con scrittura atomica JSON e blocco salvataggio in BUSY (`F2.7`).
- [ ] `P-F2.7`: Collaudo Headless (`tests/test_vertical_slice.gd`) superato al 100% via CLI (`F2.8`).
- [ ] `P-F2.8`: Collaudo congiunto manuale: Luca con NVDA e tastiera, Holy Diver con monitor e mouse.

---

## 4. PROTOCOLLO DI VALIDAZIONE PREVENTIVA A 7 ASSI

1. **Asse 1 — Validità**: Tutti i modelli e sistemi rispettano i tipi statici forti di GDScript 2.0. La serializzazione JSON include numeri di versione dello schema.
2. **Asse 2 — Efficacia**: Risolve il core loop di gioco senza dipendenze premature da sottosistemi secondari (band, locali, canzoni).
3. **Asse 3 — Coerenza**: Perfetta armonia con la Clean Architecture di `SP-07` e le formule matematiche di `SP-06` convalidate in Fase 1.
4. **Asse 4 — Completezza**: Copre Happy Path, casi limite (energia a 0, tempo residuo insufficiente, tentativi di salvataggio a metà azione, corruzione file).
5. **Asse 5 — Precisione**: Ogni componente ha una sola responsabilità e comunica unicamente via EventBus.
6. **Asse 6 — Affidabilità & Prestazioni**: I timer operano su delta time; la scrittura atomica azzera il rischio di corruzione dei salvataggi; i test headless operano in frazioni di secondo.
7. **Asse 7 — Assenza Regressioni**: Nessuna modifica retroattiva alle formule matematiche o alle costanti già convalidate nella Fase 1.
