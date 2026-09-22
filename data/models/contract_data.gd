# res://data/models/contract_data.gd
class_name ContractData
extends RefCounted

## Modello Dati del Contratto Discografico (World-tour V3.0)
## Rappresenta gli accordi tra l'artista e un'etichetta (Indipendente o Major),
## governando anticipi in denaro, clausole di recoupment (recupero debiti),
## percentuali royalties e numero di dischi contrattualizzati.

var id: String = ""
var label_name: String = ""
var contract_type: int = Enums.ContractType.INDIE_LABEL
var advance_amount: float = 0.0
var unrecouped_debt: float = 0.0
var royalty_rate: float = 0.45
var required_albums: int = 2
var delivered_albums: int = 0
var min_quality_target: float = 0.0
var is_active: bool = false
var signing_day: int = 1

func _init(
	p_id: String = "",
	p_label: String = "Indie Sound Records",
	p_type: int = Enums.ContractType.INDIE_LABEL,
	p_advance: float = 8000.0,
	p_royalty: float = 0.45,
	p_req_albums: int = 2,
	p_min_qual: float = 0.0
) -> void:
	if p_id.is_empty():
		id = "contract_%d_%d" % [p_type, randi() % 9000 + 1000]
	else:
		id = p_id
		
	label_name = p_label
	contract_type = p_type
	advance_amount = p_advance
	unrecouped_debt = p_advance
	royalty_rate = p_royalty
	required_albums = p_req_albums
	delivered_albums = 0
	min_quality_target = p_min_qual
	is_active = false
	signing_day = 1

func get_type_name() -> String:
	match contract_type:
		Enums.ContractType.SELF_RELEASED:
			return "Autoproduzione (DIY)"
		Enums.ContractType.INDIE_LABEL:
			return "Etichetta Indipendente"
		Enums.ContractType.MAJOR_LABEL:
			return "Major Multinazionale"
		_:
			return "Contratto Discografico"

func is_recouped() -> bool:
	return unrecouped_debt <= 0.01

func is_major() -> bool:
	return contract_type == Enums.ContractType.MAJOR_LABEL

## Applica le entrate da royalties per abbattere l'anticipo non recuperato (Recoupment).
## Restituisce un dizionario con la quota recuperata dall'etichetta e l'eccedenza pagata all'artista.
func apply_recoupment(gross_artist_royalty: float) -> Dictionary:
	if unrecouped_debt <= 0.0:
		return {
			"recouped_by_label": 0.0,
			"paid_to_artist": gross_artist_royalty,
			"remaining_debt": 0.0
		}
		
	if gross_artist_royalty >= unrecouped_debt:
		var recouped: float = unrecouped_debt
		var surplus: float = gross_artist_royalty - unrecouped_debt
		unrecouped_debt = 0.0
		return {
			"recouped_by_label": recouped,
			"paid_to_artist": surplus,
			"remaining_debt": 0.0
		}
	else:
		unrecouped_debt -= gross_artist_royalty
		return {
			"recouped_by_label": gross_artist_royalty,
			"paid_to_artist": 0.0,
			"remaining_debt": unrecouped_debt
		}

func is_completed() -> bool:
	return delivered_albums >= required_albums

func to_dict() -> Dictionary:
	return {
		"id": id,
		"label_name": label_name,
		"contract_type": contract_type,
		"advance_amount": advance_amount,
		"unrecouped_debt": unrecouped_debt,
		"royalty_rate": royalty_rate,
		"required_albums": required_albums,
		"delivered_albums": delivered_albums,
		"min_quality_target": min_quality_target,
		"is_active": is_active,
		"signing_day": signing_day
	}

func from_dict(dict: Dictionary) -> void:
	id = dict.get("id", id)
	label_name = dict.get("label_name", label_name)
	contract_type = int(dict.get("contract_type", contract_type))
	advance_amount = float(dict.get("advance_amount", advance_amount))
	unrecouped_debt = float(dict.get("unrecouped_debt", unrecouped_debt))
	royalty_rate = float(dict.get("royalty_rate", royalty_rate))
	required_albums = int(dict.get("required_albums", required_albums))
	delivered_albums = int(dict.get("delivered_albums", delivered_albums))
	min_quality_target = float(dict.get("min_quality_target", min_quality_target))
	is_active = bool(dict.get("is_active", is_active))
	signing_day = int(dict.get("signing_day", signing_day))
