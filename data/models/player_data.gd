# res://data/models/player_data.gd
class_name PlayerData
extends RefCounted

## Modello Dati Runtime del Personaggio Giocante per World-tour

var player_name: String = "Alex"
var primary_instrument: String = "Chitarra Elettrica"
var background_id: String = "self_taught"
var language: String = "it"

# Risorse fisiologiche e finanziarie
var energy: int = Constants.MAX_ENERGY
var stress: int = Constants.MIN_STRESS
var morale: int = Constants.MAX_MORALE
var money: float = 500.0

# Carriera e notorietà
var career_tier: int = Enums.CareerTier.BEDROOM_MUSICIAN
var fans: int = 0
var reputation: float = 5.0
var popularity: float = 1.0

var skills: Dictionary = {
	"instrument": {"level": 10, "xp": 0.0},
	"composition": {"level": 10, "xp": 0.0},
	"songwriting": {"level": 10, "xp": 0.0},
	"lyrics": {"level": 10, "xp": 0.0},
	"vocals": {"level": 10, "xp": 0.0},
	"guitar": {"level": 10, "xp": 0.0},
	"bass": {"level": 10, "xp": 0.0},
	"drums": {"level": 10, "xp": 0.0},
	"production": {"level": 10, "xp": 0.0},
	"performance": {"level": 10, "xp": 0.0},
	"charisma": {"level": 10, "xp": 0.0},
	"business": {"level": 10, "xp": 0.0}
}

# Catalogo brani del musicista
var songs: Array[SongData] = []

func add_song(song: SongData) -> void:
	# Se esiste già un brano con lo stesso id, lo aggiorna
	for i in range(songs.size()):
		if songs[i].id == song.id:
			songs[i] = song
			return
	songs.append(song)

func get_song_by_id(song_id: String) -> SongData:
	for s in songs:
		if s.id == song_id:
			return s
	return null

func get_drafts() -> Array[SongData]:
	var result: Array[SongData] = []
	for s in songs:
		if s.status == Enums.SongStatus.DRAFT:
			result.append(s)
	return result

func get_produced_songs() -> Array[SongData]:
	var result: Array[SongData] = []
	for s in songs:
		if s.status == Enums.SongStatus.PRODUCED:
			result.append(s)
	return result

func get_released_singles() -> Array[SongData]:
	var result: Array[SongData] = []
	for s in songs:
		if s.status == Enums.SongStatus.RELEASED:
			result.append(s)
	return result

func get_playable_songs() -> Array[SongData]:
	var result: Array[SongData] = []
	for s in songs:
		if s.status == Enums.SongStatus.PRODUCED or s.status == Enums.SongStatus.RELEASED:
			result.append(s)
	return result

func populate_starter_test_songs() -> void:
	songs.clear()
	
	# 2 Bozze (DRAFT)
	var d1 := SongData.new("song_draft_01", "Riff della Notte", Enums.MusicalGenre.ROCK, "night")
	d1.status = Enums.SongStatus.DRAFT
	d1.stage = Enums.SongStage.CONCEPT
	songs.append(d1)
	
	var d2 := SongData.new("song_draft_02", "Pensieri Sparsi", Enums.MusicalGenre.INDIE, "melancholy")
	d2.status = Enums.SongStatus.DRAFT
	d2.stage = Enums.SongStage.SONGWRITING
	d2.comp_skill_used = 35.0
	d2.quality_score = 30.0
	songs.append(d2)
	
	# 5 Brani Pronti per il Palco (PRODUCED)
	var p1 := SongData.new("song_prod_01", "Fuoco nel Garage", Enums.MusicalGenre.ROCK, "rebellion")
	p1.status = Enums.SongStatus.PRODUCED
	p1.stage = Enums.SongStage.COMPLETED
	p1.quality_score = 74.0
	p1.special_trait = Enums.SongTrait.STAGE_BEAST
	songs.append(p1)
	
	var p2 := SongData.new("song_prod_02", "Ballata Metropolitana", Enums.MusicalGenre.POP, "love")
	p2.status = Enums.SongStatus.PRODUCED
	p2.stage = Enums.SongStage.COMPLETED
	p2.quality_score = 68.0
	p2.special_trait = Enums.SongTrait.EARWORM
	songs.append(p2)
	
	var p3 := SongData.new("song_prod_03", "Insonnia Elettrica", Enums.MusicalGenre.ELECTRONIC, "night")
	p3.status = Enums.SongStatus.PRODUCED
	p3.stage = Enums.SongStage.COMPLETED
	p3.quality_score = 65.0
	songs.append(p3)
	
	var p4 := SongData.new("song_prod_04", "Rabbia e Cemento", Enums.MusicalGenre.METAL, "rebellion")
	p4.status = Enums.SongStatus.PRODUCED
	p4.stage = Enums.SongStage.COMPLETED
	p4.quality_score = 78.0
	p4.special_trait = Enums.SongTrait.STAGE_BEAST
	songs.append(p4)
	
	var p5 := SongData.new("song_prod_05", "Aria Sottile", Enums.MusicalGenre.INDIE, "success")
	p5.status = Enums.SongStatus.PRODUCED
	p5.stage = Enums.SongStage.COMPLETED
	p5.quality_score = 62.0
	p5.special_trait = Enums.SongTrait.CULT_CLASSIC
	songs.append(p5)
	
	# 3 Singoli Già Pubblicati (RELEASED)
	var r1 := SongData.new("song_rel_01", "Prima Scintilla", Enums.MusicalGenre.ROCK, "rebellion")
	r1.status = Enums.SongStatus.RELEASED
	r1.stage = Enums.SongStage.COMPLETED
	r1.quality_score = 72.0
	r1.special_trait = Enums.SongTrait.CULT_CLASSIC
	r1.release_day = 1
	r1.plays = 450
	r1.revenue = 135.0
	songs.append(r1)
	
	var r2 := SongData.new("song_rel_02", "Strade Deserte", Enums.MusicalGenre.POP, "melancholy")
	r2.status = Enums.SongStatus.RELEASED
	r2.stage = Enums.SongStage.COMPLETED
	r2.quality_score = 64.0
	r2.release_day = 1
	r2.plays = 280
	r2.revenue = 84.0
	songs.append(r2)
	
	var r3 := SongData.new("song_rel_03", "Urlo dal Sottosuolo", Enums.MusicalGenre.METAL, "night")
	r3.status = Enums.SongStatus.RELEASED
	r3.stage = Enums.SongStage.COMPLETED
	r3.quality_score = 80.0
	r3.special_trait = Enums.SongTrait.STAGE_BEAST
	r3.release_day = 2
	r3.plays = 620
	r3.revenue = 190.0
	songs.append(r3)


func get_skill_level(skill_key: String) -> int:
	if skills.has(skill_key):
		return skills[skill_key]["level"]
	return 10

func add_xp_to_skill(skill_key: String, xp_amount: float) -> bool:
	if not skills.has(skill_key):
		return false
	
	var data: Dictionary = skills[skill_key]
	data["xp"] += xp_amount
	var current_level: int = data["level"]
	var required_xp: int = Formulas.calculate_xp_for_level(current_level)
	var leveled_up: bool = false
	
	while data["xp"] >= float(required_xp) and current_level < 99:
		data["xp"] -= float(required_xp)
		data["level"] += 1
		current_level = data["level"]
		required_xp = Formulas.calculate_xp_for_level(current_level)
		leveled_up = true
	
	return leveled_up

func consume_energy(amount: int) -> bool:
	if energy < amount:
		return false
	energy = maxi(Constants.MIN_ENERGY, energy - amount)
	return true

func add_energy(amount: int) -> void:
	energy = mini(Constants.MAX_ENERGY, energy + amount)

func add_stress(amount: int) -> void:
	stress = mini(Constants.MAX_STRESS, stress + amount)

func reduce_stress(amount: int) -> void:
	stress = maxi(Constants.MIN_STRESS, stress - amount)

func modify_money(delta: float) -> void:
	money += delta

func to_dict() -> Dictionary:
	var serialized_songs: Array = []
	for s in songs:
		serialized_songs.append(s.to_dict())
		
	return {
		"player_name": player_name,
		"primary_instrument": primary_instrument,
		"background_id": background_id,
		"language": language,
		"energy": energy,
		"stress": stress,
		"morale": morale,
		"money": money,
		"career_tier": career_tier,
		"fans": fans,
		"reputation": reputation,
		"popularity": popularity,
		"skills": skills.duplicate(true),
		"songs": serialized_songs
	}

func from_dict(dict: Dictionary) -> void:
	player_name = dict.get("player_name", player_name)
	primary_instrument = dict.get("primary_instrument", primary_instrument)
	background_id = dict.get("background_id", background_id)
	language = dict.get("language", language)
	energy = int(dict.get("energy", energy))
	stress = int(dict.get("stress", stress))
	morale = int(dict.get("morale", morale))
	money = float(dict.get("money", money))
	career_tier = int(dict.get("career_tier", career_tier))
	fans = int(dict.get("fans", fans))
	reputation = float(dict.get("reputation", reputation))
	popularity = float(dict.get("popularity", popularity))
	if dict.has("skills") and dict["skills"] is Dictionary:
		skills = dict["skills"].duplicate(true)
		
	songs.clear()
	if dict.has("songs") and dict["songs"] is Array:
		for s_dict in dict["songs"]:
			if s_dict is Dictionary:
				var s := SongData.new()
				s.from_dict(s_dict)
				songs.append(s)
