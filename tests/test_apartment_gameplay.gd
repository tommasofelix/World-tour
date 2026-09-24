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

	# Verifica highlight visivo e segnale mouse click
	assert_true(prop.has_signal("prop_clicked"), "Segnale prop_clicked presente su InteractiveProp")
	prop.set_highlight(true)
	assert_true(prop._prompt_node.visible, "Prompt visibile con highlight attivo")
	prop.set_highlight(false)
	assert_true(not prop._prompt_node.visible, "Prompt nascosto con highlight disattivato")

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

	apt.queue_free()
