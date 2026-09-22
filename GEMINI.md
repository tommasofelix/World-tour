# World-tour — Hub di contesto locale

- Framework: ASTRALIS, baseline pubblica `main@d28d1f9`.
- Stato del progetto: Fase 5 completata (MVG V1.3); Fase 6A completata e verificata con successo (Identità del Musicista & Scheda Personaggio — Opzione 1); pronti per l'espansione V2.0 (Fase 6B: Routine, Svago e Recupero Psico-Fisico o Formati Disco Estesi); stack confermato Godot Engine 4.7.2 win64.
- Repository: pubblico; mantenere fuori dati personali e governance privata.
- AI primaria: Antigravity, salvo diversa decisione esplicita del responsabile del progetto.
- Collaboratori ausiliari: attivati soltanto quando presenti o richiesti.

## Fonti di verità

Consultare in quest’ordine e soltanto nella misura necessaria:

1. Questo file per il contesto sintetico.
2. [`knowledge/`](./knowledge/) per contratti e informazioni specialistiche.
3. [`docs/todo.md`](./docs/todo.md) per la master roadmap e il coordinamento delle fasi.
4. [`docs/piani/attivi/`](./docs/piani/attivi/) per i piani e sottopiani tecnici autorizzati.
5. [`docs/report/REGISTRO_REVISIONI.md`](./docs/report/REGISTRO_REVISIONI.md) per anomalie e collaudi aperti.

## Regole operative sintetiche

- Analizzare e proporre prima di modificare.
- Modificare soltanto dopo un’autorizzazione esplicita riferita all’oggetto e alla fase.
- Non confondere proposta, piano, implementazione, build, test, deploy, collaudo e chiusura.
- Non cancellare dati o file senza motivazione, analisi d’impatto e autorizzazione specifica.
- Non dichiarare verificato ciò che non è stato osservato con evidenze pertinenti.
- Usare procedure lineari, completamente accessibili da tastiera e leggibili con NVDA.
- Evitare duplicazioni: i dettagli appartengono alle schede `knowledge/`, non a questo router.
- Usare percorsi relativi o variabili d’ambiente; non versionare percorsi personali.

## Indice della knowledge locale

- [`00_consuetudini_operative_e_sinergia_assistente.md`](./knowledge/00_consuetudini_operative_e_sinergia_assistente.md): gating, ruoli e autorizzazioni.
- [`01_accessibilita_vocale_e_interazione_tastiera.md`](./knowledge/01_accessibilita_vocale_e_interazione_tastiera.md): accessibilità e verifica NVDA.
- [`02_architettura_stack_e_runtime.md`](./knowledge/02_architettura_stack_e_runtime.md): stack e prerequisiti osservati.
- [`03_standard_git_branching_e_commit.md`](./knowledge/03_standard_git_branching_e_commit.md): disciplina Git locale.
- [`04_struttura_progetto_e_gestione_dati.md`](./knowledge/04_struttura_progetto_e_gestione_dati.md): struttura e confini dei dati.
- [`05_game_design_e_vertical_slice.md`](./knowledge/05_game_design_e_vertical_slice.md): identità del simulatore musicale e slice.
- [`09_registro_bug_e_soluzioni.md`](./knowledge/09_registro_bug_e_soluzioni.md): problemi confermati e soluzioni validate.
- [`10_standard_piani_verifiche_e_living_documentation.md`](./knowledge/10_standard_piani_verifiche_e_living_documentation.md): piani, verifiche e chiusura.

## Parametri del progetto

- Scopo e dominio: Music Career Simulator / Life Simulation (GDD e sottopiani in [`docs/piani/attivi/sottopiani/`](./docs/piani/attivi/sottopiani/)).
- Responsabili: Luca & Holy Diver.
- Coordinatore operativo: [`docs/todo.md`](./docs/todo.md).
- Stack confermato: Godot Engine 4.7.2 win64, GDScript 2.0, Clean Architecture e AccessKit nativo.

