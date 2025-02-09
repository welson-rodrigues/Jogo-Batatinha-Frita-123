extends CharacterBody3D

@export var velocidade_normal = 3.0
@export var pular : TouchScreenButton
@export var joystick : VirtualJoystick
@export var som_passos: AudioStream  # Som de passos
@export var intervalo_entre_passos: float = 0.5  # Intervalo entre os sons dos passos
@onready var cabeca = %cabeca
@onready var camera = $cabeca/Camera3D

const JUMP_VELOCITY = 4.5
const sensibilidade = 0.3

var SPEED = velocidade_normal
var direction = Vector3.ZERO
var input_dir = Vector2.ZERO
var tempo_para_proximo_passo: float = 0.0  # Temporizador para controlar os passos
var audio_player: AudioStreamPlayer  # Player para reproduzir o som

const BOB_FREQ = 3.1
const BOB_AMP = 0.09
var t_bob = 0.0

func _ready() -> void:
	# Configura o AudioStreamPlayer para os passos
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = som_passos

func _input(event: InputEvent) -> void:
	# Controle da câmera pelo touch
	if event is InputEventScreenDrag:
		if event.position.x >= get_viewport().size.x / 3:
			%cabeca.rotate_x(-deg_to_rad(event.relative.y) * sensibilidade)
			rotate_y(-deg_to_rad(event.relative.x) * sensibilidade)
			
		# Limita a rotação vertical da câmera
		%cabeca.rotation.x = clamp(%cabeca.rotation.x, deg_to_rad(-45), deg_to_rad(80))

func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Pular
	if pular.is_pressed() and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Entrada de movimento
	if joystick:
		input_dir = joystick.output
	else:
		input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Calcula a direção do movimento
	if input_dir.length() > 0:
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		# Controle do som de passos (somente no chão e em movimento)
		if is_on_floor():
			tempo_para_proximo_passo -= delta
			if tempo_para_proximo_passo <= 0.0:
				_tocar_som_passos()
				tempo_para_proximo_passo = intervalo_entre_passos
	else:
		# Diminui gradualmente a velocidade quando não há entrada de movimento
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		tempo_para_proximo_passo = 0.0  # Reseta o temporizador quando parado
		
		# Para o som de passos se o jogador parar
		if audio_player.playing:
			audio_player.stop()

	# Para o som se estiver no ar (durante pulo ou queda)
	if not is_on_floor() and audio_player.playing:
		audio_player.stop()

	t_bob += delta * velocity .length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob) 

	# Movimenta o jogador
	move_and_slide()

func _tocar_som_passos():
	if audio_player and not audio_player.playing:
		audio_player.play()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
