# Piano Tecnico Operativo — Fase 2.5: Sistema di Localizzazione (i18n) & Menu Principale Simmetrico

- ID Piano: `P-F2.5`
- Autori del progetto: Luca & Holy Diver
- Assistente: Antigravity (Senior AI Pair Programmer & Software Engineer)
- Data: 2026-09-22
- Stato: Completato e Convalidato con successo (Verificato con collaudo congiunto NVDA/visivo e 96/96 test automatizzati)
- Coordinatore Master: [`docs/todo.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/todo.md) (Attività F2.5.1 $\rightarrow$ F2.5.5 completate)
- Fase di riferimento: Ponte architetturale tra Fase 2 (Vertical Slice V1.0) e Fase 3 (Ciclo Creativo)

---

## 1. Obiettivo della Fase Intermedia 2.5

Questa fase ponte introduce due componenti fondamentali di usabilità e architettura prima di iniziare il sistema musicale della Fase 3:

1. **Sistema di Localizzazione Bilingue (Italiano / Inglese)**:
   - Gestione delle stringhe dell'applicazione tramite file di testo strutturati (`localization/it.json` e `localization/en.json`).
   - Rilevamento automatico della lingua del sistema operativo al primo avvio (`OS.get_locale_language()`), con fallback a Inglese se non Italiano.
   - Integrazione nativa con il motore Godot (`TranslationServer`) e doppio canale di accessibilità: aggiornamento simultaneo delle etichette a monitor per utenti vedenti e dei nomi/descrizioni semantiche AccessKit per screen reader (NVDA).
   - Persistenza della lingua scelta dall'utente sia nella configurazione globale (`user://settings.json`) sia nel modello dati del personaggio (`PlayerData.language`).

2. **Menu Principale (Main Menu) & Schermata Impostazioni**:
   - Nuova scena di ingresso dell'applicazione (`ui/main_menu/main_menu.tscn`) configurata come `run/main_scene` in `project.godot`.
   - Layout simmetrico per utenti vedenti (grafica moderna, contrasto WCAG AAA) e non vedenti (auto-focus, navigazione lineare tastiera, scorciatoie).
   - Tre pulsanti principali:
     1. **Avvio Rapido (Test)**: lancia l'HUD della simulazione impostando lo stato di gioco su `GAMEPLAY_IDLE`.
     2. **Impostazioni**: apre il pannello delle impostazioni con il controllo della lingua tramite casella ad elenco (`OptionButton`) per alternare istantaneamente Italiano e Inglese.
     3. **Esci**: chiude l'applicazione in modo pulito.
   - **Navigazione Bidirezionale**: inserimento del pulsante "Menu Principale" nell'HUD per consentire il ritorno al menu di partenza in qualsiasi momento salvando la partita.

---

## 2. Decisioni Architetturali & Rationale Tecnico

### A. File JSON vs File CSV/PO per le Traduzioni
- **Scelta**: File JSON (`localization/it.json` e `localization/en.json`) caricati a runtime da un singleton `LocalizationManager` che registra gli oggetti `Translation` nel `TranslationServer` di Godot.
- **Motivazione**: I file CSV o PO in Godot richiedono la pipeline di import dell'editor grafico per generare risorse binarie `.translation`. I file JSON sono leggibili, modificabili direttamente da riga di comando o editor di testo, funzionano al 100% nei test headless da CLI (`tools/test.ps1`) e non soffrono di cache corrotte.

### B. Gestione a Doppio Livello della Persistenza Lingua
- **Livello Globale (`user://settings.json`)**: memorizza le impostazioni dell'applicazione (lingua, volumi audio) prima del caricamento di una partita, permettendo al Main Menu di avviarsi subito nella lingua preferita dell'utente.
- **Livello Scheda Personaggio (`player_data.gd`)**: campo `language: String` serializzato in `to_dict()` e `from_dict()`, garantendo che ciascun salvataggio ricordi la preferenza linguistica del musicista.

### C. Accessibilità Simmetrica (AccessKit + NVDA + Sonificazione)
- All'attivazione del cambio lingua, `LocalizationManager` emette il segnale `EventBus.language_changed`.
- `AccessibilityManager` intercetta l'evento e:
  1. Aggiorna la voce TTS preferita (`DisplayServer.tts_get_voices()`) allineandola alla lingua scelta.
  2. Aggiorna i testi semantici AccessKit (`set_accessibility_name`, `set_accessibility_description`) di tutti i controlli attivi.
  3. Vocalizza l'annuncio di conferma ("Lingua impostata su: Italiano" / "Language set to: English").

---

## 3. Risultati dei Test e Collaudo

- **Verifica Sintattica (`tools/check.ps1`)**: 19 file verificati su 19, 0 errori.
- **Suite di Test Formule (`test_formulas.gd`)**: 24/24 superati.
- **Suite di Test Localizzazione (`test_localization.gd`)**: 29/29 superati.
- **Suite di Test Vertical Slice (`test_vertical_slice.gd`)**: 43/43 superati.
- **Totale Test**: 96 superati su 96 (100% verde).
- **Collaudo Manuale Congiunto**: superato sul campo da Luca con NVDA/tastiera e Holy Diver a monitor con persistenza verificata su `settings.json`.
