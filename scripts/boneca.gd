extends Node3D

@export var canto_duracao: float = 3.0  # Tempo que a boneca canta (em segundos)
@export var observacao_duracao: float = 2.0  # Tempo que a boneca observa (em segundos)
@export var angulo_frente: float = 0.0  # Ângulo inicial (boneca virada para frente)
@export var angulo_observacao: float = 180.0  # Ângulo de observação (boneca virada para trás)

@export var som_canto: AudioStream  # Som do canto da boneca
var audio_player: AudioStreamPlayer

var is_observando = false  # Estado da boneca: observando ou cantando
var timer: Timer

func _ready():
	# Configura um Timer para controlar os ciclos
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_trocar_estado)
	add_child(timer)
	
	# Adiciona o áudio do canto da boneca
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = som_canto
	
	_iniciar_ciclo()  # Começa o ciclo de canto/observação

func _iniciar_ciclo():
	is_observando = false
	_set_angulo(angulo_frente)
	print("Boneca está cantando...")
	_tocar_canto()
	timer.start(canto_duracao)

func _trocar_estado():
	if is_observando:
		_iniciar_ciclo()  # Volta a cantar
	else:
		print("Boneca está observando!")
		_set_angulo(angulo_observacao)
		is_observando = true
		timer.start(observacao_duracao)

func _tocar_canto():
	if audio_player and som_canto:
		audio_player.play()

func _set_angulo(alvo_angulo: float):
	# Aplica o ângulo diretamente
	rotation_degrees.y = alvo_angulo
