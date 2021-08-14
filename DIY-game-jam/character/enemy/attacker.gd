class_name Attacker
extends Node2D

export(Resource) var attacker_data = null
var max_hp: Buffable
var hp: int
var attack: Buffable
var defense: Buffable
var magic_attack: Buffable
var magic_defense: Buffable
var attack_distance: Buffable
var detect_distance: Buffable
var speed: Buffable
var offset = 0
var path: PathFollow2D = null
onready var attack_area: Area2D = $AttackArea
onready var detect_area: Area2D = $DetectArea
onready var attack_shape: CollisionShape2D = $AttackArea/CollisionShape2D
onready var detect_shape: CollisionShape2D = $DetectArea/CollisionShape2D


func _ready():
	assert(attacker_data is AttackerData)
	max_hp = Buffable.new(attacker_data.max_hp)
	hp = max_hp.value()
	attack = Buffable.new(attacker_data.attack)
	defense = Buffable.new(attacker_data.defense)
	magic_attack = Buffable.new(attacker_data.magic_attack)
	magic_defense = Buffable.new(attacker_data.magic_defense)
	speed = Buffable.new(attacker_data.speed)
	# Setup collision
	attack_distance = Buffable.new(attacker_data.attack_distance)
	detect_distance = Buffable.new(attacker_data.detect_distance)
	(attack_shape.shape as CircleShape2D).radius = attack_distance.value()
	(detect_shape.shape as CircleShape2D).radius = detect_distance.value()
	add_to_group("attacker")

	
func _physics_process(delta):
	if path == null:
		return
	offset += speed.value() * delta
	path.offset = offset
	global_position = path.global_position


func take_damage(damage: int):
	var def_value = defense.value()
	var dmg_decrease = def_value / (def_value + 100)
	damage *= (1 - dmg_decrease)
	hp -= damage
	print("HP: ", hp)
	if hp <= 0:
		die()


func die():
	print("I am die QAQ")
	queue_free()
