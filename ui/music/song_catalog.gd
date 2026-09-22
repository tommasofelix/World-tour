# res://ui/music/song_catalog.gd
extends Control

## Controller del Catalogo Discografico di World-tour
## Permette di consultare brani, bozze, tracce prodotte e singoli rilasciati.
## Accessibile da tastiera per Luca e con interfaccia a schede ad alto contrasto per Holy Diver.

signal closed()
signal new_song_requested()

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var btn_filter_all: Button = $PanelMain/VBox/HBoxFilters/BtnFilterAll
@onready var btn_filter_drafts: Button = $PanelMain/VBox/HBoxFilters/BtnFilterDrafts
@onready var btn_filter_produced: Button = $PanelMain/VBox/HBoxFilters/BtnFilterProduced
@onready var btn_filter_released: Button = $PanelMain/VBox/HBoxFilters/BtnFilterReleased

@onready var scroll_container: ScrollContainer = $PanelMain/VBox/ScrollSongs
@onready var vbox_songs: VBoxContainer = $PanelMain/VBox/ScrollSongs/VBoxSongs
@onready var label_empty: Label = $PanelMain/VBox/LabelEmpty

@onready var btn_new_song: Button = $PanelMain/VBox/HBoxBottom/BtnNewSong
@onready var btn_close: Button = $PanelMain/VBox/HBoxBottom/BtnClose

var current_filter: int = -1 # -1 = All, otherwise Enums.SongStatus

func _ready() -> void:
	btn_filter_all.pressed.connect(func(): _set_filter(-1))
	btn_filter_drafts.pressed.connect(func(): _set_filter(Enums.SongStatus.DRAFT))
	btn_filter_produced.pressed.connect(func(): _set_filter(Enums.SongStatus.PRODUCED))
	btn_filter_released.pressed.connect(func(): _set_filter(Enums.SongStatus.RELEASED))
	
	btn_new_song.pressed.connect(_on_new_song_pressed)
	btn_close.pressed.connect(_on_close_pressed)
	
	EventBus.language_changed.connect(_on_language_changed)
	EventBus.song_released.connect(func(_data): refresh_catalog())
	EventBus.song_created.connect(func(_data): refresh_catalog())
	
	_refresh_ui_text()
	refresh_catalog()

func _refresh_ui_text() -> void:
	label_title.text = tr("CATALOG_TITLE")
	btn_filter_all.text = tr("CATALOG_FILTER_ALL")
	btn_filter_drafts.text = tr("CATALOG_FILTER_DRAFTS")
	btn_filter_produced.text = tr("CATALOG_FILTER_PRODUCED")
	btn_filter_released.text = tr("CATALOG_FILTER_RELEASED")
	
	label_empty.text = tr("CATALOG_EMPTY")
	btn_new_song.text = tr("CATALOG_BTN_NEW")
	btn_close.text = tr("CATALOG_BTN_CLOSE")
	
	AccessibilityManager.hook_control_accessibility(btn_new_song, tr("CATALOG_BTN_NEW"), tr("HUD_BTN_NEW_SONG_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_close, tr("CATALOG_BTN_CLOSE"), "Chiude il catalogo e ritorna alla schermata precedente.")

func _set_filter(filter: int) -> void:
	current_filter = filter
	refresh_catalog()

func refresh_catalog() -> void:
	if not vbox_songs:
		return
	for child in vbox_songs.get_children():
		child.queue_free()
		
	if not GameManager or not GameManager.player_data:
		label_empty.visible = true
		return
		
	var songs: Array[SongData] = GameManager.player_data.songs
	var filtered_songs: Array[SongData] = []
	for s in songs:
		if current_filter == -1 or s.status == current_filter:
			filtered_songs.append(s)
			
	if filtered_songs.is_empty():
		label_empty.visible = true
		btn_new_song.grab_focus()
	else:
		label_empty.visible = false
		for i in range(filtered_songs.size()):
			var s: SongData = filtered_songs[i]
			var row: HBoxContainer = _create_song_row(i + 1, s)
			vbox_songs.add_child(row)
			if i == 0:
				var first_btn: Button = row.get_node_or_null("BtnSelect")
				if first_btn:
					first_btn.grab_focus()

func _create_song_row(index: int, song: SongData) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 15)
	
	var btn := Button.new()
	btn.name = "BtnSelect"
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	
	var status_str := song.get_status_name()
	var genre_str := song.get_genre_name()
	var trait_str := song.get_trait_name()
	
	var row_text := "%d. '%s' [%s] — %s | Qualità: %.1f | Tratto: %s" % [
		index, song.title, genre_str, status_str, song.quality_score, trait_str
	]
	btn.text = row_text
	
	var acc_name := "Brano %d: %s. Genere %s. Stato %s. Qualità %.1f su 100. Tratto %s." % [
		index, song.title, genre_str, status_str, song.quality_score, trait_str
	]
	var acc_desc := "Premi Invio per visualizzare dettagli o compiere azioni."
	AccessibilityManager.hook_control_accessibility(btn, acc_name, acc_desc)
	row.add_child(btn)
	
	# Se è in stato PRODUCED, aggiungi bottone per rilasciare come Singolo
	if song.status == Enums.SongStatus.PRODUCED:
		var btn_release := Button.new()
		btn_release.text = tr("CATALOG_BTN_RELEASE")
		AccessibilityManager.hook_control_accessibility(btn_release, tr("CATALOG_BTN_RELEASE"), "Pubblica il brano sul mercato musicale.")
		btn_release.pressed.connect(func():
			if GameManager and GameManager.music_system:
				GameManager.music_system.release_single(song.id)
				refresh_catalog()
		)
		row.add_child(btn_release)
		
	return row

func _on_new_song_pressed() -> void:
	new_song_requested.emit()

func _on_close_pressed() -> void:
	closed.emit()

func _on_language_changed(_new_lang: String) -> void:
	_refresh_ui_text()
	refresh_catalog()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var key_event := event as InputEventKey
		if key_event.keycode == KEY_ESCAPE:
			_on_close_pressed()
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_N:
			_on_new_song_pressed()
			get_viewport().set_input_as_handled()
