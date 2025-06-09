extends Node2D

func _ready():
	$Area2D.connect("input_event", Callable(self, "_on_BackSettings_input"))

func _on_BackSettings_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Back button clicked - returning to menu2")
		get_tree().change_scene_to_file("res://menu2.tscn")
