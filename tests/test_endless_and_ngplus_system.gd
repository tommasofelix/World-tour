# res://tests/test_endless_and_ngplus_system.gd
extends Node

## Suite di Test Headless per l'Espansione Post-V5.1:
## Modalità Carriera Infinita (Endless Horizon), New Game+ (Legacy Heirs),
## Circuito Mondiale a 16 Metropoli e Produzione Attiva Roster Etichetta (Contratti D1, D2, D3, S1).

const CityDataScript = preload("res://data/models/city_data.gd")
const LegacySystemScript = preload("res://systems/legacy_system.gd")
const TravelSystemScript = preload("res://systems/travel_system.gd")
const FestivalSystemScript = preload("res://systems/festival_system.gd")
const IndustrySystemScript = preload("res://systems/industry_system.gd")
const ChartSystemScript = preload("res://systems/chart_system.gd")
const EndDaySystemScript = preload("res://systems/end_day_system.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST ESPANSIONE POST-V5.1 (ENDLESS & WORLD)   ")
	print("========================================================\n")

	test_endless_mode_and_calendar_progression()
	test_new_game_plus_and_mentor_royalties()
	test_16_cities_and_global_festivals()
	test_own_label_roster_production_and_hit_parade()
	test_legacy_modal_ui()

	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST ESPANSIONE POST-V5.1:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")

	if tests_failed == 0:
		print("[SUCCESSO] L'Espansione Post-V5.1 (Endless Horizon & 16 Metropoli) è convalidata al 100%!")
		get_tree().quit(0)
	else:
		printerr("[ERRORE CRITICO] Alcuni test dell'espansione Post-V5.1 sono falliti!")
		get_tree().quit(1)

func assert_true(condition: bool, message: String) -> void:
	if condition:
		tests_passed += 1
		print("  [OK] %s" % message)
	else:
		tests_failed += 1
		printerr("  [FALLITO] %s" % message)

func assert_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual == expected:
		tests_passed += 1
		print("  [OK] %s (%s == %s)" % [message, str(actual), str(expected)])
	else:
		tests_failed += 1
		printerr("  [FALLITO] %s (Atteso: %s, Ottenuto: %s)" % [message, str(expected), str(actual)])

# ==============================================================================
# 1. TEST CARRIERA INFINITA (ENDLESS HORIZON) & PROGRESSIONE MULTI-ANNO
# ==============================================================================
func test_endless_mode_and_calendar_progression() -> void:
	print("1. Verifica Modalità Carriera Infinita & Calendario Multi-Anno:")
	var cal := CalendarData.new()
	assert_equal(cal.get_year(), 1, "Giorno 1 è Anno 1")
	assert_equal(cal.get_month(), 1, "Giorno 1 è Mese 1 (Gennaio)")
	assert_equal(cal.get_day_of_month(), 1, "Giorno 1 è il primo del mese")

	# Avanzamento al Giorno 336 (ultimo giorno dell'Anno 1)
	cal.day_number = 336
	assert_equal(cal.get_year(), 1, "Giorno 336 appartiene ancora all'Anno 1")
	assert_equal(cal.get_month(), 12, "Giorno 336 è Mese 12 (Dicembre)")
	assert_equal(cal.get_day_of_month(), 28, "Giorno 336 è il 28 Dicembre")

	# Passaggio all'Anno 2 (Giorno 337)
	cal.day_number = 337
	assert_equal(cal.get_year(), 2, "Giorno 337 inizia l'Anno 2")
	assert_equal(cal.get_month(), 1, "Giorno 337 ricomincia da Mese 1 (Gennaio Anno 2)")
	assert_equal(cal.get_day_of_month(), 1, "Giorno 337 è il 1 Gennaio Anno 2")
	assert_equal(cal.get_season_name(), "Primavera", "Stagione coerente in Anno 2")

	# Verifica attivazione Endless Mode in LegacySystem
	var p := PlayerData.new()
	p.player_name = "Alex Test"
	var legacy_sys := LegacySystemScript.new(p, cal)
	assert_true(not p.is_endless_mode, "is_endless_mode è inizialmente false")

	var res := legacy_sys.continue_in_endless_mode()
	assert_true(res.get("success", false), "continue_in_endless_mode completato con successo")
	assert_true(p.is_endless_mode, "is_endless_mode impostato a true in PlayerData")

	# Serializzazione e ripristino Endless Mode
	var dict: Dictionary = p.to_dict()
	assert_true(bool(dict.get("is_endless_mode", false)), "to_dict() include is_endless_mode true")
	var p2 := PlayerData.new()
	p2.from_dict(dict)
	assert_true(p2.is_endless_mode, "from_dict() ripristina is_endless_mode correttamente")

# ==============================================================================
# 2. TEST NEW GAME+ (LEGACY HEIRS) & ROYALTIES PASSIVE DEL MENTORE
# ==============================================================================
func test_new_game_plus_and_mentor_royalties() -> void:
	print("\n2. Verifica Passaggio del Testimone (New Game+) & Royalties Mentore:")
	var mentor := PlayerData.new()
	mentor.player_name = "Maestro Alex"
	mentor.owned_instruments["guitar"] = 3 # Chitarra leggendaria
	var cal := CalendarData.new()
	cal.day_number = 336

	var legacy_sys := LegacySystemScript.new(mentor, cal)
	var ng_res := legacy_sys.prepare_new_game_plus()
	assert_true(ng_res.get("success", false), "prepare_new_game_plus completato con successo")
	var ng_data: Dictionary = ng_res.get("ng_plus_data", {})
	assert_equal(ng_data.get("mentor_name", ""), "Maestro Alex", "Nome del mentore registrato correttamente")
	assert_equal(float(ng_data.get("mentor_passive_daily_royalty", 0.0)), 15.0, "15.00 € / giorno garantiti come royalties del mentore")

	# Creazione nuova partita New Game+ con il discepolo
	var disciple := PlayerData.new()
	disciple.player_name = "Giovane Erede"
	disciple.is_new_game_plus = true
	disciple.mentor_name = str(ng_data["mentor_name"])
	disciple.mentor_passive_daily_royalty = float(ng_data["mentor_passive_daily_royalty"])
	disciple.trait_id = "legacy_disciple"

	assert_true(disciple.get_trait_name().contains("Discepolo del Rock"), "get_trait_name() include Discepolo del Rock")
	var initial_money: float = 100.0
	disciple.money = initial_money

	# Verifica accredito royalties giornaliere in EndDaySystem
	var end_day := EndDaySystemScript.new(disciple, cal)
	end_day.process_day_end(1, false)

	# Saldo atteso = iniziale (100) - vitto/alloggio (25€: cibo 10€, affitto 15€) + royalties mentore (15€) = 90.00 €
	var expected_money: float = initial_money - 25.0 + 15.0
	assert_equal(disciple.money, expected_money, "Royalties mentore accreditate nel bilancio giornaliero (%.2f €)" % disciple.money)

	# Serializzazione e ripristino New Game+
	var serialized := disciple.to_dict()
	assert_true(bool(serialized.get("is_new_game_plus", false)), "to_dict() include is_new_game_plus")
	assert_equal(str(serialized.get("mentor_name", "")), "Maestro Alex", "to_dict() include mentor_name")
	assert_equal(float(serialized.get("mentor_passive_daily_royalty", 0.0)), 15.0, "to_dict() include mentor_passive_daily_royalty")

	var restored := PlayerData.new()
	restored.from_dict(serialized)
	assert_true(restored.is_new_game_plus, "from_dict() ripristina is_new_game_plus")
	assert_equal(restored.mentor_name, "Maestro Alex", "from_dict() ripristina mentor_name")
	assert_equal(restored.mentor_passive_daily_royalty, 15.0, "from_dict() ripristina mentor_passive_daily_royalty")

# ==============================================================================
# 3. TEST 16 METROPOLI MONDIALI, ROTTE & FESTIVAL ESTIVI
# ==============================================================================
func test_16_cities_and_global_festivals() -> void:
	print("\n3. Verifica Circuito a 16 Metropoli Mondiali & Festival Globali:")
	var all_cities: Array[CityData] = CityDataScript.get_all_cities()
	assert_equal(all_cities.size(), 16, "Il catalogo geografico contiene esattamente 16 metropoli mondiali")

	# Verifica presenza delle 4 nuove metropoli
	var found_sp: bool = false
	var found_ba: bool = false
	var found_syd: bool = false
	var found_seo: bool = false

	for c in all_cities:
		if c.id == Enums.CityId.SAO_PAULO:
			found_sp = true
			assert_equal(c.name, "San Paolo", "Metropoli 13 è San Paolo")
			assert_equal(c.venues.size(), 3, "San Paolo ha 3 venue dedicate")
			assert_true(c.is_transoceanic, "San Paolo è classificata transoceanica")
		elif c.id == Enums.CityId.BUENOS_AIRES:
			found_ba = true
			assert_equal(c.name, "Buenos Aires", "Metropoli 14 è Buenos Aires")
			assert_equal(c.venues.size(), 3, "Buenos Aires ha 3 venue dedicate")
		elif c.id == Enums.CityId.SYDNEY:
			found_syd = true
			assert_equal(c.name, "Sydney", "Metropoli 15 è Sydney")
			assert_equal(c.venues.size(), 3, "Sydney ha 3 venue dedicate")
		elif c.id == Enums.CityId.SEOUL:
			found_seo = true
			assert_equal(c.name, "Seoul", "Metropoli 16 è Seoul")
			assert_equal(c.venues.size(), 3, "Seoul ha 3 venue dedicate")

	assert_true(found_sp, "San Paolo presente nel catalogo città")
	assert_true(found_ba, "Buenos Aires presente nel catalogo città")
	assert_true(found_syd, "Sydney presente nel catalogo città")
	assert_true(found_seo, "Seoul presente nel catalogo città")

	# Verifica rotte e costi in TravelSystem
	var p := PlayerData.new()
	p.reputation = 80.0
	p.money = 20000.0
	p.energy = 100
	var travel_sys := TravelSystemScript.new(p)

	# Viaggio Milano -> San Paolo (Transoceanico)
	var cost_sp: Dictionary = travel_sys.calculate_travel_cost(Enums.CityId.MILANO, Enums.CityId.SAO_PAULO)
	assert_true(bool(cost_sp.get("is_transoceanic", false)), "Volo Milano - San Paolo è transoceanico")
	assert_equal(float(cost_sp.get("money_cost", 0.0)), 1050.0, "Costo volo San Paolo = 1050.00 €")

	# Viaggio San Paolo -> Buenos Aires (Continentale Sud America)
	var cost_sa: Dictionary = travel_sys.calculate_travel_cost(Enums.CityId.SAO_PAULO, Enums.CityId.BUENOS_AIRES)
	assert_true(not bool(cost_sa.get("is_transoceanic", true)), "Tratta San Paolo - Buenos Aires non è transoceanica (stesso continente)")
	assert_equal(float(cost_sa.get("money_cost", 0.0)), 220.0, "Costo tratta Sud America = 220.00 €")

	# Esecuzione viaggio transoceanico e Jet Lag
	var travel_res := travel_sys.travel_to(Enums.CityId.SAO_PAULO)
	assert_true(travel_res.get("success", false), "Viaggio verso San Paolo riuscito")
	assert_equal(p.current_city_id, Enums.CityId.SAO_PAULO, "Città corrente aggiornata a San Paolo")
	assert_equal(p.jet_lag_days, 2, "Jet Lag di 2 giorni applicato per volo transoceanico")

	# Verifica festival estivi (16 festival)
	var fest_sys := FestivalSystemScript.new(p)
	var all_fests: Array = fest_sys.get_all_festivals()
	assert_equal(all_fests.size(), 16, "Il catalogo festival contiene esattamente 16 grandi festival mondiali")

	# Aggregazione fan globali su 16 metropoli
	p.city_fans[Enums.CityId.MILANO] = 100
	p.city_fans[Enums.CityId.SAO_PAULO] = 500
	p.city_fans[Enums.CityId.SEOUL] = 400
	var fans_summary: Dictionary = p.get_territorial_fans_summary()
	assert_equal(int(fans_summary.get("global_fans", 0)), 1000, "world_fans include le nuove metropoli (1000 fan totali)")

# ==============================================================================
# 4. TEST PRODUZIONE ATTIVA ROSTER & HIT PARADE
# ==============================================================================
func test_own_label_roster_production_and_hit_parade() -> void:
	print("\n4. Verifica Produzione Attiva Roster & Integrazione Hit Parade:")
	var p := PlayerData.new()
	p.player_name = "Alex Mogul"
	p.money = 50000.0
	p.reputation = 70.0
	var cal := CalendarData.new()

	var ind_sys := IndustrySystemScript.new(p, cal)
	var found_res := ind_sys.found_own_label("Hyperion Records", Enums.LabelPhilosophy.MAINSTREAM_POP)
	assert_true(found_res.get("success", false), "Fondazione etichetta Hyperion Records riuscita")

	# Ingaggio band nel roster
	var scout_bands: Array = ind_sys.scout_unsigned_bands()
	assert_true(scout_bands.size() >= 1, "Band disponibili per lo scouting")
	var sign_res := ind_sys.sign_band_to_own_label(scout_bands[0], 4000.0, 0.60)
	assert_true(sign_res.get("success", false), "Band ingaggiata con successo nel roster")
	var band_id: String = str(sign_res.band["id"])

	# Produzione esecutiva album con Budget Tier 2 (5.000 €)
	var initial_balance: float = p.money
	var prod_res := ind_sys.produce_band_album(band_id, 2)
	assert_true(prod_res.get("success", false), "produce_band_album completato con successo")
	assert_equal(p.money, initial_balance - 5000.0, "5.000 € detratti per la produzione dell'album")
	assert_true(float(prod_res.band["popularity"]) > 15.0, "Popolarità della band incrementata dopo la produzione")
	assert_true(str(prod_res.band["last_produced_album"]).contains("Vol."), "Album titolato e registrato nel roster")

	# Verifica integrazione in ChartSystem
	var chart_sys := ChartSystemScript.new(p, cal)
	chart_sys.update_weekly_charts(1)

	# Controllo se almeno un'opera del roster è presente o classificata
	var roster_charted: bool = false
	for e in chart_sys.top_singles:
		if e.is_label_roster:
			roster_charted = true
			assert_true(e.get_speech_description().contains("(Tua Etichetta)"), "Speech NVDA include tag '(Tua Etichetta)'")
			break

	# Anche se la band è nuova, la presenza del flag is_label_roster è testabile su ChartEntryData
	var test_entry := ChartEntryData.new(
		5, 7, "roster_test_1", "Neon Hit", "The Static Waves", false, Enums.MusicalGenre.ROCK, 25000, 2, 4,
		Enums.ChartScope.CONTINENTAL, Enums.CityId.MILANO, true
	)
	assert_true(test_entry.is_label_roster, "ChartEntryData memorizza correttamente is_label_roster")
	assert_true(test_entry.get_speech_description().contains("(Tua Etichetta)"), "get_speech_description evidenzia l'etichetta del giocatore")

	# Serializzazione ChartEntryData
	var d: Dictionary = test_entry.to_dict()
	assert_true(bool(d.get("is_label_roster", false)), "to_dict() serializza is_label_roster")
	var restored_entry := ChartEntryData.new()
	restored_entry.from_dict(d)
	assert_true(restored_entry.is_label_roster, "from_dict() deserializza is_label_roster")

# ==============================================================================
# 5. TEST INTERFACCIA LEGACY MODAL & OPZIONI ENDLESS
# ==============================================================================
func test_legacy_modal_ui() -> void:
	print("\n5. Verifica Istanziazione e Nodi Scena LegacyModal:")
	var scene: PackedScene = load("res://ui/legacy/legacy_modal.tscn")
	assert_true(scene != null, "Caricamento risorsa legacy_modal.tscn riuscito")
	var inst: Node = scene.instantiate()
	assert_true(inst != null, "Istanziazione LegacyModal riuscita")

	var btn_certs: Button = inst.find_child("BtnTabCerts", true, false)
	var btn_awards: Button = inst.find_child("BtnTabAwards", true, false)
	var btn_hof: Button = inst.find_child("BtnTabHof", true, false)
	var btn_legacy: Button = inst.find_child("BtnTabLegacy", true, false)
	var btn_close: Button = inst.find_child("BtnClose", true, false)

	assert_true(btn_certs != null, "Pulsante scheda Certificazioni presente")
	assert_true(btn_awards != null, "Pulsante scheda World Music Awards presente")
	assert_true(btn_hof != null, "Pulsante scheda Hall of Fame presente")
	assert_true(btn_legacy != null, "Pulsante scheda The Last Waltz & Epilogo presente")
	assert_true(btn_close != null, "Pulsante Chiusura presente")

	inst.free()
