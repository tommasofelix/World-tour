# 03 — Standard Git, Branching, Release AVF & Commit (v3.0.7)

## Stato del Repository
- **Ramo Principale**: `main`.
- **Remoto Ufficiale**: `origin` (`tommasofelix/World-tour`).
- **Visibilità**: Repository Pubblico Open Source.
- **Disciplina di Release**: Sistema di Versionamento AVF (`V.A.R[.M]`).

---

## 1. La Disciplina di Versionamento AVF (`V.A.R[.M]`)

I numeri di versione del progetto adottano la notazione deterministica AVF di ASTRALIS:
- **`V` (Versione / Macro-Fase)**: Incrementata al completamento di una macro-fase di roadmap (es. da V4.0 Mondo Dinamico a V5.0 Endgame & Superstar Mondiale);
- **`A` (Architettura / Modulo)**: Incrementata con l'introduzione di nuovi sottosistemi completi, refactoring strutturali o contratti di dominio;
- **`R` (Revisione / Collaudo)**: Incrementata con la chiusura di pacchetti di rifinitura post-collaudo NVDA (PRAPI) o nuove suite di test;
- **`M` (Micro-Fix / Hotfix)**: Incrementata per correzioni puntuali a caldo di regressioni o difetti bloccanti.

---

## 2. Canone 7 — Il Commit di Sicurezza Pre-Bonifica (Canone D41 Guard)

Quando un'iterazione complessa di gameplay o interfaccia ha superato il collaudo funzionale con NVDA e si procede alla rimozione di codice deprecato, vecchie classi o residui orfani (Contratto D0 Clean Sweep):
1. **Punto di Ripristino Immediato**: È obbligatorio eseguire un commit Git di sicurezza dedicato con stato di funzionamento garantito PRIMA di avviare la bonifica;
2. **Bonifica Atomica & Test Seams**: La rimozione del codice obsoleto avviene a lotti circoscritti, seguita immediatamente dall'esecuzione della suite di test headless per accertare l'assenza di rotture;
3. **Commit di Chiusura Bonifica**: A pulizia completata e test verdi confermati, viene registrato il commit definitivo (`refactor:` o `chore:`).

---

## 3. Disaccoppiamento Commit vs Push & Convenzioni Naming

1. **Commit Focalizzati e Semantici**:
   - `feat:` Nuove funzionalità di gioco, schermate o sistemi;
   - `fix:` Risoluzione di anomalie riscontrate nei test o convalidate nel `REGISTRO_REVISIONI.md`;
   - `docs:` Aggiornamento di piani, registri o schede in `knowledge/`;
   - `refactor:` Ristrutturazione di codice senza alterazione del comportamento esterno;
   - `test:` Aggiunta o estensione di suite di test headless;
   - `chore:` Manutenzione script, configurazioni o allineamenti di governance.
2. **Disaccoppiamento Rigoroso tra Commit e Push**:
   - L'autorizzazione ad applicare modifiche, registrare il commit Git o aggiornare la Living Documentation locale **NON autorizza automaticamente il push su repository remoto**;
   - Il comando `git push origin <ramo>` richiede una specifica e separata conferma esplicita di Luca.

---

## 4. Verifiche Obbligatorie Prima di Proporre un Commit

1. `git status --short --branch`: Controllo dei file modificati e assenza di file non tracciati indesiderati (`.import/`, log effimeri);
2. `git diff --check`: Verifica assenza di spaziature anomale o terminazioni di riga conflittuali;
3. **Controllo Igiene Confini Pubblici**: Scansione preventiva per accertare che non siano presenti percorsi macchina personali assoluti, password o credenziali;
4. **Esecuzione Test Headless Pertinenti**: Verifica con esito positivo (exit code 0) delle suite di test relative ai sistemi toccati.
