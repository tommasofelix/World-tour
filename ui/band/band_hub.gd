# res://ui/band/band_hub.gd
extends Control

## Controller della Schermata di Gestione della Band e Dinamiche Umane (World-tour V2.0)
## Gestisce la formazione dei membri, la bacheca audizioni, la chimica di gruppo e il Revenue Split.
## Accessibile con NVDA e con interfaccia ad alto contrasto per monitor.

signal closed()

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var label_chemistry: Label = $PanelMain/VBox/Header/LabelChemistry

@onready var vbox_members_list: VBoxContainer = $PanelMain/VBox/HBoxBody/VBoxMembers/ScrollMembers/VBoxMembersList
@onready var label_no_members: Label = $PanelMain/VBox/HBoxBody/VBoxMembers/LabelNoMembers

@onready var vbox_candidates_list: VBoxContainer = $PanelMain/VBox/HBoxBody/VBoxAuditions/ScrollAuditions/VBoxCandidatesList
@onready var btn_refresh_candidates: Button = $PanelMain/VBox/HBoxBody/VBoxAuditions/BtnRefreshCandidates

@onready var opt_revenue_split: OptionButton = $PanelMain/VBox/HBoxBottom/HBoxSplit/OptRevenueSplit
@onready var btn_close: Button = $PanelMain/VBox/HBoxBottom/BtnClose

func _ready() -> void:
	btn_close.pressed.connect(close)
	btn_refresh_candidates.pressed.connect(_on_refresh_candidates_pressed)
	opt_revenue_split.item_selected.connect(_on_revenue_split_selected)
	
	_setup_split_options()
	_setup_accessibility_hooks()

func _resolve_nodes() -> void:
	if not label_title:
		label_title = get_node_or_null("PanelMain/VBox/Header/LabelTitle")
		label_chemistry = get_node_or_null("PanelMain/VBox/Header/LabelChemistry")
		vbox_members_list = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxMembers/ScrollMembers/VBoxMembersList")
		label_no_members = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxMembers/LabelNoMembers")
		vbox_candidates_list = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxAuditions/ScrollAuditions/VBoxCandidatesList")
		btn_refresh_candidates = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxAuditions/BtnRefreshCandidates")
		opt_revenue_split = get_node_or_null("PanelMain/VBox/HBoxBottom/HBoxSplit/OptRevenueSplit")
		btn_close = get_node_or_null("PanelMain/VBox/HBoxBottom/BtnClose")

func _setup_split_options() -> void:
	_resolve_nodes()
	if not opt_revenue_split:
		return
	opt_revenue_split.clear()
	opt_revenue_split.add_item(tr("SPLIT_EQUAL"), Enums.RevenueSplit.EQUAL_SPLIT)
	opt_revenue_split.add_item(tr("SPLIT_LEADER_BALANCED"), Enums.RevenueSplit.LEADER_BALANCED)
	opt_revenue_split.add_item(tr("SPLIT_LEADER_PREDATORY"), Enums.RevenueSplit.LEADER_PREDATORY)
	
	if GameManager and GameManager.player_data:
		opt_revenue_split.select(GameManager.player_data.revenue_split_mode)

func _setup_accessibility_hooks() -> void:
	_resolve_nodes()
	if btn_close:
		AccessibilityManager.hook_control_accessibility(btn_close, "Chiudi Gestione Band", "Tasto rapido Esc o G. Ritorna all'HUD di gioco.")
	if btn_refresh_candidates:
		AccessibilityManager.hook_control_accessibility(btn_refresh_candidates, "Aggiorna Bacheca Audizioni", "Genera una nuova lista di musicisti in cerca di ingaggio.")

func open() -> void:
	visible = true
	refresh_hub()
	_resolve_nodes()
	if btn_close:
		btn_close.grab_focus()

func close() -> void:
	visible = false
	closed.emit()

func refresh_hub() -> void:
	_resolve_nodes()
	if not label_title or not GameManager or not GameManager.player_data:
		return
		
	var player: PlayerData = GameManager.player_data
	var band_sys: BandSystem = GameManager.band_system
	
	label_title.text = "Gestione Band — %s" % player.band_name
	
	# Chimica & Sinergia
	var avg_aff: float = band_sys.get_average_affinity() if band_sys else 50.0
	var avg_resp: float = band_sys.get_average_respect() if band_sys else 50.0
	var avg_tens: float = band_sys.get_average_tension() if band_sys else 0.0
	var synergy: float = band_sys.get_band_synergy_bonus() if band_sys else 0.0
	
	label_chemistry.text = "Chimica: Affinità %.0f%% | Rispetto %.0f%% | Tensione %.0f%% | Bonus Palco: %+.1f%%" % [
		avg_aff,
		avg_resp,
		avg_tens,
		synergy
	]
	
	# Membri attivi
	for c in vbox_members_list.get_children():
		c.queue_free()
		
	var active_members: Array[BandMemberData] = player.get_active_band_members()
	if active_members.is_empty():
		label_no_members.visible = true
	else:
		label_no_members.visible = false
		for m in active_members:
			var row := _create_member_row(m)
			vbox_members_list.add_child(row)
			
	# Candidati audizioni
	for c in vbox_candidates_list.get_children():
		c.queue_free()
		
	if band_sys:
		for cand in band_sys.candidates_pool:
			var row := _create_candidate_row(cand)
			vbox_candidates_list.add_child(row)
			
	# Annuncio vocale sintetico per NVDA
	var speech: String = "Gestione Band %s. Membri attivi: %d su 3. Chimica generale: Affinità %.0f%%, Rispetto %.0f%%, Tensione %.0f%%. Premi G o Esc per chiudere." % [
		player.band_name,
		active_members.size(),
		avg_aff,
		avg_resp,
		avg_tens
	]
	AccessibilityManager.announce(speech, true)

func _create_member_row(member: BandMemberData) -> Control:
	var panel := PanelContainer.new()
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)
	
	var lbl_info := Label.new()
	lbl_info.custom_minimum_size = Vector2(280, 0)
	lbl_info.text = "%s (%s, Liv. %d)\nTratto: %s | Genere: %s\nAffinità: %.0f%% | Rispetto: %.0f%% | Tensione: %.0f%%" % [
		member.member_name,
		member.get_role_name(),
		member.skill_level,
		member.get_personality_name(),
		member.get_genre_name(),
		member.affinity,
		member.musical_respect,
		member.tension
	]
	lbl_info.add_theme_font_size_override("font_size", 13)
	
	var btn_fire := Button.new()
	btn_fire.text = "Licenzia"
	btn_fire.pressed.connect(func():
		if GameManager.band_system:
			GameManager.band_system.fire_member(member.id)
			refresh_hub()
	)
	AccessibilityManager.hook_control_accessibility(btn_fire, "Licenzia %s" % member.member_name, "Rimuove il musicista dalla formazione della band.")
	
	hbox.add_child(lbl_info)
	hbox.add_child(btn_fire)
	panel.add_child(hbox)
	return panel

func _create_candidate_row(candidate: BandMemberData) -> Control:
	var panel := PanelContainer.new()
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 10)
	
	var lbl_info := Label.new()
	lbl_info.custom_minimum_size = Vector2(250, 0)
	lbl_info.text = "%s — %s (Liv. %d)\nTratto: %s | Genere: %s" % [
		candidate.member_name,
		candidate.get_role_name(),
		candidate.skill_level,
		candidate.get_personality_name(),
		candidate.get_genre_name()
	]
	lbl_info.add_theme_font_size_override("font_size", 13)
	
	var btn_hire := Button.new()
	btn_hire.text = "Ingaggia"
	btn_hire.pressed.connect(func():
		if GameManager.band_system:
			var res: Dictionary = GameManager.band_system.hire_candidate(candidate)
			if not res.get("success", false):
				AccessibilityManager.announce(res.get("message", "Impossibile ingaggiare."), true)
			refresh_hub()
	)
	AccessibilityManager.hook_control_accessibility(btn_hire, "Ingaggia %s" % candidate.member_name, "Aggiunge il musicista alla band nel ruolo di %s." % candidate.get_role_name())
	
	hbox.add_child(lbl_info)
	hbox.add_child(btn_hire)
	panel.add_child(hbox)
	return panel

func _on_refresh_candidates_pressed() -> void:
	if GameManager and GameManager.band_system:
		GameManager.band_system.refresh_candidates_pool()
		refresh_hub()

func _on_revenue_split_selected(index: int) -> void:
	var mode: int = opt_revenue_split.get_item_id(index)
	if GameManager and GameManager.band_system:
		GameManager.band_system.set_revenue_split(mode)
		refresh_hub()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_G:
			close()
			get_viewport().set_input_as_handled()
