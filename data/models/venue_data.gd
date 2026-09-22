# res://data/models/venue_data.gd
class_name VenueData
extends RefCounted

## Modello Dati del Locale per Concerti dal Vivo (World-tour)
## Conforme a SP-04 e alla Clean Architecture

var id: String = ""
var name: String = ""
var description: String = ""
var capacity: int = 15
var rent_cost: float = 0.0
var min_popularity: float = 0.0
var prestige: float = 0.0
var fair_ticket_price: float = 0.0
var atmosphere: String = "Grezzo"

func _init(
	p_id: String = "",
	p_name: String = "",
	p_capacity: int = 15,
	p_rent_cost: float = 0.0,
	p_min_pop: float = 0.0,
	p_prestige: float = 0.0,
	p_fair_price: float = 0.0,
	p_description: String = "",
	p_atmosphere: String = ""
) -> void:
	id = p_id
	name = p_name
	capacity = p_capacity
	rent_cost = p_rent_cost
	min_popularity = p_min_pop
	prestige = p_prestige
	fair_ticket_price = p_fair_price
	description = p_description
	atmosphere = p_atmosphere

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"description": description,
		"capacity": capacity,
		"rent_cost": rent_cost,
		"min_popularity": min_popularity,
		"prestige": prestige,
		"fair_ticket_price": fair_ticket_price,
		"atmosphere": atmosphere
	}

func from_dict(dict: Dictionary) -> void:
	id = str(dict.get("id", id))
	name = str(dict.get("name", name))
	description = str(dict.get("description", description))
	capacity = int(dict.get("capacity", capacity))
	rent_cost = float(dict.get("rent_cost", rent_cost))
	min_popularity = float(dict.get("min_popularity", min_popularity))
	prestige = float(dict.get("prestige", prestige))
	fair_ticket_price = float(dict.get("fair_ticket_price", fair_ticket_price))
	atmosphere = str(dict.get("atmosphere", atmosphere))

func get_localized_name() -> String:
	match id:
		"venue_garage":
			return tr("VENUE_GARAGE_NAME")
		"venue_pub":
			return tr("VENUE_PUB_NAME")
		"venue_small_club":
			return tr("VENUE_SMALL_CLUB_NAME")
		"venue_trendy_club":
			return tr("VENUE_TRENDY_CLUB_NAME")
		_:
			return name

func get_localized_description() -> String:
	match id:
		"venue_garage":
			return tr("VENUE_GARAGE_DESC")
		"venue_pub":
			return tr("VENUE_PUB_DESC")
		"venue_small_club":
			return tr("VENUE_SMALL_CLUB_DESC")
		"venue_trendy_club":
			return tr("VENUE_TRENDY_CLUB_DESC")
		_:
			return description

static func get_default_venues() -> Array[VenueData]:
	var list: Array[VenueData] = []
	list.append(VenueData.new(
		"venue_garage",
		"Garage / Sala Prove",
		15,
		0.0,
		0.0,
		0.0,
		0.0,
		"Amici e conoscenti: applausi facili, zero incassi.",
		"Grezzo"
	))
	list.append(VenueData.new(
		"venue_pub",
		"Pub / Birreria Locale",
		60,
		50.0,
		5.0,
		15.0,
		5.0,
		"Avventori distratti: occorre carisma per zittire il bar.",
		"Rumoroso"
	))
	list.append(VenueData.new(
		"venue_small_club",
		"Piccolo Club Live",
		180,
		250.0,
		20.0,
		40.0,
		12.0,
		"Appassionati di musica: ascolto attento, alta conversione fan.",
		"Underground"
	))
	list.append(VenueData.new(
		"venue_trendy_club",
		"Club di Tendenza",
		450,
		700.0,
		40.0,
		70.0,
		22.0,
		"Critici e addetti ai lavori: trampolino per la scena nazionale.",
		"Prestigioso"
	))
	return list
