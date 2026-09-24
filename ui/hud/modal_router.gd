# res://ui/hud/modal_router.gd
class_name ModalRouter
extends RefCounted

## Router e Coordinatore Specialistico delle Finestre Modali di World-tour
## Gestisce la registrazione, mutua esclusione atomica, instradamento segnali EventBus,
## apertura, chiusura e ripristino del focus per tutte le 19 finestre modali del gioco.

var hud: Control = null
var _modals: Array[Control] = []
var _pending_dilemma_at_day_end: Dictionary = {}

func setup(p_hud: Control) -> void:
	hud = p_hud
	_register_modals()
	_connect_modal_signals()
	_connect_event_bus()

func _register_modals() -> void:
	_modals = [
		hud.song_catalog_modal,
		hud.song_creator_modal,
		hud.live_concert_modal,
		hud.economy_bank_modal,
		hud.daily_summary_modal,
		hud.character_sheet_modal,
		hud.band_hub_modal,
		hud.album_creator_modal,
		hud.industry_hub_modal,
		hud.dilemma_modal,
		hud.travel_modal,
		hud.tour_modal,
		hud.festival_modal,
		hud.social_modal,
		hud.chart_modal,
		hud.system_menu_modal,
		hud.upgrades_modal,
		hud.relax_modal,
		hud.legacy_modal
	]

func _connect_modal_signals() -> void:
	if hud.song_catalog_modal:
		hud.song_catalog_modal.closed.connect(close_catalog)
		hud.song_catalog_modal.new_song_requested.connect(_on_catalog_new_song_requested)
		hud.song_catalog_modal.edit_song_requested.connect(open_song_editor)
		hud.song_catalog_modal.new_album_requested.connect(open_album_creator)
	if hud.song_creator_modal:
		hud.song_creator_modal.creation_finished.connect(_on_song_created_or_finished)
		hud.song_creator_modal.creation_canceled.connect(close_song_creator)
	if hud.live_concert_modal:
		hud.live_concert_modal.closed.connect(close_live_concert)
		hud.live_concert_modal.concert_completed.connect(_on_concert_completed)
	if hud.economy_bank_modal:
		hud.economy_bank_modal.closed.connect(close_economy_bank)
	if hud.daily_summary_modal:
		hud.daily_summary_modal.day_advanced.connect(_on_day_advanced)
	if hud.character_sheet_modal:
		hud.character_sheet_modal.closed.connect(close_character_sheet)
	if hud.band_hub_modal:
		hud.band_hub_modal.closed.connect(close_band_hub)
	if hud.album_creator_modal:
		hud.album_creator_modal.closed.connect(close_album_creator)
		hud.album_creator_modal.album_published.connect(_on_album_published)
	if hud.industry_hub_modal:
		hud.industry_hub_modal.closed.connect(close_industry_hub)
	if hud.dilemma_modal:
		hud.dilemma_modal.closed.connect(close_dilemma_modal)
	if hud.travel_modal:
		hud.travel_modal.closed.connect(close_travel_modal)
	if hud.tour_modal:
		hud.tour_modal.closed.connect(close_tour_modal)
	if hud.festival_modal:
		hud.festival_modal.closed.connect(close_festival_modal)
	if hud.social_modal:
		hud.social_modal.closed.connect(close_social_modal)
	if hud.chart_modal:
		hud.chart_modal.closed.connect(close_chart_modal)
	if hud.system_menu_modal:
		hud.system_menu_modal.resume_requested.connect(close_system_menu)
	if hud.upgrades_modal:
		hud.upgrades_modal.closed.connect(close_upgrades_modal)
	if hud.relax_modal:
		hud.relax_modal.closed.connect(close_relax_modal)
		hud.relax_modal.activity_selected.connect(_on_relax_activity_selected)
	if hud.legacy_modal:
		hud.legacy_modal.closed.connect(close_legacy_modal)

func _connect_event_bus() -> void:
	EventBus.song_catalog_requested.connect(open_catalog)
	EventBus.song_creator_requested.connect(open_song_creator)
	EventBus.live_concert_requested.connect(open_live_concert)
	EventBus.economy_screen_requested.connect(open_economy_bank)
	EventBus.band_hub_requested.connect(open_band_hub)
	EventBus.album_creator_requested.connect(open_album_creator)
	EventBus.industry_hub_requested.connect(open_industry_hub)
	EventBus.travel_screen_requested.connect(open_travel_modal)
	EventBus.social_screen_requested.connect(open_social_modal)
	EventBus.chart_screen_requested.connect(open_chart_modal)
	EventBus.legacy_screen_requested.connect(open_legacy_modal)
	EventBus.dilemma_triggered.connect(on_dilemma_triggered)

## Verifica se almeno una modale è aperta
func is_any_modal_open() -> bool:
	for m in _modals:
		if m and m.visible:
			return true
	return false

## Occulta sistematicamente tutte le finestre modali e la vista HUD principale
func hide_all_modals() -> void:
	for m in _modals:
		if m:
			m.visible = false
	if hud and hud.vbox_main:
		hud.vbox_main.visible = false

# --- Apertura & Chiusura Modali ---

func open_catalog(show_albums: bool = false) -> void:
	hide_all_modals()
	if hud.song_catalog_modal:
		hud.song_catalog_modal.visible = true
		if show_albums:
			hud.song_catalog_modal.show_albums_section()
		else:
			hud.song_catalog_modal.refresh_catalog()
	GameManager.open_menu()

func close_catalog() -> void:
	if hud.song_catalog_modal:
		hud.song_catalog_modal.visible = false
	_restore_hud(2, hud.btn_catalog)

func open_song_creator() -> void:
	hide_all_modals()
	if hud.song_creator_modal:
		hud.song_creator_modal.visible = true
		hud.song_creator_modal.start_new_song()
	GameManager.open_menu()

func close_song_creator() -> void:
	if hud.song_creator_modal:
		hud.song_creator_modal.visible = false
	_restore_hud(2, hud.btn_new_song)

func open_song_editor(song: SongData) -> void:
	hide_all_modals()
	if hud.song_creator_modal:
		hud.song_creator_modal.visible = true
		hud.song_creator_modal.edit_existing_song(song)
	GameManager.open_menu()

func open_live_concert() -> void:
	hide_all_modals()
	if hud.live_concert_modal:
		hud.live_concert_modal.visible = true
		hud.live_concert_modal.open_preparation()
	GameManager.open_menu()

func close_live_concert() -> void:
	if hud.live_concert_modal:
		hud.live_concert_modal.visible = false
	_restore_hud(3, hud.btn_concert)

func open_economy_bank() -> void:
	hide_all_modals()
	if hud.economy_bank_modal:
		hud.economy_bank_modal.open()
	GameManager.open_menu()

func close_economy_bank() -> void:
	if hud.economy_bank_modal:
		hud.economy_bank_modal.visible = false
	_restore_hud(1, hud.btn_economy)

func open_character_sheet() -> void:
	hide_all_modals()
	if hud.character_sheet_modal:
		hud.character_sheet_modal.open()
	GameManager.open_menu()

func close_character_sheet() -> void:
	if hud.character_sheet_modal:
		hud.character_sheet_modal.visible = false
	_restore_hud(1, hud.btn_character)

func open_band_hub() -> void:
	hide_all_modals()
	if hud.band_hub_modal:
		hud.band_hub_modal.open()
	GameManager.open_menu()

func close_band_hub() -> void:
	if hud.band_hub_modal:
		hud.band_hub_modal.visible = false
	_restore_hud(3, hud.btn_band)

func open_album_creator() -> void:
	hide_all_modals()
	if hud.album_creator_modal:
		hud.album_creator_modal.open()
	GameManager.open_menu()

func close_album_creator() -> void:
	if hud.album_creator_modal:
		hud.album_creator_modal.visible = false
	_restore_hud(2, hud.btn_catalog)

func open_industry_hub() -> void:
	hide_all_modals()
	if hud.industry_hub_modal:
		hud.industry_hub_modal.open()
	GameManager.open_menu()

func close_industry_hub() -> void:
	if hud.industry_hub_modal:
		hud.industry_hub_modal.visible = false
	_restore_hud(3, hud.btn_industry)

func open_travel_modal() -> void:
	hide_all_modals()
	if hud.travel_modal:
		hud.travel_modal.open()
	GameManager.open_menu()

func close_travel_modal() -> void:
	if hud.travel_modal:
		hud.travel_modal.visible = false
	_restore_hud(1, hud.btn_travel)

func open_tour_modal() -> void:
	hide_all_modals()
	if hud.tour_modal:
		hud.tour_modal.open()
	GameManager.open_menu()

func close_tour_modal() -> void:
	if hud.tour_modal:
		hud.tour_modal.visible = false
	_restore_hud(3, hud.btn_tour)

func open_festival_modal() -> void:
	hide_all_modals()
	if hud.festival_modal:
		hud.festival_modal.open()
	GameManager.open_menu()

func close_festival_modal() -> void:
	if hud.festival_modal:
		hud.festival_modal.visible = false
	_restore_hud(3, hud.btn_festival)

func open_social_modal() -> void:
	hide_all_modals()
	if hud.social_modal:
		hud.social_modal.open()
	GameManager.open_menu()

func close_social_modal() -> void:
	if hud.social_modal:
		hud.social_modal.visible = false
	_restore_hud(3, hud.btn_social)

func open_chart_modal() -> void:
	hide_all_modals()
	if hud.chart_modal:
		hud.chart_modal.open()
	GameManager.open_menu()

func close_chart_modal() -> void:
	if hud.chart_modal:
		hud.chart_modal.visible = false
	_restore_hud(3, hud.btn_chart)

func open_system_menu() -> void:
	hide_all_modals()
	if hud.system_menu_modal:
		hud.system_menu_modal.open()
	GameManager.open_menu()

func close_system_menu() -> void:
	if hud.system_menu_modal:
		hud.system_menu_modal.visible = false
	if hud and hud.vbox_main:
		hud.vbox_main.visible = true
	GameManager.close_menu()
	hud.select_category_tab(hud.current_category_tab)
	hud._update_hud_display()

func open_upgrades_modal() -> void:
	hide_all_modals()
	if hud.upgrades_modal:
		hud.upgrades_modal.open()
	GameManager.open_menu()

func close_upgrades_modal() -> void:
	if hud.upgrades_modal:
		hud.upgrades_modal.visible = false
	_restore_hud(4, hud.btn_upgrades)

func open_relax_modal() -> void:
	hide_all_modals()
	if hud.relax_modal:
		hud.relax_modal.open()
	GameManager.open_menu()

func close_relax_modal() -> void:
	if hud.relax_modal:
		hud.relax_modal.visible = false
	_restore_hud(1, hud.btn_relax)

func open_legacy_modal() -> void:
	hide_all_modals()
	if hud.legacy_modal:
		hud.legacy_modal.open()
	GameManager.open_menu()

func close_legacy_modal() -> void:
	if hud.legacy_modal:
		hud.legacy_modal.visible = false
	_restore_hud(3, hud.btn_legacy)

func open_daily_summary(summary_data: Dictionary) -> void:
	hide_all_modals()
	if summary_data.has("pending_dilemma") and not summary_data["pending_dilemma"].is_empty():
		_pending_dilemma_at_day_end = summary_data["pending_dilemma"]
	if hud.daily_summary_modal:
		hud.daily_summary_modal.show_summary(summary_data)

func on_dilemma_triggered(dilemma_dict: Dictionary) -> void:
	if hud.daily_summary_modal and hud.daily_summary_modal.visible:
		_pending_dilemma_at_day_end = dilemma_dict
		return
	hide_all_modals()
	if hud.dilemma_modal:
		hud.dilemma_modal.open(dilemma_dict)
	GameManager.open_menu()

func close_dilemma_modal() -> void:
	if hud.dilemma_modal:
		hud.dilemma_modal.visible = false
	if hud and hud.vbox_main:
		hud.vbox_main.visible = true
	GameManager.close_menu()
	hud.btn_character.grab_focus()
	hud._update_hud_display()

func _on_day_advanced() -> void:
	if hud.daily_summary_modal:
		hud.daily_summary_modal.visible = false
	if not _pending_dilemma_at_day_end.is_empty():
		var d: Dictionary = _pending_dilemma_at_day_end
		_pending_dilemma_at_day_end = {}
		on_dilemma_triggered(d)
		return
	if hud and hud.vbox_main:
		hud.vbox_main.visible = true
	hud._update_hud_display()
	hud.btn_practice.grab_focus()

func _on_album_published(_album_data: Dictionary) -> void:
	if hud.album_creator_modal:
		hud.album_creator_modal.visible = false
	open_catalog(true)
	hud._update_hud_display()

func _on_concert_completed(result: Dictionary) -> void:
	if result.get("is_sold_out", false):
		AccessibilityManager.play_cue(Enums.AudioCueType.STADIUM_SOLD_OUT)
	hud._update_hud_display()

func _on_catalog_new_song_requested() -> void:
	if hud.song_catalog_modal:
		hud.song_catalog_modal.visible = false
	open_song_creator()

func _on_song_created_or_finished(_song: SongData) -> void:
	if hud.song_creator_modal:
		hud.song_creator_modal.visible = false
	open_catalog()

func _on_relax_activity_selected(action: ActionData) -> void:
	if hud.action_system:
		hud.action_system.start_action(action)

func _restore_hud(tab_idx: int, focus_btn: Control) -> void:
	if hud and hud.vbox_main:
		hud.vbox_main.visible = true
	GameManager.close_menu()
	if hud:
		hud.select_category_tab(tab_idx)
		if focus_btn:
			focus_btn.grab_focus()
		hud._update_hud_display()
