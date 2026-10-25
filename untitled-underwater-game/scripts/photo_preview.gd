extends CanvasLayer

@export var texture_rect: TextureRect
@export var line_edit: LineEdit

var new_img: Image = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	
	GlobalSignals.save_or_discard_photo.connect(
		func(img: Image):
			if self.new_img == null:
				self.show()
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				self.new_img = img
				texture_rect.texture = ImageTexture.create_from_image(img)
	)


func _on_keep_pressed() -> void:
	if new_img != null:
		var img_name: String = "res://InGameImages/"
		if line_edit.text.is_empty(): img_name = str(img_name, new_img.get_rid(), ".png")
		else: img_name = str(img_name, line_edit.text, ".png")
		
		new_img.save_png(img_name)
		
		self.new_img = null
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		self.hide()


func _on_discard_pressed() -> void:
	self.new_img = null
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	self.hide()
