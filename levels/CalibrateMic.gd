extends Control
#doesn't really work so removed
var lastime_start = 0
var lastime_end = 0
var is_recording = false
var effect : AudioEffectRecord
var recording
var power = 0

var calibrating = false
var num_of_samples_to_get = 20
var sample_ind = 0
var total_power = 0.0
var power_levels = []

func start_calibrating():
	power_levels = []
	calibrating = true
	total_power = 0.0
	sample_ind = 0
	$CalibrateButton.text = "Calibrating"
	$CalibrateButton.disabled = true
	$Back.disabled = true

func finish_calibrating():
	calibrating = false
	LevelManager.mic_base = total_power / num_of_samples_to_get + 10
	$CalibrateButton.text = "Calibrate"
	$CalibrateButton.disabled = false
	$Back.disabled = false
	$Label.text = "calibration complete"
	#power_levels.sort()
	#print(power_levels[power_levels.size() / 2])
	print(LevelManager.mic_base)

func _ready():
	$CalibrateButton.connect("button_up", self, "start_calibrating")
	var idx = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(idx, 0)
	effect.set_recording_active(true)
	effect.format = 0
	lastime_start = OS.get_ticks_msec()
	is_recording = true

func _physics_process(_delta):
	if !calibrating:
		return
	if OS.get_ticks_msec() - lastime_start > 50 and is_recording == true:
		lastime_end = OS.get_ticks_msec()
		effect.set_recording_active(false)
		recording = effect.get_recording()
		is_recording = false
		if recording == null: return
		var data = recording.get_data()
		var avg = 0.0
		for i in len(data):
			var b = data[i]
			var u = (b + 128) & 0xFF
			var s = float(u - 128) / 128.0
			avg += s
		avg /= len(data)
		avg = clamp(avg, db2linear(-70), 1.0)
		avg = linear2db(avg)
		power = avg
		if sample_ind != 0:
			power_levels.append(power)
			total_power += power # skip first to not get mouse click sound
		sample_ind += 1
		if sample_ind > num_of_samples_to_get:
			finish_calibrating()
	if OS.get_ticks_msec() - lastime_end > 5 and is_recording == false:
		effect.set_recording_active(true)
		lastime_start = OS.get_ticks_msec()
		is_recording = true
