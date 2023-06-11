extends HBoxContainer

var heartContainer = preload("res://Scenes/GUI/heart_container.tscn")



func setMaxHearts(amountHearts: int):
	for i in range(amountHearts):
		var heart = heartContainer.instantiate()
		add_child(heart)
