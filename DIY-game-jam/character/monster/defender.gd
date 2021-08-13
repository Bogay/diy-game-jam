class_name Defender
extends Node2D

export(Resource) var defender_data = null
var type = DefenderData.DefenderType.REMOTE
var max_hp: Buffable
var hp: int
var attack: Buffable
var defense: Buffable
var magic_attack: Buffable
var magic_defense: Buffable
var attack_distance: Buffable
# Attack speed
var speed: Buffable
onready var attack_area: Area2D = $AttackArea
onready var attack_shape: CollisionShape2D = $AttackArea/CollisionShape2D

func _ready():
	assert(defender_data is DefenderData)
	type = defender_data.type
	max_hp = Buffable.new(defender_data.max_hp)
	hp = max_hp.value()
	attack = Buffable.new(defender_data.attack)
	defense = Buffable.new(defender_data.defense)
	magic_attack = Buffable.new(defender_data.magic_attack)
	magic_defense = Buffable.new(defender_data.magic_defense)
	speed = Buffable.new(defender_data.speed)
	attack_distance = Buffable.new(defender_data.attack_distance)
	(attack_shape.shape as CircleShape2D).radius = attack_distance.value()
	attack_distance.connect("value_changed", self, "_on_attack_distance_changed")

func _on_attack_distance_changed(dis):
	(attack_shape.shape as CircleShape2D).radius = dis

#func _process(delta):
#	pass
