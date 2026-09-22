# res://data/models/upgrade_data.gd
class_name UpgradeData
extends RefCounted

## Modello Dati Centralizzato per Upgrades, Attrezzatura, Strumenti e Sala Prove (World-tour V5.0)
## Fornisce costanti, elenchi strumenti multicategoria con comparatore e metodi statici di calcolo.

# --- 1. Sala Prove & Insonorizzazione (Rehearsal) ---
enum RehearsalTier {
	NONE = 0,         # Garage rumoroso (stress base 10)
	ACOUSTIC_PANELS = 1, # Pannelli fonoassorbenti base (300 €)
	PRO_ISOLATION = 2,   # Insonorizzazione professionale (800 €)
	MASTER_STUDIO = 3    # Studio perfetto & lounge relax (2.000 €)
}

const REHEARSAL_COSTS: Dictionary = {
	RehearsalTier.NONE: 0.0,
	RehearsalTier.ACOUSTIC_PANELS: 300.0,
	RehearsalTier.PRO_ISOLATION: 800.0,
	RehearsalTier.MASTER_STUDIO: 2000.0
}

static func get_rehearsal_name(tier: int) -> String:
	match tier:
		RehearsalTier.NONE:
			return "Garage Rumoroso (Nessuna Insonorizzazione)"
		RehearsalTier.ACOUSTIC_PANELS:
			return "Pannelli Fonoassorbenti Base"
		RehearsalTier.PRO_ISOLATION:
			return "Insonorizzazione Professionale"
		RehearsalTier.MASTER_STUDIO:
			return "Studio Acustico Perfetto & Lounge"
		_:
			return "Sala Standard"

static func get_rehearsal_stress(tier: int) -> int:
	match tier:
		RehearsalTier.NONE:
			return 10
		RehearsalTier.ACOUSTIC_PANELS:
			return 7
		RehearsalTier.PRO_ISOLATION:
			return 4
		RehearsalTier.MASTER_STUDIO:
			return 0
		_:
			return 10

# --- 2. Hardware Home Studio & Registrazione ---
enum StudioHardwareTier {
	BASIC_MIC = 0,     # Microfono integrato (Cap 60, Bonus 0)
	USB_CONDENSER = 1, # Mic a condensatore & Scheda USB (Costo 400 €, Cap 75, Bonus +5)
	TUBE_PREAMP = 2,   # Pre valvolare & Monitor da studio (Costo 1.200 €, Cap 90, Bonus +10)
	ANALOG_CONSOLE = 3 # Banco mixer analogico & Mastering Suite (Costo 3.500 €, Cap 100, Bonus +15)
}

const STUDIO_HARDWARE_COSTS: Dictionary = {
	StudioHardwareTier.BASIC_MIC: 0.0,
	StudioHardwareTier.USB_CONDENSER: 400.0,
	StudioHardwareTier.TUBE_PREAMP: 1200.0,
	StudioHardwareTier.ANALOG_CONSOLE: 3500.0
}

static func get_studio_hardware_name(tier: int) -> String:
	match tier:
		StudioHardwareTier.BASIC_MIC:
			return "Microfono Integrato Base"
		StudioHardwareTier.USB_CONDENSER:
			return "Microfono a Condensatore & Interfaccia USB"
		StudioHardwareTier.TUBE_PREAMP:
			return "Preamplificatore Valvolare & Monitor Studio"
		StudioHardwareTier.ANALOG_CONSOLE:
			return "Banco Mixer Analogico & Suite Mastering"
		_:
			return "Hardware Base"

static func get_studio_hardware_cap(tier: int) -> float:
	match tier:
		StudioHardwareTier.BASIC_MIC:
			return 60.0
		StudioHardwareTier.USB_CONDENSER:
			return 75.0
		StudioHardwareTier.TUBE_PREAMP:
			return 90.0
		StudioHardwareTier.ANALOG_CONSOLE:
			return 100.0
		_:
			return 60.0

static func get_studio_hardware_bonus(tier: int) -> float:
	match tier:
		StudioHardwareTier.BASIC_MIC:
			return 0.0
		StudioHardwareTier.USB_CONDENSER:
			return 5.0
		StudioHardwareTier.TUBE_PREAMP:
			return 10.0
		StudioHardwareTier.ANALOG_CONSOLE:
			return 15.0
		_:
			return 0.0

# --- 3. Negozio Strumenti Multicategoria ---
const CATEGORIES: Array[String] = [
	"guitar",
	"bass",
	"drums",
	"vocals",
	"keyboards"
]

static func get_category_display_name(category: String) -> String:
	match category:
		"guitar":
			return "Chitarre"
		"bass":
			return "Bassi"
		"drums":
			return "Batterie"
		"vocals":
			return "Microfoni / Voce"
		"keyboards":
			return "Tastiere / Synth"
		_:
			return category.capitalize()

# Catalogo completo di strumenti
const INSTRUMENTS: Dictionary = {
	"guitar": {
		0: {
			"name": "Chitarra da Studio Starter",
			"tier": 0,
			"cost": 0.0,
			"skill_bonus": 0,
			"charisma_bonus": 0,
			"band_synergy_bonus": 0.0,
			"desc": "Modello economico per principianti. Nessun bonus speciale."
		},
		1: {
			"name": "Chitarra Stage Semi-Pro",
			"tier": 1,
			"cost": 500.0,
			"skill_bonus": 5,
			"charisma_bonus": 3,
			"band_synergy_bonus": 2.0,
			"desc": "Pickup affidabili e manico veloce. +5 Livello Esecuzione, +3 Carisma live."
		},
		2: {
			"name": "Chitarra Vintage Professional",
			"tier": 2,
			"cost": 1500.0,
			"skill_bonus": 12,
			"charisma_bonus": 8,
			"band_synergy_bonus": 5.0,
			"desc": "Legni stagionati anni '70 dal timbro inconfondibile. +12 Esecuzione, +8 Carisma, +5% Concert Score."
		},
		3: {
			"name": "Custom Shop Signature d'Autore",
			"tier": 3,
			"cost": 4000.0,
			"skill_bonus": 20,
			"charisma_bonus": 15,
			"band_synergy_bonus": 10.0,
			"desc": "Capolavoro di liuteria artigianale. +20 Esecuzione, +15 Carisma, corde rinforzate anti-rottura."
		}
	},
	"bass": {
		0: {
			"name": "Basso Elettrico Standard Starter",
			"tier": 0,
			"cost": 0.0,
			"skill_bonus": 0,
			"charisma_bonus": 0,
			"band_synergy_bonus": 0.0,
			"desc": "Basso economico a 4 corde. Linea di partenza."
		},
		1: {
			"name": "Basso Groove Semi-Pro",
			"tier": 1,
			"cost": 500.0,
			"skill_bonus": 5,
			"charisma_bonus": 2,
			"band_synergy_bonus": 4.0,
			"desc": "Groove solido e attacco definito. +5 Basso, +4 Stabilità ritmica della band."
		},
		2: {
			"name": "Basso Vintage Precision 1968",
			"tier": 2,
			"cost": 1500.0,
			"skill_bonus": 12,
			"charisma_bonus": 6,
			"band_synergy_bonus": 8.0,
			"desc": "Frequenze basse calde e presenti nel mix. +12 Basso, +8 Sinergia ritmica di gruppo."
		},
		3: {
			"name": "Basso Custom Boutique Handcrafted",
			"tier": 3,
			"cost": 4000.0,
			"skill_bonus": 20,
			"charisma_bonus": 12,
			"band_synergy_bonus": 15.0,
			"desc": "Circuito attivo ed elettronica boutique. +20 Basso, +15 Sinergia palco globale."
		}
	},
	"drums": {
		0: {
			"name": "Batteria Elettronica Starter Pad",
			"tier": 0,
			"cost": 0.0,
			"skill_bonus": 0,
			"charisma_bonus": 0,
			"band_synergy_bonus": 0.0,
			"desc": "Set elettronico essenziale per esercitarsi senza fare rumore."
		},
		1: {
			"name": "Batteria Acustica Stage Live",
			"tier": 1,
			"cost": 600.0,
			"skill_bonus": 5,
			"charisma_bonus": 3,
			"band_synergy_bonus": 4.0,
			"desc": "Fusti in betulla e piatti professionali. +5 Batteria, +4 Potenza sonora dal vivo."
		},
		2: {
			"name": "Batteria Custom Maple Recording",
			"tier": 2,
			"cost": 1800.0,
			"skill_bonus": 12,
			"charisma_bonus": 7,
			"band_synergy_bonus": 9.0,
			"desc": "Fusti in acero canadese dal sustain impeccabile. +12 Batteria, +9 Sinergia band."
		},
		3: {
			"name": "Master Tour Arena Drumkit",
			"tier": 3,
			"cost": 4500.0,
			"skill_bonus": 20,
			"charisma_bonus": 15,
			"band_synergy_bonus": 16.0,
			"desc": "Set titanico a doppia cassa con rack idraulico. +20 Batteria, +15 Carisma, +16 Sinergia live."
		}
	},
	"vocals": {
		0: {
			"name": "Microfono Dinamico Starter",
			"tier": 0,
			"cost": 0.0,
			"skill_bonus": 0,
			"charisma_bonus": 0,
			"band_synergy_bonus": 0.0,
			"desc": "Microfono da karaoke per iniziare a cantare."
		},
		1: {
			"name": "Microfono Stage Pro Cardioid",
			"tier": 1,
			"cost": 400.0,
			"skill_bonus": 5,
			"charisma_bonus": 4,
			"band_synergy_bonus": 3.0,
			"desc": "Capsula resistente al feedback e ottima chiarezza vocale. +5 Voce, +4 Carisma."
		},
		2: {
			"name": "Sistema Wireless UHF Professionale",
			"tier": 2,
			"cost": 1200.0,
			"skill_bonus": 12,
			"charisma_bonus": 10,
			"band_synergy_bonus": 6.0,
			"desc": "Libertà totale di movimento sul palco senza cavi. +12 Voce, +10 Carisma live."
		},
		3: {
			"name": "Microfono Valvolare da Leggenda",
			"tier": 3,
			"cost": 3000.0,
			"skill_bonus": 20,
			"charisma_bonus": 16,
			"band_synergy_bonus": 12.0,
			"desc": "Calore analogico vellutato che incanta platee e critici. +20 Voce, +16 Carisma."
		}
	},
	"keyboards": {
		0: {
			"name": "Tastiera Controller USB Base",
			"tier": 0,
			"cost": 0.0,
			"skill_bonus": 0,
			"charisma_bonus": 0,
			"band_synergy_bonus": 0.0,
			"desc": "Tasti a molla leggeri per abbozzare accordi."
		},
		1: {
			"name": "Sintetizzatore Stage Performance",
			"tier": 1,
			"cost": 500.0,
			"skill_bonus": 5,
			"charisma_bonus": 2,
			"band_synergy_bonus": 3.0,
			"desc": "Suoni di piano e pad d'atmosfera. +5 Tastiere, +3 Armonia di gruppo."
		},
		2: {
			"name": "Workstation Professionale 88 Tasti",
			"tier": 2,
			"cost": 1500.0,
			"skill_bonus": 12,
			"charisma_bonus": 6,
			"band_synergy_bonus": 8.0,
			"desc": "Tasti pesati effetto martelletto e campionamenti orchestrali. +12 Tastiere, +8 Sinergia."
		},
		3: {
			"name": "Synthesizer Analogico Vintage Modulare",
			"tier": 3,
			"cost": 3800.0,
			"skill_bonus": 20,
			"charisma_bonus": 12,
			"band_synergy_bonus": 14.0,
			"desc": "Pura sintesi sottrattiva analogica per muri di suono cosmici. +20 Tastiere, +14 Sinergia."
		}
	}
}

static func get_instrument(category: String, tier: int) -> Dictionary:
	if INSTRUMENTS.has(category) and INSTRUMENTS[category].has(tier):
		return INSTRUMENTS[category][tier]
	return {}

## Comparatore tra strumento posseduto e modello selezionato
static func compare_instruments(category: String, current_tier: int, target_tier: int) -> Dictionary:
	var current: Dictionary = get_instrument(category, current_tier)
	var target: Dictionary = get_instrument(category, target_tier)
	
	if current.is_empty() or target.is_empty():
		return {"valid": false}
		
	var diff_skill: int = target.skill_bonus - current.skill_bonus
	var diff_charisma: int = target.charisma_bonus - current.charisma_bonus
	var diff_synergy: float = target.band_synergy_bonus - current.band_synergy_bonus
	
	var comparison_text: String = ""
	if target_tier == current_tier:
		comparison_text = "Modello attualmente in dotazione."
	elif target_tier < current_tier:
		comparison_text = "Modello inferiore rispetto a quello posseduto."
	else:
		comparison_text = "Miglioramenti rispetto al modello attuale: %+d Livello Tecnica, %+d Carisma, %+.1f%% Sinergia Band." % [
			diff_skill, diff_charisma, diff_synergy
		]
		
	return {
		"valid": true,
		"current": current,
		"target": target,
		"diff_skill": diff_skill,
		"diff_charisma": diff_charisma,
		"diff_synergy": diff_synergy,
		"comparison_text": comparison_text,
		"cost": target.cost
	}
