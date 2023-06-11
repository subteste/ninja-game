extends Node2D

@onready var heartGUI = $CanvasLayer/BoxHeartContainer
@onready var player = $Player



func _ready():
	heartGUI.setMaxHearts(player.maxHearts)
	heartGUI.updateHearts(player.currentHealth, false)
	player.healthChanged.connect(heartGUI.updateHearts)
