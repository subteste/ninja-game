extends CharacterBody2D

class_name Player

signal healthChanged

var facingDirection : String = 'Down'
@onready var isAttacking : bool = false

@export var knockbackPower = 500
@export var speed: float = 100
@onready var animation = $AnimationPlayer

@export var maxHearts: int = 3
var maxHealth: int = maxHearts * 4
@onready var currentHealth: int = maxHealth
var healthRegained: bool = false

@onready var hand = $Hand
@onready var attack_timer = $AttackTimer

func _ready():
	$Sprite2D.set_frame_coords(Vector2i(0, 0))
	attack_timer.connect("timeout", _on_AttackTimer_timeout)

func get_input():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed

func update_animation():
	if isAttacking:
		velocity = Vector2.ZERO
	
	if velocity.length() == 0:
		if animation.is_playing():
			animation.stop()
	else:
		if velocity.y > 0: facingDirection = 'Down'
		if velocity.y < 0: facingDirection = 'Up'
		elif velocity.x > 0: facingDirection = 'Right'
		elif velocity.x < 0: facingDirection = 'Left'
		isAttacking = false
		animation.play('walk' + facingDirection)
	
	if Input.is_action_just_pressed("attack"):
		animation.play('attack' + facingDirection)
		isAttacking = true
		attack_timer.start()

func _physics_process(_delta):
	get_input()
	update_animation()
	move_and_slide()



# Add a function that sets isAttacking to false when the timer times out
func _on_AttackTimer_timeout():
	isAttacking = false
	animation.play('walk' + facingDirection)


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
