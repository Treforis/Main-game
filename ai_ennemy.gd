extends CharacterBody2D

var target = GameData.player_ref

const SPEED = 150.0



func _physics_process(delta: float) -> void:
	var direction = (target.position-position).normalized()
	velocity = direction * SPEED
	look_at(target.position)
	move_and_slide()
