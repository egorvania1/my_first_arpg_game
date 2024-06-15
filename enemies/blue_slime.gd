extends CharacterBody2D

var startPosition
var endPosition

var player
var state = "WANDER"

@export var SPEED = 30
@export var limit = 0.5
@export var endPoint: Marker2D

@onready var animations = $AnimationPlayer

func _ready():
	player = get_node("/root/World/TileMap/Player")
	startPosition = position
	endPosition = endPoint.global_position
	
func changeDirection():
	var tempPosition = endPosition	
	endPosition = startPosition
	startPosition = tempPosition
	
func updateVelocity():
	var moveDirection
	match state:
		"WANDER":
			moveDirection = endPosition - position
			if moveDirection.length() < limit:
				changeDirection()
		"CHASE":
			moveDirection = global_position.direction_to(player.global_position) 
	velocity = moveDirection.normalized() * SPEED

func updateAnimation():
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
		animations.play("walk" + direction)

func _physics_process(delta):
	updateVelocity()
	move_and_slide()
	updateAnimation()

func _on_slime_vision_body_entered(body):
	if body == player:
		state = "CHASE"

func _on_slime_vision_body_exited(body):
	if body == player:
		state = "WANDER"
