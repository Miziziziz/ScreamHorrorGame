extends Spatial

export var autostart = false
func _ready():
	if autostart:
		for child in get_children():
			child.connect("finished", self, "play")
		play()

var ind = 0
func play():
	get_child(ind).play()
	ind += 1
	ind %= get_child_count()
