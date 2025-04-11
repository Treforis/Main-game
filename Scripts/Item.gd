extends Node
class_name Item

@export var item_name: String
@export var description: String
@export var icon: Texture2D
@export var item_type: String  # "fruit" or "weapon"

func use(user):
	pass  
