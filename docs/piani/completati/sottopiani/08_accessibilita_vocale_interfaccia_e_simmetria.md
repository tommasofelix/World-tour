# Sottopiano 08 — Accessibilità Vocale, Tastiera e Simmetria Universale

- ID Sottopiano: `SP-08`
- Versione: 1.1 — Ottimizzata per Simmetria Universale, Godot 4, Bridge NVDA e Zero Mouse
- Tema: Principio di Simmetria Bi-Direzionale, Integrazione Nativa NVDA, Navigazione Tastiera, Sonificazione e Co-Sviluppo Luca & Holy Diver
- Competenze di riferimento: Accessibility Engineering, Screen Reader Integration, Inclusive Game Design, Godot UI
- Documento sorgente: [`knowledge/01_accessibilita_vocale_e_interazione_tastiera.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/knowledge/01_accessibilita_vocale_e_interazione_tastiera.md), [`docs/report/ANALISI_E_CONSOLIDAMENTO_WORLD_TOUR.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/report/ANALISI_E_CONSOLIDAMENTO_WORLD_TOUR.md)
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md)

---

## 1. IL PRINCIPIO DI SIMMETRIA UNIVERSALE BI-DIREZIONALE

In World-tour la grafica visiva e l'accessibilità vocale sono due facce della stessa medaglia: coesistono in perfetta armonia senza degradarsi a vicenda:

1. **Dal Non Vedente al Normovedente (Il Ruolo di Holy Diver & Antigravity)**:
   - Interfaccia grafica moderna, rifinita, elegante e proporzionata in Godot 4.
   - Contrasti cromatici conformi agli standard WCAG AAA (minimo 4.5:1 per testo normale, 7:1 per elementi critici).
   - Reattività totale e comfort assoluto per il mouse (hover, drag-and-drop, animazioni delle barre e luci dinamiche).
2. **Dal Normovedente al Non Vedente (L'Inclusione Incondizionata per Luca)**:
   - **Zero Mouse per lo Sviluppo e il Gioco**: Il 100% dei menu, pulsanti, dialoghi e azioni deve essere controllabile da tastiera.
   - Integrazione nativa a latenza zero con lo screen reader **NVDA** (sintesi vocale parlata all'orecchio di Luca).
3. **Zero Conflitti**: La grafica visiva non ostacola mai la sintesi vocale e l'accessibilità non impoverisce l'estetica a monitor per Holy Diver.

---

## 2. MODULO `ACCESSIBILITY MANAGER` IN GODOT 4

Il nodo singleton Autoload `res://autoload/accessibility_manager.gd` coordina la comunicazione tra gli eventi di gioco e le tecnologie assistive:

### 2.1 Canale Semantico UIA Nativo & Canale Vocale Dedicato
1. **Canale Semantico Nativo (AccessKit in Godot 4.7.2)**:
   - Godot 4.7.2 espone direttamente l'albero dei controlli UI a Windows UI Automation tramite il driver nativo AccessKit (`--accessibility-driver accesskit`).
   - I controlli possiedono proprietà semantiche native (`accessibility_name`, `accessibility_description`, `accessibility_live`) lette direttamente da NVDA al passaggio del focus, senza necessità di hook invasivi.
2. **Canale di Annuncio Vocale Rapido (`AccessibilityManager`)**:
   - Gestito dall'Autoload `res://autoload/accessibility_manager.gd`.
   - Utilizza la sintesi SAPI / speech bridge per emettere messaggi di testo non vincolati al focus (es. avvisi di emergenza, annunci orologio).
3. **Modalità di Annuncio**:
   - `speak(text: String, interrupt: bool = true)`: Lettura con interruzione immediata per cambi di schermata o avvisi critici.
   - `speak_queued(text: String)`: Accodamento gentile di notifiche secondarie per non interrompere il parlato corrente.

### 2.2 Navigazione da Tastiera & Focus Management
- **Presa Automatica del Focus (`Auto-Focus`)**: Quando una nuova schermata o finestra modale si apre, il primo elemento interattivo riceve automaticamente `grab_focus()`.
- **Navigazione Lineare Standard**:
  - Tasti `Tab` / `Shift+Tab`: Spostamento ordinato in avanti e indietro tra i controlli.
  - Tasti `Freccia Su` / `Freccia Giù`: Scorrimento delle liste (brani, locali, scelte di dialogo).
  - Tasto `Invio` o `Spazio`: Attivazione del pulsante o opzione selezionata.
  - Tasto `Escape`: Chiusura finestre modali o attivazione della Pausa.
- **Scorciatoie Rapide a Cifra Singola (1–9)**:
  - In tutti i menu con elenchi numerati (scelta azioni, selezione locali, opzioni eventi), la pressione della cifra `1`–`9` attiva direttamente l'opzione corrispondente senza dover navigare con il Tab.

---

## 3. TABELLA DELLE SCORCIATOIE GLOBALI DEL GIOCO

| Tasto Rapido | Azione Eseguita | Annuncio Vocale NVDA di Esempio |
| :--- | :--- | :--- |
| **`Spazio` / `P`** | Pausa / Riprendi simulazione | `"Pausa"` oppure `"Simulazione attiva a velocità 1x"` |
| **`1`, `2`, `3`** | Imposta velocità simulazione (1x, 2x, 5x) | `"Velocità 2x"` |
| **`T`** | Annuncio orario e tempo residuo | `"Ore 16:40, Pomeriggio. Rimangono 2 minuti e 50 secondi alla mezzanotte."` |
| **`R`** | Annuncio rapido delle risorse vitali | `"Energia: 85%. Stress: 15%. Morale: 75%. Denaro: €520."` |
| **`K`** | Annuncio status carriera e progressione | `"Artista Locale. 1.250 fan. Prossimo livello a 1.500 fan."` |
| **`M`** | Apertura diretta catalogo musicale | `"Apertura catalogo: 4 brani presenti."` |
| **`B`** | Annuncio rapido bilancio economico | `"Saldo: €520. Spese fisse previste: €25. Autonomia: 20 giorni."` |
| **`D`** | Descrizione vocale dello scenario visivo | `"Ti trovi nel Red Pub. Locale caldo e rumoroso con circa 40 persone."` |

---

## 4. SONIFICAZIONE, AUDIO CUE & VOLUMI DI SICUREZZA

I segnali acustici offrono una mappa sensoriale complementare alla voce:
1. **Segnali Acustici Cruciali**:
   - `Audio Cue Inizio Azione`: Click meccanico nitido.
   - `Audio Cue Azione Completata`: Tono brillante di campana.
   - `Audio Cue Level-Up`: Arpeggio di trionfo melodico.
   - `Audio Cue Fine Corsa Lista`: Piccolo "bump" acustico quando si preme Freccia Giù sull'ultimo elemento di una lista, segnalando a Luca che l'elenco è terminato.
   - `Audio Cue Emergenza`: Respiro affannoso se l'energia scende sotto il 15%; battito cardiaco se lo stress supera l'80%.
2. **Volumi di Sicurezza Congelati**:
   - Il volume massimo degli effetti sonori e della colonna sonora è rigidamente tarato tra `0.70f` e `0.75f` (mai al 100%), garantendo che la voce di NVDA sia sempre nitida e dominante.
   - **Ducking Audio Automatico**: Durante qualsiasi annuncio vocale o finestra di dialogo aperta, la musica di sottofondo si abbassa automaticamente del 60% per tutta la durata del parlato.

---

## 5. DESIGN VISIVO PER HOLY DIVER (SINERGIA DI COPPIA)

- **Indicatore Visivo di Focus ad Alto Contrasto**:
  - Ogni elemento che riceve il focus della tastiera mostra un contorno luminoso fluorescente (Glow ciano o giallo ambra). In questo modo, mentre Luca naviga con la tastiera, Holy Diver può seguire perfettamente a monitor quale elemento è attivo in tempo reale.
- **Tipografia e Scalabilità**:
  - Font sans-serif moderni ad alta leggibilità con antialiasing pulito.
  - Spaziature generose tra i pulsanti per consentire un clic agevole anche con il mouse.

---

## 6. CHECKPOINT DI CONFORMITÀ (GATING)

- [x] `SP-08.1`: Integrazione del runtime Godot 4.7.2 con driver AccessKit verificata su Windows 11.
- [ ] `SP-08.2`: Meccanismo di auto-focus all'apertura delle schermate collaudato al 100%.
- [ ] `SP-08.3`: Tasti rapidi globali (`Spazio`, `1-3`, `T`, `R`, `K`, `M`, `B`, `D`) implementati e funzionanti.
- [ ] `SP-08.4`: Taratura dei volumi audio con ducking automatico all'attivazione della voce.
- [ ] `SP-08.5`: Indicatore visivo di focus visibile e contrastato a monitor per Holy Diver.
- [ ] `SP-08.6`: Collaudo finale congiunto: Luca gioca interamente da tastiera con NVDA mentre Holy Diver osserva e valida la grafica a monitor.
