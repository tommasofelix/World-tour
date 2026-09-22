# res://systems/music_system.gd
class_name MusicSystem
extends RefCounted

## Motore del Ciclo Creativo e della Produzione Discografica per World-tour
## Governa la pipeline in 5 stadi, la generazione del Quality Score, i Tratti Emergenti e il rilascio dei Singoli.

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

## Stadio 1: Concetto, Genere e Titolo
func create_draft(title: String, genre: int, theme: String = "love") -> SongData:
	var s_title := title.strip_edges()
	if s_title.is_empty():
		s_title = "Untitled %s Track" % Enums.MusicalGenre.keys()[genre].capitalize()
		
	var song := SongData.new("", s_title, genre, theme)
	song.status = Enums.SongStatus.DRAFT
	song.stage = Enums.SongStage.CONCEPT
	
	if player_data:
		player_data.add_song(song)
		
	EventBus.song_created.emit(song.to_dict())
	return song

## Stadio 2: Composizione Riff & Armonia
func work_on_composition(song: SongData, is_inspiration_burst: bool = false) -> Dictionary:
	if not player_data.consume_energy(15):
		return {"success": false, "reason": "energy_insufficient"}
		
	player_data.add_stress(5)
	
	var base_comp: float = float(skill_system.get_skill_level("composition")) if skill_system else 10.0
	var burst_bonus: float = 5.0 if is_inspiration_burst else 0.0
	song.comp_skill_used = base_comp + burst_bonus
	song.inspiration_bonus = burst_bonus
	song.stage = Enums.SongStage.COMPOSITION
	
	if skill_system:
		skill_system.add_xp("composition", 15.0)
		
	EventBus.song_stage_completed.emit(song.id, song.stage)
	return {"success": true, "comp_skill_used": song.comp_skill_used}

## Stadio 3: Scrittura Testo & Liriche
func work_on_lyrics(song: SongData) -> Dictionary:
	if not player_data.consume_energy(10):
		return {"success": false, "reason": "energy_insufficient"}
		
	player_data.add_stress(3)
	
	var base_lyrics: float = float(skill_system.get_skill_level("songwriting")) if skill_system else 10.0
	song.lyrics_skill_used = base_lyrics
	song.stage = Enums.SongStage.SONGWRITING
	
	if skill_system:
		skill_system.add_xp("songwriting", 12.0)
		
	EventBus.song_stage_completed.emit(song.id, song.stage)
	return {"success": true, "lyrics_skill_used": song.lyrics_skill_used}

## Stadio 4: Registrazione Tracce (Home Studio vs Studio Pro)
func record_tracks(song: SongData, use_pro_studio: bool = false) -> Dictionary:
	if not player_data.consume_energy(25):
		return {"success": false, "reason": "energy_insufficient"}
		
	if use_pro_studio:
		if player_data.money < 50.0:
			return {"success": false, "reason": "money_insufficient"}
		player_data.modify_money(-50.0)
		EventBus.money_changed.emit(player_data.money, -50.0, "studio_fee")
		song.studio_bonus = 15.0
	else:
		song.studio_bonus = 0.0
		
	player_data.add_stress(8)
	
	var base_exec: float = float(skill_system.get_skill_level("instrument")) if skill_system else 10.0
	# Se Home Studio, c'è un tetto massimo di resa esecutiva grezza di 60
	if not use_pro_studio:
		base_exec = minf(base_exec, 60.0)
		
	song.exec_skill_used = base_exec
	song.stage = Enums.SongStage.RECORDING
	
	if skill_system:
		skill_system.add_xp("instrument", 20.0)
		
	EventBus.song_stage_completed.emit(song.id, song.stage)
	return {"success": true, "exec_skill_used": song.exec_skill_used, "studio_bonus": song.studio_bonus}

## Stadio 5: Missaggio, Mastering & Determinazione Qualità Finale
func mix_and_master(song: SongData) -> Dictionary:
	if not player_data.consume_energy(15):
		return {"success": false, "reason": "energy_insufficient"}
		
	player_data.add_stress(5)
	
	var base_prod: float = float(skill_system.get_skill_level("production")) if skill_system else 10.0
	song.prod_skill_used = base_prod
	
	if skill_system:
		skill_system.add_xp("production", 15.0)
		
	# Calcolo Quality Score tramite la formula convalidata di SP-06
	var final_quality: float = Formulas.calculate_song_quality(
		song.comp_skill_used,
		song.lyrics_skill_used,
		song.exec_skill_used,
		song.prod_skill_used,
		song.studio_bonus,
		float(player_data.morale) if player_data else 100.0
	)
	song.quality_score = final_quality
	
	# Estrazione probabilistica del tratto emergente (Song Traits)
	song.special_trait = _roll_special_trait(song)
	
	song.status = Enums.SongStatus.PRODUCED
	song.stage = Enums.SongStage.COMPLETED
	
	EventBus.song_stage_completed.emit(song.id, song.stage)
	return {
		"success": true,
		"quality_score": song.quality_score,
		"special_trait": song.special_trait
	}

## Pubblicazione del brano sul mercato come Singolo
func release_single(song_id: String) -> Dictionary:
	var song: SongData = player_data.get_song_by_id(song_id)
	if not song:
		return {"success": false, "reason": "song_not_found"}
		
	if song.status != Enums.SongStatus.PRODUCED:
		return {"success": false, "reason": "song_not_produced"}
		
	song.status = Enums.SongStatus.RELEASED
	song.release_day = calendar_data.day_number if calendar_data else 1
	
	# Calcolo ricompense release singolo (fan, popolarità, reputazione, introito)
	var fan_gain: int = int(round(song.quality_score * 0.8))
	if song.special_trait == Enums.SongTrait.EARWORM:
		fan_gain = int(round(float(fan_gain) * 1.5))
	player_data.fans += fan_gain
	player_data.popularity = clampf(player_data.popularity + 2.0, 0.0, 100.0)
	player_data.reputation = clampf(player_data.reputation + (song.quality_score / 20.0), 0.0, 100.0)
	
	var initial_rev: float = round(song.quality_score * 2.5 * 100.0) / 100.0
	song.revenue += initial_rev
	player_data.modify_money(initial_rev)
	EventBus.money_changed.emit(player_data.money, initial_rev, "single_release_revenue")
	
	EventBus.song_released.emit(song.to_dict())
	
	var msg: String = tr("MSG_SONG_RELEASED") % [song.title, song.quality_score]
	AccessibilityManager.announce(msg, true)
	
	return {"success": true, "song": song}

func _roll_special_trait(song: SongData) -> int:
	# Audiophile Gem richiede produzione elevata (>= 70)
	if song.prod_skill_used >= 70.0 and randf() < 0.25:
		return Enums.SongTrait.AUDIOPHILE_GEM
		
	var roll := randf()
	if roll < 0.08:
		return Enums.SongTrait.EARWORM
	elif roll < 0.16:
		return Enums.SongTrait.STAGE_BEAST
	elif roll < 0.24:
		return Enums.SongTrait.CULT_CLASSIC
	elif roll < 0.32 and song.studio_bonus == 0.0 and song.comp_skill_used >= 30.0:
		return Enums.SongTrait.ROUGH_DIAMOND
		
	return Enums.SongTrait.NONE
