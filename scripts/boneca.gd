extends Node3D

@export var canto_duracao: float = 3.0  # Tempo que a boneca canta
@export var observacao_duracao: float = 2.0  # Tempo que a boneca observa
@export var angulo_frente: float = 0.0  # Ângulo inicial
@export var angulo_observacao: float = 180.0  # Ângulo de observação
@export var som_canto: AudioStream  # Som do canto da boneca
@export var som_virando: AudioStream  # Som da boneca girando
@export var som_observando: AudioStream  # Som da boneca observando
@export var som_detectado: AudioStream  # Som de detecção do jogador
@export var jogador: CharacterBody3D  # Referência ao jogador

var is_observando = false  # Estado da boneca
var jogador_detectado = false  # Flag para detectar o jogador
var jogador_parado = true  # Verifica se o jogador estava parado no início
var audio_player: AudioStreamPlayer
var audio_player_extra: AudioStreamPlayer
var timer: Timer

func _ready():
	# Configurações iniciais
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_trocar_estado)
	add_child(timer)
	
	# Adiciona players de som
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player_extra = AudioStreamPlayer.new()
	add_child(audio_player_extra)
	
	_iniciar_ciclo()

func _iniciar_ciclo():
	is_observando = false
	jogador_detectado = false
	jogador_parado = true  # Reset para novo ciclo
	_set_angulo(angulo_frente)
	print("Boneca está cantando...")
	_tocar_som(audio_player, som_canto)
	timer.start(canto_duracao)

func _trocar_estado():
	if is_observando:
		# Troca para o modo canto
		_iniciar_ciclo()
	else:
		# Troca para o modo observação
		print("Boneca está girando para observar!")
		_tocar_som(audio_player_extra, som_virando)
		_set_angulo(angulo_observacao)
		is_observando = true
		jogador_detectado = false
		jogador_parado = jogador.velocity.length() == 0  # Verifica se o jogador está parado
		print("Boneca está observando!")
		_tocar_som(audio_player_extra, som_observando)
		timer.start(observacao_duracao)

func _process(delta: float):
	if is_observando and jogador and not jogador_detectado:
		if jogador.velocity.length() > 0:
			if jogador_parado:
				jogador_detectado = true
				print("Jogador se moveu enquanto a boneca estava virada!")
				_tocar_som(audio_player_extra, som_detectado)

func _tocar_som(player: AudioStreamPlayer, som: AudioStream):
	if player and som:
		player.stop()
		player.stream = som
		player.play()

func _set_angulo(alvo_angulo: float):
	rotation_degrees.y = alvo_angulo
