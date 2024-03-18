extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var lifes := 6

@onready var animation := $AnimationPlayer as AnimationPlayer
@onready var sprite := $SpritePlayer as Sprite2D
@onready var remote := $remote as RemoteTransform2D
@onready var knockback_vector := Vector2.ZERO
@onready var ray_right := $Knockback_right as RayCast2D
@onready var ray_left := $Knockback_left as RayCast2D
@onready var hitPuch := $HitPuch as Area2D
@onready var make_ghost_2d = $MakeGhost2d


@onready var direction := 0

var is_jump := false
var is_puch := false
var is_hurt := false
var is_kick := false

signal player_has_died

func _physics_process(delta):
	make_ghost_2d.sprite = sprite
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jump = true
		effect_jump()
	elif Input.is_action_just_pressed("ui_accept") and !is_on_floor():
		is_kick = true
		velocity.y = (gravity * delta) * 10
	elif is_on_floor():
		if is_jump:
			pass
		is_jump = false
		is_kick = false


	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			sprite.flip_h = false
		elif direction < 0:
			sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector

	if Input.is_key_label_pressed(KEY_P):
		_action_puch()

	_set_state()
	move_and_slide()


func take_damage(knock_force := Vector2.ZERO, duration := 0.5):
	lifes -= 1

	var tween_knock = get_tree().create_tween()
	knockback_vector = knock_force
	tween_knock.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
	sprite.modulate = Color(1, 0, 0, 1)
	tween_knock.tween_property(sprite, "modulate", Color(1, 1, 1, 1), duration)
	is_hurt = true
	await get_tree().create_timer(.4).timeout
	is_hurt = false

func _set_state():
	var state = "idle"
	
	if is_hurt:
		state = "hurt"
	elif !is_on_floor() and is_kick:
		state = "jump_kick"
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


func _on_hit_head_body_entered(body):
	if body.has_method("break_sprite"):
		body.break_sprite() 

func _action_puch():
	var tween = get_tree().create_tween()
	tween.tween_property(hitPuch, "position", Vector2(sprite.scale.x * 10, 0), 0.1)
	tween.tween_property(hitPuch, "position", Vector2(0, 0), 0.1)  

func effect_jump():
	var tween_animation = create_tween()
	tween_animation.tween_property(sprite, "scale", Vector2(1.4 *sprite.scale.x , 0.6), 0.0)
	tween_animation.parallel().tween_property(sprite, "position", Vector2(0, 4), 0.0)
	tween_animation.tween_property(sprite, "scale", Vector2(1*sprite.scale.x,1), 0.1)
	tween_animation.parallel().tween_property(sprite, "position", Vector2(0, 0), 0.1)


func _on_hurt_box_body_entered(body):
	if body.is_in_group("enemy"):
		if ray_right.is_colliding():
			take_damage(Vector2(-300, JUMP_VELOCITY * 0.2))
		elif ray_left.is_colliding():
			take_damage(Vector2(300, JUMP_VELOCITY * 0.2))
		else:
			take_damage(Vector2(sprite.scale.x * -200, JUMP_VELOCITY * 0.2))
			
		if lifes <= 0:
			queue_free()
			emit_signal("player_has_died")
