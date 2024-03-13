extends CharacterBody2D

@export var SPEED = 20.0
@export var pieces : PackedStringArray
const JUMP_VELOCITY = -200.0
const box_pieces = preload("res://prefabs/particles_box.tscn")

@onready var sprite := $enemySprite as Sprite2D
@onready var animation := $AnimationEnemy as AnimationPlayer
@onready var detectd_wall := $detectd_wall as RayCast2D
@onready var colision_shape := $enemyCollision as CollisionShape2D
@onready var direction := 1


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_hurt := false
var impulse := 200

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if direction:
		velocity.x = direction * SPEED
		sprite.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if detectd_wall.is_colliding():
		detectd_wall.scale.x *= -1
		direction *= -1
		if direction != 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
		
	_set_state()
	move_and_slide()

func take_damage():
	direction = 0
	sprite.modulate = Color(1, 0, 0, 1)
	var enemyTween = get_tree().create_tween()
	enemyTween.tween_property(colision_shape, "disabled", true, 0)
	enemyTween.tween_property(self, "trasnformer", Vector2(direction, -50), 0.3)
	enemyTween.parallel().tween_property(sprite, "flip_v", true, 0.1)
	
	is_hurt = true
	await get_tree().create_timer(0.5).timeout
	is_hurt = false
	queue_free()
	
func _set_state():
	var state = "idle"
	
	if is_hurt:
		state = "hurt"
	elif direction != 0:
		state = "run"
	elif !is_on_floor():
		state = "jump"
	
	if animation.name != state:
		animation.play(state)

func break_sprite():
	is_hurt = true
	direction = 0
	await get_tree().create_timer(0.15).timeout
	for piece in pieces.size():
		var piece_instance = box_pieces.instantiate()
		get_parent().add_child(piece_instance)
		piece_instance.get_node("texture").texture = load(pieces[piece])
		piece_instance.global_position = global_position
		piece_instance.apply_impulse(Vector2(randi_range(-impulse, impulse), randi_range(-impulse, -impulse * 2)))
	queue_free()
	

func _on_hit_body_area_entered(area):
	if area.name == "HitPuch":
		break_sprite()
