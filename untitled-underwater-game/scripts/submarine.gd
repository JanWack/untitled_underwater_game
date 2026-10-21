extends CharacterBody3D

@export var camera_origin: Node3D
@export var camera_pivot: Node3D
@export var camera: Camera3D

var SENS: float = 0.005
const SPEED: float = 5.0

@export var camera_smoothness: float = 20.0
var target_rot_x: float = 0.0
var target_rot_y: float = 0.0
var current_rot_x: float = 0.0
var current_rot_y: float = 0.0


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


## Handles input that is not yet handled. Used for moving the camera
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var x: float = -event.relative.x * SENS
		var y: float = -event.relative.y * SENS
		target_rot_x = x
		target_rot_y = y


func _physics_process(delta: float) -> void:
	# Camera movement
	current_rot_x = lerp(current_rot_x, target_rot_x, camera_smoothness * delta)
	current_rot_y = lerp(current_rot_y, target_rot_y, camera_smoothness * delta)
	
	camera_origin.rotate_y(current_rot_x)
	camera_pivot.rotate_x(current_rot_y)
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-85), deg_to_rad(85))
	target_rot_x = 0.0
	target_rot_y = 0.0
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
