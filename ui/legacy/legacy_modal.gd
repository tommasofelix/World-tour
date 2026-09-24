# res://ui/legacy/legacy_modal.gd
extends Control

## Controller della Schermata Albo d'Oro, Certificazioni, Premi & Legacy Mondiale (Sezione 11)
## Accessibilità 100% tastiera e sintesi vocale NVDA per Luca (Zero Mouse),
## grafica responsive ad alto contrasto per Holy Diver.

signal closed()

const AwardSystemScript = preload("res://systems/award_system.gd")
const LegacySystemScript = preload("res://systems/legacy_system.gd")

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var label_subtitle: Label = $PanelMain/VBox/Header/LabelSubtitle
@onready var btn_tab_certs: Button = $PanelMain/VBox/HBoxTabs/BtnTabCerts
@onready var btn_tab_awards: Button = $PanelMain/VBox/HBoxTabs/BtnTabAwards
@onready var btn_tab_hof: Button = $PanelMain/VBox/HBoxTabs/BtnTabHof
@onready var btn_tab_legacy: Button = $PanelMain/VBox/HBoxTabs/BtnTabLegacy

@onready var scroll_entries: ScrollContainer = $PanelMain/VBox/PanelBody/Margin/VBoxBody/ScrollEntries
@onready var vbox_entries: VBoxContainer = $PanelMain/VBox/PanelBody/Margin/VBoxBody/ScrollEntries/VBoxEntries
@onready var label_status: Label = $PanelMain/VBox/LabelStatus
@onready var btn_close: Button = $PanelMain/VBox/HBoxBottom/BtnClose

var current_tab: int = 0 # 0 = Certificazioni, 1 = Music Awards, 2 = Hall of Fame, 3 = The Last Waltz & Epilogo

func _ready() -> void:
	btn_close.pressed.connect(close)
	AccessibilityManager.hook_control_accessibility(btn_close, "Chiudi Finestra Legacy", "Chiude la schermata e torna all'HUD.")

	btn_tab_certs.pressed.connect(func(): _set_tab(0))
	btn_tab_awards.pressed.connect(func(): _set_tab(1))
	btn_tab_hof.pressed.connect(func(): _set_tab(2))
	btn_tab_legacy.pressed.connect(func(): _set_tab(3))

	AccessibilityManager.hook_control_accessibility(btn_tab_certs, "1: Certificazioni Ufficiali", "Mostra Dischi d'Oro, Platino e Diamante conquistati da singoli e album.")
	AccessibilityManager.hook_control_accessibility(btn_tab_awards, "2: World Music Awards", "Consulta le statuette vinte nelle cerimonie annuali.")
	AccessibilityManager.hook_control_accessibility(btn_tab_hof, "3: Hall of Fame", "Verifica i requisiti per l'ingresso nella Rock and Roll Hall of Fame.")
	AccessibilityManager.hook_control_accessibility(btn_tab_legacy, "4: The Last Waltz & Epilogo", "Organizza il concerto d'addio celebrativo e consulta l'epilogo narrativo di carriera.")

	EventBus.certification_awarded.connect(func(_d): if visible: refresh_view())
	EventBus.award_won.connect(func(_d): if visible: refresh_view())
	EventBus.hall_of_fame_inducted.connect(func(_d): if visible: refresh_view())
	EventBus.last_waltz_performed.connect(func(_d): if visible: refresh_view())

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_W:
			close()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_1:
			_set_tab(0)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_2:
			_set_tab(1)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_3:
			_set_tab(2)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_4:
			_set_tab(3)
			get_viewport().set_input_as_handled()

func open() -> void:
	visible = true
	current_tab = 0
	refresh_view()
	if GameManager:
		GameManager.open_menu()
	if btn_tab_certs:
		btn_tab_certs.grab_focus()
	_announce_current_view()

func close() -> void:
	visible = false
	if GameManager:
		GameManager.close_menu()
	closed.emit()
	AccessibilityManager.announce("Schermata Legacy e Premi chiusa.", true)

func _set_tab(tab_idx: int) -> void:
	current_tab = tab_idx
	refresh_view()
	_announce_current_view()

func refresh_view() -> void:
	if not GameManager or not GameManager.player_data:
		return

	var player: PlayerData = GameManager.player_data
	var award_sys = GameManager.award_system
	var legacy_sys = GameManager.legacy_system

	for c in vbox_entries.get_children():
		c.queue_free()

	# Esegui scansione preventiva di eventuali nuove certificazioni raggiunte
	if award_sys:
		award_sys.check_and_award_certifications()

	match current_tab:
		0:
			label_title.text = "Albo d'Oro — Certificazioni Discografiche FIMI / RIAA"
			label_subtitle.text = "Dischi d'Oro (25k / 10M stream), Platino (50k / 25M stream), Multi-Platino (100k / 50M stream) e Diamante (500k / 100M stream)"
			_render_certifications_tab(player)
		1:
			label_title.text = "World Music Awards — Palmarès & Statuette Ufficiali"
			label_subtitle.text = "Cerimonia annuale di fine anno (Mese 12). Categorie: Canzone, Album, Live Band, Miglior Produttore"
			_render_awards_tab(player)
		2:
			label_title.text = "Rock and Roll Hall of Fame — Consacrazione Eterna"
			label_subtitle.text = "Requisiti: Status Superstar Mondiale, Reputazione >= 75.0, 80.000+ Fan, almeno 1 Disco di Platino"
			_render_hall_of_fame_tab(player, legacy_sys)
		3:
			label_title.text = "The Last Waltz & Epilogo Narrativo della Carriera"
			label_subtitle.text = "Il grande concerto d'addio celebrativo e il bilancio storico della tua eredità artistica"
			_render_legacy_tab(player, legacy_sys)

func _render_certifications_tab(player: PlayerData) -> void:
	if player.certifications.is_empty():
		var lbl_empty := Label.new()
		lbl_empty.text = "Nessuna certificazione ufficiale ancora conquistata.\nRilascia singoli di successo o album per scalare le vendite e gli streaming!"
		lbl_empty.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vbox_entries.add_child(lbl_empty)
		label_status.text = "Totale certificazioni: 0"
		return

	label_status.text = "Totale certificazioni: %d (Oro: %d, Platino: %d, Multi-Platino: %d, Diamante: %d)" % [
		player.certifications.size(),
		player.get_certifications_count(Enums.CertificationTier.GOLD),
		player.get_certifications_count(Enums.CertificationTier.PLATINUM),
		player.get_certifications_count(Enums.CertificationTier.MULTI_PLATINUM),
		player.get_certifications_count(Enums.CertificationTier.DIAMOND)
	]

	for i in range(player.certifications.size()):
		var cert: Dictionary = player.certifications[i]
		var item_title: String = cert.get("title", "Titolo")
		var item_type: String = "Singolo" if cert.get("type", "") == "single" else "Album"
		var tier_idx: int = int(cert.get("tier", 0))
		var tier_name: String = Enums.get_certification_name(tier_idx)
		var day_awarded: int = int(cert.get("day", 1))

		var panel := PanelContainer.new()
		var hbox := HBoxContainer.new()
		panel.add_child(hbox)

		var lbl_badge := Label.new()
		lbl_badge.text = "[ %s ]" % tier_name.to_upper()
		lbl_badge.custom_minimum_size = Vector2(160, 0)
		hbox.add_child(lbl_badge)

		var lbl_info := Label.new()
		lbl_info.text = "%s '%s' — Conseguito il Giorno %d" % [item_type, item_title, day_awarded]
		lbl_info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(lbl_info)

		var acc_speech := "Certificazione: %s per il %s '%s', ottenuto il giorno %d." % [tier_name, item_type, item_title, day_awarded]
		AccessibilityManager.hook_control_accessibility(panel, acc_speech, "Certificazione discografica ufficiale.")
		vbox_entries.add_child(panel)

func _render_awards_tab(player: PlayerData) -> void:
	if player.music_awards.is_empty():
		var lbl_empty := Label.new()
		lbl_empty.text = "Nessuna statuetta vinta ai World Music Awards finora.\nLa cerimonia si tiene ogni anno a fine stagione (Mese 12). Continua a produrre capolavori e suonare concerti memorabili!"
		lbl_empty.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vbox_entries.add_child(lbl_empty)
		label_status.text = "Statuette vinte: 0"
		return

	label_status.text = "Totale World Music Awards vinti: %d" % player.music_awards.size()

	for i in range(player.music_awards.size()):
		var award: Dictionary = player.music_awards[i]
		var cat_name: String = award.get("category_name", "Premio Musicale")
		var title: String = award.get("title", "")
		var winner: String = award.get("winner_name", player.player_name)

		var panel := PanelContainer.new()
		var hbox := HBoxContainer.new()
		panel.add_child(hbox)

		var lbl_trophy := Label.new()
		lbl_trophy.text = "🏆 [ %s ]" % cat_name
		lbl_trophy.custom_minimum_size = Vector2(240, 0)
		hbox.add_child(lbl_trophy)

		var lbl_info := Label.new()
		lbl_info.text = "Assegnato a '%s' per l'opera: '%s'" % [winner, title]
		lbl_info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(lbl_info)

		var acc_speech := "Premio: %s. Assegnato a %s per %s." % [cat_name, winner, title]
		AccessibilityManager.hook_control_accessibility(panel, acc_speech, "Trofeo World Music Awards.")
		vbox_entries.add_child(panel)

func _render_hall_of_fame_tab(player: PlayerData, legacy_sys: RefCounted) -> void:
	var check: Dictionary = legacy_sys.check_hall_of_fame_eligibility() if legacy_sys else {"eligible": false}

	if player.hall_of_fame_inducted:
		var lbl_inducted := Label.new()
		lbl_inducted.text = "🏛️ CONSACRAZIONE NELLA ROCK AND ROLL HALL OF FAME 🏛️\n\n%s e la band %s sono stati ufficialmente indotti nella Hall of Fame!\nIl vostro nome è scolpito a lettere d'oro nel tempio supremo della musica mondiale." % [
			player.player_name, player.band_name
		]
		lbl_inducted.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vbox_entries.add_child(lbl_inducted)
		label_status.text = "Status: Membro Consacrato nella Hall of Fame."
		return

	var lbl_status_hof := Label.new()
	lbl_status_hof.text = check.get("message", "")
	lbl_status_hof.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox_entries.add_child(lbl_status_hof)

	if check.get("eligible", false):
		var btn_induct := Button.new()
		btn_induct.text = "🏛️ Celebra Induzione nella Hall of Fame"
		btn_induct.pressed.connect(func():
			if legacy_sys:
				legacy_sys.induct_into_hall_of_fame()
				refresh_view()
				_announce_current_view()
		)
		AccessibilityManager.hook_control_accessibility(btn_induct, "Induzione nella Hall of Fame", "Premi Invio per celebrare la cerimonia di ingresso nella Rock and Roll Hall of Fame.")
		vbox_entries.add_child(btn_induct)
		btn_induct.grab_focus()
		label_status.text = "Sei idoneo per l'induzione!"
	else:
		label_status.text = "Requisiti mancanti per l'induzione."

func _render_legacy_tab(player: PlayerData, legacy_sys: RefCounted) -> void:
	if player.last_waltz_completed:
		var ending_eval: Dictionary = legacy_sys.evaluate_legacy_ending() if legacy_sys else {}
		var title: String = ending_eval.get("ending_title", "L'Icona Immortale")
		var narrative: String = ending_eval.get("narrative", "")

		var lbl_done := Label.new()
		lbl_done.text = "🎬 CONCERTO D'ADDIO 'THE LAST WALTZ' COMPLETATO 🎬\n\nEPILOGO DELLA CARRIERA: %s\n\n%s\n\nPuoi continuare a giocare liberamente per esplorare nuovi traguardi!" % [
			title.to_upper(), narrative
		]
		lbl_done.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vbox_entries.add_child(lbl_done)
		label_status.text = "Epilogo conseguito: %s" % title
		return

	var lbl_intro := Label.new()
	lbl_intro.text = "Il Concerto d'Addio ('The Last Waltz') è l'evento di chiusura culminante della tua carriera artistica.\nRiunisce tutti i membri della band, raccoglie milioni in beneficenza e calcola l'Epilogo Narrativo della tua Legacy.\n\nNota: Dopo il concerto potrai continuare a giocare all'infinito."
	lbl_intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox_entries.add_child(lbl_intro)

	var playable_songs: Array[SongData] = player.get_playable_songs()
	if playable_songs.is_empty():
		var lbl_warn := Label.new()
		lbl_warn.text = "È necessario avere almeno un brano pronto per tenere The Last Waltz."
		vbox_entries.add_child(lbl_warn)
		label_status.text = "Nessun brano disponibile."
		return

	var btn_waltz := Button.new()
	btn_waltz.text = "🎸 Organizza 'The Last Waltz' (Concerto d'Addio)"
	btn_waltz.pressed.connect(func():
		if legacy_sys:
			legacy_sys.perform_last_waltz(playable_songs)
			refresh_view()
			_announce_current_view()
	)
	AccessibilityManager.hook_control_accessibility(btn_waltz, "Esegui The Last Waltz", "Organizza il concerto d'addio finale e calcola l'epilogo narrativo di carriera.")
	vbox_entries.add_child(btn_waltz)
	btn_waltz.grab_focus()
	label_status.text = "Pronto per organizzare The Last Waltz."

func _announce_current_view() -> void:
	var msg: String = "%s. %s. %s." % [label_title.text, label_subtitle.text, label_status.text]
	AccessibilityManager.announce(msg, true)
