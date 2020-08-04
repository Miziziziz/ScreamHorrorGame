extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	$MainScreen/Play.connect("button_up", self, "play")
	$MainScreen/MakingOf.connect("button_up", self, "go_to_making_of")
	$MainScreen/Credits.connect("button_up", self, "open_credits")
	$MainScreen/Exit.connect("button_up", self, "exit")
	$CreditsScreen/Back.connect("button_up", self, "go_back_to_main_menu")

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		exit()

func play():
	LevelManager.load_first_level()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func go_to_making_of():
	OS.shell_open("https://www.youtube.com/channel/UCaoqVlqPTH78_xjTjTOMcmQ")

func exit():
	get_tree().quit()

func open_credits():
	$MainScreen.hide()
	$CreditsScreen.show()

func go_back_to_main_menu():
	$MainScreen.show()
	$CreditsScreen.hide()


