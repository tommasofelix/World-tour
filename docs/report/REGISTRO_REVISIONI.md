# Registro Attivo delle Revisioni & Affinamenti Post-Collaudo (RRU)
# Progetto: World-tour (Music Career Simulator)
# Autore: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Percorso: docs/report/REGISTRO_REVISIONI.md
# Archivio Storico: docs/report/archivio/ARCHIVIO_REVISIONI.md
# Framework: ASTRALIS v3.0.7

Questo documento costituisce il **Registro Attivo Snello** del progetto World-tour. Ospita *esclusivamente* le revisioni confermate ancora aperte (`[APERTA / IN TELEMETRIA]`), in lavorazione (`[IN LAVORAZIONE]`) o in corso di verifica. A collaudo positivo confermato da Luca con NVDA, le voci vengono trasferite nell'**Archivio Storico delle Revisioni** ([`ARCHIVIO_REVISIONI.md`](./archivio/ARCHIVIO_REVISIONI.md)), mantenendo questo file sempre leggero e rapido da consultare con la sintesi vocale.

---

## 📋 REVISIONI ATTIVE IN CORSO

### 🟡 RRU-22 — Ricostruzione Planimetria Isometrica Modulare & Blindatura Anti-Freeze Runtime
- **Stato**: `[IN LAVORAZIONE]`
- **Data Rilevamento**: 2026-09-24
- **Problema Riscontrato (Esperienza Utente NVDA & Holy Diver)**:
  1. Appartamento visivamente disconnesso: pavimento composto da 6 tessere con buchi e fratture; pareti slegate a diverse altezze; oggetti (porta/cassa, letto, giradischi, attrezzi, cestino) fluttuanti nel vuoto fuori dalla stanza.
  2. Blocco / freeze del gioco dopo poco tempo dall'avvio durante l'esplorazione.
- **Evidenza Telemetrica / Log**:
  - `Text-to-Speech: OneCore initialized` nei log di avvio; collisioni multiple ad alta frequenza e raffiche ravvicinate di `DisplayServer.tts_stop()` / `DisplayServer.tts_speak()` generanti deadlock nella coda audio COM Windows.
  - Auto-walk (`player.walk_to_target`) privo di timeout di sicurezza: se la traiettoria verso l'arredo è bloccata, `is_auto_walking` non si disattiva mai, scartando perennemente l'input manuale da tastiera.
  - Mancato avanzamento di `action_system.update_action(delta)` e `time_system.advance_time(delta)` in `ApartmentHud`.
- **Causa Radice**: Assenza di griglia isometrica matematica rigorosa ($2:1$, passo $\pm 100, \pm 50$), mancato allineamento dei vertici tra mattonelle e pareti, posizionamento coordinate arredi oltre il perimetro visibile, deadlock TTS Windows e assenza di watchdog/cancellazione su auto-walk.
- **Soluzione di Affinamento (PRAPI - Opzione 2)**:
  1. Matrice $5 \times 5$ tessere isometriche continue (25 tessere) con giunzioni mathematically-seamless, tappeto centrale e perimetro di collisione esatto.
  2. Mura posteriori connesse (`angolo_muro`, `finestra`, `muro_destra`) e porta d'uscita coerente su pavimento.
  3. Tutti i 9 arredi posizionati saldamente all'interno della stanza con corridoi di passaggio liberi da ostacoli.
  4. Debouncer e guardia anti-concorrenza TTS in `AccessibilityManager` (anti-deadlock).
  5. Watchdog timeout (2.0s) e cancellazione istantanea su input manuale in `PlayerAlex.walk_to_target()`.
  6. Integrazione ciclo `action_system` e `time_system` in `ApartmentHud`.
- **Piano Tecnico di Riferimento**: [`docs/piani/attivi/PIANO_GAMEPLAY_GRAFICO_APPARTAMENTO.md`](../piani/attivi/PIANO_GAMEPLAY_GRAFICO_APPARTAMENTO.md)
- **Esito Collaudo**: In attesa di autorizzazione e collaudo congiunto.

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
