extends Object

signal POI_finish

static func generate_POI_positions() -> void:
	var POI_image = NoiseTexture2D.new()
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = RandomNumberGenerator.new().randi()
	noise.frequency = .02
	POI_image.noise = noise
	await POI_image.changed
	var image: Image = POI_image.get_image()
	image.adjust_bcs(1, 2, 0)
	image.save_png("res://Build/owo.png")
	var positions: Array[Vector2i] = []
	var tempImage: Image = Image.create_empty(512,512, true, Image.FORMAT_BPTC_RGBA)
	tempImage.decompress()
	for x: int in range(0, image.get_width()):
		for y: int in range(0, image.get_height()):
			if image.get_pixel(x, y).ok_hsl_l == 0.0:
				if !distance(positions, Vector2i(x,y), 10.0):
					positions.append(Vector2i(x,y))
					tempImage.set_pixel(x,y, Color.RED)
					DungeonSave.new(image.get_size(), Vector2i(x,y), positions.size()-1)
	tempImage.save_png("res://Build/dungeons.png")
	
static func distance(positions: Array[Vector2i], compare: Vector2i, range: float) -> bool:
	for p: Vector2i in positions:
		if p.distance_to(compare) < range:
			return p.distance_to(compare) < range
	return false
