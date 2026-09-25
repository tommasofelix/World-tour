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

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST GAMEPLAY GRAFICO 2.5D LOFT NYC (V5.4.0)   ")
	print("========================================================\n")

	test_player_alex_component()
	test_interactive_prop_component()
	test_apartment_hud_component()
	test_apartment_scene_integration()

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
