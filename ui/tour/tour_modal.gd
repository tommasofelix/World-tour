# res://ui/tour/tour_modal.gd
extends Control

## Controller della Schermata di Pianificazione e Gestione Tour (World-tour F8.2 / SP-10)
## Permette a Luca (NVDA/tastiera) e a Holy Diver (monitor/mouse) di pianificare
## una tournée multi-tappa, scegliere il veicolo e monitorare l'avanzamento tra le città.

signal closed()
signal tour_started(tour_data: TourData)

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var panel_planning: PanelContainer = $PanelMain/VBox/PanelPlanning
@onready var panel_active_tour: PanelContainer = $PanelMain/VBox/PanelActiveTour

# Controlli Pianificazione
@onready var edit_tour_name: LineEdit = $PanelMain/VBox/PanelPlanning/Margin/VBoxPlan/HBoxName/EditTourName
@onready var opt_vehicle: OptionButton = $PanelMain/VBox/PanelPlanning/Margin/VBoxPlan/HBoxVehicle/OptVehicle
@onready var opt_itinerary: OptionButton = $PanelMain/VBox/PanelPlanning/Margin/VBoxPlan/HBoxItinerary/OptItinerary
@onready var label_plan_cost: Label = $PanelMain/VBox/PanelPlanning/Margin/VBoxPlan/LabelPlanCost
@onready var btn_confirm_plan: Button = $PanelMain/VBox/PanelPlanning/Margin/VBoxPlan/BtnConfirmPlan

# Controlli Tour Attivo
@onready var label_active_status: Label = $PanelMain/VBox/PanelActiveTour/Margin/VBoxActive/LabelActiveStatus
@onready var label_active_hype: Label = $PanelMain/VBox/PanelActiveTour/Margin/VBoxActive/LabelActiveHype
@onready var vbox_stops_list: VBoxContainer = $PanelMain/VBox/PanelActiveTour/Margin/VBoxActive/ScrollStops/VBoxStopsList
@onready var hbox_actions: HBoxContainer = $PanelMain/VBox/PanelActiveTour/Margin/VBoxActive/HBoxActions
@onready var btn_advance_stop: Button = $PanelMain/VBox/PanelActiveTour/Margin/VBoxActive/HBoxActions/BtnAdvanceStop
@onready var btn_cancel_tour: Button = $PanelMain/VBox/PanelActiveTour/Margin/VBoxActive/HBoxActions/BtnCancelTour

# Componenti Dinamici Sezione 6
var btn_radio_interview: Button = null
var btn_stickers_diary: Button = null
var panel_dilemma: PanelContainer = null
var label_dilemma_title: Label = null
var label_dilemma_desc: Label = null
var hbox_dilemma_options: HBoxContainer = null
var dilemma_buttons: Array[Button] = []

# Footer
@onready var label_status: Label = $PanelMain/VBox/LabelStatus
@onready var btn_close: Button = $PanelMain/VBox/HBoxBottom/BtnClose

var selected_vehicle_type: int = Enums.TourVehicleType.RUSTY_VAN
var selected_itinerary_preset: int = 0

func _ready() -> void:
	btn_close.pressed.connect(close)
	AccessibilityManager.hook_control_accessibility(btn_close, "Chiudi Finestra Tour", "Chiude la schermata delle tournée e torna all'HUD.")

	if btn_confirm_plan:
		btn_confirm_plan.pressed.connect(_on_confirm_plan_pressed)
	if btn_advance_stop:
		btn_advance_stop.pressed.connect(_on_advance_stop_pressed)
	if btn_cancel_tour:
		btn_cancel_tour.pressed.connect(_on_cancel_tour_pressed)

	# Aggiunta dinamica pulsanti Sezione 6 in HBoxActions
	if hbox_actions:
		btn_radio_interview = Button.new()
		btn_radio_interview.text = "Promozione Radio (R)"
		btn_radio_interview.custom_minimum_size = Vector2(0, 36)
		btn_radio_interview.pressed.connect(_on_radio_interview_pressed)
		hbox_actions.add_child(btn_radio_interview)
		AccessibilityManager.hook_control_accessibility(
			btn_radio_interview,
			"Promozione Radio Mattutina",
			"Tasto rapido R. Svolge un'intervista radiofonica (+10% hype tour, +25 fan locali, -15 energia)."
		)

		btn_stickers_diary = Button.new()
		btn_stickers_diary.text = "Diario Adesivi (D)"
		btn_stickers_diary.custom_minimum_size = Vector2(0, 36)
		btn_stickers_diary.pressed.connect(_on_stickers_pressed)
		hbox_actions.add_child(btn_stickers_diary)
		AccessibilityManager.hook_control_accessibility(
			btn_stickers_diary,
			"Diario Adesivi Veicolo",
			"Tasto rapido D. Legge la collezione di adesivi applicati sul veicolo del tour."
		)

	# Creazione pannello dedicato ai Dilemmi Stradali
	_setup_dilemma_panel()

	if opt_vehicle:
		opt_vehicle.clear()
		opt_vehicle.add_item("Furgone Scassato (40 €/tappa, +15 stress)", Enums.TourVehicleType.RUSTY_VAN)
		opt_vehicle.add_item("Van Professionale (150 €/tappa, +5 stress)", Enums.TourVehicleType.PRO_VAN)
		opt_vehicle.add_item("Tour Bus di Lusso (450 €/tappa, 0 stress, +cuccette)", Enums.TourVehicleType.LUXURY_BUS)
		opt_vehicle.item_selected.connect(_on_vehicle_selected)

	if opt_itinerary:
		opt_itinerary.clear()
		opt_itinerary.add_item("1: Mini-Tour 3 Città (Milano -> Bologna -> Roma)", 0)
		opt_itinerary.add_item("2: Giro d'Italia Rock (Milano -> Bologna -> Roma -> Napoli)", 1)
		opt_itinerary.add_item("3: Tour Europeo con Day Off (Milano -> Parigi -> Day Off -> Berlino -> Londra)", 2)
		opt_itinerary.add_item("4: Grand Tour Transoceanico (Londra -> New York -> Los Angeles -> Day Off -> Tokyo)", 3)
		opt_itinerary.item_selected.connect(_on_itinerary_selected)

	EventBus.tour_planned.connect(func(_t): refresh_view())
	EventBus.tour_stop_completed.connect(func(_i, _r): refresh_view())
	EventBus.tour_finished.connect(func(_s): refresh_view())
	EventBus.road_dilemma_triggered.connect(func(_d): refresh_view())
	EventBus.road_dilemma_resolved.connect(func(_c, _o): refresh_view())
	EventBus.tour_radio_interview_completed.connect(func(_i): refresh_view())
	EventBus.city_sticker_collected.connect(func(_c): refresh_view())

func _setup_dilemma_panel() -> void:
	var vbox_active = $PanelMain/VBox/PanelActiveTour/Margin/VBoxActive
	if not vbox_active:
		return

	panel_dilemma = PanelContainer.new()
	panel_dilemma.visible = false
	var pbox := VBoxContainer.new()
	pbox.add_theme_constant_override("separation", 8)

	label_dilemma_title = Label.new()
	label_dilemma_title.add_theme_font_size_override("font_size", 16)
	label_dilemma_title.modulate = Color(1.0, 0.4, 0.4, 1) # Rosso allerta
	pbox.add_child(label_dilemma_title)

	label_dilemma_desc = Label.new()
	label_dilemma_desc.add_theme_font_size_override("font_size", 14)
	label_dilemma_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	pbox.add_child(label_dilemma_desc)

	hbox_dilemma_options = HBoxContainer.new()
	hbox_dilemma_options.add_theme_constant_override("separation", 10)
	pbox.add_child(hbox_dilemma_options)

	panel_dilemma.add_child(pbox)
	vbox_active.add_child(panel_dilemma)

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_O:
			close()
			get_viewport().set_input_as_handled()
		elif not has_active_tour():
			# Scorciatoie fase di pianificazione
			if event.keycode == KEY_1:
				_select_itinerary(0)
				get_viewport().set_input_as_handled()
			elif event.keycode == KEY_2:
				_select_itinerary(1)
				get_viewport().set_input_as_handled()
			elif event.keycode == KEY_3:
				_select_itinerary(2)
				get_viewport().set_input_as_handled()
			elif event.keycode == KEY_4:
				_select_itinerary(3)
				get_viewport().set_input_as_handled()
			elif event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
				_on_confirm_plan_pressed()
				get_viewport().set_input_as_handled()
		else:
			# Scorciatoie tour attivo
			if GameManager and GameManager.tour_system and not GameManager.tour_system.pending_road_dilemma.is_empty():
				if event.keycode == KEY_1:
					_on_resolve_dilemma(1)
					get_viewport().set_input_as_handled()
				elif event.keycode == KEY_2:
					_on_resolve_dilemma(2)
					get_viewport().set_input_as_handled()
				elif event.keycode == KEY_3:
					_on_resolve_dilemma(3)
					get_viewport().set_input_as_handled()
			else:
				if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
					_on_advance_stop_pressed()
					get_viewport().set_input_as_handled()
				elif event.keycode == KEY_R:
					_on_radio_interview_pressed()
					get_viewport().set_input_as_handled()
				elif event.keycode == KEY_D:
					_on_stickers_pressed()
					get_viewport().set_input_as_handled()

func open() -> void:
	visible = true
	refresh_view()

	if GameManager and GameManager.tour_system:
		var speech: String = GameManager.tour_system.get_tour_summary_speech()
		AccessibilityManager.announce(speech, true)

	if has_active_tour():
		if btn_advance_stop and not btn_advance_stop.disabled:
			btn_advance_stop.grab_focus()
	else:
		if edit_tour_name:
			edit_tour_name.grab_focus()

func close() -> void:
	visible = false
	closed.emit()

func has_active_tour() -> bool:
	return GameManager and GameManager.tour_system and GameManager.tour_system.active_tour != null and GameManager.tour_system.active_tour.status == TourData.TourStatus.IN_PROGRESS

func _select_itinerary(preset_idx: int) -> void:
	selected_itinerary_preset = preset_idx
	if opt_itinerary:
		opt_itinerary.selected = preset_idx
	_update_plan_cost_preview()

func _on_vehicle_selected(index: int) -> void:
	selected_vehicle_type = opt_vehicle.get_item_id(index)
	_update_plan_cost_preview()

func _on_itinerary_selected(index: int) -> void:
	selected_itinerary_preset = index
	_update_plan_cost_preview()

func _update_plan_cost_preview() -> void:
	if not label_plan_cost or not GameManager:
		return

	var stops := _generate_stops_from_preset(selected_itinerary_preset)
	var specs := TourSystem.get_vehicle_specs(selected_vehicle_type)
	var total_rental: float = float(specs.cost_per_stop) * float(stops.size())

	label_plan_cost.text = "Costo Noleggio Veicolo: %.2f € (%d tappe a %.2f €/tappa). Requisito Reputazione: %.1f." % [
		total_rental, stops.size(), float(specs.cost_per_stop), float(specs.min_reputation)
	]

func _generate_stops_from_preset(preset_idx: int) -> Array[Dictionary]:
	var list: Array[Dictionary] = []
	var start_day: int = GameManager.calendar_data.day_number if GameManager and GameManager.calendar_data else 1

	match preset_idx:
		0: # Mini-Tour 3 Città
			list.append({ "city_id": Enums.CityId.MILANO, "venue_id": "milano_small_club", "venue_name": "Magazzini Underground", "day_number": start_day + 2 })
			list.append({ "city_id": Enums.CityId.BOLOGNA, "venue_id": "bologna_covo", "venue_name": "Covo Indie Club", "day_number": start_day + 4 })
			list.append({ "city_id": Enums.CityId.ROMA, "venue_id": "roma_monk", "venue_name": "Monk Club", "day_number": start_day + 6 })
		1: # Giro d'Italia Rock
			list.append({ "city_id": Enums.CityId.MILANO, "venue_id": "milano_trendy_club", "venue_name": "Alcatraz Live Hall", "day_number": start_day + 2 })
			list.append({ "city_id": Enums.CityId.BOLOGNA, "venue_id": "bologna_estragon", "venue_name": "Estragon Live", "day_number": start_day + 4 })
			list.append({ "city_id": Enums.CityId.ROMA, "venue_id": "roma_atlantico", "venue_name": "Atlantico Live", "day_number": start_day + 6 })
			list.append({ "city_id": Enums.CityId.NAPOLI, "venue_id": "napoli_arena", "venue_name": "Palapartenope Hall", "day_number": start_day + 8 })
		2: # Tour Europeo con Day Off
			list.append({ "city_id": Enums.CityId.MILANO, "venue_id": "milano_trendy_club", "venue_name": "Alcatraz Live Hall", "day_number": start_day + 2 })
			list.append({ "city_id": Enums.CityId.PARIGI, "venue_id": "paris_olympia", "venue_name": "L'Olympia", "day_number": start_day + 5 })
			list.append({ "city_id": Enums.CityId.PARIGI, "city_name": "Parigi", "is_day_off": true, "day_number": start_day + 6 })
			list.append({ "city_id": Enums.CityId.BERLINO, "venue_id": "berlin_columbia", "venue_name": "Columbiahalle", "day_number": start_day + 8 })
			list.append({ "city_id": Enums.CityId.LONDRA, "venue_id": "london_brixton", "venue_name": "O2 Brixton Academy", "day_number": start_day + 11 })
		3: # Grand Tour Transoceanico
			list.append({ "city_id": Enums.CityId.LONDRA, "venue_id": "london_brixton", "venue_name": "O2 Brixton Academy", "day_number": start_day + 2 })
			list.append({ "city_id": Enums.CityId.NEW_YORK, "venue_id": "ny_bowery", "venue_name": "Bowery Ballroom", "day_number": start_day + 6 })
			list.append({ "city_id": Enums.CityId.LOS_ANGELES, "venue_id": "la_troubadour", "venue_name": "The Troubadour", "day_number": start_day + 10 })
			list.append({ "city_id": Enums.CityId.LOS_ANGELES, "city_name": "Los Angeles", "is_day_off": true, "day_number": start_day + 11 })
			list.append({ "city_id": Enums.CityId.TOKYO, "venue_id": "tokyo_budokan", "venue_name": "Nippon Budokan", "day_number": start_day + 15 })

	return list

func _on_confirm_plan_pressed() -> void:
	if not GameManager or not GameManager.tour_system:
		return

	var title: String = edit_tour_name.text.strip_edges()
	if title.is_empty():
		title = "Tour Nazionale " + str(GameManager.calendar_data.get_year())

	var stops := _generate_stops_from_preset(selected_itinerary_preset)
	var res := GameManager.tour_system.plan_tour(title, selected_vehicle_type, stops)

	if res.success:
		label_status.text = "Tour confermato! Buon viaggio!"
		refresh_view()
	else:
		label_status.text = "Impossibile pianificare: " + res.message
		AccessibilityManager.announce(label_status.text, true)

func _on_advance_stop_pressed() -> void:
	if not GameManager or not GameManager.tour_system:
		return
	var res := GameManager.tour_system.advance_to_next_stop()
	if res.success:
		refresh_view()
	else:
		label_status.text = res.message
		AccessibilityManager.announce(label_status.text, true)

func _on_cancel_tour_pressed() -> void:
	if has_active_tour():
		GameManager.tour_system.finish_tour()
		label_status.text = "Tour interrotto."
		refresh_view()

func _on_radio_interview_pressed() -> void:
	if not GameManager or not GameManager.tour_system:
		return
	var res := GameManager.tour_system.do_radio_interview()
	label_status.text = res.message
	refresh_view()

func _on_stickers_pressed() -> void:
	if not GameManager or not GameManager.tour_system:
		return
	var speech: String = GameManager.tour_system.get_vehicle_stickers_speech()
	label_status.text = speech
	AccessibilityManager.announce(speech, true)

func _on_resolve_dilemma(choice_index: int) -> void:
	if not GameManager or not GameManager.tour_system:
		return
	var res := GameManager.tour_system.resolve_road_dilemma_choice(choice_index)
	label_status.text = res.message
	refresh_view()

func refresh_view() -> void:
	if not GameManager or not GameManager.tour_system:
		return

	var ts: TourSystem = GameManager.tour_system
	var tour: TourData = ts.active_tour
	if tour != null and tour.status == TourData.TourStatus.IN_PROGRESS:
		panel_planning.visible = false
		panel_active_tour.visible = true

		label_title.text = "TOURNÉE IN CORSO: " + tour.title.to_upper()
		label_active_status.text = "Veicolo: %s | Tappe: %d su %d | Interviste Radio: %d" % [
			tour.get_vehicle_name(),
			tour.current_stop_index,
			tour.stops.size(),
			tour.radio_interviews_count
		]
		label_active_hype.text = "Hype Tour: +%d%% | Utile Netto Finora: %.2f € | Adesivi: %d" % [
			int(round((tour.accumulated_hype - 1.0) * 100.0)),
			tour.total_net_profit,
			GameManager.player_data.visited_city_stickers.size() if GameManager.player_data else 0
		]

		# Popolamento tappe
		for child in vbox_stops_list.get_children():
			child.queue_free()

		for i in range(tour.stops.size()):
			var s: Dictionary = tour.stops[i]
			var is_done: bool = s.get("completed", false)
			var is_current: bool = (i == tour.current_stop_index)
			var prefix: String = "[FATTO] " if is_done else ("[PROSSIMA] " if is_current else "[PROGRAMMATA] ")
			var is_day_off: bool = s.get("is_day_off", false)

			var lbl := Label.new()
			if is_day_off:
				lbl.text = "%sTappa %d: [DAY OFF] Riposo a %s — Giorno %d" % [
					prefix, i + 1, s.get("city_name", ""), int(s.get("day_number", 0))
				]
			else:
				var radio_tag := " [Radio OK]" if s.get("radio_interview_done", false) else ""
				lbl.text = "%sTappa %d: %s (%s)%s — Giorno %d" % [
					prefix, i + 1, s.get("venue_name", ""), s.get("city_name", ""), radio_tag, int(s.get("day_number", 0))
				]
			if is_current:
				lbl.modulate = Color(1.0, 0.9, 0.2) # Giallo evidenziato
			elif is_done:
				lbl.modulate = Color(0.4, 0.9, 0.4) # Verde
			else:
				lbl.modulate = Color(0.8, 0.8, 0.8) # Grigio chiaro
			vbox_stops_list.add_child(lbl)

		# Gestione Dilemma Stradale
		if panel_dilemma:
			if not ts.pending_road_dilemma.is_empty():
				panel_dilemma.visible = true
				var d_title: String = ts.pending_road_dilemma.get("title", "Dilemma Stradale")
				var d_desc: String = ts.pending_road_dilemma.get("description", "")
				label_dilemma_title.text = "ATTENZIONE: %s" % d_title
				label_dilemma_desc.text = d_desc

				for child in hbox_dilemma_options.get_children():
					child.queue_free()
				dilemma_buttons.clear()

				var opts: Dictionary = ts.pending_road_dilemma.get("options", {})
				for opt_key in [1, 2, 3]:
					var opt: Dictionary = opts.get(opt_key, {})
					if not opt.is_empty():
						var btn := Button.new()
						btn.text = "%d: %s" % [opt_key, opt.label]
						btn.custom_minimum_size = Vector2(0, 36)
						btn.pressed.connect(func(): _on_resolve_dilemma(opt_key))
						hbox_dilemma_options.add_child(btn)
						dilemma_buttons.append(btn)
						AccessibilityManager.hook_control_accessibility(
							btn,
							"Scelta %d: %s" % [opt_key, opt.label],
							"Premi %d per selezionare questa opzione." % opt_key
						)
				if btn_advance_stop:
					btn_advance_stop.disabled = true
				if btn_radio_interview:
					btn_radio_interview.disabled = true
			else:
				panel_dilemma.visible = false
				if btn_advance_stop:
					btn_advance_stop.disabled = false
				if btn_radio_interview:
					btn_radio_interview.disabled = false

	else:
		panel_planning.visible = true
		panel_active_tour.visible = false
		if panel_dilemma:
			panel_dilemma.visible = false
		label_title.text = "PIANIFICAZIONE TOURNÉE"
		_update_plan_cost_preview()
