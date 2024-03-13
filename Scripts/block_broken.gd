extends CharacterBody2D

const box_pieces = preload("res://prefabs/particles_box.tscn")
const solid_coin = preload("res://prefabs/solid_coin.tscn")

@onready var anim := $anim as AnimationPlayer
@onready var spaw_coin := $spawn_coin as Marker2D;

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
		spawnCoin()
		hitpoints -= 1
		
func spawnCoin():
	var coin_instantiate = solid_coin.instantiate()
	get_parent().call_deferred("add_child", coin_instantiate)
	coin_instantiate.global_position = spaw_coin.global_position
	coin_instantiate.apply_impulse(Vector2(randi_range(-70,70), -200))
