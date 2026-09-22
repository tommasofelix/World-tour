# res://ui/album/album_creator.gd
extends Control

## Controller della Schermata di Produzione Discografica (EP & LP)
## Permette a Luca e ad Alex di assemblare raccolte musicali, definire il concept,
## lo stile dell'artwork, la traccia trainante (lead single) e pubblicare l'opera sul mercato.

signal closed()
signal album_published(album_data: Dictionary)

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var edit_title: LineEdit = $PanelMain/VBox/GridForm/EditTitle
@onready var opt_album_type: OptionButton = $PanelMain/VBox/GridForm/OptAlbumType
@onready var opt_concept: OptionButton = $PanelMain/VBox/GridForm/OptConcept
@onready var opt_artwork: OptionButton = $PanelMain/VBox/GridForm/OptArtwork
@onready var opt_lead_single: OptionButton = $PanelMain/VBox/GridForm/OptLeadSingle

@onready var scroll_tracks: ScrollContainer = $PanelMain/VBox/ScrollTracks
@onready var vbox_tracks: VBoxContainer = $PanelMain/VBox/ScrollTracks/VBoxTracks

@onready var label_summary: Label = $PanelMain/VBox/LabelSummary
@onready var btn_publish: Button = $PanelMain/VBox/HBoxBottom/BtnPublish
@onready var btn_close: Button = $PanelMain/VBox/HBoxBottom/BtnClose

var selected_song_ids: Array[String] = []
var eligible_songs: Array[SongData] = []

func _ready() -> void:
	btn_close.pressed.connect(_on_close_pressed)
	btn_publish.pressed.connect(_on_publish_pressed)
	
	opt_album_type.item_selected.connect(func(_idx): _on_type_changed())
	opt_concept.item_selected.connect(func(_idx): _update_summary())
	opt_artwork.item_selected.connect(func(_idx): _update_summary())
	opt_lead_single.item_selected.connect(func(_idx): _update_summary())
	
	_populate_dropdowns()
	_refresh_ui_text()

func open() -> void:
	visible = true
	selected_song_ids.clear()
	edit_title.text = "Nuovo Progetto %d" % (randi() % 900 + 100)
	_load_eligible_songs()
	_update_tracks_list()
	_update_lead_single_dropdown()
	_update_summary()
	
	edit_title.grab_focus()
	
	var speech := "Schermata Produzione Discografica aperta. Crea un EP (3-5 tracce) o LP (6-10 tracce). Inserisci il titolo e seleziona le canzoni."
	AccessibilityManager.announce(speech, true)

func close() -> void:
	visible = false
	closed.emit()

func _refresh_ui_text() -> void:
	label_title.text = "PRODUZIONE DISCOGRAFICA — STUDIO DI MASTERING"
	btn_publish.text = "Pubblica Album / EP (Invio)"
	btn_close.text = "Annulla (Esc)"
	
	AccessibilityManager.hook_control_accessibility(edit_title, "Titolo dell'album", "Inserisci il nome del disco o della raccolta.")
	AccessibilityManager.hook_control_accessibility(opt_album_type, "Formato disco", "Scegli tra EP (3-5 tracce) o LP (6-10 tracce).")
	AccessibilityManager.hook_control_accessibility(opt_concept, "Concept artistico", "Seleziona la direzione tematica dell'opera.")
	AccessibilityManager.hook_control_accessibility(opt_artwork, "Stile della copertina", "Definisci l'estetica visiva del packaging.")
	AccessibilityManager.hook_control_accessibility(opt_lead_single, "Traccia trainante (Lead Single)", "Seleziona il brano di punta che trainerà la promozione.")
	AccessibilityManager.hook_control_accessibility(btn_publish, "Pubblica Album", "Avvia la stampa e la distribuzione sul mercato.")
	AccessibilityManager.hook_control_accessibility(btn_close, "Chiudi", "Ritorna alla schermata precedente senza pubblicare.")

func _populate_dropdowns() -> void:
	opt_album_type.clear()
	opt_album_type.add_item("EP (Extended Play — da 3 a 5 tracce)", Enums.AlbumType.EP)
	opt_album_type.add_item("LP (Long Play Album — da 6 a 10 tracce)", Enums.AlbumType.LP)
	
	opt_concept.clear()
	opt_concept.add_item(tr("CONCEPT_COMMERCIAL_HIT"), Enums.AlbumConcept.COMMERCIAL_HIT)
	opt_concept.add_item(tr("CONCEPT_CONCEPTUAL"), Enums.AlbumConcept.CONCEPTUAL)
	opt_concept.add_item(tr("CONCEPT_RAW_UNDERGROUND"), Enums.AlbumConcept.RAW_UNDERGROUND)
	
	opt_artwork.clear()
	opt_artwork.add_item(tr("ARTWORK_MINIMALIST"), Enums.ArtworkStyle.MINIMALIST)
	opt_artwork.add_item(tr("ARTWORK_RETRO_PSYCHEDELIC"), Enums.ArtworkStyle.RETRO_PSYCHEDELIC)
	opt_artwork.add_item(tr("ARTWORK_DARK_METAL"), Enums.ArtworkStyle.DARK_METAL)
	opt_artwork.add_item(tr("ARTWORK_STREET_GRAFFITI"), Enums.ArtworkStyle.STREET_GRAFFITI)

func _load_eligible_songs() -> void:
	eligible_songs.clear()
	if GameManager and GameManager.album_system:
		eligible_songs = GameManager.album_system.get_eligible_songs()

func _update_tracks_list() -> void:
	if not vbox_tracks:
		return
	for c in vbox_tracks.get_children():
		c.queue_free()
		
	if eligible_songs.is_empty():
		var lbl := Label.new()
		lbl.text = "Nessun brano pronto o pubblicato disponibile. Completa la produzione di canzoni nel Song Creator prima di compilare un album."
		vbox_tracks.add_child(lbl)
		return
		
	for i in range(eligible_songs.size()):
		var song: SongData = eligible_songs[i]
		var chk := CheckBox.new()
		chk.name = "ChkSong_%s" % song.id
		var is_sel: bool = selected_song_ids.has(song.id)
		chk.button_pressed = is_sel
		chk.text = "%d. '%s' [%s] — Qualità: %.1f | Tratto: %s" % [
			i + 1, song.title, song.get_genre_name(), song.quality_score, song.get_trait_name()
		]
		var acc_name := "Brano %d: %s. Qualità %.1f su 100." % [i + 1, song.title, song.quality_score]
		var acc_desc := "Barra spaziatrice per includere o escludere questo brano dall'album."
		AccessibilityManager.hook_control_accessibility(chk, acc_name, acc_desc)
		
		chk.toggled.connect(func(pressed: bool):
			_on_song_toggled(song.id, pressed)
		)
		vbox_tracks.add_child(chk)

func _on_song_toggled(song_id: String, pressed: bool) -> void:
	if pressed:
		if not selected_song_ids.has(song_id):
			selected_song_ids.append(song_id)
	else:
		selected_song_ids.erase(song_id)
		
	_update_lead_single_dropdown()
	_update_summary()

func _update_lead_single_dropdown() -> void:
	opt_lead_single.clear()
	if selected_song_ids.is_empty():
		opt_lead_single.add_item("(Nessuna traccia selezionata)", -1)
		return
		
	for i in range(selected_song_ids.size()):
		var s_id: String = selected_song_ids[i]
		var title: String = s_id
		for s in eligible_songs:
			if s.id == s_id:
				title = s.title
				break
		opt_lead_single.add_item("%d. %s" % [i + 1, title], i)

func _on_type_changed() -> void:
	_update_summary()

func _update_summary() -> void:
	if not GameManager or not GameManager.album_system:
		return
		
	var a_type: int = opt_album_type.get_selected_id()
	var concept: int = opt_concept.get_selected_id()
	var artwork: int = opt_artwork.get_selected_id()
	
	var lead_id: String = ""
	var lead_idx: int = opt_lead_single.selected
	if lead_idx >= 0 and lead_idx < selected_song_ids.size():
		lead_id = selected_song_ids[lead_idx]
		
	var val: Dictionary = GameManager.album_system.validate_album_composition(selected_song_ids, a_type)
	var min_t: int = Constants.ALBUM_EP_MIN_TRACKS if a_type == Enums.AlbumType.EP else Constants.ALBUM_LP_MIN_TRACKS
	var max_t: int = Constants.ALBUM_EP_MAX_TRACKS if a_type == Enums.AlbumType.EP else Constants.ALBUM_LP_MAX_TRACKS
	
	var metrics: Dictionary = GameManager.album_system.calculate_album_metrics(
		selected_song_ids, lead_id, concept, artwork, a_type
	)
	
	var status_text: String = ""
	if not val.valid:
		btn_publish.disabled = true
		if val.reason == "too_few_tracks":
			status_text = "⚠️ Tracce selezionate: %d / %d minime richieste. Aggiungi altri brani." % [selected_song_ids.size(), min_t]
		elif val.reason == "too_many_tracks":
			status_text = "⚠️ Tracce selezionate: %d / %d massime consentite per questo formato." % [selected_song_ids.size(), max_t]
		else:
			status_text = "⚠️ Selezione tracce non valida (%s)." % val.reason
	else:
		btn_publish.disabled = false
		status_text = "✅ Formato valido (%d tracce incluse)." % selected_song_ids.size()
		
	var player_money: float = GameManager.player_data.money if GameManager and GameManager.player_data else 0.0
	var can_afford: bool = player_money >= metrics.cost
	if not can_afford:
		btn_publish.disabled = true
		status_text += " [FONDI INSUFFICIENTI: Servono %.2f €]" % metrics.cost
		
	label_summary.text = "%s\nQualità Stimata: %.1f/100 | Critica Prevista: %.1f ⭐ | Costo Produzione: %.2f € (Saldo: %.2f €)\nVendite Day 1 Stimate: ~%.0f copie | Ricavo Netto Previsto: ~%.2f €" % [
		status_text,
		metrics.overall_quality,
		metrics.review_stars,
		metrics.cost,
		player_money,
		metrics.initial_sales,
		metrics.gross_revenue * (GameManager.player_data.get_leader_revenue_share() if GameManager and GameManager.player_data else 1.0)
	]

func _on_publish_pressed() -> void:
	if not GameManager or not GameManager.album_system:
		return
		
	var a_type: int = opt_album_type.get_selected_id()
	var concept: int = opt_concept.get_selected_id()
	var artwork: int = opt_artwork.get_selected_id()
	var title: String = edit_title.text.strip_edges()
	if title.is_empty():
		title = "Senza Titolo"
		
	var lead_id: String = ""
	var lead_idx: int = opt_lead_single.selected
	if lead_idx >= 0 and lead_idx < selected_song_ids.size():
		lead_id = selected_song_ids[lead_idx]
		
	var res: Dictionary = GameManager.album_system.create_and_release_album(
		title, a_type, selected_song_ids, lead_id, concept, artwork
	)
	
	if res.success:
		visible = false
		album_published.emit(res)
	else:
		var speech := "Impossibile pubblicare: %s." % res.reason
		AccessibilityManager.announce(speech, true)

func _on_close_pressed() -> void:
	close()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var key_event := event as InputEventKey
		if key_event.keycode == KEY_ESCAPE:
			_on_close_pressed()
			get_viewport().set_input_as_handled()
