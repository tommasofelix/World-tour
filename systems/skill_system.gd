# res://systems/skill_system.gd
class_name SkillSystem
extends RefCounted

## Gestore Centralizzato della Progressione delle 7 Abilità di World-tour
## Governa l'accumulo di XP, le soglie esponenziali di livello e le notifiche di avanzamento.

var player_data: PlayerData

func _init(p_player_data: PlayerData) -> void:
	player_data = p_player_data

func add_xp(skill_key: String, xp_amount: float) -> Dictionary:
	if not player_data or not player_data.skills.has(skill_key):
		return {"success": false, "leveled_up": false}
		
	var data: Dictionary = player_data.skills[skill_key]
	var old_level: int = int(data["level"])
	data["xp"] += xp_amount
	var current_level: int = old_level
	var required_xp: int = Formulas.calculate_xp_for_level(current_level)
	var leveled_up: bool = false
	
	while data["xp"] >= float(required_xp) and current_level < 99:
		data["xp"] -= float(required_xp)
		data["level"] += 1
		current_level = data["level"]
		required_xp = Formulas.calculate_xp_for_level(current_level)
		leveled_up = true
		
	if leveled_up:
		EventBus.skill_leveled_up.emit(skill_key, current_level)
		var skill_name := get_skill_name(skill_key)
		var msg := tr("MSG_LEVEL_UP") % [skill_name, current_level]
		AccessibilityManager.announce(msg, true)
		
	return {
		"success": true,
		"leveled_up": leveled_up,
		"old_level": old_level,
		"new_level": current_level,
		"current_xp": data["xp"],
		"xp_gained": xp_amount
	}

func get_skill_level(skill_key: String) -> int:
	if player_data and player_data.skills.has(skill_key):
		return int(player_data.skills[skill_key]["level"])
	return 10

func get_skill_xp(skill_key: String) -> float:
	if player_data and player_data.skills.has(skill_key):
		return float(player_data.skills[skill_key]["xp"])
	return 0.0

func get_xp_for_next_level(skill_key: String) -> int:
	var lvl: int = get_skill_level(skill_key)
	return Formulas.calculate_xp_for_level(lvl)

func get_skill_name(skill_key: String) -> String:
	match skill_key:
		"instrument":
			return tr("SKILL_INSTRUMENT")
		"composition":
			return tr("SKILL_COMPOSITION")
		"songwriting":
			return tr("SKILL_SONGWRITING")
		"production":
			return tr("SKILL_PRODUCTION")
		"performance":
			return tr("SKILL_PERFORMANCE")
		"charisma":
			return tr("SKILL_CHARISMA")
		"business":
			return tr("SKILL_BUSINESS")
		_:
			return skill_key.capitalize()

func get_all_skills_summary() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if not player_data:
		return result
		
	for k in player_data.skills:
		result.append({
			"key": k,
			"name": get_skill_name(k),
			"level": get_skill_level(k),
			"xp": get_skill_xp(k),
			"next_level_xp": get_xp_for_next_level(k)
		})
	return result
