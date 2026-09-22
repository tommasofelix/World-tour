# res://systems/schedule_system.gd
class_name ScheduleSystem
extends RefCounted

## Motore Centrale dell'Agenda e della Programmazione Temporale (World-tour SP-09)
## Gestisce la pianificazione di concerti futuri, prove di gruppo, scadenze discografiche,
## date festival, tappe di tour e scadenze dell'affitto a calendario lunare (28 giorni).

var player_data: PlayerData
var calendar_data: CalendarData
var events: Array[CalendarEventData] = []

func _init(p_player_data: PlayerData = null, p_calendar_data: CalendarData = null) -> void:
	player_data = p_player_data
	calendar_data = p_calendar_data

## Aggiunge un nuovo impegno all'agenda
func add_event(event: CalendarEventData) -> bool:
	if not event:
		return false
		
	# Inserimento ordinato cronologicamente per day_number e poi per period
	var insert_idx: int = 0
	while insert_idx < events.size():
		var existing: CalendarEventData = events[insert_idx]
		if existing.day_number > event.day_number:
			break
		elif existing.day_number == event.day_number and existing.period > event.period:
			break
		insert_idx += 1
		
	events.insert(insert_idx, event)
	EventBus.schedule_event_added.emit(event)
	EventBus.schedule_events_updated.emit()
	return true

## Rimuove un impegno dato il suo identificatore univoco
func remove_event(event_id: String) -> bool:
	for i in range(events.size()):
		if events[i].id == event_id:
			events.remove_at(i)
			EventBus.schedule_event_removed.emit(event_id)
			EventBus.schedule_events_updated.emit()
			return true
	return false

## Recupera un evento dato il suo id
func get_event_by_id(event_id: String) -> CalendarEventData:
	for ev in events:
		if ev.id == event_id:
			return ev
	return null

## Restituisce tutti gli impegni fissati per un determinato giorno
func get_events_for_day(target_day: int) -> Array[CalendarEventData]:
	var result: Array[CalendarEventData] = []
	for ev in events:
		if ev.day_number == target_day:
			result.append(ev)
	return result

## Restituisce gli eventi fissati per un giorno e una fascia oraria specifica
func get_events_for_period(target_day: int, target_period: int) -> Array[CalendarEventData]:
	var result: Array[CalendarEventData] = []
	for ev in events:
		if ev.day_number == target_day and ev.period == target_period:
			result.append(ev)
	return result

## Verifica se esiste già un impegno per un dato giorno e fascia oraria
func has_event_at(target_day: int, target_period: int) -> bool:
	for ev in events:
		if ev.day_number == target_day and ev.period == target_period and not ev.is_completed:
			return true
	return false

## Restituisce gli eventi in arrivo per i prossimi X giorni a partire dal giorno attuale
func get_upcoming_events(days_ahead: int = 7) -> Array[CalendarEventData]:
	var cur_day: int = calendar_data.day_number if calendar_data else 1
	var max_day: int = cur_day + days_ahead
	var result: Array[CalendarEventData] = []
	for ev in events:
		if ev.day_number >= cur_day and ev.day_number <= max_day and not ev.is_completed:
			result.append(ev)
	return result

## Restituisce tutti gli impegni appartenenti a una specifica settimana globale di carriera
func get_events_for_week(target_week: int) -> Array[CalendarEventData]:
	var start_day: int = ((target_week - 1) * Constants.DAYS_PER_WEEK) + 1
	var end_day: int = target_week * Constants.DAYS_PER_WEEK
	var result: Array[CalendarEventData] = []
	for ev in events:
		if ev.day_number >= start_day and ev.day_number <= end_day:
			result.append(ev)
	return result

## Marca un evento come completato con successo
func mark_event_completed(event_id: String) -> bool:
	var ev: CalendarEventData = get_event_by_id(event_id)
	if ev:
		ev.is_completed = true
		EventBus.schedule_event_triggered.emit(ev)
		EventBus.schedule_events_updated.emit()
		return true
	return false

## Prenota un concerto con X giorni di anticipo
func book_concert_date(venue_id: String, venue_name: String, days_in_advance: int, period: int = Enums.TimePeriod.EVENING) -> CalendarEventData:
	var cur_day: int = calendar_data.day_number if calendar_data else 1
	var target_day: int = cur_day + maxi(1, days_in_advance)
	
	var ev := CalendarEventData.new(
		"concert_%s_%d" % [venue_id, target_day],
		"Concerto Live al %s" % venue_name,
		Enums.CalendarEventType.CONCERT,
		target_day,
		period,
		venue_id,
		venue_name,
		true # È un concerto concordato con il locale: saltarlo è penalizzante
	)
	add_event(ev)
	return ev

## Registra una scadenza di consegna album concordata con la label
func schedule_album_deadline(album_title: String, days_limit: int, label_name: String) -> CalendarEventData:
	var cur_day: int = calendar_data.day_number if calendar_data else 1
	var target_day: int = cur_day + days_limit
	
	var ev := CalendarEventData.new(
		"deadline_%s_%d" % [album_title.to_snake_case(), target_day],
		"Scadenza Consegna Master: %s (%s)" % [album_title, label_name],
		Enums.CalendarEventType.CONTRACT_DEADLINE,
		target_day,
		Enums.TimePeriod.EVENING,
		"",
		label_name,
		true
	)
	add_event(ev)
	return ev

## Registra la scadenza dell'affitto mensile (Giorno 28 di ogni mese)
func ensure_monthly_rent_scheduled() -> void:
	var cur_day: int = calendar_data.day_number if calendar_data else 1
	var cur_month: int = calendar_data.get_month() if calendar_data else 1
	var cur_year: int = calendar_data.get_year() if calendar_data else 1
	var rent_day: int = (cur_month * Constants.DAYS_PER_MONTH) + ((cur_year - 1) * Constants.DAYS_PER_YEAR)
	
	var ev_id: String = "rent_month_%d_year_%d" % [cur_month, cur_year]
	if get_event_by_id(ev_id) == null:
		var ev := CalendarEventData.new(
			ev_id,
			"Scadenza Canone Alloggio (Mese %d)" % cur_month,
			Enums.CalendarEventType.RENT_DUE,
			rent_day,
			Enums.TimePeriod.NIGHT,
			"",
			"Proprietario Alloggio",
			true
		)
		add_event(ev)

## Elabora il controllo giornaliero degli impegni all'avanzamento del giorno
func process_daily_schedule_check(current_day: int) -> Dictionary:
	var past_day: int = current_day - 1
	var missed_events: Array[CalendarEventData] = []
	var todays_events: Array[CalendarEventData] = get_events_for_day(current_day)
	
	# Controlla se impegni critici del giorno appena concluso sono stati mancati
	for ev in events:
		if ev.day_number == past_day and not ev.is_completed and ev.is_critical:
			missed_events.append(ev)
			EventBus.schedule_event_missed.emit(ev, "Impegno non rispettato nella data concordata.")
			
			# Penalità reputazione e morale se si salta un concerto o scadenza
			if player_data:
				player_data.reputation = maxf(1.0, player_data.reputation - 5.0)
				player_data.modify_morale(-15)
				player_data.add_stress(10)
	
	# Assicura sempre che l'affitto mensile sia in agenda
	ensure_monthly_rent_scheduled()
	
	return {
		"current_day": current_day,
		"missed_count": missed_events.size(),
		"missed_events": missed_events,
		"todays_events_count": todays_events.size(),
		"todays_events": todays_events
	}

## Genera una lettura vocale lineare sequenziale ottimizzata per NVDA
func get_linear_agenda_speech(days_ahead: int = 7) -> String:
	var cur_day: int = calendar_data.day_number if calendar_data else 1
	var upcoming: Array[CalendarEventData] = get_upcoming_events(days_ahead)
	
	if upcoming.is_empty():
		return "Agenda Band: Nessun impegno confermato per i prossimi %d giorni. Il calendario è libero per studio, prove e registrazioni." % days_ahead
		
	var lines: Array[String] = []
	lines.append("Agenda Band: %d impegni programmati per i prossimi %d giorni." % [upcoming.size(), days_ahead])
	
	for ev in upcoming:
		var delta_days: int = ev.day_number - cur_day
		var day_label: String = ""
		if delta_days == 0:
			day_label = "Oggi"
		elif delta_days == 1:
			day_label = "Domani"
		else:
			day_label = "Tra %d giorni (Giorno %d)" % [delta_days, ev.day_number]
			
		lines.append("%s - Fascia %s: %s." % [
			day_label,
			ev.get_period_name(),
			ev.title
		])
		
	return " ".join(lines)

## Serializzazione per la persistenza
func to_dict() -> Array:
	var arr: Array = []
	for ev in events:
		arr.append(ev.to_dict())
	return arr

## Deserializzazione dal salvataggio
func from_dict(arr: Array) -> void:
	events.clear()
	for item in arr:
		if item is Dictionary:
			var ev := CalendarEventData.new()
			ev.from_dict(item as Dictionary)
			events.append(ev)
