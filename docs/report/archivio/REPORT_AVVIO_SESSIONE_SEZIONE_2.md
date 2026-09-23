# Report di Handoff & Bootstrap — Avvio Sezione 2: Creatività Musicale, Scrittura e Produzione
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-23
# Percorso File: docs/report/REPORT_AVVIO_SESSIONE_SEZIONE_2.md
# File di Riferimento: docs/roadmap/02_creativita_musicale_scrittura_e_produzione.md
# Priorità: P2 — Loop Discografico & Crafting Avanzato

---

## 🎯 1. OBIETTIVO DEL DOCUMENTO

Questo documento costituisce il **Report di Bootstrap / Handoff** pronto all'uso per avviare una **nuova sessione di lavoro** (nuova chat) in pair programming con Antigravity.
Contiene lo stato dell'arte del progetto, i prerequisiti tecnici consolidati, l'analisi dei requisiti della **Sezione 2 della Roadmap Modulare** e la struttura preliminare per la stesura del **Piano Tecnico Operativo (Sotto-Fase 1A)** nel pieno rispetto della Regola 0 e della governance ASTRALIS.

---

## 🏛️ 2. STATO DELL'ARTE DEL PROGETTO (BASELINE DI PARTENZA)

1. **Sezione 1 della Roadmap Completata al 100%**:
   - **Sezione 1.1**: Creazione Personaggio guidata (nome anagrafico / nome d'arte, selettore età 16-60, 6 strumenti musicali, 5 background, 5 tratti) con biforcazione Main Menu tra *Nuova Partita* e *Modalità Test / Avvio Rapido* (Alex preconfigurato con 10 canzoni e 500 €).
   - **Sezione 1.2**: Filosofia della Notte su 22 ore virtuali (06:00 – 04:00), eliminazione totale di pop-up bloccanti a mezzanotte, overtime progressivo non forfettario (+2, +3, +5, +10 di stress), avvisi vocali discreti NVDA alle 02:00 e 03:00, e controlli di navigazione temporale rapida con tasti *Aspetta (X)* e *Dormi (Z)* con bonus sonno ristoratore.
   - **Sezione 1.3**: Triade fisiologica delle Risorse Vitali (Energia, Stress, Morale), rilevamento stati critici di Burnout Fisico (<15% energia, durata raddoppiata per azioni ordinarie ed esenzione per la cura) e Panico psicologico ($\ge$ 80% stress), verifica preventiva dei fondi disponibili, e modale `RelaxModal` (tasto HUD `R`) con opzioni numeriche `1` (Caffè), `2` (Passeggiata) e `3` (Ascolto disco con 35% chance Scintilla Creativa).

2. **Integrità del Codice & Test Suite Headless (266 / 266 Superati — 0 Errori)**:
   - Tutte le suite di test sono 100% verdi con esecuzione headless tramite console Godot:
     * `test_vital_resources_system.tscn` (37/37 OK)
     * `test_time_night_system.tscn` (28/28 OK)
     * `test_character_creation.tscn` (39/39 OK)
     * `test_vertical_slice.tscn` (65/65 OK)
     * `test_v5_ui_overhaul.tscn` (67/67 OK)
     * `test_localization.tscn` (30/30 OK)
   - Totale: 20 suite di test censite ed operative nel progetto.

3. **Integrità Documentale & Working Tree Git**:
   - Piani attivi (`docs/piani/attivi/`): 100% pulita (tutti i 15 sottopiani e il piano 1.3 archiviati in `docs/piani/completati/`).
   - Strategie attive (`docs/strategie/attive/`): 100% pulita (strategia Sezione 1 archiviata).
   - Registro Revisioni (`docs/report/REGISTRO_REVISIONI.md`): 0 anomalie aperte. Archivio storico aggiornato con `RRU-01`..`RRU-06`.
   - Master Hub di Governance: Aggiornato con Sezione 12 (Closure Container Pattern) e release `v3.0.8`.
   - Working Tree Git: 100% pulito sul branch `main`.

---

## 🎼 3. AMBITO DELLA SEZIONE 2: CREATIVITÀ MUSICALE, SCRITTURA E PRODUZIONE

Il documento specialistico di riferimento è [`docs/roadmap/02_creativita_musicale_scrittura_e_produzione.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/roadmap/02_creativita_musicale_scrittura_e_produzione.md).  
Articola l'evoluzione del ciclo creativo e discografico in quattro macro-sottoaree:

### 3.1 Pipeline Creativa a 5 Stadi & Generi Musicali
- **I 6 Generi Musicali**: Rock, Pop, Metal, Hip Hop, Elettronica, Indie.
- **I 5 Stadi di Lavorazione**:
  1. *Concept*: Genere, Titolo, Ispirazione e Tematica Lirica;
  2. *Composizione*: Melodie, riff e armonie (abilità Composizione);
  3. *Scrittura Testo*: Metrica, rime e messaggio (abilità Scrittura Testi);
  4. *Registrazione*: Tracce vocali/strumentali (abilità Strumento / Canto + Hardware Studio);
  5. *Missaggio/Mastering*: Bilanciamento sonoro (abilità Produzione + Studio).
- **Tematiche Liriche**: Scelta del tema (es. Rabbia Sociale, Amore Maledetto, Nostalgia Giovanile, Fuga dalla Realtà, Satira Politica) con bonus di affinità di genere e risonanza territoriale con le metropoli.

### 3.2 Algoritmo Quality Score & Tratti Speciali Canzone
- **Formula del Quality Score**:
  * Composizione: 25%
  * Testo: 20%
  * Esecuzione Strumentale/Vocale: 25%
  * Produzione Sonora: 20%
  * Variazione casuale controllata (+/- 4.0 punti) e clamp [1.0, 100.0].
- **Principio Inviolabile**: `QUALITY != COMMERCIAL SUCCESS` (la qualità tecnica è la base, ma streaming e vendite dipendono da promozione, tratti, fanbase e social buzz).
- **I Tratti Canzone Esistenti & Nuovi**:
  * `EARWORM` (Tormentone): +25% streaming Day 1-30.
  * `CULT_CLASSIC` (Pezzo Cult): Converte x2.0 fan ai concerti.
  * `STAGE_BEAST` (Bomba dal Vivo): +15% Concert Score come closer.
  * `AUDIOPHILE_GEM` (Gemma per Audiofili): Recensioni entusiaste (richiede Produzione >= 70).
  * `ROUGH_DIAMOND` (Diamante Grezzo): Grande composizione con registrazione low-fi.
  * Nuovi tratti: *Inno Generazionale*, *Ballata Strappalacrime*, *Riff Epico*.

### 3.3 Formati Discografici (Singolo, EP, LP/Album Completo)
- **Singolo**: 1 traccia trainante, costi minimi, ideale per esordienti.
- **EP**: 3-5 tracce, bilanciamento tra concept e coesione, primo passo per contratti indie.
- **LP / Album Completo**: 6-10 tracce, selezione lead single, stile artwork, concept artistico e moltiplicatore vendite.
- Impatto delle recensioni critiche (1.0 - 5.0 stelle) e dinamica di ripartizione incassi (Revenue Split) con la band.

### 3.4 Gestione Catalogo & Rielaborazione Bozze
- Ciclo di vita: `DRAFT` (Bozza) $\to$ `PRODUCED` (Master finito) $\to$ `RELEASED` (Pubblicato).
- Possibilità di riaprire, perfezionare e re-incidere bozze incomplete con nuove abilità o strumentazione migliore.

---

## 🛠️ 4. STRUTTURA DEL PIANO TECNICO DA REDIGERE (SOTTO-FASE 1A)

All'avvio della nuova chat, l'attività iniziale consisterà nella stesura del **Piano Tecnico Operativo Formale** in `docs/piani/attivi/PIANO_SEZIONE_2_CREATIVITA_MUSICALE_E_PRODUZIONE.md`, articolato nei seguenti **Named Contracts**:

- **Contratto D0 (Data Models & Constants)**:
  * Modello tematiche liriche (`LyricThemeData` o enum dedicato) con bonus/malus di affinità.
  * Nuovi tratti canzone ed estensione del modello `SongData`.
  * Costanti di bilanciamento tempi, costi ed energie per ciascuno stadio creativo.
- **Contratto D1 (Motore Logico MusicSystem & Formulas)**:
  * Integrazione del calcolo sinergie Tematica/Genere in `core/formulas.gd`.
  * Meccanica di perfezionamento bozze e assegnazione deterministica dei tratti speciali.
  * Influenza dell'hardware studio (`UpgradeData`) sulla fase di registrazione/missaggio.
- **Contratto D2 (Interfaccia SongCreator & SongCatalog Evoluti)**:
  * Aggiornamento della modale `SongCreator` (Tasto `N`) con selettore tematica lirica ad alto contrasto per NVDA.
  * Revisione del catalogo brani `SongCatalog` (Tasto `M`) con filtri per stato (Bozze / Prodotti / Pubblicati) e tasti rapidi numerici.
  * Modalità di compilazione Album `AlbumCreator` (Tasto `P`) con selezione traccia trainante.
- **Contratto D3 (Integrazione Macro-Area 2 nell'HUD)**:
  * Consolidamento tasti rapidi `N` (Nuovo Brano), `M` (Catalogo), `P` (Album) all'interno dell'Area 2 (Creazione & Produzione).
  * Allineamento etichette vocali AccessKit per navigazione Zero Mouse.
- **Contratto D4 (Suite di Test Headless a 0 ms)**:
  * Nuova suite dedicata `tests/test_advanced_crafting_system.gd` e `test_advanced_crafting_system.tscn`.
  * Copertura al 100% per: calcolo quality score, assegnazione tratti, verifica tematiche, transizioni di stato e salvataggio atomico JSON.
  * Suite di regressione sulle 20 suite esistenti.

---

## 📋 5. PROMPT PRONTO DA COPIARE PER LA NUOVA CHAT

Copia e incolla il seguente testo per avviare istantaneamente la nuova sessione:

```text
Ciao Antigravity! Riprendiamo il pair programming su World-tour.
Tutte le attività della Sezione 1 sono state completate, convalidate al 100% (266 test headless a 0 errori) e interamente archiviate (piani, strategie, report di sessione e registro revisioni allineati). Il working tree Git è pulito.

Oggi apriamo ufficialmente la SEZIONE 2 della Roadmap Modulare:
"Creatività Musicale, Scrittura Brani & Produzione Discografica"
(File di riferimento: docs/roadmap/02_creativita_musicale_scrittura_e_produzione.md).

Come da Regola 0 e governance ASTRALIS, procedi con la Sotto-Fase 1A:
1. Analizza la Sezione 2 e il file docs/report/REPORT_AVVIO_SESSIONE_SEZIONE_2.md.
2. Elabora il Piano Tecnico Formale (Contratti D0..D4, Validazione a 7 Assi e 3 Livelli di Simulazione) salvandolo in docs/piani/attivi/PIANO_SEZIONE_2_CREATIVITA_MUSICALE_E_PRODUZIONE.md.
3. Effettua lo Stop Obbligatorio della Sotto-Fase 1A per attendere la mia approvazione prima di toccare codice sorgente.

Presentami la sintesi del piano in formato lineare per NVDA.
```
