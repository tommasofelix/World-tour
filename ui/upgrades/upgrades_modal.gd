# res://ui/upgrades/upgrades_modal.gd
extends Control

## Modale per la Macro-Area 4: Skills, Upgrade & Strumentazione
## Gestione e miglioramento dello spazio vitale, sala prove, acquisto strumenti e hardware di registrazione.
## Progettato per Simmetria Universale (Luca con NVDA/tastiera e Holy Diver a monitor).

signal closed
signal upgrade_purchased(upgrade_id: String, cost: float)

@onready var backdrop: ColorRect = $Backdrop
@onready var panel_main: PanelContainer = $PanelMain
@onready var btn_close: Button = $PanelMain/Margin/VBox/HBoxHeader/BtnClose
@onready var label_title: Label = $PanelMain/Margin/VBox/HBoxHeader/LabelTitle
@onready var label_money: Label = $PanelMain/Margin/VBox/HBoxHeader/LabelMoney

# Selettore schede
@onready var btn_tab_housing: Button = $PanelMain/Margin/VBox/HBoxTabs/BtnTabHousing
@onready var btn_tab_rehearsal: Button = $PanelMain/Margin/VBox/HBoxTabs/BtnTabRehearsal
@onready var btn_tab_gear: Button = $PanelMain/Margin/VBox/HBoxTabs/BtnTabGear
@onready var btn_tab_studio: Button = $PanelMain/Margin/VBox/HBoxTabs/BtnTabStudio

# Contenitori schede
@onready var panel_housing: VBoxContainer = $PanelMain/Margin/VBox/PanelHousing
@onready var panel_rehearsal: VBoxContainer = $PanelMain/Margin/VBox/PanelRehearsal
@onready var panel_gear: VBoxContainer = $PanelMain/Margin/VBox/PanelGear
@onready var panel_studio: VBoxContainer = $PanelMain/Margin/VBox/PanelStudio
@onready var label_feedback: Label = $PanelMain/Margin/VBox/LabelFeedback

var current_tab: int = 1 # 1: Alloggi, 2: Sala Prove, 3: Strumenti, 4: Hardware

func _ready() -> void:
	visible = false
	btn_close.pressed.connect(_on_close_pressed)
	btn_tab_housing.pressed.connect(func(): select_tab(1))
	btn_tab_rehearsal.pressed.connect(func(): select_tab(2))
	btn_tab_gear.pressed.connect(func(): select_tab(3))
	btn_tab_studio.pressed.connect(func(): select_tab(4))
	
	_hook_accessibility()

func _hook_accessibility() -> void:
	AccessibilityManager.hook_control_accessibility(btn_close, "Chiudi Finestra Upgrades (Esc)", "Chiude la finestra dei miglioramenti e torna all'HUD.")
	AccessibilityManager.hook_control_accessibility(btn_tab_housing, "Scheda 1: Spazio Vitale e Alloggi", "Gestione residenza e traslochi.")
	AccessibilityManager.hook_control_accessibility(btn_tab_rehearsal, "Scheda 2: Sala Prove", "Insonorizzazione e miglioramento sala prove.")
	AccessibilityManager.hook_control_accessibility(btn_tab_gear, "Scheda 3: Negozio Strumenti", "Acquisto chitarre, bassi, batterie e tastiere.")
	AccessibilityManager.hook_control_accessibility(btn_tab_studio, "Scheda 4: Hardware Studio", "Microfoni, schede audio e mixer per registrazione.")

func open() -> void:
	visible = true
	label_feedback.text = ""
	_refresh_money_display()
	select_tab(1)
	btn_tab_housing.grab_focus()
	AccessibilityManager.speak(
		"Schermata Skills e Upgrade aperta. 4 categorie disponibili: 1 Spazio Vitale e Alloggi, 2 Sala Prove, 3 Negozio Strumenti, 4 Hardware di Registrazione. Premi i tasti 1-4 per cambiare scheda, Esc per chiudere."
	)

func close() -> void:
	visible = false
	closed.emit()

func select_tab(tab_idx: int) -> void:
	current_tab = tab_idx
	panel_housing.visible = (tab_idx == 1)
	panel_rehearsal.visible = (tab_idx == 2)
	panel_gear.visible = (tab_idx == 3)
	panel_studio.visible = (tab_idx == 4)
	
	match tab_idx:
		1:
			AccessibilityManager.speak("Scheda 1: Spazio Vitale e Alloggi. Gestisci la tua abitazione per migliorare il recupero notturno.")
		2:
			AccessibilityManager.speak("Scheda 2: Sala Prove. Allestisci una sala prove insonorizzata per ridurre la tensione della band.")
		3:
			AccessibilityManager.speak("Scheda 3: Negozio Strumenti. Acquista strumentazione di fascia superiore per bonus a carisma e tecnica.")
		4:
			AccessibilityManager.speak("Scheda 4: Hardware di Registrazione. Acquista microfoni e mixer per innalzare la qualità dei brani.")

func _refresh_money_display() -> void:
	if GameManager and GameManager.player_data:
		label_money.text = "Saldo: %.2f €" % GameManager.player_data.money
	else:
		label_money.text = "Saldo: 0.00 €"

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
			select_tab(1)
			get_viewport().set_input_as_handled()
		KEY_2:
			select_tab(2)
			get_viewport().set_input_as_handled()
		KEY_3:
			select_tab(3)
			get_viewport().set_input_as_handled()
		KEY_4:
			select_tab(4)
			get_viewport().set_input_as_handled()

func _on_close_pressed() -> void:
	close()
