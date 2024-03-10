extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := -1
@onready var detect_wall := $friendRayCast as RayCast2D
@onready var animation := $friendSprite as Sprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if detect_wall.is_colliding():
		detect_wall.scale.x *= -1
		direction *= -1
		if direction > 0:
			animation.flip_h = true
		else:
			animation.flip_h = false
					
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
