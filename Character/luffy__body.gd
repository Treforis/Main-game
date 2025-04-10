extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var punch_timer = $Punchtimer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle horizontal movement
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handle punch input (only if not already punching)
	if Input.is_action_just_pressed("punch") and punch_timer.is_stopped():
		animated_sprite.play("Punch")
		punch_timer.start()
		return # Skip other animation updates while punching

	# Animation logic only when not punching
	if punch_timer.is_stopped():
		if velocity.x != 0:
			animated_sprite.play("Running")
			animated_sprite.flip_h = velocity.x > 0
		else:
			animated_sprite.play("Idle")

	move_and_slide()

func _on_PunchTimer_timeout():
	animated_sprite.stop()
