# res://systems/industry_system.gd
class_name IndustrySystem
extends RefCounted

## Gestore Centralizzato dell'Industria Discografica, Contratti & Manager (World-tour V3.0)
## Governa il mercato delle etichette (Indie Label vs Major Multinazionale),
## l'erogazione degli anticipi, la clausola di recoupment sulle royalties,
## l'assunzione e le provvigioni dei manager e i bonus sul live booking.

const ContractDataScript = preload("res://data/models/contract_data.gd")
const ManagerDataScript = preload("res://data/models/manager_data.gd")
const OwnLabelDataScript = preload("res://data/models/own_label_data.gd")

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
	selected_mgr.has_legal_protection = false
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

## Modifica il livello di fiducia del manager attivo
func adjust_manager_trust(delta: float) -> float:
	var active_player := get_active_player_data()
	if not active_player or not active_player.has_manager():
		return 0.0
	var mgr = active_player.active_manager
	mgr.trust = clampf(mgr.trust + delta, 0.0, 100.0)
	EventBus.manager_trust_changed.emit(mgr.trust, delta)
	return mgr.trust

## Genera una promessa professionale da parte del manager attivo
func generate_manager_promise() -> Dictionary:
	var active_player := get_active_player_data()
	var active_calendar := get_active_calendar_data()
	if not active_player or not active_player.has_manager():
		return {}
	var mgr = active_player.active_manager
	var p_id: String = "prom_%d" % (randi() % 9000 + 1000)
	var desc: String = ""
	var target_type: String = ""
	match mgr.manager_type:
		Enums.ManagerType.TRUSTED_FRIEND:
			desc = "Organizzare un concerto autentico per i veri fan con cachet sicuro"
			target_type = "friend_gig"
		Enums.ManagerType.PRO_INDIE:
			desc = "Ottenere un ingaggio in un locale prestigioso o slot festival"
			target_type = "pro_booking"
		Enums.ManagerType.INDUSTRY_SHARK:
			desc = "Garantire un maxi-cachet per un'apertura o un grande evento mediatico"
			target_type = "shark_event"
		_:
			desc = "Supporto generale alla carriera"
			target_type = "general"
			
	var promise: Dictionary = {
		"id": p_id,
		"description": desc,
		"target_type": target_type,
		"status": "pending",
		"issued_day": active_calendar.day_number if active_calendar else 1
	}
	mgr.active_promise = promise
	EventBus.manager_promise_updated.emit(promise)
	return promise

## Valuta e conclude la promessa del manager
func evaluate_manager_promise_fulfillment(fulfilled: bool) -> Dictionary:
	var active_player := get_active_player_data()
	if not active_player or not active_player.has_manager():
		return {}
	var mgr = active_player.active_manager
	if mgr.active_promise.is_empty():
		return {}
	var old_p: Dictionary = mgr.active_promise.duplicate(true)
	if fulfilled:
		adjust_manager_trust(15.0)
		active_player.reputation = clampf(active_player.reputation + 2.5, 0.0, 100.0)
		old_p["status"] = "fulfilled"
		AccessibilityManager.announce("Promessa del Manager mantenuta! Fiducia e reputazione in ascesa.", true)
	else:
		adjust_manager_trust(-15.0)
		active_player.morale = maxi(0, active_player.morale - 5)
		old_p["status"] = "failed"
		AccessibilityManager.announce("Promessa del Manager mancata. Lieve delusione e calo di fiducia.", true)
	mgr.active_promise.clear()
	EventBus.manager_promise_updated.emit(old_p)
	return old_p

## Genera l'evento della telefonata notturna (esclusivo dello Squalo)
func process_manager_night_call() -> Dictionary:
	var active_player := get_active_player_data()
	if not active_player or not active_player.has_manager():
		return {}
	var mgr = active_player.active_manager
	if mgr.manager_type != Enums.ManagerType.INDUSTRY_SHARK:
		return {}
	return {
		"caller": mgr.manager_name,
		"proposal": "Telefonata alle 02:30: Vittorio ti sveglia per una comparsata televisiva lampo domani mattina.",
		"reward": 1500.0,
		"stress_penalty": 8
	}

## Risolve la telefonata notturna dello squalo
func resolve_manager_night_call(accepted: bool) -> Dictionary:
	var active_player := get_active_player_data()
	if not active_player or not active_player.has_manager():
		return {"success": false, "reason": "no_manager"}
	if accepted:
		active_player.modify_money(1500.0)
		active_player.stress = mini(100, active_player.stress + 8)
		adjust_manager_trust(5.0)
		EventBus.money_changed.emit(active_player.money, 1500.0, "Telefonata Notturna Squalo")
		AccessibilityManager.announce("Hai accettato l'ingaggio notturno dello Squalo! Incassati 1.500 € ma sonno interrotto (+8 Stress).", true)
		return {"success": true, "accepted": true, "earned": 1500.0}
	else:
		adjust_manager_trust(-10.0)
		AccessibilityManager.announce("Hai rifiutato la chiamata notturna. Vittorio è irritato per la tua indisponibilità (-10 Fiducia).", true)
		return {"success": true, "accepted": false, "earned": 0.0}

## Incarica un avvocato dello spettacolo per tutelare i contratti ed eliminare il rischio tradimento
func hire_entertainment_lawyer(fee: float = 1500.0) -> Dictionary:
	var active_player := get_active_player_data()
	if not active_player or not active_player.has_manager():
		return {"success": false, "reason": "no_manager"}
	var mgr = active_player.active_manager
	if mgr.has_legal_protection:
		return {"success": false, "reason": "already_protected"}
	if active_player.money < fee:
		return {"success": false, "reason": "money_insufficient", "fee": fee, "balance": active_player.money}
	active_player.modify_money(-fee)
	mgr.has_legal_protection = true
	EventBus.money_changed.emit(active_player.money, -fee, "Parcella Avvocato dello Spettacolo")
	AccessibilityManager.announce("Assunto Avvocato dello Spettacolo! Contratti e compensi con il manager sono ora blindati al 100%.", true)
	return {"success": true, "fee": fee}

## Licenzia il manager attualmente in carica (con gestione penale di rescissione)
func fire_manager() -> Dictionary:
	return fire_manager_with_severance()

## Licenzia il manager calcolando e detraendo la penale di rescissione
func fire_manager_with_severance() -> Dictionary:
	var active_player := get_active_player_data()
	if not active_player or not active_player.has_manager():
		return {"success": false, "reason": "no_active_manager"}
		
	var old_mgr = active_player.active_manager
	var severance: float = float(old_mgr.get_severance_fee())
	if active_player.money < severance:
		return {
			"success": false,
			"reason": "insufficient_funds_for_severance",
			"required": severance,
			"balance": active_player.money
		}
		
	if severance > 0.0:
		active_player.modify_money(-severance)
		EventBus.money_changed.emit(active_player.money, -severance, "Penale Rescissione Manager: %s" % old_mgr.manager_name)
		
	active_player.active_manager = null
	EventBus.manager_fired.emit(old_mgr.to_dict() if old_mgr else {})
	var speech := "Manager %s licenziato. Penale di rescissione di %.2f € saldata." % [old_mgr.manager_name, severance]
	AccessibilityManager.announce(speech, true)
	
	return {
		"success": true,
		"fired_manager": old_mgr,
		"severance_paid": severance
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
		var cut_pct: float = mgr.commission_pct
		# Se lo squalo ha fiducia critica e non c'è avvocato, trattiene 10% extra abusivo!
		if mgr.manager_type == Enums.ManagerType.INDUSTRY_SHARK and mgr.trust < 30.0 and not mgr.has_legal_protection:
			cut_pct += 0.10
		manager_cut = snappedf(gross_cachet * cut_pct, 0.01)
		manager_name = mgr.manager_name
		
	var net_band_revenue: float = snappedf(gross_cachet - manager_cut, 0.01)
	
	return {
		"base_cachet": base_cachet,
		"gross_cachet": gross_cachet,
		"manager_cut": manager_cut,
		"manager_name": manager_name,
		"net_band_revenue": net_band_revenue
	}

## Applica lo sgravio giornaliero di stress o lo stress notturno derivante dal manager
func apply_daily_manager_stress_relief() -> float:
	var active_player := get_active_player_data()
	if not active_player or not active_player.has_manager():
		return 0.0
	var mgr = active_player.active_manager
	if mgr.nocturnal_stress_rate > 0.0:
		active_player.stress = mini(100, active_player.stress + int(mgr.nocturnal_stress_rate))
		return -float(mgr.nocturnal_stress_rate)
	elif mgr.daily_stress_relief > 0.0:
		var relief: float = float(mgr.daily_stress_relief)
		active_player.stress = maxi(0, int(round(float(active_player.stress) - relief)))
		return relief
	return 0.0

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
			"Album Contratto #%d" % (found_contract.delivered_albums + 1),
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

# ==============================================================================
# DISTRIBUZIONE FISICA ESCLUSIVA, RINEGOZIAZIONE & RISCATTO MASTER (SEZIONE 9)
# ==============================================================================

## Attiva la clausola di distribuzione fisica esclusiva nei negozi di dischi
func sign_physical_distribution(_contract_id: String = "") -> Dictionary:
	var active_player := get_active_player_data()
	if not active_player or not active_player.has_active_contract():
		return {"success": false, "reason": "no_active_contract"}
		
	var contract: ContractData = active_player.active_contract
	contract.has_physical_distribution = true
	var speech := "Attivata la distribuzione fisica esclusiva nei negozi continentali! +40%% alle vendite degli album fisici (fee distribuzione 20%%)."
	AccessibilityManager.announce(speech, true)
	return {"success": true, "contract": contract}

## Annulla la distribuzione fisica esclusiva
func cancel_physical_distribution() -> Dictionary:
	var active_player := get_active_player_data()
	if not active_player or not active_player.has_active_contract():
		return {"success": false, "reason": "no_active_contract"}
	var contract: ContractData = active_player.active_contract
	contract.has_physical_distribution = false
	AccessibilityManager.announce("Distribuzione fisica esclusiva disdetta.", true)
	return {"success": true, "contract": contract}

## Rinegozia il contratto discografico attivo (richiede reputazione >= 70.0 o Disco d'Oro)
func renegotiate_contract(target_royalty_rate: float = 0.25) -> Dictionary:
	var active_player := get_active_player_data()
	if not active_player or not active_player.has_active_contract():
		return {"success": false, "reason": "no_active_contract"}
		
	var contract: ContractData = active_player.active_contract
	if contract.is_renegotiated:
		return {"success": false, "reason": "already_renegotiated"}
		
	var has_gold: bool = active_player.has_any_gold_record()
	if not contract.can_renegotiate(active_player.reputation, has_gold):
		return {
			"success": false,
			"reason": "requirements_not_met",
			"message": "Occorrono almeno reputazione 70.0 o un Disco d'Oro per rinegoziare."
		}
		
	contract.apply_renegotiation(target_royalty_rate)
	EventBus.contract_renegotiated.emit(contract.to_dict())
	
	var speech := "Trattativa conclusa con successo! L'etichetta %s accetta di elevare le tue royalties dal %.0f%% al %.0f%%!" % [
		contract.label_name,
		contract.original_royalty_rate * 100.0,
		contract.royalty_rate * 100.0
	]
	AccessibilityManager.announce(speech, true)
	return {
		"success": true,
		"new_royalty": target_royalty_rate,
		"contract": contract
	}

## Riscatta la proprietà intellettuale e i master originali di un album (Master Buyback)
func buyback_album_master(album_id: String) -> Dictionary:
	var active_player := get_active_player_data()
	if not active_player:
		return {"success": false, "reason": "no_player_data"}
		
	var target_album: AlbumData = null
	for a in active_player.albums:
		if a.id == album_id:
			target_album = a
			break
			
	if not target_album:
		return {"success": false, "reason": "album_not_found"}
		
	if not active_player.has_active_contract():
		return {"success": false, "reason": "no_contract_to_buyback_from"}
		
	var contract: ContractData = active_player.active_contract
	if contract.is_master_bought_back(album_id):
		return {"success": false, "reason": "already_bought_back"}
		
	# Costo riscatto proporzionale alle vendite dell'album (minimo 10.000 €, max 40.000 €)
	var cost: float = snappedf(10000.0 + minf(target_album.total_sales * 0.15, 30000.0), 0.01)
	if active_player.money < cost:
		return {
			"success": false,
			"reason": "insufficient_funds",
			"cost": cost,
			"balance": active_player.money
		}
		
	active_player.modify_money(-cost)
	contract.buyback_master(album_id)
	
	EventBus.money_changed.emit(active_player.money, -cost, "Riscatto Master: %s" % target_album.title)
	EventBus.master_bought_back.emit(album_id, cost)
	
	var speech := "Riscatto dei Master completato! Ora possiedi al 100%% i diritti dell'album %s per sempre!" % target_album.title
	AccessibilityManager.announce(speech, true)
	
	return {
		"success": true,
		"cost": cost,
		"album_id": album_id
	}

# ==============================================================================
# LA MIA ETICHETTA DISCOGRAFICA INDIPENDENTE (ENDGAME SEZIONE 9)
# ==============================================================================

## Fonda una propria etichetta discografica indipendente
func found_own_label(label_name: String, philosophy: int) -> Dictionary:
	var active_player := get_active_player_data()
	var active_calendar := get_active_calendar_data()
	if not active_player:
		return {"success": false, "reason": "no_player_data"}
		
	if active_player.has_own_label():
		return {"success": false, "reason": "already_has_own_label"}
		
	if active_player.has_active_contract():
		return {"success": false, "reason": "under_exclusive_contract"}
		
	if active_player.reputation < 60.0:
		return {
			"success": false,
			"reason": "reputation_too_low",
			"required": 60.0,
			"current": active_player.reputation
		}
		
	const LABEL_CAPITAL_REQUIRED: float = 25000.0
	if active_player.money < LABEL_CAPITAL_REQUIRED:
		return {
			"success": false,
			"reason": "money_insufficient",
			"required": LABEL_CAPITAL_REQUIRED,
			"balance": active_player.money
		}
		
	active_player.modify_money(-LABEL_CAPITAL_REQUIRED)
	EventBus.money_changed.emit(active_player.money, -LABEL_CAPITAL_REQUIRED, "Capitale Sociale Fondazione Etichetta: %s" % label_name)
	
	var new_label = OwnLabelDataScript.new(label_name, philosophy)
	new_label.founded_day = active_calendar.day_number if active_calendar else 1
	active_player.own_label = new_label
	
	EventBus.own_label_founded.emit(new_label.to_dict())
	
	var speech := "Fondata la tua etichetta discografica indipendente: %s (%s)! Da oggi puoi fare talent scouting e mettere sotto contratto giovani band." % [
		label_name,
		new_label.get_philosophy_name()
	]
	AccessibilityManager.announce(speech, true)
	
	return {
		"success": true,
		"label": new_label
	}

## Restituisce le band emergenti disponibili per lo scouting
func scout_unsigned_bands() -> Array[Dictionary]:
	return [
		{
			"id": "band_scout_01",
			"name": "The Static Waves",
			"genre": "Indie Rock",
			"talent": 68.0,
			"popularity": 15.0,
			"required_advance": 4000.0,
			"label_cut": 0.60
		},
		{
			"id": "band_scout_02",
			"name": "Crimson Velvet",
			"genre": "Hard Rock / Metal",
			"talent": 75.0,
			"popularity": 22.0,
			"required_advance": 6000.0,
			"label_cut": 0.65
		},
		{
			"id": "band_scout_03",
			"name": "Neon Overdrive",
			"genre": "Synthwave Pop",
			"talent": 82.0,
			"popularity": 35.0,
			"required_advance": 8000.0,
			"label_cut": 0.70
		}
	]

## Mette sotto contratto una giovane band emergente nel roster dell'etichetta
func sign_band_to_own_label(band_data: Dictionary, advance_granted: float = 5000.0, label_cut: float = 0.60) -> Dictionary:
	var active_player := get_active_player_data()
	var active_calendar := get_active_calendar_data()
	if not active_player or not active_player.has_own_label():
		return {"success": false, "reason": "no_own_label"}
		
	var label = active_player.own_label
	if label.signed_bands.size() >= 3:
		return {"success": false, "reason": "roster_full"}
		
	if active_player.money < advance_granted:
		return {
			"success": false,
			"reason": "money_insufficient",
			"required": advance_granted,
			"balance": active_player.money
		}
		
	active_player.modify_money(-advance_granted)
	EventBus.money_changed.emit(active_player.money, -advance_granted, "Anticipo Band Roster: %s" % band_data.get("name", "Nuova Band"))
	
	var band_entry: Dictionary = {
		"id": band_data.get("id", "band_%d" % (randi() % 9000 + 1000)),
		"name": band_data.get("name", "Nuova Band"),
		"genre": band_data.get("genre", "Rock"),
		"talent": float(band_data.get("talent", 60.0)),
		"popularity": float(band_data.get("popularity", 10.0)),
		"advance_debt": advance_granted,
		"label_royalty_cut": label_cut,
		"albums_count": 1,
		"signed_day": active_calendar.day_number if active_calendar else 1
	}
	
	label.add_band(band_entry)
	EventBus.own_label_band_signed.emit(band_entry)
	
	var speech := "Ingaggiata la band %s nel roster di %s! Anticipo di %.2f € erogato, percentuale royalties etichetta %.0f%%." % [
		band_entry["name"],
		label.label_name,
		advance_granted,
		label_cut * 100.0
	]
	AccessibilityManager.announce(speech, true)
	
	return {
		"success": true,
		"band": band_entry
	}

## Elabora le royalties passive generate dal roster dell'etichetta propria
func process_own_label_daily_royalties() -> Dictionary:
	var active_player := get_active_player_data()
	if not active_player or not active_player.has_own_label():
		return {"total_label_royalties": 0.0, "band_count": 0}
		
	var label = active_player.own_label
	var total_label_income: float = 0.0
	var bands_active: int = 0
	
	for b in label.signed_bands:
		bands_active += 1
		var talent: float = float(b.get("talent", 60.0))
		var pop: float = float(b.get("popularity", 10.0))
		var daily_sales: float = maxf(1.0, talent * 0.4 + pop * 0.8)
		var gross_royalties: float = daily_sales * 1.50 # 1.50 € royalties per unità
		var cut: float = float(b.get("label_royalty_cut", 0.60))
		var label_share: float = gross_royalties * cut
		var debt: float = float(b.get("advance_debt", 0.0))
		
		if debt > 0.0:
			if label_share >= debt:
				var recoup_amount: float = debt
				var surplus: float = label_share - debt
				b["advance_debt"] = 0.0
				total_label_income += recoup_amount + surplus
			else:
				b["advance_debt"] = debt - label_share
				total_label_income += label_share
		else:
			total_label_income += label_share
			
	total_label_income = snappedf(total_label_income, 0.01)
	if total_label_income > 0.0:
		label.total_catalog_revenue += total_label_income
		active_player.modify_money(total_label_income)
		EventBus.money_changed.emit(active_player.money, total_label_income, "Royalties Roster Etichetta: %s" % label.label_name)
		EventBus.own_label_royalties_received.emit(total_label_income)
		
	return {
		"total_label_royalties": total_label_income,
		"band_count": bands_active
	}
