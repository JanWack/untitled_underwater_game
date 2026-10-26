extends Node3D

@export var world_environment: WorldEnvironment
@export var water: MeshInstance3D

var old_val: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var new_val: bool
	if global_position.y < water.global_position.y: new_val = true
	else: new_val = false
	
	if new_val != old_val:
		world_environment.environment.fog_enabled = new_val
		water.mesh.set_flip_faces(new_val)
	
	old_val = new_val
