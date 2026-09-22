# res://ui/charts/chart_modal.gd
extends Control

## Controller della Schermata Classifiche Musicali & Artisti Rivali (World-tour F8.5 / SP-13)
## Accessibilità 100% tastiera e sintesi vocale NVDA per Luca,
## grafica responsive ad alto contrasto per Holy Diver.

signal closed()

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var label_subtitle: Label = $PanelMain/VBox/Header/LabelSubtitle
@onready var btn_tab_singles: Button = $PanelMain/VBox/HBoxTabs/BtnTabSingles
@onready var btn_tab_albums: Button = $PanelMain/VBox/HBoxTabs/BtnTabAlbums
@onready var btn_tab_rivals: Button = $PanelMain/VBox/HBoxTabs/BtnTabRivals

@onready var scroll_entries: ScrollContainer = $PanelMain/VBox/PanelBody/Margin/VBoxBody/ScrollEntries
@onready var vbox_entries: VBoxContainer = $PanelMain/VBox/PanelBody/Margin/VBoxBody/ScrollEntries/VBoxEntries
@onready var label_status: Label = $PanelMain/VBox/LabelStatus
@onready var btn_close: Button = $PanelMain/VBox/HBoxBottom/BtnClose

var current_tab: int = 0 # 0 = Singoli, 1 = Album, 2 = Rivali

func _ready() -> void:
	btn_close.pressed.connect(close)
	AccessibilityManager.hook_control_accessibility(btn_close, "Chiudi Finestra Classifiche", "Chiude la schermata delle classifiche e torna all'HUD.")
	
	btn_tab_singles.pressed.connect(func(): _set_tab(0))
	btn_tab_albums.pressed.connect(func(): _set_tab(1))
	btn_tab_rivals.pressed.connect(func(): _set_tab(2))
	
	AccessibilityManager.hook_control_accessibility(btn_tab_singles, "1: Top 10 Singoli", "Visualizza la classifica settimanale dei singoli.")
	AccessibilityManager.hook_control_accessibility(btn_tab_albums, "2: Top 10 Album", "Visualizza la classifica settimanale degli album ed EP.")
	AccessibilityManager.hook_control_accessibility(btn_tab_rivals, "R: Artisti Rivali", "Visualizza l'elenco delle band concorrenti della scena.")
	
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
		elif event.keycode == KEY_R:
			_set_tab(2)
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
	AccessibilityManager.announce("Schermata classifiche chiusa.", true)

func _set_tab(tab_idx: int) -> void:
	current_tab = tab_idx
	refresh_view()
	_announce_current_view()

func refresh_view() -> void:
	var cs: ChartSystem = GameManager.chart_system if GameManager else null
	var rs: RivalSystem = GameManager.rival_system if GameManager else null
	if not cs:
		return
		
	# Pulizia lista
	for c in vbox_entries.get_children():
		c.queue_free()
		
	if current_tab == 0:
		label_title.text = "Hit Parade — Top 10 Singoli della Settimana"
		label_subtitle.text = "Settimana %d | Basata su ascolti streaming e rotazione radiofonica" % cs.last_updated_week
		_render_chart_list(cs.top_singles, "stream")
	elif current_tab == 1:
		label_title.text = "Hit Parade — Top 10 Album & EP della Settimana"
		label_subtitle.text = "Settimana %d | Basata su vendite complessive e streaming aggregato" % cs.last_updated_week
		_render_chart_list(cs.top_albums, "copie")
	else:
		label_title.text = "La Scena Musicale — Artisti e Band Rivali"
		label_subtitle.text = "Concorrenti attivi nelle 6 metropoli e livelli di rivalità"
		_render_rivals_list(rs)

func _render_chart_list(entries: Array[ChartEntryData], metric_label: String) -> void:
	if entries.is_empty():
		var lbl_empty := Label.new()
		lbl_empty.text = "Nessun dato di classifica disponibile per questa settimana."
		vbox_entries.add_child(lbl_empty)
		return
		
	for e in entries:
		var panel := PanelContainer.new()
		var hbox := HBoxContainer.new()
		panel.add_child(hbox)
		
		# Evidenziazione opere della band del giocatore
		if e.is_player:
			var sb := StyleBoxFlat.new()
			sb.bg_color = Color(0.15, 0.25, 0.35, 1.0)
			sb.border_color = Color(0.4, 0.8, 1.0, 1.0)
			sb.border_width_left = 3
			sb.border_width_right = 3
			sb.border_width_top = 2
			sb.border_width_bottom = 2
			panel.add_theme_stylebox_override("panel", sb)
			
		# Rank (#1..#10)
		var lbl_rank := Label.new()
		lbl_rank.custom_minimum_size = Vector2(45, 0)
		lbl_rank.text = "#%d" % e.rank
		lbl_rank.add_theme_font_size_override("font_size", 18)
		lbl_rank.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2) if e.rank == 1 else Color(1, 1, 1))
		hbox.add_child(lbl_rank)
		
		# Movimento
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
		
		# Titolo & Artista
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
		
		var rivalry_str: String = "Neutro"
		if r.rivalry_level == 1:
			rivalry_str = "Competizione Accesa"
		elif r.rivalry_level == 2:
			rivalry_str = "Faida Aperta / Nemici"
			
		var lbl_name := Label.new()
		lbl_name.text = "%s (%s - %s) — Popolarità: %.1f | Rivalità: %s" % [r.name, city_name, genre_name, r.popularity, rivalry_str]
		lbl_name.add_theme_font_size_override("font_size", 16)
		if r.rivalry_level == 2:
			lbl_name.add_theme_color_override("font_color", Color(1.0, 0.4, 0.3))
		vbox.add_child(lbl_name)
		
		var lbl_details := Label.new()
		lbl_details.text = "Singolo: \"%s\" (Qualità: %.1f) | Album: \"%s\" (Qualità: %.1f)" % [
			r.current_single_title, r.current_single_score,
			r.current_album_title, r.current_album_score
		]
		lbl_details.add_theme_color_override("font_color", Color(0.75, 0.8, 0.85))
		vbox.add_child(lbl_details)
		
		vbox_entries.add_child(panel)

func _announce_current_view() -> void:
	var cs: ChartSystem = GameManager.chart_system if GameManager else null
	var rs: RivalSystem = GameManager.rival_system if GameManager else null
	if current_tab == 0 and cs:
		AccessibilityManager.announce(cs.get_charts_speech(0), true)
	elif current_tab == 1 and cs:
		AccessibilityManager.announce(cs.get_charts_speech(1), true)
	elif current_tab == 2 and rs:
		var lines: Array[String] = []
		lines.append("Elenco Artisti e Band Rivali della Scena:")
		for r in rs.get_all_rivals():
			lines.append("Band: %s da %s. Genere %s. Popolarità %.1f. Singolo: %s." % [
				r.name, Enums.get_city_name(r.home_city_id), Enums.get_genre_name(r.genre), r.popularity, r.current_single_title
			])
		AccessibilityManager.announce("\n".join(lines), true)
