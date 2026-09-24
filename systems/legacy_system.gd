# res://systems/legacy_system.gd
class_name LegacySystem
extends RefCounted

## Modulo Hall of Fame, Concerto d'Addio ("The Last Waltz") ed Epiloghi Narrativi di Carriera
## Conforme a SP-01, SP-07 e Clean Architecture (ASTRALIS v3.0.7).

var player_data: PlayerData
var calendar_data: CalendarData

func _init(p_player_data: PlayerData, p_calendar_data: CalendarData = null) -> void:
	player_data = p_player_data
	calendar_data = p_calendar_data

## Verifica l'idoneità all'induzione nella Rock and Roll Hall of Fame
func check_hall_of_fame_eligibility() -> Dictionary:
	if not player_data:
		return {"eligible": false, "reason": "no_player_data"}

	if player_data.hall_of_fame_inducted:
		return {"eligible": true, "already_inducted": true, "message": "Sei già una leggenda consacrata nella Hall of Fame!"}

	var has_superstar: bool = player_data.career_tier >= Enums.CareerTier.GLOBAL_SUPERSTAR
	var rep_ok: bool = player_data.reputation >= 75.0
	var fans_ok: bool = player_data.fans >= 80000
	var platinum_count: int = player_data.get_certifications_count(Enums.CertificationTier.PLATINUM) + \
							 player_data.get_certifications_count(Enums.CertificationTier.MULTI_PLATINUM) + \
							 player_data.get_certifications_count(Enums.CertificationTier.DIAMOND)
	var awards_ok: bool = player_data.music_awards.size() >= 1

	var eligible: bool = has_superstar and rep_ok and fans_ok and platinum_count >= 1

	if eligible:
		return {
			"eligible": true,
			"already_inducted": false,
			"message": "Requisiti leggendari raggiunti! Puoi essere introdotto nella Hall of Fame."
		}

	var missing: Array[String] = []
	if not has_superstar:
		missing.append("Status Superstar Mondiale")
	if not rep_ok:
		missing.append("Reputazione >= 75.0 (attuale: %.1f)" % player_data.reputation)
	if not fans_ok:
		missing.append("Almeno 80.000 fan (attuali: %d)" % player_data.fans)
	if platinum_count < 1:
		missing.append("Almeno 1 Disco di Platino o Diamante")

	return {
		"eligible": false,
		"already_inducted": false,
		"missing_requirements": missing,
		"message": "Requisiti per la Hall of Fame non ancora completati: %s." % ", ".join(missing)
	}

## Esegue l'induzione formale nella Rock and Roll Hall of Fame
func induct_into_hall_of_fame() -> Dictionary:
	var check := check_hall_of_fame_eligibility()
	if not check.get("eligible", false):
		return {"success": false, "message": check.get("message", "")}

	if player_data.hall_of_fame_inducted:
		return {"success": true, "already_inducted": true, "message": "Già consacrato nella Hall of Fame."}

	player_data.hall_of_fame_inducted = true
	player_data.modify_morale(30)
	player_data.reputation = minf(100.0, player_data.reputation + 15.0)

	EventBus.hall_of_fame_inducted.emit(player_data.player_name)
	var speech: String = "CONGRATULAZIONI SOLENNI! %s e la band %s sono stati ufficialmente indotti nella ROCK AND ROLL HALL OF FAME!" % [
		player_data.player_name,
		player_data.band_name
	]
	AccessibilityManager.announce(speech, true)

	return {
		"success": true,
		"artist_name": player_data.player_name,
		"band_name": player_data.band_name,
		"speech": speech
	}

## Conduce il concerto d'addio finale ("The Last Waltz")
func perform_last_waltz(setlist: Array[SongData]) -> Dictionary:
	if not player_data:
		return {"success": false, "reason": "no_player_data"}

	if setlist.is_empty():
		return {"success": false, "reason": "empty_setlist", "message": "Seleziona almeno una canzone per il concerto d'addio!"}

	var cur_day: int = calendar_data.day_number if calendar_data else 1
	var members_count: int = player_data.get_active_band_members().size()
	var total_qual: float = 0.0
	for s in setlist:
		total_qual += s.quality_score
	var avg_quality: float = total_qual / float(maxi(1, setlist.size()))

	# Punteggio leggendario dell'evento
	var final_score: float = clampf(avg_quality + 20.0 + (float(members_count) * 4.0), 50.0, 100.0)
	var gross_charity_funds: float = float(player_data.fans) * 1.50

	player_data.last_waltz_completed = true
	player_data.modify_morale(50)
	player_data.stress = 0

	var ending_eval := evaluate_legacy_ending()
	var ending_type: int = ending_eval.get("ending_type", Enums.LegacyEndingType.IMMORTAL_ICON)

	var result := {
		"success": true,
		"concert_score": final_score,
		"audience": maxi(80000, player_data.fans),
		"charity_funds_raised": gross_charity_funds,
		"songs_performed": setlist.size(),
		"ending_type": ending_type,
		"ending_title": ending_eval.get("ending_title", ""),
		"ending_narrative": ending_eval.get("narrative", "")
	}

	EventBus.last_waltz_performed.emit(result)
	EventBus.legacy_ending_triggered.emit(ending_type, result)

	var speech: String = "THE LAST WALTZ COMPLETATO! Punteggio serata: %.1f/100. Il tuo epilogo artistico è: %s!" % [
		final_score,
		ending_eval.get("ending_title", "")
	]
	AccessibilityManager.announce(speech, true)
	return result

## Calcola e determina l'Epilogo Narrativo della Carriera in base alle scelte e statistiche
func evaluate_legacy_ending() -> Dictionary:
	if not player_data:
		return {
			"ending_type": Enums.LegacyEndingType.IMMORTAL_ICON,
			"ending_title": "L'Icona Immortale",
			"narrative": "Una carriera vissuta all'insegna della musica."
		}

	var has_own_label: bool = player_data.has_own_label()
	var money: float = player_data.money
	var rep: float = player_data.reputation
	var pop: float = player_data.popularity
	var gold_platinum_count: int = player_data.certifications.size()
	var released_songs_count: int = player_data.get_released_singles().size()

	var ending_type: int = Enums.LegacyEndingType.IMMORTAL_ICON
	var ending_title: String = ""
	var narrative: String = ""

	# 1. Martire del Rock (Underground puro, zero major, alta rep, pochi soldi)
	if rep >= 75.0 and money < 20000.0 and (player_data.active_contract == null or player_data.active_contract.contract_type == Enums.ContractType.SELF_RELEASED):
		ending_type = Enums.LegacyEndingType.ROCK_MARTYR
		ending_title = Enums.get_legacy_ending_name(ending_type)
		narrative = "Hai rifiutato compromessi, major e classifiche di plastica. La critica mondiale e le generazioni future ti venerano come il Martire del Rock, l'anima più autentica e viscerale della musica indipendente."

	# 2. La Macchina da Soldi (Ricchezza immensa, propria label, contratti major, compromessi pop)
	elif (money >= 100000.0 or has_own_label) and pop >= 80.0:
		ending_type = Enums.LegacyEndingType.MONEY_MACHINE
		ending_title = Enums.get_legacy_ending_name(ending_type)
		narrative = "Sei diventato un magnate dell'industria, proprietario di etichette e cataloghi milionari. I tuoi jingle e le tue hit risuonano in ogni centro commerciale del pianeta. Una macchina da soldi infallibile."

	# 3. La Cometa Fiammeggiante (Pochi singoli, ma almeno un tormentone o platino clamoroso)
	elif released_songs_count <= 8 and gold_platinum_count >= 1:
		ending_type = Enums.LegacyEndingType.BLAZING_COMET
		ending_title = Enums.get_legacy_ending_name(ending_type)
		narrative = "Una parabola breve, abbagliante e indimenticabile. Pochi dischi, una manciata di capolavori immortali che hanno segnato un'epoca, prima di ritirarti all'apice del mistero."

	# 4. L'Icona Immortale (Superstar globale, grande repertorio, reputazione ed equilibrio artistico)
	else:
		ending_type = Enums.LegacyEndingType.IMMORTAL_ICON
		ending_title = Enums.get_legacy_ending_name(ending_type)
		narrative = "Il trionfo assoluto dell'arte e della popolarità. Hai riempito gli stadi di tutto il mondo mantenendo una statura artistica impeccabile. Il tuo nome è inciso per sempre nell'Olimpo degli dei della musica."

	player_data.legacy_ending = ending_type

	return {
		"ending_type": ending_type,
		"ending_title": ending_title,
		"narrative": narrative
	}

## Attiva la Modalità Carriera Infinita (Endless Horizon)
func continue_in_endless_mode() -> Dictionary:
	if not player_data:
		return {"success": false, "reason": "no_player_data"}

	player_data.is_endless_mode = true
	var name_disp: String = player_data.get_effective_name()
	var speech: String = "CARRIERA INFINITA AVVIATA! %s ha rifiutato il ritiro. La leggenda continua senza limiti negli stadi e nei festival di tutto il mondo!" % name_disp
	AccessibilityManager.announce(speech, true)
	EventBus.legacy_ending_triggered.emit(player_data.legacy_ending if player_data.legacy_ending != -1 else Enums.LegacyEndingType.IMMORTAL_ICON, {
		"is_endless_mode": true
	})
	return {
		"success": true,
		"is_endless_mode": true,
		"message": speech
	}

## Prepara e registra il passaggio del testimone (New Game+)
func prepare_new_game_plus() -> Dictionary:
	if not player_data:
		return {"success": false, "reason": "no_player_data"}

	var mentor: String = player_data.get_effective_name()
	var ng_data := {
		"mentor_name": mentor,
		"inherited_instrument_category": "guitar",
		"inherited_instrument_tier": player_data.get_instrument_tier("guitar"),
		"mentor_passive_daily_royalty": 15.0,
		"created_day": calendar_data.day_number if calendar_data else 336
	}

	var path: String = "user://new_game_plus.json"
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(ng_data, "\t"))
		file.close()

	var speech: String = "PASSAGGIO DEL TESTIMONE REGISTRATO! %s diventa il mentore della nuova generazione. La nuova partita avrà il tratto Discepolo del Rock e 15.00 euro al giorno di royalties passive." % mentor
	AccessibilityManager.announce(speech, true)

	return {
		"success": true,
		"ng_plus_data": ng_data,
		"message": speech
	}
