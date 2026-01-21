@tool
extends Sprite3D

func _ready() -> void:
	texture = $SubViewport.get_texture()

@export var hp: float:
	get:
		return hp
	set(amt):
		hp = amt
		set_hp(amt)
func tween_hp(amt:float):
	var t = get_tree().create_tween()
	t.tween_property(self, "hp", amt, 0.5)
	t.play()
func set_hp(amt:float):
	if not is_node_ready():
		return
	($SubViewport/HealthRingFill.material_override as ShaderMaterial).set_shader_parameter("hp", amt * 100)
