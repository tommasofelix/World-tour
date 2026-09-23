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
var selected_extreme_move: int = Enums.FestivalExtremeMove.NONE

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
	if EventBus.has_signal("battle_of_bands_completed"):
		EventBus.battle_of_bands_completed.connect(func(_r): refresh_view())

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_F:
			close()
			get_viewport().set_input_as_handled()
		elif event.keycode >= KEY_1 and event.keycode <= KEY_9:
			var idx: int = event.keycode - KEY_1
			if idx < current_festivals.size():
				select_festival(idx)
				get_viewport().set_input_as_handled()
		elif event.keycode == KEY_0:
			if current_festivals.size() > 9:
				select_festival(9)
				get_viewport().set_input_as_handled()
		elif event.keycode == KEY_MINUS:
			if current_festivals.size() > 10:
				select_festival(10)
				get_viewport().set_input_as_handled()
		elif event.keycode == KEY_EQUAL:
			if current_festivals.size() > 11:
				select_festival(11)
				get_viewport().set_input_as_handled()
		elif event.keycode == KEY_UP:
			if current_fest_index > 0:
				select_festival(current_fest_index - 1)
				get_viewport().set_input_as_handled()
		elif event.keycode == KEY_DOWN:
			if current_fest_index < current_festivals.size() - 1:
				select_festival(current_fest_index + 1)
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
		elif event.keycode == KEY_M:
			select_stage_type(Enums.FestivalStageType.MAIN_STAGE)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_U:
			select_stage_type(Enums.FestivalStageType.UNDERGROUND_TENT)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_E:
			cycle_extreme_move()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_O:
			cycle_sponsor()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_B:
			_on_battle_of_bands_pressed()
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
	AccessibilityManager.announce("Aperta schermata Grandi Festival Estivi. Premi da 1 a 9, 0, meno o uguale per scegliere tra i 12 festival mondiali. P/T/H per gli slot, M per Main Stage, U per Tenda Underground, B per Battle of the Bands primaverile, E per mosse estreme, O per sponsor, Invio per candidarti, Spazio per suonare.", true)
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

func select_stage_type(stage_type: int) -> void:
	var fest: FestivalData = current_festivals[current_fest_index]
	GameManager.festival_system.set_festival_stage_type(fest.id, stage_type)
	refresh_view()
	var speech := "Selezionato %s per %s." % [Enums.get_festival_stage_type_name(stage_type), fest.name]
	AccessibilityManager.announce(speech, true)

func cycle_extreme_move() -> void:
	match selected_extreme_move:
		Enums.FestivalExtremeMove.NONE:
			selected_extreme_move = Enums.FestivalExtremeMove.STAGE_DIVING
		Enums.FestivalExtremeMove.STAGE_DIVING:
			selected_extreme_move = Enums.FestivalExtremeMove.RIGGING_CLIMB
		Enums.FestivalExtremeMove.RIGGING_CLIMB:
			selected_extreme_move = Enums.FestivalExtremeMove.CROWD_SOLO
		Enums.FestivalExtremeMove.CROWD_SOLO:
			selected_extreme_move = Enums.FestivalExtremeMove.NONE
		_:
			selected_extreme_move = Enums.FestivalExtremeMove.NONE
	refresh_view()
	var speech := "Mossa Scenica selezionata: %s." % Enums.get_festival_extreme_move_name(selected_extreme_move)
	AccessibilityManager.announce(speech, true)

func cycle_sponsor() -> void:
	var fest: FestivalData = current_festivals[current_fest_index]
	var next_sponsor: int = Enums.FestivalSponsorType.NONE
	match fest.active_sponsor:
		Enums.FestivalSponsorType.NONE:
			next_sponsor = Enums.FestivalSponsorType.ENERGY_DRINK
		Enums.FestivalSponsorType.ENERGY_DRINK:
			next_sponsor = Enums.FestivalSponsorType.CRAFT_BEER
		Enums.FestivalSponsorType.CRAFT_BEER:
			next_sponsor = Enums.FestivalSponsorType.STREETWEAR_GEAR
		Enums.FestivalSponsorType.STREETWEAR_GEAR:
			next_sponsor = Enums.FestivalSponsorType.NONE
		_:
			next_sponsor = Enums.FestivalSponsorType.NONE
	GameManager.festival_system.sign_festival_sponsor(fest.id, next_sponsor)
	refresh_view()
	var speech := "Sponsor festival: %s." % Enums.get_festival_sponsor_type_name(next_sponsor)
	AccessibilityManager.announce(speech, true)

func _on_battle_of_bands_pressed() -> void:
	var check := GameManager.festival_system.can_enter_battle_of_bands()
	if not check.allowed:
		var err_msg := "Battle of the Bands non disponibile: "
		match check.reason:
			"not_spring_season":
				err_msg += "Il contest si tiene solo in Primavera (Mese 3 / Giorni 57-84)."
			"already_won":
				err_msg += "Hai già vinto il contest quest'anno e possiedi il Pass Speciale!"
			"no_songs_available":
				err_msg += "Serve almeno una canzone pronta per esibirsi al contest."
			_:
				err_msg += check.reason
		AccessibilityManager.announce(err_msg, true)
		return
		
	var songs: Array = GameManager.player_data.songs if GameManager.player_data else []
	var res := GameManager.festival_system.compete_in_battle_of_bands(songs)
	if res.get("won", false):
		var speech := "Trionfo epico alla Battle of the Bands! Punteggio %.1f contro %.1f della rivale %s! Guadagnati 300 euro, +8 reputazione e il Pass Speciale per i festival estivi!" % [
			res.concert_score,
			res.rival_score,
			check.rival_band_name
		]
		AccessibilityManager.announce(speech, true)
	else:
		var speech := "Esibizione alla Battle of the Bands conclusa. Punteggio %.1f contro %.1f. La rivale vince il contest, ma guadagni +2 reputazione per l'esperienza." % [
			res.concert_score,
			res.rival_score
		]
		AccessibilityManager.announce(speech, true)
	refresh_view()

func _update_details(fest: FestivalData) -> void:
	label_fest_name.text = fest.name
	var pass_marker := " [Pass Battle of the Bands: Requisiti Agevolati]" if (GameManager.player_data and GameManager.player_data.battle_of_bands_pass) else ""
	label_fest_info.text = "Città: %s | Arena: %s | Giorno: %d (Mese %d - Estate) | Capienza: %d | Palco: %s | Meteo: %s | Sponsor: %s%s" % [
		Enums.get_city_name(fest.city_id),
		fest.location_name,
		fest.day_number,
		fest.season_month,
		fest.capacity,
		Enums.get_festival_stage_type_name(fest.stage_type),
		Enums.get_festival_weather_name(fest.weather),
		Enums.get_festival_sponsor_type_name(fest.active_sponsor),
		pass_marker
	]
	
	label_fest_rival.text = "Rivale sul Cartellone: %s (Punteggio Benchmark: %.1f) - Mossa Estrema: %s" % [
		fest.rival_band_name,
		fest.rival_band_score,
		Enums.get_festival_extreme_move_name(selected_extreme_move)
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
	var res: Dictionary = GameManager.festival_system.perform_festival_concert(fest.id, songs, -1.0, selected_extreme_move)
	
	if res.get("success", false):
		var steal_msg := "Hai battuto la rivale %s rubando la scena!" % fest.rival_band_name if res.stole_the_show else "Concerto concluso."
		var speech := "Trionfo al Festival %s! Palco: %s. Score: %.1f. %s Pubblico: %d. Incasso: %.2f euro. Nuovi fan: %d. %s" % [
			fest.name,
			res.stage_type_name,
			res.concert_score,
			steal_msg,
			res.actual_audience,
			res.player_share,
			res.new_fans,
			res.backstage_reaction
		]
		AccessibilityManager.announce(speech, true)
		refresh_view()
	else:
		AccessibilityManager.announce("Impossibile avviare il concerto: %s" % res.get("reason", "errore"), true)
