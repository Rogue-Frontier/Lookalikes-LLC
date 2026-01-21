extends Node3D
var skillName:String:
	get:
		return $Name.text
	set(n):
		$Name.text = n
var skillRoll:int:
	get:
		return skillRoll
	set(n):
		skillRoll = n
		$CurrentDie/Roll.text = str(n)
var skillRange:String:
	set(t):
		$CurrentDie/Range.text = t
@onready var facing := Vector3(global_basis.x.x, 1, 1)
@onready var flip := (global_basis.x.x == -1)
func _ready() -> void:
	$Name.scale = facing
	$CurrentDie.scale = facing
func flash():
	$AP.play("Flash")
func flashRoll(r:int):
	skillRoll = r
	flash()
func showDie(die):
	skillRange = str(die.base) + "~" + str(die.rng)
	var mul := 1
	if mul > 1:
		skillRange = str(mul) + "(" + skillRange + ")"
func loseClash():
	$CurrentDie.visible = false
func showDice(dice:Array):
	for c in $NextDice.get_children():
		$NextDice.remove_child(c)
	visible = false
	if dice.is_empty():
		return
	visible = true
	$CurrentDie.visible = true
	showDie(dice[0])
	var x := 0
	for d in dice.slice(1):
		var dd :Node3D= preload("res://DieLabel.tscn").instantiate()
		$NextDice.add_child(dd)
		dd.position += Vector3(-x, 0, 0)
		
		dd.scale = facing
		x += 2
func clearMods():
	for c in $Mods.get_children():
		$Mods.remove_child(c)
func addMod(s:String):
	var l := preload("res://ModLabel.tscn").instantiate()
	$Mods.add_child(l)
	l.position.y = $Mods.get_child_count() * -1
	
	l.position.x = -8
	get_tree().create_tween().tween_property(l, "position:x", 0, 0.2)
