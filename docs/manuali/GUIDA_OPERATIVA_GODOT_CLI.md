# Guida Operativa — Utilizzo di Godot Engine 4.x da Riga di Comando (Zero Mouse)

- Destinatario: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA)
- Assistente: Antigravity
- Posizione file: [`docs/manuali/GUIDA_OPERATIVA_GODOT_CLI.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/manuali/GUIDA_OPERATIVA_GODOT_CLI.md)
- Versione motore di riferimento: Godot Engine v4.7.2.stable.official.win64

---

## 1. INTRODUZIONE E PRINCIPI GUIDA

Questa guida fornisce le istruzioni operative per interagire con il motore **Godot Engine 4.7.2** esclusivamente tramite tastiera e riga di comando (**PowerShell**), garantendo la massima indipendenza, velocità di sviluppo e fruibilità con lo screen reader **NVDA**, senza dover utilizzare l'editor grafico visuale.

---

## 2. CONFIGURAZIONE DEI PERCORSI NEL TERMINALE

Il motore si trova nella cartella sincronizzata dei progetti. In PowerShell, puoi definire un alias o una variabile temporanea per invocare direttamente l'eseguibile console (che inoltra l'output testuale direttamente a stdout):

```powershell
$GodotConsole = "$env:OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe"
$GodotGui     = "$env:OneDrive\progetti dei frati\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64.exe"
```

---

## 3. COMANDI OPERATIVI FONDAMENTALI

### 3.1 Verifica Versione e Diagnostica
Per accertarsi che il motore risponda:
```powershell
& $GodotConsole --version
```
Output atteso: `4.7.2.stable.official.ed1daf0bf`.

### 3.2 Verifica Sintattica dei File GDScript (Senza Finestre Grafiche)
Prima di eseguire il gioco, puoi verificare se uno script contiene errori di sintassi o riferimenti errati con il flag `--check-only`:
```powershell
& $GodotConsole --headless --check-only -s percorso/dello/script.gd
```
Se il comando non restituisce errori ed esce con codice 0, lo script è formalmente valido.

### 3.3 Esecuzione di Script Singoli e Test Unitari (Headless Mode)
I test unitari delle formule logico-matematiche (es. XP, qualità brani, EventBus) possono essere eseguiti all'istante senza avviare la finestra grafica:
```powershell
& $GodotConsole --headless -s tests/test_formulas.gd
```
L'output di ogni `print()` viene letto direttamente riga per riga da NVDA nel terminale PowerShell.

### 3.4 Avvio del Gioco con Accessibilità Forzata
Per avviare il progetto di gioco aprendo la finestra grafica ma mantenendo la console agganciata per leggere log e avvisi in tempo reale, assicurando che AccessKit e NVDA siano sempre attivi:
```powershell
& $GodotConsole --path "c:\Users\nemex\OneDrive\Documenti\GitHub\World-tour" --accessibility always --accessibility-driver accesskit
```

---

## 4. FLAG UTILI PER L'ACCESSIBILITÀ E IL DEBUG

- `--accessibility <mode>`:
  - `auto`: Attiva AccessKit se uno screen reader è attivo nel sistema (comportamento di default).
  - `always`: Forza sempre l'albero di accessibilità UIA attivo.
  - `disabled`: Disattiva l'accessibilità (utile per benchmark visivi).
- `--accessibility-driver accesskit`: Specifica l'utilizzo del backend AccessKit nativo per Windows UI Automation.
- `--headless`: Esegue il motore senza inizializzare rendering video o finestre di sistema. Ideale per test automatici e validazioni logiche.
- `-d` oppure `--debug`: Attiva il debugger locale standard su stdout.
- `--quit-after <frames>`: Chiude automaticamente l'applicazione dopo un certo numero di frame (es. `--quit-after 1` per verifiche istantanee).

---

## 5. AUTOMAZIONE TRAMITE SCRIPT POWERSHELL

Nella cartella `tools/` del repository allestiremo tre script PowerShell per velocizzare la routine quotidiana:

1. **`tools/run.ps1`**:
   Avvia il gioco con console abilitata e accessibilità nativa forzata.
2. **`tools/test.ps1`**:
   Esegue la suite di test unitari in modalità headless e stampa il resoconto sul terminale.
3. **`tools/check.ps1`**:
   Scansiona tutti i file `.gd` del repository con `--check-only` per segnalare tempestivamente errori di compilazione o warning.
