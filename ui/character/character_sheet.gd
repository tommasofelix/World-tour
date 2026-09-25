# res://ui/character/character_sheet.gd
extends Control

## Controller della Scheda Personaggio e Profilo Artistico di World-tour (V5.7.1)
## Gestisce la consultazione a 2 Sezioni Tabulate:
## - Scheda 1: Profilo Artistico, Status Carriera, Vitals e i 4 Attributi Fisiologici Innati;
## - Scheda 2: Albero delle Competenze a 6 Rami (28 abilità canoniche, gradi stellari, propedeuticità).
## Progettato per Simmetria Universale (Luca con NVDA/tastiera Zero Mouse e Holy Diver a monitor).

signal closed()

const BRANCH_NAMES: Dictionary = {
	"genre_mastery": "Cultura & Padronanza dei Generi Musicali",
	"instrumental_technique": "Competenze Strumentali & Vocali",
	"songwriting_harmony": "Composizione, Armonia & Scrittura",
	"stage_showmanship": "Palco, Spettacolo & Intrattenimento",
	"engineering_hardware": "Studio, Suono & Liuteria",
	"industry_business": "Business, Media & Relazioni Industriali"
}

# Header e Navigazione Schede
@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var label_subtitle: Label = $PanelMain/VBox/Header/LabelSubtitle
@onready var btn_tab_profile: Button = $PanelMain/VBox/HBoxTabs/BtnTabProfile
@onready var btn_tab_skills: Button = $PanelMain/VBox/HBoxTabs/BtnTabSkills

# Contenitori Schede
@onready var hbox_body: HBoxContainer = $PanelMain/VBox/HBoxBody
@onready var panel_tab_skills: VBoxContainer = $PanelMain/VBox/PanelTabSkills

# Scheda 1 — Colonna Sinistra (Anagrafica & Carriera)
@onready var label_name: Label = $PanelMain/VBox/HBoxBody/VBoxLeft/LabelName
@onready var label_instrument: Label = $PanelMain/VBox/HBoxBody/VBoxLeft/LabelInstrument
@onready var label_background: Label = $PanelMain/VBox/HBoxBody/VBoxLeft/LabelBackground
@onready var label_trait: Label = $PanelMain/VBox/HBoxBody/VBoxLeft/LabelTrait
@onready var label_career: Label = $PanelMain/VBox/HBoxBody/VBoxLeft/LabelCareer
@onready var label_fame: Label = $PanelMain/VBox/HBoxBody/VBoxLeft/LabelFame
@onready var label_finance: Label = $PanelMain/VBox/HBoxBody/VBoxLeft/LabelFinance

# Scheda 1 — Colonna Destra (Vitals & Attributi Innati)
@onready var label_vitals: Label = $PanelMain/VBox/HBoxBody/VBoxRight/LabelVitals
@onready var label_musicality: Label = $PanelMain/VBox/HBoxBody/VBoxRight/LabelMusicality
@onready var label_intelligence: Label = $PanelMain/VBox/HBoxBody/VBoxRight/LabelIntelligence
@onready var label_stamina: Label = $PanelMain/VBox/HBoxBody/VBoxRight/LabelStamina
@onready var label_charm: Label = $PanelMain/VBox/HBoxBody/VBoxRight/LabelCharm
@onready var vbox_skills: VBoxContainer = $PanelMain/VBox/HBoxBody/VBoxRight/ScrollSkills/VBoxSkillsList

# Scheda 2 — Albero Competenze
@onready var btn_branch_genre: Button = $PanelMain/VBox/PanelTabSkills/HBoxBranches/BtnBranchGenre
@onready var btn_branch_instrument: Button = $PanelMain/VBox/PanelTabSkills/HBoxBranches/BtnBranchInstrument
@onready var btn_branch_composition: Button = $PanelMain/VBox/PanelTabSkills/HBoxBranches/BtnBranchComposition
@onready var btn_branch_stage: Button = $PanelMain/VBox/PanelTabSkills/HBoxBranches/BtnBranchStage
@onready var btn_branch_tech: Button = $PanelMain/VBox/PanelTabSkills/HBoxBranches/BtnBranchTech
@onready var btn_branch_business: Button = $PanelMain/VBox/PanelTabSkills/HBoxBranches/BtnBranchBusiness

@onready var label_branch_title: Label = $PanelMain/VBox/PanelTabSkills/LabelBranchTitle
@onready var scroll_skills_tree: ScrollContainer = $PanelMain/VBox/PanelTabSkills/ScrollSkillsTree
@onready var vbox_skills_tree_list: VBoxContainer = $PanelMain/VBox/PanelTabSkills/ScrollSkillsTree/VBoxSkillsTreeList
@onready var label_skills_hint: Label = $PanelMain/VBox/PanelTabSkills/LabelSkillsHint

# Barra Inferiore
@onready var btn_close: Button = $PanelMain/VBox/HBoxBottom/BtnClose

var current_tab: int = 1
var current_branch: String = "genre_mastery"

func _ready() -> void:
	_resolve_nodes()
	if btn_close and not btn_close.pressed.is_connected(_on_btn_close_pressed):
		btn_close.pressed.connect(_on_btn_close_pressed)

	if btn_tab_profile and not btn_tab_profile.pressed.is_connected(func(): select_tab(1)):
		btn_tab_profile.pressed.connect(func(): select_tab(1))
	if btn_tab_skills and not btn_tab_skills.pressed.is_connected(func(): select_tab(2)):
		btn_tab_skills.pressed.connect(func(): select_tab(2))

	if btn_branch_genre and not btn_branch_genre.pressed.is_connected(func(): select_branch("genre_mastery")):
		btn_branch_genre.pressed.connect(func(): select_branch("genre_mastery"))
	if btn_branch_instrument and not btn_branch_instrument.pressed.is_connected(func(): select_branch("instrumental_technique")):
		btn_branch_instrument.pressed.connect(func(): select_branch("instrumental_technique"))
	if btn_branch_composition and not btn_branch_composition.pressed.is_connected(func(): select_branch("songwriting_harmony")):
		btn_branch_composition.pressed.connect(func(): select_branch("songwriting_harmony"))
	if btn_branch_stage and not btn_branch_stage.pressed.is_connected(func(): select_branch("stage_showmanship")):
		btn_branch_stage.pressed.connect(func(): select_branch("stage_showmanship"))
	if btn_branch_tech and not btn_branch_tech.pressed.is_connected(func(): select_branch("engineering_hardware")):
		btn_branch_tech.pressed.connect(func(): select_branch("engineering_hardware"))
	if btn_branch_business and not btn_branch_business.pressed.is_connected(func(): select_branch("industry_business")):
		btn_branch_business.pressed.connect(func(): select_branch("industry_business"))

	_hook_accessibility()

func _resolve_nodes() -> void:
	if not label_title:
		label_title = get_node_or_null("PanelMain/VBox/Header/LabelTitle")
		label_subtitle = get_node_or_null("PanelMain/VBox/Header/LabelSubtitle")
		btn_tab_profile = get_node_or_null("PanelMain/VBox/HBoxTabs/BtnTabProfile")
		btn_tab_skills = get_node_or_null("PanelMain/VBox/HBoxTabs/BtnTabSkills")
		hbox_body = get_node_or_null("PanelMain/VBox/HBoxBody")
		panel_tab_skills = get_node_or_null("PanelMain/VBox/PanelTabSkills")

		label_name = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxLeft/LabelName")
		label_instrument = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxLeft/LabelInstrument")
		label_background = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxLeft/LabelBackground")
		label_trait = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxLeft/LabelTrait")
		label_career = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxLeft/LabelCareer")
		label_fame = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxLeft/LabelFame")
		label_finance = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxLeft/LabelFinance")

		label_vitals = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxRight/LabelVitals")
		label_musicality = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxRight/LabelMusicality")
		label_intelligence = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxRight/LabelIntelligence")
		label_stamina = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxRight/LabelStamina")
		label_charm = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxRight/LabelCharm")
		vbox_skills = get_node_or_null("PanelMain/VBox/HBoxBody/VBoxRight/ScrollSkills/VBoxSkillsList")

		btn_branch_genre = get_node_or_null("PanelMain/VBox/PanelTabSkills/HBoxBranches/BtnBranchGenre")
		btn_branch_instrument = get_node_or_null("PanelMain/VBox/PanelTabSkills/HBoxBranches/BtnBranchInstrument")
		btn_branch_composition = get_node_or_null("PanelMain/VBox/PanelTabSkills/HBoxBranches/BtnBranchComposition")
		btn_branch_stage = get_node_or_null("PanelMain/VBox/PanelTabSkills/HBoxBranches/BtnBranchStage")
		btn_branch_tech = get_node_or_null("PanelMain/VBox/PanelTabSkills/HBoxBranches/BtnBranchTech")
		btn_branch_business = get_node_or_null("PanelMain/VBox/PanelTabSkills/HBoxBranches/BtnBranchBusiness")

		label_branch_title = get_node_or_null("PanelMain/VBox/PanelTabSkills/LabelBranchTitle")
		scroll_skills_tree = get_node_or_null("PanelMain/VBox/PanelTabSkills/ScrollSkillsTree")
		vbox_skills_tree_list = get_node_or_null("PanelMain/VBox/PanelTabSkills/ScrollSkillsTree/VBoxSkillsTreeList")
		label_skills_hint = get_node_or_null("PanelMain/VBox/PanelTabSkills/LabelSkillsHint")

		btn_close = get_node_or_null("PanelMain/VBox/HBoxBottom/BtnClose")

func _hook_accessibility() -> void:
	if btn_close:
		AccessibilityManager.hook_control_accessibility(
			btn_close,
			"Chiudi Scheda Personaggio",
			"Chiude la scheda del musicista e ritorna alla visuale dell'appartamento."
		)
	if btn_tab_profile:
		AccessibilityManager.hook_control_accessibility(
			btn_tab_profile,
			"Scheda 1: Profilo e Fisiologia",
			"Visualizza dati artistici, condizione vitale e i 4 attributi fisiologici innati. Tasto rapido 1."
		)
	if btn_tab_skills:
		AccessibilityManager.hook_control_accessibility(
			btn_tab_skills,
			"Scheda 2: Albero delle Competenze",
			"Visualizza le 31 abilità canoniche suddivise nei 6 rami con gradi stellari. Tasto rapido 2."
		)

func open() -> void:
	visible = true
	select_tab(1)
	refresh_sheet()
	_announce_open_summary()

func select_tab(tab_idx: int) -> void:
	_resolve_nodes()
	current_tab = tab_idx

	if current_tab == 1:
		if hbox_body:
			hbox_body.visible = true
		if panel_tab_skills:
			panel_tab_skills.visible = false
		if btn_tab_profile:
			btn_tab_profile.modulate = Color(1.0, 1.0, 1.0, 1.0)
		if btn_tab_skills:
			btn_tab_skills.modulate = Color(0.7, 0.7, 0.7, 1.0)
		if btn_tab_profile:
			btn_tab_profile.grab_focus()
	else:
		if hbox_body:
			hbox_body.visible = false
		if panel_tab_skills:
			panel_tab_skills.visible = true
		if btn_tab_profile:
			btn_tab_profile.modulate = Color(0.7, 0.7, 0.7, 1.0)
		if btn_tab_skills:
			btn_tab_skills.modulate = Color(1.0, 1.0, 1.0, 1.0)
		select_branch(current_branch)

func select_branch(branch_id: String) -> void:
	_resolve_nodes()
	current_branch = branch_id

	var branch_name: String = str(BRANCH_NAMES.get(branch_id, branch_id))
	if label_branch_title:
		label_branch_title.text = "Ramo: %s" % branch_name

	# Evidenziazione pulsante del ramo attivo
	_update_branch_buttons_state()

	# Popolamento abilità del ramo
	_populate_branch_skills(branch_id)

func _update_branch_buttons_state() -> void:
	var btns: Dictionary = {
		"genre_mastery": btn_branch_genre,
		"instrumental_technique": btn_branch_instrument,
		"songwriting_harmony": btn_branch_composition,
		"stage_showmanship": btn_branch_stage,
		"engineering_hardware": btn_branch_tech,
		"industry_business": btn_branch_business
	}
	for b_id in btns:
		var btn: Button = btns[b_id]
		if btn:
			btn.modulate = Color(1.0, 1.0, 1.0, 1.0) if b_id == current_branch else Color(0.65, 0.65, 0.7, 1.0)

func _populate_branch_skills(branch_id: String) -> void:
	if not vbox_skills_tree_list:
		return

	for c in vbox_skills_tree_list.get_children():
		vbox_skills_tree_list.remove_child(c)
		c.queue_free()

	var player: PlayerData = GameManager.player_data if GameManager else null
	if not player:
		return

	var skills: Array[Dictionary] = player.get_branch_skills(branch_id)
	var first_entry: Control = null

	for s in skills:
		var s_id: String = str(s.get("id", ""))
		var s_name: String = str(s.get("name", s_id))
		var s_grade: int = int(s.get("grade", 0))
		var stars_disp: String = player.get_skill_stars_display(s_id)
		var current_xp: float = float(s.get("xp", 0.0))
		var unlock_info: Dictionary = player.can_unlock_skill(s_id)
		var is_unlocked: bool = bool(unlock_info.get("can_unlock", true))
		var req_reason: String = str(unlock_info.get("reason", ""))

		var req_xp: float = float(PlayerData.SKILL_GRADE_THRESHOLDS.get(s_grade, 2000.0)) if s_grade < 5 else 2000.0

		# Creazione riga interattiva focusabile
		var row := Button.new()
		row.custom_minimum_size = Vector2(0, 44)
		row.focus_mode = Control.FOCUS_ALL
		row.alignment = HORIZONTAL_ALIGNMENT_LEFT

		var status_text: String = ""
		var accessible_text: String = ""

		if not is_unlocked and s_grade == 0:
			status_text = "[BLOCCATA] %s" % req_reason
			row.modulate = Color(0.7, 0.5, 0.5, 1.0)
			accessible_text = "%s. Non appresa. BLOCCATA. %s." % [s_name, req_reason]
		elif s_grade >= 5:
			status_text = "Maestro Leggendario (Cap 2000 XP)"
			row.modulate = Color(1.0, 0.9, 0.4, 1.0)
			accessible_text = "%s. %s. Grado massimo raggiunto." % [s_name, stars_disp]
		else:
			status_text = "XP %.1f / %d" % [current_xp, int(req_xp)]
			row.modulate = Color(0.85, 0.95, 1.0, 1.0)
			accessible_text = "%s. %s. Esperienza: %.0f su %d punti. Sbloccata." % [
				s_name, stars_disp, current_xp, int(req_xp)
			]

		row.text = "  %s  |  %s  |  %s" % [s_name, stars_disp, status_text]

		# Hook accessibilità NVDA
		AccessibilityManager.hook_control_accessibility(
			row,
			accessible_text,
			"Premi R per ascoltare l'intero ramo. Usa freccia giù o su per la prossima abilità."
		)

		row.focus_entered.connect(func():
			AccessibilityManager.announce(accessible_text, false)
		)

		vbox_skills_tree_list.add_child(row)
		if first_entry == null:
			first_entry = row

	# Annuncio vocale sintetico per NVDA all'apertura del ramo
	var branch_name: String = str(BRANCH_NAMES.get(branch_id, branch_id))
	var branch_speech: String = "Ramo %s aperto: %d abilità. Usa freccia giù per sfogliare o premi R per ascoltare tutto." % [
		branch_name, skills.size()
	]
	AccessibilityManager.announce(branch_speech, false)

	if first_entry:
		first_entry.grab_focus()

func _read_current_branch_summary() -> void:
	var player: PlayerData = GameManager.player_data if GameManager else null
	if not player or current_tab != 2:
		return

	var skills: Array[Dictionary] = player.get_branch_skills(current_branch)
	var branch_name: String = str(BRANCH_NAMES.get(current_branch, current_branch))
	var speech: String = "Riepilogo Ramo %s. %d abilità totali: " % [branch_name, skills.size()]

	for i in range(skills.size()):
		var s: Dictionary = skills[i]
		var s_id: String = str(s.get("id", ""))
		var s_name: String = str(s.get("name", s_id))
		var s_grade: int = int(s.get("grade", 0))
		var stars_disp: String = player.get_skill_stars_display(s_id)
		var unlock_info: Dictionary = player.can_unlock_skill(s_id)
		var is_unlocked: bool = bool(unlock_info.get("can_unlock", true))

		if not is_unlocked and s_grade == 0:
			speech += "%d: %s, Bloccata. " % [i + 1, s_name]
		else:
			speech += "%d: %s, %s. " % [i + 1, s_name, stars_disp]

	speech += "Premi freccia giù per navigare le singole abilità o Esc per chiudere."
	AccessibilityManager.announce(speech, true)

func refresh_sheet() -> void:
	_resolve_nodes()
	if not label_title or not GameManager or not GameManager.player_data:
		return

	var player: PlayerData = GameManager.player_data
	var career_name: String = "Principiante"
	if GameManager.career_system:
		career_name = GameManager.career_system.get_tier_name(player.career_tier)

	# Intestazione
	label_title.text = "Scheda Musicista — %s" % player.player_name

	# Colonna Sinistra (Anagrafica & Carriera)
	if label_name:
		label_name.text = "Nome d'arte: %s" % player.player_name
	if label_instrument:
		label_instrument.text = "Strumento Primario: %s" % player.primary_instrument
	if label_background:
		label_background.text = "Origine / Background: %s" % player.get_background_name()
	if label_trait:
		label_trait.text = "Tratto Personale: %s" % player.get_trait_name()
	if label_career:
		label_career.text = "Status Carriera: %s" % career_name
	if label_fame:
		label_fame.text = "Fan: %d | Popolarità: %.1f%% | Reputazione: %.1f" % [
			player.fans,
			player.popularity,
			player.reputation
		]

	# Finanze
	if label_finance:
		var runway_str: String = "Sostenibile"
		if GameManager.economy_system:
			var days: float = GameManager.economy_system.get_financial_runway_days()
			runway_str = "%d giorni" % int(days) if days < 900.0 else "Illimitata"
		label_finance.text = "Finanze: Saldo %.2f € | Spese Fisse: 25.00 €/notte | Autonomia: %s" % [
			player.money,
			runway_str
		]

	# Colonna Destra (Vitals & Attributi Fisiologici Innati)
	if label_vitals:
		label_vitals.text = "Condizione: Energia %d%% | Stress %d%% | Morale %d%%" % [
			player.energy,
			player.stress,
			player.morale
		]

	if label_musicality:
		label_musicality.text = "Musicalità: %d / 100 (Orecchio Naturale & Qualità)" % player.musicality
	if label_intelligence:
		label_intelligence.text = "Intelligenza: %d / 100 (Apprendimento Studio +0.5%% XP)" % player.intelligence
	if label_stamina:
		label_stamina.text = "Resistenza Fisica: %d / 100 (Stamina Live & Voce)" % player.stamina
	if label_charm:
		label_charm.text = "Carisma Naturale: %d / 100 (Fascino, Magnetismo & Media)" % player.charm

	# Popolamento Matrice 7 Abilità Base (Preservata per retrocompatibilità e test)
	_populate_legacy_skills_list()

func _populate_legacy_skills_list() -> void:
	if not vbox_skills:
		return

	for c in vbox_skills.get_children():
		vbox_skills.remove_child(c)
		c.queue_free()

	var key_skills: Array[String] = [
		"instrument", "vocals", "composition", "songwriting",
		"production", "performance", "charisma"
	]

	var ss: SkillSystem = GameManager.skill_system if GameManager else null
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
		lbl_name.add_theme_font_size_override("font_size", 14)

		var lbl_xp := Label.new()
		lbl_xp.text = "XP %.1f / %d" % [s_xp, req_xp]
		lbl_xp.add_theme_font_size_override("font_size", 13)
		lbl_xp.modulate = Color(0.8, 0.85, 0.95, 1)

		row.add_child(lbl_name)
		row.add_child(lbl_xp)
		vbox_skills.add_child(row)

func _announce_open_summary() -> void:
	var player: PlayerData = GameManager.player_data if GameManager else null
	if not player:
		return

	var career_name: String = "Principiante"
	if GameManager and GameManager.career_system:
		career_name = GameManager.career_system.get_tier_name(player.career_tier)

	var date_str: String = "Giorno %d" % (GameManager.calendar_data.day_number if GameManager and GameManager.calendar_data else 1)
	if GameManager and GameManager.calendar_data:
		date_str = GameManager.calendar_data.get_full_date_string()

	var upcoming_count: int = 0
	if GameManager and GameManager.schedule_system:
		upcoming_count = GameManager.schedule_system.get_upcoming_events(7).size()

	var speech: String = "Scheda Musicista di %s. Data: %s. Strumento: %s. Background: %s. Tratto: %s. Status: %s. Energia: %d%%, Stress: %d%%, Morale: %d%%. Attributi Innati: Musicalità %d, Intelligenza %d, Resistenza %d, Carisma %d. Saldo: %.2f euro. Impegni in agenda: %d. Premi 2 per l'Albero delle Competenze (28 abilità), A per l'agenda, Esc per chiudere." % [
		player.player_name,
		date_str,
		player.primary_instrument,
		player.get_background_name(),
		player.get_trait_name(),
		career_name,
		player.energy,
		player.stress,
		player.morale,
		player.musicality,
		player.intelligence,
		player.stamina,
		player.charm,
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
	if not (event is InputEventKey) or not event.is_pressed() or event.is_echo():
		return

	var key_event := event as InputEventKey
	match key_event.keycode:
		KEY_ESCAPE, KEY_C:
			_on_btn_close_pressed()
			get_viewport().set_input_as_handled()
		KEY_1, KEY_KP_1:
			select_tab(1)
			get_viewport().set_input_as_handled()
		KEY_2, KEY_KP_2:
			select_tab(2)
			get_viewport().set_input_as_handled()
		KEY_A:
			if current_tab == 1:
				if GameManager and GameManager.schedule_system:
					var agenda_speech: String = GameManager.schedule_system.get_linear_agenda_speech(7)
					AccessibilityManager.announce(agenda_speech, true)
				get_viewport().set_input_as_handled()
			elif current_tab == 2:
				select_branch("songwriting_harmony")
				get_viewport().set_input_as_handled()
		KEY_G:
			if current_tab == 2:
				select_branch("genre_mastery")
				get_viewport().set_input_as_handled()
		KEY_S:
			if current_tab == 2:
				select_branch("instrumental_technique")
				get_viewport().set_input_as_handled()
		KEY_P:
			if current_tab == 2:
				select_branch("stage_showmanship")
				get_viewport().set_input_as_handled()
		KEY_T:
			if current_tab == 2:
				select_branch("engineering_hardware")
				get_viewport().set_input_as_handled()
		KEY_B:
			if current_tab == 2:
				select_branch("industry_business")
				get_viewport().set_input_as_handled()
		KEY_R:
			if current_tab == 2:
				_read_current_branch_summary()
				get_viewport().set_input_as_handled()
