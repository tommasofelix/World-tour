# res://data/models/song_data.gd
class_name SongData
extends RefCounted

## Modello Dati del Brano Musicale per World-tour
## Rappresenta una canzone attraverso le 5 fasi di lavorazione, il rilascio e la permanenza in catalogo.

const LyricThemeData = preload("res://data/models/lyric_theme_data.gd")

var id: String = ""
var title: String = "Untitled Track"
var genre: int = Enums.MusicalGenre.ROCK
var status: int = Enums.SongStatus.DRAFT
var stage: int = Enums.SongStage.CONCEPT
var theme: String = "love"

# Punteggi e parametri componenti
var comp_skill_used: float = 10.0
var lyrics_skill_used: float = 10.0
var exec_skill_used: float = 10.0
var prod_skill_used: float = 10.0
var studio_bonus: float = 0.0
var inspiration_bonus: float = 0.0
var quality_score: float = 0.0
var is_cover: bool = false

# Songwriting Artigianale, Doppia Barra, Strumento Dominante & Rifinitura (Popomundo Inspired - V5.9.0)
var music_progress: float = 0.0 # 0.0 - 100.0
var lyrics_progress: float = 0.0 # 0.0 - 100.0
var dominant_instrument: String = "guitar" # discipline Ramo 2
var archetype: String = "standard" # anthem, ballad, riff, standard, experimental
var complexity: int = 1 # 0: semplice, 1: standard, 2: virtuosa
var polishing_status: int = 0 # 0: in_progress, 1: orange, 2: green_masterpiece, 3: standard_finalized
var polishing_hours_remaining: float = 0.0
var inspiration_invested: int = 0
var mastery_live: float = 20.0 # 20.0 - 100.0
var last_played_day: int = 0

# Tratto speciale emergente
var traits: Array[int] = []
var special_trait: int:
	get:
		return traits[0] if traits.size() > 0 else Enums.SongTrait.NONE
	set(val):
		traits.clear()
		if val != Enums.SongTrait.NONE:
			traits.append(val)

# Metriche di mercato e catalogo
var release_day: int = 0
var plays: int = 0
var plays_count: int:
	get: return plays
	set(val): plays = val

var is_released: bool:
	get: return status == Enums.SongStatus.RELEASED

var revenue: float = 0.0
var revenue_generated: float:
	get: return revenue
	set(val): revenue = val

var recorded_in_pro_studio: bool:
	get: return studio_bonus > 0.0
	set(val): studio_bonus = 15.0 if val else 0.0

func _init(
	p_id: String = "",
	p_title: String = "Untitled Track",
	p_genre: int = Enums.MusicalGenre.ROCK,
	p_theme: String = "love"
) -> void:
	if p_id.is_empty():
		id = "song_%d_%d" % [Time.get_ticks_msec(), randi() % 10000]
	else:
		id = p_id
	title = p_title
	genre = p_genre
	theme = p_theme

func is_ready_for_polishing() -> bool:
	return music_progress >= 100.0 and lyrics_progress >= 100.0 and polishing_status == 0

func is_orange_polishing() -> bool:
	return polishing_status == 1

func is_masterpiece() -> bool:
	return polishing_status == 2

func to_dict() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"genre": genre,
		"status": status,
		"stage": stage,
		"theme": theme,
		"comp_skill_used": comp_skill_used,
		"lyrics_skill_used": lyrics_skill_used,
		"exec_skill_used": exec_skill_used,
		"prod_skill_used": prod_skill_used,
		"studio_bonus": studio_bonus,
		"inspiration_bonus": inspiration_bonus,
		"quality_score": quality_score,
		"special_trait": special_trait,
		"traits": [special_trait] if special_trait != Enums.SongTrait.NONE else [],
		"recorded_in_pro_studio": recorded_in_pro_studio,
		"release_day": release_day,
		"plays": plays,
		"plays_count": plays,
		"revenue": revenue,
		"revenue_generated": revenue,
		"is_cover": is_cover,
		"music_progress": music_progress,
		"lyrics_progress": lyrics_progress,
		"dominant_instrument": dominant_instrument,
		"archetype": archetype,
		"complexity": complexity,
		"polishing_status": polishing_status,
		"polishing_hours_remaining": polishing_hours_remaining,
		"inspiration_invested": inspiration_invested,
		"mastery_live": mastery_live,
		"last_played_day": last_played_day
	}

func from_dict(dict: Dictionary) -> void:
	id = str(dict.get("id", id))
	title = str(dict.get("title", title))
	genre = int(dict.get("genre", genre))
	status = int(dict.get("status", status))
	stage = int(dict.get("stage", stage))
	theme = str(dict.get("theme", theme))
	comp_skill_used = float(dict.get("comp_skill_used", comp_skill_used))
	lyrics_skill_used = float(dict.get("lyrics_skill_used", lyrics_skill_used))
	exec_skill_used = float(dict.get("exec_skill_used", exec_skill_used))
	prod_skill_used = float(dict.get("prod_skill_used", prod_skill_used))
	studio_bonus = float(dict.get("studio_bonus", studio_bonus))
	if dict.has("recorded_in_pro_studio") and bool(dict["recorded_in_pro_studio"]):
		studio_bonus = 15.0
	inspiration_bonus = float(dict.get("inspiration_bonus", inspiration_bonus))
	quality_score = float(dict.get("quality_score", quality_score))
	is_cover = bool(dict.get("is_cover", is_cover))
	music_progress = float(dict.get("music_progress", music_progress))
	lyrics_progress = float(dict.get("lyrics_progress", lyrics_progress))
	dominant_instrument = str(dict.get("dominant_instrument", dominant_instrument))
	archetype = str(dict.get("archetype", archetype))
	complexity = int(dict.get("complexity", complexity))
	polishing_status = int(dict.get("polishing_status", polishing_status))
	polishing_hours_remaining = float(dict.get("polishing_hours_remaining", polishing_hours_remaining))
	inspiration_invested = int(dict.get("inspiration_invested", inspiration_invested))
	mastery_live = float(dict.get("mastery_live", mastery_live))
	last_played_day = int(dict.get("last_played_day", last_played_day))
	traits.clear()
	if dict.has("traits") and dict["traits"] is Array:
		for t in dict["traits"]:
			traits.append(int(t))
	elif dict.has("special_trait") and int(dict["special_trait"]) != Enums.SongTrait.NONE:
		traits.append(int(dict["special_trait"]))
	release_day = int(dict.get("release_day", release_day))
	plays = int(dict.get("plays", dict.get("plays_count", plays)))
	revenue = float(dict.get("revenue", dict.get("revenue_generated", revenue)))

static func create_cover_song(p_genre: int, skill_level: float = 10.0) -> SongData:
	var cover_title := "Cover Hit di Repertorio"
	match p_genre:
		Enums.MusicalGenre.ROCK:
			cover_title = "Classic Rock Anthem (Cover)"
		Enums.MusicalGenre.POP:
			cover_title = "Pop Radio Banger (Cover)"
		Enums.MusicalGenre.METAL:
			cover_title = "Heavy Metal Riff (Cover)"
		Enums.MusicalGenre.INDIE:
			cover_title = "Underground Indie Hit (Cover)"
		Enums.MusicalGenre.ELECTRONIC:
			cover_title = "Club Electro Beat (Cover)"
		Enums.MusicalGenre.HIPHOP:
			cover_title = "Old School Hip Hop (Cover)"
	var song := SongData.new("cover_%d_%d" % [Time.get_ticks_msec(), randi() % 1000], cover_title, p_genre, "life")
	song.status = Enums.SongStatus.RELEASED
	song.stage = Enums.SongStage.COMPLETED
	song.is_cover = true
	song.quality_score = clampf(55.0 + (skill_level * 0.30), 55.0, 85.0)
	return song

func get_genre_name() -> String:
	match genre:
		Enums.MusicalGenre.ROCK:
			return tr("GENRE_ROCK")
		Enums.MusicalGenre.POP:
			return tr("GENRE_POP")
		Enums.MusicalGenre.METAL:
			return tr("GENRE_METAL")
		Enums.MusicalGenre.HIPHOP:
			return tr("GENRE_HIPHOP")
		Enums.MusicalGenre.ELECTRONIC:
			return tr("GENRE_ELECTRONIC")
		Enums.MusicalGenre.INDIE:
			return tr("GENRE_INDIE")
		_:
			return "Rock"

func get_status_name() -> String:
	match status:
		Enums.SongStatus.DRAFT:
			return tr("STATUS_DRAFT")
		Enums.SongStatus.PRODUCED:
			return tr("STATUS_PRODUCED")
		Enums.SongStatus.RELEASED:
			return tr("STATUS_RELEASED")
		_:
			return "Bozza"

func get_trait_name() -> String:
	match special_trait:
		Enums.SongTrait.EARWORM:
			return tr("TRAIT_EARWORM")
		Enums.SongTrait.CULT_CLASSIC:
			return tr("TRAIT_CULT_CLASSIC")
		Enums.SongTrait.STAGE_BEAST:
			return tr("TRAIT_STAGE_BEAST")
		Enums.SongTrait.AUDIOPHILE_GEM:
			return tr("TRAIT_AUDIOPHILE_GEM")
		Enums.SongTrait.ROUGH_DIAMOND:
			return tr("TRAIT_ROUGH_DIAMOND")
		Enums.SongTrait.GENERATIONAL_ANTHEM:
			return tr("TRAIT_GENERATIONAL_ANTHEM")
		Enums.SongTrait.TEARJERKER_BALLAD:
			return tr("TRAIT_TEARJERKER_BALLAD")
		Enums.SongTrait.EPIC_RIFF:
			return tr("TRAIT_EPIC_RIFF")
		_:
			return tr("TRAIT_NONE")

func get_theme_name() -> String:
	var theme_obj := LyricThemeData.get_theme_by_id(theme)
	return theme_obj.get_localized_name()

func get_stage_name() -> String:
	match stage:
		Enums.SongStage.CONCEPT:
			return tr("STAGE_CONCEPT")
		Enums.SongStage.COMPOSITION:
			return tr("STAGE_COMPOSITION")
		Enums.SongStage.SONGWRITING:
			return tr("STAGE_SONGWRITING")
		Enums.SongStage.RECORDING:
			return tr("STAGE_RECORDING")
		Enums.SongStage.MIXING:
			return tr("STAGE_MIXING")
		Enums.SongStage.COMPLETED:
			return tr("STAGE_COMPLETED")
		_:
			return tr("STAGE_CONCEPT")

