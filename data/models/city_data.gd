# res://data/models/city_data.gd
class_name CityData
extends RefCounted

## Modello Dati della Città e Scena Musicale Locale per World-tour (F8.1)
## Rappresenta le metropoli della rete di viaggio, le affinità con i generi musicali,
## i club dedicati, i requisiti di reputazione e la penetrazione della fanbase.

const VenueDataScript = preload("res://data/models/venue_data.gd")

var id: int = Enums.CityId.MILANO
var name: String = "Milano"
var country: String = "Italia"
var description: String = ""
var genre_affinities: Dictionary = {}
var is_international: bool = false
var is_transoceanic: bool = false
var min_reputation_req: float = 0.0
var venues: Array[VenueData] = []

func _init(
	p_id: int = Enums.CityId.MILANO,
	p_name: String = "Milano",
	p_country: String = "Italia",
	p_desc: String = "",
	p_affinities: Dictionary = {},
	p_intl: bool = false,
	p_min_rep: float = 0.0,
	p_venues: Array[VenueData] = [],
	p_transoceanic: bool = false
) -> void:
	id = p_id
	name = p_name
	country = p_country
	description = p_desc
	genre_affinities = p_affinities.duplicate(true)
	is_international = p_intl
	min_reputation_req = p_min_rep
	venues = p_venues.duplicate()
	is_transoceanic = p_transoceanic

## Restituisce il moltiplicatore di affinità per un determinato genere musicale (default: 1.0)
func get_affinity_for_genre(genre: int) -> float:
	return float(genre_affinities.get(genre, 1.0))

## Restituisce una descrizione lineare per lo screen reader NVDA
func get_summary_speech() -> String:
	var intl_tag: String = ""
	if is_transoceanic:
		intl_tag = " (Oltreoceano Intercontinentale)"
	elif is_international:
		intl_tag = " (Città Internazionale)"
	var aff_descriptions: Array[String] = []
	for g in genre_affinities:
		var mult: float = float(genre_affinities[g])
		var bonus_pct: int = int(round((mult - 1.0) * 100.0))
		aff_descriptions.append("%s (+%d%%)" % [Enums.get_genre_name(int(g)), bonus_pct])
	var aff_str: String = ", ".join(aff_descriptions) if not aff_descriptions.is_empty() else "Neutro per tutti i generi"

	return "%s, %s%s. %s. Generi favoriti: %s. Locali disponibili: %d." % [
		name,
		country,
		intl_tag,
		description,
		aff_str,
		venues.size()
	]

func to_dict() -> Dictionary:
	var venues_arr: Array = []
	for v in venues:
		venues_arr.append(v.to_dict())

	return {
		"id": id,
		"name": name,
		"country": country,
		"description": description,
		"genre_affinities": genre_affinities.duplicate(true),
		"is_international": is_international,
		"is_transoceanic": is_transoceanic,
		"min_reputation_req": min_reputation_req,
		"venues": venues_arr
	}

func from_dict(dict: Dictionary) -> void:
	id = int(dict.get("id", id))
	name = str(dict.get("name", name))
	country = str(dict.get("country", country))
	description = str(dict.get("description", description))
	if dict.has("genre_affinities") and dict["genre_affinities"] is Dictionary:
		genre_affinities = dict["genre_affinities"].duplicate(true)
	is_international = bool(dict.get("is_international", is_international))
	is_transoceanic = bool(dict.get("is_transoceanic", is_transoceanic))
	min_reputation_req = float(dict.get("min_reputation_req", min_reputation_req))

	venues.clear()
	if dict.has("venues") and dict["venues"] is Array:
		for v_dict in dict["venues"]:
			if v_dict is Dictionary:
				var v = VenueDataScript.new()
				v.from_dict(v_dict)
				venues.append(v)

## Recupera una specifica città per ID
static func get_city(city_id: int) -> CityData:
	for c in get_all_cities():
		if c.id == city_id:
			return c
	return null

## Catalogo predefinito di tutte le 6 città di World-tour
static func get_all_cities() -> Array[CityData]:
	var list: Array[CityData] = []

	# 1. MILANO (Italia) - Pop, Rock, Elettronica
	var milano_venues: Array[VenueData] = [
		VenueDataScript.new("milano_garage", "Garage San Siro", 15, 0.0, 0.0, 0.0, 0.0, "La classica sala prove milanese.", "Grezzo"),
		VenueDataScript.new("milano_pub", "Navigli Rock Pub", 60, 50.0, 5.0, 15.0, 5.0, "Pub affollato sui Navigli.", "Rumoroso"),
		VenueDataScript.new("milano_small_club", "Magazzini Underground", 180, 250.0, 20.0, 40.0, 12.0, "Club storico per la scena alternativa.", "Underground"),
		VenueDataScript.new("milano_trendy_club", "Alcatraz Live Hall", 450, 700.0, 40.0, 70.0, 22.0, "Punto di riferimento per i concerti nazionali.", "Prestigioso")
	]
	list.append(CityData.new(
		Enums.CityId.MILANO,
		"Milano",
		"Italia",
		"Capitale discografica e finanziaria. Scena Pop, Rock ed Elettronica vibrante.",
		{ Enums.MusicalGenre.ROCK: 1.15, Enums.MusicalGenre.POP: 1.25, Enums.MusicalGenre.ELECTRONIC: 1.20 },
		false,
		0.0,
		milano_venues
	))

	# 2. BOLOGNA (Italia) - Punk, Indie Rock
	var bologna_venues: Array[VenueData] = [
		VenueDataScript.new("bologna_cellar", "Cantina del Pratello", 25, 10.0, 0.0, 5.0, 2.0, "Seminterrato caldo nel cuore di Bologna.", "Grezzo"),
		VenueDataScript.new("bologna_covo", "Covo Indie Club", 120, 120.0, 15.0, 30.0, 8.0, "Il tempio dell'indie rock italiano.", "Underground"),
		VenueDataScript.new("bologna_estragon", "Estragon Live", 380, 550.0, 35.0, 60.0, 18.0, "Grande palco per concerti intensi.", "Prestigioso")
	]
	list.append(CityData.new(
		Enums.CityId.BOLOGNA,
		"Bologna",
		"Italia",
		"Città ribelle e universitaria. Tempio dell'Indie Rock e delle scene underground.",
		{ Enums.MusicalGenre.INDIE: 1.30, Enums.MusicalGenre.ROCK: 1.20 },
		false,
		0.0,
		bologna_venues
	))

	# 3. ROMA (Italia) - Cantautorato, Rock, Pop
	var roma_venues: Array[VenueData] = [
		VenueDataScript.new("roma_pub", "Trastevere Blues Bar", 50, 45.0, 5.0, 12.0, 6.0, "Locale intimo nei vicoli romani.", "Rumoroso"),
		VenueDataScript.new("roma_monk", "Monk Club", 200, 280.0, 25.0, 45.0, 14.0, "Riferimento romano per concerti di qualità.", "Underground"),
		VenueDataScript.new("roma_atlantico", "Atlantico Live", 500, 850.0, 45.0, 75.0, 25.0, "Palcoscenico imponente per grandi band.", "Prestigioso")
	]
	list.append(CityData.new(
		Enums.CityId.ROMA,
		"Roma",
		"Italia",
		"La Città Eterna. Grande tradizione di Cantautorato e Rock d'autore.",
		{ Enums.MusicalGenre.INDIE: 1.20, Enums.MusicalGenre.ROCK: 1.20, Enums.MusicalGenre.POP: 1.15 },
		false,
		0.0,
		roma_venues
	))

	# 4. NAPOLI (Italia) - Rap, Rock, World
	var napoli_venues: Array[VenueData] = [
		VenueDataScript.new("napoli_bar", "Spaccanapoli Live Bar", 40, 30.0, 5.0, 10.0, 5.0, "Atmosfera verace e calorosa.", "Rumoroso"),
		VenueDataScript.new("napoli_duel", "Duel Beat Club", 190, 220.0, 20.0, 38.0, 10.0, "Club dinamico per rap e rock alternativo.", "Underground"),
		VenueDataScript.new("napoli_arena", "Palapartenope Hall", 600, 950.0, 50.0, 80.0, 24.0, "Auditorium gremito di folla appassionata.", "Prestigioso")
	]
	list.append(CityData.new(
		Enums.CityId.NAPOLI,
		"Napoli",
		"Italia",
		"Vulcano di ritmo e grinta. Altissima fedeltà e passione per hip hop e rock.",
		{ Enums.MusicalGenre.HIPHOP: 1.30, Enums.MusicalGenre.ROCK: 1.15, Enums.MusicalGenre.POP: 1.15 },
		false,
		0.0,
		napoli_venues
	))

	# 5. LONDRA (Regno Unito) - Rock, Indie, Brit-pop (Internazionale)
	var londra_venues: Array[VenueData] = [
		VenueDataScript.new("london_pub", "Camden Black Heart", 70, 90.0, 15.0, 25.0, 10.0, "Pub intriso di storia rock a Camden.", "Rumoroso"),
		VenueDataScript.new("london_underworld", "The Underworld", 250, 450.0, 35.0, 65.0, 20.0, "Leggendario club sotterraneo londinese.", "Underground"),
		VenueDataScript.new("london_brixton", "O2 Brixton Academy", 800, 1500.0, 60.0, 90.0, 35.0, "Il tempio consacrato del rock mondiale.", "Prestigioso")
	]
	list.append(CityData.new(
		Enums.CityId.LONDRA,
		"Londra",
		"Regno Unito",
		"La Mecca mondiale del rock. Mercato cosmopolita e trampolino globale.",
		{ Enums.MusicalGenre.ROCK: 1.30, Enums.MusicalGenre.INDIE: 1.25, Enums.MusicalGenre.POP: 1.10 },
		true,
		30.0, # Reputazione minima richiesta
		londra_venues
	))

	# 6. BERLINO (Germania) - Elettronica, Industrial, Metal (Internazionale)
	var berlino_venues: Array[VenueData] = [
		VenueDataScript.new("berlin_basement", "Kreuzberg Keller", 60, 70.0, 15.0, 20.0, 8.0, "Cantina alternativa nel quartiere più artistico.", "Underground"),
		VenueDataScript.new("berlin_so36", "SO36 Punk & Wave", 220, 380.0, 30.0, 55.0, 16.0, "Club storico dell'underground berlinese.", "Underground"),
		VenueDataScript.new("berlin_columbia", "Columbiahalle", 750, 1300.0, 55.0, 85.0, 30.0, "Imponente sala per live elettronici e metal.", "Prestigioso")
	]
	list.append(CityData.new(
		Enums.CityId.BERLINO,
		"Berlino",
		"Germania",
		"Capitale delle avanguardie. Tempio di elettronica, industrial e metal.",
		{ Enums.MusicalGenre.ELECTRONIC: 1.35, Enums.MusicalGenre.METAL: 1.25, Enums.MusicalGenre.ROCK: 1.15 },
		true,
		30.0, # Reputazione minima richiesta
		berlino_venues
	))

	# 7. DUBLINO (Irlanda) - Rock, Indie, Pop (Internazionale Europea)
	var dublino_venues: Array[VenueData] = [
		VenueDataScript.new("dublin_pub", "The Temple Bar Pub", 50, 50.0, 10.0, 20.0, 8.0, "Pub storico nel quartiere artistico di Temple Bar.", "Rumoroso"),
		VenueDataScript.new("dublin_whelans", "Whelan's Live Stage", 220, 320.0, 25.0, 50.0, 15.0, "Leggendario club per rock e cantautorato celtico.", "Underground"),
		VenueDataScript.new("dublin_olympia", "Olympia Theatre Dublin", 600, 1100.0, 50.0, 80.0, 28.0, "Teatro storico vittoriano per concerti memorabili.", "Prestigioso")
	]
	list.append(CityData.new(
		Enums.CityId.DUBLINO,
		"Dublino",
		"Irlanda",
		"Culla del rock celtico, del folk e della passione musicale autentica.",
		{ Enums.MusicalGenre.ROCK: 1.30, Enums.MusicalGenre.INDIE: 1.25, Enums.MusicalGenre.POP: 1.15 },
		true,
		25.0,
		dublino_venues,
		false
	))

	# 8. PARIGI (Francia) - Elettronica, Pop, Indie (Internazionale Europea)
	var parigi_venues: Array[VenueData] = [
		VenueDataScript.new("paris_caveau", "Caveau de la Huchette", 60, 80.0, 15.0, 30.0, 10.0, "Cantina sotterranea nel Quartiere Latino.", "Underground"),
		VenueDataScript.new("paris_cigale", "La Cigale Rock Hall", 300, 500.0, 35.0, 60.0, 18.0, "Locale storico ai piedi di Montmartre.", "Underground"),
		VenueDataScript.new("paris_olympia", "L'Olympia Paris", 750, 1400.0, 55.0, 88.0, 32.0, "Tempio sacro della musica europea e mondiale.", "Prestigioso")
	]
	list.append(CityData.new(
		Enums.CityId.PARIGI,
		"Parigi",
		"Francia",
		"Capitale dell'eleganza pop, della chanson e del French Touch elettronico.",
		{ Enums.MusicalGenre.ELECTRONIC: 1.30, Enums.MusicalGenre.POP: 1.25, Enums.MusicalGenre.INDIE: 1.20 },
		true,
		35.0,
		parigi_venues,
		false
	))

	# 9. MADRID (Spagna) - Pop, Rock, Hip Hop (Internazionale Europea)
	var madrid_venues: Array[VenueData] = [
		VenueDataScript.new("madrid_malasana", "Malasaña Rock Bar", 55, 60.0, 10.0, 25.0, 8.0, "Bar underground nel cuore della movida madrilena.", "Rumoroso"),
		VenueDataScript.new("madrid_sol", "Sala El Sol", 240, 360.0, 30.0, 55.0, 16.0, "Iconico club protagonista della scena rock spagnola.", "Underground"),
		VenueDataScript.new("madrid_riviera", "La Riviera Concerts", 700, 1250.0, 50.0, 82.0, 28.0, "Grande sala da concerto sulle rive del Manzanares.", "Prestigioso")
	]
	list.append(CityData.new(
		Enums.CityId.MADRID,
		"Madrid",
		"Spagna",
		"Energia iberica travolgente, movida notturna, rock e ritmi latini urbani.",
		{ Enums.MusicalGenre.POP: 1.25, Enums.MusicalGenre.ROCK: 1.25, Enums.MusicalGenre.HIPHOP: 1.20 },
		true,
		30.0,
		madrid_venues,
		false
	))

	# 10. NEW YORK (Stati Uniti) - Hip Hop, Rock, Pop (Oltreoceano Intercontinentale)
	var new_york_venues: Array[VenueData] = [
		VenueDataScript.new("ny_cbg", "CBGB Reborn Basement", 80, 150.0, 25.0, 50.0, 15.0, "Seminterrato leggendario culla del punk newyorkese.", "Grezzo"),
		VenueDataScript.new("ny_bowery", "Bowery Ballroom", 350, 750.0, 45.0, 75.0, 25.0, "Sala d'autore con acustica perfetta nel Lower East Side.", "Underground"),
		VenueDataScript.new("ny_madison", "Madison Music Arena", 1200, 2800.0, 75.0, 95.0, 45.0, "L'arena per eccellenza dove si consacrano le leggende.", "Prestigioso")
	]
	list.append(CityData.new(
		Enums.CityId.NEW_YORK,
		"New York",
		"Stati Uniti",
		"La capitale culturale del pianeta. Patria dell'hip-hop, del punk e delle hit mondiali.",
		{ Enums.MusicalGenre.HIPHOP: 1.30, Enums.MusicalGenre.ROCK: 1.25, Enums.MusicalGenre.POP: 1.20 },
		true,
		60.0,
		new_york_venues,
		true
	))

	# 11. LOS ANGELES (Stati Uniti) - Pop, Rock, Elettronica (Oltreoceano Intercontinentale)
	var la_venues: Array[VenueData] = [
		VenueDataScript.new("la_sunset", "Sunset Strip Club", 90, 180.0, 30.0, 55.0, 18.0, "Club affacciato sul mitico viale del rock californiano.", "Rumoroso"),
		VenueDataScript.new("la_troubadour", "The Troubadour", 400, 850.0, 50.0, 80.0, 28.0, "Palcoscenico storico dove sono nate le più grandi superstar.", "Underground"),
		VenueDataScript.new("la_forum", "The Forum Live Pavilion", 1400, 3200.0, 80.0, 98.0, 50.0, "Colossale arena per concerti e spettacoli oceanici.", "Prestigioso")
	]
	list.append(CityData.new(
		Enums.CityId.LOS_ANGELES,
		"Los Angeles",
		"Stati Uniti",
		"La Città degli Angeli. Capitale del glamour, delle mega-produzioni pop e dell'hard rock.",
		{ Enums.MusicalGenre.POP: 1.30, Enums.MusicalGenre.ROCK: 1.25, Enums.MusicalGenre.ELECTRONIC: 1.20 },
		true,
		65.0,
		la_venues,
		true
	))

	# 12. TOKYO (Giappone) - Elettronica, Rock, Pop (Oltreoceano Intercontinentale)
	var tokyo_venues: Array[VenueData] = [
		VenueDataScript.new("tokyo_shibuya", "Shibuya Underground Club", 100, 200.0, 35.0, 60.0, 20.0, "Club futuristico al neon nel cuore pulsante di Shibuya.", "Underground"),
		VenueDataScript.new("tokyo_shinjuku", "Shinjuku Loft", 450, 950.0, 55.0, 85.0, 30.0, "Pietra miliare del rock e dell'elettronica asiatica.", "Underground"),
		VenueDataScript.new("tokyo_budokan", "Budokan Music Dome", 1500, 3500.0, 85.0, 99.0, 55.0, "L'ottagono sacro consacrato agli immortali della musica mondiale.", "Prestigioso")
	]
	list.append(CityData.new(
		Enums.CityId.TOKYO,
		"Tokyo",
		"Giappone",
		"Metropoli futuristica. Tempio di suoni digitali, synth-pop, visual rock e avanguardia.",
		{ Enums.MusicalGenre.ELECTRONIC: 1.35, Enums.MusicalGenre.ROCK: 1.30, Enums.MusicalGenre.POP: 1.25 },
		true,
		70.0,
		tokyo_venues,
		true
	))

	# 13. SAN PAOLO (Brasile) - Metal, Rock, Punk (Oltreoceano Intercontinentale)
	var sao_paulo_venues: Array[VenueData] = [
		VenueDataScript.new("sp_augusta", "Rua Augusta Rock Bar", 80, 120.0, 20.0, 45.0, 15.0, "Locale ribelle nel cuore pulsante di San Paolo.", "Rumoroso"),
		VenueDataScript.new("sp_circo", "Circo Paulistano Live", 350, 600.0, 40.0, 70.0, 25.0, "Palcoscenico caldo con acustica travolgente.", "Underground"),
		VenueDataScript.new("sp_arena", "Allianz Parque Arena Hall", 1600, 3800.0, 85.0, 99.0, 55.0, "Mega impianto oceanico per il metal e il rock mondiale.", "Prestigioso")
	]
	list.append(CityData.new(
		Enums.CityId.SAO_PAULO,
		"San Paolo",
		"Brasile",
		"Capitale del rock sudamericano. Pubblico oceanico e passionale con vendite merch esplosive.",
		{ Enums.MusicalGenre.METAL: 1.35, Enums.MusicalGenre.ROCK: 1.30 },
		true,
		50.0,
		sao_paulo_venues,
		true
	))

	# 14. BUENOS AIRES (Argentina) - Indie, Rock, Pop (Oltreoceano Intercontinentale)
	var ba_venues: Array[VenueData] = [
		VenueDataScript.new("ba_san_telmo", "San Telmo Underground", 75, 110.0, 20.0, 40.0, 14.0, "Cantina artistica e viscerale nei vicoli storici.", "Underground"),
		VenueDataScript.new("ba_niceto", "Niceto Club Palermo", 320, 550.0, 35.0, 65.0, 22.0, "Il tempio dell'indie rock e della new wave argentina.", "Underground"),
		VenueDataScript.new("ba_luna_park", "Estadio Luna Park", 1500, 3600.0, 80.0, 98.0, 50.0, "Arena leggendaria con cori assordanti a squarciagola.", "Prestigioso")
	]
	list.append(CityData.new(
		Enums.CityId.BUENOS_AIRES,
		"Buenos Aires",
		"Argentina",
		"La città dell'ardore e della poesia rock. Scena alternativa devota e fedele.",
		{ Enums.MusicalGenre.INDIE: 1.30, Enums.MusicalGenre.ROCK: 1.25, Enums.MusicalGenre.POP: 1.15 },
		true,
		50.0,
		ba_venues,
		true
	))

	# 15. SYDNEY (Australia) - Classic Rock, Punk Rock (Oltreoceano Intercontinentale)
	var sydney_venues: Array[VenueData] = [
		VenueDataScript.new("syd_oxford", "Oxford Art Factory", 90, 150.0, 25.0, 50.0, 16.0, "Fucina creativa e rumorosa per band emergenti.", "Rumoroso"),
		VenueDataScript.new("syd_metro", "The Metro Theatre", 400, 750.0, 45.0, 75.0, 28.0, "Teatro iconico al centro della nightlife australiana.", "Underground"),
		VenueDataScript.new("syd_hordern", "Hordern Pavilion", 1800, 4200.0, 85.0, 99.0, 55.0, "Padiglione monumentale teatro dei tour oceanici.", "Prestigioso")
	]
	list.append(CityData.new(
		Enums.CityId.SYDNEY,
		"Sydney",
		"Australia",
		"Patria del pub rock e dell'adrenalina all'aperto. Mercato isolato ma ricchissimo.",
		{ Enums.MusicalGenre.ROCK: 1.35, Enums.MusicalGenre.INDIE: 1.20 },
		true,
		60.0,
		sydney_venues,
		true
	))

	# 16. SEOUL (Corea del Sud) - Pop, Elettronica, Hip-Hop (Oltreoceano Intercontinentale)
	var seoul_venues: Array[VenueData] = [
		VenueDataScript.new("seoul_hongdae", "Hongdae Live Club FF", 110, 180.0, 30.0, 55.0, 18.0, "Cuore della scena indie e punk alternativa di Seoul.", "Underground"),
		VenueDataScript.new("seoul_yes24", "YES24 Live Hall", 500, 900.0, 55.0, 85.0, 32.0, "Auditorium hi-tech per live performance ad altissima energia.", "Prestigioso"),
		VenueDataScript.new("seoul_kspo", "KSPO Olympic Dome", 2000, 4500.0, 90.0, 100.0, 60.0, "Colossale cupola olimpica per mega produzioni mondiali.", "Prestigioso")
	]
	list.append(CityData.new(
		Enums.CityId.SEOUL,
		"Seoul",
		"Corea del Sud",
		"Capitale della tecnologia e del pop globale. Viralità social e produzioni all'avanguardia.",
		{ Enums.MusicalGenre.POP: 1.35, Enums.MusicalGenre.ELECTRONIC: 1.30, Enums.MusicalGenre.HIPHOP: 1.25 },
		true,
		65.0,
		seoul_venues,
		true
	))

	return list
