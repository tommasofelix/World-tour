# res://ui/music/song_creator.gd
extends Control

## Controller dello Studio Musicale e Creazione Brano di World-tour (V5.9.0)
## Riorganizzazione a 3 schede con Simmetria Universale (Luca con NVDA/tastiera e Holy Diver a monitor):
## Scheda 1: Cantieri Aperti (Doppia Barra Musica/Testo, Rifinitura Arancione, Colpo d'Ala)
## Scheda 2: Nuovo Progetto Artigianale (Titolo, Genere, Tema, Strumento Dominante, Archetipo, Ispirazione)
## Scheda 3: Incisione & Master (Studio Home vs Pro, Nastro Analogico vs Digitale HD, Finalizzazione)

signal creation_finished(song: SongData)
signal creation_canceled()

const LyricThemeData = preload("res://data/models/lyric_theme_data.gd")

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var label_step_title: Label = $PanelMain/VBox/Header/LabelStepTitle
@onready var label_step_info: Label = $PanelMain/VBox/Header/LabelStepInfo

# Barra Navigazione Schede
@onready var btn_tab1: Button = $PanelMain/VBox/HBoxTabs/BtnTab1
@onready var btn_tab2: Button = $PanelMain/VBox/HBoxTabs/BtnTab2
@onready var btn_tab3: Button = $PanelMain/VBox/HBoxTabs/BtnTab3

# Scheda 1: Cantieri Aperti
@onready var tab1_drafts: VBoxContainer = $PanelMain/VBox/Tab1Drafts
@onready var vbox_drafts_list: VBoxContainer = $PanelMain/VBox/Tab1Drafts/ScrollDrafts/VBoxDraftsList
@onready var btn_draft_music: Button = $PanelMain/VBox/Tab1Drafts/HBoxDraftActions/BtnDraftMusic
@onready var btn_draft_lyrics: Button = $PanelMain/VBox/Tab1Drafts/HBoxDraftActions/BtnDraftLyrics
@onready var btn_draft_polish: Button = $PanelMain/VBox/Tab1Drafts/HBoxDraftActions/BtnDraftPolish

# Scheda 2: Form Nuovo Progetto Artigianale
@onready var vbox_form: VBoxContainer = $PanelMain/VBox/VBoxForm
@onready var edit_title: LineEdit = $PanelMain/VBox/VBoxForm/HBoxTitle/EditTitle
@onready var opt_genre: OptionButton = $PanelMain/VBox/VBoxForm/HBoxGenreTheme/OptGenre
@onready var opt_theme: OptionButton = $PanelMain/VBox/VBoxForm/HBoxGenreTheme/OptTheme
@onready var opt_dominant: OptionButton = $PanelMain/VBox/VBoxForm/HBoxCraftDetails/OptDominant
@onready var opt_archetype: OptionButton = $PanelMain/VBox/VBoxForm/HBoxCraftDetails/OptArchetype
@onready var spin_inspiration: SpinBox = $PanelMain/VBox/VBoxForm/HBoxInspiration/SpinInspiration
@onready var btn_start_craft: Button = $PanelMain/VBox/VBoxForm/HBoxInspiration/BtnStartCraft

# Scheda 3: Studio & Registrazione
@onready var hbox_studio: HBoxContainer = $PanelMain/VBox/VBoxForm/HBoxStudio
@onready var opt_studio: OptionButton = $PanelMain/VBox/VBoxForm/HBoxStudio/OptStudio
@onready var chk_burst: CheckBox = $PanelMain/VBox/VBoxForm/HBoxStudio/ChkBurst
@onready var vbox_status: VBoxContainer = $PanelMain/VBox/VBoxStatus
@onready var label_stage_status: Label = $PanelMain/VBox/VBoxStatus/LabelStageStatus

# Barra Bottoni Azione Inferiore
@onready var hbox_bottom: HBoxContainer = $PanelMain/VBox/HBoxBottom
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
var selected_draft_song: SongData = null
var current_step: int = 1
var resume_step: int = 1
var current_tab: int = 1

func _ready() -> void:
	_setup_options()

	btn_tab1.pressed.connect(func(): select_tab(1))
	btn_tab2.pressed.connect(func(): select_tab(2))
	btn_tab3.pressed.connect(func(): select_tab(3))

	btn_start_craft.pressed.connect(_on_btn_start_craft_pressed)
	btn_draft_music.pressed.connect(_on_btn_draft_music_pressed)
	btn_draft_lyrics.pressed.connect(_on_btn_draft_lyrics_pressed)
	btn_draft_polish.pressed.connect(_on_btn_draft_polish_pressed)

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

	# Strumento Dominante (Ramo 2)
	opt_dominant.clear()
	var dominant_list := [
		{"id": "guitar", "name": "Chitarra Elettrica"},
		{"id": "vocals", "name": "Canto & Voce"},
		{"id": "bass", "name": "Basso Elettrico"},
		{"id": "drums", "name": "Batteria & Percussioni"},
		{"id": "keyboards", "name": "Tastiere & Sintetizzatori"},
		{"id": "horns", "name": "Fiati & Ottoni"},
		{"id": "strings", "name": "Archi & Violino"},
		{"id": "harmonica", "name": "Armonica a Bocca"}
	]
	for idx in range(dominant_list.size()):
		var d = dominant_list[idx]
		opt_dominant.add_item(d["name"], idx)
		opt_dominant.set_item_metadata(idx, d["id"])

	# Archetipo Brano
	opt_archetype.clear()
	var archetype_list := [
		{"id": "standard", "name": "Canzone Standard"},
		{"id": "anthem", "name": "Inno da Stadio (Anthem)"},
		{"id": "ballad", "name": "Ballata Emozionale"},
		{"id": "riff", "name": "Riff Trainante"},
		{"id": "experimental", "name": "Brano Sperimentale"}
	]
	for idx in range(archetype_list.size()):
		var a = archetype_list[idx]
		opt_archetype.add_item(a["name"], idx)
		opt_archetype.set_item_metadata(idx, a["id"])

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
	AccessibilityManager.hook_control_accessibility(btn_tab1, "Scheda 1", "Visualizza l'elenco dei cantieri aperti nel cassetto con doppia barra di avanzamento.")
	AccessibilityManager.hook_control_accessibility(btn_tab2, "Scheda 2", "Compila il modulo per avviare un nuovo progetto di composizione.")
	AccessibilityManager.hook_control_accessibility(btn_tab3, "Scheda 3", "Accedi alla sala d'incisione e mastering per registrare i brani completati.")

	AccessibilityManager.hook_control_accessibility(edit_title, "Titolo Brano", "Inserisci il titolo della canzone da creare.")
	AccessibilityManager.hook_control_accessibility(opt_genre, "Genere Musicale", "Seleziona il genere musicale tra Rock, Pop, Metal, HipHop, Elettronica, Indie.")
	AccessibilityManager.hook_control_accessibility(opt_theme, "Tema Lirico", "Seleziona il tema ispiratore per il testo. Verrà vocalizzata l'affinità con il genere.")
	AccessibilityManager.hook_control_accessibility(opt_dominant, "Strumento Dominante", "Seleziona lo strumento principale che guiderà la sinergia nei concerti.")
	AccessibilityManager.hook_control_accessibility(opt_archetype, "Archetipo Canzone", "Seleziona lo stile compositivo del brano.")
	AccessibilityManager.hook_control_accessibility(spin_inspiration, "Punti Ispirazione Iniziali", "Investi punti ispirazione da 0 a 5 per dare una spinta al progetto.")
	AccessibilityManager.hook_control_accessibility(btn_start_craft, "Avvia Cantiere", "Inizia la lavorazione del brano nel loft (massimo 3 cantieri aperti).")

	var acc_studio_desc: String = "Studio Professionale a 40 euro con sconto martedì 20%" if is_tuesday else "Scegli tra Home Studio gratuito o Studio Professionale a 50 euro."
	AccessibilityManager.hook_control_accessibility(opt_studio, "Studio di Registrazione", acc_studio_desc)
	AccessibilityManager.hook_control_accessibility(chk_burst, "Ispirazione Improvvisa", "Spunta per tentare un guizzo creativo con bonus qualità.")
	AccessibilityManager.hook_control_accessibility(btn_produce_all, "Produci Brano Completo", "Registra e finalizza l'intero brano in un'unica sessione se hai energia e fondi sufficienti.")
	AccessibilityManager.hook_control_accessibility(btn_action, "Avanza Prossima Fase", "Avanza di un singolo stadio nella produzione del brano.")
	AccessibilityManager.hook_control_accessibility(btn_save_draft, "Salva Bozza", "Salva lo stato corrente della bozza e ritorna al catalogo.")
	AccessibilityManager.hook_control_accessibility(btn_edit_info, "Modifica Titolo", "Sposta il focus sul campo titolo per modificarlo velocemente.")
	AccessibilityManager.hook_control_accessibility(btn_cancel, "Annulla", "Chiude lo studio musicale senza salvare ulteriori modifiche.")

	_on_genre_or_theme_changed(0)

func select_tab(tab_idx: int) -> void:
	current_tab = tab_idx
	if tab_idx == 1:
		tab1_drafts.visible = true
		vbox_form.visible = false
		vbox_status.visible = false
		hbox_bottom.visible = true
		btn_produce_all.visible = false
		btn_action.visible = false
		btn_edit_info.visible = (current_song != null)
		btn_save_draft.visible = false
		_refresh_drafts_list()
		AccessibilityManager.announce("Scheda 1: Cantieri Aperti. Premi M per comporre musica, T per scrivere testo, R per rifinire.", true)
	elif tab_idx == 2:
		tab1_drafts.visible = false
		vbox_form.visible = true
		hbox_studio.visible = false
		vbox_status.visible = false
		hbox_bottom.visible = true
		btn_produce_all.visible = false
		btn_action.visible = false
		btn_edit_info.visible = false
		btn_save_draft.visible = false
		edit_title.grab_focus()
		AccessibilityManager.announce("Scheda 2: Nuovo Progetto. Inserisci titolo, genere e tema, poi premi Invio per avviare il cantiere.", true)
	elif tab_idx == 3:
		tab1_drafts.visible = false
		vbox_form.visible = true
		hbox_studio.visible = true
		vbox_status.visible = true
		hbox_bottom.visible = true
		btn_produce_all.visible = true
		btn_action.visible = true
		btn_edit_info.visible = true
		btn_save_draft.visible = true
		_update_stage_display()
		AccessibilityManager.announce("Scheda 3: Incisione & Master. Registra in Home Studio o Studio Professionale.", true)

func _refresh_drafts_list() -> void:
	for child in vbox_drafts_list.get_children():
		child.queue_free()

	var drafts: Array[SongData] = []
	if GameManager and GameManager.player_data:
		drafts = GameManager.player_data.get_active_draft_songs()

	btn_tab1.text = "1: Cantieri Aperti (%d/3)" % drafts.size()

	if drafts.is_empty():
		var empty_lbl := Label.new()
		empty_lbl.text = "Nessun cantiere aperto nel cassetto. Premi 2 per avviare un nuovo progetto artigianale!"
		vbox_drafts_list.add_child(empty_lbl)
		selected_draft_song = null
		return

	if selected_draft_song == null or not drafts.has(selected_draft_song):
		selected_draft_song = drafts[0]
		current_song = selected_draft_song

	for d in drafts:
		var status_str := "📝 In lavorazione"
		if d.polishing_status == 1:
			status_str = "🟧 IN RIFINITURA (36h)"
		elif d.polishing_status == 2:
			status_str = "🟩 CAPOLAVORO"
		elif d.polishing_status == 3:
			status_str = "⚪ Pronta Registrazione"

		var row_btn := Button.new()
		row_btn.text = "%s — [Musica: %.0f%%] [Testo: %.0f%%] %s" % [d.title, d.music_progress, d.lyrics_progress, status_str]
		row_btn.pressed.connect(func():
			selected_draft_song = d
			current_song = d
			AccessibilityManager.announce("Selezionato: %s. Musica al %.0f%%, Testo al %.0f%%." % [d.title, d.music_progress, d.lyrics_progress], true)
		)
		vbox_drafts_list.add_child(row_btn)

func _on_btn_start_craft_pressed() -> void:
	if not GameManager or not GameManager.music_system:
		return
	var s_title := edit_title.text.strip_edges()
	var s_genre: int = opt_genre.get_selected_id()
	var s_theme: String = str(opt_theme.get_item_metadata(opt_theme.selected))
	var s_dom: String = str(opt_dominant.get_item_metadata(opt_dominant.selected))
	var s_arch: String = str(opt_archetype.get_item_metadata(opt_archetype.selected))
	var insp: int = int(spin_inspiration.value)

	var res := GameManager.music_system.start_crafting_project(s_title, s_genre, s_theme, s_dom, s_arch, insp)
	if not res.get("success", false):
		AccessibilityManager.announce(res.get("message", "Impossibile avviare il cantiere."), true)
		return

	selected_draft_song = res["song"]
	current_song = res["song"]
	select_tab(1)
	AccessibilityManager.announce("Cantiere avviato con successo per '%s'! Premi M per comporre musica o T per scrivere il testo." % current_song.title, true)

func _on_btn_draft_music_pressed() -> void:
	if not selected_draft_song or not GameManager or not GameManager.music_system:
		AccessibilityManager.announce("Nessun cantiere selezionato per comporre musica.", true)
		return
	var res := GameManager.music_system.work_on_music_progress(selected_draft_song.id, 1.0)
	if not res.get("success", false):
		AccessibilityManager.announce("Energia insufficiente per comporre musica (15 richieste).", true)
	else:
		_refresh_drafts_list()
		AccessibilityManager.announce("Composizione musica per '%s': ora al %.0f%%!" % [selected_draft_song.title, selected_draft_song.music_progress], true)

func _on_btn_draft_lyrics_pressed() -> void:
	if not selected_draft_song or not GameManager or not GameManager.music_system:
		AccessibilityManager.announce("Nessun cantiere selezionato per scrivere testi.", true)
		return
	var res := GameManager.music_system.work_on_lyrics_progress(selected_draft_song.id, 1.0)
	if not res.get("success", false):
		AccessibilityManager.announce("Energia insufficiente per scrivere testi (10 richieste).", true)
	else:
		_refresh_drafts_list()
		AccessibilityManager.announce("Scrittura testo per '%s': ora al %.0f%%!" % [selected_draft_song.title, selected_draft_song.lyrics_progress], true)

func _on_btn_draft_polish_pressed() -> void:
	if not selected_draft_song or not GameManager or not GameManager.music_system:
		return
	if selected_draft_song.polishing_status != 1:
		AccessibilityManager.announce("Il brano non è nella finestra di rifinitura arancione (Musica e Testo devono essere al 100%).", true)
		return
	var p: PlayerData = GameManager.player_data
	if p and p.inspiration_points >= 1:
		var spent: int = mini(2, p.inspiration_points)
		GameManager.music_system.attempt_polishing_burst(selected_draft_song.id, spent)
	else:
		GameManager.music_system.finalize_polishing_standard(selected_draft_song.id)
	_refresh_drafts_list()

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

func open() -> void:
	var drafts_count: int = 0
	if GameManager and GameManager.player_data:
		drafts_count = GameManager.player_data.get_active_draft_songs().size()

	if drafts_count > 0:
		select_tab(1)
	else:
		select_tab(2)

	_update_stage_display()
	AccessibilityManager.announce("Studio musicale e di scrittura aperto. Premi 1 per cantieri aperti, 2 per nuovo progetto, 3 per studio incisione.", true)

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
	_refresh_drafts_list()

func edit_existing_song(song: SongData) -> void:
	current_song = song
	selected_draft_song = song
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

	if song.stage in [Enums.SongStage.RECORDING, Enums.SongStage.COMPLETED]:
		select_tab(3)
	else:
		select_tab(1)
	btn_edit_info.visible = true

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

	var player: PlayerData = GameManager.player_data
	if use_pro and player.money < 50.0 and current_song.stage < Enums.SongStage.RECORDING:
		AccessibilityManager.announce("Fondi insufficienti per lo Studio Professionale (richiesti 50 euro).", true)
		return

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
	select_tab(2)
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
		elif key_event.keycode == KEY_1 or key_event.keycode == KEY_KP_1:
			select_tab(1)
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_2 or key_event.keycode == KEY_KP_2:
			select_tab(2)
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_3 or key_event.keycode == KEY_KP_3:
			select_tab(3)
			get_viewport().set_input_as_handled()
		elif current_tab == 1:
			if key_event.keycode == KEY_M:
				_on_btn_draft_music_pressed()
				get_viewport().set_input_as_handled()
			elif key_event.keycode == KEY_T:
				_on_btn_draft_lyrics_pressed()
				get_viewport().set_input_as_handled()
			elif key_event.keycode == KEY_R:
				_on_btn_draft_polish_pressed()
				get_viewport().set_input_as_handled()
