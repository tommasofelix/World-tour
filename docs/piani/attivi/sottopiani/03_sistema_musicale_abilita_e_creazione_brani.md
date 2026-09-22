# Sottopiano 03 — Sistema Musicale, Abilità e Creazione Brani

- ID Sottopiano: `SP-03`
- Versione: 1.1 — Ottimizzata per Gameplay, Architettura Tecnica e UI Godot 4
- Tema: Competenze Musicali, Generi, Pipeline di Creazione, Tratti Emergenti dei Brani e Catalogo Discografico
- Competenze di riferimento: Music Crafting System, Audio/Musical Design, Systems Engineering
- Documento sorgente: [`docs/piani/attivi/World Tour .md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/World%20Tour%20.md) (Righe 979–1156, 1797–1823, 4224–4392, 5096–5246, 6008–6168, 7198–7392, 8266–8442)
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md)

---

## 1. OBIETTIVO DEL SISTEMA MUSICALE

Il sistema musicale è il cuore creativo di World-tour. Permette al giocatore di evolvere da semplice esecutore amatoriale ad autore maturo, offrendo scelte stilistiche, bivi di produzione e la gestione di un catalogo discografico che genera prestigio, ascolti ed entrate nel tempo.

---

## 2. LE 7 ABILITÀ ARTISTICHE (SKILL & PROGRESSIONE)

Ciascuna abilità è scalata da `0` a `100` con curva XP esponenziale (da [`SP-06`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/sottopiani/06_formule_matematiche_e_bilanciamento.md)):

1. **Voice (Canto)**: Timbro, intonazione, controllo del diaframma ed estensione. Cruciale per l'impatto emotivo delle linee melodiche.
2. **Instrument (Strumento)**: Precisione ritmica, velocità e pulizia esecutiva sullo strumento primario (Chitarra, Basso, Tastiera o Batteria).
3. **Songwriting (Scrittura Testi)**: Metrica, capacità evocativa e profondità dei testi. Determina l'affezione a lungo termine della fanbase.
4. **Composition (Composizione)**: Costruzione armonica, riff memorabili, dinamiche e arrangiamento dei ponti e ritornelli.
5. **Charisma (Carisma)**: Magnetismo personale e capacità di trasmettere emozione sia su disco che nei video promozionali.
6. **Performance (Presenza Scenica)**: Grinta dal vivo, tenuta atletica sul palco e interazione con il pubblico durante i live.
7. **Production (Produzione & Missaggio)**: Compressione, equalizzazione, bilanciamento dei volumi e mastering. Trasforma una buona idea in una traccia potente per le radio.

---

## 3. I 6 GENERI MUSICALI DELLA V1

Ciascun genere modella le aspettative del pubblico e il peso delle abilità nella qualità finale:

| Genere | Stile Dominante | Abilità Chiave | Pubblico Tipico / Mercato |
| :--- | :--- | :--- | :--- |
| **Rock** | Chitarre elettriche, energia e ritmo | Instrument, Composition, Performance | Appassionati fedeli, forte traino nei concerti live. |
| **Pop** | Melodia immediata, commercialità e pulizia | Voice, Songwriting, Production | Mercato di massa, streaming elevato, volatilità alta. |
| **Metal** | Velocità, distorsione e complessità | Instrument, Composition, Energy | Fanbase di ferro devota, vendite fisiche e magliette. |
| **Hip-Hop** | Ritmo serrato, rime e carisma vocale | Voice/Flow, Songwriting, Production | Streaming massiccio, viralità social e collaborazioni. |
| **Electronic** | Sintetizzatori, groove e sound design | Production, Composition, Rhythm | Club, DJ set, festival internazionali dance. |
| **Latin** | Poliritmie calde, ballabilità e calore | Rhythm, Voice, Charisma | Streaming estivo, radio generaliste e feste. |

---

## 4. LA PIPELINE DI CREAZIONE BRANO (IN 5 FASI)

La lavorazione di un brano è una sequenza tattica. Se il giocatore non ha tempo o fondi per completarla in un'unica giornata, il brano viene salvato come bozza (`DRAFT`) nel catalogo e ripreso successivamente.

```
[FASE 1: CONCETTO & STILE]
- Scelta Titolo (digitazione libera o generatore procedurale per genere)
- Scelta Genere e Direzione (es. "Melodica e Commerciale" vs "Aggressiva e Complessa")
        ↓
[FASE 2: COMPOSIZIONE & RIFF]
- Richiede 40s simulati | Consumo: 15 Energia | Influenza: Skill Composition
- Evento casuale: Ispirazione Improvvisa (Inspiration Burst) con bonus qualità
        ↓
[FASE 3: SCRITTURA TESTO]
- Richiede 30s simulati | Consumo: 10 Energia | Influenza: Skill Songwriting
- Scelta del tema (Amore, Ribellione, Melancolia, Successo, Notte)
        ↓
[FASE 4: REGISTRAZIONE TRACCE]
- Richiede 60s simulati | Consumo: 25 Energia | Influenza: Voice / Instrument
- Scelta del luogo: Home Studio (gratuito, max qualità cap 60) vs Studio Professionale (€50/ora, bonus +15)
        ↓
[FASE 5: MISSAGGIO & MASTERING]
- Richiede 30s simulati | Consumo: 15 Energia | Influenza: Skill Production
- Risultato finale: generazione scheda tecnica, Quality Score e Tratti Emergenti
```

---

## 5. I TRATTI EMERGENTI DEI BRANI (`SONG TRAITS`)

Al termine della produzione, ogni canzone ha una probabilità di sviluppare un tratto speciale che ne modifica le prestazioni commerciali e live:
- **`Earworm` (Tormentone)**: +25% agli ascolti radio e streaming nei primi 30 giorni.
- **`Cult Classic` (Pezzo Cult)**: Non esplode subito nelle classifiche, ma non invecchia mai; converte il doppio dei fan ai concerti.
- **`Stage Beast` (Bomba dal Vivo)**: Aumenta il Concert Score del 15% se inserita come chiusura della scaletta nei live.
- **`Audiophile Gem` (Gemma per Audiofili)**: Richiede Production $\ge 70$; recensioni osannanti dalle riviste di settore.
- **`Rough Diamond` (Diamante Grezzo)**: Ottima composizione ma registrazione sporca; ri-registrabile in futuro in un grande studio.

---

## 6. CATALOGO DISCOGRAFICO & FORMATI DI RELEASE

I brani completati risiedono nell'inventario del musicista e possono essere assemblati nei formati commerciali:
1. **Singolo (`Single`)**: 1 traccia di punta. Costo minimo di marketing, lancio rapido per farsi conoscere.
2. **EP (`Extended Play`)**: 3–5 tracce collegate. Ideale per la fase da Artista Emergente (T3/T4) per catturare l'attenzione dei club.
3. **Album (`Full-Length`)**: 8–12 tracce. Richiede mesi di lavoro; definisce la maturità artistica e abilita i tour nazionali.

### Ciclo Vitale Post-Pubblicazione
- `New Release` (Giorno 1–28): Picco di hype, inserimento in playlist streaming e recensioni.
- `Active Catalog` (Giorno 29–180): Entrate passive regolari calcolate a ogni fine giornata in base alla fanbase.
- `Legacy Catalog`: Tracce storiche che garantiscono un flusso di cassa costante a vita.

---

## 7. DESIGN VISIVO IN GODOT 4 & ACCESSIBILITÀ UNIVERSALE

### 7.1 Per Holy Diver (Grafica & UI Godot 4)
- **Scena Studio di Registrazione (`res://ui/studio/music_studio.tscn`)**:
  - Interfaccia a banco di missaggio con potenziometri e slider satinati per bilanciare Melodia, Ritmo e Grinta.
  - Indicatore grafico stile VU-meter ad aghi con luci verdi/gialle/rosse che oscillano a tempo durante la registrazione.
  - Scena catalogo brani (`song_catalog.tscn`) con visualizzazione a griglia di vinili/cassette con copertina colorata in base al genere.
- **Micro-Animazioni**: Quando un brano riceve il tratto `Earworm`, una piccola icona a forma di nota dorata scintillante appare sulla copertina.

### 7.2 Per Luca (Accessibilità Vocale & Comandi Tastiera NVDA)
- **Navigazione da Tastiera Lineare**:
  - Tasto rapido globale `M`: Apertura istantanea del Catalogo Brani con pausa automatica del gioco.
  - Tasto rapido `N`: Avvio guidato della creazione di una nuova canzone.
  - Navigazione elenco tracce con frecce `Su`/`Giù` ed annuncio sintetico immediato per NVDA:  
    `"1. 'Starlight Shadow' - Rock. Rilasciata Singolo. Qualità: 74/100. Tratto: Riff Memorabile. Ascolti: 14.500. Entrate totali: €420."`
  - Tasto `Invio`: Apertura menu contestuale brano (`Aggiungi a scaletta concerti`, `Ascolta anteprima sonora`, `Rilascia come singolo`).
  - Annuncio sonoro procedurale: breve arpeggio o sample ritmico di 2 secondi all'ascolto dell'anteprima.

---

## 8. CHECKPOINT DI CONFORMITÀ (GATING)

- [ ] `SP-03.1`: Definizione del modello dati `SongData` con attributi, tratti e stati di ciclo vitale.
- [ ] `SP-03.2`: Pipeline di creazione in 5 fasi implementata con salvataggio delle bozze intermedie.
- [ ] `SP-03.3`: Algoritmo di assegnazione dei tratti speciali dei brani funzionante.
- [ ] `SP-03.4`: Scena `music_studio.tscn` e `song_catalog.tscn` realizzate in Godot 4 per Holy Diver.
- [ ] `SP-03.5`: Scorciatoie `M`, `N` e navigazione con frecce collaudate al 100% con NVDA per Luca.
