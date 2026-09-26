# res://tests/test_multi_day_lifecycle.gd
extends Node

## Suite di Test Automatizzati per il Ciclo Vitale Multi-Giorno (Day Loop Stress Test)
## e Blindatura della Persistenza Overtime Notturno (Save/Load)
##
## Convalida headless deterministica a 0 ms:
## 1. Ciclo Giorno 1 Regolare (06:00 -> Sera -> Sonno anticipato -> Reset alba);
## 2. Giorno 2 con Overtime Notturno Profondo (00:00 -> 04:00, accumulo esatto 20 stress);
## 3. Blindatura Save & Reload a Notte Fonda (Risoluzione Bug-023: zero duplicazione stress/avvisi);
## 4. Transizione Economica, Spese, Alloggio e Royalties Multi-Giorno;
## 5. Ripristino FSM, Sblocco Movimento e Transizione Giornaliera.

const CalendarData = preload("res://data/models/calendar_data.gd")
const PlayerData = preload("res://data/models/player_data.gd")
const TimeSystem = preload("res://systems/time_system.gd")
const EndDaySystem = preload("res://systems/end_day_system.gd")
const DailySummary = preload("res://ui/summary/daily_summary.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST DAY LOOP MULTI-GIORNO & PERSISTENZA OVERTIME  ")
	print("========================================================\n")

	test_day_1_regular_flow_and_sleep()
	test_day_2_deep_overtime_and_stress_accumulation()
	test_save_reload_overtime_immunity()
	test_multi_day_economy_and_royalties()
	test_fsm_and_movement_unlocked_on_day_transition()

	print("\n--------------------------------------------------------")
	print("ESITO SUITE DAY LOOP & SAVE/LOAD OVERTIME:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")

	if tests_failed > 0:
		print("[ERRORE CRITICO] Alcuni test del ciclo multi-giorno sono falliti!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Il ciclo Day Loop e la persistenza Overtime sono convalidati al 100%!")
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

## TEST 1: Ciclo Giorno 1 Regolare
func test_day_1_regular_flow_and_sleep() -> void:
	print("1. Verifica Ciclo Giorno 1 Regolare (06:00 -> Sonno Anticipato -> Alba Giorno 2):")
	var cal: CalendarData = CalendarData.new()
	var player: PlayerData = PlayerData.new()
	player.money = 500.0
	player.energy = 60
	player.stress = 20
	
	var ts: TimeSystem = TimeSystem.new(cal, player)
	var end_day: EndDaySystem = EndDaySystem.new(player, cal)
	
	assert_eq(cal.day_number, 1, "Inizio da Giorno 1")
	assert_eq(cal.current_period, Enums.TimePeriod.MORNING, "Fascia iniziale: Mattina")
	assert_eq(cal.get_formatted_time_string(), "06:00", "Orario iniziale: 06:00")
	
	# Avanzamento a Sera (ore 20:00 -> 14h trascorse = 8/22 rimanenti)
	cal.remaining_seconds = cal.day_duration * (8.0 / 22.0)
	cal.update_period()
	assert_eq(cal.current_period, Enums.TimePeriod.EVENING, "Raggiunta fascia Sera")
	
	# Il giocatore decide di andare a dormire in anticipo
	ts.sleep_early()
	assert_true(ts.early_sleep_taken, "Flag early_sleep_taken impostato a true")
	assert_true(cal.overtime_state["early_sleep_taken"], "Flag sincronizzato in calendar_data.overtime_state")
	assert_eq(cal.remaining_seconds, 0.0, "Secondi rimanenti portati a 0 per fine giornata")
	
	# Calcolo resoconto notturno
	var summary: Dictionary = end_day.process_day_end(1, ts.early_sleep_taken)
	assert_true(summary.get("early_sleep_bonus", false), "Bonus riposo anticipato riconosciuto in summary")
	assert_true(player.energy >= 90, "Energia rigenerata con successo dal sonno")
	assert_true(player.stress <= 10, "Stress diminuito con successo dal sonno")
	
	# Transizione al Giorno 2
	end_day.advance_to_next_day()
	assert_eq(cal.day_number, 2, "Avanzato con successo al Giorno 2")
	assert_eq(cal.current_period, Enums.TimePeriod.MORNING, "Fascia ripristinata a Mattina")
	assert_eq(cal.get_formatted_time_string(), "06:00", "Orario ripristinato alle 06:00")
	assert_eq(cal.remaining_seconds, cal.day_duration, "Secondi rimanenti ripristinati a 300s")
	assert_true(not ts.early_sleep_taken, "early_sleep_taken azzerato per il nuovo giorno")
	assert_true(not cal.overtime_state["early_sleep_taken"], "overtime_state azzerato per il nuovo giorno")

## TEST 2: Giorno 2 con Overtime Notturno Profondo (00:00 -> 04:00)
func test_day_2_deep_overtime_and_stress_accumulation() -> void:
	print("\n2. Verifica Overtime Notturno Profondo (00:00 - 04:00) con Accumulo Esatto Stress:")
	var cal: CalendarData = CalendarData.new()
	cal.day_number = 2
	var player: PlayerData = PlayerData.new()
	player.stress = 0
	
	var ts: TimeSystem = TimeSystem.new(cal, player)
	var end_day: EndDaySystem = EndDaySystem.new(player, cal)
	
	# 1. Ore 00:00 (offset 18) -> +2 stress
	cal.remaining_seconds = cal.day_duration * (3.8 / 22.0)
	cal.update_period()
	ts.advance_time(0.1)
	assert_eq(player.stress, 2, "Ore 00:00: +2 stress accumulato")
	assert_true(ts.overtime_hour_1_applied, "overtime_hour_1_applied attivo in TimeSystem")
	assert_true(cal.overtime_state["overtime_hour_1_applied"], "overtime_hour_1_applied riflesso in CalendarData")
	
	# 2. Ore 01:00 (offset 19) -> +3 stress (totale 5)
	cal.remaining_seconds = cal.day_duration * (2.8 / 22.0)
	cal.update_period()
	ts.advance_time(0.1)
	assert_eq(player.stress, 5, "Ore 01:00: +3 stress cumulato (totale 5)")
	assert_true(ts.overtime_hour_2_applied, "overtime_hour_2_applied attivo")
	
	# 3. Ore 02:00 (offset 20) -> +5 stress (totale 10) e avviso discreto
	cal.remaining_seconds = cal.day_duration * (1.8 / 22.0)
	cal.update_period()
	ts.advance_time(0.1)
	assert_eq(player.stress, 10, "Ore 02:00: +5 stress cumulato (totale 10)")
	assert_true(ts.warned_hour_2, "warned_hour_2 registrato")
	assert_true(cal.overtime_state["warned_hour_2"], "warned_hour_2 persistito in CalendarData")
	
	# 4. Ore 03:00 (offset 21) -> +10 stress (totale 20) e avviso finale
	cal.remaining_seconds = cal.day_duration * (0.8 / 22.0)
	cal.update_period()
	ts.advance_time(0.1)
	assert_eq(player.stress, 20, "Ore 03:00: +10 stress cumulato (totale 20)")
	assert_true(ts.warned_hour_3, "warned_hour_3 registrato")
	assert_true(ts.overtime_hour_4_applied, "overtime_hour_4_applied attivo")
	
	# 5. Chiusura forzata alle 04:00 (0s rimanenti)
	cal.remaining_seconds = 0.0
	cal.update_period()
	var summary: Dictionary = end_day.process_day_end(2, false)
	assert_true(not summary.get("early_sleep_bonus", false), "Zero bonus riposo anticipato alle 04:00")
	
	# Transizione al Giorno 3 con azzeramento
	end_day.advance_to_next_day()
	assert_eq(cal.day_number, 3, "Transizione a Giorno 3")
	assert_true(not ts.overtime_hour_1_applied, "Tutti i flag overtime azzerati all'alba del Giorno 3")
	assert_true(not ts.warned_hour_2, "warned_hour_2 azzerato all'alba")
	assert_true(not cal.overtime_state["overtime_hour_4_applied"], "CalendarData overtime_state azzerato")

## TEST 3: Blindatura Save & Reload a Notte Fonda (Risoluzione BUG-023)
func test_save_reload_overtime_immunity() -> void:
	print("\n3. Verifica Immunità Duplicazione Overtime al Save/Load Notturno (RCA BUG-023):")
	var cal: CalendarData = CalendarData.new()
	cal.day_number = 3
	var player: PlayerData = PlayerData.new()
	player.stress = 0
	
	var ts: TimeSystem = TimeSystem.new(cal, player)
	
	# Avanziamo alle 02:30 di notte (offset 20, ore 20.5 trascorse)
	cal.remaining_seconds = cal.day_duration * (1.5 / 22.0)
	cal.update_period()
	ts.advance_time(0.1)
	
	# A questo punto sono state applicate ore 1 (+2), ore 2 (+3), ore 3 (+5) = 10 stress
	assert_eq(player.stress, 10, "Stress a 10 prima del salvataggio")
	assert_true(ts.warned_hour_2, "Avviso 02:00 già emesso")
	assert_true(ts.overtime_hour_3_applied, "Penalità ora 3 già applicata")
	
	# SIMULAZIONE SERIALIZZAZIONE SAVEGAME
	var cal_dict: Dictionary = cal.to_dict()
	var player_dict: Dictionary = player.to_dict()
	
	# Verifica che lo stato overtime sia presente nel dizionario serializzato
	assert_true(cal_dict.has("overtime_state"), "overtime_state presente nel salvataggio")
	assert_true(cal_dict["overtime_state"].get("overtime_hour_3_applied", false), "overtime_hour_3_applied serializzato true")
	assert_true(cal_dict["overtime_state"].get("warned_hour_2", false), "warned_hour_2 serializzato true")
	
	# SIMULAZIONE DESERIALIZZAZIONE E RICARICAMENTO IN NUOVA ISTANZA
	var reloaded_cal: CalendarData = CalendarData.new()
	reloaded_cal.from_dict(cal_dict)
	
	var reloaded_player: PlayerData = PlayerData.new()
	reloaded_player.from_dict(player_dict)
	
	var reloaded_ts: TimeSystem = TimeSystem.new(reloaded_cal, reloaded_player)
	
	# Verifica che la nuova istanza TimeSystem abbia ripristinato i flag da CalendarData
	assert_true(reloaded_ts.warned_hour_2, "warned_hour_2 ripristinato true in TimeSystem")
	assert_true(reloaded_ts.overtime_hour_1_applied, "overtime_hour_1_applied ripristinato true")
	assert_true(reloaded_ts.overtime_hour_2_applied, "overtime_hour_2_applied ripristinato true")
	assert_true(reloaded_ts.overtime_hour_3_applied, "overtime_hour_3_applied ripristinato true")
	
	# ESEGUIAMO UN TICK TEMPORALE DOPO IL CARICAMENTO:
	reloaded_ts.advance_time(0.5)
	
	# VERIFICA CRUCIALE: Nessuna penalità deve essere stata ri-applicata!
	assert_eq(reloaded_player.stress, 10, "Lo stress è rimasto rigorosamente a 10 senza duplicazioni spurie!")
	
	# Avanziamo alle 03:15: deve applicare SOLTANTO l'ora 4 (+10 stress), portando il totale a 20 e non oltre!
	reloaded_cal.remaining_seconds = reloaded_cal.day_duration * (0.7 / 22.0)
	reloaded_cal.update_period()
	reloaded_ts.advance_time(0.1)
	
	assert_eq(reloaded_player.stress, 20, "Avanzando alle 03:15 si aggiunge solo l'ora 4 (+10), stress totale = 20")
	assert_true(reloaded_ts.warned_hour_3, "Avviso 03:00 emesso regolarmente")

## TEST 4: Transizione Economica, Spese e Royalties Multi-Giorno
func test_multi_day_economy_and_royalties() -> void:
	print("\n4. Verifica Transizione Economica Multi-Giorno (Spese di Sussistenza & Statistiche):")
	var cal: CalendarData = CalendarData.new()
	var player: PlayerData = PlayerData.new()
	player.money = 200.0
	
	var end_day: EndDaySystem = EndDaySystem.new(player, cal)
	
	# Fine Giorno 1
	var sum1: Dictionary = end_day.process_day_end(1, true)
	var exp1: float = float(sum1.get("expenses", 25.0))
	assert_eq(player.money, 200.0 - exp1, "Spese giorno 1 detratte correttamente (175 €)")
	end_day.advance_to_next_day()
	
	# Fine Giorno 2
	var sum2: Dictionary = end_day.process_day_end(2, true)
	var exp2: float = float(sum2.get("expenses", 25.0))
	assert_eq(player.money, 200.0 - exp1 - exp2, "Spese giorno 2 detratte correttamente (150 €)")
	end_day.advance_to_next_day()
	
	assert_eq(player.get_career_stat("total_days_active"), 3, "total_days_active tracciato a 3 giorni (1 iniziale + 2 avanzamenti)")

## TEST 5: Sblocco FSM & Ripristino Movimento
func test_fsm_and_movement_unlocked_on_day_transition() -> void:
	print("\n5. Verifica Sblocco FSM e Movimento al Nuovo Giorno:")
	var cal: CalendarData = CalendarData.new()
	var player: PlayerData = PlayerData.new()
	var end_day: EndDaySystem = EndDaySystem.new(player, cal)
	
	# Simuliamo cambio stato a fine giornata
	GameManager.change_state(Enums.GameState.DAILY_SUMMARY)
	assert_eq(GameManager.current_state, Enums.GameState.DAILY_SUMMARY, "Stato impostato a DAILY_SUMMARY")
	
	# Avanzamento al giorno successivo
	end_day.advance_to_next_day()
	assert_eq(GameManager.current_state, Enums.GameState.GAMEPLAY_IDLE, "Stato ripristinato deterministicamente a GAMEPLAY_IDLE all'alba")
