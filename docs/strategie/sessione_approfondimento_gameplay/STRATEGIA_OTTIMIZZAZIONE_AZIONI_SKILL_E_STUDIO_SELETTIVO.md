# Strategia di Gioco — Ottimizzazione Sistemica Azioni, Competenze & Studio Selettivo (World-tour V5.8.0)
# Autori: Luca (Sviluppatore Senior Non Vedente con Screen Reader NVDA), Thomas & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-25
# Percorso File: docs/strategie/sessione_approfondimento_gameplay/STRATEGIA_OTTIMIZZAZIONE_AZIONI_SKILL_E_STUDIO_SELETTIVO.md
# Stato: [x] Convalidata Concettualmente (Fase 0 - Analisi Approfondita Sistemica e Consultiva)

---

## 🎯 1. OBIETTIVO E VISIONE SISTEMICA

Questo documento formalizza l'analisi approfondita e l'architettura di ottimizzazione per collegare in modo **efficace, organico, coerente e bilanciato** tutte le azioni a disposizione del giocatore in **World-tour** con l'**Albero delle Abilità a 6 Rami e 31 Competenze Canoniche**, traendo ispirazione dall'archetipo di **Popomundo** e dalle consuetudini della **Popoguida**.

### I 4 Pilastri Fondamentali dell'Ottimizzazione:
1. **Zero Abilità Orfane (Inclusività Totale)**: Ciascuna delle 31 competenze possiede almeno un'azione attiva e molteplici collegamenti di impatto nei sistemi di gioco (concerti, produzione brani, contratti, stampa, band e vita quotidiana).
2. **Equilibrio & Sinergia Azioni-Abilità**: Ogni azione del gioco ha un duplice binario:
   - *Binario Requisiti/Bonus*: Le abilità possedute migliorano l'efficacia, riducono i rischi e alzano il Quality Score;
   - *Binario Apprendimento ("Learning by Doing")*: L'esecuzione ripetuta dell'azione conferisce XP organici all'abilità collegata.
3. **Differenziazione Coerente dei 4 Metodi di Apprendimento**:
   - Studio su Manuale/Libro, Corsi in Accademia, Lezioni del Maestro Privato e Pratica/Ascolto Vinili hanno costi, durate, requisiti e tetti massimi (Cap) rigidamente differenziati e bilanciati.
4. **Studio Selettivo Universale (Il Selettore a Scelta Singola di Luca)**:
   - Quando il giocatore sceglie di studiare tramite Manuale, Accademia o Maestro Privato, il sistema apre un elenco a scelta singola accessibile al 100% per NVDA con tutte le 31 abilità del gioco, permettendo di scegliere liberamente cosa allenare nel rispetto delle regole propedeutiche e dei limiti di grado.

---

## 🌳 2. I 6 RAMI CANONICI E LA LORO COLLOCAZIONE SISTEMICA

Le 31 competenze dell'albero si distribuiscono sui 6 rami e impattano direttamente i sistemi di gioco:

### RAMO 1: CULTURA & PADRONANZA DEI GENERI (`genre_mastery`)
- **Competenze**:
  1. `genre_rock`: Rock Classico & Hard Rock
  2. `genre_metal`: Heavy Metal & Extreme Metal
  3. `genre_blues`: Blues & Roots
  4. `genre_pop`: Pop & Synth-Pop
  5. `genre_punk`: Punk & Garage
  6. `genre_jazz`: Jazz & Fusion
  7. `genre_folk`: Folk & Musica Acustica
- **Impatto nei Sistemi di Gioco**:
  - *SongCreator & MusicSystem*: Determina l'affinità con i brani di quel genere; un grado alto nel genere del brano aumenta il Quality Score (+2.0 a stella) e sblocca tratti tematici speciali.
  - *ConcertSystem*: Il pubblico dei locali e dei festival gradisce brani del genere padroneggiato; aumenta la conversione spettatori -> fan (+15% a stella) nei club specializzati.
  - *Apprendimento Attivo*: Studio su manuale di genere, corsi dedicati e lezioni private.
  - *Apprendimento Passivo Tangibile*: Ascolto dei vinili al giradischi del Loft NYC (+25 XP passivi al genere ascoltato).

---

### RAMO 2: COMPETENZE STRUMENTALI & VOCALI (`instrumental_technique`)
- **Competenze**:
  8. `skill_guitar`: Chitarra Elettrica (ritmica, assoli veloci, effettistica)
  9. `skill_vocals`: Canto & Tecnica Vocale (diaframma, estensione, timbro)
  10. `skill_bass`: Basso Elettrico (fingerstyle, plettro, slap & groove)
  11. `skill_drums`: Batteria & Percussioni (timing metronomico, ghost notes, dinamica)
  12. `skill_keyboards`: Tastiere & Sintetizzatori (armonia tasti, sound design)
  13. `skill_horns`: Fiati, Tromba & Sassofono (emissione, riff di fiati Funk/Ska, assoli Sax caldi e vibrato)
  14. `skill_strings`: Archi, Violino & Violoncello (archetto, intonazione fine, arrangiamenti sinfonici e folk)
  15. `skill_harmonica`: Armonica a Bocca & Strumenti Folk (bending delle note, ritmo blues e feeling acustico)
- **Impatto nei Sistemi di Gioco**:
  - *ConcertSystem*: Evita errori tecnici e stecche sul palco; alza il Concert Score del musicista e la Sinergia Palco con la band.
  - *MusicSystem*: Determina la qualità delle registrazioni strumentali durante la fase di produzione; sblocca sezioni fiati, archi epici e soli d'armonica nei brani.
  - *Apprendimento*: Pratica individuale con lo strumento nel Loft (gratis, +20 XP), lezioni private col Maestro (+80 XP), masterclass in Accademia (+50 XP), prove con la band.

---

### RAMO 3: COMPOSIZIONE, ARMONIA & SCRITTURA (`songwriting_harmony`)
- **Competenze**:
  16. `comp_theory`: Teoria Musicale & Armonia Funzionale (scale, cadenze, progressioni accordali)
  17. `comp_lyrics`: Scrittura Testi & Metrica Poetica (rime, metrica poetica, storytelling)
  18. `comp_ballads`: Composizione Ballate Emozionali (`TEARJERKER_BALLAD`)
  19. `comp_anthems`: Composizione Inni da Stadio (`GENERATIONAL_ANTHEM`)
  20. `comp_riffs`: Composizione Riff & Hook Ritmici (`EPIC_RIFF`)
  21. `comp_history`: Storia & Cultura Musicale (conoscenza dei capolavori e dei maestri del passato)
- **Impatto nei Sistemi di Gioco**:
  - *MusicSystem*: `comp_theory` accelera la fase di ideazione musicale; `comp_lyrics` accelera la stesura del testo; `comp_riffs`, `comp_ballads` e `comp_anthems` sbloccano i tratti più potenti del gioco, moltiplicando vendite e affluenza ai live.
  - *MediaSystem*: `comp_history` garantisce punteggi estatici (fino a 5 stelle) nelle recensioni dei critici musicali più severi.
  - *Propedeuticità*: `comp_ballads` e `comp_anthems` richiedono obbligatoriamente `comp_theory >= Grado 2`.

---

### RAMO 4: PALCO, SPETTACOLO & INTRATTENIMENTO (`stage_showmanship`)
- **Competenze**:
  22. `stage_presence`: Presenza Scenica & Postura da Palco (dominanza visiva, carisma scenico)
  23. `stage_crowd`: Interazione col Pubblico (Crowd Control, dialoghi tra brani, chiamata cori)
  24. `stage_improv`: Improvvisazione & Assoli Live (capacità di variare le note e infiammare il pubblico)
  25. `stage_athleticism`: Coordinazione Fisica & Atletismo da Palco (salti, headbanging senza perdere fiato)
- **Impatto nei Sistemi di Gioco**:
  - *ConcertSystem & FestivalSystem*: `stage_presence` massimizza l'hype iniziale; `stage_crowd` sblocca i cori del pubblico e moltiplica le vendite al banchetto del Merchandising; `stage_improv` sblocca il momento Bis / Encore con mance extra e ovazione; `stage_athleticism` dimezza il consumo di energia e stress durante le esibizioni live più scatenate.
  - *Propedeuticità*: `stage_athleticism` richiede obbligatoriamente `stage_presence >= Grado 2`.

---

### RAMO 5: STUDIO, SUONO & LIUTERIA (`engineering_hardware`)
- **Competenze**:
  26. `tech_production`: Produzione Discografica & Missaggio (equalizzazione, compressione, mastering)
  27. `tech_live_sound`: Tecnico del Suono Live (gestione mixer di palco, acustica ambientale e monitor spia)
  28. `tech_lutherie`: Liuteria & Manutenzione Strumentale (cambio corde, regolazione action, saldatura jack)
- **Impatto nei Sistemi di Gioco**:
  - *MusicSystem & Studio*: `tech_production` alza il Quality Score delle registrazioni fatte nell'Home Studio e riduce del 30% le spese per gli studi professionali esterni.
  - *ConcertSystem*: `tech_live_sound` annulla i malus acustici causati da locali con impianti scadenti o acustica rimbombante.
  - *UpgradesSystem & Loft*: `tech_lutherie` azzera il rischio di rottura corde sul palco e riduce del 70% i costi di riparazione presso il liutaio cittadino.
  - *Loft NYC*: L'azione alla Cassa Attrezzi (`toolbox_check` e `toolbox_maintain`) allena direttamente `tech_live_sound` e `tech_lutherie`!

---

### RAMO 6: BUSINESS, MEDIA & RELAZIONI INDUSTRIALI (`industry_business`)
- **Competenze**:
  29. `biz_media`: Relazioni coi Media (capacità di sostenere interviste radiofoniche, podcast e TV con carisma)
  30. `biz_negotiation`: Negoziazione Contrattuale & Royalties (trattative con etichette discografiche e manager)
  31. `biz_marketing`: Marketing Digitale & Social Branding (campagne social virali su BandFeed e sponsorizzazioni)
- **Impatto nei Sistemi di Gioco**:
  - *IndustrySystem*: `biz_negotiation` permette di ottenere anticipi più cospicui (+20%), royalties discografiche maggiori e penali ridotte in caso di rottura del contratto; `biz_media` massimizza la reputazione e il Buzz generato dalle interviste promozionali.
  - *SocialSystem*: `biz_marketing` moltiplica la viralità dei post, la conversione dei follower e gli incassi delle dirette streaming.
  - *MediaBroadcaster*: Gestione degli scandali e interviste di riparazione con successo garantito.

---

## ⚖️ 3. MATRICE DEI 4 METODI DI STUDIO E ALLENAMENTO

Per garantire profondità sistemica ed eliminare exploit, ciascuno dei 4 metodi adotta regole deterministiche:

### 1. Studio su Manuale / Libro (Autoapprendimento Teorico)
- **Ruolo Unico**: È l'**unico metodo autorizzato a sbloccare una competenza da Grado 0 (Non Appresa) a Grado 1 (Principiante)**!
- **Ambito di Efficacia**: Dal Grado 0 al Grado 2 (Praticante).
- **Tetto Massimo (Cap)**: **Grado 2 (Praticante)**.
  - *Regola*: Nessun artista può diventare un professionista o un virtuoso leggendo solo libri senza confronto pratico o accademico. Oltre il Grado 2, il manuale restituisce il messaggio: *"Hai assimilato tutta la teoria di base di questo testo. Per raggiungere il livello Professionista (Grado 3) frequenta l'Accademia Musicale o prendi lezioni da un Maestro."*
- **Costi & Fisiologia**:
  - *Denaro*: Gratuito (o costo una tantum d'acquisto manuale).
  - *Tempo*: 10.0 secondi di gioco virtuale.
  - *Fisiologia*: `-12 Energia`, `+4 Stress` (sforzo di concentrazione prolungato), `+2 Morale`.
  - *XP Conferiti*: `+35.0 XP` base (moltiplicati dal coefficiente dell'attributo innato `intelligence`).

---

### 2. Corso in Accademia Musicale / Conservatorio (Formazione Formale)
- **Requisito d'Accesso**: La competenza deve essere **già sbloccata ad almeno Grado 1**. L'accademia non accetta allievi privi delle basi minime: richiede prima lo studio del manuale introduttivo!
- **Ambito di Efficacia**: Dal Grado 1 al Grado 3 (Professionista).
- **Tetto Massimo (Cap)**: **Grado 3 (Professionista)**.
  - *Regola*: L'Accademia rilascia il diploma professionale ma non può forgiare virtuosi leggendari o fuoriclasse del palco. Oltre il Grado 3, il sistema notifica: *"L'Accademia forma fino al Grado 3 Professionista. Per raggiungere i gradi d'eccellenza (Virtuoso e Maestro Leggendario) devi ingaggiare un Maestro Privato d'élite o fare esperienza diretta sul campo."*
- **Costi & Fisiologia**:
  - *Denaro*: `30.00 €` a sessione.
  - *Tempo*: 12.0 secondi di gioco virtuale.
  - *Fisiologia*: `-18 Energia`, `0 Stress` (ambiente didattico protetto e strutturato), `+5 Morale`.
  - *XP Conferiti*: `+50.0 XP` base (moltiplicati da `intelligence`).

---

### 3. Lezione Privata con Maestro / Mentore NPC (Perfezionamento Virtuoso)
- **Requisito d'Accesso**: La competenza deve essere **già sbloccata ad almeno Grado 1**. Non si paga una tariffa d'élite da 50-75 € per farsi spiegare l'alfabeto musicale o come impugnare il plettro!
- **Ambito di Efficacia**: Dal Grado 1 al Grado 5 (Maestro Leggendario). È il metodo principe per superare il Grado 3 e conquistare il Grado 4 (Virtuoso) e il Grado 5 (Maestro Leggendario).
- **Tetto Massimo (Cap)**: **Grado 5 (Cap Assoluto di Sistema)**.
- **Costi & Fisiologia**:
  - *Denaro*: `50.00 €` (o `75.00 €` per i gradi 4-5).
  - *Tempo*: 12.0 secondi di gioco virtuale.
  - *Fisiologia*: `-22 Energia`, `+8 Stress` (rigore tecnico inflessibile del maestro), `+10 Morale` (soddisfazione artistica superiore).
  - *XP Conferiti*: `+80.0 XP` intensivi (moltiplicati da `intelligence`).

---

### 4. Pratica Individuale & "Learning by Doing" (Esperienza Empirica Multi-Strumento)
- **Pratica Strumentale & Vocale Domestica ("Scale, Riff & Vocalizzi")**:
  - Eseguita nella postazione musicale / chitarra nel Loft NYC (`guitar_practice`).
  - *Sistemica Multi-Strumento*: Non è vincolata alla sola chitarra! Il musicista può scegliere se allenare:
    * **Chitarra Elettrica** (`skill_guitar`): scale pentatoniche, precisione plettrata alternata e riff;
    * **Canto & Tecnica Vocale** (`skill_vocals`): vocalizzi, respirazione diaframmatica ed estensione vocale (sempre disponibile, la voce non richiede strumento fisico);
    * **Basso Elettrico** (`skill_bass`): scale al metronomo, groove ritmico e slap;
    * **Batteria & Percussioni** (`skill_drums`): rudimenti sul pad allenatore, paradiddle e coordinazione;
    * **Tastiere & Sintetizzatori** (`skill_keyboards`): arpeggi, indipendenza mani e armonia moderna;
    * *(Predisposizione aperta per strumenti futuri: Fiati, Archi, Armonica)*.
  - *Costo & Fisiologia*: `0.0 €`, `-10 Energia`, `+3 Stress`, `+5 Morale`, durata 10.0 secondi virtuali.
  - *XP Conferiti*: `+20.0 XP` diretti alla competenza strumentale o vocale selezionata.
  - *Range di Efficacia*: Dal Grado 1 al Grado 4 (Virtuoso). Per raggiungere la perfezione assoluta di Grado 5 (Maestro Leggendario) richiede sessioni di rifinitura con il Maestro Privato o tournée internazionali.
- **Ascolto Attivo Vinili al Giradischi**:
  - Azioni dedicate per genere (`turntable_listen_rock`, `_metal`, `_blues`, `_jazz`, `_pop`, `_punk`, `_folk`, `turntable_study`).
  - *Costo*: `0.0 €`, `0 Energia`, `-10 Stress` (rilassante), `+20 Morale`, 35% scintilla creativa.
  - *XP*: `+25.0 XP` passivi alla competenza del genere ascoltato o a `tech_production`.
- **Esecuzioni Live, Creazione Brani e Trattative**:
  - Ogni concerto eseguito assegna XP a `stage_presence`, `stage_crowd` e `skill_*` dello strumento suonato sul palco.
  - Ogni brano composto assegna XP a `comp_theory`, `comp_lyrics`, `comp_riffs` e al genere del brano.
  - Ogni rinegoziazione contrattuale assegna XP a `biz_negotiation`.
  - Ogni intervista con la stampa assegna XP a `biz_media`.
  - Ogni operazione alla cassa attrezzi assegna XP a `tech_lutherie` e `tech_live_sound`.

---

## 🎛️ 4. IL SELETTORE A SCELTA SINGOLA DELLE 31 ABILITÀ (`SkillStudyPicker`)

### L'Intuizione di Luca:
Invece di avere azioni rigide con una singola abilità pre-assegnata (es. manuale che allena solo teoria, maestro che insegna solo chitarra), il sistema adotta un approccio sistemico:
1. Il giocatore interagisce con l'arredo:
   - Divano/Letto -> Seleziona *"Studio su manuale teorico"*;
   - Porta NYC -> Seleziona *"Lezione in Accademia Musicale"*;
   - Chitarra/Salotto -> Seleziona *"Lezione col Maestro Privato"*.
2. All'attivazione dell'azione, il sistema non parte alla cieca, ma **apre il Selettore Singolo delle Abilità (`SkillStudyPicker`)**.
3. Il selettore presenta la lista verticale completa di tutte le **31 abilità del sistema**, formattata in modo rigorosamente lineare per **NVDA Zero Mouse**.

### Struttura della Voce nel Selettore:
Per ogni abilità, la riga espone chiaramente:
```text
[Indice] [Nome Abilità] — Ramo: [Nome Ramo] — [Stelle Grado] — [Stato Idoneità]
```
Esempi concreti:
- *Caso 1 (Idonea per Manuale)*:  
  `1. Rock Classico & Hard Rock — Ramo: Cultura Generi — ★☆☆☆☆ (Grado 1: Principiante) — [IDONEA: Allena fino a Grado 2]`
- *Caso 2 (Bloccata da Propedeuticità)*:  
  `15. Composizione Ballate — Ramo: Composizione — ☆☆☆☆☆ (Grado 0: Non Appresa) — [BLOCCATA: Richiede Grado 2 in Teoria Musicale]`
- *Caso 3 (Accademia con Grado 0)*:  
  `9. Canto & Tecnica Vocale — Ramo: Strumenti & Voce — ☆☆☆☆☆ (Grado 0: Non Appresa) — [NON IDONEA: Richiede Manuale Base per sbloccare Grado 1]`
- *Caso 4 (Manuale su Grado 2)*:  
  `13. Teoria Musicale & Armonia — Ramo: Composizione — ★★☆☆☆ (Grado 2: Praticante) — [LIMITE RAGGIUNTO: Per Grado 3 frequenta Accademia o Maestro]`
- *Caso 5 (Accademia su Grado 3)*:  
  `8. Chitarra Elettrica — Ramo: Strumenti & Voce — ★★★☆☆ (Grado 3: Professionista) — [LIMITE ACCADEMICO: Per Gradi 4 e 5 ingaggia un Maestro Privato]`
- *Caso 6 (Maestro su Grado 4)*:  
  `8. Chitarra Elettrica — Ramo: Strumenti & Voce — ★★★★☆ (Grado 4: Virtuoso) — [IDONEA: Sessione per scalare a Maestro Leggendario]`
- *Caso 7 (Già Maestro Leggendario)*:  
  `8. Chitarra Elettrica — Ramo: Strumenti & Voce — ★★★★★ (Grado 5: Maestro Leggendario) — [COMPLETATA: Maestria Massima Raggiunta]`

### Interazione da Tastiera (Zero Mouse):
- **Frecce Su / Giù** (o **Numpad 8 / 2**): Scorrimento riga per riga con lettura vocale immediata di NVDA tramite `AccessibilityManager.announce()`.
- **Numeri Diretti (`1`..`9`) / Tasti Rapidi Ramo (`G`, `S`, `A`, `P`, `T`, `B`)**: Filtro immediato per ramo per raggiungere rapidamente la competenza desiderata senza scorrere 31 righe se si preferisce la scorciatoia.
- **Invio / Spazio**: Seleziona la competenza. Se l'abilità non è idonea per il metodo scelto, NVDA legge la motivazione di rifiuto e il focus resta fermo. Se è idonea, il selettore si chiude e l'azione parte con stato `GAMEPLAY_BUSY`, timer progressivo e barra inspection!
- **Esc**: Annulla la selezione, chiude il selettore e torna all'appartamento senza alcun consumo di risorse.

---

### 4.1 IL SELETTORE DI PRATICA STRUMENTALE & VOCALE (`InstrumentPracticePicker`)

Quando il musicista interagisce con la postazione musicale / chitarra nel Loft e attiva *"Scale e riff"* (o *"Scale, riff & vocalizzi"*):
1. **Apertura del Selettore Strumentale & Vocale**: Il sistema apre una finestra a scelta singola dedicata al **Ramo 2 (Competenze Strumentali & Vocali)**.
2. **Elenco delle 8 Discipline Canoniche Selezionabili**:
   - `1. Chitarra Elettrica (skill_guitar)` — [Ritmica, scale e assoli veloci]
   - `2. Canto & Tecnica Vocale (skill_vocals)` — [Vocalizzi, respirazione diaframmatica ed estensione]
   - `3. Basso Elettrico (skill_bass)` — [Fingerstyle, plettro e slap groove]
   - `4. Batteria & Percussioni (skill_drums)` — [Timing metronomico, paradiddle e coordinazione]
   - `5. Tastiere & Sintetizzatori (skill_keyboards)` — [Arpeggi, scale e accordi estesi]
   - `6. Fiati, Tromba & Sassofono (skill_horns)` — [Emissione, riff di fiati Funk/Ska, assoli Sax caldi]
   - `7. Archi, Violino & Violoncello (skill_strings)` — [Archetto, intonazione fine, arrangiamenti sinfonici e folk]
   - `8. Armonica a Bocca & Strumenti Folk (skill_harmonica)` — [Bending delle note, ritmo blues e feeling acustico]
3. **Indicazione dello Strumento Primario & Stato**:
   - Lo strumento scelto nella creazione del personaggio viene evidenziato come `[STRUMENTO PRINCIPALE]`;
   - La voce (Canto) è **sempre accessibile** ovunque (non necessita di strumento fisico);
   - Gli strumenti fisici indicano il grado attuale e lo stato dell'hardware (es. se posseduto o presente nel loft);
4. **Esito della Pratica**:
   - La sessione dura 10.0 secondi con stato `GAMEPLAY_BUSY`;
   - Al termine, conferisce `+20.0 XP` alla disciplina scelta, consuma 10 energia, aumenta il morale di +5 e comporta una leggera fatica muscolare (+3 stress);
   - Annuncio vocale dedicato per NVDA: *"Sessione completata! +20 XP assegnati a Canto & Tecnica Vocale (Grado 2: Praticante)"*.

---

## 🔄 5. MATRICE SINERGICA AZIONI <-> COMPETENZE NEL LOFT NYC

Riepilogo delle interazioni negli arredi del Loft NYC armonizzate con l'Albero a 6 Rami:

| Arredo | Azione | Metodo / Scopo | Abilità Collegata / Target | Effetti Primari |
| :--- | :--- | :--- | :--- | :--- |
| **Divano (`couch`)** | `couch_study_manual` | Metodo 1: Manuale | **Scelta Singola (31 Abilità)** | Sblocca Grado 1 o allena fino a Grado 2 (+35 XP) |
| **Divano (`couch`)** | `couch_jam` | Pratica Acustica | `comp_riffs` o `comp_theory` | +10 XP Riff/Teoria, +10 Morale, 35% Scintilla |
| **Divano (`couch`)** | `couch_sit` / `couch_nap` | Riposo & Relax | Fisiologia (Stamina/Energia) | Rigenera Energia, riduce Stress |
| **Chitarra (`guitar`)** | `guitar_practice` | Pratica Multi-Strumento | **Scelta Singola (8 Strumenti/Voce)** | +20 XP Strumento o Canto, -10 Energia, +5 Morale |
| **Chitarra (`guitar`)** | `guitar_mentor_lesson` | Metodo 3: Maestro | **Scelta Singola (31 Abilità)** | Allena fino a Grado 5 (+80 XP, -50.00 €) |
| **Chitarra (`guitar`)** | `guitar_tune` | Manutenzione Base | `tech_lutherie` | +5 XP Liuteria, +5 Morale, -5 Stress |
| **Chitarra (`guitar`)** | `guitar_create` | Song Creator | `comp_*`, `genre_*`, `musicality` | Apertura modale composizione |
| **Porta NYC (`door`)** | `door_academy_course` | Metodo 2: Accademia | **Scelta Singola (31 Abilità)** | Allena da Grado 1 a Grado 3 (+50 XP, -30.00 €) |
| **Porta NYC (`door`)** | `door_concert` | Live Concert | `stage_*`, `skill_*`, `tech_live_sound` | Esecuzione concerto live |
| **Porta NYC (`door`)** | `door_tour` / `door_travel` | Tour & Viaggi | `stamina`, `charm`, `biz_*` | Viaggi e date interurbane |
| **Giradischi (`turntable`)** | `turntable_listen_rock` | Ascolto Vinile Rock | `genre_rock` | +25 XP Rock, +20 Morale, -10 Stress |
| **Giradischi (`turntable`)** | `turntable_listen_metal`| Ascolto Vinile Metal| `genre_metal` | +25 XP Metal, +20 Morale, -10 Stress |
| **Giradischi (`turntable`)** | `turntable_listen_blues`| Ascolto Vinile Blues| `genre_blues` | +25 XP Blues, +20 Morale, -10 Stress |
| **Giradischi (`turntable`)** | `turntable_listen_jazz` | Ascolto Vinile Jazz | `genre_jazz` | +25 XP Jazz, +20 Morale, -10 Stress |
| **Giradischi (`turntable`)** | `turntable_study` | Studio Missaggio | `tech_production` | +25 XP Produzione, +5 Morale |
| **Cassa Attrezzi (`toolbox`)**| `toolbox_check` | Controllo Jack/Cavi | `tech_live_sound` | +10 XP Tecnico Live, +5 Morale, -2 Stress |
| **Cassa Attrezzi (`toolbox`)**| `toolbox_maintain` | Setup Chitarra | `tech_lutherie` | +15 XP Liuteria, -5 Energia, +10 Morale |
| **Guardaroba (`wardrobe`)** | `wardrobe_change_look` | Cambio Outfit | `stage_presence` | +10 Morale, +5 XP Presenza Scenica |
| **Stereo (`stereo`)** | `stereo_radio` | Analisi Radio/Trend | `biz_marketing` / Trend | +5 Morale, -5 Stress, +10 XP Marketing |
| **Letto (`bed`)** | `bed_study_night` | Studio Serale | **Scelta Singola (Manuale)** | Studio teorico notturno prima di dormire |
| **Letto (`bed`)** | `bed_sleep` / `bed_rest`| Sonno & Riposo | Fisiologia (Stamina/Energia) | Rigenerazione totale risorse vitali |

---

## 🛡️ 6. VALIDAZIONE SUI 7 ASSI DI QUALITÀ ASTRALIS

- **Asse 1 — Validità**: Rispetto rigoroso dei contratti tipizzati di GDScript 2.0 (`skill_id: String`, `method_type: int`, `target_grade: int`); gestione sicura delle collezioni e dizionari.
- **Asse 2 — Efficacia**: Risoluzione radicale del problema delle azioni hardcodate su singole skill, offrendo al giocatore la libertà di forgiare il proprio stile di artista in modo profondo e dinamico.
- **Asse 3 — Coerenza**: Perfetta armonia con la Clean Architecture di World-tour, il pattern EventBus a segnali, il modello dati `PlayerData` e l'HUD del Loft NYC.
- **Asse 4 — Completezza**: Copertura di tutte le 28 competenze, dei 6 rami, dei 4 metodi di apprendimento e di tutti i possibili stati di idoneità/errore.
- **Asse 5 — Precisione**: L'introduzione del selettore non altera le azioni di base preesistenti ma ne arricchisce la flessibilità e l'attribuzione XP.
- **Asse 6 — Affidabilità & Prestazioni**: Esecuzione headless a 0 ms senza allocazioni cicliche pesanti né ritardi artificiali.
- **Asse 7 — Assenza Regressioni & Retrocompatibilità**: Piena tutela del mapping legacy `skills` e delle 31 suite di test attualmente al 100% verdi.

---

## 🚦 7. PROSSIMI PASSI OPERATIVI (PIPELINE ASTRALIS)

1. **Revisione Consultiva di Luca & Thomas (Fase 0)**:
   - Discussione e approvazione dell'analisi concettuale qui redatta.
2. **Aggiornamento del Registro Revisioni (`REGISTRO_REVISIONI.md`)**:
   - Apertura della voce formale `RRU-29`.
3. **Passaggio alla Sotto-Fase 1A (Su Ordine Esplicito)**:
   - Quando Luca darà il comando (*"passa alla fase 1"*), redazione del Piano Tecnico Formale con Named Contracts atomici (`docs/piani/attivi/PIANO_TECNICO_OTTIMIZZAZIONE_AZIONI_SKILL_E_STUDIO_SELETTIVO.md`).
4. **Sotto-Fase 1B & Test Headless**:
   - Implementazione del selettore accessibile, aggiornamento del catalogo azioni e test headless a 0 ms con 32 suite verdi.
