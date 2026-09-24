# res://ui/charts/chart_modal.gd
extends Control

## Controller della Schermata Classifiche Musicali, Artisti Rivali & Media Broadcaster (Sezione 10)
## Accessibilità 100% tastiera e sintesi vocale NVDA per Luca,
## grafica responsive ad alto contrasto per Holy Diver.

signal closed()

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var label_subtitle: Label = $PanelMain/VBox/Header/LabelSubtitle
@onready var btn_tab_singles: Button = $PanelMain/VBox/HBoxTabs/BtnTabSingles
@onready var btn_tab_territorial: Button = $PanelMain/VBox/HBoxTabs/BtnTabTerritorial
@onready var btn_tab_rivals: Button = $PanelMain/VBox/HBoxTabs/BtnTabRivals
@onready var btn_tab_media: Button = $PanelMain/VBox/HBoxTabs/BtnTabMedia

@onready var scroll_entries: ScrollContainer = $PanelMain/VBox/PanelBody/Margin/VBoxBody/ScrollEntries
@onready var vbox_entries: VBoxContainer = $PanelMain/VBox/PanelBody/Margin/VBoxBody/ScrollEntries/VBoxEntries
@onready var label_status: Label = $PanelMain/VBox/LabelStatus
@onready var btn_close: Button = $PanelMain/VBox/HBoxBottom/BtnClose

var current_tab: int = 0 # 0 = Top 10 Continentale, 1 = Hit Parade Territoriali, 2 = Rivali & Relazioni, 3 = Media & Stampa
var selected_city_idx: int = 0
var supported_cities: Array[int] = [
	Enums.CityId.MILANO,
	Enums.CityId.BOLOGNA,
	Enums.CityId.ROMA,
	Enums.CityId.NAPOLI,
	Enums.CityId.LONDRA,
	Enums.CityId.BERLINO
]

func _ready() -> void:
	btn_close.pressed.connect(close)
	AccessibilityManager.hook_control_accessibility(btn_close, "Chiudi Finestra Classifiche", "Chiude la schermata e torna all'HUD.")
	
	btn_tab_singles.pressed.connect(func(): _set_tab(0))
	btn_tab_territorial.pressed.connect(func(): _set_tab(1))
	btn_tab_rivals.pressed.connect(func(): _set_tab(2))
	btn_tab_media.pressed.connect(func(): _set_tab(3))
	
	AccessibilityManager.hook_control_accessibility(btn_tab_singles, "1: Top 10 Continentale", "Visualizza la classifica ufficiale europea.")
	AccessibilityManager.hook_control_accessibility(btn_tab_territorial, "2: Hit Parade Nazionali", "Visualizza le classifiche specifiche per città e nazione.")
	AccessibilityManager.hook_control_accessibility(btn_tab_rivals, "3: Artisti Rivali & Relazioni", "Consulta le band rivali, l'affinità e le opzioni di tour congiunto o dissing.")
	AccessibilityManager.hook_control_accessibility(btn_tab_media, "4: Media, Radio & Stampa", "Visualizza le emittenti per interviste e la rassegna stampa critica.")
	
	EventBus.weekly_charts_updated.connect(func(_d): if visible: refresh_view())

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_H:
			close()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_1:
			_set_tab(0)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_2:
			_set_tab(1)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_3:
			_set_tab(2)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_4:
			_set_tab(3)
			get_viewport().set_input_as_handled()
		elif current_tab == 1:
			# Navigazione metropoli territoriali
			if event.keycode == KEY_LEFT or event.keycode == KEY_UP:
				selected_city_idx = posmod(selected_city_idx - 1, supported_cities.size())
				refresh_view()
				_announce_current_view()
				get_viewport().set_input_as_handled()
			elif event.keycode == KEY_RIGHT or event.keycode == KEY_DOWN:
				selected_city_idx = (selected_city_idx + 1) % supported_cities.size()
				refresh_view()
				_announce_current_view()
				get_viewport().set_input_as_handled()

func open() -> void:
	visible = true
	current_tab = 0
	refresh_view()
	if GameManager:
		GameManager.open_menu()
	if btn_tab_singles:
		btn_tab_singles.grab_focus()
	_announce_current_view()

func close() -> void:
	visible = false
	if GameManager:
		GameManager.close_menu()
	closed.emit()
	AccessibilityManager.announce("Schermata classifiche e media chiusa.", true)

func _set_tab(tab_idx: int) -> void:
	current_tab = tab_idx
	refresh_view()
	_announce_current_view()

func refresh_view() -> void:
	var cs: ChartSystem = GameManager.chart_system if GameManager else null
	var rs: RivalSystem = GameManager.rival_system if GameManager else null
	var ms: MediaSystem = GameManager.media_system if GameManager else null
	if not cs:
		return
		
	for c in vbox_entries.get_children():
		c.queue_free()
		
	if current_tab == 0:
		label_title.text = "Hit Parade — Top 10 Continentale Ufficiale"
		label_subtitle.text = "Settimana %d | Basata su ascolti streaming e vendite aggregate" % cs.last_updated_week
		_render_chart_list(cs.top_singles, "stream")
	elif current_tab == 1:
		var cur_city: int = supported_cities[selected_city_idx]
		var c_name: String = Enums.get_city_name(cur_city)
		label_title.text = "Hit Parade Nazionale / Territoriale — %s" % c_name
		label_subtitle.text = "Usa Freccia Sinistra / Destra per cambiare città. Top 5 Singoli locali:"
		var terr_entries: Array[ChartEntryData] = cs.get_territorial_chart(cur_city, false)
		_render_chart_list(terr_entries, "ascolti locali")
	elif current_tab == 2:
		label_title.text = "La Scena Musicale — Artisti Rivali & Relazioni"
		label_subtitle.text = "10 Band Continentali | Tasto T per proporre Tour Congiunto, D per Dissing"
		_render_rivals_list(rs)
	elif current_tab == 3:
		label_title.text = "Media Broadcaster & Rassegna Stampa"
		label_subtitle.text = "Emittenti Radio / TV per interviste promozionali e rassegna critica"
		_render_media_list(ms)

func _render_chart_list(entries: Array[ChartEntryData], metric_label: String) -> void:
	if entries.is_empty():
		var lbl_empty := Label.new()
		lbl_empty.text = "Nessun dato di classifica disponibile per questa selezione."
		vbox_entries.add_child(lbl_empty)
		return
		
	for e in entries:
		var panel := PanelContainer.new()
		var hbox := HBoxContainer.new()
		panel.add_child(hbox)
		
		if e.is_player:
			var sb := StyleBoxFlat.new()
			sb.bg_color = Color(0.15, 0.25, 0.35, 1.0)
			sb.border_color = Color(0.4, 0.8, 1.0, 1.0)
			sb.border_width_left = 3
			sb.border_width_right = 3
			sb.border_width_top = 2
			sb.border_width_bottom = 2
			panel.add_theme_stylebox_override("panel", sb)
			
		var lbl_rank := Label.new()
		lbl_rank.custom_minimum_size = Vector2(45, 0)
		lbl_rank.text = "#%d" % e.rank
		lbl_rank.add_theme_font_size_override("font_size", 18)
		lbl_rank.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2) if e.rank == 1 else Color(1, 1, 1))
		hbox.add_child(lbl_rank)
		
		var lbl_mov := Label.new()
		lbl_mov.custom_minimum_size = Vector2(65, 0)
		lbl_mov.text = e.get_movement_symbol()
		if e.is_new_entry():
			lbl_mov.add_theme_color_override("font_color", Color(0.3, 1.0, 0.5))
		elif e.get_movement_delta() > 0:
			lbl_mov.add_theme_color_override("font_color", Color(0.4, 0.9, 0.4))
		elif e.get_movement_delta() < 0:
			lbl_mov.add_theme_color_override("font_color", Color(1.0, 0.4, 0.4))
		else:
			lbl_mov.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
		hbox.add_child(lbl_mov)
		
		var vbox_info := VBoxContainer.new()
		vbox_info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var lbl_t := Label.new()
		lbl_t.text = "%s — %s%s" % [e.title, e.artist_name, " (TUA BAND)" if e.is_player else ""]
		lbl_t.add_theme_font_size_override("font_size", 16)
		vbox_info.add_child(lbl_t)
		
		var lbl_sub := Label.new()
		lbl_sub.text = "%d %s | Settimane: %d | Picco: #%d" % [e.metric_value, metric_label, e.weeks_on_chart, e.peak_rank]
		lbl_sub.add_theme_color_override("font_color", Color(0.7, 0.75, 0.8))
		vbox_info.add_child(lbl_sub)
		
		hbox.add_child(vbox_info)
		vbox_entries.add_child(panel)

func _render_rivals_list(rs: RivalSystem) -> void:
	if not rs or rs.rivals.is_empty():
		var lbl_empty := Label.new()
		lbl_empty.text = "Nessuna band rivale registrata nella scena."
		vbox_entries.add_child(lbl_empty)
		return
		
	for r: RivalData in rs.get_all_rivals():
		var panel := PanelContainer.new()
		var vbox := VBoxContainer.new()
		panel.add_child(vbox)
		
		var city_name: String = Enums.get_city_name(r.home_city_id)
		var genre_name: String = Enums.get_genre_name(r.genre)
		var rel_name: String = Enums.get_rival_relationship_name(r.relationship)
		
		var lbl_name := Label.new()
		lbl_name.text = "%s (%s - %s) — Popolarità: %.1f | Relazione: %s (Affinità: %.1f/100)" % [
			r.name, city_name, genre_name, r.popularity, rel_name, r.affinity_score
		]
		lbl_name.add_theme_font_size_override("font_size", 16)
		if r.relationship == Enums.RivalRelationship.OPEN_FEUD:
			lbl_name.add_theme_color_override("font_color", Color(1.0, 0.4, 0.3))
		elif r.co_headlining_eligible:
			lbl_name.add_theme_color_override("font_color", Color(0.4, 1.0, 0.6))
		vbox.add_child(lbl_name)
		
		var lbl_details := Label.new()
		var co_head_str: String = "Idoneo Co-Headlining Tour" if r.co_headlining_eligible else "Non disponibile per tour"
		lbl_details.text = "Singolo: \"%s\" (Score: %.1f) | %s" % [
			r.current_single_title, r.current_single_score, co_head_str
		]
		lbl_details.add_theme_color_override("font_color", Color(0.75, 0.8, 0.85))
		vbox.add_child(lbl_details)
		
		# Pulsanti interazione accessibili
		var hbox_actions := HBoxContainer.new()
		var btn_praise := Button.new()
		btn_praise.text = "Tributo / Elogio (+15 Affinità)"
		btn_praise.pressed.connect(func():
			var res: Dictionary = rs.praise_rival(r.id)
			AccessibilityManager.announce(str(res.get("message", "")), true)
			refresh_view()
		)
		hbox_actions.add_child(btn_praise)
		
		var btn_tour := Button.new()
		btn_tour.text = "Proponi Co-Headlining Tour"
		btn_tour.pressed.connect(func():
			var res: Dictionary = rs.propose_co_headlining(r.id)
			AccessibilityManager.announce(str(res.get("message", "")), true)
			refresh_view()
		)
		hbox_actions.add_child(btn_tour)
		
		var btn_diss := Button.new()
		btn_diss.text = "Lancia Dissing Mediatico"
		btn_diss.pressed.connect(func():
			var cur_day: int = GameManager.calendar_data.current_day if GameManager and GameManager.calendar_data else 1
			var res: Dictionary = rs.trigger_dissing(r.id, cur_day)
			AccessibilityManager.announce(str(res.get("message", "")), true)
			refresh_view()
		)
		hbox_actions.add_child(btn_diss)
		vbox.add_child(hbox_actions)
		
		vbox_entries.add_child(panel)

func _render_media_list(ms: MediaSystem) -> void:
	if not ms:
		return
		
	var cur_city: int = GameManager.player_data.current_city_id if GameManager and GameManager.player_data else Enums.CityId.MILANO
	var city_name: String = Enums.get_city_name(cur_city)
	
	var lbl_outlets_header := Label.new()
	lbl_outlets_header.text = "Emittenti Accreditate a %s per Interviste del Mattino:" % city_name
	lbl_outlets_header.add_theme_font_size_override("font_size", 16)
	lbl_outlets_header.add_theme_color_override("font_color", Color(0.4, 0.8, 1.0))
	vbox_entries.add_child(lbl_outlets_header)
	
	var city_outlets: Array[MediaOutletData] = ms.get_outlets_for_city(cur_city)
	if city_outlets.is_empty():
		var lbl_none := Label.new()
		lbl_none.text = "Nessuna emittente locale registrata per questa città."
		vbox_entries.add_child(lbl_none)
	else:
		var cur_day: int = GameManager.calendar_data.current_day if GameManager and GameManager.calendar_data else 1
		for o: MediaOutletData in city_outlets:
			var panel := PanelContainer.new()
			var vbox := VBoxContainer.new()
			panel.add_child(vbox)
			
			var lbl_o := Label.new()
			lbl_o.text = "%s (%s) — Ascoltatori: %d | Hype: +%.1f | Rep: +%.1f" % [
				o.name, o.get_type_name(), o.reach_listeners, o.hype_yield, o.reputation_yield
			]
			vbox.add_child(lbl_o)
			
			var btn_interview := Button.new()
			btn_interview.text = "Sostieni Intervista (Consumo: %d Energia)" % o.interview_cost_energy
			var check: Dictionary = ms.can_do_interview(o.id, cur_day)
			if not check.get("allowed", false):
				btn_interview.disabled = true
				btn_interview.text += " [Non disponibile: %s]" % str(check.get("reason", ""))
			else:
				btn_interview.pressed.connect(func():
					var res: Dictionary = ms.conduct_interview(o.id, cur_day)
					AccessibilityManager.announce(str(res.get("message", "")), true)
					refresh_view()
				)
			vbox.add_child(btn_interview)
			vbox_entries.add_child(panel)
			
	var lbl_press_header := Label.new()
	lbl_press_header.text = "\nRassegna Stampa & Giudizi della Critica:"
	lbl_press_header.add_theme_font_size_override("font_size", 16)
	lbl_press_header.add_theme_color_override("font_color", Color(1.0, 0.85, 0.4))
	vbox_entries.add_child(lbl_press_header)
	
	if ms.press_reviews.is_empty():
		var lbl_empty_press := Label.new()
		lbl_empty_press.text = "Nessun articolo o recensione pubblicato di recente."
		vbox_entries.add_child(lbl_empty_press)
	else:
		for rev in ms.press_reviews:
			var panel_p := PanelContainer.new()
			var vbox_p := VBoxContainer.new()
			panel_p.add_child(vbox_p)
			
			var lbl_pr := Label.new()
			lbl_pr.text = "Giorno %d — '%s' su %s (Voto: %.1f/5.0 stelle)" % [
				int(rev.get("day", 1)), str(rev.get("work_title", "")), str(rev.get("outlet", "")), float(rev.get("rating_stars", 3.0))
			]
			lbl_pr.add_theme_font_size_override("font_size", 14)
			vbox_p.add_child(lbl_pr)
			
			var lbl_pc := Label.new()
			lbl_pc.text = "Critico %s: \"%s\"" % [str(rev.get("reviewer", "")), str(rev.get("comment", ""))]
			lbl_pc.add_theme_color_override("font_color", Color(0.8, 0.85, 0.9))
			vbox_p.add_child(lbl_pc)
			
			vbox_entries.add_child(panel_p)

func _announce_current_view() -> void:
	var cs: ChartSystem = GameManager.chart_system if GameManager else null
	var rs: RivalSystem = GameManager.rival_system if GameManager else null
	var ms: MediaSystem = GameManager.media_system if GameManager else null
	if current_tab == 0 and cs:
		AccessibilityManager.announce(cs.get_charts_speech(0), true)
	elif current_tab == 1 and cs:
		var cur_city: int = supported_cities[selected_city_idx]
		AccessibilityManager.announce(cs.get_territorial_charts_speech(cur_city, 0), true)
	elif current_tab == 2 and rs:
		var lines: Array[String] = []
		lines.append("Elenco Artisti e Band Rivali della Scena:")
		for r in rs.get_all_rivals():
			var rel: String = Enums.get_rival_relationship_name(r.relationship)
			var coh: String = "Idoneo a tour" if r.co_headlining_eligible else "Non idoneo a tour"
			lines.append("Band: %s da %s. Genere %s. Popolarità %.1f. Relazione: %s (%s). Singolo: %s." % [
				r.name, Enums.get_city_name(r.home_city_id), Enums.get_genre_name(r.genre), r.popularity, rel, coh, r.current_single_title
			])
		AccessibilityManager.announce("\n".join(lines), true)
	elif current_tab == 3 and ms:
		var lines: Array[String] = []
		lines.append("Media, Emittenti e Rassegna Stampa:")
		var cur_city: int = GameManager.player_data.current_city_id if GameManager and GameManager.player_data else Enums.CityId.MILANO
		var outlets: Array[MediaOutletData] = ms.get_outlets_for_city(cur_city)
		lines.append("Emittenti a %s:" % Enums.get_city_name(cur_city))
		for o in outlets:
			lines.append("%s (%s), raggiunge %d ascoltatori, costo %d energia." % [o.name, o.get_type_name(), o.reach_listeners, o.interview_cost_energy])
		lines.append(ms.get_press_speech())
		AccessibilityManager.announce("\n".join(lines), true)
