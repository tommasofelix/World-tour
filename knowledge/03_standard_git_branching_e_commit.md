# Standard Git, branching e commit

## Stato del repository

- Ramo predefinito osservato: `main`.
- Remoto: `origin`.
- Repository pubblico.
- Strategia di release: non ancora definita.

## Regole

- Verificare repository, ramo e working tree prima di ogni modifica.
- Non usare comandi distruttivi per scartare modifiche non proprie.
- Non committare o pubblicare senza autorizzazione esplicita e separata.
- Mantenere commit focalizzati e descrittivi.
- Usare prefissi semantici quando appropriato: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`.
- Usare un ramo dedicato per modifiche complesse o destinate a revisione.
- Preservare la lingua e le convenzioni dei contenuti destinati a collaboratori esterni.

## Verifiche prima di proporre un commit

1. `git status --short --branch`.
2. Esame completo del diff.
3. `git diff --check`.
4. Test pertinenti realmente eseguiti, oppure indicazione esplicita che non sono disponibili.
5. Controllo che non siano presenti segreti, percorsi personali o file locali.
