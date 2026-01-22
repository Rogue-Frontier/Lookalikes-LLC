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
			c.fovIn(2, 0.2)
			
			c.posTo(user.global_position, 0.05)
			await c.wait(0.1)
			
			c.pos = user.global_position
			c.pos_tween = false
			user.approach(skill.target, 7)
			user.add_child(preload("res://Underpainting1.tscn").instantiate())
			
			#c.posTo(c.calc_center([user, skill.target]), 0.3)
			await c.wait(0.1)
			await c.fovOut(18.0, 0.3)
			),
		Die.mk(1, 8, func(user:Unit, skill:SkillDesc, roll:int):
			var c := skill.cam
			c.fovIn(2, 0.2)
			await c.wait(0.1)
			
			c.pos = user.global_position
			c.pos_tween = false
			user.approach(skill.target, 7)
			user.add_child(preload("res://Underpainting2.tscn").instantiate())
			
			c.posTo(c.calc_center([user, skill.target]), 0.3)
			await c.wait(0.1)
			await c.fovOut(18.0, 0.3)
			),
		Die.mk(1, 8, func(user:Unit, skill:SkillDesc, roll:int):
			var c := skill.cam
			c.fovIn(2, 0.2)
			await c.wait(0.1)
			c.pos_tween = false
			user.approach(skill.target, 7)
			user.add_child(preload("res://Underpainting3.tscn").instantiate())
			await c.wait(0.1)
			await c.fovOut(18.0, 0.3)
			await c.wait(0.2)
			),
	])
static func ActionPainting():	return SkillDesc.mk("Action Painting", [
		Die.mk(1, 8, func(user, skill:SkillDesc, roll):
			var c := skill.cam
			if not skill.currentDie.reuse:
				c.fovIn(2, 0.2)
				await c.wait(0.1)
			c.pos_tween = false
			
			user.add_child(preload("res://Underpainting1.tscn").instantiate())
			skill.target.add_child(preload("res://PaintSplatter.tscn").instantiate())
			
			await c.fovOut(18.0, 0.3)
			await c.wait(0.2)
			skill.currentDie.reuse = true
			)
	])
func onRoll():
	pass
func onHit():
	pass
	
