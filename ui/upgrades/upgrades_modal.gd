# res://ui/upgrades/upgrades_modal.gd
extends Control

## Modale per la Macro-Area 4: Skills, Upgrade & Strumentazione (World-tour V5.0 - Sezione 4)
## Gestione spazio vitale, sala prove con sub-affitto, negozio multicategoria, sound shaping (pedali/ampli),
## liuteria (usura/muletto) e hardware studio (digitale/analogico).
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
@onready var hbox_tabs: HBoxContainer = $PanelMain/Margin/VBox/HBoxTabs
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

# Elementi aggiuntivi Sezione 4 (creati dinamicamente per compatibilità e robustezza)
var btn_tab_shaping: Button = null
var panel_shaping: VBoxContainer = null

# Controlli Scheda 2 (Sub-affitto)
var btn_toggle_sublet: Button = null

# Controlli Scheda 3 (Equipaggia band)
var btn_equip_band: Button = null

# Controlli Scheda 4 (Filosofia Nastro/Digitale)
var btn_toggle_philosophy: Button = null

# Controlli Scheda 5 (Sound Shaping & Liutaio)
var label_shaping_status: Label = null
var btn_amp_1: Button = null
var btn_amp_2: Button = null
var label_pedalboard_status: Label = null
var pedal_buttons: Dictionary = {}
var label_luthier_status: Label = null
var btn_luthier_basic: Button = null
var btn_luthier_full: Button = null
var btn_buy_backup: Button = null

var current_tab: int = 1 # 1: Alloggi, 2: Sala Prove, 3: Strumenti, 4: Hardware, 5: Sound Shaping & Liutaio
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
	
	_build_section_4_extensions()
	_hook_accessibility()

func _build_section_4_extensions() -> void:
	# 1. Pulsante Sub-affitto in Scheda 2
	btn_toggle_sublet = Button.new()
	btn_toggle_sublet.custom_minimum_size = Vector2(0, 36)
	btn_toggle_sublet.pressed.connect(_on_toggle_sublet_pressed)
	panel_rehearsal.add_child(btn_toggle_sublet)
	
	# 2. Pulsante Assegna alla Band in Scheda 3
	btn_equip_band = Button.new()
	btn_equip_band.custom_minimum_size = Vector2(0, 36)
	btn_equip_band.pressed.connect(_on_equip_band_pressed)
	panel_gear.add_child(btn_equip_band)
	
	# 3. Pulsante Filosofia di Registrazione in Scheda 4
	btn_toggle_philosophy = Button.new()
	btn_toggle_philosophy.custom_minimum_size = Vector2(0, 36)
	btn_toggle_philosophy.pressed.connect(_on_toggle_philosophy_pressed)
	panel_studio.add_child(btn_toggle_philosophy)
	
	# 4. Tab 5: Sound Shaping & Liutaio
	btn_tab_shaping = Button.new()
	btn_tab_shaping.text = "5. Sound Shaping & Liutaio"
	btn_tab_shaping.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn_tab_shaping.pressed.connect(func(): select_tab(5))
	hbox_tabs.add_child(btn_tab_shaping)
	
	panel_shaping = VBoxContainer.new()
	panel_shaping.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel_shaping.visible = false
	panel_shaping.add_theme_constant_override("separation", 8)
	
	label_shaping_status = Label.new()
	label_shaping_status.text = "Amplificatore Attuale: Standard Transistor (Base)"
	label_shaping_status.add_theme_color_override("font_color", Color(0.2, 0.85, 0.4, 1.0))
	panel_shaping.add_child(label_shaping_status)
	
	var hbox_amps := HBoxContainer.new()
	hbox_amps.add_theme_constant_override("separation", 8)
	btn_amp_1 = Button.new()
	btn_amp_1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn_amp_1.text = "A. Valvolare Britannico (600 €) — Rock/Indie"
	btn_amp_1.pressed.connect(func(): _on_buy_amp(UpgradeData.AmpType.BRITISH_TUBE))
	hbox_amps.add_child(btn_amp_1)
	
	btn_amp_2 = Button.new()
	btn_amp_2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn_amp_2.text = "B. American Clean (600 €) — Pop/Metal"
	btn_amp_2.pressed.connect(func(): _on_buy_amp(UpgradeData.AmpType.AMERICAN_CLEAN))
	hbox_amps.add_child(btn_amp_2)
	panel_shaping.add_child(hbox_amps)
	
	label_pedalboard_status = Label.new()
	label_pedalboard_status.text = "Pedalboard (Max 3): Nessun pedale attivo"
	label_pedalboard_status.add_theme_color_override("font_color", Color(0.9, 0.85, 0.3, 1.0))
	panel_shaping.add_child(label_pedalboard_status)
	
	var hbox_pedals := HBoxContainer.new()
	hbox_pedals.add_theme_constant_override("separation", 6)
	for p_id in UpgradeData.get_all_pedal_ids():
		var p_data: Dictionary = UpgradeData.get_pedal(p_id)
		var b := Button.new()
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.text = "%s (%.0f €)" % [p_data.get("name", p_id), p_data.get("cost", 100.0)]
		var this_id: String = p_id
		b.pressed.connect(func(): _on_toggle_pedal_pressed(this_id))
		pedal_buttons[this_id] = b
		hbox_pedals.add_child(b)
	panel_shaping.add_child(hbox_pedals)
	
	label_luthier_status = Label.new()
	label_luthier_status.text = "Liuteria: Condizione Strumento 100% | Muletto nel van: Assente"
	label_luthier_status.add_theme_color_override("font_color", Color(0.3, 0.85, 0.9, 1.0))
	panel_shaping.add_child(label_luthier_status)
	
	var hbox_luthier := HBoxContainer.new()
	hbox_luthier.add_theme_constant_override("separation", 8)
	btn_luthier_basic = Button.new()
	btn_luthier_basic.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn_luthier_basic.text = "Manutenzione Corde (30 €)"
	btn_luthier_basic.pressed.connect(func(): _on_luthier_service(false))
	hbox_luthier.add_child(btn_luthier_basic)
	
	btn_luthier_full = Button.new()
	btn_luthier_full.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn_luthier_full.text = "Rettifica Liuteria (80 €)"
	btn_luthier_full.pressed.connect(func(): _on_luthier_service(true))
	hbox_luthier.add_child(btn_luthier_full)
	
	btn_buy_backup = Button.new()
	btn_buy_backup.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn_buy_backup.text = "Muletto Van (150 €)"
	btn_buy_backup.pressed.connect(_on_buy_backup_pressed)
	hbox_luthier.add_child(btn_buy_backup)
	panel_shaping.add_child(hbox_luthier)
	
	var vbox_root: VBoxContainer = $PanelMain/Margin/VBox
	vbox_root.add_child(panel_shaping)
	vbox_root.move_child(panel_shaping, label_feedback.get_index())

func _hook_accessibility() -> void:
	AccessibilityManager.hook_control_accessibility(btn_close, "Chiudi Finestra Upgrades (Esc)", "Chiude la finestra dei miglioramenti e torna all'HUD.")
	AccessibilityManager.hook_control_accessibility(btn_tab_housing, "Scheda 1: Spazio Vitale e Alloggi", "Gestione residenza e traslochi.")
	AccessibilityManager.hook_control_accessibility(btn_tab_rehearsal, "Scheda 2: Sala Prove", "Insonorizzazione, prove e sub-affitto.")
	AccessibilityManager.hook_control_accessibility(btn_tab_gear, "Scheda 3: Negozio Strumenti", "Acquisto chitarre, bassi, batterie, microfoni e tastiere.")
	AccessibilityManager.hook_control_accessibility(btn_tab_studio, "Scheda 4: Hardware Studio", "Microfoni, schede audio, mixer e filosofia di registrazione.")
	if btn_tab_shaping:
		AccessibilityManager.hook_control_accessibility(btn_tab_shaping, "Scheda 5: Sound Shaping e Liuteria", "Pedalboard, amplificatori, manutenzione liutaio e muletto di riserva.")

func open() -> void:
	visible = true
	label_feedback.text = ""
	_refresh_money_display()
	select_tab(1)
	btn_tab_housing.grab_focus()
	AccessibilityManager.speak(
		"Schermata Skills e Upgrade aperta. 5 categorie disponibili: 1 Spazio Vitale, 2 Sala Prove, 3 Negozio Strumenti, 4 Hardware di Registrazione, 5 Sound Shaping e Liuteria. Premi i tasti 1-5 per cambiare scheda, Esc per chiudere."
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
	if panel_shaping:
		panel_shaping.visible = (tab_idx == 5)
	label_feedback.text = ""
	
	match tab_idx:
		1:
			_refresh_housing_view()
			AccessibilityManager.speak("Scheda 1: Spazio Vitale e Alloggi. Seleziona la residenza per cambiare canone e recupero.")
		2:
			_refresh_rehearsal_view()
			AccessibilityManager.speak("Scheda 2: Sala Prove. Acquista insonorizzazione per ridurre lo stress, premi P per fare le prove o S per sub-affitto.")
		3:
			select_gear_category(selected_instrument_category)
			AccessibilityManager.speak("Scheda 3: Negozio Strumenti Multicategoria. Usa i tasti G, B, D, V, K per selezionare la categoria, E per equipaggiare la band.")
		4:
			_refresh_studio_view()
			AccessibilityManager.speak("Scheda 4: Hardware Studio. Acquista microfoni e mixer, o premi F per cambiare tra Digitale HD e Nastro Analogico.")
		5:
			_refresh_shaping_view()
			AccessibilityManager.speak("Scheda 5: Sound Shaping e Liuteria. Configura amplificatori, pedali, o effettua la manutenzione dallo strumento dal liutaio.")

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
	
	if btn_toggle_sublet:
		var sublet_txt: String = "ATTIVO (+%s €/giorno)" % ("50" if r_tier >= 3 else "20") if p.rehearsal_sublet_active else "DISATTIVATO"
		btn_toggle_sublet.text = "Sub-affitto Sala a Band Esterne (S): %s" % sublet_txt

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
	var res: Dictionary = GameManager.band_system.hold_rehearsal_session(true)
	if res.get("success", false):
		label_feedback.text = res.get("message", "Prove completate con successo!")
	else:
		label_feedback.text = res.get("message", "Impossibile svolgere le prove.")
	_refresh_money_display()
	AccessibilityManager.speak(label_feedback.text)

func _on_toggle_sublet_pressed() -> void:
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	if p.rehearsal_tier < UpgradeData.RehearsalTier.PRO_ISOLATION:
		label_feedback.text = "Il sub-affitto commerciale richiede almeno l'Insonorizzazione Professionale (Tier 2)!"
		AccessibilityManager.speak(label_feedback.text)
		return
	p.rehearsal_sublet_active = not p.rehearsal_sublet_active
	var msg: String = "Sub-affitto sala prove attivato (+%s € al giorno a fine giornata)!" % ("50" if p.rehearsal_tier >= 3 else "20") if p.rehearsal_sublet_active else "Sub-affitto sala prove disattivato."
	label_feedback.text = msg
	_refresh_rehearsal_view()
	AccessibilityManager.speak(msg)

# --- SCHEDA 3: NEGOZIO STRUMENTI ---
func select_gear_category(cat: String) -> void:
	selected_instrument_category = cat
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	var cur_tier: int = p.get_instrument_tier(cat)
	var cur_inst: Dictionary = UpgradeData.get_instrument(cat, cur_tier)
	var cond: float = p.get_instrument_condition(cat)
	
	label_gear_current.text = "Categoria: %s | In Dotazione: %s (Tier %d) | Condizione: %.0f%%" % [
		UpgradeData.get_category_display_name(cat),
		cur_inst.get("name", "Starter"),
		cur_tier,
		cond
	]
	
	var m1: Dictionary = UpgradeData.get_instrument(cat, 1)
	var m2: Dictionary = UpgradeData.get_instrument(cat, 2)
	var m3: Dictionary = UpgradeData.get_instrument(cat, 3)
	
	btn_gear_1.text = "A. %s (%.0f €) — %s" % [m1.get("name", ""), m1.get("cost", 0.0), "In Dotazione" if cur_tier >= 1 else "Acquista"]
	btn_gear_2.text = "B. %s (%.0f €) — %s" % [m2.get("name", ""), m2.get("cost", 0.0), "In Dotazione" if cur_tier >= 2 else "Acquista"]
	btn_gear_3.text = "C. %s (%.0f €) — %s" % [m3.get("name", ""), m3.get("cost", 0.0), "In Dotazione" if cur_tier >= 3 else "Acquista"]
	
	if btn_equip_band:
		btn_equip_band.text = "Assegna Dotazione Tier %d alla Band (Premi E)" % cur_tier
	
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
	p.instrument_condition[cat] = 100.0
	EventBus.money_changed.emit(p.money, -cost, "instrument_purchase")
	upgrade_purchased.emit("%s_tier_%d" % [cat, target_tier], cost)
	
	label_feedback.text = "Congratulazioni! Hai acquistato: %s!" % inst.get("name", "")
	select_gear_category(cat)
	_refresh_money_display()
	AccessibilityManager.speak(label_feedback.text)

func _on_equip_band_pressed() -> void:
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	var cat: String = selected_instrument_category
	var cur_tier: int = p.get_instrument_tier(cat)
	var equipped_count: int = 0
	
	for m in p.band_members:
		var member_cat: String = "bass"
		match m.role:
			Enums.BandRole.BASS: member_cat = "bass"
			Enums.BandRole.DRUMS: member_cat = "drums"
			Enums.BandRole.KEYBOARDS: member_cat = "keyboards"
			Enums.BandRole.GUITAR_RHYTHM: member_cat = "guitar"
			Enums.BandRole.VOCALS: member_cat = "vocals"
		if member_cat == cat:
			m.equip_gear(cur_tier)
			equipped_count += 1
			
	if equipped_count > 0:
		label_feedback.text = "Strumentazione %s (Tier %d) equipaggiata a %d compagni della band! Sinergia aumentata." % [
			UpgradeData.get_category_display_name(cat), cur_tier, equipped_count
		]
	else:
		label_feedback.text = "Nessun membro della band corrisponde al ruolo di %s." % UpgradeData.get_category_display_name(cat)
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
	
	if btn_toggle_philosophy:
		var phil_name: String = UpgradeData.get_recording_philosophy_name(p.recording_philosophy)
		btn_toggle_philosophy.text = "Filosofia Registrazione (Premi F): %s %s" % [
			phil_name, "(Costo bobine: 25 €)" if p.recording_philosophy == 1 else "(Costo: 0 €)"
		]

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

func _on_toggle_philosophy_pressed() -> void:
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	p.recording_philosophy = 0 if p.recording_philosophy == 1 else 1
	var msg: String = "Filosofia impostata su: %s." % UpgradeData.get_recording_philosophy_name(p.recording_philosophy)
	label_feedback.text = msg
	_refresh_studio_view()
	AccessibilityManager.speak(msg)

# --- SCHEDA 5: SOUND SHAPING & LIUTAIO ---
func _refresh_shaping_view() -> void:
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	var amp: Dictionary = UpgradeData.get_amp_model(p.current_amp_tier)
	label_shaping_status.text = "Amplificatore Attivo: %s" % amp.get("name", "Standard")
	
	btn_amp_1.text = "A. Valvolare Britannico (600 €) — %s" % ("Attivo" if p.current_amp_tier == 1 else "Equipaggia")
	btn_amp_2.text = "B. American Clean (600 €) — %s" % ("Attivo" if p.current_amp_tier == 2 else "Equipaggia")
	
	var active_names: Array = []
	for p_id in p.active_pedalboard:
		var p_info: Dictionary = UpgradeData.get_pedal(p_id)
		active_names.append(p_info.get("name", p_id))
	var board_str: String = ", ".join(active_names) if not active_names.is_empty() else "Nessuno (fino a 3 slot)"
	label_pedalboard_status.text = "Pedalboard Attiva (%d/3): %s" % [p.active_pedalboard.size(), board_str]
	
	for p_id in pedal_buttons:
		var btn: Button = pedal_buttons[p_id]
		var p_data: Dictionary = UpgradeData.get_pedal(p_id)
		var is_owned: bool = p.owned_pedals.has(p_id)
		var is_active: bool = p.active_pedalboard.has(p_id)
		var status_str: String = "IN PEDALBOARD" if is_active else ("Posseduto" if is_owned else "Acquista")
		btn.text = "%s — %s" % [p_data.get("name", p_id), status_str]
		
	var p_cat: String = p.get_primary_category()
	var cond: float = p.get_instrument_condition(p_cat)
	var state_desc: String = "Ottimo" if cond >= 70.0 else ("Usurato" if cond >= 40.0 else "CRITICO (< 20%)")
	label_luthier_status.text = "Integrità Strumento (%s): %.0f%% [%s] | Muletto nel van: %s" % [
		UpgradeData.get_category_display_name(p_cat), cond, state_desc, "PRESENTE" if p.has_backup_instrument else "ASSENTE"
	]
	btn_buy_backup.text = "Muletto Van (150 €) — %s" % ("Posseduto" if p.has_backup_instrument else "Acquista")

func _on_buy_amp(tier: int) -> void:
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	if p.current_amp_tier == tier:
		label_feedback.text = "Stai già usando questo amplificatore!"
		AccessibilityManager.speak(label_feedback.text)
		return
	var amp: Dictionary = UpgradeData.get_amp_model(tier)
	var cost: float = float(amp.get("cost", 600.0))
	if p.money < cost:
		label_feedback.text = "Fondi insufficienti per l'amplificatore (richiesti %.2f €)!" % cost
		AccessibilityManager.speak(label_feedback.text)
		return
	p.modify_money(-cost)
	p.current_amp_tier = tier
	EventBus.money_changed.emit(p.money, -cost, "amp_purchase")
	label_feedback.text = "Equipaggiato: %s!" % amp.get("name", "")
	_refresh_shaping_view()
	_refresh_money_display()
	AccessibilityManager.speak(label_feedback.text)

func _on_toggle_pedal_pressed(pedal_id: String) -> void:
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	var p_data: Dictionary = UpgradeData.get_pedal(pedal_id)
	if not p.owned_pedals.has(pedal_id):
		var cost: float = float(p_data.get("cost", 100.0))
		if p.money < cost:
			label_feedback.text = "Fondi insufficienti per acquistare %s (richiesti %.2f €)!" % [p_data.get("name", ""), cost]
			AccessibilityManager.speak(label_feedback.text)
			return
		p.modify_money(-cost)
		p.owned_pedals.append(pedal_id)
		EventBus.money_changed.emit(p.money, -cost, "pedal_purchase")
		p.equip_pedal(pedal_id)
		label_feedback.text = "Acquistato e inserito in pedalboard: %s!" % p_data.get("name", "")
	else:
		if p.active_pedalboard.has(pedal_id):
			p.unequip_pedal(pedal_id)
			label_feedback.text = "Rimosso dalla pedalboard: %s." % p_data.get("name", "")
		else:
			if p.equip_pedal(pedal_id):
				label_feedback.text = "Inserito in pedalboard: %s." % p_data.get("name", "")
			else:
				label_feedback.text = "Pedalboard piena (massimo 3 pedali attivi simultaneamente)!"
	_refresh_shaping_view()
	_refresh_money_display()
	AccessibilityManager.speak(label_feedback.text)

func _on_luthier_service(full_service: bool) -> void:
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	var p_cat: String = p.get_primary_category()
	var res: Dictionary = p.repair_instrument(p_cat, full_service)
	if res.get("success", false):
		label_feedback.text = "Intervento liuteria completato! Integrità strumento ripristinata al 100%."
		_refresh_shaping_view()
		_refresh_money_display()
	else:
		label_feedback.text = "Fondi insufficienti per il liutaio (richiesti %.2f €)!" % float(res.get("cost", 30.0))
	AccessibilityManager.speak(label_feedback.text)

func _on_buy_backup_pressed() -> void:
	if not GameManager or not GameManager.player_data:
		return
	var p: PlayerData = GameManager.player_data
	if p.has_backup_instrument:
		label_feedback.text = "Possiedi già uno strumento di riserva (muletto) nel van!"
		AccessibilityManager.speak(label_feedback.text)
		return
	var cost: float = Constants.COST_BACKUP_INSTRUMENT
	if p.money < cost:
		label_feedback.text = "Fondi insufficienti per il muletto di riserva (richiesti %.2f €)!" % cost
		AccessibilityManager.speak(label_feedback.text)
		return
	p.modify_money(-cost)
	p.has_backup_instrument = true
	EventBus.money_changed.emit(p.money, -cost, "backup_instrument_purchase")
	label_feedback.text = "Muletto di riserva acquistato e riposto nel van! Incidenti live azzerati."
	_refresh_shaping_view()
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
		KEY_5:
			select_tab(5)
			get_viewport().set_input_as_handled()
		KEY_P:
			if current_tab == 2:
				_on_action_rehearse_pressed()
				get_viewport().set_input_as_handled()
		KEY_S:
			if current_tab == 2:
				_on_toggle_sublet_pressed()
				get_viewport().set_input_as_handled()
		KEY_F:
			if current_tab == 4:
				_on_toggle_philosophy_pressed()
				get_viewport().set_input_as_handled()
		KEY_E:
			if current_tab == 3:
				_on_equip_band_pressed()
				get_viewport().set_input_as_handled()
		KEY_G:
			if current_tab == 3:
				select_gear_category("guitar")
				get_viewport().set_input_as_handled()
		KEY_B:
			if current_tab == 3:
				select_gear_category("bass")
			elif current_tab == 2:
				_on_buy_rehearsal(UpgradeData.RehearsalTier.PRO_ISOLATION)
			elif current_tab == 4:
				_on_buy_studio_hardware(UpgradeData.StudioHardwareTier.TUBE_PREAMP)
			elif current_tab == 5:
				_on_buy_amp(UpgradeData.AmpType.AMERICAN_CLEAN)
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
			elif current_tab == 5:
				_on_buy_amp(UpgradeData.AmpType.BRITISH_TUBE)
			get_viewport().set_input_as_handled()
		KEY_C:
			if current_tab == 2:
				_on_buy_rehearsal(UpgradeData.RehearsalTier.MASTER_STUDIO)
			elif current_tab == 3:
				_on_buy_instrument(3)
			elif current_tab == 4:
				_on_buy_studio_hardware(UpgradeData.StudioHardwareTier.ANALOG_CONSOLE)
			get_viewport().set_input_as_handled()
		KEY_O:
			if current_tab == 5:
				_on_luthier_service(false)
				get_viewport().set_input_as_handled()
		KEY_R:
			if current_tab == 5:
				_on_luthier_service(true)
				get_viewport().set_input_as_handled()
		KEY_M:
			if current_tab == 5:
				_on_buy_backup_pressed()
				get_viewport().set_input_as_handled()

func _on_close_pressed() -> void:
	close()
