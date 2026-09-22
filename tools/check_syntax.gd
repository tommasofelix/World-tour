extends Node

func _ready() -> void:
	print("=== VERIFICA COMPILAZIONE E SINTASSI DEI FILE GDSCRIPT ===")
	var files: Array[String] = []
	_scan_dir("res://", files)
	
	var total: int = 0
	var failed: int = 0
	
	for file_path in files:
		if file_path == "res://tools/check_syntax.gd":
			continue
		total += 1
		var script = load(file_path)
		if script == null:
			print("[ERRORE] " + file_path)
			failed += 1
		else:
			print("[OK] " + file_path)
	
	print("\n=== RIEPILOGO VERIFICA COMPILAZIONE ===")
	print("File verificati: %d" % total)
	print("Errori rilevati: %d" % failed)
	
	get_tree().quit(1 if failed > 0 else 0)

func _scan_dir(path: String, results: Array[String]) -> void:
	var dir := DirAccess.open(path)
	if not dir:
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not file_name.begins_with("."):
			var full_path := path.path_join(file_name)
			if dir.current_is_dir():
				if file_name != ".godot":
					_scan_dir(full_path, results)
			elif file_name.ends_with(".gd"):
				results.append(full_path)
		file_name = dir.get_next()
	dir.list_dir_end()
