# World-tour — Piano Tecnico Formale (Sotto-Fase 1A & 1B): Menu Interazioni Pixel Art & Azioni Multiple Arredi Loft NYC
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-25
# Stato: [x] [CONVALIDATO CON SUCCESSO] (Sotto-Fase 1B convalidata al 100% con 251 test superati a 0 ms)
# File Piano: docs/piani/completati/PIANO_MENU_INTERAZIONI_PIXEL_ART_APPARTAMENTO.md
# Coordinatore Master: docs/todo.md
# Versione Consolidata AVF: V5.6.0

---

## 🎯 1. OBIETTIVO E PERIMETRO DELL'INTERVENTO

Nel loft isometrico di New York (`scenes/apartment/apartment.tscn`), l'interazione con i 10 arredi presenti viene trasformata da singola azione istantanea ad un **sistema dinamico ad azioni multiple con durata temporale**, fedele al mockup pixel art di riferimento (`assets/img/gameplay/GUI/Menu_interazione/menu_interazione_example.jpeg`) e alle pergamene:
- `interazione_corta.png` (306x183 px, per 1-2 azioni)
- `interazione_media.png` (288x396 px, per 3-4 azioni)
- `interazione_lunga.png` (290x704 px, per 5+ azioni)

### 📌 Recepimento Direttive di Luca:
1. **Guardaroba (Prop 7)**: dedicato esclusivamente a **cambiarsi il look** (`cambiarsi_il_look()`), rimuovendo scorciatoie per Scheda Artista o Catalogo brani (già coperte dai tasti HUD `C` e `K`);
2. **Cassa Attrezzi (Prop 8)**: rimosso il punto 2 (*Gear Studio & Upgrades Hub*); il toolbox si concentra sulla manutenzione strumenti, verifica cablaggi e set-up;
3. **Durata Temporale delle Azioni**: ogni azione ha una **durata esplicita in secondi** (`duration_seconds`) gestita tramite `ActionSystem` ed integrata nel ciclo vitale e orario (`TimeSystem`). Durante l'azione, Alex entra nello stato `GAMEPLAY_BUSY`, il tempo avanza, compare l'indicazione di avanzamento e NVDA vocalizza avvio, durata ed esito con audio cue calibrato `<= 0.75f`.

---

## 🛡️ 2. PROTOCOLLO 12 — I 6 CANCELLI INVIOLABILI (INNER CODEX)

- **Cancello 1 (Rifiuto Patching Euristico & Root Cause Analysis)**:
  - Posizionamento dinamico dello scroll a schermo accanto all'arredo calcolato dalla camera con clamping di sicurezza (minimo 20 px dai margini viewport 1920x1080);
  - Selezione deterministica della texture pergamena in base al numero di opzioni (corta per 1-2, media per 3-4, lunga per 5+).
- **Cancello 2 (Hardware Grounding & Zero Mouse)**:
  - Navigazione 100% da tastiera (Frecce, Numpad 8/2, numeri 1..N, Invio, Esc) con speculare usabilità mouse (hover, click, cursore a manina).
- **Cancello 3 (Hitbox, Clearance Continua & Volumi Sicuri)**:
  - Menu su CanvasLayer; blocco movimento Alex durante il menu e durante le azioni a durata;
  - Earcons sonori congelati al limite salvavita `<= 0.75f` (-2.5 dB) con ducking acustico per non coprire NVDA.
- **Cancello 4 (Named Contracts D0..D6)**:
  - Scomposizione atomica in contratti indipendenti e verificabili.
- **Cancello 5 (Determinismo Headless & Zero ms)**:
  - Test seams headless a 0 ms senza ritardi artificiali né `OS.delay()`, simulando l'avanzamento tramite `update_action(delta)`.
- **Cancello 6 (Budget Token & Anti-Bloat Normativo)**:
  - Componente autonomo `InteractionMenuModal` e router compatto in `ApartmentHud`.

---

## 📐 3. SCOMPOSIZIONE ATOMICA IN NAMED CONTRACTS (D0..D6)

### 📦 CONTRATTO D0: Clean Sweep & Integrazione Asset Pixel Art
- Integrazione texture pergamena (`interazione_corta.png`, `interazione_media.png`, `interazione_lunga.png`) con importazione Texture2D pixel art lossless (Filter Nearest);
- Integrazione font pixel art `PressStart2P.ttf` ad alto contrasto per testi e numeri d'ordine;
- Verifica disponibilità earcons PCM procedurali (`UI_OPEN`, `MENU_FOCUS`, `BUTTON_CLICK`, `ACTION_COMPLETE`).

---

### 📋 CONTRATTO D1: Catalogo Azioni Multiple con Durata per i 10 Arredi
Ogni azione definisce `id`, `titolo`, `descrizione`, `durata_secondi`, `costo_energia`, `costo_denaro`, `delta_stress`, `delta_morale`, `xp_skill` e `tipo_azione` (TEMPO_REALE, MODALE, TOGGLE, ISPEZIONE):

1. **`couch` (Divano Vissuto & Relax)**:
   - `couch_inspect`: "Esamina divano" (Ispezione immediata nel Dialogue Box, 0s);
   - `couch_sit`: "Siediti e rilassati (5s)" (Durata: 5s, -12 stress, +5 morale, +5 energia);
   - `couch_nap`: "Schiaccia un pisolino (15s)" (Durata: 15s, +20 energia, -10 stress, avanza tempo virtuale);
   - `couch_jam`: "Jam acustica da divano (10s)" (Durata: 10s, -5 energia, +10 XP Composizione, 35% chance Scintilla Creativa).

2. **`guitar` (Chitarra Elettrica & Amplificatore)**:
   - `guitar_inspect`: "Esamina strumento" (Ispezione immediata, 0s);
   - `guitar_create`: "Componi nuovo brano" (Apre `SongCreatorModal`, 0s);
   - `guitar_practice`: "Esercizio scale e riff (10s)" (Durata: 10s, -10 energia, +20 XP Chitarra);
   - `guitar_tune`: "Accorda e pulisci strumento (5s)" (Durata: 5s, +5 Morale, manutenzione gear).

3. **`kitchen` (Cucina & Macchina Caffè)**:
   - `kitchen_inspect`: "Esamina cucina" (Ispezione immediata, 0s);
   - `kitchen_espresso`: "Prepara espresso bollente (5s)" (Durata: 5s, +15 energia, -5 stress);
   - `kitchen_snack`: "Spuntino energetico (10s)" (Durata: 10s, costo 3.50 €, +25 energia, +5 morale);
   - `kitchen_clean`: "Pulisci e riordina cucina (10s)" (Durata: 10s, -5 energia, +10 Morale).

4. **`turntable` (Giradischi & Vinili da Collezione)**:
   - `turntable_inspect`: "Esamina collezione vinili" (Ispezione immediata, 0s);
   - `turntable_listen`: "Ascolta vinile d'epoca (12s)" (Durata: 12s, +20 morale, -10 stress, 35% chance Scintilla Creativa);
   - `turntable_study`: "Analisi produzione musicale (10s)" (Durata: 10s, -5 energia, +15 XP Produzione).

5. **`bed` (Letto Singolo & Riposo)**:
   - `bed_inspect`: "Esamina letto" (Ispezione immediata, 0s);
   - `bed_sleep`: "Dormi fino a domani" (Trigger sonno notturno / Fine giornata immediato);
   - `bed_rest`: "Riposo breve (8s)" (Durata: 8s, avanza alla fascia oraria successiva, +15 energia);
   - `bed_make`: "Rifai il letto (5s)" (Durata: 5s, +5 Morale).

6. **`arcade` (Cabinato Arcade Vintage)**:
   - `arcade_inspect`: "Esamina cabinato" (Ispezione immediata, 0s);
   - `arcade_play`: "Partita retro-game (10s)" (Durata: 10s, +10 Morale, -5 Stress);
   - `arcade_challenge`: "Sfida il record personale (15s)" (Durata: 15s, azzardo arcade: 50% chance +25 morale, 50% -5 morale).

7. **`wardrobe` (Libreria Guardaroba — ESCLUSIVO CAMBIO LOOK)**:
   - `wardrobe_inspect`: "Esamina abiti & guardaroba" (Ispezione immediata dello stile attuale, 0s);
   - `wardrobe_change_look`: "Cambiati il look da palco (8s)" (Durata: 8s, Alex si cambia d'abito: +10 Morale, annuncio nuovo stile punk/rock/glam).

8. **`toolbox` (Cassa Attrezzi — MANUTENZIONE & SETUP STRUMENTI)**:
   - `toolbox_inspect`: "Esamina cassa attrezzi" (Ispezione attrezzi e cavi jack, 0s);
   - `toolbox_check`: "Controllo cavi e jack (5s)" (Durata: 5s, +5 XP Live, verifica integrità impianti);
   - `toolbox_maintain`: "Manutenzione & set-up chitarra (10s)" (Durata: 10s, -5 energia, +10 Morale, recupero usura gear).

9. **`door` (Porta d'Uscita per New York)**:
   - `door_inspect`: "Esamina porta & skyline NYC" (Ispezione immediata, 0s);
   - `door_concert`: "Concerto Live nei locali" (Apre `LiveConcertModal`);
   - `door_tour`: "Pianificazione Tournée" (Apre `TourModal`);
   - `door_travel`: "Viaggia in un'altra metropoli" (Apre `TravelModal`);
   - `door_festivals`: "I Grandi Festival Estivi" (Apre `FestivalModal`).

10. **`stereo` (Stereo & Casse Monitor da Studio)**:
    - `stereo_inspect`: "Esamina monitor studio" (Ispezione immediata diffusori, 0s);
    - `stereo_toggle`: "Accendi / Spegni Hi-Fi" (Toggle immediato con musica loft);
    - `stereo_radio`: "Radio Rock & Notizie (8s)" (Durata: 8s, +5 Morale, rassegna musicale).

---

## 🎨 CONTRATTO D2: Scena & Componente `InteractionMenu`
- Scena `res://ui/interaction_menu/interaction_menu.tscn` e script `interaction_menu.gd`:
  * Radice: `Control` ancorato a schermo in coordinate globali con clamping;
  * `TextureRect` di sfondo che carica dinamicamente `interazione_corta.png`, `interazione_media.png` o `interazione_lunga.png`;
  * Intestazione arredo in font `PressStart2P.ttf`;
  * Lista pulsanti opzioni numerati `[1]`, `[2]`, ... con durata visibile (es. `"[1] Prepara espresso (5s)"`);
  * Segnali: `action_chosen(prop_id: String, action_dict: Dictionary)` e `menu_closed()`.

---

## 🎧 CONTRATTO D3: Accessibilità Assoluta & Zero Mouse (Luca NVDA)
- **Apertura del menu**:
  * Focus trap sul menu, blocco movimento di Alex;
  * Annuncio NVDA:
    > "Menu interazione aperto: [Nome Arredo]. [N] azioni disponibili. Usa le Frecce Su e Giù o i numeri da 1 a [N] per scegliere, Invio per confermare, Esc per chiudere."
- **Navigazione ed esecuzione**:
  * Tasti numerici diretti `1`..`N` o `Numpad 1`..`N`: selezione immediata;
  * `Frecce Su/Giù` o `Numpad 8/2`: scorrimento con annuncio vocale riga per riga indicando nome, durata ed effetto;
  * `Invio` / `Spazio`: conferma ed esecuzione dell'opzione selezionata;
  * `Esc`: chiusura immediata con sblocco personaggio e annuncio *"Menu interazione chiuso"*;
  * Earcons audio a volume salvavita `<= 0.75f`.

---

## ⏱️ CONTRATTO D4: Esecuzione Temporale delle Azioni (`ActionSystem` & `ApartmentHud`)
- **Gestione delle azioni con durata**:
  * Quando viene scelta un'azione con `durata_secondi > 0`:
    1. Il menu interazione si chiude;
    2. Alex entra nello stato `GAMEPLAY_BUSY`;
    3. `ActionSystem.start_action(...)` avvia il cronometro dell'azione;
    4. Nel Dialogue Box in basso a sinistra compare l'indicatore di azione in corso (es. `"[AZIONE] Prepara espresso bollente... Durata: 5s"`);
    5. NVDA vocalizza: *"Avviata azione: [Nome]. Durata: [N] secondi."*;
    6. Al completamento: applicazione deterministica dei delta (Energia, Stress, Morale, XP), riproduzione earcon convalidato, annuncio vocale dell'esito e ritorno ad Alex in stato `GAMEPLAY_IDLE`.
- **Azioni modali (Concerti, Canzoni, Tour)**:
  * Aprono direttamente la modale corrispondente con pausa dinamica;
- **Azioni di ispezione**:
  * Mostrano immediatamente la descrizione narrativa nel Dialogue Box senza consumare tempo.

---

## 🧪 CONTRATTO D5: Suite di Test Headless a 0 ms (`test_apartment_gameplay.gd`)
- Estensione della suite di test headless con la **Sezione 5**:
  * Verifica caricamento e selezione corretta dello sfondo pergamena (corta/media/lunga);
  * Verifica configurazione azioni per tutti i 10 arredi;
  * Verifica del Guardaroba: presente esclusivamente l'azione di cambio look (`wardrobe_change_look`), assenza di modali esterne;
  * Verifica della Cassa Attrezzi: punto 2 rimosso, presenti manutenzione e controllo cavi;
  * Verifica della gestione durata temporale: avvio azione, simulazione `update_action(delta)`, completamento ed emissione segnali a 0 ms;
  * Zero regressioni sui test esistenti: 251 asserzioni superate al 100% con 0 errori a 0 ms.

---

## 📚 CONTRATTO D6: Living Documentation & Disciplina AVF
- Registrazione attività `F9.12` in `docs/todo.md`;
- Aggiornamento living documentation in `knowledge/01_accessibilita_vocale_e_interazione_tastiera.md` e `knowledge/05_game_design_e_vertical_slice.md`;
- Archiviazione del piano in `docs/piani/completati/`;
- Versionamento deterministico AVF `V5.6.0`.

---

## 🏁 4. ESITO DELLA VALIDAZIONE

La Sotto-Fase 1B è stata interamente completata con successo:
1. Suite headless `res://tests/test_apartment_gameplay.tscn` eseguita a 0 ms: **251/251 test superati, 0 falliti**.
2. Suite headless `res://tests/test_ui_audio_and_numpad_system.tscn` eseguita a 0 ms: **128/128 test superati, 0 falliti**.
3. Living documentation e `docs/todo.md` allineati alla versione consolidata AVF `V5.6.0`.
