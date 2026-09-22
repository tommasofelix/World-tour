# Sottopiano 01 — Game Design, Visione e Progressione

- ID Sottopiano: `SP-01`
- Versione: 1.1 — Ottimizzata per Gameplay, Tecnica e Motore Godot
- Tema: Visione d'insieme, Archetipi di Carriera, Matrice di Sblocco, Condizioni di Fine Partita e Presentazione Visiva/Vocale
- Competenze di riferimento: Game Design, Creative Direction, Narrative & Systems Architecture
- Documento sorgente: [`docs/piani/attivi/World Tour .md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/World%20Tour%20.md) (Righe 1–382, 2408–2544, 3174–3437, 4569–4624)
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md)

---

## 1. OBIETTIVO E HIGH CONCEPT

Il giocatore veste i panni di un aspirante musicista che parte da zero assoluto in una cameretta di periferia e costruisce progressivamente la propria carriera artistica e professionale fino allo status di **Superstar Mondiale**.

### Principi Inviolabili di Design
1. **Libertà Espressiva Assoluta**: Il gioco non impone quale genere suonare o quale destino seguire. L'origine geografica e sociale influenza il punto di partenza, non il destino finale.
2. **Nessuna Crescita Lineare Obbligatoria**: Il successo non è un contatore numerico che sale in modo banale. La carriera attraversa fasi di picco, momenti di stasi creativa e scelte di rottura.
3. **Scelte con Tradeoff Reali (Risk vs Reward)**: Ogni decisione comporta un costo d'opportunità tangibile (suonare in un locale malfamato paga subito ma logora il morale ed espone a risse; incidere in uno studio costoso indebita ma alza il valore del master).
4. **Disaccoppiamento tra Qualità e Notorietà**: Il valore artistico fidelizza la fanbase reale; la popolarità commerciale riempie le sale occasionali.
5. **Principio di Simmetria Universale Bi-Direzionale**: L'esperienza deve risultare visivamente spettacolare, moderna e reattiva al mouse per Holy Diver e i giocatori vedenti, e contemporaneamente controllabile al 100% da tastiera con audio e sintesi vocale NVDA per Luca.

---

## 2. I 3 ARCHETIPI DI CARRIERA (STILI DI GIOCO & PLAYER AGENCY)

Per evitare percorsi obbligati e garantire un'alta rigiocabilità, il design supporta tre macro-stili emergenti:

### A. L'Animale da Palco (`The Live Beast`)
- **Focus**: Performance, Charisma, esibizioni dal vivo frequenti nei locali e tournée serrate.
- **Dinamica economica**: Incassi immediati dalla vendita dei biglietti e dalle consumazioni.
- **Fanbase**: Crescita rapida a livello territoriale, pubblico caloroso e fidelizzato.
- **Rischio principale**: Forte logorio fisico (esaurimento energia) e rischio burnout da viaggio continuo.

### B. Il Perfezionista di Studio (`The Studio Craftsman`)
- **Focus**: Composition, Songwriting, Production, perfezionamento ossessivo delle registrazioni.
- **Dinamica economica**: Entrate passive da streaming, vendite fisiche e royalties discografiche.
- **Fanbase**: Fan esigenti che apprezzano la complessità e la profondità dei singoli brani.
- **Rischio principale**: Costi elevati di studio e rischio di rimanere dimenticati dal vivo se non si rilasciano tracce regolarmente.

### C. Il Ribelle di Tendenza (`The Trendsetter`)
- **Focus**: Originalità estrema, presenza scenica magnetica, provocazione mediatica e networking sociale.
- **Dinamica economica**: Sponsorizzazioni, attenzione dei media e cachet per eventi speciali.
- **Fanbase**: Pubblico giovane ed espansivo, incline alla viralità online.
- **Rischio principale**: Volatilità della fama (le mode passano in fretta) e conflitti etici con la reputazione di settore.

---

## 3. LA MATRICE DEGLI 8 LIVELLI DI STATUS (REQUISITI DI SBLOCCO)

La transizione tra gli stadi di carriera è regolata da soglie quantitative e qualitative esplicite:

| Livello | Denominazione Status | Fan Minimi | Popolarità Minima | Brani Minimi / Qualità Media | Locali Accessibili |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **T1** | `Beginner` (Nessuno) | 0 | 0% | 0 brani / Qualsiasi | Garage / Sala Prove |
| **T2** | `Amateur` (Amatoriale) | 50 | 5% | 1 demo / Qualità $\ge 20$ | Piccoli Bar diurni |
| **T3** | `Emerging` (Emergente) | 300 | 15% | 2 singoli / Qualità $\ge 35$ | Pub serali e birrerie |
| **T4** | `Local Hero` (Eroe Locale) | 1.500 | 30% | 1 EP (3 brani) / Qualità $\ge 50$ | Club live di quartiere |
| **T5** | `National Act` (Nazionale) | 15.000 | 50% | 1 Album / Qualità $\ge 65$ | Teatri e Club storici |
| **T6** | `International Act` (Estero) | 100.000 | 70% | 2 Album / Qualità $\ge 75$ | Palazzetti e Festival |
| **T7** | `Global Star` (Star Mondiale) | 1.000.000 | 85% | 3 Album / Qualità $\ge 85$ | Arene internazionali |
| **T8** | `Superstar` (Leggenda) | 10.000.000 | 95% | Catalogo storico / Qualità $\ge 90$ | Stadi mondiali |

---

## 4. CONDIZIONI DI VITTORIA E FALLIMENTO (GAME OVER / VICTORY)

### 4.1 Condizioni di Vittoria (`Victory Conditions`)
La partita principale si considera vinta al raggiungimento dello stato di **Superstar Mondiale** (Livello T8), con il soddisfacimento congiunto di:
1. Almeno 10.000.000 di fan registrati.
2. Almeno un concerto sold-out in uno Stadio internazionale con Concert Score $\ge 90$.
3. Patrimonio netto personale $\ge$ €1.000.000.
- *Post-Vittoria*: Accesso alla modalità libera "Endgame & Legacy" (continuare a suonare, produrre nuovi talenti, gestire la propria etichetta).

### 4.2 Condizioni di Fallimento Critico (`Game Over Conditions`)
Il gioco non è privo di rischi reali. Il fallimento si verifica in due circostanze:
1. **Bancarotta Irreversibile**: Saldo finanziario inferiore a -€2.000 per più di 14 giorni consecutivi senza possibilità di stipulare prestiti o coprire i costi fissi.
2. **Burnout Creativo / Collasso Fisiologico**: Livello di Stress a 100 per 10 giorni consecutivi con Energia a zero, che porta al ricovero forzato e al ritiro temporaneo dalle scene con perdita di tutti i contratti attivi.
- *Valvola di Salvataggio V1*: Nelle prime fasi (T1–T2), la famiglia o un amico possono intervenire una tantum per salvare l'artista dal baratro, con forte perdita di morale.

---

## 5. DESIGN DELL'INTERFACCIA IN GODOT 4 & SIMMETRIA UNIVERSALE

### 5.1 Per Holy Diver (Visual Design & Godot 4 UI)
- **Scena di Dashboard Carriera (`res://ui/career/career_dashboard.tscn`)**:
  - `CareerProgressBar`: TextureProgressBar stilizzata a forma di traccia audio o manico di chitarra con 8 nodi luminosi corrispondenti agli 8 status.
  - `StatusCard`: Riquadro centrale moderno con font ad alto contrasto, bordo arrotondato e badge illustrato (icona cassetta vintage per Amateur, vinile dorato per Local Hero, disco di platino per Superstar).
  - Colori tematici definiti nel tema globale `theme_world_tour.tres` con contrasti WCAG conformi (minimo 4.5:1).
  - Hover ed effetti visivi morbidi all'avvicinamento del cursore del mouse.

### 5.2 Per Luca (Audio & Screen Reader Integration)
- **Navigazione Rapida da Tastiera**:
  - Tasto rapido `K` (o `F2`): Annuncio immediato a voce dello stato di carriera, senza necessità di aprire menu complessi.
  - Output vocale NVDA (formato lineare e sintetico):  
    `"Status: Artista Locale. Fan: 1.250 su 1.500 necessari per Eroe Locale. Popolarità: 28%. Obiettivo brano: manca 1 EP con qualità almeno 50."`
  - Feedback sonoro di Level Up: Arpeggio trionfale all'avanzamento di livello di carriera con volume protetto a 0.75f e ducking automatico della musica.

---

## 6. ROADMAP OPERATIVA EVOLUTIVA (V1.0 – V5.0)

- **V1.0 (Minimum Viable Game)**: Carriera solista, livelli T1 $\rightarrow$ T4 (fino a Eroe Locale nei club di quartiere), loop giornaliero solido e persistenza.
- **V2.0 (Band & Espansione)**: Livelli T4 $\rightarrow$ T5 (Nazionale), formazione del gruppo, dinamiche tra musicisti, EP e Album completi.
- **V3.0 (Industria & Major)**: Livelli T5 $\rightarrow$ T6 (Internazionale), contratti discografici, manager, booking e scandali etici.
- **V4.0 (Mondo Dinamico)**: Livelli T6 $\rightarrow$ T7 (Star Mondiale), festival estivi continentali, tour mondiali, rivali e social media.
- **V5.0 (Superstar & Legacy)**: Livello T8 (Stadi), vertice della celebrità, filantropia e modalità Legacy storica.

---

## 7. CHECKPOINT DI CONFORMITÀ (GATING)

- [ ] `SP-01.1`: Definizione formale degli 8 livelli di status e delle formule di transizione nel codice (`career_data.gd`).
- [ ] `SP-01.2`: Implementazione delle condizioni di Game Over e Vittoria nel `GameManager`.
- [ ] `SP-01.3`: Realizzazione della scena `career_dashboard.tscn` in Godot 4 con grafica per Holy Diver.
- [ ] `SP-01.4`: Implementazione della scorciatoia vocale `K` con annuncio immediato NVDA per Luca.
- [ ] `SP-01.5`: Collaudo congiunto della progressione di carriera (Luca alla tastiera, Holy Diver al monitor).
