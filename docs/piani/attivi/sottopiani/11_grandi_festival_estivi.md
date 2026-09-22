# Sottopiano 11 — I Grandi Festival Estivi (FestivalSystem & FestivalData)

- ID Sottopiano: `SP-11`
- Versione: 1.0 — Architettura Stagionale, Slot di Esibizione, Competizione tra Band e Merchandising Massivo
- Autore: Luca & Antigravity (Pair Programming Senior)
- Tema: Stagione dei grandi festival all'aperto nei mesi estivi (Mesi 4-6 / Giorni 85-168), slot orari di esibizione (Pomeriggio, Tramonto, Headliner), confronto con band rivali sul cartellone ("Rubare la Scena"), moltiplicatore vendite merch (x3 - x5) e spinta massiva di popolarità
- Competenze di riferimento: Core Systems Architecture, Simulation Design, Festival Management, Accessibilità NVDA
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md)
- Hub di contesto: [`GEMINI.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/GEMINI.md)

---

## 1. VISIONE & OBIETTIVO ARCHITETTURALE

Nella progressione di carriera di una band, i **Grandi Festival Estivi** rappresentano l'evento culmine della stagione all'aperto. A differenza dei concerti regolari nei club o nelle sale al chiuso, il festival introduce:
1. **Stagionalità Rigorosa**: I festival si tengono durante l'Estate (Mesi 4, 5 e 6 del calendario sistemico). I bandi e le candidature si aprono in Primavera (Mese 3), premiando la pianificazione strategica sull'agenda.
2. **Slot Orari di Esibizione (`FestivalSlot`)**: Dalla gavetta pomeridiana sotto il sole cocente allo slot dorato del tramonto fino al prestigioso ruolo di *Headliner notturno* davanti a una marea oceanica.
3. **Impatto Scalabile su Fanbase e Notorietà**: Esibirsi davanti a 10.000 - 80.000 spettatori garantisce un tasso di conversione fan e un riverbero territoriale molto superiore a qualsiasi live ordinario.
4. **Vendite Merchandising Intensive**: Il pubblico dei grandi festival acquista avidamente magliette, vinili, poster e gadget ufficiali (moltiplicatore vendite merch da x3 a x5 rispetto ai club).
5. **Competizione tra Band & Rivale del Cartellone ("Rubare la Scena" - *Steal the Show*)**: Ogni festival presenta un cartellone condiviso con altre formazioni della scena. Superare il punteggio della band rivale consacra la band agli occhi della critica e del pubblico, scatenando un'ondata di hype.

---

## 2. SLOT DI ESIBIZIONE & REQUISITI (`FestivalSlot`)

Utilizza l'enum preesistente in `core/enums.gd` (`Enums.FestivalSlot`):

### 1. Slot Pomeridiano (`OPENING_AFTERNOON = 0`)
- **Orario Virtuale**: 14:00 - 17:00.
- **Pubblico Presente**: ~20% della capienza dell'area festival (2.000 - 8.000 spettatori).
- **Cachet Garantito**: Modesto (400 € - 900 €).
- **Pressione / Stress**: Basso (+5 stress).
- **Moltiplicatore Merch**: x2.5.
- **Prerequisiti**: Reputazione minima >= 15.0.

### 2. Slot al Tramonto / Golden Hour (`SUNSET_SLOT = 1`)
- **Orario Virtuale**: 18:30 - 20:30.
- **Pubblico Presente**: ~60% della capienza dell'area festival (8.000 - 25.000 spettatori).
- **Cachet Garantito**: Rilevante (1.800 € - 4.500 €).
- **Pressione / Stress**: Moderato (+15 stress).
- **Moltiplicatore Merch**: x4.0.
- **Prerequisiti**: Reputazione minima >= 35.0, almeno 1 Album/EP pubblicato.

### 3. Headliner Notturno (`HEADLINER_NIGHT = 2`)
- **Orario Virtuale**: 21:30 - 23:30.
- **Pubblico Presente**: 100% della capienza (20.000 - 80.000 spettatori).
- **Cachet Garantito**: Trionfale (8.000 € - 30.000 €).
- **Pressione / Stress**: Elevato (+30 stress).
- **Moltiplicatore Merch**: x5.5.
- **Prerequisiti**: Reputazione minima >= 60.0 (o >= 45.0 se supportati da Manager Squalo `INDUSTRY_SHARK`).

---

## 3. CATALOGO DEI 6 GRANDI FESTIVAL CONTINENTALI

Ciascuna delle 6 metropoli della rete ospita un festival simbolo:

1. **Milano**: *Rock in Milano Open Air* (Idroscalo / Parco)
   - Capienza: 35.000 persone. Mese: 4 (Giugno), Giorno: 92.
   - Generi prediletti: Rock, Elettronica, Pop.
   - Rivale cartellone: *"The Chrome Shadows"* (Synth-Rock affermato, benchmark 74.0).

2. **Bologna**: *Independent Summer Fest* (Arena Parco Nord)
   - Capienza: 20.000 persone. Mese: 5 (Luglio), Giorno: 120.
   - Generi prediletti: Indie, Rock, Punk.
   - Rivale cartellone: *"I Ribelli del Pratello"* (Indie-Rock cult, benchmark 72.0).

3. **Roma**: *Roma Rock & Live Fest* (Ippodromo delle Capannelle)
   - Capienza: 40.000 persone. Mese: 5 (Luglio), Giorno: 134.
   - Generi prediletti: Rock, Pop, Cantautorato.
   - Rivale cartellone: *"Colosseo Sound Machine"* (Rock da classifica, benchmark 76.0).

4. **Napoli**: *Partenope Sound Fest* (Arenile di Bagnoli sul Mare)
   - Capienza: 25.000 persone. Mese: 6 (Agosto), Giorno: 152.
   - Generi prediletti: Hip Hop, Urban, Rock alternativo.
   - Rivale cartellone: *"Vesuvio Posse"* (Hip Hop militante, benchmark 75.0).

5. **Londra**: *Hyde Park & Download Calling* (Regno Unito - Internazionale)
   - Capienza: 65.000 persone. Mese: 4 (Giugno), Giorno: 104.
   - Generi prediletti: Rock, Metal, Indie.
   - Rivale cartellone: *"Royal Camden Vanguard"* (Brit-Rock leggendario, benchmark 82.0).
   - Requisiti accesso: Reputazione estera >= 40.0.

6. **Berlino**: *Berlin Electronic & Heavy Gathering* (Tempelhof / Spree)
   - Capienza: 50.000 persone. Mese: 6 (Agosto), Giorno: 160.
   - Generi prediletti: Elettronica, Metal, Industrial.
   - Rivale cartellone: *"Klangwerk Berlin"* (Industrial Techno idol, benchmark 80.0).
   - Requisiti accesso: Reputazione estera >= 40.0.

---

## 4. ARCHITETTURA DEL MODELLO DATI (`FestivalData`)

File dedicato in `data/models/festival_data.gd`:
- `id: String`: Identificativo univoco (es. `fest_milano`).
- `name: String`: Nome del festival.
- `city_id: int`: Città ospitante (`Enums.CityId`).
- `location_name: String`: Nome del parco o arena.
- `day_number: int`: Giorno del calendario di svolgimento (in Mese 4-6).
- `capacity: int`: Capienza massima area festival.
- `genre_focus: Array[int]`: Generi con moltiplicatore gradimento.
- `rival_band_name: String`: Nome della band rivale presente nel cartellone.
- `rival_band_score: float`: Punteggio della band rivale per la meccanica "Rubare la Scena".
- `booked_slot: int`: Slot prenotato dal giocatore (-1 = non prenotato, 0 = Pomeriggio, 1 = Tramonto, 2 = Headliner).
- `is_completed: bool`: Flag di completamento dell'edizione annuale.
- `performance_result: Dictionary`: Esito registrato dell'esibizione.
- Serializzazione completa con `to_dict()` e `from_dict()`.

---

## 5. MOTORE GESTIONALE DEI FESTIVAL (`FestivalSystem`)

File dedicato in `systems/festival_system.gd`:
- **Catalogo Predefinito**: Inizializzazione dei 6 festival con coordinate temporali e territoriali.
- **Controlli di Ammissione (`can_apply_for_slot(festival_id, slot)`)**:
  - Verifica reputazione del musicista rispetto al requisito dello slot.
  - Verifica se il festival è già passato o già prenotato.
  - Mediazione Manager: I manager qualificati (`PRO_INDIE` e `INDUSTRY_SHARK`) riducono la soglia reputazione del 20% - 35% e amplificano il cachet.
- **Prenotazione & Sincronizzazione Agenda (`book_festival_slot`)**:
  - Assegna lo slot al festival.
  - Genera un evento `CalendarEventData` di tipo `Enums.CalendarEventType.FESTIVAL` e lo registra in `ScheduleSystem`.
- **Risoluzione Live al Festival (`perform_festival_concert(festival_id, songs, ticket_price = 0.0)`)**:
  - Calcola il Concert Score tenendo conto del talento della band e dell'affinità di genere con il festival.
  - Calcola l'affluenza reale in base alla capienza, allo slot e alla notorietà.
  - Calcola l'incasso totale = `Cachet Garantito + Vendite Merchandising (affluenza * merch_multiplier * pricing)`.
  - **Meccanica "Rubare la Scena" (*Steal the Show*)**:
    - Se `concert_score >= rival_band_score`:
      - "Steal the Show" riuscito! Bonus fan +25%, +10 Morale band, -15 Tensione band, +5.0 Reputazione immediata.
    - Se `concert_score < rival_band_score`:
      - La rivale mantiene il primato: i fan aumentano comunque per l'alta affluenza, ma c'è un moderato accumulo di stress.
  - Ripartizione provvigione del manager e distribuzione incassi alla band.
  - Accredito dei fan territoriali tramite `TravelSystem` (85% nella città ospitante, 15% riverbero nazionale).

---

## 6. ACCESSIBILITÀ NVDA & INTERFACCIA TASTIERA

File UI dedicati in `ui/festival/`:
- **Scorciatoia HUD**: Tasto rapido `F` ("Festival").
- **Tasti Rapidi da Tastiera**:
  - `1`..`6`: Selezione del Festival desiderato nel catalogo.
  - `P` / `1`: Selezione Slot Pomeriggio.
  - `T` / `2`: Selezione Slot Tramonto.
  - `H` / `3`: Selezione Slot Headliner.
  - `Invio` / `C`: Candidatura / Prenotazione slot.
  - `S` / `Spazio`: Avvia Esibizione al Festival (se ci si trova sul posto nel giorno dell'evento).
  - `Esc`: Chiudi finestra.
- **Resa Vocale Lineare per NVDA**:
  - Dicitura sequenziale senza caratteri ASCII complessi:
    *"Festival: Rock in Milano Open Air. Città: Milano. Data: Giorno 92 (Mese 4 - Estate). Slot: Tramonto (Pubblico stimato: 18.000). Cachet: 3.200 €. Rivale sul cartellone: The Chrome Shadows (Score rivale: 74). Stato: Candidatura accettata."*
