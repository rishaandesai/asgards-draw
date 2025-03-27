extends Sprite2D

func _ready():
	var width = 12
	var height = 7
	var img = Image.create(width, height, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	
	for y in range(height):
		for x in range(width):
			var nx = (x - width / 2.0 + 0.5) / (width / 2.0)
			var ny = (y - height / 2.0 + 0.5) / (height / 2.0)
			if nx * nx + ny * ny <= 0.95:
				img.set_pixel(x, y, Color(0, 0, 0, 0.35))
	
	var tex = ImageTexture.create_from_image(img)
	texture = tex
	set_texture_filter(CanvasItem.TEXTURE_FILTER_NEAREST)
	scale = Vector2(3, 3)
	position.y += 4
