extends Camera2D

@export var tilemap: TileMap

func _ready():
	var mapRect = tilemap.get_used_rect()
	var cellSize = tilemap.cell_quadrant_size
	var worldSizeInPixels = mapRect.size * cellSize
	limit_right = worldSizeInPixels.x
	limit_bottom = worldSizeInPixels.y
