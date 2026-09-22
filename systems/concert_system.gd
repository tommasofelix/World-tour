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
func resolve_concert(venue: VenueData, setlist: Array[SongData], ticket_price: float, is_soundcheck: bool = false, event_score_delta: float = 0.0) -> Dictionary:
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
	var base_score: float = Formulas.calculate_concert_score(
		perf_level,
		charisma_level,
		avg_quality,
		float(player_data.energy)
	)
	
	var soundcheck_bonus: float = 5.0 if is_soundcheck else 0.0
	var final_score: float = clampf((base_score * closer_bonus_mult) + event_score_delta + soundcheck_bonus, 1.0, 100.0)
	
	# 5. Conversione Fan
	var new_fans: int = Formulas.calculate_fan_conversion(audience, final_score, charisma_level)
	if last_song.special_trait == Enums.SongTrait.CULT_CLASSIC:
		new_fans = int(round(float(new_fans) * 2.0))
		
	player_data.fans += new_fans
	
	# 6. Economia Serata
	var gross_revenue: float = float(audience) * ticket_price
	var net_revenue: float = gross_revenue - venue.rent_cost
	if gross_revenue > 0.0:
		player_data.modify_money(gross_revenue)
		EventBus.money_changed.emit(player_data.money, gross_revenue, "concert_tickets")
		
	# 7. Crescita notorietà & statistiche
	var pop_gain: float = (final_score / 100.0) * (float(audience) / float(venue.capacity)) * 3.0
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
		"concert_score": final_score,
		"new_fans": new_fans,
		"popularity_gained": pop_gain,
		"is_soundcheck": is_soundcheck
	}
	
	EventBus.concert_resolved.emit(result)
	return result
