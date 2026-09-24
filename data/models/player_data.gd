# res://data/models/player_data.gd
class_name PlayerData
extends RefCounted

## Modello Dati Runtime del Personaggio Giocante per World-tour
const UpgradeData = preload("res://data/models/upgrade_data.gd")

var player_name: String = "Alex"
var stage_name: String = ""
var age: int = 20
var primary_instrument: String = "Chitarra Elettrica"
var background_id: String = "self_taught"
var trait_id: String = "charismatic"
var language: String = "it"

func get_effective_name() -> String:
	return stage_name if not stage_name.is_empty() else player_name

func get_background_name() -> String:
	match background_id:
		"self_taught":
			return "Autodidatta (Equilibrato)"
		"conservatory":
			return "Conservatorio (Teoria & Composizione)"
		"busker", "street_kid":
			return "Musicista di Strada (Carisma & Grinta)"
		"punk_rebel":
			return "Ribelle Punk (Grinta & Presenza Scenica)"
		"bedroom_producer":
			return "Producer da Cameretta (Produzione Sonora)"
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
		"stage_animal":
			return "Animale da Palco (+Concert Score nei Live)"
		"creative_insomniac", "night_owl":
			return "Insonne Creativo (+Idee di Notte, -Recupero Sonno)"
		"resilient":
			return "Resiliente (-Consumo Energia e Stress)"
		_:
			return "Carismatico"

func apply_starting_background_and_trait() -> void:
	match background_id:
		"self_taught":
			money = 50.0
			skills["instrument"]["level"] = 12
		"conservatory":
			money = 30.0
			skills["composition"]["level"] = 14
			skills["instrument"]["level"] = 12
		"busker", "street_kid":
			money = 25.0
			skills["performance"]["level"] = 14
			skills["charisma"]["level"] = 12
		"punk_rebel":
			money = 20.0
			skills["performance"]["level"] = 15
		"bedroom_producer":
			money = 40.0
			skills["production"]["level"] = 15
			skills["composition"]["level"] = 12
		_:
			money = 50.0

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

# Skills, Upgrade Hub & Strumentazione (World-tour V5.0 / F9.1 & Sezione 4)
var rehearsal_tier: int = 0
var studio_hardware_tier: int = 0
var owned_instruments: Dictionary = {
	"guitar": 0,
	"bass": 0,
	"drums": 0,
	"vocals": 0,
	"keyboards": 0
}
var instrument_condition: Dictionary = {
	"guitar": 100.0,
	"bass": 100.0,
	"drums": 100.0,
	"vocals": 100.0,
	"keyboards": 100.0
}
var has_backup_instrument: bool = false
var owned_pedals: Array[String] = []
var active_pedalboard: Array[String] = []
var current_amp_tier: int = 0
var rehearsal_sublet_active: bool = false
var recording_philosophy: int = 0

func get_instrument_tier(category: String) -> int:
	return int(owned_instruments.get(category, 0))

func set_instrument_tier(category: String, tier: int) -> void:
	owned_instruments[category] = tier

func get_primary_category() -> String:
	var cat: String = "guitar"
	var p_lower: String = primary_instrument.to_lower()
	if p_lower.contains("bass"):
		cat = "bass"
	elif p_lower.contains("drum") or p_lower.contains("batteria"):
		cat = "drums"
	elif p_lower.contains("voc") or p_lower.contains("cant") or p_lower.contains("voice"):
		cat = "vocals"
	elif p_lower.contains("key") or p_lower.contains("tast") or p_lower.contains("piano"):
		cat = "keyboards"
	return cat

func get_instrument_condition(category: String) -> float:
	return clampf(float(instrument_condition.get(category, 100.0)), 0.0, 100.0)

func apply_instrument_wear(category: String, amount: float) -> void:
	var cur: float = get_instrument_condition(category)
	instrument_condition[category] = clampf(cur - amount, 0.0, 100.0)

func repair_instrument(category: String, full_service: bool = false) -> Dictionary:
	var cost: float = Constants.COST_LUTHIER_FULL if full_service else Constants.COST_LUTHIER_BASIC
	if money < cost:
		return {"success": false, "reason": "money_insufficient", "cost": cost}
	modify_money(-cost)
	EventBus.money_changed.emit(money, -cost, "luthier_repair")
	instrument_condition[category] = 100.0
	return {"success": true, "cost": cost, "full_service": full_service}

func equip_pedal(pedal_id: String) -> bool:
	if not owned_pedals.has(pedal_id):
		return false
	if active_pedalboard.has(pedal_id):
		return true
	if active_pedalboard.size() >= 3:
		return false
	active_pedalboard.append(pedal_id)
	return true

func unequip_pedal(pedal_id: String) -> void:
	active_pedalboard.erase(pedal_id)

func get_sound_shaping_genre_bonus(target_genre: int) -> float:
	return UpgradeData.calculate_sound_shaping_bonus(active_pedalboard, current_amp_tier, target_genre)

func equip_band_member(member_id: String, tier: int) -> bool:
	for m in band_members:
		if m.id == member_id:
			m.equip_gear(tier)
			return true
	return false

func get_total_gear_synergy_bonus() -> float:
	var total: float = 0.0
	for cat in owned_instruments:
		var tier: int = int(owned_instruments[cat])
		var inst: Dictionary = UpgradeData.get_instrument(cat, tier)
		if not inst.is_empty():
			total += float(inst.get("band_synergy_bonus", 0.0))
	for m in band_members:
		if m and m.is_active and m.equipped_gear_tier > 0:
			total += float(m.equipped_gear_tier) * 2.0
	return total

func get_primary_instrument_bonus() -> Dictionary:
	var cat: String = get_primary_category()
	var tier: int = get_instrument_tier(cat)
	return UpgradeData.get_instrument(cat, tier)

# Mappa Geografica & Fanbase Territoriale (World-tour V4.0 / F8.1 & F8.2 / Sezione 6)
var current_city_id: int = Enums.CityId.MILANO
var city_fans: Dictionary = {
	Enums.CityId.MILANO: 0,
	Enums.CityId.BOLOGNA: 0,
	Enums.CityId.ROMA: 0,
	Enums.CityId.NAPOLI: 0,
	Enums.CityId.LONDRA: 0,
	Enums.CityId.BERLINO: 0,
	Enums.CityId.DUBLINO: 0,
	Enums.CityId.PARIGI: 0,
	Enums.CityId.MADRID: 0,
	Enums.CityId.NEW_YORK: 0,
	Enums.CityId.LOS_ANGELES: 0,
	Enums.CityId.TOKYO: 0
}
var city_popularity: Dictionary = {
	Enums.CityId.MILANO: 1.0,
	Enums.CityId.BOLOGNA: 0.0,
	Enums.CityId.ROMA: 0.0,
	Enums.CityId.NAPOLI: 0.0,
	Enums.CityId.LONDRA: 0.0,
	Enums.CityId.BERLINO: 0.0,
	Enums.CityId.DUBLINO: 0.0,
	Enums.CityId.PARIGI: 0.0,
	Enums.CityId.MADRID: 0.0,
	Enums.CityId.NEW_YORK: 0.0,
	Enums.CityId.LOS_ANGELES: 0.0,
	Enums.CityId.TOKYO: 0.0
}

# Logistica di Viaggio, Jet Lag & Diario Adesivi Mezzo (Sezione 6)
var jet_lag_days: int = 0
var visited_city_stickers: Array[int] = []
var vehicle_custom_name: String = ""

# Grandi Festival Estivi & Battle of the Bands (Sezione 7)
var battle_of_bands_pass: bool = false
var festival_trophies: Array[String] = []

# Fan Club Ufficiale della Band & Fandom (Sezione 8)
const FanClubDataScript = preload("res://data/models/fan_club_data.gd")
var fan_club: RefCounted = FanClubDataScript.new()

func get_territorial_fans_summary() -> Dictionary:
	var it_fans: int = int(city_fans.get(Enums.CityId.MILANO, 0)) + int(city_fans.get(Enums.CityId.BOLOGNA, 0)) + int(city_fans.get(Enums.CityId.ROMA, 0)) + int(city_fans.get(Enums.CityId.NAPOLI, 0))
	var eu_fans: int = it_fans + int(city_fans.get(Enums.CityId.LONDRA, 0)) + int(city_fans.get(Enums.CityId.BERLINO, 0)) + int(city_fans.get(Enums.CityId.DUBLINO, 0)) + int(city_fans.get(Enums.CityId.PARIGI, 0)) + int(city_fans.get(Enums.CityId.MADRID, 0))
	var world_fans: int = eu_fans + int(city_fans.get(Enums.CityId.NEW_YORK, 0)) + int(city_fans.get(Enums.CityId.LOS_ANGELES, 0)) + int(city_fans.get(Enums.CityId.TOKYO, 0))
	return {
		"italian_fans": it_fans,
		"european_fans": eu_fans,
		"global_fans": world_fans,
		"local_city_fans": int(city_fans.get(current_city_id, 0))
	}

func get_current_city_name() -> String:
	return Enums.get_city_name(current_city_id)

func get_city_fans(city_id: int) -> int:
	return int(city_fans.get(city_id, 0))

func get_city_popularity(city_id: int) -> float:
	return float(city_popularity.get(city_id, 0.0))

# Raccolte Discografiche (EP / Album)
var albums: Array[AlbumData] = []

# Industria Discografica, Contratti & Manager (World-tour V3.0 & Sezione 9)
const ContractDataScript = preload("res://data/models/contract_data.gd")
const ManagerDataScript = preload("res://data/models/manager_data.gd")
const OwnLabelDataScript = preload("res://data/models/own_label_data.gd")

var active_contract: RefCounted = null
var active_manager: RefCounted = null
var available_contracts: Array = []
var resolved_dilemmas: Array[String] = []
var own_label: RefCounted = null

func has_active_contract() -> bool:
	return active_contract != null and active_contract.is_active

func has_manager() -> bool:
	return active_manager != null and active_manager.is_hired

func has_own_label() -> bool:
	return own_label != null and own_label.is_founded

func has_any_gold_record() -> bool:
	for a in albums:
		if a.is_released and a.total_sales >= 25000.0:
			return true
	return false

# Endgame, Certificazioni, Music Awards & Legacy (World-tour V5.0 / Sezione 11)
var certifications: Array[Dictionary] = []
var music_awards: Array[Dictionary] = []
var hall_of_fame_inducted: bool = false
var last_waltz_completed: bool = false
var legacy_ending: int = -1

func add_certification(item_id: String, item_title: String, item_type: String, tier: int, day: int) -> bool:
	for c in certifications:
		if c.get("item_id", "") == item_id and int(c.get("tier", 0)) == tier:
			return false
	certifications.append({
		"item_id": item_id,
		"title": item_title,
		"type": item_type,
		"tier": tier,
		"tier_name": Enums.get_certification_name(tier),
		"day": day
	})
	return true

func get_certifications_count(tier: int = -1) -> int:
	if tier == -1:
		return certifications.size()
	var count: int = 0
	for c in certifications:
		if int(c.get("tier", 0)) == tier:
			count += 1
	return count

func add_music_award(award_data: Dictionary) -> void:
	music_awards.append(award_data)

func has_won_award(category: int) -> bool:
	for a in music_awards:
		if int(a.get("category", -1)) == category:
			return true
	return false


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
		"stage_name": stage_name,
		"age": age,
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
		"rehearsal_tier": rehearsal_tier,
		"studio_hardware_tier": studio_hardware_tier,
		"owned_instruments": owned_instruments.duplicate(true),
		"instrument_condition": instrument_condition.duplicate(true),
		"has_backup_instrument": has_backup_instrument,
		"owned_pedals": owned_pedals.duplicate(),
		"active_pedalboard": active_pedalboard.duplicate(),
		"current_amp_tier": current_amp_tier,
		"rehearsal_sublet_active": rehearsal_sublet_active,
		"recording_philosophy": recording_philosophy,
		"band_members": serialized_members,
		"albums": serialized_albums,
		"active_contract": active_contract.to_dict() if active_contract else {},
		"active_manager": active_manager.to_dict() if active_manager else {},
		"resolved_dilemmas": resolved_dilemmas.duplicate(),
		"current_city_id": current_city_id,
		"city_fans": city_fans.duplicate(true),
		"city_popularity": city_popularity.duplicate(true),
		"jet_lag_days": jet_lag_days,
		"visited_city_stickers": visited_city_stickers.duplicate(),
		"vehicle_custom_name": vehicle_custom_name,
		"battle_of_bands_pass": battle_of_bands_pass,
		"festival_trophies": festival_trophies.duplicate(),
		"fan_club": fan_club.to_dict() if fan_club else {},
		"own_label": own_label.to_dict() if own_label else {},
		"certifications": certifications.duplicate(true),
		"music_awards": music_awards.duplicate(true),
		"hall_of_fame_inducted": hall_of_fame_inducted,
		"last_waltz_completed": last_waltz_completed,
		"legacy_ending": legacy_ending
	}

func from_dict(dict: Dictionary) -> void:
	player_name = dict.get("player_name", player_name)
	stage_name = dict.get("stage_name", stage_name)
	age = int(dict.get("age", age))
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
	jet_lag_days = int(dict.get("jet_lag_days", jet_lag_days))
	vehicle_custom_name = str(dict.get("vehicle_custom_name", vehicle_custom_name))
	battle_of_bands_pass = bool(dict.get("battle_of_bands_pass", battle_of_bands_pass))
	festival_trophies.clear()
	if dict.has("festival_trophies") and dict["festival_trophies"] is Array:
		for tr in dict["festival_trophies"]:
			festival_trophies.append(str(tr))
	if dict.has("fan_club") and dict["fan_club"] is Dictionary and not dict["fan_club"].is_empty():
		fan_club = FanClubDataScript.new()
		fan_club.from_dict(dict["fan_club"])
	else:
		fan_club = FanClubDataScript.new()
	visited_city_stickers.clear()
	if dict.has("visited_city_stickers") and dict["visited_city_stickers"] is Array:
		for st_id in dict["visited_city_stickers"]:
			visited_city_stickers.append(int(st_id))
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
	rehearsal_tier = int(dict.get("rehearsal_tier", rehearsal_tier))
	studio_hardware_tier = int(dict.get("studio_hardware_tier", studio_hardware_tier))
	if dict.has("owned_instruments") and dict["owned_instruments"] is Dictionary:
		for k in dict["owned_instruments"]:
			owned_instruments[str(k)] = int(dict["owned_instruments"][k])
	if dict.has("instrument_condition") and dict["instrument_condition"] is Dictionary:
		for k in dict["instrument_condition"]:
			instrument_condition[str(k)] = float(dict["instrument_condition"][k])
	has_backup_instrument = bool(dict.get("has_backup_instrument", has_backup_instrument))
	if dict.has("owned_pedals") and dict["owned_pedals"] is Array:
		owned_pedals.clear()
		for p in dict["owned_pedals"]:
			owned_pedals.append(str(p))
	if dict.has("active_pedalboard") and dict["active_pedalboard"] is Array:
		active_pedalboard.clear()
		for p in dict["active_pedalboard"]:
			active_pedalboard.append(str(p))
	current_amp_tier = int(dict.get("current_amp_tier", current_amp_tier))
	rehearsal_sublet_active = bool(dict.get("rehearsal_sublet_active", rehearsal_sublet_active))
	recording_philosophy = int(dict.get("recording_philosophy", recording_philosophy))
	
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

	if dict.has("own_label") and dict["own_label"] is Dictionary and not dict["own_label"].is_empty():
		own_label = OwnLabelDataScript.new()
		own_label.from_dict(dict["own_label"])
	else:
		own_label = null

	certifications.clear()
	if dict.has("certifications") and dict["certifications"] is Array:
		for c_dict in dict["certifications"]:
			if c_dict is Dictionary:
				certifications.append(c_dict.duplicate(true))

	music_awards.clear()
	if dict.has("music_awards") and dict["music_awards"] is Array:
		for a_dict in dict["music_awards"]:
			if a_dict is Dictionary:
				music_awards.append(a_dict.duplicate(true))

	hall_of_fame_inducted = bool(dict.get("hall_of_fame_inducted", hall_of_fame_inducted))
	last_waltz_completed = bool(dict.get("last_waltz_completed", last_waltz_completed))
	legacy_ending = int(dict.get("legacy_ending", legacy_ending))


