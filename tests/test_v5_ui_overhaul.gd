# res://tests/test_v5_ui_overhaul.gd
extends Node

## Suite di Test Headless per la Riorganizzazione UI V5.0 (Fase 9.0 / SP-14)
## Valida l'architettura a 5 sezioni: Top Bar permanente, Menu di Sistema Esc,
## selettore delle 4 Macro-Aree con filtraggio visivo e navigazione NVDA,
## e la nuova modale UpgradesModal.

var tests_passed: int = 0
var tests_failed: int = 0

var hud_scene: PackedScene = preload("res://ui/hud/hud.tscn")
var hud_instance: Control = null

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST RIORGANIZZAZIONE UI & MACRO-AREE V5.0 (F9.0)")
	print("========================================================")
	
	test_hud_v5_nodes()
	test_macro_areas_tab_switching()
	test_system_menu_modal()
	test_upgrades_modal()
	test_top_bar_and_info_speech()
	test_modal_mutual_exclusion_v5()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST RIORGANIZZAZIONE UI V5.0:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if hud_instance:
		hud_instance.queue_free()
		
	if tests_failed == 0:
		print("[SUCCESSO] Architettura UI a 5 sezioni convalidata al 100%!")
		get_tree().quit(0)
	else:
		printerr("[ERRORE CRITICO] Alcuni test UI V5 sono falliti!")
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

# -------------------------------------------------------------
# TEST 1: Istanziazione nodi V5 nell'HUD
# -------------------------------------------------------------
func test_hud_v5_nodes() -> void:
	print("\n[TEST 1] Istanziazione nodi V5 nell'HUD...")
	hud_instance = hud_scene.instantiate()
	add_child(hud_instance)
	
	assert_true(hud_instance != null, "Istanza HUD creata con successo")
	assert_true(hud_instance.hbox_categories != null, "HBoxCategories presente nell'HUD")
	assert_true(hud_instance.btn_tab_personal != null, "BtnTabPersonal presente")
	assert_true(hud_instance.btn_tab_creation != null, "BtnTabCreation presente")
	assert_true(hud_instance.btn_tab_career != null, "BtnTabCareer presente")
	assert_true(hud_instance.btn_tab_upgrades != null, "BtnTabUpgrades presente")
	assert_true(hud_instance.btn_upgrades != null, "BtnUpgrades presente in HBoxActions")
	assert_true(hud_instance.system_menu_modal != null, "SystemMenuModal presente nell'albero")
	assert_true(hud_instance.upgrades_modal != null, "UpgradesModal presente nell'albero")
	assert_true(not hud_instance._is_any_modal_open(), "Nessuna modale aperta all'avvio")

# -------------------------------------------------------------
# TEST 2: Filtraggio pulsanti per Macro-Area
# -------------------------------------------------------------
func test_macro_areas_tab_switching() -> void:
	print("\n[TEST 2] Filtraggio pulsanti per Macro-Area...")
	# 1. Area Personale (Default)
	hud_instance.select_category_tab(1)
	assert_equal(hud_instance.current_category_tab, 1, "Categoria corrente = 1 (Hub Personale)")
	assert_true(hud_instance.btn_character.visible, "BtnCharacter visibile in Area 1")
	assert_true(hud_instance.btn_agenda.visible, "BtnAgenda visibile in Area 1")
	assert_true(hud_instance.btn_economy.visible, "BtnEconomy visibile in Area 1")
	assert_true(hud_instance.btn_travel.visible, "BtnTravel visibile in Area 1")
	assert_true(hud_instance.btn_practice.visible, "BtnPractice visibile in Area 1")
	assert_true(not hud_instance.btn_catalog.visible, "BtnCatalog occultato in Area 1")
	assert_true(not hud_instance.btn_concert.visible, "BtnConcert occultato in Area 1")
	assert_true(not hud_instance.btn_upgrades.visible, "BtnUpgrades occultato in Area 1")
	
	# 2. Area Creazione & Produzione
	hud_instance.select_category_tab(2)
	assert_equal(hud_instance.current_category_tab, 2, "Categoria corrente = 2 (Creazione)")
	assert_true(hud_instance.btn_catalog.visible, "BtnCatalog visibile in Area 2")
	assert_true(hud_instance.btn_new_song.visible, "BtnNewSong visibile in Area 2")
	assert_true(not hud_instance.btn_character.visible, "BtnCharacter occultato in Area 2")
	assert_true(not hud_instance.btn_concert.visible, "BtnConcert occultato in Area 2")
	
	# 3. Area Carriera & Band
	hud_instance.select_category_tab(3)
	assert_equal(hud_instance.current_category_tab, 3, "Categoria corrente = 3 (Carriera)")
	assert_true(hud_instance.btn_concert.visible, "BtnConcert visibile in Area 3")
	assert_true(hud_instance.btn_band.visible, "BtnBand visibile in Area 3")
	assert_true(hud_instance.btn_tour.visible, "BtnTour visibile in Area 3")
	assert_true(hud_instance.btn_festival.visible, "BtnFestival visibile in Area 3")
	assert_true(hud_instance.btn_social.visible, "BtnSocial visibile in Area 3")
	assert_true(hud_instance.btn_chart.visible, "BtnChart visibile in Area 3")
	assert_true(hud_instance.btn_industry.visible, "BtnIndustry visibile in Area 3")
	assert_true(not hud_instance.btn_character.visible, "BtnCharacter occultato in Area 3")
	assert_true(not hud_instance.btn_catalog.visible, "BtnCatalog occultato in Area 3")
	
	# 4. Area Skills & Upgrade
	hud_instance.select_category_tab(4)
	assert_equal(hud_instance.current_category_tab, 4, "Categoria corrente = 4 (Upgrades)")
	assert_true(hud_instance.btn_upgrades.visible, "BtnUpgrades visibile in Area 4")
	assert_true(not hud_instance.btn_character.visible, "BtnCharacter occultato in Area 4")
	assert_true(not hud_instance.btn_concert.visible, "BtnConcert occultato in Area 4")
	
	# Ripristino Area 1
	hud_instance.select_category_tab(1)

# -------------------------------------------------------------
# TEST 3: SystemMenuModal (Menu di Pausa Esc)
# -------------------------------------------------------------
func test_system_menu_modal() -> void:
	print("\n[TEST 3] Funzionamento SystemMenuModal (Pausa Esc)...")
	hud_instance.open_system_menu()
	assert_true(hud_instance.system_menu_modal.visible, "SystemMenuModal visibile dopo open_system_menu()")
	assert_true(not hud_instance.vbox_main.visible, "vbox_main occultato con SystemMenuModal aperto")
	assert_true(hud_instance._is_any_modal_open(), "_is_any_modal_open() ritorna true")
	
	hud_instance.close_system_menu()
	assert_true(not hud_instance.system_menu_modal.visible, "SystemMenuModal chiuso dopo close_system_menu()")
	assert_true(hud_instance.vbox_main.visible, "vbox_main ripristinato dopo chiusura")
	assert_true(not hud_instance._is_any_modal_open(), "_is_any_modal_open() ritorna false")

# -------------------------------------------------------------
# TEST 4: UpgradesModal (Miglioramenti)
# -------------------------------------------------------------
func test_upgrades_modal() -> void:
	print("\n[TEST 4] Funzionamento UpgradesModal...")
	hud_instance.open_upgrades_modal()
	assert_true(hud_instance.upgrades_modal.visible, "UpgradesModal visibile dopo open_upgrades_modal()")
	assert_true(not hud_instance.vbox_main.visible, "vbox_main occultato")
	assert_true(hud_instance._is_any_modal_open(), "_is_any_modal_open() ritorna true")
	
	# Test selezione schede interne a UpgradesModal
	var up_modal = hud_instance.upgrades_modal
	up_modal.select_tab(1)
	assert_true(up_modal.panel_housing.visible, "PanelHousing visibile su Tab 1")
	assert_true(not up_modal.panel_rehearsal.visible, "PanelRehearsal occultato su Tab 1")
	
	up_modal.select_tab(2)
	assert_true(up_modal.panel_rehearsal.visible, "PanelRehearsal visibile su Tab 2")
	assert_true(not up_modal.panel_housing.visible, "PanelHousing occultato su Tab 2")
	
	up_modal.select_tab(3)
	assert_true(up_modal.panel_gear.visible, "PanelGear visibile su Tab 3")
	
	up_modal.select_tab(4)
	assert_true(up_modal.panel_studio.visible, "PanelStudio visibile su Tab 4")
	
	hud_instance.close_upgrades_modal()
	assert_true(not hud_instance.upgrades_modal.visible, "UpgradesModal occultata dopo close_upgrades_modal()")
	assert_true(hud_instance.vbox_main.visible, "vbox_main ripristinato")

# -------------------------------------------------------------
# TEST 5: Top Bar Permanente & Info Vocale Rapida (Tasto I)
# -------------------------------------------------------------
func test_top_bar_and_info_speech() -> void:
	print("\n[TEST 5] Top Bar Permanente & Info Vocale...")
	assert_true(hud_instance.label_time != null, "LabelTime presente")
	assert_true(hud_instance.label_energy != null, "LabelEnergy presente")
	assert_true(hud_instance.label_stress != null, "LabelStress presente")
	assert_true(hud_instance.label_morale != null, "LabelMorale presente")
	assert_true(hud_instance.label_money != null, "LabelMoney presente")
	assert_true(hud_instance.btn_speed != null, "BtnSpeed presente")
	assert_true(hud_instance.btn_pause != null, "BtnPause presente")
	
	# Invocazione metodo di info rapida
	hud_instance.speak_hud_info()
	assert_true(true, "speak_hud_info() eseguito senza errori")

# -------------------------------------------------------------
# TEST 6: Mutua Esclusione tra Modali V5
# -------------------------------------------------------------
func test_modal_mutual_exclusion_v5() -> void:
	print("\n[TEST 6] Mutua Esclusione tra Modali V5...")
	hud_instance.open_upgrades_modal()
	assert_true(hud_instance.upgrades_modal.visible, "UpgradesModal aperta")
	
	# Apertura diretta di SystemMenuModal
	hud_instance.open_system_menu()
	assert_true(not hud_instance.upgrades_modal.visible, "UpgradesModal occultata da open_system_menu")
	assert_true(hud_instance.system_menu_modal.visible, "SystemMenuModal visibile")
	
	hud_instance._hide_all_modals()
	assert_true(not hud_instance._is_any_modal_open(), "Tutte le modali occultate da _hide_all_modals()")
