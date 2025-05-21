extends CharacterBody2D

# RayCast2D nodes
@onready var ray_up = $RayUp
@onready var ray_down = $RayDown
@onready var ray_left = $RayLeft
@onready var ray_right = $RayRight
@onready var ray_up_left = $RayUpLeft
@onready var ray_up_right = $RayUpRight
@onready var ray_down_left = $RayDownLeft
@onready var ray_down_right = $RayDownRight

# Player and movement tracking
var target = null
var fallback_direction = "right"
var last_failed_direction = ""

# Timer to avoid rapid direction switching
var change_direction_timer := 0.0
const CHANGE_DIR_DELAY := 0.5

# Movement vectors for all 8 directions
var direction_vectors = {
	"up": Vector2(0, -1),
	"down": Vector2(0, 1),
	"left": Vector2(-1, 0),
	"right": Vector2(1, 0),
	"up_left": Vector2(-1, -1).normalized(),
	"up_right": Vector2(1, -1).normalized(),
	"down_left": Vector2(-1, 1).normalized(),
	"down_right": Vector2(1, 1).normalized(),
}

const SPEED = 150.0

func _ready():
	target = GameData.player_ref
	randomize()

func _physics_process(delta: float) -> void:
	if target == null:
		return

	change_direction_timer -= delta

	var chase_direction = (target.position - position).normalized()
	fallback_direction = get_cardinal_direction(chase_direction)
	var current_ray = get_current_ray(fallback_direction)

	if current_ray and current_ray.is_colliding():
		if change_direction_timer <= 0:
			fallback_direction = pick_new_direction()
			change_direction_timer = CHANGE_DIR_DELAY
		velocity = direction_vectors[fallback_direction] * SPEED
	else:
		velocity = chase_direction * SPEED
		change_direction_timer = 0
		last_failed_direction = ""  # Reset memory when path is clear

	move_and_slide()
	print("Direction:", fallback_direction, " | Velocity:", velocity, " | Pos:", position)

func get_cardinal_direction(vec: Vector2) -> String:
	var angle = vec.angle()
	if angle >= -PI/8 and angle < PI/8:
		return "right"
	elif angle >= PI/8 and angle < 3*PI/8:
		return "down_right"
	elif angle >= 3*PI/8 and angle < 5*PI/8:
		return "down"
	elif angle >= 5*PI/8 and angle < 7*PI/8:
		return "down_left"
	elif angle >= 7*PI/8 or angle < -7*PI/8:
		return "left"
	elif angle >= -7*PI/8 and angle < -5*PI/8:
		return "up_left"
	elif angle >= -5*PI/8 and angle < -3*PI/8:
		return "up"
	elif angle >= -3*PI/8 and angle < -PI/8:
		return "up_right"
	else:
		return "right"

func get_current_ray(dir_name: String) -> RayCast2D:
	match dir_name:
		"up": return ray_up
		"down": return ray_down
		"left": return ray_left
		"right": return ray_right
		"up_left": return ray_up_left
		"up_right": return ray_up_right
		"down_left": return ray_down_left
		"down_right": return ray_down_right
		_: return null

func pick_new_direction() -> String:
	var options = []
	var all_dirs = {
		"up": ray_up,
		"down": ray_down,
		"left": ray_left,
		"right": ray_right,
		"up_left": ray_up_left,
		"up_right": ray_up_right,
		"down_left": ray_down_left,
		"down_right": ray_down_right
	}

	# Collect all non-colliding directions that are not the last failed
	for dir_name in all_dirs.keys():
		var ray = all_dirs[dir_name]
		if not ray.is_colliding() and dir_name != last_failed_direction:
			options.append(dir_name)

	if options.size() > 0:
		var new_direction = options[randi() % options.size()]
		last_failed_direction = new_direction
		print("Picked new direction:", new_direction)
		return new_direction
	else:
		# Try any non-colliding direction (even if it's the last failed)
		var all_non_colliding = []
		for dir_name in all_dirs.keys():
			if not all_dirs[dir_name].is_colliding():
				all_non_colliding.append(dir_name)

		if all_non_colliding.size() > 0:
			var new_direction = all_non_colliding[randi() % all_non_colliding.size()]
			last_failed_direction = new_direction
			print("All blocked except (reused):", new_direction)
			return new_direction

		# Fully stuck: choose random direction anyway
		var fallback = all_dirs.keys()[randi() % all_dirs.size()]
		print("Fully trapped — forcing move to:", fallback)
		return fallback
