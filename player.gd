extends CharacterBody2D

const SPEED = 350.0
const JUMP_VELOCITY = -400.0

var gravity_direction = 1
@onready var spawn_position = global_position

func _physics_process(delta: float) -> void:
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

	# Inversione della gravità con la barra spaziatrice
	if Input.is_action_just_pressed("ui_accept"):
		gravity_direction *= -1

	# Gestione gravità in base alla direzione corrente
	if not is_on_floor() and gravity_direction == 1:
		velocity.y += gravity * delta
	elif not is_on_ceiling() and gravity_direction == -1:
		velocity.y -= gravity * delta

	# Salto
	if Input.is_action_just_pressed("ui_up") and (is_on_floor() or is_on_ceiling()):
		velocity.y = JUMP_VELOCITY * gravity_direction

	# Movimento orizzontale
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Controllo caduta nei vuoti (Game Over automatico se vai troppo in basso o fuori schermo)
	if global_position.y > 650 or global_position.y < -150:
		die()

func die() -> void:
	# Riporta il player alla posizione iniziale se cade in un baratro
	global_position = spawn_position
	velocity = Vector2.ZERO
	gravity_direction = 1
