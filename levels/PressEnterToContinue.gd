extends Control

func _process(delta):
	if Input.is_action_just_pressed("continue"):
		LevelManager.load_next_level()
	if Input.is_action_just_pressed("exit"):
		LevelManager.load_main_menu()
