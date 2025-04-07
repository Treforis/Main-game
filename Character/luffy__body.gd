extends CharacterBody2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var Punch_Timer = $Punchtimer
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
	
	if Input.is_action_just_pressed("punch") and Punch_Timer.is_stopped():
		animated_sprite.play("Punch")
		Punch_Timer.start()
		
	if Punch_Timer.is_stopped():
		if not is_on_floor():
			animated_sprite.play("Jump")
		elif velocity.x != 0:
			animated_sprite.play("Running")
			animated_sprite.flip_h = velocity.x > 0
		else:
			animated_sprite.play("Idle")


	move_and_slide()
	
func _on_PunchTimer_timeout():
	animated_sprite.stop()

func punch():
	$PunchHitbox.monitoring = true
	$PunchHitbox.visible = true  
	$PunchHitbox/Timer.start()
