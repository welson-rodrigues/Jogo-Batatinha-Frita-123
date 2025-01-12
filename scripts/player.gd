extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 4.5
const sensibilidade = 0.2
@export var joystick : VirtualJoystick
var input_dir
var direction = Vector3.ZERO

func _input(event):
	if event is InputEventScreenDrag:
		if event.position.x >= get_viewport().size.x / 2:
			%cabeca.rotate_x(-deg_to_rad(event.relative.y) * sensibilidade)
			rotate_y(-deg_to_rad(event.relative.x) * sensibilidade)
			
			%cabeca.rotation.x = clamp(%cabeca.rotation.x, deg_to_rad(-45), deg_to_rad(80))

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if joystick:
		input_dir = joystick.output
	else:
		input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), 0.5)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
