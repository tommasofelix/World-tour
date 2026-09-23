# res://ui/relax/relax_modal.gd
extends Control

## Schermata Modale di Recupero Attivo e Benessere (Sezione 1.3)
## Permette al musicista di scegliere tra Caffè, Passeggiata e Ascolto Musica.
## Conforme a Simmetria Universale (accessibilità 100% Zero Mouse per Luca con NVDA).

signal activity_selected(action: ActionData)
signal closed

@onready var backdrop: ColorRect = $Backdrop
@onready var panel_main: PanelContainer = $PanelMain
@onready var btn_coffee: Button = $PanelMain/Margin/VBox/BtnCoffee
@onready var btn_walk: Button = $PanelMain/Margin/VBox/BtnWalk
@onready var btn_music: Button = $PanelMain/Margin/VBox/BtnMusic
@onready var btn_close: Button = $PanelMain/Margin/VBox/BtnClose

func _ready() -> void:
	visible = false
	if btn_coffee and not btn_coffee.pressed.is_connected(_on_btn_coffee_pressed):
		btn_coffee.pressed.connect(_on_btn_coffee_pressed)
	if btn_walk and not btn_walk.pressed.is_connected(_on_btn_walk_pressed):
		btn_walk.pressed.connect(_on_btn_walk_pressed)
	if btn_music and not btn_music.pressed.is_connected(_on_btn_music_pressed):
		btn_music.pressed.connect(_on_btn_music_pressed)
	if btn_close and not btn_close.pressed.is_connected(close):
		btn_close.pressed.connect(close)
		
	_hook_accessibility()

func _hook_accessibility() -> void:
	AccessibilityManager.hook_control_accessibility(
		btn_coffee,
		"Bevi un Caffè al Bar (Tasto 1). Costo: 2 euro.",
		"Recupera istantaneamente +15 Energia, ma aumenta lo Stress di +5. Durata: 5 secondi virtuali."
	)
	AccessibilityManager.hook_control_accessibility(
		btn_walk,
		"Passeggiata Rilassante al Parco (Tasto 2). Gratuito.",
		"Riduce lo Stress di -15, aumenta il Morale di +5 e consuma -5 Energia. Durata: 10 secondi virtuali."
	)
	AccessibilityManager.hook_control_accessibility(
		btn_music,
		"Ascolta un Disco Capolavoro (Tasto 3). Gratuito.",
		"Aumenta il Morale di +20, riduce lo Stress di -10 con il 35% di probabilità di ispirazione per un brano. Durata: 12 secondi virtuali."
	)
	AccessibilityManager.hook_control_accessibility(
		btn_close,
		"Chiudi Finestra di Recupero (Tasto Esc)",
		"Ritorna all'interfaccia principale senza svolgere alcuna attività."
	)

func open() -> void:
	visible = true
	if btn_coffee:
		btn_coffee.grab_focus()
	AccessibilityManager.speak(
		"Menu Recupero Attivo e Benessere aperto. Opzioni disponibili: 1 Bevi un Caffè al bar (2 euro), 2 Passeggiata al Parco, 3 Ascolta un Disco Capolavoro, oppure Esc per annullare."
	)

func close() -> void:
	visible = false
	closed.emit()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if not (event is InputEventKey) or not event.is_pressed() or event.is_echo():
		return
		
	match event.keycode:
		KEY_ESCAPE:
			close()
			get_viewport().set_input_as_handled()
		KEY_1:
			_on_btn_coffee_pressed()
			get_viewport().set_input_as_handled()
		KEY_2:
			_on_btn_walk_pressed()
			get_viewport().set_input_as_handled()
		KEY_3:
			_on_btn_music_pressed()
			get_viewport().set_input_as_handled()

static func create_coffee_action() -> ActionData:
	return ActionData.new(
		"recovery_coffee",
		"Bevi un Caffè al Bar",
		Constants.RECOVERY_COFFEE_DURATION,
		0,
		0,
		0.0,
		"",
		true,
		Constants.RECOVERY_COFFEE_ENERGY,
		Constants.RECOVERY_COFFEE_STRESS,
		0,
		Constants.RECOVERY_COFFEE_COST,
		0.0
	)

static func create_walk_action() -> ActionData:
	return ActionData.new(
		"recovery_walk",
		"Passeggiata Rilassante al Parco",
		Constants.RECOVERY_WALK_DURATION,
		0,
		0,
		0.0,
		"",
		true,
		-Constants.RECOVERY_WALK_ENERGY_COST,
		-Constants.RECOVERY_WALK_STRESS_RELIEF,
		Constants.RECOVERY_WALK_MORALE,
		0.0,
		0.0
	)

static func create_music_action() -> ActionData:
	return ActionData.new(
		"recovery_music",
		"Ascolto Disco Capolavoro",
		Constants.RECOVERY_MUSIC_DURATION,
		0,
		0,
		0.0,
		"",
		true,
		0,
		-Constants.RECOVERY_MUSIC_STRESS_RELIEF,
		Constants.RECOVERY_MUSIC_MORALE,
		0.0,
		Constants.RECOVERY_MUSIC_SPARK_CHANCE
	)

func _on_btn_coffee_pressed() -> void:
	var act: ActionData = create_coffee_action()
	activity_selected.emit(act)
	close()

func _on_btn_walk_pressed() -> void:
	var act: ActionData = create_walk_action()
	activity_selected.emit(act)
	close()

func _on_btn_music_pressed() -> void:
	var act: ActionData = create_music_action()
	activity_selected.emit(act)
	close()
