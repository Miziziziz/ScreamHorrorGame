extends Area


signal player_entered

func _ready():
	connect("body_entered", self, "on_body_enter")

func on_body_enter(coll):
	if "Player" in coll.name:
		emit_signal("player_entered")
