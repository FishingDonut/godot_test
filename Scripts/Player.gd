extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation := $PlayerAnimated as AnimatedSprite2D
@onready var remote := $remote as RemoteTransform2D
var is_jump := false
var is_puch := false

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
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction
		
		if is_on_floor() and !is_jump:
			animation.play("run")
		elif is_jump:
			animation.play("jump")
			
	elif is_jump:
		animation.play("jump")
	elif is_on_floor() and Input.is_key_label_pressed(KEY_P):
		animation.play("puch")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle")

	move_and_slide()


func _on_hurtbox_body_entered(body):
	print("toque")
	if body.is_in_group("enemy"):
		queue_free()

func follow_camera(camera):
	remote.remote_path = camera.get_path()
