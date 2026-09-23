# Report di Handoff & Bootstrap — Avvio Sezione 5: Concerti dal Vivo, Locali, Scaletta & Pubblico
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-23
# Percorso File: docs/report/REPORT_AVVIO_SESSIONE_SEZIONE_5.md
# File di Riferimento: docs/roadmap/05_concerti_locali_scaletta_e_pubblico.md
# Baseline AVF: V4.4.0
# Priorità: P5 — Performance Live, Venue Calendar, Drammaturgia Scaletta & Merch

---

## 🎯 1. OBIETTIVO DEL DOCUMENTO

Questo documento costituisce il **Report di Bootstrap & Handoff** per l'apertura ufficiale della **Sezione 5 della Roadmap Modulare** di **World-tour** ("Concerti dal Vivo, Locali, Scaletta & Pubblico").
Fornisce la sintesi dei requisiti, lo stato consolidato del codebase (23 suite headless convalidate con 0 errori a 0 ms), e le direttrici operative per formulare il Piano Tecnico Formale (Sotto-Fase 1A).

---

## 🏛️ 2. STATO DELL'ARTE DEL CODEBASE (BASELINE DI PARTENZA)

1. **Sezioni 1, 2, 3 e 4 Completate e Archiviate al 100%**:
   - **Sezione 1 (Identità, Routine & Risorse)**: Creazione personaggio guidata, ciclo notte 22h, overtime progressivo, skip time, riposo anticipato, triade vitale e `RelaxModal`.
   - **Sezione 2 (Creatività Musicale & Produzione)**: 10 Temi Lirici, tratti canzone speciali, sconto studio martedì, pipeline 6 fasi in `SongCreator`, `SongCatalog` e `AlbumCreator`.
   - **Sezione 3 (La Band, Reclutamento & Dinamiche Relazionali)**: 5 ruoli strumentali, 8 personalità, bacheca audizioni con formula rifiuto, prove di gruppo e Revenue Split.
   - **Sezione 4 (Strumenti, Sala Prove, Home Studio & Upgrades Hub)**: Negozio multicategoria con comparatore e dotazione band, 5 pedali e 2 amplificatori, insonorizzazione e sub-affitto passivo sala prove, nastro analogico a bobine vs digitale HD, usura progressiva (-8% concerti, -3% prove), muletto salvavita nel van e manutenzione liutaio.
2. **Integrità del Codice & Suite Headless**:
   - **23 suite headless convalidate con 0 errori e zero regressioni**.
   - Watchdog timeout a 15 secondi (`tools/test.ps1`).
3. **Persistenza & Accessibilità**:
   - `SaveManager` blindato con re-binding esplicito per tutti i sistemi.
   - `AccessibilityManager` con gating semantico delle scorciatoie durante i menu.
   - Working tree Git pulito e versione AVF: **`V4.4.0`**.

---

## 🎸 3. I 5 PILASTRI DELLA SEZIONE 5 (ROADMAP MODULARE 05)

Il documento specialistico di riferimento è [`docs/roadmap/05_concerti_locali_scaletta_e_pubblico.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/roadmap/05_concerti_locali_scaletta_e_pubblico.md).

### 5.1 Espansione del Circuito dei Locali
- Locali classici già esistenti: `venue_garage` (15 spettatori, 0 €), `venue_pub` (60 spettatori, 50 €), `venue_small_club` (180 spettatori, 250 €), `venue_trendy_club` (450 spettatori, 700 €).
- Nuove venue ad identità differenziata:
  * `venue_social_center` (*Centro Sociale / Spazio Occupato*): Capienza media (120 spettatori), affitto quasi nullo (30 €), tolleranza alta per artisti emergenti e generi ribelli (Punk, Metal, Indie), prezzo biglietto basso ma altissimo impatto sulla reputazione locale underground.
  * `venue_opera_theatre` (*Teatro d'Opera Storico*): Capienza alta (800 spettatori), affitto e requisiti elevati, biglietto premium, ideale per performance acustiche raffinate, con forte incremento di popolarità e prestigio.

### 5.2 Disponibilità e Calendario delle Venue (La Meccanica di Luca)
- Le venue non sono sempre libere: ciascun locale dispone di un proprio calendario eventi sincronizzato su `ScheduleSystem`.
- Stati del locale nella data scelta: *Libero*, *Prenotato da altra band*, *Chiuso per manutenzione*.
- Richiesta di prenotazione anticipata, con particolare affollamento e concorrenza sulle serate del weekend (Venerdì e Sabato).

### 5.3 Flow e Drammaturgia della Scaletta (1–4 brani)
- Posizionamento drammaturgico dei pezzi in scaletta:
  * *Opener*: primo brano energico per accendere il pubblico (+hype iniziale);
  * *Mid*: brani centrali per sostenere l'interesse;
  * *Intimo / Ballad*: cambio di atmosfera emotiva;
  * *Closer*: gran finale esplosivo con Closer Bonus se presente il tratto `STAGE_BEAST`.
- Opzione *Cover di Artisti Famosi*: possibilità di eseguire cover per scaldare il pubblico nei locali ostili con minore repertorio proprio.

### 5.4 Nuovi Imprevisti di Palco Procedurali & Bivi Scenici
- Espansione degli Stage Events oltre a quelli base (`BROKEN_STRING`, `AUDIO_FEEDBACK`, `ENTHUSIASTIC_FAN`):
  * `BLACKOUT`: calo improvviso di corrente elettrica sul palco (bivio: canto a cappella unplugged col pubblico o pausa per attendere i tecnici);
  * `CROWD_CHANT`: cori da stadio spontanei della folla (bivio: assecondare il coro o attaccare subito il ritornello successivo);
  * `PIT_FIGHT`: rissa nel pit (bivio: fermare lo show dal microfono per calmare gli animi o far intervenire la security);
  * `STAGE_DIVING`: tuffo dal palco verso la folla (bivio: crowd surfing trionfale su carisma elevato o atterraggio rovinoso).

### 5.5 Banchetto Merchandising & Momento Bis / Encore
- Allestimento del banchetto merch nel foyer del locale con selezione articoli (magliette, spille, poster, plettri).
- Meccanica dell'Encore/Bis richiesto a gran voce dal pubblico se il Concert Score supera 85/100, con piccolo extra incasso e spinta sul morale della band.

---

## 📋 4. PROMPT PRONTO PER LA NUOVA CHAT (AVVIO SEZIONE 5)

```text
Ciao Antigravity! Riprendiamo il pair programming su World-tour. Tutte le attività delle Sezioni 1, 2, 3 e 4 sono state completate, convalidate al 100% (23 suite headless a 0 errori) e interamente archiviate. Il working tree Git è pulito e la versione AVF è V4.4.0. Oggi apriamo ufficialmente la SEZIONE 5 della Roadmap Modulare: 'Concerti dal Vivo, Locali, Scaletta & Pubblico' (File di riferimento: docs/roadmap/05_concerti_locali_scaletta_e_pubblico.md e docs/report/REPORT_AVVIO_SESSIONE_SEZIONE_5.md). Come da Regola 0 e governance ASTRALIS v3.0.7, procedi con la Sotto-Fase 1A: analizza i requisiti e l'integrazione con ScheduleSystem e LiveConcert, elabora il Piano Tecnico Formale in docs/piani/attivi/ ed effettua lo Stop Obbligatorio per attendere la nostra approvazione.
```
