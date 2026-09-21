# World-tour — Direttive locali per OpenAI Codex

- Framework: ASTRALIS, baseline pubblica `main@d28d1f9`.
- Ruolo predefinito di Codex: copilota ausiliario e revisore, salvo mandato operativo esplicito.
- Hub di contesto: [`GEMINI.md`](./GEMINI.md).
- Repository pubblico: nessun dato personale, percorso macchina o contenuto del Master Hub privato.

## Caricamento progressivo

- Per richieste brevi usare questo file e `GEMINI.md`.
- Per analisi o pianificazione consultare soltanto da una a tre schede pertinenti in [`knowledge/`](./knowledge/).
- Non caricare in massa documentazione, piani completati o archivi.

## Vincoli operativi

1. Richieste come “analizza”, “verifica”, “valuta” o “cosa ne pensi?” impongono modalità consultiva e sola lettura.
2. Modifiche a file o configurazioni richiedono un comando esplicito e circoscritto come “procedi”, “applica” o “esegui”.
3. L’autorizzazione a scrivere un piano non autorizza codice, build, test, deploy, commit, push, cancellazioni o chiusura.
4. Prima di eliminare qualsiasi elemento spiegare motivo, impatto, recuperabilità e attendere un consenso specifico.
5. Distinguere sempre evidenza osservata, inferenza, proposta e risultato validato.
6. Tutte le procedure devono funzionare da tastiera ed essere descritte linearmente per NVDA, senza diagrammi bidimensionali.
7. Usare percorsi relativi o variabili d’ambiente. Non introdurre percorsi utente o segreti nei file pubblici.
8. Mantenere i router sotto 250 righe e collocare i dettagli nelle schede `knowledge/`.
9. Non creare configurazioni per strumenti o assistenti non presenti e non richiesti.
10. Non effettuare commit o push senza autorizzazione separata.

## Fonti operative

- Governance e gating: [`knowledge/00_consuetudini_operative_e_sinergia_assistente.md`](./knowledge/00_consuetudini_operative_e_sinergia_assistente.md).
- Accessibilità: [`knowledge/01_accessibilita_vocale_e_interazione_tastiera.md`](./knowledge/01_accessibilita_vocale_e_interazione_tastiera.md).
- Stack rilevato: [`knowledge/02_architettura_stack_e_runtime.md`](./knowledge/02_architettura_stack_e_runtime.md).
- Git: [`knowledge/03_standard_git_branching_e_commit.md`](./knowledge/03_standard_git_branching_e_commit.md).
- Piani e verifiche: [`knowledge/10_standard_piani_verifiche_e_living_documentation.md`](./knowledge/10_standard_piani_verifiche_e_living_documentation.md).
