extends Panel

@onready var sprite = $Sprite2D

func updateSprite(spriteValue: int, healthRegained: bool):
	if sprite.frame == 4 and healthRegained == false:
		sprite.frame = 4
	else:
		sprite.frame = spriteValue
