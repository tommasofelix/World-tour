# Sottopiano SP-15: Skills, Upgrade Hub & Strumentazione (Versione 5.0)

- Framework: ASTRALIS / World-tour V5.0
- Autori: Luca & Holy Diver
- Assistente: Antigravity
- Percorso file: `docs/piani/completati/sottopiani/15_skills_upgrade_hub_e_strumentazione.md`
- Stato: `[x] COMPLETATO E CONVALIDATO` — Upgrades Hub Implementato con 19/19 Suite Superate

---

## 1. OBIETTIVI & AMBITO

Questo sottopiano definisce l'architettura tecnica e le meccaniche di gioco per la **Macro-Area 4: Skills, Upgrade Hub & Strumentazione (`UpgradesModal`)** accessibile tramite il tasto rapido `U` o la quarta sezione dell'HUD di World-tour.

L'hub articola la crescita materiale e professionale del musicista e della band in 4 assi:
1. **Spazio Vitale & Alloggi (Lifestyle)**: Gestione traslochi e 4 livelli di residenza (Stanzetta 15€, Appartamento condiviso con la Band 25€ con ripartizione canone, Loft con sala prove 50€, Villa con studio 150€) con riscontri economici, bonus morale notturno e requisiti di carriera/band.
2. **Sala Prove Insonorizzata**: Trattamento acustico progressivo (Pannelli Fonoassorbenti Base 300 €, Insonorizzazione Professionale 800 €, Studio Acustico Perfetto & Lounge 2.000 €) con mitigazione dello stress delle prove e azione diretta "Sessione di Prove con la Band" (`BandSystem.hold_rehearsal_session()`).
3. **Negozio Strumenti Multicategoria con Comparatore**: 5 famiglie strumentali (Chitarre, Bassi, Batterie, Microfoni/Voce, Tastiere/Synth) con tier progressivi, visualizzazione comparativa con lo strumento posseduto (+Livello tecnica, +Carisma live, +Sinergia/stabilità band) e benefici estesi a tutto il gruppo.
4. **Hardware Home Studio & Registrazione**: 3 upgrade per l'home recording (Microfono condensatore 400 €, Preamplificatore valvolare 1.200 €, Banco analogico e suite mastering 3.500 €) con innalzamento progressivo del tetto esecutivo casalingo (da 60 a 75, 90, 100) e bonus di qualità discografica (`studio_bonus` da +0 a +15) a costo zero.

---

## 2. MODELLO DATI & COSTANTI (`UpgradeData`)

Il file `data/models/upgrade_data.gd` formalizza:
- Catalogo strumenti con categorie: `guitar`, `bass`, `drums`, `vocals`, `keyboards`.
- Struttura dati `InstrumentModel`:
  - `id: String`
  - `name: String`
  - `category: String`
  - `tier: int` (0: Starter, 1: Semi-Pro, 2: Pro Vintage, 3: Master Signature)
  - `cost: float`
  - `skill_bonus: int`
  - `charisma_bonus: int`
  - `band_synergy_bonus: float`
  - `description: String`
- Livelli Sala Prove (`RehearsalTier`):
  - Livello 0: Nessuna sala / Garage rumoroso (Stress prova +10)
  - Livello 1: Pannelli Fonoassorbenti Base (Costo 300 €, Stress prova +7, -30% affaticamento)
  - Livello 2: Insonorizzazione Professionale (Costo 800 €, Stress prova +4, +5% affinità band)
  - Livello 3: Studio Acustico Perfetto & Lounge (Costo 2.000 €, Stress prova 0, +8 morale, massima coesione)
- Livelli Hardware Studio (`StudioHardwareTier`):
  - Livello 0: Microfono Integrato (Cap esecutivo 60, studio_bonus 0)
  - Livello 1: Mic Condensatore & Interfaccia USB (Costo 400 €, Cap 75, studio_bonus 5)
  - Livello 2: Pre Valvolare & Monitor Studio (Costo 1.200 €, Cap 90, studio_bonus 10, +5 produzione)
  - Livello 3: Banco Analogico & Suite Mastering (Costo 3.500 €, Cap rimosso 100, studio_bonus 15)

---

## 3. IMPATTO SUI SISTEMI DI GIOCO

1. **`MusicSystem.record_tracks()`**:
   - Se `use_pro_studio == false`:
     - Il cap massimo su `base_exec` non è più bloccato a 60, ma diventa `[60, 75, 90, 100]` in base a `studio_hardware_tier`.
     - Viene applicato lo `studio_bonus` casalingo corrispondente `[0, 5, 10, 15]`.
     - Viene calcolato il bonus tecnico dello strumento primario posseduto dal protagonista.
2. **`BandSystem.hold_rehearsal_session()`**:
   - Azione di prova: consuma 15 energia.
   - Calcola lo stress generato in base a `rehearsal_tier`.
   - Incrementa l'affinità (+3/+5), il rispetto musicale (+4/+6) e riduce la tensione della band (-8/-15).
   - Aggiunge bonus di sinergia per strumenti avanzati posseduti dalla band.
3. **`LiveConcert` / `ConcertSystem`**:
   - Gli strumenti di fascia alta (Semi-Pro, Pro, Master) forniscono bonus al carisma e al punteggio finale del concerto (`Concert Score`).

---

## 4. SECONDA BARRA SUPERIORE & RISOLUZIONE

1. **Risoluzione 1920x1080**:
   - `project.godot`: `window/size/mode="maximized"`, `window/stretch/aspect="keep"`.
2. **Seconda Barra Superiore (`PanelPlayerOverview`)**:
   - Riorganizzata in formato lineare:
     `Città: [Città] | Status: [Carriera] | Livello: Scrittura testi Lv. X, Composizione Lv. Y, Strumento Lv. Z, Produzione Lv. K`
   - Aggiornamento dinamico in `hud.gd` con `_update_player_overview()`.

---

## 5. PIANO DI VERIFICA

1. Suite automatizzata headless: `tests/test_upgrades_system.gd` con 40+ asserzioni dedicate.
2. Esecuzione globale: `tools/test.ps1` per verificare 19/19 suite a 0 errori.
3. Collaudo vocale completo con NVDA.
