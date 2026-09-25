# World-tour — Piano Tecnico Formale: Revisione Interazioni Arredi, Modali & Adattamento Testo Pergamene
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-25
# Stato: [x] [CONVALIDATO CON SUCCESSO]
# File Piano: docs/piani/completati/PIANO_REVISIONE_INTERAZIONI_MODALI_E_TESTO_PERGAMENE.md
# Coordinatore Master: docs/todo.md
# Versione Target AVF: V5.6.1

---

## 🎯 1. OBIETTIVO E PERIMETRO DELL'INTERVENTO

Risolvere deterministicamente i problemi riscontrati nel loft:
1. **Sblocco delle Modali Aperte dagli Arredi (Chitarra, Porta, ecc.)**: correzione della visibilità del nodo radice `Modals` in `ApartmentHud` che impediva a `SongCreator`, `TravelModal`, `TourModal`, `FestivalModal` e `LiveConcert` di comparire a schermo, causando il blocco del protagonista Alex (`is_movement_locked = true`);
2. **Ciclo di Vita & Focus di `SongCreator`**: implementazione del metodo `open()` con reset brano, focus automatico su `edit_title` e annuncio vocale completo per NVDA;
3. **Adattamento del Testo nel Menu Interazioni**: eliminazione di qualsiasi fuoriuscita del testo dai bordi della pergamena tramite autowrap intelligente (`AUTOWRAP_WORD_SMART`), font size calibrato a 8 px, margini orizzontali ottimali, larghezza uniforme a 320 px e titoli d'azione compatti ed eleganti nel catalogo `ApartmentInteractions`;
4. **Verifica Rigorosa a 0 ms**: test automatici su tutte le funzioni degli arredi e su tutte le modali collegate.

---

## 🔍 2. ROOT CAUSE ANALYSIS (RCA) DETERMINISTICHE

1. **Causa Blocco Chitarra e Porta**:
   - In `ui/apartment_hud/apartment_hud.tscn`, il nodo genitore `[node name="Modals" type="Control"]` era salvato con proprietà `visible = false`.
   - In `apartment_hud.gd`, il metodo `open_modal(modal_node)` rendeva visibile il singolo figlio (es. `SongCreator.visible = true`), ma non impostava mai `Modals.visible = true`. Poiché il genitore era invisibile, l'intera finestra rimaneva nascosta al rendering e all'albero di input.
   - Contestualmente, `modal_opened.emit()` impostava `player.is_movement_locked = true` e `GameManager.open_menu()`. Non vedendo la modale e non potendo muoversi, il gioco risultava congelato.

2. **Causa Mancanza Focus in `SongCreator`**:
   - `open_modal()` invoca `modal_node.call("open")` se il metodo esiste. `SongCreator` non aveva il metodo `open()`, lasciando il focus nel vuoto.

3. **Causa Fuoriuscita Testo nel Menu Interazioni**:
   - I pulsanti in `interaction_menu.gd` avevano `autowrap_mode` disattivato, font size a 9 px e pergamena media/lunga larga solo 288–290 px con margini 26+26 px (spazio utile solo 236 px).
   - Testi come `[1] Accorda e pulisci strumento (5s)` (36 caratteri, ~315 px) eccedevano di 79 pixel a destra.

---

## 📐 3. SCOMPOSIZIONE IN NAMED CONTRACTS (D0..D4)

### 📦 CONTRATTO D0: Correzione Visibilità Contenitore Modali in `ApartmentHud`
- In `ui/apartment_hud/apartment_hud.tscn`:
  * Rimosso `visible = false` sul nodo radice `Modals`;
- In `ui/apartment_hud/apartment_hud.gd`:
  * In `open_modal(modal_node)`:
    ```gdscript
    if has_node("Modals"):
        $Modals.visible = true
    modal_node.visible = true
    ```
  * In `close_modal(modal_node)` e `hide_all_modals()`:
    * Se nessuna modale figlia in `_all_modals` è visibile, impostare `$Modals.visible = false` per non interferire con il click sul loft.

---

### 🎸 CONTRATTO D1: Sblocco e Focus di `SongCreator` e Modali Correlate
- In `ui/music/song_creator.gd`:
  * Implementato `func open() -> void`:
    ```gdscript
    func open() -> void:
        start_new_song()
        _update_stage_display()
        if edit_title:
            edit_title.grab_focus()
        AccessibilityManager.announce("Studio musicale aperto. Componi un nuovo brano. Titolo predefinito: %s. Premi Tab per navigare i parametri o Invio per iniziare." % edit_title.text, true)
    ```
- In `ui/apartment_hud/apartment_hud.gd`:
  * Collegati in `_connect_modal_signals()` i segnali `new_song_requested` ed `edit_song_requested` di `song_catalog_modal` a `open_modal(song_creator_modal)`;
  * Implementato `open()` anche in `live_concert.gd` e `song_catalog.gd` con grab focus sul primo elemento per coerenza e immediatezza con NVDA.

---

### 📜 CONTRATTO D2: Adattamento Testo & Layout Pergamena nel Menu Interazioni
- In `ui/interaction_menu/interaction_menu.tscn`:
  * `ContentMargin`: `margin_left = 20`, `margin_right = 20`, `margin_top = 28`, `margin_bottom = 28`;
- In `ui/interaction_menu/interaction_menu.gd`:
  * Ricalibrato `menu_size` con larghezza uniforme a **320 pixel** (spazio utile $320 - 40 = 280$ px):
    * Corta ($\le 2$ azioni): $320 \times 190$ px;
    * Media ($3..4$ azioni): $320 \times 400$ px;
    * Lunga ($\ge 5$ azioni): $320 \times 680$ px;
  * Sui pulsanti opzione:
    * `btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART`;
    * `btn.add_theme_font_size_override("font_size", 8)`;
    * StyleBox: `content_margin_left = 6`, `content_margin_right = 6`, `content_margin_top = 4`, `content_margin_bottom = 4`;
  * In `_on_option_selected(index)`:
    * Emettere `menu_closed.emit()` prima di `action_chosen.emit()` per notificare correttamente l'avvenuta chiusura del popup.

---

### 📝 CONTRATTO D3: Compattamento Titoli Azioni in `ApartmentInteractions`
Ottimizzati i titoli dei 10 arredi per mantenerli compatti, preservando al 100% l'indicazione della durata e la descrizione accessibile estesa per NVDA:
- Chitarra:
  * `guitar_inspect`: "Esamina chitarra"
  * `guitar_create`: "Componi brano"
  * `guitar_practice`: "Scale e riff (10s)"
  * `guitar_tune`: "Accorda e pulisci (5s)"
- Cucina:
  * `kitchen_espresso`: "Prepara espresso (5s)"
  * `kitchen_snack`: "Spuntino veloce (10s)"
  * `kitchen_clean`: "Riordina cucina (10s)"
- Divano:
  * `couch_sit`: "Relax da divano (5s)"
  * `couch_nap`: "Pisolino (15s)"
  * `couch_jam`: "Jam acustica (10s)"
- Giradischi:
  * `turntable_listen`: "Ascolta vinile (12s)"
  * `turntable_study`: "Studio produzione (10s)"
- Letto:
  * `bed_sleep`: "Dormi fino a domani"
  * `bed_rest`: "Riposo breve (8s)"
  * `bed_make`: "Rifai il letto (5s)"
- Arcade:
  * `arcade_play`: "Partita retrò (10s)"
  * `arcade_challenge`: "Sfida il record (15s)"
- Guardaroba:
  * `wardrobe_inspect`: "Esamina abiti"
  * `wardrobe_change_look`: "Cambiati il look (8s)"
- Cassa Attrezzi:
  * `toolbox_inspect`: "Esamina attrezzi"
  * `toolbox_check`: "Controllo cavi/jack (5s)"
  * `toolbox_maintain`: "Set-up chitarra (10s)"
- Porta NYC:
  * `door_inspect`: "Esamina skyline NYC"
  * `door_concert`: "Concerti live nei locali"
  * `door_tour`: "Pianificazione tournée"
  * `door_travel`: "Viaggia in altra città"
  * `door_festivals`: "Grandi Festival Estivi"
- Stereo:
  * `stereo_toggle`: "Accendi/Spegni Hi-Fi"
  * `stereo_radio`: "Radio Rock (8s)"

---

## 🧪 4. CONVALIDAZIONE HEADLESS A 0 MS & RISULTATI

- `tests/test_apartment_gameplay.gd`:
  * 271/271 asserzioni superate con 0 fallimenti e 0 errori a 0 ms.
  * Verifica visibilità `$Modals` dinamica.
  * Verifica apertura e chiusura di `SongCreatorModal`, `LiveConcertModal`, `TravelModal`, `TourModal`, `FestivalModal`.
  * Verifica autowrap word-smart e larghezza standard a 320 px delle pergamene.
- Suite globale `tools/test.ps1`:
  * 30/30 suite di test headless completate con successo con 0 errori a 0 ms.
  * Versione AVF consolidata: `V5.6.1`.
