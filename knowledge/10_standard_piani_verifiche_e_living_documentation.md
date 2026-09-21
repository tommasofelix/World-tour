# Standard per piani, verifiche e documentazione viva

## Stati distinti

- Proposta: soluzione non ancora autorizzata.
- Piano: contratti operativi approvati per la sola pianificazione.
- Implementazione: modifica applicata ma non necessariamente verificata.
- Verifica automatica: controlli tecnici eseguiti con esito registrato.
- Collaudo manuale: comportamento osservato dall’utente nel contesto reale.
- Chiusura: obiettivo accettato e documentazione allineata.

## Flusso

1. Fase 0: analisi del risultato richiesto e delle alternative proporzionate.
2. Fase 1A: piano tecnico in `docs/piani/attivi/` e stop obbligatorio.
3. Fase 1B: implementazione e test soltanto dopo autorizzazione specifica.
4. Fase 2: eventuale deploy e collaudo manuale autorizzati separatamente.
5. Fase 3: chiusura, changelog e archiviazione dopo evidenza sufficiente.
6. Fase 4: eventuale aggiornamento della knowledge dopo nuova autorizzazione.

## Contratti dei piani

- Numerare le attività come `D0`, `D1` e successive.
- Usare `[ ]` per aperto, `[/]` per in corso e `[x]` soltanto per verificato.
- Specificare input, output, file coinvolti, rischi, rollback e criterio di accettazione.
- Distinguere sempre test eseguiti da test proposti.

## Igiene documentale

- Le informazioni hanno una sola fonte di verità e vengono collegate tramite link relativi.
- Le voci più recenti dei registri sono collocate in cima.
- I router restano sintetici; i dettagli vivono nella knowledge.
