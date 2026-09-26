# res://systems/concert_system.gd
class_name ConcertSystem
extends RefCounted

## Motore del Palco dal Vivo e della Simulazione Concerti (World-tour)
## Governa l'accesso ai locali, la disponibilità del calendario venue, la drammaturgia
## della scaletta, gli imprevisti live (Stage Events), il calcolo del Concert Score,
## la conversione fan, il banchetto merchandising, l'Encore e l'economia della serata.
## Conforme a SP-04, SP-06 e alla Clean Architecture (ASTRALIS v3.0.7).

var player_data: PlayerData
var calendar_data: CalendarData
var skill_system: SkillSystem

## Override manuali o di prenotazione per la disponibilità dei locali ("venue_id_dayNumber" -> status)
var venue_status_overrides: Dictionary = {}

## Livello allestimento scenico per grandi arene e stadi (Enums.StageProductionTier)
var active_stage_production: int = Enums.StageProductionTier.BASIC_STADIUM

func select_stage_production(tier: int) -> Dictionary:
	var cost: float = 0.0
	match tier:
		Enums.StageProductionTier.RUNWAY_CATWALK:
			cost = Constants.STAGE_RUNWAY_COST
		Enums.StageProductionTier.CENTER_360_STAGE:
			cost = Constants.STAGE_360_COST
		Enums.StageProductionTier.MEGA_PYRO_LASER:
			cost = Constants.STAGE_PYRO_COST
		_:
			cost = 0.0

	if player_data and cost > 0.0 and player_data.money < cost:
		return {
			"success": false,
			"reason": "money_insufficient",
			"cost": cost,
			"message": "Fondi insufficienti per l'allestimento scenico (%.2f € richiesti)." % cost
		}

	active_stage_production = tier
	return {
		"success": true,
		"tier": tier,
		"tier_name": Enums.get_stage_production_name(tier),
		"cost": cost
	}


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

# ==============================================================================
# GESTIONE DEL CALENDARIO E DISPONIBILITÀ DELLE VENUE (LA MECCANICA DI LUCA)
# ==============================================================================

## Restituisce lo stato di disponibilità di un locale per uno specifico giorno di calendario
func get_venue_status(venue_id: String, day_number: int) -> int:
	var key := "%s_%d" % [venue_id, day_number]
	if venue_status_overrides.has(key):
		return int(venue_status_overrides[key])

	# Controlla se la band del giocatore ha già prenotato questo locale in agenda
	if GameManager and GameManager.schedule_system:
		var events := GameManager.schedule_system.get_events_for_day(day_number)
		for ev in events:
			if ev.event_type == Enums.CalendarEventType.CONCERT and ev.location_id == venue_id and not ev.is_completed:
				return Enums.VenueBookingStatus.BOOKED_PLAYER

	# Locali fuori dal circuito locale principale (es. città secondarie o test) sono sempre liberi
	if not venue_id.begins_with("venue_"):
		return Enums.VenueBookingStatus.FREE

	# Garage è sempre libero per le prove e i concerti starter
	if venue_id == "venue_garage":
		return Enums.VenueBookingStatus.FREE

	# Calcolo deterministico della disponibilità naturale
	var weekday: int = (day_number - 1) % Constants.DAYS_PER_WEEK
	var is_weekend: bool = (weekday == Enums.Weekday.FRIDAY or weekday == Enums.Weekday.SATURDAY)
	var is_monday: bool = (weekday == Enums.Weekday.MONDAY)

	# Teatri e club underground chiusi di lunedì per manutenzione/riposo
	if is_monday and (venue_id.contains("theatre") or venue_id.contains("small_club")):
		return Enums.VenueBookingStatus.MAINTENANCE

	# Hash deterministico basato su venue_id e day_number
	var hash_val: int = absi((venue_id.hash() + (day_number * 31))) % 100

	# Soglia di occupazione: i locali prestigiosi e i weekend sono più affollati
	var occupancy_threshold: int = 30
	if venue_id.contains("garage"):
		occupancy_threshold = 20 if is_weekend else 10
	elif venue_id.contains("pub"):
		occupancy_threshold = 45 if is_weekend else 20
	elif venue_id.contains("social"):
		occupancy_threshold = 50 if is_weekend else 25
	elif venue_id.contains("theatre") or venue_id.contains("opera"):
		occupancy_threshold = 70 if is_weekend else 35
	else:
		occupancy_threshold = 65 if is_weekend else 30

	if hash_val < occupancy_threshold:
		return Enums.VenueBookingStatus.BOOKED_OTHER

	return Enums.VenueBookingStatus.FREE

## Imposta forzatamente o manualmente lo stato di una venue per un dato giorno
func set_venue_status_override(venue_id: String, day_number: int, status: int) -> void:
	venue_status_overrides["%s_%d" % [venue_id, day_number]] = status

## Prenota anticipatamente un locale per uno specifico giorno futuro
func book_venue_date(venue_id: String, day_number: int) -> bool:
	var cur_status: int = get_venue_status(venue_id, day_number)
	if cur_status != Enums.VenueBookingStatus.FREE:
		return false
	set_venue_status_override(venue_id, day_number, Enums.VenueBookingStatus.BOOKED_PLAYER)
	return true

## Calcola il costo dell'affitto applicando eventuale sovrapprezzo weekend (+20% Ven/Sab)
func get_venue_rent_cost(venue: VenueData, day_number: int) -> float:
	var weekday: int = (day_number - 1) % Constants.DAYS_PER_WEEK
	if weekday == Enums.Weekday.FRIDAY or weekday == Enums.Weekday.SATURDAY:
		return venue.rent_cost * Constants.WEEKEND_RENT_SURCHARGE
	return venue.rent_cost

## Verifica se il giocatore soddisfa i requisiti per suonare nel locale
func can_play_concert(venue: VenueData, setlist: Array[SongData]) -> Dictionary:
	if not player_data:
		return {"allowed": false, "reason": "no_player_data", "message": "Dati giocatore non trovati."}

	if setlist.is_empty():
		return {"allowed": false, "reason": "empty_setlist", "message": "La scaletta deve contenere almeno un brano pronto o pubblicato."}

	if player_data.energy < 25:
		return {"allowed": false, "reason": "energy_insufficient", "message": "Energia insufficiente per suonare dal vivo (25 richieste)."}

	var cur_day: int = calendar_data.day_number if calendar_data else 1
	if calendar_data:
		var status: int = get_venue_status(venue.id, cur_day)
		if status == Enums.VenueBookingStatus.BOOKED_OTHER:
			return {"allowed": false, "reason": "venue_occupied", "message": tr("CONCERT_VENUE_OCCUPIED_MSG")}
		if status == Enums.VenueBookingStatus.MAINTENANCE:
			return {"allowed": false, "reason": "venue_closed", "message": tr("CONCERT_VENUE_CLOSED_MSG")}

	var actual_rent: float = get_venue_rent_cost(venue, cur_day)
	if player_data.money < actual_rent:
		return {"allowed": false, "reason": "money_insufficient", "message": "Fondi insufficienti per l'affitto del locale (%.2f € richiesti)." % actual_rent}

	if player_data.popularity < venue.min_popularity:
		return {"allowed": false, "reason": "popularity_insufficient", "message": "Popolarità insufficiente per questo locale (%.1f%% richiesta)." % venue.min_popularity}

	if player_data.reputation < venue.min_reputation:
		return {"allowed": false, "reason": "reputation_insufficient", "message": "Reputazione insufficiente per questo locale prestigioso (%.1f richiesta)." % venue.min_reputation}

	return {"allowed": true, "reason": "ok", "message": "Pronto a salire sul palco!"}

## Esegue il Soundcheck pomeridiano (consuma 15 energia, riduce a zero gli imprevisti tecnici)
func perform_soundcheck() -> Dictionary:
	if not player_data:
		return {"success": false, "reason": "no_player_data"}

	if not player_data.consume_energy(15):
		return {"success": false, "reason": "energy_insufficient"}

	player_data.add_stress(4)
	return {"success": true, "acoustic_bonus": 5.0}

# ==============================================================================
# IMPREVISTI SCENICI (STAGE EVENTS PROCEDURALI & BIVI A 7 TIPI)
# ==============================================================================

## Genera un imprevisto scenico casuale sul palco (Stage Event) scegliendo tra i 7 tipi
func generate_stage_event(is_soundcheck_done: bool = false) -> Dictionary:
	var possible_types: Array[int] = [
		Enums.StageEventType.BROKEN_STRING,
		Enums.StageEventType.ENTHUSIASTIC_FAN,
		Enums.StageEventType.CROWD_CHANT,
		Enums.StageEventType.PIT_FIGHT,
		Enums.StageEventType.STAGE_DIVING
	]
	# Senza soundcheck aumentano i rischi di ritorno acustico e blackout
	if not is_soundcheck_done:
		possible_types.append(Enums.StageEventType.AUDIO_FEEDBACK)
		possible_types.append(Enums.StageEventType.BLACKOUT)

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
		Enums.StageEventType.BLACKOUT:
			return {
				"type": chosen_type,
				"title": tr("EVENT_BLACKOUT_TITLE"),
				"description": tr("EVENT_BLACKOUT_DESC"),
				"choice_1_text": tr("EVENT_BLACKOUT_CHOICE_1"),
				"choice_1_skill": "charisma",
				"choice_2_text": tr("EVENT_BLACKOUT_CHOICE_2"),
				"choice_2_skill": "performance"
			}
		Enums.StageEventType.CROWD_CHANT:
			return {
				"type": chosen_type,
				"title": tr("EVENT_CHANT_TITLE"),
				"description": tr("EVENT_CHANT_DESC"),
				"choice_1_text": tr("EVENT_CHANT_CHOICE_1"),
				"choice_1_skill": "charisma",
				"choice_2_text": tr("EVENT_CHANT_CHOICE_2"),
				"choice_2_skill": "performance"
			}
		Enums.StageEventType.PIT_FIGHT:
			return {
				"type": chosen_type,
				"title": tr("EVENT_FIGHT_TITLE"),
				"description": tr("EVENT_FIGHT_DESC"),
				"choice_1_text": tr("EVENT_FIGHT_CHOICE_1"),
				"choice_1_skill": "charisma",
				"choice_2_text": tr("EVENT_FIGHT_CHOICE_2"),
				"choice_2_skill": "performance"
			}
		Enums.StageEventType.STAGE_DIVING:
			return {
				"type": chosen_type,
				"title": tr("EVENT_DIVING_TITLE"),
				"description": tr("EVENT_DIVING_DESC"),
				"choice_1_text": tr("EVENT_DIVING_CHOICE_1"),
				"choice_1_skill": "charisma",
				"choice_2_text": tr("EVENT_DIVING_CHOICE_2"),
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

	# Test di abilità deterministico con clamping tra 40% e 95%
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

# ==============================================================================
# BANCHETTO MERCHANDISING ED ENCORE / BIS
# ==============================================================================

## Calcola i dati di vendita del banchetto merchandising al foyer
func calculate_merch_sales(venue: VenueData, audience: int, concert_score: float, charisma: float) -> Dictionary:
	if audience <= 0:
		return {
			"items_sold": 0, "gross_revenue": 0.0, "production_costs": 0.0, "net_revenue": 0.0,
			"pins_sold": 0, "tshirts_sold": 0, "posters_sold": 0, "picks_sold": 0
		}

	# Percentuale di acquirenti proporzionale a punteggio e carisma (8% - 45%)
	var buyer_ratio: float = clampf((concert_score / 100.0) * (0.20 + (charisma / 250.0)), 0.08, 0.45)
	if venue and venue.venue_type == VenueData.TYPE_SOCIAL_CENTER:
		buyer_ratio = clampf(buyer_ratio * 1.30, 0.10, 0.55)

	var buyers: int = maxi(1, int(round(float(audience) * buyer_ratio)))

	var pins: int = int(round(float(buyers) * 0.60))
	var tshirts: int = int(round(float(buyers) * 0.35))
	var posters: int = int(round(float(buyers) * 0.25))
	var picks: int = int(round(float(buyers) * 0.40))

	var gross: float = (pins * Constants.MERCH_PIN_PRICE) + (tshirts * Constants.MERCH_TSHIRT_PRICE) + (posters * Constants.MERCH_POSTER_PRICE) + (picks * Constants.MERCH_PICKS_PRICE)
	var costs: float = (pins * Constants.MERCH_PIN_COST) + (tshirts * Constants.MERCH_TSHIRT_COST) + (posters * Constants.MERCH_POSTER_COST) + (picks * Constants.MERCH_PICKS_COST)
	var net: float = gross - costs
	var total_items: int = pins + tshirts + posters + picks

	return {
		"items_sold": total_items,
		"gross_revenue": gross,
		"production_costs": costs,
		"net_revenue": net,
		"pins_sold": pins,
		"tshirts_sold": tshirts,
		"posters_sold": posters,
		"picks_sold": picks
	}

## Risolve la concessione o il rifiuto del Bis / Encore
func resolve_encore(granted: bool, current_score: float) -> Dictionary:
	if not granted:
		return {"granted": false, "message": "Hai salutato il pubblico tra gli applausi scroscianti."}

	if not player_data:
		return {"granted": false, "message": "Dati giocatore assenti."}

	if player_data.energy < Constants.ENCORE_ENERGY_COST:
		return {
			"granted": false,
			"energy_insufficient": true,
			"message": "Troppo stanco per concedere il bis! Hai dovuto salutare il pubblico."
		}

	player_data.consume_energy(Constants.ENCORE_ENERGY_COST)
	player_data.modify_money(Constants.ENCORE_EXTRA_CASH)
	player_data.increment_career_stat("total_encores_granted", 1)
	EventBus.money_changed.emit(player_data.money, Constants.ENCORE_EXTRA_CASH, "encore_cash")

	if player_data:
		player_data.modify_morale(Constants.ENCORE_BAND_MORALE_BONUS)
		var active_members := player_data.get_active_band_members()
		if not active_members.is_empty():
			for m in active_members:
				m.modify_affinity(3.0)
				m.modify_tension(-5.0)
			if GameManager and GameManager.band_system:
				GameManager.band_system._emit_chemistry_changed()

	return {
		"granted": true,
		"energy_spent": Constants.ENCORE_ENERGY_COST,
		"cash_gained": Constants.ENCORE_EXTRA_CASH,
		"fan_bonus_mult": Constants.ENCORE_FAN_BONUS_MULT,
		"band_morale_bonus": Constants.ENCORE_BAND_MORALE_BONUS,
		"message": "BIS TRIONFALE! Il pubblico è impazzito: mance extra (+50 €), fan fidelizzati e morale alle stelle!"
	}

# ==============================================================================
# RISOLUZIONE COMPLETA DEL CONCERTO
# ==============================================================================

## Risolve completamente il concerto live, calcolando spettatori, drammaturgia, score, incasso e fan
func resolve_concert(venue: VenueData, setlist: Array[SongData], ticket_price: float, is_soundcheck: bool = false, event_score_delta: float = 0.0, force_stage_accident: Variant = null) -> Dictionary:
	var check := can_play_concert(venue, setlist)
	if not check.get("allowed", false):
		return {"success": false, "reason": check.get("reason", "error"), "message": check.get("message", "")}

	var cur_day: int = calendar_data.day_number if calendar_data else 1
	var actual_rent: float = get_venue_rent_cost(venue, cur_day)

	# 1. Costi di affitto ed energia
	player_data.modify_money(-actual_rent)
	EventBus.money_changed.emit(player_data.money, -actual_rent, "venue_rent")

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

	# Mega Allestimento Scenico Palco (Arene e Stadi - Sezione 11)
	var stage_prod_cost: float = 0.0
	var stage_fan_mult: float = 1.0
	var stage_pyro_bonus: float = 0.0
	if venue.venue_type in [VenueData.TYPE_ARENA, VenueData.TYPE_STADIUM]:
		match active_stage_production:
			Enums.StageProductionTier.RUNWAY_CATWALK:
				stage_prod_cost = Constants.STAGE_RUNWAY_COST
				stage_fan_mult = Constants.STAGE_RUNWAY_BONUS_FAN
			Enums.StageProductionTier.CENTER_360_STAGE:
				stage_prod_cost = Constants.STAGE_360_COST
				var bonus_cap: int = int(round(float(venue.capacity) * (Constants.STAGE_360_CAPACITY_BONUS - 1.0)))
				audience = mini(venue.capacity + bonus_cap, int(round(float(audience) * Constants.STAGE_360_CAPACITY_BONUS)))
			Enums.StageProductionTier.MEGA_PYRO_LASER:
				stage_prod_cost = Constants.STAGE_PYRO_COST
				stage_pyro_bonus = Constants.STAGE_PYRO_SCORE_BONUS

		if stage_prod_cost > 0.0:
			player_data.modify_money(-stage_prod_cost)
			EventBus.money_changed.emit(player_data.money, -stage_prod_cost, "stage_production_service")

	# Moltiplicatore Social Buzz (Hype generato da post e viralità)
	var social_buzz_mult: float = 1.0
	if GameManager and GameManager.social_media_system:
		social_buzz_mult = GameManager.social_media_system.get_live_buzz_multiplier()
	if social_buzz_mult > 1.0:
		audience = mini(venue.capacity, int(round(float(audience) * social_buzz_mult)))

	# Bonus Fan Club Ufficiale (Fedeltà e zoccolo duro garantito di spettatori - Sezione 8)
	if player_data and player_data.fan_club and player_data.fan_club.is_founded:
		var fan_club_boost: float = player_data.fan_club.get_concert_attendance_boost()
		if fan_club_boost > 0.0:
			var extra_attendance: int = int(round(float(audience) * fan_club_boost))
			audience = mini(venue.capacity, audience + extra_attendance)

	# Moltiplicatore Evento Cittadino (Notte Bianca, Fiera Musica, Festival Urbano - Sezione 6)
	var city_event_audience_mult: float = 1.0
	var city_event_fan_mult: float = 1.0
	var city_event_rep_bonus: float = 0.0
	var city_event_name: String = ""
	if GameManager and GameManager.travel_system:
		var cur_day_ev: int = calendar_data.day_number if calendar_data else 1
		var c_ev: Dictionary = GameManager.travel_system.get_active_city_event(GameManager.travel_system.current_city_id, cur_day_ev)
		if c_ev and c_ev.get("type", Enums.CityEventType.NONE) != Enums.CityEventType.NONE:
			city_event_audience_mult = float(c_ev.get("audience_mult", 1.0))
			city_event_fan_mult = float(c_ev.get("fan_mult", 1.0))
			city_event_rep_bonus = float(c_ev.get("rep_bonus", 0.0))
			city_event_name = str(c_ev.get("name", ""))
	if city_event_audience_mult > 1.0:
		audience = mini(venue.capacity, int(round(float(audience) * city_event_audience_mult)))

	# 3. Drammaturgia della Scaletta e Valutazione Qualità Media
	var total_qual: float = 0.0
	for s in setlist:
		var mastery_factor: float = clampf(s.mastery_live / 100.0, 0.20, 1.00)
		var weighted_qual: float = s.quality_score * (0.50 + 0.50 * mastery_factor)
		if not s.dominant_instrument.is_empty():
			var inst_key := "skill_%s" % s.dominant_instrument
			var has_virtuoso: bool = false
			if player_data and player_data.get_skill_grade(inst_key) >= 3:
				has_virtuoso = true
			elif player_data:
				for m in player_data.get_active_band_members():
					if m and not m.instrument.is_empty() and m.instrument.to_lower().contains(s.dominant_instrument.to_lower()):
						has_virtuoso = true
						break
			if has_virtuoso:
				weighted_qual *= 1.15
		total_qual += weighted_qual
	var avg_quality: float = total_qual / float(maxi(1, setlist.size()))

	# Bonus Opener (Posizione 1)
	var opening_hype_bonus: float = 0.0
	var opening_score_mult: float = 1.0
	if not setlist.is_empty():
		var opener: SongData = setlist[0]
		if opener.genre in [Enums.MusicalGenre.ROCK, Enums.MusicalGenre.METAL, Enums.MusicalGenre.ELECTRONIC] or opener.special_trait == Enums.SongTrait.EPIC_RIFF or opener.quality_score >= 65.0:
			opening_hype_bonus = Constants.OPENING_HYPE_BONUS
			opening_score_mult = Constants.OPENING_SCORE_MULT

	# Bonus Mid-Set Ballad (Posizioni centrali)
	var ballad_fan_mult: float = 1.0
	if setlist.size() > 1:
		for idx in range(1, setlist.size() - (1 if setlist.size() > 2 else 0)):
			var mid_song: SongData = setlist[idx]
			if mid_song.special_trait == Enums.SongTrait.TEARJERKER_BALLAD:
				player_data.stress = maxi(0, player_data.stress - Constants.BALLAD_STRESS_RELIEF)
				ballad_fan_mult = Constants.BALLAD_FAN_MULT
				break

	# Bonus Closer / Stage Beast sull'ultimo pezzo della scaletta
	var closer_bonus_mult: float = 1.0
	var anthem_rep_boost: float = 0.0
	var anthem_fan_mult: float = 1.0
	var last_song: SongData = setlist[setlist.size() - 1]
	if last_song.special_trait == Enums.SongTrait.STAGE_BEAST:
		closer_bonus_mult = 1.15
	elif last_song.special_trait == Enums.SongTrait.GENERATIONAL_ANTHEM:
		anthem_rep_boost = Constants.TRAIT_ANTHEM_REP_BOOST
		anthem_fan_mult = 1.25

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

	var raw_score: float = ((base_score * closer_bonus_mult) * opening_score_mult) + event_score_delta + soundcheck_bonus + band_synergy + sound_shaping_bonus + stage_pyro_bonus - accident_penalty
	var final_score: float = clampf(raw_score * city_affinity_mult, 1.0, 100.0)

	# Bonus specifici per tipologia di locale
	var venue_rep_mult: float = 1.0
	var venue_fan_mult: float = 1.0
	if venue.venue_type == VenueData.TYPE_SOCIAL_CENTER:
		venue_rep_mult = 1.50
		if last_song.genre in [Enums.MusicalGenre.ROCK, Enums.MusicalGenre.METAL, Enums.MusicalGenre.INDIE, Enums.MusicalGenre.HIPHOP]:
			venue_fan_mult = 1.25
	elif venue.venue_type == VenueData.TYPE_OPERA_THEATRE:
		venue_rep_mult = 1.30
	elif venue.venue_type == VenueData.TYPE_ARENA:
		venue_rep_mult = 1.60
	elif venue.venue_type == VenueData.TYPE_STADIUM:
		venue_rep_mult = 2.00

	# 5. Conversione Fan
	var new_fans: int = Formulas.calculate_fan_conversion(audience, final_score, charisma_level)
	if last_song.special_trait == Enums.SongTrait.CULT_CLASSIC:
		new_fans = int(round(float(new_fans) * 2.0))
	if calendar_data and calendar_data.get_weekday() == Enums.Weekday.SATURDAY:
		new_fans = int(round(float(new_fans) * Constants.WEEKEND_SATURDAY_FAN_MULT))
	if city_affinity_mult != 1.0:
		new_fans = int(round(float(new_fans) * city_affinity_mult))
	if city_event_fan_mult > 1.0:
		new_fans = int(round(float(new_fans) * city_event_fan_mult))
	if stage_fan_mult > 1.0:
		new_fans = int(round(float(new_fans) * stage_fan_mult))
	if ballad_fan_mult > 1.0 or anthem_fan_mult > 1.0 or venue_fan_mult > 1.0:
		new_fans = int(round(float(new_fans) * ballad_fan_mult * anthem_fan_mult * venue_fan_mult))

	# Marcatura evento a calendario se programmato
	if GameManager and GameManager.schedule_system and calendar_data:
		var todays_events := GameManager.schedule_system.get_events_for_day(calendar_data.day_number)
		for ev in todays_events:
			if ev.event_type == Enums.CalendarEventType.CONCERT and (ev.location_id == venue.id or ev.location_id.is_empty()):
				GameManager.schedule_system.mark_event_completed(ev.id)

	# 6. Banchetto Merchandising & Economia Serata
	var merch_data: Dictionary = calculate_merch_sales(venue, audience, final_score, charisma_level)
	var merch_net: float = float(merch_data.get("net_revenue", 0.0))

	var gross_revenue: float = float(audience) * ticket_price
	var manager_cut: float = 0.0
	var pool_revenue: float = gross_revenue
	if GameManager and GameManager.industry_system and player_data.has_manager():
		var rev_calc: Dictionary = GameManager.industry_system.calculate_live_concert_revenue(gross_revenue)
		gross_revenue = rev_calc.gross_cachet
		manager_cut = rev_calc.manager_cut
		pool_revenue = rev_calc.net_band_revenue

	var net_revenue: float = (gross_revenue - actual_rent) + merch_net
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

	var total_payout: float = player_share + merch_net
	if total_payout > 0.0:
		player_data.modify_money(total_payout)
		EventBus.money_changed.emit(player_data.money, total_payout, "concert_and_merch")

	# 7. Crescita notorietà & statistiche con territorialità
	var pop_gain: float = (final_score / 100.0) * (float(audience) / float(venue.capacity)) * 3.0
	if GameManager and GameManager.travel_system:
		var cur_cid: int = GameManager.travel_system.current_city_id
		GameManager.travel_system.add_fans_in_city(cur_cid, new_fans)
		GameManager.travel_system.modify_popularity_in_city(cur_cid, pop_gain)
	else:
		player_data.fans += new_fans
		player_data.popularity = clampf(player_data.popularity + pop_gain, 0.0, 100.0)

	player_data.reputation = maxf(1.0, player_data.reputation + ((final_score * 0.03) * venue_rep_mult) + anthem_rep_boost + city_event_rep_bonus)

	# Aggiorna metriche per le canzoni eseguite (le cover non registrano plays originali né revenue)
	for s in setlist:
		if not s.is_cover:
			s.plays += audience
			s.revenue += (gross_revenue / float(maxi(1, setlist.size())))
		s.mastery_live = clampf(s.mastery_live + 15.0, 20.0, 100.0)
		s.last_played_day = cur_day

	# 8. Assegnazione XP abilità dal vivo
	if skill_system:
		skill_system.add_xp("performance", 25.0)
		skill_system.add_xp("charisma", 20.0)

	# 9. Dinamiche post-concerto della Band
	if GameManager and GameManager.band_system:
		GameManager.band_system.process_post_concert_dynamics(final_score)

	# 10. Tracciamento Statistiche di Carriera (Sezione 12)
	var is_sold_out: bool = (audience >= venue.capacity)
	if player_data:
		player_data.increment_career_stat("total_concerts_performed", 1)
		player_data.increment_career_stat("total_audience_attended", audience)
		player_data.increment_career_stat("total_live_earnings", player_share)
		player_data.increment_career_stat("total_merch_earnings", merch_net)
		if venue.venue_type in [VenueData.TYPE_ARENA, VenueData.TYPE_STADIUM]:
			player_data.increment_career_stat("total_stadium_concerts", 1)
			if is_sold_out:
				player_data.increment_career_stat("stadium_sold_outs", 1)

	var eligible_for_encore: bool = final_score >= Constants.ENCORE_SCORE_THRESHOLD

	var result := {
		"success": true,
		"venue_id": venue.id,
		"venue_name": venue.get_localized_name(),
		"audience": audience,
		"capacity": venue.capacity,
		"is_sold_out": is_sold_out,
		"ticket_price": ticket_price,
		"gross_revenue": gross_revenue,
		"rent_cost": actual_rent,
		"net_revenue": net_revenue,
		"player_share": player_share,
		"band_share": band_share,
		"merch_data": merch_data,
		"opening_hype_bonus": opening_hype_bonus,
		"opening_score_mult": opening_score_mult,
		"ballad_fan_mult": ballad_fan_mult,
		"eligible_for_encore": eligible_for_encore,
		"band_synergy_bonus": band_synergy,
		"sound_shaping_bonus": sound_shaping_bonus,
		"stage_accident": stage_accident,
		"accident_saved": accident_saved_by_backup,
		"accident_penalty": accident_penalty,
		"concert_score": final_score,
		"city_affinity_mult": city_affinity_mult,
		"tour_hype_mult": tour_hype_mult,
		"city_event_name": city_event_name,
		"city_event_audience_mult": city_event_audience_mult,
		"new_fans": new_fans,
		"popularity_gained": pop_gain,
		"is_soundcheck": is_soundcheck,
		"stage_production": active_stage_production,
		"stage_prod_cost": stage_prod_cost
	}


	if GameManager and GameManager.tour_system and GameManager.tour_system.active_tour:
		GameManager.tour_system.record_stop_result(result)

	EventBus.concert_resolved.emit(result)
	return result

# ==============================================================================
# SERIALIZZAZIONE E PERSISTENZA
# ==============================================================================

func to_dict() -> Dictionary:
	return {
		"venue_status_overrides": venue_status_overrides.duplicate(true),
		"active_stage_production": active_stage_production
	}

func from_dict(dict: Dictionary) -> void:
	if dict.has("venue_status_overrides") and dict["venue_status_overrides"] is Dictionary:
		venue_status_overrides = dict["venue_status_overrides"].duplicate(true)
	active_stage_production = int(dict.get("active_stage_production", active_stage_production))

