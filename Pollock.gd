extends Node
const Unit = preload("res://unit.gd")
class InflictPaint:
	func onHit(attacker:Unit):
		pass
func inflictPaint():
	return InflictPaint.new()
var Die := SkillDesc.Die
var Skills := [
	SkillDesc.mk("Underpainting", [
		Die.mk(1, 16, func(user:Unit, skill:SkillDesc, roll:int):
			if true:
				skill.cam.fovIn(2, 0.2)
				await skill.cam.wait(0.1)
				skill.cam.cam_tween = false
				user.approach(skill.target, 7)
				user.add_child(preload("res://Underpainting1.tscn").instantiate())
				await skill.cam.wait(0.1)
				await skill.cam.fovOut(18.0, 0.3)
			),
		Die.mk(1, 16, func(user:Unit, skill:SkillDesc, roll:int):
			skill.cam.fovIn(2, 0.2)
			await skill.cam.wait(0.1)
			user.approach(skill.target, 7)
			user.add_child(preload("res://Underpainting2.tscn").instantiate())
			await skill.cam.wait(0.1)
			await skill.cam.fovOut(18.0, 0.3)
			),
		Die.mk(1, 16, func(user:Unit, skill:SkillDesc, roll:int):
			skill.cam.fovIn(2, 0.2)
			await skill.cam.wait(0.1)
			user.approach(skill.target, 7)
			user.add_child(preload("res://Underpainting3.tscn").instantiate())
			await skill.cam.wait(0.1)
			await skill.cam.fovOut(18.0, 0.3)
			await skill.cam.wait(0.2)
			),
	]),
	SkillDesc.mk("Action Painting", [
		Die.mk(1, 8, func(unit, skill, roll):
			pass
			)
	])
]
func onHit():
	pass
