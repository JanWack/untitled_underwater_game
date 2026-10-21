extends CharacterBody3D

@export var camera_origin: Node3D
@export var camera_pivot: Node3D

# Camera
@export var camera_smoothness: float = 20.0
var camera_target_rot_x: float = 0.0
var camera_target_rot_y: float = 0.0
var camera_current_rot_x: float = 0.0
var camera_current_rot_y: float = 0.0

# Player
@export var smoothness: float = 20.0
var target_rot_x: float = 0.0
var target_rot_y: float = 0.0
var current_rot_x: float = 0.0
var current_rot_y: float = 0.0

var SENS: float = 0.005
const SPEED: float = 2.0
const TURN_SPEED: float = 0.01


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


## Handles input that is not yet handled. Used for moving the camera and input
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var x: float = -event.relative.x * SENS
		var y: float = -event.relative.y * SENS
		camera_target_rot_x = x
		camera_target_rot_y = y


func _physics_process(delta: float) -> void:
	# Smooth camera movement
	camera_current_rot_x = lerp(camera_current_rot_x, camera_target_rot_x, camera_smoothness * delta)
	camera_current_rot_y = lerp(camera_current_rot_y, camera_target_rot_y, camera_smoothness * delta)
	
	camera_origin.rotate_y(camera_current_rot_x)
	camera_pivot.rotate_x(camera_current_rot_y)
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-85), deg_to_rad(85))
	camera_target_rot_x = 0.0
	camera_target_rot_y = 0.0
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down") * TURN_SPEED
	if input_dir:
		rotate_y(-input_dir.x)
		rotate_object_local(Vector3.RIGHT, input_dir.y)
		rotation.x = clamp(rotation.x, deg_to_rad(-85), deg_to_rad(85))
	
	var velocity_dir: float = 0.0
	if Input.is_action_pressed("gas"):
		velocity_dir += 1.0
	if Input.is_action_pressed("break"):
		velocity_dir -= 1.0
	
	if velocity_dir != 0.0:
		velocity = global_transform.basis.z * velocity_dir * SPEED
	else:
		velocity = velocity.move_toward(Vector3.ZERO, SPEED * delta)

	move_and_slide()
