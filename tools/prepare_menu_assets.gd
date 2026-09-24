extends SceneTree

func _init() -> void:
	print("--- Preparazione Asset Menu ---")
	var bg_img: Image = Image.load_from_file("res://assets/img/menu/menu_img/background_menu.jpeg")
	var example_img: Image = Image.load_from_file("res://assets/img/menu/examples/menu_example.jpeg")
	
	if not bg_img or not example_img:
		print("ERRORE: Impossibile caricare immagini di sfondo.")
		quit(1)
		return
		
	print("Dimensioni background_menu: ", bg_img.get_size())
	print("Dimensioni menu_example: ", example_img.get_size())
	
	# Assicuriamo che bg_img sia 1408x768 per perfetto allineamento
	if bg_img.get_width() != example_img.get_width() or bg_img.get_height() != example_img.get_height():
		bg_img.resize(example_img.get_width(), example_img.get_height(), Image.INTERPOLATE_NEAREST)
		
	# Salviamo una versione con pentagramma puro (copiando la porzione del pentagramma da menu_example)
	var clean_bg: Image = bg_img.duplicate()
	# In menu_example il bordo inferiore di ESCI AL DESKTOP termina prima di Y = 530
	# La zona del pentagramma puro senza bottoni inizia a Y = 530
	var pentagram_src_rect: Rect2i = Rect2i(200, 530, 1008, 768 - 530)
	clean_bg.blit_rect(example_img, pentagram_src_rect, Vector2i(200, 530))
	
	var err: Error = clean_bg.save_png("res://assets/img/menu/menu_img/background_menu_clean.png")
	if err == OK:
		print("SUCCESS: background_menu_clean.png generato con successo!")
	else:
		print("ERRORE nel salvataggio: ", err)
		
	quit(0)
