extends CharacterBody2D

@export var speed = 30

@export var endPoint : Marker2D
var endPosition
var startPosition
@export var limit = 0.5
@onready var animation = $AnimationPlayer

func _ready():
	
	startPosition = position
	endPosition = endPoint.global_position

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		position = endPosition
		changeDirection()
	velocity = moveDirection.normalized() * speed
	
func updateAnimation():
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
	updateVelocity()
	move_and_slide()
	updateAnimation()
