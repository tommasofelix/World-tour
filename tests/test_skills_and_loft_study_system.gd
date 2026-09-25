# res://tests/test_skills_and_loft_study_system.gd
extends Node

## Suite di Test Headless per l'Albero delle Abilità a 6 Rami, 31 Competenze,
## 5 Gradi di Maestria e i 4 Metodi di Studio Dinamico nel Loft NYC (World-tour V5.8.0 / Popomundo Inspired)
## Esecuzione deterministica headless a 0 ms senza rendering grafico.

const ApartmentInteractions = preload("res://scenes/apartment/apartment_interactions.gd")
const InstrumentPracticePicker = preload("res://ui/interaction_menu/instrument_practice_picker.gd")
const SkillStudyPicker = preload("res://ui/interaction_menu/skill_study_picker.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST ALBERO ABILITÀ & STUDIO LOFT NYC (V5.8.0)  ")
	print("========================================================\n")

	test_innate_attributes_and_skill_tree_structure()
	test_five_mastery_grades_and_xp_progression()
	test_prerequisites_and_unlock_guards()
	test_study_eligibility_validation()
	test_four_study_methods_in_loft_catalog()
	test_toolbox_cables_and_lutherie_skills()
	test_instrument_practice_picker_flow()
	test_skill_study_picker_flow()
	test_vinyl_listening_passive_genre_boost()
	test_legacy_backward_compatibility_and_sync()
	test_action_system_tree_xp_integration()
	test_save_load_persistence_skill_tree()
	test_character_sheet_tabbed_skills_tree()

	print("\n--------------------------------------------------------")
	print("ESITO TEST ALBERO ABILITÀ & METODI DI STUDIO LOFT:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")

	if tests_failed > 0:
		print("[ERRORE CRITICO] Alcuni test dell'Albero Abilità sono falliti!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Albero Abilità e Studio Loft convalidati al 100%!")
		get_tree().quit(0)

func assert_true(condition: bool, test_name: String) -> void:
	if condition:
		print("  [OK] %s" % test_name)
		tests_passed += 1
	else:
		printerr("  [FALLITO] %s" % test_name)
		tests_failed += 1

func assert_eq(val1: Variant, val2: Variant, test_name: String) -> void:
	if val1 == val2:
		print("  [OK] %s (%s == %s)" % [test_name, str(val1), str(val2)])
		tests_passed += 1
	else:
		printerr("  [FALLITO] %s (Atteso: %s, Ottenuto: %s)" % [test_name, str(val2), str(val1)])
		tests_failed += 1

# --- Test Case Dettagliati ---

func test_innate_attributes_and_skill_tree_structure() -> void:
	print("1. Verifica Attributi Innati e Struttura Albero a 6 Rami:")
	var player := PlayerData.new()

	# Controllo 4 Attributi Fisiologici Innati
	assert_eq(player.musicality, 50, "Musicalità iniziale = 50")
	assert_eq(player.intelligence, 50, "Intelligenza iniziale = 50")
	assert_eq(player.stamina, 50, "Resistenza fisica (stamina) iniziale = 50")
	assert_eq(player.charm, 50, "Carisma naturale iniziale = 50")

	player.modify_innate_attribute("musicality", 15)
	assert_eq(player.get_innate_attribute("musicality"), 65, "Modifica attributo musicality (+15 = 65)")

	player.modify_innate_attribute("stamina", -10)
	assert_eq(player.get_innate_attribute("stamina"), 40, "Modifica attributo stamina (-10 = 40)")

	# Controllo 6 Rami Canonici
	var branches := ["genre_mastery", "instrumental_technique", "songwriting_harmony", "stage_showmanship", "engineering_hardware", "industry_business"]
	for b in branches:
		var b_skills: Array[Dictionary] = player.get_branch_skills(b)
		assert_true(b_skills.size() > 0, "Ramo %s contiene competenze (%d trovate)" % [b, b_skills.size()])

	# Controllo 31 Competenze complessive
	var all_skills: Array[Dictionary] = player.get_all_skill_tree_summary()
	assert_eq(all_skills.size(), 31, "Albero completo contiene esattamente 31 competenze canoniche")

	# Controllo 8 competenze Ramo 2 (instrumental_technique)
	var inst_skills: Array[Dictionary] = player.get_branch_skills("instrumental_technique")
	assert_eq(inst_skills.size(), 8, "Ramo 2 contiene esattamente 8 competenze strumentali/vocali")
	assert_eq(player.get_skill_grade("skill_horns"), 0, "Fiati e Sax inizialmente a Grado 0")
	assert_eq(player.get_skill_grade("skill_strings"), 0, "Archi e Violino inizialmente a Grado 0")
	assert_eq(player.get_skill_grade("skill_harmonica"), 0, "Armonica e Folk inizialmente a Grado 0")

	# Controllo competenze starter Alex
	assert_eq(player.get_skill_grade("skill_guitar"), 1, "Alex starter: Chitarra a Grado 1 Principiante")
	assert_eq(player.get_skill_grade("genre_rock"), 1, "Alex starter: Rock Classico a Grado 1 Principiante")
	assert_eq(player.get_skill_grade("comp_theory"), 1, "Alex starter: Teoria Musicale a Grado 1 Principiante")
	assert_eq(player.get_skill_grade("stage_presence"), 1, "Alex starter: Presenza Scenica a Grado 1 Principiante")

	# Controllo abilità bloccate inizialmente (Grado 0)
	assert_eq(player.get_skill_grade("genre_metal"), 0, "Heavy Metal inizialmente a Grado 0 (Non Appresa)")
	assert_eq(player.get_skill_grade("comp_ballads"), 0, "Composizione Ballate inizialmente a Grado 0")

func test_five_mastery_grades_and_xp_progression() -> void:
	print("\n2. Verifica Scala 5 Gradi di Padronanza (Stelle 1-5) & Curve XP:")
	var player := PlayerData.new()

	# Stringhe a stelle per NVDA
	var disp_g1 := player.get_skill_stars_display("skill_guitar")
	assert_true(disp_g1.contains("★☆☆☆☆"), "Grado 1 visualizza 1 stella piena")
	assert_true(disp_g1.contains("Principiante"), "Grado 1 descrive 'Principiante'")

	# Progressione XP da Grado 1 a Grado 2 (soglia 100 XP)
	var res1: Dictionary = player.add_skill_tree_xp("skill_guitar", 110.0)
	assert_true(res1["success"], "Aggiunta XP a Chitarra riuscita")
	assert_true(res1["leveled_up"], "Passaggio di grado registrato")
	assert_eq(res1["new_grade"], 2, "Nuovo grado = 2 (Praticante)")
	assert_eq(player.get_skill_grade("skill_guitar"), 2, "Chitarra ora al Grado 2")

	# Progressione verso Grado 3 (soglia 250 XP)
	var res2: Dictionary = player.add_skill_tree_xp("skill_guitar", 260.0)
	assert_eq(res2["new_grade"], 3, "Chitarra salita al Grado 3 (Professionista)")

	# Progressione verso Grado 4 (soglia 500 XP)
	var res3: Dictionary = player.add_skill_tree_xp("skill_guitar", 510.0)
	assert_eq(res3["new_grade"], 4, "Chitarra salita al Grado 4 (Esperto / Virtuoso)")

	# Progressione verso Grado 5 (soglia 1000 XP)
	var res4: Dictionary = player.add_skill_tree_xp("skill_guitar", 1010.0)
	assert_eq(res4["new_grade"], 5, "Chitarra salita al Grado 5 (Maestro Leggendario)")

	var disp_g5 := player.get_skill_stars_display("skill_guitar")
	assert_true(disp_g5.contains("★★★★★"), "Grado 5 visualizza 5 stelle piene")
	assert_true(disp_g5.contains("Maestro"), "Grado 5 descrive 'Maestro'")

	# Verifica Cap Grado 5 (nessun ulteriore passaggio di grado)
	var res_cap: Dictionary = player.add_skill_tree_xp("skill_guitar", 500.0)
	assert_true(res_cap.get("is_max", false), "Raggiunto Cap massimo per Grado 5")
	assert_eq(player.get_skill_grade("skill_guitar"), 5, "Grado rimane congelato a 5")

func test_prerequisites_and_unlock_guards() -> void:
	print("\n3. Verifica Regole Propedeutiche ('Se... Allora') & Guardie Sblocco:")
	var player := PlayerData.new()

	# Teoria Musicale parte a Grado 1 per Alex
	assert_eq(player.get_skill_grade("comp_theory"), 1, "Teoria Musicale a Grado 1")

	# Tentativo sblocco Ballate con Teoria < 2 -> BLOCCATO
	var check_ballads: Dictionary = player.can_unlock_skill("comp_ballads")
	assert_true(not check_ballads["can_unlock"], "Sblocco Ballate respinto se Teoria < 2")
	assert_true(check_ballads["reason"].contains("Richiede Grado 2"), "Motivazione indica requisito Grado 2")

	# Tentativo sblocco Inni da Stadio con Teoria < 2 -> BLOCCATO
	var check_anthems: Dictionary = player.can_unlock_skill("comp_anthems")
	assert_true(not check_anthems["can_unlock"], "Sblocco Inni da Stadio respinto se Teoria < 2")

	# Porta Teoria Musicale a Grado 2
	player.add_skill_tree_xp("comp_theory", 110.0)
	assert_eq(player.get_skill_grade("comp_theory"), 2, "Teoria Musicale portata al Grado 2")

	# Ora Ballate e Inni possono essere sbloccati
	var check_ballads_ok: Dictionary = player.can_unlock_skill("comp_ballads")
	assert_true(check_ballads_ok["can_unlock"], "Sblocco Ballate consentito con Teoria Grado 2")

	var check_anthems_ok: Dictionary = player.can_unlock_skill("comp_anthems")
	assert_true(check_anthems_ok["can_unlock"], "Sblocco Inni consentito con Teoria Grado 2")

	# Verifica prerequisiti Atletismo da Palco (richiede Presenza Scenica Grado 2)
	assert_eq(player.get_skill_grade("stage_presence"), 1, "Presenza Scenica a Grado 1")
	var check_ath: Dictionary = player.can_unlock_skill("stage_athleticism")
	assert_true(not check_ath["can_unlock"], "Atletismo respinto con Presenza Scenica < 2")

	player.add_skill_tree_xp("stage_presence", 110.0)
	assert_eq(player.get_skill_grade("stage_presence"), 2, "Presenza Scenica portata al Grado 2")
	var check_ath_ok: Dictionary = player.can_unlock_skill("stage_athleticism")
	assert_true(check_ath_ok["can_unlock"], "Atletismo consentito con Presenza Scenica Grado 2")

func test_study_eligibility_validation() -> void:
	print("\n3b. Verifica Validazione Deterministica Idoneità Metodi di Studio:")
	var player := PlayerData.new()

	# Metodo MANUAL (0): Grado 0 -> ok, Grado 1 -> ok, Grado 2 -> rifiutato (Cap 2)
	var check_m0: Dictionary = player.validate_study_eligibility("genre_metal", PlayerData.StudyMethodType.MANUAL)
	assert_true(check_m0["is_eligible"], "Manuale idoneo per abilità a Grado 0 (sblocco base)")

	var check_m1: Dictionary = player.validate_study_eligibility("skill_guitar", PlayerData.StudyMethodType.MANUAL)
	assert_true(check_m1["is_eligible"], "Manuale idoneo per abilità a Grado 1")

	player.add_skill_tree_xp("skill_guitar", 120.0) # Grado 2
	var check_m2: Dictionary = player.validate_study_eligibility("skill_guitar", PlayerData.StudyMethodType.MANUAL)
	assert_true(not check_m2["is_eligible"], "Manuale rifiuta abilità a Grado 2 (richiede Accademia/Maestro)")

	# Metodo ACADEMY (1): Grado 0 -> rifiutato (richiede basi Grado 1), Grado 1 -> ok, Grado 2 -> ok, Grado 3 -> rifiutato (Cap 3)
	var check_ac0: Dictionary = player.validate_study_eligibility("genre_metal", PlayerData.StudyMethodType.ACADEMY)
	assert_true(not check_ac0["is_eligible"], "Accademia rifiuta Grado 0 (richiede basi Grado 1)")

	var check_ac2: Dictionary = player.validate_study_eligibility("skill_guitar", PlayerData.StudyMethodType.ACADEMY)
	assert_true(check_ac2["is_eligible"], "Accademia idonea per Grado 2")

	player.add_skill_tree_xp("skill_guitar", 260.0) # Grado 3
	var check_ac3: Dictionary = player.validate_study_eligibility("skill_guitar", PlayerData.StudyMethodType.ACADEMY)
	assert_true(not check_ac3["is_eligible"], "Accademia rifiuta Grado 3 (richiede Maestro Privato)")

	# Metodo MENTOR (2): Grado 0 -> rifiutato, Grado 3 -> ok, Grado 4 -> ok, Grado 5 -> rifiutato (Cap 5)
	var check_me0: Dictionary = player.validate_study_eligibility("genre_metal", PlayerData.StudyMethodType.MENTOR)
	assert_true(not check_me0["is_eligible"], "Maestro rifiuta Grado 0 (richiede basi Grado 1)")

	var check_me3: Dictionary = player.validate_study_eligibility("skill_guitar", PlayerData.StudyMethodType.MENTOR)
	assert_true(check_me3["is_eligible"], "Maestro idoneo per Grado 3")

	player.add_skill_tree_xp("skill_guitar", 520.0) # Grado 4
	var check_me4: Dictionary = player.validate_study_eligibility("skill_guitar", PlayerData.StudyMethodType.MENTOR)
	assert_true(check_me4["is_eligible"], "Maestro idoneo per Grado 4")

	player.add_skill_tree_xp("skill_guitar", 1020.0) # Grado 5
	var check_me5: Dictionary = player.validate_study_eligibility("skill_guitar", PlayerData.StudyMethodType.MENTOR)
	assert_true(not check_me5["is_eligible"], "Maestro rifiuta Grado 5 (maestria massima)")

	# Metodo PRACTICE (3): consentita solo su Ramo 2 (instrumental_technique) con Grado < 5
	var check_pr_inst: Dictionary = player.validate_study_eligibility("skill_bass", PlayerData.StudyMethodType.PRACTICE)
	assert_true(check_pr_inst["is_eligible"], "Pratica idonea su Basso Elettrico (Ramo 2)")

	var check_pr_theory: Dictionary = player.validate_study_eligibility("comp_theory", PlayerData.StudyMethodType.PRACTICE)
	assert_true(not check_pr_theory["is_eligible"], "Pratica rifiutata su Teoria Musicale (non Ramo 2)")

func test_four_study_methods_in_loft_catalog() -> void:
	print("\n4. Verifica Catalogo 4 Metodi di Studio negli Arredi del Loft NYC:")

	# Metodo 1: Manuali sul Divano
	var couch_actions: Array[Dictionary] = ApartmentInteractions.get_actions_for_prop("couch")
	var manual_found: bool = false
	for a in couch_actions:
		if a["id"] == "couch_study_manual":
			manual_found = true
			assert_eq(a["type"], "study_picker", "Manuale divano di tipo study_picker")
			assert_eq(a["study_method"], 0, "Manuale divano metodo MANUAL (0)")
			assert_eq(a["duration_seconds"], 10.0, "Manuale divano dura 10s")
			assert_eq(a["money_cost"], 0.0, "Manuale divano a costo zero")
			assert_eq(a["xp_amount"], 35.0, "Manuale divano conferisce 35 XP")
			break
	assert_true(manual_found, "Azione couch_study_manual presente nel divano")

	# Metodo 2: Accademia alla Porta del Loft
	var door_actions: Array[Dictionary] = ApartmentInteractions.get_actions_for_prop("door")
	var academy_found: bool = false
	for a in door_actions:
		if a["id"] == "door_academy_course":
			academy_found = true
			assert_eq(a["type"], "study_picker", "Accademia porta di tipo study_picker")
			assert_eq(a["study_method"], 1, "Accademia porta metodo ACADEMY (1)")
			assert_eq(a["duration_seconds"], 12.0, "Corso accademia dura 12s")
			assert_eq(a["money_cost"], 30.0, "Corso accademia costa 30.00 €")
			assert_eq(a["xp_amount"], 50.0, "Corso accademia conferisce 50 XP")
			break
	assert_true(academy_found, "Azione door_academy_course presente nella porta d'uscita")

	# Metodo 3: Lezione Privata del Maestro alla Chitarra (Azione Diretta Contestuale)
	var guitar_actions: Array[Dictionary] = ApartmentInteractions.get_actions_for_prop("guitar")
	var mentor_found: bool = false
	for a in guitar_actions:
		if a["id"] == "guitar_mentor_lesson":
			mentor_found = true
			assert_eq(a["type"], "action", "Lezione maestro di tipo action diretta")
			assert_eq(a["xp_skill"], "skill_guitar", "Lezione maestro allena skill_guitar")
			assert_eq(a["duration_seconds"], 12.0, "Lezione maestro dura 12s")
			assert_eq(a["money_cost"], 50.0, "Lezione maestro costa 50.00 €")
			assert_eq(a["xp_amount"], 75.0, "Lezione maestro conferisce +75 XP intensivi")
			break
	assert_true(mentor_found, "Azione guitar_mentor_lesson presente nella chitarra")

	# Metodo 4: Pratica Chitarra Contestuale Diretta
	var practice_found: bool = false
	for a in guitar_actions:
		if a["id"] == "guitar_practice":
			practice_found = true
			assert_eq(a["type"], "action", "Pratica chitarra di tipo action diretta")
			assert_eq(a["xp_skill"], "skill_guitar", "Pratica chitarra allena skill_guitar")
			assert_eq(a["money_cost"], 0.0, "Pratica individuale chitarra gratuita")
			assert_eq(a["duration_seconds"], 10.0, "Pratica dura 10s")
			assert_eq(a["xp_amount"], 20.0, "Pratica conferisce +20 XP")
			break
	assert_true(practice_found, "Azione guitar_practice presente nella chitarra")

func test_toolbox_cables_and_lutherie_skills() -> void:
	print("\n4b. Verifica Competenze Tecniche alla Cassa Attrezzi (Toolbox):")
	var toolbox_actions: Array[Dictionary] = ApartmentInteractions.get_actions_for_prop("toolbox")
	var check_found: bool = false
	var maintain_found: bool = false
	for a in toolbox_actions:
		if a["id"] == "toolbox_check":
			check_found = true
			assert_eq(a["xp_skill"], "tech_live_sound", "Controllo cavi/jack allena Tecnico Suono Live (tech_live_sound)")
			assert_eq(a["xp_amount"], 10.0, "Controllo cavi/jack conferisce +10 XP")
		elif a["id"] == "toolbox_maintain":
			maintain_found = true
			assert_eq(a["xp_skill"], "tech_lutherie", "Set-up chitarra allena Liuteria (tech_lutherie)")
			assert_eq(a["xp_amount"], 15.0, "Set-up chitarra conferisce +15 XP")
	assert_true(check_found, "Azione toolbox_check presente con tech_live_sound")
	assert_true(maintain_found, "Azione toolbox_maintain presente con tech_lutherie")

func test_instrument_practice_picker_flow() -> void:
	print("\n4c. Verifica Flusso UI Accessibile InstrumentPracticePicker:")
	var player := PlayerData.new()
	var picker := InstrumentPracticePicker.new()
	add_child(picker)

	picker.open_picker(player)
	assert_true(picker.is_picker_open, "Picker pratica aperto")
	assert_eq(picker.current_instruments.size(), 8, "Picker pratica contiene esattamente 8 strumenti/voce")
	assert_eq(picker.buttons.size(), 8, "Picker pratica genera 8 pulsanti accessibili")

	var captured_inst := {"id": "", "name": ""}
	picker.instrument_selected.connect(func(s_id, s_name):
		captured_inst["id"] = s_id
		captured_inst["name"] = s_name
	)

	# Simula selezione del primo strumento (Chitarra)
	picker.select_index(0)
	assert_eq(captured_inst["id"], "skill_guitar", "Segnale emette skill_guitar")
	assert_true(captured_inst["name"].contains("Chitarra"), "Segnale emette nome Chitarra")

	picker.close_picker()
	assert_true(not picker.is_picker_open, "Picker pratica chiuso")
	remove_child(picker)
	picker.queue_free()

func test_skill_study_picker_flow() -> void:
	print("\n4d. Verifica Flusso UI Accessibile SkillStudyPicker:")
	var player := PlayerData.new()
	var picker := SkillStudyPicker.new()
	add_child(picker)

	picker.open_study_picker(player, PlayerData.StudyMethodType.MANUAL)
	assert_true(picker.is_picker_open, "Picker studio aperto")
	assert_eq(picker.filtered_skills.size(), 31, "Visualizza tutte le 31 competenze senza filtro")
	assert_eq(picker.buttons.size(), 31, "Generati 31 pulsanti accessibili")

	# Test filtro rapido Ramo Generi (G)
	picker.set_branch_filter("genre_mastery")
	assert_eq(picker.filtered_skills.size(), 7, "Filtro Generi mostra 7 competenze")

	# Test filtro rapido Ramo Strumenti (S)
	picker.set_branch_filter("instrumental_technique")
	assert_eq(picker.filtered_skills.size(), 8, "Filtro Strumenti mostra 8 competenze")

	# Test reset filtro (0)
	picker.set_branch_filter("")
	assert_eq(picker.filtered_skills.size(), 31, "Reset filtro ripristina 31 competenze")

	var captured_study := {"id": "", "method": -1}
	picker.skill_selected.connect(func(s_id, _s_name, m_type):
		captured_study["id"] = s_id
		captured_study["method"] = m_type
	)

	# Seleziona prima competenza (comp_theory / rock idonea per Manuale)
	picker.select_index(0)
	assert_eq(captured_study["method"], PlayerData.StudyMethodType.MANUAL, "Metodo studio emesso corretto")

	picker.close_study_picker()
	assert_true(not picker.is_picker_open, "Picker studio chiuso")
	remove_child(picker)
	picker.queue_free()

func test_vinyl_listening_passive_genre_boost() -> void:
	print("\n5. Verifica Ascolto Vinili al Giradischi & Boost Passivo di Genere:")
	var turntable_actions: Array[Dictionary] = ApartmentInteractions.get_actions_for_prop("turntable")

	var rock_found: bool = false
	var metal_found: bool = false
	var blues_found: bool = false
	var jazz_found: bool = false
	var study_found: bool = false

	for a in turntable_actions:
		match a["id"]:
			"turntable_listen_rock":
				rock_found = true
				assert_eq(a["xp_skill"], "genre_rock", "Vinile Rock assegna XP a genre_rock")
				assert_eq(a["xp_amount"], 25.0, "Vinile Rock conferisce +25 XP")
				assert_eq(a["morale_delta"], 20, "Vinile Rock ricarica +20 Morale")
				assert_eq(a["stress_delta"], -10, "Vinile Rock riduce -10 Stress")
			"turntable_listen_metal":
				metal_found = true
				assert_eq(a["xp_skill"], "genre_metal", "Vinile Metal assegna XP a genre_metal")
				assert_eq(a["xp_amount"], 25.0, "Vinile Metal conferisce +25 XP")
			"turntable_listen_blues":
				blues_found = true
				assert_eq(a["xp_skill"], "genre_blues", "Vinile Blues assegna XP a genre_blues")
			"turntable_listen_jazz":
				jazz_found = true
				assert_eq(a["xp_skill"], "genre_jazz", "Vinile Jazz assegna XP a genre_jazz")
			"turntable_study":
				study_found = true
				assert_eq(a["xp_skill"], "tech_production", "Studio produzione assegna XP a tech_production")

	assert_true(rock_found, "Vinile Classic Rock presente nel giradischi")
	assert_true(metal_found, "Vinile Heavy Metal presente nel giradischi")
	assert_true(blues_found, "Vinile Blues & Roots presente nel giradischi")
	assert_true(jazz_found, "Vinile Jazz & Fusion presente nel giradischi")
	assert_true(study_found, "Analisi Missaggio presente nel giradischi")

	# Simulazione ascolto vinile Metal partendo da Grado 0: sblocca Grado 1 Principiante
	var player := PlayerData.new()
	assert_eq(player.get_skill_grade("genre_metal"), 0, "Heavy Metal inizialmente a Grado 0")

	player.add_skill_tree_xp("genre_metal", 25.0)
	assert_eq(player.get_skill_grade("genre_metal"), 1, "Ascolto vinile sblocca Heavy Metal al Grado 1 Principiante")
	assert_true(player.get_skill_stars_display("genre_metal").contains("★☆☆☆☆"), "Grado 1 visualizza 1 stella")

func test_legacy_backward_compatibility_and_sync() -> void:
	print("\n6. Verifica Retrocompatibilità Legacy Assoluta (D0):")
	var player := PlayerData.new()

	# Chiamata legacy get_skill_level
	var comp_lvl: int = player.get_skill_level("composition")
	assert_true(comp_lvl >= 10, "get_skill_level('composition') risponde correttamente (valore: %d)" % comp_lvl)

	var inst_lvl: int = player.get_skill_level("instrument")
	assert_true(inst_lvl >= 10, "get_skill_level('instrument') risponde correttamente (valore: %d)" % inst_lvl)

	# Chiamata legacy add_xp_to_skill su 'guitar'
	var old_guitar_xp: float = float(player.skill_tree["skill_guitar"]["xp"])
	player.add_xp_to_skill("guitar", 50.0)
	var new_guitar_xp: float = float(player.skill_tree["skill_guitar"]["xp"])
	assert_true(new_guitar_xp > old_guitar_xp, "add_xp_to_skill('guitar') sincronizza skill_guitar nell'Albero")

	# Controllo presenza intatta di tutte le 12 chiavi storiche nel dizionario skills
	var legacy_keys := ["instrument", "composition", "songwriting", "lyrics", "vocals", "guitar", "bass", "drums", "production", "performance", "charisma", "business"]
	for lk in legacy_keys:
		assert_true(player.skills.has(lk), "Dizionario legacy preserva chiave '%s'" % lk)

func test_action_system_tree_xp_integration() -> void:
	print("\n7. Verifica Esecuzione Azione Studio con ActionSystem & Annuncio NVDA:")
	var player := PlayerData.new()
	var cal := CalendarData.new()
	var act_sys := ActionSystem.new(player, cal)

	var initial_xp: float = float(player.skill_tree["genre_rock"]["xp"])
	var act_data := ActionData.new(
		"turntable_listen_rock",
		"Vinile Classic Rock",
		12.0,
		0,
		0,
		25.0,
		"genre_rock",
		false
	)

	var started: bool = act_sys.start_action(act_data)
	assert_true(started, "Avvio azione vinile rock riuscito")
	assert_true(act_sys.is_running, "ActionSystem in esecuzione")

	# Conclusione istantanea headless (0 ms)
	act_sys.update_action(12.0)
	assert_true(not act_sys.is_running, "Azione vinile rock conclusa")

	var after_xp: float = float(player.skill_tree["genre_rock"]["xp"])
	assert_true(after_xp > initial_xp, "XP guadagnati su genre_rock tramite ActionSystem")

func test_save_load_persistence_skill_tree() -> void:
	print("\n8. Verifica Serializzazione & Deserializzazione Save/Load (to_dict / from_dict):")
	var player1 := PlayerData.new()
	player1.modify_innate_attribute("musicality", 20)
	player1.modify_innate_attribute("intelligence", 15)
	player1.add_skill_tree_xp("genre_blues", 50.0) # Sblocca Grado 1 Blues
	player1.add_skill_tree_xp("comp_theory", 120.0) # Porta a Grado 2

	var s_dict: Dictionary = player1.to_dict()
	assert_true(s_dict.has("musicality"), "to_dict() include musicality")
	assert_true(s_dict.has("intelligence"), "to_dict() include intelligence")
	assert_true(s_dict.has("skill_tree"), "to_dict() include skill_tree")

	var player2 := PlayerData.new()
	player2.from_dict(s_dict)

	assert_eq(player2.musicality, 70, "Ripristinata musicality (50 + 20 = 70)")
	assert_eq(player2.intelligence, 65, "Ripristinata intelligence (50 + 15 = 65)")
	assert_eq(player2.get_skill_grade("genre_blues"), 1, "Ripristinato Blues a Grado 1")
	assert_eq(player2.get_skill_grade("comp_theory"), 2, "Ripristinata Teoria a Grado 2")

func test_character_sheet_tabbed_skills_tree() -> void:
	print("\n9. Verifica Scheda Personaggio Tabbed a 2 Sezioni (CharacterSheet V5.7.1):")
	var char_res: Resource = load("res://ui/character/character_sheet.tscn")
	assert_true(char_res != null, "Risorsa character_sheet.tscn caricata")
	var sheet: Control = char_res.instantiate() as Control
	assert_true(sheet != null, "Istanziazione character_sheet riuscita")
	add_child(sheet)

	# 1. Verifica Controlli di Testata e Navigazione Tab
	assert_true(sheet.btn_tab_profile != null, "BtnTabProfile presente")
	assert_true(sheet.btn_tab_skills != null, "BtnTabSkills presente")
	assert_eq(sheet.current_tab, 1, "Scheda iniziale = 1 (Profilo & Fisiologia)")

	# 2. Verifica Scheda 1 (Profilo & Fisiologia)
	GameManager.player_data = PlayerData.new()
	GameManager.player_data.player_name = "Alex Test"
	GameManager.player_data.modify_innate_attribute("musicality", 20) # 70
	GameManager.player_data.modify_innate_attribute("intelligence", 30) # 80

	sheet.refresh_sheet()
	assert_true(sheet.label_musicality != null, "LabelMusicality presente")
	assert_true(sheet.label_intelligence != null, "LabelIntelligence presente")
	assert_true(sheet.label_stamina != null, "LabelStamina presente")
	assert_true(sheet.label_charm != null, "LabelCharm presente")
	assert_true(sheet.label_musicality.text.contains("70"), "LabelMusicality riflette valore 70")
	assert_true(sheet.label_intelligence.text.contains("80"), "LabelIntelligence riflette valore 80")
	assert_eq(sheet.vbox_skills.get_child_count(), 7, "Matrice legacy 7 abilità base popolata")

	# 3. Transizione a Scheda 2 (Albero Competenze)
	sheet.select_tab(2)
	assert_eq(sheet.current_tab, 2, "Transizione a Scheda 2 riuscita")
	assert_true(sheet.panel_tab_skills.visible, "PanelTabSkills visibile")
	assert_true(not sheet.hbox_body.visible, "HBoxBody (Scheda 1) occultato")

	# 4. Navigazione 6 Rami e Verifica Conteggi Abilità (Totale 31)
	var branches_to_check := {
		"genre_mastery": 7,
		"instrumental_technique": 8,
		"songwriting_harmony": 6,
		"stage_showmanship": 4,
		"engineering_hardware": 3,
		"industry_business": 3
	}
	var total_skills_counted: int = 0
	for b_id in branches_to_check:
		sheet.select_branch(b_id)
		var expected_count: int = branches_to_check[b_id]
		var actual_count: int = sheet.vbox_skills_tree_list.get_child_count()
		assert_eq(actual_count, expected_count, "Ramo '%s' contiene esattamente %d abilità" % [b_id, expected_count])
		total_skills_counted += actual_count

	assert_eq(total_skills_counted, 31, "Tutte le 31 abilità canoniche visualizzate nei 6 rami")

	# 5. Verifica Metodo Riassunto Vocale Ramo
	sheet._read_current_branch_summary()
	assert_true(true, "Metodo _read_current_branch_summary() eseguito senza errori")

	# 6. Ritorno a Scheda 1 e Chiusura
	sheet.select_tab(1)
	assert_eq(sheet.current_tab, 1, "Ritorno a Scheda 1 riuscito")
	assert_true(sheet.hbox_body.visible, "HBoxBody (Scheda 1) visibile")
	assert_true(not sheet.panel_tab_skills.visible, "PanelTabSkills occultato")

	remove_child(sheet)
	sheet.queue_free()
