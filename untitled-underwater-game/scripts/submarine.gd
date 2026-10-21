extends CharacterBody3D
class_name Submarine

const SPEED: float = 4.0
const TURN_SPEED: float = 0.01

func _physics_process(delta: float) -> void:
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
