extends HBoxContainer

var heartContainer = preload("res://Scenes/GUI/heart_container.tscn")


func setMaxHearts(amountHearts: int):
	for i in range(amountHearts):
		var heart = heartContainer.instantiate()
		add_child(heart)


func updateHearts(currentHealth: float, healthRegained: bool):
	currentHealth = currentHealth/4
	var fullHeart = int(currentHealth)
	var spriteValue = 4 - int((currentHealth - fullHeart) * 4)
	var hearts = get_children()

	for i in range(hearts.size()):
		if i < fullHeart: hearts[i].updateSprite(0, healthRegained)
		else: hearts[i].updateSprite(spriteValue, healthRegained)

