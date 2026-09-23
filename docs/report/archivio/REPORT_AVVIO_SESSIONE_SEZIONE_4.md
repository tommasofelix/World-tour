# Report di Handoff & Bootstrap — Avvio Sezione 4: Strumenti Musicali, Sala Prove, Home Studio & Upgrades Hub
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA) & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-23
# Percorso File: docs/report/REPORT_AVVIO_SESSIONE_SEZIONE_4.md
# File di Riferimento: docs/roadmap/04_strumenti_sala_prove_home_studio_e_upgrades.md
# Priorità: P4 — Crescita Materiale, Hardware, Studio & Infrastrutture

---

## 🎯 1. OBIETTIVO DEL DOCUMENTO

Questo documento costituisce il **Report di Bootstrap & Handoff** per l'avvio formale della **Sezione 4 della Roadmap Modulare** di **World-tour** ("Strumenti Musicali, Sala Prove, Home Studio & Upgrades Hub").
Fornisce la mappatura completa dei requisiti tecnici, lo stato dell'arte consolidato del codebase (con 23/23 suite di test headless convalidate con 0 errori), l'inventario delle meccaniche già abbozzate in F9.1 e l'architettura dei contratti formali da implementare nella Sotto-Fase 1A.

---

## 🏛️ 2. STATO DELL'ARTE DEL PROGETTO (BASELINE DI PARTENZA)

1. **Sezioni 1, 2 e 3 Completate e Archiviate al 100%**:
   - **Sezione 1 (Identità, Routine & Risorse)**: Creazione personaggio guidata, ciclo notte espanso a 22h con overtime progressivo, skip time, riposo anticipato, triade risorse vitali (Energia, Stress, Morale), stati di burnout/panico e modale `RelaxModal` (tasto `R`).
   - **Sezione 2 (Creatività Musicale & Produzione)**: 10 Temi Lirici con modello `LyricThemeData`, matrice di affinità genere/città, 3 tratti canzone specializzati (`GENERATIONAL_ANTHEM`, `TEARJERKER_BALLAD`, `EPIC_RIFF`), sconto Martedì del 20% sullo studio professionale, calibrazione hardware home studio, rielaborazione bozze e annunci vocali dinamici per NVDA in `SongCreator`, `SongCatalog` e `AlbumCreator`.
   - **Sezione 3 (La Band, Reclutamento & Dinamiche Relazionali)**: Inclusione del Cantante (`VOCALS`) per il quartetto completo (5 ruoli strumentali), 8 personalità psicologiche con tratti `MERCENARY`, `STAGE_ANXIOUS`, `NATURAL_LEADER`, `PEACEMAKER`, bacheca audizioni con rifiuto deterministico su divario abilità/reputazione, calcolo compatibilità avanzata, boost front-man vocale su Sinergia Palco live, prove di gruppo con modificatori pacificatore/perfezionista, reazioni differenziate al Revenue Split (risentimento predatorio), allineamento bilingue dizionari (259 chiavi) e accessibilità NVDA in `BandHub`.
2. **Integrità del Codice & Suite Headless (23 / 23 Suite Superate — 0 Errori)**:
   - Tutte le 23 suite di test del progetto sono convalidate con esito 100% verde (oltre 1.260 asserzioni complessive verificate, 0 fallimenti, runner headless protetto da watchdog timeout a 15 secondi in `tools/test.ps1`).
3. **Integrità Documentale & Working Tree Git**:
   - Working tree Git: **100% pulito** (nessuna modifica pendente).
   - Disciplina di Versionamento AVF: **V4.3.0** consolidata.
   - Piani attivi (`docs/piani/attivi/`): pulita (pronta ad accogliere il Piano Sezione 4).
   - Registro Revisioni (`docs/report/REGISTRO_REVISIONI.md`): 0 anomalie aperte. Tutte le RCA storiche censite in `knowledge/09_registro_bug_e_soluzioni.md` (`BUG-001`..`BUG-004`).

---

## 🎸 3. AMBITO DELLA SEZIONE 4: STRUMENTI, SALA PROVE, HOME STUDIO & UPGRADES

Il documento specialistico di riferimento è [`docs/roadmap/04_strumenti_sala_prove_home_studio_e_upgrades.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/roadmap/04_strumenti_sala_prove_home_studio_e_upgrades.md).
La sezione si articola in 4 pilastri tecnici:

### 4.1 Negozio Strumenti Multicategoria, Comparatore & Dotazione Band
- **5 Famiglie Strumentali**: Chitarre (`guitar`), Bassi (`bass`), Batterie (`drums`), Microfoni/Voce (`vocals`), Tastiere/Synth (`keyboards`).
- **4 Tier di Qualità**: Tier 0 (Starter, 0 €), Tier 1 (Semi-Pro), Tier 2 (Pro Vintage), Tier 3 (Master Signature).
- **Comparatore Dinamico Differenziale**: Calcolo e vocalizzazione istantanea delle differenze (+Tecnica, +Carisma, +Sinergia Band, differenziale di costo) tramite `UpgradeData.compare_instruments()`.
- **Equipaggiamento per la Band**: Possibilità per il protagonista di acquistare o assegnare strumenti di livello superiore ai compagni di band reclutati, elevando la loro efficacia scenica e la Sinergia Palco complessiva.
- **Sound Shaping & Profilo Sonoro**:
  * Pedali d'effetto e pedalboard (Overdrive, High-Gain Distortion, Chorus, Tape Delay, Wah-Wah) con bonus di affinità al genere musicale eseguito.
  * Tipologia amplificatori (Valvolare Britannico con calore/saturazione per Rock/Indie vs Pulito Americano cristallino per Pop/Metal).

### 4.2 Insonorizzazione della Sala Prove, Vicinato & Gestione Ambientale
- **4 Livelli di Trattamento Acustico (`UpgradeData.RehearsalTier`)**:
  * Tier 0: *Garage Rumoroso* (0 €, +10 Stress prova, nessun bonus);
  * Tier 1: *Pannelli Fonoassorbenti Base* (300 €, +7 Stress prova, -30% affaticamento fisico);
  * Tier 2: *Insonorizzazione Professionale* (800 €, +4 Stress prova, +5% Affinità Band);
  * Tier 3: *Studio Acustico Perfetto & Lounge* (2.000 €, 0 Stress prova, +8 Morale, massima coesione).
- **Azione Rapida Prove Band**: Pulsante diretto "Fai una Prova con la Band" integrato nella modale Upgrades.
- **Eventi di Disturbo della Quiete Pubblica**: Rischio deterministico di reclami dei vicini o intervento delle forze dell'ordine con sanzione economica (100 - 300 €) se si prova ad alto volume in orario serale/notturno in sale non insonorizzate (Tier 0 o 1). L'insonorizzazione funge da barriera protettiva permanente.
- **Reddito Passivo Sub-Affitto**: Possibilità opzionale per sale avanzate (Tier 2 e 3) di sub-affittare lo spazio ad altre formazioni locali quando la band non prova, generando entrate economiche settimanali.

### 4.3 Hardware Home Studio & Filosofia di Registrazione
- **4 Livelli di Hardware Studio (`UpgradeData.StudioHardwareTier`)**:
  * Tier 0: *Microfono Integrato Base* (0 €, Cap Esecuzione 60, Studio Bonus +0);
  * Tier 1: *Microfono a Condensatore & Interfaccia USB* (400 €, Cap Esecuzione 75, Studio Bonus +5);
  * Tier 2: *Preamplificatore Valvolare & Monitor da Studio* (1.200 €, Cap Esecuzione 90, Studio Bonus +10);
  * Tier 3: *Banco Mixer Analogico & Suite Mastering* (3.500 €, Cap Esecuzione 100, Studio Bonus +15).
- **Impatto Matematico Diretto in `MusicSystem.record_tracks()`**: Il cap e il bonus hardware determinano la qualità del master casalingo.
- **Scelta della Filosofia di Registrazione**:
  * *Analogico su Nastro Magnetico*: costo aggiuntivo bobine/nastro, timbro caldo e organico, bonus di produzione per generi Rock e Indie.
  * *Digitale High-Definition*: suono chirurgico, pulito e definito, ideale per produzioni Pop, Elettronica e Metal moderno.

### 4.4 Usura, Manutenzione Liuteria & Strumenti di Riserva ("Muletti")
- **Condizione & Usura Strumenti**: Tracciamento dello stato di integrità dell'equipaggiamento attivo (`condition` 0 - 100%). L'uso intensivo durante concerti dal vivo e prove riduce progressivamente l'affidabilità.
- **Rischio Incidenti Live (Stage Accidents)**: Se la condizione scende sotto la soglia critica (< 40%), aumenta esponenzialmente la probabilità di rottura corde o guasto ai jack/pick-up durante lo show, con penalità di performance.
- **Liutaio di Fiducia**: Servizio professionale accessibile dalla modale per manutenzione ordinaria (cambio corde ed intonazione, 30 €) o rettifica completa liuteria (80 €) per ripristinare la condizione al 100%.
- **Strumenti Muletto nel Baule**: Possibilità di portare uno strumento di riserva nel van/tour bus per azzerare istantaneamente il rischio di interruzione del live.

### 4.5 Accessibilità Assoluta Zero Mouse in `UpgradesModal` (Tasto `U`)
- Navigazione lineare 100% da tastiera con tasti numerici `1`..`4` per le 4 schede (Alloggi, Sala Prove, Negozio Strumenti, Hardware Studio).
- Annunci vocali comparativi immediati per NVDA che esplicitano differenziali di abilità, carisma, sinergia, costo e stato di usura.
- Volumi dei feedback acustici calibrati nell'intervallo di sicurezza **0.7f - 0.8f** (anti-mascheramento voce NVDA).

---

## 📋 4. ISTRUZIONI DI AVVIO PER LA SESSIONE SUCCESSIVA (PROMPT PRONTO ALL'USO)

All'apertura della nuova chat/sessione su **World-tour**, Tom e Luca potranno incollare direttamente il seguente prompt per avviare la Sezione 4:

```text
Ciao Antigravity! Riprendiamo il pair programming su World-tour. Tutte le attività delle Sezioni 1, 2 e 3 sono state completate, convalidate al 100% (23 suite headless a 0 errori) e interamente archiviate. Il working tree Git è pulito e la versione AVF è V4.3.0. Oggi apriamo ufficialmente la SEZIONE 4 della Roadmap Modulare: 'Strumenti Musicali, Sala Prove, Home Studio & Upgrades Hub' (File di riferimento: docs/roadmap/04_strumenti_sala_prove_home_studio_e_upgrades.md e docs/report/REPORT_AVVIO_SESSIONE_SEZIONE_4.md). Come da Regola 0 e governance ASTRALIS v3.0.7, procedi con la Sotto-Fase 1A: analizza i requisiti, elabora il Piano Tecnico Formale in docs/piani/attivi/ ed effettua lo Stop Obbligatorio per attendere la nostra approvazione.
```
