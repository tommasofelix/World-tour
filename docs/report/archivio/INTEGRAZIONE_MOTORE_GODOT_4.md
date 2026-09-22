# Rapporto di Analisi, Verifica e Strategia Integrativa — Motore Godot Engine 4.x

- Autori del progetto: Luca & Holy Diver
- Assistente: Antigravity (Senior AI Pair Programmer & Software Engineer)
- Data: 2026-09-22
- Stato: Approvato e Verificato
- Riferimento Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md) (Fase 1: Preparazione Ambiente)

---

## 1. PREMESSA E OBIETTIVO

A seguito dell'assegnazione dei permessi di accesso nello spazio di lavoro per la cartella del motore grafico prescelto, è stata condotta una sessione di analisi diagnostica, verifica empirica da riga di comando ed elaborazione della strategia di integrazione tecnica per il progetto **World-tour**.

L'obiettivo è duplice:
1. Verificare l'effettivo runtime di Godot disponibile sulla macchina di sviluppo, la sua architettura e le capacità native.
2. Definire una strategia operativa che abiliti la **Simmetria Universale Bi-Direzionale**: massima accessibilità e indipendenza operativa da tastiera con screen reader NVDA per Luca (Zero Mouse), unitamente alla piena compatibilità con l'editor visivo e l'esperienza grafica contemporanea col mouse per Holy Diver.

---

## 2. VERIFICA AMBIENTE ED EVIDENZE EMPIRICHE

La verifica è stata effettuata direttamente tramite console PowerShell sull'eseguibile presente nel percorso indicato:

- **Percorso Cartella Motore**: `$env:OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\`
- **Eseguibili Rilevati**:
  - `Godot_v4.7.2-stable_win64.exe` (180,8 MB): Eseguibile principale con interfaccia grafica completa (editor e runtime di gioco).
  - `Godot_v4.7.2-stable_win64_console.exe` (198 KB): Eseguibile wrapper da console con reindirizzamento standard I/O (stdout/stderr), ideale per automazione CLI, headless test e pipeline accessibili da riga di comando.
- **Versione Ufficiale Rilevata**:
  - Stringa di versione: `4.7.2.stable.official.ed1daf0bf`
  - Architettura: 64-bit (`win64`), piattaforma Windows 11.
  - Esito del comando `--version`: Codice di uscita 0, runtime pienamente reattivo e funzionante.

---

## 3. SCOPERTA ARCHITETTURALE DI SVOLTA: NATIVE ACCESSKIT IN GODOT 4.7

Durante l'ispezione analitica dei flag CLI (`--help`) e delle API dei nodi `Control`, è emersa una novità tecnologica di fondamentale rilievo:

**Godot Engine 4.7 include nativamente l'integrazione con AccessKit!**

### Evidenze Tecniche Riscontrate:
1. **Flag CLI Nativi del Motore**:
   - `--accessibility <mode>`: Impostazioni disponibili: `['auto' (default: attivo se uno screen reader è in esecuzione), 'always', 'disabled']`.
   - `--accessibility-driver <driver>`: Driver disponibili: `['accesskit', 'dummy']`.
2. **Proprietà di Accessibilità Integrate nei Nodi `Control`**:
   L'ispezione dinamica della classe `Control` di Godot 4.7.2 ha confermato la presenza nativa delle seguenti proprietà e metodi di primo livello:
   - `accessibility_name`: Nome esposto allo screen reader.
   - `accessibility_description`: Descrizione di contesto o aiuto.
   - `accessibility_live`: Gestione delle Live Regions (per annunciare dinamicamente variazioni come l'orologio o il completamento delle azioni).
   - `accessibility_labeled_by_nodes` e `accessibility_described_by_nodes`: Relazioni associative semantiche tra nodi.
   - `accessibility_flow_to_nodes`: Ordine di lettura logico.
   - Metodi: `set_accessibility_name()`, `get_accessibility_name()`, `set_accessibility_live()`, `queue_accessibility_update()`.

### Valore Strategico per il Progetto:
Nelle versioni storiche di Godot, l'interfaccia grafica proprietaria su Vulkan/OpenGL era opaca per gli screen reader, imponendo lo sviluppo di wrapper esterni via DLL (`nvdaControllerClient.dll`).  
In **Godot 4.7.2**, grazie ad **AccessKit**, i controlli UI nativi di Godot vengono automaticamente mappati nell'albero **UI Automation (UIA)** del sistema operativo Windows. Di conseguenza, **NVDA è in grado di leggere e interagire nativamente con l'alberatura dell'interfaccia** purché i nodi `Control` siano valorizzati con i corretti descrittori semantici.

---

## 4. STRATEGIA INTEGRATIVA A 4 PILASTRI

Per massimizzare l'efficacia dello sviluppo congiunto tra Luca, Holy Diver e Antigravity, la strategia integrativa si articola in quattro pilastri:

### Pilastro 1 — Sviluppo Disaccoppiato e "CLI-First" per Luca (Zero Mouse)
- **Scrittura del Codice**: Tutto il codice GDScript, le configurazioni `project.godot` e i modelli dati (`.gd`, `.tres`, JSON) vengono creati e modificati tramite editor di testo accessibile (VS Code o pair programming con Antigravity).
- **Validazione Sintattica Immediata**: Tramite il wrapper console è possibile convalidare gli script senza aprire finestre grafiche:
  `Godot_v4.7.2-stable_win64_console.exe --headless --check-only -s script.gd`
- **Unit Test Headless**: I sistemi logici (formule matematiche, progressione XP, EventBus, salvataggio) vengono collaudati tramite script di test eseguiti in modalità headless con output diretto su terminale PowerShell, perfettamente leggibile da NVDA.
- **Workflow Visivo per Holy Diver**: Holy Diver può aprire `Godot_v4.7.2-stable_win64.exe` direttamente sulla cartella di progetto per comporre visivamente scene grafiche, posizionare sfondi, animazioni, palette cromatiche e curare l'ergonomia per il mouse. Poiché la logica risiede in classi separate (Clean Architecture), il lavoro visivo non impatta né rompe la logica di gioco.

### Pilastro 2 — Implementazione della Simmetria Universale UI
- **Navigazione Lineare da Tastiera**:
  - Ogni schermata definisce rigorosamente la catena di focus con `focus_next`, `focus_previous` e le relazioni direzionali (`focus_neighbor_*`).
  - Utilizzo dei tasti `Tab` / `Shift+Tab` e delle `Frecce Direzionali` per spostarsi tra controlli, con `Invio` o `Spazio` per l'attivazione.
  - Scorciatoie rapide da tastiera (tasti `1`–`9` e Numpad) per le azioni ricorrenti della routine quotidiana.
- **Semantica AccessKit Completa**:
  - Ogni bottone, cursore, riquadro di testo e indicatore di risorsa avrà sempre `accessibility_name` e `accessibility_description` impostati.
  - Le informazioni di stato critiche (orologio residuo, livello energia, cassa) saranno collegate a nodi con `accessibility_live = Control.ACCESSIBILITY_LIVE_POLITE` o `ASSERTIVE` per letture tempestive.
- **Supervisione Estetica e Accessibilità Visiva (Holy Diver)**:
  - Contrasto cromatico minimo 4.5:1 per testi standard e 7:1 per elementi chiave (conformità WCAG AAA).
  - Dimensioni dei caratteri scalabili e aree cliccabili generose per l'interazione col mouse.

### Pilastro 3 — Modulo `AccessibilityManager` e Ridondanza Ibrida
Pur beneficiando del supporto nativo di AccessKit, manterremo il modulo Autoload `AccessibilityManager` (`autoload/accessibility_manager.gd`) per garantire:
1. **Sonificazione dell'Interfaccia (Audio Cues)**:
   - Feedback acustici brevi e distintivi per: spostamento focus, avvio azione, scadenza orologio, completamento giornata, cambio livello carriera.
2. **Priorità Acustica e Anti-Mascheramento (Genoma Globale di Luca)**:
   - Volume della musica e degli effetti ambientali limitato a **0.7f – 0.8f** (mai 1.0f pieno).
   - Audio ducking automatico: abbattimento temporaneo del volume di sottofondo durante l'emissione vocale o gli allarmi di sistema.
3. **Canale Vocale Ridondante / Annunci Rapidi**:
   - Possibilità di emettere annunci istantanei tramite `DisplayServer.tts_speak()` o bridge dedicato qualora si desideri forzare la lettura vocale di un evento narrativo critico senza attendere il focus di NVDA.

### Pilastro 4 — Script di Automazione e Tooling Locale
Allestire nella cartella del repository degli script PowerShell di supporto:
- `tools/run_game.ps1`: Avvia il gioco in modalità finestra con flag `--accessibility always` e console attiva.
- `tools/test_headless.ps1`: Esegue la suite di test unitari automatici in modalità headless e restituisce l'esito a terminale.
- `tools/check_scripts.ps1`: Verifica la correttezza sintattica di tutti i file GDScript del progetto.

---

## 5. PIANO DI AGGIORNAMENTO ROADMAP

Con la verifica del motore Godot Engine v4.7.2 e la scoperta del supporto nativo AccessKit, la roadmap operativa in [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md) viene aggiornata:

- **Attività `F1.1` (Definizione ed installazione ambiente runtime)**: Da contrassegnare come completata `[x]`.
- **Prossima Attività `F1.2`**: Inizializzazione della struttura ad albero del progetto Godot 4 (`project.godot`, `core/`, `data/`, `systems/`, `autoload/`, `ui/`, `tests/`).

---

## 6. CONCLUSIONI E VERDETTO

L'integrazione di **Godot Engine 4.7.2** rappresenta la scelta ottimale per World-tour:
- Unisce la potenza grafica e la facilità di composizione visiva per Holy Diver alla solidità di scripting pulito e sviluppo CLI per Luca.
- La presenza nativa di **AccessKit** abbatte le barriere storiche di accessibilità del motore, rendendo World-tour un progetto pionieristico di videogame pienamente inclusivo fin dalle sue fondamenta architetturali.
