# Strategia & Modello Concettuale — Pacing del Songwriting, Limiti Quotidiani & Sviluppo Graduale Popomundo
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 26 Settembre 2026
# Percorso: docs/strategie/attive/STRATEGIA_PACING_SONGWRITING_E_CREATIVITA_POPOMUNDO.md
# Macro-Fase: Macro-Fase 2 (Revisione Sistemica Popomundo)
# Stato: [x] Consolidata e Pronta per Validazione Preventiva

---

## 🎯 1. VISIONE ARCHITETTURALE E OBIETTIVO DEL MODULO

Questo documento consolida la strategia architetturale e di game design per la **Macro-Fase 2** del progetto **World-tour**, finalizzata a:
1. Rallentare organicamente il loop di creazione delle canzoni, superando la logica dello spamming compulsivo e adottando il modello di maturazione graduale ispirato a **Popomundo**;
2. Trasformare la scrittura di un brano in un cantiere artigianale che accompagna l'artista per **4–7 giorni di gioco in-game**, richiedendo scelte ponderate, dedizione e cura;
3. Introdurre limiti fisiologici quotidiani e la meccanica dei **Rendimenti Marginali Decrescenti** per singolo brano, incentivando la gestione parallela dei **3 cantieri aperti nel cassetto**;
4. Integrare l'avanzamento del tempo virtuale nelle sessioni di scrittura eseguite da `SongCreator`, armonizzandole con il ciclo circadiano (Mattino, Pomeriggio, Sera, Notte);
5. Garantire la piena conformità al principio di **Simmetria Universale** e **Accessibilità Vocale Assoluta (Zero Mouse)** per lo screen reader **NVDA**.

---

## 🏛️ 2. ANALISI DELLE CAUSE RADICE (RCA) E MODELLO MENTALE

### Diagnosi del Sistema Precedente
- **Guadagno Eccessivo**: La formula originaria generava tra il 25% e il 35% di avanzamento per click, esaurendo una barra in sole 3 o 4 interazioni.
- **Assenza di Anti-Grinding sul Brano**: Il giocatore poteva premere consecutivamente i tasti `M` (Musica) e `T` (Testo) finché disponeva di energia, completando la scrittura in 30 secondi reali e a orologio virtuale fermo.
- **Svalutazione del Portfolio Bozze**: Il cap di 3 cantieri aperti in parallelo risultava privo di significato pratico, poiché ogni brano veniva concepito e chiuso istantaneamente prima di aprirne un altro.

### Il Modello Mentale Popomundo
Nella realtà di un compositore e nel modello di Popomundo:
- La mente creativa non può produrre melodie o versi memorabili all'infinito nello stesso giorno per lo stesso pezzo: subentra la saturazione di idee.
- Una canzone ha bisogno di "decantare": si compone una bozza al mattino, ci si torna sopra il giorno successivo con orecchie fresche, si riscrive il ritornello al terzo giorno.
- Quando un musicista ha ancora energia nella giornata, non accanisce sullo stesso brano saturo: apre il cassetto e lavora a un secondo progetto, oppure studia o fa prove con la band.

---

## ⚙️ 3. I TRE PILASTRI DELLA NUOVA PROGRESSIONE

### Pilastro 1 — Regola delle 2 Sessioni & Rendimenti Marginali Decrescenti
Ciascuna canzone traccia in modo autonomo il numero di sessioni giornaliere dedicate alla musica (`daily_music_sessions`) e al testo (`daily_lyrics_sessions`):

- **Prima Sessione Giornaliera (Concentrazione Piena)**:
  - *Condizione*: `daily_sessions == 0`;
  - *Resa*: **100% del guadagno calcolato**;
  - *Consumo*: Risorse standard (Musica: 15 Energia, +4 Stress; Testo: 10 Energia, +3 Stress);
  - *Feedback NVDA*: *"Sessione completata con ottima concentrazione artistica!"*

- **Seconda Sessione Giornaliera (Fatica Creativa)**:
  - *Condizione*: `daily_sessions == 1`;
  - *Resa*: **50% del guadagno calcolato** (rendimento marginale dimezzato);
  - *Consumo*: Risorse standard con stress incrementato del 50% (Musica: 15 Energia, +6 Stress; Testo: 10 Energia, +5 Stress);
  - *Feedback NVDA*: *"Seconda sessione della giornata: senti la fatica accumularsi, ma riesci a rifinire qualche passaggio (+50% resa)."*

- **Terza Sessione o Superiore (Saturazione d'Autore / Blocco per Oggi)**:
  - *Condizione*: `daily_sessions >= 2`;
  - *Resa*: **0% — Azione Rifiutata a Costo Zero**;
  - *Consumo*: **0 Energia, 0 Stress**;
  - *Feedback NVDA*: *"Hai dato il massimo su questo brano per oggi! Lascia decantare le idee fino a domani o dedicati ad un altro cantiere aperto."*

---

### Pilastro 2 — Ricalibrazione Formule di Avanzamento e Tempi di Maturazione

1. **Riformulazione del Guadagno Base**:
   - `base_gain` ridotta da `15.0%` a **`8.0%`**;
   - Bonus abilità: `+(livello_competenza * 0.20%)` (da 0 a +20%);
   - Bonus attributo innato: `+(attributo * 0.10%)` (da +1% a +10%);
   - Bonus affinità lirica (solo testo): da `-1.5%` a `+3.5%`;
   - Slancio Punti Ispirazione investiti: `+(ispirazione_spesa * 5%)` su sessione 1;
   - Se in Burnout Creativo ("Sindrome del Foglio Bianco"): guadagno moltiplicato per `0.70x`.

2. **Dinamica Temporale di Completamento**:
   - Resa Sessione 1 (Fresco): **`12% – 16%`** di avanzamento;
   - Resa Sessione 2 (Stanco): **`6% – 8%`** di avanzamento;
   - Massimo avanzamento giornaliero possibile per barra: circa **`18% – 24%`**;
   - Tempo minimo per portare una barra al 100%: **4–5 giorni virtuali** di lavoro costante a pieno regime;
   - Tempo medio complessivo (Musica + Testo + Finestra Arancione 36h): **`5 – 7 giorni virtuali`**.

---

### Pilastro 3 — Avanzamento Temporale Virtuale & Reset Circadiano

1. **Scorrimento dell'Orologio da Studio (`SongCreator`)**:
   - Ciascuna sessione di composizione musicale consuma **2 ore virtuali** (7200s virtuali calcolati su `day_duration` di `TimeSystem`);
   - Ciascuna sessione di scrittura testi consuma **1.5 ore virtuali** (5400s virtuali);
   - In questo modo comporre non avviene in un limbo atemporale, ma fa progredire il sole e le fasce orarie.

2. **Reset Notturno Deterministico**:
   - Al sopraggiungere dell'alba o al completamento del sonno (`CalendarData.reset_daily_saturation()` / `EndDaySystem`), tutte le canzoni nel catalogo del giocatore azzerano i contatori `daily_music_sessions = 0` e `daily_lyrics_sessions = 0`;
   - Serializzazione atomica su salvataggio JSON (`to_dict()` e `from_dict()`).

---

## 🎧 4. ERGONOMIA VOCALE PER NVDA & ZERO MOUSE

1. **Indicatore Parlante nella Lista Cantieri Aperti (Scheda 1)**:
   - Ogni bottone di bozza nella lista descrive sinteticamente disponibilità e stato:
     - *"Bozza 1: 'Rebel Heart' — Musica: 35% (Sessioni oggi: 0/2, Resa Piena), Testo: 28% (Sessioni oggi: 1/2, Resa 50%)."*
     - Se satura: *"Musica: 55% (Satura per oggi — Riprendi domani)."*
2. **Pulsanti Azione M e T Parlanti**:
   - Il tooltip e l'annuncio dei pulsanti `BtnDraftMusic` (`M`) e `BtnDraftLyrics` (`T`) riflettono la resa attuale:
     - Prima sessione: *"Componi Musica (Tasto M) — Resa piena 100%, 15 Energia, 2 ore."*
     - Seconda sessione: *"Componi Musica (Tasto M) — Seconda sessione (Resa 50%, Stress +50%), 15 Energia, 2 ore."*
     - Satura: *"Componi Musica (Tasto M) — Satura per oggi. Dedicati ad un altro brano."*
3. **Guardia Anti-Spreco**:
   - Nessuna spesa di risorse in caso di azione bloccata.

---

## 📋 5. SCOMPOSIZIONE NEI NAMED CONTRACTS (FASE 1A)

- **Contratto D0**: Modello `SongData` con `daily_music_sessions`, `daily_lyrics_sessions`, helper `can_work_music_today()`, `can_work_lyrics_today()` e serializzazione;
- **Contratto D1**: Ricalibrazione formule `work_on_music_progress` e `work_on_lyrics_progress` in `MusicSystem` con rendimenti decrescenti al 50% e blocco a 2 sessioni;
- **Contratto D2**: Integrazione avanzamento tempo virtuale (1.5h / 2h) in `MusicSystem` e collegamento con `TimeSystem`;
- **Contratto D3**: Reset giornaliero in `CalendarData` / `EndDaySystem` e allineamento azioni Loft (`ApartmentInteractions`);
- **Contratto D4**: UI `SongCreator` (Scheda 1) con annunci parlanti dello stato sessioni e disabilitazione visiva/vocale dei pulsanti saturi;
- **Contratto D5**: Blindatura headless con test suite a 0 ms e avanzamento AVF a `V5.10.0`.
