class_name Attacker
extends Node2D

export(Resource) var attacker_data = null
var max_hp: Buffable
var hp: int
var attack: Buffable
var defense: Buffable
var magic_attack: Buffable
var magic_defense: Buffable
var speed: Buffable
var offset = 0
var path: PathFollow2D = null

func _ready():
	assert(attacker_data is AttackerData)
	max_hp = Buffable.new(attacker_data.max_hp)
	hp = max_hp.value()
	attack = Buffable.new(attacker_data.attack)
	defense = Buffable.new(attacker_data.defense)
	magic_attack = Buffable.new(attacker_data.magic_attack)
	magic_defense = Buffable.new(attacker_data.magic_defense)
	speed = Buffable.new(attacker_data.speed)
	
func _physics_process(delta):
	if path == null:
		return
	offset += speed.value() * delta
	path.offset = offset
	global_position = path.global_position
	print(offset)
