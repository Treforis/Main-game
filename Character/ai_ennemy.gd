extends CharacterBody2D

var target = GameData.player_ref

const SPEED = 100

func _ready() -> void:
	target = GameData.player_ref

func _physics_process(delta: float) -> void:
	if target == null:
		return
	var direction = (target.position-position).normalized()
	velocity = direction * SPEED
	move_and_slide()
