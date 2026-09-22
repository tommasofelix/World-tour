# Sottopiano 09 — Calendario Sistemico, Agenda, Cicli Temporali e Programmazione Eventi

- ID Sottopiano: `SP-09`
- Versione: 1.0 — Architettura Sistemica, Modello Dati e Integrazione Modulare
- Autore: Luca & Antigravity (Pair Programming Senior)
- Tema: Scansione multi-livello del tempo (giorni, settimane, mesi, stagioni), Agenda personale della Band, Programmazione settimanale dei locali e Scadenze sistemiche di settore
- Competenze di riferimento: Core Systems Architecture, Simulation Design, Narrative Pacing, Accessibilità NVDA
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md)
- Hub di contesto: [`GEMINI.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/GEMINI.md)

---

## 1. VISIONE & OBIETTIVO ARCHITETTURALE

Finora il tempo in *World-tour* è stato gestito tramite un contatore di giorni lineari (`day_number: 1, 2, 3...`) e una suddivisione intra-giornaliera in 4 fasce orarie.
Per trasformare il simulatore musicale in un **mondo vivo, credibile, dinamico e strategico**, è necessario un **Sistema di Calendario Multi-Livello Integrato**.

La vita reale di un musicista è scandita dal calendario:
1. **La Settimana**: I locali lavorano a pieno regime solo dal giovedì al sabato; il lunedì è giorno di chiusura; i giorni feriali sono ideali per le prove e le registrazioni.
2. **Il Mese**: L'affitto si paga a fine mese; le royalties e i rendiconti discografici arrivano a cadenza mensile/trimestrale.
3. **Le Stagioni**: I grandi festival all'aperto e i tour interurbani si svolgono d'estate; l'inverno è la stagione delle registrazioni in studio e della scrittura; la primavera e l'autunno vedono il picco di uscite discografiche.
4. **L'Agenda Personale & degli Impegni**: Prenotare un live con 2 settimane d'anticipo, avere una scadenza con la Major per consegnare il master dell'album entro 60 giorni, pianificare le prove con i compagni prima di una data importante.

---

## 2. MODELLO MATEMATICO DEL TEMPO (CONVENZIONE 28 GIORNI)

Per garantire massima pulizia algoritmica, assenza di casi limite bizzarri e perfetta simmetria cognitiva per la lettura con screen reader, adottiamo il **Gold Standard dei simulatori di vita (Convenzione Lunare a 28 Giorni)**:

- **1 Settimana** = Esattamente 7 Giorni:
  - `0`: Lunedì
  - `1`: Martedì
  - `2`: Mercoledì
  - `3`: Giovedì
  - `4`: Venerdì
  - `5`: Sabato
  - `6`: Domenica
- **1 Mese** = Esattamente 4 Settimane = **28 Giorni**.
  - **Proprietà Straordinaria**: Il giorno 1 di ogni mese è **SEMPRE un Lunedì**, il giorno 28 è **SEMPRE una Domenica**.
  - Non esistono mesi zoppi con 30 o 31 giorni, facilitando la memorizzazione mentale per Luca e una rappresentazione tabellare perfetta per Holy Diver.
- **1 Anno** = 12 Mesi = 48 Settimane = **336 Giorni di Carriera**.
- **4 Stagioni** da 3 Mesi ciascuna:
  - **Primavera**: Mesi 1, 2, 3 (Marzo, Aprile, Maggio) — Risveglio della scena, singoli radiofonici primaverili, bandi festival.
  - **Estate**: Mesi 4, 5, 6 (Giugno, Luglio, Agosto) — Grandi Festival all'Aperto, Tour Interurbani e Nazionali.
  - **Autunno**: Mesi 7, 8, 9 (Settembre, Ottobre, Novembre) — Ritorno nei Club al chiuso, uscite Album LP di punta, contratti discografici.
  - **Inverno**: Mesi 10, 11, 12 (Dicembre, Gennaio, Febbraio) — Sessioni intensive di studio, concerti festivi di Capodanno, scrittura nuovi concept.

### Formule di Calcolo Deterministico dal `day_number`:
```python
# Giorno della settimana (0 = Lunedì, 6 = Domenica)
weekday = (day_number - 1) % 7

# Giorno del mese (1 .. 28)
day_of_month = ((day_number - 1) % 28) + 1

# Mese (1 .. 12)
month = (int((day_number - 1) / 28) % 12) + 1

# Settimana globale di carriera
week_number = int((day_number - 1) / 7) + 1

# Anno di carriera (1, 2, ...)
year = int((day_number - 1) / (28 * 12)) + 1

# Stagione (0 = Primavera, 1 = Estate, 2 = Autunno, 3 = Inverno)
season = int((month - 1) / 3)
```

---

## 3. IMPATTO DEI GIORNI DELLA SETTIMANA SUL GAMEPLAY

| Giorno | Nome | Atmosfera & Focus Gameplay | Effetti Sistemici sui Concerti & Routine |
| :--- | :--- | :--- | :--- |
| **0** | **Lunedì** | Ritorno alla routine, decompressione | Locali chiusi per live. Studio personale, scrittura brani, commissioni. |
| **1** | **Martedì** | Sessioni tecniche e lavoro | Studio di registrazione con tariffe scontate (-20% sui costi orari). |
| **2** | **Mercoledì** | Prove d'insieme della band | Prove di gruppo con affinità potenziata (+20% XP intesa). |
| **3** | **Giovedì** | Serate Open Mic & Jam Session | Piccoli club aperti. Cachet ridotto, ma possibilità di talent scout tra il pubblico. |
| **4** | **Venerdì** | Inizio del Weekend Musicale | **Affluenza Live +50%**. Maggior consumo birra/merch. Serate Indie/Rock nei club medi. |
| **5** | **Sabato** | **Prime Time della Settimana** | **Affluenza Live +100% (Sold-out probabile)**. Cachet massimi, conversione fan x1.5. |
| **6** | **Domenica** | Giorno di Riposo & Ripensamento | Relax casalingo (sgravio stress extra), busking per strada o pianificazione tour. |

---

## 4. ARCHITETTURA TECNICA & MODELLO DATI

### 4.1 Modello `CalendarEventData` (`data/models/calendar_event_data.gd`)
Rappresenta qualsiasi impegno o ricorrenza inserita a calendario:
- `id: String`: identificatore univoco.
- `title: String`: nome dell'evento (es. *"Live al Matrix Club"*, *"Scadenza Consegna Master Album"*, *"Pagamento Affitto"*).
- `event_type: int`: tipologia (es. `Enums.CalendarEventType.CONCERT`, `REHEARSAL`, `STUDIO_BOOKING`, `CONTRACT_DEADLINE`, `RENT_DUE`, `FESTIVAL`, `TOUR_STOP`).
- `day_number: int`: giorno esatto dell'evento.
- `period: int`: fascia oraria interessata (`Enums.TimePeriod`).
- `location_id: String`: locale o luogo in cui si svolge l'evento.
- `city_id: String`: città di svolgimento.
- `details: Dictionary`: parametri specifici (es. scaletta, anticipo concordato, etichetta).
- `is_completed: bool`: flag di avvenuto svolgimento.
- `is_critical: bool`: se vero, il mancato rispetto causa penalità (es. saltare un concerto confermato o non consegnare il master alla Major).

### 4.2 Sottosistema `ScheduleSystem` (`systems/schedule_system.gd`)
Motore centrale per la gestione degli eventi temporali:
- Registrazione, cancellazione e query degli impegni.
- Metodi di ricerca:
  - `get_events_for_day(target_day: int) -> Array[CalendarEventData]`
  - `get_events_for_week(target_week: int) -> Array[CalendarEventData]`
  - `get_upcoming_events(days_ahead: int = 7) -> Array[CalendarEventData]`
  - `has_event_at(day: int, period: int) -> bool`
- Segnali EventBus dedicati:
  - `signal schedule_event_added(event: CalendarEventData)`
  - `signal schedule_event_triggered(event: CalendarEventData)`
  - `signal schedule_event_missed(event: CalendarEventData, reason: String)`

---

## 5. INTEGRAZIONE SISTEMICA CON I MODULI DI GIOCO

### 5.1 Integrazione con la Scheda del Personaggio (`CharacterSheet`)
- Nella scheda personaggio (`CharacterSheet`), aggiungere una sezione **"Agenda Impegni"** (consultabile con tasto rapido dedicato o tab).
- **Vocalizzazione Lineare per NVDA**:
  Premendo il comando agenda, NVDA legge in sequenza cronologica gli impegni dei prossimi giorni:
  > *"Oggi: Venerdì 12 Maggio. Sera: Concerto Live al Red Pub (Milano). Domani: Sabato 13 Maggio — Nessun impegno confermato. Tra 8 giorni: Scadenza Consegna Album per Apex Global Records."*

### 5.2 Integrazione con i Locali & Concerti (`ConcertSystem`)
- I concerti non si improvvisano solo "il giorno stesso": i locali più prestigiosi richiedono prenotazione con 3-7 giorni di anticipo.
- Il venerdì e il sabato sera i club hanno un'agenda settimanale: se il giocatore non prenota in tempo, una band rivale della scena potrebbe occupare la data!

### 5.3 Integrazione con l'Industria & i Contratti (`IndustrySystem`)
- Quando si firma con una Major, il contratto include una **Scadenza di Consegna (Deadline)** a calendario (es. entro 60 giorni).
- L'agenda notifica l'avvicinarsi della data (avvisi a -30, -14, -7 giorni), aumentando la tensione e lo stress se l'album non è ancora stato masterizzato.

### 5.4 Integrazione con l'Economia (`EconomySystem`)
- Spese fisse e canone di locazione scalati regolarmente a fine mese (il giorno 28 di ogni mese simulato).
- Bilancio trimestrale delle royalties discografiche (il 28 di ogni 3° mese).

### 5.5 Integrazione con Tour & Festival (Fase 8 - Versione 4.0)
- Il **Tour Interurbano** è per definizione un itinerario a calendario: tappe consecutive programmate con date di viaggio e date di esibizione.
- I **Grandi Festival Estivi** hanno date fisse nei mesi estivi (Mesi 4-6): i bandi e gli inviti arrivano in Primavera (Mese 3), con esibizioni calendarizzate a Luglio/Agosto.

---

## 6. PIANO DI ROLLOUT & GATING OPERATIVO

1. **Estensione Modello Dati**: arricchire `CalendarData` con le formule dei 28 giorni, giorni della settimana, mesi, stagioni e anni.
2. **Creazione Modello `CalendarEventData` e Motore `ScheduleSystem`**.
3. **Integrazione `CharacterSheet` e HUD**: visualizzazione data completa (es. *"Giorno 12 — Venerdì 12 Maggio (Primavera Anno 1)"*) e sezione Agenda nella Scheda Personaggio.
4. **Connessione con `ConcertSystem`, `IndustrySystem`, `TourSystem`**.
5. **Suite di Test Dedicata (`test_schedule_system.gd`)**: 100% test headless superati.
