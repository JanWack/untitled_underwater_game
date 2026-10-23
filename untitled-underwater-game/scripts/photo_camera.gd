extends Camera3D

var tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.current = false


func _unhandled_input(event: InputEvent) -> void:
	if self.current:
		if Input.is_action_just_pressed("zoom_in"):
			if tween and tween.is_running():
				return
			tween = get_tree().create_tween()
			var new_fov: float = clamp(self.fov - 10.0, 30.0, 75.0)
			tween.tween_property(self, "fov", new_fov, 0.3).set_trans(Tween.TRANS_SINE)
		elif Input.is_action_just_pressed("zoom_out"):
			if tween and tween.is_running():
				return
			tween = get_tree().create_tween()
			var new_fov: float = clamp(self.fov + 10.0, 30.0, 75.0)
			tween.tween_property(self, "fov", new_fov, 0.3).set_trans(Tween.TRANS_SINE)
		elif Input.is_action_just_pressed("take_photo"):
			var img: Image = get_viewport().get_texture().get_image()
			var img_name: String = str("res://InGameImages/", self.global_position, ".png")
			img.save_png(img_name)
