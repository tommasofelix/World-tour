# res://ui/concert/live_concert.gd
extends Control

## Controller del Palco dal Vivo e della Simulazione Concerti per World-tour
## Implementa la Simmetria Universale (Luca con NVDA/tastiera e Tom a monitor)
## Gestisce la preparazione scaletta, gli imprevisti live (Stage Events) e il resoconto finale.

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

# Contenitore 3: Resoconto Finale
@onready var summary_container: VBoxContainer = $PanelMain/VBox/SummaryContainer
@onready var label_summary_title: Label = $PanelMain/VBox/SummaryContainer/LabelSummaryTitle
@onready var label_venue_audience: Label = $PanelMain/VBox/SummaryContainer/LabelVenueAudience
@onready var label_concert_score: Label = $PanelMain/VBox/SummaryContainer/LabelConcertScore
@onready var label_new_fans: Label = $PanelMain/VBox/SummaryContainer/LabelNewFans
@onready var label_financials: Label = $PanelMain/VBox/SummaryContainer/LabelFinancials
@onready var label_stats_gained: Label = $PanelMain/VBox/SummaryContainer/LabelStatsGained
@onready var btn_finish_concert: Button = $PanelMain/VBox/SummaryContainer/HBoxSummaryButtons/BtnFinishConcert

var venues: Array[VenueData] = []
var selected_venue: VenueData
var selected_setlist: Array[SongData] = []
var is_soundcheck: bool = false
var current_event: Dictionary = {}
var event_score_delta: float = 0.0
var latest_result: Dictionary = {}

func _ready() -> void:
	venues = VenueData.get_default_venues()
	
	opt_venue.item_selected.connect(_on_venue_selected)
	spin_price.value_changed.connect(_on_price_changed)
	chk_soundcheck.toggled.connect(func(pressed: bool): is_soundcheck = pressed)
	
	btn_start_concert.pressed.connect(_on_start_concert_pressed)
	btn_cancel_prep.pressed.connect(_on_cancel_pressed)
	
	btn_choice1.pressed.connect(func(): _on_choice_pressed(1))
	btn_choice2.pressed.connect(func(): _on_choice_pressed(2))
	btn_next_phase.pressed.connect(_on_next_phase_pressed)
	btn_finish_concert.pressed.connect(_on_finish_concert_pressed)
	
	EventBus.language_changed.connect(_on_language_changed)
	
	_setup_accessibility_hooks()
	open_preparation()

func _setup_accessibility_hooks() -> void:
	AccessibilityManager.hook_control_accessibility(opt_venue, tr("CONCERT_LABEL_VENUE"), "Seleziona il locale con le frecce su e giù.")
	AccessibilityManager.hook_control_accessibility(spin_price, tr("CONCERT_LABEL_PRICE"), "Imposta il prezzo del biglietto in euro.")
	AccessibilityManager.hook_control_accessibility(chk_soundcheck, tr("CONCERT_LABEL_SOUNDCHECK"), "Spunta per eseguire il soundcheck prima dello show.")
	AccessibilityManager.hook_control_accessibility(btn_start_concert, tr("CONCERT_BTN_START"), "Avvia il concerto live con la scaletta selezionata.")
	AccessibilityManager.hook_control_accessibility(btn_cancel_prep, tr("CONCERT_BTN_CANCEL"), "Chiude il menu concerti e torna all'HUD.")
	AccessibilityManager.hook_control_accessibility(btn_choice1, "Scelta 1", "Tasto rapido 1. Risolvi l'imprevisto con la prima opzione.")
	AccessibilityManager.hook_control_accessibility(btn_choice2, "Scelta 2", "Tasto rapido 2. Risolvi l'imprevisto con la seconda opzione.")
	AccessibilityManager.hook_control_accessibility(btn_next_phase, "Concludi Show", "Passa alla schermata di resoconto finale.")
	AccessibilityManager.hook_control_accessibility(btn_finish_concert, tr("CONCERT_BTN_CLOSE_SUMMARY"), "Incassa i guadagni e ritorna all'HUD principale.")

func open_preparation() -> void:
	label_title.text = tr("CONCERT_TITLE_PREP")
	prep_container.visible = true
	show_container.visible = false
	summary_container.visible = false
	
	selected_setlist.clear()
	is_soundcheck = false
	chk_soundcheck.button_pressed = false
	event_score_delta = 0.0
	current_event.clear()
	latest_result.clear()
	
	# Popola i locali
	opt_venue.clear()
	var player_pop: float = GameManager.player_data.popularity if GameManager and GameManager.player_data else 0.0
	for i in range(venues.size()):
		var v: VenueData = venues[i]
		var is_locked: bool = player_pop < v.min_popularity
		var lock_suffix: String = " (Bloccato - Req. %.0f%%)" % v.min_popularity if is_locked else ""
		opt_venue.add_item("%s%s" % [v.get_localized_name(), lock_suffix], i)
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
	
	AccessibilityManager.announce("Palco dal Vivo. Scegli locale e scaletta per il concerto.", true)
	opt_venue.grab_focus()

func _on_venue_selected(index: int) -> void:
	if index < 0 or index >= venues.size():
		return
	selected_venue = venues[index]
	label_venue_details.text = "Capienza: %d | Affitto: %.2f € | Popolarità min: %.1f%%" % [
		selected_venue.capacity, selected_venue.rent_cost, selected_venue.min_popularity
	]
	spin_price.value = selected_venue.fair_ticket_price
	label_fair_price.text = "(Prezzo consigliato dal locale: %.2f €)" % selected_venue.fair_ticket_price

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
	if playable_songs.is_empty():
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

func _toggle_song_in_setlist(song: SongData, is_checked: bool, chk_box: CheckBox) -> void:
	if is_checked:
		if selected_setlist.size() >= 4:
			chk_box.set_pressed_no_signal(false)
			AccessibilityManager.announce("Scaletta piena (massimo 4 brani per concerto).", true)
			return
		selected_setlist.append(song)
		var position_str: String = "Opener" if selected_setlist.size() == 1 else ("Closer" if selected_setlist.size() == 4 else "Mid-Set")
		var bonus_note: String = " con bonus Stage Beast attivo (+15%)!" if song.special_trait == Enums.SongTrait.STAGE_BEAST and selected_setlist.size() > 1 else "."
		AccessibilityManager.announce("'%s' aggiunto in scaletta come %s%s" % [song.title, position_str, bonus_note], true)
	else:
		selected_setlist.erase(song)
		AccessibilityManager.announce("'%s' rimosso dalla scaletta." % song.title, true)
		
	_update_setlist_summary()

func _update_setlist_summary() -> void:
	if selected_setlist.is_empty():
		label_setlist_summary.text = "Scaletta attuale: [Nessun brano selezionato — Seleziona da 1 a 4 brani]"
		return
		
	var summary_parts: Array[String] = []
	for idx in range(selected_setlist.size()):
		var s: SongData = selected_setlist[idx]
		var role: String = "Opener" if idx == 0 else (("Closer" if idx == selected_setlist.size() - 1 else "Mid"))
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
	summary_container.visible = false
	
	label_show_status.text = "Sei sul palco del %s! La folla urla e la musica inizia a suonare!" % selected_venue.get_localized_name()
	bar_hype.value = 70.0
	
	# Genera evento imprevisto live
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
	
	AccessibilityManager.announce("%s Premi Invio su 'Concludi Show' per vedere i risultati." % label_event_outcome.text, true)

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
	
	# Transizione alla fase di riepilogo
	label_title.text = tr("CONCERT_TITLE_SUMMARY")
	prep_container.visible = false
	show_container.visible = false
	summary_container.visible = true
	
	label_venue_audience.text = "Locale: %s | Spettatori Presenti: %d / %d" % [
		latest_result.get("venue_name", ""),
		latest_result.get("audience", 0),
		latest_result.get("capacity", 0)
	]
	label_concert_score.text = "Punteggio Esibizione dal Vivo: %.1f / 100" % latest_result.get("concert_score", 0.0)
	label_new_fans.text = "Nuovi Fan Conquistati: +%d Fan" % latest_result.get("new_fans", 0)
	label_financials.text = "Incasso Lordo: %.2f € | Affitto: %.2f € | Guadagno Netto: %+.2f €" % [
		latest_result.get("gross_revenue", 0.0),
		latest_result.get("rent_cost", 0.0),
		latest_result.get("net_revenue", 0.0)
	]
	label_stats_gained.text = "Popolarità: +%.1f%% | XP Assegnati a Performance e Carisma" % latest_result.get("popularity_gained", 0.0)
	
	var voc_summary := "Concerto Concluso! %s. %s. %s. %s. Premi Invio per incassare e tornare all'HUD." % [
		label_venue_audience.text,
		label_concert_score.text,
		label_new_fans.text,
		label_financials.text
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
		elif show_container.visible:
			if key_event.keycode == KEY_1 and not btn_choice1.disabled:
				_on_choice_pressed(1)
				get_viewport().set_input_as_handled()
			elif key_event.keycode == KEY_2 and not btn_choice2.disabled:
				_on_choice_pressed(2)
				get_viewport().set_input_as_handled()
