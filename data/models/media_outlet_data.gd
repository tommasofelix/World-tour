# res://data/models/media_outlet_data.gd
class_name MediaOutletData
extends RefCounted

## Modello Dati per Emittenti, Stampa e Canali Broadcast (World-tour Sezione 10)
## Rappresenta stazioni radiofoniche, canali TV, podcast e riviste specializzate

var id: String = ""
var name: String = ""
var media_type: int = Enums.BroadcastMediaType.LOCAL_RADIO
var city_id: int = Enums.CityId.MILANO
var reach_listeners: int = 5000
var min_career_tier: int = Enums.CareerTier.LOCAL_ARTIST
var required_reputation: float = 10.0
var preferred_genre: int = Enums.MusicalGenre.ROCK
var interview_cost_energy: int = 15
var hype_yield: float = 12.0
var reputation_yield: float = 1.0

func _init(
	p_id: String = "",
	p_name: String = "",
	p_type: int = Enums.BroadcastMediaType.LOCAL_RADIO,
	p_city: int = Enums.CityId.MILANO,
	p_listeners: int = 5000,
	p_tier: int = Enums.CareerTier.LOCAL_ARTIST,
	p_req_rep: float = 10.0,
	p_genre: int = Enums.MusicalGenre.ROCK,
	p_energy: int = 15,
	p_hype: float = 12.0,
	p_rep_yield: float = 1.0
) -> void:
	id = p_id
	name = p_name
	media_type = p_type
	city_id = p_city
	reach_listeners = p_listeners
	min_career_tier = p_tier
	required_reputation = p_req_rep
	preferred_genre = p_genre
	interview_cost_energy = p_energy
	hype_yield = p_hype
	reputation_yield = p_rep_yield

func get_type_name() -> String:
	return Enums.get_broadcast_media_type_name(media_type)

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"media_type": int(media_type),
		"city_id": int(city_id),
		"reach_listeners": reach_listeners,
		"min_career_tier": int(min_career_tier),
		"required_reputation": required_reputation,
		"preferred_genre": int(preferred_genre),
		"interview_cost_energy": interview_cost_energy,
		"hype_yield": hype_yield,
		"reputation_yield": reputation_yield
	}

func from_dict(d: Dictionary) -> void:
	id = d.get("id", "")
	name = d.get("name", "")
	media_type = int(d.get("media_type", Enums.BroadcastMediaType.LOCAL_RADIO))
	city_id = int(d.get("city_id", Enums.CityId.MILANO))
	reach_listeners = int(d.get("reach_listeners", 5000))
	min_career_tier = int(d.get("min_career_tier", Enums.CareerTier.LOCAL_ARTIST))
	required_reputation = float(d.get("required_reputation", 10.0))
	preferred_genre = int(d.get("preferred_genre", Enums.MusicalGenre.ROCK))
	interview_cost_energy = int(d.get("interview_cost_energy", 15))
	hype_yield = float(d.get("hype_yield", 12.0))
	reputation_yield = float(d.get("reputation_yield", 1.0))
