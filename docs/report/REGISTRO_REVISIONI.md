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
