# res://tests/test_vital_resources_system.gd
extends Node

## Suite di Test Automatizzati per la Triade Risorse Vitali (Energia, Stress, Morale),
## Recupero Attivo Diurno, Burnout e Panico (Sezione 1.3)

const RelaxModalScript = preload("res://ui/relax/relax_modal.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST RISORSE VITALI & RECUPERO ATTIVO (SEZ. 1.3)   ")
	print("========================================================\n")
	
	test_recovery_coffee()
	test_recovery_walk()
	test_recovery_music()
	test_insufficient_funds_rejection()
	test_burnout_duration_doubling()
	test_panic_state_detection()
	test_relax_modal_instantiation()
	
	print("\n--------------------------------------------------------")
	print("ESITO TEST SISTEMA RISORSE VITALI & RECUPERO:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed > 0:
		print("[ERRORE CRITICO] Alcuni test delle risorse vitali sono falliti!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Il sistema Risorse Vitali e Recupero Attivo è convalidato al 100%!")
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

func test_recovery_coffee() -> void:
	print("1. Verifica Attività Caffè al Bar (Recupero Energia & Costo Stress/Denaro):")
	var player: PlayerData = PlayerData.new()
	var cal: CalendarData = CalendarData.new()
	player.energy = 40
	player.stress = 20
	player.money = 100.0
	
	var act_sys: ActionSystem = ActionSystem.new(player, cal)
	var coffee_act: ActionData = RelaxModalScript.create_coffee_action()
	
	assert_eq(coffee_act.money_cost, Constants.RECOVERY_COFFEE_COST, "Costo caffè = 2.00 €")
	assert_true(coffee_act.is_recovery, "Flag is_recovery = true")
	
	var started: bool = act_sys.start_action(coffee_act)
	assert_true(started, "Avvio azione caffè riuscito")
	assert_true(act_sys.is_running, "ActionSystem in esecuzione")
	
	# Avanzamento e completamento (5 secondi)
	act_sys.update_action(coffee_act.duration_seconds)
	assert_true(not act_sys.is_running, "Azione caffè completata")
	assert_eq(player.money, 98.0, "Saldo detratto di 2.00 € (100 - 2 = 98)")
	assert_eq(player.energy, 40 + Constants.RECOVERY_COFFEE_ENERGY, "Energia incrementata di +15 (40 + 15 = 55)")
	assert_eq(player.stress, 20 + Constants.RECOVERY_COFFEE_STRESS, "Stress incrementato di +5 (20 + 5 = 25)")

func test_recovery_walk() -> void:
	print("\n2. Verifica Attività Passeggiata al Parco (Defaticamento Stress & Morale):")
	var player: PlayerData = PlayerData.new()
	var cal: CalendarData = CalendarData.new()
	player.energy = 50
	player.stress = 40
	player.morale = 60
	player.money = 98.0
	
	var act_sys: ActionSystem = ActionSystem.new(player, cal)
	var walk_act: ActionData = RelaxModalScript.create_walk_action()
	
	assert_eq(walk_act.money_cost, 0.0, "Costo passeggiata = 0 € (Gratis)")
	assert_true(walk_act.is_recovery, "Flag is_recovery = true")
	
	var started: bool = act_sys.start_action(walk_act)
	assert_true(started, "Avvio azione passeggiata riuscito")
	
	act_sys.update_action(walk_act.duration_seconds)
	assert_true(not act_sys.is_running, "Azione passeggiata completata")
	assert_eq(player.money, 98.0, "Saldo invariato (Gratis)")
	assert_eq(player.stress, 40 - Constants.RECOVERY_WALK_STRESS_RELIEF, "Stress ridotto di -15 (40 - 15 = 25)")
	assert_eq(player.morale, 60 + Constants.RECOVERY_WALK_MORALE, "Morale aumentato di +5 (60 + 5 = 65)")
	assert_eq(player.energy, 50 - Constants.RECOVERY_WALK_ENERGY_COST, "Energia ridotta di -5 (50 - 5 = 45)")

func test_recovery_music() -> void:
	print("\n3. Verifica Attività Ascolto Disco (Ricarica Morale & Relax):")
	var player: PlayerData = PlayerData.new()
	var cal: CalendarData = CalendarData.new()
	player.energy = 45
	player.stress = 25
	player.morale = 65
	
	var act_sys: ActionSystem = ActionSystem.new(player, cal)
	var music_act: ActionData = RelaxModalScript.create_music_action()
	
	assert_eq(music_act.money_cost, 0.0, "Costo ascolto musica = 0 € (Gratis)")
	assert_eq(music_act.inspiration_chance, Constants.RECOVERY_MUSIC_SPARK_CHANCE, "Chance Scintilla Creativa = 35%")
	
	var started: bool = act_sys.start_action(music_act)
	assert_true(started, "Avvio ascolto musica riuscito")
	
	act_sys.update_action(music_act.duration_seconds)
	assert_true(not act_sys.is_running, "Azione ascolto musica completata")
	assert_eq(player.morale, 65 + Constants.RECOVERY_MUSIC_MORALE, "Morale aumentato di +20 (65 + 20 = 85)")
	assert_eq(player.stress, 25 - Constants.RECOVERY_MUSIC_STRESS_RELIEF, "Stress ridotto di -10 (25 - 10 = 15)")

func test_insufficient_funds_rejection() -> void:
	print("\n4. Verifica Blocco Azione per Fondi Insufficienti:")
	var player: PlayerData = PlayerData.new()
	var cal: CalendarData = CalendarData.new()
	player.money = 1.0 # Meno dei 2 € richiesti
	
	var act_sys: ActionSystem = ActionSystem.new(player, cal)
	var coffee_act: ActionData = RelaxModalScript.create_coffee_action()
	
	var check: Dictionary = act_sys.can_start_action(coffee_act)
	assert_true(not check["can_start"], "Avvio caffè rifiutato con 1.00 €")
	assert_true(check["reason"].contains("Denaro insufficiente"), "Motivazione segnala Denaro insufficiente")

func test_burnout_duration_doubling() -> void:
	print("\n5. Verifica Condizione di Burnout Fisico (< 15% Energia):")
	var player: PlayerData = PlayerData.new()
	var cal: CalendarData = CalendarData.new()
	player.energy = 10 # Sotto la soglia di 15%
	
	var act_sys: ActionSystem = ActionSystem.new(player, cal)
	
	# 5A. Azione ordinaria (quick practice): durata raddoppiata
	var practice_act: ActionData = ActionData.new("practice", "Allenamento", 10.0, 5, 2, 10.0)
	var started_practice: bool = act_sys.start_action(practice_act)
	assert_true(started_practice, "Azione ordinaria avviata")
	assert_eq(act_sys.current_action_duration, 20.0, "Durata raddoppiata da 10s a 20s per Burnout")
	act_sys.cancel_action()
	
	# 5B. Azione di recupero (caffè): durata NON raddoppiata per consentire la cura
	var coffee_act: ActionData = RelaxModalScript.create_coffee_action()
	var started_coffee: bool = act_sys.start_action(coffee_act)
	assert_true(started_coffee, "Azione di recupero caffè avviata in Burnout")
	assert_eq(act_sys.current_action_duration, Constants.RECOVERY_COFFEE_DURATION, "Durata recupero rimane nominale (5s) per cura")
	act_sys.cancel_action()

func test_panic_state_detection() -> void:
	print("\n6. Verifica Rilevamento Soglia di Panico (>= 80% Stress):")
	var player: PlayerData = PlayerData.new()
	var cal: CalendarData = CalendarData.new()
	player.stress = 85 # Sopra la soglia di 80
	
	var act_sys: ActionSystem = ActionSystem.new(player, cal)
	var walk_act: ActionData = RelaxModalScript.create_walk_action()
	var started: bool = act_sys.start_action(walk_act)
	assert_true(started, "Passeggiata avviabile anche in stato di panico per de-escalation")
	act_sys.cancel_action()

func test_relax_modal_instantiation() -> void:
	print("\n7. Verifica Istanziazione e Nodi Scena RelaxModal:")
	var scene: PackedScene = load("res://ui/relax/relax_modal.tscn")
	assert_true(scene != null, "Caricamento risorsa relax_modal.tscn riuscito")
	var inst: Node = scene.instantiate()
	assert_true(inst != null, "Istanziazione RelaxModal riuscita")
	add_child(inst)
	
	var btn_coffee: Button = inst.find_child("BtnCoffee", true, false)
	var btn_walk: Button = inst.find_child("BtnWalk", true, false)
	var btn_music: Button = inst.find_child("BtnMusic", true, false)
	var btn_close: Button = inst.find_child("BtnClose", true, false)
	
	assert_true(btn_coffee != null, "Nodo BtnCoffee presente")
	assert_true(btn_walk != null, "Nodo BtnWalk presente")
	assert_true(btn_music != null, "Nodo BtnMusic presente")
	assert_true(btn_close != null, "Nodo BtnClose presente")
	
	# Verifica emissione segnale activity_selected via Array capture (closure-safe)
	var received: Array = []
	inst.activity_selected.connect(func(act): received.append(act))
	inst._on_btn_coffee_pressed()
	assert_true(received.size() > 0, "Segnale activity_selected emesso alla pressione di BtnCoffee")
	if received.size() > 0:
		assert_eq(received[0].action_id, "recovery_coffee", "Action id emesso = recovery_coffee")
	
	inst.queue_free()
