extends Node2D

func _ready():
	# Connect "2ndmenu" input event to load the level
	$"2ndmenu".connect("input_event", Callable(self, "_on_2ndmenu_input"))
	
	# Connect "areasett" input event to go to settings
	$areasett.connect("input_event", Callable(self, "_on_GoSettings_input"))
	
	# Connect "areaundo" input event to go back to the area_2d scene
	$areaundo.connect("input_event", Callable(self, "_on_Undo_input"))
	
	# Connect "areaquit" input event to quit the game
	var areaquit_node = $areaquit
	if areaquit_node:
		areaquit_node.connect("input_event", Callable(self, "_on_Quit_input"))
	else:
		print("Error: 'areaquit' node not found in scene!")

func _on_2ndmenu_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Clicked Play on 2ndmenu - loading level1")
		get_tree().change_scene_to_file("res://level1.tscn")

func _on_GoSettings_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("GoSettings clicked - transitioning to insettings")
		get_tree().change_scene_to_file("res://insettings.tscn")

# New function to handle the "Undo" button click
func _on_Undo_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Undo clicked - returning to area_2d")
		get_tree().change_scene_to_file("res://area_2d.tscn")

# New function to handle the "Quit" button click (closes the game)
func _on_Quit_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Quit clicked - closing the game")  # Debugging message
		get_tree().quit()  # This will close the game
