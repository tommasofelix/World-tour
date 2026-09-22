# res://ui/economy/economy_bank.gd
extends Control

## Controller dell'Ufficio Finanziario, Bilancio e Lavoro di World-tour
## Permette la consultazione del saldo, spese fisse, autonomia residua,
## gestione del lavoro di sussistenza e consultazione delle ultime transazioni.
## Completamente accessibile con NVDA e con interfaccia ad alto contrasto per monitor.

signal closed()

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var label_balance: Label = $PanelMain/VBox/OverviewContainer/LabelBalance
@onready var label_runway: Label = $PanelMain/VBox/OverviewContainer/LabelRunway
@onready var label_status: Label = $PanelMain/VBox/OverviewContainer/LabelStatus
@onready var label_housing: Label = $PanelMain/VBox/OverviewContainer/HBoxHousing/LabelHousing
@onready var opt_housing: OptionButton = $PanelMain/VBox/OverviewContainer/HBoxHousing/OptHousing
@onready var btn_change_housing: Button = $PanelMain/VBox/OverviewContainer/HBoxHousing/BtnChangeHousing

@onready var label_job_header: Label = $PanelMain/VBox/JobContainer/LabelJobHeader
@onready var label_job_desc: Label = $PanelMain/VBox/JobContainer/LabelJobDesc
@onready var btn_work_shift: Button = $PanelMain/VBox/JobContainer/HBoxJobButtons/BtnWorkShift
@onready var btn_resign: Button = $PanelMain/VBox/JobContainer/HBoxJobButtons/BtnResign

@onready var vbox_transactions: VBoxContainer = $PanelMain/VBox/HistoryContainer/ScrollHistory/VBoxTransactions
@onready var btn_close: Button = $PanelMain/VBox/HBoxBottom/BtnClose

func _ready() -> void:
	btn_work_shift.pressed.connect(_on_work_shift_pressed)
	btn_resign.pressed.connect(_on_resign_pressed)
	btn_close.pressed.connect(close)
	if btn_change_housing:
		btn_change_housing.pressed.connect(_on_change_housing_pressed)
	_populate_housing_dropdown()
	
	EventBus.language_changed.connect(func(_l): _refresh_ui_text())
	EventBus.money_changed.connect(func(_b, _d, _r): refresh_view())
	EventBus.housing_changed.connect(func(_t, _r): refresh_view())
	
	_setup_accessibility_hooks()
	_refresh_ui_text()

func _setup_accessibility_hooks() -> void:
	AccessibilityManager.hook_control_accessibility(btn_work_shift, tr("BANK_BTN_WORK"), "Consuma energia ed effettua un turno di lavoro per incassare lo stipendio.")
	AccessibilityManager.hook_control_accessibility(btn_resign, tr("BANK_BTN_RESIGN"), "Licenziati dal lavoro ordinario per dedicarti esclusivamente alla musica a tempo pieno.")
	AccessibilityManager.hook_control_accessibility(btn_close, tr("BANK_BTN_CLOSE"), "Chiude la schermata economica e ritorna all'HUD di gioco.")
	if opt_housing:
		AccessibilityManager.hook_control_accessibility(opt_housing, "Scelta nuova residenza", "Seleziona tra Stanzetta, Appartamento condiviso con la Band, Loft con sala prove o Villa.")
	if btn_change_housing:
		AccessibilityManager.hook_control_accessibility(btn_change_housing, "Trasloca", "Conferma il cambio di alloggio e aggiorna il canone di affitto.")

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_B:
			close()
			get_viewport().set_input_as_handled()

func open() -> void:
	visible = true
	refresh_view()
	
	# Annuncio vocale sintetico per NVDA
	var bal: float = GameManager.player_data.money if GameManager and GameManager.player_data else 0.0
	var runway: float = GameManager.economy_system.get_financial_runway_days() if GameManager and GameManager.economy_system else 0.0
	var st_name: String = GameManager.career_system.get_tier_name(GameManager.player_data.career_tier) if GameManager and GameManager.career_system and GameManager.player_data else "Beginner"
	var speech: String = "Ufficio Finanziario aperto. Saldo attuale: %.2f euro. Autonomia stimata: %.1f giorni. Status carriera: %s." % [bal, runway, st_name]
	AccessibilityManager.announce(speech, true)
	
	if btn_work_shift and not btn_work_shift.disabled:
		btn_work_shift.grab_focus()
	elif btn_close:
		btn_close.grab_focus()

func close() -> void:
	visible = false
	closed.emit()

func _refresh_ui_text() -> void:
	label_title.text = tr("BANK_TITLE")
	label_job_header.text = tr("BANK_JOB_SECTION")
	btn_work_shift.text = tr("BANK_BTN_WORK")
	btn_resign.text = tr("BANK_BTN_RESIGN")
	btn_close.text = tr("BANK_BTN_CLOSE")

func refresh_view() -> void:
	if not GameManager or not GameManager.player_data:
		return
		
	var player: PlayerData = GameManager.player_data
	var econ: EconomySystem = GameManager.economy_system
	var career: CareerSystem = GameManager.career_system
	
	label_balance.text = tr("BANK_BALANCE") % player.money
	
	var runway: float = econ.get_financial_runway_days() if econ else 0.0
	var daily_exp: float = econ.get_daily_fixed_expenses().total if econ else 25.0
	label_runway.text = tr("BANK_RUNWAY") % [runway, daily_exp]
	
	var tier_name: String = career.get_tier_name(player.career_tier) if career else "Beginner"
	label_status.text = tr("BANK_STATUS") % tier_name
	
	# Aggiornamento stato alloggio
	if label_housing:
		var h_tier: int = player.current_housing_tier
		var h_name: String = HousingData.get_tier_name(h_tier)
		var h_rent: float = HousingData.get_tier_rent(h_tier)
		if h_tier == Enums.HousingTier.SHARED_FLAT and not player.band_members.is_empty():
			var share: float = snappedf(h_rent / float(1 + player.band_members.size()), 0.01)
			label_housing.text = "Alloggio: %s (Quota Alex: %.2f € su %.2f € totali)" % [h_name, share, h_rent]
		else:
			label_housing.text = "Alloggio: %s (Canone: %.2f €/giorno)" % [h_name, h_rent]
			
	if opt_housing:
		for i in range(opt_housing.item_count):
			if opt_housing.get_item_id(i) == player.current_housing_tier:
				opt_housing.select(i)
				break
	
	# Aggiornamento stato lavoro
	if econ:
		var job: Dictionary = econ.get_current_job()
		if job.id == "none":
			label_job_desc.text = tr("JOB_NONE_NAME") + " — " + tr("JOB_ERR_UNEMPLOYED")
			btn_work_shift.disabled = true
			btn_resign.disabled = true
		else:
			label_job_desc.text = "%s (Paga: %.2f € | Consumo: %d Energia, +%d Stress)" % [
				job.name, job.wage, job.energy_cost, job.stress_gain
			]
			btn_work_shift.disabled = player.energy < job.energy_cost
			btn_resign.disabled = false
			
		# Popolamento transazioni
		_populate_transactions(econ.get_recent_transactions(12))

func _populate_housing_dropdown() -> void:
	if not opt_housing:
		return
	opt_housing.clear()
	opt_housing.add_item("Stanzetta Singola (15 €/giorno)", Enums.HousingTier.STARTER_BEDROOM)
	opt_housing.add_item("Appartamento Condiviso con Band (25 €/giorno)", Enums.HousingTier.SHARED_FLAT)
	opt_housing.add_item("Loft con Sala Prove Inclusa (50 €/giorno)", Enums.HousingTier.LOFT_STUDIO)
	opt_housing.add_item("Villa di Lusso con Studio (150 €/giorno)", Enums.HousingTier.LUXURY_VILLA)

func _on_change_housing_pressed() -> void:
	if not GameManager or not GameManager.economy_system:
		return
	var selected_tier: int = opt_housing.get_selected_id()
	var res: Dictionary = GameManager.economy_system.change_housing(selected_tier)
	if res.success:
		refresh_view()
	else:
		var err_msg := "Trasloco non consentito: "
		match res.reason:
			"already_current":
				err_msg += "Stai già vivendo in questo alloggio."
			"no_band_members":
				err_msg += "Devi avere almeno un compagno nella band per condividere un appartamento!"
			"career_too_low":
				err_msg += "La villa richiede uno status di carriera almeno da Artista Indipendente."
			"money_insufficient":
				err_msg += "Fondi insufficienti per pagare il canone iniziale di questo alloggio."
			_:
				err_msg += res.reason
		AccessibilityManager.announce(err_msg, true)

func _populate_transactions(tx_list: Array[Dictionary]) -> void:
	if not vbox_transactions:
		return
	for c in vbox_transactions.get_children():
		c.queue_free()
		
	if tx_list.is_empty():
		var empty_lbl := Label.new()
		empty_lbl.text = "Nessuna transazione recente registrata."
		vbox_transactions.add_child(empty_lbl)
		return
		
	for i in range(tx_list.size()):
		var tx: Dictionary = tx_list[i]
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 20)
		
		var day_str: String = "G%d" % tx.get("day", 1)
		var amt: float = tx.get("amount", 0.0)
		var sign_str: String = "+" if amt > 0 else ""
		var amt_str: String = "%s%.2f €" % [sign_str, amt]
		var desc_str: String = str(tx.get("description", ""))
		
		var lbl_day := Label.new()
		lbl_day.text = "[%s]" % day_str
		lbl_day.custom_minimum_size = Vector2(45, 0)
		
		var lbl_desc := Label.new()
		lbl_desc.text = desc_str
		lbl_desc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var lbl_amt := Label.new()
		lbl_amt.text = amt_str
		if amt < 0:
			lbl_amt.modulate = Color(1.0, 0.4, 0.4) # Rosso spese
		else:
			lbl_amt.modulate = Color(0.4, 1.0, 0.4) # Verde entrate
			
		row.add_child(lbl_day)
		row.add_child(lbl_desc)
		row.add_child(lbl_amt)
		
		vbox_transactions.add_child(row)

func _on_work_shift_pressed() -> void:
	if not GameManager or not GameManager.economy_system:
		return
	var res: Dictionary = GameManager.economy_system.perform_job_shift()
	refresh_view()
	if not res.get("success", false):
		AccessibilityManager.announce(res.get("message", "Impossibile lavorare."), true)

func _on_resign_pressed() -> void:
	if not GameManager or not GameManager.economy_system:
		return
	GameManager.economy_system.resign_from_job()
	refresh_view()
	btn_close.grab_focus()
