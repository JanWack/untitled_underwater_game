extends Camera3D

@export var turn_speed: float = 60
@export var follow_dist: float = 5
@export var follow_speed: float = 2
@export var hight_diff: float = 2.5
@export var target: Submarine

var is_looking_at_photo: bool = false


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	GlobalSignals.looking_at_photo.connect(
		func(done: bool):
			is_looking_at_photo = done
			if not done:
				target.switch_to_photo_camera(false)
				self.current = true
	)


func _unhandled_key_input(_event: InputEvent) -> void:
	if not is_looking_at_photo:
		if Input.is_action_just_pressed("switch_camera"):
			target.switch_to_photo_camera(true)
		elif Input.is_action_just_released("switch_camera"):
			target.switch_to_photo_camera(false)
			self.current = true


func _physics_process(delta) -> void:
	var to_target = target.global_transform.origin - global_transform.origin
	var dist = to_target.length()
	var move_vec = to_target
	move_vec.y += hight_diff
	to_target = to_target.normalized()
	
	var accel = dist - follow_dist
	global_transform.origin += accel * move_vec * follow_speed * delta
	
	var up = global_transform.basis.y
	var right = global_transform.basis.x
	
	var r_dot = to_target.dot(right)
	var u_dot = to_target.dot(up)
	
	rotation_degrees.y += turn_speed * -r_dot * delta
	rotation_degrees.x += turn_speed * u_dot * delta
