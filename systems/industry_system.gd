# res://systems/industry_system.gd
class_name IndustrySystem
extends RefCounted

## Gestore Centralizzato dell'Industria Discografica, Contratti & Manager (World-tour V3.0)
## Governa il mercato delle etichette (Indie Label vs Major Multinazionale),
## l'erogazione degli anticipi, la clausola di recoupment sulle royalties,
## l'assunzione e le provvigioni dei manager e i bonus sul live booking.

const ContractDataScript = preload("res://data/models/contract_data.gd")
const ManagerDataScript = preload("res://data/models/manager_data.gd")

var player_data: PlayerData
var calendar_data: CalendarData

func _init(p_player: PlayerData, p_calendar: CalendarData = null) -> void:
	player_data = p_player
	calendar_data = p_calendar

func get_active_player_data() -> PlayerData:
	if player_data:
		return player_data
	if GameManager and GameManager.player_data:
		return GameManager.player_data
	return null

func get_active_calendar_data() -> CalendarData:
	if calendar_data:
		return calendar_data
	if GameManager and GameManager.calendar_data:
		return GameManager.calendar_data
	return null

# ==============================================================================
# GESTIONE MANAGER & AGENZIE DI BOOKING
# ==============================================================================

## Restituisce i 3 profili di manager disponibili per l'ingaggio
func get_available_managers() -> Array:
	var result: Array = [
		ManagerDataScript.new("mgr_friend", "Matteo (Amico Fidato)", Enums.ManagerType.TRUSTED_FRIEND),
		ManagerDataScript.new("mgr_pro", "Elena Santi (Booking Pro)", Enums.ManagerType.PRO_INDIE),
		ManagerDataScript.new("mgr_shark", "Vittorio Brambilla (Apex Talent)", Enums.ManagerType.INDUSTRY_SHARK)
	]
	return result

## Ingaggia un manager per la band
func hire_manager(manager_type: int) -> Dictionary:
	var active_player := get_active_player_data()
	var active_calendar := get_active_calendar_data()
	if not active_player:
		return {"success": false, "reason": "no_player_data"}
		
	var all_managers: Array = get_available_managers()
	var selected_mgr = null
	for m in all_managers:
		if m.manager_type == manager_type:
			selected_mgr = m
			break
			
	if not selected_mgr:
		return {"success": false, "reason": "manager_not_found"}
		
	if active_player.money < selected_mgr.hiring_fee:
		return {
			"success": false,
			"reason": "money_insufficient",
			"fee": selected_mgr.hiring_fee,
			"balance": active_player.money
		}
		
	# Detrazione tariffa iniziale d'ingaggio
	active_player.modify_money(-selected_mgr.hiring_fee)
	EventBus.money_changed.emit(active_player.money, -selected_mgr.hiring_fee, "Ingaggio Manager: %s" % selected_mgr.manager_name)
	
	selected_mgr.is_hired = true
	selected_mgr.hired_day = active_calendar.day_number if active_calendar else 1
	active_player.active_manager = selected_mgr
	
	EventBus.manager_hired.emit(selected_mgr.to_dict())
	
	var speech := "Ingaggiato il manager %s! Commissione: %.0f%% sui live. Cachet aumentato del %.0f%%." % [
		selected_mgr.manager_name,
		selected_mgr.commission_pct * 100.0,
		(selected_mgr.booking_cachet_multiplier - 1.0) * 100.0
	]
	AccessibilityManager.announce(speech, true)
	
	return {
		"success": true,
		"manager": selected_mgr
	}

## Licenzia il manager attualmente in carica
func fire_manager() -> Dictionary:
	var active_player := get_active_player_data()
	if not active_player or not active_player.has_manager():
		return {"success": false, "reason": "no_active_manager"}
		
	var old_mgr = active_player.active_manager
	active_player.active_manager = null
	
	EventBus.manager_fired.emit(old_mgr.to_dict() if old_mgr else {})
	AccessibilityManager.announce("Manager licenziato. Da questo momento gestisci concerti e contatti da solo.", true)
	
	return {
		"success": true,
		"fired_manager": old_mgr
	}

## Calcola il cachet e la provvigione del manager per un concerto live
func calculate_live_concert_revenue(base_cachet: float) -> Dictionary:
	var active_player := get_active_player_data()
	var gross_cachet: float = base_cachet
	var manager_cut: float = 0.0
	var manager_name: String = ""
	
	if active_player and active_player.has_manager():
		var mgr = active_player.active_manager
		gross_cachet = snappedf(base_cachet * mgr.booking_cachet_multiplier, 0.01)
		manager_cut = snappedf(gross_cachet * mgr.commission_pct, 0.01)
		manager_name = mgr.manager_name
		
	var net_band_revenue: float = snappedf(gross_cachet - manager_cut, 0.01)
	
	return {
		"base_cachet": base_cachet,
		"gross_cachet": gross_cachet,
		"manager_cut": manager_cut,
		"manager_name": manager_name,
		"net_band_revenue": net_band_revenue
	}

## Applica lo sgravio giornaliero di stress derivante dalla gestione professionale
func apply_daily_manager_stress_relief() -> float:
	var active_player := get_active_player_data()
	if not active_player or not active_player.has_manager():
		return 0.0
	var mgr = active_player.active_manager
	var relief: float = float(mgr.daily_stress_relief)
	active_player.stress = maxi(0, int(round(float(active_player.stress) - relief)))
	return relief

# ==============================================================================
# GESTIONE CONTRATTI DISCOGRAFICI (INDIE VS MAJOR)
# ==============================================================================

## Genera le offerte contrattuali correnti in base alla reputazione e ai fan
func refresh_contract_offers() -> Array:
	var active_player := get_active_player_data()
	var result: Array = []
	if not active_player:
		return result
		
	# Se il musicista ha già un contratto attivo, le etichette attendono la conclusione
	if active_player.has_active_contract():
		return result
		
	var rep: float = active_player.reputation
	var fans: int = active_player.fans
	
	# Tier 1: Offerta Indie Label base (da 15.0 reputazione o 100 fan)
	if rep >= 15.0 or fans >= 100:
		var indie_01 = ContractDataScript.new(
			"indie_black_velvet",
			"Black Velvet Records",
			Enums.ContractType.INDIE_LABEL,
			Constants.CONTRACT_INDIE_ADVANCE_DEFAULT,
			Constants.CONTRACT_INDIE_ROYALTY_RATE,
			Constants.CONTRACT_INDIE_ALBUMS_REQ,
			0.0
		)
		result.append(indie_01)
		
	# Tier 2: Offerta Indie Specializzata (da 30.0 reputazione o 500 fan)
	if rep >= 30.0 or fans >= 500:
		var indie_02 = ContractDataScript.new(
			"indie_neon_sun",
			"Neon Sun Independent",
			Enums.ContractType.INDIE_LABEL,
			12000.0,
			0.40,
			2,
			45.0
		)
		result.append(indie_02)
		
	# Tier 3: Offerta Major Multinazionale (da 50.0 reputazione o 1.500 fan)
	if rep >= 50.0 or fans >= 1500:
		var major_01 = ContractDataScript.new(
			"major_apex_global",
			"Apex Global Music",
			Enums.ContractType.MAJOR_LABEL,
			Constants.CONTRACT_MAJOR_ADVANCE_DEFAULT,
			Constants.CONTRACT_MAJOR_ROYALTY_RATE,
			Constants.CONTRACT_MAJOR_ALBUMS_REQ,
			Constants.CONTRACT_MAJOR_MIN_QUALITY
		)
		result.append(major_01)
		
	# Tier 4: Offerta Top Major Mondiale (da 75.0 reputazione o 5.000 fan)
	if rep >= 75.0 or fans >= 5000:
		var major_02 = ContractDataScript.new(
			"major_titan_records",
			"Titan Records Worldwide",
			Enums.ContractType.MAJOR_LABEL,
			100000.0,
			0.12,
			3,
			75.0
		)
		result.append(major_02)
		
	active_player.available_contracts = result
	return result

## Firma un contratto discografico tra quelli disponibili
func sign_contract(contract_id: String) -> Dictionary:
	var active_player := get_active_player_data()
	var active_calendar := get_active_calendar_data()
	if not active_player:
		return {"success": false, "reason": "no_player_data"}
		
	if active_player.has_active_contract():
		return {"success": false, "reason": "already_has_contract"}
		
	var found_contract = null
	for c in active_player.available_contracts:
		if c.id == contract_id:
			found_contract = c
			break
			
	if not found_contract:
		return {"success": false, "reason": "contract_not_found"}
		
	# Accredito anticipo alla firma
	active_player.modify_money(found_contract.advance_amount)
	EventBus.money_changed.emit(
		active_player.money,
		found_contract.advance_amount,
		"Anticipo Discografico: %s" % found_contract.label_name
	)
	
	found_contract.is_active = true
	found_contract.signing_day = active_calendar.day_number if active_calendar else 1
	active_player.active_contract = found_contract
	active_player.available_contracts.clear()
	
	# Inserimento scadenza di consegna master nell'Agenda della Band (SP-09)
	if GameManager and GameManager.schedule_system:
		var deadline_days: int = 56 if found_contract.contract_type == Enums.ContractType.MAJOR_LABEL else 84
		GameManager.schedule_system.schedule_album_deadline(
			"Album Contratto #%d" % (found_contract.albums_delivered + 1),
			deadline_days,
			found_contract.label_name
		)
	
	EventBus.contract_signed.emit(found_contract.to_dict())
	
	var type_str: String = found_contract.get_type_name()
	var speech := "Firmato contratto discografico con %s (%s)! Anticipo di %.2f euro accreditato. Debito iniziale di recupero (Recoupment): %.2f euro." % [
		found_contract.label_name,
		type_str,
		found_contract.advance_amount,
		found_contract.unrecouped_debt
	]
	AccessibilityManager.announce(speech, true)
	
	return {
		"success": true,
		"contract": found_contract
	}

## Rescinde il contratto discografico attivo
func cancel_contract() -> Dictionary:
	var active_player := get_active_player_data()
	if not active_player or not active_player.has_active_contract():
		return {"success": false, "reason": "no_active_contract"}
		
	var old_contract = active_player.active_contract
	var remaining_debt: float = float(old_contract.unrecouped_debt)
	
	# Penalità di reputazione per rottura anticipata degli accordi
	active_player.reputation = maxf(0.0, active_player.reputation - 15.0)
	old_contract.is_active = false
	active_player.active_contract = null
	
	EventBus.contract_canceled.emit(old_contract.to_dict())
	
	var speech := "Contratto con %s rescisso. Penalità di 15 punti reputazione per rottura degli accordi." % old_contract.label_name
	AccessibilityManager.announce(speech, true)
	
	return {
		"success": true,
		"canceled_contract": old_contract,
		"unrecouped_debt_abandoned": remaining_debt
	}

## Registra la consegna di un album e valida i requisiti dell'etichetta
func process_album_delivery(album: AlbumData) -> Dictionary:
	var active_player := get_active_player_data()
	if not active_player or not active_player.has_active_contract():
		return {"under_contract": false}
		
	var contract = active_player.active_contract
	contract.delivered_albums += 1
	
	var is_quality_ok: bool = true
	var note: String = "Album approvato regolarmente."
	
	# Controllo standard A&R della Major
	if contract.contract_type == Enums.ContractType.MAJOR_LABEL:
		if album.overall_quality < contract.min_quality_target:
			is_quality_ok = false
			note = "L'A&R della major esprime forte delusione per la qualità (%.1f / %.1f minima richiesta)." % [
				album.overall_quality, contract.min_quality_target
			]
			active_player.stress = mini(100, active_player.stress + 15)
			AccessibilityManager.announce("Attenzione: la Major segnala che l'album non raggiunge lo standard commerciale concordato (+15 Stress).", true)
			
	var contract_finished: bool = contract.is_completed()
	if contract_finished:
		contract.is_active = false
		EventBus.contract_completed.emit(contract.to_dict())
		var speech := "Congratulazioni! Hai completato tutti i %d album richiesti dal contratto con %s. Ora sei un artista libero!" % [
			contract.required_albums, contract.label_name
		]
		AccessibilityManager.announce(speech, true)
		
	return {
		"under_contract": true,
		"contract": contract,
		"delivered": contract.delivered_albums,
		"required": contract.required_albums,
		"is_completed": contract_finished,
		"quality_ok": is_quality_ok,
		"note": note
	}

## Elabora il recoupment e la ripartizione royalties sul catalogo
func process_royalties_recoupment(gross_album_royalty: float) -> Dictionary:
	var active_player := get_active_player_data()
	if not active_player or not active_player.has_active_contract():
		return {
			"under_contract": false,
			"artist_received": gross_album_royalty,
			"recouped_by_label": 0.0,
			"remaining_debt": 0.0
		}
		
	var contract = active_player.active_contract
	var nominal_artist_share: float = gross_album_royalty * contract.royalty_rate
	var had_debt_before: bool = not contract.is_recouped()
	
	var recoup_res: Dictionary = contract.apply_recoupment(nominal_artist_share)
	
	if had_debt_before and contract.is_recouped():
		AccessibilityManager.announce("Traguardo Storico! L'anticipo di %s è stato interamente recuperato (Recouped). Da oggi incassi le piene royalties!" % contract.label_name, true)
		
	EventBus.recoupment_updated.emit(recoup_res.recouped_by_label, contract.unrecouped_debt)
	
	return {
		"under_contract": true,
		"artist_received": recoup_res.paid_to_artist,
		"recouped_by_label": recoup_res.recouped_by_label,
		"remaining_debt": recoup_res.remaining_debt
	}
