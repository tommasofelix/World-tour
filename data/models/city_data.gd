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
	p_venues: Array[VenueData] = []
) -> void:
	id = p_id
	name = p_name
	country = p_country
	description = p_desc
	genre_affinities = p_affinities.duplicate(true)
	is_international = p_intl
	min_reputation_req = p_min_rep
	venues = p_venues.duplicate()

## Restituisce il moltiplicatore di affinità per un determinato genere musicale (default: 1.0)
func get_affinity_for_genre(genre: int) -> float:
	return float(genre_affinities.get(genre, 1.0))

## Restituisce una descrizione lineare per lo screen reader NVDA
func get_summary_speech() -> String:
	var intl_tag: String = " (Città Internazionale)" if is_international else ""
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
	
	return list
