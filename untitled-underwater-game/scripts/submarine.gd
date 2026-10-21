extends CharacterBody3D
class_name Submarine

const SPEED: float = 4.0
const ACCELERATION: float = 2.0
const TURN_SPEED: float = 1.0
const TURN_ACCELERATION: float = 2.0

var forward_speed: float = 0.0
var turn_velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	var target_turn: Vector2 = input_dir * TURN_SPEED
	
	turn_velocity = turn_velocity.lerp(target_turn, TURN_ACCELERATION * delta)
	rotation.y -= turn_velocity.x * delta
	rotation.x += turn_velocity.y * delta
	rotation.x = clamp(rotation.x, deg_to_rad(-85), deg_to_rad(85))
	
	var velocity_dir: float = 0.0
	if Input.is_action_pressed("gas"):
		velocity_dir += 1.0
	if Input.is_action_pressed("break"):
		velocity_dir -= 1.0
	
	forward_speed = move_toward(forward_speed, velocity_dir * SPEED, ACCELERATION * delta)
	velocity = -global_transform.basis.z * forward_speed

	move_and_slide()
