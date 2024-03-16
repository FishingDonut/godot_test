extends Node2D

const enemy_prefabs = preload("res://prefabs/enemy.tscn")

@export var active_spawn := true

var spawn_timer = 0.0
var spawn_interval = 2.0

func _ready():
	pass


func _process(delta):
	if active_spawn:
		spawn_timer += delta
		if spawn_timer >= spawn_interval:
			_spawn_enemy()
			spawn_timer = 0.0


func _spawn_enemy():
	var enemy_instantiate = enemy_prefabs.instantiate()
	get_parent().call_deferred("add_child", enemy_instantiate)
	enemy_instantiate.global_position = global_position
