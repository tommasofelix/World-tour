# res://ui/upgrades/upgrades_modal.gd
extends Control

## Modale per la Macro-Area 4: Skills, Upgrade & Strumentazione
## Gestione e miglioramento dello spazio vitale, sala prove, acquisto strumenti multicategoria e hardware di registrazione.
## Progettato per Simmetria Universale (Luca con NVDA/tastiera e Holy Diver a monitor).
const UpgradeData = preload("res://data/models/upgrade_data.gd")

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
@onready var label_housing_current: Label = $PanelMain/Margin/VBox/PanelHousing/LabelHousingCurrent
@onready var btn_housing_1: Button = $PanelMain/Margin/VBox/PanelHousing/VBoxHousingList/BtnHousing1
@onready var btn_housing_2: Button = $PanelMain/Margin/VBox/PanelHousing/VBoxHousingList/BtnHousing2
@onready var btn_housing_3: Button = $PanelMain/Margin/VBox/PanelHousing/VBoxHousingList/BtnHousing3
@onready var btn_housing_4: Button = $PanelMain/Margin/VBox/PanelHousing/VBoxHousingList/BtnHousing4

@onready var panel_rehearsal: VBoxContainer = $PanelMain/Margin/VBox/PanelRehearsal
@onready var label_rehearsal_current: Label = $PanelMain/Margin/VBox/PanelRehearsal/LabelRehearsalCurrent
@onready var btn_rehearsal_1: Button = $PanelMain/Margin/VBox/PanelRehearsal/VBoxRehearsalList/BtnRehearsal1
@onready var btn_rehearsal_2: Button = $PanelMain/Margin/VBox/PanelRehearsal/VBoxRehearsalList/BtnRehearsal2
@onready var btn_rehearsal_3: Button = $PanelMain/Margin/VBox/PanelRehearsal/VBoxRehearsalList/BtnRehearsal3
@onready var btn_action_rehearse: Button = $PanelMain/Margin/VBox/PanelRehearsal/BtnActionRehearse

@onready var panel_gear: VBoxContainer = $PanelMain/Margin/VBox/PanelGear
@onready var btn_cat_guitar: Button = $PanelMain/Margin/VBox/PanelGear/HBoxGearCats/BtnCatGuitar
@onready var btn_cat_bass: Button = $PanelMain/Margin/VBox/PanelGear/HBoxGearCats/BtnCatBass
@onready var btn_cat_drums: Button = $PanelMain/Margin/VBox/PanelGear/HBoxGearCats/BtnCatDrums
@onready var btn_cat_vocals: Button = $PanelMain/Margin/VBox/PanelGear/HBoxGearCats/BtnCatVocals
@onready var btn_cat_keys: Button = $PanelMain/Margin/VBox/PanelGear/HBoxGearCats/BtnCatKeys
@onready var label_gear_current: Label = $PanelMain/Margin/VBox/PanelGear/LabelGearCurrent
@onready var label_gear_compare: Label = $PanelMain/Margin/VBox/PanelGear/LabelGearCompare
@onready var btn_gear_1: Button = $PanelMain/Margin/VBox/PanelGear/VBoxGearList/BtnGear1
@onready var btn_gear_2: Button = $PanelMain/Margin/VBox/PanelGear/VBoxGearList/BtnGear2
@onready var btn_gear_3: Button = $PanelMain/Margin/VBox/PanelGear/VBoxGearList/BtnGear3

@onready var panel_studio: VBoxContainer = $PanelMain/Margin/VBox/PanelStudio
@onready var label_studio_current: Label = $PanelMain/Margin/VBox/PanelStudio/LabelStudioCurrent
@onready var btn_studio_1: Button = $PanelMain/Margin/VBox/PanelStudio/VBoxStudioList/BtnStudio1
@onready var btn_studio_2: Button = $PanelMain/Margin/VBox/PanelStudio/VBoxStudioList/BtnStudio2
@onready var btn_studio_3: Button = $PanelMain/Margin/VBox/PanelStudio/VBoxStudioList/BtnStudio3

@onready var label_feedback: Label = $PanelMain/Margin/VBox/LabelFeedback

var current_tab: int = 1 # 1: Alloggi, 2: Sala Prove, 3: Strumenti, 4: Hardware
var selected_instrument_category: String = "guitar"

func _ready() -> void:
	visible = false
	btn_close.pressed.connect(_on_close_pressed)
	btn_tab_housing.pressed.connect(func(): select_tab(1))
	btn_tab_rehearsal.pressed.connect(func(): select_tab(2))
	btn_tab_gear.pressed.connect(func(): select_tab(3))
	btn_tab_studio.pressed.connect(func(): select_tab(4))
	
	# Connessioni Scheda 1 (Alloggi)
	btn_housing_1.pressed.connect(func(): _on_select_housing(Enums.HousingTier.STARTER_BEDROOM))
	btn_housing_2.pressed.connect(func(): _on_select_housing(Enums.HousingTier.SHARED_FLAT))
	btn_housing_3.pressed.connect(func(): _on_select_housing(Enums.HousingTier.LOFT_STUDIO))
	btn_housing_4.pressed.connect(func(): _on_select_housing(Enums.HousingTier.LUXURY_VILLA))
	
	# Connessioni Scheda 2 (Sala Prove)
	btn_rehearsal_1.pressed.connect(func(): _on_buy_rehearsal(UpgradeData.RehearsalTier.ACOUSTIC_PANELS))
	btn_rehearsal_2.pressed.connect(func(): _on_buy_rehearsal(UpgradeData.RehearsalTier.PRO_ISOLATION))
	btn_rehearsal_3.pressed.connect(func(): _on_buy_rehearsal(UpgradeData.RehearsalTier.MASTER_STUDIO))
	btn_action_rehearse.pressed.connect(_on_action_rehearse_pressed)
	
	# Connessioni Scheda 3 (Categorie Strumenti)
	btn_cat_guitar.pressed.connect(func(): select_gear_category("guitar"))
	btn_cat_bass.pressed.connect(func(): select_gear_category("bass"))
	btn_cat_drums.pressed.connect(func(): select_gear_category("drums"))
	btn_cat_vocals.pressed.connect(func(): select_gear_category("vocals"))
	btn_cat_keys.pressed.connect(func(): select_gear_category("keyboards"))
	
	btn_gear_1.pressed.connect(func(): _on_buy_instrument(1))
	btn_gear_2.pressed.connect(func(): _on_buy_instrument(2))
	btn_gear_3.pressed.connect(func(): _on_buy_instrument(3))
	
	btn_gear_1.focus_entered.connect(func(): _preview_instrument(1))
	btn_gear_2.focus_entered.connect(func(): _preview_instrument(2))
	btn_gear_3.focus_entered.connect(func(): _preview_instrument(3))
	
	# Connessioni Scheda 4 (Hardware Studio)
	btn_studio_1.pressed.connect(func(): _on_buy_studio_hardware(UpgradeData.StudioHardwareTier.USB_CONDENSER))
	btn_studio_2.pressed.connect(func(): _on_buy_studio_hardware(UpgradeData.StudioHardwareTier.TUBE_PREAMP))
	btn_studio_3.pressed.connect(func(): _on_buy_studio_hardware(UpgradeData.StudioHardwareTier.ANALOG_CONSOLE))
	
	_hook_accessibility()

func _hook_accessibility() -> void:
	AccessibilityManager.hook_control_accessibility(btn_close, "Chiudi Finestra Upgrades (Esc)", "Chiude la finestra dei miglioramenti e torna all'HUD.")
	AccessibilityManager.hook_control_accessibility(btn_tab_housing, "Scheda 1: Spazio Vitale e Alloggi", "Gestione residenza e traslochi.")
	AccessibilityManager.hook_control_accessibility(btn_tab_rehearsal, "Scheda 2: Sala Prove", "Insonorizzazione e prove con la band.")
	AccessibilityManager.hook_control_accessibility(btn_tab_gear, "Scheda 3: Negozio Strumenti", "Acquisto chitarre, bassi, batterie, microfoni e tastiere.")
	AccessibilityManager.hook_control_accessibility(btn_tab_studio, "Scheda 4: Hardware Studio", "Microfoni, schede audio e mixer per registrazione.")

func open() -> void:
	visible = true
	label_feedback.text = ""
	_refresh_money_display()
	select_tab(1)
	btn_tab_housing.grab_focus()
	AccessibilityManager.speak(
		"Schermata Skills e Upgrade aperta. 4 categorie disponibili: 1 Spazio Vitale, 2 Sala Prove, 3 Negozio Strumenti, 4 Hardware di Registrazione. Premi i tasti 1-4 per cambiare scheda, Esc per chiudere."
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
	label_feedback.text = ""
	
	match tab_idx:
		1:
			_refresh_housing_view()
			AccessibilityManager.speak("Scheda 1: Spazio Vitale e Alloggi. Seleziona la residenza per cambiare canone e recupero.")
		2:
			_refresh_rehearsal_view()
			AccessibilityManager.speak("Scheda 2: Sala Prove. Acquista insonorizzazione per ridurre lo stress o premi P per fare le prove.")
		3:
			select_gear_category(selected_instrument_category)
			AccessibilityManager.speak("Scheda 3: Negozio Strumenti Multicategoria. Usa i tasti G, B, D, V, K per selezionare la categoria.")
		4:
			_refresh_studio_view()
			AccessibilityManager.speak("Scheda 4: Hardware Studio. Acquista microfoni e mixer per innalzare il cap esecutivo e la qualità dei brani.")

func _refresh_money_display() -> void:
	if GameManager and GameManager.player_data:
		label_money.text = "Saldo: %.2f €" % GameManager.player_data.money
	else:
		label_money.text = "Saldo: 0.00 €"

# --- SCHEDA 1: ALLOGGI ---
func _refresh_housing_view() -> void:
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	var h_tier: int = p.current_housing_tier
	var rent: float = HousingData.get_tier_rent(h_tier)
	label_housing_current.text = "Alloggio Attuale: %s (%.2f € / giorno)" % [
		HousingData.get_tier_name(h_tier), rent
	]

func _on_select_housing(tier: int) -> void:
	if not GameManager or not GameManager.player_data:
		return
	if GameManager.economy_system:
		var res: Dictionary = GameManager.economy_system.change_housing(tier)
		if res.get("success", false):
			label_feedback.text = "Trasloco effettuato in: %s!" % HousingData.get_tier_name(tier)
			_refresh_housing_view()
			_refresh_money_display()
		else:
			var reason: String = res.get("reason", "error")
			if reason == "already_current":
				label_feedback.text = "Abiti già in questo alloggio!"
			elif reason == "no_band_members":
				label_feedback.text = "Per l'appartamento condiviso devi prima avere membri nella band!"
			elif reason == "career_too_low":
				label_feedback.text = "La villa di lusso richiede almeno lo status di Fenomeno Indie!"
			elif reason == "money_insufficient":
				label_feedback.text = "Fondi insufficienti per sostenere la caparra/canone iniziale!"
			AccessibilityManager.speak(label_feedback.text)

# --- SCHEDA 2: SALA PROVE ---
func _refresh_rehearsal_view() -> void:
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	var r_tier: int = p.rehearsal_tier
	label_rehearsal_current.text = "Allestimento Attuale: %s (Stress prova: +%d)" % [
		UpgradeData.get_rehearsal_name(r_tier), UpgradeData.get_rehearsal_stress(r_tier)
	]
	
	btn_rehearsal_1.text = "A. Pannelli Fonoassorbenti (300 €) — %s" % ("Posseduto" if r_tier >= 1 else "Acquista")
	btn_rehearsal_2.text = "B. Insonorizzazione Pro (800 €) — %s" % ("Posseduto" if r_tier >= 2 else "Acquista")
	btn_rehearsal_3.text = "C. Studio Acustico & Lounge (2.000 €) — %s" % ("Posseduto" if r_tier >= 3 else "Acquista")

func _on_buy_rehearsal(tier: int) -> void:
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	if p.rehearsal_tier >= tier:
		label_feedback.text = "Possiedi già questo livello di isolamento o uno superiore!"
		AccessibilityManager.speak(label_feedback.text)
		return
		
	var cost: float = float(UpgradeData.REHEARSAL_COSTS[tier])
	if p.money < cost:
		label_feedback.text = "Fondi insufficienti (richiesti %.2f €)!" % cost
		AccessibilityManager.speak(label_feedback.text)
		return
		
	p.modify_money(-cost)
	p.rehearsal_tier = tier
	EventBus.money_changed.emit(p.money, -cost, "rehearsal_upgrade")
	upgrade_purchased.emit("rehearsal_%d" % tier, cost)
	
	label_feedback.text = "Acquistato con successo: %s!" % UpgradeData.get_rehearsal_name(tier)
	_refresh_rehearsal_view()
	_refresh_money_display()
	AccessibilityManager.speak(label_feedback.text)

func _on_action_rehearse_pressed() -> void:
	if not GameManager or not GameManager.band_system:
		return
	var res: Dictionary = GameManager.band_system.hold_rehearsal_session()
	if res.get("success", false):
		label_feedback.text = res.get("message", "Prove completate con successo!")
	else:
		label_feedback.text = res.get("message", "Impossibile svolgere le prove.")
	_refresh_money_display()
	AccessibilityManager.speak(label_feedback.text)

# --- SCHEDA 3: NEGOZIO STRUMENTI ---
func select_gear_category(cat: String) -> void:
	selected_instrument_category = cat
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	var cur_tier: int = p.get_instrument_tier(cat)
	var cur_inst: Dictionary = UpgradeData.get_instrument(cat, cur_tier)
	
	label_gear_current.text = "Categoria: %s | In Dotazione: %s (Tier %d)" % [
		UpgradeData.get_category_display_name(cat),
		cur_inst.get("name", "Starter"),
		cur_tier
	]
	
	# Popola i 3 modelli
	var m1: Dictionary = UpgradeData.get_instrument(cat, 1)
	var m2: Dictionary = UpgradeData.get_instrument(cat, 2)
	var m3: Dictionary = UpgradeData.get_instrument(cat, 3)
	
	btn_gear_1.text = "A. %s (%.0f €) — %s" % [m1.get("name", ""), m1.get("cost", 0.0), "In Dotazione" if cur_tier >= 1 else "Acquista"]
	btn_gear_2.text = "B. %s (%.0f €) — %s" % [m2.get("name", ""), m2.get("cost", 0.0), "In Dotazione" if cur_tier >= 2 else "Acquista"]
	btn_gear_3.text = "C. %s (%.0f €) — %s" % [m3.get("name", ""), m3.get("cost", 0.0), "In Dotazione" if cur_tier >= 3 else "Acquista"]
	
	_preview_instrument(1)

func _preview_instrument(target_tier: int) -> void:
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	var cur_tier: int = p.get_instrument_tier(selected_instrument_category)
	var cmp: Dictionary = UpgradeData.compare_instruments(selected_instrument_category, cur_tier, target_tier)
	if cmp.get("valid", false):
		label_gear_compare.text = cmp.get("comparison_text", "")

func _on_buy_instrument(target_tier: int) -> void:
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	var cat: String = selected_instrument_category
	var cur_tier: int = p.get_instrument_tier(cat)
	if cur_tier >= target_tier:
		label_feedback.text = "Possiedi già questo strumento o un modello superiore!"
		AccessibilityManager.speak(label_feedback.text)
		return
		
	var inst: Dictionary = UpgradeData.get_instrument(cat, target_tier)
	var cost: float = float(inst.get("cost", 0.0))
	if p.money < cost:
		label_feedback.text = "Fondi insufficienti per acquistare %s (richiesti %.2f €)!" % [inst.get("name", ""), cost]
		AccessibilityManager.speak(label_feedback.text)
		return
		
	p.modify_money(-cost)
	p.set_instrument_tier(cat, target_tier)
	EventBus.money_changed.emit(p.money, -cost, "instrument_purchase")
	upgrade_purchased.emit("%s_tier_%d" % [cat, target_tier], cost)
	
	label_feedback.text = "Congratulazioni! Hai acquistato: %s!" % inst.get("name", "")
	select_gear_category(cat)
	_refresh_money_display()
	AccessibilityManager.speak(label_feedback.text)

# --- SCHEDA 4: HARDWARE STUDIO ---
func _refresh_studio_view() -> void:
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	var hw_tier: int = p.studio_hardware_tier
	label_studio_current.text = "Setup Attuale: %s (Cap Esecuzione: %.0f, Bonus Qualità: +%.0f)" % [
		UpgradeData.get_studio_hardware_name(hw_tier),
		UpgradeData.get_studio_hardware_cap(hw_tier),
		UpgradeData.get_studio_hardware_bonus(hw_tier)
	]
	
	btn_studio_1.text = "A. Mic Condensatore & USB (400 €) — %s" % ("Posseduto" if hw_tier >= 1 else "Acquista")
	btn_studio_2.text = "B. Pre Valvolare & Monitor (1.200 €) — %s" % ("Posseduto" if hw_tier >= 2 else "Acquista")
	btn_studio_3.text = "C. Banco Mixer & Mastering (3.500 €) — %s" % ("Posseduto" if hw_tier >= 3 else "Acquista")

func _on_buy_studio_hardware(tier: int) -> void:
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	if p.studio_hardware_tier >= tier:
		label_feedback.text = "Possiedi già questa attrezzatura o un hardware superiore!"
		AccessibilityManager.speak(label_feedback.text)
		return
		
	var cost: float = float(UpgradeData.STUDIO_HARDWARE_COSTS[tier])
	if p.money < cost:
		label_feedback.text = "Fondi insufficienti (richiesti %.2f €)!" % cost
		AccessibilityManager.speak(label_feedback.text)
		return
		
	p.modify_money(-cost)
	p.studio_hardware_tier = tier
	EventBus.money_changed.emit(p.money, -cost, "studio_hardware_upgrade")
	upgrade_purchased.emit("studio_hw_%d" % tier, cost)
	
	label_feedback.text = "Acquistato con successo: %s!" % UpgradeData.get_studio_hardware_name(tier)
	_refresh_studio_view()
	_refresh_money_display()
	AccessibilityManager.speak(label_feedback.text)

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
		KEY_P:
			if current_tab == 2:
				_on_action_rehearse_pressed()
				get_viewport().set_input_as_handled()
		KEY_G:
			if current_tab == 3:
				select_gear_category("guitar")
				get_viewport().set_input_as_handled()
		KEY_B:
			if current_tab == 3:
				select_gear_category("bass")
				get_viewport().set_input_as_handled()
		KEY_D:
			if current_tab == 3:
				select_gear_category("drums")
				get_viewport().set_input_as_handled()
		KEY_V:
			if current_tab == 3:
				select_gear_category("vocals")
				get_viewport().set_input_as_handled()
		KEY_K:
			if current_tab == 3:
				select_gear_category("keyboards")
				get_viewport().set_input_as_handled()
		KEY_A:
			if current_tab == 2:
				_on_buy_rehearsal(UpgradeData.RehearsalTier.ACOUSTIC_PANELS)
			elif current_tab == 3:
				_on_buy_instrument(1)
			elif current_tab == 4:
				_on_buy_studio_hardware(UpgradeData.StudioHardwareTier.USB_CONDENSER)
			get_viewport().set_input_as_handled()
		KEY_B:
			if current_tab == 2:
				_on_buy_rehearsal(UpgradeData.RehearsalTier.PRO_ISOLATION)
			elif current_tab == 4:
				_on_buy_studio_hardware(UpgradeData.StudioHardwareTier.TUBE_PREAMP)
			get_viewport().set_input_as_handled()
		KEY_C:
			if current_tab == 2:
				_on_buy_rehearsal(UpgradeData.RehearsalTier.MASTER_STUDIO)
			elif current_tab == 3:
				_on_buy_instrument(3)
			elif current_tab == 4:
				_on_buy_studio_hardware(UpgradeData.StudioHardwareTier.ANALOG_CONSOLE)
			get_viewport().set_input_as_handled()

func _on_close_pressed() -> void:
	close()
