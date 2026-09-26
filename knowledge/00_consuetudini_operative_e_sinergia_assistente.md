# 00 — Consuetudini Operative, Dialogo a 2 Tempi & Protocolli ASTRALIS (v3.0.7)

## Stato & Ambito
- **Ambito**: Progetto World-tour (Music Career Simulator / Life Simulation).
- **Framework**: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica).
- **Runtime**: Godot Engine 4.7.2 win64, GDScript 2.0, Clean Architecture DDD.
- **Accessibilità**: Screen reader NVDA via driver nativo AccessKit (Zero Mouse).

---

## 1. Principio del Dialogo a 2 Tempi & Gating Semantico

1. **Default Consultivo Permanente**:
   - L'assistente opera in modalità consultiva permanente: analizza, verifica i log, consulta le schede di riferimento e formula proposte strutturate.
   - **Divieto Assoluto di Modifica Autonoma**: Nessun file, codice sorgente o impostazione può essere creato, modificato o eliminato senza l'esplicito comando di Luca (*"procedi"*, *"applica"*, *"esegui"*).
   - Richieste come *"cosa ne pensi?"*, *"valuta"*, *"come faresti?"*, *"analizza"* impongono all'assistente di rimanere in modalità consultiva pura (zero azioni modificative).
2. **Gating Semantico e Disaccoppiamento Fase 1**:
   - Comandi come *"passa alla fase 1"* autorizzano **esclusivamente la stesura del Piano Tecnico Formale (Sotto-Fase 1A)** in `docs/piani/attivi/`.
   - L'assistente redige il piano, lo registra e si arresta tassativamente (**Stop Obbligatorio**), attendendo la convalida esplicita di Luca post-lettura prima di toccare codice o configurazioni (Sotto-Fase 1B).
3. **Matrice di Avanzamento a 3 Stati per NVDA**:
   - `- [ ] [DA AVVIARE]`: Attività pianificata ma non ancora iniziata;
   - `- [/] [IMPLEMENTATO — IN ATTESA DI CONVALIDA]`: Codice scritto o intervento completato, in attesa di test o collaudo formale (spunta parziale);
   - `- [x] [CONVALIDATO CON SUCCESSO]`: Spunta definitiva concessa **esclusivamente POST-CONVALIDA** (approvazione per la 1A, test suite 100% verde per la 1B, collaudo pratico NVDA per la Fase 2). Divieto assoluto di spunta preventiva.

---

## 2. I 12 Protocolli Operativi Ufficiali ASTRALIS

L'assistente riconosce e aggancia dinamicamente i 12 protocolli formali del framework:

1. **Protocollo Progettazione** *(Fase 0 & Sotto-Fase 1A)*: Definizione modello mentale, architettura e contratti D0..DN prima di modificare codice;
2. **Protocollo Validazione** *(7 Assi + 3 Livelli)*: Certificazione di robustezza e assenza regressioni;
3. **Protocollo Esecuzione** *(Sotto-Fase 1B / Deploy Fase 2)*: Modifiche chirurgiche, build pulita e deploy proattivo;
4. **Protocollo Telemetria & Monitoraggio Live** *(Fase 2)*: Affiancamento durante il collaudo con filtro ad alto segnale ed estrazione anomalie nel `REGISTRO_REVISIONI.md`;
5. **Protocollo Revisione & Affinamento (PRAPI)**: Ciclo rapido di feedback post-collaudo con la Strategia dei Buffer di Rifinitura;
6. **Protocollo Chiusura** *(Fase 3)*: Commit Git (`feat:`, `fix:`, `docs:`), calcolo versione AVF (`V.A.R[.M]`), archiviazione piani in `docs/piani/completati/` e Domanda Ponte Obbligatoria;
7. **Protocollo Auto-Apprendimento Continuo** *(Fase 4)*: Consolidamento delle lezioni su Doppio Binario (Binario A Locale in `knowledge/`, Binario B Globale nel Master Hub);
8. **Protocollo Aggiornamento & Migrazione Stack**: Avanzamento versioni runtime/motore e compatibilità binaria;
9. **Protocollo Diagnosi & Risoluzione Bug Sistemici**: Isolamento cause radice deterministiche (RCA) senza workaround fragili;
10. **Protocollo Configurazione & Ambiente**: Setup CLI, percorsi dinamici e toolchain;
11. **Protocollo Pulizia, Bonifica & Rifinitura**: Rimozione codice morto ed elementi obsoleti con Contratto D0 Clean Sweep e Canone 7 (D41 Guard);
12. **Protocollo Dialettica Ingegneristica & Auto-Revisione Avversariale**: Inner Codex Pattern basato sui 6 Cancelli Inviolabili.

---

## 3. Pipeline Operativa a 4 Fasi & Domanda Ponte di Chiusura

- **Fase 1A (Pianificazione & Stop Obbligatorio)**: Stesura del piano tecnico in `docs/piani/attivi/` con audit preventivo dei 6 Cancelli e checkpoint di convalida.
- **Fase 1B (Esecuzione Tecnica & Test Headless)**: Pre-Flight Check, modifiche chirurgiche, compilazione e suite di test automatici a 0 ms (solo post-convalida del piano).
- **Fase 2 (Deploy Proattivo, Telemetria & Collaudo Manuale)**: Avvio del motore con console e supporto screen reader, monitoraggio log ed esecuzione test pratico di Luca da tastiera con NVDA.
- **Fase 3 (Chiusura Tecnica, Git & AVF)**: Commit strutturato, aggiornamento Living Documentation, archiviazione del piano in `docs/piani/completati/` e chiusura tassativa con la **Domanda Ponte Obbligatoria**:
  > *"Vuoi che avviamo ora la sessione formale di Auto-Apprendimento (Fase 4) per elaborare la bozza dettagliata delle regole e aggiornare le schede di conoscenza e governance?"*
- **Fase 4 (Auto-Apprendimento Continuo — al via libera di Luca)**: Mappatura file di destinazione, redazione paragrafi completi su Binario A (Locale) e Binario B (Master Hub) e applicazione autorizzata.

---

## 4. Validazione Preventiva sui 7 Assi di Qualità & Matrice a 3 Livelli

Ogni proposta tecnica deve soddisfare i **7 Assi di Qualità**:
1. *Validità*: Rispetto rigoroso dei contratti logici e dei tipi GDScript tipizzati;
2. *Efficacia*: Risoluzione deterministica del problema alla radice senza pezze euristiche;
3. *Coerenza*: Armonia architetturale con Clean Architecture e disaccoppiamento EventBus;
4. *Completezza*: Gestione esplicita di tutti i rami di errore e condizioni al contorno;
5. *Precisione*: Modifiche chirurgiche minime, preservando codice e commenti esistenti;
6. *Affidabilità & Prestazioni*: Zero leak, rispetto delle risorse ed esecuzione headless a 0 ms;
7. *Assenza di Regressioni*: Tutela del comportamento preesistente e delle suite di test attive.

La proposta viene verificata sulla **Matrice di Simulazione a 3 Livelli**:
- *Livello 1: Scenari Comuni* (Happy Path — flusso tipico di gameplay e UI);
- *Livello 2: Scenari Meno Comuni* (Alternative Paths & condizioni concorrenti);
- *Livello 3: Casi Limite & Condizioni Estreme* (Corner Cases, valori nulli, array vuoti, boundary values).

---

## 5. Protocollo di Eliminazione Consapevole e Protetta (5 Passi)

Prima di procedere alla cancellazione di qualsiasi file o directory:
1. **Identificazione Esatta**: Indicare chiaramente percorso e natura del bersaglio;
2. **Motivazione Tecnica**: Spiegare perché il file deve essere eliminato;
3. **Analisi d'Impatto**: Descrivere le conseguenze sul progetto, sulle dipendenze e sui test;
4. **Verifica Dati & Recuperabilità**: Accertare che dati storici o note utili siano preservati altrove;
5. **Richiesta di Consenso Specifico**: Attendere l'autorizzazione esplicita di Luca prima di procedere.

---

## 6. Canoni Architetturali di Simulazione & Pacing Fisiologico (Revisione Popomundo)

1. **Canone del Pacing a 2 Sessioni Quotidiane con Zero-Cost Rejection**:
   - Le attività creative (composizione musicale, stesura testi, arrangiamento) e formative ad alto valore non devono essere spammabili all'infinito in una singola giornata virtuale.
   - Ogni cantiere attivo impone un limite tassativo di massimo 2 sessioni giornaliere per componente:
     * Sessione 1: resa piena al 100% e consumi nominali;
     * Sessione 2: resa dimezzata al 50% per stanchezza creativa e stress maggiorato del +50%;
     * Sessione 3+: **Rifiuto Categorico a Costo Zero**. Il sistema blocca l'operazione restituendo un esito negativo strutturato *prima* di prelevare energia o infliggere stress (0 energia, 0 stress, 0 tempo perso), con notifica vocale immediata per NVDA.
   - All'alba di ogni nuovo giorno virtuale (`EndDaySystem`), i contatori giornalieri vengono azzerati in modo deterministico.

2. **Canone dell'Avanzamento Temporale Sincrono nei Modali (`advance_virtual_hours`)**:
   - Quando un'interfaccia a schermo intero (come `SongCreator`) o un menu opera durante la pausa del gioco (`is_paused`), le attività che nella diegesi consumano ore non possono dipendere dal delta tick del motore fisico.
   - Il sistema invoca metodi sincroni dedicati (`TimeSystem.advance_virtual_hours(hours)`), che scalano l'orologio, aggiornano le fasce orarie (Mattino $\to$ Pomeriggio $\to$ Notte), emettono `time_ticked` e gestiscono le notifiche di overtime progressivo, mantenendo fermo l'avatar nel mondo 2.5D.

3. **Canone della Trasparenza Vocale delle Risorse Discrete (Zero-Guessing NVDA)**:
   - L'accessibilità per non vedenti esclude l'esplorazione per "tentativi ed errori".
   - L'indicatore di disponibilità residua (`[Musica: %.0f%% (%d/2)]`) è integrato direttamente nell'etichetta dell'entità, e i pulsanti d'azione aggiornano in tempo reale la propria dicitura e descrizione accessibile per NVDA (*"Resa 50%"* vs *"Satura per oggi"* con disabilitazione del tasto).
