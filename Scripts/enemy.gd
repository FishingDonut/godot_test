extends CharacterBody2D

const SPEED = 50.0
const JUMP_VELOCITY = -200.0

@onready var sprite := $enemySprite as Sprite2D
@onready var animation := $AnimationEnemy as AnimationPlayer
@onready var detectd_wall := $detectd_wall as RayCast2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := 1
var is_dead := false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	if !is_dead:
		if direction:
			velocity.x = direction * SPEED
			sprite.scale.x = direction
			animation.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			animation.play("idle")
		
		if detectd_wall.is_colliding():
			detectd_wall.scale.x *= -1
			direction *= -1
			if direction != 0:
				sprite.flip_h = false
			else:
				sprite.flip_h = true
			
		move_and_slide()
		
