# GDD 2.0 / SP-11: Modello Dati Festival Estivo
class_name FestivalData
extends RefCounted

## Identificativo univoco del festival
var id: String = ""

## Nome del festival
var name: String = ""

## Città ospitante (Enums.CityId)
var city_id: int = Enums.CityId.MILANO

## Nome dell'arena o parco all'aperto
var location_name: String = ""

## Giorno del calendario di svolgimento (Mesi 4-6 / Giorni 85-168)
var day_number: int = 92

## Mese della stagione (4, 5 o 6)
var season_month: int = 4

## Capienza totale dell'area festival
var capacity: int = 35000

## Generi musicali prediletti del festival (affinità pubblico)
var genre_focus: Array[int] = []

## Nome della band rivale presente nel cartellone
var rival_band_name: String = ""

## Punteggio concerto benchmark della band rivale (da battere per Steal the Show)
var rival_band_score: float = 75.0

## Slot orario prenotato dal giocatore (-1 = Nessuno, 0 = Pomeriggio, 1 = Tramonto, 2 = Headliner)
var booked_slot: int = -1

## Stato di svolgimento del festival
var is_completed: bool = false

## Esito memorizzato dell'esibizione
var performance_result: Dictionary = {}

func _init(
	p_id: String = "",
	p_name: String = "",
	p_city_id: int = Enums.CityId.MILANO,
	p_location: String = "",
	p_day: int = 92,
	p_month: int = 4,
	p_capacity: int = 35000,
	p_genres: Array[int] = [],
	p_rival_name: String = "",
	p_rival_score: float = 75.0
) -> void:
	id = p_id
	name = p_name
	city_id = p_city_id
	location_name = p_location
	day_number = p_day
	season_month = p_month
	capacity = p_capacity
	genre_focus = p_genres
	rival_band_name = p_rival_name
	rival_band_score = p_rival_score
	booked_slot = -1
	is_completed = false
	performance_result = {}

func is_slot_booked() -> bool:
	return booked_slot != -1

## Restituisce le specifiche bilanciate per ciascun slot orario del festival
static func get_slot_specs(slot: int, festival_capacity: int = 30000) -> Dictionary:
	match slot:
		Enums.FestivalSlot.OPENING_AFTERNOON:
			return {
				"slot": Enums.FestivalSlot.OPENING_AFTERNOON,
				"name": "Slot Pomeridiano (Apertura)",
				"time_range": "14:00 - 17:00",
				"audience_share": 0.20,
				"estimated_audience": int(festival_capacity * 0.20),
				"guaranteed_fee": 600.0,
				"min_reputation": 15.0,
				"merch_multiplier": 2.5,
				"stress_gain": 5.0,
				"energy_cost": 25
			}
		Enums.FestivalSlot.SUNSET_SLOT:
			return {
				"slot": Enums.FestivalSlot.SUNSET_SLOT,
				"name": "Slot al Tramonto (Golden Hour)",
				"time_range": "18:30 - 20:30",
				"audience_share": 0.60,
				"estimated_audience": int(festival_capacity * 0.60),
				"guaranteed_fee": 3000.0,
				"min_reputation": 35.0,
				"merch_multiplier": 4.0,
				"stress_gain": 15.0,
				"energy_cost": 35
			}
		Enums.FestivalSlot.HEADLINER_NIGHT:
			return {
				"slot": Enums.FestivalSlot.HEADLINER_NIGHT,
				"name": "Headliner Notturno (Prime Time)",
				"time_range": "21:30 - 23:30",
				"audience_share": 1.0,
				"estimated_audience": festival_capacity,
				"guaranteed_fee": 12000.0,
				"min_reputation": 60.0,
				"merch_multiplier": 5.5,
				"stress_gain": 30.0,
				"energy_cost": 50
			}
		_:
			return {}

func to_dict() -> Dictionary:
	var genres_serialized: Array = []
	for g in genre_focus:
		genres_serialized.append(int(g))
		
	return {
		"id": id,
		"name": name,
		"city_id": int(city_id),
		"location_name": location_name,
		"day_number": day_number,
		"season_month": season_month,
		"capacity": capacity,
		"genre_focus": genres_serialized,
		"rival_band_name": rival_band_name,
		"rival_band_score": rival_band_score,
		"booked_slot": booked_slot,
		"is_completed": is_completed,
		"performance_result": performance_result.duplicate(true)
	}

func from_dict(d: Dictionary) -> void:
	id = d.get("id", "")
	name = d.get("name", "")
	city_id = int(d.get("city_id", Enums.CityId.MILANO))
	location_name = d.get("location_name", "")
	day_number = int(d.get("day_number", 92))
	season_month = int(d.get("season_month", 4))
	capacity = int(d.get("capacity", 35000))
	
	genre_focus.clear()
	var raw_genres: Array = d.get("genre_focus", [])
	for g in raw_genres:
		genre_focus.append(int(g))
		
	rival_band_name = d.get("rival_band_name", "")
	rival_band_score = float(d.get("rival_band_score", 75.0))
	booked_slot = int(d.get("booked_slot", -1))
	is_completed = bool(d.get("is_completed", false))
	performance_result = d.get("performance_result", {}).duplicate(true)
