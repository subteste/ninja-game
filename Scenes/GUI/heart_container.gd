extends Panel

@onready var sprite = $Sprite2D

func updateSprite(spriteValue: int):
	if sprite.frame == 4:
		sprite.frame = 4
	else:
		sprite.frame = spriteValue
