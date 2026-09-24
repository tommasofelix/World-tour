# res://data/models/lyric_theme_data.gd
class_name LyricThemeData
extends RefCounted

## Modello Dati Puro per le Tematiche Liriche di World-tour (Sezione 2)
## Definisce i 10 temi lirici, le affinità con i generi musicali e la risonanza territoriale.

var id: String = ""
var name_key: String = ""
var desc_key: String = ""
var preferred_genres: Array = []
var negative_genres: Array = []
var city_resonance: Array = []

func _init(
	p_id: String = "",
	p_name_key: String = "",
	p_desc_key: String = "",
	p_preferred: Array = [],
	p_negative: Array = [],
	p_resonance: Array = []
) -> void:
	id = p_id
	name_key = p_name_key
	desc_key = p_desc_key
	preferred_genres = p_preferred
	negative_genres = p_negative
	city_resonance = p_resonance

func get_localized_name() -> String:
	return tr(name_key)

func get_localized_description() -> String:
	return tr(desc_key)

static func _make(
	p_id: String,
	p_name_key: String,
	p_desc_key: String,
	p_preferred: Array,
	p_negative: Array = [],
	p_resonance: Array = []
):
	var script_res = load("res://data/models/lyric_theme_data.gd")
	return script_res.new(p_id, p_name_key, p_desc_key, p_preferred, p_negative, p_resonance)

static func get_all_themes() -> Array:
	var themes: Array = [
		_make(
			"love",
			"THEME_LOVE",
			"THEME_DESC_LOVE",
			[Enums.MusicalGenre.POP, Enums.MusicalGenre.INDIE, Enums.MusicalGenre.ROCK],
			[],
			[Enums.CityId.NAPOLI, Enums.CityId.ROMA]
		),
		_make(
			"rebellion",
			"THEME_REBELLION",
			"THEME_DESC_REBELLION",
			[Enums.MusicalGenre.ROCK, Enums.MusicalGenre.METAL, Enums.MusicalGenre.HIPHOP],
			[Enums.MusicalGenre.POP],
			[Enums.CityId.BOLOGNA, Enums.CityId.LONDRA]
		),
		_make(
			"melancholy",
			"THEME_MELANCHOLY",
			"THEME_DESC_MELANCHOLY",
			[Enums.MusicalGenre.INDIE, Enums.MusicalGenre.ROCK, Enums.MusicalGenre.POP],
			[],
			[Enums.CityId.LONDRA, Enums.CityId.BOLOGNA]
		),
		_make(
			"success",
			"THEME_SUCCESS",
			"THEME_DESC_SUCCESS",
			[Enums.MusicalGenre.HIPHOP, Enums.MusicalGenre.POP, Enums.MusicalGenre.ELECTRONIC],
			[Enums.MusicalGenre.INDIE],
			[Enums.CityId.MILANO, Enums.CityId.LONDRA]
		),
		_make(
			"night",
			"THEME_NIGHT",
			"THEME_DESC_NIGHT",
			[Enums.MusicalGenre.ELECTRONIC, Enums.MusicalGenre.POP, Enums.MusicalGenre.INDIE],
			[],
			[Enums.CityId.BERLINO, Enums.CityId.MILANO]
		),
		_make(
			"social_anger",
			"THEME_SOCIAL_ANGER",
			"THEME_DESC_SOCIAL_ANGER",
			[Enums.MusicalGenre.METAL, Enums.MusicalGenre.ROCK, Enums.MusicalGenre.HIPHOP],
			[Enums.MusicalGenre.POP],
			[Enums.CityId.BOLOGNA, Enums.CityId.BERLINO]
		),
		_make(
			"cursed_love",
			"THEME_CURSED_LOVE",
			"THEME_DESC_CURSED_LOVE",
			[Enums.MusicalGenre.METAL, Enums.MusicalGenre.ROCK, Enums.MusicalGenre.INDIE],
			[],
			[Enums.CityId.NAPOLI, Enums.CityId.ROMA]
		),
		_make(
			"youth_nostalgia",
			"THEME_YOUTH_NOSTALGIA",
			"THEME_DESC_YOUTH_NOSTALGIA",
			[Enums.MusicalGenre.INDIE, Enums.MusicalGenre.POP, Enums.MusicalGenre.ROCK],
			[],
			[Enums.CityId.BOLOGNA, Enums.CityId.ROMA]
		),
		_make(
			"escapism",
			"THEME_ESCAPISM",
			"THEME_DESC_ESCAPISM",
			[Enums.MusicalGenre.ELECTRONIC, Enums.MusicalGenre.INDIE, Enums.MusicalGenre.ROCK],
			[],
			[Enums.CityId.BERLINO, Enums.CityId.LONDRA]
		),
		_make(
			"political_satire",
			"THEME_POLITICAL_SATIRE",
			"THEME_DESC_POLITICAL_SATIRE",
			[Enums.MusicalGenre.HIPHOP, Enums.MusicalGenre.INDIE, Enums.MusicalGenre.ROCK],
			[Enums.MusicalGenre.POP],
			[Enums.CityId.BOLOGNA, Enums.CityId.ROMA]
		)
	]
	return themes

static func get_theme_by_id(theme_id: String) -> RefCounted:
	for t in get_all_themes():
		if t.id == theme_id:
			return t
	return get_all_themes()[0] # Fallback su love

static func get_affinity_for_genre(theme_id: String, genre: int) -> float:
	var theme_data = get_theme_by_id(theme_id)
	if genre in theme_data.preferred_genres:
		return Constants.SONG_THEME_SYNERGY_HIGH
	elif genre in theme_data.negative_genres:
		return Constants.SONG_THEME_SYNERGY_LOW
	return Constants.SONG_THEME_SYNERGY_NEUTRAL
