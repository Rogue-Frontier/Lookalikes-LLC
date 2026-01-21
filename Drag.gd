extends Area3D

var b := false
func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var iemb := event as InputEventMouseButton
		if iemb.is_pressed():
			b = true
		if iemb.is_released():
			b = false
			
		if iemb.button_index == MOUSE_BUTTON_WHEEL_UP:
			var n3 := get_parent_node_3d() as Camera3D
			var t = get_tree().create_tween()
			t.tween_property(n3, "fov", n3.fov - 5, 0.4)
		# zoom out
		if iemb.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var n3 := get_parent_node_3d() as Camera3D
			var t = get_tree().create_tween()
			t.tween_property(n3, "fov", n3.fov + 5, 0.4)
	if event is InputEventMouseMotion:
		if b:
			var iemm := event as InputEventMouseMotion
			#get_parent_node_3d().translate(dv)
			
			var dv := Vector3(-iemm.screen_relative.x / 2, 0, 0)
			
			var n3 := get_parent_node_3d()
			var t = get_tree().create_tween()
			t.tween_property(n3, "global_position", n3.global_position + dv, 0.4)
			
			var dr := n3.global_rotation_degrees + Vector3(iemm.screen_relative.y / 5, 0, 0)
			dr.x = clamp(dr.x, -45, 0)
			n3.global_rotation_degrees = dr
			
			
