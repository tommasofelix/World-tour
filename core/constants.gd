# res://core/constants.gd
class_name Constants
extends RefCounted

## Parametri e Costanti Centralizzate di Bilanciamento per World-tour

# --- Orologio e Tempo ---
const DAY_DURATION_5_MIN: float = 300.0
const DAY_DURATION_10_MIN: float = 600.0
const DAY_DURATION_15_MIN: float = 900.0
const DAY_DURATION_20_MIN: float = 1200.0
const DEFAULT_DAY_DURATION_SECONDS: float = 300.0
const DAY_DURATION_SECONDS: float = 300.0
const SUPPORTED_DAY_DURATIONS: Array[float] = [300.0, 600.0, 900.0, 1200.0]

const OVERTIME_DURATION_SECONDS: float = 120.0
const SPEED_NORMAL: float = 1.0
const SPEED_FAST: float = 2.0
const SPEED_3X: float = 3.0
const SPEED_ULTRA: float = 5.0
const SUPPORTED_SPEEDS: Array[float] = [1.0, 2.0, 3.0]

# --- Fisiologia e Risorse Vitali ---
const MAX_ENERGY: int = 100
const MIN_ENERGY: int = 0
const MAX_STRESS: int = 100
const MIN_STRESS: int = 0
const MAX_MORALE: int = 100
const MIN_MORALE: int = 0

const SLEEP_STANDARD_ENERGY: int = 70
const SLEEP_STANDARD_STRESS_RELIEF: int = 15
const OVERTIME_ENERGY_RESTORATION: int = 35
const OVERTIME_STRESS_PENALTY: int = 20

# --- Overtime Progressivo e Riposo Anticipato (Sezione 1.2) ---
const VIRTUAL_HOURS_PER_DAY: float = 22.0
const OVERTIME_STRESS_HOUR_1: int = 2
const OVERTIME_STRESS_HOUR_2: int = 3
const OVERTIME_STRESS_HOUR_3: int = 5
const OVERTIME_STRESS_HOUR_4: int = 10
const EARLY_SLEEP_ENERGY_BONUS_EVENING: int = 15
const EARLY_SLEEP_STRESS_BONUS_EVENING: int = 10
const EARLY_SLEEP_ENERGY_BONUS_NIGHT_EARLY: int = 10
const EARLY_SLEEP_STRESS_BONUS_NIGHT_EARLY: int = 5

# Soglie fisiologiche di emergenza
const ENERGY_BURNOUT_THRESHOLD: int = 15
const STRESS_PANIC_THRESHOLD: int = 80

# --- Finanze e Spese Quotidiane ---
const DAILY_FOOD_EXPENSE: float = 10.0
const DAILY_ROOM_RENT: float = 15.0
const TAXI_BASE_FARE: float = 25.0
const BUS_TICKET_PRICE: float = 2.0
const BANKRUPTCY_LIMIT: float = -2000.0

# --- Parametri Formule XP e Abilità ---
const XP_BASE_MULTIPLIER: float = 50.0
const XP_LEVEL_EXPONENT: float = 1.35
const ACTION_XP_BASE: float = 10.0
const ACTION_DURATION_EXPONENT: float = 0.85

# Moltiplicatori saturazione giornaliera (Diminishing Returns)
const SATURATION_FIRST_SESSION: float = 1.0
const SATURATION_SECOND_SESSION: float = 0.70
const SATURATION_SUBSEQUENT_SESSIONS: float = 0.40

# --- Parametri Formule Musica e Qualità ---
const SONG_MIN_QUALITY: float = 1.0
const SONG_MAX_QUALITY: float = 100.0
const SONG_SKILL_WEIGHT_COMP: float = 0.25
const SONG_SKILL_WEIGHT_LYRICS: float = 0.20
const SONG_SKILL_WEIGHT_EXECUTION: float = 0.25
const SONG_SKILL_WEIGHT_PRODUCTION: float = 0.20
const SONG_RANDOM_VARIATION_RANGE: float = 4.0

# --- Concerti, Pubblico e Fanbase ---
const MIN_AUDIENCE_DEFAULT: int = 3
const FAIR_TICKET_PRICE_DEFAULT: float = 10.0
const CONCERT_SCORE_WEIGHT_PERF: float = 0.30
const CONCERT_SCORE_WEIGHT_CHARISMA: float = 0.25
const CONCERT_SCORE_WEIGHT_QUALITY: float = 0.25
const CONCERT_SCORE_WEIGHT_ENERGY: float = 0.10
const CONCERT_RANDOM_VARIATION_RANGE: float = 5.0
const FAN_CONVERSION_EXPONENT: float = 2.2

# --- Accessibilità e Audio ---
const AUDIO_MAX_VOLUME_DB: float = -2.5 # Corrisponde a circa 0.75f lineare
const AUDIO_DUCKING_RATIO: float = 0.40 # Riduzione al 40% durante sintesi
const AUDIO_SAFE_VOLUME_LINEAR: float = 0.75

# Live Region Modes per AccessKit / Screen Reader
const ACCESSIBILITY_LIVE_OFF: int = 0
const ACCESSIBILITY_LIVE_POLITE: int = 1
const ACCESSIBILITY_LIVE_ASSERTIVE: int = 2

# --- Band e Compagni di Gruppo (World-tour V2.0) ---
const MAX_BAND_MEMBERS: int = 3 # Oltre ad Alex (formazione completa 4 elementi)
const BAND_TENSION_SAFE: float = 40.0
const BAND_TENSION_WARNING: float = 70.0
const BAND_TENSION_CRITICAL: float = 85.0 # Rischio abbandono band
const BAND_AUDITION_FEE: float = 30.0

# --- Formati Album (EP / LP) ---
const ALBUM_EP_MIN_TRACKS: int = 3
const ALBUM_EP_MAX_TRACKS: int = 5
const ALBUM_LP_MIN_TRACKS: int = 6
const ALBUM_LP_MAX_TRACKS: int = 10
const ALBUM_EP_PRODUCTION_COST: float = 80.0
const ALBUM_LP_PRODUCTION_COST: float = 200.0
const ALBUM_EP_ROYALTY_RATE: float = 0.35
const ALBUM_LP_ROYALTY_RATE: float = 0.60

# --- Alloggi & Lifestyle (Canoni Giornalieri) ---
const RENT_BEDROOM: float = 15.0
const RENT_SHARED_FLAT: float = 25.0
const RENT_LOFT_STUDIO: float = 50.0
const RENT_LUXURY_VILLA: float = 150.0

# --- Contratti Discografici & Industria (World-tour V3.0) ---
const CONTRACT_INDIE_ADVANCE_DEFAULT: float = 8000.0
const CONTRACT_MAJOR_ADVANCE_DEFAULT: float = 60000.0
const CONTRACT_INDIE_ROYALTY_RATE: float = 0.45
const CONTRACT_MAJOR_ROYALTY_RATE: float = 0.15
const CONTRACT_SELF_ROYALTY_RATE: float = 1.00
const CONTRACT_INDIE_ALBUMS_REQ: int = 2
const CONTRACT_MAJOR_ALBUMS_REQ: int = 3
const CONTRACT_MAJOR_MIN_QUALITY: float = 65.0

# --- Manager & Agenzie di Booking ---
const MANAGER_FRIEND_COMMISSION: float = 0.10
const MANAGER_PRO_COMMISSION: float = 0.15
const MANAGER_SHARK_COMMISSION: float = 0.22

const MANAGER_FRIEND_HIRING_FEE: float = 50.0
const MANAGER_PRO_HIRING_FEE: float = 400.0
const MANAGER_SHARK_HIRING_FEE: float = 2000.0

const MANAGER_FRIEND_CACHET_MULT: float = 1.10
const MANAGER_PRO_CACHET_MULT: float = 1.25
const MANAGER_SHARK_CACHET_MULT: float = 1.50

const MANAGER_FRIEND_STRESS_RELIEF: float = 1.0
const MANAGER_PRO_STRESS_RELIEF: float = 2.5
const MANAGER_SHARK_STRESS_RELIEF: float = 4.0

# --- Calendario Sistemico & Cicli Temporali (SP-09 / World-tour V4.0) ---
const DAYS_PER_WEEK: int = 7
const DAYS_PER_MONTH: int = 28
const WEEKS_PER_MONTH: int = 4
const MONTHS_PER_YEAR: int = 12
const DAYS_PER_YEAR: int = 336 # 28 * 12
const MONTHS_PER_SEASON: int = 3

# Moltiplicatori e bonus legati ai giorni della settimana
const WEEKEND_FRIDAY_AUDIENCE_MULT: float = 1.50
const WEEKEND_SATURDAY_AUDIENCE_MULT: float = 2.00
const WEEKEND_SATURDAY_FAN_MULT: float = 1.50
const TUESDAY_STUDIO_DISCOUNT: float = 0.20
const WEDNESDAY_BAND_XP_MULT: float = 1.20


