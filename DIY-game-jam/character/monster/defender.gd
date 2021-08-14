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
var detected_attackers = {}
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
	attack_area.connect("body_entered", self, "_on_body_entered")
	add_to_group("defender")


func _on_attack_distance_changed(dis):
	(attack_shape.shape as CircleShape2D).radius = dis


func _on_body_entered(a: Node):
	var attacker = a.get_parent()
	if not attacker is Attacker:
		return
	enqueue_attacker(attacker)


func enqueue_attacker(attacker: Attacker):
	var attacker_id = attack.get_instance_id()
	assert(not attacker_id in detected_attackers)
	detected_attackers[attacker_id] = attacker
	print('Got you: ', attacker.name)
