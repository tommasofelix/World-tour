# res://ui/music/song_creator.gd
extends Control

## Controller dello Studio Musicale e Creazione Guidata Brano di World-tour
## Conforme alla Simmetria Universale (Luca con NVDA/tastiera e Holy Diver a monitor).

signal creation_finished(song: SongData)
signal creation_canceled()

@onready var label_title: Label = $PanelMain/VBox/LabelTitle
@onready var label_step_title: Label = $PanelMain/VBox/LabelStepTitle
@onready var label_step_info: Label = $PanelMain/VBox/LabelStepInfo

# Contenitori dei singoli step
@onready var step1_container: VBoxContainer = $PanelMain/VBox/Step1Container
@onready var edit_title: LineEdit = $PanelMain/VBox/Step1Container/HBoxTitle/EditTitle
@onready var opt_genre: OptionButton = $PanelMain/VBox/Step1Container/HBoxGenre/OptGenre
@onready var opt_theme: OptionButton = $PanelMain/VBox/Step1Container/HBoxTheme/OptTheme

@onready var step2_container: VBoxContainer = $PanelMain/VBox/Step2Container
@onready var chk_burst: CheckBox = $PanelMain/VBox/Step2Container/ChkBurst

@onready var step3_container: VBoxContainer = $PanelMain/VBox/Step3Container

@onready var step4_container: VBoxContainer = $PanelMain/VBox/Step4Container
@onready var opt_studio: OptionButton = $PanelMain/VBox/Step4Container/HBoxStudio/OptStudio

@onready var step5_container: VBoxContainer = $PanelMain/VBox/Step5Container

@onready var step6_container: VBoxContainer = $PanelMain/VBox/Step6Container
@onready var label_result: Label = $PanelMain/VBox/Step6Container/LabelResult
@onready var btn_release_now: Button = $PanelMain/VBox/Step6Container/HBoxResult/BtnReleaseNow
@onready var btn_done: Button = $PanelMain/VBox/Step6Container/HBoxResult/BtnDone

# Bottoni di navigazione in basso
@onready var btn_action: Button = $PanelMain/VBox/HBoxBottom/BtnAction
@onready var btn_save_draft: Button = $PanelMain/VBox/HBoxBottom/BtnSaveDraft
@onready var btn_cancel: Button = $PanelMain/VBox/HBoxBottom/BtnCancel

var current_song: SongData
var current_step: int = 1

func _ready() -> void:
	_setup_options()
	
	btn_action.pressed.connect(_on_btn_action_pressed)
	btn_save_draft.pressed.connect(_on_btn_save_draft_pressed)
	btn_cancel.pressed.connect(_on_btn_cancel_pressed)
	
	btn_release_now.pressed.connect(_on_btn_release_now_pressed)
	btn_done.pressed.connect(_on_btn_done_pressed)
	
	EventBus.language_changed.connect(_on_language_changed)
	
	start_new_song()

func _setup_options() -> void:
	# Generi
	opt_genre.clear()
	opt_genre.add_item(tr("GENRE_ROCK"), Enums.MusicalGenre.ROCK)
	opt_genre.add_item(tr("GENRE_POP"), Enums.MusicalGenre.POP)
	opt_genre.add_item(tr("GENRE_METAL"), Enums.MusicalGenre.METAL)
	opt_genre.add_item(tr("GENRE_HIPHOP"), Enums.MusicalGenre.HIPHOP)
	opt_genre.add_item(tr("GENRE_ELECTRONIC"), Enums.MusicalGenre.ELECTRONIC)
	opt_genre.add_item(tr("GENRE_INDIE"), Enums.MusicalGenre.INDIE)
	
	# Temi
	opt_theme.clear()
	opt_theme.add_item(tr("THEME_LOVE"), 0)
	opt_theme.set_item_metadata(0, "love")
	opt_theme.add_item(tr("THEME_REBELLION"), 1)
	opt_theme.set_item_metadata(1, "rebellion")
	opt_theme.add_item(tr("THEME_MELANCHOLY"), 2)
	opt_theme.set_item_metadata(2, "melancholy")
	opt_theme.add_item(tr("THEME_SUCCESS"), 3)
	opt_theme.set_item_metadata(3, "success")
	opt_theme.add_item(tr("THEME_NIGHT"), 4)
	opt_theme.set_item_metadata(4, "night")
	
	# Studio
	opt_studio.clear()
	opt_studio.add_item(tr("CREATOR_STUDIO_HOME"), 0)
	opt_studio.set_item_metadata(0, false)
	opt_studio.add_item(tr("CREATOR_STUDIO_PRO"), 1)
	opt_studio.set_item_metadata(1, true)

func start_new_song() -> void:
	current_song = null
	current_step = 1
	edit_title.text = "Nuova Traccia %d" % [randi() % 900 + 100]
	_show_step(1)
	edit_title.grab_focus()

func _show_step(step: int) -> void:
	current_step = step
	step1_container.visible = (step == 1)
	step2_container.visible = (step == 2)
	step3_container.visible = (step == 3)
	step4_container.visible = (step == 4)
	step5_container.visible = (step == 5)
	step6_container.visible = (step == 6)
	
	btn_action.visible = (step < 6)
	btn_save_draft.visible = (step > 1 and step < 6)
	
	match step:
		1:
			label_step_title.text = tr("CREATOR_STEP1")
			label_step_info.text = "Scegli il titolo, il genere musicale e il tema ispiratore per la tua nuova opera."
			btn_action.text = "Inizia Composizione"
			edit_title.grab_focus()
		2:
			label_step_title.text = tr("CREATOR_STEP2")
			label_step_info.text = "Crea riff e progressioni armoniche. Richiede 15 energia."
			btn_action.text = "Componi Melodia"
			btn_action.grab_focus()
		3:
			label_step_title.text = tr("CREATOR_STEP3")
			label_step_info.text = "Scrivi strofe e ritornello. Richiede 10 energia."
			btn_action.text = "Scrivi Testo"
			btn_action.grab_focus()
		4:
			label_step_title.text = tr("CREATOR_STEP4")
			label_step_info.text = "Registra le tracce strumentali e vocali. Richiede 25 energia."
			btn_action.text = "Incidi Tracce"
			opt_studio.grab_focus()
		5:
			label_step_title.text = tr("CREATOR_STEP5")
			label_step_info.text = "Bilancia equalizzazione, volumi e mastering. Richiede 15 energia."
			btn_action.text = "Finalizza Master"
			btn_action.grab_focus()
		6:
			label_step_title.text = "Master Ultimato con Successo!"
			var trait_str: String = current_song.get_trait_name() if current_song else "Standard"
			var qual: float = current_song.quality_score if current_song else 0.0
			label_step_info.text = "Punteggio Qualità: %.1f / 100 | Tratto emergente: %s" % [qual, trait_str]
			label_result.text = "Il brano '%s' è pronto per essere rilasciato sul mercato discografico!" % [current_song.title if current_song else ""]
			btn_release_now.grab_focus()
			
	AccessibilityManager.announce("%s. %s" % [label_step_title.text, label_step_info.text], true)

func _on_btn_action_pressed() -> void:
	if not GameManager or not GameManager.music_system:
		return
		
	var ms: MusicSystem = GameManager.music_system
	
	match current_step:
		1:
			var s_title := edit_title.text
			var s_genre := opt_genre.get_selected_id()
			var s_theme: String = str(opt_theme.get_item_metadata(opt_theme.selected))
			current_song = ms.create_draft(s_title, s_genre, s_theme)
			_show_step(2)
		2:
			var res := ms.work_on_composition(current_song, chk_burst.button_pressed)
			if res.get("success", false):
				_show_step(3)
			else:
				AccessibilityManager.announce("Energia insufficiente per comporre.", true)
		3:
			var res := ms.work_on_lyrics(current_song)
			if res.get("success", false):
				_show_step(4)
			else:
				AccessibilityManager.announce("Energia insufficiente per scrivere il testo.", true)
		4:
			var use_pro: bool = bool(opt_studio.get_item_metadata(opt_studio.selected))
			var res := ms.record_tracks(current_song, use_pro)
			if res.get("success", false):
				_show_step(5)
			else:
				var reason: String = res.get("reason", "")
				if reason == "money_insufficient":
					AccessibilityManager.announce("Fondi insufficienti per lo Studio Professionale (50 € richiesti).", true)
				else:
					AccessibilityManager.announce("Energia insufficiente per registrare.", true)
		5:
			var res := ms.mix_and_master(current_song)
			if res.get("success", false):
				_show_step(6)
			else:
				AccessibilityManager.announce("Energia insufficiente per il missaggio.", true)

func _on_btn_save_draft_pressed() -> void:
	if current_song:
		AccessibilityManager.announce(tr("MSG_SONG_SAVED_DRAFT") % current_song.title, true)
	creation_finished.emit(current_song)

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
	_show_step(current_step)

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var key_event := event as InputEventKey
		if key_event.keycode == KEY_ESCAPE:
			_on_btn_cancel_pressed()
			get_viewport().set_input_as_handled()
