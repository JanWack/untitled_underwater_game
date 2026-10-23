extends CanvasLayer

@export var texture_rect: TextureRect

var new_img = null
var img_name = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	
	GlobalSignals.save_or_discard_photo.connect(
		func(img: ViewportTexture, titel: String):
			if self.img_name == null:
				self.show()
				self.new_img = img
				texture_rect.texture = img
				self.img_name = titel
	)


func _on_keep_pressed() -> void:
	if self.img_name != null:
		var png: Image = new_img.get_image()
		png.save_png(self.img_name)
		
		self.img_name = null
		self.new_img = null
		self.hide()


func _on_discard_pressed() -> void:
	self.img_name = null
	self.new_img = null
	self.hide()
