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
signal concert_resolved(concert_result: Dictionary)
signal stage_event_triggered(event_data: Dictionary)

# --- Segnali Economia & Carriera ---
signal money_changed(new_balance: float, delta: float, reason: String)
signal career_status_unlocked(new_tier: int, tier_name: String)
signal game_over_triggered(reason: String)

# --- Segnali di Accessibilità & Interfaccia ---
signal accessibility_announced(text: String, is_interrupt: bool)
signal ui_focus_changed(control_name: String, control_role: String, control_value: String)

# --- Segnali di Sistema & Localizzazione ---
signal language_changed(new_language: String)
