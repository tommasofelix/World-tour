# res://tests/test_industry_system.gd
extends Node

## Suite di Test Headless per l'Industria Musicale, Contratti & Manager (World-tour V3.0 & Sezione 9)

const IndustrySystemScript = preload("res://systems/industry_system.gd")
const ContractDataScript = preload("res://data/models/contract_data.gd")
const ManagerDataScript = preload("res://data/models/manager_data.gd")
const OwnLabelDataScript = preload("res://data/models/own_label_data.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST INDUSTRIA, CONTRATTI & MANAGER (SEZIONE 9)  ")
	print("========================================================")
	
	test_contract_and_manager_models()
	test_contract_offers_generation()
	test_contract_signing_and_advances()
	test_recoupment_mechanics()
	test_album_delivery_and_completion()
	test_contract_cancellation()
	test_physical_distribution()
	test_contract_renegotiation()
	test_master_buyback()
	test_manager_lifecycle_and_concert_cuts()
	test_own_independent_label_endgame()
	test_ui_scene_instantiation()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST INDUSTRIA E CONTRATTI:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed == 0:
		print("[SUCCESSO] Il sistema dell'Industria Musicale Sezione 9 è convalidato al 100%!")
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

# 1. Modelli ContractData, ManagerData e OwnLabelData
func test_contract_and_manager_models() -> void:
	print("\n1. Verifica Modelli Dati ContractData, ManagerData e OwnLabelData:")
	var c = ContractDataScript.new("c_01", "Test Records", Enums.ContractType.INDIE_LABEL, 5000.0, 0.45, 2, 0.0)
	assert_equal(c.label_name, "Test Records", "Nome etichetta impostato")
	assert_equal(c.contract_type, Enums.ContractType.INDIE_LABEL, "Tipo Indie Label")
	assert_equal(c.advance_amount, 5000.0, "Anticipo 5000 €")
	assert_equal(c.unrecouped_debt, 5000.0, "Debito iniziale = anticipo")
	assert_true(not c.is_recouped(), "Inizialmente non recouped")
	assert_true(not c.has_physical_distribution, "Distribuzione fisica disattivata di default")
	
	var c_dict: Dictionary = c.to_dict()
	var c_loaded = ContractDataScript.new()
	c_loaded.from_dict(c_dict)
	assert_equal(c_loaded.id, "c_01", "Ripristino id da serializzazione")
	assert_equal(c_loaded.advance_amount, 5000.0, "Ripristino anticipo")
	
	var m = ManagerDataScript.new("m_01", "Matteo", Enums.ManagerType.TRUSTED_FRIEND)
	assert_equal(m.commission_pct, Constants.MANAGER_FRIEND_COMMISSION, "Commissione amico fidato = 10%")
	assert_equal(m.booking_cachet_multiplier, Constants.MANAGER_FRIEND_CACHET_MULT, "Moltiplicatore cachet amico = 1.10x")
	assert_equal(m.trust, 60.0, "Fiducia iniziale amico fidato = 60%")
	assert_equal(m.get_severance_fee(), 0.0, "Penale licenziamento amico fidato = 0 €")
	
	var shark = ManagerDataScript.new("m_shark", "Vittorio", Enums.ManagerType.INDUSTRY_SHARK)
	assert_equal(shark.nocturnal_stress_rate, 4.0, "Stress notturno dello squalo = 4.0")
	assert_equal(shark.daily_stress_relief, 0.0, "Sgravio stress diurno squalo = 0.0")
	assert_equal(shark.get_severance_fee(), 1500.0, "Penale licenziamento squalo = 1.500 €")
	
	var label = OwnLabelDataScript.new("Velvet Underground", Enums.LabelPhilosophy.UNDERGROUND_INDIE)
	assert_equal(label.label_name, "Velvet Underground", "Nome etichetta propria impostato")
	assert_equal(label.philosophy, Enums.LabelPhilosophy.UNDERGROUND_INDIE, "Filosofia etichetta corretta")
	assert_true(label.is_founded, "Etichetta marcata come fondata")
	
	var l_dict: Dictionary = label.to_dict()
	var l_loaded = OwnLabelDataScript.new()
	l_loaded.from_dict(l_dict)
	assert_equal(l_loaded.label_name, "Velvet Underground", "Ripristino etichetta da serializzazione")

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
	var recoup_1: Dictionary = ind_sys.process_royalties_recoupment(2000.0)
	assert_equal(recoup_1.recouped_by_label, 400.0, "Etichetta recupera 400 € di debito")
	assert_equal(recoup_1.artist_received, 0.0, "Artista riceve 0 € finché c'è debito")
	assert_equal(contract.unrecouped_debt, 600.0, "Debito residuo = 600 €")
	assert_true(not contract.is_recouped(), "Non ancora recouped")
	
	# Seconda tranche: 4000 € lordi -> artista spetta 20% = 800 €
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

# 7. Distribuzione Fisica Esclusiva
func test_physical_distribution() -> void:
	print("\n7. Verifica Distribuzione Fisica Esclusiva (Attivazione e Revoca):")
	var player := PlayerData.new()
	var cal := CalendarData.new()
	var ind_sys = IndustrySystemScript.new(player, cal)
	
	var contract = ContractDataScript.new("dist_test", "Continental Dist", Enums.ContractType.INDIE_LABEL, 5000.0, 0.45, 2, 0.0)
	contract.is_active = true
	player.active_contract = contract
	
	var dist_res: Dictionary = ind_sys.sign_physical_distribution()
	assert_true(dist_res.success, "Attivazione distribuzione fisica riuscita")
	assert_true(contract.has_physical_distribution, "Flag distribuzione fisica attivo")
	
	var cancel_dist: Dictionary = ind_sys.cancel_physical_distribution()
	assert_true(cancel_dist.success, "Disdetta distribuzione fisica riuscita")
	assert_true(not contract.has_physical_distribution, "Flag distribuzione fisica revocato")

# 8. Rinegoziazione Contrattuale
func test_contract_renegotiation() -> void:
	print("\n8. Verifica Rinegoziazione Contrattuale su Reputazione e Dischi d'Oro:")
	var player := PlayerData.new()
	player.reputation = 30.0
	var cal := CalendarData.new()
	var ind_sys = IndustrySystemScript.new(player, cal)
	
	var contract = ContractDataScript.new("reneg_test", "Major Titan", Enums.ContractType.MAJOR_LABEL, 60000.0, 0.15, 3, 65.0)
	contract.is_active = true
	player.active_contract = contract
	
	# Tentativo 1: Reputazione troppo bassa e zero dischi d'oro
	var fail_reneg: Dictionary = ind_sys.renegotiate_contract(0.25)
	assert_true(not fail_reneg.success, "Rinegoziazione respinta per requisiti insufficienti")
	assert_equal(contract.royalty_rate, 0.15, "Royalty rimasta al 15%")
	
	# Tentativo 2: Conquista Disco d'Oro (album con >= 25.000 copie vendute)
	var gold_album := AlbumData.new("gold_01", "Masterpiece", Enums.AlbumType.LP)
	gold_album.is_released = true
	gold_album.total_sales = 26000.0
	player.add_album(gold_album)
	assert_true(player.has_any_gold_record(), "Player possiede ufficialmente un Disco d'Oro")
	
	var success_reneg: Dictionary = ind_sys.renegotiate_contract(0.25)
	assert_true(success_reneg.success, "Rinegoziazione approvata grazie al Disco d'Oro!")
	assert_equal(contract.royalty_rate, 0.25, "Royalty innalzata al 25%")
	assert_true(contract.is_renegotiated, "Contratto marcato come rinegoziato")
	
	# Tentativo 3: Tentativo di rinegoziare nuovamente
	var second_reneg: Dictionary = ind_sys.renegotiate_contract(0.30)
	assert_true(not second_reneg.success, "Rifiutata seconda rinegoziazione sullo stesso accordo")

# 9. Riscatto Master Originali (Master Buyback)
func test_master_buyback() -> void:
	print("\n9. Verifica Riscatto Master Originali (Master Buyback):")
	var player := PlayerData.new()
	player.money = 25000.0
	var cal := CalendarData.new()
	var ind_sys = IndustrySystemScript.new(player, cal)
	
	var contract = ContractDataScript.new("buyback_contract", "Old Label", Enums.ContractType.INDIE_LABEL, 8000.0, 0.45, 2, 0.0)
	contract.is_active = true
	player.active_contract = contract
	
	var album := AlbumData.new("album_classic", "First Album", Enums.AlbumType.LP)
	album.is_released = true
	album.total_sales = 10000.0
	player.add_album(album)
	
	var buy_res: Dictionary = ind_sys.buyback_album_master(album.id)
	assert_true(buy_res.success, "Riscatto master completato")
	assert_true(contract.is_master_bought_back(album.id), "Master dell'album risulta riscattato")
	assert_true(player.money < 25000.0, "Costo riscatto detratto dal conto del giocatore")
	
	# Tentativo di riacquistare lo stesso master già riscattato
	var dup_res: Dictionary = ind_sys.buyback_album_master(album.id)
	assert_true(not dup_res.success, "Rifiutato acquisto master già riscattato")

# 10. Ciclo Vitale Manager, Fiducia, Telefonate Notturne, Tutela Legale e Penale
func test_manager_lifecycle_and_concert_cuts() -> void:
	print("\n10. Verifica Manager Avanzato (Fiducia, Promesse, Chiamate Notturne, Avvocato e Penale):")
	var player := PlayerData.new()
	player.money = 2000.0
	player.stress = 30
	var cal := CalendarData.new()
	var ind_sys = IndustrySystemScript.new(player, cal)
	
	# Ingaggio Professionista Indipendente (costa 400 €)
	var hire_pro: Dictionary = ind_sys.hire_manager(Enums.ManagerType.PRO_INDIE)
	assert_true(hire_pro.success, "Ingaggio manager professionista riuscito")
	assert_equal(player.money, 1600.0, "Saldo dopo ingaggio = 1600 €")
	
	# Modifica fiducia del manager
	var new_trust: float = ind_sys.adjust_manager_trust(20.0)
	assert_equal(new_trust, 70.0, "Fiducia salita a 70%")
	
	# Generazione e completamento promessa professionale
	var prom: Dictionary = ind_sys.generate_manager_promise()
	assert_true(not prom.is_empty(), "Promessa del manager generata")
	var eval_p: Dictionary = ind_sys.evaluate_manager_promise_fulfillment(true)
	assert_equal(eval_p.status, "fulfilled", "Promessa del manager mantenuta con successo")
	
	# Tentativo licenziamento con fondi insufficienti (riduciamo artificiosamente i soldi)
	player.money = 100.0
	var fail_fire: Dictionary = ind_sys.fire_manager()
	assert_true(not fail_fire.success, "Rifiutato licenziamento per fondi insufficienti a pagare la penale (250 €)")
	assert_true(player.has_manager(), "Manager ancora in carica")
	
	# Aggiunta fondi e licenziamento con penale
	player.money = 500.0
	var succ_fire: Dictionary = ind_sys.fire_manager()
	assert_true(succ_fire.success, "Licenziamento completato saldando la penale")
	assert_equal(player.money, 250.0, "Saldo decurtato della penale di 250 € (500 -> 250)")
	assert_true(not player.has_manager(), "Manager rimosso dal giocatore")
	
	# Ingaggio Squalo dell'Industria (costa 2000 €, forniamo fondi)
	player.money = 5000.0
	var hire_shark: Dictionary = ind_sys.hire_manager(Enums.ManagerType.INDUSTRY_SHARK)
	assert_true(hire_shark.success, "Ingaggio Squalo dell'Industria riuscito")
	
	# Telefonata notturna delle 02:30 dello squalo
	var night_call: Dictionary = ind_sys.process_manager_night_call()
	assert_true(not night_call.is_empty(), "Ricevuta telefonata notturna dallo squalo")
	var res_call: Dictionary = ind_sys.resolve_manager_night_call(true)
	assert_true(res_call.accepted, "Accettata comparsata notturna dello squalo")
	assert_true(player.stress > 30, "Stress aumentato a seguito del sonno interrotto")
	
	# Tutela legale: assunzione dell'avvocato
	var lawyer_res: Dictionary = ind_sys.hire_entertainment_lawyer(1500.0)
	assert_true(lawyer_res.success, "Avvocato dello spettacolo ingaggiato con successo")
	assert_true(player.active_manager.has_legal_protection, "Manager protetto da accordi legali blindati")

# 11. Fondazione Propria Etichetta Indipendente (Endgame)
func test_own_independent_label_endgame() -> void:
	print("\n11. Verifica Fondazione Propria Etichetta Indipendente (Endgame Sezione 9):")
	var player := PlayerData.new()
	player.reputation = 40.0
	player.money = 10000.0
	var cal := CalendarData.new()
	var ind_sys = IndustrySystemScript.new(player, cal)
	
	# Tentativo 1: Requisiti mancanti (rep < 60 e soldi < 25.000)
	var fail_label: Dictionary = ind_sys.found_own_label("My Label", Enums.LabelPhilosophy.UNDERGROUND_INDIE)
	assert_true(not fail_label.success, "Rifiutata fondazione label per requisiti mancanti")
	
	# Tentativo 2: Con requisiti pieni
	player.reputation = 65.0
	player.money = 30000.0
	var succ_label: Dictionary = ind_sys.found_own_label("Velvet Sounds", Enums.LabelPhilosophy.UNDERGROUND_INDIE)
	assert_true(succ_label.success, "Etichetta discografica indipendente fondata con successo!")
	assert_true(player.has_own_label(), "Player possiede una propria etichetta attiva")
	assert_equal(player.money, 5000.0, "Capitale sociale di 25.000 € detratto (30.000 -> 5.000)")
	
	# Talent scouting di giovani band
	var scout_bands: Array[Dictionary] = ind_sys.scout_unsigned_bands()
	assert_equal(scout_bands.size(), 3, "Trovate 3 band emergenti nello scouting")
	
	# Firma di una band nel roster (anticipo 4.000 €)
	var target_band = scout_bands[0]
	var sign_band_res: Dictionary = ind_sys.sign_band_to_own_label(target_band, 4000.0, 0.60)
	assert_true(sign_band_res.success, "Band emergente messa sotto contratto nel roster!")
	assert_equal(player.own_label.signed_bands.size(), 1, "Roster label conta 1 band attiva")
	assert_equal(player.money, 1000.0, "Anticipo detratto dal saldo (5.000 -> 1.000)")
	
	# Simulazione royalties passive notturne della band
	var roy_sim: Dictionary = ind_sys.process_own_label_daily_royalties()
	assert_true(roy_sim.total_label_royalties > 0.0, "Etichetta propria incassa royalties passive dal catalogo")
	assert_true(player.money > 1000.0, "Saldo del giocatore accreditato delle entrate dell'etichetta")

# 12. Verifica Istanziazione e Nodi Scene UI (IndustryHub & DilemmaModal)
func test_ui_scene_instantiation() -> void:
	print("\n12. Verifica Istanziazione e Nodi Scene UI (IndustryHub 3 Tabs & DilemmaModal):")
	
	# IndustryHub
	var hub_res = load("res://ui/industry/industry_hub.tscn")
	assert_true(hub_res != null, "Risorsa industry_hub.tscn caricata")
	if hub_res:
		var hub_inst = hub_res.instantiate()
		assert_true(hub_inst != null, "Istanziazione IndustryHub riuscita")
		if hub_inst:
			var tab_c = hub_inst.get_node_or_null("PanelMain/VBox/HBoxTabs/BtnTabContracts")
			var tab_m = hub_inst.get_node_or_null("PanelMain/VBox/HBoxTabs/BtnTabManagers")
			var tab_l = hub_inst.get_node_or_null("PanelMain/VBox/HBoxTabs/BtnTabOwnLabel")
			var btn_ref = hub_inst.get_node_or_null("PanelMain/VBox/TabContracts/HBoxOffersHeader/BtnRefreshOffers")
			var btn_reneg = hub_inst.get_node_or_null("PanelMain/VBox/TabContracts/PanelActiveContract/VBox/HBoxActions/BtnRenegotiate")
			var btn_buyback = hub_inst.get_node_or_null("PanelMain/VBox/TabContracts/PanelActiveContract/VBox/HBoxActions/BtnMasterBuyback")
			var btn_pdist = hub_inst.get_node_or_null("PanelMain/VBox/TabContracts/PanelActiveContract/VBox/HBoxActions/BtnPhysicalDist")
			var btn_fire = hub_inst.get_node_or_null("PanelMain/VBox/TabManagers/PanelActiveManager/VBox/HBoxActions/BtnFireManager")
			var btn_lawyer = hub_inst.get_node_or_null("PanelMain/VBox/TabManagers/PanelActiveManager/VBox/HBoxActions/BtnHireLawyer")
			var btn_found = hub_inst.get_node_or_null("PanelMain/VBox/TabOwnLabel/PanelOwnLabelStatus/VBox/HBoxOwnLabelActions/BtnFoundLabel")
			var btn_scout = hub_inst.get_node_or_null("PanelMain/VBox/TabOwnLabel/PanelOwnLabelStatus/VBox/HBoxOwnLabelActions/BtnScoutBands")
			var btn_cls = hub_inst.get_node_or_null("PanelMain/VBox/HBoxFooter/BtnClose")
			
			assert_true(tab_c != null, "Pulsante Tab Contratti presente")
			assert_true(tab_m != null, "Pulsante Tab Manager presente")
			assert_true(tab_l != null, "Pulsante Tab Propria Etichetta presente")
			assert_true(btn_ref != null, "Pulsante Cerca Offerte presente")
			assert_true(btn_reneg != null, "Pulsante Rinegozia Contratto presente")
			assert_true(btn_buyback != null, "Pulsante Riscatto Master presente")
			assert_true(btn_pdist != null, "Pulsante Distribuzione Fisica presente")
			assert_true(btn_fire != null, "Pulsante Licenzia Manager presente")
			assert_true(btn_lawyer != null, "Pulsante Assumi Avvocato presente")
			assert_true(btn_found != null, "Pulsante Fonda Etichetta presente")
			assert_true(btn_scout != null, "Pulsante Talent Scouting presente")
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
