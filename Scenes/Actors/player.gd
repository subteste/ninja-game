extends CharacterBody2D

class_name Player

signal healthChanged

@export var knockbackPower = 500
@export var speed: float = 100
@onready var animation = $AnimationPlayer

@export var maxHearts: int = 3
var maxHealth: int = maxHearts * 4
@onready var currentHealth: int = maxHealth
var healthRegained: bool = false


func _ready():
	$Sprite2D.set_frame_coords(Vector2i(0, 0))

func get_input():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed

func update_animation():
	if velocity.length() == 0:
		if animation.is_playing():
			animation.stop()
	else:
		var walk = 'Down'
		if velocity.y < 0: walk = 'Up'
		elif velocity.x > 0: walk = 'Right'
		elif velocity.x < 0: walk = 'Left'
		animation.play('walk' + walk)

func _physics_process(_delta):
	get_input()
	move_and_slide()
	update_animation()



func _on_hurt_box_area_entered(area):
	if area.name == "SlimeHitBox":
		currentHealth -= 1
		healthRegained = false
		if currentHealth < 0:
			currentHealth = maxHealth
			healthRegained = true
		healthChanged.emit(currentHealth, healthRegained)
		knockback(area.get_parent().velocity)


func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
