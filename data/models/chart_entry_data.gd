# GDD 2.0 / SP-13: Modello Dati Elemento di Classifica (Hit Parade)
class_name ChartEntryData
extends RefCounted

## Posizione attuale in classifica (1..10)
var rank: int = 1

## Posizione nella settimana precedente (0 = Debutto / New Entry)
var previous_rank: int = 0

## Identificativo univoco dell'opera (Song ID o Album ID)
var entry_id: String = ""

## Titolo del brano o dell'album
var title: String = ""

## Nome dell'artista o band
var artist_name: String = ""

## True se l'opera appartiene alla band del giocatore
var is_player: bool = false

## Genere musicale (Enums.MusicalGenre)
var genre: int = Enums.MusicalGenre.ROCK

## Metrica quantitativa della settimana (Stream per i singoli, Copie per gli album)
var metric_value: int = 0

## Numero di settimane consecutive di permanenza in classifica
var weeks_on_chart: int = 1

## Migliore posizione storica mai raggiunta (Peak Rank)
var peak_rank: int = 1

## Ambito della classifica (Enums.ChartScope.CONTINENTAL o NATIONAL)
var chart_scope: int = Enums.ChartScope.CONTINENTAL

## Città o nazione di riferimento territoriale (se scope == NATIONAL, altrimenti Enums.CityId.MILANO)
var target_city_id: int = Enums.CityId.MILANO

func _init(
	p_rank: int = 1,
	p_prev: int = 0,
	p_id: String = "",
	p_title: String = "",
	p_artist: String = "",
	p_is_player: bool = false,
	p_genre: int = Enums.MusicalGenre.ROCK,
	p_metric: int = 0,
	p_weeks: int = 1,
	p_peak: int = 1,
	p_scope: int = Enums.ChartScope.CONTINENTAL,
	p_city: int = Enums.CityId.MILANO
) -> void:
	rank = p_rank
	previous_rank = p_prev
	entry_id = p_id
	title = p_title
	artist_name = p_artist
	is_player = p_is_player
	genre = p_genre
	metric_value = p_metric
	weeks_on_chart = p_weeks
	peak_rank = p_peak if p_peak > 0 else p_rank
	chart_scope = p_scope
	target_city_id = p_city

## Verifica se l'opera è una nuova entrata nella classifica settimanale
func is_new_entry() -> bool:
	return previous_rank == 0

## Calcola lo spostamento di posizione (positivo = salita, negativo = discesa)
func get_movement_delta() -> int:
	if is_new_entry():
		return 0
	return previous_rank - rank

## Genera il simbolo sintetico di movimento per l'interfaccia visiva
func get_movement_symbol() -> String:
	if is_new_entry():
		return "NEW"
	var delta: int = get_movement_delta()
	if delta > 0:
		return "▲ +%d" % delta
	elif delta < 0:
		return "▼ -%d" % abs(delta)
	else:
		return "="

## Descrizione testuale lineare per la sintesi vocale NVDA
func get_speech_description() -> String:
	var mov_text: String = ""
	if is_new_entry():
		mov_text = "Nuova entrata!"
	else:
		var delta: int = get_movement_delta()
		if delta > 0:
			mov_text = "Sale di %d posizioni (era %d)" % [delta, previous_rank]
		elif delta < 0:
			mov_text = "Scende di %d posizioni (era %d)" % [abs(delta), previous_rank]
		else:
			mov_text = "Stabile rispetto alla scorsa settimana"
			
	var player_tag: String = " (Tua band)" if is_player else ""
	return "Posizione %d: '%s' di %s%s. %s. Settimane in classifica: %d. Picco storico: #%d. Volume settimanale: %d." % [
		rank,
		title,
		artist_name,
		player_tag,
		mov_text,
		weeks_on_chart,
		peak_rank,
		metric_value
	]

func to_dict() -> Dictionary:
	return {
		"rank": rank,
		"previous_rank": previous_rank,
		"entry_id": entry_id,
		"title": title,
		"artist_name": artist_name,
		"is_player": is_player,
		"genre": int(genre),
		"metric_value": metric_value,
		"weeks_on_chart": weeks_on_chart,
		"peak_rank": peak_rank,
		"chart_scope": int(chart_scope),
		"target_city_id": int(target_city_id)
	}

func from_dict(d: Dictionary) -> void:
	rank = int(d.get("rank", 1))
	previous_rank = int(d.get("previous_rank", 0))
	entry_id = d.get("entry_id", "")
	title = d.get("title", "")
	artist_name = d.get("artist_name", "")
	is_player = bool(d.get("is_player", false))
	genre = int(d.get("genre", Enums.MusicalGenre.ROCK))
	metric_value = int(d.get("metric_value", 0))
	weeks_on_chart = int(d.get("weeks_on_chart", 1))
	peak_rank = int(d.get("peak_rank", rank))
	chart_scope = int(d.get("chart_scope", Enums.ChartScope.CONTINENTAL))
	target_city_id = int(d.get("target_city_id", Enums.CityId.MILANO))
