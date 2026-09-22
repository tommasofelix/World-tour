# res://systems/band_system.gd
class_name BandSystem
extends RefCounted

## Gestore Centralizzato della Band, Reclutamento e Dinamiche Umane (World-tour V2.0)
## Governa la chimica di gruppo (Affinità, Rispetto, Tensione), le audizioni dei candidati,
## la divisione dei compensi (Revenue Split) e l'impatto sonoro sui concerti dal vivo.

var player_data: PlayerData
var calendar_data: CalendarData
var candidates_pool: Array[BandMemberData] = []

const CANDIDATE_NAMES: Array[String] = [
	"Davide", "Elena", "Matteo", "Sara", "Lorenzo",
	"Chiara", "Simone", "Federica", "Michele", "Valentina",
	"Giacomo", "Beatrice", "Fabio", "Giulia", "Andrea"
]

func _init(p_player: PlayerData, p_calendar: CalendarData = null) -> void:
	player_data = p_player
	calendar_data = p_calendar
	generate_initial_candidates_if_empty()

func generate_initial_candidates_if_empty() -> void:
	if candidates_pool.is_empty():
		refresh_candidates_pool()

func refresh_candidates_pool() -> void:
	candidates_pool.clear()
	var roles: Array[int] = [
		Enums.BandRole.BASS,
		Enums.BandRole.DRUMS,
		Enums.BandRole.KEYBOARDS,
		Enums.BandRole.GUITAR_RHYTHM
	]
	
	# Genera almeno 4 candidati (uno per ciascun ruolo)
	for i in range(roles.size()):
		var role: int = roles[i]
		var name_idx: int = (i + int(Time.get_ticks_msec() / 100)) % CANDIDATE_NAMES.size()
		var m_name: String = "%s %s" % [CANDIDATE_NAMES[name_idx], _get_role_suffix(role)]
		var personality: int = randi() % 4
		var genre: int = randi() % 6
		var base_skill: int = 12 + (randi() % 15)
		if player_data:
			base_skill += int(player_data.reputation * 1.5)
			
		var candidate := BandMemberData.new(
			"cand_%d_%d" % [role, randi() % 1000],
			m_name,
			role,
			personality,
			genre,
			clampi(base_skill, 10, 85)
		)
		candidates_pool.append(candidate)

func _get_role_suffix(role: int) -> String:
	match role:
		Enums.BandRole.BASS:
			return "Groove"
		Enums.BandRole.DRUMS:
			return "Beats"
		Enums.BandRole.KEYBOARDS:
			return "Keys"
		Enums.BandRole.GUITAR_RHYTHM:
			return "Riff"
		_:
			return "Sound"

func audition_candidate(candidate: BandMemberData) -> Dictionary:
	if not player_data:
		return {"success": false, "reason": "no_player_data"}
		
	if player_data.money < Constants.BAND_AUDITION_FEE:
		return {
			"success": false,
			"reason": "money_insufficient",
			"message": "Fondi insufficienti per organizzare l'audizione (richiesti %.2f €)." % Constants.BAND_AUDITION_FEE
		}
		
	player_data.modify_money(-Constants.BAND_AUDITION_FEE)
	EventBus.money_changed.emit(player_data.money, -Constants.BAND_AUDITION_FEE, "band_audition")
	
	# Calcolo compatibilità
	var compatibility: float = 50.0
	if candidate.personality == Enums.BandPersonality.RELIABLE:
		compatibility += 20.0
	elif candidate.personality == Enums.BandPersonality.PERFECTIONIST:
		compatibility += 10.0
	elif candidate.personality == Enums.BandPersonality.EGO_ARTIST:
		compatibility -= 10.0
		
	return {
		"success": true,
		"candidate": candidate,
		"compatibility": clampf(compatibility, 10.0, 100.0),
		"message": "Audizione completata con successo per %s." % candidate.member_name
	}

func hire_candidate(candidate: BandMemberData) -> Dictionary:
	if not player_data:
		return {"success": false, "reason": "no_player_data"}
		
	if player_data.has_full_band():
		return {
			"success": false,
			"reason": "band_full",
			"message": "La band ha già raggiunto il limite massimo di %d membri." % Constants.MAX_BAND_MEMBERS
		}
		
	# Controlla se il ruolo è già occupato
	var existing: BandMemberData = player_data.get_band_member_by_role(candidate.role)
	if existing:
		return {
			"success": false,
			"reason": "role_filled",
			"message": "Il ruolo di %s è già occupato da %s." % [candidate.get_role_name(), existing.member_name]
		}
		
	if calendar_data:
		candidate.joined_day = calendar_data.day_number
		
	player_data.add_band_member(candidate)
	candidates_pool.erase(candidate)
	
	EventBus.band_member_joined.emit(candidate)
	_emit_chemistry_changed()
	
	var msg: String = "%s è entrato nella band come %s!" % [candidate.member_name, candidate.get_role_name()]
	AccessibilityManager.announce(msg, true)
	
	return {
		"success": true,
		"member": candidate,
		"message": msg
	}

func fire_member(member_id: String) -> Dictionary:
	if not player_data:
		return {"success": false, "reason": "no_player_data"}
		
	var target_member: BandMemberData = null
	for m in player_data.band_members:
		if m.id == member_id:
			target_member = m
			break
			
	if not target_member:
		return {"success": false, "reason": "member_not_found"}
		
	player_data.remove_band_member(member_id)
	EventBus.band_member_left.emit(target_member, "fired")
	_emit_chemistry_changed()
	
	var msg: String = "%s è stato sollevato dal suo ruolo nella band." % target_member.member_name
	AccessibilityManager.announce(msg, true)
	
	return {
		"success": true,
		"message": msg
	}

func set_revenue_split(mode: int) -> void:
	if not player_data:
		return
		
	player_data.revenue_split_mode = mode
	
	# Impatto psicologico sui membri della band
	for m in player_data.band_members:
		match mode:
			Enums.RevenueSplit.EQUAL_SPLIT:
				m.modify_tension(-10.0)
				m.modify_respect(5.0)
				m.modify_affinity(5.0)
			Enums.RevenueSplit.LEADER_BALANCED:
				if m.personality == Enums.BandPersonality.EGO_ARTIST:
					m.modify_tension(8.0)
			Enums.RevenueSplit.LEADER_PREDATORY:
				m.modify_tension(20.0)
				m.modify_respect(-12.0)
				m.modify_affinity(-10.0)
				
	EventBus.band_revenue_split_changed.emit(mode)
	_emit_chemistry_changed()

func get_average_affinity() -> float:
	var members: Array[BandMemberData] = player_data.get_active_band_members() if player_data else []
	if members.is_empty():
		return 50.0
	var sum: float = 0.0
	for m in members:
		sum += m.affinity
	return sum / float(members.size())

func get_average_respect() -> float:
	var members: Array[BandMemberData] = player_data.get_active_band_members() if player_data else []
	if members.is_empty():
		return 50.0
	var sum: float = 0.0
	for m in members:
		sum += m.musical_respect
	return sum / float(members.size())

func get_average_tension() -> float:
	var members: Array[BandMemberData] = player_data.get_active_band_members() if player_data else []
	if members.is_empty():
		return 0.0
	var sum: float = 0.0
	for m in members:
		sum += m.tension
	return sum / float(members.size())

func get_band_synergy_bonus() -> float:
	var members: Array[BandMemberData] = player_data.get_active_band_members() if player_data else []
	if members.is_empty():
		return 0.0
		
	var avg_aff: float = get_average_affinity()
	var avg_resp: float = get_average_respect()
	var avg_tens: float = get_average_tension()
	
	# Sinergia sonora: Affinità e rispetto arricchiscono il sound (+25 max), la tensione genera dissonanze (-15 max)
	var raw_synergy: float = ((avg_aff * 0.40) + (avg_resp * 0.60)) - (avg_tens * 0.70)
	var bonus: float = (raw_synergy / 100.0) * 25.0
	return clampf(bonus, -15.0, 25.0)

func process_post_concert_dynamics(concert_score: float) -> Array[Dictionary]:
	var crisis_events: Array[Dictionary] = []
	if not player_data:
		return crisis_events
		
	for m in player_data.get_active_band_members():
		if concert_score >= 75.0:
			m.modify_respect(6.0)
			m.modify_affinity(5.0)
			m.modify_tension(-12.0)
		elif concert_score >= 50.0:
			m.modify_respect(3.0)
			m.modify_affinity(2.0)
			m.modify_tension(-5.0)
		else:
			m.modify_respect(-5.0)
			m.modify_tension(15.0)
			
		# Controllo soglia critica abbandono
		if m.is_threatening_to_quit():
			crisis_events.append({
				"member_id": m.id,
				"member_name": m.member_name,
				"tension": m.tension,
				"message": "ATTENZIONE: La tensione di %s è arrivata a %.0f%%! Minaccia di lasciare il gruppo!" % [m.member_name, m.tension]
			})
			
	_emit_chemistry_changed()
	return crisis_events

func _emit_chemistry_changed() -> void:
	EventBus.band_chemistry_changed.emit(
		get_average_affinity(),
		get_average_respect(),
		get_average_tension()
	)
