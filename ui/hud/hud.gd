# res://ui/hud/hud.gd
extends Control

## Controller della Schermata Principale (HUD) di World-tour
## Implementa l'architettura a Layer Differenziati per Simmetria Universale (Luca & Holy Diver).

@onready var label_time: Label = $VBoxMain/PanelTop/HBoxTop/LabelTime
@onready var label_energy: Label = $VBoxMain/PanelTop/HBoxTop/LabelEnergy
@onready var label_money: Label = $VBoxMain/PanelTop/HBoxTop/LabelMoney
@onready var label_status: Label = $VBoxMain/PanelCenter/LabelStatus
@onready var btn_practice: Button = $VBoxMain/PanelCenter/HBoxActions/BtnPractice
@onready var btn_pause: Button = $VBoxMain/PanelCenter/HBoxActions/BtnPause
@onready var btn_save: Button = $VBoxMain/PanelCenter/HBoxActions/BtnSave

var action_system: ActionSystem
var quick_practice_action: ActionData

func _ready() -> void:
	# Inizializzazione azione rapida
	quick_practice_action = ActionData.new(
		"quick_practice",
		"Allenamento Rapido",
		10.0,
		15,
		5,
		10.0,
		"instrument"
	)
	
	action_system = ActionSystem.new(GameManager.player_data, GameManager.calendar_data)
	if GameManager.current_state == Enums.GameState.BOOT:
		GameManager.change_state(Enums.GameState.GAMEPLAY_IDLE)
	
	# Configurazione semantica AccessKit per NVDA
	AccessibilityManager.hook_control_accessibility(btn_practice, "Esegui Allenamento Rapido", "Tasto rapido 1. Dura 10 secondi, consuma 15 energia e fornisce XP per lo strumento.")
	AccessibilityManager.hook_control_accessibility(btn_pause, "Pausa o Riprendi Simulazione", "Tasto rapido Spazio. Blocca o riavvia lo scorrere del tempo.")
	AccessibilityManager.hook_control_accessibility(btn_save, "Salva Partita", "Salva lo stato corrente del gioco su disco.")
	
	# Impostazione Live Region per l'orologio (annuncio dinamico senza spostare il focus)
	label_time.set_accessibility_live(Constants.ACCESSIBILITY_LIVE_POLITE)
	label_status.set_accessibility_live(Constants.ACCESSIBILITY_LIVE_ASSERTIVE)
	
	# Connessione eventi UI
	btn_practice.pressed.connect(_on_btn_practice_pressed)
	btn_pause.pressed.connect(_on_btn_pause_pressed)
	btn_save.pressed.connect(_on_btn_save_pressed)
	
	# Connessione EventBus per aggiornamento speculare
	EventBus.time_ticked.connect(_on_time_ticked)
	EventBus.action_started.connect(_on_action_started)
	EventBus.action_progress.connect(_on_action_progress)
	EventBus.action_completed.connect(_on_action_completed)
	EventBus.money_changed.connect(_on_money_changed)
	
	# Aggiornamento iniziale
	_update_hud_display()
	
	# Auto-focus sul primo elemento utile
	btn_practice.grab_focus()

func _process(delta: float) -> void:
	if GameManager.time_system:
		GameManager.time_system.advance_time(delta)
	if action_system and action_system.is_running:
		action_system.update_action(delta)

func _update_hud_display() -> void:
	if GameManager.calendar_data:
		var t_str: String = GameManager.calendar_data.get_formatted_time_string()
		var p_str: String = GameManager.calendar_data.get_period_name()
		var d_num: int = GameManager.calendar_data.day_number
		label_time.text = "Giorno %d — Ore %s (%s)" % [d_num, t_str, p_str]
		label_time.set_accessibility_name("Orologio: Giorno %d, ore %s, %s" % [d_num, t_str, p_str])
		
	if GameManager.player_data:
		label_energy.text = "Energia: %d%%" % GameManager.player_data.energy
		label_money.text = "Saldo: %.2f €" % GameManager.player_data.money

func _on_time_ticked(remaining_sec: float, time_str: String, period: int) -> void:
	_update_hud_display()

func _on_btn_practice_pressed() -> void:
	if action_system:
		action_system.start_action(quick_practice_action)

func _on_btn_pause_pressed() -> void:
	if GameManager.time_system:
		var paused: bool = GameManager.time_system.toggle_pause()
		btn_pause.text = "Riprendi (Spazio)" if paused else "Pausa (Spazio)"

func _on_btn_save_pressed() -> void:
	SaveManager.save_game()

func _on_action_started(action_id: String, duration: float) -> void:
	label_status.text = "Azione in corso: %s..." % action_id
	btn_practice.disabled = true

func _on_action_progress(action_id: String, elapsed: float, duration: float) -> void:
	var progress_pct: int = int(round((elapsed / duration) * 100.0))
	label_status.text = "Avanzamento: %d%%" % progress_pct

func _on_action_completed(action_id: String, rewards: Dictionary) -> void:
	label_status.text = "Completato! +%.1f XP" % rewards.get("xp_gained", 0.0)
	btn_practice.disabled = false
	_update_hud_display()

func _on_money_changed(new_bal: float, delta: float, reason: String) -> void:
	_update_hud_display()
