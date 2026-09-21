# Consuetudini operative e sinergia con gli assistenti

## Stato

- Ambito: progetto World-tour.
- Fonte: baseline pubblica ASTRALIS `main@d28d1f9`.
- Dominio applicativo: non ancora determinato.

## Dialogo a due tempi

1. L’assistente analizza, verifica e propone.
2. Il responsabile autorizza esplicitamente l’oggetto e la fase successiva.
3. L’assistente esegue soltanto quanto autorizzato.
4. Il risultato rimane “implementato ma non validato” finché non esistono evidenze pertinenti.

Le autorizzazioni non si propagano automaticamente tra piano, codice, configurazione, test, deploy, commit, push, cancellazione e chiusura.

## Ruoli

- L’AI primaria coordina eventuali modifiche autorizzate.
- Un’AI ausiliaria opera come revisore indipendente e non modifica in concorrenza gli stessi file.
- Se il ruolo non è dichiarato, l’assistente lo esplicita prima di un’azione operativa.

## Validazione preventiva

Ogni proposta non banale viene valutata per:

- validità;
- efficacia;
- coerenza;
- completezza;
- precisione;
- prestazioni e affidabilità;
- assenza di regressioni.

La simulazione considera:

- percorso normale;
- concorrenza o alternative;
- casi limite e fallimenti recuperabili.

## Eliminazione protetta

Prima di cancellare un file o dato:

1. identificare esattamente il bersaglio;
2. spiegare la necessità;
3. verificare dipendenze e perdita potenziale;
4. descrivere la possibilità di recupero;
5. ottenere autorizzazione esplicita.
