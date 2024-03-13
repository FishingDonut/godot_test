extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := -1
@onready var detect_wall := $friendRayCast as RayCast2D
@onready var sprite := $friendSprite as Sprite2D
@onready var animation := $friendAnimation as AnimationPlayer

const box_pieces = preload("res://prefabs/particles_box.tscn")

@export var pieces : PackedStringArray
@export var hitpoints := 3

var impulse := 100


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if detect_wall.is_colliding():
		detect_wall.scale.x *= -1
		direction *= -1
		if direction > 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
					
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()


func _on_hurt_box_body_entered(body):
	if body.name == "Player":
		body.velocity.y = body.JUMP_VELOCITY * 0.5
		break_sprite()

func break_sprite():
	animation.play("hurt")
	direction = 0
	await get_tree().create_timer(0.15).timeout
	for piece in pieces.size():
		var piece_instance = box_pieces.instantiate()
		get_parent().add_child(piece_instance)
		piece_instance.get_node("texture").texture = load(pieces[piece])
		piece_instance.global_position = global_position
		piece_instance.apply_impulse(Vector2(randi_range(-impulse, impulse), randi_range(-impulse, -impulse * 2)))
	queue_free()
