# res://data/models/player_data.gd
class_name PlayerData
extends RefCounted

## Modello Dati Runtime del Personaggio Giocante per World-tour

var player_name: String = "Alex"
var primary_instrument: String = "Chitarra Elettrica"
var background_id: String = "self_taught"
var trait_id: String = "charismatic"
var language: String = "it"

func get_background_name() -> String:
	match background_id:
		"self_taught":
			return "Autodidatta (Equilibrato)"
		"conservatory":
			return "Conservatorio (Teoria & Composizione)"
		"street_kid":
			return "Musicista di Strada (Carisma & Grinta)"
		"art_family":
			return "Famiglia d'Arte (Notorietà & Contatti)"
		_:
			return "Autodidatta"

func get_trait_name() -> String:
	match trait_id:
		"charismatic":
			return "Carismatico (+Presenza Scenica e Fan)"
		"perfectionist":
			return "Perfezionista (+Qualità Brani, +Stress)"
		"night_owl":
			return "Creativo Notturno (+Ispirazione Serale)"
		"resilient":
			return "Resiliente (-Consumo Energia)"
		_:
			return "Carismatico"

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

# Band, Compagni e Dinamiche Umane (World-tour V2.0)
var band_name: String = "The Rebels"
var band_members: Array[BandMemberData] = []
var revenue_split_mode: int = Enums.RevenueSplit.EQUAL_SPLIT

# Lifestyle & Alloggi
var current_housing_tier: int = Enums.HousingTier.STARTER_BEDROOM

# Mappa Geografica & Fanbase Territoriale (World-tour V4.0 / F8.1)
var current_city_id: int = Enums.CityId.MILANO
var city_fans: Dictionary = {
	Enums.CityId.MILANO: 0,
	Enums.CityId.BOLOGNA: 0,
	Enums.CityId.ROMA: 0,
	Enums.CityId.NAPOLI: 0,
	Enums.CityId.LONDRA: 0,
	Enums.CityId.BERLINO: 0
}
var city_popularity: Dictionary = {
	Enums.CityId.MILANO: 1.0,
	Enums.CityId.BOLOGNA: 0.0,
	Enums.CityId.ROMA: 0.0,
	Enums.CityId.NAPOLI: 0.0,
	Enums.CityId.LONDRA: 0.0,
	Enums.CityId.BERLINO: 0.0
}

func get_current_city_name() -> String:
	match current_city_id:
		Enums.CityId.MILANO:
			return "Milano"
		Enums.CityId.BOLOGNA:
			return "Bologna"
		Enums.CityId.ROMA:
			return "Roma"
		Enums.CityId.NAPOLI:
			return "Napoli"
		Enums.CityId.LONDRA:
			return "Londra"
		Enums.CityId.BERLINO:
			return "Berlino"
		_:
			return "Milano"

# Raccolte Discografiche (EP / Album)
var albums: Array[AlbumData] = []

# Industria Discografica, Contratti & Manager (World-tour V3.0)
const ContractDataScript = preload("res://data/models/contract_data.gd")
const ManagerDataScript = preload("res://data/models/manager_data.gd")

var active_contract: RefCounted = null
var active_manager: RefCounted = null
var available_contracts: Array = []
var resolved_dilemmas: Array[String] = []

func has_active_contract() -> bool:
	return active_contract != null and active_contract.is_active

func has_manager() -> bool:
	return active_manager != null and active_manager.is_hired

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
		var val = skills[skill_key]
		if val is Dictionary:
			return int(val.get("level", 10))
		return int(val)
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

func modify_morale(delta: int) -> void:
	morale = clampi(morale + delta, Constants.MIN_MORALE, Constants.MAX_MORALE)

func modify_money(delta: float) -> void:
	money += delta

func add_fans(amount: int) -> void:
	fans = maxi(0, fans + amount)

func modify_fans(delta: int) -> void:
	fans = maxi(0, fans + delta)

func get_active_band_members() -> Array[BandMemberData]:
	var result: Array[BandMemberData] = []
	for m in band_members:
		if m.is_active:
			result.append(m)
	return result

func add_band_member(member: BandMemberData) -> bool:
	if band_members.size() >= Constants.MAX_BAND_MEMBERS:
		return false
	band_members.append(member)
	return true

func remove_band_member(member_id: String) -> bool:
	for i in range(band_members.size()):
		if band_members[i].id == member_id:
			band_members.remove_at(i)
			return true
	return false

func get_band_member_by_role(role: int) -> BandMemberData:
	for m in band_members:
		if m.role == role and m.is_active:
			return m
	return null

func has_full_band() -> bool:
	return band_members.size() >= Constants.MAX_BAND_MEMBERS

func get_revenue_split_name() -> String:
	match revenue_split_mode:
		Enums.RevenueSplit.EQUAL_SPLIT:
			return tr("SPLIT_EQUAL")
		Enums.RevenueSplit.LEADER_BALANCED:
			return tr("SPLIT_LEADER_BALANCED")
		Enums.RevenueSplit.LEADER_PREDATORY:
			return tr("SPLIT_LEADER_PREDATORY")
		_:
			return tr("SPLIT_EQUAL")

func get_leader_revenue_share() -> float:
	if band_members.is_empty():
		return 1.0
	match revenue_split_mode:
		Enums.RevenueSplit.EQUAL_SPLIT:
			return 1.0 / float(1 + band_members.size())
		Enums.RevenueSplit.LEADER_BALANCED:
			return 0.40
		Enums.RevenueSplit.LEADER_PREDATORY:
			return 0.70
		_:
			return 1.0 / float(1 + band_members.size())

func add_album(album: AlbumData) -> void:
	albums.append(album)

func get_released_albums() -> Array[AlbumData]:
	var result: Array[AlbumData] = []
	for a in albums:
		if a.is_released:
			result.append(a)
	return result

func to_dict() -> Dictionary:
	var serialized_songs: Array = []
	for s in songs:
		serialized_songs.append(s.to_dict())
		
	var serialized_members: Array = []
	for m in band_members:
		serialized_members.append(m.to_dict())
		
	var serialized_albums: Array = []
	for a in albums:
		serialized_albums.append(a.to_dict())
		
	return {
		"player_name": player_name,
		"primary_instrument": primary_instrument,
		"background_id": background_id,
		"trait_id": trait_id,
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
		"songs": serialized_songs,
		"band_name": band_name,
		"revenue_split_mode": revenue_split_mode,
		"current_housing_tier": current_housing_tier,
		"band_members": serialized_members,
		"albums": serialized_albums,
		"active_contract": active_contract.to_dict() if active_contract else {},
		"active_manager": active_manager.to_dict() if active_manager else {},
		"resolved_dilemmas": resolved_dilemmas.duplicate(),
		"current_city_id": current_city_id,
		"city_fans": city_fans.duplicate(true),
		"city_popularity": city_popularity.duplicate(true)
	}

func from_dict(dict: Dictionary) -> void:
	player_name = dict.get("player_name", player_name)
	primary_instrument = dict.get("primary_instrument", primary_instrument)
	background_id = dict.get("background_id", background_id)
	trait_id = dict.get("trait_id", trait_id)
	language = dict.get("language", language)
	energy = int(dict.get("energy", energy))
	stress = int(dict.get("stress", stress))
	morale = int(dict.get("morale", morale))
	money = float(dict.get("money", money))
	career_tier = int(dict.get("career_tier", career_tier))
	fans = int(dict.get("fans", fans))
	reputation = float(dict.get("reputation", reputation))
	popularity = float(dict.get("popularity", popularity))
	current_city_id = int(dict.get("current_city_id", current_city_id))
	if dict.has("city_fans") and dict["city_fans"] is Dictionary:
		city_fans.clear()
		for k in dict["city_fans"]:
			city_fans[int(k)] = int(dict["city_fans"][k])
	if dict.has("city_popularity") and dict["city_popularity"] is Dictionary:
		city_popularity.clear()
		for k in dict["city_popularity"]:
			city_popularity[int(k)] = float(dict["city_popularity"][k])
	if dict.has("skills") and dict["skills"] is Dictionary:
		skills = dict["skills"].duplicate(true)
		
	songs.clear()
	if dict.has("songs") and dict["songs"] is Array:
		for s_dict in dict["songs"]:
			if s_dict is Dictionary:
				var s := SongData.new()
				s.from_dict(s_dict)
				songs.append(s)
				
	band_name = dict.get("band_name", band_name)
	revenue_split_mode = int(dict.get("revenue_split_mode", revenue_split_mode))
	current_housing_tier = int(dict.get("current_housing_tier", current_housing_tier))
	
	band_members.clear()
	if dict.has("band_members") and dict["band_members"] is Array:
		for m_dict in dict["band_members"]:
			if m_dict is Dictionary:
				var m := BandMemberData.new()
				m.from_dict(m_dict)
				band_members.append(m)
				
	albums.clear()
	if dict.has("albums") and dict["albums"] is Array:
		for a_dict in dict["albums"]:
			if a_dict is Dictionary:
				var a := AlbumData.new()
				a.from_dict(a_dict)
				albums.append(a)
				
	if dict.has("active_contract") and dict["active_contract"] is Dictionary and not dict["active_contract"].is_empty():
		active_contract = ContractDataScript.new()
		active_contract.from_dict(dict["active_contract"])
	else:
		active_contract = null
		
	if dict.has("active_manager") and dict["active_manager"] is Dictionary and not dict["active_manager"].is_empty():
		active_manager = ManagerDataScript.new()
		active_manager.from_dict(dict["active_manager"])
	else:
		active_manager = null
		
	resolved_dilemmas.clear()
	if dict.has("resolved_dilemmas") and dict["resolved_dilemmas"] is Array:
		for d_id in dict["resolved_dilemmas"]:
			resolved_dilemmas.append(str(d_id))

