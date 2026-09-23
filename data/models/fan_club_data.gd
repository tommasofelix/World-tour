# GDD 2.0 / SP-12: Modello Dati Fan Club Ufficiale della Band (Sezione 8)
class_name FanClubData
extends RefCounted

## Flag se il fan club ufficiale è stato fondato
var is_founded: bool = false

## Nome del Presidente del Fan Club (personaggio procedurale)
var president_name: String = ""

## Città di origine del Presidente
var president_city_id: int = Enums.CityId.MILANO

## Personalità del Presidente (es. "Devoto della Prima Ora", "Organizzatore Nato", "Collezionista")
var president_trait: String = "Devoto della Prima Ora"

## Livello di fedeltà e radicamento della community (1..5)
var loyalty_tier: int = 1

## Numero di iscritti tesserati al Fan Club
var members_count: int = 0

## Quota d'iscrizione / tesseramento annuo (€)
var membership_fee: float = 15.0

## Cassa del Fan Club (€) accumulata dai tesseramenti
var treasury: float = 0.0

## Flag se il raduno annuale è già stato svolto per l'anno in corso
var annual_meeting_held: bool = false

## Anno dell'ultimo raduno svolto
var last_meeting_year: int = 0

func _init(
	p_founded: bool = false,
	p_president: String = "",
	p_city_id: int = Enums.CityId.MILANO
) -> void:
	is_founded = p_founded
	president_name = p_president
	president_city_id = p_city_id
	president_trait = "Devoto della Prima Ora"
	loyalty_tier = 1
	members_count = 0
	membership_fee = 15.0
	treasury = 0.0
	annual_meeting_held = false
	last_meeting_year = 0

## Ritorna il bonus percentuale garantito sull'affluenza minima ai concerti live (+5% a +25%)
func get_concert_attendance_boost() -> float:
	if not is_founded:
		return 0.0
	return float(loyalty_tier) * 0.05

## Aggiunge nuovi membri tesserati al fan club
func add_members(new_members: int) -> void:
	if not is_founded:
		return
	members_count = maxi(0, members_count + new_members)
	var fee_collected: float = float(new_members) * membership_fee
	treasury += fee_collected
	_update_loyalty_tier()

## Aggiorna il tier di fedeltà in base al numero di membri
func _update_loyalty_tier() -> void:
	if members_count >= 2500:
		loyalty_tier = 5
	elif members_count >= 1200:
		loyalty_tier = 4
	elif members_count >= 600:
		loyalty_tier = 3
	elif members_count >= 250:
		loyalty_tier = 2
	else:
		loyalty_tier = 1

## Serializzazione per persistenza JSON
func to_dict() -> Dictionary:
	return {
		"is_founded": is_founded,
		"president_name": president_name,
		"president_city_id": president_city_id,
		"president_trait": president_trait,
		"loyalty_tier": loyalty_tier,
		"members_count": members_count,
		"membership_fee": membership_fee,
		"treasury": treasury,
		"annual_meeting_held": annual_meeting_held,
		"last_meeting_year": last_meeting_year
	}

## Deserializzazione da persistenza JSON
func from_dict(d: Dictionary) -> void:
	is_founded = bool(d.get("is_founded", false))
	president_name = str(d.get("president_name", ""))
	president_city_id = int(d.get("president_city_id", Enums.CityId.MILANO))
	president_trait = str(d.get("president_trait", "Devoto della Prima Ora"))
	loyalty_tier = int(d.get("loyalty_tier", 1))
	members_count = int(d.get("members_count", 0))
	membership_fee = float(d.get("membership_fee", 15.0))
	treasury = float(d.get("treasury", 0.0))
	annual_meeting_held = bool(d.get("annual_meeting_held", false))
	last_meeting_year = int(d.get("last_meeting_year", 0))
