# res://data/models/action_data.gd
class_name ActionData
extends RefCounted

## Modello Dati Descrittivo per Azioni e Attività di World-tour
## Supporta sia l'allenamento delle abilità sia le attività di recupero attivo (Sezione 1.3)

var action_id: String = ""
var action_name: String = ""
var description: String = ""
var duration_seconds: float = 10.0
var energy_cost: int = 15
var stress_gain: int = 5
var base_xp: float = 10.0
var target_skill: String = "instrument"
var required_location: String = "bedroom"

# Parametri Recupero Attivo & Benessere (Sezione 1.3)
var is_recovery: bool = false
var energy_delta: int = 0
var stress_delta: int = 0
var morale_delta: int = 0
var money_cost: float = 0.0
var inspiration_chance: float = 0.0

func _init(
	p_id: String = "",
	p_name: String = "",
	p_duration: float = 10.0,
	p_energy: int = 15,
	p_stress: int = 5,
	p_xp: float = 10.0,
	p_skill: String = "instrument",
	p_is_recovery: bool = false,
	p_energy_delta: int = 0,
	p_stress_delta: int = 0,
	p_morale_delta: int = 0,
	p_money_cost: float = 0.0,
	p_inspiration_chance: float = 0.0
) -> void:
	action_id = p_id
	action_name = p_name
	duration_seconds = p_duration
	energy_cost = p_energy
	stress_gain = p_stress
	base_xp = p_xp
	target_skill = p_skill
	is_recovery = p_is_recovery
	energy_delta = p_energy_delta
	stress_delta = p_stress_delta
	morale_delta = p_morale_delta
	money_cost = p_money_cost
	inspiration_chance = p_inspiration_chance
