# World-tour — Roadmap Modulare: Sezione 12

- File di origine: `docs/roadmap.md`
- Titolo: Architettura UI, Accessibilità NVDA & Sound Design
- Priorità Operativa: P12 - Interfaccia & Audio

---

## 12. ARCHITETTURA UI, ACCESSIBILITÀ NVDA & SOUND DESIGN

### 12.1 Architettura HUD a 5 Sezioni, Top Bar Permanente & Menu di Sistema Esc
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Modulo centrale: `ui/hud/hud.gd` e `ui/system_menu/system_menu_modal.gd`.
  - Top Bar Fissa Permanente: Calendario, orologio, risorse vitali (Energia, Stress, Morale), saldo bancario e controlli runtime sempre visibili e ancorati in alto.
  - Risoluzione viewport nativa: 1920x1080 ad alto contrasto per Holy Diver.
  - Comportamento gerarchico del tasto `Esc`:
    - Se una modale è aperta: chiude la modale attiva e torna all'HUD principale.
    - Se nessuna modale è aperta (a riposo nell'HUD): mette la simulazione in pausa e apre il `SystemMenuModal`.
  - Voci del Menu di Sistema: 1. Riprendi Partita, 2. Salva Partita (salvataggio atomico immediato con annuncio vocale per NVDA), 3. Impostazioni & Accessibilità, 4. Torna al Menu Principale.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Scheda riassuntiva di statistiche complessive di carriera consultabile direttamente dal menu di pausa.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 12.2 Selettore a 4 Macro-Aree & Conservazione dei 15 Tasti Rapidi Diretti
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Organizzazione delle 4 Macro-Aree tematiche (Tasti numerici `1`..`4`):
    - `1` Hub Personale (Personaggio `C`, Agenda `A`, Bilancio `B`, Viaggi `V`)
    - `2` Creazione & Produzione (Catalogo `M`, Nuovo Brano `N`, Produzione Album `P`)
    - `3` Carriera & Band (Concerti `L`, Band `G`, Tour `O`, Festival `F`, Social `Y`, Classifiche `H`, Industria `K`)
    - `4` Skills & Upgrades (Alloggi, Sala Prove, Negozio Strumenti, Hardware Studio `U`)
  - Conservazione integrale di tutti i 15 tasti rapidi alfabetici diretti storici per gli utenti esperti, garantendo navigazione istantanea senza sottomenu.
  - Isolamento atomico dei backdrop e gestione anti-sovrapposizione con `_hide_all_modals()`.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Supporto per comandi Numpad per navigazione veloce riga per riga.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 12.3 Bridge AccessibilityManager, AccessKit Nativo & Zero Mouse
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Autoload bridge: `autoload/accessibility_manager.gd`.
  - Comunicazione bidirezionale con NVDA tramite controller DLL nativo o fallback SAPI sintetico.
  - AccessKit nativo di Godot 4 per l'esposizione corretta dell'albero di accessibilità del sistema operativo.
  - Modalità Zero Mouse rigorosa: ogni schermata, elenco, cursore e pulsante è pilotabile al 100% da tastiera con focus ciclico, Tab, Frecce, Invio e Spazio.
  - Modalità Live Region (`ACCESSIBILITY_LIVE_POLITE` e `ACCESSIBILITY_LIVE_ASSERTIVE`) per messaggi urgenti a schermo.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Opzione per attivare una modalità di "Descrizione Dettagliata Narrativa" per ascoltare descrizioni di lore approfondite dei locali e delle città.
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

### 12.4 Sound Design, Priorità Acustica Anti-Mascheramento & Pausa Dinamica
- **Dettagli Tecnici & Meccaniche Già Implementate**:
  - Regola aurea di coesistenza: I suoni di gioco e ambientali sono calibrati a un volume sicuro lineare compreso tra 0.7f e 0.75f (`AUDIO_SAFE_VOLUME_LINEAR` = 0.75, corrispondente a -2.5 dB `AUDIO_MAX_VOLUME_DB`).
  - Ducking acustico automatico: Il volume scende al 40% (`AUDIO_DUCKING_RATIO` = 0.40) ogni volta che la voce di NVDA o del sintetizzatore sta pronunciando un testo a schermo, eliminando qualsiasi mascheramento vocale.
  - Pausa Dinamica: All'apertura di qualsiasi menu o modale, il tempo di gioco viene congelato per consentire a Luca di ascoltare e riflettere senza ansia da timer.
- **Direttrici di Espansione & Idee di Gameplay**:
  - Effetti sonori distintivi (Earcon / Audio Cues) per ciascuna macro-area (es. accordo di chitarra rock per l'area Live, rumore di mixer per la Produzione, campane per la domenica di classifica, applausi per la vittoria del #1).
- **Spazio per i Dettagli di Luca**:
  - *Note e idee*: 

---

