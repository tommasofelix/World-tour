# Sottopiano 02 — Simulazione Vita, Gestione Tempo e Routine

- ID Sottopiano: `SP-02`
- Versione: 1.1 — Ottimizzata per Gameplay, Architettura Tecnica e UI Godot 4
- Tema: Orologio di Gioco, Fasce Orarie, Triade Risorse, Meccanica Overtime, Nodi Location e Controllo Accessibile
- Competenze di riferimento: Core Mechanics, Life Simulation, Ergonomia & Pacing, Systems Architecture
- Documento sorgente: [`docs/piani/attivi/World Tour .md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/World%20Tour%20.md) (Righe 168–978, 1161–1796, 2630–3173, 3590–4223, 4814–5052, 6892–7165)
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md)

---

## 1. OBIETTIVO DEL SISTEMA TEMPORALE E VITALE

Il tempo è la risorsa centrale ed esauribile di World-tour. La gestione della routine quotidiana simula con realismo la vita del musicista: bilanciare la spinta artistica (studio, composizione, prove) con i bisogni biologici (energia, sonno, stress) e i vincoli materiali (lavoro di sostentamento, spostamenti urbani).

---

## 2. REGOLE DEL SISTEMA TEMPORALE & FASCE ORARIE

### 2.1 Struttura della Giornata (I 600 Secondi Simulati)
Una giornata attiva è composta da **600 secondi simulati** (convenzionalmente dalle 08:00 alle 24:00), suddivisi in 4 Fasce Orarie con impatto tematico e contestuale:

| Fascia Oraria | Orario Simulato | Secondi Corrispondenti | Attività Consigliate e Caratteristiche |
| :--- | :--- | :--- | :--- |
| **Mattina (`MORNING`)** | 08:00 – 12:00 | 600s $\rightarrow$ 450s | Mente fresca: studio tecnico dello strumento, composizione, commissioni diurne. |
| **Pomeriggio (`AFTERNOON`)** | 12:00 – 17:00 | 450s $\rightarrow$ 260s | Lavoro ordinario di sussistenza, sessioni in studio di registrazione, spostamenti. |
| **Sera (`EVENING`)** | 17:00 – 21:00 | 260s $\rightarrow$ 110s | Prove con la band, soundcheck, networking nei pub e aperitivi musicali. |
| **Notte (`NIGHT`)** | 21:00 – 24:00 | 110s $\rightarrow$ 0s | Concerti dal vivo sul palco, nightlife/feste oppure riposo tempestivo a casa. |

---

## 3. MACCHINA A STATI TEMPORALE & CONTROLLI

### 3.1 Gli Stati Temporali del Gioco
1. **Stato `IDLE` (In Attesa / Navigazione)**:
   - Il personaggio è fermo nel luogo corrente.
   - Non vengono consumati punti energia straordinari.
   - Il giocatore naviga liberamente i menu, consulta statistiche e sceglie la prossima azione.
2. **Stato `BUSY` (Azione in Corso)**:
   - Viene avviata un'attività con durata nota (es. Allenamento 15s, Viaggio in bus 40s, Concerto 90s).
   - Barra di avanzamento attiva a schermo; tempo di gioco che scala in base alla velocità scelta.
   - Possibilità di interruzione volontaria con il tasto `Escape` (con rimborso pro-quota di risorse e ricompensa XP parziale).
   - Durante l'azione possono verificarsi micro-eventi procedurali (pensieri del personaggio, incontri casuali).
3. **Stato `PAUSED` (Pausa di Gioco)**:
   - Sfrutta il sistema nativo di Godot `get_tree().paused = true`.
   - Tutti i timer del mondo sono congelati a zero decremento.
   - Tutti i nodi dell'interfaccia (`UI`) rimangono attivi e navigabili al 100% grazie a `ProcessMode = Node.PROCESS_MODE_ALWAYS`.

### 3.2 Pausa Dinamica Automatica (Accessibilità & Comfort)
- **Pausa Automatica nei Menu**: All'apertura di qualsiasi finestra modale o pannello di consultazione (scheda personaggio, catalogo canzoni, selezione locale, popup evento), la simulazione temporale si mette automaticamente in pausa. Questo garantisce a Luca piena libertà di ascoltare la sintesi vocale NVDA senza perdere preziosi secondi della giornata.
- **Selettore Manuale di Velocità**:
  - `Pausa` (Tasto `Spazio` o `P`): arresto immediato.
  - `Play 1x` (Tasto `1`): 1 secondo reale = 1 secondo di gioco.
  - `Fast 2x` (Tasto `2`): simulazione accelerata per allenamenti medi.
  - `Ultra 5x` (Tasto `3`): avanzamento ultra-rapido per viaggi e sonno.
- **Meccanica "Passa Tempo" (`PASS TIME`)**: Tasto rapido `T` per saltare istantaneamente blocchi di tempo (+15s, +30s, +60s o direttamente fino all'inizio della serata).

---

## 4. IL DILEMMA DEGLI STRAORDINARI NOTTURNI (`OVERTIME / NIGHT OWL`)

Cosa accade alle 24:00 (timer a zero)? Il giocatore è posto davanti a una scelta strategica vitale:
1. **Opzione A — Riposo Standard a Casa**:
   - La giornata termina normalmente.
   - Recupero energetico pieno (+70 punti), abbattimento naturale dello stress (-15 punti).
   - Risveglio l'indomani alle 08:00 con timer pieno (600s).
2. **Opzione B — Fare le Ore Piccole / Notte in Bianco (`Overtime`)**:
   - Il giocatore sceglie di rimanere sveglio fino alle 04:00 per completare una canzone o festeggiare dopo un concerto trionfale.
   - Ottiene un bonus di **120 secondi simulati extra**.
   - *Prezzo fisiologico*: L'indomani il risveglio avviene alle 12:00 (si salta tutta la Mattina, timer iniziale ridotto a 450s), con recupero energetico dimezzato (+35 punti) e accumulo di stress (+20 punti).

---

## 5. LA TRIADE DELLE RISORSE & STATI CRITICI

1. **Energia Vitale (`energy`: 0–100)**:
   - Consumata da ogni azione fisica, viaggio e concerto.
   - *Soglia Critica (< 20)*: Efficienza dimezzata; rischio raddoppiato di stecche nei concerti; compare audio cue di affanno respiratorio.
   - *Collasso a Zero*: Se l'energia tocca 0, il personaggio sviene. Trasporto forzato a casa in taxi (€30 di spesa), perdita della serata e penalità di morale.
2. **Livello di Stress (`stress`: 0–100)**:
   - Aumenta con il superlavoro, il traffico, i debiti economici e i fischi ai concerti.
   - Ridotto da relax a casa, uscite con amici, sonno e hobby.
   - *Soglia di Rischio (> 75)*: Blocco creativo totale (impossibile comporre nuove canzoni).
3. **Livello di Morale (`morale`: 0–100)**:
   - Riflette l'autostima e la carica artistica.
   - Aumenta con concerti riusciti, complimenti dei fan, progressi musicali e recensioni positive.
   - Agisce come moltiplicatore universale di efficienza su tutte le attività.

---

## 6. SISTEMA DEI TRASPORTI & LOCATION URBANE

La città è modellata come un grafo di nodi connessi. Viaggiare da un nodo all'altro richiede di scegliere tra **Tempo**, **Denaro** ed **Energia**:

| Mezzo di Trasporto | Costo Monetario | Tempo di Viaggio | Consumo Energia | Affidabilità / Note |
| :--- | :--- | :--- | :--- | :--- |
| **A Piedi** | €0 | Elevato (90–120s) | -15 Energia | 100% affidabile; zero rischi di traffico. |
| **Bicicletta** | €0 (richiede acquisto bici) | Medio (60–80s) | -10 Energia | Più rapido; richiede possesso della bici. |
| **Autobus Pubblico** | €2.00 | Medio-Basso (40–55s) | -3 Energia | Economico; possibile traffico nelle ore di punta. |
| **Taxi** | Elevato (€20–€40) | Minimo (15–25s) | -0 Energia | Salva-tempo assoluto per chi ha budget. |
| **Auto Privata** | Carburante + usura | Minimo (15–20s) | -2 Energia | Massima indipendenza (sbloccabile a T3/T4). |

### Nodi Geografici della Città (V1.0)
- `Casa / Appartamento`: Riposo gratuito, allenamento chitarra acustica a basso volume, composizione testi.
- `Centro Urbano`: Negozi di dischi e strumenti, bar diurni per networking.
- `Sala Prove & Studio`: Affitto orario per incidere brani con strumentazione di qualità.
- `Club & Locali Live`: Garage periferico, Bar di quartiere e Club serale per i concerti.

---

## 7. DESIGN VISIVO IN GODOT 4 & ACCESSIBILITÀ UNIVERSALE

### 7.1 Per Holy Diver (Grafica HUD & Controlli Godot 4)
- **Scena HUD Principale (`res://ui/hud/hud.tscn`)**:
  - `TopBar`: Barra superiore scura con bordo luminoso contenente orologio digitale elegante (`15:42`) e indicatore grafico del giorno (`GIORNO 12`).
  - `TimeOfDayIcon`: Icona SVG dinamica che transiziona tra Sole radioso (Mattina), Sole caldo (Pomeriggio), Tramonto aranciato (Sera) e Luna con stelle (Notte).
  - `ResourceGauges`: Tre `TextureProgressBar` affiancate con gradienti morbidi:
    - Energia (Verde smeraldo / Giallo oro).
    - Stress (Arancio / Rosso pulsante quando critico).
    - Morale (Azzurro cielo / Blu notte).
  - `ActionProgressBanner`: Notifica fluttuante al centro dello schermo durante le azioni `BUSY`, con barra di avanzamento e pulsante grafico `[Annulla]`.
  - `SpeedControls`: Gruppo di 4 pulsanti stilizzati (`[||]`, `[>]`, `[>>]`, `[>>>]`) con stati hover/pressed definiti nel tema.

### 7.2 Per Luca (Accessibilità Vocale & Comandi Tastiera NVDA)
- **Scorciatoie Globali Immediate**:
  - `Spazio` o `P`: Attivazione/Disattivazione Pausa. Annuncio NVDA immediato: `"Pausa"` o `"Play 1x"`.
  - `1`, `2`, `3`: Cambio velocità simulazione a 1x, 2x, 5x.
  - `T`: Annuncio dell'ora e della fascia:  
    `"Ore 16:20, Pomeriggio. Rimangono 3 minuti e 10 secondi alla fine della giornata."`
  - `R`: Annuncio rapido delle risorse vitali:  
    `"Energia: 80%. Stress: 25%. Morale: 70%. Cassa: €350."`
  - `Escape`: Interruzione dell'azione in corso con dialogo accessibile di conferma.
- **Segnali Sonori Protetti**:
  - Tocco discreto ad ogni cambio fascia oraria (da Mattina a Pomeriggio, ecc.).
  - Respiro affannoso in sottofondo se l'energia scende sotto il 15%.
  - Volumi congelati a 0.75f con ducking automatico all'attivazione della voce.

---

## 8. CHECKPOINT DI CONFORMITÀ (GATING)

- [ ] `SP-02.1`: Implementazione del `TimeSystem` con orologio a 600s e mappatura delle 4 fasce orarie.
- [ ] `SP-02.2`: Macchina a stati `IDLE` / `BUSY` / `PAUSED` con transizioni pulite ed EventBus.
- [ ] `SP-02.3`: Pausa Dinamica automatica verificata all'apertura di ogni finestra modale (test NVDA).
- [ ] `SP-02.4`: Meccanismo di Overtime notturno (ore piccole) funzionante con penalità il giorno seguente.
- [ ] `SP-02.5`: Scena HUD di Godot 4 creata con le barre delle risorse e i controlli temporali per Holy Diver.
- [ ] `SP-02.6`: Shortcut `Spazio`, `1-3`, `T`, `R`, `Esc` collaudate con screen reader attivo.
