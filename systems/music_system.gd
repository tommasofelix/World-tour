# res://systems/music_system.gd
class_name MusicSystem
extends RefCounted

## Motore del Ciclo Creativo e della Produzione Discografica per World-tour
## Governa la pipeline in 5 stadi, la generazione del Quality Score, i Tratti Emergenti e il rilascio dei Singoli.
const UpgradeData = preload("res://data/models/upgrade_data.gd")

var player_data: PlayerData
var calendar_data: CalendarData
var skill_system: SkillSystem
var time_system: TimeSystem:
	get:
		if _time_system != null:
			return _time_system
		if GameManager and GameManager.time_system:
			return GameManager.time_system
		return null
	set(val):
		_time_system = val
var _time_system: TimeSystem = null

func _init(p_player_data: PlayerData, p_arg2: Variant = null, p_arg3: Variant = null, p_arg4: Variant = null) -> void:
	player_data = p_player_data
	for arg in [p_arg2, p_arg3, p_arg4]:
		if arg is CalendarData:
			calendar_data = arg
		elif arg is SkillSystem:
			skill_system = arg
		elif arg is TimeSystem:
			_time_system = arg

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

# ==============================================================================
# SONGWRITING ARTIGIANALE, DOPPIA BARRA E RIFINITURA (V5.9.0 / Popomundo Inspired)
# ==============================================================================

## Avvia un nuovo cantiere di songwriting artigianale (massimo 3 cantieri aperti)
func start_crafting_project(title: String, genre: int, theme: String = "love", dominant_inst: String = "guitar", archetype: String = "standard", initial_inspiration: int = 0) -> Dictionary:
	if player_data:
		var open_drafts: Array[SongData] = player_data.get_active_draft_songs()
		if open_drafts.size() >= 3:
			return {
				"success": false,
				"reason": "draft_cap_reached",
				"message": "Hai già 3 progetti aperti nel cassetto. Completa o archivia una bozza prima di iniziarne un'altra."
			}
			
		if initial_inspiration > 0:
			if not player_data.consume_inspiration(initial_inspiration):
				return {
					"success": false,
					"reason": "inspiration_insufficient",
					"message": "Punti Ispirazione insufficienti per iniziare con questo slancio."
				}

	var s_title := title.strip_edges()
	if s_title.is_empty():
		s_title = "Nuovo Progetto %s" % Enums.MusicalGenre.keys()[genre].capitalize()

	var song := SongData.new("", s_title, genre, theme)
	song.status = Enums.SongStatus.DRAFT
	song.stage = Enums.SongStage.COMPOSITION
	song.dominant_instrument = dominant_inst
	song.archetype = archetype
	song.inspiration_invested = initial_inspiration
	var initial_boost: float = float(initial_inspiration) * 10.0
	song.music_progress = clampf(initial_boost, 0.0, 100.0)
	song.lyrics_progress = clampf(initial_boost, 0.0, 100.0)
	song.polishing_status = 0
	song.polishing_hours_remaining = 0.0
	song.mastery_live = 20.0

	var in_burnout: bool = player_data.is_in_creative_burnout() if player_data else false

	if player_data:
		player_data.add_song(song)

	EventBus.song_created.emit(song.to_dict())
	return {
		"success": true,
		"song": song,
		"burnout_warning": in_burnout
	}

## Lavora sull'avanzamento della componente musicale (accordi, riff, melodia)
func work_on_music_progress(song_id: String, hours: float = 1.0) -> Dictionary:
	var song: SongData = player_data.get_song_by_id(song_id) if player_data else null
	if not song:
		return {"success": false, "reason": "song_not_found"}

	if not song.can_work_music_today():
		return {
			"success": false,
			"reason": "daily_limit_reached",
			"message": "Hai dato il massimo sulla musica di questo brano per oggi! Lascia decantare le idee fino a domani o dedicati ad un altro cantiere."
		}

	if not player_data or not player_data.consume_energy(15):
		return {"success": false, "reason": "energy_insufficient"}

	var in_burnout: bool = player_data.is_in_creative_burnout()
	var is_second_session: bool = (song.daily_music_sessions == 1)
	var rendement_mult: float = 0.50 if is_second_session else 1.0

	var stress_gain: int = (12 if in_burnout else 6) if is_second_session else (8 if in_burnout else 4)
	player_data.add_stress(stress_gain)

	var base_gain: float = 8.0
	var skill_harmony: float = float(player_data.get_skill_level("comp_theory"))
	var musicality: float = float(player_data.musicality)
	var gain: float = (base_gain + (skill_harmony * 0.20) + (musicality * 0.10)) * hours * rendement_mult
	if in_burnout:
		gain *= 0.70

	song.music_progress = clampf(song.music_progress + gain, 0.0, 100.0)
	song.comp_skill_used = maxf(song.comp_skill_used, skill_harmony)
	song.daily_music_sessions += 1

	if player_data:
		player_data.add_xp_to_skill("comp_theory", 15.0 if not is_second_session else 8.0)
		player_data.add_xp_to_skill("comp_riffs", 10.0 if not is_second_session else 5.0)

	var active_time: TimeSystem = time_system
	if active_time:
		active_time.advance_virtual_hours(2.0)

	var ready_now: bool = (song.music_progress >= 100.0 and song.lyrics_progress >= 100.0 and song.polishing_status == 0)
	if ready_now:
		song.polishing_status = 1 # ORANGE
		song.polishing_hours_remaining = 36.0
		AccessibilityManager.announce("Ispirazione al vertice! Entrambe le componenti sono al 100%%: %s entra nella Finestra di Rifinitura Arancione (36 ore)!" % song.title, true)

	return {
		"success": true,
		"song": song,
		"music_progress": song.music_progress,
		"gain": gain,
		"is_second_session": is_second_session,
		"polishing_status": song.polishing_status,
		"polishing_hours_remaining": song.polishing_hours_remaining
	}

## Lavora sull'avanzamento del testo (liriche, rime, metrica)
func work_on_lyrics_progress(song_id: String, hours: float = 1.0) -> Dictionary:
	var song: SongData = player_data.get_song_by_id(song_id) if player_data else null
	if not song:
		return {"success": false, "reason": "song_not_found"}

	if not song.can_work_lyrics_today():
		return {
			"success": false,
			"reason": "daily_limit_reached",
			"message": "Hai dato il massimo sui testi di questo brano per oggi! Lascia decantare le rime fino a domani o dedicati ad un altro cantiere."
		}

	if not player_data or not player_data.consume_energy(10):
		return {"success": false, "reason": "energy_insufficient"}

	var in_burnout: bool = player_data.is_in_creative_burnout()
	var is_second_session: bool = (song.daily_lyrics_sessions == 1)
	var rendement_mult: float = 0.50 if is_second_session else 1.0

	var stress_gain: int = (9 if in_burnout else 5) if is_second_session else (6 if in_burnout else 3)
	player_data.add_stress(stress_gain)

	var base_gain: float = 8.0
	var skill_lyrics: float = float(player_data.get_skill_level("comp_lyrics"))
	var intelligence: float = float(player_data.intelligence)
	var affinity: float = Formulas.calculate_theme_genre_affinity(song.theme, song.genre)
	var gain: float = (base_gain + (skill_lyrics * 0.20) + (intelligence * 0.10) + affinity) * hours * rendement_mult
	if in_burnout:
		gain *= 0.70

	song.lyrics_progress = clampf(song.lyrics_progress + gain, 0.0, 100.0)
	song.lyrics_skill_used = maxf(song.lyrics_skill_used, skill_lyrics)
	song.daily_lyrics_sessions += 1

	if player_data:
		player_data.add_xp_to_skill("comp_lyrics", 15.0 if not is_second_session else 8.0)

	var active_time: TimeSystem = time_system
	if active_time:
		active_time.advance_virtual_hours(1.5)

	var ready_now: bool = (song.music_progress >= 100.0 and song.lyrics_progress >= 100.0 and song.polishing_status == 0)
	if ready_now:
		song.polishing_status = 1 # ORANGE
		song.polishing_hours_remaining = 36.0
		AccessibilityManager.announce("Ispirazione al vertice! Entrambe le componenti sono al 100%%: %s entra nella Finestra di Rifinitura Arancione (36 ore)!" % song.title, true)

	return {
		"success": true,
		"song": song,
		"lyrics_progress": song.lyrics_progress,
		"gain": gain,
		"is_second_session": is_second_session,
		"polishing_status": song.polishing_status,
		"polishing_hours_remaining": song.polishing_hours_remaining
	}

## Tenta il Colpo d'Ala spendendo Punti Ispirazione durante la finestra arancione
func attempt_polishing_burst(song_id: String, inspiration_spent: int) -> Dictionary:
	var song: SongData = player_data.get_song_by_id(song_id) if player_data else null
	if not song:
		return {"success": false, "reason": "song_not_found"}

	if song.polishing_status != 1:
		return {
			"success": false,
			"reason": "not_in_orange_window",
			"message": "Il brano non si trova nella finestra di rifinitura arancione."
		}

	if inspiration_spent < 1 or not player_data or player_data.inspiration_points < inspiration_spent:
		return {
			"success": false,
			"reason": "inspiration_insufficient",
			"message": "Punti Ispirazione insufficienti per tentare il Colpo d'Ala."
		}

	player_data.consume_inspiration(inspiration_spent)
	var prior_invested: int = song.inspiration_invested
	song.inspiration_invested += inspiration_spent

	var base_chance: float = 0.25 + (float(inspiration_spent - 1) * 0.25) + (float(prior_invested) * 0.05) + (float(player_data.musicality) / 200.0)
	var final_chance: float = clampf(base_chance, 0.10, 0.95)
	var is_success: bool = (randf() <= final_chance)

	if is_success:
		song.polishing_status = 2 # GREEN_MASTERPIECE
		song.inspiration_bonus += 20.0
		song.stage = Enums.SongStage.RECORDING
		player_data.creative_burnout_days = 4
		AccessibilityManager.announce("COLPO D'ALA TRIONFALE! %s diventa un Capolavoro Verde Brillante (+20 Qualità)! Alex entra in svuotamento creativo per 4 giorni." % song.title, true)
		return {
			"success": true,
			"is_masterpiece": true,
			"quality_bonus": 20.0,
			"burnout_days": 4
		}
	else:
		song.polishing_status = 3 # STANDARD_FINALIZED
		song.inspiration_bonus += 5.0
		song.stage = Enums.SongStage.RECORDING
		AccessibilityManager.announce("Rifinitura completata. %s viene consolidata come traccia solida (+5 Qualità)." % song.title, true)
		return {
			"success": true,
			"is_masterpiece": false,
			"quality_bonus": 5.0,
			"burnout_days": 0
		}

## Consolida il brano arancione come traccia standard senza spendere ispirazione
func finalize_polishing_standard(song_id: String) -> Dictionary:
	var song: SongData = player_data.get_song_by_id(song_id) if player_data else null
	if not song:
		return {"success": false, "reason": "song_not_found"}

	if song.polishing_status != 1:
		return {"success": false, "reason": "not_in_orange_window"}

	song.polishing_status = 3 # STANDARD_FINALIZED
	song.stage = Enums.SongStage.RECORDING
	song.polishing_hours_remaining = 0.0
	AccessibilityManager.announce("%s consolidata come traccia standard, pronta per la registrazione!" % song.title, true)
	return {"success": true, "song": song}

## Gestisce il decadimento orario della finestra di rifinitura arancione (36 ore)
func process_hourly_polishing_decay(delta_virtual_hours: float) -> void:
	if not player_data:
		return
	for s in player_data.songs:
		if s.polishing_status == 1:
			s.polishing_hours_remaining -= delta_virtual_hours
			if s.polishing_hours_remaining <= 0.0:
				s.polishing_status = 3
				s.polishing_hours_remaining = 0.0
				s.stage = Enums.SongStage.RECORDING
				AccessibilityManager.announce("Tempo di rifinitura scaduto per %s: consolidata automaticamente come traccia standard." % s.title, true)

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

## Stadio 4: Registrazione Tracce (Home Studio vs Studio Pro, Nastro Analogico vs Digitale)
func record_tracks(song: SongData, use_pro_studio: bool = false, philosophy_override: int = -1) -> Dictionary:
	if not player_data.consume_energy(25):
		return {"success": false, "reason": "energy_insufficient"}

	var hw_tier: int = player_data.studio_hardware_tier if player_data else 0
	var hw_cap: float = UpgradeData.get_studio_hardware_cap(hw_tier)
	var hw_bonus: float = UpgradeData.get_studio_hardware_bonus(hw_tier)

	song.recorded_in_pro_studio = use_pro_studio

	if use_pro_studio:
		var studio_cost: float = 50.0
		var is_tuesday: bool = false
		if calendar_data:
			is_tuesday = (calendar_data.get_weekday() == Enums.Weekday.TUESDAY)
		if is_tuesday:
			studio_cost = 50.0 * (1.0 - Constants.TUESDAY_STUDIO_DISCOUNT)

		if player_data.money < studio_cost:
			return {"success": false, "reason": "money_insufficient"}
		player_data.modify_money(-studio_cost)
		EventBus.money_changed.emit(player_data.money, -studio_cost, "studio_fee")
		song.studio_bonus = 15.0
		if is_tuesday:
			AccessibilityManager.announce("Sconto Martedì del 20%% applicato allo Studio Professionale! Spesa: %.2f euro" % studio_cost, true)
	else:
		song.studio_bonus = hw_bonus
		var phil: int = philosophy_override
		if phil < 0 and player_data:
			phil = player_data.recording_philosophy

		if phil == UpgradeData.RecordingPhilosophy.ANALOG_TAPE:
			var tape_cost: float = Constants.ANALOG_TAPE_COST
			if player_data and player_data.money >= tape_cost:
				player_data.modify_money(-tape_cost)
				EventBus.money_changed.emit(player_data.money, -tape_cost, "analog_tape_cost")
				if song.genre == Enums.MusicalGenre.ROCK or song.genre == Enums.MusicalGenre.INDIE:
					song.studio_bonus += 5.0
				AccessibilityManager.announce("Incisione su Nastro Magnetico completata (+5 qualità calore analogico). Spesa bobine: %.2f €." % tape_cost, true)
			else:
				if song.genre == Enums.MusicalGenre.POP or song.genre == Enums.MusicalGenre.ELECTRONIC:
					song.studio_bonus += 3.0
				AccessibilityManager.announce("Fondi insufficienti per le bobine di nastro: registrazione effettuata in Digitale HD.", true)
		else:
			# Digitale HD
			if song.genre == Enums.MusicalGenre.POP or song.genre == Enums.MusicalGenre.ELECTRONIC:
				song.studio_bonus += 3.0

	player_data.add_stress(8)

	if player_data:
		var p_cat: String = player_data.get_primary_category()
		player_data.apply_instrument_wear(p_cat, 2.0)

	var base_exec: float = float(skill_system.get_skill_level("instrument")) if skill_system else 10.0
	if player_data:
		var inst_bonus: Dictionary = player_data.get_primary_instrument_bonus()
		base_exec += float(inst_bonus.get("skill_bonus", 0))

	# Se Home Studio, il tetto massimo di resa esecutiva scala con l'hardware
	if not use_pro_studio:
		base_exec = minf(base_exec, hw_cap)

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

	# Calcolo Quality Score tramite la formula convalidata integrando affinità tema-genere
	var theme_affinity: float = Formulas.calculate_theme_genre_affinity(song.theme, song.genre)
	var final_quality: float = Formulas.calculate_song_quality(
		song.comp_skill_used,
		song.lyrics_skill_used,
		song.exec_skill_used,
		song.prod_skill_used,
		song.studio_bonus,
		float(player_data.morale) if player_data else 100.0,
		0.0,
		theme_affinity
	)
	if song.inspiration_bonus > 0.0:
		final_quality = clampf(final_quality + song.inspiration_bonus, Constants.SONG_MIN_QUALITY, Constants.SONG_MAX_QUALITY)
	song.quality_score = final_quality

	# Estrazione probabilistica del tratto emergente (Song Traits)
	if song.is_masterpiece():
		var top_traits := [Enums.SongTrait.EARWORM, Enums.SongTrait.GENERATIONAL_ANTHEM, Enums.SongTrait.STAGE_BEAST, Enums.SongTrait.EPIC_RIFF]
		song.special_trait = top_traits[randi() % top_traits.size()]
	else:
		song.special_trait = _roll_special_trait(song)

	song.status = Enums.SongStatus.PRODUCED
	song.stage = Enums.SongStage.COMPLETED

	if player_data:
		player_data.increment_career_stat("total_songs_written", 1)

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

	if player_data:
		player_data.increment_career_stat("total_singles_released", 1)

	# Calcolo ricompense release singolo (fan, popolarità, reputazione, introito)
	var fan_gain: int = int(round(song.quality_score * 0.8))
	if song.special_trait == Enums.SongTrait.EARWORM:
		fan_gain = int(round(float(fan_gain) * 1.5))
	elif song.special_trait == Enums.SongTrait.GENERATIONAL_ANTHEM:
		fan_gain = int(round(float(fan_gain) * 1.3))
		player_data.reputation = clampf(player_data.reputation + Constants.TRAIT_ANTHEM_REP_BOOST, 0.0, 100.0)
	elif song.special_trait == Enums.SongTrait.TEARJERKER_BALLAD:
		player_data.morale = mini(Constants.MAX_MORALE, player_data.morale + 10)
	elif song.special_trait == Enums.SongTrait.EPIC_RIFF:
		if song.genre == Enums.MusicalGenre.ROCK or song.genre == Enums.MusicalGenre.METAL:
			fan_gain = int(round(float(fan_gain) * 1.2))

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

	# Inno Generazionale richiede composizione e testi solidi (>= 35)
	if song.comp_skill_used >= 35.0 and song.lyrics_skill_used >= 35.0 and randf() < 0.12:
		return Enums.SongTrait.GENERATIONAL_ANTHEM

	# Ballata Strappalacrime favorita da alta scrittura testi (>= 30) o temi emotivi
	if song.lyrics_skill_used >= 30.0 and (song.theme == "melancholy" or song.theme == "cursed_love" or song.theme == "love") and randf() < 0.18:
		return Enums.SongTrait.TEARJERKER_BALLAD

	# Riff Epico favorito da rock o metal ed esecuzione strumentale (>= 30)
	if (song.genre == Enums.MusicalGenre.ROCK or song.genre == Enums.MusicalGenre.METAL) and song.exec_skill_used >= 30.0 and randf() < 0.18:
		return Enums.SongTrait.EPIC_RIFF

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
