# res://systems/dilemma_system.gd
class_name DilemmaSystem
extends RefCounted

## Gestore dei Bivi Etico-Narrativi e delle Scelte Morali (World-tour V3.0)
## Propone al giocatore scelte critiche tra successo commerciale immediato,
## integrità artistica, dinamiche di gruppo e scandali mediatici.

const DilemmaDataScript = preload("res://data/models/dilemma_data.gd")

var player_data: PlayerData
var calendar_data: CalendarData

var dilemmas_catalog: Array = []

func _init(p_player: PlayerData, p_calendar: CalendarData = null) -> void:
	player_data = p_player
	calendar_data = p_calendar
	_build_catalog()

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

func _build_catalog() -> void:
	dilemmas_catalog.clear()
	
	# 1. Spot Bibita Gassata
	var d1 = DilemmaDataScript.new(
		"dilemma_commercial_ad",
		"Spot Pubblicitario per Bibita Commerciale",
		"Un'agenzia pubblicitaria offre 4.000 € per usare il tuo miglior riff in uno spot televisivo di bevande gassate. I fan più intransigenti e i tuoi compagni di band lo considerano una svendita commerciale.",
		Enums.DilemmaCategory.COMMERCIAL_ETHICS
	)
	d1.setup_options(
		"Accetta l'offerta commerciale",
		"Incassi subito 4.000 €, ma subisci un contraccolpo al morale e sale la tensione nella band.",
		{"money": 4000.0, "morale": -15.0, "tension": 12.0, "fans": -30},
		"Rifiuta e preserva l'autenticità",
		"Niente denaro extra, ma rafforzi l'intesa con la band, il morale e la tua credibilità.",
		{"money": 0.0, "morale": 15.0, "tension": -8.0, "reputation": 4.0, "respect": 10.0}
	)
	d1.req_min_fans = 50
	dilemmas_catalog.append(d1)
	
	# 2. Apertura Tour Popstar
	var d2 = DilemmaDataScript.new(
		"dilemma_opening_act",
		"Apertura Palazzetti per una Popstar",
		"Un famoso tour manager ti propone 3 date di apertura per una celebrità pop da classifica. La clausola impone una scaletta corta di 20 minuti e il divieto assoluto di vendere il vostro merchandising.",
		Enums.DilemmaCategory.ARTISTIC_INTEGRITY
	)
	d2.setup_options(
		"Firma la clausola e suona",
		"Grande esposizione mediatica e compenso garantito, ma la band si sente sminuita.",
		{"money": 1500.0, "fans": 250, "respect": -10.0, "stress": 12.0},
		"Rifiuta e continua da headliner",
		"Rinunci ai palazzetti ma mantieni pieno controllo sui concerti e orgoglio di gruppo.",
		{"money": 0.0, "respect": 15.0, "morale": 10.0, "fans": 60}
	)
	d2.req_min_fans = 200
	dilemmas_catalog.append(d2)
	
	# 3. Pressione della Major: Censura Testo
	var d3 = DilemmaDataScript.new(
		"dilemma_label_censorship",
		"Pressione dell'A&R: Censura del Singolo",
		"Il direttore artistico della casa discografica richiede di modificare e addolcire il testo del nuovo singolo per garantirgli i passaggi nei network radiofonici nazionali.",
		Enums.DilemmaCategory.COMMERCIAL_ETHICS
	)
	d3.setup_options(
		"Accetta la censura radiofonica",
		"Ottieni una spinta promozionale massiccia, ma perdi credibilità artistica.",
		{"money": 2500.0, "morale": -20.0, "tension": 10.0, "reputation": -5.0, "fans": 150},
		"Rifiuta e difendi la visione originale",
		"L'etichetta si infuria, ma conquisti il rispetto eterno del tuo pubblico e dei compagni.",
		{"money": 0.0, "morale": 25.0, "reputation": 8.0, "respect": 15.0}
	)
	d3.req_has_contract = true
	dilemmas_catalog.append(d3)
	
	# 4. Gaffe e Polemica con la Stampa
	var d4 = DilemmaDataScript.new(
		"dilemma_wild_interview",
		"Intervista Fuori Controllo",
		"A fine concerto, un compagno di band euforico ha insultato una storica testata musicale. Il giornalista minaccia di boicottare le recensioni dei vostri dischi.",
		Enums.DilemmaCategory.MEDIA_SCANDAL
	)
	d4.setup_options(
		"Difendi il compagno a spada tratta",
		"La stampa vi attacca, ma la band diventa una roccia inespugnabile.",
		{"affinity": 20.0, "tension": -10.0, "reputation": -8.0, "fans": 120},
		"Prendi le distanze pubblicamente",
		"Salvi le relazioni con i media, ma ferisci profondamente il tuo musicista.",
		{"affinity": -20.0, "tension": 15.0, "reputation": 6.0, "morale": -10.0}
	)
	d4.req_min_fans = 100
	dilemmas_catalog.append(d4)
	
	# 5. Beneficenza o Cassa Sicura
	var d5 = DilemmaDataScript.new(
		"dilemma_charity_festival",
		"Solidarietà o Cachet Commerciale",
		"Hai la possibilità di suonare come headliner a un festival benefico per le scuole di musica di periferia, oppure in una ricca festa privata aziendale ben pagata.",
		Enums.DilemmaCategory.COMMERCIAL_ETHICS
	)
	d5.setup_options(
		"Suona al Festival di Beneficenza",
		"Compenso nullo, ma enorme gratificazione morale, stima della comunità e tanti fan autentici.",
		{"money": 0.0, "morale": 25.0, "reputation": 10.0, "fans": 180, "respect": 10.0},
		"Suona alla Festa Privata Aziendale",
		"Incasso cospicuo e immediato, ma zero entusiasmo artistico.",
		{"money": 1200.0, "morale": -10.0, "fans": 10}
	)
	dilemmas_catalog.append(d5)
	
	# 6. Sospetto di Plagio
	var d6 = DilemmaDataScript.new(
		"dilemma_plagiarism_risk",
		"Sospetto di Plagio Interno",
		"Ti accorgi che il ritornello proposto da un membro ricalca quasi nota per nota un brano di nicchia degli anni '70. La canzone funziona a meraviglia, ma il rischio è concreto.",
		Enums.DilemmaCategory.ARTISTIC_INTEGRITY
	)
	d6.setup_options(
		"Imponi di riscrivere il ritornello",
		"Eviti qualsiasi guaio legale e tuteli la tua reputazione, ma il compagno ci resta male.",
		{"tension": 8.0, "morale": 5.0, "reputation": 5.0},
		"Lascia il brano intatto",
		"Risparmi tempo ed energia confidando che nessuno se ne accorga.",
		{"morale": -10.0, "stress": 10.0, "fans": 40}
	)
	dilemmas_catalog.append(d6)
	
	# 7. Vetrina a Pagamento (Pay to Play)
	var d7 = DilemmaDataScript.new(
		"dilemma_pay_to_play",
		"Vetrina a Pagamento (Pay to Play)",
		"Un'organizzazione losca offre uno slot in prima serata in un noto club di Milano, pretendendo però che compriate 400 € di prevendite a vostro carico.",
		Enums.DilemmaCategory.COMMERCIAL_ETHICS
	)
	d7.setup_options(
		"Paga la quota per non perdere la vetrina",
		"Spendi i soldi nella speranza che ci sia qualche produttore in sala.",
		{"money": -400.0, "stress": 10.0, "fans": 50},
		"Rifiuta e denuncia la pratica sui social",
		"Ti schieri contro lo sfruttamento dei musicisti, guadagnando l'affetto della scena.",
		{"money": 0.0, "reputation": 8.0, "morale": 15.0, "respect": 12.0}
	)
	dilemmas_catalog.append(d7)
	
	# 8. Ghostwriting per una Star
	var d8 = DilemmaDataScript.new(
		"dilemma_ghostwriting",
		"Proposta di Ghostwriting",
		"Un produttore importante ti propone di cedere i diritti esclusivi di un tuo brano per 3.000 €: verrà firmato e cantato da una celebrità senza menzionare il tuo nome.",
		Enums.DilemmaCategory.ARTISTIC_INTEGRITY
	)
	d8.setup_options(
		"Accetta i contanti e cedi la traccia",
		"Una boccata d'ossigeno per le finanze, ma non potrai mai rivendicare la paternità dell'opera.",
		{"money": 3000.0, "morale": -20.0, "stress": 8.0},
		"Rifiuta con orgoglio: la musica è tua",
		"Mantieni la proprietà delle tue canzoni per il tuo futuro discografico.",
		{"money": 0.0, "morale": 20.0, "respect": 10.0}
	)
	dilemmas_catalog.append(d8)
	
	# 9. La Rete di Distribuzione Continentale (Sezione 9)
	var d9 = DilemmaDataScript.new(
		"dilemma_exclusive_distribution_deal",
		"La Rete di Distribuzione Continentale",
		"Un consorzio di grossisti propone un'esclusiva per piazzare i vostri vinili nei negozi di tutte le 12 metropoli, pretendendo però il 25% sui diritti di distribuzione fisica.",
		Enums.DilemmaCategory.COMMERCIAL_ETHICS
	)
	d9.setup_options(
		"Firma l'accordo di distribuzione esclusiva",
		"Monetizzazione garantita e vasta penetrazione nei negozi, ma vincoli distributivi.",
		{"money": 2000.0, "fans": 300, "reputation": 5.0, "tension": 5.0},
		"Rifiuta e prediligi la distribuzione autonoma",
		"Zero vincoli commerciali, rafforzando l'orgoglio indipendente della band.",
		{"money": 0.0, "morale": 15.0, "respect": 10.0}
	)
	d9.req_min_fans = 300
	dilemmas_catalog.append(d9)
	
	# 10. Rendiconto Sospetto del Manager
	var d10 = DilemmaDataScript.new(
		"dilemma_shark_hidden_accounting",
		"Rendiconto Sospetto del Manager",
		"Dopo un festival estivo, noti delle strane decurtazioni per 'spese di rappresentanza' non concordate nel cachet del live.",
		Enums.DilemmaCategory.BAND_INTERNAL
	)
	d10.setup_options(
		"Assumi un avvocato per un audit contabile",
		"Investi del denaro per chiarire i conti e farti rispettare dall'ambiente.",
		{"money": -800.0, "reputation": 4.0, "respect": 10.0, "morale": 10.0},
		"Lascia correre per non compromettere il booking",
		"Eviti lo scontro diretto con il manager, ma la band si sente poco tutelata.",
		{"money": 0.0, "morale": -15.0, "stress": 12.0}
	)
	d10.req_min_reputation = 35.0
	dilemmas_catalog.append(d10)
	
	# 11. Riscatto Anticipato dei Master
	var d11 = DilemmaDataScript.new(
		"dilemma_master_buyback_ultimatum",
		"Offerta di Riscatto Anticipato dei Master",
		"L'etichetta ti propone di riscattare i nastri master del vostro album di debutto con uno sconto del 30%, a patto di concedere loro l'opzione prioritaria sul prossimo tour.",
		Enums.DilemmaCategory.ARTISTIC_INTEGRITY
	)
	d11.setup_options(
		"Accetta il patto e riscatta i tuoi master",
		"Riacquisti la sovranità sulla tua musica, con grande sollievo per la band.",
		{"money": -5000.0, "morale": 25.0, "reputation": 8.0, "respect": 15.0},
		"Rifiuta e mantieni piena libertà sul tour",
		"Nessun vincolo sui concerti, rimandando il riscatto dei master.",
		{"money": 0.0, "morale": 10.0, "stress": -5.0}
	)
	d11.req_has_contract = true
	dilemmas_catalog.append(d11)
	
	# 12. Giovane Band Emergente della Scena
	var d12 = DilemmaDataScript.new(
		"dilemma_young_band_talent_scouting",
		"La Giovane Band Emergente della Scena",
		"Un gruppo di ragazzi giovanissimi e talentuosi ti consegna un nastro demo fuori dal locale, implorandoti di produrre il loro primo singolo.",
		Enums.DilemmaCategory.ARTISTIC_INTEGRITY
	)
	d12.setup_options(
		"Finanzia la registrazione del loro singolo",
		"Agisci da mecenate della scena musicale, conquistando la devozione dei nuovi talenti.",
		{"money": -1000.0, "morale": 20.0, "reputation": 6.0, "fans": 150},
		"Dai loro solo qualche consiglio fraterno",
		"Incoraggi i giovani musicisti a farsi le ossa da soli senza impegnare risorse.",
		{"money": 0.0, "morale": 5.0, "respect": 5.0}
	)
	d12.req_min_fans = 500
	dilemmas_catalog.append(d12)

## Trova tutti i dilemmi che soddisfano i requisiti e non sono stati ancora affrontati
func get_eligible_dilemmas() -> Array:
	var active_player := get_active_player_data()
	var result: Array = []
	if not active_player:
		return result
		
	for d in dilemmas_catalog:
		if active_player.resolved_dilemmas.has(d.id):
			continue
		if d.is_eligible(active_player):
			result.append(d)
			
	return result

## Valuta la comparsa di un dilemma (chiamato ad esempio a fine giornata o nei live)
func evaluate_daily_dilemma() -> RefCounted:
	var eligible: Array = get_eligible_dilemmas()
	if eligible.is_empty():
		return null
		
	# Selezione deterministica o casuale ponderata del primo dilemma idoneo
	var selected = eligible[0]
	EventBus.dilemma_triggered.emit(selected.to_dict())
	return selected

## Risolve il dilemma applicando le conseguenze scelte (opzione 1 = A, opzione 2 = B)
func resolve_dilemma(dilemma_id: String, option_idx: int) -> Dictionary:
	var active_player := get_active_player_data()
	if not active_player:
		return {"success": false, "reason": "no_player_data"}
		
	var target_dilemma = null
	for d in dilemmas_catalog:
		if d.id == dilemma_id:
			target_dilemma = d
			break
			
	if not target_dilemma:
		return {"success": false, "reason": "dilemma_not_found"}
		
	var effects: Dictionary = target_dilemma.option_a_effects if option_idx == 1 else target_dilemma.option_b_effects
	var chosen_title: String = target_dilemma.option_a_title if option_idx == 1 else target_dilemma.option_b_title
	
	# Applicazione effetti a PlayerData
	if effects.has("money"):
		active_player.modify_money(float(effects["money"]))
		EventBus.money_changed.emit(active_player.money, float(effects["money"]), "Bivio: %s" % target_dilemma.title)
		
	if effects.has("morale"):
		active_player.morale = clampi(active_player.morale + int(effects["morale"]), 0, 100)
		
	if effects.has("stress"):
		active_player.stress = clampi(active_player.stress + int(effects["stress"]), 0, 100)
		
	if effects.has("fans"):
		active_player.fans = maxi(0, active_player.fans + int(effects["fans"]))
		
	if effects.has("reputation"):
		active_player.reputation = clampf(active_player.reputation + float(effects["reputation"]), 0.0, 100.0)
		
	# Effetti sui compagni di band
	if not active_player.band_members.is_empty():
		var delta_tension: float = float(effects.get("tension", 0.0))
		var delta_respect: float = float(effects.get("respect", 0.0))
		var delta_affinity: float = float(effects.get("affinity", 0.0))
		
		for m in active_player.band_members:
			if delta_tension != 0.0:
				m.adjust_tension(delta_tension)
			if delta_respect != 0.0:
				m.adjust_respect(delta_respect)
			if delta_affinity != 0.0:
				m.adjust_affinity(delta_affinity)
				
		EventBus.band_chemistry_changed.emit(0.0, 0.0, 0.0)
		
	target_dilemma.is_resolved = true
	target_dilemma.chosen_option = option_idx
	active_player.resolved_dilemmas.append(dilemma_id)
	
	EventBus.dilemma_resolved.emit(dilemma_id, option_idx, effects)
	
	var speech := "Decisione registrata: %s. Conseguenze applicate al tuo percorso artistico." % chosen_title
	AccessibilityManager.announce(speech, true)
	
	return {
		"success": true,
		"dilemma_id": dilemma_id,
		"option_chosen": option_idx,
		"effects": effects
	}
