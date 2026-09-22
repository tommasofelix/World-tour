# res://data/models/manager_data.gd
class_name ManagerData
extends RefCounted

## Modello Dati del Manager & Agenzia di Booking (World-tour V3.0)
## Governa il supporto professionale, le commissioni percentuali sui concerti,
## i moltiplicatori di cachet live e lo sgravio dello stress organizzativo.

var id: String = ""
var manager_name: String = ""
var manager_type: int = Enums.ManagerType.TRUSTED_FRIEND
var commission_pct: float = Constants.MANAGER_FRIEND_COMMISSION
var booking_cachet_multiplier: float = Constants.MANAGER_FRIEND_CACHET_MULT
var reputation_multiplier: float = 1.05
var daily_stress_relief: float = Constants.MANAGER_FRIEND_STRESS_RELIEF
var hiring_fee: float = Constants.MANAGER_FRIEND_HIRING_FEE
var is_hired: bool = false
var hired_day: int = 1

func _init(
	p_id: String = "",
	p_name: String = "Matteo (Amico Fidato)",
	p_type: int = Enums.ManagerType.TRUSTED_FRIEND
) -> void:
	if p_id.is_empty():
		id = "mgr_%d" % (randi() % 9000 + 1000)
	else:
		id = p_id
		
	manager_name = p_name
	manager_type = p_type
	_setup_stats_by_type(p_type)

func _setup_stats_by_type(p_type: int) -> void:
	match p_type:
		Enums.ManagerType.TRUSTED_FRIEND:
			commission_pct = Constants.MANAGER_FRIEND_COMMISSION
			booking_cachet_multiplier = Constants.MANAGER_FRIEND_CACHET_MULT
			reputation_multiplier = 1.05
			daily_stress_relief = Constants.MANAGER_FRIEND_STRESS_RELIEF
			hiring_fee = Constants.MANAGER_FRIEND_HIRING_FEE
		Enums.ManagerType.PRO_INDIE:
			commission_pct = Constants.MANAGER_PRO_COMMISSION
			booking_cachet_multiplier = Constants.MANAGER_PRO_CACHET_MULT
			reputation_multiplier = 1.15
			daily_stress_relief = Constants.MANAGER_PRO_STRESS_RELIEF
			hiring_fee = Constants.MANAGER_PRO_HIRING_FEE
		Enums.ManagerType.INDUSTRY_SHARK:
			commission_pct = Constants.MANAGER_SHARK_COMMISSION
			booking_cachet_multiplier = Constants.MANAGER_SHARK_CACHET_MULT
			reputation_multiplier = 1.30
			daily_stress_relief = Constants.MANAGER_SHARK_STRESS_RELIEF
			hiring_fee = Constants.MANAGER_SHARK_HIRING_FEE
		_:
			commission_pct = 0.0
			booking_cachet_multiplier = 1.0
			reputation_multiplier = 1.0
			daily_stress_relief = 0.0
			hiring_fee = 0.0

func get_type_name() -> String:
	match manager_type:
		Enums.ManagerType.TRUSTED_FRIEND:
			return "Amico Fidato"
		Enums.ManagerType.PRO_INDIE:
			return "Professionista Indipendente"
		Enums.ManagerType.INDUSTRY_SHARK:
			return "Squalo dell'Industria"
		_:
			return "Nessun Manager"

func get_description() -> String:
	match manager_type:
		Enums.ManagerType.TRUSTED_FRIEND:
			return "Tariffa modesta (10%% commissione). Onesto e leale. +10%% cachet live e -1.0 stress/giorno."
		Enums.ManagerType.PRO_INDIE:
			return "Manager qualificato (15%% commissione). Ottimi contatti festival. +25%% cachet live e -2.5 stress/giorno."
		Enums.ManagerType.INDUSTRY_SHARK:
			return "Top manager d'alta finanza (22%% commissione). Aperture palazzetti e TV. +50%% cachet live e -4.0 stress/giorno."
		_:
			return "Gestisci tutto da solo."

func to_dict() -> Dictionary:
	return {
		"id": id,
		"manager_name": manager_name,
		"manager_type": manager_type,
		"commission_pct": commission_pct,
		"booking_cachet_multiplier": booking_cachet_multiplier,
		"reputation_multiplier": reputation_multiplier,
		"daily_stress_relief": daily_stress_relief,
		"hiring_fee": hiring_fee,
		"is_hired": is_hired,
		"hired_day": hired_day
	}

func from_dict(dict: Dictionary) -> void:
	id = dict.get("id", id)
	manager_name = dict.get("manager_name", manager_name)
	manager_type = int(dict.get("manager_type", manager_type))
	commission_pct = float(dict.get("commission_pct", commission_pct))
	booking_cachet_multiplier = float(dict.get("booking_cachet_multiplier", booking_cachet_multiplier))
	reputation_multiplier = float(dict.get("reputation_multiplier", reputation_multiplier))
	daily_stress_relief = float(dict.get("daily_stress_relief", daily_stress_relief))
	hiring_fee = float(dict.get("hiring_fee", hiring_fee))
	is_hired = bool(dict.get("is_hired", is_hired))
	hired_day = int(dict.get("hired_day", hired_day))
