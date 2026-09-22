# res://ui/industry/industry_hub.gd
extends Control

## Controller della Dashboard Industria Musicale, Contratti Discografici & Manager (World-tour V3.0)
## Gestisce la negoziazione di contratti (Indie vs Major), il recoupment del debito,
## e la rappresentanza artistica tramite 3 profili di manager.
## Totalmente accessibile con NVDA e con interfaccia ad alto contrasto per monitor.

signal closed()

enum HubTab { CONTRACTS = 0, MANAGERS = 1 }

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var label_status_summary: Label = $PanelMain/VBox/Header/LabelStatusSummary

@onready var btn_tab_contracts: Button = $PanelMain/VBox/HBoxTabs/BtnTabContracts
@onready var btn_tab_managers: Button = $PanelMain/VBox/HBoxTabs/BtnTabManagers

@onready var tab_contracts: VBoxContainer = $PanelMain/VBox/TabContracts
@onready var tab_managers: VBoxContainer = $PanelMain/VBox/TabManagers

# Contratti
@onready var label_active_contract_title: Label = $PanelMain/VBox/TabContracts/PanelActiveContract/VBox/LabelActiveContractTitle
@onready var label_active_contract_details: Label = $PanelMain/VBox/TabContracts/PanelActiveContract/VBox/LabelActiveContractDetails
@onready var btn_rescind_contract: Button = $PanelMain/VBox/TabContracts/PanelActiveContract/VBox/HBoxActions/BtnRescindContract

@onready var vbox_offers_list: VBoxContainer = $PanelMain/VBox/TabContracts/ScrollOffers/VBoxOffersList
@onready var label_no_offers: Label = $PanelMain/VBox/TabContracts/LabelNoOffers
@onready var btn_refresh_offers: Button = $PanelMain/VBox/TabContracts/HBoxOffersHeader/BtnRefreshOffers

# Manager
@onready var label_active_manager_title: Label = $PanelMain/VBox/TabManagers/PanelActiveManager/VBox/LabelActiveManagerTitle
@onready var label_active_manager_details: Label = $PanelMain/VBox/TabManagers/PanelActiveManager/VBox/LabelActiveManagerDetails
@onready var btn_fire_manager: Button = $PanelMain/VBox/TabManagers/PanelActiveManager/VBox/HBoxActions/BtnFireManager

@onready var vbox_managers_list: VBoxContainer = $PanelMain/VBox/TabManagers/ScrollManagers/VBoxManagersList

@onready var btn_close: Button = $PanelMain/VBox/HBoxFooter/BtnClose

var current_tab: int = HubTab.CONTRACTS

func _ready() -> void:
	btn_tab_contracts.pressed.connect(func(): _set_tab(HubTab.CONTRACTS))
	btn_tab_managers.pressed.connect(func(): _set_tab(HubTab.MANAGERS))
	btn_close.pressed.connect(close)
	btn_refresh_offers.pressed.connect(_on_refresh_offers_pressed)
	btn_rescind_contract.pressed.connect(_on_rescind_contract_pressed)
	btn_fire_manager.pressed.connect(_on_fire_manager_pressed)
	
	_setup_accessibility_hooks()

func _resolve_nodes() -> void:
	if not label_title:
		label_title = get_node_or_null("PanelMain/VBox/Header/LabelTitle")
		label_status_summary = get_node_or_null("PanelMain/VBox/Header/LabelStatusSummary")
		btn_tab_contracts = get_node_or_null("PanelMain/VBox/HBoxTabs/BtnTabContracts")
		btn_tab_managers = get_node_or_null("PanelMain/VBox/HBoxTabs/BtnTabManagers")
		tab_contracts = get_node_or_null("PanelMain/VBox/TabContracts")
		tab_managers = get_node_or_null("PanelMain/VBox/TabManagers")
		label_active_contract_title = get_node_or_null("PanelMain/VBox/TabContracts/PanelActiveContract/VBox/LabelActiveContractTitle")
		label_active_contract_details = get_node_or_null("PanelMain/VBox/TabContracts/PanelActiveContract/VBox/LabelActiveContractDetails")
		btn_rescind_contract = get_node_or_null("PanelMain/VBox/TabContracts/PanelActiveContract/VBox/HBoxActions/BtnRescindContract")
		vbox_offers_list = get_node_or_null("PanelMain/VBox/TabContracts/ScrollOffers/VBoxOffersList")
		label_no_offers = get_node_or_null("PanelMain/VBox/TabContracts/LabelNoOffers")
		btn_refresh_offers = get_node_or_null("PanelMain/VBox/TabContracts/HBoxOffersHeader/BtnRefreshOffers")
		label_active_manager_title = get_node_or_null("PanelMain/VBox/TabManagers/PanelActiveManager/VBox/LabelActiveManagerTitle")
		label_active_manager_details = get_node_or_null("PanelMain/VBox/TabManagers/PanelActiveManager/VBox/LabelActiveManagerDetails")
		btn_fire_manager = get_node_or_null("PanelMain/VBox/TabManagers/PanelActiveManager/VBox/HBoxActions/BtnFireManager")
		vbox_managers_list = get_node_or_null("PanelMain/VBox/TabManagers/ScrollManagers/VBoxManagersList")
		btn_close = get_node_or_null("PanelMain/VBox/HBoxFooter/BtnClose")

func _setup_accessibility_hooks() -> void:
	_resolve_nodes()
	if btn_tab_contracts:
		AccessibilityManager.hook_control_accessibility(btn_tab_contracts, "Scheda Contratti Discografici", "Tasto 1. Consulta il contratto in corso, lo stato del recoupment e le offerte delle etichette.")
	if btn_tab_managers:
		AccessibilityManager.hook_control_accessibility(btn_tab_managers, "Scheda Manager e Rappresentanza", "Tasto 2. Consulta il manager attuale o ingaggia un nuovo rappresentante.")
	if btn_refresh_offers:
		AccessibilityManager.hook_control_accessibility(btn_refresh_offers, "Cerca Nuove Offerte Discografiche", "Tasto R. Genera nuove proposte contrattuali in base alla tua reputazione attuale.")
	if btn_rescind_contract:
		AccessibilityManager.hook_control_accessibility(btn_rescind_contract, "Rescindi Contratto Discografico", "Rescindi anticipatamente l'accordo discografico attivo subendo una penalità di reputazione.")
	if btn_fire_manager:
		AccessibilityManager.hook_control_accessibility(btn_fire_manager, "Licenzia Manager", "Interrompi la collaborazione con il tuo manager attuale.")
	if btn_close:
		AccessibilityManager.hook_control_accessibility(btn_close, "Chiudi Schermata Industria", "Tasto Esc o K. Torna all'HUD di gioco.")

func open() -> void:
	visible = true
	_resolve_nodes()
	_set_tab(HubTab.CONTRACTS)
	refresh_hub()
	if btn_tab_contracts:
		btn_tab_contracts.grab_focus()
	
	# Annuncio vocale iniziale sintetico per NVDA
	var player: PlayerData = GameManager.player_data if GameManager else null
	var contract_str := "Autoproduzione"
	if player and player.active_contract:
		contract_str = "%s (%s)" % [player.active_contract.label_name, player.active_contract.get_type_name()]
	var manager_str := "Nessun Manager"
	if player and player.active_manager:
		manager_str = "%s (%s)" % [player.active_manager.manager_name, player.active_manager.get_type_name()]
		
	var speech: String = "Industria Musicale e Contratti. Contratto: %s. Manager: %s. Premi 1 per Contratti, 2 per Manager, Esc o K per uscire." % [
		contract_str,
		manager_str
	]
	AccessibilityManager.announce(speech, true)

func close() -> void:
	visible = false
	closed.emit()

func _set_tab(tab: int) -> void:
	current_tab = tab
	_resolve_nodes()
	if tab_contracts:
		tab_contracts.visible = (tab == HubTab.CONTRACTS)
	if tab_managers:
		tab_managers.visible = (tab == HubTab.MANAGERS)
		
	if tab == HubTab.CONTRACTS:
		AccessibilityManager.announce("Scheda Contratti Discografici attiva. Consulta lo stato del contratto o le offerte.", false)
	else:
		AccessibilityManager.announce("Scheda Manager e Rappresentanza attiva. Consulta il manager attuale o ingaggia un nuovo professionista.", false)

func refresh_hub() -> void:
	_resolve_nodes()
	if not GameManager or not GameManager.player_data:
		return
		
	var player: PlayerData = GameManager.player_data
	var ind_sys: IndustrySystem = GameManager.industry_system
	
	# Header Status
	var c_name := "Autoproduzione"
	if player.active_contract:
		c_name = "%s (%s)" % [player.active_contract.label_name, player.active_contract.get_type_name()]
	var m_name := "Nessuno"
	if player.active_manager:
		m_name = "%s (%s)" % [player.active_manager.manager_name, player.active_manager.get_type_name()]
	if label_status_summary:
		label_status_summary.text = "Contratto: %s | Manager: %s" % [c_name, m_name]
		
	_refresh_contracts_tab(player, ind_sys)
	_refresh_managers_tab(player, ind_sys)

func _refresh_contracts_tab(player: PlayerData, ind_sys: IndustrySystem) -> void:
	# 1. Contratto attivo
	if player.active_contract:
		var c: ContractData = player.active_contract
		label_active_contract_title.text = "Contratto in Vigore: %s [%s]" % [c.label_name, c.get_type_name().to_upper()]
		
		var pct_recouped: float = 0.0
		if c.advance_amount > 0.0:
			pct_recouped = clampf((c.advance_amount - c.unrecouped_debt) / c.advance_amount * 100.0, 0.0, 100.0)
			
		label_active_contract_details.text = "Anticipo Ricevuto: %.2f € | Debito Residuo da Recuperare: %.2f € (%.1f%% recuperato)\nRoyalty Artista: %.1f%% | Album Consegnati: %d su %d\nControllo A&R: %s" % [
			c.advance_amount,
			c.unrecouped_debt,
			pct_recouped,
			c.royalty_rate * 100.0,
			c.delivered_albums,
			c.required_albums,
			"Rigoroso (Major: Qualità min. %.0f)" % c.min_quality_target if c.is_major() else "Totale Libertà Creativa (Indie)"
		]
		btn_rescind_contract.visible = true
		btn_rescind_contract.text = "Rescindi Contratto (Penalità: -15 Rep.)"
	else:
		label_active_contract_title.text = "Regime di Autoproduzione (Indipendente)"
		label_active_contract_details.text = "Attualmente non sei legato ad alcuna etichetta discografica.\nTrattieni il 100% dei ricavi da royalties sui brani e sugli album, ma non hai accesso ad anticipi liquidi né a supporto promozionale avanzato."
		btn_rescind_contract.visible = false

	# 2. Offerte disponibili
	for child in vbox_offers_list.get_children():
		child.queue_free()
		
	var offers: Array = player.available_contracts
	if offers.is_empty():
		label_no_offers.visible = true
	else:
		label_no_offers.visible = false
		for i in range(offers.size()):
			var offer: ContractData = offers[i]
			var row := _create_offer_row(offer, i)
			vbox_offers_list.add_child(row)

func _create_offer_row(offer: ContractData, _index: int) -> Control:
	var panel := PanelContainer.new()
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 14)
	
	var lbl := Label.new()
	lbl.custom_minimum_size = Vector2(560, 0)
	lbl.add_theme_font_size_override("font_size", 13)
	lbl.text = "• %s (%s)\n  Anticipo: %.2f € | Royalties Artista: %.1f%% | Album Richiesti: %d\n  Controllo: %s" % [
		offer.label_name,
		offer.get_type_name(),
		offer.advance_amount,
		offer.royalty_rate * 100.0,
		offer.required_albums,
		"Supervisione Major (Qualità min. %.0f)" % offer.min_quality_target if offer.is_major() else "Libertà Artistica Totale (Indie)"
	]
	
	var btn_sign := Button.new()
	btn_sign.text = "Firma Contratto"
	btn_sign.pressed.connect(func():
		if GameManager and GameManager.industry_system:
			var res: Dictionary = GameManager.industry_system.sign_contract(offer.id)
			if res.get("success", false):
				var speech: String = "Contratto firmato con %s! Ricevuto anticipo di %.2f euro. Debito iniziale da recuperare: %.2f euro." % [
					offer.label_name,
					offer.advance_amount,
					offer.unrecouped_debt
				]
				AccessibilityManager.announce(speech, true)
			else:
				AccessibilityManager.announce("Impossibile firmare il contratto: %s" % res.get("reason", "errore"), true)
			refresh_hub()
	)
	AccessibilityManager.hook_control_accessibility(btn_sign, "Firma Contratto con %s" % offer.label_name, "Anticipo immediato di %.2f euro, royalty al %.1f%%." % [offer.advance_amount, offer.royalty_rate * 100.0])
	
	hbox.add_child(lbl)
	hbox.add_child(btn_sign)
	panel.add_child(hbox)
	return panel

func _refresh_managers_tab(player: PlayerData, ind_sys: IndustrySystem) -> void:
	# 1. Manager Attivo
	if player.active_manager:
		var m: ManagerData = player.active_manager
		label_active_manager_title.text = "Manager Attivo: %s [%s]" % [m.manager_name, m.get_type_name()]
		label_active_manager_details.text = "Commissione sui Live: %.0f%%\nBoost Cachet Concerti: +%.0f%%\nSgravio Stress Giornaliero: -%.1f punti a notte" % [
			m.commission_pct * 100.0,
			(m.booking_cachet_multiplier - 1.0) * 100.0,
			m.daily_stress_relief
		]
		btn_fire_manager.visible = true
		btn_fire_manager.text = "Licenzia %s" % m.manager_name
	else:
		label_active_manager_title.text = "Nessun Manager Attivo"
		label_active_manager_details.text = "Nessun professionista gestisce la tua agenda o tratta per i tuoi ingaggi dal vivo.\nIngaggiare un manager aumenta gli incassi dei concerti e riduce il carico di stress organizzativo."
		btn_fire_manager.visible = false

	# 2. Profili Manager Disponibili
	for child in vbox_managers_list.get_children():
		child.queue_free()
		
	var profiles: Array[Dictionary] = [
		{
			"type": Enums.ManagerType.TRUSTED_FRIEND,
			"name": "Marco 'Bibo' (Amico Fidato)",
			"desc": "Un compagno fidato che ti dà una mano con date e volantini. Commissione minima (10%), +10% ai cachet, -1.0 stress al giorno.",
			"req_desc": "Nessun requisito (Disponibile da subito)",
			"eligible": true
		},
		{
			"type": Enums.ManagerType.PRO_INDIE,
			"name": "Giulia 'Rocket' Moretti (Manager Indipendente)",
			"desc": "Professionista della scena indipendente con ottimi contatti nei club. Commissione 15%, +25% ai cachet, -2.5 stress al giorno.",
			"req_desc": "Richiede Reputazione >= 20.0 e almeno 200 Fan",
			"eligible": (player.reputation >= 20.0 and player.fans >= 200)
		},
		{
			"type": Enums.ManagerType.INDUSTRY_SHARK,
			"name": "Vittorio 'The Shark' Sanna (Squalo del Settore)",
			"desc": "Agente spietato e influente che apre le porte dei grandi festival. Commissione 22%, +50% ai cachet, -4.0 stress al giorno.",
			"req_desc": "Richiede Reputazione >= 50.0 e almeno 1.000 Fan",
			"eligible": (player.reputation >= 50.0 and player.fans >= 1000)
		}
	]
	
	for prof in profiles:
		var row := _create_manager_row(prof, player, ind_sys)
		vbox_managers_list.add_child(row)

func _create_manager_row(prof: Dictionary, player: PlayerData, ind_sys: IndustrySystem) -> Control:
	var panel := PanelContainer.new()
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 14)
	
	var lbl := Label.new()
	lbl.custom_minimum_size = Vector2(560, 0)
	lbl.add_theme_font_size_override("font_size", 13)
	
	var is_current: bool = (player.active_manager and player.active_manager.manager_type == prof["type"])
	var status_tag := " [ATTUALMENTE INGAGGIATO]" if is_current else ""
	
	lbl.text = "• %s%s\n  %s\n  Requisiti: %s" % [
		prof["name"],
		status_tag,
		prof["desc"],
		prof["req_desc"]
	]
	
	var btn_hire := Button.new()
	btn_hire.text = "Ingaggia"
	if is_current:
		btn_hire.text = "In Servizio"
		btn_hire.disabled = true
	elif not prof["eligible"]:
		btn_hire.text = "Requisiti Mancanti"
		btn_hire.disabled = true
	else:
		btn_hire.pressed.connect(func():
			if ind_sys:
				var res: Dictionary = ind_sys.hire_manager(prof["type"])
				if res.get("success", false):
					var speech: String = "Manager ingaggiato con successo: %s!" % prof["name"]
					AccessibilityManager.announce(speech, true)
				else:
					AccessibilityManager.announce("Impossibile ingaggiare il manager: %s" % res.get("reason", "errore"), true)
				refresh_hub()
		)
		
	AccessibilityManager.hook_control_accessibility(btn_hire, "Ingaggia %s" % prof["name"], "%s. %s" % [prof["desc"], prof["req_desc"]])
	
	hbox.add_child(lbl)
	hbox.add_child(btn_hire)
	panel.add_child(hbox)
	return panel

func _on_refresh_offers_pressed() -> void:
	if GameManager and GameManager.industry_system:
		var offers: Array = GameManager.industry_system.refresh_contract_offers()
		refresh_hub()
		var speech: String = "Trovate %d offerte discografiche disponibili." % offers.size()
		AccessibilityManager.announce(speech, true)

func _on_rescind_contract_pressed() -> void:
	if GameManager and GameManager.industry_system:
		var res: Dictionary = GameManager.industry_system.cancel_contract()
		if res.get("success", false):
			AccessibilityManager.announce("Contratto rescisso. Penalità applicata. Sei tornato in regime di autoproduzione.", true)
		else:
			AccessibilityManager.announce("Impossibile rescindere il contratto: %s" % res.get("reason", "errore"), true)
		refresh_hub()

func _on_fire_manager_pressed() -> void:
	if GameManager and GameManager.industry_system:
		var res: Dictionary = GameManager.industry_system.fire_manager()
		if res.get("success", false):
			AccessibilityManager.announce("Manager licenziato. Ora gestisci la tua attività in solitaria.", true)
		refresh_hub()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var key_event := event as InputEventKey
		if key_event.keycode == KEY_ESCAPE or key_event.keycode == KEY_K:
			close()
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_1:
			_set_tab(HubTab.CONTRACTS)
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_2:
			_set_tab(HubTab.MANAGERS)
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_R and current_tab == HubTab.CONTRACTS:
			_on_refresh_offers_pressed()
			get_viewport().set_input_as_handled()
