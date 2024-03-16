extends Area2D

@export var score := 50

@onready var animation := $coinAnimation as AnimatedSprite2D
@onready var colision = $colision

var follow := Vector2.ZERO
var duration_idle := 0.6
var distance_idle := 8
var distance_collect := 20
var duration_collect := 0.3
var coins := 1

# Called when the node enters the scene tree for the first time.

func _ready():
	move_coin()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	animation.position = follow


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var coinTween = create_tween().set_loops().set_trans(Tween.TRANS_QUAD)
	coinTween.tween_property(self, "follow", Vector2.UP * distance_collect, duration_collect)
	animation.play("collect")
	await colision.call_deferred("queue_free")
	Globals.coins += 1
	Globals.score += score


func _on_coin_animation_animation_finished():
	var rigid_body = self.get_parent()
	rigid_body.queue_free()
	self.queue_free()


func move_coin():
	var coinTween = create_tween().set_loops().set_trans(Tween.TRANS_QUAD)
	coinTween.tween_property(self, "follow", Vector2.UP * distance_idle, duration_idle)
	coinTween.tween_property(self, "follow", Vector2.ZERO, duration_idle)
