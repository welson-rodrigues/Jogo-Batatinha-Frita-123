extends Area3D

@export var cena_vitoria: PackedScene  # A cena de vitória que será carregada

func _ready():
		connect("body_entered", _quando_jogador_toca)
		
func _quando_jogador_toca(body):
	if body is CharacterBody3D:  # Verifica se é o jogador
		print("Jogador chegou ao final!")
		mudar_para_tela_vitoria()
									
func mudar_para_tela_vitoria():
	get_tree().change_scene_to_file("res://cenas/menu.tscn")
											
