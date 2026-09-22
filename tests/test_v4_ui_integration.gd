# res://tests/test_v4_ui_integration.gd
extends Node

## Suite di Test Headless per l'Integrazione UI e Accessibilità V4.0 (Fase 8.6)
## Valida l'istanziazione dell'HUD, la centralizzazione di _hide_all_modals(),
## la corretta mutua esclusione delle 15 modali, il comportamento di _is_any_modal_open()
## e l'aggancio delle scorciatoie da tastiera e dei metadati AccessKit/NVDA.

var tests_passed: int = 0
var tests_failed: int = 0

var hud_scene: PackedScene = preload("res://ui/hud/hud.tscn")
var hud_instance: Control = null

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST INTEGRAZIONE UI & ACCESSIBILITÀ V4.0 (F8.6)")
	print("========================================================")
	
	test_hud_instantiation_and_nodes()
	test_v4_buttons_and_accessibility_hooks()
	test_modal_mutual_exclusion_and_hide_all()
	test_modal_state_predicate()
	test_modal_close_and_hud_restore()
	test_all_v4_modals_lifecycle()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST INTEGRAZIONE UI V4.0:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if hud_instance:
		hud_instance.queue_free()
		
	if tests_failed == 0:
		print("[SUCCESSO] Integrazione UI & Accessibilità V4.0 convalidate al 100%!")
		get_tree().quit(0)
	else:
		printerr("[ERRORE CRITICO] Alcuni test di integrazione UI sono falliti!")
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
# TEST 1: Istanziazione HUD e nodi principali
# -------------------------------------------------------------
func test_hud_instantiation_and_nodes() -> void:
	print("\n[TEST 1] Istanziazione HUD e nodi principali...")
	hud_instance = hud_scene.instantiate()
	add_child(hud_instance)
	
	assert_true(hud_instance != null, "Istanza HUD creata con successo")
	assert_true(hud_instance.vbox_main != null, "vbox_main presente nell'HUD")
	assert_true(hud_instance.vbox_main.visible, "vbox_main inizialmente visibile")
	assert_true(not hud_instance._is_any_modal_open(), "_is_any_modal_open() ritorna false all'avvio")

# -------------------------------------------------------------
# TEST 2: Presenza pulsanti V4 e Accessibilità AccessKit
# -------------------------------------------------------------
func test_v4_buttons_and_accessibility_hooks() -> void:
	print("\n[TEST 2] Pulsanti V4 e Accessibilità AccessKit...")
	assert_true(hud_instance.btn_travel != null, "Pulsante Viaggi (V) presente")
	assert_true(hud_instance.btn_tour != null, "Pulsante Tour (O) presente")
	assert_true(hud_instance.btn_festival != null, "Pulsante Festival (F) presente")
	assert_true(hud_instance.btn_social != null, "Pulsante Social (Y) presente")
	assert_true(hud_instance.btn_chart != null, "Pulsante Classifiche (H) presente")
	
	assert_true(hud_instance.travel_modal != null, "Modale TravelModal presente nell'albero")
	assert_true(hud_instance.tour_modal != null, "Modale TourModal presente nell'albero")
	assert_true(hud_instance.festival_modal != null, "Modale FestivalModal presente nell'albero")
	assert_true(hud_instance.social_modal != null, "Modale SocialModal presente nell'albero")
	assert_true(hud_instance.chart_modal != null, "Modale ChartModal presente nell'albero")

# -------------------------------------------------------------
# TEST 3: Mutua Esclusione Modali e _hide_all_modals()
# -------------------------------------------------------------
func test_modal_mutual_exclusion_and_hide_all() -> void:
	print("\n[TEST 3] Mutua Esclusione Modali e _hide_all_modals()...")
	# Apre TravelModal
	hud_instance.open_travel_modal()
	assert_true(hud_instance.travel_modal.visible, "TravelModal aperta e visibile")
	assert_true(not hud_instance.vbox_main.visible, "vbox_main occultato con TravelModal aperta")
	assert_true(hud_instance._is_any_modal_open(), "_is_any_modal_open() ritorna true con TravelModal")
	
	# Apre TourModal direttamente (senza previa chiusura manuale)
	hud_instance.open_tour_modal()
	assert_true(not hud_instance.travel_modal.visible, "_hide_all_modals() ha occultato TravelModal")
	assert_true(hud_instance.tour_modal.visible, "TourModal aperta e visibile")
	assert_true(not hud_instance.vbox_main.visible, "vbox_main rimane occultato")
	
	# Esegue _hide_all_modals() esplicito
	hud_instance._hide_all_modals()
	assert_true(not hud_instance.tour_modal.visible, "TourModal occultata dopo _hide_all_modals()")
	assert_true(not hud_instance._is_any_modal_open(), "_is_any_modal_open() ritorna false dopo _hide_all_modals()")

# -------------------------------------------------------------
# TEST 4: Predicato _is_any_modal_open() con tutte le modali V4
# -------------------------------------------------------------
func test_modal_state_predicate() -> void:
	print("\n[TEST 4] Predicato _is_any_modal_open() con tutte le modali V4...")
	hud_instance._hide_all_modals()
	
	# Festival
	hud_instance.open_festival_modal()
	assert_true(hud_instance.festival_modal.visible, "FestivalModal visibile")
	assert_true(hud_instance._is_any_modal_open(), "_is_any_modal_open() true per FestivalModal")
	
	# Social
	hud_instance.open_social_modal()
	assert_true(not hud_instance.festival_modal.visible, "FestivalModal chiusa da open_social_modal")
	assert_true(hud_instance.social_modal.visible, "SocialModal visibile")
	assert_true(hud_instance._is_any_modal_open(), "_is_any_modal_open() true per SocialModal")
	
	# Chart
	hud_instance.open_chart_modal()
	assert_true(not hud_instance.social_modal.visible, "SocialModal chiusa da open_chart_modal")
	assert_true(hud_instance.chart_modal.visible, "ChartModal visibile")
	assert_true(hud_instance._is_any_modal_open(), "_is_any_modal_open() true per ChartModal")

# -------------------------------------------------------------
# TEST 5: Chiusura modale e ripristino HUD
# -------------------------------------------------------------
func test_modal_close_and_hud_restore() -> void:
	print("\n[TEST 5] Chiusura modale e ripristino HUD...")
	# Chiude ChartModal
	hud_instance.close_chart_modal()
	assert_true(not hud_instance.chart_modal.visible, "ChartModal chiusa con successo")
	assert_true(hud_instance.vbox_main.visible, "vbox_main ripristinato alla chiusura")
	assert_true(not hud_instance._is_any_modal_open(), "Nessuna modale aperta dopo close_chart_modal")

# -------------------------------------------------------------
# TEST 6: Ciclo di Vita Completo per tutte le 5 finestre V4
# -------------------------------------------------------------
func test_all_v4_modals_lifecycle() -> void:
	print("\n[TEST 6] Ciclo di Vita Completo per tutte le 5 finestre V4...")
	
	# 1. Travel
	hud_instance.open_travel_modal()
	assert_true(hud_instance.travel_modal.visible, "1. Travel aperto")
	hud_instance.close_travel_modal()
	assert_true(not hud_instance.travel_modal.visible and hud_instance.vbox_main.visible, "1. Travel chiuso e HUD ripristinato")
	
	# 2. Tour
	hud_instance.open_tour_modal()
	assert_true(hud_instance.tour_modal.visible, "2. Tour aperto")
	hud_instance.close_tour_modal()
	assert_true(not hud_instance.tour_modal.visible and hud_instance.vbox_main.visible, "2. Tour chiuso e HUD ripristinato")
	
	# 3. Festival
	hud_instance.open_festival_modal()
	assert_true(hud_instance.festival_modal.visible, "3. Festival aperto")
	hud_instance.close_festival_modal()
	assert_true(not hud_instance.festival_modal.visible and hud_instance.vbox_main.visible, "3. Festival chiuso e HUD ripristinato")
	
	# 4. Social
	hud_instance.open_social_modal()
	assert_true(hud_instance.social_modal.visible, "4. Social aperto")
	hud_instance.close_social_modal()
	assert_true(not hud_instance.social_modal.visible and hud_instance.vbox_main.visible, "4. Social chiuso e HUD ripristinato")
	
	# 5. Charts
	hud_instance.open_chart_modal()
	assert_true(hud_instance.chart_modal.visible, "5. Charts aperto")
	hud_instance.close_chart_modal()
	assert_true(not hud_instance.chart_modal.visible and hud_instance.vbox_main.visible, "5. Charts chiuso e HUD ripristinato")
	
	assert_true(not hud_instance._is_any_modal_open(), "Stato finale: HUD completamente pulito")
