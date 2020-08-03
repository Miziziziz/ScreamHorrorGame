extends KinematicBody

var mouse_sens = 0.5
var move_speed = 6.0

var light_turn_speed = 5.0

var key_count = 0

onready var raycast_interactable = $Camera/RayCastInteractable

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sens * event.relative.x
		$Camera.rotation_degrees.x -= mouse_sens * event.relative.y
		$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, -90, 90)

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("interact"):
		if raycast_interactable.is_colliding():
			var coll = raycast_interactable.get_collider()
			if "Key" in coll.name:
				pickup_key()
				coll.queue_free()
			elif "Door" in coll.name:
				if key_count > 0:
					use_key()
				else:
					$CanvasLayer/DoorLocked.show()
					$CanvasLayer/DoorLocked/HideTimer.start()
			elif "Gate" in coll.name:
				if key_count > 0:
					use_key()
					coll.get_node("AnimationPlayer").play("open")
				else:
					$CanvasLayer/GateLocked.show()
					$CanvasLayer/GateLocked/HideTimer.start()
	hide_ui_popups()
	if raycast_interactable.is_colliding():
		var coll = raycast_interactable.get_collider()
		if "Key" in coll.name:
			$CanvasLayer/PickupKey.show()
		elif "Door" in coll.name:
			$CanvasLayer/OpenDoor.show()
		elif "Gate" in coll.name:
			$CanvasLayer/OpenGate.show()

func hide_ui_popups():
	$CanvasLayer/OpenDoor.hide()
	$CanvasLayer/PickupKey.hide()
	$CanvasLayer/OpenGate.hide()

func pickup_key():
	key_count += 1
	var ind = 0
	for key in $CanvasLayer/Keys.get_children():
		if ind < key_count:
			key.show()
		else:
			key.hide()
		ind += 1

func use_key():
	key_count -= 1
	var ind = 0
	for key in $CanvasLayer/Keys.get_children():
		if ind < key_count:
			key.show()
		else:
			key.hide()
		ind += 1

func _physics_process(_delta):
	var move_vec = Vector3()
	if Input.is_action_pressed("move_forward"):
		move_vec += Vector3.FORWARD
	if Input.is_action_pressed("move_backwards"):
		move_vec += Vector3.BACK
	if Input.is_action_pressed("move_right"):
		move_vec += Vector3.RIGHT
	if Input.is_action_pressed("move_left"):
		move_vec += Vector3.LEFT

	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3.UP, rotation.y)
	move_and_slide(move_vec * move_speed, Vector3.UP)
	global_transform.origin.y = 0
