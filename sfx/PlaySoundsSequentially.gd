extends Spatial

func _ready():
	for child in get_children():
		child.connect("finished", self, "play_next")
	play_next()

var ind = 0
func play_next():
	get_child(ind).play()
	ind += 1
	ind %= get_child_count()
