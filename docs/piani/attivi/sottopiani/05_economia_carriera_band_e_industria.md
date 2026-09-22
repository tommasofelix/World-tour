# Sottopiano 05 — Economia, Carriera, Band e Industria

- ID Sottopiano: `SP-05`
- Versione: 1.1 — Ottimizzata per Gameplay, Architettura Tecnica e UI Godot 4
- Tema: Modello Economico, Lavoro di Sussistenza, Sblocco dell'Autonomia, Dinamiche di Band e Contratti Discografici
- Competenze di riferimento: Economy Simulation, Social Systems, Narrative Events, Systems Engineering
- Documento sorgente: [`docs/piani/attivi/World Tour .md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/World%20Tour%20.md) (Righe 1824–1903, 1955–2008, 2112–2266, 2775–2886, 4511–4568, 5371–5458, 6355–6410, 7507–7633, 8571–8640)
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md)

---

## 1. OBIETTIVO DEL SISTEMA ECONOMICO E PROFESSIONALE

Rappresentare il percorso realistico del musicista che deve far quadrare il bilancio quotidiano: lavorare per pagare le bollette e gli strumenti, decidere quando rischiare e fare il salto nel vuoto verso il professionismo, gestire i compagni di band e negoziare contratti con case discografiche indipendenti o multinazionali.

---

## 2. FLUSSI ECONOMICI & LAVORO DI SUSSISTENZA (FASE INIZIALE)

A inizio carriera la sola musica non copre l'affitto e il cibo. Il giocatore deve bilanciare il tempo tra lavoro ordinario e passione musicale:

### 2.1 I Lavori Ordinari di Sostentamento (T1–T3)
- **Cameriere Serale**: Paga €45/giorno | Consuma 180s (fascia Pomeriggio/Sera) | -25 Energia, +10 Stress. Limita le serate disponibili per i concerti.
- **Commesso Part-time**: Paga €55/giorno | Consuma 160s (fascia Mattina/Pomeriggio) | -20 Energia, +5 Stress. Lascia le serate libere per suonare.
- **Magazziniere**: Paga €70/giorno | Consuma 200s | -35 Energia, +15 Stress. Ottimo stipendio ma forte logorio fisico.

### 2.2 Il Momento del Salto nel Vuoto (`The Leap`)
Quando i ricavi dei concerti e dei primi singoli superano la soglia critica (€30–€40 al giorno stabili), il giocatore può compiere la scelta epica: **licenziarsi dal lavoro ordinario**. Si liberano 200 secondi al giorno per provare e comporre, ma ogni mese le spese fisse continuano a bussare alla porta.

---

## 3. DINAMICHE RELAZIONALI DELLA BAND (V2+)

La musica d'insieme moltiplica la potenza sonora ma introduce complessità umane:
1. **Reclutamento dei Membri**: Incontri nei club, audizioni in sala prove o annunci online.
2. **Indicatori della Band**:
   - **Affinità Personale (0–100)**: Simpatia e chimica umana tra i componenti.
   - **Rispetto Musicale (0–100)**: Riconoscimento della bravura e della leadership del protagonista.
   - **Tensione Interna (0–100)**: Cresce con tour estenuanti, divisione iniqua degli incassi o liti artistiche sulla scaletta. Se supera quota 85, un membro può abbandonare il gruppo a metà tournée.
3. **Divisione degli Incassi (`Revenue Split`)**: Il protagonista decide come ripartire i compensi dei live (es. 50% al leader e 50% al resto del gruppo, o divisione paritaria al 25% ciascuno).

---

## 4. L'INDUSTRIA DISCOGRAFICA & LE ETICHETTE (V3+)

Quando l'artista raggiunge lo status di Artista Nazionale (T5), si presentano offerte discografiche strutturate:

### 4.1 Etichetta Indipendente (`Indie Label`)
- **Anticipo Modesto**: €5.000–€20.000.
- **Royalty Equa**: 40%–50% sul venduto e sullo streaming.
- **Libertà Artistica**: 100% (nessun vincolo sui generi o sui testi).
- **Supporto**: Distribuzione nei negozi specializzati e stampa vinili per i puristi.

### 4.2 Major Discografica (`Major Label`)
- **Anticipo Massiccio**: €100.000–€500.000 (fondi per grandi studi, producer di fama e videoclip).
- **Royalty Ridotta**: 12%–18% con clausola di recupero integrale degli anticipi (`Recoupment`).
- **Pressione Commerciale**: Obbligo di consegnare almeno due singoli da classifica approvati dai direttori artistici (A&R). Rischio di cancellazione del disco se i singoli falliscono.

---

## 5. DESIGN VISIVO IN GODOT 4 & ACCESSIBILITÀ UNIVERSALE

### 5.1 Per Holy Diver (Grafica & UI Godot 4)
- **Scena Bilancio & Banca (`res://ui/economy/economy_bank.tscn`)**:
  - Grafico a barre moderno con entrate mensili (Verde acido) e spese fisse (Rosso rubino).
  - Cassa centrale in grande evidenza (`€ 1.450,00`) con animazione di conteggio fluido e icone delle transazioni.
  - Registro storico delle transazioni a scorrimento con categorie (`Live`, `Studio`, `Affitto`, `Cibo`, `Lavoro`).
- **Scena Gestione Band (`res://ui/band/band_hub.tscn`)**:
  - Schede dei compagni con ritratti stilizzati, barre di Affinità e Tensione con colori dinamici, e micro-fumetti di stato (es. *"Stasera spacchiamo!"*, *"Dovremmo provare di più quel ritornello"*).

### 5.2 Per Luca (Accessibilità Vocale & Comandi Tastiera NVDA)
- **Comandi Rapidi da Tastiera**:
  - Tasto rapido `B`: Annuncio vocale istantaneo del bilancio e dell'autonomia economica residua:  
    `"Saldo attuale: €520. Entrate oggi: €180. Spese fisse previste a mezzanotte: €25. Autonomia economica stimata: 20 giorni."`
  - Tasto rapido `G`: Annuncio stato della band:  
    `"Band attiva: 4 membri. Chimica generale: 78%. Livello di tensione: Basso (15%). Prossima prova in calendario: Domani ore 18:00."`
  - Finestra di firma contratti: Lettura riga per riga di anticipo, percentuale royalty e obblighi contrattuali con conferma esplicita tramite tasto `Invio`.

---

## 6. CHECKPOINT DI CONFORMITÀ (GATING)

- [ ] `SP-05.1`: Modulo `EconomySystem` con gestione saldo, spese fisse notturne e log transazioni.
- [ ] `SP-05.2`: Sistema di lavoro ordinario funzionante con consumo di tempo ed energia.
- [ ] `SP-05.3`: Meccanismo del "Salto nel vuoto" (licenziamento dal lavoro e passaggio alla musica a tempo pieno).
- [ ] `SP-05.4`: Struttura dati per membri della band e contratti discografici pronta per la V2.
- [ ] `SP-05.5`: Scena bilancio realizzata in Godot per Holy Diver e collaudata con shortcut `B` per Luca.
