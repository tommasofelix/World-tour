# res://systems/band_system.gd
class_name BandSystem
extends RefCounted

## Gestore Centralizzato della Band, Reclutamento e Dinamiche Umane (World-tour V2.0)
## Governa la chimica di gruppo (Affinità, Rispetto, Tensione), le audizioni dei candidati,
## la divisione dei compensi (Revenue Split) e l'impatto sonoro sui concerti dal vivo.
const UpgradeData = preload("res://data/models/upgrade_data.gd")

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
		Enums.BandRole.GUITAR_RHYTHM,
		Enums.BandRole.VOCALS
	]
	
	# Genera almeno 5 candidati garantendo la presenza di tutti i 5 ruoli
	for i in range(roles.size()):
		var role: int = roles[i]
		var name_idx: int = (i + int(Time.get_ticks_msec() / 100)) % CANDIDATE_NAMES.size()
		var m_name: String = "%s %s" % [CANDIDATE_NAMES[name_idx], _get_role_suffix(role)]
		var personality: int = randi() % 8
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
		Enums.BandRole.VOCALS:
			return "Voice"
		_:
			return "Sound"

func calculate_compatibility(candidate: BandMemberData) -> float:
	var compatibility: float = 50.0
	match candidate.personality:
		Enums.BandPersonality.RELIABLE:
			compatibility += 20.0
		Enums.BandPersonality.PEACEMAKER:
			compatibility += 15.0
		Enums.BandPersonality.PERFECTIONIST:
			compatibility += 10.0
		Enums.BandPersonality.WILD_PARTY:
			compatibility += 5.0
		Enums.BandPersonality.MERCENARY:
			compatibility += 0.0
		Enums.BandPersonality.STAGE_ANXIOUS:
			compatibility -= 5.0
		Enums.BandPersonality.NATURAL_LEADER:
			compatibility -= 10.0
		Enums.BandPersonality.EGO_ARTIST:
			compatibility -= 10.0
			
	return clampf(compatibility, 10.0, 100.0)

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
	
	# Verifica se il candidato accetta o rifiuta per divario di livello / reputazione
	var rep_expected: float = player_data.reputation * 2.0 + 15.0
	var delta_skill: float = float(candidate.skill_level) - rep_expected
	if delta_skill > 25.0:
		var rej_msg: String = "Il candidato %s ha svolto il provino ma ha rifiutato l'offerta: reputa la band ancora troppo acerba per le sue aspettative artistiche (richiesta reputazione più alta)." % candidate.member_name
		AccessibilityManager.announce(rej_msg, true)
		return {
			"success": false,
			"reason": "candidate_rejected",
			"candidate": candidate,
			"message": rej_msg
		}
		
	var compatibility: float = calculate_compatibility(candidate)
	var ok_msg: String = "Audizione completata con successo per %s (Compatibilità stimata: %.0f%%)." % [candidate.member_name, compatibility]
	AccessibilityManager.announce(ok_msg, true)
	return {
		"success": true,
		"candidate": candidate,
		"compatibility": compatibility,
		"message": ok_msg
	}

func hire_candidate(candidate: BandMemberData) -> Dictionary:
	if not player_data:
		return {"success": false, "reason": "no_player_data"}
		
	if player_data.has_full_band():
		return {
			"success": false,
			"reason": "band_full",
			"message": "La band ha già raggiunto il limite massimo di %d compagni." % Constants.MAX_BAND_MEMBERS
		}
		
	# Controlla se il ruolo è già occupato
	var existing: BandMemberData = player_data.get_band_member_by_role(candidate.role)
	if existing:
		return {
			"success": false,
			"reason": "role_filled",
			"message": "Il ruolo di %s è già occupato da %s." % [candidate.get_role_name(), existing.member_name]
		}
		
	# Controllo divario di abilità se assunto direttamente
	var rep_expected: float = player_data.reputation * 2.0 + 15.0
	var delta_skill: float = float(candidate.skill_level) - rep_expected
	if delta_skill > 25.0:
		return {
			"success": false,
			"reason": "candidate_rejected",
			"message": "Il candidato %s rifiuta l'ingaggio: reputa la band ancora troppo acerba per le sue aspettative artistiche." % candidate.member_name
		}
		
	if calendar_data:
		candidate.joined_day = calendar_data.day_number
		
	# Calibrazione affinità iniziale basata sulla compatibilità
	candidate.affinity = calculate_compatibility(candidate)
	if candidate.personality == Enums.BandPersonality.PEACEMAKER:
		candidate.tension = 0.0
	elif candidate.personality == Enums.BandPersonality.EGO_ARTIST:
		candidate.tension = 15.0
	elif candidate.personality == Enums.BandPersonality.STAGE_ANXIOUS:
		candidate.tension = 10.0
		
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
	
	# Impatto psicologico sui membri della band in base alla personalità
	for m in player_data.band_members:
		match mode:
			Enums.RevenueSplit.EQUAL_SPLIT:
				m.modify_tension(-10.0)
				m.modify_respect(5.0)
				m.modify_affinity(5.0)
			Enums.RevenueSplit.LEADER_BALANCED:
				if m.personality == Enums.BandPersonality.EGO_ARTIST or m.personality == Enums.BandPersonality.MERCENARY:
					m.modify_tension(8.0)
				elif m.personality == Enums.BandPersonality.NATURAL_LEADER:
					m.modify_tension(5.0)
			Enums.RevenueSplit.LEADER_PREDATORY:
				var tens_penalty: float = 20.0
				var resp_penalty: float = -12.0
				if m.personality == Enums.BandPersonality.MERCENARY:
					tens_penalty = 30.0 # Mercenario intollerante a quote predatorie
					resp_penalty = -18.0
				elif m.personality == Enums.BandPersonality.EGO_ARTIST:
					tens_penalty = 25.0
					resp_penalty = -15.0
				m.modify_tension(tens_penalty)
				m.modify_respect(resp_penalty)
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
	
	# Boost front-man: cantante dedicato carismatico o con personalità da palco
	for m in members:
		if m.role == Enums.BandRole.VOCALS:
			bonus += 3.0 # Boost presenza scenica vocale
			if m.personality == Enums.BandPersonality.WILD_PARTY:
				bonus += 2.0
				
	if player_data:
		bonus += player_data.get_total_gear_synergy_bonus()
	return clampf(bonus, -15.0, 35.0)

## Conduce una sessione di prove con la band
func hold_rehearsal_session(check_noise_complaint: bool = false) -> Dictionary:
	if not player_data:
		return {"success": false, "reason": "no_player_data"}
	if player_data.band_members.is_empty():
		return {
			"success": false,
			"reason": "no_band",
			"message": "Non hai ancora una band con cui provare. Recluta prima dei musicisti!"
		}
		
	var r_tier: int = player_data.rehearsal_tier
	if player_data.current_housing_tier == Enums.HousingTier.LOFT_STUDIO:
		r_tier = maxi(r_tier, 2)
	elif player_data.current_housing_tier == Enums.HousingTier.LUXURY_VILLA:
		r_tier = maxi(r_tier, 3)
		
	# Tier 1+ riduce l'affaticamento del 30% (consumo energia scende da 15 a 10)
	var energy_cost: int = 10 if r_tier >= UpgradeData.RehearsalTier.ACOUSTIC_PANELS else 15
	if not player_data.consume_energy(energy_cost):
		return {
			"success": false,
			"reason": "energy_insufficient",
			"message": "Energia insufficiente per una sessione di prove (richiesta %d%%)." % energy_cost
		}
		
	var stress_gain: int = UpgradeData.get_rehearsal_stress(r_tier)
	if stress_gain > 0:
		player_data.add_stress(stress_gain)
		
	# Tier 3 (Studio Acustico Perfetto & Lounge): +8 morale ad Alex
	if r_tier >= UpgradeData.RehearsalTier.MASTER_STUDIO:
		player_data.add_morale(8)
		
	# Usura dello strumento attivo durante le prove (-3%)
	var p_cat: String = player_data.get_primary_category()
	player_data.apply_instrument_wear(p_cat, Constants.WEAR_PER_REHEARSAL)
		
	# Prove aumentano affinità e rispetto, e riducono tensione, con bonus speciali da personalità
	var has_peacemaker: bool = false
	var has_perfectionist: bool = false
	for m in player_data.band_members:
		if m.personality == Enums.BandPersonality.PEACEMAKER:
			has_peacemaker = true
		elif m.personality == Enums.BandPersonality.PERFECTIONIST:
			has_perfectionist = true
			
	var aff_delta: float = 6.0 if has_peacemaker else 4.0
	# Tier 2 (Insonorizzazione Pro): +5% extra affinità band
	if r_tier >= UpgradeData.RehearsalTier.PRO_ISOLATION:
		aff_delta += 5.0
		
	var resp_delta: float = 7.0 if has_perfectionist else 5.0
	var tens_delta: float = -10.0 if has_peacemaker else -8.0
	
	for m in player_data.band_members:
		m.modify_affinity(aff_delta)
		m.modify_respect(resp_delta)
		m.modify_tension(tens_delta)
		
	_emit_chemistry_changed()
	
	# Controllo disturbo della quiete pubblica (se richiesto dal contesto o dalle prove)
	var noise_incident: bool = false
	var noise_message: String = ""
	if check_noise_complaint:
		if r_tier == UpgradeData.RehearsalTier.NONE:
			noise_incident = true
			var fine: float = Constants.REHEARSAL_NEIGHBOR_FINE_TIER_0
			if player_data.money >= fine:
				player_data.modify_money(-fine)
				EventBus.money_changed.emit(player_data.money, -fine, "neighbor_complaint_fine")
			player_data.add_stress(10)
			noise_message = " I vicini hanno protestato per il rumore nel garage: sanzione di %.0f € e +10 Stress!" % fine
		elif r_tier == UpgradeData.RehearsalTier.ACOUSTIC_PANELS:
			noise_incident = true
			player_data.add_stress(5)
	# Aumenta la padronanza live delle canzoni in repertorio (+15%)
	var cur_day: int = GameManager.calendar_data.day_number if GameManager and GameManager.calendar_data else 1
	for s in player_data.get_playable_songs():
		s.mastery_live = clampf(s.mastery_live + 15.0, 20.0, 100.0)
		s.last_played_day = cur_day

	var msg: String = "Sessione di prove completata! La coesione del gruppo e la padronanza dei brani sono aumentate (Stress accumulato: +%d).%s" % [stress_gain, noise_message]
	AccessibilityManager.announce(msg, true)
	return {
		"success": true,
		"stress_gain": stress_gain,
		"rehearsal_tier": r_tier,
		"energy_cost": energy_cost,
		"noise_incident": noise_incident,
		"message": msg
	}

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
