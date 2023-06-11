extends HBoxContainer

var heartContainer = preload("res://Scenes/GUI/heart_container.tscn")


func setMaxHearts(amountHearts: int):
	for i in range(amountHearts):
		var heart = heartContainer.instantiate()
		add_child(heart)


func updateHearts(currentHealth: float):
	currentHealth = currentHealth/4
	var fullHeart = int(currentHealth)
	var spriteValue = 4 - int((currentHealth - fullHeart) * 4)
	var hearts = get_children()

	for i in range(fullHeart, hearts.size()):
		hearts[i].updateSprite(spriteValue)

