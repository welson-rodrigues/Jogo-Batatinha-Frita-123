extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_left"):
		visible = true
		

func _on_revive_pressed() -> void:
	pass # Replace with function body.


func _on_to_give_up_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/menu.tscn")
