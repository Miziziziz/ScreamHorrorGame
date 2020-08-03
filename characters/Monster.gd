extends KinematicBody

var microphone
var player : KinematicBody
var nav : Navigation

var move_speed = 30

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	nav = get_parent()
	microphone = get_tree().get_nodes_in_group("microphone")[0]

func _physics_process(delta):
	if microphone.can_see:
		return
	
	var path = nav.get_simple_path(global_transform.origin, player.global_transform.origin)
	if path.size() > 1:
		var dir = path[1] - global_transform.origin
		dir.y = 0
		dir = dir.normalized()
		move_and_slide(dir * move_speed, Vector3.UP)
		rotation.y = atan2(dir.x, dir.z)
