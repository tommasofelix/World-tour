# res://ui/music/song_catalog.gd
extends Control

## Controller del Catalogo Discografico di World-tour
## Permette di consultare brani, bozze, tracce prodotte, singoli e raccolte Album/EP.
## Accessibile da tastiera per Luca e con interfaccia a schede ad alto contrasto per Holy Diver.

signal closed()
signal new_song_requested()
signal new_album_requested()
signal edit_song_requested(song: SongData)

const FILTER_ALL: int = -1
const FILTER_ALBUMS: int = 99

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var btn_filter_all: Button = $PanelMain/VBox/HBoxFilters/BtnFilterAll
@onready var btn_filter_drafts: Button = $PanelMain/VBox/HBoxFilters/BtnFilterDrafts
@onready var btn_filter_produced: Button = $PanelMain/VBox/HBoxFilters/BtnFilterProduced
@onready var btn_filter_released: Button = $PanelMain/VBox/HBoxFilters/BtnFilterReleased
@onready var btn_filter_albums: Button = $PanelMain/VBox/HBoxFilters/BtnFilterAlbums

@onready var scroll_container: ScrollContainer = $PanelMain/VBox/ScrollSongs
@onready var vbox_songs: VBoxContainer = $PanelMain/VBox/ScrollSongs/VBoxSongs
@onready var label_empty: Label = $PanelMain/VBox/LabelEmpty

@onready var btn_new_song: Button = $PanelMain/VBox/HBoxBottom/BtnNewSong
@onready var btn_new_album: Button = $PanelMain/VBox/HBoxBottom/BtnNewAlbum
@onready var btn_close: Button = $PanelMain/VBox/HBoxBottom/BtnClose

var current_filter: int = -1 # -1 = All, 99 = Albums, otherwise Enums.SongStatus

func _ready() -> void:
	btn_filter_all.pressed.connect(func(): _set_filter(FILTER_ALL))
	btn_filter_drafts.pressed.connect(func(): _set_filter(Enums.SongStatus.DRAFT))
	btn_filter_produced.pressed.connect(func(): _set_filter(Enums.SongStatus.PRODUCED))
	btn_filter_released.pressed.connect(func(): _set_filter(Enums.SongStatus.RELEASED))
	btn_filter_albums.pressed.connect(func(): _set_filter(FILTER_ALBUMS))
	
	btn_new_song.pressed.connect(_on_new_song_pressed)
	btn_new_album.pressed.connect(_on_new_album_pressed)
	btn_close.pressed.connect(_on_close_pressed)
	
	EventBus.language_changed.connect(_on_language_changed)
	EventBus.song_released.connect(func(_data): refresh_catalog())
	EventBus.song_created.connect(func(_data): refresh_catalog())
	EventBus.song_updated.connect(func(_data): refresh_catalog())
	EventBus.album_released.connect(func(_data): refresh_catalog())
	
	_refresh_ui_text()
	refresh_catalog()

func _refresh_ui_text() -> void:
	label_title.text = tr("CATALOG_TITLE")
	btn_filter_all.text = tr("CATALOG_FILTER_ALL")
	btn_filter_drafts.text = tr("CATALOG_FILTER_DRAFTS")
	btn_filter_produced.text = tr("CATALOG_FILTER_PRODUCED")
	btn_filter_released.text = tr("CATALOG_FILTER_RELEASED")
	btn_filter_albums.text = tr("CATALOG_FILTER_ALBUMS")
	
	label_empty.text = tr("CATALOG_EMPTY")
	btn_new_song.text = tr("CATALOG_BTN_NEW")
	btn_new_album.text = tr("CATALOG_BTN_NEW_ALBUM")
	btn_close.text = tr("CATALOG_BTN_CLOSE")
	
	AccessibilityManager.hook_control_accessibility(btn_filter_all, tr("CATALOG_FILTER_ALL"), "Visualizza tutti i brani e singoli. Tasto rapido S.")
	AccessibilityManager.hook_control_accessibility(btn_filter_drafts, tr("CATALOG_FILTER_DRAFTS"), "Filtra solo le bozze in lavorazione.")
	AccessibilityManager.hook_control_accessibility(btn_filter_produced, tr("CATALOG_FILTER_PRODUCED"), "Filtra i brani prodotti pronti per il rilascio.")
	AccessibilityManager.hook_control_accessibility(btn_filter_released, tr("CATALOG_FILTER_RELEASED"), "Filtra i singoli pubblicati sul mercato.")
	AccessibilityManager.hook_control_accessibility(btn_filter_albums, tr("CATALOG_FILTER_ALBUMS"), "Visualizza la sezione dedicata ad Album ed EP. Tasto rapido A.")

	AccessibilityManager.hook_control_accessibility(btn_new_song, tr("CATALOG_BTN_NEW"), tr("HUD_BTN_NEW_SONG_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_new_album, tr("CATALOG_BTN_NEW_ALBUM"), "Tasto rapido P. Apre lo studio di mastering per produrre un EP o LP.")
	AccessibilityManager.hook_control_accessibility(btn_close, tr("CATALOG_BTN_CLOSE"), "Chiude il catalogo e ritorna alla schermata precedente.")

func _set_filter(filter: int) -> void:
	current_filter = filter
	refresh_catalog()

func show_albums_section() -> void:
	current_filter = FILTER_ALBUMS
	refresh_catalog()
	var count: int = GameManager.player_data.albums.size() if GameManager and GameManager.player_data else 0
	var announcement := "Sezione Album ed EP selezionata. %d opere pubblicate." % count
	if count > 0:
		announcement += " Premi i tasti freccia per scorrere o Invio per ascoltare la tracklist."
	else:
		announcement += " Premi P per registrare il tuo primo disco."
	AccessibilityManager.announce(announcement, true)

func show_songs_section() -> void:
	current_filter = FILTER_ALL
	refresh_catalog()
	var count: int = GameManager.player_data.songs.size() if GameManager and GameManager.player_data else 0
	AccessibilityManager.announce("Sezione Brani e Singoli selezionata. %d tracce presenti." % count, true)

func refresh_catalog() -> void:
	if not vbox_songs:
		return
	for child in vbox_songs.get_children():
		child.queue_free()
		
	if not GameManager or not GameManager.player_data:
		label_empty.visible = true
		return
		
	if current_filter == FILTER_ALBUMS:
		_render_albums()
	else:
		_render_songs()

func _render_songs() -> void:
	var songs: Array[SongData] = GameManager.player_data.songs
	var filtered_songs: Array[SongData] = []
	for s in songs:
		if current_filter == -1 or s.status == current_filter:
			filtered_songs.append(s)
			
	if filtered_songs.is_empty():
		label_empty.visible = true
		label_empty.text = tr("CATALOG_EMPTY")
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

func _render_albums() -> void:
	var albums: Array[AlbumData] = GameManager.player_data.albums
	if albums.is_empty():
		label_empty.visible = true
		label_empty.text = "Nessun Album o EP ancora pubblicato. Premi 'P' per produrre il tuo primo disco!"
		btn_new_album.grab_focus()
	else:
		label_empty.visible = false
		for i in range(albums.size()):
			var a: AlbumData = albums[i]
			var row: HBoxContainer = _create_album_row(i + 1, a)
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
	var theme_str := song.get_theme_name()
	
	var row_text := "%d. '%s' [%s - %s] — %s | Qualità: %.1f | Tratto: %s" % [
		index, song.title, genre_str, theme_str, status_str, song.quality_score, trait_str
	]
	btn.text = row_text
	
	var acc_name := "Brano %d: %s. Genere %s. Tema %s. Stato %s. Qualità %.1f su 100. Tratto %s." % [
		index, song.title, genre_str, theme_str, status_str, song.quality_score, trait_str
	]
	var acc_desc := "Premi Invio per visualizzare dettagli o compiere azioni."
	
	if song.status == Enums.SongStatus.DRAFT:
		var stage_str := song.get_stage_name()
		acc_name = "Bozza %d: %s. Genere %s. Tema %s. Fase %s. Qualità %.1f su 100." % [
			index, song.title, genre_str, theme_str, stage_str, song.quality_score
		]
		acc_desc = tr("CATALOG_BTN_EDIT_ACC_DESC")
		btn.pressed.connect(func():
			edit_song_requested.emit(song)
		)
		
		var btn_edit := Button.new()
		btn_edit.name = "BtnEdit"
		btn_edit.text = tr("CATALOG_BTN_EDIT")
		AccessibilityManager.hook_control_accessibility(btn_edit, tr("CATALOG_BTN_EDIT"), tr("CATALOG_BTN_EDIT_ACC_DESC"))
		btn_edit.pressed.connect(func():
			edit_song_requested.emit(song)
		)
		AccessibilityManager.hook_control_accessibility(btn, acc_name, acc_desc)
		row.add_child(btn)
		row.add_child(btn_edit)
	elif song.status == Enums.SongStatus.PRODUCED:
		AccessibilityManager.hook_control_accessibility(btn, acc_name, acc_desc)
		row.add_child(btn)
		var btn_release := Button.new()
		btn_release.name = "BtnRelease"
		btn_release.text = tr("CATALOG_BTN_RELEASE")
		AccessibilityManager.hook_control_accessibility(btn_release, tr("CATALOG_BTN_RELEASE"), "Pubblica il brano sul mercato musicale.")
		btn_release.pressed.connect(func():
			if GameManager and GameManager.music_system:
				GameManager.music_system.release_single(song.id)
				refresh_catalog()
		)
		row.add_child(btn_release)
	else:
		AccessibilityManager.hook_control_accessibility(btn, acc_name, acc_desc)
		row.add_child(btn)
		
	return row

func _create_album_row(index: int, album: AlbumData) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 15)
	
	var btn := Button.new()
	btn.name = "BtnSelect"
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	
	var type_str := album.get_type_name()
	var row_text := "%d. [%s] '%s' — Recensioni: %.1f ⭐ | Qualità: %.1f | Vendite: %.0f copie | %d tracce" % [
		index, type_str, album.title, album.review_stars, album.overall_quality, album.total_sales, album.song_ids.size()
	]
	btn.text = row_text
	
	var acc_name := "%s %d: %s. Valutazione critica: %.1f stelle su 5. Qualità: %.1f. Vendite totali: %.0f copie. Tracce incluse: %d." % [
		type_str, index, album.title, album.review_stars, album.overall_quality, album.total_sales, album.song_ids.size()
	]
	var acc_desc := "Premi Invio per ascoltare i dettagli completi e l'elenco delle tracce."
	AccessibilityManager.hook_control_accessibility(btn, acc_name, acc_desc)
	
	btn.pressed.connect(func():
		var track_titles: Array[String] = []
		if GameManager and GameManager.player_data:
			for s_id in album.song_ids:
				var title_found: String = "Traccia sconosciuta"
				for s in GameManager.player_data.songs:
					if s.id == s_id:
						title_found = s.title
						break
				track_titles.append(title_found)
		var tracklist_str: String = ", ".join(track_titles)
		var details_speech := "%s '%s': Pubblicato il Giorno %d. Qualità: %.1f su 100. Critica: %.1f stelle. Copie vendute: %.0f. Tracce (%d): %s." % [
			type_str,
			album.title,
			album.release_day,
			album.overall_quality,
			album.review_stars,
			album.total_sales,
			album.song_ids.size(),
			tracklist_str
		]
		AccessibilityManager.announce(details_speech, true)
	)
	
	row.add_child(btn)
	return row

func _on_new_song_pressed() -> void:
	new_song_requested.emit()

func _on_new_album_pressed() -> void:
	new_album_requested.emit()

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
		elif key_event.keycode == KEY_P:
			_on_new_album_pressed()
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_A:
			show_albums_section()
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_S:
			show_songs_section()
			get_viewport().set_input_as_handled()
