# res://core/enums.gd
class_name Enums
extends RefCounted

## Enumerazioni e Tipi Centralizzati di World-tour

enum GameState {
	BOOT,                   # Inizializzazione configurazioni e audio
	MAIN_MENU,              # Menu principale (Nuova Partita, Carica, Opzioni, Esci)
	CHARACTER_CREATION,     # Scelta anagrafica, background e strumento iniziale
	GAMEPLAY_IDLE,          # Mondo attivo, orologio che scorre, giocatore libero
	GAMEPLAY_BUSY,          # Azione in corso con blocco azioni concorrenti
	GAMEPLAY_PAUSED,        # Simulazione temporale congelata
	DAILY_SUMMARY,          # Schermata riepilogativa a mezzanotte
	GAME_OVER               # Fine partita per bancarotta o burnout
}

enum MusicalGenre {
	ROCK,
	POP,
	METAL,
	HIPHOP,
	ELECTRONIC,
	INDIE
}

enum TimePeriod {
	MORNING,    # 06:00 - 12:00
	AFTERNOON,  # 12:00 - 18:00
	EVENING,    # 18:00 - 24:00
	NIGHT       # 00:00 - 06:00 (Overtime)
}

enum CareerTier {
	NOBODY,             # Livello 0: Nessuno
	BEDROOM_MUSICIAN,   # Livello 1: Musicista da cameretta
	BUSKER,             # Livello 2: Artista di strada
	LOCAL_ARTIST,       # Livello 3: Attrazione locale nei pub
	UNDERGROUND_HERO,   # Livello 4: Eroe della scena underground
	INDIE_SENSATION,    # Livello 5: Fenomeno indie nazionale
	NATIONAL_STAR,      # Livello 6: Stella della musica nazionale
	GLOBAL_SUPERSTAR    # Livello 7: Icona e superstar mondiale
}

enum SkillType {
	INSTRUMENT,     # Esecuzione e tecnica strumentale
	COMPOSITION,    # Composizione e arrangiamento
	SONGWRITING,    # Scrittura testi e poetica
	PRODUCTION,     # Produzione e missaggio sonoro
	PERFORMANCE,    # Presenza scenica dal vivo
	CHARISMA,       # Magnetismo e comunicazione col pubblico
	BUSINESS        # Senso degli affari e negoziazione contratti
}

enum SongStatus {
	DRAFT,          # Bozza in lavorazione (fasi 1-4)
	PRODUCED,       # Master completato e pronto per il rilascio
	RELEASED        # Pubblicato sul mercato come Singolo, EP o Album
}

enum SongStage {
	CONCEPT,        # Fase 1: Scelta Genere, Tema e Titolo
	COMPOSITION,    # Fase 2: Riff, Accordi ed Armonia
	SONGWRITING,    # Fase 3: Testi e Metrica
	RECORDING,      # Fase 4: Registrazione Strumento / Voce
	MIXING,         # Fase 5: Missaggio e Mastering
	COMPLETED       # Lavorazione ultimata
}

enum SongTrait {
	NONE,           # Nessun tratto speciale
	EARWORM,        # Tormentone (+25% ascolti nei primi 30gg)
	CULT_CLASSIC,   # Pezzo Cult (converte x2 fan ai live)
	STAGE_BEAST,    # Bomba dal Vivo (+15% Concert Score se in chiusura)
	AUDIOPHILE_GEM, # Gemma per Audiofili (recensioni eccellenti, req. Prod >= 70)
	ROUGH_DIAMOND   # Diamante Grezzo (buona composizione ma registrata low-fi)
}

enum StageEventType {
	NONE,
	BROKEN_STRING,    # Corda spezzata
	AUDIO_FEEDBACK,   # Fischio monitor
	ENTHUSIASTIC_FAN  # Fan che sale sul palco
}

