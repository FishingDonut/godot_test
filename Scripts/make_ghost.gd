extends Node2D


var ghost_scene = preload("res://prefabs/ghost.tscn")
var ghost_time = 0.0
var ghost_time_interval = 0.05
var sprite

func _ready():
	pass # Replace with function body.


func _process(delta):
	ghost_time += delta
	if ghost_time >= ghost_time_interval:
		ghost_time = 0
		make_ghost()


func make_ghost():
	var ghost_instantiate: Sprite2D = ghost_scene.instantiate()
	get_parent().get_parent().call_deferred("add_child", ghost_instantiate)
	ghost_instantiate.global_position = global_position
	ghost_instantiate.texture 	= sprite.texture
	ghost_instantiate.vframes 	= sprite.vframes
	ghost_instantiate.hframes 	= sprite.hframes
	ghost_instantiate.frame 	= sprite.frame
	ghost_instantiate.flip_h 	= sprite.flip_h
	ghost_instantiate.flip_v 	= sprite.flip_v
	ghost_instantiate.modulate 	= Color(0, 0, 1)
