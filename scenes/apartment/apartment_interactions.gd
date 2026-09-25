# res://scenes/apartment/apartment_interactions.gd
class_name ApartmentInteractions
extends RefCounted

## Catalogo Centralizzato delle Azioni Multiple con Durata per gli Arredi del Loft NYC (V5.6.0)
## Recepisce integralmente le direttive di Luca:
## - Guardaroba (wardrobe): esclusivo cambio look da palco (cambiarsi_il_look);
## - Cassa attrezzi (toolbox): rimossa apertura Upgrades Hub, orientata a manutenzione e cavi;
## - Durata temporale esplicita (duration_seconds) per ogni azione attiva.

static func get_actions_for_prop(prop_id: String) -> Array[Dictionary]:
	match prop_id:
		"couch":
			return [
				{
					"id": "couch_inspect",
					"title": "Esamina divano",
					"description": "Osserva il divano vissuto con le toppe rock e i cuscini sfatti.",
					"duration_seconds": 0.0,
					"type": "inspect",
					"dialogue_text": "Divano vissuto con toppe punk e cuscini sfatti sotto la luce del sole. Ottimo per distendersi e smaltire lo stress."
				},
				{
					"id": "couch_sit",
					"title": "Relax da divano",
					"description": "Distenditi qualche istante per sciogliere la tensione muscolare (-12 Stress, +5 Morale, +5 Energia).",
					"duration_seconds": 5.0,
					"type": "action",
					"energy_delta": 5,
					"stress_delta": -12,
					"morale_delta": 5,
					"money_cost": 0.0,
					"result_message": "Ti rilassi sul divano del loft. Tensione allentata e mente rigenerata (-12 Stress, +5 Morale, +5 Energia)!"
				},
				{
					"id": "couch_nap",
					"title": "Pisolino",
					"description": "Un power nap rigenerante per ricaricare le batterie (+20 Energia, -10 Stress).",
					"duration_seconds": 15.0,
					"type": "action",
					"energy_delta": 20,
					"stress_delta": -10,
					"morale_delta": 0,
					"money_cost": 0.0,
					"advances_time": true,
					"result_message": "Pisolino completato sul divano! Ti risvegli fresco e rinvigorito (+20 Energia, -10 Stress)."
				},
				{
					"id": "couch_jam",
					"title": "Jam acustica",
					"description": "Strimpella accordi in libertà alla ricerca di ispirazione (+10 XP Composizione, 35% Scintilla).",
					"duration_seconds": 10.0,
					"type": "action",
					"energy_delta": -5,
					"stress_delta": -5,
					"morale_delta": 10,
					"money_cost": 0.0,
					"xp_amount": 10.0,
					"xp_skill": "composition",
					"inspiration_chance": 0.35,
					"result_message": "Sessione acustica rilassante sul divano (+10 XP Composizione, +10 Morale)!"
				},
				{
					"id": "couch_study_manual",
					"title": "Studio manuale teorico",
					"description": "Leggi un testo fondamentale per apprendere le basi o sbloccare una nuova competenza da zero (-12 Energia, +4 Stress, +2 Morale, +35 XP).",
					"duration_seconds": 10.0,
					"type": "study_picker",
					"study_method": 0,
					"energy_delta": -12,
					"stress_delta": 4,
					"morale_delta": 2,
					"money_cost": 0.0,
					"xp_amount": 35.0,
					"xp_skill": "comp_theory",
					"result_message": "Studio del manuale teorico completato sul divano (+35 XP)!"
				}
			]

		"guitar":
			return [
				{
					"id": "guitar_inspect",
					"title": "Esamina chitarra",
					"description": "Ispeziona chitarra, manico, pickup e amplificatore vintage.",
					"duration_seconds": 0.0,
					"type": "inspect",
					"dialogue_text": "Chitarra elettrica su supporto e testata valvolare. Posso comporre un nuovo brano o allenarmi sui riff!"
				},
				{
					"id": "guitar_create",
					"title": "Componi brano",
					"description": "Apri il Song Creator per scrivere e registrare una nuova traccia.",
					"duration_seconds": 0.0,
					"type": "modal",
					"modal_name": "SongCreator"
				},
				{
					"id": "guitar_practice",
					"title": "Scale e riff alla chitarra",
					"description": "Pratica tecnica per affinare scale, bending e riff alla chitarra (+20 XP Chitarra, -10 Energia).",
					"duration_seconds": 10.0,
					"type": "action",
					"energy_delta": -10,
					"stress_delta": 3,
					"morale_delta": 5,
					"money_cost": 0.0,
					"xp_amount": 20.0,
					"xp_skill": "skill_guitar",
					"result_message": "Esercizio alla chitarra completato: +20 XP Chitarra, -10 Energia, +3 Stress, +5 Morale!"
				},
				{
					"id": "guitar_mentor_lesson",
					"title": "Lezione di chitarra col Maestro",
					"description": "Masterclass intensiva di chitarra a domicilio con un maestro professionista (Costo 50.00 €, +75 XP Chitarra, -22 Energia).",
					"duration_seconds": 12.0,
					"type": "action",
					"energy_delta": -22,
					"stress_delta": 8,
					"morale_delta": 10,
					"money_cost": 50.0,
					"xp_amount": 75.0,
					"xp_skill": "skill_guitar",
					"result_message": "Lezione di chitarra col Maestro completata: +75 XP Chitarra, -50.00 €, -22 Energia, +10 Morale!"
				},
				{
					"id": "guitar_tune",
					"title": "Accorda e pulisci",
					"description": "Controlla l'accordatura fine e lucida il corpo della chitarra (+5 Morale, manutenzione).",
					"duration_seconds": 5.0,
					"type": "action",
					"energy_delta": -2,
					"stress_delta": -5,
					"morale_delta": 5,
					"money_cost": 0.0,
					"result_message": "Chitarra accordata al millesimo e corde pulite (+5 Morale, -5 Stress)!"
				}
			]

		"kitchen":
			return [
				{
					"id": "kitchen_inspect",
					"title": "Esamina cucina",
					"description": "Guarda il bancone, la moka e le tazze da caffè espresso.",
					"duration_seconds": 0.0,
					"type": "inspect",
					"dialogue_text": "Cucina con pensili in legno e macchina dell'espresso fumante. Il carburante indispensabile per ogni rocker!"
				},
				{
					"id": "kitchen_espresso",
					"title": "Prepara espresso",
					"description": "Un espresso nero concentrato per ricaricare le energie (+15 Energia, -5 Stress).",
					"duration_seconds": 5.0,
					"type": "action",
					"energy_delta": 15,
					"stress_delta": -5,
					"morale_delta": 0,
					"money_cost": 0.0,
					"result_message": "Espresso bollente sorseggiato nella cucina del loft. Energia ripristinata (+15 Energia, -5 Stress)!"
				},
				{
					"id": "kitchen_snack",
					"title": "Spuntino veloce",
					"description": "Panino sostanzioso dal frigo (Costo 3.50 €, +25 Energia, +5 Morale).",
					"duration_seconds": 10.0,
					"type": "action",
					"energy_delta": 25,
					"stress_delta": -5,
					"morale_delta": 5,
					"money_cost": 3.50,
					"result_message": "Spuntino abbondante e nutriente consumato (+25 Energia, +5 Morale, -3.50 €)!"
				},
				{
					"id": "kitchen_clean",
					"title": "Riordina cucina",
					"description": "Lava le tazzine e sistema il bancone (+10 Morale domestico).",
					"duration_seconds": 10.0,
					"type": "action",
					"energy_delta": -5,
					"stress_delta": -5,
					"morale_delta": 10,
					"money_cost": 0.0,
					"result_message": "Cucina ripulita e splendente. L'ordine mentale fa bene al morale (+10 Morale)!"
				}
			]

		"turntable":
			return [
				{
					"id": "turntable_inspect",
					"title": "Esamina vinili",
					"description": "Sfoglia i vinili storici rock, punk e psichedelia.",
					"duration_seconds": 0.0,
					"type": "inspect",
					"dialogue_text": "Giradischi retrò e vinili d'epoca sotto l'insegna GIGS. Una miniera d'oro per l'ispirazione artistica!"
				},
				{
					"id": "turntable_listen",
					"title": "Ascolta vinile",
					"description": "Ascolto analogico ad alta fedeltà (+20 Morale, -10 Stress, 35% Scintilla Creativa).",
					"duration_seconds": 12.0,
					"type": "action",
					"energy_delta": 0,
					"stress_delta": -10,
					"morale_delta": 20,
					"money_cost": 0.0,
					"inspiration_chance": 0.35,
					"xp_amount": 10.0,
					"xp_skill": "composition",
					"result_message": "Il calore analogico del vinile risuona nel loft, sciogliendo la tensione (+20 Morale, -10 Stress)!"
				},
				{
					"id": "turntable_listen_rock",
					"title": "Vinile Classic Rock",
					"description": "Ascolto rock energico (+20 Morale, -10 Stress, 35% Scintilla, +25 XP Rock Classico).",
					"duration_seconds": 12.0,
					"type": "action",
					"energy_delta": 0,
					"stress_delta": -10,
					"morale_delta": 20,
					"money_cost": 0.0,
					"inspiration_chance": 0.35,
					"xp_amount": 25.0,
					"xp_skill": "genre_rock",
					"result_message": "Ascolto Classic Rock completato: sound energico assorbito (+25 XP Rock Classico, +20 Morale, -10 Stress)!"
				},
				{
					"id": "turntable_listen_metal",
					"title": "Vinile Heavy Metal",
					"description": "Riff veloci e doppia cassa tellurica (+20 Morale, -10 Stress, 35% Scintilla, +25 XP Heavy Metal).",
					"duration_seconds": 12.0,
					"type": "action",
					"energy_delta": 0,
					"stress_delta": -10,
					"morale_delta": 20,
					"money_cost": 0.0,
					"inspiration_chance": 0.35,
					"xp_amount": 25.0,
					"xp_skill": "genre_metal",
					"result_message": "Ascolto Heavy Metal completato: riff potenti e attacco metallico (+25 XP Heavy Metal)!"
				},
				{
					"id": "turntable_listen_blues",
					"title": "Vinile Blues & Roots",
					"description": "Feeling viscerale e pentatoniche (+20 Morale, -10 Stress, 35% Scintilla, +25 XP Blues & Roots).",
					"duration_seconds": 12.0,
					"type": "action",
					"energy_delta": 0,
					"stress_delta": -10,
					"morale_delta": 20,
					"money_cost": 0.0,
					"inspiration_chance": 0.35,
					"xp_amount": 25.0,
					"xp_skill": "genre_blues",
					"result_message": "Ascolto Blues completato: calore e malinconia viscerale (+25 XP Blues & Roots)!"
				},
				{
					"id": "turntable_listen_jazz",
					"title": "Vinile Jazz & Fusion",
					"description": "Accordi estesi e tempi dispari (+20 Morale, -10 Stress, 35% Scintilla, +25 XP Jazz & Fusion).",
					"duration_seconds": 12.0,
					"type": "action",
					"energy_delta": 0,
					"stress_delta": -10,
					"morale_delta": 20,
					"money_cost": 0.0,
					"inspiration_chance": 0.35,
					"xp_amount": 25.0,
					"xp_skill": "genre_jazz",
					"result_message": "Ascolto Jazz completato: armonie avanzate metabolizzate (+25 XP Jazz & Fusion)!"
				},
				{
					"id": "turntable_study",
					"title": "Studio produzione",
					"description": "Ascolto analitico delle frequenze e degli arrangiamenti (+25 XP Produzione).",
					"duration_seconds": 10.0,
					"type": "action",
					"energy_delta": -5,
					"stress_delta": 0,
					"morale_delta": 5,
					"money_cost": 0.0,
					"xp_amount": 25.0,
					"xp_skill": "tech_production",
					"result_message": "Analisi critica completata: nuove tecniche di missaggio apprese (+25 XP Produzione)!"
				}
			]

		"bed":
			return [
				{
					"id": "bed_inspect",
					"title": "Esamina letto",
					"description": "Lenzuola stropicciate, cuscini vissuti e spartiti sparsi.",
					"duration_seconds": 0.0,
					"type": "inspect",
					"dialogue_text": "Letto singolo con lenzuola stropicciate. Qui posso dormire fino a domani mattina o riposare per far avanzare l'ora."
				},
				{
					"id": "bed_sleep",
					"title": "Dormi fino a domani",
					"description": "Chiudi la giornata e vai a dormire fino alle 06:00 del mattino successivo.",
					"duration_seconds": 0.0,
					"type": "sleep"
				},
				{
					"id": "bed_rest",
					"title": "Riposo breve",
					"description": "Riposati sul letto e avanza alla fascia oraria successiva (+15 Energia).",
					"duration_seconds": 5.0,
					"type": "advance_period",
					"energy_delta": 15,
					"stress_delta": -5,
					"result_message": "Riposo completato. Passaggio alla fascia oraria successiva (+15 Energia, -5 Stress)."
				},
				{
					"id": "bed_make",
					"title": "Rifai il letto",
					"description": "Piccola disciplina mattutina per iniziare bene la giornata (+5 Morale).",
					"duration_seconds": 5.0,
					"type": "action",
					"energy_delta": -2,
					"stress_delta": -3,
					"morale_delta": 5,
					"money_cost": 0.0,
					"result_message": "Letto rifatto e spartiti riordinati (+5 Morale, -3 Stress)!"
				}
			]

		"arcade":
			return [
				{
					"id": "arcade_inspect",
					"title": "Esamina cabinato",
					"description": "Monitor CRT a 15 KHz, joystick a palla e pulsanti clicky anni '80.",
					"duration_seconds": 0.0,
					"type": "inspect",
					"dialogue_text": "Cabinato arcade vintage anni '80 con monitor a tubo catodico. Una partita veloce per svagarsi e staccare la spina!"
				},
				{
					"id": "arcade_play",
					"title": "Partita retrò",
					"description": "Fai una partita veloce al cabinato per staccare (+10 Morale, -5 Stress).",
					"duration_seconds": 10.0,
					"type": "action",
					"energy_delta": -3,
					"stress_delta": -5,
					"morale_delta": 10,
					"money_cost": 0.0,
					"result_message": "Partita arcade completata! Morale rinvigorito (+10 Morale, -5 Stress)!"
				},
				{
					"id": "arcade_challenge",
					"title": "Sfida il record",
					"description": "Sessione intensa per battere l'high score (50% chance +25 Morale / 50% -5 Morale).",
					"duration_seconds": 15.0,
					"type": "action",
					"energy_delta": -8,
					"stress_delta": 5,
					"morale_delta": 25,
					"money_cost": 0.0,
					"is_gamble": true,
					"result_message": "Nuovo record stabilito sul cabinato vintage (+25 Morale)!"
				}
			]

		"wardrobe":
			# Recepimento direttiva Luca: ESCLUSIVO CAMBIO LOOK
			return [
				{
					"id": "wardrobe_inspect",
					"title": "Esamina abiti",
					"description": "Osserva chiodi in pelle, t-shirt vintage e accessori da palco.",
					"duration_seconds": 0.0,
					"type": "inspect",
					"dialogue_text": "Libreria e guardaroba in legno con toppe e giacche da rocker. Qui c'è tutto l'outfit per salire sul palco!"
				},
				{
					"id": "wardrobe_change_look",
					"title": "Cambiati il look",
					"description": "Prova un nuovo abbinamento di scena per ricaricare la fiducia (+10 Morale).",
					"duration_seconds": 8.0,
					"type": "action",
					"energy_delta": -2,
					"stress_delta": -5,
					"morale_delta": 10,
					"money_cost": 0.0,
					"result_message": "Outfit da rocker rinnovato! Giacca in pelle impeccabile e carica al massimo (+10 Morale)!"
				}
			]

		"toolbox":
			# Recepimento direttiva Luca: RIMOSSO UPGRADES HUB, MANUTENZIONE & SETUP
			return [
				{
					"id": "toolbox_inspect",
					"title": "Esamina attrezzi",
					"description": "Chiavi a brugola, cavi jack schermati, saldatore a stagno e pedali.",
					"duration_seconds": 0.0,
					"type": "inspect",
					"dialogue_text": "Cassa attrezzi in metallo rosso con cavi jack, attrezzi di precisione e ricambi per chitarra."
				},
				{
					"id": "toolbox_check",
					"title": "Controllo cavi/jack",
					"description": "Verifica l'integrità dei contatti e l'assenza di fruscii (+10 XP Tecnico Suono Live).",
					"duration_seconds": 5.0,
					"type": "action",
					"energy_delta": -2,
					"stress_delta": -2,
					"morale_delta": 5,
					"money_cost": 0.0,
					"xp_amount": 10.0,
					"xp_skill": "tech_live_sound",
					"result_message": "Cavi jack e connessioni testati: nessun ronzio o dispersione (+10 XP Tecnico Suono Live, +5 Morale)!"
				},
				{
					"id": "toolbox_maintain",
					"title": "Set-up chitarra",
					"description": "Pulisci i potenziometri e regola l'action del manico (-5 Energia, +10 Morale, +15 XP Liuteria).",
					"duration_seconds": 10.0,
					"type": "action",
					"energy_delta": -5,
					"stress_delta": -5,
					"morale_delta": 10,
					"money_cost": 0.0,
					"xp_amount": 15.0,
					"xp_skill": "tech_lutherie",
					"result_message": "Set-up chitarra completato: action perfetta e tastiera pulita (-5 Energia, +10 Morale, +15 XP Liuteria)!"
				}
			]

		"door":
			return [
				{
					"id": "door_inspect",
					"title": "Esamina skyline NYC",
					"description": "Guarda oltre la soglia del loft verso le strade di Manhattan.",
					"duration_seconds": 0.0,
					"type": "inspect",
					"dialogue_text": "La porta d'ingresso del loft che si affaccia sulla metropoli di New York. Esci per raggiungere i locali live o partire in tour!"
				},
				{
					"id": "door_concert",
					"title": "Concerti nei locali",
					"description": "Seleziona un locale a New York, prepara la scaletta e suona dal vivo.",
					"duration_seconds": 0.0,
					"type": "modal",
					"modal_name": "LiveConcert"
				},
				{
					"id": "door_tour",
					"title": "Pianifica tournée",
					"description": "Organizza le tappe interurbane del tour con la tua band.",
					"duration_seconds": 0.0,
					"type": "modal",
					"modal_name": "TourModal"
				},
				{
					"id": "door_travel",
					"title": "Viaggia in altra città",
					"description": "Prendi un treno o aereo per visitare un'altra città del circuito.",
					"duration_seconds": 0.0,
					"type": "modal",
					"modal_name": "TravelModal"
				},
				{
					"id": "door_festivals",
					"title": "Grandi Festival Estivi",
					"description": "Accedi al circuito dei grandi festival open air estivi.",
					"duration_seconds": 0.0,
					"type": "modal",
					"modal_name": "FestivalModal"
				},
				{
					"id": "door_academy_course",
					"title": "Corso in Accademia",
					"description": "Frequenta una masterclass pomeridiana al conservatorio su una competenza a scelta (Costo 30.00 €, -18 Energia, +5 Morale, +50 XP).",
					"duration_seconds": 12.0,
					"type": "study_picker",
					"study_method": 1,
					"energy_delta": -18,
					"stress_delta": 0,
					"morale_delta": 5,
					"money_cost": 30.0,
					"xp_amount": 50.0,
					"xp_skill": "comp_theory",
					"result_message": "Masterclass in Accademia completata con profitto (+50 XP, -30.00 €)!"
				}
			]

		"stereo":
			return [
				{
					"id": "stereo_inspect",
					"title": "Esamina monitor",
					"description": "Diffusori acustici da studio ad alta definizione sonora.",
					"duration_seconds": 0.0,
					"type": "inspect",
					"dialogue_text": "Impianto hi-fi e diffusori monitor da studio. La colonna sonora perfetta per caricare il loft di pura energia rock!"
				},
				{
					"id": "stereo_toggle",
					"title": "Accendi / Spegni Hi-Fi",
					"description": "Attiva o disattiva la musica in diffusione nel loft.",
					"duration_seconds": 0.0,
					"type": "toggle"
				},
				{
					"id": "stereo_radio",
					"title": "Radio Rock",
					"description": "Sintonizzati sull'emittente rock cittadina per scoprire le novità (+5 Morale).",
					"duration_seconds": 8.0,
					"type": "action",
					"energy_delta": 0,
					"stress_delta": -5,
					"morale_delta": 5,
					"money_cost": 0.0,
					"result_message": "Sintonizzato sulla radio rock locale: novità musicali e buona carica (+5 Morale, -5 Stress)!"
				}
			]

		_:
			return []
