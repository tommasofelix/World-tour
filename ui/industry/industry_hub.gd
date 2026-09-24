# res://ui/industry/industry_hub.gd
extends Control

## Controller della Dashboard Industria Musicale, Contratti Discografici & Manager (World-tour V3.0 & Sezione 9)
## Gestisce la negoziazione contrattuale (Indie vs Major), il recoupment del debito,
## la distribuzione fisica esclusiva, la rinegoziazione, il riscatto dei master,
## la rappresentanza artistica del manager (fiducia, promesse, tutela legale) e la propria etichetta discografica indipendente.
## Totalmente accessibile con NVDA e con interfaccia ad alto contrasto per monitor.

signal closed()

enum HubTab { CONTRACTS = 0, MANAGERS = 1, OWN_LABEL = 2 }

const OwnLabelDataScript = preload("res://data/models/own_label_data.gd")

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var label_status_summary: Label = $PanelMain/VBox/Header/LabelStatusSummary

@onready var btn_tab_contracts: Button = $PanelMain/VBox/HBoxTabs/BtnTabContracts
@onready var btn_tab_managers: Button = $PanelMain/VBox/HBoxTabs/BtnTabManagers
@onready var btn_tab_own_label: Button = $PanelMain/VBox/HBoxTabs/BtnTabOwnLabel

@onready var tab_contracts: VBoxContainer = $PanelMain/VBox/TabContracts
@onready var tab_managers: VBoxContainer = $PanelMain/VBox/TabManagers
@onready var tab_own_label: VBoxContainer = $PanelMain/VBox/TabOwnLabel

# Contratti
@onready var label_active_contract_title: Label = $PanelMain/VBox/TabContracts/PanelActiveContract/VBox/LabelActiveContractTitle
@onready var label_active_contract_details: Label = $PanelMain/VBox/TabContracts/PanelActiveContract/VBox/LabelActiveContractDetails
@onready var btn_rescind_contract: Button = $PanelMain/VBox/TabContracts/PanelActiveContract/VBox/HBoxActions/BtnRescindContract
@onready var btn_renegotiate: Button = $PanelMain/VBox/TabContracts/PanelActiveContract/VBox/HBoxActions/BtnRenegotiate
@onready var btn_master_buyback: Button = $PanelMain/VBox/TabContracts/PanelActiveContract/VBox/HBoxActions/BtnMasterBuyback
@onready var btn_physical_dist: Button = $PanelMain/VBox/TabContracts/PanelActiveContract/VBox/HBoxActions/BtnPhysicalDist

@onready var vbox_offers_list: VBoxContainer = $PanelMain/VBox/TabContracts/ScrollOffers/VBoxOffersList
@onready var label_no_offers: Label = $PanelMain/VBox/TabContracts/LabelNoOffers
@onready var btn_refresh_offers: Button = $PanelMain/VBox/TabContracts/HBoxOffersHeader/BtnRefreshOffers

# Manager
@onready var label_active_manager_title: Label = $PanelMain/VBox/TabManagers/PanelActiveManager/VBox/LabelActiveManagerTitle
@onready var label_active_manager_details: Label = $PanelMain/VBox/TabManagers/PanelActiveManager/VBox/LabelActiveManagerDetails
@onready var btn_fire_manager: Button = $PanelMain/VBox/TabManagers/PanelActiveManager/VBox/HBoxActions/BtnFireManager
@onready var btn_hire_lawyer: Button = $PanelMain/VBox/TabManagers/PanelActiveManager/VBox/HBoxActions/BtnHireLawyer

@onready var vbox_managers_list: VBoxContainer = $PanelMain/VBox/TabManagers/ScrollManagers/VBoxManagersList

# Propria Etichetta
@onready var label_own_label_title: Label = $PanelMain/VBox/TabOwnLabel/PanelOwnLabelStatus/VBox/LabelOwnLabelTitle
@onready var label_own_label_details: Label = $PanelMain/VBox/TabOwnLabel/PanelOwnLabelStatus/VBox/LabelOwnLabelDetails
@onready var btn_found_label: Button = $PanelMain/VBox/TabOwnLabel/PanelOwnLabelStatus/VBox/HBoxOwnLabelActions/BtnFoundLabel
@onready var btn_scout_bands: Button = $PanelMain/VBox/TabOwnLabel/PanelOwnLabelStatus/VBox/HBoxOwnLabelActions/BtnScoutBands
@onready var vbox_roster_list: VBoxContainer = $PanelMain/VBox/TabOwnLabel/ScrollRoster/VBoxRosterList

@onready var btn_close: Button = $PanelMain/VBox/HBoxFooter/BtnClose

var current_tab: int = HubTab.CONTRACTS

func _ready() -> void:
	_resolve_nodes()
	if btn_tab_contracts:
		btn_tab_contracts.pressed.connect(func(): _set_tab(HubTab.CONTRACTS))
	if btn_tab_managers:
		btn_tab_managers.pressed.connect(func(): _set_tab(HubTab.MANAGERS))
	if btn_tab_own_label:
		btn_tab_own_label.pressed.connect(func(): _set_tab(HubTab.OWN_LABEL))
	if btn_close:
		btn_close.pressed.connect(close)
	if btn_refresh_offers:
		btn_refresh_offers.pressed.connect(_on_refresh_offers_pressed)
	if btn_rescind_contract:
		btn_rescind_contract.pressed.connect(_on_rescind_contract_pressed)
	if btn_renegotiate:
		btn_renegotiate.pressed.connect(_on_renegotiate_pressed)
	if btn_master_buyback:
		btn_master_buyback.pressed.connect(_on_master_buyback_pressed)
	if btn_physical_dist:
		btn_physical_dist.pressed.connect(_on_physical_dist_pressed)
	if btn_fire_manager:
		btn_fire_manager.pressed.connect(_on_fire_manager_pressed)
	if btn_hire_lawyer:
		btn_hire_lawyer.pressed.connect(_on_hire_lawyer_pressed)
	if btn_found_label:
		btn_found_label.pressed.connect(_on_found_label_pressed)
	if btn_scout_bands:
		btn_scout_bands.pressed.connect(_on_scout_bands_pressed)
	
	_setup_accessibility_hooks()

func _resolve_nodes() -> void:
	if not label_title:
		label_title = get_node_or_null("PanelMain/VBox/Header/LabelTitle")
		label_status_summary = get_node_or_null("PanelMain/VBox/Header/LabelStatusSummary")
		btn_tab_contracts = get_node_or_null("PanelMain/VBox/HBoxTabs/BtnTabContracts")
		btn_tab_managers = get_node_or_null("PanelMain/VBox/HBoxTabs/BtnTabManagers")
		btn_tab_own_label = get_node_or_null("PanelMain/VBox/HBoxTabs/BtnTabOwnLabel")
		tab_contracts = get_node_or_null("PanelMain/VBox/TabContracts")
		tab_managers = get_node_or_null("PanelMain/VBox/TabManagers")
		tab_own_label = get_node_or_null("PanelMain/VBox/TabOwnLabel")
		label_active_contract_title = get_node_or_null("PanelMain/VBox/TabContracts/PanelActiveContract/VBox/LabelActiveContractTitle")
		label_active_contract_details = get_node_or_null("PanelMain/VBox/TabContracts/PanelActiveContract/VBox/LabelActiveContractDetails")
		btn_rescind_contract = get_node_or_null("PanelMain/VBox/TabContracts/PanelActiveContract/VBox/HBoxActions/BtnRescindContract")
		btn_renegotiate = get_node_or_null("PanelMain/VBox/TabContracts/PanelActiveContract/VBox/HBoxActions/BtnRenegotiate")
		btn_master_buyback = get_node_or_null("PanelMain/VBox/TabContracts/PanelActiveContract/VBox/HBoxActions/BtnMasterBuyback")
		btn_physical_dist = get_node_or_null("PanelMain/VBox/TabContracts/PanelActiveContract/VBox/HBoxActions/BtnPhysicalDist")
		vbox_offers_list = get_node_or_null("PanelMain/VBox/TabContracts/ScrollOffers/VBoxOffersList")
		label_no_offers = get_node_or_null("PanelMain/VBox/TabContracts/LabelNoOffers")
		btn_refresh_offers = get_node_or_null("PanelMain/VBox/TabContracts/HBoxOffersHeader/BtnRefreshOffers")
		label_active_manager_title = get_node_or_null("PanelMain/VBox/TabManagers/PanelActiveManager/VBox/LabelActiveManagerTitle")
		label_active_manager_details = get_node_or_null("PanelMain/VBox/TabManagers/PanelActiveManager/VBox/LabelActiveManagerDetails")
		btn_fire_manager = get_node_or_null("PanelMain/VBox/TabManagers/PanelActiveManager/VBox/HBoxActions/BtnFireManager")
		btn_hire_lawyer = get_node_or_null("PanelMain/VBox/TabManagers/PanelActiveManager/VBox/HBoxActions/BtnHireLawyer")
		vbox_managers_list = get_node_or_null("PanelMain/VBox/TabManagers/ScrollManagers/VBoxManagersList")
		label_own_label_title = get_node_or_null("PanelMain/VBox/TabOwnLabel/PanelOwnLabelStatus/VBox/LabelOwnLabelTitle")
		label_own_label_details = get_node_or_null("PanelMain/VBox/TabOwnLabel/PanelOwnLabelStatus/VBox/LabelOwnLabelDetails")
		btn_found_label = get_node_or_null("PanelMain/VBox/TabOwnLabel/PanelOwnLabelStatus/VBox/HBoxOwnLabelActions/BtnFoundLabel")
		btn_scout_bands = get_node_or_null("PanelMain/VBox/TabOwnLabel/PanelOwnLabelStatus/VBox/HBoxOwnLabelActions/BtnScoutBands")
		vbox_roster_list = get_node_or_null("PanelMain/VBox/TabOwnLabel/ScrollRoster/VBoxRosterList")
		btn_close = get_node_or_null("PanelMain/VBox/HBoxFooter/BtnClose")

func _setup_accessibility_hooks() -> void:
	_resolve_nodes()
	if btn_tab_contracts:
		AccessibilityManager.hook_control_accessibility(btn_tab_contracts, "Scheda Contratti Discografici", "Tasto 1. Consulta il contratto in vigore, recoupment, rinegoziazione e offerte.")
	if btn_tab_managers:
		AccessibilityManager.hook_control_accessibility(btn_tab_managers, "Scheda Manager e Rappresentanza", "Tasto 2. Consulta il manager attuale, fiducia, promesse e tutela legale.")
	if btn_tab_own_label:
		AccessibilityManager.hook_control_accessibility(btn_tab_own_label, "Scheda La Mia Etichetta Discografica", "Tasto 3. Gestisci la tua etichetta indipendente, talent scouting e roster band.")
	if btn_refresh_offers:
		AccessibilityManager.hook_control_accessibility(btn_refresh_offers, "Cerca Nuove Offerte Discografiche", "Tasto R. Genera nuove proposte contrattuali in base alla tua reputazione attuale.")
	if btn_rescind_contract:
		AccessibilityManager.hook_control_accessibility(btn_rescind_contract, "Rescindi Contratto Discografico", "Rescindi anticipatamente l'accordo subendo penalità di reputazione.")
	if btn_renegotiate:
		AccessibilityManager.hook_control_accessibility(btn_renegotiate, "Rinegozia Contratto", "Tasto R. Tratta percentuali royalties più elevate con l'etichetta.")
	if btn_master_buyback:
		AccessibilityManager.hook_control_accessibility(btn_master_buyback, "Riscatta Master Album", "Tasto M. Riacquista i diritti di proprietà master dei tuoi album storici.")
	if btn_physical_dist:
		AccessibilityManager.hook_control_accessibility(btn_physical_dist, "Distribuzione Fisica Esclusiva", "Tasto D. Attiva o revoca la distribuzione nei negozi delle 12 metropoli.")
	if btn_fire_manager:
		AccessibilityManager.hook_control_accessibility(btn_fire_manager, "Licenzia Manager", "Tasto F. Interrompi la collaborazione pagando la penale di rescissione.")
	if btn_hire_lawyer:
		AccessibilityManager.hook_control_accessibility(btn_hire_lawyer, "Assumi Avvocato Tutela Legale", "Tasto L. Ingaggia un avvocato per blindare contratti e incassi da abusi.")
	if btn_found_label:
		AccessibilityManager.hook_control_accessibility(btn_found_label, "Fonda Etichetta Discografica", "Tasto F. Investi 25.000 € e fonda la tua label indipendente.")
	if btn_scout_bands:
		AccessibilityManager.hook_control_accessibility(btn_scout_bands, "Talent Scouting Giovani Band", "Tasto S. Visiona e metti sotto contratto giovani band emergenti.")
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
	var label_str := "Nessuna"
	if player and player.has_own_label():
		label_str = player.own_label.label_name
		
	var speech: String = "Industria Musicale e Management. Contratto: %s. Manager: %s. Etichetta: %s. Premi 1 per Contratti, 2 per Manager, 3 per La Mia Etichetta, Esc o K per uscire." % [
		contract_str,
		manager_str,
		label_str
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
	if tab_own_label:
		tab_own_label.visible = (tab == HubTab.OWN_LABEL)
		
	match tab:
		HubTab.CONTRACTS:
			AccessibilityManager.announce("Scheda Contratti Discografici attiva. Consulta lo stato del contratto, recoupment, rinegoziazione o offerte.", false)
		HubTab.MANAGERS:
			AccessibilityManager.announce("Scheda Manager e Rappresentanza attiva. Consulta il manager attuale, fiducia, promesse e tutela legale.", false)
		HubTab.OWN_LABEL:
			AccessibilityManager.announce("Scheda La Mia Etichetta Discografica attiva. Consulta la tua label, talent scouting e roster band.", false)

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
	var l_name := "Nessuna"
	if player.has_own_label():
		l_name = player.own_label.label_name
		
	if label_status_summary:
		label_status_summary.text = "Contratto: %s | Manager: %s | Etichetta: %s" % [c_name, m_name, l_name]
		
	_refresh_contracts_tab(player, ind_sys)
	_refresh_managers_tab(player, ind_sys)
	_refresh_own_label_tab(player, ind_sys)

func _refresh_contracts_tab(player: PlayerData, _ind_sys: IndustrySystem) -> void:
	if not label_active_contract_title or not label_active_contract_details:
		return
		
	if player.active_contract:
		var c: ContractData = player.active_contract
		label_active_contract_title.text = "Contratto in Vigore: %s [%s]" % [c.label_name, c.get_type_name().to_upper()]
		
		var pct_recouped: float = 0.0
		if c.advance_amount > 0.0:
			pct_recouped = clampf((c.advance_amount - c.unrecouped_debt) / c.advance_amount * 100.0, 0.0, 100.0)
			
		var dist_str: String = "Attiva (+40% vendite fisiche)" if c.has_physical_distribution else "Non Attiva"
		var reneg_str: String = "Sì (Royalty al %.0f%%)" % (c.royalty_rate * 100.0) if c.is_renegotiated else "Disponibile" if c.can_renegotiate(player.reputation, player.has_any_gold_record()) else "Requisiti Mancanti (Rep >= 70 o Disco d'Oro)"
		
		label_active_contract_details.text = "Anticipo Ricevuto: %.2f € | Debito Residuo da Recuperare: %.2f € (%.1f%% recuperato)\nRoyalty Artista: %.1f%% | Album Consegnati: %d su %d\nDistribuzione Fisica Esclusiva: %s | Rinegoziazione: %s\nControllo A&R: %s" % [
			c.advance_amount,
			c.unrecouped_debt,
			pct_recouped,
			c.royalty_rate * 100.0,
			c.delivered_albums,
			c.required_albums,
			dist_str,
			reneg_str,
			"Rigoroso (Major: Qualità min. %.0f)" % c.min_quality_target if c.is_major() else "Totale Libertà Creativa (Indie)"
		]
		
		if btn_rescind_contract:
			btn_rescind_contract.visible = true
			btn_rescind_contract.text = "Rescindi Contratto (Penalità: -15 Rep.)"
		if btn_renegotiate:
			btn_renegotiate.visible = true
			btn_renegotiate.disabled = not c.can_renegotiate(player.reputation, player.has_any_gold_record())
			btn_renegotiate.text = "Rinegoziato (25%%)" if c.is_renegotiated else "Rinegozia Contratto (R)"
		if btn_master_buyback:
			btn_master_buyback.visible = not player.albums.is_empty()
			btn_master_buyback.text = "Riscatta Master Album (M)"
		if btn_physical_dist:
			btn_physical_dist.visible = true
			btn_physical_dist.text = "Distribuzione Fisica Attiva (D)" if c.has_physical_distribution else "Attiva Distr. Fisica (D)"
	else:
		label_active_contract_title.text = "Regime di Autoproduzione (Indipendente)"
		label_active_contract_details.text = "Attualmente non sei legato ad alcuna etichetta discografica.\nTrattieni il 100% dei ricavi da royalties sui brani e sugli album, ma non hai accesso ad anticipi liquidi né a supporto promozionale avanzato."
		if btn_rescind_contract:
			btn_rescind_contract.visible = false
		if btn_renegotiate:
			btn_renegotiate.visible = false
		if btn_master_buyback:
			btn_master_buyback.visible = false
		if btn_physical_dist:
			btn_physical_dist.visible = false

	# Offerte disponibili
	if vbox_offers_list:
		for child in vbox_offers_list.get_children():
			child.queue_free()
			
		var offers: Array = player.available_contracts
		if offers.is_empty():
			if label_no_offers:
				label_no_offers.visible = true
		else:
			if label_no_offers:
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

func _refresh_managers_tab(player: PlayerData, _ind_sys: IndustrySystem) -> void:
	if not label_active_manager_title or not label_active_manager_details:
		return
		
	if player.active_manager:
		var m: ManagerData = player.active_manager
		label_active_manager_title.text = "Manager Attivo: %s [%s]" % [m.manager_name, m.get_type_name()]
		
		var legal_str: String = "Garantita (Avvocato in Servizio)" if m.has_legal_protection else "Nessuna (Rischio abusi con bassa fiducia)"
		var prom_str: String = m.active_promise.get("description", "Nessuna promessa attiva") if not m.active_promise.is_empty() else "Nessuna promessa in corso"
		var stress_desc: String = "+%.1f punti a notte (richieste notturne)" % m.nocturnal_stress_rate if m.nocturnal_stress_rate > 0.0 else "-%.1f punti a notte" % m.daily_stress_relief
		
		label_active_manager_details.text = "Fiducia Reciproca: %.0f%% | Penale di Rescissione: %.2f €\nCommissione sui Live: %.0f%% | Boost Cachet: +%.0f%%\nStress Management: %s\nPromessa in Corso: %s\nTutela Legale: %s" % [
			m.trust,
			m.get_severance_fee(),
			m.commission_pct * 100.0,
			(m.booking_cachet_multiplier - 1.0) * 100.0,
			stress_desc,
			prom_str,
			legal_str
		]
		
		if btn_fire_manager:
			btn_fire_manager.visible = true
			btn_fire_manager.text = "Licenzia %s (Penale: %.0f €)" % [m.manager_name, m.get_severance_fee()]
		if btn_hire_lawyer:
			btn_hire_lawyer.visible = true
			btn_hire_lawyer.disabled = m.has_legal_protection
			btn_hire_lawyer.text = "Tutela Legale Attiva" if m.has_legal_protection else "Assumi Avvocato (1.500 €)"
	else:
		label_active_manager_title.text = "Nessun Manager Attivo"
		label_active_manager_details.text = "Nessun professionista gestisce la tua agenda o tratta per i tuoi ingaggi dal vivo.\nIngaggiare un manager aumenta gli incassi dei concerti e riduce il carico di stress organizzativo."
		if btn_fire_manager:
			btn_fire_manager.visible = false
		if btn_hire_lawyer:
			btn_hire_lawyer.visible = false

	# Profili manager disponibili
	if vbox_managers_list:
		for child in vbox_managers_list.get_children():
			child.queue_free()
			
		var profiles: Array[Dictionary] = [
			{
				"type": Enums.ManagerType.TRUSTED_FRIEND,
				"name": "Matteo (Amico Fidato)",
				"desc": "Un compagno fidato leale e protettivo. Commissione 10%, +10% ai cachet, -1.0 stress al giorno. Penale rescissione: 0 €.",
				"req_desc": "Nessun requisito (Disponibile da subito)",
				"eligible": true
			},
			{
				"type": Enums.ManagerType.PRO_INDIE,
				"name": "Elena Santi (Professionista Indipendente)",
				"desc": "Professionista della scena indipendente con ottimi contatti nei club. Commissione 15%, +25% ai cachet, -2.5 stress al giorno. Penale: 250 €.",
				"req_desc": "Richiede Reputazione >= 20.0 e almeno 200 Fan",
				"eligible": (player.reputation >= 20.0 and player.fans >= 200)
			},
			{
				"type": Enums.ManagerType.INDUSTRY_SHARK,
				"name": "Vittorio Brambilla (Squalo dell'Industria)",
				"desc": "Agente d'alta finanza aggressivo: apre grandi festival e TV. Commissione 22%, +50% ai cachet, ma genera +4.0 stress a notte con chiamate alle 02:30. Penale: 1.500 €.",
				"req_desc": "Richiede Reputazione >= 50.0 e almeno 1.000 Fan",
				"eligible": (player.reputation >= 50.0 and player.fans >= 1000)
			}
		]
		
		for prof in profiles:
			var row := _create_manager_row(prof, player)
			vbox_managers_list.add_child(row)

func _create_manager_row(prof: Dictionary, player: PlayerData) -> Control:
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
			if GameManager and GameManager.industry_system:
				var res: Dictionary = GameManager.industry_system.hire_manager(prof["type"])
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

func _refresh_own_label_tab(player: PlayerData, _ind_sys: IndustrySystem) -> void:
	if not label_own_label_title or not label_own_label_details:
		return
		
	if player.has_own_label():
		var label = player.own_label
		label_own_label_title.text = "La Mia Etichetta: %s [%s]" % [label.label_name, label.get_philosophy_name().to_upper()]
		label_own_label_details.text = "Reputazione Label: %.1f | Ricavi Totali di Catalogo: %.2f €\nBand Emergenti Sotto Contratto: %d su 3\nOgni notte le band del roster vendono album e generano royalties passive per la tua etichetta!" % [
			label.reputation,
			label.total_catalog_revenue,
			label.signed_bands.size()
		]
		if btn_found_label:
			btn_found_label.visible = false
		if btn_scout_bands:
			btn_scout_bands.visible = true
			btn_scout_bands.text = "Talent Scouting Giovani Band (S)"
	else:
		label_own_label_title.text = "Nessuna Etichetta Discografica Fondata"
		label_own_label_details.text = "Requisiti per fondare la tua label indipendente:\n• Reputazione >= 60.0 (Attuale: %.1f)\n• Capitale Sociale: 25.000 € (Attuale: %.2f €)\n• Regime libero (nessun contratto con major attivo)" % [
			player.reputation,
			player.money
		]
		if btn_found_label:
			btn_found_label.visible = true
			var can_found: bool = (player.reputation >= 60.0 and player.money >= 25000.0 and not player.has_active_contract())
			btn_found_label.disabled = not can_found
			btn_found_label.text = "Fonda Etichetta (25.000 €)" if can_found else "Requisiti Mancanti per Fondazione"
		if btn_scout_bands:
			btn_scout_bands.visible = false

	# Roster delle band sotto contratto
	if vbox_roster_list:
		for child in vbox_roster_list.get_children():
			child.queue_free()
			
		if player.has_own_label():
			var label = player.own_label
			if label.signed_bands.is_empty():
				var lbl_empty := Label.new()
				lbl_empty.text = "Nessuna band nel roster. Clicca su 'Talent Scouting Giovani Band' (Tasto S) per scoprire nuovi talenti!"
				lbl_empty.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7, 1))
				vbox_roster_list.add_child(lbl_empty)
			else:
				for b in label.signed_bands:
					var row := _create_roster_band_row(b, label)
					vbox_roster_list.add_child(row)

func _create_roster_band_row(b: Dictionary, _label: RefCounted) -> Control:
	var panel := PanelContainer.new()
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 14)
	
	var lbl := Label.new()
	lbl.custom_minimum_size = Vector2(560, 0)
	lbl.add_theme_font_size_override("font_size", 13)
	
	var recouped_str: String = "RECOUPED (Utile netto 100%)" if float(b.get("advance_debt", 0.0)) <= 0.0 else "Debito anticipo residuo: %.2f €" % float(b.get("advance_debt", 0.0))
	lbl.text = "• %s (%s)\n  Talento: %.0f | Popolarità: %.0f | Quota Royalties Etichetta: %.0f%%\n  Stato Recoupment: %s" % [
		b.get("name", "Band"),
		b.get("genre", "Genere"),
		float(b.get("talent", 50.0)),
		float(b.get("popularity", 10.0)),
		float(b.get("label_royalty_cut", 0.60)) * 100.0,
		recouped_str
	]
	
	hbox.add_child(lbl)
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

func _on_renegotiate_pressed() -> void:
	if GameManager and GameManager.industry_system:
		var res: Dictionary = GameManager.industry_system.renegotiate_contract(0.25)
		if res.get("success", false):
			AccessibilityManager.announce("Rinegoziazione contrattuale coronata da successo! Royalties salite al 25%.", true)
		else:
			AccessibilityManager.announce("Rinegoziazione rifiutata: %s" % res.get("message", res.get("reason", "requisiti non raggiunti")), true)
		refresh_hub()

func _on_master_buyback_pressed() -> void:
	if not GameManager or not GameManager.player_data or not GameManager.industry_system:
		return
	var player: PlayerData = GameManager.player_data
	if player.albums.is_empty():
		AccessibilityManager.announce("Nessun album pubblicato da riscattare.", true)
		return
	var target_album: AlbumData = player.albums[0]
	var res: Dictionary = GameManager.industry_system.buyback_album_master(target_album.id)
	if res.get("success", false):
		AccessibilityManager.announce("Master dell'album %s riscattato per %.2f €!" % [target_album.title, res.get("cost", 0.0)], true)
	else:
		AccessibilityManager.announce("Impossibile riscattare il master: %s" % res.get("reason", "errore"), true)
	refresh_hub()

func _on_physical_dist_pressed() -> void:
	if not GameManager or not GameManager.industry_system or not GameManager.player_data:
		return
	var player: PlayerData = GameManager.player_data
	if not player.has_active_contract():
		return
	if player.active_contract.has_physical_distribution:
		GameManager.industry_system.cancel_physical_distribution()
	else:
		GameManager.industry_system.sign_physical_distribution()
	refresh_hub()

func _on_fire_manager_pressed() -> void:
	if GameManager and GameManager.industry_system:
		var res: Dictionary = GameManager.industry_system.fire_manager()
		if res.get("success", false):
			AccessibilityManager.announce("Manager licenziato con successo.", true)
		else:
			AccessibilityManager.announce("Impossibile licenziare il manager: fondi insufficienti per la penale.", true)
		refresh_hub()

func _on_hire_lawyer_pressed() -> void:
	if GameManager and GameManager.industry_system:
		var res: Dictionary = GameManager.industry_system.hire_entertainment_lawyer(1500.0)
		if res.get("success", false):
			AccessibilityManager.announce("Avvocato dello spettacolo assunto per 1.500 €. Contratti blindati!", true)
		else:
			AccessibilityManager.announce("Impossibile assumere l'avvocato: %s" % res.get("reason", "errore"), true)
		refresh_hub()

func _on_found_label_pressed() -> void:
	if GameManager and GameManager.industry_system:
		var res: Dictionary = GameManager.industry_system.found_own_label("Velvet Sounds Records", Enums.LabelPhilosophy.UNDERGROUND_INDIE)
		if res.get("success", false):
			AccessibilityManager.announce("Etichetta discografica Velvet Sounds Records fondata con successo!", true)
		else:
			AccessibilityManager.announce("Impossibile fondare l'etichetta: %s" % res.get("reason", "requisiti mancanti"), true)
		refresh_hub()

func _on_scout_bands_pressed() -> void:
	if not GameManager or not GameManager.industry_system or not GameManager.player_data:
		return
	var bands: Array[Dictionary] = GameManager.industry_system.scout_unsigned_bands()
	if bands.is_empty():
		AccessibilityManager.announce("Nessuna band emergente al momento.", true)
		return
	# Firma la prima band idonea
	var target_band = bands[0]
	var res: Dictionary = GameManager.industry_system.sign_band_to_own_label(target_band, target_band["required_advance"], target_band["label_cut"])
	if res.get("success", false):
		AccessibilityManager.announce("Firma completata! %s è ora nel tuo roster!" % target_band["name"], true)
	else:
		AccessibilityManager.announce("Firma fallita: %s" % res.get("reason", "errore"), true)
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
		elif key_event.keycode == KEY_3:
			_set_tab(HubTab.OWN_LABEL)
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_R and current_tab == HubTab.CONTRACTS:
			_on_refresh_offers_pressed()
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_D and current_tab == HubTab.CONTRACTS:
			_on_physical_dist_pressed()
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_M and current_tab == HubTab.CONTRACTS:
			_on_master_buyback_pressed()
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_L and current_tab == HubTab.MANAGERS:
			_on_hire_lawyer_pressed()
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_F and current_tab == HubTab.MANAGERS:
			_on_fire_manager_pressed()
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_F and current_tab == HubTab.OWN_LABEL:
			_on_found_label_pressed()
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_S and current_tab == HubTab.OWN_LABEL:
			_on_scout_bands_pressed()
			get_viewport().set_input_as_handled()
