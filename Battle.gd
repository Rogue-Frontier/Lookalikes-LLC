extends Node3D
const SkillDesc := preload("res://SkillDesc.gd")
const SkillSlot := preload("res://SkillSlot.gd")
const Unit := preload("res://unit.gd")
const Die := SkillDesc.Die
class ClashView:
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
func underpainting(): return SkillDesc.mk("Underpainting", [
	Die.mk(1, 16, func(user, skill, roll):
		if true:
			await zoomInWait(2, 0.2, 0.1)
			cam_tween = false
			approach(user, skill.target, 7)
			user.add_child(preload("res://Underpainting1.tscn").instantiate())
			await get_tree().create_timer(0.1).timeout
			await zoomOutWait(18.0, 0.3)
		cam_tween = true
		),
	Die.mk(1, 16, func(user, skill, roll):
		if true:
			await zoomInWait(2, 0.2, 0.1)
			cam_tween = false
			approach(user, skill.target, 7)
			user.add_child(preload("res://Underpainting2.tscn").instantiate())
			await get_tree().create_timer(0.1).timeout
			await zoomOutWait(18.0, 0.3)
		cam_tween = true
		),
	Die.mk(1, 16, func(user, skill, roll):
		if true:
			await zoomInWait(2, 0.2, 0.1)
			cam_tween = false
			approach(user, skill.target, 7)
			user.add_child(preload("res://Underpainting3.tscn").instantiate())
			await get_tree().create_timer(0.1).timeout
			await zoomOutWait(18.0, 0.3)
			await get_tree().create_timer(0.2).timeout
		cam_tween = true
		),
	])
func makeClash(l, r):
	l.target = r
	r.target = l
	l.clash = true
	r.clash = true
func _ready() -> void:
	get_tree().create_timer(0.1).timeout.connect(func():
		for u:Unit in get_tree().get_nodes_in_group("Unit"):
			u.make_slots()
		start_turn()
		makeClash($LeftUnit/Slots/Slot0, $RightUnit/Slots/Slot0)
		
		$LeftUnit/Slots/Slot0.skillDesc = underpainting()
		$RightUnit/Slots/Slot0.skillDesc = underpainting()
		
		makeClash($LeftUnit2/Slots/Slot0, $RightUnit2/Slots/Slot0)
		
		$LeftUnit2/Slots/Slot0.skillDesc = underpainting()
		$RightUnit2/Slots/Slot0.skillDesc = underpainting()
		
		
		start_combat()
			
		)
var combat_autocam := false
var combat_pov := Vector3(0, 0, 0)
var combat_dist := 18
var cam_tween := true
var fov_tween := false

static func calc_center(arr:Array[Vector3]):
	var r := Vector3(0,0,0)
	for v in arr:
		r += v / arr.size()
	return r
func _process(delta: float) -> void:
	if combat_autocam:
		var uu := get_tree().get_nodes_in_group("Unit").filter(func(u:Unit): return u.visible)
		var center := SkillDesc.SkillCam.calc_center(uu)
		var dist := SkillDesc.SkillCam.calc_dist(center, uu)
		combat_pov = SkillDesc.SkillCam.auto_pov(center)
		var sz := combat_dist + 8 + dist * 1.5
		if fov_tween:
			#get_tree().create_tween().tween_property($Camera, "size", sz, 0.3)
			$Camera.size += (sz - $Camera.size) * delta
		else:
			$Camera.size = sz
		var t := create_tween()
		#t.set_trans(Tween.TRANS_QUAD)
		#t.set_ease(Tween.EASE_IN)
		if cam_tween:
			$Camera.global_position += (combat_pov - $Camera.global_position) * delta * 5
			$Camera.global_rotation_degrees += (Vector3(-15,0,0) - $Camera.global_rotation_degrees) * delta * 5
		else:
			$Camera.global_position = combat_pov
func start_turn():
	for u:Unit in get_tree().get_nodes_in_group("Unit"):
		u.start_turn()
func start_combat():
	combat_autocam = true
	var slots := get_tree().get_nodes_in_group("SkillSlot")
	slots.sort_custom(func(a:SkillSlot, b:SkillSlot):
		return a.speed > b.speed
		)
	for s in slots:
		s.hide()
	var c := $Camera3D
	var csep := Vector3(0, 6, 16)
	for u:Unit in get_tree().get_nodes_in_group("Unit"):
		u.visible = false
	while not slots.is_empty():
		var s :SkillSlot= slots[0]
		slots.pop_front()
		fov_tween = true
		if not s.pending:
			continue
		var tt = s.target
		var lU := s.user
		lU.visible = true
		if s.target and s.target.pending and (s.clash or s.target.clash):
			var rU := s.target.user
			rU.visible = true
			s.pending = false
			s.target.pending = false
			if true:
				var _t = create_tween()
				_t.tween_property($Dark, "modulate", Color(0,0,0,0.8), 0.5)
			if true:
				# First Approach
				var ce := (lU.global_position + rU.global_position) / 2
				var sep := 8
				var ti := (lU.global_position - rU.global_position).length() / 48.0
				var _tl := create_tween()
				_tl.tween_property(lU, "global_position", ce - Vector3(sep / 2, 0, 0), ti)
				var _tr := create_tween()
				_tr.tween_property(rU, "global_position", ce + Vector3(sep / 2, 0, 0), ti)
				var _tc = create_tween()
				_tc.tween_property(c, "global_position", ce + csep, ti)
				await _tr.finished
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
					_tw = get_tree().create_tween()
					_tw.set_ease(Tween.EASE_OUT)
					_tw.set_trans(Tween.TRANS_QUAD)
					_tw.tween_property(lU, "global_position", ce - Vector3(sep / 2, 0, 0), ti)
					
					_tw = get_tree().create_tween()
					_tw.set_ease(Tween.EASE_OUT)
					_tw.set_trans(Tween.TRANS_QUAD)
					_tw.tween_property(rU, "global_position", ce + Vector3(sep / 2, 0, 0), ti)
					
					var _tc = get_tree().create_tween()
					_tc.tween_property(c, "global_position", ce + csep, ti)
					await _tw.finished
				if true:
					var flash = preload("res://ClashFlash.tscn").instantiate()
					add_child(flash)
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
						rLa.loseClash()
						pass
					elif rRoll > lRoll:
						lLa.loseClash()
						pass
					_tw = get_tree().create_tween()
					_tw.set_ease(Tween.EASE_OUT)
					_tw.set_trans(Tween.TRANS_QUAD)
					_tw.tween_property(lU, "global_position", lU.global_position + kbL * lPush, 0.1)
					_tw = get_tree().create_tween()
					_tw.set_ease(Tween.EASE_OUT)
					_tw.set_trans(Tween.TRANS_QUAD)
					_tw.tween_property(rU, "global_position", rU.global_position - kbL * rPush, 0.1)
					await _tw.finished
					await get_tree().create_timer(0.25).timeout
					
					
					fov_tween = false
					
					if lRoll > rRoll:
						rSk.loseClash()
						await lSk.useCurrent(lU, 0.5)
					elif rRoll > lRoll:
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
			var rU := s.target.user
			rU.visible = true
			var sep := 6
			var _tl := create_tween()
			_tl.tween_property(lU, "global_position", rU.global_position - Vector3(sep / 2, 0, 0), 0.5)
			#Unopposed
			rU.visible = false
		lU.visible = false
		fov_tween = true
		pass
	combat_autocam = false
