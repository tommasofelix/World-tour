# tests/test_vertical_slice.gd
extends Node

## Suite di Test Headless per il Vertical Slice V1.0 di World-tour
## Valida l'intero Core Loop: Modelli Dati -> TimeSystem -> ActionSystem -> EndDaySystem -> SaveManager

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST VERTICAL SLICE V1.0 (CORE LOOP VITALE)   ")
	print("========================================================\n")
	
	test_player_data_model()
	test_calendar_data_model()
	test_time_system_flow()
	test_action_system_execution()
	test_action_anti_grinding()
	test_end_day_resolution()
	test_atomic_save_and_load()
	test_character_sheet_ui()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST VERTICAL SLICE:")
	print("  Test Superati: ", tests_passed)
	print("  Test Falliti:  ", tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed > 0:
		printerr("[ERRORE CRITICO] Il Vertical Slice V1.0 presenta anomalie!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Il Vertical Slice V1.0 è convalidato al 100%!")
		get_tree().quit(0)

func assert_true(condition: bool, test_name: String) -> void:
	if condition:
		print("  [OK] ", test_name)
		tests_passed += 1
	else:
		printerr("  [FALLITO] ", test_name)
		tests_failed += 1

func assert_equal(actual: Variant, expected: Variant, test_name: String) -> void:
	if actual == expected:
		print("  [OK] %s (%s == %s)" % [test_name, str(actual), str(expected)])
		tests_passed += 1
	else:
		printerr("  [FALLITO] %s (Effettivo: %s, Atteso: %s)" % [test_name, str(actual), str(expected)])
		tests_failed += 1

# --- Test Case Dettagliati ---

func test_player_data_model() -> void:
	print("1. Verifica Modello PlayerData:")
	var p: PlayerData = PlayerData.new()
	assert_equal(p.energy, 100, "Energia iniziale = 100")
	assert_equal(p.stress, 0, "Stress iniziale = 0")
	assert_equal(p.money, 500.0, "Saldo iniziale = 500.00 €")
	assert_equal(p.get_skill_level("instrument"), 10, "Livello base strumento = 10")
	
	# Test consumo ed eccezione
	var ok_consume: bool = p.consume_energy(40)
	assert_true(ok_consume and p.energy == 60, "Consumo 40 energia -> Rimanenti 60")
	var fail_consume: bool = p.consume_energy(100)
	assert_true(not fail_consume and p.energy == 60, "Consumo eccessivo (100) -> Rifiutato senza modifiche")
	
	# Test serializzazione
	var d: Dictionary = p.to_dict()
	var p_restored: PlayerData = PlayerData.new()
	p_restored.from_dict(d)
	assert_equal(p_restored.energy, 60, "Ripristino serializzazione: Energia mantenuta a 60")
	
	# Test tratti, background e serializzazione identità
	assert_equal(p.background_id, "self_taught", "Background ID iniziale = self_taught")
	assert_equal(p.trait_id, "charismatic", "Trait ID iniziale = charismatic")
	assert_true(p.get_background_name().contains("Autodidatta"), "Nome background localizzato contiene Autodidatta")
	assert_true(p.get_trait_name().contains("Carismatico"), "Nome tratto localizzato contiene Carismatico")
	
	p.trait_id = "resilient"
	p.background_id = "conservatory"
	var d2: Dictionary = p.to_dict()
	var p2: PlayerData = PlayerData.new()
	p2.from_dict(d2)
	assert_equal(p2.trait_id, "resilient", "Ripristino serializzazione: Trait ID resilient")
	assert_equal(p2.background_id, "conservatory", "Ripristino serializzazione: Background ID conservatory")
	
	# Test Band, Album e Alloggi (World-tour V2.0)
	var member := BandMemberData.new("bass_01", "Marco Bass", Enums.BandRole.BASS, Enums.BandPersonality.RELIABLE, Enums.MusicalGenre.ROCK, 15)
	assert_true(p.add_band_member(member), "Aggiunta membro band riuscita")
	assert_equal(p.band_members.size(), 1, "Numero membri band = 1")
	assert_equal(p.get_band_member_by_role(Enums.BandRole.BASS).member_name, "Marco Bass", "Recupero bassista per ruolo corretto")
	
	var album := AlbumData.new("ep_01", "First Demo EP", Enums.AlbumType.EP)
	album.song_ids = ["s1", "s2", "s3"]
	p.add_album(album)
	assert_equal(p.albums.size(), 1, "Numero album registrati = 1")
	
	p.revenue_split_mode = Enums.RevenueSplit.LEADER_BALANCED
	p.current_housing_tier = Enums.HousingTier.SHARED_FLAT
	
	var d3: Dictionary = p.to_dict()
	var p3: PlayerData = PlayerData.new()
	p3.from_dict(d3)
	assert_equal(p3.band_members.size(), 1, "Ripristino serializzazione: 1 membro band")
	assert_equal(p3.band_members[0].member_name, "Marco Bass", "Ripristino nome membro: Marco Bass")
	assert_equal(p3.albums.size(), 1, "Ripristino serializzazione: 1 album")
	assert_equal(p3.albums[0].title, "First Demo EP", "Ripristino titolo album")
	assert_equal(p3.revenue_split_mode, Enums.RevenueSplit.LEADER_BALANCED, "Ripristino revenue split")
	assert_equal(p3.current_housing_tier, Enums.HousingTier.SHARED_FLAT, "Ripristino housing tier")

func test_calendar_data_model() -> void:
	print("\n2. Verifica Modello CalendarData:")
	var c: CalendarData = CalendarData.new()
	assert_equal(c.day_number, 1, "Giorno iniziale = 1")
	assert_equal(c.remaining_seconds, 300.0, "Secondi iniziali = 300s (5 min default)")
	assert_equal(c.get_period_name(), "Mattina", "Fascia oraria iniziale = Mattina")
	assert_equal(c.get_formatted_time_string(), "06:00", "Orario virtuale iniziale = 06:00")
	
	# Avanzamento orario virtuale a metà giornata (150s rimanenti)
	c.remaining_seconds = 150.0
	c.update_period()
	assert_equal(c.get_period_name(), "Pomeriggio", "A 150s -> Fascia Pomeriggio")
	assert_equal(c.get_formatted_time_string(), "17:00", "A 150s -> Ore 17:00 virtuali")

func test_time_system_flow() -> void:
	print("\n3. Verifica Motore Temporale (TimeSystem):")
	var c: CalendarData = CalendarData.new()
	var ts: TimeSystem = TimeSystem.new(c)
	
	# Avanzamento nominale a 1x (da 300s)
	ts.advance_time(10.0)
	assert_equal(c.remaining_seconds, 290.0, "Avanzamento 10s a 1x -> 290s rimanenti")
	
	# Pausa attiva
	ts.set_paused(true)
	ts.advance_time(10.0)
	assert_equal(c.remaining_seconds, 290.0, "In pausa -> Il tempo rimane bloccato a 290s")
	ts.set_paused(false)
	
	# Moltiplicatore 2x
	ts.set_time_scale(2.0)
	ts.advance_time(10.0)
	assert_equal(c.remaining_seconds, 270.0, "Avanzamento 10s a 2x -> 270s rimanenti")

func test_action_system_execution() -> void:
	print("\n4. Verifica Esecuzione Azione (ActionSystem):")
	var p: PlayerData = PlayerData.new()
	var c: CalendarData = CalendarData.new()
	var act_sys: ActionSystem = ActionSystem.new(p, c)
	var test_action: ActionData = ActionData.new(
		"test_practice",
		"Test Allenamento",
		10.0,
		20,
		5,
		15.0,
		"instrument"
	)
	
	# Tentativo avvio azione
	var started: bool = act_sys.start_action(test_action)
	assert_true(started, "Avvio azione regolare consentito")
	assert_true(act_sys.is_running, "ActionSystem risulta in stato di esecuzione")
	assert_equal(GameManager.get_current_state(), Enums.GameState.GAMEPLAY_BUSY, "FSM globale transita in GAMEPLAY_BUSY")
	
	# Aggiornamento parziale (50%)
	act_sys.update_action(5.0)
	assert_true(act_sys.is_running, "Azione ancora in corso a metà timer")
	
	# Completamento azione (rimanenti 5.0s)
	act_sys.update_action(5.0)
	assert_true(not act_sys.is_running, "Azione completata e conclusa")
	assert_equal(p.energy, 80, "Consumo energia applicato (100 - 20 = 80)")
	assert_equal(p.stress, 5, "Stress accumulato applicato (0 + 5 = 5)")
	assert_true(p.skills["instrument"]["xp"] > 0.0, "XP assegnati allo strumento")
	assert_equal(GameManager.get_current_state(), Enums.GameState.GAMEPLAY_IDLE, "FSM globale ritorna in GAMEPLAY_IDLE")

func test_action_anti_grinding() -> void:
	print("\n5. Verifica Anti-Grinding Azioni nel CalendarData:")
	var c: CalendarData = CalendarData.new()
	assert_equal(c.get_action_count("practice"), 0, "Conteggio iniziale azione = 0")
	
	c.increment_action_count("practice")
	assert_equal(c.get_action_count("practice"), 1, "Prima esecuzione registrata = 1")
	
	c.increment_action_count("practice")
	assert_equal(c.get_action_count("practice"), 2, "Seconda esecuzione registrata = 2")
	
	c.reset_daily_saturation()
	assert_equal(c.get_action_count("practice"), 0, "Reset giornaliero azzera saturazione a 0")

func test_end_day_resolution() -> void:
	print("\n6. Verifica Risoluzione Fine Giornata (EndDaySystem):")
	var p: PlayerData = PlayerData.new()
	p.money = 200.0
	p.energy = 20
	p.stress = 40
	
	var c: CalendarData = CalendarData.new()
	var end_day: EndDaySystem = EndDaySystem.new(p, c)
	
	# Simulazione emissione giorno terminato
	EventBus.day_ended.emit(1)
	
	assert_equal(GameManager.get_current_state(), Enums.GameState.DAILY_SUMMARY, "Transizione a DAILY_SUMMARY")
	assert_equal(p.money, 175.0, "Spese vive (25€) detratte dal saldo (200 - 25 = 175€)")
	assert_equal(p.energy, 90, "Sonno ristoratore: +70 energia (20 + 70 = 90)")
	assert_equal(p.stress, 25, "Sonno ristoratore: -15 stress (40 - 15 = 25)")
	
	# Passaggio al giorno successivo
	end_day.advance_to_next_day()
	assert_equal(c.day_number, 2, "Giorno incrementato a 2")
	assert_equal(c.remaining_seconds, 300.0, "Orologio ripristinato a 300s")
	assert_equal(GameManager.get_current_state(), Enums.GameState.GAMEPLAY_IDLE, "FSM ritorna in GAMEPLAY_IDLE")

func test_atomic_save_and_load() -> void:
	print("\n7. Verifica Persistenza Atomica (SaveManager):")
	GameManager.player_data = PlayerData.new()
	GameManager.player_data.player_name = "Luca Rock"
	GameManager.player_data.money = 777.50
	GameManager.calendar_data = CalendarData.new()
	GameManager.calendar_data.day_number = 3
	GameManager.change_state(Enums.GameState.GAMEPLAY_IDLE)
	
	# Test blocco salvataggio durante azione (BUSY)
	GameManager.change_state(Enums.GameState.GAMEPLAY_BUSY)
	var save_blocked: bool = SaveManager.save_game()
	assert_true(not save_blocked, "Salvataggio bloccato categoricamente in stato GAMEPLAY_BUSY")
	
	# Test salvataggio valido in IDLE
	GameManager.change_state(Enums.GameState.GAMEPLAY_IDLE)
	var save_ok: bool = SaveManager.save_game()
	assert_true(save_ok, "Salvataggio atomico riuscito in stato IDLE")
	assert_true(SaveManager.has_savegame(), "File user://savegame.json presente su disco")
	
	# Modifica memoria per simulare riavvio
	GameManager.player_data.player_name = "Modificato"
	GameManager.player_data.money = 0.0
	GameManager.calendar_data.day_number = 99
	
	# Test caricamento
	var load_ok: bool = SaveManager.load_game()
	assert_true(load_ok, "Caricamento salvataggio riuscito")
	assert_equal(GameManager.player_data.player_name, "Luca Rock", "Nome ripristinato correttamente: Luca Rock")
	assert_equal(GameManager.player_data.money, 777.50, "Saldo ripristinato correttamente: 777.50 €")
	assert_equal(GameManager.calendar_data.day_number, 3, "Giorno ripristinato correttamente: Giorno 3")

func test_character_sheet_ui() -> void:
	print("\n8. Verifica Scheda Personaggio e Identità (CharacterSheet):")
	var char_res: Resource = load("res://ui/character/character_sheet.tscn")
	assert_true(char_res != null, "Risorsa character_sheet.tscn caricata")
	var sheet: Control = char_res.instantiate() as Control
	assert_true(sheet != null, "Istanziazione character_sheet riuscita")
	
	add_child(sheet)
	var btn_close: Button = sheet.get_node_or_null("PanelMain/VBox/HBoxBottom/BtnClose")
	assert_true(btn_close != null, "BtnClose presente nella scheda personaggio")
	
	var lbl_name: Label = sheet.get_node_or_null("PanelMain/VBox/HBoxBody/VBoxLeft/LabelName")
	assert_true(lbl_name != null, "LabelName presente nella colonna anagrafica")
	
	var vbox_skills: VBoxContainer = sheet.get_node_or_null("PanelMain/VBox/HBoxBody/VBoxRight/ScrollSkills/VBoxSkillsList")
	assert_true(vbox_skills != null, "VBoxSkillsList presente per la matrice delle 7 abilità")
	
	sheet.refresh_sheet()
	assert_equal(vbox_skills.get_child_count(), 7, "Matrice delle 7 abilità popolata (7 elementi)")
	remove_child(sheet)
	sheet.queue_free()

