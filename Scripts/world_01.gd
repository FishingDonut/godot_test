extends Node2D

@onready var player := $Player as CharacterBody2D
@onready var camera := $Camera2D as Camera2D
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.coins = 0
	Globals.score = 0
	player.follow_camera(camera)
	player.player_has_died.connect(reload_game)
 
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reload_game():
	await get_tree().create_timer(0.3).timeout
	get_tree().reload_current_scene()
