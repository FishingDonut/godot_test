extends Node2D

@onready var force_impact := 250

func _on_area_colision_body_entered(body):
	if body.name == "Player":
		body.take_damage(Vector2(body.direction * force_impact, body.JUMP_VELOCITY * 1.3))
