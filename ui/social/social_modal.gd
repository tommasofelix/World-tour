# res://ui/social/social_modal.gd
extends Control

## Controller della Schermata Social Media & Fan Engagement (World-tour F8.4 / SP-12)
## Accessibilità 100% tastiera e sintesi vocale NVDA per Luca,
## interfaccia grafica moderna e leggibile per Holy Diver.

signal closed()
signal post_published(post: SocialPostData)
signal controversy_resolved(choice: int, result: Dictionary)

@onready var label_title: Label = $PanelMain/VBox/Header/LabelTitle
@onready var label_stats: Label = $PanelMain/VBox/Header/LabelStats
@onready var panel_controversy: PanelContainer = $PanelMain/VBox/PanelControversy
@onready var label_controversy_title: Label = $PanelMain/VBox/PanelControversy/VBoxContro/LabelControTitle
@onready var label_controversy_desc: Label = $PanelMain/VBox/PanelControversy/VBoxContro/LabelControDesc
@onready var btn_contro_ignore: Button = $PanelMain/VBox/PanelControversy/VBoxContro/HBoxControButtons/BtnIgnore
@onready var btn_contro_apology: Button = $PanelMain/VBox/PanelControversy/VBoxContro/HBoxControButtons/BtnApology
@onready var btn_contro_doubledown: Button = $PanelMain/VBox/PanelControversy/VBoxContro/HBoxControButtons/BtnDoubleDown

@onready var btn_post_practice: Button = $PanelMain/VBox/HBoxActions/BtnPractice
@onready var btn_post_teaser: Button = $PanelMain/VBox/HBoxActions/BtnTeaser
@onready var btn_post_bts: Button = $PanelMain/VBox/HBoxActions/BtnBTS
@onready var btn_post_provocation: Button = $PanelMain/VBox/HBoxActions/BtnProvocation

@onready var scroll_feed: ScrollContainer = $PanelMain/VBox/PanelFeed/Margin/VBoxFeed/ScrollFeed
@onready var vbox_posts: VBoxContainer = $PanelMain/VBox/PanelFeed/Margin/VBoxFeed/ScrollFeed/VBoxPosts
@onready var label_status: Label = $PanelMain/VBox/LabelStatus
@onready var btn_close: Button = $PanelMain/VBox/HBoxBottom/BtnClose

func _ready() -> void:
	btn_close.pressed.connect(close)
	AccessibilityManager.hook_control_accessibility(btn_close, "Chiudi Finestra Social", "Chiude la schermata dei social media e torna all'HUD.")
	
	btn_post_practice.pressed.connect(func(): _on_publish_pressed(Enums.SocialPostType.PRACTICE_CLIP))
	btn_post_teaser.pressed.connect(func(): _on_publish_pressed(Enums.SocialPostType.TRACK_TEASER))
	btn_post_bts.pressed.connect(func(): _on_publish_pressed(Enums.SocialPostType.BEHIND_THE_SCENES))
	btn_post_provocation.pressed.connect(func(): _on_publish_pressed(Enums.SocialPostType.PROVOCATION))
	
	AccessibilityManager.hook_control_accessibility(btn_post_practice, "1: Clip Prove", "Pubblica una clip delle prove in sala. Consuma 10 energia.")
	AccessibilityManager.hook_control_accessibility(btn_post_teaser, "2: Teaser Brano", "Pubblica un'anteprima audio di un brano del repertorio. Consuma 15 energia.")
	AccessibilityManager.hook_control_accessibility(btn_post_bts, "3: Backstage", "Pubblica retroscena e vita da band. Consuma 10 energia.")
	AccessibilityManager.hook_control_accessibility(btn_post_provocation, "4: Post Provocatorio", "Pubblica una dichiarazione provocatoria o dissing. Alto potenziale virale ma rischio polemica. Consuma 15 energia.")
	
	btn_contro_ignore.pressed.connect(func(): _on_resolve_controversy_pressed(0))
	btn_contro_apology.pressed.connect(func(): _on_resolve_controversy_pressed(1))
	btn_contro_doubledown.pressed.connect(func(): _on_resolve_controversy_pressed(2))
	
	AccessibilityManager.hook_control_accessibility(btn_contro_ignore, "Tasto A: Ignora la Polemica", "Nessun commento pubblico. Lieve perdita follower e stress minimo.")
	AccessibilityManager.hook_control_accessibility(btn_contro_apology, "Tasto B: Scuse Pubbliche", "Pubblica scuse formali. Aumenta la reputazione generale ma delude i ribelli.")
	AccessibilityManager.hook_control_accessibility(btn_contro_doubledown, "Tasto C: Raddoppia la Posta", "Sfida apertamente le critiche. Rischio estremo: 50% trionfo virale, 50% disastro.")
	
	EventBus.social_post_published.connect(func(_p): refresh_view())
	EventBus.social_controversy_triggered.connect(func(_c): refresh_view())
	EventBus.social_controversy_resolved.connect(func(_ch, _o): refresh_view())
	EventBus.social_buzz_updated.connect(func(_b): refresh_view())

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_Y:
			close()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_1:
			_on_publish_pressed(Enums.SocialPostType.PRACTICE_CLIP)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_2:
			_on_publish_pressed(Enums.SocialPostType.TRACK_TEASER)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_3:
			_on_publish_pressed(Enums.SocialPostType.BEHIND_THE_SCENES)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_4:
			_on_publish_pressed(Enums.SocialPostType.PROVOCATION)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_A and panel_controversy.visible:
			_on_resolve_controversy_pressed(0)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_B and panel_controversy.visible:
			_on_resolve_controversy_pressed(1)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_C and panel_controversy.visible:
			_on_resolve_controversy_pressed(2)
			get_viewport().set_input_as_handled()

func open() -> void:
	visible = true
	refresh_view()
	if GameManager:
		GameManager.open_menu()
	if btn_post_practice:
		btn_post_practice.grab_focus()
	_announce_summary()

func close() -> void:
	visible = false
	if GameManager:
		GameManager.close_menu()
	closed.emit()
	AccessibilityManager.announce("Schermata social chiusa.", true)

func refresh_view() -> void:
	var sys: SocialMediaSystem = GameManager.social_media_system if GameManager else null
	if not sys:
		return
		
	# Header & Statistiche
	label_stats.text = "Follower: %d | Hype (Buzz): %.2fx | Post Oggi: %d/%d" % [
		sys.total_followers,
		sys.weekly_buzz,
		sys.posts_published_today,
		sys.max_posts_per_day
	]
	
	# Pannello Controversia
	if sys.has_active_controversy():
		panel_controversy.visible = true
		label_controversy_desc.text = "Argomento: %s\nScegli la strategia della band: [A] Ignora (Silenzio) | [B] Scuse Formali | [C] Raddoppia la Posta (Double Down)" % str(sys.active_controversy.get("topic", ""))
		btn_contro_ignore.grab_focus()
	else:
		panel_controversy.visible = false
		
	# Aggiornamento pulsanti pubblicazione in base a energia e limiti
	_update_publish_buttons(sys)
	
	# Ricostruzione Feed Post
	for c in vbox_posts.get_children():
		c.queue_free()
		
	if sys.post_history.is_empty():
		var lbl_empty := Label.new()
		lbl_empty.text = "Nessun post pubblicato finora. Usa i tasti da 1 a 4 per condividere contenuti con i fan."
		lbl_empty.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vbox_posts.add_child(lbl_empty)
	else:
		var show_count: int = mini(5, sys.post_history.size())
		for i in range(show_count):
			var p: SocialPostData = sys.post_history[i]
			var panel_post := PanelContainer.new()
			var vbox_post := VBoxContainer.new()
			panel_post.add_child(vbox_post)
			
			var header_txt: String = "Post #%d: %s (Giorno %d)" % [i + 1, Enums.get_social_post_type_name(p.post_type), p.day_published]
			if p.is_viral:
				header_txt += " ⭐ VIRALE"
			if p.is_controversial:
				header_txt += " ⚠️ SHITSTORM"
			var lbl_head := Label.new()
			lbl_head.text = header_txt
			lbl_head.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3) if p.is_viral else Color(0.8, 0.9, 1.0))
			vbox_post.add_child(lbl_head)
			
			if not p.caption.is_empty():
				var lbl_cap := Label.new()
				lbl_cap.text = "\"%s\"" % p.caption
				lbl_cap.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
				vbox_post.add_child(lbl_cap)
				
			var lbl_metrics := Label.new()
			lbl_metrics.text = "Views: %d | Like: %d | Condivisioni: %d | Nuovi Fan: +%d" % [p.views, p.likes, p.shares, p.new_followers]
			vbox_post.add_child(lbl_metrics)
			
			if not p.comments_sample.is_empty():
				var lbl_comm := Label.new()
				lbl_comm.text = "Commento del pubblico: \"%s\"" % p.comments_sample[0]
				lbl_comm.add_theme_color_override("font_color", Color(0.7, 0.8, 0.7))
				lbl_comm.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
				vbox_post.add_child(lbl_comm)
				
			vbox_posts.add_child(panel_post)

func _update_publish_buttons(sys: SocialMediaSystem) -> void:
	var can_practice := sys.can_publish_post(Enums.SocialPostType.PRACTICE_CLIP)
	var can_teaser := sys.can_publish_post(Enums.SocialPostType.TRACK_TEASER)
	var can_bts := sys.can_publish_post(Enums.SocialPostType.BEHIND_THE_SCENES)
	var can_prov := sys.can_publish_post(Enums.SocialPostType.PROVOCATION)
	
	btn_post_practice.disabled = not can_practice.get("allowed", false)
	btn_post_teaser.disabled = not can_teaser.get("allowed", false)
	btn_post_bts.disabled = not can_bts.get("allowed", false)
	btn_post_provocation.disabled = not can_prov.get("allowed", false)

func _on_publish_pressed(post_type: int) -> void:
	var sys: SocialMediaSystem = GameManager.social_media_system if GameManager else null
	if not sys:
		return
		
	var res := sys.publish_post(post_type)
	if res.get("success", false):
		var msg: String = str(res.get("message", "Post pubblicato!"))
		label_status.text = msg
		AccessibilityManager.announce(msg, true)
		post_published.emit(res.get("post"))
		refresh_view()
	else:
		var err_msg: String = str(res.get("message", "Impossibile pubblicare."))
		label_status.text = err_msg
		AccessibilityManager.announce(err_msg, true)

func _on_resolve_controversy_pressed(choice: int) -> void:
	var sys: SocialMediaSystem = GameManager.social_media_system if GameManager else null
	if not sys:
		return
		
	var res := sys.resolve_controversy(choice)
	if res.get("success", false):
		var msg: String = str(res.get("message", "Polemica risolta."))
		label_status.text = msg
		AccessibilityManager.announce(msg, true)
		controversy_resolved.emit(choice, res)
		refresh_view()
		if btn_post_practice:
			btn_post_practice.grab_focus()
	else:
		var err_msg: String = str(res.get("message", "Errore nella risoluzione."))
		label_status.text = err_msg
		AccessibilityManager.announce(err_msg, true)

func _announce_summary() -> void:
	var sys: SocialMediaSystem = GameManager.social_media_system if GameManager else null
	if sys:
		AccessibilityManager.announce(sys.get_social_feed_speech(), true)
	else:
		AccessibilityManager.announce("Canale Social Media della Band. Premi Esc per uscire.", true)
