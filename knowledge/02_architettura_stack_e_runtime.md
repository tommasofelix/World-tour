# Architettura, stack e runtime

## Baseline osservata al 2026-09-21

- Codice sorgente: assente.
- Linguaggi applicativi: non determinati.
- Framework: non determinato.
- Gestore dipendenze: assente.
- Sistema di build: assente.
- Suite di test: assente.
- Pipeline CI/CD: assente.

## Ambiente disponibile rilevato

- Git 2.45.2 per Windows.
- Java 22 disponibile nel `PATH`.
- Python 3.12.0 disponibile nel `PATH`.
- Rust/Cargo non presente nel `PATH`.

La disponibilità di un runtime sulla macchina non implica che il progetto lo adotti.

## Cancello di aggiornamento

Questa scheda dovrà essere aggiornata soltanto dopo l’introduzione o la scelta esplicita dello stack. Dovrà allora registrare:

- versioni supportate;
- prerequisiti obbligatori e opzionali;
- comandi di build, test ed esecuzione;
- variabili d’ambiente senza valori sensibili;
- vincoli di portabilità e rollback.
