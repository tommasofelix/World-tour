# Piano Tecnico Formale — Bonifica Fase 2: Disaccoppiamento Input, Bonifica Scorciatoie & Risoluzione Audio Leak
# Progetto: World-tour (Music Career & Life Simulator)
# Autore: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-24
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Sotto-Fase 2B Convalidata al 100% con 28/28 Suite Headless a 0 ms)
# File Piano: docs/piani/attivi/PIANO_BONIFICA_FASE_2_CONFLITTO_TASTI_E_AUDIO_LEAK.md
# Riferimento Diagnostico: docs/report/ANALISI_DIAGNOSTICA_SISTEMA_V5.2.md (Anomalie 1 e 4)
# Versione AVF Target: V5.2.0

---

## 🎯 1. OBIETTIVO E PERIMETRO DELLA FASE 2

Il presente piano operativo risolve le due anomalie funzionali identificate nel Rapporto di Analisi Diagnostica Profonda ([`docs/report/ANALISI_DIAGNOSTICA_SISTEMA_V5.2.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/report/ANALISI_DIAGNOSTICA_SISTEMA_V5.2.md)):
1. **Anomalia 1 — Conflitto di Tasti e Shadowing tra Autoload (`AccessibilityManager`) e Scena (`HUD`)**:
   - Bonifica del metodo `_unhandled_input` in `autoload/accessibility_manager.gd` eliminando i vecchi binding confliggenti delle Fasi 2 e 2.5 (`1`, `2`, `3`, `T`, `R`, `K`, `P`, `M`, `N`);
   - Mantenimento in `AccessibilityManager` esclusivamente dei comandi globali di emergenza e accessibilità pura (Numpad Navigation e silenziamento audio `KP_PERIOD`);
   - Garanzia che l'HUD rimanga l'unico e incontrastato router per la navigazione delle Macro-Aree e delle finestre modali.
2. **Anomalia 4 — Risoluzione Memory Leak AudioStreamPlaybackWAV nei Test Headless**:
   - Pulizia esplicita del flusso audio (`audio_player.stop()` e dereferenziazione `audio_player.stream = null`) in `systems/audio_cue_system.gd` nei metodi `stop()` e `_exit_tree()`;
   - Chiamata preventiva a `AccessibilityManager.silence()` e rilascio immediato (`free()` anziché `queue_free()` prima di `quit(0)`) nella suite `tests/test_v5_ui_overhaul.gd`.

---

## 📦 2. SCOMPOSIZIONE ATOMICA IN NAMED CONTRACTS (PROTOCOLLO 12 - CANCELLO 4)

### ⌨️ Contratto S4 — Input Decoupling & Shortcut Clean Sweep (`accessibility_manager.gd`)
- Rimozione del blocco storico di scorciatoie da tastiera (linee 105–158) in `autoload/accessibility_manager.gd`:
  - `KEY_SPACE, KEY_P` (pausa): già gestito deterministicamente in `HUD._unhandled_input` e via tastierino `KEY_KP_SUBTRACT`;
  - `KEY_1, KEY_2, KEY_3` (velocità tempo): in conflitto diretto con la selezione delle Macro-Aree 1, 2, 3 nell'HUD. La regolazione velocità avviene tramite tasto `T` (ciclo nell'HUD) e `KP_ADD` nel Numpad;
  - `KEY_T` (annuncio orario): in conflitto con il tasto velocità HUD. L'orario viene annunciato tramite `KEY_I` (`speak_hud_info()`) o focalizzando l'orologio;
  - `KEY_R` (annuncio risorse): in conflitto con l'apertura di `RelaxModal` (tasto `R` nell'HUD). La lettura risorse è integrata nella Top Bar permanente e in `speak_hud_info()`;
  - `KEY_K` (annuncio status): in conflitto con l'apertura di `IndustryHub` (tasto `K` nell'HUD). Lo status è sempre visibile e letto nella Top Bar;
  - `KEY_M` (song catalog) e `KEY_N` (song creator): già gestiti da `HUD._unhandled_input` e dai pulsanti dell'Area 2.
- Preservazione blindata in `AccessibilityManager._unhandled_input`:
  - Controlli Numpad (`KP_PERIOD` silence, `KP_5` annuncio focus, `KP_8`/`KP_2`/`KP_4`/`KP_6` navigazione a croce, `KP_ENTER`/`KP_0` accept, `KP_ADD` ciclo velocità, `KP_SUBTRACT` pausa).

### 🔊 Contratto S5 — Audio Stream Cleanup & Zero ObjectDB Leak (`audio_cue_system.gd` & Test)
- Modifica di `systems/audio_cue_system.gd`:
  - Nel metodo `stop()`: aggiungere `audio_player.stream = null` per rilasciare immediatamente il puntatore all'istanza `AudioStreamWAV` e all'`AudioStreamPlaybackWAV` associato;
  - Implementare `_exit_tree()` per invocare `stop()` e pulire la cache dei campioni se necessario.
- Modifica di `tests/test_v5_ui_overhaul.gd`:
  - Invocare `AccessibilityManager.silence()` prima del termine del test;
  - Sostituire `hud_instance.queue_free()` con `hud_instance.free()` per distruggere immediatamente l'albero UI prima dell'invocazione di `get_tree().quit(0)`.

---

## ⚖️ 3. VALIDAZIONE PREVENTIVA A 7 ASSI & 3 LIVELLI DI SIMULAZIONE

- **Asse 1 — Validità**: Rispetto formale delle firme e assenza di chiamate orfane a metodi rimossi.
- **Asse 2 — Efficacia**: Eliminazione totale del conflitto di tasti e azzeramento del leak di 2 istanze `ObjectDB`.
- **Asse 3 — Coerenza**: Netta separazione delle responsabilità: `AccessibilityManager` = sintesi vocale e Numpad; `HUD` = navigazione UI, modali e scorciatoie di gioco.
- **Asse 4 — Completezza**: Verifica che nessun test dipenda dai vecchi binding rimossi da `AccessibilityManager`.
- **Asse 5 — Precisione**: Interventi circoscritti a 3 file (`accessibility_manager.gd`, `audio_cue_system.gd`, `test_v5_ui_overhaul.gd`).
- **Asse 6 — Affidabilità & Prestazioni**: Eliminazione di leak di memoria e overhead di gestione input duplicati.
- **Asse 7 — Assenza Regressioni**: 28/28 suite di test superate con 0 errori a 0 ms.

### I 3 Livelli di Simulazione
- **Livello 1 (Happy Path)**: Selezione delle Macro-Aree con tasti `1`, `2`, `3`, `4` nell'HUD senza intercettazioni indebite; silenziamento audio con `KP_PERIOD` e `AccessibilityManager.silence()`.
- **Livello 2 (Alternativi/Concorrenti)**: Navigazione mista con tastiera alfanumerica (`Esc`, `C`, `G`, `L`, `M`, `R`) e tastierino numerico (`KP_1`..`KP_9`) senza conflitti di focus o eventi duplicati.
- **Livello 3 (Corner Cases)**: Chiusura immediata di scene con audio in riproduzione: verifica con `tools/test.ps1 -TestFile test_v5_ui_overhaul` che il warning di ObjectDB leak sia completamente azzerato.

---

## 📋 4. CHECKLIST OPERATIVA A 3 STATI PER NVDA

- [x] [CONVALIDATO CON SUCCESSO] `T2.1`: Bonifica `_unhandled_input` in `autoload/accessibility_manager.gd` (Contratto S4).
- [x] [CONVALIDATO CON SUCCESSO] `T2.2`: Pulizia e dereferenziazione stream audio in `systems/audio_cue_system.gd` (Contratto S5).
- [x] [CONVALIDATO CON SUCCESSO] `T2.3`: Fix rilascio istanza HUD e silence in `tests/test_v5_ui_overhaul.gd` (Contratto S5).
- [x] [CONVALIDATO CON SUCCESSO] `T2.4`: Verifica mirata con `tools/test.ps1 -TestFile test_v5_ui_overhaul` con zero ObjectDB leak (Contratto S5).
- [x] [CONVALIDATO CON SUCCESSO] `T2.5`: Verifica mirata con `tools/test.ps1 -TestFile test_ui_audio_and_numpad_system` per integrità Numpad (Contratto S4).
- [x] [CONVALIDATO CON SUCCESSO] `T2.6`: Verifica globale con `tools/check.ps1` (0 errori, 0 warning) e `tools/test.ps1` (28/28 suite superate a 0 ms).

---

## 🏁 5. ESITO SOTTO-FASE 2B (CONVALIDA FORMALE COMPLETATA)

Tutti i contratti S4 ed S5 sono stati applicati e convalidati con successo al 100%:
1. Eliminati tutti i conflitti e shadowing di scorciatoie da tastiera tra `AccessibilityManager` e `HUD`.
2. Salvaguardati e verificati tutti i controlli Numpad Navigation e silenziamento in `AccessibilityManager`.
3. Azzerato completamente il memory leak di ObjectDB audio stream sia nella suite `test_v5_ui_overhaul` che in `test_ui_audio_and_numpad_system`.
4. Suite globale 28/28 verificata al 100% con 0 errori a 0 ms. Zero warning console.
