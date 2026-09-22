# res://ui/summary/daily_summary.gd
extends Control

## Controller della Schermata Riepilogativa di Fine Giornata (Daily Summary)
## Mostra spese di sussistenza, saldo, recupero sonno e permette di iniziare il nuovo giorno.
## Accessibile al 100% da tastiera per Luca con NVDA e ad alto contrasto per Holy Diver.

signal day_advanced()

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var label_day_info: Label = $PanelMain/VBox/VBoxContent/LabelDayInfo
@onready var label_expenses: Label = $PanelMain/VBox/VBoxContent/LabelExpenses
@onready var label_balance: Label = $PanelMain/VBox/VBoxContent/LabelBalance
@onready var label_sleep: Label = $PanelMain/VBox/VBoxContent/LabelSleep
@onready var label_stats: Label = $PanelMain/VBox/VBoxContent/LabelStats
@onready var btn_next_day: Button = $PanelMain/VBox/HBoxBottom/BtnNextDay

var current_summary: Dictionary = {}

func _ready() -> void:
	btn_next_day.pressed.connect(_on_next_day_pressed)
	_setup_accessibility()

func _setup_accessibility() -> void:
	AccessibilityManager.hook_control_accessibility(
		btn_next_day,
		"Inizia Nuovo Giorno",
		"Conclude il resoconto notturno e inizia la nuova giornata di attività."
	)

func show_summary(summary_data: Dictionary) -> void:
	current_summary = summary_data
	visible = true
	
	var day_num: int = int(summary_data.get("completed_day", 1))
	var expenses: float = float(summary_data.get("expenses", 25.0))
	var food: float = float(summary_data.get("food", 10.0))
	var rent: float = float(summary_data.get("rent", 15.0))
	var royalties: float = float(summary_data.get("royalties", 0.0))
	var album_count: int = int(summary_data.get("album_count", 0))
	var housing_name: String = str(summary_data.get("housing_name", "Stanzetta"))
	var new_balance: float = float(summary_data.get("new_balance", 0.0))
	var cur_energy: int = int(summary_data.get("current_energy", 100))
	var cur_stress: int = int(summary_data.get("current_stress", 0))
	var band_crises: Array = summary_data.get("band_crises", [])
	
	label_title.text = "Riepilogo Notturno — Fine Giornata %d" % day_num
	label_day_info.text = "Giorno %d terminato | Alloggio: %s" % [day_num, housing_name]
	
	var exp_str := "Spese di Sussistenza: -%.2f € (Vitto: %.2f €, Affitto: %.2f €)" % [expenses, food, rent]
	if royalties > 0.0:
		exp_str += "\nRoyalties Catalogo: +%.2f € da %d album/EP" % [royalties, album_count]
	if not band_crises.is_empty():
		exp_str += "\n⚠️ TENSIONE CRITICA BAND: %s rischia di abbandonare!" % ", ".join(band_crises)
		
	label_expenses.text = exp_str
	label_balance.text = "Nuovo Saldo Disponibile: %.2f €" % new_balance
	label_sleep.text = "Sonno Ristoratore Completato"
	label_stats.text = "Condizione Attuale: Energia %d%% | Stress %d%%" % [cur_energy, cur_stress]
	
	var speech: String = "Riepilogo Giorno %d concluso. Alloggio: %s. Spese: %.2f euro." % [
		day_num, housing_name, expenses
	]
	if royalties > 0.0:
		speech += " Royalties catalogo: +%.2f euro." % royalties
	speech += " Nuovo saldo: %.2f euro. Condizione: energia %d%%, stress %d%%. Premi Invio per iniziare il Giorno %d." % [
		new_balance,
		cur_energy,
		cur_stress,
		day_num + 1
	]
	if not band_crises.is_empty():
		speech += " ATTENZIONE: Tensione critica per %s!" % ", ".join(band_crises)
		
	AccessibilityManager.announce(speech, true)
	btn_next_day.grab_focus()

func _on_next_day_pressed() -> void:
	visible = false
	if GameManager and GameManager.end_day_system:
		GameManager.end_day_system.advance_to_next_day()
	day_advanced.emit()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var key_event := event as InputEventKey
		if key_event.keycode == KEY_ENTER or key_event.keycode == KEY_KP_ENTER or key_event.keycode == KEY_SPACE:
			_on_next_day_pressed()
			get_viewport().set_input_as_handled()
