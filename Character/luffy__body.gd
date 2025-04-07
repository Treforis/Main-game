extends CharacterBody2D
@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Animation logic (jump takes priority)
	if not is_on_floor():
		animated_sprite.play("Jump")
	elif velocity.x != 0:
		animated_sprite.play("Running")
		animated_sprite.flip_h = velocity.x > 0
	else:
		animated_sprite.play("Idle")

	move_and_slide()
