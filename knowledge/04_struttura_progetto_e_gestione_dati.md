# Struttura del progetto e gestione dei dati

## Struttura di governance

- `GEMINI.md`: router per l’AI primaria.
- `AGENTS.md`: router locale per Codex.
- `knowledge/`: contratti e conoscenza specifica.
- `docs/strategie/attive/`: analisi strategiche correnti.
- `docs/piani/attivi/`: piani tecnici autorizzati.
- `docs/piani/completati/`: piani chiusi con evidenza.
- `docs/report/`: registri, audit e report.
- `docs/idee/`: proposte non ancora autorizzate.
- `docs/manuali/`: guide operative validate.

## Confini dei dati

- Contenuto pubblico: documentazione agnostica, codice del progetto e configurazioni portabili approvate.
- Contenuto locale: preferenze personali, percorsi macchina, log diagnostici, cache e configurazioni dell’editor.
- Contenuto riservato: credenziali, segreti, dati personali e documenti del Master Hub privato.

I contenuti locali o riservati non devono essere copiati nel repository. I percorsi persistenti devono essere relativi o risolti tramite variabili d’ambiente.

## Stato applicativo

La struttura del codice e dei dati applicativi non è ancora definita. Nessuna cartella `src/`, formato dati o strategia di persistenza viene presunta.
