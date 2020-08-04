extends Node


var level_list = [
	"res://levels/IntroCutscene.tscn",
	"res://levels/CasualMaze.tscn",
	"res://levels/FirstGate.tscn",
	"res://levels/TheStatue.tscn",
	"res://levels/FirstAttack.tscn",
	"res://levels/FirstSaltRing.tscn"
]

var ind = 0
func load_first_level():
	ind = 0
	get_tree().change_scene(level_list[0])

func load_next_level():
	ind += 1
	ind %= level_list.size()
	get_tree().change_scene(level_list[ind])
	$DoorSound.play()


func load_main_menu():
	get_tree().change_scene("res://levels/MainMenu.tscn")
