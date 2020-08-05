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

var dist_travelled = 0.0
func _physics_process(_delta):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("MonsterBreath"), microphone.can_see)
	if microphone.can_see:
		return
	
	if !active:
		return
	
	var our_pos = global_transform.origin
	var p_pos = player.global_transform.origin
	var path = nav.get_simple_path(our_pos, p_pos)
	
	if our_pos.distance_squared_to(p_pos) <= ATTACK_DIST * ATTACK_DIST:
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(our_pos + Vector3.UP, p_pos + Vector3.UP, [self], collision_mask)
		if !result:
			player.kill()
	elif path.size() > 1:
		var dir = path[1] - global_transform.origin
		dir.y = 0
		dir = dir.normalized()
		
		move_and_slide(dir * move_speed, Vector3.UP)
		rotation.y = atan2(dir.x, dir.z)
		dist_travelled += global_transform.origin.distance_to(our_pos)
		if dist_travelled >= 1.0:
			$FootstepSounds.play()
			dist_travelled = 0.0

func set_active():
	active = true
