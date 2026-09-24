# GDD 2.0 / SP-13: Sottosistema Gestione Artisti e Band Rivali
class_name RivalSystem
extends RefCounted

## Catalogo delle band e artisti rivali registrati (id -> RivalData)
var rivals: Dictionary = {}

func _init() -> void:
	_init_default_rivals()

## Inizializza il catalogo delle band rivali della scena musicale
func _init_default_rivals() -> void:
	rivals.clear()
	
	# 1. MILANO (Rock / Elettronica) - The Chrome Shadows
	var r1 := RivalData.new(
		"rival_chrome_shadows",
		"The Chrome Shadows",
		Enums.MusicalGenre.ROCK,
		Enums.CityId.MILANO,
		Enums.CareerTier.INDIE_SENSATION,
		72.0,
		"Neon Mirage",
		74.0,
		"Overdrive City",
		76.0,
		0
	)
	rivals[r1.id] = r1
	
	# 2. BOLOGNA (Indie / Rock) - I Ribelli del Pratello
	var r2 := RivalData.new(
		"rival_ribelli_pratello",
		"I Ribelli del Pratello",
		Enums.MusicalGenre.INDIE,
		Enums.CityId.BOLOGNA,
		Enums.CareerTier.LOCAL_ARTIST,
		60.0,
		"Portici Rossi",
		72.0,
		"Sottovoce EP",
		73.0,
		0
	)
	rivals[r2.id] = r2
	
	# 3. ROMA (Pop / Rock) - Colosseo Sound Machine
	var r3 := RivalData.new(
		"rival_colosseo_sound",
		"Colosseo Sound Machine",
		Enums.MusicalGenre.POP,
		Enums.CityId.ROMA,
		Enums.CareerTier.INDIE_SENSATION,
		75.0,
		"Travertino Beat",
		76.0,
		"Tramonto Imperiale",
		77.0,
		0
	)
	rivals[r3.id] = r3
	
	# 4. NAPOLI (Hip Hop / Crossover) - Vesuvio Posse
	var r4 := RivalData.new(
		"rival_vesuvio_posse",
		"Vesuvio Posse",
		Enums.MusicalGenre.HIPHOP,
		Enums.CityId.NAPOLI,
		Enums.CareerTier.INDIE_SENSATION,
		74.0,
		"Fumo e Lava",
		75.0,
		"Spaccanapoli Sound",
		75.0,
		0
	)
	rivals[r4.id] = r4
	
	# 5. LONDRA (Metal / Rock) - Royal Camden Vanguard
	var r5 := RivalData.new(
		"rival_royal_camden",
		"Royal Camden Vanguard",
		Enums.MusicalGenre.METAL,
		Enums.CityId.LONDRA,
		Enums.CareerTier.NATIONAL_STAR,
		82.0,
		"Thames Riot",
		82.0,
		"Crown of Rust",
		90.0,
		0
	)
	rivals[r5.id] = r5
	
	# 6. BERLINO (Elettronica / Industrial) - Klangwerk Berlin
	var r6 := RivalData.new(
		"rival_klangwerk",
		"Klangwerk Berlin",
		Enums.MusicalGenre.ELECTRONIC,
		Enums.CityId.BERLINO,
		Enums.CareerTier.NATIONAL_STAR,
		80.0,
		"Beton Tanz",
		80.0,
		"Nachtschicht",
		82.0,
		0
	)
	rivals[r6.id] = r6
	
	# 7. MILANO (Pop Acustico emergente) - The Silver Strings
	var r7 := RivalData.new(
		"rival_silver_strings",
		"The Silver Strings",
		Enums.MusicalGenre.POP,
		Enums.CityId.MILANO,
		Enums.CareerTier.BUSKER,
		42.0,
		"Gocce di Pioggia",
		58.0,
		"Primo Passo EP",
		60.0,
		0
	)
	rivals[r7.id] = r7
	
	# 8. BOLOGNA (Punk / Underground) - Distorsione Pura
	var r8 := RivalData.new(
		"rival_distorsione_pura",
		"Distorsione Pura",
		Enums.MusicalGenre.ROCK,
		Enums.CityId.BOLOGNA,
		Enums.CareerTier.LOCAL_ARTIST,
		52.0,
		"No Regole",
		65.0,
		"Urla nel Sottoscala",
		66.0,
		0
	)
	rivals[r8.id] = r8
	
	# 9. ROMA (Indie / Folk) - Echoes of Trastevere
	var r9 := RivalData.new(
		"rival_echoes_trastevere",
		"Echoes of Trastevere",
		Enums.MusicalGenre.INDIE,
		Enums.CityId.ROMA,
		Enums.CareerTier.LOCAL_ARTIST,
		55.0,
		"Vicolo Cieco",
		68.0,
		"San Callisto Nights",
		69.0,
		0
	)
	rivals[r9.id] = r9
	
	# 10. NAPOLI (Funk / Rock) - Partenope Sound
	var r10 := RivalData.new(
		"rival_partenope_sound",
		"Partenope Sound",
		Enums.MusicalGenre.ROCK,
		Enums.CityId.NAPOLI,
		Enums.CareerTier.LOCAL_ARTIST,
		58.0,
		"Maremoto",
		70.0,
		"Golfo di Notte",
		71.0,
		0
	)
	rivals[r10.id] = r10

## Restituisce un rivale per ID
func get_rival(id: String) -> RivalData:
	return rivals.get(id, null)

## Restituisce tutti i rivali registrati
func get_all_rivals() -> Array[RivalData]:
	var list: Array[RivalData] = []
	for r in rivals.values():
		list.append(r)
	return list

## Restituisce i rivali appartenenti a una specifica città
func get_rivals_by_city(city_id: int) -> Array[RivalData]:
	var list: Array[RivalData] = []
	for r in rivals.values():
		if r.home_city_id == city_id:
			list.append(r)
	return list

## Modifica il livello di rivalità con una determinata band
func set_rivalry_level(rival_id: String, level: int) -> void:
	if rivals.has(rival_id):
		rivals[rival_id].rivalry_level = clampi(level, 0, 2)
		if level == 0:
			rivals[rival_id].relationship = Enums.RivalRelationship.NEUTRAL
		elif level == 1:
			rivals[rival_id].relationship = Enums.RivalRelationship.HEATED_RIVAL
		elif level == 2:
			rivals[rival_id].relationship = Enums.RivalRelationship.OPEN_FEUD

## Interazione amichevole o diplomatica con un rivale (complimento, tributo)
func praise_rival(rival_id: String) -> Dictionary:
	var r: RivalData = get_rival(rival_id)
	if not r:
		return {"success": false, "reason": "rival_not_found"}
	r.update_affinity(15.0)
	var note: String = "Hai espresso stima pubblica per %s (+15 affinità)." % r.name
	r.history_notes.append(note)
	return {
		"success": true,
		"rival_name": r.name,
		"new_affinity": r.affinity_score,
		"relationship": r.relationship,
		"co_headlining_eligible": r.co_headlining_eligible,
		"message": note
	}

## Proposta di Tour Congiunto Co-Headlining
func propose_co_headlining(rival_id: String) -> Dictionary:
	var r: RivalData = get_rival(rival_id)
	if not r:
		return {"success": false, "reason": "rival_not_found"}
	if r.co_headlining_eligible:
		var note: String = "%s ha accettato con entusiasmo la proposta di Co-Headlining Tour!" % r.name
		r.history_notes.append(note)
		return {
			"success": true,
			"accepted": true,
			"rival_name": r.name,
			"fan_bonus_mult": Constants.MEDIA_CO_HEADLINING_FAN_BONUS,
			"expense_discount": Constants.MEDIA_CO_HEADLINING_EXPENSE_DISCOUNT,
			"message": note
		}
	else:
		r.update_affinity(-5.0)
		var note: String = "%s ha rifiutato la proposta di tour congiunto (Affinità insufficiente: %.1f/70)." % [r.name, r.affinity_score]
		r.history_notes.append(note)
		return {
			"success": true,
			"accepted": false,
			"rival_name": r.name,
			"reason": "affinity_too_low",
			"message": note
		}

## Dissing e provocazione pubblica verso una band rivale
func trigger_dissing(rival_id: String, current_day: int = 1) -> Dictionary:
	var r: RivalData = get_rival(rival_id)
	if not r:
		return {"success": false, "reason": "rival_not_found"}
	r.update_affinity(-35.0)
	r.relationship = Enums.RivalRelationship.OPEN_FEUD
	r.rivalry_level = 2
	r.last_dissing_day = current_day
	var note: String = "Giorno %d: Lanciato dissing mediatico contro %s! Relazione degenerata in Faida Aperta." % [current_day, r.name]
	r.history_notes.append(note)
	return {
		"success": true,
		"rival_name": r.name,
		"relationship": r.relationship,
		"buzz_multiplier": Constants.MEDIA_DISSING_BUZZ_MULT,
		"message": note
	}

## Simula fluttuazioni e progressione settimanale dei rivali
func simulate_weekly_performance() -> void:
	for r: RivalData in rivals.values():
		var delta_pop: float = randf_range(-1.5, 2.0)
		r.popularity = clampf(r.popularity + delta_pop, 10.0, 100.0)
		
		# Piccola fluttuazione naturale di rotazione dei singoli/album
		var score_fluct: float = randf_range(-2.0, 2.0)
		r.current_single_score = clampf(r.current_single_score + score_fluct, 40.0, 100.0)

## Serializzazione per savegame
func to_dict() -> Dictionary:
	var out: Dictionary = {}
	for k in rivals.keys():
		out[k] = rivals[k].to_dict()
	return out

## Deserializzazione da savegame
func from_dict(d: Dictionary) -> void:
	for k in d.keys():
		if rivals.has(k):
			rivals[k].from_dict(d[k])
		else:
			var r := RivalData.new()
			r.from_dict(d[k])
			rivals[k] = r
