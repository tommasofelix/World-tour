# res://autoload/event_bus.gd
extends Node

## Bus Globale degli Eventi Disaccoppiato a Segnali per World-tour
## Tutti i layer comunicano tramite questo modulo singleton, senza accoppiamento diretto.

# --- Segnali Temporali & Calendario ---
signal time_ticked(remaining_seconds: float, time_str: String, period: int)
signal day_started(day_number: int)
signal day_ended(day_number: int)
signal pause_toggled(is_paused: bool)
signal speed_changed(new_speed: float)

# --- Segnali Azioni & Routine ---
signal action_started(action_id: String, duration: float)
signal action_progress(action_id: String, elapsed: float, duration: float)
signal action_completed(action_id: String, rewards: Dictionary)
signal action_canceled(action_id: String)

# --- Segnali Musicali & Spettacoli ---
signal song_created(song_data: Dictionary)
signal song_updated(song_data: Dictionary)
signal song_stage_completed(song_id: String, stage: int)
signal song_released(song_data: Dictionary)
signal skill_leveled_up(skill_key: String, new_level: int)
signal concert_resolved(concert_result: Dictionary)
signal stage_event_triggered(event_data: Dictionary)
signal song_catalog_requested()
signal song_creator_requested()
signal live_concert_requested()

# --- Segnali Economia & Carriera ---
signal money_changed(new_balance: float, delta: float, reason: String)
signal career_status_unlocked(new_tier: int, tier_name: String)
signal career_tier_promoted(new_tier: int, tier_name: String)
signal job_completed(job_id: String, wage: float)
signal resigned_from_job()
signal transaction_logged(transaction: Dictionary)
signal economy_screen_requested()
signal game_over_triggered(reason: String)

# --- Segnali di Accessibilità & Interfaccia ---
signal accessibility_announced(text: String, is_interrupt: bool)
signal ui_focus_changed(control_name: String, control_role: String, control_value: String)

# --- Segnali di Sistema & Localizzazione ---
signal language_changed(new_language: String)

# --- Segnali Band & Dinamiche Umane (World-tour V2.0) ---
signal band_member_joined(member: BandMemberData)
signal band_member_left(member: BandMemberData, reason: String)
signal band_chemistry_changed(affinity: float, respect: float, tension: float)
signal band_revenue_split_changed(new_mode: int)
signal band_hub_requested()
signal album_created(album_data: Dictionary)
signal album_released(album_data: Dictionary)
signal album_sales_updated(total_royalties: float, album_count: int)
signal album_creator_requested()
signal housing_changed(new_tier: int, rent: float)

# --- Segnali Industria, Contratti & Manager (World-tour V3.0) ---
signal contract_offered(contract_data: Dictionary)
signal contract_signed(contract_data: Dictionary)
signal contract_completed(contract_data: Dictionary)
signal contract_canceled(contract_data: Dictionary)
signal recoupment_updated(recouped_amount: float, remaining_debt: float)
signal manager_hired(manager_data: Dictionary)
signal manager_fired(manager_data: Dictionary)
signal industry_hub_requested()

# --- Segnali Bivi Etico-Narrativi ---
signal dilemma_triggered(dilemma_data: Dictionary)
signal dilemma_resolved(dilemma_id: String, option_chosen: int, effects: Dictionary)

# --- Segnali Calendario Sistemico & Agenda della Band (World-tour V4.0 / SP-09) ---
signal schedule_event_added(event: CalendarEventData)
signal schedule_event_removed(event_id: String)
signal schedule_event_triggered(event: CalendarEventData)
signal schedule_event_missed(event: CalendarEventData, reason: String)
signal schedule_events_updated()
signal schedule_modal_requested()

# --- Segnali Mappa Geografica & Viaggi (World-tour V4.0 / F8.1) ---
signal city_changed(old_city_id: int, new_city_id: int)
signal travel_screen_requested()

# --- Segnali Tour Musicali & Tournée (World-tour V4.0 / F8.2) ---
signal tour_planned(tour_data: TourData)
signal tour_stop_completed(stop_index: int, concert_result: Dictionary)
signal tour_finished(summary: Dictionary)
signal tour_screen_requested()



