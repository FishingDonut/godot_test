extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation := $PlayerAnimated as AnimatedSprite2D
@onready var remote := $remote as RemoteTransform2D
@export var lifes := 6
@onready var knockback_vector := Vector2.ZERO
@onready var ray_right := $Knockback_right as RayCast2D
@onready var ray_left := $Knockback_left as RayCast2D
@onready var direction := 0

var is_jump := false
var is_puch := false
var is_hurt := false

func blink():
	var tweenPlayer = get_tree().create_tween()
	
	if !is_on_floor():
		tweenPlayer.tween_property(self, "modulate", Color(1, 1, 1), 0.15)
	else:
		tweenPlayer.tween_property(self, "modulate", Color(1,0, 0), 1).set_delay(1)
		tweenPlayer.tween_property(self, "modulate", Color(0,0, 1), 1).set_delay(1)

func _physics_process(delta):
	#blink()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jump = true
	elif is_on_floor():
		is_jump = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector

	_set_state()
	move_and_slide()


func _on_hurtbox_body_entered(body):
	if body.is_in_group("enemy"):
		print("dano")
		if ray_right.is_colliding():
			take_damage(Vector2(-300, JUMP_VELOCITY * 0.2))
			print("1")
		if ray_left.is_colliding():
			take_damage(Vector2(300, JUMP_VELOCITY * 0.2))
			print("2")
		if lifes <= 0:
			queue_free()

func take_damage(knock_force := Vector2.ZERO, duration := 0.5):
	lifes -= 1

	var tween_knock = get_tree().create_tween().parallel()
	knockback_vector = knock_force
	tween_knock.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
	animation.modulate = Color(1, 0, 0, 1)
	tween_knock.tween_property(animation, "modulate", Color(1, 1, 1, 1), duration)
	is_hurt = true
	await get_tree().create_timer(.4).timeout
	is_hurt = false

func _set_state():
	var state = "idle"
	
	if is_hurt:
		state = "hurt"
	elif !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
	elif Input.is_key_label_pressed(KEY_P):
		state = "puch"
	
	if animation.name != state:
		animation.play(state)
	
func follow_camera(camera):
	remote.remote_path = camera.get_path()
