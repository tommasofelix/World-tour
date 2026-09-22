# GDD 2.0 / SP-12: Modello Dati Post Social Media
class_name SocialPostData
extends RefCounted

## Identificativo univoco del post
var id: String = ""

## Tipologia di contenuto (Enums.SocialPostType)
var post_type: int = Enums.SocialPostType.PRACTICE_CLIP

## Giorno del calendario di pubblicazione
var day_published: int = 1

## Didascalia o testo del post
var caption: String = ""

## ID del brano collegato (se post_type == TRACK_TEASER)
var song_id: String = ""

## Titolo del brano collegato
var song_title: String = ""

## Visualizzazioni generate dal post
var views: int = 0

## Mi Piace / Like ricevuti
var likes: int = 0

## Condivisioni / Repost
var shares: int = 0

## Nuovi follower conquistati
var new_followers: int = 0

## Flag se il post è diventato virale (score straordinario)
var is_viral: bool = false

## Flag se il post ha generato una polemica online / shitstorm
var is_controversial: bool = false

## Campione di commenti procedurali del pubblico
var comments_sample: Array[String] = []

func _init(
	p_id: String = "",
	p_type: int = Enums.SocialPostType.PRACTICE_CLIP,
	p_day: int = 1,
	p_caption: String = "",
	p_song_id: String = "",
	p_song_title: String = ""
) -> void:
	id = p_id if not p_id.is_empty() else ("post_%d_%d" % [Time.get_ticks_msec(), randi() % 10000])
	post_type = p_type
	day_published = p_day
	caption = p_caption
	song_id = p_song_id
	song_title = p_song_title
	views = 0
	likes = 0
	shares = 0
	new_followers = 0
	is_viral = false
	is_controversial = false
	comments_sample = []

func to_dict() -> Dictionary:
	return {
		"id": id,
		"post_type": int(post_type),
		"day_published": day_published,
		"caption": caption,
		"song_id": song_id,
		"song_title": song_title,
		"views": views,
		"likes": likes,
		"shares": shares,
		"new_followers": new_followers,
		"is_viral": is_viral,
		"is_controversial": is_controversial,
		"comments_sample": comments_sample.duplicate()
	}

func from_dict(d: Dictionary) -> void:
	id = d.get("id", "")
	post_type = int(d.get("post_type", Enums.SocialPostType.PRACTICE_CLIP))
	day_published = int(d.get("day_published", 1))
	caption = d.get("caption", "")
	song_id = d.get("song_id", "")
	song_title = d.get("song_title", "")
	views = int(d.get("views", 0))
	likes = int(d.get("likes", 0))
	shares = int(d.get("shares", 0))
	new_followers = int(d.get("new_followers", 0))
	is_viral = bool(d.get("is_viral", false))
	is_controversial = bool(d.get("is_controversial", false))
	
	comments_sample.clear()
	var raw_comments: Array = d.get("comments_sample", [])
	for c in raw_comments:
		comments_sample.append(str(c))
