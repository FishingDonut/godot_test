extends CanvasLayer
@onready var resume = $ContainerRow/resume

func _ready():
	visible = false
	
func _unhandled_input(event):
	if event.is_action_pressed("esc"):
		get_tree().paused = true
		visible = true
		resume.grab_focus()
		
func _on_resume_pressed():
	visible = false
	get_tree().paused = false


func _on_exit_pressed():
	get_tree().quit()
