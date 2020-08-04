extends StaticBody

signal opened
func open():
	$AnimationPlayer.play("open")
	emit_signal("opened")
