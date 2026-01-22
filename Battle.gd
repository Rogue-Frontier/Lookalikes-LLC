extends Node3D
const SkillDesc := preload("res://SkillDesc.gd")
const SkillSlot := preload("res://SkillSlot.gd")
const Unit := preload("res://unit.gd")
const Die := SkillDesc.Die
class ClashHandle:
	func pause_anim():
		pass
	func continue_anim():
		pass
	var participants:Array[Unit]
	var camera:Node3D
	var fov:int
func zoomInWait(dist:float, dur:float, wait:float):
	var t:Tween
	t = get_tree().create_tween()
	t.set_trans(Tween.TRANS_QUAD)
	t.set_ease(Tween.EASE_IN)
	t.tween_property(self, "combat_dist", dist, dur)
	await get_tree().create_timer(wait).timeout
func zoomOutWait(dist:float, dur:float):
	var t:Tween
	t = get_tree().create_tween()
	t.set_trans(Tween.TRANS_QUAD)
	t.set_ease(Tween.EASE_OUT)
	t.tween_property(self, "combat_dist", dist, dur)
	await t.finished
func wait(w:float):
	await get_tree().create_timer(w).timeout
func approach(attacker, target, dist):
	var t := get_tree().create_tween()
	t.tween_property(attacker, "global_position", target.global_position + (attacker.global_position - target.global_position).normalized() * Vector3(dist, 0, 0), 0.1)
	await t.finished
func makeClash(l, r):
	l.target = r
	r.target = l
	l.clash = true
	r.clash = true
const Pollock = preload("res://Pollock.gd")
func _ready() -> void:
	get_tree().create_timer(0.1).timeout.connect(func():
		for u:Unit in get_tree().get_nodes_in_group("Unit"):
			u.make_slots()
		start_turn()
		makeClash($LeftUnit/Slots/Slot0, $RightUnit/Slots/Slot0)
		$LeftUnit/Slots/Slot0.skillDesc = Pollock.Underpainting()
		$RightUnit/Slots/Slot0.skillDesc = Pollock.Underpainting()
		if false:
			makeClash($LeftUnit2/Slots/Slot0, $RightUnit2/Slots/Slot0)
			$LeftUnit2/Slots/Slot0.skillDesc = Pollock.ActionPainting()
			$RightUnit2/Slots/Slot0.skillDesc = Pollock.ActionPainting()
		start_combat()
		)
var combat_autocam := false
var combat_pov := Vector3(0, 0, 0)
var combat_dist := 18
var cam_tween := true
var fov_tween := false
var clashing := []
func _process(delta: float) -> void:
	if clashing.size() > 1:
		var uu := get_tree().get_nodes_in_group("Unit").filter(func(u:Unit): return u.visible)
		var center := SkillDesc.SkillCam.calc_center(uu)
		var dist := SkillDesc.SkillCam.calc_dist(center, uu)
		combat_pov = SkillDesc.SkillCam.auto_pov(center)
		var sz := combat_dist + 8 + dist * 1.5
		$Camera.size += (sz - $Camera.size) * delta
		var t := create_tween()
		#t.set_trans(Tween.TRANS_QUAD)
		#t.set_ease(Tween.EASE_IN)
		$Camera.global_position = combat_pov
		
		$Camera.global_position += (combat_pov - $Camera.global_position) * delta * 5
		$Camera.global_rotation_degrees += (Vector3(-15,0,0) - $Camera.global_rotation_degrees) * delta * 5
	elif clashing.size() == 1:
		var c :Clash= clashing.front()
		var uu := get_tree().get_nodes_in_group("Unit").filter(func(u:Unit): return u.visible)
		var center := SkillDesc.SkillCam.calc_center(uu)
		var dist := SkillDesc.SkillCam.calc_dist(center, uu)
		combat_pov = SkillDesc.SkillCam.auto_pov(center)
		var sz :int= SkillDesc.SkillCam.auto_fov(combat_dist, dist)
		if c.cam:
			sz = SkillDesc.SkillCam.auto_fov(c.cam.fov, dist)
		if not c.cam or c.cam.pos_tween:
			#get_tree().create_tween().tween_property($Camera, "size", sz, 0.3)
			$Camera.size += (sz - $Camera.size) * delta
		else:
			$Camera.size = sz
		if not c.cam or c.cam.pos_tween:
			$Camera.global_position += (combat_pov - $Camera.global_position) * delta * 2.5
			$Camera.global_rotation_degrees += (Vector3(-15,0,0) - $Camera.global_rotation_degrees) * delta * 2.5
		else:
			$Camera.global_position = combat_pov
func start_turn():
	for u:Unit in get_tree().get_nodes_in_group("Unit"):
		u.start_turn()
func start_combat():
	var slots := get_tree().get_nodes_in_group("SkillSlot")
	slots.sort_custom(func(a:SkillSlot, b:SkillSlot):
		return a.speed > b.speed
		)
	for s in slots:
		s.hide()
	for u:Unit in get_tree().get_nodes_in_group("Unit"):
		u.start_combat()
		u.visible = false
	var clashes := []
	while not slots.is_empty():
		var s:SkillSlot=slots[0]
		slots.pop_front()
		if not s.pending:
			continue
		if not s.skillDesc:
			continue
		var c := Clash.new()
		clashes.push_back(c)
		c.done.connect(func():
			clashes.erase(c)
			return
			)
		clash(c, s)
	clashing = clashes
	for c in clashes:
		await c.done
class Clash:
	var cam:SkillDesc.SkillCam
	signal done
func clash(cl:Clash, s:SkillSlot):
	var tt = s.target
	var lU := s.user
	var tree := lU.get_tree()
	lU.visible = true
	if s.target and s.target.pending and (s.clash or s.target.clash):
		var rU := s.target.user
		rU.visible = true
		s.pending = false
		s.target.pending = false
		if true:
			# First Approach
			var ce := (lU.global_position + rU.global_position) / 2
			var sep := 8
			var ti := (lU.global_position - rU.global_position).length() / 48.0
			var _tl := tree.create_tween()
			_tl.tween_property(lU, "global_position", ce - Vector3(sep / 2, 0, 0), ti)
			var _tr := tree.create_tween()
			_tr.tween_property(rU, "global_position", ce + Vector3(sep / 2, 0, 0), ti)
			await tree.create_timer(ti).timeout
		var la := preload("res://SkillLabel.tscn")
		var lLa := la.instantiate()
		var rLa := la.instantiate()
		lU.get_node("Slots").add_child(lLa)
		rU.get_node("Slots").add_child(rLa)
		var clashing := true
		var lSk := s.skillDesc
		var rSk := s.target.skillDesc
		lSk.onRoll.connect(func(r:int):
			lLa.showDice(lSk.diceLeft)
			lLa.flashRoll(r)
			lLa.clearMods()
			)
		lSk.onClashLose.connect(func():
			lLa.showDice(lSk.diceLeft)
			lLa.clearMods()
			)
		rSk.onRoll.connect(func(r:int):
			rLa.showDice(rSk.diceLeft)
			rLa.flashRoll(r)
			rLa.clearMods()
			)
		rSk.onClashLose.connect(func():
			rLa.showDice(rSk.diceLeft)
			rLa.clearMods()
			)
		lSk.target = rU
		rSk.target = lU
		while clashing:
			var ce := (lU.global_position + rU.global_position) / 2
			var _tw:Tween
			lLa.skillName = lSk.skillName
			rLa.skillName = rSk.skillName
			var lRoll = lSk.rollCurrent(0.5)
			var rRoll = rSk.rollCurrent(0.5)
			if true:
				#Clash approach
				var sep := 6
				var ti := 0.5
				_tw = tree.create_tween()
				_tw.set_ease(Tween.EASE_OUT)
				_tw.set_trans(Tween.TRANS_QUAD)
				_tw.tween_property(lU, "global_position", ce - Vector3(sep / 2, 0, 0), ti)
				_tw = tree.create_tween()
				_tw.set_ease(Tween.EASE_OUT)
				_tw.set_trans(Tween.TRANS_QUAD)
				_tw.tween_property(rU, "global_position", ce + Vector3(sep / 2, 0, 0), ti)
				await tree.create_timer(ti).timeout
			if true:
				var flash = preload("res://ClashFlash.tscn").instantiate()
				tree.root.add_child(flash)
				flash.global_position = (lU.global_position + rU.global_position)/2 + Vector3(0, 5, 0)
				#Knockbacks
				var kbL := (lU.global_position - rU.global_position).normalized()
				var lPush := 5.0
				var rPush := 5.0
				if lRoll < rRoll:
					rPush = 0.5
				if rRoll < lRoll:
					lPush = 0.5
				if lRoll > rRoll:
					lLa.winClash()
					rLa.loseClash()
				elif rRoll > lRoll:
					rLa.winClash()
					lLa.loseClash()
				_tw = tree.create_tween()
				_tw.set_ease(Tween.EASE_OUT)
				_tw.set_trans(Tween.TRANS_QUAD)
				_tw.tween_property(lU, "global_position", lU.global_position + kbL * lPush, 0.1)
				_tw = tree.create_tween()
				_tw.set_ease(Tween.EASE_OUT)
				_tw.set_trans(Tween.TRANS_QUAD)
				_tw.tween_property(rU, "global_position", rU.global_position - kbL * rPush, 0.1)
				await _tw.finished
				await tree.create_timer(0.25).timeout
				
				if lRoll > rRoll:
					lSk.cam.tree = get_tree()
					cl.cam = lSk.cam
					cl.cam.fov_tween = false
					lSk.winClash()
					rSk.loseClash()
					await lSk.useCurrent(lU, 0.5)
				elif rRoll > lRoll:
					rSk.cam.tree = get_tree()
					cl.cam = rSk.cam
					cl.cam.fov_tween = false
					rSk.winClash()
					lSk.loseClash()
					await rSk.useCurrent(rU, 0.5)
			clashing = lSk.hasDice and rSk.hasDice
		while lSk.hasDice:
			await lSk.useCurrent(lU, 0.5)
		while rSk.hasDice:
			await rSk.useCurrent(rU, 0.5)
		#Clash
		rU.visible = false
	elif s.target:
		s.pending = false
		var rU := s.target.user
		rU.visible = true
		var sep := 6
		var _tl := tree.create_tween()
		_tl.tween_property(lU, "global_position", rU.global_position - Vector3(sep / 2, 0, 0), 0.5)
		#Unopposed
		rU.visible = false
	lU.visible = false
	cl.done.emit()
