extends Node2D

func _ready():
	# Back button
	$Area2D.connect("input_event", Callable(self, "_on_BackButton_input"))

	# Connect aqm to handle colqm click
	$aqm.connect("input_event", Callable(self, "_on_QM_clicked"))

func _on_BackButton_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Back button clicked - returning to menu2")
		get_tree().change_scene_to_file("res://menu2.tscn")

func _on_QM_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("colqm clicked - Hiding aqm, Showing aq1")
		$aqm.visible = false
		$aq1.visible = true
