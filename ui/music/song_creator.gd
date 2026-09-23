# res://ui/music/song_creator.gd
extends Control

## Controller dello Studio Musicale e Creazione Brano di World-tour
## Scheda Unica Integrata: tutti i parametri artistici e di produzione in una sola interfaccia.
## Conforme alla Simmetria Universale (Luca con NVDA/tastiera e Holy Diver a monitor).

signal creation_finished(song: SongData)
signal creation_canceled()

const LyricThemeData = preload("res://data/models/lyric_theme_data.gd")

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var label_step_title: Label = $PanelMain/VBox/Header/LabelStepTitle
@onready var label_step_info: Label = $PanelMain/VBox/Header/LabelStepInfo

# Campi di input artistici e di produzione
@onready var edit_title: LineEdit = $PanelMain/VBox/VBoxForm/HBoxTitle/EditTitle
@onready var opt_genre: OptionButton = $PanelMain/VBox/VBoxForm/HBoxGenreTheme/OptGenre
@onready var opt_theme: OptionButton = $PanelMain/VBox/VBoxForm/HBoxGenreTheme/OptTheme
@onready var opt_studio: OptionButton = $PanelMain/VBox/VBoxForm/HBoxStudio/OptStudio
@onready var chk_burst: CheckBox = $PanelMain/VBox/VBoxForm/HBoxStudio/ChkBurst

# Stato e bottoni di avanzamento
@onready var label_stage_status: Label = $PanelMain/VBox/VBoxStatus/LabelStageStatus
@onready var btn_produce_all: Button = $PanelMain/VBox/HBoxBottom/BtnProduceAll
@onready var btn_action: Button = $PanelMain/VBox/HBoxBottom/BtnAction
@onready var btn_save_draft: Button = $PanelMain/VBox/HBoxBottom/BtnSaveDraft
@onready var btn_edit_info: Button = $PanelMain/VBox/HBoxBottom/BtnEditInfo
@onready var btn_cancel: Button = $PanelMain/VBox/HBoxBottom/BtnCancel

# Sezione risultato finale
@onready var panel_result: PanelContainer = $PanelMain/VBox/PanelResult
@onready var label_result: Label = $PanelMain/VBox/PanelResult/VBoxResult/LabelResult
@onready var btn_release_now: Button = $PanelMain/VBox/PanelResult/VBoxResult/HBoxResult/BtnReleaseNow
@onready var btn_done: Button = $PanelMain/VBox/PanelResult/VBoxResult/HBoxResult/BtnDone

var current_song: SongData = null
var current_step: int = 1
var resume_step: int = 1

func _ready() -> void:
	_setup_options()
	
	btn_produce_all.pressed.connect(_on_btn_produce_all_pressed)
	btn_action.pressed.connect(_on_btn_action_pressed)
	btn_save_draft.pressed.connect(_on_btn_save_draft_pressed)
	btn_edit_info.pressed.connect(_on_btn_edit_info_pressed)
	btn_cancel.pressed.connect(_on_btn_cancel_pressed)
	
	btn_release_now.pressed.connect(_on_btn_release_now_pressed)
	btn_done.pressed.connect(_on_btn_done_pressed)
	
	opt_genre.item_selected.connect(_on_genre_or_theme_changed)
	opt_theme.item_selected.connect(_on_genre_or_theme_changed)
	
	EventBus.language_changed.connect(_on_language_changed)
	
	start_new_song()

func _setup_options() -> void:
	# Generi musicali
	opt_genre.clear()
	opt_genre.add_item(tr("GENRE_ROCK"), Enums.MusicalGenre.ROCK)
	opt_genre.add_item(tr("GENRE_POP"), Enums.MusicalGenre.POP)
	opt_genre.add_item(tr("GENRE_METAL"), Enums.MusicalGenre.METAL)
	opt_genre.add_item(tr("GENRE_HIPHOP"), Enums.MusicalGenre.HIPHOP)
	opt_genre.add_item(tr("GENRE_ELECTRONIC"), Enums.MusicalGenre.ELECTRONIC)
	opt_genre.add_item(tr("GENRE_INDIE"), Enums.MusicalGenre.INDIE)
	
	# Temi lirici da LyricThemeData (10 temi)
	opt_theme.clear()
	var all_themes: Array = LyricThemeData.get_all_themes()
	for i in range(all_themes.size()):
		var t = all_themes[i]
		opt_theme.add_item(t.get_localized_name(), i)
		opt_theme.set_item_metadata(i, t.id)
	
	# Scelta dello Studio con rilevamento dinamico dello sconto del Martedì
	opt_studio.clear()
	opt_studio.add_item(tr("CREATOR_STUDIO_HOME"), 0)
	opt_studio.set_item_metadata(0, false)
	
	var is_tuesday: bool = false
	if GameManager and GameManager.calendar_data:
		is_tuesday = (GameManager.calendar_data.get_weekday() == Enums.Weekday.TUESDAY)
	var studio_pro_text: String = "Studio Professionale (40 € - Sconto Martedì 20% applicato)" if is_tuesday else "Studio Professionale (50 €)"
	opt_studio.add_item(studio_pro_text, 1)
	opt_studio.set_item_metadata(1, true)
	
	# Hook semantici per l'accessibilità da tastiera e NVDA
	AccessibilityManager.hook_control_accessibility(edit_title, "Titolo Brano", "Inserisci il titolo della canzone da creare.")
	AccessibilityManager.hook_control_accessibility(opt_genre, "Genere Musicale", "Seleziona il genere musicale tra Rock, Pop, Metal, HipHop, Elettronica, Indie.")
	AccessibilityManager.hook_control_accessibility(opt_theme, "Tema Lirico", "Seleziona il tema ispiratore per il testo. Verrà vocalizzata l'affinità con il genere.")
	var acc_studio_desc: String = "Studio Professionale a 40 euro con sconto martedì 20%" if is_tuesday else "Scegli tra Home Studio gratuito o Studio Professionale a 50 euro."
	AccessibilityManager.hook_control_accessibility(opt_studio, "Studio di Registrazione", acc_studio_desc)
	AccessibilityManager.hook_control_accessibility(chk_burst, "Ispirazione Improvvisa", "Spunta per tentare un guizzo creativo con bonus qualità.")
	AccessibilityManager.hook_control_accessibility(btn_produce_all, "Produci Brano Completo", "Registra e finalizza l'intero brano in un'unica sessione se hai energia e fondi sufficienti.")
	AccessibilityManager.hook_control_accessibility(btn_action, "Avanza Prossima Fase", "Avanza di un singolo stadio nella produzione del brano.")
	AccessibilityManager.hook_control_accessibility(btn_save_draft, "Salva Bozza", "Salva lo stato corrente della bozza e ritorna al catalogo.")
	AccessibilityManager.hook_control_accessibility(btn_edit_info, "Modifica Titolo", "Sposta il focus sul campo titolo per modificarlo velocemente.")
	AccessibilityManager.hook_control_accessibility(btn_cancel, "Annulla", "Chiude lo studio musicale senza salvare ulteriori modifiche.")
	
	_on_genre_or_theme_changed(0)

func _on_genre_or_theme_changed(_index: int = 0) -> void:
	if not opt_genre or not opt_theme or opt_genre.selected < 0 or opt_theme.selected < 0:
		return
	var s_genre: int = opt_genre.get_selected_id()
	var s_theme: String = str(opt_theme.get_item_metadata(opt_theme.selected))
	var affinity := LyricThemeData.get_affinity_for_genre(s_theme, s_genre)
	var theme_obj := LyricThemeData.get_theme_by_id(s_theme)
	var aff_desc := ""
	if affinity > 0:
		aff_desc = "Alta sinergia artistica (+%.1f qualità)." % affinity
	elif affinity < 0:
		aff_desc = "Sinergia contrastante (%.1f qualità)." % affinity
	else:
		aff_desc = "Sinergia neutra."
	var acc_theme_desc := "%s. %s %s" % [theme_obj.get_localized_name(), theme_obj.get_localized_description(), aff_desc]
	AccessibilityManager.hook_control_accessibility(opt_theme, "Tema Lirico", acc_theme_desc)

func start_new_song() -> void:
	current_song = null
	resume_step = 1
	current_step = 1
	panel_result.visible = false
	label_title.text = tr("CREATOR_TITLE")
	edit_title.text = "Nuova Traccia %d" % [randi() % 900 + 100]
	chk_burst.button_pressed = false
	opt_studio.select(0)
	_update_stage_display()
	edit_title.grab_focus()

func edit_existing_song(song: SongData) -> void:
	current_song = song
	label_title.text = "%s — '%s'" % [tr("CREATOR_TITLE_EDIT"), song.title]
	panel_result.visible = (song.status == Enums.SongStatus.PRODUCED or song.status == Enums.SongStatus.RELEASED)
	
	edit_title.text = song.title
	for i in range(opt_genre.item_count):
		if opt_genre.get_item_id(i) == song.genre:
			opt_genre.selected = i
			break
	for i in range(opt_theme.item_count):
		if str(opt_theme.get_item_metadata(i)) == song.theme:
			opt_theme.selected = i
			break
			
	var target_step: int = 1
	match song.stage:
		Enums.SongStage.CONCEPT:
			target_step = 1
		Enums.SongStage.COMPOSITION:
			target_step = 3
		Enums.SongStage.SONGWRITING:
			target_step = 4
		Enums.SongStage.RECORDING:
			target_step = 5
		Enums.SongStage.COMPLETED:
			target_step = 6
		_:
			target_step = 1
			
	resume_step = target_step
	current_step = target_step
	btn_edit_info.visible = true
	_update_stage_display()
	btn_action.grab_focus()

func _update_stage_display() -> void:
	if current_song == null:
		label_stage_status.text = "Fase attuale: Ideazione | Produzione completa: 65 Energia (oppure a tappe)"
		btn_action.text = "1. Componi Melodia (-15 Energia)"
		btn_produce_all.text = "Produci Tutto (65 Energia)"
		btn_produce_all.disabled = false
		btn_action.disabled = false
		panel_result.visible = false
		return
		
	match current_song.stage:
		Enums.SongStage.CONCEPT:
			label_stage_status.text = "Fase attuale: Ideazione | Prossimo passo: Melodia (-15 Energia)"
			btn_action.text = "Componi Melodia (-15 Energia)"
			btn_produce_all.disabled = false
			btn_action.disabled = false
			panel_result.visible = false
		Enums.SongStage.COMPOSITION:
			label_stage_status.text = "Fase attuale: Melodia Composta | Prossimo passo: Testo (-10 Energia)"
			btn_action.text = "Scrivi Testo (-10 Energia)"
			btn_produce_all.disabled = false
			btn_action.disabled = false
			panel_result.visible = false
		Enums.SongStage.SONGWRITING:
			label_stage_status.text = "Fase attuale: Testo Scritto | Prossimo passo: Registrazione (-25 Energia)"
			btn_action.text = "Registra Tracce (-25 Energia)"
			btn_produce_all.disabled = false
			btn_action.disabled = false
			panel_result.visible = false
		Enums.SongStage.RECORDING:
			label_stage_status.text = "Fase attuale: Tracce Registrate | Prossimo passo: Missaggio Finale (-15 Energia)"
			btn_action.text = "Finalizza Master (-15 Energia)"
			btn_produce_all.disabled = false
			btn_action.disabled = false
			panel_result.visible = false
		Enums.SongStage.COMPLETED:
			label_stage_status.text = "Fase attuale: Master Ultimato e Prodotto!"
			btn_produce_all.disabled = true
			btn_action.disabled = true
			panel_result.visible = true
			var trait_str: String = current_song.get_trait_name()
			label_result.text = "Brano Ultimato con Successo! Punteggio: %.1f / 100 | Tratto: %s" % [
				current_song.quality_score,
				trait_str
			]
			btn_release_now.grab_focus()

func _sync_form_to_song() -> void:
	var s_title := edit_title.text.strip_edges()
	if s_title.is_empty():
		s_title = "Untitled Track"
	var s_genre: int = opt_genre.get_selected_id()
	var s_theme: String = str(opt_theme.get_item_metadata(opt_theme.selected))
	
	if current_song == null:
		if GameManager and GameManager.music_system:
			current_song = GameManager.music_system.create_draft(s_title, s_genre, s_theme)
	else:
		current_song.title = s_title
		current_song.genre = s_genre
		current_song.theme = s_theme
		EventBus.song_updated.emit(current_song.to_dict())

func _on_btn_produce_all_pressed() -> void:
	if not GameManager or not GameManager.music_system:
		return
		
	_sync_form_to_song()
	var ms: MusicSystem = GameManager.music_system
	var use_pro: bool = bool(opt_studio.get_item_metadata(opt_studio.selected))
	var burst: bool = chk_burst.button_pressed
	
	# Verifica rapida risorse complessive
	var player: PlayerData = GameManager.player_data
	if use_pro and player.money < 50.0 and current_song.stage < Enums.SongStage.RECORDING:
		AccessibilityManager.announce("Fondi insufficienti per lo Studio Professionale (richiesti 50 euro).", true)
		return
		
	# Esecuzione stadi fino al completamento
	if current_song.stage == Enums.SongStage.CONCEPT:
		var r1 := ms.work_on_composition(current_song, burst)
		if not r1.get("success", false):
			AccessibilityManager.announce("Energia insufficiente per comporre la melodia.", true)
			_update_stage_display()
			return
			
	if current_song.stage == Enums.SongStage.COMPOSITION:
		var r2 := ms.work_on_lyrics(current_song)
		if not r2.get("success", false):
			AccessibilityManager.announce("Energia insufficiente per scrivere il testo.", true)
			_update_stage_display()
			return
			
	if current_song.stage == Enums.SongStage.SONGWRITING:
		var r3 := ms.record_tracks(current_song, use_pro)
		if not r3.get("success", false):
			AccessibilityManager.announce("Energia o fondi insufficienti per incidere le tracce.", true)
			_update_stage_display()
			return
			
	if current_song.stage == Enums.SongStage.RECORDING:
		var r4 := ms.mix_and_master(current_song)
		if not r4.get("success", false):
			AccessibilityManager.announce("Energia insufficiente per il missaggio finale.", true)
			_update_stage_display()
			return
			
	current_step = 6
	resume_step = 6
	_update_stage_display()
	var speech: String = "Produzione completata! '%s' è pronta. Punteggio qualità: %.1f. Tratto: %s." % [
		current_song.title,
		current_song.quality_score,
		current_song.get_trait_name()
	]
	AccessibilityManager.announce(speech, true)

func _on_btn_action_pressed() -> void:
	if not GameManager or not GameManager.music_system:
		return
		
	_sync_form_to_song()
	var ms: MusicSystem = GameManager.music_system
	var use_pro: bool = bool(opt_studio.get_item_metadata(opt_studio.selected))
	var burst: bool = chk_burst.button_pressed
	
	match current_song.stage:
		Enums.SongStage.CONCEPT:
			var res := ms.work_on_composition(current_song, burst)
			if res.get("success", false):
				current_step = 3
				resume_step = 3
				_update_stage_display()
				AccessibilityManager.announce("Melodia composta con successo. Ora scrivi il testo.", true)
			else:
				AccessibilityManager.announce("Energia insufficiente per comporre.", true)
		Enums.SongStage.COMPOSITION:
			var res := ms.work_on_lyrics(current_song)
			if res.get("success", false):
				current_step = 4
				resume_step = 4
				_update_stage_display()
				AccessibilityManager.announce("Testo completato con successo. Ora incidi le tracce.", true)
			else:
				AccessibilityManager.announce("Energia insufficiente per il testo.", true)
		Enums.SongStage.SONGWRITING:
			var res := ms.record_tracks(current_song, use_pro)
			if res.get("success", false):
				current_step = 5
				resume_step = 5
				_update_stage_display()
				AccessibilityManager.announce("Tracce incise con successo. Ora finalizza il master.", true)
			else:
				var reason: String = res.get("reason", "")
				if reason == "money_insufficient":
					AccessibilityManager.announce("Fondi insufficienti per lo Studio Professionale (50 euro richiesti).", true)
				else:
					AccessibilityManager.announce("Energia insufficiente per registrare.", true)
		Enums.SongStage.RECORDING:
			var res := ms.mix_and_master(current_song)
			if res.get("success", false):
				current_step = 6
				resume_step = 6
				_update_stage_display()
				var speech: String = "Master ultimato! Qualità: %.1f, Tratto: %s." % [
					current_song.quality_score,
					current_song.get_trait_name()
				]
				AccessibilityManager.announce(speech, true)
			else:
				AccessibilityManager.announce("Energia insufficiente per il missaggio.", true)

func _on_btn_save_draft_pressed() -> void:
	_sync_form_to_song()
	if current_song:
		AccessibilityManager.announce("Bozza '%s' salvata nel catalogo." % current_song.title, true)
	creation_finished.emit(current_song)

func _on_btn_edit_info_pressed() -> void:
	edit_title.grab_focus()
	AccessibilityManager.announce("Focus sul titolo del brano.", true)

func _on_btn_release_now_pressed() -> void:
	if current_song and GameManager and GameManager.music_system:
		GameManager.music_system.release_single(current_song.id)
	creation_finished.emit(current_song)

func _on_btn_done_pressed() -> void:
	creation_finished.emit(current_song)

func _on_btn_cancel_pressed() -> void:
	creation_canceled.emit()

func _on_language_changed(_new_lang: String) -> void:
	_setup_options()
	_update_stage_display()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var key_event := event as InputEventKey
		if key_event.keycode == KEY_ESCAPE:
			_on_btn_cancel_pressed()
			get_viewport().set_input_as_handled()
