# GDD 2.0 / SP-12: Sottosistema Social Media, Fan Engagement & Viralità
class_name SocialMediaSystem
extends RefCounted

## Riferimento ai dati giocatore
var player_data: PlayerData

## Riferimento ai dati calendario
var calendar_data: CalendarData

## Riferimento opzionale a BandSystem
var band_system: RefCounted

## Riferimento opzionale a MusicSystem
var music_system: RefCounted

## Base totale dei follower del canale della band
var total_followers: int = 150

## Moltiplicatore Hype e Viralità settimanale [1.0 - 2.5]
var weekly_buzz: float = 1.0

## Cronologia dei post pubblicati (ultimi post registrati)
var post_history: Array[SocialPostData] = []

## Dati della controversia online attiva (se presente)
var active_controversy: Dictionary = {}

## Contatore dei post pubblicati nella giornata corrente
var posts_published_today: int = 0

## Limite massimo di pubblicazioni giornaliere per evitare saturazione fan
var max_posts_per_day: int = 3

func _init(
	p_player: PlayerData = null,
	p_calendar: CalendarData = null,
	p_band: RefCounted = null,
	p_music: RefCounted = null
) -> void:
	player_data = p_player
	calendar_data = p_calendar
	band_system = p_band
	music_system = p_music

## Verifica se è possibile pubblicare un determinato post
func can_publish_post(post_type: int, song_id: String = "") -> Dictionary:
	var energy_cost: int = get_energy_cost_for_type(post_type)
	
	if player_data and player_data.energy < energy_cost:
		return {
			"allowed": false,
			"reason": "energy_insufficient",
			"cost_energy": energy_cost,
			"message": "Energia insufficiente (%d richiesta, %d attuale)." % [energy_cost, player_data.energy if player_data else 0]
		}
		
	if posts_published_today >= max_posts_per_day:
		return {
			"allowed": false,
			"reason": "daily_limit_reached",
			"cost_energy": energy_cost,
			"message": "Hai già pubblicato %d post oggi. I tuoi follower sono saturi, riprova domani." % max_posts_per_day
		}
		
	if has_active_controversy():
		return {
			"allowed": false,
			"reason": "controversy_active",
			"cost_energy": energy_cost,
			"message": "C'è una polemica online in corso! Devi prima affrontarla premendo 'R' prima di pubblicare nuovi post."
		}
		
	if post_type == Enums.SocialPostType.TRACK_TEASER:
		if not player_data or player_data.songs.is_empty():
			return {
				"allowed": false,
				"reason": "no_songs_available",
				"cost_energy": energy_cost,
				"message": "Non hai brani nel catalogo della band per creare un teaser."
			}
		if not song_id.is_empty():
			var found: bool = false
			for s in player_data.songs:
				if s.id == song_id:
					found = true
					break
			if not found:
				return {
					"allowed": false,
					"reason": "song_not_found",
					"cost_energy": energy_cost,
					"message": "Il brano selezionato per il teaser non esiste nel catalogo."
				}
				
	return {
		"allowed": true,
		"reason": "ok",
		"cost_energy": energy_cost,
		"message": "Pronto per la pubblicazione."
	}

## Costo in energia per tipologia di post
func get_energy_cost_for_type(post_type: int) -> int:
	match post_type:
		Enums.SocialPostType.PRACTICE_CLIP:
			return 10
		Enums.SocialPostType.TRACK_TEASER:
			return 15
		Enums.SocialPostType.BEHIND_THE_SCENES:
			return 10
		Enums.SocialPostType.PROVOCATION:
			return 15
		_:
			return 10

## Pubblica un nuovo contenuto social sul canale della band
func publish_post(post_type: int, song_id: String = "", custom_caption: String = "") -> Dictionary:
	var check := can_publish_post(post_type, song_id)
	if not check.get("allowed", false):
		return {"success": false, "reason": check.get("reason", "error"), "message": check.get("message", "")}
		
	var energy_cost: int = check.get("cost_energy", 10)
	if player_data:
		player_data.consume_energy(energy_cost)
		
	var day_num: int = calendar_data.day_number if calendar_data else 1
	var charisma_val: float = float(player_data.get_skill_level("charisma")) if player_data else 10.0
	var pop_val: float = player_data.popularity if player_data else 5.0
	
	# Risoluzione brano per teaser
	var linked_song: SongData = null
	var song_title: String = ""
	if post_type == Enums.SocialPostType.TRACK_TEASER:
		if not song_id.is_empty():
			for s in player_data.songs:
				if s.id == song_id:
					linked_song = s
					break
		if not linked_song and player_data and not player_data.songs.is_empty():
			linked_song = player_data.songs[0]
		if linked_song:
			song_id = linked_song.id
			song_title = linked_song.title
			
	# Generazione didascalia procedurale se non fornita
	var final_caption: String = custom_caption
	if final_caption.is_empty():
		final_caption = _generate_default_caption(post_type, song_title)
		
	# 1. Calcolo Visualizzazioni Base
	var base_views: float = (float(total_followers) * 0.45) + (pop_val * 140.0) + float(randi_range(35, 120))
	var charisma_mult: float = 1.0 + (charisma_val * 0.015) # +1.5% per punto di carisma
	var type_view_mult: float = 1.0
	
	match post_type:
		Enums.SocialPostType.PRACTICE_CLIP:
			type_view_mult = 1.05
		Enums.SocialPostType.TRACK_TEASER:
			type_view_mult = 1.25
			if linked_song and linked_song.quality_score > 60.0:
				type_view_mult += 0.35
		Enums.SocialPostType.BEHIND_THE_SCENES:
			type_view_mult = 1.15
			if player_data and not player_data.band_members.is_empty():
				for m in player_data.band_members:
					if m.personality == Enums.BandPersonality.WILD_PARTY:
						type_view_mult += 0.25
						break
		Enums.SocialPostType.PROVOCATION:
			type_view_mult = 1.80
			
	var calc_views: int = int(round(base_views * charisma_mult * type_view_mult))
	
	# 2. Determinazione Viralità
	var viral_chance: float = 0.06 + (charisma_val * 0.005)
	if post_type == Enums.SocialPostType.PROVOCATION:
		viral_chance += 0.18
	elif post_type == Enums.SocialPostType.TRACK_TEASER and linked_song and linked_song.quality_score >= 70.0:
		viral_chance += 0.12
		
	var is_viral: bool = randf() <= viral_chance
	if is_viral:
		calc_views = int(round(float(calc_views) * randf_range(2.5, 4.0)))
		
	# 3. Calcolo Like, Condivisioni e Nuovi Follower
	var like_rate: float = randf_range(0.09, 0.18)
	var calc_likes: int = maxi(1, int(round(float(calc_views) * like_rate)))
	
	var share_rate: float = randf_range(0.04, 0.12) if not is_viral else randf_range(0.15, 0.30)
	var calc_shares: int = maxi(0, int(round(float(calc_likes) * share_rate)))
	
	var follower_rate: float = randf_range(0.02, 0.05) if not is_viral else randf_range(0.06, 0.12)
	var new_foll: int = maxi(1, int(round(float(calc_views) * follower_rate)))
	
	# 4. Generazione Commenti Procedurali
	var comments: Array[String] = _generate_comments_sample(post_type, is_viral, song_title)
	
	# 5. Creazione Post Dati
	var new_post := SocialPostData.new(
		"",
		post_type,
		day_num,
		final_caption,
		song_id,
		song_title
	)
	new_post.views = calc_views
	new_post.likes = calc_likes
	new_post.shares = calc_shares
	new_post.new_followers = new_foll
	new_post.is_viral = is_viral
	new_post.comments_sample = comments
	
	# 6. Aggiornamento Metriche e Riverbero Fan
	total_followers += new_foll
	
	# Conversione in fan reali di gioco (circa 40% dei follower social)
	var real_fan_gain: int = maxi(1, int(round(float(new_foll) * 0.40)))
	if player_data:
		player_data.add_fans(real_fan_gain)
		
	# Riverbero nella città corrente se presente
	if GameManager and GameManager.travel_system:
		var cur_city_id: int = GameManager.travel_system.current_city_id
		GameManager.travel_system.add_fans_in_city(cur_city_id, real_fan_gain)
		
	# Incremento Hype Buzz
	var buzz_delta: float = 0.08
	if post_type == Enums.SocialPostType.TRACK_TEASER:
		buzz_delta = 0.14
		if linked_song:
			linked_song.quality_score = clampf(linked_song.quality_score + 1.0, 0.0, 100.0)
	elif post_type == Enums.SocialPostType.PROVOCATION:
		buzz_delta = 0.22
	if is_viral:
		buzz_delta += 0.25
		
	weekly_buzz = clampf(weekly_buzz + buzz_delta, 1.0, 2.5)
	
	# 7. Verifica Rischio Polemica / Controversia Online
	var triggered_controversy: bool = false
	if post_type == Enums.SocialPostType.PROVOCATION:
		var controversy_chance: float = 0.32
		if randf() <= controversy_chance:
			triggered_controversy = true
			_trigger_controversy(new_post, "Dichiarazione sfrontata che ha indignato parte del pubblico musicale")
	elif post_type == Enums.SocialPostType.BEHIND_THE_SCENES:
		# Se la band ha tensione critica, possibile leak
		if player_data and not player_data.band_members.is_empty():
			var avg_tension: float = 0.0
			for m in player_data.band_members:
				avg_tension += m.tension
			avg_tension /= float(player_data.band_members.size())
			if avg_tension >= 65.0 and randf() <= 0.25:
				triggered_controversy = true
				_trigger_controversy(new_post, "Video del backstage dove emergono accesi litigi interni tra i membri")
				
	new_post.is_controversial = triggered_controversy
	
	# Salvataggio in cronologia post
	post_history.insert(0, new_post)
	if post_history.size() > 50:
		post_history.resize(50)
		
	posts_published_today += 1
	
	# Notifiche e Segnali EventBus
	if EventBus:
		EventBus.social_post_published.emit(new_post)
		EventBus.social_buzz_updated.emit(weekly_buzz)
		
	var speech_summary: String = "Post pubblicato! Tipo: %s. Visualizzazioni: %d, Mi piace: %d, Nuovi follower: %d. Buzz: %.2fx." % [
		Enums.get_social_post_type_name(post_type),
		calc_views,
		calc_likes,
		new_foll,
		weekly_buzz
	]
	if is_viral:
		speech_summary += " CLAMOROSO: Il post è diventato virale in rete!"
	if triggered_controversy:
		speech_summary += " ATTENZIONE: Il post ha innescato una shitstorm online! Premi R per risolverla."
		
	return {
		"success": true,
		"post": new_post,
		"views": calc_views,
		"likes": calc_likes,
		"shares": calc_shares,
		"new_followers": new_foll,
		"real_fans_added": real_fan_gain,
		"is_viral": is_viral,
		"is_controversial": triggered_controversy,
		"weekly_buzz": weekly_buzz,
		"message": speech_summary
	}

## Innesca una polemica online / shitstorm
func _trigger_controversy(origin_post: SocialPostData, topic: String) -> void:
	active_controversy = {
		"id": "contro_%d_%d" % [Time.get_ticks_msec(), randi() % 1000],
		"post_id": origin_post.id,
		"topic": topic,
		"intensity": randi_range(1, 3),
		"origin_caption": origin_post.caption,
		"day_started": calendar_data.day_number if calendar_data else 1
	}
	if EventBus:
		EventBus.social_controversy_triggered.emit(active_controversy)

## Risolve la controversia online con una delle 3 opzioni strategiche
## 0 = Ignora (Silenzio stampa), 1 = Scuse pubbliche, 2 = Raddoppia la posta (Double down)
func resolve_controversy(choice: int) -> Dictionary:
	if not has_active_controversy():
		return {"success": false, "reason": "no_active_controversy", "message": "Nessuna polemica online in corso da risolvere."}
		
	var topic: String = str(active_controversy.get("topic", "Polemica sui social"))
	var outcome_msg: String = ""
	var follower_delta: int = 0
	var rep_delta: float = 0.0
	var stress_delta: int = 0
	var is_triumph: bool = false
	
	match choice:
		0:
			# 0 = Ignora / Silenzio stampa
			follower_delta = -maxi(1, int(round(float(total_followers) * 0.02)))
			rep_delta = 0.0
			stress_delta = 6
			outcome_msg = "Hai ignorato la bufera. Il rumore scema lentamente, ma hai perso il 2%% dei follower (%d) per mancata risposta." % abs(follower_delta)
		1:
			# 1 = Scuse formali
			follower_delta = -maxi(1, int(round(float(total_followers) * 0.04)))
			rep_delta = 3.5
			stress_delta = -4
			outcome_msg = "Hai pubblicato scuse formali. La reputazione generale sale (+3.5), anche se hai deluso parte dei follower più underground (-4%%)."
		2:
			# 2 = Raddoppia la posta (Double Down)
			if randf() <= 0.50:
				# Trionfo virale ribelle
				is_triumph = true
				follower_delta = maxi(5, int(round(float(total_followers) * 0.16)))
				rep_delta = 4.0
				stress_delta = -5
				weekly_buzz = 2.5
				outcome_msg = "TRIONFO VIRALE! Il tuo contrattacco senza filtri ha entusiasmato la community. Follower aumentati del 16%% (+%d) e buzz al massimo (2.50x)!" % follower_delta
			else:
				# Boicottaggio e disastro mediatico
				follower_delta = -maxi(5, int(round(float(total_followers) * 0.09)))
				rep_delta = -7.0
				stress_delta = 16
				weekly_buzz = maxf(1.0, weekly_buzz * 0.8)
				outcome_msg = "DISASTRO MEDIATICO! I media e i fan ti hanno attaccato duramente. Follower persi (-9%%), reputazione calata (-7.0) e stress elevato (+16)."
		_:
			return {"success": false, "reason": "invalid_choice", "message": "Scelta non valida (0=Ignora, 1=Scuse, 2=Raddoppia)."}
			
	# Applicazione effetti al giocatore
	total_followers = maxi(10, total_followers + follower_delta)
	if player_data:
		if rep_delta != 0.0:
			player_data.popularity = clampf(player_data.popularity + rep_delta, 0.0, 100.0)
		if stress_delta > 0:
			player_data.add_stress(stress_delta)
		elif stress_delta < 0:
			player_data.reduce_stress(abs(stress_delta))
			
	var resolved_data := active_controversy.duplicate()
	active_controversy.clear()
	
	var result := {
		"success": true,
		"choice": choice,
		"topic": topic,
		"follower_delta": follower_delta,
		"rep_delta": rep_delta,
		"stress_delta": stress_delta,
		"is_triumph": is_triumph,
		"total_followers": total_followers,
		"weekly_buzz": weekly_buzz,
		"message": outcome_msg
	}
	
	if EventBus:
		EventBus.social_controversy_resolved.emit(choice, result)
		EventBus.social_buzz_updated.emit(weekly_buzz)
		
	return result

## Decadimento notturno e reset delle metriche giornaliere
func process_daily_decay() -> void:
	posts_published_today = 0
	
	# Decadimento 10% del buzz hype fisiologico
	weekly_buzz = maxf(1.0, snappedf(weekly_buzz * 0.90, 0.01))
	
	if EventBus:
		EventBus.social_buzz_updated.emit(weekly_buzz)

## Ritorna il moltiplicatore buzz live per i concerti [1.0 - 2.5]
func get_live_buzz_multiplier() -> float:
	return clampf(weekly_buzz, 1.0, 2.5)

## Controlla se c'è una controversia attiva non risolta
func has_active_controversy() -> bool:
	return not active_controversy.is_empty()

## Genera una didascalia procedurale in base al tipo di post
func _generate_default_caption(post_type: int, song_title: String) -> String:
	match post_type:
		Enums.SocialPostType.PRACTICE_CLIP:
			var clip_pool: Array[String] = [
				"Nuovi riff in sala prove! Il sudore prima del palco.",
				"Provando gli accordi del finale fino allo sfinimento.",
				"Sessione notturna tra cavi, amplificatori a palla e accordi distorti.",
				"Chiudiamo la sequenza ritmica. Ci vediamo ai live!"
			]
			return clip_pool[randi() % clip_pool.size()]
		Enums.SocialPostType.TRACK_TEASER:
			if not song_title.is_empty():
				return "Anteprima esclusiva di '%s'! Diteci nei commenti cosa ne pensate." % song_title
			return "Un piccolo assaggio di cosa sta bollendo in pentola per il prossimo brano..."
		Enums.SocialPostType.BEHIND_THE_SCENES:
			var bts_pool: Array[String] = [
				"Vita da furgone tra una città e l'altra. Tranci di pizza e risate.",
				"Camerini prima dello show: accordatori, ansia e caffè freddo.",
				"Quando il navigatore sbaglia strada e finiamo in mezzo alla campagna.",
				"Smontaggio palco all'una di notte. L'altra faccia del rock and roll."
			]
			return bts_pool[randi() % bts_pool.size()]
		Enums.SocialPostType.PROVOCATION:
			var prov_pool: Array[String] = [
				"Le classifiche radiofoniche oggi sono morte. La vera musica siamo noi.",
				"Chi fa pop di plastica dovrebbe scendere dal palco e lasciare spazio alle chitarre vere.",
				"Ci dicono che siamo troppo rumorosi. Noi alziamo il volume al doppio.",
				"Dedicato a chi diceva che non saremmo mai arrivati fin qui. Salutateci dai divani."
			]
			return prov_pool[randi() % prov_pool.size()]
		_:
			return "Nuovo aggiornamento dalla band!"

## Genera un set procedurale di commenti del pubblico
func _generate_comments_sample(post_type: int, is_viral: bool, song_title: String) -> Array[String]:
	var result: Array[String] = []
	var comments_pool: Array[String] = []
	
	if is_viral:
		comments_pool = [
			"Questo video mi è apparso nei Per Te ed è una bomba assurda!",
			"Condiviso subito con tutti i miei amici, spaccate!",
			"Mamma mia che sound potente, quando venite nella mia città?",
			"Algoritmo grazie di avermi fatto scoprire questa band!"
		]
	else:
		match post_type:
			Enums.SocialPostType.PRACTICE_CLIP:
				comments_pool = [
					"Quel riff a metà è pazzesco, bravi!",
					"Bello vedere quanto lavoro c'è dietro ogni pezzo.",
					"Il batterista è una macchina da guerra!"
				]
			Enums.SocialPostType.TRACK_TEASER:
				comments_pool = [
					"Se il singolo '%s' esce così, lo metto in loop tutto il giorno!" % song_title,
					"Non vedo l'ora che esca su tutte le piattaforme!",
					"Produzione pulita e melodia che entra in testa al primo ascolto."
				]
			Enums.SocialPostType.BEHIND_THE_SCENES:
				comments_pool = [
					"Siete fantastici anche fuori dal palco!",
					"Troppo simpatici, vi seguo dall'inizio.",
					"La vera vita da band, autenticità pura senza filtri."
				]
			Enums.SocialPostType.PROVOCATION:
				comments_pool = [
					"Parole dure ma sacrosante, qualcuno doveva pur dirlo!",
					"Calma con l'ego però... prima fate i numeri poi parlate.",
					"Idolo assoluto, chi non è d'accordo non capisce niente di musica!"
				]
			_:
				comments_pool = ["Grandi!", "Continuate così!"]
				
	comments_pool.shuffle()
	var pick_count: int = mini(3, comments_pool.size())
	for i in range(pick_count):
		result.append(comments_pool[i])
		
	return result

## Genera una resa testuale sequenziale lineare ottimizzata per NVDA
func get_social_feed_speech() -> String:
	var lines: Array[String] = []
	lines.append("Canale Social della Band.")
	lines.append("Follower Totali: %d." % total_followers)
	lines.append("Hype Social (Buzz): %.2fx." % weekly_buzz)
	lines.append("Post pubblicati oggi: %d su %d disponibili." % [posts_published_today, max_posts_per_day])
	
	if has_active_controversy():
		lines.append("ATTENZIONE: Polemica online in corso! Motivo: %s. Premi R per risolverla." % str(active_controversy.get("topic", "")))
		
	if post_history.is_empty():
		lines.append("Nessun post pubblicato finora. Premi i tasti da 1 a 4 per pubblicare un contenuto.")
	else:
		lines.append("Ultimi post pubblicati (totale %d):" % post_history.size())
		var count: int = mini(3, post_history.size())
		for i in range(count):
			var p: SocialPostData = post_history[i]
			var post_line: String = "Post %d: %s (Giorno %d). Views: %d, Mi piace: %d, Nuovi follower: %d." % [
				i + 1,
				Enums.get_social_post_type_name(p.post_type),
				p.day_published,
				p.views,
				p.likes,
				p.new_followers
			]
			if p.is_viral:
				post_line += " [VIRALE]"
			if p.is_controversial:
				post_line += " [POLEMICA]"
			lines.append(post_line)
			if not p.caption.is_empty():
				lines.append("  Didascalia: \"%s\"" % p.caption)
			if not p.comments_sample.is_empty():
				lines.append("  Commento del pubblico: \"%s\"" % p.comments_sample[0])
				
	return "\n".join(lines)

## Serializzazione dizionario per salvataggio
func to_dict() -> Dictionary:
	var posts_arr: Array[Dictionary] = []
	for p in post_history:
		posts_arr.append(p.to_dict())
		
	return {
		"total_followers": total_followers,
		"weekly_buzz": weekly_buzz,
		"posts_published_today": posts_published_today,
		"active_controversy": active_controversy.duplicate(),
		"post_history": posts_arr
	}

## Deserializzazione da dizionario salvataggio
func from_dict(d: Dictionary) -> void:
	total_followers = int(d.get("total_followers", 150))
	weekly_buzz = float(d.get("weekly_buzz", 1.0))
	posts_published_today = int(d.get("posts_published_today", 0))
	active_controversy = d.get("active_controversy", {}).duplicate()
	
	post_history.clear()
	var raw_posts: Array = d.get("post_history", [])
	for p_dict in raw_posts:
		if p_dict is Dictionary:
			var post_item := SocialPostData.new()
			post_item.from_dict(p_dict)
			post_history.append(post_item)
