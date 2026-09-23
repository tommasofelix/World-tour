# res://tests/test_time_night_system.gd
extends Node

## Suite di Test Automatizzati per la Filosofia della Notte, Overtime Progressivo,
## Skip Time e Riposo Anticipato (Sezione 1.2)

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST FILOSOFIA DELLA NOTTE & OVERTIME (SEZ. 1.2)   ")
	print("========================================================\n")
	
	test_virtual_time_scaling_22h()
	test_progressive_overtime_stress()
	test_skip_to_next_period()
	test_early_sleep_bonus()
	
	print("\n--------------------------------------------------------")
	print("ESITO TEST SISTEMA NOTTE & TEMPO:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed > 0:
		print("[ERRORE CRITICO] Alcuni test del sistema notte/tempo sono falliti!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Il sistema Notte, Overtime e Riposo è convalidato al 100%!")
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

func test_virtual_time_scaling_22h() -> void:
	print("1. Verifica Calcolo Orario Virtuale e Fasce su 22 Ore (06:00 - 04:00):")
	var cal: CalendarData = CalendarData.new()
	assert_eq(cal.get_formatted_time_string(), "06:00", "Inizio giornata a 300s -> 06:00")
	assert_eq(cal.current_period, Enums.TimePeriod.MORNING, "Fascia iniziale -> Mattina")
	
	# A metà giornata (150s rimanenti su 300s) = 50% di 22h = +11 ore -> 17:00
	cal.remaining_seconds = 150.0
	cal.update_period()
	assert_eq(cal.get_formatted_time_string(), "17:00", "A 150s rimanenti -> 17:00")
	assert_eq(cal.current_period, Enums.TimePeriod.AFTERNOON, "A 150s rimanenti -> Pomeriggio")
	
	# A 18 ore trascorse (00:00 Mezzanotte):
	# 18/22 trascorso -> rimanente = (4/22) * 300 = 54.545s
	cal.remaining_seconds = (4.0 / 22.0) * 300.0
	cal.update_period()
	assert_eq(cal.get_formatted_time_string(), "00:00", "A 18h trascorse -> 00:00 esatto")
	assert_eq(cal.current_period, Enums.TimePeriod.NIGHT, "A 00:00 -> Fascia Notte")
	
	# A fine giornata (0s rimanenti) -> 04:00
	cal.remaining_seconds = 0.0
	cal.update_period()
	assert_eq(cal.get_formatted_time_string(), "04:00", "A 0s rimanenti -> 04:00 termine giornata")

func test_progressive_overtime_stress() -> void:
	print("\n2. Verifica Overtime Progressivo (00:00 - 04:00):")
	var cal: CalendarData = CalendarData.new()
	var player: PlayerData = PlayerData.new()
	player.stress = 0
	
	var ts: TimeSystem = TimeSystem.new(cal, player)
	
	# Posizioniamo il tempo poco prima di mezzanotte: 17.9 ore trascorse
	var sec_before_midnight: float = ( (22.0 - 17.9) / 22.0 ) * 300.0
	cal.remaining_seconds = sec_before_midnight
	cal.update_period()
	ts.advance_time(0.1)
	assert_eq(player.stress, 0, "Prima di mezzanotte: nessuno stress overtime")
	
	# Ora avanziamo nella prima ora notturna (00:00 - 01:00):
	# 18.5 ore trascorse -> Overtime ora 1
	var sec_hour_1: float = ( (22.0 - 18.5) / 22.0 ) * 300.0
	cal.remaining_seconds = sec_hour_1
	cal.update_period()
	ts.advance_time(0.1)
	assert_eq(player.stress, Constants.OVERTIME_STRESS_HOUR_1, "Ora notturna 1 (00:00-01:00): +2 stress")
	
	# Seconda ora notturna (01:00 - 02:00):
	# 19.5 ore trascorse -> Overtime ora 2
	var sec_hour_2: float = ( (22.0 - 19.5) / 22.0 ) * 300.0
	cal.remaining_seconds = sec_hour_2
	cal.update_period()
	ts.advance_time(0.1)
	var expected_stress_2: int = Constants.OVERTIME_STRESS_HOUR_1 + Constants.OVERTIME_STRESS_HOUR_2
	assert_eq(player.stress, expected_stress_2, "Ora notturna 2 (01:00-02:00): +3 stress cumulato (totale 5)")
	
	# Terza ora notturna (02:00 - 03:00):
	# 20.5 ore trascorse -> Overtime ora 3
	var sec_hour_3: float = ( (22.0 - 20.5) / 22.0 ) * 300.0
	cal.remaining_seconds = sec_hour_3
	cal.update_period()
	ts.advance_time(0.1)
	var expected_stress_3: int = expected_stress_2 + Constants.OVERTIME_STRESS_HOUR_3
	assert_eq(player.stress, expected_stress_3, "Ora notturna 3 (02:00-03:00): +5 stress cumulato (totale 10)")
	assert_true(ts.warned_hour_2, "Avviso discreto ore 02:00 annunciato")
	
	# Quarta ora notturna (03:00 - 04:00):
	# 21.5 ore trascorse -> Overtime ora 4
	var sec_hour_4: float = ( (22.0 - 21.5) / 22.0 ) * 300.0
	cal.remaining_seconds = sec_hour_4
	cal.update_period()
	ts.advance_time(0.1)
	var expected_stress_4: int = expected_stress_3 + Constants.OVERTIME_STRESS_HOUR_4
	assert_eq(player.stress, expected_stress_4, "Ora notturna 4 (03:00-04:00): +10 stress cumulato (totale 20)")
	assert_true(ts.warned_hour_3, "Avviso discreto ore 03:00 annunciato")

func test_skip_to_next_period() -> void:
	print("\n3. Verifica Funzione Aspetta / Skip Time:")
	var cal: CalendarData = CalendarData.new()
	var ts: TimeSystem = TimeSystem.new(cal)
	
	assert_eq(cal.current_period, Enums.TimePeriod.MORNING, "Partenza: Mattina")
	
	# Skip 1: Mattina -> Pomeriggio
	var res1: bool = ts.skip_to_next_period()
	assert_true(res1, "Skip 1 eseguito con successo")
	assert_eq(cal.current_period, Enums.TimePeriod.AFTERNOON, "Fascia raggiunta: Pomeriggio")
	
	# Skip 2: Pomeriggio -> Sera
	var res2: bool = ts.skip_to_next_period()
	assert_true(res2, "Skip 2 eseguito con successo")
	assert_eq(cal.current_period, Enums.TimePeriod.EVENING, "Fascia raggiunta: Sera")
	
	# Skip 3: Sera -> Notte
	var res3: bool = ts.skip_to_next_period()
	assert_true(res3, "Skip 3 eseguito con successo")
	assert_eq(cal.current_period, Enums.TimePeriod.NIGHT, "Fascia raggiunta: Notte")
	
	# Skip 4: In Notte, skip_to_next_period non avanza ulteriormente (si dorme con Z)
	var res4: bool = ts.skip_to_next_period()
	assert_true(not res4, "In Notte lo skip restituisce false per evitare fine giorno involontaria")

func test_early_sleep_bonus() -> void:
	print("\n4. Verifica Riposo Anticipato (Dormi) e Bonus EndDaySystem:")
	var cal: CalendarData = CalendarData.new()
	var player: PlayerData = PlayerData.new()
	player.energy = 50
	player.stress = 30
	
	var ts: TimeSystem = TimeSystem.new(cal, player)
	var end_day: EndDaySystem = EndDaySystem.new(player, cal)
	
	# Chiamata a sleep_early prima delle 04:00
	cal.remaining_seconds = 100.0
	ts.sleep_early()
	
	assert_true(ts.early_sleep_taken, "Flag early_sleep_taken impostato a true")
	assert_eq(cal.remaining_seconds, 0.0, "Secondi rimanenti portati a 0 per concludere la giornata")
	
	# Verifichiamo che EndDaySystem riconosca il bonus di riposo anticipato
	var summary: Dictionary = end_day.process_day_end(1, ts.early_sleep_taken)
	assert_true(summary.get("early_sleep_bonus", false), "EndDaySystem ha registrato il bonus riposo anticipato")
	assert_eq(summary.get("sleep_quality", ""), "Riposo Anticipato Ristoratore", "Qualità riposo = Riposo Anticipato Ristoratore")
	
	# Energia recuperata base è 70 (o 100 max) + bonus 10 = recupero pieno
	assert_true(player.energy >= 90, "Energia recuperata efficacemente con bonus riposo anticipato")
	assert_true(player.stress <= 15, "Stress ridotto efficacemente con bonus riposo anticipato")
