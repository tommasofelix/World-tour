# Sottopiano 13 — Artisti Rivali & Classifiche Musicali (ChartSystem & RivalSystem)

- ID Sottopiano: `SP-13`
- Stato: `[x] Archiviato` — Completato e Convalidato al 100% con 17 test suite headless (0 errori)
- Versione: 1.0 — Hit Parade Settimanale Singoli e Album, Band Rivali Underground & Mainstream, Faide e Dinamiche di Classifica
- Autore: Luca & Antigravity (Pair Programming Senior)
- Tema: Hit parade settimanale (Top 10 Singoli e Top 10 Album) aggiornata ogni Domenica sera, artisti e band rivali della scena underground e mainstream con tratti competitivi e faide, monitoraggio delle posizioni in classifica, picchi storici (#1 Hit), impatto sulle vendite, concerti e reputazione con la label.
- Competenze di riferimento: Core Systems Architecture, Simulation Design, Competitive Dynamics, Accessibilità NVDA
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md)
- Hub di contesto: [`GEMINI.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/GEMINI.md)

---

## 1. VISIONE & OBIETTIVO ARCHITETTURALE

La progressione nel mondo della musica non è un cammino solitario: il successo si misura anche nel confronto serrato con la scena musicale contemporanea.
La **Fase 8.5** introduce la competitività viva e pulsante del mercato discografico:

1. **La Hit Parade Settimanale (`ChartSystem`)**:
   - Ogni Domenica a mezzanotte viene pubblicata la classifica ufficiale:
     - **Top 10 Singoli**: Basata su stream settimanali, passaggi radiofonici ed engagement social generato dai brani rilasciati.
     - **Top 10 Album**: Basata sulle vendite fisiche/digitali e streaming aggregato degli EP e LP.
   - Ogni posizione registra: `rank` (1..10), `previous_rank`, `movement` (salita, discesa, invariato, new entry `NEW`), `weeks_on_chart` e `peak_rank` (massimo risultato raggiunto).
2. **Gli Artisti Rivali della Scena (`RivalSystem`, `RivalData`)**:
   - Catalogo di band concorrenti che popolano le 6 città e i vari livelli di carriera:
     - Band emergenti e indie rivali (es. *I Ribelli del Pratello*, *The Chrome Shadows*).
     - Gruppi affermati della scena nazionale e major darling (es. *Colosseo Sound Machine*, *Vesuvio Posse*, *Royal Camden Vanguard*, *Klangwerk Berlin*).
     - Nuovi concorrenti procedurali generati per mantenere viva la sfida nel tempo.
   - Indicatori di rivalità: `rivalry_level` (0 = Neutro, 1 = Competizione amichevole, 2 = Faida mediatica accesa).
3. **Dinamiche di Scalata & Traguardi Epici**:
   - **Debutto in Top 10**: Prima entrata in classifica (+3.0 reputazione, boost morale band).
   - **La Conquista della Vetta (#1 Hit Single / #1 Album)**: Raggiungere il primo posto assoluto sbloccando prestigio mediatico (+15.0 reputazione, offerte contrattuali vantaggiose e bonus vendite).
   - **Faide & Sfide tra Band**: Dichiarazioni sui social, frecciatine prima dei festival o concerti condivisi.

---

## 2. MODELLI DATI

### A. `RivalData` (`data/models/rival_data.gd`)
- `id: String`: Identificativo univoco.
- `name: String`: Nome della band/artista rivale.
- `genre: int`: Genere musicale (`Enums.MusicalGenre`).
- `home_city_id: int`: Città d'origine (`Enums.CityId`).
- `career_tier: int`: Fascia di carriera (`Enums.CareerTier`).
- `popularity: float`: Popolarità generale (0.0 - 100.0).
- `current_single_title: String`: Titolo dell'ultimo singolo in rotazione.
- `current_single_score: float`: Punteggio di qualità del singolo rivale.
- `current_album_title: String`: Titolo dell'album rivale sul mercato.
- `current_album_score: float`: Punteggio di qualità dell'album rivale.
- `rivalry_level: int`: Grado di attrito/competizione (0 = Neutro, 1 = Competizione, 2 = Faida accesa).
- `to_dict()` e `from_dict()`.

### B. `ChartEntryData` (`data/models/chart_entry_data.gd`)
- `rank: int`: Posizione attuale (1..10).
- `previous_rank: int`: Posizione nella settimana precedente (0 se debutto).
- `entry_id: String`: ID del brano o dell'album.
- `title: String`: Titolo dell'opera.
- `artist_name: String`: Nome dell'artista o band.
- `is_player: bool`: True se appartiene alla band del giocatore.
- `genre: int`: Genere musicale.
- `metric_value: int`: Punteggio quantitativo (stream o vendite stimate della settimana).
- `weeks_on_chart: int`: Numero di settimane continuative in classifica.
- `peak_rank: int`: Migliore posizione mai raggiunta.
- `to_dict()` e `from_dict()`.

---

## 3. SOTTOSISTEMI DI GIOCO

### A. `ChartSystem` (`systems/chart_system.gd`)
- Traccia la `top_singles: Array[ChartEntryData]` e la `top_albums: Array[ChartEntryData]`.
- Metodo `update_weekly_charts(day_number: int)`:
  - Raccoglie i brani e album rilasciati dal giocatore (`player_data.songs` e `player_data.albums`).
  - Calcola la spinta settimanale: per il giocatore si basa su qualità, recensioni, popolarità, concerti recenti e `weekly_buzz` social.
  - Simula le performance dei singoli e album dei rivali (`RivalSystem`).
  - Ordina per volume di stream/vendite settimanali e compone le Top 10.
  - Aggiorna movimenti, settimane di permanenza e picchi storici.
  - Rileva traguardi: prima entrata in classifica o conquista del #1 con emissione di segnali ed eventi narrativi.
- Resa vocale lineare `get_charts_speech(chart_type: int) -> String` per NVDA.

### B. `RivalSystem` (`systems/rival_system.gd`)
- Mantiene il catalogo degli artisti rivali (`rivals: Dictionary`).
- Genera rilasci periodici per i rivali e aggiorna i loro punteggi.
- Gestisce l'interazione tra band: sfide sul palco, faide social e commenti della critica.

---

## 4. INTERFACCIA UTENTE & ACCESSIBILITÀ NVDA

- **Modale `ChartModal` (`ui/charts/chart_modal.gd` & `.tscn`)**:
  - Tasto rapido dall'HUD: `H` ("Hit Parade").
  - Navigazione tra le due classifiche con tasti `1` (Singoli) e `2` (Album).
  - Tasto `R`: Scheda di dettaglio dei rivali in classifica e stato delle faide.
  - Tasto `Esc`: Chiusura e ritorno all'HUD.
  - Vocalizzazione sequenziale per NVDA: posizione, movimento, artista, titolo e punteggio senza griglie bidimensionali.
