extends Node2D

@onready var heartGUI = $CanvasLayer/BoxHeartContainer
@onready var player = $Player

func _ready():
	heartGUI.setMaxHearts(player.maxHearts)
