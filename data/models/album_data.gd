# res://data/models/album_data.gd
class_name AlbumData
extends RefCounted

## Modello Dati per Album ed EP Discografici (World-tour V2.0)
## Governa le raccolte discografiche composte da 3-5 tracce (EP) o 6-10 tracce (LP),
## il concept, la traccia trainante, l'artwork, le recensioni della critica e le vendite.

var id: String = ""
var title: String = ""
var album_type: int = Enums.AlbumType.EP # EP o LP
var concept: int = Enums.AlbumConcept.COMMERCIAL_HIT
var artwork_style: int = Enums.ArtworkStyle.MINIMALIST
var lead_single_id: String = ""
var song_ids: Array[String] = []
var overall_quality: float = 0.0
var review_stars: float = 3.0 # 1.0 - 5.0
var release_day: int = 0
var total_sales: float = 0.0
var is_released: bool = false

func _init(
	p_id: String = "",
	p_title: String = "",
	p_type: int = Enums.AlbumType.EP
) -> void:
	if p_id.is_empty():
		id = "album_%d_%d" % [Time.get_ticks_msec(), randi() % 10000]
	else:
		id = p_id
	title = p_title
	album_type = p_type

func get_type_name() -> String:
	match album_type:
		Enums.AlbumType.EP:
			return tr("ALBUM_TYPE_EP")
		Enums.AlbumType.LP:
			return tr("ALBUM_TYPE_LP")
		_:
			return "EP"

func get_concept_name() -> String:
	match concept:
		Enums.AlbumConcept.CONCEPTUAL:
			return tr("CONCEPT_CONCEPTUAL")
		Enums.AlbumConcept.COMMERCIAL_HIT:
			return tr("CONCEPT_COMMERCIAL_HIT")
		Enums.AlbumConcept.RAW_UNDERGROUND:
			return tr("CONCEPT_RAW_UNDERGROUND")
		_:
			return "Standard"

func get_artwork_name() -> String:
	match artwork_style:
		Enums.ArtworkStyle.MINIMALIST:
			return tr("ARTWORK_MINIMALIST")
		Enums.ArtworkStyle.RETRO_PSYCHEDELIC:
			return tr("ARTWORK_RETRO_PSYCHEDELIC")
		Enums.ArtworkStyle.DARK_METAL:
			return tr("ARTWORK_DARK_METAL")
		Enums.ArtworkStyle.STREET_GRAFFITI:
			return tr("ARTWORK_STREET_GRAFFITI")
		_:
			return "Standard"

func get_min_tracks() -> int:
	return Constants.ALBUM_EP_MIN_TRACKS if album_type == Enums.AlbumType.EP else Constants.ALBUM_LP_MIN_TRACKS

func get_max_tracks() -> int:
	return Constants.ALBUM_EP_MAX_TRACKS if album_type == Enums.AlbumType.EP else Constants.ALBUM_LP_MAX_TRACKS

func to_dict() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"album_type": album_type,
		"concept": concept,
		"artwork_style": artwork_style,
		"lead_single_id": lead_single_id,
		"song_ids": song_ids.duplicate(),
		"overall_quality": overall_quality,
		"review_stars": review_stars,
		"release_day": release_day,
		"total_sales": total_sales,
		"is_released": is_released
	}

func from_dict(data: Dictionary) -> void:
	id = str(data.get("id", id))
	title = str(data.get("title", title))
	album_type = int(data.get("album_type", album_type))
	concept = int(data.get("concept", concept))
	artwork_style = int(data.get("artwork_style", artwork_style))
	lead_single_id = str(data.get("lead_single_id", lead_single_id))
	
	song_ids.clear()
	var raw_songs: Array = data.get("song_ids", [])
	for s_id in raw_songs:
		song_ids.append(str(s_id))
		
	overall_quality = float(data.get("overall_quality", overall_quality))
	review_stars = float(data.get("review_stars", review_stars))
	release_day = int(data.get("release_day", release_day))
	total_sales = float(data.get("total_sales", total_sales))
	is_released = bool(data.get("is_released", is_released))
