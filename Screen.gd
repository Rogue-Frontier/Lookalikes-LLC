extends Control


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var iemm := event as InputEventMouseMotion
		print(iemm.screen_velocity)


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	pass # Replace with function body.
