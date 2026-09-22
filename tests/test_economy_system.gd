# res://tests/test_economy_system.gd
extends Node

## Suite di Test Automatizzati per Economia, Carriera e Bilancio (Fase 5 / Vertical Slice V1.3)
## Copre: Velocità temporale (1x, 2x, 3x), Starter Pack 10 canzoni, Modulo Economico,
## Spese fisse e registro transazioni, Lavori ordinari e "Salto nel Vuoto",
## Progressione di Carriera e UI EconomyBank.

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST ECONOMIA, CARRIERA & RILASCIO (FASE 5)   ")
	print("========================================================\n")
	
	test_game_speed_controls()
	test_starter_test_songs_pack()
	test_fixed_expenses_and_financial_runway()
	test_transaction_logging()
	test_survival_jobs_and_the_leap()
	test_career_tier_progression()
	test_economy_bank_ui_instantiation()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST ECONOMIA & CARRIERA:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed > 0:
		print("[ERRORE CRITICO] Alcuni test di economia e carriera sono falliti!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Il sistema Economico e di Carriera è convalidato al 100%!")
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

# 1. Test Controllo Velocità di Gioco (1x, 2x, 3x)
func test_game_speed_controls() -> void:
	print("1. Verifica Controllo Velocità Temporale (1x, 2x, 3x):")
	var cal := CalendarData.new()
	var time_sys := TimeSystem.new(cal)
	
	assert_eq(time_sys.time_scale, 1.0, "Velocità iniziale = 1x")
	
	var s2: float = time_sys.cycle_speed()
	assert_eq(s2, 2.0, "cycle_speed passa da 1x a 2x")
	assert_eq(time_sys.time_scale, 2.0, "time_scale aggiornato a 2.0")
	
	var s3: float = time_sys.cycle_speed()
	assert_eq(s3, 3.0, "cycle_speed passa da 2x a 3x")
	assert_eq(time_sys.time_scale, 3.0, "time_scale aggiornato a 3.0")
	
	var s1: float = time_sys.cycle_speed()
	assert_eq(s1, 1.0, "cycle_speed ritorna a 1x")
	
	# Verifica avanzamento a 3x
	cal.remaining_seconds = 600.0
	time_sys.set_time_scale(3.0)
	time_sys.advance_time(10.0) # 10s * 3 = 30s consumati
	assert_eq(cal.remaining_seconds, 570.0, "A 3x, 10s consumano 30s virtuali (600 -> 570)")

# 2. Test Starter Pack 10 Canzoni
func test_starter_test_songs_pack() -> void:
	print("\n2. Verifica Starter Pack 10 Canzoni di Test:")
	var player := PlayerData.new()
	assert_eq(player.songs.size(), 0, "Inizialmente 0 canzoni")
	
	player.populate_starter_test_songs()
	assert_eq(player.songs.size(), 10, "Generati esattamente 10 brani di test")
	
	assert_eq(player.get_drafts().size(), 2, "2 bozze presenti")
	assert_eq(player.get_produced_songs().size(), 5, "5 brani pronti per i live presenti")
	assert_eq(player.get_released_singles().size(), 3, "3 singoli pubblicati presenti")
	assert_eq(player.get_playable_songs().size(), 8, "8 brani eseguibili in scaletta concerto (5 pronti + 3 rilasciati)")
	
	# Verifica presenza tratti speciali closer
	var has_stage_beast: bool = false
	var has_cult_classic: bool = false
	for s in player.songs:
		if s.special_trait == Enums.SongTrait.STAGE_BEAST:
			has_stage_beast = true
		if s.special_trait == Enums.SongTrait.CULT_CLASSIC:
			has_cult_classic = true
	assert_true(has_stage_beast, "Tratto STAGE_BEAST presente nei brani starter")
	assert_true(has_cult_classic, "Tratto CULT_CLASSIC presente nei brani starter")

# 3. Test Spese Fisse Quotidiane e Autonomia Finanziaria
func test_fixed_expenses_and_financial_runway() -> void:
	print("\n3. Verifica Spese Fisse Quotidiane e Autonomia:")
	var player := PlayerData.new()
	player.money = 250.0
	var cal := CalendarData.new()
	var econ := EconomySystem.new(player, cal)
	
	var expenses: Dictionary = econ.get_daily_fixed_expenses()
	assert_eq(expenses.food, 10.0, "Cibo giornaliero = 10.0 €")
	assert_eq(expenses.rent, 15.0, "Alloggio giornaliero = 15.0 €")
	assert_eq(expenses.total, 25.0, "Spese fisse totali = 25.0 € al giorno")
	
	var runway: float = econ.get_financial_runway_days()
	assert_eq(runway, 10.0, "Con 250 € e 25 €/giorno, autonomia = 10 giorni")
	
	player.money = 0.0
	assert_eq(econ.get_financial_runway_days(), 0.0, "Con 0 €, autonomia = 0 giorni")

# 4. Test Registro Transazioni
func test_transaction_logging() -> void:
	print("\n4. Verifica Registro Transazioni:")
	var player := PlayerData.new()
	var cal := CalendarData.new()
	cal.day_number = 3
	var econ := EconomySystem.new(player, cal)
	
	assert_eq(econ.transactions.size(), 0, "Registro inizialmente vuoto")
	
	econ.log_transaction(100.0, "live", "Incasso concerto pub")
	econ.log_transaction(-25.0, "rent", "Spese vive")
	
	assert_eq(econ.transactions.size(), 2, "2 transazioni registrate")
	var recent: Array[Dictionary] = econ.get_recent_transactions(5)
	assert_eq(recent.size(), 2, "get_recent_transactions restituisce 2 voci")
	assert_eq(recent[0].amount, -25.0, "Più recente è la spesa di 25 €")
	assert_eq(recent[0].day, 3, "Giorno della transazione = 3")

# 5. Test Lavori Ordinari e Meccanica "Salto nel Vuoto"
func test_survival_jobs_and_the_leap() -> void:
	print("\n5. Verifica Lavori Ordinari e Salto nel Vuoto:")
	var player := PlayerData.new()
	player.money = 100.0
	player.energy = 80
	var cal := CalendarData.new()
	var econ := EconomySystem.new(player, cal)
	
	var cur_job: Dictionary = econ.get_current_job()
	assert_eq(cur_job.id, "retail", "Lavoro di partenza è commesso part-time")
	assert_eq(cur_job.wage, 55.0, "Paga commesso = 55.0 €")
	
	# Esecuzione turno di lavoro
	var work_res: Dictionary = econ.perform_job_shift()
	assert_true(work_res.success, "Turno di lavoro svolto con successo")
	assert_eq(player.money, 155.0, "Saldo incrementato di 55 € (100 + 55 = 155)")
	assert_eq(player.energy, 60, "Energia scalata di 20 (80 - 20 = 60)")
	
	# Salto nel vuoto (Licenziamento)
	var resign_res: Dictionary = econ.resign_from_job()
	assert_true(resign_res.success, "Licenziamento avvenuto con successo")
	assert_eq(econ.current_job_id, "none", "Giocatore ora è musicista a tempo pieno")
	
	# Tentativo di lavorare da disoccupato
	var fail_work: Dictionary = econ.perform_job_shift()
	assert_eq(fail_work.success, false, "Impossibile lavorare da disoccupato")
	
	# Riassunzione
	var hired: bool = econ.accept_job("waiter")
	assert_true(hired, "Assunzione come cameriere riuscita")
	assert_eq(econ.current_job_id, "waiter", "Nuovo lavoro = waiter")

# 6. Test Progressione Carriera
func test_career_tier_progression() -> void:
	print("\n6. Verifica Progressione Carriera (CareerSystem):")
	var player := PlayerData.new()
	player.career_tier = Enums.CareerTier.BEDROOM_MUSICIAN
	player.fans = 15
	player.popularity = 3.0
	
	var career := CareerSystem.new(player)
	assert_eq(player.career_tier, Enums.CareerTier.BEDROOM_MUSICIAN, "Inizialmente BEDROOM_MUSICIAN")
	
	# Non soddisfa ancora i requisiti per BUSKER (richiede 50 fan, 5% pop, 1 singolo)
	var eval1: Dictionary = career.evaluate_career_progression()
	assert_eq(eval1.promoted, false, "Nessuna promozione senza requisiti")
	
	# Raggiunge i requisiti per BUSKER
	player.fans = 60
	player.popularity = 8.0
	var single := SongData.new("s1", "First Hit", Enums.MusicalGenre.ROCK)
	single.status = Enums.SongStatus.RELEASED
	player.songs.append(single)
	
	var eval2: Dictionary = career.evaluate_career_progression()
	assert_true(eval2.promoted, "Promosso a BUSKER")
	assert_eq(player.career_tier, Enums.CareerTier.BUSKER, "Nuovo status = BUSKER")
	assert_true(eval2.tier_name.length() > 0, "Nome tier valido")

# 7. Test Istanziazione UI EconomyBank
func test_economy_bank_ui_instantiation() -> void:
	print("\n7. Verifica Istanziazione Scena UI EconomyBank:")
	var bank_scene = load("res://ui/economy/economy_bank.tscn")
	assert_true(bank_scene != null, "Scena economy_bank.tscn caricata")
	
	var instance: Node = bank_scene.instantiate()
	assert_true(instance != null, "Istanza economy_bank creata")
	
	var backdrop: ColorRect = instance.get_node_or_null("Backdrop")
	var btn_work: Button = instance.get_node_or_null("PanelMain/VBox/JobContainer/HBoxJobButtons/BtnWorkShift")
	var btn_resign: Button = instance.get_node_or_null("PanelMain/VBox/JobContainer/HBoxJobButtons/BtnResign")
	var btn_close: Button = instance.get_node_or_null("PanelMain/VBox/HBoxBottom/BtnClose")
	
	assert_true(backdrop != null, "Backdrop full-screen presente")
	assert_true(btn_work != null, "BtnWorkShift presente")
	assert_true(btn_resign != null, "BtnResign presente")
	assert_true(btn_close != null, "BtnClose presente")
	
	instance.queue_free()
