# GDD 2.0 / SP-13: Modello Dati per Band e Artisti Rivali
class_name RivalData
extends RefCounted

## Identificativo univoco dell'artista o band rivale
var id: String = ""

## Nome dell'artista o gruppo
var name: String = ""

## Genere musicale primario (Enums.MusicalGenre)
var genre: int = Enums.MusicalGenre.ROCK

## Città natale / base operativa (Enums.CityId)
var home_city_id: int = Enums.CityId.MILANO

## Fascia di carriera dell'artista (Enums.CareerTier)
var career_tier: int = Enums.CareerTier.LOCAL_ARTIST

## Indice di popolarità attuale [0.0 - 100.0]
var popularity: float = 30.0

## Titolo del singolo attualmente promosso in radio/streaming
var current_single_title: String = ""

## Punteggio qualitativo del singolo rivale [1.0 - 100.0]
var current_single_score: float = 60.0

## Titolo dell'album/EP attualmente sul mercato
var current_album_title: String = ""

## Punteggio qualitativo dell'album rivale [1.0 - 100.0]
var current_album_score: float = 65.0

## Livello di rivalità con la band del giocatore:
## 0 = Neutro / Rispetto a distanza
## 1 = Competizione accesa
## 2 = Faida mediatica aperta / Dissing
var rivalry_level: int = 0

## Relazione dinamica specialistica (Enums.RivalRelationship)
var relationship: int = Enums.RivalRelationship.NEUTRAL

## Punteggio di affinità / simpatia verso il giocatore [0.0 - 100.0]
var affinity_score: float = 50.0

## Flag idoneità a Tour Congiunto Co-Headlining (affinity >= 70.0 e rispetto reciproco)
var co_headlining_eligible: bool = false

## Giorno dell'ultimo dissing o scontro mediatico
var last_dissing_day: int = 0

## Note storiche sul rapporto tra le band
var history_notes: Array[String] = []

func _init(
	p_id: String = "",
	p_name: String = "",
	p_genre: int = Enums.MusicalGenre.ROCK,
	p_city: int = Enums.CityId.MILANO,
	p_tier: int = Enums.CareerTier.LOCAL_ARTIST,
	p_pop: float = 30.0,
	p_single: String = "",
	p_single_score: float = 60.0,
	p_album: String = "",
	p_album_score: float = 65.0,
	p_rivalry: int = 0,
	p_rel: int = Enums.RivalRelationship.NEUTRAL,
	p_aff: float = 50.0
) -> void:
	id = p_id if not p_id.is_empty() else ("rival_%d_%d" % [Time.get_ticks_msec(), randi() % 10000])
	name = p_name
	genre = p_genre
	home_city_id = p_city
	career_tier = p_tier
	popularity = p_pop
	current_single_title = p_single
	current_single_score = p_single_score
	current_album_title = p_album
	current_album_score = p_album_score
	rivalry_level = p_rivalry
	relationship = p_rel
	affinity_score = p_aff
	co_headlining_eligible = (affinity_score >= 70.0 and relationship == Enums.RivalRelationship.RESPECTFUL)
	last_dissing_day = 0
	history_notes = []

func update_affinity(delta: float) -> void:
	affinity_score = clampf(affinity_score + delta, 0.0, 100.0)
	if affinity_score >= 70.0 and relationship != Enums.RivalRelationship.OPEN_FEUD:
		relationship = Enums.RivalRelationship.RESPECTFUL
		co_headlining_eligible = true
	elif affinity_score <= 25.0:
		relationship = Enums.RivalRelationship.OPEN_FEUD
		co_headlining_eligible = false
	elif affinity_score <= 45.0:
		relationship = Enums.RivalRelationship.HEATED_RIVAL
		co_headlining_eligible = false
	else:
		relationship = Enums.RivalRelationship.NEUTRAL
		co_headlining_eligible = false
	# Mantiene sincronizzato anche rivalry_level storico
	match relationship:
		Enums.RivalRelationship.RESPECTFUL, Enums.RivalRelationship.NEUTRAL:
			rivalry_level = 0
		Enums.RivalRelationship.HEATED_RIVAL:
			rivalry_level = 1
		Enums.RivalRelationship.OPEN_FEUD:
			rivalry_level = 2

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"genre": int(genre),
		"home_city_id": int(home_city_id),
		"career_tier": int(career_tier),
		"popularity": popularity,
		"current_single_title": current_single_title,
		"current_single_score": current_single_score,
		"current_album_title": current_album_title,
		"current_album_score": current_album_score,
		"rivalry_level": rivalry_level,
		"relationship": int(relationship),
		"affinity_score": affinity_score,
		"co_headlining_eligible": co_headlining_eligible,
		"last_dissing_day": last_dissing_day,
		"history_notes": history_notes.duplicate()
	}

func from_dict(d: Dictionary) -> void:
	id = d.get("id", "")
	name = d.get("name", "")
	genre = int(d.get("genre", Enums.MusicalGenre.ROCK))
	home_city_id = int(d.get("home_city_id", Enums.CityId.MILANO))
	career_tier = int(d.get("career_tier", Enums.CareerTier.LOCAL_ARTIST))
	popularity = float(d.get("popularity", 30.0))
	current_single_title = d.get("current_single_title", "")
	current_single_score = float(d.get("current_single_score", 60.0))
	current_album_title = d.get("current_album_title", "")
	current_album_score = float(d.get("current_album_score", 65.0))
	rivalry_level = int(d.get("rivalry_level", 0))
	relationship = int(d.get("relationship", rivalry_level))
	affinity_score = float(d.get("affinity_score", 50.0))
	co_headlining_eligible = bool(d.get("co_headlining_eligible", affinity_score >= 70.0 and relationship == Enums.RivalRelationship.RESPECTFUL))
	last_dissing_day = int(d.get("last_dissing_day", 0))
	
	history_notes.clear()
	var raw_notes: Array = d.get("history_notes", [])
	for n in raw_notes:
		history_notes.append(str(n))
