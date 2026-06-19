extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var size := 16
	var image := Image.create(size, size, false, Image.FORMAT_RGBA8)
	for y in size:
		for x in size:
			var u := float(x) / float(size - 1)
			var v := float(y) / float(size - 1)
			image.set_pixel(x, y, Color(u, v, 0.0, 1.0))
	var texture := ImageTexture.create_from_image(image)
	material.set_shader_parameter("source_texture", texture)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
