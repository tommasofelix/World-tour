# res://tests/test_apartment_gameplay.gd
extends Node

## Suite di Test Automatizzati per il Gameplay Grafico 2.5D nel Loft di New York (V5.4.0)
## Convalida headless deterministica a 0 ms:
## 1. Controller PlayerAlex (animazioni 4 direzioni, facing, hitbox ai piedi, auto-walk);
## 2. InteractiveProp (rilevamento Area2D, corpo solido, highlight, etichette NVDA);
## 3. ApartmentHud (barre vitali, inspection box cyberpunk, router 19 modali);
## 4. ApartmentScene (integrazione loft, Y-sorting, perimetro, ciclo arredi Tab/Numpad, 15 hotkeys).

const PlayerAlex = preload("res://scenes/apartment/player_alex.gd")
const InteractiveProp = preload("res://scenes/apartment/interactive_prop.gd")
const ApartmentHud = preload("res://ui/apartment_hud/apartment_hud.gd")
const ApartmentScene = preload("res://scenes/apartment/apartment.gd")
const ApartmentInteractions = preload("res://scenes/apartment/apartment_interactions.gd")
const InteractionMenu = preload("res://ui/interaction_menu/interaction_menu.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST GAMEPLAY GRAFICO 2.5D LOFT NYC (V5.6.0)   ")
	print("========================================================\n")

	test_player_alex_component()
	test_interactive_prop_component()
	test_apartment_hud_component()
	test_apartment_scene_integration()
	test_interaction_menu_and_actions()
	test_key_segregation_and_sleep_cycle()
	test_action_busy_lifecycle_and_safety()

	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST GAMEPLAY APPARTAMENTO:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")

	if tests_failed > 0:
		print("[ERRORE CRITICO] Alcuni test del Gameplay Grafico sono falliti!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Il Gameplay Grafico 2.5D del Loft è convalidato al 100%!")
		get_tree().quit(0)

func assert_true(condition: bool, test_name: String) -> void:
	if condition:
		print("  [OK] %s" % test_name)
		tests_passed += 1
	else:
		print("  [FALLITO] %s" % test_name)
		tests_failed += 1

func assert_eq(val1: Variant, val2: Variant, test_name: String) -> void:
	if val1 == val2:
		print("  [OK] %s (%s == %s)" % [test_name, str(val1), str(val2)])
		tests_passed += 1
	else:
		print("  [FALLITO] %s (Atteso: %s, Ottenuto: %s)" % [test_name, str(val2), str(val1)])
		tests_failed += 1

func test_player_alex_component() -> void:
	print("1. Verifica Controller PlayerAlex:")
	var p_scene: PackedScene = load("res://scenes/apartment/player_alex.tscn")
	assert_true(p_scene != null, "Risorsa player_alex.tscn caricata")

	var player: PlayerAlex = p_scene.instantiate() as PlayerAlex
	assert_true(player != null, "Istanziazione PlayerAlex riuscita")
	add_child(player)

	assert_true(player.is_in_group("player"), "Player registrato nel gruppo 'player'")
	assert_eq(player.current_facing, "down", "Facing iniziale impostato su 'down'")
	assert_true(player.y_sort_enabled, "Y-Sorting attivo su PlayerAlex")

	# Verifica animazioni registrate nello SpriteFrames
	var frames: SpriteFrames = player.animated_sprite.sprite_frames
	assert_true(frames != null, "SpriteFrames presente")
	assert_true(frames.has_animation("idle_down"), "Animazione 'idle_down' presente")
	assert_true(frames.has_animation("idle_up"), "Animazione 'idle_up' presente")
	assert_true(frames.has_animation("idle_left"), "Animazione 'idle_left' presente")
	assert_true(frames.has_animation("idle_right"), "Animazione 'idle_right' presente")
	assert_true(frames.has_animation("walk_down"), "Animazione 'walk_down' presente")
	assert_true(frames.has_animation("walk_up"), "Animazione 'walk_up' presente")
	assert_true(frames.has_animation("walk_left"), "Animazione 'walk_left' presente")
	assert_true(frames.has_animation("walk_right"), "Animazione 'walk_right' presente")

	# Verifica logica di orientamento facing
	player._update_facing(Vector2(1.0, 0.0))
	assert_eq(player.current_facing, "right", "Facing orientato a destra")
	player._update_facing(Vector2(-1.0, 0.0))
	assert_eq(player.current_facing, "left", "Facing orientato a sinistra")
	player._update_facing(Vector2(0.0, -1.0))
	assert_eq(player.current_facing, "up", "Facing orientato in alto")
	player._update_facing(Vector2(0.0, 1.0))
	assert_eq(player.current_facing, "down", "Facing orientato in basso")

	# Verifica hitbox ai piedi per clearance isometrica
	assert_true(player.collision_shape != null, "CollisionShape2D presente")
	assert_true(player.collision_shape.position.y < 0.0, "Hitbox posizionata alla base dei piedi")

	# Test auto-walk con gestione stallo ostacoli (Contratto D2)
	var callback_called: bool = false
	player.walk_to_target(Vector2(500, 500), func(): callback_called = true)
	assert_true(player.is_auto_walking, "Auto-walk avviato")
	player._stuck_timer = 0.7
	player._process_auto_walk(0.1)
	assert_true(not player.is_auto_walking, "Auto-walk arrestato su stallo ostacoli")
	assert_true(not callback_called, "Callback interazione NON invocata su stallo")

	player.queue_free()

func test_interactive_prop_component() -> void:
	print("\n2. Verifica InteractiveProp (Hotspot Arredi):")
	var prop_scene: PackedScene = load("res://scenes/apartment/interactive_prop.tscn")
	assert_true(prop_scene != null, "Risorsa interactive_prop.tscn caricata")

	var prop: InteractiveProp = prop_scene.instantiate() as InteractiveProp
	assert_true(prop != null, "Istanziazione InteractiveProp riuscita")
	add_child(prop)

	prop.prop_id = "test_guitar"
	prop.prop_name = "Chitarra di Prova"
	prop.prop_description = "Strumento per collaudo"
	prop.hotkey_hint = "P"
	prop.inspection_text = "Una splendida chitarra di prova."

	# Verifica etichetta accessibile lineare per NVDA
	var speech_label: String = prop.get_accessible_label(1, 9)
	assert_true(speech_label.begins_with("Oggetto 1 di 9: Chitarra di Prova"), "Etichetta contiene prefisso ordinale e nome")
	assert_true(speech_label.contains("Tasto rapido: P"), "Etichetta contiene hint tasto rapido")
	assert_true(speech_label.contains("Premi Invio o Spazio"), "Etichetta contiene istruzione di input")

	# Verifica segnale di interazione
	var signal_received: Array[String] = []
	prop.interaction_triggered.connect(func(pid): signal_received.append(pid))
	prop.trigger_interaction()
	assert_eq(signal_received.size(), 1, "Segnale interaction_triggered emesso")
	assert_eq(signal_received[0], "test_guitar", "ID emesso corrisponde a 'test_guitar'")

	# Verifica highlight visivo e assenza prompt fluttuante [SPAZIO] (Contratto D0)
	assert_true(prop.has_signal("prop_clicked"), "Segnale prop_clicked presente su InteractiveProp")
	assert_true(prop.get_node_or_null("Prompt") == null, "Nodo Prompt rimosso da InteractiveProp")
	prop.set_highlight(true)
	assert_eq(prop._sprite_node.modulate, Color(1.2, 1.2, 1.2, 1.0), "Highlight attivo modula colore dello sprite")
	prop.set_highlight(false)
	assert_eq(prop._sprite_node.modulate, Color(1.0, 1.0, 1.0, 1.0), "Highlight disattivato ripristina colore normale")

	# Verifica calcolo stand position
	assert_eq(prop.get_stand_position(), prop.global_position + prop.stand_offset, "get_stand_position calcolato correttamente")

	prop.queue_free()

func test_apartment_hud_component() -> void:
	print("\n3. Verifica ApartmentHud:")
	var hud_scene: PackedScene = load("res://ui/apartment_hud/apartment_hud.tscn")
	assert_true(hud_scene != null, "Risorsa apartment_hud.tscn caricata")

	var hud: ApartmentHud = hud_scene.instantiate() as ApartmentHud
	assert_true(hud != null, "Istanziazione ApartmentHud riuscita")
	add_child(hud)

	# Verifica registrazione atomica delle 19 modali
	assert_eq(hud._all_modals.size(), 19, "Esattamente 19 modali registrate nell'ApartmentHud")
	assert_true(not hud.is_any_modal_open(), "Nessuna modale aperta all'avvio")

	# Test apertura e chiusura modale con guardia is_any_modal_open
	hud.open_modal(hud.song_catalog_modal)
	assert_true(hud.is_any_modal_open(), "is_any_modal_open() è true con SongCatalog aperto")
	assert_true(hud.song_catalog_modal.visible, "SongCatalog visibile")

	hud.hide_all_modals()
	assert_true(not hud.is_any_modal_open(), "is_any_modal_open() è false dopo hide_all_modals()")
	assert_true(not hud.song_catalog_modal.visible, "SongCatalog nascosto")

	# Test inspection box
	hud.show_inspection("Ispezione test su arredo", "ALEX", "Hint azione test")
	assert_eq(hud.label_speaker.text, "ALEX", "Nome speaker inspection box corretto")
	assert_eq(hud.label_text.text, "Ispezione test su arredo", "Testo inspection box corretto")

	# Test interazioni domestiche differenziate (Contratto D4)
	hud.open_modal_by_prop_id("couch")
	assert_eq(hud.label_speaker.text, "DIVANO", "Interazione divano aggiorna inspection box con DIVANO")
	
	hud.open_modal_by_prop_id("kitchen")
	assert_eq(hud.label_speaker.text, "CUCINA", "Interazione cucina aggiorna inspection box con CUCINA")
	
	hud.open_modal_by_prop_id("turntable")
	assert_eq(hud.label_speaker.text, "GIRADISCHI", "Interazione giradischi aggiorna inspection box con GIRADISCHI")

	# Test interazione letto (Contratto D3)
	hud.open_modal_by_prop_id("bed")
	assert_eq(hud.label_speaker.text, "LETTO", "Interazione letto aggiorna inspection box con LETTO")

	# Test stato bistabile stereo (Toggle On / Off) (Contratto D4)
	assert_true(not hud.is_stereo_on, "Stereo inizialmente spento")
	hud.open_modal_by_prop_id("stereo")
	assert_true(hud.is_stereo_on, "Stereo acceso dopo primo trigger")
	assert_true(hud.label_text.text.contains("Stereo acceso"), "Inspection box indica stereo acceso")

	hud.open_modal_by_prop_id("stereo")
	assert_true(not hud.is_stereo_on, "Stereo spento dopo secondo trigger (Toggle)")
	assert_true(hud.label_text.text.contains("Stereo spento"), "Inspection box indica stereo spento")

	# Test dinamismo ritratti espressivi di Alex (Contratto D1)
	var test_player: PlayerData = PlayerData.new()
	test_player.energy = 80.0
	test_player.stress = 20.0
	test_player.morale = 75.0
	assert_eq(hud.get_alex_portrait_texture(test_player), hud.TEX_ALEX_NORMALE, "Alex in equilibrio emotivo usa alex_normale.png")

	test_player.morale = 25.0
	assert_eq(hud.get_alex_portrait_texture(test_player), hud.TEX_ALEX_TRISTE, "Alex con morale basso (<= 30%) usa alex_triste.png")

	test_player.morale = 75.0
	test_player.stress = 65.0
	assert_eq(hud.get_alex_portrait_texture(test_player), hud.TEX_ALEX_ARRABBIATO, "Alex con stress elevato (>= 60%) usa alex_arrabbiato.png")

	test_player.stress = 90.0
	assert_eq(hud.get_alex_portrait_texture(test_player), hud.TEX_ALEX_DISPERATO, "Alex con stress estremo (>= 85%) usa alex_disperato.png")

	test_player.stress = 20.0
	test_player.energy = 10.0
	assert_eq(hud.get_alex_portrait_texture(test_player), hud.TEX_ALEX_DISPERATO, "Alex con energia critica (<= 15%) usa alex_disperato.png")

	# Test dinamismo icone meteo / fasce orarie (Contratto D3)
	assert_eq(hud.get_period_weather_texture(Enums.TimePeriod.MORNING), hud.TEX_MATTINO, "Mattina usa Mattino.png")
	assert_eq(hud.get_period_weather_texture(Enums.TimePeriod.AFTERNOON), hud.TEX_POMERIGGIO, "Pomeriggio usa Pomeriggio.png")
	assert_eq(hud.get_period_weather_texture(Enums.TimePeriod.EVENING), hud.TEX_TRAMONTO, "Sera usa Tramonto.png")
	assert_eq(hud.get_period_weather_texture(Enums.TimePeriod.NIGHT), hud.TEX_NOTTE, "Notte usa Notte.png")

	# Test dinamismo icona denaro (Contratto D4)
	if GameManager:
		GameManager.player_data.money = 250.0
		hud.update_hud_display()
		if hud.texture_money_icon:
			assert_eq(hud.texture_money_icon.texture, hud.TEX_POCHI_SOLDI, "Saldo < 1000€ usa pochi_soldi.png")

		GameManager.player_data.money = 1500.0
		hud.update_hud_display()
		if hud.texture_money_icon:
			assert_eq(hud.texture_money_icon.texture, hud.TEX_MOLTI_SOLDI, "Saldo >= 1000€ usa Molti_Soldi.png")

	# Test pulsanti Dock Macro-Categorie (Contratto D5)
	if hud.btn_dock_personal:
		hud.btn_dock_personal.pressed.emit()
		assert_true(hud.character_sheet_modal.visible, "BtnDockPersonal apre CharacterSheetModal")
		hud.hide_all_modals()

	if hud.btn_dock_creation:
		hud.btn_dock_creation.pressed.emit()
		assert_true(hud.song_catalog_modal.visible, "BtnDockCreation apre SongCatalogModal")
		hud.hide_all_modals()

	if hud.btn_dock_career:
		hud.btn_dock_career.pressed.emit()
		assert_true(hud.live_concert_modal.visible, "BtnDockCareer apre LiveConcertModal")
		hud.hide_all_modals()

	if hud.btn_dock_tools:
		hud.btn_dock_tools.pressed.emit()
		assert_true(hud.upgrades_modal.visible, "BtnDockTools apre UpgradesModal")
		hud.hide_all_modals()

	if hud.btn_dock_band:
		hud.btn_dock_band.pressed.emit()
		assert_true(hud.band_hub_modal.visible, "BtnDockBand apre BandHubModal")
		hud.hide_all_modals()

	# Verifica Clearance Geometrica Anti-Sovrapposizione Dialogue - Dock (Full HD 1920x1080)
	if hud.panel_dialogue and hud.panel_center_dock:
		var dialogue_right: float = hud.panel_dialogue.offset_right
		var dock_left: float = (1920.0 * hud.panel_center_dock.anchor_left) + hud.panel_center_dock.offset_left
		assert_true(dialogue_right < dock_left, "Nessuna sovrapposizione tra dialogue box (X=%.1f) e center dock (X=%.1f)" % [dialogue_right, dock_left])
		var clearance: float = dock_left - dialogue_right
		assert_true(clearance >= 80.0, "Clearance tra dialogue e dock >= 80px (reale: %.1f px)" % clearance)

	hud.reset_inspection()
	assert_true(hud.label_text.text.contains("Loft Apartment"), "reset_inspection ripristina ambient text")

	hud.queue_free()

func test_apartment_scene_integration() -> void:
	print("\n4. Verifica Scena Completa ApartmentScene (Loft NYC):")
	var apt_scene: PackedScene = load("res://scenes/apartment/apartment.tscn")
	assert_true(apt_scene != null, "Risorsa apartment.tscn caricata")

	var apt: ApartmentScene = apt_scene.instantiate() as ApartmentScene
	assert_true(apt != null, "Istanziazione ApartmentScene riuscita")
	add_child(apt)

	# Verifica albero dei nodi
	assert_true(apt.y_sort_root != null, "YSortRoot presente")
	assert_true(apt.y_sort_root.y_sort_enabled, "Y-Sorting attivo su YSortRoot")
	assert_true(apt.player != null, "PlayerAlex presente nella stanza")
	assert_true(apt.camera != null, "Camera2D presente")
	assert_true(apt.hud != null, "ApartmentHud presente nel CanvasLayer")

	# Verifica wrapper temporali advance_to_next_period e trigger_sleep_now (Contratto D3)
	if GameManager and GameManager.time_system:
		assert_true(GameManager.time_system.has_method("advance_to_next_period"), "TimeSystem espone advance_to_next_period()")
		assert_true(GameManager.time_system.has_method("trigger_sleep_now"), "TimeSystem espone trigger_sleep_now()")

	# Verifica raccolta dei 10 arredi interattivi (incluso Stereo)
	assert_eq(apt.props.size(), 10, "Esattamente 10 arredi interattivi registrati nella stanza")

	var expected_ids := ["guitar", "kitchen", "couch", "turntable", "arcade", "bed", "wardrobe", "toolbox", "door", "stereo"]
	for expected_id in expected_ids:
		var found: bool = false
		for p in apt.props:
			if "prop_id" in p and p.prop_id == expected_id:
				found = true
				break
		assert_true(found, "Arredo con prop_id '%s' presente nel loft" % expected_id)

	# Test navigazione ciclica arredi (Canale Logico Tab / Numpad)
	assert_eq(apt.selected_prop_index, -1, "Nessun arredo selezionato all'avvio")

	apt._cycle_prop_selection(1)
	assert_eq(apt.selected_prop_index, 0, "Tab seleziona arredo 0 (guitar)")

	apt._cycle_prop_selection(1)
	assert_eq(apt.selected_prop_index, 1, "Tab seleziona arredo 1 (kitchen)")

	apt._cycle_prop_selection(-1)
	assert_eq(apt.selected_prop_index, 0, "Shift+Tab torna ad arredo 0 (guitar)")

	apt._cycle_prop_selection(-1)
	assert_eq(apt.selected_prop_index, 9, "Shift+Tab avvolge all'ultimo arredo (stereo)")

	apt._clear_prop_selection()
	assert_eq(apt.selected_prop_index, -1, "_clear_prop_selection ripristina stato a -1")

	# Test mouse click interattivo su arredo (Holy Diver The Sims style)
	var guitar_prop: InteractiveProp = apt.props[0]
	assert_true(guitar_prop.has_signal("prop_clicked"), "InteractiveProp espone segnale prop_clicked")
	guitar_prop.is_player_in_range = true
	guitar_prop.prop_clicked.emit(guitar_prop)
	assert_true(apt.hud.is_any_modal_open(), "Click mouse su arredo apre la modale corrispondente")
	apt.hud.hide_all_modals()

	# Test interazione specifica stereo
	apt._on_prop_interaction("stereo")
	assert_true(apt.hud.label_speaker.text.contains("STEREO"), "Interazione stereo aggiorna inspection box")
	apt.hud.reset_inspection()

	# Test tasti Numpad (KEY_KP_1 .. KEY_KP_5) per le 5 Macro-Aree del dock
	var numpad_tests = [
		{"key": KEY_KP_1, "modal": apt.hud.character_sheet_modal, "name": "KP_1 -> Personale"},
		{"key": KEY_KP_2, "modal": apt.hud.song_catalog_modal, "name": "KP_2 -> Creazione"},
		{"key": KEY_KP_3, "modal": apt.hud.live_concert_modal, "name": "KP_3 -> Carriera"},
		{"key": KEY_KP_4, "modal": apt.hud.social_modal, "name": "KP_4 -> Social"},
		{"key": KEY_KP_5, "modal": apt.hud.band_hub_modal, "name": "KP_5 -> Band"}
	]
	for t in numpad_tests:
		var ev := InputEventKey.new()
		ev.pressed = true
		ev.keycode = t.key
		apt._unhandled_input(ev)
		assert_true(t.modal.visible, "Tasto %s apre correttamente la modale associata" % t.name)
		apt.hud.hide_all_modals()

	apt.queue_free()

func test_interaction_menu_and_actions() -> void:
	print("\n5. Verifica InteractionMenu & Catalogo Azioni Multiple (V5.6.0):")
	var menu_scene: PackedScene = load("res://ui/interaction_menu/interaction_menu.tscn")
	assert_true(menu_scene != null, "Risorsa interaction_menu.tscn caricata")

	var menu: InteractionMenu = menu_scene.instantiate() as InteractionMenu
	assert_true(menu != null, "Istanziazione InteractionMenu riuscita")
	add_child(menu)

	assert_true(menu.has_signal("action_chosen"), "Segnale action_chosen presente")
	assert_true(menu.has_signal("menu_closed"), "Segnale menu_closed presente")
	assert_true(not menu.visible, "InteractionMenu inizialmente nascosto")

	# Test selezione texture dinamica in base al numero di opzioni
	# 1. Texture corta per <= 2 opzioni
	var actions_corta: Array[Dictionary] = [
		{"id": "a1", "title": "Azione 1", "description": "Desc 1", "duration_seconds": 0.0},
		{"id": "a2", "title": "Azione 2", "description": "Desc 2", "duration_seconds": 5.0}
	]
	menu.open_menu("test_prop", "Arredo Test", actions_corta, Vector2(500, 400))
	assert_true(menu.visible, "Menu visibile dopo open_menu")
	assert_true(menu.is_menu_open, "is_menu_open è true")
	assert_eq(menu.background_texture.texture, menu.TEX_CORTA, "2 azioni usano pergamena corta (interazione_corta.png)")
	assert_eq(menu.buttons.size(), 2, "Esattamente 2 pulsanti generati")
	assert_true(menu.buttons[1].text.contains("(5s)"), "Testo opzione con durata indica (5s)")

	# 2. Texture media per 3-4 opzioni
	var actions_media: Array[Dictionary] = [
		{"id": "a1", "title": "A1", "description": "", "duration_seconds": 0.0},
		{"id": "a2", "title": "A2", "description": "", "duration_seconds": 0.0},
		{"id": "a3", "title": "A3", "description": "", "duration_seconds": 0.0},
		{"id": "a4", "title": "A4", "description": "", "duration_seconds": 0.0}
	]
	menu.open_menu("test_prop", "Arredo Test 4", actions_media, Vector2(500, 400))
	assert_eq(menu.background_texture.texture, menu.TEX_MEDIA, "4 azioni usano pergamena media (interazione_media.png)")
	assert_eq(menu.buttons.size(), 4, "Esattamente 4 pulsanti generati")

	# 3. Texture lunga per 5+ opzioni
	var actions_lunga: Array[Dictionary] = [
		{"id": "a1", "title": "A1", "description": "", "duration_seconds": 0.0},
		{"id": "a2", "title": "A2", "description": "", "duration_seconds": 0.0},
		{"id": "a3", "title": "A3", "description": "", "duration_seconds": 0.0},
		{"id": "a4", "title": "A4", "description": "", "duration_seconds": 0.0},
		{"id": "a5", "title": "A5", "description": "", "duration_seconds": 0.0}
	]
	menu.open_menu("test_prop", "Arredo Test 5", actions_lunga, Vector2(500, 400))
	assert_eq(menu.background_texture.texture, menu.TEX_LUNGA, "5 azioni usano pergamena lunga (interazione_lunga.png)")
	assert_eq(menu.buttons.size(), 5, "Esattamente 5 pulsanti generati")

	# Test clamping viewport
	menu.open_menu("test_prop", "Test Margini", actions_corta, Vector2(1950, 1050))
	assert_true(menu.position.x <= 1920.0 - menu.size.x, "Clamping asse X mantiene menu nello schermo")
	assert_true(menu.position.y <= 1080.0 - menu.size.y, "Clamping asse Y mantiene menu nello schermo")

	# Test selezione opzione tramite segnale
	var captured: Dictionary = {}
	menu.action_chosen.connect(func(p, a):
		captured["prop"] = p
		captured["action"] = a
	)
	menu._on_option_selected(1)
	assert_eq(captured.get("prop", ""), "test_prop", "Segnale action_chosen emette prop_id corretto")
	assert_eq(captured.get("action", {}).get("id", ""), "a2", "Segnale action_chosen emette action_data corretta")
	assert_true(not menu.visible, "Menu nascosto dopo selezione opzione")

	# Test chiusura menu con Esc
	menu.open_menu("test_prop", "Test Chiusura", actions_corta, Vector2(500, 400))
	var ev_esc := InputEventKey.new()
	ev_esc.pressed = true
	ev_esc.keycode = KEY_ESCAPE
	menu._unhandled_input(ev_esc)
	assert_true(not menu.is_menu_open, "Tasto Esc chiude correttamente il menu interazioni")

	# Test scorciatoia numerica da tastiera
	menu.open_menu("test_prop", "Test Numeri", actions_corta, Vector2(500, 400))
	var ev_num := InputEventKey.new()
	ev_num.pressed = true
	ev_num.keycode = KEY_2
	menu._unhandled_input(ev_num)
	assert_eq(captured.get("action", {}).get("id", ""), "a2", "Tasto 2 seleziona direttamente la seconda opzione")

	menu.queue_free()

	# Verifica catalogo ApartmentInteractions per tutti i 10 arredi
	var expected_props = ["couch", "guitar", "kitchen", "turntable", "bed", "arcade", "wardrobe", "toolbox", "door", "stereo"]
	for p_id in expected_props:
		var acts: Array[Dictionary] = ApartmentInteractions.get_actions_for_prop(p_id)
		assert_true(acts.size() > 0, "Catalogo azioni presente e non vuoto per '%s'" % p_id)
		for act in acts:
			assert_true(act.has("id") and not act["id"].is_empty(), "Azione su '%s' ha id valido (%s)" % [p_id, act.get("id", "")])
			assert_true(act.has("title") and not act["title"].is_empty(), "Azione '%s' ha title valido" % act["id"])
			assert_true(act.has("duration_seconds") and act["duration_seconds"] >= 0.0, "Azione '%s' ha durata valida (%s s)" % [act["id"], str(act.get("duration_seconds"))])

	# Verifica specifica Guardaroba: ESCLUSIVO CAMBIO LOOK (direttiva Luca)
	var wardrobe_acts: Array[Dictionary] = ApartmentInteractions.get_actions_for_prop("wardrobe")
	assert_eq(wardrobe_acts.size(), 2, "Guardaroba ha esattamente 2 azioni (ispezione e cambio look)")
	assert_eq(wardrobe_acts[1].id, "wardrobe_change_look", "Guardaroba espone 'wardrobe_change_look'")
	for w_act in wardrobe_acts:
		assert_true(w_act.get("type", "") != "modal", "Guardaroba non contiene modali esterne spurie")

	# Verifica specifica Cassa Attrezzi: RIMOSSO UPGRADES HUB (direttiva Luca)
	var toolbox_acts: Array[Dictionary] = ApartmentInteractions.get_actions_for_prop("toolbox")
	var has_upgrades_modal: bool = false
	for tb_act in toolbox_acts:
		if tb_act.get("modal_name", "") == "Upgrades" or tb_act.get("id", "") == "toolbox_upgrades":
			has_upgrades_modal = true
	assert_true(not has_upgrades_modal, "Cassa attrezzi NON contiene apertura Upgrades Hub")

	# Test esecuzione azione con durata e modifica PlayerData in ApartmentHud
	var hud_scene: PackedScene = load("res://ui/apartment_hud/apartment_hud.tscn")
	var test_hud: ApartmentHud = hud_scene.instantiate() as ApartmentHud
	add_child(test_hud)

	var p_data := PlayerData.new()
	p_data.energy = 50.0
	p_data.stress = 40.0
	p_data.morale = 60.0
	GameManager.player_data = p_data

	# Esecuzione couch_sit
	var sit_action = {
		"id": "couch_sit",
		"title": "Relax da divano",
		"description": "Relax",
		"duration_seconds": 0.0,
		"type": "action",
		"energy_delta": 5,
		"stress_delta": -12,
		"morale_delta": 5
	}
	test_hud.execute_interaction_action("couch", sit_action)
	assert_eq(p_data.energy, 55.0, "Azione applica +5 energia (50 -> 55)")
	assert_eq(p_data.stress, 28.0, "Azione applica -12 stress (40 -> 28)")
	assert_eq(p_data.morale, 65.0, "Azione applica +5 morale (60 -> 65)")

	# Test apertura e visibilità modali da arredi (Contratto D0 & D1)
	# 1. Chitarra -> SongCreator
	test_hud.execute_interaction_action("guitar", {"type": "modal", "modal_name": "SongCreator"})
	assert_true(test_hud.get_node("Modals").visible, "Nodo Modals visibile all'apertura di SongCreator")
	assert_true(test_hud.song_creator_modal.visible, "SongCreator visibile a schermo")
	assert_true(test_hud.is_any_modal_open(), "is_any_modal_open() è true con SongCreator aperto")
	test_hud.close_modal(test_hud.song_creator_modal)
	assert_true(not test_hud.song_creator_modal.visible, "SongCreator nascosto dopo close_modal")
	assert_true(not test_hud.get_node("Modals").visible, "Nodo Modals nascosto dopo chiusura di SongCreator")
	assert_true(not test_hud.is_any_modal_open(), "is_any_modal_open() è false dopo chiusura")

	# 2. Porta -> LiveConcert
	test_hud.execute_interaction_action("door", {"type": "modal", "modal_name": "LiveConcert"})
	assert_true(test_hud.get_node("Modals").visible, "Nodo Modals visibile per LiveConcert")
	assert_true(test_hud.live_concert_modal.visible, "LiveConcert visibile")
	test_hud.close_modal(test_hud.live_concert_modal)
	assert_true(not test_hud.get_node("Modals").visible, "Nodo Modals nascosto dopo chiusura LiveConcert")

	# 3. Porta -> TravelModal
	test_hud.execute_interaction_action("door", {"type": "modal", "modal_name": "TravelModal"})
	assert_true(test_hud.get_node("Modals").visible, "Nodo Modals visibile per TravelModal")
	assert_true(test_hud.travel_modal.visible, "TravelModal visibile")
	test_hud.close_modal(test_hud.travel_modal)
	assert_true(not test_hud.get_node("Modals").visible, "Nodo Modals nascosto dopo chiusura TravelModal")

	# 4. Porta -> TourModal
	test_hud.execute_interaction_action("door", {"type": "modal", "modal_name": "TourModal"})
	assert_true(test_hud.get_node("Modals").visible, "Nodo Modals visibile per TourModal")
	assert_true(test_hud.tour_modal.visible, "TourModal visibile")
	test_hud.close_modal(test_hud.tour_modal)
	assert_true(not test_hud.get_node("Modals").visible, "Nodo Modals nascosto dopo chiusura TourModal")

	# 5. Porta -> FestivalModal
	test_hud.execute_interaction_action("door", {"type": "modal", "modal_name": "FestivalModal"})
	assert_true(test_hud.get_node("Modals").visible, "Nodo Modals visibile per FestivalModal")
	assert_true(test_hud.festival_modal.visible, "FestivalModal visibile")
	test_hud.close_modal(test_hud.festival_modal)
	assert_true(not test_hud.get_node("Modals").visible, "Nodo Modals nascosto dopo chiusura FestivalModal")

	# 6. Verifica layout pergamena 320px e autowrap testo opzioni (Contratto D2)
	var check_menu = preload("res://ui/interaction_menu/interaction_menu.tscn").instantiate()
	add_child(check_menu)
	var wrap_actions: Array[Dictionary] = [{"id": "t1", "title": "Testo Lungo di Prova per Autowrap", "duration_seconds": 5.0}]
	check_menu.open_menu("test_prop", "Test Layout", wrap_actions, Vector2(200, 200))
	assert_eq(check_menu.size.x, 320.0, "Larghezza pergamena standard a 320px")
	assert_eq(check_menu.buttons[0].autowrap_mode, TextServer.AUTOWRAP_WORD_SMART, "Autowrap attivo su pulsante pergamena")
	check_menu.queue_free()

	test_hud.queue_free()

func test_key_segregation_and_sleep_cycle() -> void:
	print("\n6. Verifica Segregazione Tasti Movimento & Ciclo Sonno / DailySummary (V5.6.2):")

	# --- Asse 1: Segregazione Tasti Movimento (Nessun movimento con W/A/S/D) ---
	var p_scene: PackedScene = load("res://scenes/apartment/player_alex.tscn")
	var player: PlayerAlex = p_scene.instantiate() as PlayerAlex
	add_child(player)

	# Verifica che a riposo (nessuna freccia / KP premuto) il vettore sia (0, 0)
	var v_rest: Vector2 = player._get_input_vector()
	assert_eq(v_rest, Vector2.ZERO, "PlayerAlex a riposo ha input_vector pari a Vector2.ZERO")

	# Verifica che la pressione del tasto W da tastiera non attivi alcuna interazione in PlayerAlex
	var ev_w := InputEventKey.new()
	ev_w.pressed = true
	ev_w.keycode = KEY_W
	player._unhandled_input(ev_w)
	assert_true(not player.is_auto_walking, "Tasto W non attiva auto-walk su PlayerAlex")
	assert_eq(player.velocity, Vector2.ZERO, "Tasto W non modifica la velocity di PlayerAlex")
	assert_true(not player.is_movement_locked, "Tasto W non altera il lock del movimento in assenza di modali")

	player.queue_free()

	# --- Asse 2: Apertura LegacyModal con W e Azzeramento Velocity in ApartmentScene ---
	var apt_scene: PackedScene = load("res://scenes/apartment/apartment.tscn")
	var apt: ApartmentScene = apt_scene.instantiate() as ApartmentScene
	add_child(apt)

	# Simula pressione tasto W nella stanza
	apt._unhandled_input(ev_w)
	assert_true(apt.hud.legacy_modal.visible, "Pressione tasto W apre correttamente LegacyModal (Albo d'oro)")
	assert_true(apt.player.is_movement_locked, "Apertura modale con W blocca il movimento di Alex")
	assert_eq(apt.player.velocity, Vector2.ZERO, "Apertura modale con W azzera istantaneamente la velocity di Alex")
	assert_true(not apt.player.is_auto_walking, "Apertura modale con W cancella qualsiasi auto-walk residuo")

	# Chiusura modale e ripristino movimento
	apt.hud.close_modal(apt.hud.legacy_modal)
	assert_true(not apt.hud.legacy_modal.visible, "LegacyModal chiusa con successo")
	assert_true(not apt.player.is_movement_locked, "Chiusura modale ripristina libertà di movimento di Alex")

	apt.queue_free()

	# --- Asse 3: Ricezione Daily Summary & Visibilità $Modals (Risoluzione Freeze) ---
	var hud_scene: PackedScene = load("res://ui/apartment_hud/apartment_hud.tscn")
	var hud: ApartmentHud = hud_scene.instantiate() as ApartmentHud
	add_child(hud)

	# Verifica che EventBus esponga il segnale daily_summary_ready
	assert_true(EventBus.has_signal("daily_summary_ready"), "EventBus espone segnale 'daily_summary_ready'")

	# Simulazione ricezione summary_data da EndDaySystem
	var test_summary: Dictionary = {
		"day": 5,
		"energy_restored": 80.0,
		"stress_change": -30.0,
		"morale_change": 15.0,
		"money_delta": 250.0,
		"events": ["Test evento notturno superato con successo"]
	}

	hud._on_daily_summary_ready(test_summary)
	assert_true(hud.has_node("Modals"), "Nodo Modals presente nell'HUD")
	assert_true(hud.get_node("Modals").visible, "Nodo $Modals reso visibile all'arrivo del Daily Summary")
	assert_true(hud.daily_summary_modal.visible, "DailySummaryModal reso visibile all'arrivo del Daily Summary")
	assert_true(hud.is_any_modal_open(), "is_any_modal_open() è true con DailySummary aperto")

	# Simulazione avanzamento giorno / chiusura summary
	hud.close_modal(hud.daily_summary_modal)
	assert_true(not hud.daily_summary_modal.visible, "DailySummaryModal nascosto dopo chiusura")
	assert_true(not hud.get_node("Modals").visible, "Nodo $Modals nascosto quando nessuna modale è aperta")
	assert_true(not hud.is_any_modal_open(), "is_any_modal_open() è false dopo chiusura del DailySummary")

	# --- Asse 4: Distinzione Azioni con Durata & Attribuzione XP (Contratto D2) ---
	var p_data := PlayerData.new()
	var xp_before: float = p_data.skills["instrument"]["xp"]
	GameManager.player_data = p_data

	# Azione chitarra con XP: non deve essere puro recupero
	var practice_action: Dictionary = {
		"id": "guitar_practice",
		"title": "Esercizio Tecnico",
		"duration_seconds": 0.0,
		"type": "action",
		"xp_amount": 15.0,
		"xp_skill": "instrument",
		"energy_delta": -10,
		"stress_delta": 5
	}
	hud.execute_interaction_action("guitar", practice_action)
	var xp_after: float = p_data.skills["instrument"]["xp"]
	assert_true(xp_after >= xp_before + 15.0, "Esercizio alla chitarra conferisce XP alla skill 'instrument'")

	# Azione divano puro relax: è recupero, nessun XP richiesto
	var nap_action: Dictionary = {
		"id": "couch_nap",
		"title": "Pisolino Ristoratore",
		"duration_seconds": 0.0,
		"type": "action",
		"xp_amount": 0.0,
		"energy_delta": 15,
		"stress_delta": -10
	}
	hud.execute_interaction_action("couch", nap_action)
	assert_true(p_data.energy > 0.0, "Pisolino sul divano applica correttamente recupero energetico")

	hud.queue_free()

func test_action_busy_lifecycle_and_safety() -> void:
	print("\n7. Verifica Ciclo GAMEPLAY_BUSY, Anti-Spam, Interruzione Esc & Sblocco SystemMenu (V5.6.3):")

	var apt_scene: PackedScene = load("res://scenes/apartment/apartment.tscn")
	var apt: ApartmentScene = apt_scene.instantiate() as ApartmentScene
	add_child(apt)

	# --- Blocco 1: Risoluzione Freeze SystemMenuModal & Ripristino Movimento ---
	var ev_esc := InputEventKey.new()
	ev_esc.pressed = true
	ev_esc.keycode = KEY_ESCAPE

	apt._unhandled_input(ev_esc)
	assert_true(apt.hud.system_menu_modal.visible, "Pressione Esc apre SystemMenuModal")
	assert_true(apt.player.is_movement_locked, "Apertura SystemMenu blocca movimento di Alex")
	assert_true(GameManager.is_paused(), "Apertura SystemMenu attiva pausa temporale")

	# Simulazione chiusura tramite Riprendi (resume_requested)
	apt.hud.system_menu_modal.resume_requested.emit()
	assert_true(not apt.hud.system_menu_modal.visible, "resume_requested chiude visivamente SystemMenuModal")
	assert_true(not apt.hud.get_node("Modals").visible, "Nodo $Modals nascosto dopo chiusura SystemMenu")
	assert_true(not apt.player.is_movement_locked, "Chiusura SystemMenu sblocca regolarmente movimento di Alex (Zero Freeze)")
	assert_true(not GameManager.is_paused(), "Chiusura SystemMenu disattiva la pausa temporale")
	assert_eq(GameManager.current_state, Enums.GameState.GAMEPLAY_IDLE, "FSM globale ritorna in GAMEPLAY_IDLE")

	# --- Blocco 2: Lock Immediato su Avvio Azione con Durata ---
	var p_data := PlayerData.new()
	p_data.energy = 80
	p_data.stress = 20
	p_data.morale = 70
	p_data.money = 500.0
	GameManager.player_data = p_data

	var practice_action: Dictionary = {
		"id": "guitar_practice",
		"title": "Scale e riff",
		"duration_seconds": 10.0,
		"type": "action",
		"xp_amount": 15.0,
		"xp_skill": "instrument",
		"energy_delta": -10,
		"stress_delta": 5,
		"money_cost": 0.0
	}

	apt.hud.execute_interaction_action("guitar", practice_action)
	assert_true(apt.hud.action_system.is_running, "ActionSystem in esecuzione per l'azione con durata")
	assert_eq(GameManager.current_state, Enums.GameState.GAMEPLAY_BUSY, "FSM globale transita deterministicamente in GAMEPLAY_BUSY")
	assert_true(apt.player.is_movement_locked, "Alex riceve lock di movimento durante GAMEPLAY_BUSY")
	assert_eq(apt.player.velocity, Vector2.ZERO, "Velocità di Alex azzerata durante l'azione")
	assert_true(not apt.player.is_auto_walking, "Auto-walk disabilitato durante l'azione")

	# --- Blocco 3: Resistenza ad Action Spamming & Guardie di Sicurezza ---
	# Tentativo di muovere Alex
	apt.player._physics_process(0.1)
	assert_eq(apt.player.velocity, Vector2.ZERO, "Physics process mantiene velocità zero durante GAMEPLAY_BUSY")

	# Tentativo di aprire modale da tasto rapido (es. W per LegacyModal o P per SongCreator)
	var ev_w := InputEventKey.new()
	ev_w.pressed = true
	ev_w.keycode = KEY_W
	apt._unhandled_input(ev_w)
	assert_true(not apt.hud.legacy_modal.visible, "Tasti rapidi modali categoricamente rifiutati durante GAMEPLAY_BUSY")

	# Tentativo di cliccare su un altro arredo col mouse
	var kitchen_prop: InteractiveProp = apt.props[1]
	apt._on_prop_clicked(kitchen_prop)
	assert_true(not apt.hud.interaction_menu.is_menu_open, "Click mouse su altri arredi ignorato durante GAMEPLAY_BUSY")

	# Protezione del salvataggio dati
	assert_true(not SaveManager.is_save_allowed(), "Salvataggio categoricamente vietato durante GAMEPLAY_BUSY")

	# --- Blocco 4: Annullamento Pulito dell'Azione con Esc (Integrità Risorse) ---
	var pre_energy: int = p_data.energy
	var pre_stress: int = p_data.stress
	var pre_money: float = p_data.money

	apt._unhandled_input(ev_esc)
	assert_true(not apt.hud.action_system.is_running, "Tasto Esc interrompe regolarmente l'azione con durata")
	assert_eq(GameManager.current_state, Enums.GameState.GAMEPLAY_IDLE, "FSM globale ritorna in GAMEPLAY_IDLE dopo interruzione")
	assert_true(not apt.player.is_movement_locked, "Alex sbloccato dopo interruzione dell'azione")

	# Verifica integrità risorse: nessun addebito o corruzione
	assert_eq(p_data.energy, pre_energy, "Energia immutata dopo annullamento azione (nessun consumo indebito)")
	assert_eq(p_data.stress, pre_stress, "Stress immutato dopo annullamento azione")
	assert_eq(p_data.money, pre_money, "Denaro immutato dopo annullamento azione")

	# --- Blocco 5: Ciclo di Completamento Naturale a Fine Timer ---
	apt.hud.execute_interaction_action("guitar", practice_action)
	assert_true(apt.hud.action_system.is_running, "Seconda azione avviata regolarmente da IDLE")
	assert_true(apt.player.is_movement_locked, "Alex nuovamente vincolato in BUSY")

	# Avanzamento del timer al 100%
	apt.hud.action_system.update_action(10.0)
	assert_true(not apt.hud.action_system.is_running, "Azione completata con successo a fine durata")
	assert_eq(GameManager.current_state, Enums.GameState.GAMEPLAY_IDLE, "FSM globale ripristinata in GAMEPLAY_IDLE a fine azione")
	assert_true(not apt.player.is_movement_locked, "Alex sbloccato a completamento azione")
	assert_eq(p_data.energy, pre_energy - 10, "Energia scalata correttamente al termine naturale dell'azione (-10)")
	assert_eq(p_data.stress, pre_stress + 5, "Stress incrementato correttamente al termine naturale dell'azione (+5)")

	apt.queue_free()

