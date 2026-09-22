# res://systems/economy_system.gd
class_name EconomySystem
extends RefCounted

## Motore di Simulazione Economica, Sostentamento e Spese Fisse (World-tour)
## Governa il bilancio del giocatore, l'addebito delle spese quotidiane,
## i lavori di sussistenza (T1-T3), il "Salto nel Vuoto" (The Leap) e il registro transazioni.
## Conforme a SP-05 e Clean Architecture.

var player_data: PlayerData
var calendar_data: CalendarData

var current_job_id: String = "retail" # Inizia come commesso part-time
var transactions: Array[Dictionary] = []

const MAX_TRANSACTIONS: int = 50

func _init(p_player: PlayerData, p_calendar: CalendarData = null) -> void:
	player_data = p_player
	calendar_data = p_calendar
	
	# Ascolto eventi di guadagno/spesa dal gioco per tracciarli automaticamente nel registro
	EventBus.money_changed.connect(_on_external_money_changed)

func _on_external_money_changed(new_bal: float, delta: float, reason: String) -> void:
	# Evita di loggare se il delta è 0 o se già loggato internamente come job o end_day
	if is_zero_approx(delta) or reason.begins_with("Stipendio") or reason.begins_with("Spese vive"):
		return
	var cat: String = "general"
	if reason == "venue_rent":
		cat = "rent"
	elif reason == "concert_tickets":
		cat = "live"
	elif reason.begins_with("single_release") or reason == "single_sales":
		cat = "single"
	elif reason.begins_with("pro_studio"):
		cat = "studio"
	log_transaction(delta, cat, reason)

func get_daily_fixed_expenses() -> Dictionary:
	var food: float = Constants.DAILY_FOOD_EXPENSE
	var tier: int = player_data.current_housing_tier if player_data else Enums.HousingTier.STARTER_BEDROOM
	var base_rent: float = HousingData.get_tier_rent(tier)
	var rent: float = base_rent
	if player_data and tier == Enums.HousingTier.SHARED_FLAT:
		var roommates: int = 1 + player_data.band_members.size()
		rent = snappedf(base_rent / float(roommates), 0.01)
	return {
		"food": food,
		"rent": rent,
		"total": food + rent
	}

## Permette di cambiare residenza / alloggio
func change_housing(new_tier: int) -> Dictionary:
	if not player_data:
		return { "success": false, "reason": "no_player" }
	if player_data.current_housing_tier == new_tier:
		return { "success": false, "reason": "already_current" }
	var rent: float = HousingData.get_tier_rent(new_tier)
	if new_tier == Enums.HousingTier.SHARED_FLAT and player_data.band_members.is_empty():
		return { "success": false, "reason": "no_band_members" }
	if new_tier == Enums.HousingTier.LUXURY_VILLA and player_data.career_tier < Enums.CareerTier.INDIE_SENSATION:
		return { "success": false, "reason": "career_too_low" }
	if player_data.money < rent:
		return { "success": false, "reason": "money_insufficient" }
		
	player_data.current_housing_tier = new_tier
	EventBus.housing_changed.emit(new_tier, rent)
	AccessibilityManager.announce("Alloggio cambiato in: %s. Canone giornaliero: %.2f euro." % [
		HousingData.get_tier_name(new_tier), rent
	], true)
	return { "success": true, "new_tier": new_tier, "rent": rent }

func get_financial_runway_days() -> float:
	if not player_data or player_data.money <= 0.0:
		return 0.0
	var daily_total: float = get_daily_fixed_expenses().total
	if daily_total <= 0.0:
		return 999.0
	return player_data.money / daily_total

func log_transaction(amount: float, category: String, description: String, day_num: int = -1) -> void:
	var d: int = day_num
	if d == -1 and calendar_data:
		d = calendar_data.day_number
	elif d == -1:
		d = 1
		
	var entry: Dictionary = {
		"day": d,
		"amount": amount,
		"category": category,
		"description": description
	}
	
	transactions.append(entry)
	if transactions.size() > MAX_TRANSACTIONS:
		transactions.pop_front()
		
	EventBus.transaction_logged.emit(entry)

func get_recent_transactions(limit: int = 10) -> Array[Dictionary]:
	var res: Array[Dictionary] = []
	var start_idx: int = maxi(0, transactions.size() - limit)
	for i in range(transactions.size() - 1, start_idx - 1, -1):
		res.append(transactions[i])
	return res

func get_available_jobs() -> Array[Dictionary]:
	return [
		{
			"id": "retail",
			"name": tr("JOB_RETAIL_NAME"),
			"desc": tr("JOB_RETAIL_DESC"),
			"wage": 55.0,
			"energy_cost": 20,
			"stress_gain": 5,
			"duration_sec": 160.0
		},
		{
			"id": "waiter",
			"name": tr("JOB_WAITER_NAME"),
			"desc": tr("JOB_WAITER_DESC"),
			"wage": 45.0,
			"energy_cost": 25,
			"stress_gain": 10,
			"duration_sec": 180.0
		},
		{
			"id": "warehouse",
			"name": tr("JOB_WAREHOUSE_NAME"),
			"desc": tr("JOB_WAREHOUSE_DESC"),
			"wage": 70.0,
			"energy_cost": 35,
			"stress_gain": 15,
			"duration_sec": 200.0
		}
	]

func get_current_job() -> Dictionary:
	if current_job_id == "none" or current_job_id.is_empty():
		return {"id": "none", "name": tr("JOB_NONE_NAME"), "wage": 0.0}
	var jobs: Array[Dictionary] = get_available_jobs()
	for j in jobs:
		if j.id == current_job_id:
			return j
	return {"id": "none", "name": tr("JOB_NONE_NAME"), "wage": 0.0}

func perform_job_shift() -> Dictionary:
	if not player_data:
		return {"success": false, "reason": "no_player_data"}
		
	var job: Dictionary = get_current_job()
	if job.id == "none":
		return {"success": false, "reason": "unemployed", "message": tr("JOB_ERR_UNEMPLOYED")}
		
	var e_cost: int = job.get("energy_cost", 20)
	if player_data.energy < e_cost:
		return {"success": false, "reason": "energy_insufficient", "message": tr("JOB_ERR_ENERGY")}
		
	player_data.consume_energy(e_cost)
	player_data.add_stress(job.get("stress_gain", 5))
	
	var wage: float = job.get("wage", 50.0)
	player_data.modify_money(wage)
	
	var day_num: int = calendar_data.day_number if calendar_data else 1
	log_transaction(wage, "job", "Stipendio da %s" % job.name, day_num)
	EventBus.money_changed.emit(player_data.money, wage, "Stipendio lavoro: %s" % job.name)
	EventBus.job_completed.emit(current_job_id, wage)
	
	var msg: String = "Turno completato come %s. Guadagnati %.2f euro. Energia spesa: %d." % [job.name, wage, e_cost]
	AccessibilityManager.announce(msg, true)
	
	return {
		"success": true,
		"wage": wage,
		"energy_spent": e_cost,
		"stress_gained": job.get("stress_gain", 5),
		"new_balance": player_data.money,
		"job_name": job.name
	}

func resign_from_job() -> Dictionary:
	if current_job_id == "none":
		return {"success": false, "reason": "already_resigned"}
		
	var old_job: Dictionary = get_current_job()
	current_job_id = "none"
	EventBus.resigned_from_job.emit()
	
	var msg: String = "Hai compiuto il Salto nel Vuoto! Ti sei licenziato da %s: ora sei un musicista a tempo pieno!" % old_job.name
	AccessibilityManager.announce(msg, true)
	
	return {
		"success": true,
		"old_job_name": old_job.name,
		"message": msg
	}

func accept_job(job_id: String) -> bool:
	var jobs: Array[Dictionary] = get_available_jobs()
	for j in jobs:
		if j.id == job_id:
			current_job_id = job_id
			var msg: String = "Assunto come %s! Stipendio giornaliero: %.2f euro." % [j.name, j.wage]
			AccessibilityManager.announce(msg, true)
			return true
	return false

func to_dict() -> Dictionary:
	return {
		"current_job_id": current_job_id,
		"transactions": transactions
	}

func from_dict(dict: Dictionary) -> void:
	current_job_id = str(dict.get("current_job_id", "retail"))
	transactions.clear()
	var raw_tx: Array = dict.get("transactions", [])
	for t in raw_tx:
		if t is Dictionary:
			transactions.append(t)
