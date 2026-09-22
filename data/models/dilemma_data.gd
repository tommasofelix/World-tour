# res://data/models/dilemma_data.gd
class_name DilemmaData
extends RefCounted

## Modello Dati per gli Eventi a Bivio Etico-Narrativo (World-tour V3.0)
## Rappresenta le scelte morali ed etiche del mondo musicale:
## spot commerciali, compromessi artistici, dichiarazioni controverse e liti con la major.

var id: String = ""
var category: int = Enums.DilemmaCategory.COMMERCIAL_ETHICS
var title: String = ""
var description: String = ""

var option_a_title: String = ""
var option_a_desc: String = ""
var option_a_effects: Dictionary = {}

var option_b_title: String = ""
var option_b_desc: String = ""
var option_b_effects: Dictionary = {}

var req_min_fans: int = 0
var req_min_reputation: float = 0.0
var req_has_contract: bool = false
var is_resolved: bool = false
var chosen_option: int = 0

func _init(
	p_id: String = "",
	p_title: String = "",
	p_desc: String = "",
	p_cat: int = Enums.DilemmaCategory.COMMERCIAL_ETHICS
) -> void:
	id = p_id
	title = p_title
	description = p_desc
	category = p_cat
	option_a_effects = {}
	option_b_effects = {}
	is_resolved = false
	chosen_option = 0

func setup_options(
	opt_a_title: String,
	opt_a_desc: String,
	opt_a_eff: Dictionary,
	opt_b_title: String,
	opt_b_desc: String,
	opt_b_eff: Dictionary
) -> void:
	option_a_title = opt_a_title
	option_a_desc = opt_a_desc
	option_a_effects = opt_a_eff
	option_b_title = opt_b_title
	option_b_desc = opt_b_desc
	option_b_effects = opt_b_eff

func is_eligible(player: PlayerData) -> bool:
	if not player:
		return false
	if is_resolved:
		return false
	if player.fans < req_min_fans:
		return false
	if player.reputation < req_min_reputation:
		return false
	if req_has_contract and not player.has_active_contract():
		return false
	return true

func to_dict() -> Dictionary:
	return {
		"id": id,
		"category": category,
		"title": title,
		"description": description,
		"option_a_title": option_a_title,
		"option_a_desc": option_a_desc,
		"option_a_effects": option_a_effects,
		"option_b_title": option_b_title,
		"option_b_desc": option_b_desc,
		"option_b_effects": option_b_effects,
		"req_min_fans": req_min_fans,
		"req_min_reputation": req_min_reputation,
		"req_has_contract": req_has_contract,
		"is_resolved": is_resolved,
		"chosen_option": chosen_option
	}

func from_dict(dict: Dictionary) -> void:
	id = dict.get("id", id)
	category = int(dict.get("category", category))
	title = dict.get("title", title)
	description = dict.get("description", description)
	option_a_title = dict.get("option_a_title", option_a_title)
	option_a_desc = dict.get("option_a_desc", option_a_desc)
	option_a_effects = dict.get("option_a_effects", option_a_effects)
	option_b_title = dict.get("option_b_title", option_b_title)
	option_b_desc = dict.get("option_b_desc", option_b_desc)
	option_b_effects = dict.get("option_b_effects", option_b_effects)
	req_min_fans = int(dict.get("req_min_fans", req_min_fans))
	req_min_reputation = float(dict.get("req_min_reputation", req_min_reputation))
	req_has_contract = bool(dict.get("req_has_contract", req_has_contract))
	is_resolved = bool(dict.get("is_resolved", is_resolved))
	chosen_option = int(dict.get("chosen_option", chosen_option))
