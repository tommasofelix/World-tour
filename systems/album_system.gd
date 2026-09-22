# res://systems/album_system.gd
class_name AlbumSystem
extends RefCounted

## Gestore Centralizzato della Produzione Discografica (EP & LP) (World-tour V2.0)
## Governa la compilazione di raccolte discografiche (3-5 tracce per EP, 6-10 per LP),
## il calcolo della qualità complessiva, la sinergia di gruppo, l'impatto della lead single,
## le recensioni della critica musicale (1-5 stelle) e le vendite/royalties passive a catalogo.

var player_data: PlayerData
var calendar_data: CalendarData

func _init(p_player: PlayerData, p_calendar: CalendarData = null) -> void:
	player_data = p_player
	calendar_data = p_calendar

func get_active_player_data() -> PlayerData:
	if player_data:
		return player_data
	if GameManager and GameManager.player_data:
		return GameManager.player_data
	return null

func get_active_calendar_data() -> CalendarData:
	if calendar_data:
		return calendar_data
	if GameManager and GameManager.calendar_data:
		return GameManager.calendar_data
	return null

## Restituisce tutti i brani idonei per essere inseriti in un album (PRODUCED o RELEASED)
func get_eligible_songs() -> Array[SongData]:
	var active_player := get_active_player_data()
	var result: Array[SongData] = []
	if not active_player:
		return result
	for s in active_player.songs:
		if s.status == Enums.SongStatus.PRODUCED or s.status == Enums.SongStatus.RELEASED:
			result.append(s)
	return result

## Valida la composizione delle tracce per il tipo di album selezionato
func validate_album_composition(song_ids: Array[String], album_type: int) -> Dictionary:
	get_active_player_data()
	var min_tracks: int = Constants.ALBUM_EP_MIN_TRACKS if album_type == Enums.AlbumType.EP else Constants.ALBUM_LP_MIN_TRACKS
	var max_tracks: int = Constants.ALBUM_EP_MAX_TRACKS if album_type == Enums.AlbumType.EP else Constants.ALBUM_LP_MAX_TRACKS
	
	if song_ids.size() < min_tracks:
		return {
			"valid": false,
			"reason": "too_few_tracks",
			"min": min_tracks,
			"current": song_ids.size()
		}
		
	if song_ids.size() > max_tracks:
		return {
			"valid": false,
			"reason": "too_many_tracks",
			"max": max_tracks,
			"current": song_ids.size()
		}
		
	# Verifica duplicati
	var seen: Dictionary = {}
	for s_id in song_ids:
		if seen.has(s_id):
			return {
				"valid": false,
				"reason": "duplicate_tracks"
			}
		seen[s_id] = true
		
	# Verifica esistenza e stato
	if player_data:
		for s_id in song_ids:
			var found: SongData = null
			for s in player_data.songs:
				if s.id == s_id:
					found = s
					break
			if not found:
				return {
					"valid": false,
					"reason": "song_not_found",
					"song_id": s_id
				}
			if found.status != Enums.SongStatus.PRODUCED and found.status != Enums.SongStatus.RELEASED:
				return {
					"valid": false,
					"reason": "song_not_eligible",
					"song_id": s_id,
					"status": found.status
				}
				
	return {
		"valid": true,
		"tracks_count": song_ids.size()
	}

## Calcola le metriche previste per l'album (qualità, recensioni, vendite stimate)
func calculate_album_metrics(
	song_ids: Array[String],
	lead_single_id: String,
	concept: int,
	artwork_style: int,
	album_type: int
) -> Dictionary:
	get_active_player_data()
	if song_ids.is_empty() or not player_data:
		return {
			"overall_quality": 10.0,
			"review_stars": 2.5,
			"initial_sales": 10.0,
			"gross_revenue": 20.0,
			"fan_gain": 5,
			"rep_gain": 0.5,
			"cost": Constants.ALBUM_EP_PRODUCTION_COST
		}
		
	var total_quality: float = 0.0
	var tracks_count: int = song_ids.size()
	var lead_song: SongData = null
	
	for s_id in song_ids:
		for s in player_data.songs:
			if s.id == s_id:
				total_quality += s.quality_score
				if s.id == lead_single_id:
					lead_song = s
				break
				
	var avg_quality: float = total_quality / float(tracks_count)
	
	# Bonus Lead Single (fino a +8.0 punti basato sulla traccia trainante)
	var lead_bonus: float = 0.0
	if lead_song:
		lead_bonus = (lead_song.quality_score / 100.0) * 8.0
	else:
		lead_bonus = 2.0 # Default minimo se nessuna traccia speciale indicata
		
	# Bonus Concept e Artwork
	var concept_bonus: float = 3.0
	match concept:
		Enums.AlbumConcept.CONCEPTUAL:
			concept_bonus = 5.0
		Enums.AlbumConcept.COMMERCIAL_HIT:
			concept_bonus = 4.0
		Enums.AlbumConcept.RAW_UNDERGROUND:
			concept_bonus = 3.5
			
	var artwork_bonus: float = 3.0
	match artwork_style:
		Enums.ArtworkStyle.RETRO_PSYCHEDELIC:
			artwork_bonus = 4.0
		Enums.ArtworkStyle.DARK_METAL:
			artwork_bonus = 4.0
		Enums.ArtworkStyle.STREET_GRAFFITI:
			artwork_bonus = 3.5
		_:
			artwork_bonus = 3.0
			
	# Bonus Sinergia Band
	var band_bonus: float = 0.0
	if not player_data.band_members.is_empty():
		var total_chem: float = 0.0
		for m in player_data.band_members:
			total_chem += (m.affinity + m.respect - (m.tension * 0.5))
		var avg_chem: float = total_chem / float(player_data.band_members.size())
		band_bonus = (avg_chem / 100.0) * 8.0
		
	var overall_quality: float = clampf(
		avg_quality + lead_bonus + concept_bonus + artwork_bonus + band_bonus,
		Constants.SONG_MIN_QUALITY,
		Constants.SONG_MAX_QUALITY
	)
	
	# Calcolo Recensioni Critiche (1.0 - 5.0 stelle)
	# Formula equilibrata: 1.0 stella base + proporzione qualità
	var raw_stars: float = 1.0 + (overall_quality / 100.0) * 4.0
	# Piccola varianza realistica deterministica (± 0.2)
	var review_stars: float = clampf(snappedf(raw_stars, 0.5), 1.0, 5.0)
	
	var cost: float = Constants.ALBUM_EP_PRODUCTION_COST if album_type == Enums.AlbumType.EP else Constants.ALBUM_LP_PRODUCTION_COST
	
	# Vendite iniziali (Day 1)
	var rep: float = player_data.reputation
	var fans: float = float(player_data.fans)
	var sales_mult: float = 1.4 if album_type == Enums.AlbumType.LP else 1.0
	var initial_sales: float = ((rep * 35.0) + (fans * 0.45) + (overall_quality * 6.0)) * sales_mult
	initial_sales = maxf(15.0, snappedf(initial_sales, 1.0))
	
	# Prezzo medio per copia/stream
	var unit_price: float = 2.50 if album_type == Enums.AlbumType.EP else 4.50
	var gross_revenue: float = snappedf(initial_sales * unit_price, 0.01)
	
	# Conversione Fan e Reputazione
	var fan_gain: int = int((initial_sales * 0.12) + (overall_quality * 0.25))
	var rep_gain: float = snappedf((overall_quality / 30.0) + (1.2 if album_type == Enums.AlbumType.LP else 0.6), 0.1)
	
	return {
		"overall_quality": overall_quality,
		"review_stars": review_stars,
		"cost": cost,
		"initial_sales": initial_sales,
		"gross_revenue": gross_revenue,
		"fan_gain": fan_gain,
		"rep_gain": rep_gain
	}

## Crea e pubblica ufficialmente un album/EP
func create_and_release_album(
	title: String,
	album_type: int,
	song_ids: Array[String],
	lead_single_id: String,
	concept: int,
	artwork_style: int
) -> Dictionary:
	var val: Dictionary = validate_album_composition(song_ids, album_type)
	if not val.valid:
		return {
			"success": false,
			"reason": val.reason
		}
		
	var metrics: Dictionary = calculate_album_metrics(song_ids, lead_single_id, concept, artwork_style, album_type)
	var cost: float = metrics.cost
	
	if not player_data or player_data.money < cost:
		return {
			"success": false,
			"reason": "money_insufficient",
			"cost": cost,
			"balance": player_data.money if player_data else 0.0
		}
		
	# Detrazione costi di produzione
	player_data.modify_money(-cost)
	EventBus.money_changed.emit(player_data.money, -cost, "Produzione %s: %s" % [
		"EP" if album_type == Enums.AlbumType.EP else "LP", title
	])
	
	var day_num: int = calendar_data.day_number if calendar_data else 1
	
	# Creazione entità AlbumData
	var album := AlbumData.new("", title, album_type)
	album.concept = concept
	album.artwork_style = artwork_style
	album.lead_single_id = lead_single_id
	album.song_ids = song_ids.duplicate()
	album.overall_quality = metrics.overall_quality
	album.review_stars = metrics.review_stars
	album.release_day = day_num
	album.total_sales = metrics.initial_sales
	album.is_released = true
	
	player_data.albums.append(album)
	
	# Aggiorna lo stato dei singoli inclusi a RELEASED se non lo erano già
	for s_id in song_ids:
		for s in player_data.songs:
			if s.id == s_id:
				if s.status != Enums.SongStatus.RELEASED:
					s.status = Enums.SongStatus.RELEASED
					s.release_day = day_num
				break
				
	# Ripartizione incassi lordi del Day 1 con la band
	var gross_rev: float = metrics.gross_revenue
	var leader_ratio: float = player_data.get_leader_revenue_share()
	var player_share: float = snappedf(gross_rev * leader_ratio, 0.01)
	
	player_data.modify_money(player_share)
	EventBus.money_changed.emit(player_data.money, player_share, "Incassi Day 1 %s: %s" % [
		album.get_type_name(), title
	])
	
	# Impatto psicologico sui compagni di band
	if not player_data.band_members.is_empty():
		for m in player_data.band_members:
			if metrics.review_stars >= 4.0:
				m.adjust_respect(10.0)
				m.adjust_tension(-8.0)
			elif metrics.review_stars >= 3.0:
				m.adjust_respect(4.0)
				m.adjust_tension(-3.0)
			else:
				m.adjust_tension(6.0)
		EventBus.band_chemistry_changed.emit(
			_calc_avg_affinity(), _calc_avg_respect(), _calc_avg_tension()
		)
		
	# Aumento reputazione e fan
	player_data.fans += metrics.fan_gain
	player_data.reputation = clampf(player_data.reputation + metrics.rep_gain, 0.0, 100.0)
	
	EventBus.album_created.emit(album.to_dict())
	EventBus.album_released.emit(album.to_dict())
	
	var type_str := album.get_type_name()
	var speech := "Pubblicato il nuovo %s '%s'! Recensioni: %.1f stelle su 5. Vendite iniziali: %.0f copie. Incasso netto leader: %.2f euro." % [
		type_str, title, metrics.review_stars, metrics.initial_sales, player_share
	]
	AccessibilityManager.announce(speech, true)
	
	return {
		"success": true,
		"album": album,
		"revenue": player_share,
		"fan_gain": metrics.fan_gain,
		"rep_gain": metrics.rep_gain,
		"metrics": metrics
	}

## Elabora le royalties passive giornaliere a catalogo
func process_daily_royalties() -> Dictionary:
	var total_player_royalties: float = 0.0
	var count: int = 0
	
	if not player_data or player_data.albums.is_empty():
		return {
			"total_royalties": 0.0,
			"album_count": 0
		}
		
	var current_day: int = calendar_data.day_number if calendar_data else 1
	var leader_ratio: float = player_data.get_leader_revenue_share()
	
	for album in player_data.albums:
		if not album.is_released:
			continue
			
		var days_old: int = maxi(1, current_day - album.release_day)
		# Decadimento graduale realistico (si assesta su vendite di catalogo stabili)
		var decay: float = pow(0.97, clampf(float(days_old), 0.0, 60.0))
		var daily_units: float = maxf(1.0, (album.overall_quality * 0.35 + float(player_data.fans) * 0.03) * decay)
		var royalty_rate: float = Constants.ALBUM_EP_ROYALTY_RATE if album.album_type == Enums.AlbumType.EP else Constants.ALBUM_LP_ROYALTY_RATE
		var gross_album_royalty: float = daily_units * royalty_rate
		var player_album_royalty: float = snappedf(gross_album_royalty * leader_ratio, 0.01)
		
		album.total_sales += daily_units
		total_player_royalties += player_album_royalty
		count += 1
		
	total_player_royalties = snappedf(total_player_royalties, 0.01)
	
	if total_player_royalties > 0.0:
		player_data.modify_money(total_player_royalties)
		EventBus.money_changed.emit(player_data.money, total_player_royalties, "Royalties Catalogo Album (%d titoli)" % count)
		EventBus.album_sales_updated.emit(total_player_royalties, count)
		
	return {
		"total_royalties": total_player_royalties,
		"album_count": count
	}

func _calc_avg_affinity() -> float:
	if not player_data or player_data.band_members.is_empty():
		return 0.0
	var sum: float = 0.0
	for m in player_data.band_members:
		sum += m.affinity
	return sum / float(player_data.band_members.size())

func _calc_avg_respect() -> float:
	if not player_data or player_data.band_members.is_empty():
		return 0.0
	var sum: float = 0.0
	for m in player_data.band_members:
		sum += m.respect
	return sum / float(player_data.band_members.size())

func _calc_avg_tension() -> float:
	if not player_data or player_data.band_members.is_empty():
		return 0.0
	var sum: float = 0.0
	for m in player_data.band_members:
		sum += m.tension
	return sum / float(player_data.band_members.size())
