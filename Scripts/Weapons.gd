extends Item
class_name Weapon

@export var damage: int
@export var attack_speed: float = 1.0

func use(user):
	user.equip_weapon(self)
