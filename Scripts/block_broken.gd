extends CharacterBody2D

const box_pieces = preload("res://prefabs/particles_box.tscn")

@onready var anim := $anim as AnimationPlayer

@export var pieces : PackedStringArray
@export var hitpoints := 3

var impulse := 100

func break_sprite():
	if hitpoints <= 0:
		for piece in pieces.size():
			var piece_instance = box_pieces.instantiate()
			get_parent().add_child(piece_instance)
			piece_instance.get_node("texture").texture = load(pieces[piece])
			piece_instance.global_position = global_position
			piece_instance.apply_impulse(Vector2(randi_range(-impulse, impulse), randi_range(-impulse, -impulse * 2)))
		queue_free()
	else:
		anim.play("hit")
		hitpoints -= 1
