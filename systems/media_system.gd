# res://systems/media_system.gd
class_name MediaSystem
extends RefCounted

## Sottosistema Gestione Media Broadcaster, Interviste Promozionali & Rassegna Stampa (Sezione 10)
## Governa emittenti radio locali, TV musicali, podcast, rassegna stampa e interviste di riparazione.

const MediaOutletDataScript = preload("res://data/models/media_outlet_data.gd")

var player_data: PlayerData
var calendar_data: CalendarData

## Catalogo delle emittenti registrate (id -> MediaOutletData)
var outlets: Dictionary = {}

## Storico delle interviste effettuate (array di Dictionary)
var interview_history: Array[Dictionary] = []

## Rassegna stampa e recensioni raccolte (array di Dictionary con autore, testata, voto, commento)
var press_reviews: Array[Dictionary] = []

## Giorno dell'ultima intervista svolta (per limitare a 1 intervista al giorno)
var last_interview_day: int = -1

func _init(p_player: PlayerData = null, p_calendar: CalendarData = null) -> void:
	player_data = p_player
	calendar_data = p_calendar
	_init_default_outlets()

func _init_default_outlets() -> void:
	outlets.clear()
	
	# 1. MILANO
	var o_mi_radio := MediaOutletDataScript.new(
		"radio_pop_milano",
		"Radio Popolare Milano",
		Enums.BroadcastMediaType.LOCAL_RADIO,
		Enums.CityId.MILANO,
		15000,
		Enums.CareerTier.LOCAL_ARTIST,
		10.0,
		Enums.MusicalGenre.ROCK,
		Constants.MEDIA_INTERVIEW_RADIO_ENERGY,
		Constants.MEDIA_INTERVIEW_RADIO_HYPE,
		1.5
	)
	outlets[o_mi_radio.id] = o_mi_radio
	
	var o_mi_tv := MediaOutletDataScript.new(
		"rock_tv_milano",
		"Rock TV Italia",
		Enums.BroadcastMediaType.MUSIC_TELEVISION,
		Enums.CityId.MILANO,
		60000,
		Enums.CareerTier.UNDERGROUND_HERO,
		25.0,
		Enums.MusicalGenre.ROCK,
		Constants.MEDIA_INTERVIEW_TV_ENERGY,
		Constants.MEDIA_INTERVIEW_TV_HYPE,
		3.0
	)
	outlets[o_mi_tv.id] = o_mi_tv
	
	# 2. BOLOGNA
	var o_bo_radio := MediaOutletDataScript.new(
		"radio_citta_fujiko",
		"Radio Città del Capo / Fujiko",
		Enums.BroadcastMediaType.LOCAL_RADIO,
		Enums.CityId.BOLOGNA,
		12000,
		Enums.CareerTier.LOCAL_ARTIST,
		8.0,
		Enums.MusicalGenre.INDIE,
		Constants.MEDIA_INTERVIEW_RADIO_ENERGY,
		Constants.MEDIA_INTERVIEW_RADIO_HYPE,
		1.5
	)
	outlets[o_bo_radio.id] = o_bo_radio
	
	var o_bo_podcast := MediaOutletDataScript.new(
		"pratello_sound_podcast",
		"Pratello Underground Podcast",
		Enums.BroadcastMediaType.CULTURE_PODCAST,
		Enums.CityId.BOLOGNA,
		20000,
		Enums.CareerTier.LOCAL_ARTIST,
		12.0,
		Enums.MusicalGenre.INDIE,
		Constants.MEDIA_INTERVIEW_PODCAST_ENERGY,
		8.0,
		Constants.MEDIA_INTERVIEW_PODCAST_REP
	)
	outlets[o_bo_podcast.id] = o_bo_podcast
	
	# 3. ROMA
	var o_ro_radio := MediaOutletDataScript.new(
		"radio_rock_roma",
		"Radio Rock Roma 106.6",
		Enums.BroadcastMediaType.LOCAL_RADIO,
		Enums.CityId.ROMA,
		25000,
		Enums.CareerTier.LOCAL_ARTIST,
		15.0,
		Enums.MusicalGenre.ROCK,
		Constants.MEDIA_INTERVIEW_RADIO_ENERGY,
		Constants.MEDIA_INTERVIEW_RADIO_HYPE,
		2.0
	)
	outlets[o_ro_radio.id] = o_ro_radio
	
	# 4. NAPOLI
	var o_na_radio := MediaOutletDataScript.new(
		"radio_kiss_napoli",
		"Radio Kiss Kiss Napoli Underground",
		Enums.BroadcastMediaType.LOCAL_RADIO,
		Enums.CityId.NAPOLI,
		22000,
		Enums.CareerTier.LOCAL_ARTIST,
		12.0,
		Enums.MusicalGenre.HIPHOP,
		Constants.MEDIA_INTERVIEW_RADIO_ENERGY,
		Constants.MEDIA_INTERVIEW_RADIO_HYPE,
		2.0
	)
	outlets[o_na_radio.id] = o_na_radio
	
	# 5. LONDRA
	var o_lo_radio := MediaOutletDataScript.new(
		"bbc_radio1_london",
		"BBC Radio 1 Introducing",
		Enums.BroadcastMediaType.LOCAL_RADIO,
		Enums.CityId.LONDRA,
		85000,
		Enums.CareerTier.INDIE_SENSATION,
		35.0,
		Enums.MusicalGenre.ROCK,
		Constants.MEDIA_INTERVIEW_RADIO_ENERGY,
		20.0,
		3.5
	)
	outlets[o_lo_radio.id] = o_lo_radio
	
	# 6. BERLINO
	var o_be_radio := MediaOutletDataScript.new(
		"fluxfm_berlin",
		"FluxFM Berlin Alternative",
		Enums.BroadcastMediaType.LOCAL_RADIO,
		Enums.CityId.BERLINO,
		45000,
		Enums.CareerTier.LOCAL_ARTIST,
		20.0,
		Enums.MusicalGenre.ELECTRONIC,
		Constants.MEDIA_INTERVIEW_RADIO_ENERGY,
		16.0,
		2.5
	)
	outlets[o_be_radio.id] = o_be_radio

## Restituisce le emittenti accessibili per la città specificata
func get_outlets_for_city(city_id: int) -> Array[MediaOutletData]:
	var list: Array[MediaOutletData] = []
	for o: MediaOutletData in outlets.values():
		if o.city_id == city_id:
			list.append(o)
	return list

## Verifica se il giocatore può sostenere un'intervista con una determinata emittente
func can_do_interview(outlet_id: String, current_day: int = 1) -> Dictionary:
	var o: MediaOutletData = outlets.get(outlet_id, null)
	if not o:
		return {"allowed": false, "reason": "outlet_not_found"}
		
	if last_interview_day == current_day:
		return {"allowed": false, "reason": "already_interviewed_today"}
		
	if player_data:
		if player_data.energy < o.interview_cost_energy:
			return {"allowed": false, "reason": "energy_insufficient"}
		if player_data.career_tier < o.min_career_tier:
			return {"allowed": false, "reason": "career_tier_too_low"}
		if player_data.reputation < o.required_reputation:
			return {"allowed": false, "reason": "reputation_too_low"}
			
	return {"allowed": true, "outlet": o}

## Esegue un'intervista promozionale del mattino
func conduct_interview(outlet_id: String, current_day: int = 1) -> Dictionary:
	var check: Dictionary = can_do_interview(outlet_id, current_day)
	if not check.get("allowed", false):
		return {"success": false, "reason": check.get("reason", "error")}
		
	var o: MediaOutletData = check.outlet
	if player_data:
		player_data.consume_energy(o.interview_cost_energy)
		player_data.reputation = clampf(player_data.reputation + o.reputation_yield, 0.0, 100.0)
		player_data.modify_morale(5)
		
		# Guadagno fan locali dalla trasmissione radio/tv
		var fans_gain: int = int(float(o.reach_listeners) * 0.015)
		player_data.add_fans(fans_gain)
		var current_city: int = player_data.current_city_id
		if player_data.city_fans.has(current_city):
			player_data.city_fans[current_city] = int(player_data.city_fans[current_city]) + fans_gain
			
	last_interview_day = current_day
	var entry: Dictionary = {
		"day": current_day,
		"outlet_id": o.id,
		"outlet_name": o.name,
		"media_type": o.media_type,
		"hype_added": o.hype_yield,
		"reputation_added": o.reputation_yield
	}
	interview_history.append(entry)
	
	if EventBus and EventBus.has_signal("tour_radio_interview_completed"):
		EventBus.tour_radio_interview_completed.emit({
			"station_name": o.name,
			"hype_gain": o.hype_yield,
			"rep_gain": o.reputation_yield
		})
		
	return {
		"success": true,
		"outlet_name": o.name,
		"hype_yield": o.hype_yield,
		"reputation_yield": o.reputation_yield,
		"message": "Intervista completata con successo su %s! Hype +%.1f, Reputazione +%.1f." % [o.name, o.hype_yield, o.reputation_yield]
	}

## Intervista di Riparazione post-scandalo o shitstorm (recupero reputazione/morale)
func conduct_crisis_repair_interview(outlet_id: String, current_day: int = 1) -> Dictionary:
	var o: MediaOutletData = outlets.get(outlet_id, null)
	if not o:
		return {"success": false, "reason": "outlet_not_found"}
		
	if player_data and player_data.energy < 20:
		return {"success": false, "reason": "energy_insufficient"}
		
	if player_data:
		player_data.consume_energy(20)
		player_data.reputation = clampf(player_data.reputation + 4.0, 0.0, 100.0)
		player_data.modify_morale(10)
		
	last_interview_day = current_day
	var note: String = "Intervista chiarificatrice su %s: le scuse e le spiegazioni hanno calmato le acque (+4.0 Reputazione)." % o.name
	return {
		"success": true,
		"outlet_name": o.name,
		"reputation_restored": 4.0,
		"message": note
	}

## Aggiunge una recensione specialistica alla rassegna stampa
func add_press_review(work_title: String, reviewer: String, outlet: String, rating_stars: float, comment: String, current_day: int = 1) -> void:
	var rev: Dictionary = {
		"day": current_day,
		"work_title": work_title,
		"reviewer": reviewer,
		"outlet": outlet,
		"rating_stars": rating_stars,
		"comment": comment
	}
	press_reviews.append(rev)

## Genera il testo accessibile per lo screen reader NVDA sulla rassegna stampa
func get_press_speech() -> String:
	var lines: Array[String] = []
	lines.append("Rassegna Stampa & Critica Musicale:")
	if press_reviews.is_empty():
		lines.append("Nessuna recensione registrata finora nella rassegna stampa.")
	else:
		for rev in press_reviews:
			lines.append("Giorno %d - '%s' su %s: %.1f/5.0 stelle. Critico %s: \"%s\"" % [
				int(rev.get("day", 1)),
				str(rev.get("work_title", "")),
				str(rev.get("outlet", "")),
				float(rev.get("rating_stars", 3.0)),
				str(rev.get("reviewer", "")),
				str(rev.get("comment", ""))
			])
	return "\n".join(lines)

## Serializzazione savegame
func to_dict() -> Dictionary:
	return {
		"last_interview_day": last_interview_day,
		"interview_history": interview_history.duplicate(),
		"press_reviews": press_reviews.duplicate()
	}

## Deserializzazione savegame
func from_dict(d: Dictionary) -> void:
	last_interview_day = int(d.get("last_interview_day", -1))
	interview_history.clear()
	var raw_h: Array = d.get("interview_history", [])
	for h in raw_h:
		if h is Dictionary:
			interview_history.append(h)
			
	press_reviews.clear()
	var raw_p: Array = d.get("press_reviews", [])
	for p in raw_p:
		if p is Dictionary:
			press_reviews.append(p)
