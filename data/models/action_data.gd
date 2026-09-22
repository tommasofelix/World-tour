# res://data/models/action_data.gd
class_name ActionData
extends RefCounted

## Modello Dati Descrittivo per Azioni e Attività di World-tour

var action_id: String = ""
var action_name: String = ""
var description: String = ""
var duration_seconds: float = 10.0
var energy_cost: int = 15
var stress_gain: int = 5
var base_xp: float = 10.0
var target_skill: String = "instrument"
var required_location: String = "bedroom"

func _init(p_id: String = "", p_name: String = "", p_duration: float = 10.0, p_energy: int = 15, p_stress: int = 5, p_xp: float = 10.0, p_skill: String = "instrument") -> void:
	action_id = p_id
	action_name = p_name
	duration_seconds = p_duration
	energy_cost = p_energy
	stress_gain = p_stress
	base_xp = p_xp
	target_skill = p_skill
