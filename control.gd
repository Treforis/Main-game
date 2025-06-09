extends Node2D

func _ready():
	# Connect the "Menu" button
	$Menu.connect("input_event", Callable(self, "_on_Menu_input"))
	
	# Connect areaquit signal (the Area2D node, not the CollisionShape)
	$areaquit.connect("input_event", Callable(self, "_on_Quit_input"))

func _on_Menu_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Clicked the Menu Area2D - transitioning to menu2")
		get_tree().change_scene_to_file("res://menu2.tscn")

func _on_Quit_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Quit clicked - closing game")
		get_viewport().get_window().close()
