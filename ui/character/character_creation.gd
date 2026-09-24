# res://ui/character/character_creation.gd
extends Control

## Schermata di Creazione del Personaggio per World-tour
## Conforme a Section 1.1 e al Principio di Simmetria Universale (Luca con NVDA/tastiera e Holy Diver a monitor).

@onready var edit_name: LineEdit = $CenterContainer/PanelMain/VBoxMain/ScrollContainer/VBoxContent/HBoxName/EditName
@onready var edit_stage_name: LineEdit = $CenterContainer/PanelMain/VBoxMain/ScrollContainer/VBoxContent/HBoxStageName/EditStageName
@onready var spin_age: SpinBox = $CenterContainer/PanelMain/VBoxMain/ScrollContainer/VBoxContent/HBoxAge/SpinAge
@onready var opt_instrument: OptionButton = $CenterContainer/PanelMain/VBoxMain/ScrollContainer/VBoxContent/HBoxInstrument/OptInstrument
@onready var opt_background: OptionButton = $CenterContainer/PanelMain/VBoxMain/ScrollContainer/VBoxContent/HBoxBackground/OptBackground
@onready var opt_trait: OptionButton = $CenterContainer/PanelMain/VBoxMain/ScrollContainer/VBoxContent/HBoxTrait/OptTrait
@onready var label_summary: Label = $CenterContainer/PanelMain/VBoxMain/ScrollContainer/VBoxContent/PanelSummary/LabelSummary

@onready var btn_start: Button = $CenterContainer/PanelMain/VBoxMain/HBoxButtons/BtnStart
@onready var btn_quick_default: Button = $CenterContainer/PanelMain/VBoxMain/HBoxButtons/BtnQuickDefault
@onready var btn_back: Button = $CenterContainer/PanelMain/VBoxMain/HBoxButtons/BtnBack

const INSTRUMENTS: Array[String] = [
	"Chitarra Elettrica",
	"Chitarra Acustica",
	"Basso",
	"Batteria",
	"Tastiere / Pianoforte",
	"Voce"
]

const BACKGROUNDS: Array[Dictionary] = [
	{
		"id": "self_taught",
		"name": "Autodidatta",
		"desc": "Partenza equilibrata. +12 Strumento, 50 € di saldo iniziale."
	},
	{
		"id": "conservatory",
		"name": "Conservatorio",
		"desc": "Solide basi teoriche. +14 Composizione, +12 Strumento, 30 € iniziali."
	},
	{
		"id": "busker",
		"name": "Musicista di Strada",
		"desc": "Abituato al contatto col pubblico. +14 Presenza Scenica, +12 Carisma, 25 € iniziali."
	},
	{
		"id": "punk_rebel",
		"name": "Ribelle Punk",
		"desc": "Attitudine aggressiva. +15 Presenza Scenica, 20 € iniziali."
	},
	{
		"id": "bedroom_producer",
		"name": "Producer da Cameretta",
		"desc": "Maestria nel sound design. +15 Produzione, +12 Composizione, 40 € iniziali."
	}
]

const TRAITS: Array[Dictionary] = [
	{
		"id": "charismatic",
		"name": "Carismatico",
		"desc": "Presenza magnetica. +10% conversione fan e bonus nei dialoghi."
	},
	{
		"id": "perfectionist",
		"name": "Perfezionista",
		"desc": "Cura maniacale del dettaglio. +10% qualità brani, +15% accumulo stress."
	},
	{
		"id": "stage_animal",
		"name": "Animale da Palco",
		"desc": "Esplosione di energia live. +15% Concert Score nei concerti."
	},
	{
		"id": "creative_insomniac",
		"name": "Insonne Creativo",
		"desc": "Ispirazione notturna. Maggiore probabilità di riff notturni, -10 riposo."
	},
	{
		"id": "resilient",
		"name": "Resiliente",
		"desc": "Tenacia d'acciaio. Soglia panico all'85% e minor stress dagli imprevisti."
	}
]

func _ready() -> void:
	_populate_dropdowns()
	_connect_signals()
	_refresh_summary()
	_hook_accessibility()
	
	# Focus iniziale sul primo campo modificabile
	edit_name.grab_focus()

func _populate_dropdowns() -> void:
	# Strumenti
	opt_instrument.clear()
	for i in range(INSTRUMENTS.size()):
		opt_instrument.add_item(INSTRUMENTS[i], i)
		opt_instrument.set_item_metadata(i, INSTRUMENTS[i])
	opt_instrument.select(0)
	
	# Background
	opt_background.clear()
	for i in range(BACKGROUNDS.size()):
		var bg: Dictionary = BACKGROUNDS[i]
		opt_background.add_item(bg["name"], i)
		opt_background.set_item_metadata(i, bg["id"])
	opt_background.select(0)
	
	# Tratti
	opt_trait.clear()
	for i in range(TRAITS.size()):
		var tr_data: Dictionary = TRAITS[i]
		opt_trait.add_item(tr_data["name"], i)
		opt_trait.set_item_metadata(i, tr_data["id"])
	opt_trait.select(0)

func _connect_signals() -> void:
	edit_name.text_changed.connect(_on_field_changed)
	edit_stage_name.text_changed.connect(_on_field_changed)
	spin_age.value_changed.connect(_on_age_changed)
	opt_instrument.item_selected.connect(_on_instrument_selected)
	opt_background.item_selected.connect(_on_background_selected)
	opt_trait.item_selected.connect(_on_trait_selected)
	
	btn_start.pressed.connect(_on_start_pressed)
	btn_quick_default.pressed.connect(_on_quick_default_pressed)
	btn_back.pressed.connect(_on_back_pressed)

func _hook_accessibility() -> void:
	AccessibilityManager.hook_control_accessibility(
		edit_name,
		"Nome Personale",
		"Inserisci il nome anagrafico del protagonista. Predefinito: Alex."
	)
	AccessibilityManager.hook_control_accessibility(
		edit_stage_name,
		"Nome d'Arte",
		"Facoltativo. Inserisci il nome d'arte con cui l'artista sarà conosciuto dal pubblico."
	)
	AccessibilityManager.hook_control_accessibility(
		spin_age,
		"Età Iniziale",
		"Seleziona l'età di partenza del musicista tra 18 e 35 anni. Predefinito: 20."
	)
	AccessibilityManager.hook_control_accessibility(
		opt_instrument,
		"Strumento Principale",
		"Seleziona lo strumento principale del personaggio tra Chitarra Elettrica, Acustica, Basso, Batteria, Tastiere o Voce."
	)
	AccessibilityManager.hook_control_accessibility(
		opt_background,
		"Background di Partenza",
		"Scegli il contesto da cui parte il protagonista: Autodidatta, Conservatorio, Musicista di Strada, Punk o Producer."
	)
	AccessibilityManager.hook_control_accessibility(
		opt_trait,
		"Tratto Caratteriale",
		"Scegli una predisposizione comportamentale: Carismatico, Perfezionista, Animale da Palco, Insonne o Resiliente."
	)
	AccessibilityManager.hook_control_accessibility(
		btn_start,
		"Inizia Carriera",
		"Conferma le scelte e avvia la nuova carriera musicale partendo dalla stanzetta."
	)
	AccessibilityManager.hook_control_accessibility(
		btn_quick_default,
		"Avvio Predefinito Alex",
		"Applica immediatamente la configurazione classica: Alex, 20 anni, Chitarra, Autodidatta e Carismatico."
	)
	AccessibilityManager.hook_control_accessibility(
		btn_back,
		"Torna al Menu Principale",
		"Annulla la creazione del personaggio e ritorna al menu iniziale."
	)

func _on_field_changed(_new_text: String) -> void:
	_refresh_summary()

func _on_age_changed(value: float) -> void:
	_refresh_summary()
	AccessibilityManager.announce("Età impostata a %d anni." % int(value), false)

func _on_instrument_selected(index: int) -> void:
	_refresh_summary()
	var inst_name: String = str(opt_instrument.get_item_metadata(index))
	AccessibilityManager.announce("Strumento principale: %s" % inst_name, false)

func _on_background_selected(index: int) -> void:
	_refresh_summary()
	var bg: Dictionary = BACKGROUNDS[index]
	AccessibilityManager.announce("Background selezionato: %s. %s" % [bg["name"], bg["desc"]], false)

func _on_trait_selected(index: int) -> void:
	_refresh_summary()
	var tr_data: Dictionary = TRAITS[index]
	AccessibilityManager.announce("Tratto selezionato: %s. %s" % [tr_data["name"], tr_data["desc"]], false)

func _refresh_summary() -> void:
	var p_name: String = edit_name.text.strip_edges()
	if p_name.is_empty():
		p_name = "Alex"
	var p_stage: String = edit_stage_name.text.strip_edges()
	var p_age: int = int(spin_age.value)
	
	var inst_idx: int = opt_instrument.selected
	var inst_name: String = INSTRUMENTS[inst_idx] if inst_idx >= 0 and inst_idx < INSTRUMENTS.size() else "Chitarra Elettrica"
	
	var bg_idx: int = opt_background.selected
	var bg_data: Dictionary = BACKGROUNDS[bg_idx] if bg_idx >= 0 and bg_idx < BACKGROUNDS.size() else BACKGROUNDS[0]
	
	var tr_idx: int = opt_trait.selected
	var tr_data: Dictionary = TRAITS[tr_idx] if tr_idx >= 0 and tr_idx < TRAITS.size() else TRAITS[0]
	
	var name_display: String = p_name
	if not p_stage.is_empty():
		name_display += " (\"%s\")" % p_stage
		
	var summary_text: String = "Riepilogo Musicista: %s, %d anni\nStrumento: %s\nOrigine: %s — %s\nTratto: %s — %s" % [
		name_display,
		p_age,
		inst_name,
		bg_data["name"],
		bg_data["desc"],
		tr_data["name"],
		tr_data["desc"]
	]
	label_summary.text = summary_text

func _on_start_pressed() -> void:
	var p_name: String = edit_name.text.strip_edges()
	if p_name.is_empty():
		p_name = "Alex"
	var p_stage: String = edit_stage_name.text.strip_edges()
	var p_age: int = int(spin_age.value)
	
	var inst_idx: int = opt_instrument.selected
	var inst_name: String = INSTRUMENTS[inst_idx] if inst_idx >= 0 and inst_idx < INSTRUMENTS.size() else "Chitarra Elettrica"
	
	var bg_idx: int = opt_background.selected
	var bg_id: String = str(opt_background.get_item_metadata(bg_idx)) if bg_idx >= 0 else "self_taught"
	
	var tr_idx: int = opt_trait.selected
	var tr_id: String = str(opt_trait.get_item_metadata(tr_idx)) if tr_idx >= 0 else "charismatic"
	
	if GameManager:
		GameManager.start_new_game(p_name, inst_name, bg_id, false, p_stage, p_age, tr_id)
		
	AccessibilityManager.announce("Carriera iniziata! Benvenuto nel mondo della musica, %s." % (p_stage if not p_stage.is_empty() else p_name), true)
	get_tree().change_scene_to_file("res://ui/hud/hud.tscn")

func _on_quick_default_pressed() -> void:
	if GameManager:
		GameManager.start_new_game("Alex", "Chitarra Elettrica", "self_taught", false, "", 20, "charismatic")
	AccessibilityManager.announce("Avvio predefinito completato. Benvenuto Alex!", true)
	get_tree().change_scene_to_file("res://ui/hud/hud.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey) or not event.is_pressed() or event.is_echo():
		return
	var key_event := event as InputEventKey
	if key_event.keycode == KEY_ESCAPE:
		_on_back_pressed()
		get_viewport().set_input_as_handled()
	elif key_event.keycode == KEY_ENTER or key_event.keycode == KEY_KP_ENTER:
		# Se non siamo dentro una LineEdit (dove invio invia il testo), avvia la carriera
		var focus_owner := get_viewport().gui_get_focus_owner()
		if focus_owner == btn_start or focus_owner == btn_quick_default or focus_owner == btn_back:
			pass
		elif not (focus_owner is LineEdit):
			_on_start_pressed()
			get_viewport().set_input_as_handled()
