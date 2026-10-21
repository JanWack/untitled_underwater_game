extends CharacterBody3D
class_name Submarine

# Export variables
@export var main_propeller: MeshInstance3D
@export var left_propeller: MeshInstance3D
@export var right_propeller: MeshInstance3D
@export var main_prop_base: Node3D

# Constants
const SPEED: float = 5.0
const ACCELERATION: float = 2.0
const TURN_SPEED: float = 1.0
const TURN_ACCELERATION: float = 2.0
const PROPELLER_SPEED: float = 10
const PROPELLER_ACCELERATION: float = 8.0
const PROPELLER_ROTATION_SMOOTHING: float = 0.02
const SMALL_PROPELLER_ACCELERATION: float = 10.0
const SMALL_PROPELLER_ROTATION_SMOOTHING: float = 0.02

# Variables
var forward_speed: float = 0.0
var turn_velocity: Vector2 = Vector2.ZERO
var main_propeller_speed: float = 0.0
var left_propeller_speed: float = 0.0
var right_propeller_speed: float = 0.0

var tween: Tween


## Handles the player input
func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("up"): rotate_main_propeller(135.0)
	elif Input.is_action_just_pressed("down"): rotate_main_propeller(45.0)
	else: rotate_main_propeller(90)


## Handles the turning and velocity of the submarine.
## Also spinns the propellers.
func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	turn_velocity = turn_velocity.lerp(input_dir * TURN_SPEED, TURN_ACCELERATION * delta)
	
	rotation.y -= turn_velocity.x * delta
	rotate_object_local(Vector3.RIGHT, turn_velocity.y * delta) # Prevents gimbal-lock or smth...
	
	var velocity_dir: float = 0.0
	if Input.is_action_pressed("gas"): velocity_dir += 1.0
	if Input.is_action_pressed("break"): velocity_dir -= 1.0
	
	forward_speed = move_toward(forward_speed, velocity_dir * SPEED, ACCELERATION * delta)
	velocity = -global_transform.basis.z * forward_speed
	
	spin_propelars(delta, velocity_dir, input_dir)

	move_and_slide()


## Spins the main and side propelars when moving
func spin_propelars(delta: float, velocity_dir: float, input_dir: Vector2) -> void:
	if velocity_dir: main_propeller_speed = move_toward(main_propeller_speed, velocity_dir * PROPELLER_SPEED, PROPELLER_ACCELERATION * delta)
	else: main_propeller_speed = move_toward(main_propeller_speed, input_dir.y * PROPELLER_SPEED, PROPELLER_ACCELERATION * delta)
	main_propeller.rotate_y(-main_propeller_speed * PROPELLER_ROTATION_SMOOTHING)
	left_propeller_speed = move_toward(left_propeller_speed, max(input_dir.x, 0.0) * PROPELLER_SPEED, SMALL_PROPELLER_ACCELERATION * delta)
	left_propeller.rotate_z(-left_propeller_speed * SMALL_PROPELLER_ROTATION_SMOOTHING)
	right_propeller_speed = move_toward(right_propeller_speed, min(input_dir.x, 0.0) * PROPELLER_SPEED, SMALL_PROPELLER_ACCELERATION * delta)
	right_propeller.rotate_z(-right_propeller_speed * SMALL_PROPELLER_ROTATION_SMOOTHING)


## Rotates the main propelar up or down
func rotate_main_propeller(angle: float) -> void:
	if tween and tween.is_running():
			tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(main_prop_base, "rotation", Vector3(deg_to_rad(angle), 0, 0), 0.7).set_trans(Tween.TRANS_SINE)
