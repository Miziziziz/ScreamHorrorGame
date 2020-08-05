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

var can_see_if_power_above = 0.01
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

func _physics_process(_delta):
	if player.dead:
		screen_cover.show()
		can_see = false
		
		return
	if OS.get_ticks_msec() - lastime_start > 80 and is_recording == true:
		lastime_end = OS.get_ticks_msec()
		effect.set_recording_active(false)
		recording = effect.get_recording()
		is_recording = false
		if recording == null: return
		var data = recording.get_data()
		#var s = 0
#		for i in range(min(44,data.size()),data.size()):
#			s += data[i] * data[i]
#		power = sqrt(s/(max(data.size(),45)-44))


		var avg = 0.0
		for i in len(data):
			var b = data[i]
			var u = (b + 128) & 0xFF
			var s = float(u - 128) / 128.0
			avg += s
		avg /= len(data)
		avg = clamp(avg, 0.0, 1.0)
		#avg = linear2db(avg)
		power = avg
	
	if OS.get_ticks_msec() - lastime_end > 10 and is_recording == false:
		effect.set_recording_active(true)
		lastime_start = OS.get_ticks_msec()
		is_recording = true
	
	#print(power, " ", power > can_see_if_power_above)
	can_see = power > can_see_if_power_above
	if playtest:
		can_see = Input.is_action_pressed("scream")

	if can_see:
		screen_cover.hide()
	else:
		screen_cover.show()
