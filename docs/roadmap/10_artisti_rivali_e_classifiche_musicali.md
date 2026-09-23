# World-tour — Roadmap Modulare: Sezione 10

- File di origine: `docs/roadmap.md`
- Titolo: Artisti Rivali, Hit Parade & Classifiche Musicali
- Priorità Operativa: P10 - Competizione & Classifiche

---

## 10. ARTISTI RIVALI, HIT PARADE & CLASSIFICHE MUSICALI

### 10.1 Il Catalogo delle 10 Band Rivali Continentali
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/rival_data.gd` e modulo `systems/rival_system.gd`.
  - Le 10 Band Rivali con città, generi, carriera, singoli ed album attivi:
    1. `The Chrome Shadows`: Milano, Rock/Elettronica, Tier Indie Sensation, Singolo "Neon Mirage", Album "Overdrive City".
    2. `I Ribelli del Pratello`: Bologna, Indie/Rock, Tier Local Artist, Singolo "Portici Rossi", Album "Sottovoce EP".
    3. `Colosseo Sound Machine`: Roma, Pop/Rock melodico, Tier Indie Sensation, Singolo "Travertino Beat", Album "Tramonto Imperiale".
    4. `Vesuvio Posse`: Napoli, Hip Hop/Crossover, Tier Indie Sensation, Singolo "Fumo e Lava", Album "Spaccanapoli Sound".
    5. `Royal Camden Vanguard`: Londra, Metal/Hard Rock, Tier National Star, Singolo "Thames Riot", Album "Crown of Rust".
    6. `Klangwerk Berlin`: Berlino, Elettronica/Industrial, Tier National Star, Singolo "Beton Tanz", Album "Nachtschicht".
    7. `The Silver Strings`: Milano, Pop Acustico, Tier Busker, Singolo "Gocce di Pioggia", Album "Sussurri Acustici".
    8. `Bologna Wave`: Bologna, Elettronica/Synthpop, Tier Local Artist, Singolo "Notte Rossa", Album "Frequenze Urbane".
    9. `London Fog`: Londra, Indie Rock/Shoegaze, Tier Indie Sensation, Singolo "Mist & Shadows", Album "Streets of London".
    10. `Berliner Mauer Beat`: Berlino, Hip Hop/Underground, Tier Local Artist, Singolo "Graffiti Wall", Album "Ostkreuz Sessions".
- **Direttrici di Espansione & Idee di Gameplay**:
  - Relazioni interpersonali con i leader dei rivali (rispetto reciproco, amicizia sincera o rivalità velenosa).
  - Possibilità di organizzare un tour congiunto a doppio cartellone (*Co-Headlining Tour*) con una band rivale amica.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 10.2 Hit Parade Settimanale: Top 10 Singoli e Top 10 Album
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modello dati: `data/models/chart_entry_data.gd` e modulo `systems/chart_system.gd`.
  - Schermata modale ad alto contrasto: `ui/chart/chart_modal.tscn` e `.gd`, tasto rapido HUD `H`.
  - Tasti interni: `1` per visualizzare la Top 10 Singoli, `2` per la Top 10 Album, `R` per la scheda dettagliata del Rivale.
  - Simulazione settimanale ogni Domenica notte (`Weekday.SUNDAY`) in `EndDaySystem`.
  - Tracciamento dinamico per ogni brano/album:
    - Posizione attuale [1 - 10]
    - Posizione precedente con indicatore di movimento: Nuova entrata (`NEW`), Salita (`▲`), Discesa (`▼`), Stabile (`=`)
    - Settimane di permanenza in classifica
    - Posizione di picco storico raggiunta
- **Direttrici di Espansione & Idee di Gameplay**:
  - Allargamento della classifica a Top 20 o Top 40.
  - Classifiche separate per singolo Paese (Hit Parade Italia, Regno Unito, Germania) oltre alla classifica continentale europea.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 10.3 Algoritmo di Stream, Vendite Fisiche & Conquista del Numero 1
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Formula calcolo vendite/stream del giocatore: Basata su Quality Score del brano/disco, Fanbase totale, Popolarità e moltiplicatore `social_buzz`.
  - Se il brano o l'album supera tutti i concorrenti e raggiunge la posizione #1:
    - Scatta l'evento trionfale "Hai conquistato il Primo Posto in Classifica!".
    - Bonus straordinario a reputazione (+15.0), incremento fan e morale al 100%.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Competizione feroce per la "Canzone di Natale" o il "Tormentone Estivo dell'Anno".
  - Meccaniche di boicottaggio o guerre di streaming tra fandom rivali.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 10.4 Faide tra Artisti, Dissing & Riconoscimenti Speciali
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Livello di rivalità tracciato in `RivalData`: 0 = Neutro/Rispetto a distanza, 1 = Competizione accesa, 2 = Faida mediatica aperta.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Dissing su BandFeed: Possibilità di pubblicare un brano o un post che prende di mira un rivale specifico per scalare le classifiche grazie alla curiosità del pubblico.
  - Evento di riconciliazione sul palco durante un grande festival con duetto a sorpresa.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

