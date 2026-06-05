extends Node
const Unit = preload("res://unit.gd")
class InflictPaint:
	func onHit(attacker:Unit):
		pass
func inflictPaint():
	return InflictPaint.new()
const Die := SkillDesc.Die
static func Underpainting(): return \
	SkillDesc.mk("Underpainting", 5, [
		Die.mk(1, 8, func(user:Unit, skill:SkillDesc, roll:int):
			var c := skill.cam
			c.fovIn(9, 0.15)
			c.pos_tween = false
			c.posOut(c.auto_pov(user.global_position), 0.15)
			await c.wait(0.1)
			c.pos = user.global_position
			user.approach(skill.target, 7)
			user.add_child(preload("res://Underpainting1.tscn").instantiate())
			await c.wait(0.1)
			
			skill.target.knockback((skill.target.global_position - user.global_position).normalized() * roll)
			
			c.posOut(c.auto_pov(skill.target.global_position), 0.2)
			await c.fovOut(18.0, 0.2)
			),
		Die.mk(1, 8, func(user:Unit, skill:SkillDesc, roll:int):
			var c := skill.cam
			c.fovIn(9, 0.15)
			c.pos_tween = false
			c.posOut(c.auto_pov(user.global_position), 0.15)
			await c.wait(0.05)
			c.pos = user.global_position
			user.approach(skill.target, 7)
			user.add_child(preload("res://Underpainting2.tscn").instantiate())
			await c.wait(0.1)
			skill.target.knockback((skill.target.global_position - user.global_position).normalized() * roll)
			c.posOut(c.auto_pov(skill.target.global_position), 0.2)
			await c.fovOut(18.0, 0.2)
			),
		Die.mk(1, 8, func(user:Unit, skill:SkillDesc, roll:int):
			var c := skill.cam
			c.fovIn(9, 0.2)
			c.pos_tween = false
			c.posOut(c.auto_pov(user.global_position), 0.2)
			await c.wait(0.1)
			c.pos = user.global_position
			user.approach(skill.target, 7)
			user.add_child(preload("res://Underpainting3.tscn").instantiate())
			await c.wait(0.1)
			skill.target.knockback((skill.target.global_position - user.global_position).normalized() * roll)
			c.posOut(c.auto_pov(skill.target.global_position), 0.2)
			await c.fovOut(18.0, 0.3)
			await c.wait(0.2)
			),
	])
static func ActionPainting():
	var counters := {
		times = 0
	}
	return SkillDesc.mk("Action Painting",10, [
		Die.mk(1, 8, func(user, skill:SkillDesc, roll):
			var c := skill.cam
			if not skill.currentDie.reuse:
				counters.times = 0
			c.fovIn(2, 0.2)
			c.posOut(c.auto_pov(user.global_position), 0.2)
			await c.wait(0.2)
			c.pos_tween = false
			user.add_child(preload("res://Underpainting1.tscn").instantiate())
			skill.target.add_child(preload("res://PaintSplatter.tscn").instantiate())	
			
			skill.target.knockback((skill.target.global_position - user.global_position).normalized() * roll)
			
			c.posOut(c.auto_pov(skill.target.global_position), 0.3)
			await c.fovOut(18.0, 0.3)
			await c.wait(0.1)
			skill.currentDie.reuse = counters.times < 4
			counters.times += 1
			, "Reuse 3 times")
	])
func onRoll():
	pass
func onHit():
	pass
	
