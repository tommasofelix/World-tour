# res://systems/end_day_system.gd
class_name EndDaySystem
extends RefCounted

## Sistema di Risoluzione della Fine Giornata, Spese di Sussistenza, Alloggi e Royalties
## Calcola canone di locazione in base all'alloggio, incassa le royalties passive dagli album,
## applica il recupero del sonno e gestisce le dinamiche relazionali notturne della band.

signal summary_ready(summary_data: Dictionary)

var player_data: PlayerData
var calendar_data: CalendarData

func _init(p_player: PlayerData = null, p_calendar: CalendarData = null) -> void:
	player_data = p_player
	calendar_data = p_calendar
	EventBus.day_ended.connect(_on_day_ended)

func _on_day_ended(day_num: int) -> void:
	GameManager.change_state(Enums.GameState.DAILY_SUMMARY)
	
	var food_exp: float = Constants.DAILY_FOOD_EXPENSE
	var tier: int = player_data.current_housing_tier if player_data else Enums.HousingTier.STARTER_BEDROOM
	var base_rent: float = HousingData.get_tier_rent(tier)
	var actual_rent: float = base_rent
	
	# In appartamento condiviso, le spese della casa si dividono con i membri della band presenti
	if player_data and tier == Enums.HousingTier.SHARED_FLAT:
		var roommates: int = 1 + player_data.band_members.size()
		actual_rent = snappedf(base_rent / float(roommates), 0.01)
		
	var total_expenses: float = food_exp + actual_rent
	
	if player_data:
		player_data.modify_money(-total_expenses)
		EventBus.money_changed.emit(player_data.money, -total_expenses, "Spese vive (vitto e alloggio)")
		if GameManager and GameManager.economy_system:
			GameManager.economy_system.log_transaction(-total_expenses, "rent", "Spese vive (%s)" % HousingData.get_tier_name(tier), day_num)
		
		# Dinamiche notturne alloggio & band
		var housing := HousingData.new(tier)
		if housing.tension_daily_modifier != 0.0 and not player_data.band_members.is_empty():
			for m in player_data.band_members:
				m.adjust_tension(housing.tension_daily_modifier)
				
		# Sonno ristoratore con eventuali bonus comfort alloggio
		var energy_gain: int = Constants.SLEEP_STANDARD_ENERGY + int(housing.morale_daily_bonus * 0.5)
		var stress_relief: int = Constants.SLEEP_STANDARD_STRESS_RELIEF + int(housing.morale_daily_bonus)
		player_data.add_energy(energy_gain)
		player_data.reduce_stress(stress_relief)
		
	# Incasso automatico royalties passive dagli album a catalogo
	var royalties_earned: float = 0.0
	var album_count: int = 0
	if GameManager and GameManager.album_system:
		var roy_res: Dictionary = GameManager.album_system.process_daily_royalties()
		royalties_earned = roy_res.get("total_royalties", 0.0)
		album_count = roy_res.get("album_count", 0)
		
	# Rilevamento tensioni critiche nei compagni di band
	var band_crises: Array[String] = []
	if player_data and not player_data.band_members.is_empty():
		for m in player_data.band_members:
			if m.tension >= Constants.BAND_TENSION_CRITICAL:
				band_crises.append(m.name)
				
	# Sgravio stress organizzativo dal Manager
	if GameManager and GameManager.industry_system:
		GameManager.industry_system.apply_daily_manager_stress_relief()
		
	# Decadimento notturno hype social e reset limite post giornalieri
	if GameManager and GameManager.social_media_system:
		GameManager.social_media_system.process_daily_decay()
		
	# Aggiornamento settimanale ufficiale Hit Parade (ogni Domenica notte)
	if calendar_data and calendar_data.get_weekday() == Enums.Weekday.SUNDAY:
		if GameManager and GameManager.chart_system:
			GameManager.chart_system.update_weekly_charts(day_num)
		
	# Valutazione dilemmi etici serali
	var pending_dilemma: DilemmaData = null
	if GameManager and GameManager.dilemma_system:
		pending_dilemma = GameManager.dilemma_system.evaluate_daily_dilemma()
		
	var summary: Dictionary = {
		"completed_day": day_num,
		"expenses": total_expenses,
		"rent": actual_rent,
		"food": food_exp,
		"royalties": royalties_earned,
		"album_count": album_count,
		"new_balance": player_data.money if player_data else 0.0,
		"current_energy": player_data.energy if player_data else 100,
		"current_stress": player_data.stress if player_data else 0,
		"housing_name": HousingData.get_tier_name(tier),
		"band_crises": band_crises,
		"pending_dilemma": pending_dilemma.to_dict() if pending_dilemma else {}
	}
	
	summary_ready.emit(summary)
	
	var speech: String = "Fine della giornata %d. Alloggio: %s. Spese vive: %.2f euro (cibo %.2f, affitto %.2f)." % [
		day_num,
		HousingData.get_tier_name(tier),
		total_expenses,
		food_exp,
		actual_rent
	]
	if royalties_earned > 0.0:
		speech += " Royalties catalogo: +%.2f euro da %d album." % [royalties_earned, album_count]
	speech += " Nuovo saldo: %.2f euro. Sonno ristoratore completato." % [
		player_data.money if player_data else 0.0
	]
	if not band_crises.is_empty():
		speech += " ATTENZIONE: Tensione critica per %s!" % ", ".join(band_crises)
		
	AccessibilityManager.announce(speech, true)

func advance_to_next_day() -> void:
	if calendar_data:
		calendar_data.day_number += 1
		calendar_data.reset_daily_saturation()
		
	var new_day: int = calendar_data.day_number if calendar_data else 1
	
	# Controllo impegni a calendario e avanzamento dell'agenda
	var schedule_report: Dictionary = {}
	if GameManager and GameManager.schedule_system:
		schedule_report = GameManager.schedule_system.process_daily_schedule_check(new_day)
		
	GameManager.change_state(Enums.GameState.GAMEPLAY_IDLE)
	
	EventBus.day_started.emit(new_day)
	
	var date_str: String = calendar_data.get_full_date_string() if calendar_data else ("Giorno %d" % new_day)
	var speech: String = "Inizia il Giorno %d: %s. Buongiorno!" % [new_day, date_str]
	if schedule_report.get("todays_events_count", 0) > 0:
		speech += " Hai %d impegni in agenda per oggi." % schedule_report["todays_events_count"]
	if schedule_report.get("missed_count", 0) > 0:
		speech += " ATTENZIONE: Hai mancato %d impegni critici ieri!" % schedule_report["missed_count"]
		
	AccessibilityManager.announce(speech, true)

