extends Node3D
func showBar(arr:Array[bool], sz:int):
	for c in $Bar.get_children():
		$Bar.remove_child(c)
	for i in range(sz):
		var x := -0.25 * (sz - 1) + 0.5 * i
		var s := preload("res://EmotionCoin.tscn").instantiate()
		$Bar.add_child(s)
		s.position.x = x
		if i < arr.size():
			if arr[i]:
				s.modulate = Color.CYAN
			else:
				s.modulate = Color.RED
		else:
			s.modulate = Color.DIM_GRAY
