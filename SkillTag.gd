extends Node3D
var cost:int:
	set(c):
		$Cost.text = str(c)
var skillName:String:
	set(n):
		$Name.text = n
var skillDesc:String:
	set(d):
		$SkillPanel/Text.text = d
func _ready() -> void:
	var tw := get_tree().create_tween()
	#var pos := position
	#position = Vector3(0,0,0)
	tw.set_trans(Tween.TRANS_QUAD)
	tw.set_ease(Tween.EASE_OUT)
	#tw.tween_property(self, "position", pos, 0.2)
func _on_area_3d_mouse_entered() -> void:
	$Back.modulate = Color(Color.GRAY, 1)
	$SkillPanel.visible = true
func _on_area_3d_mouse_exited() -> void:
	$Back.modulate = Color.WHITE
	$SkillPanel.visible = false
signal mouseDown
signal leftDown
signal rightDown
var prev := false
var leftPrev := false
var rightPrev := false
func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	var iemb := event as InputEventMouseButton
	if iemb:
		if iemb.is_pressed():
			if not prev:
				mouseDown.emit()
			if iemb.button_index == MOUSE_BUTTON_LEFT and not leftPrev:
				leftDown.emit()
			if iemb.button_index == MOUSE_BUTTON_RIGHT and not rightPrev:
				rightDown.emit()
		prev = iemb.is_pressed()
		if iemb.button_index == MOUSE_BUTTON_LEFT:
			leftPrev = prev
		if iemb.button_index == MOUSE_BUTTON_RIGHT:
			rightPrev = prev
