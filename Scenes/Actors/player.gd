extends CharacterBody2D

@export var speed := 100
@onready var animation = $Sprite2D/AnimationPlayer

func _ready():
	$Sprite2D.set_frame_coords(Vector2i(0, 0))

func get_input():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed

# Update the sprite animation and set its x position to 1 every time it stops.
func update_animation():
	var frame = $Sprite2D.get_frame_coords().x
	if velocity.length() == 0:
		if animation.is_playing():
			animation.stop()
	else:
		var walk = 'Down'
		if velocity.y < 0: walk = 'Up'
		elif velocity.x > 0: walk = 'Right'
		elif velocity.x < 0: walk = 'Left'
		animation.play('walk' + walk)

# Main loop of the player node.
func _physics_process(_delta):
	get_input()
	move_and_slide()
	update_animation()


