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

enum BandRole {
	BASS,             # Bassista (Groove & stabilità)
	DRUMS,            # Batterista (Ritmo & potenza sonora)
	KEYBOARDS,        # Tastierista (Atmosfera & armonie)
	GUITAR_RHYTHM     # Chitarrista ritmico (Muro di suono)
}

enum BandPersonality {
	RELIABLE,         # Affidabile e calmo: -Tensione, +Puntualità
	PERFECTIONIST,    # Perfezionista: +Qualità live, genera Tensione con performance scarse
	WILD_PARTY,       # Animale da festa: +Presenza scenica, rischio imprevisti
	EGO_ARTIST        # Ego smisurato: grande talento, permaloso su scaletta e compensi
}

enum RevenueSplit {
	EQUAL_SPLIT,      # Paritaria (25% a ciascun membro attivo)
	LEADER_BALANCED,  # Leader 40%, compagni 20% ciascuno
	LEADER_PREDATORY  # Leader 70%, compagni 10% ciascuno
}

enum AlbumType {
	EP,               # Extended Play (3-5 tracce)
	LP                # Long Play / Full Album (6-10 tracce)
}

enum AlbumConcept {
	CONCEPTUAL,       # Album tematico concettuale (+Recensioni critiche)
	COMMERCIAL_HIT,   # Orientato alle hit radiofoniche (+Vendite/Streaming)
	RAW_UNDERGROUND   # Registrazione grezza e autentica (+Fan fedeli live)
}

enum ArtworkStyle {
	MINIMALIST,
	RETRO_PSYCHEDELIC,
	DARK_METAL,
	STREET_GRAFFITI
}

enum HousingTier {
	STARTER_BEDROOM,  # Stanzetta singola (15 €/giorno)
	SHARED_FLAT,      # Appartamento condiviso con la band (25 €/giorno totali)
	LOFT_STUDIO,      # Loft con sala prove inclusa (50 €/giorno)
	LUXURY_VILLA      # Villa con studio professionale (150 €/giorno)
}

enum ContractType {
	SELF_RELEASED,    # Autoproduzione / Indipendente totale (100% royalties, 0 anticipo)
	INDIE_LABEL,      # Etichetta indipendente (45% royalties, anticipo modesto, piena libertà)
	MAJOR_LABEL       # Major multinazionale (15% royalties, grande anticipo, recoupment e vincoli A&R)
}

enum ManagerType {
	NONE,             # Nessun manager
	TRUSTED_FRIEND,   # Amico fidato (10% commissione, bonus live modesto)
	PRO_INDIE,        # Professionista indipendente (15% commissione, ottimo booking)
	INDUSTRY_SHARK    # Squalo dell'industria (22% commissione, mega booking e contatti top)
}

enum DilemmaCategory {
	COMMERCIAL_ETHICS, # Scelte tra soldi facili e dignità artistica
	BAND_INTERNAL,     # Conflitti interni e gelosie
	MEDIA_SCANDAL,     # Dichiarazioni e relazioni pubbliche
	ARTISTIC_INTEGRITY # Richieste di compromesso sui testi/musica
}

# --- Calendario Sistemico & Cicli Temporali (SP-09 / V4.0) ---
enum Weekday {
	MONDAY = 0,
	TUESDAY = 1,
	WEDNESDAY = 2,
	THURSDAY = 3,
	FRIDAY = 4,
	SATURDAY = 5,
	SUNDAY = 6
}

enum Season {
	SPRING = 0,
	SUMMER = 1,
	AUTUMN = 2,
	WINTER = 3
}

enum CalendarEventType {
	CONCERT = 0,
	REHEARSAL = 1,
	STUDIO_BOOKING = 2,
	CONTRACT_DEADLINE = 3,
	RENT_DUE = 4,
	FESTIVAL = 5,
	TOUR_STOP = 6
}

# --- Mondo Dinamico, Tour, Festival & Social (V4.0) ---
enum CityId {
	MILANO = 0,
	BOLOGNA = 1,
	ROMA = 2,
	NAPOLI = 3,
	LONDRA = 4,
	BERLINO = 5
}

enum TourVehicleType {
	RUSTY_VAN = 0,    # Furgone scassato (economico, +15 stress per tappa, rischio guasto)
	PRO_VAN = 1,      # Van professionale (bilanciato, +5 stress)
	LUXURY_BUS = 2    # Tour bus di lusso (0 stress, costo elevato)
}

enum FestivalSlot {
	OPENING_AFTERNOON = 0, # Slot pomeridiano di apertura
	SUNSET_SLOT = 1,       # Slot al tramonto
	HEADLINER_NIGHT = 2    # Headliner notturno principale
}

enum SocialPostType {
	PRACTICE_CLIP = 0,     # Video prove / backstage
	TRACK_TEASER = 1,      # Teaser di un brano o singolo
	BEHIND_THE_SCENES = 2, # Vita da band / tour
	PROVOCATION = 3        # Post provocatorio / meme
}

static func get_genre_name(genre: int) -> String:
	match genre:
		MusicalGenre.ROCK:
			return "Rock"
		MusicalGenre.POP:
			return "Pop"
		MusicalGenre.METAL:
			return "Metal"
		MusicalGenre.HIPHOP:
			return "Hip Hop"
		MusicalGenre.ELECTRONIC:
			return "Elettronica"
		MusicalGenre.INDIE:
			return "Indie"
		_:
			return "Rock"

static func get_city_name(city_id: int) -> String:
	match city_id:
		CityId.MILANO:
			return "Milano"
		CityId.BOLOGNA:
			return "Bologna"
		CityId.ROMA:
			return "Roma"
		CityId.NAPOLI:
			return "Napoli"
		CityId.LONDRA:
			return "Londra"
		CityId.BERLINO:
			return "Berlino"
		_:
			return "Sconosciuta"

static func get_festival_slot_name(slot: int) -> String:
	match slot:
		FestivalSlot.OPENING_AFTERNOON:
			return "Slot Pomeridiano (Apertura)"
		FestivalSlot.SUNSET_SLOT:
			return "Slot al Tramonto (Golden Hour)"
		FestivalSlot.HEADLINER_NIGHT:
			return "Headliner Notturno (Prime Time)"
		_:
			return "Slot Non Assegnato"



