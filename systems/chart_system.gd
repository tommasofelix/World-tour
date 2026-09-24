# GDD 2.0 / SP-13: Sottosistema Gestione Classifiche Musicali (Hit Parade)
class_name ChartSystem
extends RefCounted

## Riferimento ai dati giocatore
var player_data: PlayerData

## Riferimento ai dati calendario
var calendar_data: CalendarData

## Riferimento al sistema degli artisti rivali
var rival_system: RivalSystem

## Riferimento opzionale a SocialMediaSystem per buzz
var social_media_system: RefCounted

## Riferimento opzionale ad AlbumSystem per catalogo dischi
var album_system: RefCounted

## Classifica Top 10 dei Singoli (Hit Parade Singles)
var top_singles: Array[ChartEntryData] = []

## Classifica Top 10 degli Album / EP (Hit Parade Albums)
var top_albums: Array[ChartEntryData] = []

## Classifiche Territoriali Singoli (city_id -> Array[ChartEntryData])
var territorial_singles: Dictionary = {}

## Classifiche Territoriali Album (city_id -> Array[ChartEntryData])
var territorial_albums: Dictionary = {}

## Ultima settimana di calendario in cui è avvenuto l'aggiornamento
var last_updated_week: int = 0

## Migliore posizione mai raggiunta dal giocatore nei singoli
var player_highest_single_rank: int = 999

## Migliore posizione mai raggiunta dal giocatore negli album
var player_highest_album_rank: int = 999

## Settimane consecutive trascorse al primo posto (#1)
var weeks_at_number_one: int = 0

func _init(
	p_player: PlayerData = null,
	p_calendar: CalendarData = null,
	p_rivals: RivalSystem = null,
	p_social: RefCounted = null,
	p_albums: RefCounted = null
) -> void:
	player_data = p_player
	calendar_data = p_calendar
	rival_system = p_rivals if p_rivals != null else RivalSystem.new()
	social_media_system = p_social
	album_system = p_albums
	init_starter_charts()

## Inizializza le classifiche iniziali di partenza con i soli artisti del panorama musicale
func init_starter_charts() -> void:
	top_singles.clear()
	top_albums.clear()
	last_updated_week = 1
	if rival_system:
		var rivals_list: Array[RivalData] = rival_system.get_all_rivals()
		var sorted_rivals := rivals_list.duplicate()
		sorted_rivals.sort_custom(func(a: RivalData, b: RivalData) -> bool:
			return a.popularity > b.popularity
		)
		var limit: int = mini(10, sorted_rivals.size())
		for i in range(limit):
			var r: RivalData = sorted_rivals[i]
			var stream_val: int = int((r.popularity * 1600.0) + (r.current_single_score * 420.0))
			var sales_val: int = int((r.popularity * 180.0) + (r.current_album_score * 45.0))
			top_singles.append(ChartEntryData.new(
				i + 1, 0, "rival_single_" + r.id, r.current_single_title, r.name, false, r.genre, stream_val, 1, i + 1
			))
			top_albums.append(ChartEntryData.new(
				i + 1, 0, "rival_album_" + r.id, r.current_album_title, r.name, false, r.genre, sales_val, 1, i + 1
			))

## Esegue l'aggiornamento settimanale ufficiale della Hit Parade (ogni Domenica sera)
func update_weekly_charts(current_day: int = 1) -> Dictionary:
	# Simula performance dei rivali
	if rival_system:
		rival_system.simulate_weekly_performance()
		
	var old_singles_map: Dictionary = {}
	for old_e in top_singles:
		old_singles_map[old_e.entry_id] = old_e
		
	var old_albums_map: Dictionary = {}
	for old_a in top_albums:
		old_albums_map[old_a.entry_id] = old_a
		
	# -------------------------------------------------------------
	# 1. COMPILAZIONE TOP 10 SINGOLI
	# -------------------------------------------------------------
	var candidate_singles: Array[Dictionary] = []
	
	# Candidati dai rivali
	if rival_system:
		for r: RivalData in rival_system.get_all_rivals():
			var stream_val: int = int((r.popularity * 1600.0) + (r.current_single_score * 420.0) + float(randi_range(3000, 12000)))
			candidate_singles.append({
				"id": "rival_single_" + r.id,
				"title": r.current_single_title,
				"artist": r.name,
				"is_player": false,
				"genre": r.genre,
				"metric": stream_val
			})
			
	# Candidati dal giocatore
	if player_data and not player_data.songs.is_empty():
		var player_pop: float = player_data.popularity
		var player_fans: int = player_data.fans
		var buzz_mult: float = 1.0
		if social_media_system and social_media_system.has_method("get_live_buzz_multiplier"):
			buzz_mult = social_media_system.get_live_buzz_multiplier()
		elif social_media_system:
			buzz_mult = float(social_media_system.get("weekly_buzz"))
			
		for s: SongData in player_data.songs:
			# Considera brani completati o rilasciati
			if s.status == Enums.SongStatus.PRODUCED or s.status == Enums.SongStatus.RELEASED:
				var song_qual: float = s.quality_score
				var base_stream: float = (player_pop * 1800.0) + (song_qual * 550.0) + (float(player_fans) * 0.9)
				
				# Bonus tratti speciali del brano
				if s.special_trait == Enums.SongTrait.EARWORM:
					base_stream *= 1.35
				elif s.special_trait == Enums.SongTrait.AUDIOPHILE_GEM:
					base_stream *= 1.25
				elif s.special_trait == Enums.SongTrait.STAGE_BEAST:
					base_stream *= 1.15
				elif s.special_trait == Enums.SongTrait.GENERATIONAL_ANTHEM:
					base_stream *= 1.30

				# Meccanica Tormentone Stagionale (Mesi 4-6 Estivi o Mese 12 Invernale)
				if calendar_data:
					var current_month: int = calendar_data.current_month if "current_month" in calendar_data else int((current_day - 1) / 28) + 1
					if (current_month >= 4 and current_month <= 6) or current_month == 12:
						if s.special_trait == Enums.SongTrait.EARWORM or s.special_trait == Enums.SongTrait.GENERATIONAL_ANTHEM:
							base_stream *= Constants.MEDIA_SEASONAL_HIT_MULT
					
				var player_stream: int = int(round(base_stream * buzz_mult))
				candidate_singles.append({
					"id": s.id,
					"title": s.title,
					"artist": player_data.band_name if not player_data.band_name.is_empty() else "The Rebels",
					"is_player": true,
					"genre": s.genre,
					"metric": player_stream
				})
				
	# Ordinamento decrescente per metric (stream)
	candidate_singles.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return int(a.metric) > int(b.metric)
	)
	
	# Costruzione nuova Top 10 Singoli
	top_singles.clear()
	var singles_limit: int = mini(10, candidate_singles.size())
	for i in range(singles_limit):
		var cand: Dictionary = candidate_singles[i]
		var cur_rank: int = i + 1
		var c_id: String = str(cand.id)
		
		var prev_rank: int = 0
		var weeks: int = 1
		var peak: int = cur_rank
		
		if old_singles_map.has(c_id):
			var old_ent: ChartEntryData = old_singles_map[c_id]
			prev_rank = old_ent.rank
			weeks = old_ent.weeks_on_chart + 1
			peak = mini(cur_rank, old_ent.peak_rank)
			
		var new_entry := ChartEntryData.new(
			cur_rank,
			prev_rank,
			c_id,
			str(cand.title),
			str(cand.artist),
			bool(cand.is_player),
			int(cand.genre),
			int(cand.metric),
			weeks,
			peak
		)
		top_singles.append(new_entry)
		
		# Traguardi del giocatore
		if new_entry.is_player:
			if cur_rank < player_highest_single_rank:
				player_highest_single_rank = cur_rank
				
			# Debutto per la prima volta in classifica
			if new_entry.is_new_entry() and cur_rank <= 10:
				if EventBus:
					EventBus.chart_debut_achieved.emit("single", new_entry.title, cur_rank)
				if player_data:
					player_data.popularity = clampf(player_data.popularity + 2.5, 0.0, 100.0)
					player_data.modify_morale(10)
					
			# Raggiungimento del #1
			if cur_rank == 1:
				weeks_at_number_one += 1
				if EventBus:
					EventBus.chart_number_one_achieved.emit("single", new_entry.title)
				if player_data:
					player_data.popularity = clampf(player_data.popularity + 6.0, 0.0, 100.0)
					player_data.modify_morale(20)
					player_data.add_fans(350)
					player_data.increment_career_stat("weeks_at_number_one", 1)

	# -------------------------------------------------------------
	# 2. COMPILAZIONE TOP 10 ALBUM
	# -------------------------------------------------------------
	var candidate_albums: Array[Dictionary] = []
	
	# Candidati dai rivali
	if rival_system:
		for r: RivalData in rival_system.get_all_rivals():
			var sales_val: int = int((r.popularity * 120.0) + (r.current_album_score * 35.0) + float(randi_range(400, 2500)))
			candidate_albums.append({
				"id": "rival_album_" + r.id,
				"title": r.current_album_title,
				"artist": r.name,
				"is_player": false,
				"genre": r.genre,
				"metric": sales_val
			})
			
	# Candidati dal giocatore
	if player_data and not player_data.albums.is_empty():
		var player_pop: float = player_data.popularity
		for alb: AlbumData in player_data.albums:
			var alb_sales: int = int(round((player_pop * 140.0) + (alb.overall_quality * 45.0) + (float(player_data.fans) * 0.15)))
			candidate_albums.append({
				"id": alb.id,
				"title": alb.title,
				"artist": player_data.band_name if not player_data.band_name.is_empty() else "The Rebels",
				"is_player": true,
				"genre": alb.genre,
				"metric": alb_sales
			})
			
	candidate_albums.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return int(a.metric) > int(b.metric)
	)
	
	top_albums.clear()
	var albums_limit: int = mini(10, candidate_albums.size())
	for i in range(albums_limit):
		var cand: Dictionary = candidate_albums[i]
		var cur_rank: int = i + 1
		var c_id: String = str(cand.id)
		
		var prev_rank: int = 0
		var weeks: int = 1
		var peak: int = cur_rank
		
		if old_albums_map.has(c_id):
			var old_ent: ChartEntryData = old_albums_map[c_id]
			prev_rank = old_ent.rank
			weeks = old_ent.weeks_on_chart + 1
			peak = mini(cur_rank, old_ent.peak_rank)
			
		var new_entry := ChartEntryData.new(
			cur_rank,
			prev_rank,
			c_id,
			str(cand.title),
			str(cand.artist),
			bool(cand.is_player),
			int(cand.genre),
			int(cand.metric),
			weeks,
			peak
		)
		top_albums.append(new_entry)
		
		if new_entry.is_player:
			if cur_rank < player_highest_album_rank:
				player_highest_album_rank = cur_rank
			if new_entry.is_new_entry() and cur_rank <= 10:
				if EventBus:
					EventBus.chart_debut_achieved.emit("album", new_entry.title, cur_rank)
				if player_data:
					player_data.popularity = clampf(player_data.popularity + 4.0, 0.0, 100.0)
					player_data.modify_morale(15)
			if cur_rank == 1:
				if EventBus:
					EventBus.chart_number_one_achieved.emit("album", new_entry.title)
				if player_data:
					player_data.popularity = clampf(player_data.popularity + 8.0, 0.0, 100.0)
					player_data.modify_morale(25)
					player_data.add_fans(600)
					player_data.increment_career_stat("weeks_at_number_one", 1)
					
	last_updated_week = maxi(1, int((current_day - 1) / 7) + 1)
	
	# -------------------------------------------------------------
	# 3. COMPILAZIONE CLASSIFICHE TERRITORIALI (Per metropoli/città)
	# -------------------------------------------------------------
	_update_territorial_charts(candidate_singles, candidate_albums)
	
	if EventBus:
		EventBus.weekly_charts_updated.emit({
			"week": last_updated_week,
			"singles": top_singles,
			"albums": top_albums,
			"territorial_singles": territorial_singles,
			"territorial_albums": territorial_albums
		})
		
	return {
		"success": true,
		"week": last_updated_week,
		"singles_count": top_singles.size(),
		"albums_count": top_albums.size()
	}

## Compila le classifiche territoriali locali per le principali nazioni/città
func _update_territorial_charts(all_singles: Array[Dictionary], all_albums: Array[Dictionary]) -> void:
	territorial_singles.clear()
	territorial_albums.clear()
	
	var supported_cities: Array[int] = [
		Enums.CityId.MILANO,
		Enums.CityId.BOLOGNA,
		Enums.CityId.ROMA,
		Enums.CityId.NAPOLI,
		Enums.CityId.LONDRA,
		Enums.CityId.BERLINO
	]
	
	for city_id in supported_cities:
		var city_singles: Array[ChartEntryData] = []
		var city_albums: Array[ChartEntryData] = []
		
		# Singoli filtrati e ponderati per città
		var city_cands: Array[Dictionary] = []
		for cand in all_singles:
			var metric_mod: float = float(cand.metric)
			if cand.is_player and player_data:
				var local_fans: int = player_data.get_city_fans(city_id)
				metric_mod += float(local_fans) * 1.5
			city_cands.append({
				"cand": cand,
				"local_metric": int(metric_mod)
			})
			
		city_cands.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
			return int(a.local_metric) > int(b.local_metric)
		)
		
		var limit_s: int = mini(5, city_cands.size())
		for idx in range(limit_s):
			var item: Dictionary = city_cands[idx]
			var c: Dictionary = item.cand
			city_singles.append(ChartEntryData.new(
				idx + 1,
				0,
				str(c.id),
				str(c.title),
				str(c.artist),
				bool(c.is_player),
				int(c.genre),
				int(item.local_metric),
				1,
				idx + 1,
				Enums.ChartScope.NATIONAL,
				city_id
			))
		territorial_singles[city_id] = city_singles
		
		# Album filtrati e ponderati per città
		var alb_cands: Array[Dictionary] = []
		for acand in all_albums:
			var alb_metric_mod: float = float(acand.metric)
			if acand.is_player and player_data:
				var local_fans: int = player_data.get_city_fans(city_id)
				alb_metric_mod += float(local_fans) * 0.5
			alb_cands.append({
				"cand": acand,
				"local_metric": int(alb_metric_mod)
			})
			
		alb_cands.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
			return int(a.local_metric) > int(b.local_metric)
		)
		
		var limit_a: int = mini(5, alb_cands.size())
		for idx in range(limit_a):
			var aitem: Dictionary = alb_cands[idx]
			var ac: Dictionary = aitem.cand
			city_albums.append(ChartEntryData.new(
				idx + 1,
				0,
				str(ac.id),
				str(ac.title),
				str(ac.artist),
				bool(ac.is_player),
				int(ac.genre),
				int(aitem.local_metric),
				1,
				idx + 1,
				Enums.ChartScope.NATIONAL,
				city_id
			))
		territorial_albums[city_id] = city_albums

## Restituisce la classifica territoriale per una determinata città
func get_territorial_chart(city_id: int, is_album: bool = false) -> Array[ChartEntryData]:
	if is_album:
		return territorial_albums.get(city_id, [])
	return territorial_singles.get(city_id, [])

## Restituisce le canzoni del giocatore attualmente presenti nella Top 10 Singoli
func get_player_single_entries() -> Array[ChartEntryData]:
	var list: Array[ChartEntryData] = []
	for e in top_singles:
		if e.is_player:
			list.append(e)
	return list

## Restituisce gli album del giocatore attualmente presenti nella Top 10 Album
func get_player_album_entries() -> Array[ChartEntryData]:
	var list: Array[ChartEntryData] = []
	for e in top_albums:
		if e.is_player:
			list.append(e)
	return list

## Genera il report vocale lineare e accessibile per NVDA
func get_charts_speech(chart_type: int = 0) -> String:
	var lines: Array[String] = []
	var list: Array[ChartEntryData] = top_singles if chart_type == 0 else top_albums
	var chart_title: String = "Classifica Ufficiale Top 10 Singoli" if chart_type == 0 else "Classifica Ufficiale Top 10 Album"
	
	lines.append(chart_title + " (Settimana %d)." % last_updated_week)
	
	var player_entries: Array[ChartEntryData] = get_player_single_entries() if chart_type == 0 else get_player_album_entries()
	if player_entries.is_empty():
		lines.append("La tua band non ha opere attualmente in classifica.")
	else:
		lines.append("La tua band è presente con %d opera/e:" % player_entries.size())
		for pe in player_entries:
			lines.append("  Posizione #%d: '%s' (%s)" % [pe.rank, pe.title, pe.get_movement_symbol()])
			
	lines.append("Elenco completo delle 10 posizioni:")
	for e: ChartEntryData in list:
		lines.append(e.get_speech_description())
		
	return "\n".join(lines)

## Descrizione vocale per classifica territoriale
func get_territorial_charts_speech(city_id: int, chart_type: int = 0) -> String:
	var city_name: String = Enums.get_city_name(city_id)
	var entries: Array[ChartEntryData] = get_territorial_chart(city_id, chart_type == 1)
	var type_str: String = "Singoli" if chart_type == 0 else "Album"
	var lines: Array[String] = []
	lines.append("Hit Parade Territoriale di %s — Top 5 %s:" % [city_name, type_str])
	if entries.is_empty():
		lines.append("Nessun dato territoriale disponibile per questa città.")
	else:
		for e in entries:
			var ptag: String = " (Tua Band)" if e.is_player else ""
			lines.append("#%d: '%s' di %s%s - Punteggio: %d" % [e.rank, e.title, e.artist_name, ptag, e.metric_value])
	return "\n".join(lines)

## Serializzazione per savegame
func to_dict() -> Dictionary:
	var singles_arr: Array[Dictionary] = []
	for s in top_singles:
		singles_arr.append(s.to_dict())
		
	var albums_arr: Array[Dictionary] = []
	for a in top_albums:
		albums_arr.append(a.to_dict())
		
	var terr_singles_dict: Dictionary = {}
	for c_id in territorial_singles.keys():
		var arr: Array[Dictionary] = []
		for e in territorial_singles[c_id]:
			arr.append(e.to_dict())
		terr_singles_dict[str(c_id)] = arr
		
	var terr_albums_dict: Dictionary = {}
	for c_id in territorial_albums.keys():
		var arr: Array[Dictionary] = []
		for e in territorial_albums[c_id]:
			arr.append(e.to_dict())
		terr_albums_dict[str(c_id)] = arr
		
	return {
		"last_updated_week": last_updated_week,
		"player_highest_single_rank": player_highest_single_rank,
		"player_highest_album_rank": player_highest_album_rank,
		"weeks_at_number_one": weeks_at_number_one,
		"top_singles": singles_arr,
		"top_albums": albums_arr,
		"territorial_singles": terr_singles_dict,
		"territorial_albums": terr_albums_dict
	}

## Deserializzazione da savegame
func from_dict(d: Dictionary) -> void:
	last_updated_week = int(d.get("last_updated_week", 0))
	player_highest_single_rank = int(d.get("player_highest_single_rank", 999))
	player_highest_album_rank = int(d.get("player_highest_album_rank", 999))
	weeks_at_number_one = int(d.get("weeks_at_number_one", 0))
	
	top_singles.clear()
	var raw_s: Array = d.get("top_singles", [])
	for s_dict in raw_s:
		if s_dict is Dictionary:
			var se := ChartEntryData.new()
			se.from_dict(s_dict)
			top_singles.append(se)
			
	top_albums.clear()
	var raw_a: Array = d.get("top_albums", [])
	for a_dict in raw_a:
		if a_dict is Dictionary:
			var ae := ChartEntryData.new()
			ae.from_dict(a_dict)
			top_albums.append(ae)

	territorial_singles.clear()
	var raw_ts: Dictionary = d.get("territorial_singles", {})
	for k in raw_ts.keys():
		var c_id: int = int(k)
		var arr: Array[ChartEntryData] = []
		for item in raw_ts[k]:
			if item is Dictionary:
				var e := ChartEntryData.new()
				e.from_dict(item)
				arr.append(e)
		territorial_singles[c_id] = arr

	territorial_albums.clear()
	var raw_ta: Dictionary = d.get("territorial_albums", {})
	for k in raw_ta.keys():
		var c_id: int = int(k)
		var arr: Array[ChartEntryData] = []
		for item in raw_ta[k]:
			if item is Dictionary:
				var e := ChartEntryData.new()
				e.from_dict(item)
				arr.append(e)
		territorial_albums[c_id] = arr
