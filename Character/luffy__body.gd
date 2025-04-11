extends CharacterBody2D
class_name LuffyBody

# --- EXISTING SETUP ---
@onready var animated_sprite = $AnimatedSprite2D
@onready var punch_timer = $Punchtimer
@onready var punch_hitbox = $PunchHitbox
@onready var punch_shape = $PunchHitbox/CollisionShape2D
@onready var body_hitbox = $CollisionShape2D

var punch_offset := Vector2(30, 0)
const SPEED = 300.0

# --- NEW ITEM SYSTEM ---
var inventory: Array[Item] = []
var current_weapon: Weapon = null
var active_fruit: String = ""

func _ready():
	punch_hitbox.monitoring = false
	punch_hitbox.visible = false
	
func _physics_process(delta: float) -> void:
	var direction_x := Input.get_axis("left", "right")
	var direction_y := Input.get_axis("up", "down")

	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Punch input
	if Input.is_action_just_pressed("punch") and punch_timer.is_stopped():
		animated_sprite.play("Punch")
		punch_timer.start()
		punch_shape.disabled = false

		var flip = animated_sprite.flip_h
		var offset = punch_offset
		if flip:
			offset = -punch_offset
		punch_hitbox.position = -offset
		punch_hitbox.monitoring = true
		punch_hitbox.visible = true
		return 

	if punch_timer.is_stopped():
		punch_shape.disabled = true
		punch_hitbox.position = Vector2(0, 0)
		if velocity.x != 0 or velocity.y != 0:
			animated_sprite.play("Running")
			animated_sprite.flip_h = velocity.x > 0 
		else:
			animated_sprite.play("Idle")

	move_and_slide()

func _on_PunchTimer_timeout():
	punch_hitbox.monitoring = false
	punch_hitbox.visible = false
	animated_sprite.stop()

# --- ITEM SYSTEM FUNCTIONS ---

func pick_up_item(item: Item):
	inventory.append(item)
	print("Picked up: %s" % item.item_name)
	item.use(self)  # Auto-use item on pickup

func equip_weapon(weapon: Weapon):
	current_weapon = weapon
	print("Equipped weapon: %s (Damage: %d)" % [weapon.item_name, weapon.damage])

func apply_fruit_effect(effect_type: String, duration: float):
	active_fruit = effect_type
	print("Activated fruit power: %s" % effect_type)
