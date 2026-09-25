# World-tour — Piano Tecnico Formale: Segregazione Tasti Movimento, Ciclo Sonno & Allineamento Arredi
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-25
# Stato: [x] [CONVALIDATO CON SUCCESSO — FASE 1B/2/3 CONCLUSA]
# File Piano: docs/piani/completati/PIANO_SEGREGAZIONE_TASTI_MOVIMENTO_E_CICLO_SONNO_LOFT.md
# Coordinatore Master: docs/todo.md
# Versione Target AVF: V5.6.2

---

## 🎯 1. OBIETTIVO E PERIMETRO DELL'INTERVENTO

Risolvere deterministicamente le anomalie riscontrate nel loft NYC:
1. **Segregazione dei Canali di Input (Zero Collisioni Tasto `W`)**: eliminare il cammino involontario in avanti di Alex alla pressione di `W` (Albo d'oro) rimuovendo i comandi WASD da `player_alex.gd` e riservando il movimento spaziale unicamente alle Frecce direzionali e al Tastierino Numerico (Numpad 8/2/4/6 e diagonali);
2. **Riparazione Ciclo del Sonno & Riepilogo Notturno (`DailySummary`)**: sanare l'errore di tipo e segnale (`EventBus.day_ended(int)` vs `Dictionary`) e la visibilità del contenitore padre `$Modals`, garantendo che alla chiusura della giornata la modale del riepilogo notturno appaia, riceva il focus, vocalizzi il resoconto completo e permetta di passare al nuovo giorno (06:00 del mattino) sbloccando Alex;
3. **Sblocco Accredito XP nelle Azioni con Durata del Loft**: correggere il flag `p_is_recovery` in `ApartmentHud._run_action_with_duration` e `ActionSystem` per assicurare che azioni come le scale e riff sulla chitarra o la jam acustica assegnino regolarmente i punti esperienza;
4. **Allineamento Etichette Arredi in `apartment.tscn`**: aggiornare i testi di ispezione e i nomi di `PropWardrobe` ("Guardaroba & Outfit") e `PropToolbox` ("Cassa Attrezzi & Manutenzione") in piena conformità con le direttive specialistiche di Luca.

---

## 🔍 2. ROOT CAUSE ANALYSIS (RCA) DETERMINISTICHE

1. **Causa Movimento su Tasto `W`**:
   - In `scenes/apartment/player_alex.gd`, `_get_input_vector()` conteneva `if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W): v.y -= 1.0`.
   - In `_physics_process()`, la pressione di `W` veniva rilevata ad ogni frame come comando di moto in avanti/alto, collidendo con il tasto rapido `KEY_W` dell'Albo d'oro gestito in `apartment.gd`.
   - In un gioco con oltre 15 comandi alfabetici, i tasti lettera non devono interferire con il movimento.

2. **Causa Freeze al Sonno / Passaggio Giorno Successivo**:
   - In `ui/apartment_hud/apartment_hud.gd` (riga 177), `EventBus.day_ended` era collegato a `_on_day_ended(summary_data: Dictionary)`.
   - `EventBus.day_ended` trasmette `day_number: int`. Invocare `.get()` sull'intero in `daily_summary.gd` (riga 35) generava un crash di runtime (`Invalid call. Nonexistent function 'get' in base 'int'`).
   - Il fornitore effettivo del dizionario è `EndDaySystem.summary_ready`.
   - Inoltre, `hide_all_modals()` spegneva `$Modals.visible = false` senza riattivarlo prima di mostrare `daily_summary_modal`, lasciando la finestra invisibile a schermo e il giocatore bloccato nello stato `DAILY_SUMMARY`.

3. **Causa Mancato Guadagno XP Azioni Loft**:
   - In `_run_action_with_duration()`, l'azione veniva istanziata con `p_is_recovery = true` hardcoded.
   - In `ActionSystem._complete_action()`, la presenza di `is_recovery == true` dirottava l'esecuzione sul ramo del sonno/caffè, saltando il calcolo e l'accredito dei punti esperienza per lo strumento o la composizione.

---

## 📐 3. SCOMPOSIZIONE IN NAMED CONTRACTS (D0..D4)

### 🎮 CONTRATTO D0: Segregazione Tasti Movimento (Zero Collisioni Tasto W)
- In `scenes/apartment/player_alex.gd`:
  * Rimosso `Input.is_key_pressed(KEY_W)`, `KEY_S`, `KEY_A`, `KEY_D` da `_get_input_vector()`;
  * Mantenuto unicamente `ui_up`, `ui_down`, `ui_left`, `ui_right` e i tasti Numpad (`KEY_KP_8`, `KEY_KP_2`, `KEY_KP_4`, `KEY_KP_6`, `KEY_KP_7`, `KEY_KP_9`, `KEY_KP_1`, `KEY_KP_3`).
- In `scenes/apartment/apartment.gd`:
  * In `_on_modal_opened(_modal_name: String)`: aggiunto `player.velocity = Vector2.ZERO` e `player.cancel_auto_walk()` per azzerare qualsiasi inerzia residua all'apertura delle finestre.

---

### 🌙 CONTRATTO D1: Allineamento Segnale Ciclo Sonno & Riepilogo Notturno
- In `autoload/event_bus.gd`:
  * Aggiunto `signal daily_summary_ready(summary_data: Dictionary)`;
- In `systems/end_day_system.gd`:
  * In `process_day_end()`: dopo `summary_ready.emit(summary)`, emesso `EventBus.daily_summary_ready.emit(summary)`.
- In `ui/apartment_hud/apartment_hud.gd`:
  * In `_connect_events()`:
    * `EventBus.daily_summary_ready.connect(_on_daily_summary_ready)`;
    * `EventBus.day_ended.connect(func(_d: int): update_hud_display())`;
  * Ristrutturato `_on_daily_summary_ready(summary_data: Dictionary)`:
    * Esegue `hide_all_modals()`;
    * Imposta `$Modals.visible = true`;
    * Invoca `daily_summary_modal.show_summary(summary_data)`;
    * Emette `modal_opened.emit("DailySummary")`;
  * In `open_dilemma(dilemma_dict)`: imposta `$Modals.visible = true` prima di `dilemma_modal.open(dilemma_dict)`.

---

### 🎸 CONTRATTO D2: Sblocco Guadagno XP nelle Azioni con Durata del Loft
- In `ui/apartment_hud/apartment_hud.gd`:
  * In `_run_action_with_duration(action: Dictionary)`:
    * Calcolato `p_is_recovery = (xp <= 0.0)`.
- In `systems/action_system.gd`:
  * In `_complete_action()`: consentita l'assegnazione degli XP se `current_action.base_xp > 0.0` anche in presenza di modificatori di recupero fisiologico.
  * Aggiunto supporto ad `add_xp_to_skill` e alias `add_skill_xp` in `PlayerData`.

---

### 🏷️ CONTRATTO D3: Allineamento Etichette Arredi in `apartment.tscn`
- In `scenes/apartment/apartment.tscn`:
  * Aggiornato `PropWardrobe` a:
    * `prop_name`: `"Guardaroba & Outfit"`
    * `prop_description`: `"Cambiati il look da palco per caricare il morale"`
    * `inspection_text`: `"Armadio guardaroba con toppe e giacche da rocker. Qui puoi cambiarti il look da palco! [Spazio]"`
  * Aggiornato `PropToolbox` a:
    * `prop_name`: `"Cassa Attrezzi & Manutenzione"`
    * `prop_description`: `"Controlla cavi jack ed esegui set-up della chitarra"`
    * `inspection_text`: `"Cassa degli attrezzi rossa con cavi jack e attrezzi di precisione per la manutenzione degli strumenti. [Spazio]"`

---

### 🧪 CONTRATTO D4: Convalida Headless a 0 ms & Test Suite
- In `tests/test_apartment_gameplay.gd`:
  * Test Isolamento Tasto `W`: verificato che la pressione di `KEY_W` non alteri il vettore di movimento di Alex (`_get_input_vector() == Vector2.ZERO`);
  * Test Ciclo del Sonno e Riepilogo: verificata ricezione di `_on_daily_summary_ready(summary_dict)`, verifica `$Modals.visible == true` e `daily_summary_modal.visible == true`, verifica `btn_next_day` ed il passaggio al giorno successivo con chiusura modale e sblocco Alex;
  * Test Guadagno XP: verificato che l'esecuzione di `guitar_practice` incrementi regolarmente gli XP dello strumento.
  * Esecuzione 30/30 suite headless superata al 100% con 0 errori a 0 ms; verifica sintattica di 114 file GDScript con 0 errori.
