# World-tour — Approfondimento Sistemico: Analisi Roadmap per l'Alpha Version

- Data di redazione: 23 Settembre 2026
- Autori: Luca & Antigravity (Senior AI Pair Programmer)
- Percorso file: `docs/report/ALLEGATO_APPROFONDIMENTO_ROADMAP_ALFA.md`
- Documento padre: [`docs/report/REPORT_SESSIONE_ROADMAP_E_ALPHA.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/report/REPORT_SESSIONE_ROADMAP_E_ALPHA.md)
- Roadmap analizzata: [`docs/roadmap.md`](file:///c:/Users/nemex/OneDrive/Documenti/GitHub/World-tour/docs/roadmap.md)
- Destinazione d'uso: Base analitica per la sessione successiva per ricavare la scaletta implementativa dell'Alpha Version.

---

## 1. DEFINIZIONE DEL PERIMETRO DI "ALPHA VERSION GIOCABILE"

### 1.1 Differenza tra Suite Headless e Loop Orizzontale Integrato
Attualmente World-tour dispone di **19 suite di test headless** (`tests/`) che validano con 0 errori ciascun modulo preso singolarmente o a coppie (ad esempio `MusicSystem`, `ConcertSystem`, `BandSystem`, `TravelSystem`, `SocialMediaSystem`, `ChartSystem`, `UpgradesSystem`).

L'obiettivo dell'**Alpha Version** è compiere il salto qualitativo decisivo:
- Passare dalla validazione modulare isolata a un **Loop di Gioco Orizzontale Connesso ed Esperibile**.
- Consentire a Luca (tramite screen reader NVDA e tastiera completa Zero Mouse) e a Holy Diver (tramite monitor 1920x1080 ad alto contrasto e mouse) di avviare una partita, progredire attraverso le settimane di gioco e vivere l'esperienza completa del simulatore in modo coeso, organico e privo di punti morti.

### 1.2 I 6 Criteri Cardine dell'Alpha Version
Un'Alpha Version completa di World-tour deve consentire al giocatore di:
1. **Vivere la quotidianità del musicista**: Gestire l'energia, lo stress, il morale, il cibo e l'affitto attraverso il passaggio fluido delle fasce orarie (Mattina, Pomeriggio, Sera, Notte).
2. **Creare e pubblicare musica**: Scrivere brani nei 6 generi, inciderli in home studio o in studio professionale, assemblare Singoli, EP o Album, e vederli generare vendite e royalties giornaliere.
3. **Suonare dal vivo e viaggiare**: Esibirsi nei locali cittadini, affrontare gli imprevisti di palco, organizzare tournée con veicoli dedicati e partecipare ai festival estivi all'aperto.
4. **Vivere la band**: Reclutare compagni con personalità distinte, gestire la tensione interna con le prove in sala insonorizzata e concordare le percentuali di spartizione dei compensi.
5. **Competere e comunicare**: Pubblicare contenuti su BandFeed, gestire le shitstorm, scalare la Hit Parade settimanale contro le 10 band rivali ed entrare in Top 10 fino al primo posto.
6. **Evolvere il proprio status**: Negoziare contratti con etichette Indie o Major, assumere un manager, acquistare strumenti migliori, allestire l'home studio e trasferirsi in residenze più prestigiose.

---

## 2. ANALISI DEI COLLEGAMENTI SISTEMICI TRA LE 12 SEZIONI DELLA ROADMAP

L'analisi profonda della Roadmap rivela come le 12 sezioni non siano isole, ma ingranaggi di una catena interdipendente:

### Catena 1: Dal Riff alla Hit Parade (Sezioni 1, 2, 4, 8, 10)
- Il livello di abilità del protagonista (Sezione 1) e la qualità dello strumento/hardware posseduto (Sezione 4) determinano il **Quality Score** della canzone prodotta (Sezione 2).
- Il brano rilasciato genera streaming e vendite Day 1, potenziate dalla popolarità e dal moltiplicatore **social_buzz** ottenuto con i post su BandFeed (Sezione 8).
- Ogni domenica notte, i dati di vendita e stream confluiscono nell'algoritmo di **ChartSystem** (Sezione 10), determinando l'ingresso in Hit Parade e il duello con i brani delle band rivali.

### Catena 2: Dal Garage al Festival Estivo (Sezioni 3, 5, 6, 7)
- La sinergia e la tensione della band (Sezione 3) influenzano direttamente il **Concert Score** nei locali live (Sezione 5).
- L'esito del concerto converte spettatori in fan territoriali e sblocca la reputazione necessaria per viaggiare in altre metropoli (Sezione 6).
- L'organizzazione di tournée multi-tappa genera un accumulo di **Hype a catena** (+5% a data), che permette di soddisfare i requisiti dei cartelloni dei **Grandi Festival Estivi** nei mesi 4-6 (Sezione 7) per tentare la meccanica "Rubare la Scena".

### Catena 3: Economia, Contratti & Crescita Materiale (Sezioni 1, 4, 9, 11)
- Le spese quotidiane di sussistenza e canone alloggio (Sezione 1) impongono la ricerca continua di entrate (concerti, royalties, stipendi).
- La crescita di popolarità attira le offerte di etichette Indie o Major con anticipi liquidi consistenti (Sezione 9), regolati dal vincolo del **Recoupment**.
- La liquidità ottenuta viene reinvestita nell'**Upgrade Hub** (Sezione 4) per comprare strumenti Master, insonorizzare la sala prove e sbloccare residence prestigiosi, aprendo la strada all'Endgame degli stadi (Sezione 11).

---

## 3. PUNTI DI SUTURA & CONNESSIONI DA PERFEZIONARE PER L'ALPHA

Dall'analisi emergono alcuni "punti di sutura" tecnici su cui concentrare la scaletta implementativa per rendere l'esperienza perfettamente fluida:

### Sutura A: Integrazione Unificata dell'Agenda sul Calendario
- *Stato attuale*: Il calendario (`CalendarData`) e lo `ScheduleSystem` tracciano date e giorni, ma le varie attività (date dei concerti singoli, tappe del tour, scadenze affitto, festival estivi e rilascio classifiche della domenica) devono convergere in modo cristallino nella schermata Agenda (tasto `A`), offrendo a Luca un riepilogo vocale lineare di "Cosa c'è in programma oggi e nei prossimi 7 giorni".

### Sutura B: Narrazione e Notifiche Notturne nel DailySummary
- *Stato attuale*: La schermata `DailySummary` calcola correttamente spese, royalties e riposo a mezzanotte.
- *Perfezionamento Alpha*: Arricchire il riepilogo notturno con la vocalizzazione strutturata degli eventi avvenuti nel mondo (es. "La band rivale The Chrome Shadows ha rilasciato un nuovo singolo", "Le tue royalties ammontano a 45 €", "Attenzione: la tensione della band è salita al 75%").

### Sutura C: Flusso di Sblocco Naturale (Onboarding & Early Game)
- *Stato attuale*: Il giocatore parte con 10 canzoni di test nello starter pack.
- *Perfezionamento Alpha*: Garantire che una nuova partita pulita offra un percorso guidato intuitivo:
  - Giorno 1: Alex da solo nella stanzetta, scrive la sua prima canzone o fa un lavoretto di sussistenza.
  - Giorni 2-7: Primi live nel Garage o Pub, audizione per il primo compagno di band, rilascio del primo singolo autoprodotto.
  - Giorni 8-28: Formazione della band completa, primo concerto in un piccolo club, apertura del canale BandFeed.

### Sutura D: Bilanciamento delle Risorse ed Anti-Stallo
- *Stato attuale*: Formule matematiche calibrate in `Constants`.
- *Perfezionamento Alpha*: Verificare che non si verifichino stalli economici precoci (es. rimanere senza soldi e senza energia contemporaneamente prima di aver potuto suonare un live) introducendo micro-attività di recupero d'emergenza (es. suonare per strada come busker per guadagnare 15-20 € immediati).

---

## 4. PROPOSTA DEI 5 BLOCCHI OPERATIVI PER LA SCALETTA IMPLEMENTATIVA

In vista della prossima sessione, si propone di articolare la scaletta per l'Alpha Version in 5 blocchi sequenziali:

### Blocco 1: Flusso Globale di Partita & Onboarding Pulito
- Flusso Nuova Partita senza dati fittizi residui, inizializzazione pulita di Alex e delle finanze iniziali.
- Transizione fluida tra Schermata Titoli (`MainMenu`), Creazione/Selezione Personaggio, HUD di Gioco e Menu di Sistema (`Esc`).
- Verifica della persistenza totale (Salvataggio atomico e Ricaricamento a metà carriera con conservazione di ogni parametro).

### Blocco 2: Loop Creativo & Discografico End-to-End
- Percorso completo verificabile: Ideazione brano -> Scrittura -> Registrazione -> Produzione -> Inserimento in EP/LP -> Assegnazione Artwork e Lead Single -> Pubblicazione -> Rassegna stampa critica -> Vendite e Royalties.

### Blocco 3: Loop Live, Territorio, Tour & Festival
- Percorso verificabile dal vivo: Soundcheck e scaletta nel Pub locale -> Successo con Closer Bonus -> Spostamento a Bologna o Roma con il Furgone -> Apertura del primo Tour a tappe con Hype progressivo -> Partecipazione a un Festival estivo all'aperto nello slot al Tramonto.

### Blocco 4: Loop Band, Social Media, Rivali & Contratti
- Percorso relazionale e competitivo: Audizione e ingresso del bassista e batterista -> Sessione di prove con riduzione tensione -> Pubblicazione clip prove su BandFeed -> Gestione di una shitstorm -> Ingresso nella Hit Parade domenicale contro i Colosseo Sound Machine -> Offerta contrattuale da etichetta Indie.

### Blocco 5: Rifinitura Accessibilità NVDA, Bilanciamento Globale & Alpha Build
- Revisione riga per riga di tutti i flussi con sintesi vocale e tastiera Zero Mouse.
- Verifica coesistenza estetica ad alto contrasto per monitor/mouse.
- Convalida finale su tutte le 19+ suite di test ed emissione della release taggata **Alpha 1.0**.

---

## 5. CONCLUSIONI & PROSSIMI PASSI

Questo allegato fornisce una visione architetturale completa e integrata della roadmap.  
Nella prossima sessione, partendo da questa base analitica, potremo trasformare questi 5 blocchi in una **scaletta operativa compatta, con compiti precisi e caselle di spunta sequenziali**, per procedere direttamente all'assemblaggio e al collaudo dell'Alpha Version di World-tour.
