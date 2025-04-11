extends Fruit


func _ready():
	item_name = "Rubber Fruit"
	description = "Grants rubber powers!"
	effect_type = "rubber"
	icon = preload("res://Assets/Fruits/rubber_fruit.png")
	item_type = "fruit"


func _on_area_entered(body: Node) -> void:
	if body is LuffyBody:
		set_deferred("monitoring", false)
		body.pick_up_item(self)
		queue_free()
