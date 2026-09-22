# tests/test_formulas.gd
extends SceneTree

## Suite di Test Unitari Headless per le Formule Matematiche di World-tour
## Eseguibile direttamente da riga di comando senza rendering grafico.

var tests_passed: int = 0
var tests_failed: int = 0

func _init() -> void:
	print("\n========================================================")
	print("   SUITE DI TEST FORMULE MATEMATICHE (WORLD-TOUR)   ")
	print("========================================================\n")
	
	test_xp_progression()
	test_diminishing_returns()
	test_efficiency_factor()
	test_training_xp()
	test_song_quality()
	test_audience_calculation()
	test_concert_score()
	test_fan_conversion()
	test_edge_cases_and_robustness()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST:")
	print("  Test Superati: ", tests_passed)
	print("  Test Falliti:  ", tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed > 0:
		print("[ERRORE CRITICO] Alcuni test matematici sono falliti!")
		quit(1)
	else:
		print("[SUCCESSO] Tutte le formule matematiche sono convalidate e stabili al 100%.")
		quit(0)

func assert_true(condition: bool, test_name: String) -> void:
	if condition:
		print("  [OK] ", test_name)
		tests_passed += 1
	else:
		printerr("  [FALLITO] ", test_name)
		tests_failed += 1

func assert_approx_equal(actual: float, expected: float, tolerance: float, test_name: String) -> void:
	var diff: float = absf(actual - expected)
	if diff <= tolerance:
		print("  [OK] %s (Effettivo: %f, Atteso: %f)" % [test_name, actual, expected])
		tests_passed += 1
	else:
		printerr("  [FALLITO] %s (Effettivo: %f, Atteso: %f, Diff: %f)" % [test_name, actual, expected, diff])
		tests_failed += 1

# --- Test Case Dettagliati ---

func test_xp_progression() -> void:
	print("1. Verifica Progressione XP per Livello:")
	var xp_l1: int = Formulas.calculate_xp_for_level(1)
	assert_approx_equal(float(xp_l1), 50.0, 1.0, "Livello 1 -> 50 XP")
	
	var xp_l5: int = Formulas.calculate_xp_for_level(5)
	assert_approx_equal(float(xp_l5), 437.0, 2.0, "Livello 5 -> ~437 XP")
	
	var xp_l20: int = Formulas.calculate_xp_for_level(20)
	assert_approx_equal(float(xp_l20), 2845.0, 10.0, "Livello 20 -> ~2845 XP")
	
	var xp_l99: int = Formulas.calculate_xp_for_level(99)
	assert_approx_equal(float(xp_l99), 24722.0, 50.0, "Livello 99 -> ~24722 XP")

func test_diminishing_returns() -> void:
	print("\n2. Verifica Anti-Grinding (Rendimenti Marginali Decrescenti):")
	assert_approx_equal(Formulas.get_saturation_modifier(1), 1.0, 0.001, "Prima sessione -> 100% resa")
	assert_approx_equal(Formulas.get_saturation_modifier(2), 0.70, 0.001, "Seconda sessione -> 70% resa")
	assert_approx_equal(Formulas.get_saturation_modifier(3), 0.40, 0.001, "Terza sessione -> 40% resa")
	assert_approx_equal(Formulas.get_saturation_modifier(10), 0.40, 0.001, "Decima sessione -> 40% resa")

func test_efficiency_factor() -> void:
	print("\n3. Verifica Freno Fisiologico (Stress & Morale):")
	var eff_nominal: float = Formulas.calculate_efficiency_factor(0.0, 100.0)
	assert_true(eff_nominal >= 0.95 and eff_nominal <= 1.30, "Condizioni ottimali -> Efficienza [0.95, 1.30]")
	
	var eff_exhausted: float = Formulas.calculate_efficiency_factor(100.0, 0.0)
	assert_true(eff_exhausted >= 0.20 and eff_exhausted <= 0.35, "Condizioni estreme di stress -> Efficienza compresa e frenata")

func test_training_xp() -> void:
	print("\n4. Verifica Guadagno XP Allenamento:")
	var xp_10s: float = Formulas.calculate_training_xp(10.0, 10.0, 1, 0.0, 50.0)
	assert_true(xp_10s >= 5.0 and xp_10s <= 15.0, "Allenamento base 10s -> Guadagno nominale corretto")
	
	var xp_60s: float = Formulas.calculate_training_xp(10.0, 60.0, 1, 0.0, 50.0)
	assert_true(xp_60s > xp_10s, "Allenamento prolungato (60s) -> Produce più XP di quello breve (10s)")

func test_song_quality() -> void:
	print("\n5. Verifica Qualità dei Brani Musicali (Quality Score):")
	var q_beginner: float = Formulas.calculate_song_quality(10.0, 10.0, 10.0, 10.0, 0.0, 50.0, 0.0)
	assert_true(q_beginner >= 1.0 and q_beginner <= 25.0, "Composizione principiante (Skill 10) -> Qualità bassa corretta")
	
	var q_master: float = Formulas.calculate_song_quality(100.0, 100.0, 100.0, 100.0, 20.0, 100.0, 0.0)
	assert_true(q_master >= 95.0 and q_master <= 100.0, "Composizione leggenda (Skill 100) -> Qualità al top")

func test_audience_calculation() -> void:
	print("\n6. Verifica Domanda e Affluenza Concerti:")
	var aud_nobody: int = Formulas.calculate_audience(100, 0.0, 0.0, 10.0, 10.0)
	assert_true(aud_nobody >= Constants.MIN_AUDIENCE_DEFAULT and aud_nobody <= 20, "Artista sconosciuto -> Presenza di pubblico minima garantita")
	
	var aud_star: int = Formulas.calculate_audience(500, 100.0, 100.0, 10.0, 10.0)
	assert_true(aud_star >= 400 and aud_star <= 500, "Superstar in locale prestigioso -> Sold-out o quasi")

func test_concert_score() -> void:
	print("\n7. Verifica Punteggio Esibizione Live:")
	var score_bad: float = Formulas.calculate_concert_score(10.0, 10.0, 10.0, 20.0, 0.0)
	assert_true(score_bad >= 1.0 and score_bad <= 25.0, "Show fiacco con poca energia -> Score basso")
	
	var score_epic: float = Formulas.calculate_concert_score(90.0, 90.0, 90.0, 100.0, 0.0)
	assert_true(score_epic >= 80.0 and score_epic <= 100.0, "Show leggendario a piena energia -> Score elevato")

func test_fan_conversion() -> void:
	print("\n8. Verifica Conversione Fan:")
	var fans_bad: int = Formulas.calculate_fan_conversion(50, 20.0, 10.0)
	assert_true(fans_bad <= 2, "Show deludente -> Pochissimi o nessun fan convertito")
	
	var fans_great: int = Formulas.calculate_fan_conversion(200, 90.0, 80.0)
	assert_true(fans_great >= 25, "Show trionfale con grande carisma -> Molti fan fidelizzati")

func test_edge_cases_and_robustness() -> void:
	print("\n9. Stress Test Casi Limite e Robustezza Invarianti:")
	# Livello zero o negativo non deve provocare crash
	assert_true(Formulas.calculate_xp_for_level(0) >= 50, "Livello 0 -> Safe fallback a 50 XP")
	assert_true(Formulas.calculate_xp_for_level(-5) >= 50, "Livello negativo -> Safe fallback a 50 XP")
	
	# Prezzo spropositato del biglietto
	var aud_overpriced: int = Formulas.calculate_audience(100, 50.0, 50.0, 1000.0, 10.0)
	assert_true(aud_overpriced >= Constants.MIN_AUDIENCE_DEFAULT, "Biglietto a 1000€ -> Nessun crash, minimo garantito")
	
	# Audience zero non deve produrre numeri negativi o crash
	assert_true(Formulas.calculate_fan_conversion(0, 100.0, 100.0) == 0, "Audience zero -> Zero fan senza crash")
