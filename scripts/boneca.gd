extends Node3D

@export var canto_duracao: float = 3.0
@export var observacao_duracao: float = 2.0
@export var angulo_frente: float = 0.0
@export var angulo_observacao: float = 180.0

@export var som_canto: AudioStream
@export var som_virando: AudioStream
@export var som_observando: AudioStream
@export var som_detectado: AudioStream

@export var jogador: CharacterBody3D
@export var canva: CanvasLayer
@export var botoes: Control

var audio_player: AudioStreamPlayer
var audio_player_extra: AudioStreamPlayer
var timer: Timer

var is_observando = false
var jogador_detectado = false

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_trocar_estado)
	add_child(timer)

	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = som_canto

	audio_player_extra = AudioStreamPlayer.new()
	add_child(audio_player_extra)

	_iniciar_ciclo()
	#canva.visible = false

func _iniciar_ciclo():
	is_observando = false
	jogador_detectado = false
	_set_angulo(angulo_frente)
	_tocar_som(audio_player, som_canto)
	timer.start(canto_duracao)

func _trocar_estado():
	if is_observando:
		_iniciar_ciclo()
	else:
		print("Boneca está girando para observar!")
		_tocar_som(audio_player_extra, som_virando)
		_set_angulo(angulo_observacao)
		is_observando = true
		jogador_detectado = false  # Resetar detecção ao começar a observar
		print("Boneca está observando!")
		_tocar_som(audio_player_extra, som_observando)
		timer.start(observacao_duracao)

func _process(delta: float):
	if is_observando and jogador:
		# Verifica se o jogador está se movendo enquanto a boneca está observando
		if jogador.velocity.length() > 0 and not jogador_detectado:
			jogador_detectado = true
			print("Jogador se moveu enquanto a boneca estava virada!")
			_tocar_som(audio_player_extra, som_detectado)
			canva.visible = true
			botoes.visible = false

func _tocar_som(player: AudioStreamPlayer, som: AudioStream):
	if player and som:
		player.stop()
		player.stream = som
		player.play()

func _set_angulo(alvo_angulo: float):
	rotation_degrees.y = alvo_angulo
