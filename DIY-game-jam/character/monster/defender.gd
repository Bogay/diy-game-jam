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
var can_attack = 1
var original_muzzle_x: float = 0
onready var muzzle: Node2D = $Muzzle
onready var attack_area: Area2D = $AttackArea
onready var attack_shape: CollisionShape2D = $AttackArea/CollisionShape2D
onready var animated_sprite: AnimatedSprite = $AnimatedSprite

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
	assert(attack_distance.connect("value_changed", self, "_on_attack_distance_changed") == OK)
	assert(attack_area.connect("area_entered", self, "_on_area_entered") == OK)
	assert(attack_area.connect("area_exited", self, "_on_area_exited") == OK)
	animated_sprite.animation = "idle"
	original_muzzle_x = muzzle.position.x
	add_to_group("defender")


func _process(_delta: float):
	update_direction()
	try_shoot()


func update_direction():
	var target = get_target_attacker()
	if target == null:
		return
	var is_left = (target.global_position - global_position).x < 0
	animated_sprite.flip_h = is_left
	muzzle.position.x = -original_muzzle_x if is_left else original_muzzle_x


func try_shoot():
	if not detected_attackers.empty():
		if not can_attack:
			return
		shoot()


func shoot() -> void:
	# TODO: read bullet from defender data
	var bullet_scene = preload("res://battle/test.tscn") as PackedScene
	var bullet = bullet_scene.instance() as Bullet
	var target = get_target_attacker()
	assert(target.connect("tree_exiting", bullet, "_on_target_exiting") == OK)
	bullet.target = target
	muzzle.add_child(bullet)
	play_attack_animation()
	can_attack = 0
	yield(get_tree().create_timer(1 / speed.value()), "timeout")
	can_attack = 1


func play_attack_animation():
	animated_sprite.animation = "attack"
	assert(animated_sprite.connect("animation_finished", self, "attack_animation_callback") == OK)
	

func attack_animation_callback():
	animated_sprite.disconnect("animation_finished", self, "attack_animation_callback")
	animated_sprite.animation = "idle"


func get_target_attacker() -> Attacker:
	if not len(detected_attackers):
		return null
	var id = detected_attackers.keys()[0]
	return detected_attackers[id]


func _on_attack_distance_changed(dis):
	(attack_shape.shape as CircleShape2D).radius = dis


func _on_area_entered(area: Area2D):
	var attacker = area.get_parent() as Attacker
	if attacker == null or area.name != "DamageArea":
		return
	enqueue_attacker(attacker)


func enqueue_attacker(attacker: Attacker):
	var attacker_id = attacker.get_instance_id()
	assert(not attacker_id in detected_attackers)
	# FIX: I can't find a way to get the exited node id,
	#   so I need to scan the dictionary to remove attacker.
	assert(attacker.connect("tree_exited", self, "refresh_attackers") == OK)
	detected_attackers[attacker_id] = attacker
	print("Got you: ", attacker.name)


func _on_area_exited(area: Area2D):
	var attacker = area.get_parent() as Attacker
	if attacker == null or area.name != "DamageArea":
		return
	dequeue_attacker(attacker)


func dequeue_attacker(attacker: Attacker):
	var attacker_id = attacker.get_instance_id()
	assert(attacker_id in detected_attackers)
	detected_attackers.erase(attacker_id)
	print("Good bye: ", attacker.name)


func refresh_attackers():
	var will_remove = []
	for id in detected_attackers:
		var attacker =  detected_attackers[id]
		if not attacker.is_inside_tree():
			will_remove.append(id)
	for id in will_remove:
		detected_attackers.erase(id)
