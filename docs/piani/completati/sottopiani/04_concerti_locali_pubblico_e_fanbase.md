# Sottopiano 04 — Concerti, Locali, Pubblico e Fanbase

- ID Sottopiano: `SP-04`
- Versione: 1.1 — Ottimizzata per Gameplay, Architettura Tecnica e UI Godot 4
- Tema: Meccanica dei Live Show, Tattica della Scaletta, Imprevisti sul Palco, Tipologie di Locali e Fidelizzazione del Pubblico
- Competenze di riferimento: Live Events Design, PR & Audience Simulation, Systems Engineering
- Documento sorgente: [`docs/piani/attivi/World Tour .md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/World%20Tour%20.md) (Righe 1904–2048, 4393–4510, 5247–5370, 6169–6354, 7393–7506, 8443–8570)
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md)

---

## 1. OBIETTIVO DEL SISTEMA LIVE

I concerti rappresentano il culmine dinamico della carriera musicale. È sul palco che la musica prende vita, le canzoni affrontano il giudizio diretto della folla e il passaparola trasforma un musicista sconosciuto in una realtà acclamata sul territorio.

---

## 2. GERARCHIA DEI LOCALI (VENUE DI PARTENZA)

Ogni locale impone un costo d'affitto, una capienza massima e un profilo specifico di pubblico:

| Locale | Tipo & Atmosfera | Capienza | Costo Affitto | Popolarità Richiesta | Reazione del Pubblico |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Garage / Sala Prove** | Familiare / Grezzo | 15 persone | €0 | 0% | Amici e conoscenti: applausi facili, zero incassi. |
| **Pub / Birreria Locale** | Caotico / Rumoroso | 60 persone | €50 (o quota bar) | 5% | Avventori distratti: occorre carisma per zittire il bar. |
| **Piccolo Club Live** | Underground / Intenso | 180 persone | €250 | 20% | Appassionati di musica: ascolto attento, alta conversione fan. |
| **Club di Tendenza** | Prestigioso / Esigente | 450 persone | €700 | 40% | Critici e addetti ai lavori: trampolino per la scena nazionale. |

---

## 3. PREPARAZIONE TATTICA DELLO SHOW

Il successo della serata non è affidato al caso, ma a scelte strategiche pregresse:

### 3.1 La Tattica della Scaletta (`Setlist Strategy`)
L'ordine di esecuzione delle canzoni incide sul punteggio finale del concerto:
- **Brano d'Apertura (`Opener`)**: Richiede alta Energia e Melodia per catturare subito l'attenzione ed eccitare la folla.
- **Corpo Centrale (`Mid-Set`)**: Spazio per ballate, brani complessi o nuove canzoni in fase di collaudo.
- **Brano di Chiusura (`Closer / Bis`)**: Se si posiziona un pezzo con il tratto speciale `Stage Beast` o la canzone più famosa del catalogo, si attiva un bonus del +15% sul Concert Score complessivo.

### 3.2 La Fase del Soundcheck (Opzionale)
Nel tardo pomeriggio (18:00–19:30), il giocatore può scegliere se eseguire il soundcheck:
- *Eseguire il Soundcheck* (consuma 25s di tempo e 15 energia): Azzeramento dei rischi di problemi all'impianto audio durante la serata e +5% all'acustica.
- *Saltare il Soundcheck*: Si risparmia tempo ed energia, ma si rischiano fischi o ritardi all'inizio del live.

---

## 4. DINAMICHE LIVE & IMPREVISTI SUL PALCO (`STAGE EVENTS`)

Durante l'esecuzione dello show possono verificarsi eventi imprevisti che mettono alla prova i riflessi e il carisma dell'artista:
- **Corda della Chitarra Spezzata**:
  - *Scelta 1*: Continua a cantare a cappella con il pubblico (Test su `Charisma`).
  - *Scelta 2*: Cambio strumento fulmineo dietro le quinte (Test su `Performance`).
- **Problemi all'Impianto Audio (Fischio nei Monitor)**:
  - Gestire la situazione con ironia o fermare il pezzo per farlo ripartire più potente.
- **Fan Entusiasta che Sale sul Palco**:
  - Abbracciarlo e condividere il ritornello (+Fan, +Popolarità) oppure allontanarlo per sicurezza.

---

## 5. RISOLUZIONE DELLO SHOW & ECONOMIA DELLA SERATA

Al termine dell'esibizione, il motore di gioco risolve matematicamente l'evento:
1. **Calcolo Spettatori Presenti (`Audience`)**:
   - Dipende dalla Popolarità locale dell'artista, dal prestigio del locale e dalla correttezza del prezzo del biglietto (da [`SP-06`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/06_formule_matematiche_e_bilanciamento.md)).
2. **Calcolo del `Concert Score` (0–100)**:
   - Ponderazione tra esecuzione tecnica dei brani, carisma vocale, scaletta ed esito degli imprevisti live.
3. **Conversione Spettatori in Nuovi Fan stabili**:
   - Più lo score è alto, maggiore è la percentuale di pubblico che si iscrive alla fanbase fidelizzata dell'artista.
4. **Incasso Netto della Serata**:
   $$\text{Incasso Netto} = (\text{Audience} \times \text{Prezzo Biglietto}) - \text{Affitto Locale} - \text{Spese Spostamento}$$

---

## 6. DESIGN VISIVO IN GODOT 4 & ACCESSIBILITÀ UNIVERSALE

### 6.1 Per Holy Diver (Grafica & UI Godot 4)
- **Scena Concerto dal Vivo (`res://ui/concert/live_concert.tscn`)**:
  - Visuale scenica accattivante con silhouette scure della folla in primo piano che saltano a ritmo con braccia alzate.
  - Luci da palco dinamiche (`PointLight2D` con gradienti colorati) che mutano colore e intensità in base all'energia del brano in esecuzione.
  - Indicatore dinamico `Hype Meter` ad arco in alto a destra che pulsa e vibra quando il pubblico è in visibilio.
  - Pannello di composizione scaletta con drag-and-drop o pulsanti a click per spostare le canzoni in scaletta.

### 6.2 Per Luca (Accessibilità Vocale & Comandi Tastiera NVDA)
- **Tasti Rapidi e Annunci Immediati**:
  - Tasto rapido globale `L`: Accesso immediato al menu Concerti e selezione dei locali disponibili.
  - Durante l'esibizione, lettura lineare dei passaggi chiave con NVDA:  
    `"Inizio concerto al Red Pub! Brano 1: 'Thunderstorm' [Rock]. Reazione folla: Molto entusiasta! Hype al 75%."`
  - In caso di imprevisto sul palco, la simulazione si mette in pausa e lo screen reader annuncia il bivio con scelte rapide `1` e `2`:  
    `"Imprevisto! Si è rotto il cavo del microfono! Premi 1 per improvvisare al megafono, 2 per fare un assolo di chitarra."`
  - Schermata di Resoconto Finale: Annuncio ordinato di spettatori presenti, incasso netto in euro e nuovi fan fidelizzati.
  - Feedback sonoro: boato della folla (applausi scroscianti o mormorio deluso) con volume congelato a 0.75f e ducking protetto.

---

## 7. CHECKPOINT DI CONFORMITÀ (GATING)

- [ ] `SP-04.1`: Definizione del catalogo locali (`VenueData`) con parametri di capienza e atmosfera.
- [ ] `SP-04.2`: Interfaccia e logica di composizione scaletta funzionante con bonus ordine brani.
- [ ] `SP-04.3`: Motore di risoluzione del concerto implementato con gestione eventi live a bivi.
- [ ] `SP-04.4`: Scena `live_concert.tscn` creata in Godot 4 con luci dinamiche ed effetti per Holy Diver.
- [ ] `SP-04.5`: Navigazione scaletta e gestione scelte live con tastiera e NVDA collaudata per Luca.
