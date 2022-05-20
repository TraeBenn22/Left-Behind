extends KinematicBody

onready var camera = $Pivot/Camera

var gravity = -30
var max_speed = 8
var mouse_sensitivity = 0.002  # radians/pixel

var velocity = Vector3()
var input_dir = Vector3()

# called once this node is created and added to the game
func _init():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
# called automatically by the engine when there is unhandled input to the game
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
	
# called automatically by the engine, every tick (game update)
func _physics_process(delta):
	handle_input()
	handle_movement(delta)


func handle_input():
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	# desired move in camera direction
	if Input.is_action_pressed("move_forward"):
		input_dir += -global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		input_dir += global_transform.basis.z
	if Input.is_action_pressed("strafe_left"):
		input_dir += -global_transform.basis.x
	if Input.is_action_pressed("strafe_right"):
		input_dir += global_transform.basis.x
	input_dir = input_dir.normalized()


func handle_movement(delta):
	velocity.y += gravity * delta
	var desired_velocity = input_dir * max_speed

	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
