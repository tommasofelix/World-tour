# Strategia & Modello Concettuale — Sezione 1: Identità, Routine Quotidiana & Risorse Vitali
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-23
# Percorso: docs/strategie/archiviate/STRATEGIA_SEZIONE_1_IDENTITA_ROUTINE_NOTTE_RISORSE.md
# Stato: [x] Convalidata ed Archiviata

---

## 1. VISIONE ARCHITETTURALE E OBIETTIVO DEL MODULO

La Sezione 1 della Roadmap di **World-tour** definisce i pilastri fondamentali della simulazione di vita del musicista, garantendo al contempo:
1. Una forte immedesimazione narrativa e artistica del protagonista fin dal primo avvio.
2. Un ritmo di gioco (*pacing*) fluido, privo di blocchi o pop-up punitivi, dove il tempo virtuale scorre in armonia con le scelte strategiche del giocatore.
3. Un modello fisiologico coerente a tre dimensioni (Energia, Stress, Morale) dotato sia di soglie di allarme e crisi (Burnout, Panico, Blocco Creativo) sia di strumenti attivi di de-escalation e recupero diurno.
4. Piena conformità al principio di **Simmetria Universale**: interfaccia visiva moderna ad alto contrasto per vedenti e fruibilità completa da tastiera (**Zero Mouse**) con vocalizzazione riga per riga per lo screen reader **NVDA**.

---

## 2. COMPONENTE 1: IDENTITÀ & CREAZIONE GUIDATA DEL PERSONAGGIO (SEZ. 1.1)

### Modello di Naming Duale & Anagrafica
- **Nome Anagrafico (`player_name`)**: Identità reale della persona (utilizzata nei contratti, nei rapporti bancari e burocratici).
- **Nome d'Arte Facoltativo (`stage_name`)**: Alias scenico (utilizzato nei crediti dei brani, copertine album, rassegna stampa e festival).
- **Metodo `get_effective_name()`**: Se lo stage name è valorizzato viene utilizzato per la ribalta pubblica, altrimenti ripiega armoniosamente sul nome anagrafico.
- **Età Anagrafica (`age`)**: Valore compreso tra 16 e 60 anni (influenza lo stile narrativo e le opzioni future).

### I 6 Strumenti Musicali Primari
1. Chitarra Elettrica (Ritmica/Solista)
2. Chitarra Acustica
3. Basso Elettrico
4. Batteria & Percussioni
5. Tastiere & Sintetizzatori
6. Voce Principale / Frontman

### I 5 Background di Provenienza
- **Autodidatta**: +50 € saldo iniziale, Livello 12 Strumento.
- **Conservatorio**: +30 € saldo iniziale, Livello 14 Composizione, Livello 12 Strumento.
- **Busker di Strada**: +25 € saldo iniziale, Livello 14 Presenza Scenica, Livello 12 Carisma.
- **Punk Ribelle**: +20 € saldo iniziale, Livello 15 Presenza Scenica.
- **Producer / Bedroom Artist**: +40 € saldo iniziale, Livello 15 Produzione, Livello 12 Composizione.

### I 5 Tratti Caratteriali Distintivi
- **Carismatico**: Incremento naturale dell'ingaggio fan e della presenza scenica.
- **Perfezionista**: Bonus qualità sui brani, ma maggiore accumulo di stress in sessione.
- **Animale da Palco**: Performance esplosive nei concerti live e resistenza allo stress live.
- **Insonne**: Consumo energetico ridotto durante la notte, ma recupero del sonno più lento.
- **Resiliente**: Maggiore tolleranza allo stress e de-escalation accelerata.

### Biforcazione nel Main Menu
- **Nuova Partita**: Apre la schermata di creazione guidata (`ui/character_creation/character_creation.tscn`).
- **Modalità Test / Avvio Rapido**: Istanzia direttamente il profilo preconfigurato (Alex, 20 anni, Autodidatta, Carismatico, 500 € di saldo e 10 canzoni pronte per il collaudo immediato dei sistemi).

---

## 3. COMPONENTE 2: FILOSOFIA DELLA NOTTE & OVERTIME PROGRESSIVO (SEZ. 1.2)

### La Scala Oraria a 22 Ore Virtuali (06:00 – 04:00)
- Il ciclo giornaliero non termina a mezzanotte (00:00), ma si estende fino alle 04:00 del mattino seguente, riflettendo la reale vita notturna del musicista.
- **Suddivisione in 4 Fasce Orarie**:
  * Mattina (06:00 – 12:00)
  * Pomeriggio (12:00 – 18:00)
  * Sera (18:00 – 00:00)
  * Notte / Overtime (00:00 – 04:00)

### Eliminazione dei Pop-up Bloccanti a Mezzanotte
- A mezzanotte (00:00) il gioco **non interrompe mai l'azione con pop-up o finestre modali**.
- Il tempo prosegue in modo fluido e silenzioso, concedendo al giocatore piena facoltà di continuare a suonare, scrivere o viaggiare.

### Overtime Progressivo Non Forfettario
Lo stress notturno si accumula in modo esponenziale per ogni ora trascorsa svegli:
- Ore 00:00: +2 Stress.
- Ore 01:00: +3 Stress (totale 5).
- Ore 02:00: +5 Stress (totale 10). Primo **Avviso Discreto Vocale NVDA**: *"Ore 02:00 di notte. Puoi andare a dormire (tasto Z) o proseguire le tue attività."*
- Ore 03:00: +10 Stress (totale 20). Secondo **Avviso Discreto Vocale NVDA**: *"Attenzione: sono le 03:00. La giornata terminerà alle 04:00."*
- Ore 04:00: Chiusura forzata automatica della giornata e transizione al riepilogo notturno.

### Controlli di Navigazione Temporale Rapida
- **Aspetta (Tasto Rapido `X`)**: Salta direttamente all'inizio della fascia oraria successiva (Mattina $\to$ Pomeriggio $\to$ Sera $\to$ Notte). In fascia Notte la funzione è inibita per evitare salti involontari alla giornata successiva.
- **Dormi / Riposo Anticipato (Tasto Rapido `Z`)**: Consente di andare a dormire prima delle 04:00:
  * A letto prima di mezzanotte: **Bonus Riposo Ristoratore** (+15 Energia extra, -10 Stress extra).
  * A letto prima delle 02:00: Bonus Riposo (+10 Energia extra, -5 Stress extra).

---

## 4. COMPONENTE 3: TRIADE RISORSE VITALI & RECUPERO ATTIVO (SEZ. 1.3)

### La Triade Fisiologica
1. **Energia (`[0, 100]`)**: Risorsa fisica essenziale per svolgere qualsiasi azione.
   - *Soglia di Burnout Fisico (< 15%)*:
     * Le azioni ordinarie raddoppiano il tempo di esecuzione (`duration * 2.0`).
     * Avviso vocale NVDA per segnalare lo stato di spossatezza estrema.
     * **Regola di Esenzione**: Le azioni di recupero attivo mantengono la durata nominale per permettere al musicista di curarsi e spezzare la spirale di crisi.
2. **Stress (`[0, 100]`)**: Carico mentale e ansia accumulata.
   - *Soglia di Panico ($\ge$ 80%)*:
     * Allarme vocale preventivo per NVDA.
     * Necessità di de-escalation rapida per evitare il crollo nelle performance live e creative.
3. **Morale (`[0, 100]`)**: Entusiasmo e motivazione artistica.
   - *Soglia di Blocco Creativo (< 20%)*: Penalità severe sulla qualità compositiva dei brani.

### Sistema di Recupero Attivo Diurno (`RelaxModal` — Tasto Rapido `R`)
Permette scelte tattiche immediate durante il giorno senza dover forzare il sonno notturno:
1. **Bevi un Caffè al Bar (Tasto `1`)**:
   - Costo: 2.00 € (verifica preventiva saldo obbligatoria).
   - Benefici: +15 Energia, a fronte di +5 Stress.
   - Durata: 5 secondi virtuali.
2. **Passeggiata Rilassante al Parco (Tasto `2`)**:
   - Costo: Gratuito (0.00 €).
   - Benefici: -15 Stress, +5 Morale, consumo minimo -5 Energia.
   - Durata: 10 secondi virtuali.
3. **Ascolta un Disco Capolavoro (Tasto `3`)**:
   - Costo: Gratuito (0.00 €).
   - Benefici: +20 Morale, -10 Stress.
   - **Meccanica Scintilla Creativa**: 35% di probabilità di trarre ispirazione, conferendo +15 XP in Scrittura testi con annuncio sonoro/vocale dedicato.
   - Durata: 12 secondi virtuali.

---

## 5. TEST & EVIDENZA EMPIRICA

- **Suite di Test Dedicate**:
  * `test_character_creation.tscn`: 39/39 asserzioni OK.
  * `test_time_night_system.tscn`: 28/28 asserzioni OK.
  * `test_vital_resources_system.tscn`: 37/37 asserzioni OK.
- **Suite di Regressione**:
  * `test_vertical_slice.tscn`: 65/65 asserzioni OK.
  * `test_v5_ui_overhaul.tscn`: 67/67 asserzioni OK.
  * `test_localization.tscn`: 30/30 asserzioni OK.
- **Esito Complessivo**: 266 test su 266 superati al 100% in modalità headless CLI.
