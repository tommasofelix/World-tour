# res://data/models/own_label_data.gd
class_name OwnLabelData
extends RefCounted

## Modello Dati per la Propria Etichetta Discografica Indipendente (World-tour Endgame / Sezione 9)
## Governa il roster di giovani band emergenti messe sotto contratto da Alex,
## gli anticipi concessi, la filosofia editoriale e le royalties passive generate dal catalogo.

var label_name: String = ""
var is_founded: bool = false
var founded_day: int = 1
var philosophy: int = Enums.LabelPhilosophy.UNDERGROUND_INDIE
var reputation: float = 10.0
var signed_bands: Array[Dictionary] = []
var total_catalog_revenue: float = 0.0

func _init(p_name: String = "", p_philosophy: int = Enums.LabelPhilosophy.UNDERGROUND_INDIE) -> void:
	label_name = p_name
	philosophy = p_philosophy
	is_founded = not p_name.is_empty()
	founded_day = 1
	reputation = 10.0
	signed_bands = []
	total_catalog_revenue = 0.0

func get_philosophy_name() -> String:
	return Enums.get_label_philosophy_name(philosophy)

func add_band(band_data: Dictionary) -> void:
	# Evita duplicati di ID
	for i in range(signed_bands.size()):
		if signed_bands[i].get("id", "") == band_data.get("id", ""):
			signed_bands[i] = band_data.duplicate(true)
			return
	signed_bands.append(band_data.duplicate(true))

func remove_band(band_id: String) -> bool:
	for i in range(signed_bands.size()):
		if signed_bands[i].get("id", "") == band_id:
			signed_bands.remove_at(i)
			return true
	return false

func get_band_by_id(band_id: String) -> Dictionary:
	for b in signed_bands:
		if b.get("id", "") == band_id:
			return b
	return {}

func to_dict() -> Dictionary:
	var serialized_bands: Array = []
	for b in signed_bands:
		serialized_bands.append(b.duplicate(true))
	return {
		"label_name": label_name,
		"is_founded": is_founded,
		"founded_day": founded_day,
		"philosophy": philosophy,
		"reputation": reputation,
		"signed_bands": serialized_bands,
		"total_catalog_revenue": total_catalog_revenue
	}

func from_dict(dict: Dictionary) -> void:
	label_name = dict.get("label_name", label_name)
	is_founded = bool(dict.get("is_founded", is_founded))
	founded_day = int(dict.get("founded_day", founded_day))
	philosophy = int(dict.get("philosophy", philosophy))
	reputation = float(dict.get("reputation", reputation))
	total_catalog_revenue = float(dict.get("total_catalog_revenue", total_catalog_revenue))
	signed_bands.clear()
	if dict.has("signed_bands") and dict["signed_bands"] is Array:
		for b in dict["signed_bands"]:
			if b is Dictionary:
				signed_bands.append(b.duplicate(true))
