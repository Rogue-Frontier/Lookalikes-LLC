extends Node3D
const Unit = preload("res://unit.gd")
func _ready() -> void:
	add_child(preload("res://health_ring.tscn").instantiate())
	make_slots()
func _process(delta: float) -> void:
	global_rotation.x = get_tree().get_first_node_in_group("Camera").global_rotation.x
	if(scale.x == -1):
		global_rotation.x += PI

func start_battle():
	pass
func start_turn():
	pass

func make_slots():
	var count := 1
	var w := 2.0
	var offset = (count - 1) * w / 2
	for i in range(count):
		var slot := preload("res://SkillSlot.tscn").instantiate()
		slot.position.x = -offset + i * w
		slot.name = "Slot" + str(i)
		slot.user = self
		$Slots.add_child(slot)	
func move_to_target_side():
	pass
func approach(target:Unit, dist:int):
	var t := get_tree().create_tween()
	t.tween_property(self, "global_position", target.global_position + (self.global_position - target.global_position).normalized() * Vector3(dist, 0, 0), 0.1)
	await t.finished
