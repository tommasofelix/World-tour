# res://ui/concert/live_concert.gd
extends Control

## Controller del Palco dal Vivo e della Simulazione Concerti per World-tour
## Implementa la Simmetria Universale (Luca con NVDA/tastiera e Tom a monitor)
## Gestisce la preparazione scaletta, il calendario disponibilità dei locali, la drammaturgia
## artistica, gli imprevisti live (7 Stage Events), il banchetto merchandising, il Bis e il resoconto finale.
## Conforme ad ASTRALIS v3.0.7 e alle Regole Auree.

signal closed()
signal concert_completed(result: Dictionary)

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle

# Contenitore 1: Preparazione & Scaletta
@onready var prep_container: VBoxContainer = $PanelMain/VBox/PrepContainer
@onready var opt_venue: OptionButton = $PanelMain/VBox/PrepContainer/HBoxVenue/OptVenue
@onready var label_venue_details: Label = $PanelMain/VBox/PrepContainer/HBoxVenue/LabelVenueDetails
@onready var spin_price: SpinBox = $PanelMain/VBox/PrepContainer/HBoxPrice/SpinPrice
@onready var label_fair_price: Label = $PanelMain/VBox/PrepContainer/HBoxPrice/LabelFairPrice
@onready var chk_soundcheck: CheckBox = $PanelMain/VBox/PrepContainer/ChkSoundcheck
@onready var label_setlist_header: Label = $PanelMain/VBox/PrepContainer/LabelSetlistHeader
@onready var scroll_setlist: ScrollContainer = $PanelMain/VBox/PrepContainer/ScrollSetlist
@onready var vbox_songs: VBoxContainer = $PanelMain/VBox/PrepContainer/ScrollSetlist/VBoxSongs
@onready var label_setlist_summary: Label = $PanelMain/VBox/PrepContainer/LabelSetlistSummary
@onready var btn_start_concert: Button = $PanelMain/VBox/PrepContainer/HBoxPrepButtons/BtnStartConcert
@onready var btn_add_cover: Button = $PanelMain/VBox/PrepContainer/HBoxPrepButtons/BtnAddCover
@onready var btn_cancel_prep: Button = $PanelMain/VBox/PrepContainer/HBoxPrepButtons/BtnCancelPrep

# Contenitore 2: Esibizione & Imprevisto Live
@onready var show_container: VBoxContainer = $PanelMain/VBox/ShowContainer
@onready var label_show_status: Label = $PanelMain/VBox/ShowContainer/LabelShowStatus
@onready var label_hype: Label = $PanelMain/VBox/ShowContainer/HBoxHype/LabelHype
@onready var bar_hype: ProgressBar = $PanelMain/VBox/ShowContainer/HBoxHype/BarHype
@onready var panel_event: PanelContainer = $PanelMain/VBox/ShowContainer/PanelEvent
@onready var label_event_title: Label = $PanelMain/VBox/ShowContainer/PanelEvent/VBoxEvent/LabelEventTitle
@onready var label_event_desc: Label = $PanelMain/VBox/ShowContainer/PanelEvent/VBoxEvent/LabelEventDesc
@onready var btn_choice1: Button = $PanelMain/VBox/ShowContainer/PanelEvent/VBoxEvent/HBoxChoices/BtnChoice1
@onready var btn_choice2: Button = $PanelMain/VBox/ShowContainer/PanelEvent/VBoxEvent/HBoxChoices/BtnChoice2
@onready var label_event_outcome: Label = $PanelMain/VBox/ShowContainer/PanelEvent/VBoxEvent/LabelEventOutcome
@onready var btn_next_phase: Button = $PanelMain/VBox/ShowContainer/HBoxShowButtons/BtnNextPhase

# Contenitore 2B: Momento Bis / Encore
@onready var encore_container: VBoxContainer = $PanelMain/VBox/EncoreContainer
@onready var label_encore_title: Label = $PanelMain/VBox/EncoreContainer/LabelEncoreTitle
@onready var label_encore_desc: Label = $PanelMain/VBox/EncoreContainer/LabelEncoreDesc
@onready var btn_grant_encore: Button = $PanelMain/VBox/EncoreContainer/HBoxEncoreChoices/BtnGrantEncore
@onready var btn_decline_encore: Button = $PanelMain/VBox/EncoreContainer/HBoxEncoreChoices/BtnDeclineEncore
@onready var label_encore_outcome: Label = $PanelMain/VBox/EncoreContainer/LabelEncoreOutcome
@onready var btn_proceed_summary: Button = $PanelMain/VBox/EncoreContainer/HBoxEncoreNext/BtnProceedSummary

# Contenitore 3: Resoconto Finale
@onready var summary_container: VBoxContainer = $PanelMain/VBox/SummaryContainer
@onready var label_summary_title: Label = $PanelMain/VBox/SummaryContainer/LabelSummaryTitle
@onready var label_venue_audience: Label = $PanelMain/VBox/SummaryContainer/LabelVenueAudience
@onready var label_concert_score: Label = $PanelMain/VBox/SummaryContainer/LabelConcertScore
@onready var label_new_fans: Label = $PanelMain/VBox/SummaryContainer/LabelNewFans
@onready var label_financials: Label = $PanelMain/VBox/SummaryContainer/LabelFinancials
@onready var label_merch: Label = $PanelMain/VBox/SummaryContainer/LabelMerch
@onready var label_stats_gained: Label = $PanelMain/VBox/SummaryContainer/LabelStatsGained
@onready var btn_finish_concert: Button = $PanelMain/VBox/SummaryContainer/HBoxSummaryButtons/BtnFinishConcert

var venues: Array[VenueData] = []
var selected_venue: VenueData
var selected_setlist: Array[SongData] = []
var is_soundcheck: bool = false
var current_event: Dictionary = {}
var event_score_delta: float = 0.0
var latest_result: Dictionary = {}
var active_cover_song: SongData = null

func _ready() -> void:
	venues = VenueData.get_default_venues()
	
	opt_venue.item_selected.connect(_on_venue_selected)
	spin_price.value_changed.connect(_on_price_changed)
	chk_soundcheck.toggled.connect(func(pressed: bool): is_soundcheck = pressed)
	
	btn_start_concert.pressed.connect(_on_start_concert_pressed)
	if btn_add_cover:
		btn_add_cover.pressed.connect(_on_add_cover_pressed)
	btn_cancel_prep.pressed.connect(_on_cancel_pressed)
	
	btn_choice1.pressed.connect(func(): _on_choice_pressed(1))
	btn_choice2.pressed.connect(func(): _on_choice_pressed(2))
	btn_next_phase.pressed.connect(_on_next_phase_pressed)
	
	if btn_grant_encore:
		btn_grant_encore.pressed.connect(_on_grant_encore_pressed)
	if btn_decline_encore:
		btn_decline_encore.pressed.connect(_on_decline_encore_pressed)
	if btn_proceed_summary:
		btn_proceed_summary.pressed.connect(_on_proceed_summary_pressed)
		
	btn_finish_concert.pressed.connect(_on_finish_concert_pressed)
	
	EventBus.language_changed.connect(_on_language_changed)
	
	_setup_accessibility_hooks()
	open_preparation()

func _setup_accessibility_hooks() -> void:
	AccessibilityManager.hook_control_accessibility(opt_venue, tr("CONCERT_LABEL_VENUE"), "Seleziona il locale con le frecce su e giù. Indica la disponibilità odierna.")
	AccessibilityManager.hook_control_accessibility(spin_price, tr("CONCERT_LABEL_PRICE"), "Imposta il prezzo del biglietto in euro.")
	AccessibilityManager.hook_control_accessibility(chk_soundcheck, tr("CONCERT_LABEL_SOUNDCHECK"), "Spunta per eseguire il soundcheck prima dello show.")
	AccessibilityManager.hook_control_accessibility(btn_start_concert, tr("CONCERT_BTN_START"), "Avvia il concerto live con la scaletta selezionata.")
	if btn_add_cover:
		AccessibilityManager.hook_control_accessibility(btn_add_cover, tr("CONCERT_ADD_COVER_BTN"), "Tasto C. Inserisce una cover famosa di repertorio per scaldare il pubblico.")
	AccessibilityManager.hook_control_accessibility(btn_cancel_prep, tr("CONCERT_BTN_CANCEL"), "Chiude il menu concerti e torna all'HUD.")
	AccessibilityManager.hook_control_accessibility(btn_choice1, "Scelta 1", "Tasto rapido 1. Risolvi l'imprevisto con la prima opzione.")
	AccessibilityManager.hook_control_accessibility(btn_choice2, "Scelta 2", "Tasto rapido 2. Risolvi l'imprevisto con la seconda opzione.")
	AccessibilityManager.hook_control_accessibility(btn_next_phase, "Concludi Show", "Passa alla fase successiva dello show.")
	if btn_grant_encore:
		AccessibilityManager.hook_control_accessibility(btn_grant_encore, tr("CONCERT_ENCORE_BTN_GRANT"), "Tasto 1. Concedi il Bis al pubblico.")
	if btn_decline_encore:
		AccessibilityManager.hook_control_accessibility(btn_decline_encore, tr("CONCERT_ENCORE_BTN_DECLINE"), "Tasto 2. Saluta e concludi il concerto.")
	if btn_proceed_summary:
		AccessibilityManager.hook_control_accessibility(btn_proceed_summary, "Resoconto Finale", "Visualizza il resoconto economico e artistico.")
	AccessibilityManager.hook_control_accessibility(btn_finish_concert, tr("CONCERT_BTN_CLOSE_SUMMARY"), "Incassa i guadagni e ritorna all'HUD principale.")

func open_preparation() -> void:
	label_title.text = tr("CONCERT_TITLE_PREP")
	prep_container.visible = true
	show_container.visible = false
	if encore_container:
		encore_container.visible = false
	summary_container.visible = false
	
	selected_setlist.clear()
	is_soundcheck = false
	chk_soundcheck.button_pressed = false
	event_score_delta = 0.0
	current_event.clear()
	latest_result.clear()
	active_cover_song = null
	
	# Popola i locali della città corrente o catalogo di default
	if GameManager and GameManager.travel_system:
		venues = GameManager.travel_system.get_current_city_venues()
	else:
		venues = VenueData.get_default_venues()
		
	opt_venue.clear()
	var player_pop: float = GameManager.player_data.popularity if GameManager and GameManager.player_data else 0.0
	var player_rep: float = GameManager.player_data.reputation if GameManager and GameManager.player_data else 0.0
	var cur_day: int = GameManager.calendar_data.day_number if GameManager and GameManager.calendar_data else 1
	
	for i in range(venues.size()):
		var v: VenueData = venues[i]
		var is_locked_pop: bool = player_pop < v.min_popularity
		var is_locked_rep: bool = player_rep < v.min_reputation
		var is_locked: bool = is_locked_pop or is_locked_rep
		
		var v_status: int = Enums.VenueBookingStatus.FREE
		if GameManager and GameManager.concert_system:
			v_status = GameManager.concert_system.get_venue_status(v.id, cur_day)
			
		var status_tag: String = ""
		match v_status:
			Enums.VenueBookingStatus.BOOKED_OTHER:
				status_tag = " [Occupato Oggi]"
			Enums.VenueBookingStatus.MAINTENANCE:
				status_tag = " [Chiuso Oggi]"
			Enums.VenueBookingStatus.BOOKED_PLAYER:
				status_tag = " [Tuo Concerto Oggi]"
			_:
				status_tag = ""
				
		var lock_suffix: String = ""
		if is_locked_pop:
			lock_suffix = " (Bloccato - Req. Pop %.0f%%)" % v.min_popularity
		elif is_locked_rep:
			lock_suffix = " (Bloccato - Req. Rep %.0f)" % v.min_reputation
			
		opt_venue.add_item("%s%s%s" % [v.get_localized_name(), status_tag, lock_suffix], i)
		opt_venue.set_item_disabled(i, is_locked)
		
	# Seleziona il primo locale disponibile
	var first_avail: int = 0
	for i in range(venues.size()):
		if not opt_venue.is_item_disabled(i):
			first_avail = i
			break
	opt_venue.selected = first_avail
	_on_venue_selected(first_avail)
	
	_populate_songs()
	_update_setlist_summary()
	
	AccessibilityManager.announce("Palco dal Vivo. Scegli locale e organizza la scaletta del concerto.", true)
	opt_venue.grab_focus()

func _on_venue_selected(index: int) -> void:
	if index < 0 or index >= venues.size():
		return
	selected_venue = venues[index]
	
	var cur_day: int = GameManager.calendar_data.day_number if GameManager and GameManager.calendar_data else 1
	var actual_rent: float = selected_venue.rent_cost
	var v_status: int = Enums.VenueBookingStatus.FREE
	if GameManager and GameManager.concert_system:
		actual_rent = GameManager.concert_system.get_venue_rent_cost(selected_venue, cur_day)
		v_status = GameManager.concert_system.get_venue_status(selected_venue.id, cur_day)
		
	var weekend_note: String = " (+20% Weekend)" if actual_rent > selected_venue.rent_cost else ""
	var status_name: String = Enums.get_venue_booking_status_name(v_status)
	
	label_venue_details.text = "Capienza: %d | Affitto: %.2f €%s | Pop min: %.0f%% | Rep min: %.0f | Atmosfera: %s | Stato oggi: %s" % [
		selected_venue.capacity,
		actual_rent,
		weekend_note,
		selected_venue.min_popularity,
		selected_venue.min_reputation,
		selected_venue.atmosphere,
		status_name
	]
	
	spin_price.value = selected_venue.fair_ticket_price
	label_fair_price.text = "(Prezzo consigliato dal locale: %.2f €)" % selected_venue.fair_ticket_price
	
	# Verifica accessibilità odierna del locale
	if v_status == Enums.VenueBookingStatus.BOOKED_OTHER or v_status == Enums.VenueBookingStatus.MAINTENANCE:
		btn_start_concert.disabled = true
		var warn_msg: String = tr("CONCERT_VENUE_OCCUPIED_MSG") if v_status == Enums.VenueBookingStatus.BOOKED_OTHER else tr("CONCERT_VENUE_CLOSED_MSG")
		AccessibilityManager.announce("%s. %s" % [label_venue_details.text, warn_msg], true)
	else:
		btn_start_concert.disabled = selected_setlist.is_empty()
		AccessibilityManager.announce(label_venue_details.text, true)

func _on_price_changed(_val: float) -> void:
	if selected_venue:
		var ratio: float = spin_price.value / maxf(1.0, selected_venue.fair_ticket_price)
		if ratio > 1.4:
			label_fair_price.text = "(Prezzo alto! Il pubblico potrebbe essere penalizzato)"
		elif ratio < 0.8:
			label_fair_price.text = "(Prezzo conveniente! Attirerà molti spettatori)"
		else:
			label_fair_price.text = "(Prezzo equo ed equilibrato)"

func _populate_songs() -> void:
	for child in vbox_songs.get_children():
		child.queue_free()
		
	if not GameManager or not GameManager.player_data:
		return
		
	var playable_songs: Array[SongData] = GameManager.player_data.get_playable_songs()
	if playable_songs.is_empty() and active_cover_song == null:
		var lbl_empty := Label.new()
		lbl_empty.text = tr("CONCERT_NO_PLAYABLE_SONGS")
		lbl_empty.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vbox_songs.add_child(lbl_empty)
		btn_start_concert.disabled = true
		return
		
	btn_start_concert.disabled = false
	for i in range(playable_songs.size()):
		var song: SongData = playable_songs[i]
		var chk := CheckBox.new()
		var trait_badge: String = " [%s]" % song.get_trait_name() if song.special_trait != Enums.SongTrait.NONE else ""
		chk.text = "%d. '%s' [%s] — Qualità: %.1f%s" % [
			i + 1, song.title, song.get_genre_name(), song.quality_score, trait_badge
		]
		var acc_name: String = "Brano %d: %s. Genere %s. Qualità %.1f.%s" % [
			i + 1, song.title, song.get_genre_name(), song.quality_score, trait_badge
		]
		AccessibilityManager.hook_control_accessibility(chk, acc_name, "Spunta per includere o escludere dalla scaletta.")
		
		chk.toggled.connect(func(pressed: bool):
			_toggle_song_in_setlist(song, pressed, chk)
		)
		vbox_songs.add_child(chk)
		
	# Se è presente una cover attiva, aggiungila alla lista
	if active_cover_song:
		var chk_cover := CheckBox.new()
		chk_cover.text = "★ [COVER] '%s' [%s] — Qualità: %.1f" % [
			active_cover_song.title, active_cover_song.get_genre_name(), active_cover_song.quality_score
		]
		chk_cover.button_pressed = selected_setlist.has(active_cover_song)
		AccessibilityManager.hook_control_accessibility(chk_cover, chk_cover.text, "Spunta per includere la cover di repertorio in scaletta.")
		chk_cover.toggled.connect(func(pressed: bool):
			_toggle_song_in_setlist(active_cover_song, pressed, chk_cover)
		)
		vbox_songs.add_child(chk_cover)

func _on_add_cover_pressed() -> void:
	if selected_setlist.size() >= 4:
		AccessibilityManager.announce("Scaletta già piena (massimo 4 brani).", true)
		return
		
	var skill_exec: float = 10.0
	if GameManager and GameManager.player_data:
		skill_exec = float(GameManager.player_data.get_skill_level("instrument"))
		
	var genre: int = Enums.MusicalGenre.ROCK
	if not selected_setlist.is_empty():
		genre = selected_setlist[0].genre
		
	active_cover_song = SongData.create_cover_song(genre, skill_exec)
	selected_setlist.append(active_cover_song)
	_populate_songs()
	_update_setlist_summary()
	AccessibilityManager.announce("Cover '%s' aggiunta alla scaletta!" % active_cover_song.title, true)

func _toggle_song_in_setlist(song: SongData, is_checked: bool, chk_box: CheckBox) -> void:
	if is_checked:
		if selected_setlist.size() >= 4:
			chk_box.set_pressed_no_signal(false)
			AccessibilityManager.announce("Scaletta piena (massimo 4 brani per concerto).", true)
			return
		selected_setlist.append(song)
		var role: String = "Opener" if selected_setlist.size() == 1 else ("Closer" if selected_setlist.size() == 4 else "Mid-Set")
		var bonus_info: String = ""
		if role == "Opener" and (song.genre in [Enums.MusicalGenre.ROCK, Enums.MusicalGenre.METAL, Enums.MusicalGenre.ELECTRONIC] or song.special_trait == Enums.SongTrait.EPIC_RIFF or song.quality_score >= 65.0):
			bonus_info = " con bonus Opening Hype attivo (+15 Folla)!"
		elif role == "Mid-Set" and song.special_trait == Enums.SongTrait.TEARJERKER_BALLAD:
			bonus_info = " con momento intimo Ballad (-5 stress band, +15% fan)!"
		elif song.special_trait == Enums.SongTrait.STAGE_BEAST:
			bonus_info = " con Closer Bonus Stage Beast (+15% score)!"
		elif song.special_trait == Enums.SongTrait.GENERATIONAL_ANTHEM:
			bonus_info = " con Inno Generazionale (+3.0 reputazione, +25% fan)!"
			
		AccessibilityManager.announce("'%s' inserito in scaletta come %s%s" % [song.title, role, bonus_info], true)
	else:
		selected_setlist.erase(song)
		if song == active_cover_song:
			active_cover_song = null
			_populate_songs()
		AccessibilityManager.announce("'%s' rimosso dalla scaletta." % song.title, true)
		
	_update_setlist_summary()

func _update_setlist_summary() -> void:
	if selected_setlist.is_empty():
		label_setlist_summary.text = "Scaletta attuale: [Nessun brano selezionato — Seleziona da 1 a 4 brani]"
		btn_start_concert.disabled = true
		return
		
	var cur_day: int = GameManager.calendar_data.day_number if GameManager and GameManager.calendar_data else 1
	var v_status: int = Enums.VenueBookingStatus.FREE
	if GameManager and GameManager.concert_system and selected_venue:
		v_status = GameManager.concert_system.get_venue_status(selected_venue.id, cur_day)
	btn_start_concert.disabled = (v_status == Enums.VenueBookingStatus.BOOKED_OTHER or v_status == Enums.VenueBookingStatus.MAINTENANCE)
		
	var summary_parts: Array[String] = []
	for idx in range(selected_setlist.size()):
		var s: SongData = selected_setlist[idx]
		var role: String = "Opener" if idx == 0 else (("Closer" if idx == selected_setlist.size() - 1 else "Mid"))
		if role == "Mid" and s.special_trait == Enums.SongTrait.TEARJERKER_BALLAD:
			role = "Intimo"
		summary_parts.append("%s: '%s'" % [role, s.title])
		
	label_setlist_summary.text = "Scaletta: " + " | ".join(summary_parts)

func _on_start_concert_pressed() -> void:
	if not GameManager or not GameManager.concert_system:
		return
		
	var check := GameManager.concert_system.can_play_concert(selected_venue, selected_setlist)
	if not check.get("allowed", false):
		AccessibilityManager.announce(check.get("message", "Impossibile iniziare il concerto."), true)
		return
		
	# Esegui soundcheck se spuntato
	if chk_soundcheck.button_pressed:
		GameManager.concert_system.perform_soundcheck()
		
	# Transizione alla fase live (ShowContainer)
	label_title.text = tr("CONCERT_TITLE_LIVE")
	prep_container.visible = false
	show_container.visible = true
	if encore_container:
		encore_container.visible = false
	summary_container.visible = false
	
	label_show_status.text = "Sei sul palco del %s! La folla urla e la musica inizia a suonare!" % selected_venue.get_localized_name()
	bar_hype.value = 70.0
	
	# Bonus Opening Hype applicato subito alla barra
	if not selected_setlist.is_empty():
		var opener: SongData = selected_setlist[0]
		if opener.genre in [Enums.MusicalGenre.ROCK, Enums.MusicalGenre.METAL, Enums.MusicalGenre.ELECTRONIC] or opener.special_trait == Enums.SongTrait.EPIC_RIFF or opener.quality_score >= 65.0:
			bar_hype.value = clampf(bar_hype.value + Constants.OPENING_HYPE_BONUS, 10.0, 100.0)
	
	# Genera evento imprevisto live (7 tipi)
	current_event = GameManager.concert_system.generate_stage_event(chk_soundcheck.button_pressed)
	label_event_title.text = current_event.get("title", "Imprevisto sul Palco!")
	label_event_desc.text = current_event.get("description", "")
	btn_choice1.text = current_event.get("choice_1_text", "Scelta 1")
	btn_choice2.text = current_event.get("choice_2_text", "Scelta 2")
	btn_choice1.disabled = false
	btn_choice2.disabled = false
	btn_next_phase.disabled = true
	label_event_outcome.text = ""
	
	var announce_text := "%s. Scaletta: %d brani. %s %s. Premi 1 per %s, premi 2 per %s." % [
		label_show_status.text,
		selected_setlist.size(),
		label_event_title.text,
		label_event_desc.text,
		btn_choice1.text,
		btn_choice2.text
	]
	AccessibilityManager.announce(announce_text, true)
	btn_choice1.grab_focus()

func _on_choice_pressed(choice_index: int) -> void:
	if not GameManager or not GameManager.concert_system or current_event.is_empty():
		return
		
	btn_choice1.disabled = true
	btn_choice2.disabled = true
	
	var res := GameManager.concert_system.resolve_stage_event_choice(current_event, choice_index)
	event_score_delta = float(res.get("score_delta", 0.0))
	label_event_outcome.text = res.get("message", "")
	
	bar_hype.value = clampf(bar_hype.value + (event_score_delta * 1.5), 10.0, 100.0)
	btn_next_phase.disabled = false
	btn_next_phase.grab_focus()
	
	AccessibilityManager.announce("%s Premi Invio su 'Concludi Show' per proseguire." % label_event_outcome.text, true)

func _on_next_phase_pressed() -> void:
	if not GameManager or not GameManager.concert_system:
		return
		
	latest_result = GameManager.concert_system.resolve_concert(
		selected_venue,
		selected_setlist,
		spin_price.value,
		chk_soundcheck.button_pressed,
		event_score_delta
	)
	
	# Verifica idoneità per la fase Encore / Bis (score >= 85.0)
	if latest_result.get("eligible_for_encore", false) and encore_container:
		_show_encore_phase()
	else:
		_show_summary_phase()

func _show_encore_phase() -> void:
	label_title.text = tr("CONCERT_ENCORE_TITLE")
	prep_container.visible = false
	show_container.visible = false
	encore_container.visible = true
	summary_container.visible = false
	
	label_encore_outcome.text = ""
	btn_grant_encore.disabled = false
	btn_decline_encore.disabled = false
	btn_proceed_summary.disabled = true
	
	var announce_encore := "%s %s. Premi 1 per concedere il Bis (-10 Energia, +10%% Fan, +50 €), premi 2 per salutare e chiudere." % [
		label_encore_title.text, label_encore_desc.text
	]
	AccessibilityManager.announce(announce_encore, true)
	btn_grant_encore.grab_focus()

func _on_grant_encore_pressed() -> void:
	if not GameManager or not GameManager.concert_system:
		return
	btn_grant_encore.disabled = true
	btn_decline_encore.disabled = true
	
	var enc_res := GameManager.concert_system.resolve_encore(true, latest_result.get("concert_score", 0.0))
	if enc_res.get("granted", false):
		latest_result["encore_granted"] = true
		latest_result["new_fans"] = int(round(float(latest_result.get("new_fans", 0)) * Constants.ENCORE_FAN_BONUS_MULT))
		latest_result["player_share"] = float(latest_result.get("player_share", 0.0)) + Constants.ENCORE_EXTRA_CASH
		latest_result["net_revenue"] = float(latest_result.get("net_revenue", 0.0)) + Constants.ENCORE_EXTRA_CASH
		label_encore_outcome.text = enc_res.get("message", "")
	else:
		label_encore_outcome.text = enc_res.get("message", "")
		
	btn_proceed_summary.disabled = false
	btn_proceed_summary.grab_focus()
	AccessibilityManager.announce("%s Premi Invio su 'Passa al Resoconto Finale'." % label_encore_outcome.text, true)

func _on_decline_encore_pressed() -> void:
	if not GameManager or not GameManager.concert_system:
		return
	btn_grant_encore.disabled = true
	btn_decline_encore.disabled = true
	
	var enc_res := GameManager.concert_system.resolve_encore(false, 0.0)
	label_encore_outcome.text = enc_res.get("message", "")
	
	btn_proceed_summary.disabled = false
	btn_proceed_summary.grab_focus()
	AccessibilityManager.announce("%s Premi Invio su 'Passa al Resoconto Finale'." % label_encore_outcome.text, true)

func _on_proceed_summary_pressed() -> void:
	_show_summary_phase()

func _show_summary_phase() -> void:
	label_title.text = tr("CONCERT_TITLE_SUMMARY")
	prep_container.visible = false
	show_container.visible = false
	if encore_container:
		encore_container.visible = false
	summary_container.visible = true
	
	label_venue_audience.text = "Locale: %s | Spettatori Presenti: %d / %d" % [
		latest_result.get("venue_name", ""),
		latest_result.get("audience", 0),
		latest_result.get("capacity", 0)
	]
	label_concert_score.text = "Punteggio Esibizione dal Vivo: %.1f / 100" % latest_result.get("concert_score", 0.0)
	label_new_fans.text = "Nuovi Fan Conquistati: +%d Fan" % latest_result.get("new_fans", 0)
	label_financials.text = "Incasso Biglietti: %.2f € | Spese Affitto: %.2f € | Guadagno Netto Totale: %+.2f €" % [
		latest_result.get("gross_revenue", 0.0),
		latest_result.get("rent_cost", 0.0),
		latest_result.get("net_revenue", 0.0)
	]
	
	var merch: Dictionary = latest_result.get("merch_data", {})
	if label_merch:
		label_merch.text = "Banchetto Merchandising: Venduti %d articoli | Incasso lordo: %.2f € | Ricavo netto: %+.2f €" % [
			merch.get("items_sold", 0),
			merch.get("gross_revenue", 0.0),
			merch.get("net_revenue", 0.0)
		]
		
	label_stats_gained.text = "Popolarità: +%.1f%% | XP Assegnati a Performance e Carisma" % latest_result.get("popularity_gained", 0.0)
	
	var merch_speech: String = label_merch.text if label_merch else ""
	var voc_summary := "Concerto Concluso! %s. %s. %s. %s. %s. Premi Invio per incassare e tornare all'HUD." % [
		label_venue_audience.text,
		label_concert_score.text,
		label_new_fans.text,
		label_financials.text,
		merch_speech
	]
	AccessibilityManager.announce(voc_summary, true)
	btn_finish_concert.grab_focus()

func _on_finish_concert_pressed() -> void:
	concert_completed.emit(latest_result)
	closed.emit()

func _on_cancel_pressed() -> void:
	closed.emit()

func _on_language_changed(_new_lang: String) -> void:
	_setup_accessibility_hooks()
	if prep_container.visible:
		open_preparation()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var key_event := event as InputEventKey
		if key_event.keycode == KEY_ESCAPE:
			if prep_container.visible or summary_container.visible:
				_on_cancel_pressed()
				get_viewport().set_input_as_handled()
		elif prep_container.visible:
			if key_event.keycode == KEY_C and btn_add_cover and not btn_add_cover.disabled:
				_on_add_cover_pressed()
				get_viewport().set_input_as_handled()
		elif show_container.visible:
			if key_event.keycode == KEY_1 and not btn_choice1.disabled:
				_on_choice_pressed(1)
				get_viewport().set_input_as_handled()
			elif key_event.keycode == KEY_2 and not btn_choice2.disabled:
				_on_choice_pressed(2)
				get_viewport().set_input_as_handled()
		elif encore_container and encore_container.visible:
			if key_event.keycode == KEY_1 and not btn_grant_encore.disabled:
				_on_grant_encore_pressed()
				get_viewport().set_input_as_handled()
			elif key_event.keycode == KEY_2 and not btn_decline_encore.disabled:
				_on_decline_encore_pressed()
				get_viewport().set_input_as_handled()
