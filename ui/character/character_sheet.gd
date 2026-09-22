# res://ui/character/character_sheet.gd
extends Control

## Controller della Scheda Personaggio e Profilo Artistico di World-tour
## Permette a Luca (NVDA/tastiera) e a Holy Diver (a monitor) di consultare
## tutte le caratteristiche, necessità vitali e livelli delle 7 abilità del musicista.

signal closed()

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var label_subtitle: Label = $PanelMain/VBox/Header/LabelSubtitle

# Informazioni anagrafiche e status
@onready var label_name: Label = $PanelMain/VBox/HBoxBody/VBoxLeft/LabelName
@onready var label_instrument: Label = $PanelMain/VBox/HBoxBody/VBoxLeft/LabelInstrument
@onready var label_background: Label = $PanelMain/VBox/HBoxBody/VBoxLeft/LabelBackground
@onready var label_trait: Label = $PanelMain/VBox/HBoxBody/VBoxLeft/LabelTrait
@onready var label_career: Label = $PanelMain/VBox/HBoxBody/VBoxLeft/LabelCareer
@onready var label_fame: Label = $PanelMain/VBox/HBoxBody/VBoxLeft/LabelFame

# Fisiologia e bisogni
@onready var label_vitals: Label = $PanelMain/VBox/HBoxBody/VBoxLeft/LabelVitals
@onready var label_finance: Label = $PanelMain/VBox/HBoxBody/VBoxLeft/LabelFinance

# Contenitore abilità
@onready var vbox_skills: VBoxContainer = $PanelMain/VBox/HBoxBody/VBoxRight/ScrollSkills/VBoxSkillsList

# Pulsante chiudi
@onready var btn_close: Button = $PanelMain/VBox/HBoxBottom/BtnClose

func _ready() -> void:
	btn_close.pressed.connect(_on_btn_close_pressed)
	AccessibilityManager.hook_control_accessibility(
		btn_close,
		"Chiudi Scheda Personaggio",
		"Chiude la scheda del musicista e ritorna alla schermata principale dell'HUD."
	)

func _resolve_nodes() -> void:
	if not label_title:
		label_title = get_node_or_null("PanelMain/VBox/Header/LabelTitle")
		label_subtitle = get_node_or_null("PanelMain/VBox/Header/LabelSubtitle")
		label_name = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxLeft/LabelName")
		label_instrument = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxLeft/LabelInstrument")
		label_background = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxLeft/LabelBackground")
		label_trait = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxLeft/LabelTrait")
		label_career = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxLeft/LabelCareer")
		label_fame = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxLeft/LabelFame")
		label_vitals = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxLeft/LabelVitals")
		label_finance = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxLeft/LabelFinance")
		vbox_skills = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxRight/ScrollSkills/VBoxSkillsList")
		btn_close = get_node_or_null("PanelMain/VBox/HBoxBottom/BtnClose")

func open() -> void:
	visible = true
	refresh_sheet()
	if btn_close:
		btn_close.grab_focus()

func refresh_sheet() -> void:
	_resolve_nodes()
	if not label_title or not vbox_skills or not GameManager or not GameManager.player_data:
		return
		
	var player: PlayerData = GameManager.player_data
	var career_name: String = "Principiante"
	if GameManager.career_system:
		career_name = GameManager.career_system.get_tier_name(player.career_tier)
		
	label_title.text = "Scheda Musicista — %s" % player.player_name
	label_name.text = "Nome d'arte: %s" % player.player_name
	label_instrument.text = "Strumento Primario: %s" % player.primary_instrument
	label_background.text = "Origine / Background: %s" % player.get_background_name()
	label_trait.text = "Tratto Personale: %s" % player.get_trait_name()
	label_career.text = "Status Carriera: %s" % career_name
	label_fame.text = "Fan: %d | Popolarità: %.1f%% | Reputazione: %.1f" % [
		player.fans,
		player.popularity,
		player.reputation
	]
	
	# Vitals & Finanze
	var runway_str: String = "Sostenibile"
	if GameManager.economy_system:
		var days: float = GameManager.economy_system.get_financial_runway_days()
		runway_str = "%d giorni" % int(days) if days < 900.0 else "Illimitata"
		
	label_vitals.text = "Condizione: Energia %d%% | Stress %d%% | Morale %d%%" % [
		player.energy,
		player.stress,
		player.morale
	]
	label_finance.text = "Finanze: Saldo %.2f € | Spese Fisse: 25.00 €/notte | Autonomia: %s" % [
		player.money,
		runway_str
	]
	
	# Popolamento Matrice Abilità
	for c in vbox_skills.get_children():
		c.queue_free()
		
	var key_skills: Array[String] = [
		"instrument", "vocals", "composition", "songwriting",
		"production", "performance", "charisma"
	]
	
	var ss: SkillSystem = GameManager.skill_system
	for s_key in key_skills:
		var s_name: String = ss.get_skill_name(s_key) if ss else s_key.capitalize()
		var s_lvl: int = ss.get_skill_level(s_key) if ss else 10
		var s_xp: float = ss.get_skill_xp(s_key) if ss else 0.0
		var req_xp: int = ss.get_xp_for_next_level(s_key) if ss else 100
		
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		
		var lbl_name := Label.new()
		lbl_name.custom_minimum_size = Vector2(170, 0)
		lbl_name.text = "%s (Liv. %d):" % [s_name, s_lvl]
		lbl_name.add_theme_font_size_override("font_size", 15)
		
		var lbl_xp := Label.new()
		lbl_xp.text = "XP %.1f / %d" % [s_xp, req_xp]
		lbl_xp.add_theme_font_size_override("font_size", 14)
		lbl_xp.modulate = Color(0.8, 0.85, 0.95, 1)
		
		row.add_child(lbl_name)
		row.add_child(lbl_xp)
		vbox_skills.add_child(row)
		
	# Annuncio vocale sintetico per NVDA
	var date_str: String = "Giorno %d" % (GameManager.calendar_data.day_number if GameManager.calendar_data else 1)
	if GameManager and GameManager.calendar_data:
		date_str = GameManager.calendar_data.get_full_date_string()
		
	var upcoming_count: int = 0
	if GameManager and GameManager.schedule_system:
		upcoming_count = GameManager.schedule_system.get_upcoming_events(7).size()
		
	var speech: String = "Scheda Personaggio di %s. Data: %s. Strumento: %s. Background: %s. Tratto: %s. Status: %s. Energia: %d%%, Stress: %d%%, Morale: %d%%. Saldo: %.2f euro. Impegni in agenda: %d nei prossimi 7 giorni. Premi A per ascoltare l'agenda o Esc per tornare all'HUD." % [
		player.player_name,
		date_str,
		player.primary_instrument,
		player.get_background_name(),
		player.get_trait_name(),
		career_name,
		player.energy,
		player.stress,
		player.morale,
		player.money,
		upcoming_count
	]
	AccessibilityManager.announce(speech, true)

func _on_btn_close_pressed() -> void:
	visible = false
	closed.emit()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var key_event := event as InputEventKey
		if key_event.keycode == KEY_ESCAPE or key_event.keycode == KEY_C:
			_on_btn_close_pressed()
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_A:
			if GameManager and GameManager.schedule_system:
				var agenda_speech: String = GameManager.schedule_system.get_linear_agenda_speech(7)
				AccessibilityManager.announce(agenda_speech, true)
			get_viewport().set_input_as_handled()
