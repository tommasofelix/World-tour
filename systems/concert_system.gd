# res://systems/concert_system.gd
class_name ConcertSystem
extends RefCounted

## Motore del Palco dal Vivo e della Simulazione Concerti (World-tour)
## Governa l'accesso ai locali, la scaletta, gli imprevisti live (Stage Events),
## il calcolo del Concert Score, la conversione fan e l'economia della serata.
## Conforme a SP-04, SP-06 e alla Clean Architecture.

var player_data: PlayerData
var calendar_data: CalendarData
var skill_system: SkillSystem

func _init(p_player_data: PlayerData, p_arg2: Variant = null, p_arg3: Variant = null) -> void:
	player_data = p_player_data
	if p_arg2 is CalendarData:
		calendar_data = p_arg2
	elif p_arg2 is SkillSystem:
		skill_system = p_arg2
		
	if p_arg3 is CalendarData:
		calendar_data = p_arg3
	elif p_arg3 is SkillSystem:
		skill_system = p_arg3

## Verifica se il giocatore soddisfa i requisiti per suonare nel locale
func can_play_concert(venue: VenueData, setlist: Array[SongData]) -> Dictionary:
	if not player_data:
		return {"allowed": false, "reason": "no_player_data", "message": "Dati giocatore non trovati."}
		
	if setlist.is_empty():
		return {"allowed": false, "reason": "empty_setlist", "message": "La scaletta deve contenere almeno un brano pronto o pubblicato."}
		
	if player_data.energy < 25:
		return {"allowed": false, "reason": "energy_insufficient", "message": "Energia insufficiente per suonare dal vivo (25 richieste)."}
		
	if player_data.money < venue.rent_cost:
		return {"allowed": false, "reason": "money_insufficient", "message": "Fondi insufficienti per l'affitto del locale (%.2f € richiesti)." % venue.rent_cost}
		
	if player_data.popularity < venue.min_popularity:
		return {"allowed": false, "reason": "popularity_insufficient", "message": "Popolarità insufficiente per questo locale (%.1f%% richiesta)." % venue.min_popularity}
		
	return {"allowed": true, "reason": "ok", "message": "Pronto a salire sul palco!"}

## Esegue il Soundcheck pomeridiano (consuma 15 energia, riduce a zero gli imprevisti tecnici)
func perform_soundcheck() -> Dictionary:
	if not player_data:
		return {"success": false, "reason": "no_player_data"}
		
	if not player_data.consume_energy(15):
		return {"success": false, "reason": "energy_insufficient"}
		
	player_data.add_stress(4)
	return {"success": true, "acoustic_bonus": 5.0}

## Genera un imprevisto scenico casuale sul palco (Stage Event)
func generate_stage_event(is_soundcheck_done: bool = false) -> Dictionary:
	var possible_types: Array[int] = [Enums.StageEventType.BROKEN_STRING, Enums.StageEventType.ENTHUSIASTIC_FAN]
	if not is_soundcheck_done:
		possible_types.append(Enums.StageEventType.AUDIO_FEEDBACK)
		
	var chosen_type: int = possible_types[randi() % possible_types.size()]
	
	match chosen_type:
		Enums.StageEventType.BROKEN_STRING:
			return {
				"type": chosen_type,
				"title": tr("EVENT_STRING_TITLE"),
				"description": tr("EVENT_STRING_DESC"),
				"choice_1_text": tr("EVENT_STRING_CHOICE_1"),
				"choice_1_skill": "charisma",
				"choice_2_text": tr("EVENT_STRING_CHOICE_2"),
				"choice_2_skill": "performance"
			}
		Enums.StageEventType.AUDIO_FEEDBACK:
			return {
				"type": chosen_type,
				"title": tr("EVENT_AUDIO_TITLE"),
				"description": tr("EVENT_AUDIO_DESC"),
				"choice_1_text": tr("EVENT_AUDIO_CHOICE_1"),
				"choice_1_skill": "charisma",
				"choice_2_text": tr("EVENT_AUDIO_CHOICE_2"),
				"choice_2_skill": "performance"
			}
		Enums.StageEventType.ENTHUSIASTIC_FAN:
			return {
				"type": chosen_type,
				"title": tr("EVENT_FAN_TITLE"),
				"description": tr("EVENT_FAN_DESC"),
				"choice_1_text": tr("EVENT_FAN_CHOICE_1"),
				"choice_1_skill": "charisma",
				"choice_2_text": tr("EVENT_FAN_CHOICE_2"),
				"choice_2_skill": "performance"
			}
		_:
			return {
				"type": Enums.StageEventType.NONE,
				"title": "",
				"description": "",
				"choice_1_text": "",
				"choice_1_skill": "",
				"choice_2_text": "",
				"choice_2_skill": ""
			}

## Risolve la scelta compiuta dal giocatore durante un imprevisto live
func resolve_stage_event_choice(event_data: Dictionary, choice_index: int) -> Dictionary:
	var skill_tested: String = event_data.get("choice_1_skill", "charisma") if choice_index == 1 else event_data.get("choice_2_skill", "performance")
	var skill_level: int = player_data.get_skill_level(skill_tested) if player_data else 10
	
	# Test di abilità: probabilità di successo scalata sul livello della skill
	var success_chance: float = clampf(float(skill_level) / 25.0, 0.40, 0.95)
	var is_success: bool = randf() <= success_chance
	
	var score_delta: float = 10.0 if is_success else -8.0
	var xp_awarded: float = 20.0 if is_success else 8.0
	
	if skill_system:
		skill_system.add_xp(skill_tested, xp_awarded)
		
	var outcome_msg: String = tr("EVENT_OUTCOME_SUCCESS") if is_success else tr("EVENT_OUTCOME_FAILURE")
	return {
		"is_success": is_success,
		"score_delta": score_delta,
		"skill_tested": skill_tested,
		"xp_awarded": xp_awarded,
		"message": outcome_msg
	}

## Risolve completamente il concerto live, calcolando spettatori, score, incasso e fan
func resolve_concert(venue: VenueData, setlist: Array[SongData], ticket_price: float, is_soundcheck: bool = false, event_score_delta: float = 0.0, force_stage_accident: Variant = null) -> Dictionary:
	var check := can_play_concert(venue, setlist)
	if not check.get("allowed", false):
		return {"success": false, "reason": check.get("reason", "error"), "message": check.get("message", "")}
		
	# 1. Costi di affitto ed energia
	player_data.modify_money(-venue.rent_cost)
	EventBus.money_changed.emit(player_data.money, -venue.rent_cost, "venue_rent")
	
	player_data.consume_energy(25)
	player_data.add_stress(10)
	
	# 2. Calcolo spettatori (Audience)
	var audience: int = Formulas.calculate_audience(
		venue.capacity,
		player_data.popularity,
		venue.prestige,
		ticket_price,
		venue.fair_ticket_price
	)
	
	# Moltiplicatori del fine settimana (Venerdì +50%, Sabato +100%)
	var weekend_mult: float = 1.0
	if calendar_data:
		var wday: int = calendar_data.get_weekday()
		if wday == Enums.Weekday.FRIDAY:
			weekend_mult = Constants.WEEKEND_FRIDAY_AUDIENCE_MULT
		elif wday == Enums.Weekday.SATURDAY:
			weekend_mult = Constants.WEEKEND_SATURDAY_AUDIENCE_MULT
	if weekend_mult > 1.0:
		audience = mini(venue.capacity, int(round(float(audience) * weekend_mult)))
		
	# Moltiplicatore Hype del Tour (se c'è una tournée in corso)
	var tour_hype_mult: float = 1.0
	if GameManager and GameManager.tour_system:
		tour_hype_mult = GameManager.tour_system.get_tour_hype_multiplier()
	if tour_hype_mult > 1.0:
		audience = mini(venue.capacity, int(round(float(audience) * tour_hype_mult)))
		
	# Moltiplicatore Social Buzz (Hype generato da post e viralità)
	var social_buzz_mult: float = 1.0
	if GameManager and GameManager.social_media_system:
		social_buzz_mult = GameManager.social_media_system.get_live_buzz_multiplier()
	if social_buzz_mult > 1.0:
		audience = mini(venue.capacity, int(round(float(audience) * social_buzz_mult)))
	
	# 3. Valutazione scaletta e qualità media
	var total_qual: float = 0.0
	for s in setlist:
		total_qual += s.quality_score
	var avg_quality: float = total_qual / float(maxi(1, setlist.size()))
	
	# Bonus Closer / Stage Beast sull'ultimo pezzo della scaletta
	var closer_bonus_mult: float = 1.0
	var last_song: SongData = setlist[setlist.size() - 1]
	if last_song.special_trait == Enums.SongTrait.STAGE_BEAST:
		closer_bonus_mult = 1.15
		
	# 4. Calcolo Concert Score
	var perf_level: float = float(player_data.get_skill_level("performance"))
	var charisma_level: float = float(player_data.get_skill_level("charisma"))
	if player_data:
		var inst_bonus: Dictionary = player_data.get_primary_instrument_bonus()
		charisma_level += float(inst_bonus.get("charisma_bonus", 0))
	var base_score: float = Formulas.calculate_concert_score(
		perf_level,
		charisma_level,
		avg_quality,
		float(player_data.energy)
	)
	
	var soundcheck_bonus: float = 5.0 if is_soundcheck else 0.0
	var band_synergy: float = 0.0
	if GameManager and GameManager.band_system:
		band_synergy = GameManager.band_system.get_band_synergy_bonus()
	
	# Sound Shaping Bonus (Pedalboard + Amplificatore)
	var sound_shaping_bonus: float = 0.0
	if player_data:
		sound_shaping_bonus = player_data.get_sound_shaping_genre_bonus(last_song.genre)
		
	# Gestione usura strumento ed eventuali Stage Accidents
	var stage_accident: bool = false
	var accident_saved_by_backup: bool = false
	var accident_penalty: float = 0.0
	if player_data:
		var p_cat: String = player_data.get_primary_category()
		var cond: float = player_data.get_instrument_condition(p_cat)
		var trigger_accident: bool = false
		if force_stage_accident != null:
			trigger_accident = bool(force_stage_accident)
		elif cond <= Constants.CONDITION_CRITICAL:
			trigger_accident = randf() <= Constants.STAGE_ACCIDENT_CHANCE
			
		if trigger_accident:
			stage_accident = true
			if player_data.has_backup_instrument:
				accident_saved_by_backup = true
				AccessibilityManager.announce("Corda rotta sul palco! Sostituzione istantanea con il muletto nel van: lo show continua senza intoppi!", true)
			else:
				accident_penalty = Constants.STAGE_ACCIDENT_SCORE_PENALTY
				AccessibilityManager.announce("ATTENZIONE: Guasto tecnico allo strumento durante il concerto! Nessun muletto di riserva: penalità di -15 allo score!", true)
				
		player_data.apply_instrument_wear(p_cat, Constants.WEAR_PER_CONCERT)
	
	# Calcolo affinità media della scaletta con la scena musicale della città corrente
	var city_affinity_mult: float = 1.0
	if GameManager and GameManager.travel_system:
		var cur_city: CityData = GameManager.travel_system.get_current_city()
		if cur_city:
			var total_aff: float = 0.0
			for s in setlist:
				total_aff += cur_city.get_affinity_for_genre(s.genre)
			city_affinity_mult = total_aff / float(maxi(1, setlist.size()))
			
	var raw_score: float = (base_score * closer_bonus_mult) + event_score_delta + soundcheck_bonus + band_synergy + sound_shaping_bonus - accident_penalty
	var final_score: float = clampf(raw_score * city_affinity_mult, 1.0, 100.0)
	
	# 5. Conversione Fan
	var new_fans: int = Formulas.calculate_fan_conversion(audience, final_score, charisma_level)
	if last_song.special_trait == Enums.SongTrait.CULT_CLASSIC:
		new_fans = int(round(float(new_fans) * 2.0))
	if calendar_data and calendar_data.get_weekday() == Enums.Weekday.SATURDAY:
		new_fans = int(round(float(new_fans) * Constants.WEEKEND_SATURDAY_FAN_MULT))
	if city_affinity_mult != 1.0:
		new_fans = int(round(float(new_fans) * city_affinity_mult))
		
	# Marcatura evento a calendario se programmato
	if GameManager and GameManager.schedule_system and calendar_data:
		var todays_events := GameManager.schedule_system.get_events_for_day(calendar_data.day_number)
		for ev in todays_events:
			if ev.event_type == Enums.CalendarEventType.CONCERT and (ev.location_id == venue.id or ev.location_id.is_empty()):
				GameManager.schedule_system.mark_event_completed(ev.id)
	
	# 6. Economia Serata & Ripartizione Compensi (Revenue Split & Manager)
	var gross_revenue: float = float(audience) * ticket_price
	var manager_cut: float = 0.0
	var pool_revenue: float = gross_revenue
	if GameManager and GameManager.industry_system and player_data.has_manager():
		var rev_calc: Dictionary = GameManager.industry_system.calculate_live_concert_revenue(gross_revenue)
		gross_revenue = rev_calc.gross_cachet
		manager_cut = rev_calc.manager_cut
		pool_revenue = rev_calc.net_band_revenue
		
	var net_revenue: float = gross_revenue - venue.rent_cost
	var player_share: float = pool_revenue
	var band_share: float = 0.0
	var active_members: Array[BandMemberData] = player_data.get_active_band_members() if player_data else []
	if not active_members.is_empty():
		var total_members: int = 1 + active_members.size()
		match player_data.revenue_split_mode:
			Enums.RevenueSplit.EQUAL_SPLIT:
				player_share = pool_revenue / float(total_members)
			Enums.RevenueSplit.LEADER_BALANCED:
				player_share = pool_revenue * 0.40
			Enums.RevenueSplit.LEADER_PREDATORY:
				player_share = pool_revenue * 0.70
		band_share = pool_revenue - player_share
		
	if player_share > 0.0:
		player_data.modify_money(player_share)
		EventBus.money_changed.emit(player_data.money, player_share, "concert_tickets")
		
	# 7. Crescita notorietà & statistiche con territorialità
	var pop_gain: float = (final_score / 100.0) * (float(audience) / float(venue.capacity)) * 3.0
	if GameManager and GameManager.travel_system:
		var cur_cid: int = GameManager.travel_system.current_city_id
		GameManager.travel_system.add_fans_in_city(cur_cid, new_fans)
		GameManager.travel_system.modify_popularity_in_city(cur_cid, pop_gain)
	else:
		player_data.fans += new_fans
		player_data.popularity = clampf(player_data.popularity + pop_gain, 0.0, 100.0)
		
	player_data.reputation = maxf(1.0, player_data.reputation + (final_score * 0.03))
	
	# Aggiorna metriche per le canzoni eseguite
	for s in setlist:
		s.plays += audience
		s.revenue += (gross_revenue / float(maxi(1, setlist.size())))
		
	# 8. Assegnazione XP abilità dal vivo
	if skill_system:
		skill_system.add_xp("performance", 25.0)
		skill_system.add_xp("charisma", 20.0)
		
	# 9. Dinamiche post-concerto della Band
	if GameManager and GameManager.band_system:
		GameManager.band_system.process_post_concert_dynamics(final_score)
		
	var result := {
		"success": true,
		"venue_id": venue.id,
		"venue_name": venue.get_localized_name(),
		"audience": audience,
		"capacity": venue.capacity,
		"ticket_price": ticket_price,
		"gross_revenue": gross_revenue,
		"rent_cost": venue.rent_cost,
		"net_revenue": net_revenue,
		"player_share": player_share,
		"band_share": band_share,
		"band_synergy_bonus": band_synergy,
		"sound_shaping_bonus": sound_shaping_bonus,
		"stage_accident": stage_accident,
		"accident_saved": accident_saved_by_backup,
		"accident_penalty": accident_penalty,
		"concert_score": final_score,
		"city_affinity_mult": city_affinity_mult,
		"tour_hype_mult": tour_hype_mult,
		"new_fans": new_fans,
		"popularity_gained": pop_gain,
		"is_soundcheck": is_soundcheck
	}
	
	if GameManager and GameManager.tour_system and GameManager.tour_system.active_tour:
		GameManager.tour_system.record_stop_result(result)
		
	EventBus.concert_resolved.emit(result)
	return result
