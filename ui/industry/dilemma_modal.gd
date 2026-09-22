# res://ui/industry/dilemma_modal.gd
extends Control

## Modale per i Bivi Etico-Narrativi dell'Industria Musicale (World-tour V3.0)
## Presenta una situazione critica con 2 scelte contrapposte (integrità vs compromesso economico, band vs ego, ecc.).
## Supporta navigazione da tastiera al 100% (tasti 1 e 2) e vocalizzazione lineare per NVDA.

signal closed()
signal resolved(dilemma_id: String, option_chosen: int)

@onready var label_category: Label = $PanelMain/VBox/Header/LabelCategory
@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var label_description: Label = $PanelMain/VBox/LabelDescription

@onready var label_option1_title: Label = $PanelMain/VBox/VBoxOptions/PanelOption1/VBox/LabelOption1Title
@onready var label_option1_desc: Label = $PanelMain/VBox/VBoxOptions/PanelOption1/VBox/LabelOption1Desc
@onready var btn_option_1: Button = $PanelMain/VBox/VBoxOptions/PanelOption1/VBox/BtnOption1

@onready var label_option2_title: Label = $PanelMain/VBox/VBoxOptions/PanelOption2/VBox/LabelOption2Title
@onready var label_option2_desc: Label = $PanelMain/VBox/VBoxOptions/PanelOption2/VBox/LabelOption2Desc
@onready var btn_option_2: Button = $PanelMain/VBox/VBoxOptions/PanelOption2/VBox/BtnOption2

var current_dilemma_id: String = ""
var current_dilemma_data: Dictionary = {}

func _ready() -> void:
	btn_option_1.pressed.connect(func(): _choose_option(1))
	btn_option_2.pressed.connect(func(): _choose_option(2))

func _resolve_nodes() -> void:
	if not label_title:
		label_category = get_node_or_null("PanelMain/VBox/Header/LabelCategory")
		label_title = get_node_or_null("PanelMain/VBox/Header/LabelTitle")
		label_description = get_node_or_null("PanelMain/VBox/LabelDescription")
		label_option1_title = get_node_or_null("PanelMain/VBox/VBoxOptions/PanelOption1/VBox/LabelOption1Title")
		label_option1_desc = get_node_or_null("PanelMain/VBox/VBoxOptions/PanelOption1/VBox/LabelOption1Desc")
		btn_option_1 = get_node_or_null("PanelMain/VBox/VBoxOptions/PanelOption1/VBox/BtnOption1")
		label_option2_title = get_node_or_null("PanelMain/VBox/VBoxOptions/PanelOption2/VBox/LabelOption2Title")
		label_option2_desc = get_node_or_null("PanelMain/VBox/VBoxOptions/PanelOption2/VBox/LabelOption2Desc")
		btn_option_2 = get_node_or_null("PanelMain/VBox/VBoxOptions/PanelOption2/VBox/BtnOption2")

func open(dilemma_dict: Dictionary) -> void:
	visible = true
	_resolve_nodes()
	current_dilemma_data = dilemma_dict
	current_dilemma_id = dilemma_dict.get("id", "")
	
	var title: String = dilemma_dict.get("title", "Bivio Etico")
	var desc: String = dilemma_dict.get("description", "")
	var cat_enum: int = dilemma_dict.get("category", 0)
	var cat_name: String = _get_category_name(cat_enum)
	
	var opt1_title: String = dilemma_dict.get("option_a_title", "Opzione 1")
	var opt1_desc: String = dilemma_dict.get("option_a_desc", "")
	var opt2_title: String = dilemma_dict.get("option_b_title", "Opzione 2")
	var opt2_desc: String = dilemma_dict.get("option_b_desc", "")
	
	if label_category:
		label_category.text = "BIVIO ETICO — %s" % cat_name.to_upper()
	if label_title:
		label_title.text = title
	if label_description:
		label_description.text = desc
		
	if label_option1_title:
		label_option1_title.text = "1. %s" % opt1_title
	if label_option1_desc:
		label_option1_desc.text = opt1_desc
	if btn_option_1:
		btn_option_1.text = "Scegli: %s (Tasto 1)" % opt1_title
		AccessibilityManager.hook_control_accessibility(btn_option_1, "Opzione 1: %s" % opt1_title, opt1_desc)
		
	if label_option2_title:
		label_option2_title.text = "2. %s" % opt2_title
	if label_option2_desc:
		label_option2_desc.text = opt2_desc
	if btn_option_2:
		btn_option_2.text = "Scegli: %s (Tasto 2)" % opt2_title
		AccessibilityManager.hook_control_accessibility(btn_option_2, "Opzione 2: %s" % opt2_title, opt2_desc)
		
	if btn_option_1:
		btn_option_1.grab_focus()
		
	# Vocalizzazione immediata e lineare per NVDA
	var speech: String = "Bivio Etico: %s. Categoria: %s. Situazione: %s. Opzione 1: %s. Conseguenze: %s. Opzione 2: %s. Conseguenze: %s. Premi 1 per la prima opzione o 2 per la seconda opzione." % [
		title,
		cat_name,
		desc,
		opt1_title,
		opt1_desc,
		opt2_title,
		opt2_desc
	]
	AccessibilityManager.announce(speech, true)

func _choose_option(option_idx: int) -> void:
	if current_dilemma_id.is_empty():
		close()
		return
		
	var opt_title: String = current_dilemma_data.get("option_a_title", "") if option_idx == 1 else current_dilemma_data.get("option_b_title", "")
	
	if GameManager and GameManager.dilemma_system:
		var res: Dictionary = GameManager.dilemma_system.resolve_dilemma(current_dilemma_id, option_idx)
		if res.get("success", false):
			var speech: String = "Hai scelto: %s. Risoluzione applicata." % opt_title
			AccessibilityManager.announce(speech, true)
			
	resolved.emit(current_dilemma_id, option_idx)
	close()

func close() -> void:
	visible = false
	current_dilemma_id = ""
	current_dilemma_data.clear()
	closed.emit()

func _get_category_name(cat: int) -> String:
	match cat:
		Enums.DilemmaCategory.ARTISTIC_INTEGRITY:
			return "Integrità Artistica"
		Enums.DilemmaCategory.BAND_INTERNAL:
			return "Dinamiche Umane e di Gruppo"
		Enums.DilemmaCategory.MEDIA_SCANDAL:
			return "Scandalo & Relazioni Pubbliche"
		Enums.DilemmaCategory.COMMERCIAL_ETHICS:
			return "Etica Commerciale & Mercato"
		_:
			return "Decisione di Carriera"

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var key_event := event as InputEventKey
		if key_event.keycode == KEY_1:
			_choose_option(1)
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_2:
			_choose_option(2)
			get_viewport().set_input_as_handled()
