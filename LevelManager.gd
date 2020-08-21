extends Node


var level_list = [
	"res://levels/IntroCutscene.tscn",
	"res://levels/CasualMaze.tscn",
	"res://levels/FirstGate.tscn",
	"res://levels/TheStatue.tscn",
	"res://levels/FirstAttack.tscn",
	"res://levels/FirstSaltRing.tscn",
	"res://levels/YetAnother.tscn",
	"res://levels/EndLevel.tscn"
]

var mic_low = 0.045
func set_mic_low(_mic_low:float):
	mic_low = _mic_low
	mic_base = (mic_high - mic_low) / 2.0 + mic_low

var mic_high = 0.075
func set_mic_high(_mic_high:float):
	mic_high = _mic_high
	mic_base = (mic_high - mic_low) / 2.0 + mic_low

var mic_base = 0.065

var ind = 0
func load_first_level():
	ind = 0
	get_tree().change_scene(level_list[0])

func load_next_level():
	ind += 1
	if ind >= level_list.size():
		load_main_menu()
	else:
		get_tree().change_scene(level_list[ind])
		$DoorSound.play()


func load_main_menu():
	get_tree().change_scene("res://levels/MainMenu.tscn")
