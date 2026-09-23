# res://core/formulas.gd
class_name Formulas
extends RefCounted

## Classe Pura di Calcolo Matematico e Algoritmi di Gioco per World-tour
## Tutte le funzioni sono statiche, deterministiche e prive di side-effect.

const LyricThemeData = preload("res://data/models/lyric_theme_data.gd")

# --- 1. Progressione ed Esperienza (XP) ---

## Calcola l'esperienza totale necessaria per salire dal livello attuale al livello successivo
static func calculate_xp_for_level(level: int) -> int:
	var safe_level: float = maxf(1.0, float(level))
	var required_xp: float = Constants.XP_BASE_MULTIPLIER * pow(safe_level, Constants.XP_LEVEL_EXPONENT)
	return int(round(required_xp))

## Restituisce il coefficiente di saturazione per l'anti-grinding giornaliero
static func get_saturation_modifier(daily_count: int) -> float:
	if daily_count <= 1:
		return Constants.SATURATION_FIRST_SESSION
	elif daily_count == 2:
		return Constants.SATURATION_SECOND_SESSION
	else:
		return Constants.SATURATION_SUBSEQUENT_SESSIONS

## Calcola l'indice di efficienza del personaggio [0.20, 1.30] basato su stress e morale
static func calculate_efficiency_factor(stress: float, morale: float) -> float:
	var safe_stress: float = clampf(stress, float(Constants.MIN_STRESS), float(Constants.MAX_STRESS))
	var safe_morale: float = clampf(morale, float(Constants.MIN_MORALE), float(Constants.MAX_MORALE))
	
	var stress_factor: float = 1.0 - (safe_stress / 150.0)
	var morale_factor: float = 0.50 + (safe_morale / 200.0)
	var raw_efficiency: float = stress_factor * morale_factor
	
	return clampf(raw_efficiency, 0.20, 1.30)

## Calcola l'XP guadagnato da un'azione di allenamento
static func calculate_training_xp(base_xp: float, duration_seconds: float, daily_count: int, stress: float, morale: float) -> float:
	var safe_duration: float = maxf(1.0, duration_seconds)
	var duration_factor: float = pow(safe_duration / 10.0, Constants.ACTION_DURATION_EXPONENT)
	var saturation: float = get_saturation_modifier(daily_count)
	var efficiency: float = calculate_efficiency_factor(stress, morale)
	
	var gained_xp: float = base_xp * duration_factor * saturation * efficiency
	return maxf(1.0, gained_xp)

# --- 2. Qualità dei Brani Musicali ---

## Calcola il bonus/malus di sinergia artistica tra tema lirico e genere musicale
static func calculate_theme_genre_affinity(theme: String, genre: int) -> float:
	return LyricThemeData.get_affinity_for_genre(theme, genre)

## Calcola il punteggio di qualità finale di un brano musicale [1.0, 100.0]
static func calculate_song_quality(comp_skill: float, lyric_skill: float, exec_skill: float, prod_skill: float, studio_bonus: float, morale: float, rng_roll: float = 0.0, theme_affinity: float = 0.0) -> float:
	var c_skill: float = clampf(comp_skill, 1.0, 100.0)
	var l_skill: float = clampf(lyric_skill, 1.0, 100.0)
	var e_skill: float = clampf(exec_skill, 1.0, 100.0)
	var p_skill: float = clampf(prod_skill + studio_bonus, 1.0, 100.0)
	var safe_morale: float = clampf(morale, 0.0, 100.0)
	
	var skill_base: float = (
		(Constants.SONG_SKILL_WEIGHT_COMP * c_skill) +
		(Constants.SONG_SKILL_WEIGHT_LYRICS * l_skill) +
		(Constants.SONG_SKILL_WEIGHT_EXECUTION * e_skill) +
		(Constants.SONG_SKILL_WEIGHT_PRODUCTION * p_skill)
	)
	
	var morale_modifier: float = 0.85 + (0.30 * (safe_morale / 100.0))
	var bounded_rng: float = clampf(rng_roll, -Constants.SONG_RANDOM_VARIATION_RANGE, Constants.SONG_RANDOM_VARIATION_RANGE)
	var final_quality: float = (skill_base * morale_modifier) + bounded_rng + theme_affinity
	
	return clampf(final_quality, Constants.SONG_MIN_QUALITY, Constants.SONG_MAX_QUALITY)

# --- 3. Concerti, Audience e Fanbase ---

## Calcola l'affluenza di spettatori presenti a un concerto
static func calculate_audience(capacity: int, popularity: float, prestige: float, ticket_price: float, fair_price: float = Constants.FAIR_TICKET_PRICE_DEFAULT) -> int:
	var safe_capacity: int = maxi(Constants.MIN_AUDIENCE_DEFAULT, capacity)
	var safe_pop: float = clampf(popularity, 0.0, 100.0)
	var safe_prestige: float = clampf(prestige, 0.0, 100.0)
	var safe_fair_price: float = maxf(1.0, fair_price)
	
	var prestige_mod: float = 0.80 + (0.40 * (safe_prestige / 100.0))
	var ticket_ratio: float = ticket_price / safe_fair_price
	var ticket_penalty: float = clampf(1.50 - (0.50 * ticket_ratio), 0.10, 1.20)
	
	var demand_ratio: float = 0.12 + (0.88 * (safe_pop / 100.0))
	var demand: float = float(safe_capacity) * demand_ratio * prestige_mod * ticket_penalty
	
	var audience_count: int = int(floor(demand))
	audience_count = mini(safe_capacity, maxi(Constants.MIN_AUDIENCE_DEFAULT, audience_count))
	return audience_count

## Calcola il punteggio di riuscita del concerto live [1.0, 100.0]
static func calculate_concert_score(perf_skill: float, charisma_skill: float, avg_song_quality: float, current_energy: float, rng_roll: float = 0.0) -> float:
	var safe_perf: float = clampf(perf_skill, 1.0, 100.0)
	var safe_charisma: float = clampf(charisma_skill, 1.0, 100.0)
	var safe_quality: float = clampf(avg_song_quality, 1.0, 100.0)
	var safe_energy: float = clampf(current_energy, 0.0, 100.0)
	
	var bounded_rng: float = clampf(rng_roll, -Constants.CONCERT_RANDOM_VARIATION_RANGE, Constants.CONCERT_RANDOM_VARIATION_RANGE)
	var raw_score: float = (
		(Constants.CONCERT_SCORE_WEIGHT_PERF * safe_perf) +
		(Constants.CONCERT_SCORE_WEIGHT_CHARISMA * safe_charisma) +
		(Constants.CONCERT_SCORE_WEIGHT_QUALITY * safe_quality) +
		(Constants.CONCERT_SCORE_WEIGHT_ENERGY * safe_energy) +
		bounded_rng
	)
	
	return clampf(raw_score, 1.0, 100.0)

## Calcola quanti spettatori presenti vengono convertiti in fan fidelizzati permanenti
static func calculate_fan_conversion(audience: int, concert_score: float, charisma_skill: float) -> int:
	var safe_audience: int = maxi(0, audience)
	var safe_score: float = clampf(concert_score, 1.0, 100.0)
	var safe_charisma: float = clampf(charisma_skill, 1.0, 100.0)
	
	var base_score_ratio: float = safe_score / 100.0
	var score_factor: float = pow(base_score_ratio, Constants.FAN_CONVERSION_EXPONENT)
	var charisma_factor: float = 0.15 + (0.35 * (safe_charisma / 100.0))
	var conversion_rate: float = score_factor * charisma_factor
	
	var new_fans: int = int(floor(float(safe_audience) * conversion_rate))
	return maxi(0, new_fans)
