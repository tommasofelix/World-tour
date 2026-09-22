# res://systems/career_system.gd
class_name CareerSystem
extends RefCounted

## Modulo di Progressione della Carriera e Riconoscimento Artistico (World-tour)
## Governa il passaggio tra gli stadi di notorietà (da Beginner a Superstar),
## la reputazione nell'ambiente musicale e lo sblocco di opportunità di vertice.
## Conforme a SP-01 e Clean Architecture.

var player_data: PlayerData

func _init(p_player_data: PlayerData) -> void:
	player_data = p_player_data
	EventBus.concert_resolved.connect(_on_performance_or_release)
	EventBus.song_released.connect(_on_performance_or_release)

func _on_performance_or_release(_data: Dictionary = {}) -> void:
	evaluate_career_progression()

func get_tier_name(tier: int) -> String:
	match tier:
		Enums.CareerTier.NOBODY:
			return tr("CAREER_TIER_0")
		Enums.CareerTier.BEDROOM_MUSICIAN:
			return tr("CAREER_TIER_1")
		Enums.CareerTier.BUSKER:
			return tr("CAREER_TIER_2")
		Enums.CareerTier.LOCAL_ARTIST:
			return tr("CAREER_TIER_3")
		Enums.CareerTier.UNDERGROUND_HERO:
			return tr("CAREER_TIER_4")
		Enums.CareerTier.INDIE_SENSATION:
			return tr("CAREER_TIER_5")
		Enums.CareerTier.NATIONAL_STAR:
			return tr("CAREER_TIER_6")
		Enums.CareerTier.GLOBAL_SUPERSTAR:
			return tr("CAREER_TIER_7")
		_:
			return tr("CAREER_TIER_0")

func get_tier_requirements(tier: int) -> Dictionary:
	match tier:
		Enums.CareerTier.NOBODY:
			return {"min_fans": 0, "min_pop": 0.0, "min_singles": 0}
		Enums.CareerTier.BEDROOM_MUSICIAN:
			return {"min_fans": 10, "min_pop": 2.0, "min_singles": 0}
		Enums.CareerTier.BUSKER:
			return {"min_fans": 50, "min_pop": 5.0, "min_singles": 1}
		Enums.CareerTier.LOCAL_ARTIST:
			return {"min_fans": 250, "min_pop": 15.0, "min_singles": 2}
		Enums.CareerTier.UNDERGROUND_HERO:
			return {"min_fans": 1000, "min_pop": 30.0, "min_singles": 3}
		Enums.CareerTier.INDIE_SENSATION:
			return {"min_fans": 5000, "min_pop": 50.0, "min_singles": 5}
		Enums.CareerTier.NATIONAL_STAR:
			return {"min_fans": 25000, "min_pop": 70.0, "min_singles": 8}
		Enums.CareerTier.GLOBAL_SUPERSTAR:
			return {"min_fans": 100000, "min_pop": 90.0, "min_singles": 12}
		_:
			return {"min_fans": 999999, "min_pop": 100.0, "min_singles": 99}

func evaluate_career_progression() -> Dictionary:
	if not player_data:
		return {"promoted": false, "reason": "no_player_data"}
		
	var current_tier: int = player_data.career_tier
	var next_tier: int = current_tier + 1
	if next_tier > Enums.CareerTier.GLOBAL_SUPERSTAR:
		return {"promoted": false, "reason": "max_tier_reached"}
		
	var reqs: Dictionary = get_tier_requirements(next_tier)
	var released_singles: int = player_data.get_released_singles().size()
	
	if player_data.fans >= reqs.min_fans and player_data.popularity >= reqs.min_pop and released_singles >= reqs.min_singles:
		player_data.career_tier = next_tier
		var new_name: String = get_tier_name(next_tier)
		
		EventBus.career_tier_promoted.emit(next_tier, new_name)
		EventBus.career_status_unlocked.emit(next_tier, new_name)
		
		var msg: String = "Congratulazioni! Sei stato promosso di status: ora sei %s!" % new_name
		AccessibilityManager.announce(msg, true)
		
		return {
			"promoted": true,
			"old_tier": current_tier,
			"new_tier": next_tier,
			"tier_name": new_name
		}
		
	return {
		"promoted": false,
		"current_tier": current_tier,
		"tier_name": get_tier_name(current_tier)
	}

func get_career_summary() -> Dictionary:
	if not player_data:
		return {}
	var cur: int = player_data.career_tier
	var nxt: int = mini(cur + 1, Enums.CareerTier.GLOBAL_SUPERSTAR)
	var nxt_reqs: Dictionary = get_tier_requirements(nxt)
	return {
		"tier": cur,
		"tier_name": get_tier_name(cur),
		"next_tier": nxt,
		"next_tier_name": get_tier_name(nxt),
		"fans": player_data.fans,
		"req_fans": nxt_reqs.min_fans,
		"popularity": player_data.popularity,
		"req_popularity": nxt_reqs.min_pop,
		"singles": player_data.get_released_singles().size(),
		"req_singles": nxt_reqs.min_singles
	}
