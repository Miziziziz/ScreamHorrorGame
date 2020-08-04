extends KinematicBody

var microphone
var player : KinematicBody
var nav : Navigation

var move_speed = 30
export var active = true

const ATTACK_DIST = 2

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	nav = get_parent()
	microphone = get_tree().get_nodes_in_group("microphone")[0]

func _physics_process(delta):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("MonsterBreath"), microphone.can_see)
	if microphone.can_see:
		return
	
	if !active:
		return
	
	var our_pos = global_transform.origin
	var p_pos = player.global_transform.origin
	var path = nav.get_simple_path(our_pos, p_pos)
	if path.size() > 1:
		var dir = path[1] - global_transform.origin
		dir.y = 0
		dir = dir.normalized()
		move_and_slide(dir * move_speed, Vector3.UP)
		rotation.y = atan2(dir.x, dir.z)
	
	if our_pos.distance_squared_to(p_pos) <= ATTACK_DIST * ATTACK_DIST:
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(our_pos + Vector3.UP, p_pos + Vector3.UP, [self], collision_mask)
		if !result:
			player.kill()


func set_active():
	active = true
