# res://data/models/band_member_data.gd
class_name BandMemberData
extends RefCounted

## Modello Dati di un Membro della Band per World-tour (V2.0)
## Traccia l'identità, lo strumento, la personalità, il livello tecnico
## e i 3 indicatori psicologici di gruppo: Affinità, Rispetto e Tensione.

var id: String = ""
var member_name: String = ""
var role: int = Enums.BandRole.BASS
var personality: int = Enums.BandPersonality.RELIABLE
var preferred_genre: int = Enums.MusicalGenre.ROCK
var skill_level: int = 10
var affinity: float = 50.0        # 0.0 - 100.0 (affinità umana e sintonia)
var musical_respect: float = 50.0 # 0.0 - 100.0 (riconoscimento del talento e leadership)
var tension: float = 0.0          # 0.0 - 100.0 (conflitti e attriti interni)
var is_active: bool = true
var joined_day: int = 1

func _init(
	p_id: String = "",
	p_name: String = "",
	p_role: int = Enums.BandRole.BASS,
	p_personality: int = Enums.BandPersonality.RELIABLE,
	p_genre: int = Enums.MusicalGenre.ROCK,
	p_skill: int = 10
) -> void:
	if p_id.is_empty():
		id = "member_%d_%d" % [Time.get_ticks_msec(), randi() % 10000]
	else:
		id = p_id
	member_name = p_name
	role = p_role
	personality = p_personality
	preferred_genre = p_genre
	skill_level = p_skill

func get_role_name() -> String:
	match role:
		Enums.BandRole.BASS:
			return tr("ROLE_BASS")
		Enums.BandRole.DRUMS:
			return tr("ROLE_DRUMS")
		Enums.BandRole.KEYBOARDS:
			return tr("ROLE_KEYBOARDS")
		Enums.BandRole.GUITAR_RHYTHM:
			return tr("ROLE_GUITAR_RHYTHM")
		Enums.BandRole.VOCALS:
			return tr("ROLE_VOCALS")
		_:
			return tr("ROLE_BASS")

func get_personality_name() -> String:
	match personality:
		Enums.BandPersonality.RELIABLE:
			return tr("PERSONALITY_RELIABLE")
		Enums.BandPersonality.PERFECTIONIST:
			return tr("PERSONALITY_PERFECTIONIST")
		Enums.BandPersonality.WILD_PARTY:
			return tr("PERSONALITY_WILD_PARTY")
		Enums.BandPersonality.EGO_ARTIST:
			return tr("PERSONALITY_EGO_ARTIST")
		Enums.BandPersonality.MERCENARY:
			return tr("PERSONALITY_MERCENARY")
		Enums.BandPersonality.STAGE_ANXIOUS:
			return tr("PERSONALITY_STAGE_ANXIOUS")
		Enums.BandPersonality.NATURAL_LEADER:
			return tr("PERSONALITY_NATURAL_LEADER")
		Enums.BandPersonality.PEACEMAKER:
			return tr("PERSONALITY_PEACEMAKER")
		_:
			return tr("PERSONALITY_RELIABLE")

func get_genre_name() -> String:
	match preferred_genre:
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
			return tr("GENRE_ROCK")

func modify_affinity(delta: float) -> void:
	affinity = clampf(affinity + delta, 0.0, 100.0)

func modify_respect(delta: float) -> void:
	musical_respect = clampf(musical_respect + delta, 0.0, 100.0)

func modify_tension(delta: float) -> void:
	tension = clampf(tension + delta, 0.0, 100.0)

func adjust_affinity(delta: float) -> void:
	modify_affinity(delta)

func adjust_respect(delta: float) -> void:
	modify_respect(delta)

func adjust_tension(delta: float) -> void:
	modify_tension(delta)

var respect: float:
	get:
		return musical_respect
	set(value):
		musical_respect = value

func is_threatening_to_quit() -> bool:
	return tension >= Constants.BAND_TENSION_CRITICAL

func to_dict() -> Dictionary:
	return {
		"id": id,
		"member_name": member_name,
		"role": role,
		"personality": personality,
		"preferred_genre": preferred_genre,
		"skill_level": skill_level,
		"affinity": affinity,
		"musical_respect": musical_respect,
		"tension": tension,
		"is_active": is_active,
		"joined_day": joined_day
	}

func from_dict(data: Dictionary) -> void:
	id = str(data.get("id", id))
	member_name = str(data.get("member_name", member_name))
	role = int(data.get("role", role))
	personality = int(data.get("personality", personality))
	preferred_genre = int(data.get("preferred_genre", preferred_genre))
	skill_level = int(data.get("skill_level", skill_level))
	affinity = float(data.get("affinity", affinity))
	musical_respect = float(data.get("musical_respect", musical_respect))
	tension = float(data.get("tension", tension))
	is_active = bool(data.get("is_active", is_active))
	joined_day = int(data.get("joined_day", joined_day))
