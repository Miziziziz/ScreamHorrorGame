extends Node
# uses a bunch of code from: https://pastebin.com/64saG7V4
# by https://twitter.com/AniC_dev
# as well as code from: https://godotengine.org/qa/67091/how-to-read-audio-samples-as-1-1-floats
var lastime_start = 0
var lastime_end = 0
var is_recording = false
var effect : AudioEffectRecord
var recording
var power = 0

#var can_see_if_power_above = 0.01
onready var screen_cover = $CanvasLayer/ScreenCover

var can_see = false
var playtest = false # set to true to use shift to scream
var player = null
func _ready():
	#can_see_if_power_above = LevelManager.mic_base
	player = get_tree().get_nodes_in_group("player")[0]
	screen_cover.show()
	var idx = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(idx, 0)
	effect.set_recording_active(true)
	effect.format = 0
	lastime_start = OS.get_ticks_msec()
	is_recording = true

var last_samples = []
func _physics_process(_delta):
	if player.dead:
		screen_cover.show()
		can_see = false
		return
	
	var power = AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index("Record"), 0)
	power = clamp(db2linear(power), 0.0, 1.0)
	
	last_samples.append(power)
	if last_samples.size() > 10:
		last_samples.pop_front()
	print(get_avg_power(), " ", LevelManager.mic_base)
	can_see = get_avg_power() > LevelManager.mic_base
	if playtest:
		can_see = Input.is_action_pressed("scream")

	if can_see:
		screen_cover.hide()
	else:
		screen_cover.show()

func get_avg_power():
	var avg = 0.0
	for sample in last_samples:
		avg += sample
	avg /= last_samples.size()
	return avg
