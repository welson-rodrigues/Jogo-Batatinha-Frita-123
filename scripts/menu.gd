extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#MusicController.play_music()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/carregamento.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_info_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/creditos.tscn")
