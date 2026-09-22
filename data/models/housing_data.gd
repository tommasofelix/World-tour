# res://data/models/housing_data.gd
class_name HousingData
extends RefCounted

## Modello Dati per Residenze, Alloggi e Lifestyle del Musicista (World-tour V2.0)
## Governa il costo di affitto giornaliero, la disponibilità di sala prove privata,
## l'effetto sulla convivenza tra membri della band e i bonus morali.

var housing_tier: int = Enums.HousingTier.STARTER_BEDROOM
var housing_name: String = ""
var daily_rent: float = 15.0
var has_rehearsal_space: bool = false
var shared_with_band: bool = false
var tension_daily_modifier: float = 0.0 # Positivo se la convivenza genera attrito
var morale_daily_bonus: float = 0.0

func _init(tier: int = Enums.HousingTier.STARTER_BEDROOM) -> void:
	setup_tier(tier)

func setup_tier(tier: int) -> void:
	housing_tier = tier
	match tier:
		Enums.HousingTier.STARTER_BEDROOM:
			housing_name = tr("HOUSING_BEDROOM")
			daily_rent = Constants.RENT_BEDROOM
			has_rehearsal_space = false
			shared_with_band = false
			tension_daily_modifier = 0.0
			morale_daily_bonus = 0.0
		Enums.HousingTier.SHARED_FLAT:
			housing_name = tr("HOUSING_SHARED_FLAT")
			daily_rent = Constants.RENT_SHARED_FLAT
			has_rehearsal_space = false
			shared_with_band = true
			tension_daily_modifier = 1.0 # Convivenza stretta genera attriti occasionali
			morale_daily_bonus = 2.0
		Enums.HousingTier.LOFT_STUDIO:
			housing_name = tr("HOUSING_LOFT_STUDIO")
			daily_rent = Constants.RENT_LOFT_STUDIO
			has_rehearsal_space = true
			shared_with_band = false
			tension_daily_modifier = -1.0 # Spazio ampio e sala prove inclusa
			morale_daily_bonus = 5.0
		Enums.HousingTier.LUXURY_VILLA:
			housing_name = tr("HOUSING_LUXURY_VILLA")
			daily_rent = Constants.RENT_LUXURY_VILLA
			has_rehearsal_space = true
			shared_with_band = false
			tension_daily_modifier = -2.0
			morale_daily_bonus = 10.0

static func get_tier_name(tier: int) -> String:
	match tier:
		Enums.HousingTier.STARTER_BEDROOM:
			return TranslationServer.translate("HOUSING_BEDROOM")
		Enums.HousingTier.SHARED_FLAT:
			return TranslationServer.translate("HOUSING_SHARED_FLAT")
		Enums.HousingTier.LOFT_STUDIO:
			return TranslationServer.translate("HOUSING_LOFT_STUDIO")
		Enums.HousingTier.LUXURY_VILLA:
			return TranslationServer.translate("HOUSING_LUXURY_VILLA")
		_:
			return "Stanzetta"

static func get_tier_rent(tier: int) -> float:
	match tier:
		Enums.HousingTier.STARTER_BEDROOM:
			return Constants.RENT_BEDROOM
		Enums.HousingTier.SHARED_FLAT:
			return Constants.RENT_SHARED_FLAT
		Enums.HousingTier.LOFT_STUDIO:
			return Constants.RENT_LOFT_STUDIO
		Enums.HousingTier.LUXURY_VILLA:
			return Constants.RENT_LUXURY_VILLA
		_:
			return Constants.RENT_BEDROOM
