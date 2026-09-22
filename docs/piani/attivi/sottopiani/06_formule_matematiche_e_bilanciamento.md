# Sottopiano 06 — Formule Matematiche e Bilanciamento

- ID Sottopiano: `SP-06`
- Versione: 1.1 — Ottimizzata per Gameplay, Robustezza Matematica e Architettura Godot 4
- Tema: Algoritmi di Progressione, Curve di Rendimento, Formule di Qualità, Calcolo Pubblico e Costanti Centralizzate
- Competenze di riferimento: Mathematical Modeling, Game Balancing, Algorithmic Engineering
- Documento sorgente: [`docs/piani/attivi/World Tour .md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/piani/attivi/World%20Tour%20.md) (Righe 4730–4771, 5643–6785)
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md)

---

## 1. PRINCIPI FONDAMENTALI DI BILANCIAMENTO

1. **Purezza Funzionale**: La classe `Formulas` (`res://core/formulas.gd`) è un modulo di calcolo matematico puro: zero variabili di stato, zero riferimenti alla UI o all'albero delle scene, zero side-effect.
2. **Anti-Grinding Matematico (Diminishing Returns Quotidiani)**: Ripetere la medesima azione nella stessa giornata applica un coefficiente di saturazione decrescente:
   - Prima sessione: 100% resa.
   - Seconda sessione: 70% resa.
   - Terza sessione o successive: 40% resa.
3. **Invariante di Sicurezza (Nessun Softlock)**: Il bilanciamento garantisce che nessuna combinazione sfortunata di eventi o calcoli possa bloccare la partita in uno stallo irreversibile (divisioni per zero, numeri negativi impossibili, azzeramento fondi senza possibilità di riscatto).
4. **Isolamento delle Costanti**: Tutti i parametri numerici risiedono in `Constants` (`res://core/constants.gd`) per consentire a Holy Diver e Luca di tarare il gioco senza modificare la logica di calcolo.

---

## 2. FORMULE MATEMATICHE FORMALI

### 2.1 Progressione XP per Livello di Abilità
Per ciascuna delle 7 abilità, l'esperienza totale necessaria per raggiungere il livello successivo $L+1$ partendo dal livello $L$ (da 1 a 99) è:

$$\text{XP\_Required}(L) = \text{round}\left(50.0 \times L^{1.35}\right)$$

| Livello Attuale | Livello Target | XP Necessari | Dedizione Stimata |
| :--- | :--- | :--- | :--- |
| Livello 1 | Livello 2 | 50 XP | 2–3 sessioni rapide di studio |
| Livello 5 | Livello 6 | 437 XP | 1–2 giornate di studio regolare |
| Livello 20 | Livello 21 | 2.845 XP | 1 settimana di esercizio e prove |
| Livello 50 | Livello 51 | 9.852 XP | 1 mese di intensa attività professionale |
| Livello 99 | Livello 100 | 25.418 XP | Maestria assoluta da leggenda della musica |

### 2.2 Formula del Guadagno XP dell'Allenamento
Dato un allenamento con durata $D$ (in secondi) e ripetizione $R$ (volte eseguita oggi):

$$\text{XP\_Gain} = \text{Base\_Action\_XP} \times \left(\frac{D}{10.0}\right)^{0.85} \times \text{Saturation\_Mod}(R) \times \text{Efficiency\_Factor}$$

- $\text{Saturation\_Mod}(1) = 1.0$, $\text{Saturation\_Mod}(2) = 0.70$, $\text{Saturation\_Mod}(3+) = 0.40$.

### 2.3 Formula dell'Efficienza (Freno da Stress & Morale)
Dati Stress $S \in [0, 100]$ e Morale $M \in [0, 100]$:

$$\text{Efficiency\_Factor} = \text{clamp}\left(\left(1.0 - \frac{S}{150.0}\right) \times \left(0.50 + \frac{M}{200.0}\right), 0.20, 1.30\right)$$

### 2.4 Formula della Qualità della Canzone (`Quality Score`)
Calcolata al completamento della produzione a partire dalle 4 abilità contributive e dal bonus studio:

$$\text{Skill\_Base} = (0.25 \times \text{Composition}) + (0.20 \times \text{Songwriting}) + (0.25 \times \text{Execution}) + (0.20 \times (\text{Production} + \text{Studio\_Bonus}))$$

$$\text{Quality\_Final} = \text{clamp}\left(\text{Skill\_Base} \times \left(0.85 + 0.30 \times \frac{M}{100.0}\right) + \text{Random\_Range}(-4.0, +4.0), 1.0, 100.0\right)$$

### 2.5 Formula dell'Affluenza al Concerto (`Audience`)
Data la capienza del locale $C$, la Popolarità dell'artista $P \in [0, 100]$, il Prestigio del locale $Pr \in [0, 100]$ e il Prezzo del biglietto $T$:

$$\text{Prestige\_Mod} = 0.80 + 0.40 \times \frac{Pr}{100.0}$$

$$\text{Ticket\_Ratio} = \frac{T}{\text{Fair\_Price}}, \quad \text{Ticket\_Penalty} = \text{clamp}(1.50 - 0.50 \times \text{Ticket\_Ratio}, 0.10, 1.20)$$

$$\text{Demand} = C \times \left(0.12 + 0.88 \times \frac{P}{100.0}\right) \times \text{Prestige\_Mod} \times \text{Ticket\_Penalty}$$

$$\text{Audience} = \min(C, \max(\text{Min\_Audience\_Default}, \text{floor}(\text{Demand})))$$

### 2.6 Formula del Risultato dello Spettacolo (`Concert Score`)
$$\text{Concert\_Score} = (0.30 \times \text{Performance}) + (0.25 \times \text{Charisma}) + (0.25 \times \overline{\text{Quality}}_{\text{setlist}}) + (0.10 \times \text{Energy\_Factor}) + \text{Random\_Range}(-5.0, +5.0)$$

### 2.7 Formula di Conversione Fan (`Fans Gained`)
$$\text{Conversion\_Rate} = \left(\frac{\text{Concert\_Score}}{100.0}\right)^{2.2} \times \left(0.15 + 0.35 \times \frac{\text{Charisma}}{100.0}\right)$$

$$\text{Fans\_Gained} = \text{floor}(\text{Audience} \times \text{Conversion\_Rate})$$

---

## 3. IL FILE DELLE COSTANTI CENTRALIZZATE (`CONSTANTS.GD`)

```gdscript
# res://core/constants.gd
class_name Constants
extends RefCounted

# Orologio e Tempo
const DAY_DURATION_SECONDS: float = 600.0
const OVERTIME_DURATION_SECONDS: float = 120.0
const SPEED_NORMAL: float = 1.0
const SPEED_FAST: float = 2.0
const SPEED_ULTRA: float = 5.0

# Risorse Vitali
const MAX_ENERGY: int = 100
const MAX_STRESS: int = 100
const MAX_MORALE: int = 100
const SLEEP_STANDARD_ENERGY: int = 70
const SLEEP_STANDARD_STRESS_RELIEF: int = 15
const OVERTIME_ENERGY_RESTORATION: int = 35
const OVERTIME_STRESS_PENALTY: int = 20

# Finanze e Sussistenza
const DAILY_FOOD_EXPENSE: float = 10.0
const DAILY_ROOM_RENT: float = 15.0
const TAXI_BASE_FARE: float = 25.0
const BUS_TICKET_PRICE: float = 2.0
const BANKRUPTCY_LIMIT: float = -2000.0

# Concerti e Pubblico
const MIN_AUDIENCE_DEFAULT: int = 3
```

---

## 4. DESIGN TECNICO IN GODOT 4 & SIMMETRIA

### 4.1 Per Holy Diver (Visual Graph & Tuning Panel)
- **Scena di Debug & Tuning Matematico (`res://ui/dev/balance_tuning.tscn`)**:
  - Grafici interattivi 2D generati dinamicamente con `Line2D` che tracciano la curva di salita XP e la curva di rendimento dell'audience al variare degli slider.
  - Possibilità per Holy Diver di testare istantaneamente il "feel" numerico spostando cursori a video prima di consolidare i valori.

### 4.2 Per Luca (Ispezione Audio-Vocale con NVDA)
- **Suite di Test Unitari Assertivi (`res://tests/test_formulas.gd`)**:
  - Test automatici eseguiti da riga di comando o in avvio di debug che verificano l'assenza di divisioni per zero, NaN e overflow su 10.000 iterazioni simulate.
  - Tasto rapido di debug `F10`: Annuncio vocale sintetico per NVDA dell'esito dei test matematici:  
    `"Verifica formule completata: 42 test superati con successo. Zero errori di calcolo rilevati."`

---

## 5. CHECKPOINT DI CONFORMITÀ (GATING)

- [ ] `SP-06.1`: Implementazione di `res://core/constants.gd` con tutte le costanti congelate.
- [ ] `SP-06.2`: Implementazione della classe pura `res://core/formulas.gd` con tutte le funzioni matematiche.
- [ ] `SP-06.3`: Scrittura della suite di test unitari `test_formulas.gd` con validazione di tutti i casi limite.
- [ ] `SP-06.4`: Verifica del bilanciamento economico iniziale e delle curve di conversione fan.
