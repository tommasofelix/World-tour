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
	NONE,                # Nessun tratto speciale
	EARWORM,             # Tormentone (+25% ascolti nei primi 30gg)
	CULT_CLASSIC,        # Pezzo Cult (converte x2 fan ai live)
	STAGE_BEAST,         # Bomba dal Vivo (+15% Concert Score se in chiusura)
	AUDIOPHILE_GEM,      # Gemma per Audiofili (recensioni eccellenti, req. Prod >= 70)
	ROUGH_DIAMOND,       # Diamante Grezzo (buona composizione ma registrata low-fi)
	GENERATIONAL_ANTHEM, # Inno Generazionale (+30% engagement nei live, boost reputazione)
	TEARJERKER_BALLAD,   # Ballata Strappalacrime (+20% morale del pubblico nei live)
	EPIC_RIFF            # Riff Epico (+20% memorabilità live per generi rock/metal)
}

enum StageEventType {
	NONE,
	BROKEN_STRING,    # Corda spezzata
	AUDIO_FEEDBACK,   # Fischio monitor
	ENTHUSIASTIC_FAN, # Fan che sale sul palco
	BLACKOUT,         # Calo improvviso di tensione elettrica
	CROWD_CHANT,      # Cori da stadio spontanei della folla
	PIT_FIGHT,        # Rissa nel mosh pit
	STAGE_DIVING      # Tuffo dal palco / crowd surfing
}

enum VenueBookingStatus {
	FREE,             # Libero per stasera o per prenotazioni future
	BOOKED_OTHER,     # Occupato da altra band o serata a tema
	MAINTENANCE,      # Chiuso per riposo o manutenzione tecnica
	BOOKED_PLAYER     # Già prenotato da Alex e dalla band
}

enum BandRole {
	BASS,             # Bassista (Groove & stabilità)
	DRUMS,            # Batterista (Ritmo & potenza sonora)
	KEYBOARDS,        # Tastierista (Atmosfera & armonie)
	GUITAR_RHYTHM,    # Chitarrista ritmico (Muro di suono)
	VOCALS            # Cantante / Voce Principale (Interpretazione, carisma e presenza scenica)
}

enum BandPersonality {
	RELIABLE,         # Affidabile e calmo: -Tensione, +Puntualità
	PERFECTIONIST,    # Perfezionista: +Qualità live, genera Tensione con performance scarse
	WILD_PARTY,       # Animale da festa: +Presenza scenica, rischio imprevisti
	EGO_ARTIST,       # Ego smisurato: grande talento, permaloso su scaletta e compensi
	MERCENARY,        # Mercenario: pragmatico, motivato dal denaro, intollerante a quote basse
	STAGE_ANXIOUS,    # Ansioso da Palco: sensibile alla pressione dei grandi palchi
	NATURAL_LEADER,   # Leader Naturale: trainante ma potenziale attrito di leadership
	PEACEMAKER        # Pacificatore: mediatore empatico, mitiga la tensione e favorisce l'intesa
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

enum LabelPhilosophy {
	UNDERGROUND_INDIE = 0, # Massima integrità e fedeltà della scena
	MAINSTREAM_POP = 1,    # Orientata alle classifiche e vendite
	ROCK_HERITAGE = 2,     # Produzioni analogiche e virtuosismo
	EXPERIMENTAL = 3       # Suoni d'avanguardia ed esplorazione
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
	BERLINO = 5,
	DUBLINO = 6,
	PARIGI = 7,
	MADRID = 8,
	NEW_YORK = 9,
	LOS_ANGELES = 10,
	TOKYO = 11
}

enum RoadDilemmaType {
	FLAT_TIRE_RAIN = 0,    # Foratura in autostrada sotto la pioggia
	REST_STOP_NIGHT = 1,   # Sosta in autogrill alle 03:00
	BUDGET_MOTEL = 2,      # Motel economico lungo la statale
	LOST_ROUTE = 3         # Smarrimento del percorso / deviazione
}

enum CityEventType {
	NONE = 0,
	WHITE_NIGHT = 1,         # Notte Bianca (+100% affluenza concerti, +50% fan)
	MUSIC_EXPO = 2,          # Fiera Internazionale della Musica (-20% req etichette/manager, +5 rep)
	STREET_CULTURE_FEST = 3  # Festival Culturale Urbano (+35% affluenza pub/club, +30% merch)
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

enum FestivalStageType {
	MAIN_STAGE = 0,        # Palco principale (folla oceanica, massima visibilità)
	UNDERGROUND_TENT = 1   # Tenda underground (intima, generi viscerali, +50% conv. fan, +30% merch)
}

enum FestivalExtremeMove {
	NONE = 0,         # Performance regolare e pulita senza rischi
	STAGE_DIVING = 1, # Tuffo nella folla (check Fisico/Carisma)
	RIGGING_CLIMB = 2,# Scalata tralicci luci (check Performance)
	CROWD_SOLO = 3    # Assolo/cantato in mezzo alla folla (check Abilità Strumento)
}

enum FestivalSponsorType {
	NONE = 0,            # Nessuno sponsor
	ENERGY_DRINK = 1,    # Energy drink (denaro + boost energia)
	CRAFT_BEER = 2,      # Birrificio artigianale (denaro + morale/tensione)
	STREETWEAR_GEAR = 3  # Abbigliamento streetwear/rock (denaro + carisma)
}

enum FestivalWeather {
	SUNNY_HEATWAVE = 0,  # Sole cocente / Canicola estiva (più fatica, più vendite merch/bibite)
	PERFECT_MILD = 1,    # Clima mite ideale (nessun malus)
	SUMMER_STORM = 2     # Temporale estivo e fango (bivio: suonare sotto il diluvio vs stop)
}

enum SocialPostType {
	PRACTICE_CLIP = 0,     # Video prove / backstage
	TRACK_TEASER = 1,      # Teaser di un brano o singolo
	BEHIND_THE_SCENES = 2, # Vita da band / tour
	PROVOCATION = 3,       # Post provocatorio / meme
	LIVE_STREAM = 4,       # Diretta streaming con i fan
	COUNTDOWN_TEASER = 5   # Countdown pre-uscita singolo/disco
}

enum SocialSponsorBudget {
	NONE = 0,
	LIGHT = 100,    # 100 € (+100% reach)
	MEDIUM = 250,   # 250 € (+250% reach)
	HEAVY = 500     # 500 € (+500% reach)
}

enum RivalRelationship {
	RESPECTFUL = 0,     # Rispetto reciproco e stima professionale
	NEUTRAL = 1,        # Distacco formale / Concorrenza ordinaria
	HEATED_RIVAL = 2,   # Competizione accesa e punzecchiature
	OPEN_FEUD = 3       # Faida aperta, dissing e scontro mediatico
}

enum ChartScope {
	CONTINENTAL = 0,    # Hit Parade Europea / Continentale
	NATIONAL = 1        # Hit Parade specifica per Nazione/Territorio
}

enum BroadcastMediaType {
	LOCAL_RADIO = 0,     # Radio locale della metropoli (Hype moderato, basso costo energia)
	MUSIC_TELEVISION = 1,# Emittente musicale TV (Grande impatto visivo/fama, req. Tier >= 4)
	CULTURE_PODCAST = 2, # Podcast tematico e intervista lunga (Reputazione e fedeltà fan)
	SPECIALIZED_PRESS = 3# Rassegna stampa / Rivista musicale di settore (Critica e rispetto)
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
		CityId.DUBLINO:
			return "Dublino"
		CityId.PARIGI:
			return "Parigi"
		CityId.MADRID:
			return "Madrid"
		CityId.NEW_YORK:
			return "New York"
		CityId.LOS_ANGELES:
			return "Los Angeles"
		CityId.TOKYO:
			return "Tokyo"
		_:
			return "Sconosciuta"

static func get_road_dilemma_name(dilemma: int) -> String:
	match dilemma:
		RoadDilemmaType.FLAT_TIRE_RAIN:
			return "Foratura sotto la Pioggia"
		RoadDilemmaType.REST_STOP_NIGHT:
			return "Sosta in Autogrill alle 03:00"
		RoadDilemmaType.BUDGET_MOTEL:
			return "Motel Economico sulla Statale"
		RoadDilemmaType.LOST_ROUTE:
			return "Smarrimento del Percorso"
		_:
			return "Nessun Imprevisto"

static func get_city_event_name(event_type: int) -> String:
	match event_type:
		CityEventType.WHITE_NIGHT:
			return "Notte Bianca"
		CityEventType.MUSIC_EXPO:
			return "Fiera Internazionale della Musica"
		CityEventType.STREET_CULTURE_FEST:
			return "Festival Culturale Urbano"
		_:
			return "Nessun Evento"

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

static func get_social_post_type_name(post_type: int) -> String:
	match post_type:
		SocialPostType.PRACTICE_CLIP:
			return "Clip delle Prove"
		SocialPostType.TRACK_TEASER:
			return "Teaser di un Brano"
		SocialPostType.BEHIND_THE_SCENES:
			return "Dietro le Quinte / Backstage"
		SocialPostType.PROVOCATION:
			return "Post Provocatorio / Meme"
		SocialPostType.LIVE_STREAM:
			return "Diretta Live Streaming"
		SocialPostType.COUNTDOWN_TEASER:
			return "Countdown Pre-Uscita"
		_:
			return "Post Sconosciuto"

static func get_venue_booking_status_name(status: int) -> String:
	match status:
		VenueBookingStatus.FREE:
			return "Libero"
		VenueBookingStatus.BOOKED_OTHER:
			return "Occupato da altra band"
		VenueBookingStatus.MAINTENANCE:
			return "Chiuso per manutenzione"
		VenueBookingStatus.BOOKED_PLAYER:
			return "Tuo concerto in programma"
		_:
			return "Sconosciuto"

static func get_stage_event_type_name(event_type: int) -> String:
	match event_type:
		StageEventType.BROKEN_STRING:
			return "Corda Spezzata"
		StageEventType.AUDIO_FEEDBACK:
			return "Fischio Monitor"
		StageEventType.ENTHUSIASTIC_FAN:
			return "Fan sul Palco"
		StageEventType.BLACKOUT:
			return "Blackout Elettrico"
		StageEventType.CROWD_CHANT:
			return "Cori della Folla"
		StageEventType.PIT_FIGHT:
			return "Rissa nel Pit"
		StageEventType.STAGE_DIVING:
			return "Tuffo dal Palco"
		_:
			return "Nessun Imprevisto"

static func get_festival_stage_type_name(stage_type: int) -> String:
	match stage_type:
		FestivalStageType.MAIN_STAGE:
			return "Palco Principale (Main Stage)"
		FestivalStageType.UNDERGROUND_TENT:
			return "Tenda Underground (Stage Secondario)"
		_:
			return "Palco Principale"

static func get_festival_extreme_move_name(move: int) -> String:
	match move:
		FestivalExtremeMove.STAGE_DIVING:
			return "Stage Diving (Salto nella Folla)"
		FestivalExtremeMove.RIGGING_CLIMB:
			return "Arrampicata sui Tralicci Luci"
		FestivalExtremeMove.CROWD_SOLO:
			return "Assolo in Mezzo alla Folla"
		FestivalExtremeMove.NONE:
			return "Show Regolare (Zero Rischi)"
		_:
			return "Nessuna Mossa"

static func get_festival_sponsor_type_name(sponsor: int) -> String:
	match sponsor:
		FestivalSponsorType.ENERGY_DRINK:
			return "Sponsor Energy Drink Extreme"
		FestivalSponsorType.CRAFT_BEER:
			return "Sponsor Birrificio Artigianale"
		FestivalSponsorType.STREETWEAR_GEAR:
			return "Sponsor Marchio Streetwear & Rock"
		FestivalSponsorType.NONE:
			return "Nessuno Sponsor"
		_:
			return "Nessuno Sponsor"

static func get_festival_weather_name(weather: int) -> String:
	match weather:
		FestivalWeather.SUNNY_HEATWAVE:
			return "Sole Cocente (Canicola Estiva)"
		FestivalWeather.PERFECT_MILD:
			return "Clima Mite Ideale"
		FestivalWeather.SUMMER_STORM:
			return "Temporale Estivo & Fango"
		_:
			return "Clima Variabile"

static func get_label_philosophy_name(phil: int) -> String:
	match phil:
		LabelPhilosophy.UNDERGROUND_INDIE:
			return "Underground & Indie Autentico"
		LabelPhilosophy.MAINSTREAM_POP:
			return "Mainstream Pop & Classifiche"
		LabelPhilosophy.ROCK_HERITAGE:
			return "Rock Heritage & Purezza Strumentale"
		LabelPhilosophy.EXPERIMENTAL:
			return "Avanguardia & Sperimentale"
		_:
			return "Indipendente Generica"

static func get_rival_relationship_name(rel: int) -> String:
	match rel:
		RivalRelationship.RESPECTFUL:
			return "Rispetto & Collaborazione"
		RivalRelationship.NEUTRAL:
			return "Neutro / Distacco Professionale"
		RivalRelationship.HEATED_RIVAL:
			return "Competizione Accesa"
		RivalRelationship.OPEN_FEUD:
			return "Faida Aperta & Dissing"
		_:
			return "Neutro"

static func get_broadcast_media_type_name(media: int) -> String:
	match media:
		BroadcastMediaType.LOCAL_RADIO:
			return "Radio Locale"
		BroadcastMediaType.MUSIC_TELEVISION:
			return "Emittente Televisiva Musicale"
		BroadcastMediaType.CULTURE_PODCAST:
			return "Podcast Musicale & Intervista"
		BroadcastMediaType.SPECIALIZED_PRESS:
			return "Stampa Musicale Specializzata"
		_:
			return "Media Broadcaster"
