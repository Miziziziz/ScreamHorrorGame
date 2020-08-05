extends Node

var lastime_start = 0
var lastime_end = 0
var is_recording = false
var effect : AudioEffectRecord
var recording
var power = 0

func _ready():
	var idx = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(idx, 0)
	effect.set_recording_active(true)
	effect.format = 0
	lastime_start = OS.get_ticks_msec()
	is_recording = true

func _physics_process(_delta):
	if OS.get_ticks_msec() - lastime_start > 50 and is_recording == true:
		lastime_end = OS.get_ticks_msec()
		effect.set_recording_active(false)
		recording = effect.get_recording()
		is_recording = false
		if recording == null: return
		var data = recording.get_data()
		var s = 0
		for i in range(min(44,data.size()),data.size()):
			s += data[i] * data[i]
		power = sqrt(s/(max(data.size(),45)-44))
	
	if OS.get_ticks_msec() - lastime_end > 5 and is_recording == false:
		effect.set_recording_active(true)
		lastime_start = OS.get_ticks_msec()
		is_recording = true
