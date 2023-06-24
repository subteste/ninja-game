extends CharacterBody2D

class_name Player

signal healthChanged


#Variables to handle player's movement
@export var knockbackPower = 500
@export var speed: float = 100
@onready var animation = $AnimationPlayer

#Variables to handle player's health
@export var maxHearts: int = 3
var maxHealth: int = maxHearts * 4
@onready var currentHealth: int = maxHealth
var healthRegained: bool = false

#Variables to handle player's attack and direction
var facingDirection : String = 'Down'
var isAttacking : bool = false
var canAttack: bool = true
@onready var cooldown = $AttackCooldown
@onready var hand = $Hand
@onready var attack_timer = $AttackTimer
var weapon_scene = preload("res://Scenes/weapons/sword.tscn")
var angle = {
	"Down": 0,
	"Left": deg_to_rad(90),
	"Up": deg_to_rad(180),
	"Right": deg_to_rad(270)
}


func _ready():
	attack_timer.connect("timeout", _on_AttackTimer_timeout)

func get_input():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed

func update_animation():
	if velocity.length():
		if velocity.y > 0: facingDirection = 'Down'
		if velocity.y < 0: facingDirection = 'Up'
		elif velocity.x > 0: facingDirection = 'Right'
		elif velocity.x < 0: facingDirection = 'Left'
		animation.play('walk' + facingDirection)
	elif isAttacking:
		animation.play('attack' + facingDirection)
	elif velocity.length() == 0:
		animation.stop()

func player_attack():
	if Input.is_action_just_pressed("attack") and canAttack and isAttacking == false:
		isAttacking = true
		canAttack = false
		attack_timer.start()
	
	if isAttacking:
		if hand.get_child_count() == 0:
			var weapon = weapon_scene.instantiate()
			hand.add_child(weapon)
			weapon.rotation = angle[facingDirection]
			
	if isAttacking:
		velocity = Vector2.ZERO

func _physics_process(_delta):
	get_input()
	player_attack()
	update_animation()
	move_and_slide()


#Handles the general attack time, such as cooldown time and the duration of each attack
func _on_AttackTimer_timeout():
	if hand.get_child_count() > 0:
		hand.get_child(0).queue_free()
	isAttacking = false
	animation.play('walk' + facingDirection)
	cooldown.start()
	await cooldown.timeout
	canAttack = true


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
