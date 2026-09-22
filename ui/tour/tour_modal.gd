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
@onready var btn_advance_stop: Button = $PanelMain/VBox/PanelActiveTour/Margin/VBoxActive/HBoxActions/BtnAdvanceStop
@onready var btn_cancel_tour: Button = $PanelMain/VBox/PanelActiveTour/Margin/VBoxActive/HBoxActions/BtnCancelTour

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
		opt_itinerary.add_item("3: Tour Europeo (Milano -> Berlino -> Londra)", 2)
		opt_itinerary.item_selected.connect(_on_itinerary_selected)
		
	EventBus.tour_planned.connect(func(_t): refresh_view())
	EventBus.tour_stop_completed.connect(func(_i, _r): refresh_view())
	EventBus.tour_finished.connect(func(_s): refresh_view())

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
			elif event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
				_on_confirm_plan_pressed()
				get_viewport().set_input_as_handled()
		else:
			# Scorciatoie tour attivo
			if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
				_on_advance_stop_pressed()
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
		2: # Tour Europeo
			list.append({ "city_id": Enums.CityId.MILANO, "venue_id": "milano_trendy_club", "venue_name": "Alcatraz Live Hall", "day_number": start_day + 2 })
			list.append({ "city_id": Enums.CityId.BERLINO, "venue_id": "berlin_columbia", "venue_name": "Columbiahalle", "day_number": start_day + 5 })
			list.append({ "city_id": Enums.CityId.LONDRA, "venue_id": "london_brixton", "venue_name": "O2 Brixton Academy", "day_number": start_day + 8 })
			
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

func refresh_view() -> void:
	if not GameManager or not GameManager.tour_system:
		return
		
	var tour: TourData = GameManager.tour_system.active_tour
	if tour != null and tour.status == TourData.TourStatus.IN_PROGRESS:
		panel_planning.visible = false
		panel_active_tour.visible = true
		
		label_title.text = "TOURNÉE IN CORSO: " + tour.title.to_upper()
		label_active_status.text = "Veicolo: %s | Tappe Completate: %d su %d" % [
			tour.get_vehicle_name(),
			tour.current_stop_index,
			tour.stops.size()
		]
		label_active_hype.text = "Hype Tour Attivo: +%d%% | Utile Netto Finora: %.2f €" % [
			int(round((tour.accumulated_hype - 1.0) * 100.0)),
			tour.total_net_profit
		]
		
		# Popolamento tappe
		for child in vbox_stops_list.get_children():
			child.queue_free()
			
		for i in range(tour.stops.size()):
			var s: Dictionary = tour.stops[i]
			var is_done: bool = s.get("completed", false)
			var is_current: bool = (i == tour.current_stop_index)
			var prefix: String = "[FATTO] " if is_done else ("[PROSSIMA] " if is_current else "[PROGRAMMATA] ")
			
			var lbl := Label.new()
			lbl.text = "%sTappa %d: %s (%s) — Giorno %d" % [
				prefix, i + 1, s.get("venue_name", ""), s.get("city_name", ""), int(s.get("day_number", 0))
			]
			if is_current:
				lbl.modulate = Color(1.0, 0.9, 0.2) # Giallo evidenziato
			elif is_done:
				lbl.modulate = Color(0.4, 0.9, 0.4) # Verde
			else:
				lbl.modulate = Color(0.8, 0.8, 0.8) # Grigio chiaro
			vbox_stops_list.add_child(lbl)
			
	else:
		panel_planning.visible = true
		panel_active_tour.visible = false
		label_title.text = "PIANIFICAZIONE TOURNÉE"
		_update_plan_cost_preview()
