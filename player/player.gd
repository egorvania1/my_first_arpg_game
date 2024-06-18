extends CharacterBody2D

signal healthChanged

@export var speed: int = 70
@onready var animations = $AnimationPlayer

@export var maxHealth: int = 3
@onready var currentHealth: int = maxHealth

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed
	
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

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		#print_debug(collider.name)

func _physics_process(delta):
	handleInput()
	move_and_slide()
	handleCollision()
	updateAnimation()

func damage(attack: Attack):
	currentHealth -= attack.attackDamage
	if currentHealth < 0:
		currentHealth = maxHealth
	healthChanged.emit(currentHealth)
	knockback(attack.attackPosition, attack.knockbackPower)
	
func knockback(enemyVelocity: Vector2, knockbackPower: int):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
