# Sottopiano 10 — Pianificazione & Gestione del Tour (Tournée Multi-Tappa e Logistica)

- ID Sottopiano: `SP-10`
- Stato: `[x] Archiviato` — Completato e Convalidato al 100% con 17 test suite headless (0 errori)
- Versione: 1.0 — Architettura Sistemica, Mezzi di Trasporto, Hype Progressivo e Dinamiche di Gruppo
- Autore: Luca & Antigravity (Pair Programming Senior)
- Tema: Organizzazione di tournée multi-tappa (3-8 date consecutive in città diverse), scelta del veicolo di trasporto (Rusty Van, Pro Van, Luxury Bus), logistica, alloggi in tour, stanchezza cumulativa e logorio della band
- Competenze di riferimento: Core Systems Architecture, Simulation Design, Tour Management, Accessibilità NVDA
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md)
- Hub di contesto: [`GEMINI.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/GEMINI.md)

---

## 1. VISIONE & OBIETTIVO ARCHITETTURALE

Nella carriera di qualsiasi artista o band musicale, la **Tournée (Tour)** rappresenta il rito di passaggio fondamentale dall'essere un'attrazione locale a un fenomeno culturale nazionale e globale.

Mentre il singolo concerto risolve una serata isolata in un singolo locale, il Tour introduce una **dimensione strategica a lungo raggio**:
1. **Pianificazione dell'Itinerario**: Scegliere una sequenza logica di città (es. Milano -> Bologna -> Roma -> Napoli, oppure Londra -> Berlino) con date ben distanziate sul calendario.
2. **Logistica & Mezzi di Trasporto**: Scegliere il veicolo con cui viaggiare, bilanciando costi di noleggio e comfort (dal furgone scassato che logora i musicisti al tour bus professionale con cuccette).
3. **Effetto Hype a Catena (Riverbero Progressivo)**: Un concerto trionfale in una città genera passaparola e amplifica la vendita dei biglietti per le tappe successive (+5% - +10% audience cumulativa).
4. **Logorio Fisico & Dinamiche Umane**: Il tour mette alla prova la convivenza della band. Spostamenti faticosi, notti insonni e guasti meccanici aumentano lo Stress e la Tensione interna; al contrario, il trionfo condiviso consolida l'Affinità e il Rispetto Musicale.

---

## 2. MEZZI DI TRASPORTO & COSTI LOGISTICI (`TourVehicleType`)

Utilizza l'enum centralizzato `Enums.TourVehicleType` in `core/enums.gd`:

### 1. Furgone Scassato (`RUSTY_VAN = 0`)
- **Descrizione**: Il classico furgone scassato da battaglia degli esordi indipendenti.
- **Costo Noleggio**: Economico (40 € per tappa).
- **Impatto Fisico**: +15 Stress e -20 Energia aggiuntiva a ciascun musicista per tappa.
- **Rischio Imprevisti Meccanici (15%)**: Guasto al motore durante il trasferimento (costo riparazione 60 €, ritardo al soundcheck o cancellazione).
- **Prerequisiti**: Nessuno, accessibile da inizio carriera.

### 2. Van Professionale (`PRO_VAN = 1`)
- **Descrizione**: Minivan affidabile, spazioso, climatizzato e dotato di vano per strumentazione protetta.
- **Costo Noleggio**: Bilanciato (150 € per tappa).
- **Impatto Fisico**: +5 Stress e -10 Energia per tappa.
- **Affidabilità**: 0% rischio guasti ordinari.
- **Prerequisiti**: Saldo adeguato, Reputazione >= 15.0.

### 3. Tour Bus di Lusso (`LUXURY_BUS = 2`)
- **Descrizione**: Autobus Gran Turismo a due piani con zona lounge, cuccette per dormire in viaggio e frigo bar.
- **Costo Noleggio**: Elevato (450 € per tappa).
- **Impatto Fisico**: **0 Stress** da spostamento e recupero di **+15 Energia** durante il tragitto.
- **Bonus Prestigio**: +15% di Hype iniziale e comfort massimo per la band (-10 Tensione interna).
- **Prerequisiti**: Reputazione >= 40.0 o presenza di un Manager Professionista / Major Label.

---

## 3. STRUTTURA DATI DEL TOUR (`TourData`)

Classe dati dedicata in `data/models/tour_data.gd`:
- `id: String`: Identificativo univoco (es. `tour_2026_01`).
- `title: String`: Titolo della tournée (es. *"Neon Underground Tour"*).
- `vehicle_type: int`: Tipo veicolo (`TourVehicleType`).
- `status: int`: Stato del tour (Pianificato, In Corso, Completato, Interrotto).
- `stops: Array[TourStopData]`: Elenco ordinato delle tappe. Ciascuna tappa memorizza:
  - `stop_number: int` (1, 2, 3...)
  - `city_id: int` (Milano, Bologna, Roma, Napoli, Londra, Berlino)
  - `venue_id: String` (ID del locale selezionato)
  - `day_number: int` (Giorno a calendario dell'evento)
  - `completed: bool`
  - `concert_result: Dictionary` (incassi, spettatori, score, fan conquistati)
- `current_stop_index: int`: Indice della tappa corrente.
- `accumulated_hype: float`: Moltiplicatore cumulativo di affluenza guadagnato tappa dopo tappa (inizia a 1.0, +0.05 per ogni concerto con score >= 70).
- `total_gross_revenue: float`: Incasso totale lordo del tour.
- `total_expenses: float`: Costi complessivi (trasporti, affitti locali).
- `total_net_profit: float`: Utile netto ripartito tra la band.
- `total_fans_gained: int`: Nuovi fan totali conquistati sull'intera rete.

---

## 4. IL MOTORE DI GESTIONE DEL TOUR (`TourSystem`)

Sottosistema in `systems/tour_system.gd`:
1. **`plan_tour(title, vehicle, stops, player_data)`**:
   - Valida le date (almeno 1-2 giorni di intervallo tra tappe per il viaggio).
   - Valida i locali (requisiti di popolarità e reputazione per ogni città).
   - Pre-calcola il budget stimato del tour.
   - Schedula automaticamente tutte le tappe su `ScheduleSystem` (`Enums.CalendarEventType.TOUR_STOP`).
2. **`advance_to_next_stop()`**:
   - Esegue il viaggio logistico verso la città della prossima tappa sfruttando `TravelSystem`.
   - Modula costi e stress in base al veicolo del tour.
   - Risolve eventuali eventi imprevisti di viaggio (es. gomma a terra sul Rusty Van).
3. **`record_stop_performance(concert_result)`**:
   - Registra l'esito del concerto per la tappa corrente.
   - Se lo score è eccellente (>= 70), aumenta l'`accumulated_hype` di +5%, amplificando il pubblico della tappa successiva.
   - Distribuisce i fan territoriali tramite `TravelSystem.add_fans_in_city`.
4. **`finish_tour()`**:
   - Emette il bilancio finale del tour con rendiconto economico, fan totali e impatto sulle relazioni della band:
     - Se il tour è in attivo economico e di fan: +15 Affinità, +15 Rispetto Musicale, -20 Tensione.
     - Se il tour è in perdita e stressante: +25 Tensione interna, rischio abbandono compagni.
   - Riconosce punti Reputazione aggiuntivi per aver concluso una tournée completa.

---

## 5. ACCESSIBILITÀ ASSOLUTA (NVDA / ZERO MOUSE) & SIMMETRIA VISIVA

1. **Dashboard Tour ad Alto Contrasto per Holy Diver**:
   - Mappa/timeline lineare con l'itinerario delle città, badge per la tappa attiva, statistiche di incasso e barra dell'Hype.
2. **Procedura Lineare Vocale per Luca**:
   - Tasto rapido globale nell'HUD: **`O`** ("Tour").
   - Vocalizzazione lineare dell'itinerario: tappa corrente, destinazione successiva, veicolo utilizzato, date a calendario.
   - Scorciatoie numeriche da tastiera per le azioni di tour.
   - Annuncio audio dedicato di arrivo in città e completamento della tournée.

---

## 6. PIANO DI COLLAUDO & TEST AUTOMATIZZATI

- Creazione della suite dedicata [`tests/test_tour_system.gd`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/tests/test_tour_system.gd):
  1. Test pianificazione tour (validazione tappe, veicoli, budget).
  2. Test integrazione con `ScheduleSystem` (presenza tappe a calendario).
  3. Test logistica e differenziali veicoli (Rusty Van vs Pro Van vs Luxury Bus).
  4. Test accumulo Hype sequenziale tra concerti.
  5. Test dinamiche psicologiche della band post-tour.
  6. Test resa vocale per NVDA e serializzazione save/load.
