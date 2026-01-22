extends Node
const Unit = preload("res://unit.gd")
class InflictPaint:
	func onHit(attacker:Unit):
		pass
func inflictPaint():
	return InflictPaint.new()
const Die := SkillDesc.Die
static func Underpainting(): return \
	SkillDesc.mk("Underpainting", [
		Die.mk(1, 8, func(user:Unit, skill:SkillDesc, roll:int):
			var c := skill.cam
			c.tree = user.get_tree()
			
			c.fovIn(2, 0.2)
			await skill.cam.wait(0.1)
			c.cam_tween = false
			user.approach(skill.target, 7)
			user.add_child(preload("res://Underpainting1.tscn").instantiate())
			await c.wait(0.1)
			await c.fovOut(18.0, 0.3)
			),
		Die.mk(1, 8, func(user:Unit, skill:SkillDesc, roll:int):
			var c := skill.cam
			c.tree = user.get_tree()
			
			c.fovIn(2, 0.2)
			await c.wait(0.1)
			user.approach(skill.target, 7)
			user.add_child(preload("res://Underpainting2.tscn").instantiate())
			await c.wait(0.1)
			await c.fovOut(18.0, 0.3)
			),
		Die.mk(1, 8, func(user:Unit, skill:SkillDesc, roll:int):
			var c := skill.cam
			c.tree = user.get_tree()
			
			c.fovIn(2, 0.2)
			await c.wait(0.1)
			user.approach(skill.target, 7)
			user.add_child(preload("res://Underpainting3.tscn").instantiate())
			await c.wait(0.1)
			await c.fovOut(18.0, 0.3)
			await c.wait(0.2)
			),
	])
var ActionPainting :=	SkillDesc.mk("Action Painting", [
		Die.mk(1, 8, func(unit, skill, roll):
			pass
			)
	])
func onRoll():
	pass
func onHit():
	pass
	
