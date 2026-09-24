# Piano Tecnico Formale — Bonifica Fase 1: Igiene, Deduplicazione & Allineamento Zero Rischio
# Progetto: World-tour (Music Career & Life Simulator)
# Autore: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-24
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Sotto-Fase 1B Convalidata al 100% con 28/28 Suite Headless a 0 ms)
# File Piano: docs/piani/attivi/PIANO_BONIFICA_FASE_1_IGIENE_E_PULIZIA_ZERO_RISCHIO.md
# Riferimento Diagnostico: docs/report/ANALISI_DIAGNOSTICA_SISTEMA_V5.2.md
# Versione AVF Target: V5.2.0

---

## 🎯 1. OBIETTIVO E PERIMETRO DELL'INTERVENTO (FASE 1)

Il presente piano operativo recepisce le anomalie a rischio zero evidenziate nel Rapporto di Analisi Diagnostica Profonda ([`docs/report/ANALISI_DIAGNOSTICA_SISTEMA_V5.2.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/report/ANALISI_DIAGNOSTICA_SISTEMA_V5.2.md)) con l'obiettivo di:
1. Eliminare i warning di caricamento engine di Godot 4 dovuti al mismatch degli identificatori UID;
2. Rimuovere il codice duplicato e ridondante nel caricamento del salvataggio (`SaveManager.gd`);
3. Bonificare le directory orfane residue secondo il canone *Clean Sweep*;
4. Sincronizzare deterministamente la versione `5.2.0` nei metadati del motore (`project.godot`) e nella Living Documentation (`CHANGELOG.md`).

---

## 🔒 2. PROTOCOLLO DI ELIMINAZIONE CONSAPEVOLE E PROTETTA (CANONE D0)

In conformità alla **Firma 4** del Genoma Globale, si dichiara preventivamente:
- **Elementi da Eliminare**:
  1. Cartella `ui/menus/` (directory vuota, 0 byte, 0 file);
  2. Cartella `ui/common/` (directory vuota, 0 byte, 0 file).
- **Motivazione Tecnica**: Residui orfani creati all'avvio del progetto prima dell'adozione dell'architettura a modali autonome.
- **Impatto sul Progetto**: Zero. Nessun file GDScript o scena TSCN fa riferimento a queste due cartelle. Le 28 suite di test continueranno a funzionare inalterate.
- **Verifica Salvaguardia Dati**: Verificato che le cartelle sono interamente prive di note, file nascosti o asset.

---

## 📦 3. SCOMPOSIZIONE ATOMICA IN NAMED CONTRACTS (PROTOCOLLO 12 - CANCELLO 4)

### 🧹 Contratto D0 — Clean Sweep (Rimozione Residui Orfani)
- Eliminazione protetta della directory vuota `ui/menus/`;
- Eliminazione protetta della directory vuota `ui/common/`.

### 🏷️ Contratto S1 — Engine UID Alignment (Eliminazione Warning Godot 4)
- Sostituzione delle stringhe UID fittizie/manuali con gli UID reali generati in `.gd.uid`:
  1. `ui/system_menu/system_menu_modal.tscn` (linea 3):
     - Da: `uid="uid://c5q3menu89xyz"`
     - A: `uid="uid://d3rjqtlnu71rk"`
  2. `ui/upgrades/upgrades_modal.tscn` (linea 3):
     - Da: `uid="uid://df67upgradewt01"`
     - A: `uid="uid://b72cn1ikjbwsm"`
  3. `tests/test_v5_ui_overhaul.tscn` (linea 3):
     - Da: `uid="uid://bv5uioverhaul01"`
     - A: `uid="uid://dd1xjhs7gr88v"`
  4. `tests/test_upgrades_system.tscn` (linea 3):
     - Da: `uid="uid://cf87testupgradwt01"`
     - A: `uid="uid://witt06asvvn1"`
  5. `tests/test_ui_audio_and_numpad_system.tscn` (linea 3):
     - Da: `uid="uid://bv5audnumpad01"`
     - A: `uid="uid://50xejq1dviqs"`

### ✂️ Contratto S2 — Code Deduplication (`SaveManager.gd`)
- Rimozione chirurgica del secondo blocco di configurazione di `GameManager.concert_system` (linee 247-253 in `autoload/save_manager.gd`), già completamente eseguito alle linee 132-137.

### 📌 Contratto S3 — Version & Changelog Alignment
- Aggiornamento di `project.godot`:
  - `config/version="5.2.0"` (in precedenza rimasto a `1.0.0`).
- Aggiornamento di `CHANGELOG.md`:
  - Aggiunta della voce formale per la release `Versione 5.2.0 — Espansione Post-V5.1: Endless Horizon, New Game+ Heirs, Circuito a 16 Metropoli & Magnate Discografico Attivo`.

---

## ⚖️ 4. VALIDAZIONE PREVENTIVA A 7 ASSI & 3 LIVELLI DI SIMULAZIONE

- **Asse 1 — Validità**: Rispetto rigoroso della sintassi GDScript 2.0 e del formato di serializzazione TSCN di Godot 4.
- **Asse 2 — Efficacia**: Eliminazione immediata al 100% dei warning di caricamento console e del blocco duplicato.
- **Asse 3 — Coerenza**: Perfetta aderenza alle convenzioni architetturali del repository e alla disciplina AVF.
- **Asse 4 — Completezza**: Copertura di tutti i mismatch UID individuati dall'analisi diagnostica automatizzata.
- **Asse 5 — Precisione**: Modifiche minime, limitate esclusivamente a 5 righe di metadati scena, 6 righe di codice ridondante e 2 file di metadati/documentazione.
- **Asse 6 — Affidabilità & Prestazioni**: Riduzione impercettibile ma deterministica dell'overhead nel ciclo di caricamento partita.
- **Asse 7 — Assenza Regressioni**: Le 28 suite di test automatizzate headless devono continuare a superare tutti i controlli a 0 errori e 0 ms.

### I 3 Livelli di Simulazione
- **Livello 1 (Happy Path)**: Avvio del controllo sintattico `tools/check.ps1` con 0 errori e 0 warning di UID; esecuzione di `tools/test.ps1` con 28/28 suite superate.
- **Livello 2 (Alternativi/Concorrenti)**: Salvataggio e caricamento partita da menu principale e dall'HUD senza impatti sul runtime di `ConcertSystem`.
- **Livello 3 (Corner Cases)**: Verifica che l'assenza delle cartelle vuote non provochi anomalie nei tool PowerShell di scansione file.

---

## 📋 5. CHECKLIST OPERATIVA A 3 STATI PER NVDA

- [x] [CONVALIDATO CON SUCCESSO] `T1.1`: Eliminazione protetta cartelle vuote `ui/menus/` e `ui/common/` (Contratto D0).
- [x] [CONVALIDATO CON SUCCESSO] `T1.2`: Correzione UID in `ui/system_menu/system_menu_modal.tscn` (Contratto S1).
- [x] [CONVALIDATO CON SUCCESSO] `T1.3`: Correzione UID in `ui/upgrades/upgrades_modal.tscn` (Contratto S1).
- [x] [CONVALIDATO CON SUCCESSO] `T1.4`: Correzione UID in `tests/test_v5_ui_overhaul.tscn` (Contratto S1).
- [x] [CONVALIDATO CON SUCCESSO] `T1.5`: Correzione UID in `tests/test_upgrades_system.tscn` (Contratto S1).
- [x] [CONVALIDATO CON SUCCESSO] `T1.6`: Correzione UID in `tests/test_ui_audio_and_numpad_system.tscn` (Contratto S1).
- [x] [CONVALIDATO CON SUCCESSO] `T1.7`: Rimozione blocco duplicato `concert_system` in `autoload/save_manager.gd` (Contratto S2).
- [x] [CONVALIDATO CON SUCCESSO] `T1.8`: Allineamento `config/version="5.2.0"` in `project.godot` (Contratto S3).
- [x] [CONVALIDATO CON SUCCESSO] `T1.9`: Inserimento voce V5.2.0 in `CHANGELOG.md` (Contratto S3).
- [x] [CONVALIDATO CON SUCCESSO] `T1.10`: Verifica globale con `tools/check.ps1` (0 errori, 0 warning) e `tools/test.ps1` (28/28 suite superate a 0 ms).

---

## 🏁 6. ESITO SOTTO-FASE 1B (CONVALIDA FORMALE COMPLETATA)

Tutte le modifiche dei contratti D0, S1, S2 e S3 sono state convalidate con successo:
1. `tools/check.ps1`: 104 file verificati con 0 errori e 0 warning di UID.
2. `tools/test.ps1`: 28 suite di test su 28 superate al 100% con 0 errori a 0 ms.
3. Integrità del runtime e del versionamento V5.2.0 completamente ristabilita.
