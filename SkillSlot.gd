extends Node3D
const Unit = preload("res://unit.gd")
const SkillSlot = preload("res://SkillSlot.gd")
const SkillPage = preload("res://SkillPage.gd")
const SkillDesc = preload("res://SkillDesc.gd")
var pending:bool = true
var speed:int
var user:Unit
var target:SkillSlot
var skill:SkillPage
var skillDesc:SkillDesc
var clash:bool
func _ready():
	pass
