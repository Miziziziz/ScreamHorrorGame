extends Control

var lastime_start = 0
var lastime_end = 0
var is_recording = false
var effect : AudioEffectRecord
var recording
var power = 0

var calibrating = false
var num_of_samples_to_get = 80
var sample_ind = 0
var total_power = 0.0
var power_levels = []
var highest_recorded = 0.0

var last_samples = []

enum CALIBRATING_STATES {NONE, LOW, HIGH}
var cur_calibrating_state = CALIBRATING_STATES.NONE

func start_calibrating_low():
	cur_calibrating_state = CALIBRATING_STATES.LOW
	start_calibrating()

func start_calibrating_high():
	cur_calibrating_state = CALIBRATING_STATES.HIGH
	start_calibrating()

func start_calibrating():
	power_levels = []
	calibrating = true
	total_power = 0.0
	sample_ind = 0
	highest_recorded = 0.0
	if cur_calibrating_state == CALIBRATING_STATES.LOW:
		$CalibrateLow.text = "Calibrating..."
	else:
		$CalibrateHigh.text = "Calibrating..."
	$CalibrateHigh.disabled = true
	$CalibrateLow.disabled = true
	$Back.disabled = true

func finish_calibrating():
	calibrating = false
	LevelManager.mic_base = total_power / num_of_samples_to_get + 10
	$CalibrateHigh.text = "calibrate high"
	$CalibrateLow.text = "calibrate low"
	$CalibrateHigh.disabled = false
	$CalibrateLow.disabled = false
	$Back.disabled = false
	if cur_calibrating_state == CALIBRATING_STATES.LOW:
		$CalibrateLow/Level.text = "current level: " + str(highest_recorded)
		LevelManager.set_mic_low(highest_recorded)
	else:
		power_levels.sort()
		var median = power_levels[power_levels.size() / 2]
		$CalibrateHigh/Level.text = "current level: " + str(median)
		LevelManager.set_mic_high(median)

func _ready():
	
	$CalibrateHigh/Level.text = "current level: " + str(LevelManager.mic_high)
	$CalibrateLow/Level.text = "current level: " + str(LevelManager.mic_low)
	
	$CalibrateHigh.connect("button_up", self, "start_calibrating_high")
	$CalibrateLow.connect("button_up", self, "start_calibrating_low")
	var idx = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(idx, 0)
	effect.set_recording_active(true)
	effect.format = 0

func _physics_process(_delta):
	var power = AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index("Record"), 0)
	#var y = AudioServer.get_bus_peak_volume_right_db(AudioServer.get_bus_index("Master"), 0)
	power = clamp(db2linear(power), 0.0, 1.0)# * 5.0
	$MicrophoneVol.text = "current microphone volume: " + str(power)# + ", " + str(y)
	$MicrohponeVolSlider.value = power
	
	last_samples.append(power)
	if last_samples.size() > 10:
		last_samples.pop_front()
	
	if calibrating:
		if power > highest_recorded:
			highest_recorded =  get_avg_power()
		power_levels.append(get_avg_power())
		sample_ind += 1
		if sample_ind > num_of_samples_to_get:
			finish_calibrating()

func get_avg_power():
	var avg = 0.0
	for sample in last_samples:
		avg += sample
	avg /= last_samples.size()
	return avg
