# res://ui/festival/festival_modal.gd
extends Control

## Controller della Finestra Grandi Festival Estivi (World-tour F8.3 / SP-11)
## Accessibilità 100% tastiera e sintesi vocale NVDA per Luca,
## interfaccia grafica ad alto contrasto per Holy Diver.

signal closed()
signal festival_booked(festival_id: String, slot: int)
signal festival_performed(festival_id: String, result: Dictionary)

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var vbox_festival_list: VBoxContainer = $PanelMain/VBox/HBoxBody/PanelList/Margin/VBoxList/Scroll/VBoxFestivals

# Dettagli Festival
@onready var label_fest_name: Label = $PanelMain/VBox/HBoxBody/PanelDetails/Margin/VBoxDetails/LabelFestName
@onready var label_fest_info: Label = $PanelMain/VBox/HBoxBody/PanelDetails/Margin/VBoxDetails/LabelFestInfo
@onready var label_fest_rival: Label = $PanelMain/VBox/HBoxBody/PanelDetails/Margin/VBoxDetails/LabelFestRival
@onready var opt_slot: OptionButton = $PanelMain/VBox/HBoxBody/PanelDetails/Margin/VBoxDetails/HBoxSlot/OptSlot
@onready var label_slot_details: Label = $PanelMain/VBox/HBoxBody/PanelDetails/Margin/VBoxDetails/LabelSlotDetails
@onready var btn_book_slot: Button = $PanelMain/VBox/HBoxBody/PanelDetails/Margin/VBoxDetails/HBoxActions/BtnBookSlot
@onready var btn_perform_festival: Button = $PanelMain/VBox/HBoxBody/PanelDetails/Margin/VBoxDetails/HBoxActions/BtnPerformFestival

# Footer
@onready var label_status: Label = $PanelMain/VBox/LabelStatus
@onready var btn_close: Button = $PanelMain/VBox/HBoxBottom/BtnClose

var current_fest_index: int = 0
var current_festivals: Array[FestivalData] = []
var selected_slot: int = Enums.FestivalSlot.OPENING_AFTERNOON

func _ready() -> void:
	btn_close.pressed.connect(close)
	AccessibilityManager.hook_control_accessibility(btn_close, "Chiudi Finestra Festival", "Chiude la schermata dei festival estivi e torna all'HUD.")
	
	if btn_book_slot:
		btn_book_slot.pressed.connect(_on_book_slot_pressed)
	if btn_perform_festival:
		btn_perform_festival.pressed.connect(_on_perform_festival_pressed)
		
	if opt_slot:
		opt_slot.clear()
		opt_slot.add_item("1: Pomeriggio (Apertura) - 20% capienza", Enums.FestivalSlot.OPENING_AFTERNOON)
		opt_slot.add_item("2: Tramonto (Golden Hour) - 60% capienza", Enums.FestivalSlot.SUNSET_SLOT)
		opt_slot.add_item("3: Headliner (Prime Time Notturno) - 100% capienza", Enums.FestivalSlot.HEADLINER_NIGHT)
		opt_slot.item_selected.connect(_on_slot_selected)
		
	EventBus.festival_slot_booked.connect(func(_f, _s): refresh_view())
	EventBus.festival_performed.connect(func(_f, _r): refresh_view())

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_F:
			close()
			get_viewport().set_input_as_handled()
		elif event.keycode >= KEY_1 and event.keycode <= KEY_6:
			var idx: int = event.keycode - KEY_1
			if idx < current_festivals.size():
				select_festival(idx)
				get_viewport().set_input_as_handled()
		elif event.keycode == KEY_P:
			select_slot(Enums.FestivalSlot.OPENING_AFTERNOON)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_T:
			select_slot(Enums.FestivalSlot.SUNSET_SLOT)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_H:
			select_slot(Enums.FestivalSlot.HEADLINER_NIGHT)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_ENTER or event.keycode == KEY_C:
			if btn_book_slot and btn_book_slot.is_inside_tree() and not btn_book_slot.disabled:
				_on_book_slot_pressed()
				get_viewport().set_input_as_handled()
		elif event.keycode == KEY_SPACE or event.keycode == KEY_S:
			if btn_perform_festival and btn_perform_festival.is_inside_tree() and not btn_perform_festival.disabled:
				_on_perform_festival_pressed()
				get_viewport().set_input_as_handled()

func open() -> void:
	visible = true
	GameManager.change_state(Enums.GameState.GAMEPLAY_PAUSED)
	refresh_view()
	AccessibilityManager.announce("Aperta schermata Grandi Festival Estivi. Premi da 1 a 6 per selezionare un festival, P/T/H per scegliere lo slot, Invio per candidarti, Spazio per suonare.", true)
	if btn_close:
		btn_close.grab_focus()

func close() -> void:
	visible = false
	GameManager.change_state(Enums.GameState.GAMEPLAY_IDLE)
	closed.emit()
	AccessibilityManager.announce("Schermata Grandi Festival chiusa. Ritorno all'HUD principale.", true)

func refresh_view() -> void:
	var fest_sys: FestivalSystem = GameManager.festival_system
	if not fest_sys:
		return
		
	current_festivals = fest_sys.get_all_festivals()
	_rebuild_festival_buttons()
	if current_festivals.size() > 0:
		if current_fest_index >= current_festivals.size():
			current_fest_index = 0
		_update_details(current_festivals[current_fest_index])

func _rebuild_festival_buttons() -> void:
	if not vbox_festival_list:
		return
	for child in vbox_festival_list.get_children():
		child.queue_free()
		
	var idx := 0
	for fest in current_festivals:
		var btn := Button.new()
		var status_marker := ""
		if fest.is_completed:
			status_marker = " [CONCLUSO]"
		elif fest.is_slot_booked():
			status_marker = " [PRENOTATO: %s]" % Enums.get_festival_slot_name(fest.booked_slot)
			
		btn.text = "%d. %s (%s - Giorno %d)%s" % [
			idx + 1,
			fest.name,
			Enums.get_city_name(fest.city_id),
			fest.day_number,
			status_marker
		]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		var capture_idx := idx
		btn.pressed.connect(func(): select_festival(capture_idx))
		AccessibilityManager.hook_control_accessibility(
			btn,
			"Festival %s" % fest.name,
			"Giorno %d a %s. Capienza %d persone. Premi Invio per selezionare." % [
				fest.day_number,
				Enums.get_city_name(fest.city_id),
				fest.capacity
			]
		)
		vbox_festival_list.add_child(btn)
		idx += 1

func select_festival(index: int) -> void:
	if index < 0 or index >= current_festivals.size():
		return
	current_fest_index = index
	var fest: FestivalData = current_festivals[current_fest_index]
	_update_details(fest)
	
	var speech: String = GameManager.festival_system.get_festival_details_speech(fest.id)
	AccessibilityManager.announce(speech, true)

func select_slot(slot: int) -> void:
	selected_slot = slot
	if opt_slot:
		opt_slot.select(slot)
	_on_slot_selected(slot)

func _on_slot_selected(index: int) -> void:
	selected_slot = index
	var fest: FestivalData = current_festivals[current_fest_index]
	var specs: Dictionary = FestivalData.get_slot_specs(selected_slot, fest.capacity)
	var check: Dictionary = GameManager.festival_system.can_apply_for_slot(fest.id, selected_slot)
	
	var req_text := "Requisito: Reputazione %.1f (Tua: %.1f)." % [
		check.get("required_reputation", specs.min_reputation),
		GameManager.player_data.reputation if GameManager.player_data else 0.0
	]
	
	label_slot_details.text = "%s | Orario: %s | Pubblico Stimato: %d | Cachet Garantito: %.0f € | Merch: x%.1f\n%s" % [
		specs.name,
		specs.time_range,
		specs.estimated_audience,
		check.get("effective_fee", specs.guaranteed_fee),
		specs.merch_multiplier,
		req_text
	]
	
	btn_book_slot.disabled = not check.allowed
	
	var speech := "%s. Orario %s. Pubblico stimato %d. Cachet %.0f euro. %s" % [
		specs.name,
		specs.time_range,
		specs.estimated_audience,
		check.get("effective_fee", specs.guaranteed_fee),
		req_text
	]
	AccessibilityManager.announce(speech, false)

func _update_details(fest: FestivalData) -> void:
	label_fest_name.text = fest.name
	label_fest_info.text = "Città: %s | Arena: %s | Giorno: %d (Mese %d - Estate) | Capienza: %d persone" % [
		Enums.get_city_name(fest.city_id),
		fest.location_name,
		fest.day_number,
		fest.season_month,
		fest.capacity
	]
	
	label_fest_rival.text = "Rivale sul Cartellone: %s (Punteggio Benchmark: %.1f) - Obiettivo: Steal the Show!" % [
		fest.rival_band_name,
		fest.rival_band_score
	]
	
	if fest.is_completed:
		label_status.text = "Edizione di quest'anno completata. Risultato memorizzato."
		btn_book_slot.disabled = true
		btn_perform_festival.disabled = true
	elif fest.is_slot_booked():
		label_status.text = "Slot prenotato: %s. Pronto per suonare il Giorno %d a %s!" % [
			Enums.get_festival_slot_name(fest.booked_slot),
			fest.day_number,
			Enums.get_city_name(fest.city_id)
		]
		btn_book_slot.disabled = true
		
		# Abilita esibizione se ci si trova nella città giusta
		var cur_city: int = GameManager.player_data.current_city_id if GameManager.player_data else Enums.CityId.MILANO
		var cur_day: int = GameManager.calendar_data.day_number if GameManager.calendar_data else 1
		btn_perform_festival.disabled = not (cur_city == fest.city_id and cur_day == fest.day_number)
		if cur_city != fest.city_id:
			label_status.text += " [ATTENZIONE: Devi viaggiare a %s per esibirti]" % Enums.get_city_name(fest.city_id)
	else:
		label_status.text = "Scegli uno slot e premi Candidati (Invio / C)."
		btn_perform_festival.disabled = true
		_on_slot_selected(selected_slot)

func _on_book_slot_pressed() -> void:
	var fest: FestivalData = current_festivals[current_fest_index]
	var res: Dictionary = GameManager.festival_system.book_festival_slot(fest.id, selected_slot)
	if res.get("success", false):
		AccessibilityManager.announce("Candidatura confermata! La band suonerà a %s nello slot %s al giorno %d!" % [
			fest.name,
			Enums.get_festival_slot_name(selected_slot),
			fest.day_number
		], true)
		refresh_view()
	else:
		AccessibilityManager.announce("Candidatura rifiutata: %s" % res.get("reason", "errore"), true)

func _on_perform_festival_pressed() -> void:
	var fest: FestivalData = current_festivals[current_fest_index]
	var songs: Array = GameManager.player_data.songs if GameManager.player_data else []
	var res: Dictionary = GameManager.festival_system.perform_festival_concert(fest.id, songs)
	
	if res.get("success", false):
		var steal_msg := "Hai battuto la rivale %s rubando la scena!" % fest.rival_band_name if res.stole_the_show else "Concerto concluso."
		var speech := "Trionfo al Festival %s! Score: %.1f. %s Pubblico: %d. Incasso: %.2f euro. Nuovi fan: %d." % [
			fest.name,
			res.concert_score,
			steal_msg,
			res.actual_audience,
			res.player_share,
			res.new_fans
		]
		AccessibilityManager.announce(speech, true)
		refresh_view()
	else:
		AccessibilityManager.announce("Impossibile avviare il concerto: %s" % res.get("reason", "errore"), true)
