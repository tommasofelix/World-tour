# res://tests/test_industry_system.gd
extends Node

## Suite di Test Headless per l'Industria Musicale, Contratti & Manager (World-tour V3.0)

const IndustrySystemScript = preload("res://systems/industry_system.gd")
const ContractDataScript = preload("res://data/models/contract_data.gd")
const ManagerDataScript = preload("res://data/models/manager_data.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST INDUSTRIA, CONTRATTI & MANAGER (V3.0)     ")
	print("========================================================")
	
	test_contract_and_manager_models()
	test_contract_offers_generation()
	test_contract_signing_and_advances()
	test_recoupment_mechanics()
	test_album_delivery_and_completion()
	test_contract_cancellation()
	test_manager_lifecycle_and_concert_cuts()
	test_ui_scene_instantiation()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST INDUSTRIA E CONTRATTI:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed == 0:
		print("[SUCCESSO] Il sistema dell'Industria Musicale V3.0 è convalidato al 100%!")
		get_tree().quit(0)
	else:
		printerr("[ERRORE CRITICO] Alcuni test dell'industria sono falliti!")
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

# 1. Modelli ContractData e ManagerData
func test_contract_and_manager_models() -> void:
	print("\n1. Verifica Modelli Dati ContractData e ManagerData:")
	var c = ContractDataScript.new("c_01", "Test Records", Enums.ContractType.INDIE_LABEL, 5000.0, 0.45, 2, 0.0)
	assert_equal(c.label_name, "Test Records", "Nome etichetta impostato")
	assert_equal(c.contract_type, Enums.ContractType.INDIE_LABEL, "Tipo Indie Label")
	assert_equal(c.advance_amount, 5000.0, "Anticipo 5000 €")
	assert_equal(c.unrecouped_debt, 5000.0, "Debito iniziale = anticipo")
	assert_true(not c.is_recouped(), "Inizialmente non recouped")
	
	var c_dict: Dictionary = c.to_dict()
	var c_loaded = ContractDataScript.new()
	c_loaded.from_dict(c_dict)
	assert_equal(c_loaded.id, "c_01", "Ripristino id da serializzazione")
	assert_equal(c_loaded.advance_amount, 5000.0, "Ripristino anticipo")
	
	var m = ManagerDataScript.new("m_01", "Matteo", Enums.ManagerType.TRUSTED_FRIEND)
	assert_equal(m.commission_pct, Constants.MANAGER_FRIEND_COMMISSION, "Commissione amico fidato = 10%")
	assert_equal(m.booking_cachet_multiplier, Constants.MANAGER_FRIEND_CACHET_MULT, "Moltiplicatore cachet amico = 1.10x")

# 2. Generazione Offerte Contrattuali
func test_contract_offers_generation() -> void:
	print("\n2. Verifica Generazione Offerte Contrattuali (Tier, Fan, Reputazione):")
	var player := PlayerData.new()
	var cal := CalendarData.new()
	var ind_sys = IndustrySystemScript.new(player, cal)
	
	# Principiante assoluto: nessuna offerta
	player.reputation = 2.0
	player.fans = 10
	var initial_offers: Array = ind_sys.refresh_contract_offers()
	assert_true(initial_offers.is_empty(), "Nessuna offerta per artista principiante")
	
	# Artista Locale con 15.0 rep: prime offerte Indie
	player.reputation = 20.0
	player.fans = 150
	var indie_offers: Array = ind_sys.refresh_contract_offers()
	assert_true(indie_offers.size() >= 1, "Offerte Indie generate con reputazione adeguata")
	assert_equal(indie_offers[0].contract_type, Enums.ContractType.INDIE_LABEL, "Prima offerta è di tipo Indie")
	
	# Stella Nazionale con 60.0 rep e 2000 fan: offerte Major
	player.reputation = 60.0
	player.fans = 2500
	var major_offers: Array = ind_sys.refresh_contract_offers()
	assert_true(major_offers.size() >= 3, "Offerte estese a Major con alta reputazione")
	var has_major: bool = false
	for o in major_offers:
		if o.contract_type == Enums.ContractType.MAJOR_LABEL:
			has_major = true
			break
	assert_true(has_major, "Trovata offerta di una Major Multinazionale")

# 3. Firma Contratto e Accredito Anticipi
func test_contract_signing_and_advances() -> void:
	print("\n3. Verifica Firma Contratto e Accredito Anticipi:")
	var player := PlayerData.new()
	player.money = 100.0
	player.reputation = 35.0
	player.fans = 600
	var cal := CalendarData.new()
	var ind_sys = IndustrySystemScript.new(player, cal)
	
	var offers: Array = ind_sys.refresh_contract_offers()
	var target_contract = offers[0]
	var advance: float = float(target_contract.advance_amount)
	
	var res: Dictionary = ind_sys.sign_contract(target_contract.id)
	assert_true(res.success, "Firma del contratto riuscita")
	assert_true(player.has_active_contract(), "Player ha contratto attivo")
	assert_equal(player.money, 100.0 + advance, "Anticipo accreditato sul saldo")
	assert_equal(player.active_contract.unrecouped_debt, advance, "Debito di recoupment impostato")
	
	# Tentativo di firmare un secondo contratto mentre si è sotto contratto
	var second_res: Dictionary = ind_sys.sign_contract("any_id")
	assert_true(not second_res.success, "Rifiutata firma concorrente se già sotto contratto")

# 4. Meccanismo di Recoupment (Recupero Anticipi sulle Royalties)
func test_recoupment_mechanics() -> void:
	print("\n4. Verifica Meccanismo di Recoupment (Abbattimento Debito su Royalties):")
	var player := PlayerData.new()
	player.money = 0.0
	var cal := CalendarData.new()
	var ind_sys = IndustrySystemScript.new(player, cal)
	
	var contract = ContractDataScript.new("recoup_test", "Major Sound", Enums.ContractType.MAJOR_LABEL, 1000.0, 0.20, 2, 50.0)
	contract.is_active = true
	player.active_contract = contract
	
	# Prima tranche royalties: 2000 € lordi -> artista spetta il 20% = 400 €
	# Il debito scende da 1000 a 600 €, artista riceve 0 €
	var recoup_1: Dictionary = ind_sys.process_royalties_recoupment(2000.0)
	assert_equal(recoup_1.recouped_by_label, 400.0, "Etichetta recupera 400 € di debito")
	assert_equal(recoup_1.artist_received, 0.0, "Artista riceve 0 € finché c'è debito")
	assert_equal(contract.unrecouped_debt, 600.0, "Debito residuo = 600 €")
	assert_true(not contract.is_recouped(), "Non ancora recouped")
	
	# Seconda tranche: 4000 € lordi -> artista spetta 20% = 800 €
	# Debito 600 € viene estinto interamente, eccedenza di 200 € va all'artista!
	var recoup_2: Dictionary = ind_sys.process_royalties_recoupment(4000.0)
	assert_equal(recoup_2.recouped_by_label, 600.0, "Etichetta recupera gli ultimi 600 €")
	assert_equal(recoup_2.artist_received, 200.0, "Artista incassa l'eccedenza di 200 €")
	assert_equal(contract.unrecouped_debt, 0.0, "Debito residuo azzerato a 0 €")
	assert_true(contract.is_recouped(), "Contratto ufficialmente RECOUPED")

# 5. Consegna Dischi e Completamento Contratto
func test_album_delivery_and_completion() -> void:
	print("\n5. Verifica Consegna Dischi e Completamento Obblighi Contrattuali:")
	var player := PlayerData.new()
	var cal := CalendarData.new()
	var ind_sys = IndustrySystemScript.new(player, cal)
	
	var contract = ContractDataScript.new("delivery_test", "Indie Art", Enums.ContractType.INDIE_LABEL, 4000.0, 0.45, 2, 0.0)
	contract.is_active = true
	player.active_contract = contract
	
	var album_1 := AlbumData.new("a1", "Debut", Enums.AlbumType.EP)
	album_1.overall_quality = 60.0
	var del_1: Dictionary = ind_sys.process_album_delivery(album_1)
	assert_equal(del_1.delivered, 1, "Primo album consegnato (1/2)")
	assert_true(not del_1.is_completed, "Contratto non ancora ultimato")
	assert_true(player.has_active_contract(), "Contratto ancora attivo")
	
	var album_2 := AlbumData.new("a2", "Sophomore", Enums.AlbumType.LP)
	album_2.overall_quality = 70.0
	var del_2: Dictionary = ind_sys.process_album_delivery(album_2)
	assert_equal(del_2.delivered, 2, "Secondo album consegnato (2/2)")
	assert_true(del_2.is_completed, "Contratto completato al 100%")
	assert_true(not player.has_active_contract(), "Artista torna libero dopo la scadenza")

# 6. Rescissione Contratto
func test_contract_cancellation() -> void:
	print("\n6. Verifica Rescissione Contratto e Penalità:")
	var player := PlayerData.new()
	player.reputation = 50.0
	var cal := CalendarData.new()
	var ind_sys = IndustrySystemScript.new(player, cal)
	
	var contract = ContractDataScript.new("cancel_test", "Bad Deal Records", Enums.ContractType.MAJOR_LABEL, 50000.0, 0.12, 3, 70.0)
	contract.is_active = true
	player.active_contract = contract
	
	var cancel_res: Dictionary = ind_sys.cancel_contract()
	assert_true(cancel_res.success, "Rescissione eseguita con successo")
	assert_true(not player.has_active_contract(), "Player non ha più contratto attivo")
	assert_equal(player.reputation, 35.0, "Applicata penalità di 15 punti reputazione (50 -> 35)")

# 7. Ciclo Vitale Manager e Provvigioni Live
func test_manager_lifecycle_and_concert_cuts() -> void:
	print("\n7. Verifica Manager (Ingaggio, Provvigione Concerti, Sgravio Stress, Licenziamento):")
	var player := PlayerData.new()
	player.money = 500.0
	player.stress = 40
	var cal := CalendarData.new()
	var ind_sys = IndustrySystemScript.new(player, cal)
	
	# Tentativo ingaggio squalo senza fondi (costa 2000 €)
	var fail_shark: Dictionary = ind_sys.hire_manager(Enums.ManagerType.INDUSTRY_SHARK)
	assert_true(not fail_shark.success, "Rifiutato ingaggio squalo per fondi insufficienti")
	
	# Ingaggio Professionista Indipendente (costa 400 €)
	var hire_pro: Dictionary = ind_sys.hire_manager(Enums.ManagerType.PRO_INDIE)
	assert_true(hire_pro.success, "Ingaggio manager professionista riuscito")
	assert_true(player.has_manager(), "Player ha un manager attivo")
	assert_equal(player.money, 100.0, "Detratta tariffa di 400 € dal saldo (500 -> 100)")
	
	# Calcolo provvigione concerto live (cachet base 100 € -> con pro mult 1.25x = 125 €, provvigione 15% = 18.75 €, netto band = 106.25 €)
	var cut_calc: Dictionary = ind_sys.calculate_live_concert_revenue(100.0)
	assert_equal(cut_calc.gross_cachet, 125.0, "Cachet aumentato a 125 € grazie al booking pro")
	assert_equal(cut_calc.manager_cut, 18.75, "Provvigione manager del 15% = 18.75 €")
	assert_equal(cut_calc.net_band_revenue, 106.25, "Netto band = 106.25 € (> 100 € base)")
	
	# Sgravio stress giornaliero (-2.5 stress)
	var relief: float = ind_sys.apply_daily_manager_stress_relief()
	assert_true(relief > 2.0, "Applicato sgravio stress dal manager")
	assert_true(player.stress < 40, "Stress sceso sotto 40 (attuale: %d)" % player.stress)
	
	# Licenziamento manager
	var fire_res: Dictionary = ind_sys.fire_manager()
	assert_true(fire_res.success, "Licenziamento manager riuscito")
	assert_true(not player.has_manager(), "Player non ha più manager")

# 8. Verifica Istanziazione e Nodi Scene UI (IndustryHub & DilemmaModal)
func test_ui_scene_instantiation() -> void:
	print("\n8. Verifica Istanziazione e Nodi Scene UI (IndustryHub & DilemmaModal):")
	
	# IndustryHub
	var hub_res = load("res://ui/industry/industry_hub.tscn")
	assert_true(hub_res != null, "Risorsa industry_hub.tscn caricata")
	if hub_res:
		var hub_inst = hub_res.instantiate()
		assert_true(hub_inst != null, "Istanziazione IndustryHub riuscita")
		if hub_inst:
			var tab_c = hub_inst.get_node_or_null("PanelMain/VBox/HBoxTabs/BtnTabContracts")
			var tab_m = hub_inst.get_node_or_null("PanelMain/VBox/HBoxTabs/BtnTabManagers")
			var btn_ref = hub_inst.get_node_or_null("PanelMain/VBox/TabContracts/HBoxOffersHeader/BtnRefreshOffers")
			var btn_res = hub_inst.get_node_or_null("PanelMain/VBox/TabContracts/PanelActiveContract/VBox/HBoxActions/BtnRescindContract")
			var btn_fire = hub_inst.get_node_or_null("PanelMain/VBox/TabManagers/PanelActiveManager/VBox/HBoxActions/BtnFireManager")
			var btn_cls = hub_inst.get_node_or_null("PanelMain/VBox/HBoxFooter/BtnClose")
			
			assert_true(tab_c != null, "Pulsante Tab Contratti presente")
			assert_true(tab_m != null, "Pulsante Tab Manager presente")
			assert_true(btn_ref != null, "Pulsante Cerca Offerte presente")
			assert_true(btn_res != null, "Pulsante Rescindi Contratto presente")
			assert_true(btn_fire != null, "Pulsante Licenzia Manager presente")
			assert_true(btn_cls != null, "Pulsante Chiudi presente")
			hub_inst.queue_free()
			
	# DilemmaModal
	var dil_res = load("res://ui/industry/dilemma_modal.tscn")
	assert_true(dil_res != null, "Risorsa dilemma_modal.tscn caricata")
	if dil_res:
		var dil_inst = dil_res.instantiate()
		assert_true(dil_inst != null, "Istanziazione DilemmaModal riuscita")
		if dil_inst:
			var lbl_t = dil_inst.get_node_or_null("PanelMain/VBox/Header/LabelTitle")
			var btn_opt1 = dil_inst.get_node_or_null("PanelMain/VBox/VBoxOptions/PanelOption1/VBox/BtnOption1")
			var btn_opt2 = dil_inst.get_node_or_null("PanelMain/VBox/VBoxOptions/PanelOption2/VBox/BtnOption2")
			
			assert_true(lbl_t != null, "Label Titolo Dilemma presente")
			assert_true(btn_opt1 != null, "Pulsante Opzione 1 presente")
			assert_true(btn_opt2 != null, "Pulsante Opzione 2 presente")
			dil_inst.queue_free()

