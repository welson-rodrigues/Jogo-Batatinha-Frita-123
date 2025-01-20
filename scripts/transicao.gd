extends CanvasLayer

var nova_cena := ""
func fade_to_scene(_nova_cena: String) -> void:
	_nova_cena = _nova_cena
	$AnimationPlayer.play("fade")

func change_scene() -> void:
	get_tree().change_scene(nova_cena)
