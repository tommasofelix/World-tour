# res://ui/travel/travel_modal.gd
extends Control

## Controller della Mappa Geografica e Spostamenti Interurbani per World-tour (F8.1)
## Permette a Luca (NVDA/tastiera) e a Holy Diver (monitor/mouse) di esplorare
## le scene musicali delle città, verificare costi/stanchezza e viaggiare.

signal closed()
signal traveled_to_city(city_id: int)

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var label_current_location: Label = $PanelMain/VBox/PanelLocation/Margin/LabelCurrentLocation
@onready var vbox_cities: VBoxContainer = $PanelMain/VBox/ScrollCities/VBoxCitiesList
@onready var label_status: Label = $PanelMain/VBox/LabelStatus
@onready var btn_close: Button = $PanelMain/VBox/HBoxBottom/BtnClose

var travel_buttons: Array[Button] = []

func _ready() -> void:
	btn_close.pressed.connect(close)
	AccessibilityManager.hook_control_accessibility(btn_close, "Chiudi Mappa Viaggi", "Chiude la schermata dei viaggi e torna all'HUD.")

	EventBus.city_changed.connect(func(_o, _n): refresh_view())
	EventBus.money_changed.connect(func(_b, _d, _r): refresh_view())

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_V:
			close()
			get_viewport().set_input_as_handled()
		elif event.keycode >= KEY_1 and event.keycode <= KEY_9:
			var target_idx: int = event.keycode - KEY_1
			if target_idx < travel_buttons.size() and not travel_buttons[target_idx].disabled:
				travel_buttons[target_idx].pressed.emit()
				get_viewport().set_input_as_handled()
		elif event.keycode == KEY_0:
			if 9 < travel_buttons.size() and not travel_buttons[9].disabled:
				travel_buttons[9].pressed.emit()
				get_viewport().set_input_as_handled()

func open() -> void:
	visible = true
	refresh_view()

	if GameManager and GameManager.travel_system:
		var speech: String = GameManager.travel_system.get_linear_travel_options_speech()
		AccessibilityManager.announce(speech, true)

	if not travel_buttons.is_empty():
		for b in travel_buttons:
			if not b.disabled:
				b.grab_focus()
				break

func close() -> void:
	visible = false
	closed.emit()

func refresh_view() -> void:
	if not label_title or not GameManager or not GameManager.travel_system:
		return

	var ts: TravelSystem = GameManager.travel_system
	var cur_city = ts.get_current_city()
	var cur_name: String = cur_city.name if cur_city else "Milano"
	var fans_here: int = ts.get_fans_in_city(ts.current_city_id)
	var pop_here: float = ts.get_popularity_in_city(ts.current_city_id)
	var cur_event := ts.get_active_city_event(ts.current_city_id)
	var pl: PlayerData = GameManager.player_data

	label_title.text = "Mappa Geografica & Viaggi — Città Corrente: %s" % cur_name
	var loc_text := "Posizione Attuale: %s (%s) | Fan: %d | Notorietà: %.1f%% | Locali: %d" % [
		cur_name,
		cur_city.country if cur_city else "Italia",
		fans_here,
		pop_here,
		cur_city.venues.size() if cur_city else 0
	]
	if not cur_event.is_empty():
		loc_text += " | EVENTO: %s (+%d%% pubblico)" % [cur_event.name, int(round((cur_event.audience_mult - 1.0) * 100.0))]
	if pl and pl.jet_lag_days > 0:
		loc_text += " | JET LAG: %d giorni rimanenti (-15%% energia concerti)" % pl.jet_lag_days
	label_current_location.text = loc_text

	for c in vbox_cities.get_children():
		c.queue_free()
	travel_buttons.clear()

	var idx: int = 1
	for city in ts.cities:
		var is_current: bool = city.id == ts.current_city_id
		var check := ts.can_travel_to(city.id)
		var costs := ts.calculate_travel_cost(ts.current_city_id, city.id)
		var city_fans: int = ts.get_fans_in_city(city.id)
		var city_pop: float = ts.get_popularity_in_city(city.id)
		var c_event := ts.get_active_city_event(city.id)

		var card := PanelContainer.new()
		var card_vbox := VBoxContainer.new()
		card_vbox.add_theme_constant_override("separation", 6)

		var hbox_info := HBoxContainer.new()
		hbox_info.add_theme_constant_override("separation", 12)

		var lbl_city := Label.new()
		lbl_city.text = "%d. %s (%s)" % [idx, city.name, city.country]
		lbl_city.add_theme_font_size_override("font_size", 16)
		lbl_city.custom_minimum_size = Vector2(220, 0)

		var lbl_metrics := Label.new()
		lbl_metrics.text = "Fan: %d | Notorietà: %.1f%% | Locali: %d" % [city_fans, city_pop, city.venues.size()]
		lbl_metrics.add_theme_font_size_override("font_size", 14)
		lbl_metrics.modulate = Color(0.8, 0.85, 0.95, 1)

		hbox_info.add_child(lbl_city)
		hbox_info.add_child(lbl_metrics)

		if not c_event.is_empty():
			var lbl_evt := Label.new()
			lbl_evt.text = "[EVENTO: %s]" % c_event.name
			lbl_evt.add_theme_font_size_override("font_size", 14)
			lbl_evt.modulate = Color(1.0, 0.8, 0.2, 1)
			hbox_info.add_child(lbl_evt)

		card_vbox.add_child(hbox_info)

		var lbl_desc := Label.new()
		lbl_desc.text = "%s Generi favoriti: %s" % [city.description, _format_affinities(city.genre_affinities)]
		lbl_desc.add_theme_font_size_override("font_size", 13)
		lbl_desc.modulate = Color(0.75, 0.75, 0.8, 1)
		card_vbox.add_child(lbl_desc)

		var hbox_btn := HBoxContainer.new()
		hbox_btn.add_theme_constant_override("separation", 10)

		var btn_travel := Button.new()
		btn_travel.custom_minimum_size = Vector2(200, 36)

		if is_current:
			btn_travel.text = "Ti trovi qui"
			btn_travel.disabled = true
		elif check.allowed:
			btn_travel.text = "Viaggia a %s (%.2f €)" % [city.name, costs.money_cost]
			btn_travel.pressed.connect(func(): _on_travel_pressed(city.id))
		else:
			btn_travel.text = "Non disponibile"
			btn_travel.disabled = true

		hbox_btn.add_child(btn_travel)
		travel_buttons.append(btn_travel)

		var lbl_cost := Label.new()
		if not is_current:
			var cost_str := "Costo: %.2f € | Fatica: -%d Energia, +%d Stress" % [
				costs.money_cost, costs.energy_cost, costs.stress_cost
			]
			if costs.get("is_transoceanic", false):
				cost_str += " [Volo Transoceanico - Jet Lag 2 giorni]"
			lbl_cost.text = cost_str
			if not check.allowed:
				lbl_cost.text += " [%s]" % check.message
				lbl_cost.modulate = Color(1.0, 0.6, 0.6, 1)
			else:
				lbl_cost.modulate = Color(0.7, 0.9, 0.7, 1)
		else:
			lbl_cost.text = "Città base corrente della band."
			lbl_cost.modulate = Color(0.6, 0.8, 1.0, 1)

		hbox_btn.add_child(lbl_cost)
		card_vbox.add_child(hbox_btn)

		card.add_child(card_vbox)
		vbox_cities.add_child(card)

		# Hook AccessKit per NVDA
		var acc_name: String = "%d: %s (%s)" % [idx, city.name, city.country]
		var acc_desc: String = "Costo %.2f euro, fatica %d energia. %s. %s" % [
			costs.money_cost, costs.energy_cost, city.description, ("Disponibile" if check.allowed else check.message)
		]
		if not c_event.is_empty():
			acc_desc += " Attivo evento cittadino: %s." % c_event.name
		if costs.get("is_transoceanic", false):
			acc_desc += " Volo transoceanico: applica Jet Lag di 2 giorni."
		AccessibilityManager.hook_control_accessibility(btn_travel, acc_name, acc_desc)

		idx += 1

func _format_affinities(affinities: Dictionary) -> String:
	var parts: Array[String] = []
	for g in affinities:
		var mult: float = float(affinities[g])
		var bonus: int = int(round((mult - 1.0) * 100.0))
		parts.append("%s +%d%%" % [Enums.get_genre_name(int(g)), bonus])
	return ", ".join(parts) if not parts.is_empty() else "Nessuno"

func _on_travel_pressed(target_city_id: int) -> void:
	if not GameManager or not GameManager.travel_system:
		return
	var res := GameManager.travel_system.travel_to(target_city_id)
	if res.success:
		label_status.text = res.message
		traveled_to_city.emit(target_city_id)
		refresh_view()
	else:
		label_status.text = res.message
		AccessibilityManager.announce(res.message, true)
