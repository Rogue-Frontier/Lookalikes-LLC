class_name SkillDesc
class Die:
	var base:int
	var rng:int
	
	var top:int:
		get:
			return base + rng
	var reuse:bool
	var disableReuse:bool
	var atk:Callable
	var loseClash:Callable
	var winClash:Callable
	func roll(chance:float) -> int:
		var r := base
		var unit := int(sign(rng))
		for i in range(abs(rng)):
			if randf() < chance:
				r += unit
		return r
	func attack(user, skill, roll):
		if atk:
			await atk.call(user, skill, roll)
	static func mk(base:int, rng:int, atk) -> Die:
		var d := Die.new()
		d.base = base
		d.rng = rng
		d.atk = atk
		return d
class SkillCam:
	var pos := Vector3(0, 0, 0)
	var fov := 18
	var cam_tween := false
	var tree:SceneTree
	func fovIn(dist:float, dur:float):
		var t:Tween
		
		t = tree.create_tween()
		t.set_trans(Tween.TRANS_QUAD)
		t.set_ease(Tween.EASE_IN)
		t.tween_property(self, "fov", dist, dur)
		t.play()
		await t.finished
	func fovOut(dist:float, dur:float):
		var t:Tween= tree.create_tween()
		t.set_trans(Tween.TRANS_QUAD)
		t.set_ease(Tween.EASE_OUT)
		t.tween_property(self, "fov", dist, dur)
		t.play()
		await t.finished
		await check_pause()
	func wait(t:float):
		await tree.create_timer(t).timeout
		await check_pause()
	var paused:bool
	signal unpaused
	func check_pause():
		if paused:
			await unpaused
	func pause():
		paused = true
	func unpause():
		paused = false
		unpaused.emit()
		pass
	static func calc_center(uu) -> Vector3:
		var center := Vector3(0,0,0)
		for u in uu:
			center += u.global_position / uu.size()
		return center
	static func calc_dist(center, uu) -> int:
		var dist := 0.0
		for u in uu:
			dist += (u.global_position - center).length() / uu.size()
		return dist
	static func auto_pov(center:Vector3):
		var y := 10 + center.z * sin(deg_to_rad(-15))
		return Vector3(center.x, y, 15)
	static func auto_fov(fov:int, dist:int):
		return fov + 8 + dist * 1.5
static func mk(skillName:String, diceLeft:Array[Die]) -> SkillDesc:
	var sd = SkillDesc.new()
	sd.skillName = skillName
	sd.diceLeft = diceLeft
	return sd
var cam:= SkillCam.new()
var skillName:String
var diceLeft : Array[Die]
var hasDice:bool:
	get:
		return not diceLeft.is_empty()
var currentDie : Die:
	get:
		return diceLeft[0]
var target:Unit
const Unit = preload("res://unit.gd")
signal onRoll(r:int)
signal onClashLose
signal onClashWin
func winClash():
	onClashWin.emit()
	var d := currentDie
	if d.winClash:
		d.winClash.call()
func loseClash():
	var d := currentDie
	diceLeft.remove_at(0)
	onClashLose.emit()
	if d.loseClash:
		d.loseClash.call()
func useCurrent(user:Unit, chance:float):
	var d := currentDie
	var r:= d.roll(chance)
	onRoll.emit(r)
	await d.attack(user, self, r)
	var re := d.reuse
	if d.reuse and not d.disableReuse:
		return
	diceLeft.remove_at(0)

func rollCurrent(chance:float) -> int:
	var r:= currentDie.roll(chance)
	onRoll.emit(r)
	return r
func attack(user:Unit, chance:float):
	var r = rollCurrent(chance)
	await currentDie.attack(user, self, r)
func start_battle():
	pass	
func start_turn():
	pass
