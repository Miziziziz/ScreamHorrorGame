extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	$MainScreen/Play.connect("button_up", self, "play")
	$MainScreen/MakingOf.connect("button_up", self, "go_to_making_of")
	$MainScreen/Credits.connect("button_up", self, "open_credits")
	$MainScreen/Exit.connect("button_up", self, "exit")
	$CreditsScreen/Back.connect("button_up", self, "open_main_menu")
	$MainScreen/CalibrateMic.connect("button_up", self, "open_calibration")
	$CalibrateMic/Back.connect("button_up", self, "open_main_menu")
	
	open_main_menu()

func _process(_delta):
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
	hide_all()
	$CreditsScreen.show()

func open_main_menu():
	hide_all()
	$MainScreen.show()

func open_calibration():
	hide_all()
	$CalibrateMic.show()

func hide_all():
	$CalibrateMic.hide()
	$CreditsScreen.hide()
	$MainScreen.hide()
