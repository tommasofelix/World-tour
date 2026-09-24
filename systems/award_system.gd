# res://systems/award_system.gd
class_name AwardSystem
extends RefCounted

## Modulo Certificazioni Ufficiali (Oro, Platino, Diamante) & World Music Awards
## Governa il riconoscimento discografico FIMI/RIAA e la cerimonia annuale dei premi musicali.
## Conforme a SP-01, SP-07 e Clean Architecture (ASTRALIS v3.0.7).

var player_data: PlayerData
var calendar_data: CalendarData

func _init(p_player_data: PlayerData, p_calendar_data: CalendarData = null) -> void:
	player_data = p_player_data
	calendar_data = p_calendar_data

## Valuta e assegna eventuali nuove certificazioni (Oro, Platino, Diamante) per singoli e album
func check_and_award_certifications() -> Array[Dictionary]:
	var newly_awarded: Array[Dictionary] = []
	if not player_data:
		return newly_awarded

	var cur_day: int = calendar_data.day_number if calendar_data else 1

	# 1. Verifica Singoli
	for s in player_data.songs:
		if not s.is_released or s.is_cover:
			continue
		var stream_count: int = s.plays
		var single_awarded := _evaluate_tiers_for_release(s.id, s.title, "single", stream_count, 0.0, cur_day)
		newly_awarded.append_array(single_awarded)

	# 2. Verifica Album ed EP
	for a in player_data.albums:
		if not a.is_released:
			continue
		var sales_count: float = a.total_sales
		var album_awarded := _evaluate_tiers_for_release(a.id, a.title, "album", 0, sales_count, cur_day)
		newly_awarded.append_array(album_awarded)

	return newly_awarded

func _evaluate_tiers_for_release(item_id: String, item_title: String, item_type: String, streams: int, sales: float, day: int) -> Array[Dictionary]:
	var awarded: Array[Dictionary] = []

	# Verifica Oro
	if (streams >= Constants.CERT_GOLD_STREAMS or sales >= Constants.CERT_GOLD_SALES):
		if player_data.add_certification(item_id, item_title, item_type, Enums.CertificationTier.GOLD, day):
			var cert_entry: Dictionary = {
				"item_id": item_id,
				"title": item_title,
				"type": item_type,
				"tier": Enums.CertificationTier.GOLD,
				"tier_name": "Disco d'Oro",
				"day": day
			}
			awarded.append(cert_entry)
			EventBus.certification_awarded.emit(cert_entry)
			AccessibilityManager.announce("CERTIFICAZIONE UFFICIALE: '%s' ha ottenuto il DISCO D'ORO!" % item_title, true)

	# Verifica Platino
	if (streams >= Constants.CERT_PLATINUM_STREAMS or sales >= Constants.CERT_PLATINUM_SALES):
		if player_data.add_certification(item_id, item_title, item_type, Enums.CertificationTier.PLATINUM, day):
			var cert_entry: Dictionary = {
				"item_id": item_id,
				"title": item_title,
				"type": item_type,
				"tier": Enums.CertificationTier.PLATINUM,
				"tier_name": "Disco di Platino",
				"day": day
			}
			awarded.append(cert_entry)
			EventBus.certification_awarded.emit(cert_entry)
			AccessibilityManager.announce("CERTIFICAZIONE UFFICIALE: '%s' ha conquistato il DISCO DI PLATINO!" % item_title, true)

	# Verifica Multi-Platino
	if (streams >= Constants.CERT_MULTI_PLATINUM_STREAMS or sales >= Constants.CERT_MULTI_PLATINUM_SALES):
		if player_data.add_certification(item_id, item_title, item_type, Enums.CertificationTier.MULTI_PLATINUM, day):
			var cert_entry: Dictionary = {
				"item_id": item_id,
				"title": item_title,
				"type": item_type,
				"tier": Enums.CertificationTier.MULTI_PLATINUM,
				"tier_name": "Multi-Platino",
				"day": day
			}
			awarded.append(cert_entry)
			EventBus.certification_awarded.emit(cert_entry)
			AccessibilityManager.announce("CERTIFICAZIONE STRAORDINARIA: '%s' ha raggiunto il MULTI-PLATINO!" % item_title, true)

	# Verifica Diamante
	if (streams >= Constants.CERT_DIAMOND_STREAMS or sales >= Constants.CERT_DIAMOND_SALES):
		if player_data.add_certification(item_id, item_title, item_type, Enums.CertificationTier.DIAMOND, day):
			var cert_entry: Dictionary = {
				"item_id": item_id,
				"title": item_title,
				"type": item_type,
				"tier": Enums.CertificationTier.DIAMOND,
				"tier_name": "Disco di Diamante",
				"day": day
			}
			awarded.append(cert_entry)
			EventBus.certification_awarded.emit(cert_entry)
			AccessibilityManager.announce("TRIONFO NELLA STORIA DELLA MUSICA: '%s' è DISCO DI DIAMANTE!" % item_title, true)

	return awarded

## Conduce la cerimonia annuale dei World Music Awards (Giorno 336 / Mese 12)
func evaluate_annual_music_awards(year: int) -> Dictionary:
	if not player_data:
		return {"success": false, "reason": "no_player_data"}

	var results: Dictionary = {
		"year": year,
		"awards": []
	}

	# 1. Categoria: Canzone dell'Anno (Song of the Year)
	var best_song: SongData = null
	var max_song_score: float = 0.0
	for s in player_data.songs:
		if s.is_released and not s.is_cover:
			var score: float = s.quality_score + (float(s.plays) / 100000.0)
			if score > max_song_score:
				max_song_score = score
				best_song = s

	var song_award_won: bool = best_song != null and best_song.quality_score >= 70.0 and max_song_score >= 80.0
	var song_award := {
		"category": Enums.MusicAwardCategory.SONG_OF_THE_YEAR,
		"category_name": Enums.get_award_category_name(Enums.MusicAwardCategory.SONG_OF_THE_YEAR),
		"won": song_award_won,
		"title": best_song.title if best_song else "Nessuna candidatura",
		"winner_name": player_data.player_name if song_award_won else "Band Rivale di Vertice"
	}
	results["awards"].append(song_award)
	if song_award_won:
		player_data.add_music_award(song_award)
		EventBus.award_won.emit(song_award)

	# 2. Categoria: Album dell'Anno (Album of the Year)
	var best_album: AlbumData = null
	for a in player_data.albums:
		if a.is_released and (best_album == null or a.overall_quality > best_album.overall_quality):
			best_album = a

	var album_award_won: bool = best_album != null and best_album.overall_quality >= 75.0 and best_album.total_sales >= 10000.0
	var album_award := {
		"category": Enums.MusicAwardCategory.ALBUM_OF_THE_YEAR,
		"category_name": Enums.get_award_category_name(Enums.MusicAwardCategory.ALBUM_OF_THE_YEAR),
		"won": album_award_won,
		"title": best_album.title if best_album else "Nessuna candidatura",
		"winner_name": player_data.player_name if album_award_won else "The Neon Syndicate"
	}
	results["awards"].append(album_award)
	if album_award_won:
		player_data.add_music_award(album_award)
		EventBus.award_won.emit(album_award)

	# 3. Categoria: Miglior Band dal Vivo (Best Live Band)
	var live_won: bool = player_data.popularity >= 60.0 and player_data.reputation >= 65.0
	var live_award := {
		"category": Enums.MusicAwardCategory.BEST_LIVE_BAND,
		"category_name": Enums.get_award_category_name(Enums.MusicAwardCategory.BEST_LIVE_BAND),
		"won": live_won,
		"title": player_data.band_name,
		"winner_name": player_data.band_name if live_won else "Velvet Thunder"
	}
	results["awards"].append(live_award)
	if live_won:
		player_data.add_music_award(live_award)
		EventBus.award_won.emit(live_award)

	# 4. Categoria: Miglior Produttore Musicale (Best Producer)
	var prod_level: int = player_data.get_skill_level("production")
	var prod_won: bool = prod_level >= 70
	var prod_award := {
		"category": Enums.MusicAwardCategory.BEST_PRODUCER,
		"category_name": Enums.get_award_category_name(Enums.MusicAwardCategory.BEST_PRODUCER),
		"won": prod_won,
		"title": "Produzione e Mastering Discografico",
		"winner_name": player_data.player_name if prod_won else "SoundMaster Pro London"
	}
	results["awards"].append(prod_award)
	if prod_won:
		player_data.add_music_award(prod_award)
		EventBus.award_won.emit(prod_award)

	EventBus.music_awards_ceremony_held.emit(results)

	var speech: String = "CERIMONIA WORLD MUSIC AWARDS ANNO %d: Hai conquistato %d statuette!" % [
		year,
		player_data.music_awards.size()
	]
	AccessibilityManager.announce(speech, true)
	return results
