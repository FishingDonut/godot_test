extends Sprite2D

func _ready():
	_ghost_start()
	
func _ghost_start():
	var tween_ghost = create_tween()
	tween_ghost.tween_property(self, "modulate:a", 0, 0.4)
	tween_ghost.tween_callback(_ghost_finish)
	

func _ghost_finish():
	print("deleted")
	queue_free()
