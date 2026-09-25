# Strategia Integrale di Gioco — Sinergie di Band, Autore, Repertorio & Mercato Musicale (Eredità Popomundo)
# Autori: Luca, Thomas & Antigravity
# Framework: ASTRALIS v3.0.7 (Architettura Universale & Governance Polimorfica)
# Data: 2026-09-25
# Percorso: docs/strategie/sessione_approfondimento_gameplay/STRATEGIA_INTEGRALE_EVOLUZIONE_GAMEPLAY_POPOMUNDO.md
# Stato: [x] Convalidata Concettualmente (Fase 0 - Documento Strategico Master Unificato)

---

## 1. VISIONE GENERALE E FILOSOFIA ARCHITETTURALE

Il presente documento fonde e consolida in un'unica visione strategica organica l'analisi comparativa ed esplorativa delle meccaniche storiche di **Popomundo** e della **Popoguida**, adattandole ed elevandole per il motore di gioco di **World-tour**.

### Gli Obiettivi Cardine:
1. **Integrazione Duale Armonica**: Unire la dimensione collettiva della **Band** (concerti, scalette, sale prove, tournée, crew tecnica e saturazione di piazza) con la dimensione individuale del **Singolo Artista / Autore** (studio delle abilità, artigianato delle canzoni, finestra di rifinitura arancione/verde, mercato delle canzoni all'asta e salute personale).
2. **Superamento del Difetto Storico di Popomundo**: 
   - Popomundo soffriva di una gestione del tempo estenuante, vincolata ai tick del server in tempo reale (mesi di calendario per un tour, attese passive, ansia da login).
   - In World-tour **il tempo è virtuale, discreto e governato dal giocatore**: ogni azione ha impatto immediato, il ritmo è fluido, con skip-time, pause dinamiche e zero tempi morti.
3. **Simmetria Universale & Accessibilità Assoluta (Zero Mouse)**: Tutte le meccaniche, finestre temporali e mercati sono progettati per essere fruibili al 100% da tastiera e Numpad, con logica lineare "Se... Allora" ottimizzata per la lettura vocale riga per riga di NVDA.

---

## PARTE I: LA PROSPETTIVA DELLA BAND, DEL LIVE & DELLE TOURNÉE

---

### PILASTRO 1: IL CICLO VITALE DEL REPERTORIO (PRATICA, SALA PROVE & DECAY)

#### Il Livello di "Padronanza Live" (Song Mastery: 0% – 100%)
- Ogni canzone appena composta o arrangiata non è pronta a rendere al massimo sul palco: entra nel repertorio con una **Padronanza Live base del 20%**.
- Eseguire dal vivo un brano a bassa padronanza aumenta il rischio di imprecisioni, assoli fuori tempo e sbavature, penalizzando il `Concert Score`.
- Portare il brano al **100% di Padronanza Live** ne sblocca il massimo potenziale scenico, galvanizzando il pubblico.

#### Meccanica della Sala Prove (Focus Mirato vs Dispersione)
- *Se* la band organizza una sessione in Sala Prove (dal Loft o dal menu Band), *allora* il giocatore può impostare fino a **3 brani prioritari su cui concentrarsi**.
- *Se* si provano 1 o 2 brani: ciascun brano guadagna un incremento rapido di padronanza (+25% a sessione).
- *Se* si provano 3 brani: ciascun brano guadagna un incremento moderato (+15% a sessione).
- *Se* si lasciano troppi brani in prova passiva (4 o più): la padronanza si disperde (+5% ciascuno), riprendendo il celebre principio della Popoguida ("chi troppo prova, nulla stringe").

#### Meccanica del "Decay" da Mancata Esecuzione (Arrugginimento dei Brani)
- Le canzoni possiedono una memoria dinamica:
  - *Se* un brano viene eseguito in un concerto ufficiale, la sua padronanza si rinfresca e resta al 100%.
  - *Se* un brano rimane fuori da qualsiasi scaletta o sessione di prova per più di **3 settimane virtuali (21 giorni)**, *allora* subisce l'arrugginimento: perde il 5% di padronanza ogni settimana successiva, fino a una soglia minima del 50%.
  - Questo incentiva a variare la scaletta nei tour o a convocare prove di ripasso prima dei grandi eventi.

---

### PILASTRO 2: ANATOMIA DEL CONCERTO, PACING & STAGE MOVES

#### Flusso della Scaletta (Setlist Flow & Tensione Emotiva)
La scaletta non è una lista statica, ma una curva drammaturgica:
- **Brano di Apertura (Opener)**: Deve catturare subito l'attenzione. Brani ad alto ritmo o con il tratto `EPIC_RIFF` conferiscono un bonus immediato all'attenzione del pubblico (+10% Engagement iniziale).
- **Fase Centrale (The Journey)**: Alternanza tra brani energici e ballate intense (`TEARJERKER_BALLAD`).
  - *Se* si posizionano 3 ballate lente di seguito, *allora* l'energia del pubblico cala per sonnolenza.
  - *Se* si alternano ritmi sostenuti e momenti intimi, *allora* l'emozione della platea cresce costantemente.
- **Chiusura Eclatante (Closer & Stage Beast)**: Il brano più famoso della band chiude la scaletta ufficiale, preparando il terreno per il Bis (Encore).

#### Stage Moves Reattive da Palco (Scelte Attive col Pubblico)
Oltre ai 7 eventi procedurali già esistenti, il giocatore può attivare mosse sceniche strategiche:
- **Saluto alla Città**: Chiamare la metropoli per nome (*"Ciao Milano! / Hello Tokyo!"*). Se il Carisma del Frontman è alto, genera un boost istantaneo di gradimento locale.
- **Cori con la Folla (Sing-Along)**: Invitare la folla a cantare il ritornello. Ha successo pieno se il brano è famoso o possiede il tratto `GENERATIONAL_ANTHEM`.
- **Presentazione della Band**: Dare spazio a un assolo di basso o batteria, aumentando il morale dei compagni e la coesione del gruppo.
- **Assolo Virtuoso**: Rischio/rendimento legato all'abilità dello strumentista (se riesce, tripudio del pubblico; se fallisce, errore udibile).

---

### PILASTRO 3: LA CREW PROFESSIONALE DA TOURNÉE

La band che cresce si trasforma in una vera macchina itinerante, ingaggiando a stipendio settimanale fino a 3 figure specializzate:

1. **Il Fonico di Fiducia (Sound Technician)**:
   - *Effetto*: Compensa l'acustica deficitaria dei club economici, azzera il rischio di fischi/feedback nei locali underground e aumenta del +10% la qualità percepita del suono dal pubblico.
2. **Il Roadie / Backliner**:
   - *Effetto*: Gestisce montaggio, carico e accordatura. Riduce del 60% l'usura di corde, amplificatori e cavi ad ogni concerto, e velocizza i tempi tecnici tra le date.
3. **Il Tour Manager**:
   - *Effetto*: Ottimizza spostamenti e alloggi. Riduce del 50% lo stress accumulato nei viaggi lunghi e nei voli transoceanici (protezione da Jet Lag).

---

### PILASTRO 4: GEOGRAFIA DELLA FAMA, SATURAZIONE DI PIAZZA & IL "BUZZ"

#### Reputazione Locale per Metropoli (Circuito a 16 Città)
- La notorietà non è un valore unico astratto: la band può essere un mito a Roma o Dublino e completamente sconosciuta a San Paolo o Tokyo.
- Ognuna delle 16 metropoli traccia la propria reputazione locale (da 0 a 100).

#### Il Principio di Saturazione (Cooldown di Piazza)
Estrapolato direttamente dalla regola aurea di Popomundo ("non suonare troppo presto nella stessa città"):
- *Se* la band tiene un concerto in una metropoli, *allora* quella città entra in stato di **Saturazione Recente** per **14–21 giorni virtuali**.
- *Se* il giocatore forza un secondo concerto nella stessa città prima della scadenza del cooldown:
  - L'affluenza del pubblico subisce un taglio del -40% (la folla ha già assistito allo show di recente).
  - Le vendite del banco Merchandising crollano.
  - La crescita della reputazione locale è dimezzata.
- *Se* la band pianifica una tournée itinerante circolare (es. Milano $\to$ Parigi $\to$ Berlino $\to$ Madrid) e torna a Milano dopo un mese, la piazza è nuovamente "affamata", garantendo sold-out e massimo entusiasmo.

#### Fama Duratura vs Buzz Effimero
- **Fama Duratura**: Si edifica con dischi di successo, festival estivi e concerti sold-out. È stabile e non decade facilmente.
- **Buzz Mediatico**: È la popolarità volatile a breve termine (generata da interviste radio, videoclip, post virali su BandFeed o gossip). Possiede un valore da 0 a 100 che cala del -10% ogni pochi giorni se non viene rinvigorito o capitalizzato con un evento importante.

---

## PARTE II: LA PROSPETTIVA DEL SINGOLO ARTISTA, AUTORE & COMPOSITORE

---

### PILASTRO 5: IL PROCESSO ARTIGIANALE DI CREAZIONE DEL BRANO

#### Fase 1: La Raccolta delle Ispirazioni (The Muse & Life Experience)
- L'ispirazione non si crea a comando: si accumula vivendo la vita reale del musicista.
- Andare nei locali notturni a sentire altre band, ascoltare vinili rari al giradischi del Loft, fare passeggiate notturne o vivere amori e rotture fa guadagnare **"Punti Ispirazione"**.
- All'inizio della scrittura, l'autore può investire Ispirazioni per innalzare il **Potenziale Massimo (Quality Cap)** del brano.
- *Trade-off*: investire troppe ispirazioni esterne riduce l'originalità pura del pezzo (richiamo al plagio involontario).

#### Fase 2: Identità, Sottogenere & Strumenti Dominanti
- L'autore stabilisce:
  1. Genere e Sottogenere musicale;
  2. Lo Strumento Predominante (Riff di Chitarra Elettrica, Basso Funky, Pianoforte da Ballata, Batteria Ritmica);
  3. L'Archetipo Espressivo (Inno da Stadio, Ballata Romantica, Pezzo Ritmico, Brano Complesso/Sperimentale).
- *Sinergia Band*: se lo strumento dominante della canzone corrisponde al punto di forza di un membro della band, l'esecuzione live riceve un cospicuo bonus sinergico.

#### Fase 3: La Doppia Barra di Avanzamento (Testo vs Musica)
- La composizione non è istantanea, ma procede su due binari paralleli:
  - **Avanzamento del Testo (Lyrics 0%–100%)**: guidato dall'abilità `Testi`, dalla metrica poetica e dalla profondità del tema lirico.
  - **Avanzamento della Musica (Melodia & Armonia 0%–100%)**: guidato da `Composizione`, `Teoria Musicale` e padronanza strumentale.
- Alex può lavorare al brano a blocchi di ore nel Loft (sul divano con la chitarra o alla scrivania con gli appunti).

#### Fase 4: La Finestra di Rifinitura (Arancione $\to$ Ispirazioni $\to$ Verde Brillante)
La mitica meccanica di Popomundo:
- Quando entrambe le barre raggiungono il 100%, il brano entra nello stato **"Completo in Attesa di Rifinitura" (Segnalatore Arancione)**.
- Si apre una **finestra temporale di 24–48 ore virtuali (1–2 giorni)**.
- L'autore si trova davanti a un bivio:
  - *Scelta A — Chiusura Immediata*: convalida il brano con il suo potenziale base.
  - *Scelta B — Il Colpo d'Ala*: spende da 1 a 3 Punti Ispirazione per rifinire il pezzo.
- *L'Effetto del Verde Brillante*: se l'investimento ha successo, il segnalatore diventa **Verde Brillante ("Masterpiece / Hit Potenziale")**:
  - +25% di passaggi radiofonici (Airplay) e streaming;
  - Probabilità triplicata di generare tratti leggendari (`EARWORM`, `GENERATIONAL_ANTHEM`);
  - Longevità aumentata del brano nelle classifiche prima di subire declino.
- *Scadenza*: se passano le 48 ore senza interventi, la musa sfuma e la canzone si consolida automaticamente sul livello standard.

#### Fase 5: La Sindrome del Foglio Bianco & Cooldown Creativo
- Completare un brano brillante prosciuga le energie interiori dell'autore.
- *Se* Alex termina un brano eccellente, *allora* entra nello stato **"Svuotamento Creativo"** per 3–5 giorni virtuali.
- *Se* prova a forzare la scrittura di un nuovo brano durante questo periodo, il consumo di Stress raddoppia e la nuova canzone nasce banale o priva di mordente.
- Per ricaricare la musa occorrono riposo, ascolto di dischi ed esperienze cittadine.

---

### PILASTRO 6: IL MERCATO DELLE CANZONI & L'ASTA DEI DIRITTI (THE SONG MARKETPLACE)

Questa meccanica introduce la carriera parallela dell'Autore/Ghostwriter e lo scambio economico di opere musicali:

#### A. Vendere Canzoni all'Asta (Monetizzare il Talento d'Autore)
- *Se* Alex ha nel cassetto un brano eccellente ma non adatto al genere della propria band, può metterlo **all'Asta nella Borsa dei Brani** (dal PC del Loft).
- L'asta resta aperta da 3 a 5 giorni virtuali, durante i quali etichette e band rivali fanno offerte al rialzo.
- **Due Formule di Vendita a Scelta**:
  1. *Cessione Totale (Buyout Completo)*: Alex cede tutti i diritti in cambio di un pagamento cash immediato consistente (da 2.000 € a 30.000 € per pezzi Verdi), ideale per finanziare tour o comprare strumentazione.
  2. *Cessione Editoriale con Royalties (Publishing Royalty 25%–50%)*: incasso cash ridotto, ma Alex mantiene la paternità autoriale: ogni volta che la band acquirente suona la canzone live o scala le Hit Parade, Alex riceve royalties passive continuative.

#### B. Comprare Canzoni all'Asta (Acquisire Hit Esterne)
- *Se* la band ha una scadenza imminente per consegnare un album ma Alex ha il blocco dello scrittore o poco tempo, può consultare l'Asta dei Brani.
- Alex può esaminare Genere, Strumento Dominante e Qualità indicativa a stelle, fare la propria offerta e, vincendo l'asta, incorporare il brano nel repertorio della band per provarlo e inciderlo.

---

### PILASTRO 7: ALBERO SPECIALISTICO DELLE ABILITÀ & METODI DI APPRENDIMENTO

#### Struttura ad Albero delle Competenze Musicali
Estrapolando le abilità specialistiche da Popomundo:
1. **Composizione & Scrittura**:
   - *Teoria Musicale & Armonia*: accelera la composizione della melodia e degli accordi.
   - *Scrittura Testi & Metrica Poetica*: profondità delle liriche e qualità dei temi.
   - *Specializzazioni*: Ballate romantiche, Inni da stadio, Riff & Hook ritmici.
   - *Storia del Genere*: rispetto e recensioni positive della critica specialistica.
2. **Performance & Palco**:
   - *Presenza Scenica (Showmanship)*: carisma visivo e sicurezza sul palco.
   - *Interazione col Pubblico (Crowd Control)*: efficacia di cori, applausi e Stage Moves.
   - *Improvvisazione & Virtuosismo*: assoli spettacolari con boost al Live Score.

#### I 4 Metodi di Apprendimento nel Loft & in Città (Gameplay Tangibile)
Niente più acquisizioni astratte, ma attività visibili nel tempo virtuale:
1. **Manuali & Libri di Teoria**:
   - Acquistabili nei negozi o ordinabili dal PC del Loft (es. *"Manuale di Armonia Funzionale"*, *"L'Arte della Rima"*).
   - Leggere il libro per 1 o 2 ore sul divano/letto del Loft è il requisito per **sbloccare il Livello Base (Livello 1)** di una nuova competenza.
2. **Corsi Accademici & Conservatorio**:
   - Iscrizione con retta mensile e frequenza di 2 slot orari settimanali nella metropoli. Crescita metodica e solida delle abilità teoriche.
3. **Lezioni Private da un Maestro NPC (Mentore)**:
   - Ingaggiare un veterano (maestro di canto, chitarrista jazz anziano) per lezioni a domicilio nel Loft (es. 60 € all'ora).
   - Crescita tripla rispetto all'auto-apprendimento ed eliminazione dei vizi tecnici.
4. **Pratica Individuale Quotidiana**:
   - Esercizi ed arpeggi sulla chitarra o alla tastiera nel Loft NYC. Mantiene agili le dita e calda la voce a costo zero.

---

### PILASTRO 8: ATTRITO FISICO, SALUTE & FISIOLOGIA DEL MUSICISTA

Il musicista non è una macchina:
- **Afonia / Laringite del Cantante**: causata da concerti serrati senza riposo o colpi di freddo. Impedisce il canto live, costringendo a rimpiazzi d'emergenza o alla cancellazione della data con penale.
- **Tendinite dello Strumentista**: insorge dopo troppe ore consecutive di shredding o prove estenuanti senza pause. Penalizza la precisione sul palco finché non viene curata con riposo e fisioterapia.
- **Malanni di Stagione & Postumi (Hangover)**: conseguenze di feste notturne sregolate o viaggi invernali in van non riscaldato.
- **Rimedi Fisiologici nel Loft & Farmacia**: tisane calde al miele in cucina, spray per la gola, kit di primo soccorso, visite specialistiche alla clinica medica.

---

## 4. SCHEMA DI INTEGRAZIONE NELL'ARCHITETTURA WORLD-TOUR

Questo impianto strategico si innesta in modo chirurgico sui moduli e file già convalidati nel progetto:

1. **Repertorio & Live**:
   - Estensione di `SongData` con `mastery_percentage` (0–100%), `is_masterpiece_green` (bool), `refine_window_hours` (int).
   - Aggiornamento di `BandSystem` e `ConcertSystem` con logiche di sala prove (focus su 3 brani), arrugginimento a 21 giorni, e calcolo Cooldown di Piazza su 16 metropoli.
2. **Crew da Tour**:
   - Inserimento di `CrewMemberData` (Fonico, Roadie, Tour Manager) gestibile da `UpgradesHub` e stipendi scalati nel bilancio settimanale.
3. **Mercato & Aste**:
   - Sottosistema `SongMarketplaceSystem` per registrare le aste di brani (Buyout o Royalty Split) accessibile dal PC del Loft e dalla dashboard contratti.
4. **Skills & Apprendimento nel Loft**:
   - Espansione di `PlayerData` con le nuove competenze ad albero.
   - Nuove opzioni contestuali nel menu interazioni degli arredi del Loft NYC (`ApartmentInteractions`): leggere manuali sul divano, prendere lezioni private dal maestro, esercitarsi sulle scale.

---

## CONCLUSIONE

Questo documento costituisce il riferimento strategico e concettuale definitivo per la futura evoluzione del gameplay di World-tour, fondendo l'incomparabile profondità romantica e gestionale di Popomundo con la moderna architettura deterministica, rapida e totalmente accessibile a zero mouse di Luca e Thomas.
