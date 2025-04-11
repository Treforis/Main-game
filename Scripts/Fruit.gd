extends Item

class_name Fruit

@export var effect_type: String

func use(user):
	user.apply_fruit_effect(effect_type)
