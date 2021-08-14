class_name Bullet
extends Node2D

export(Resource) var bullet_data = null
var target: Node2D
var direction: Vector2


func _ready():
	assert(bullet_data is BulletData)
	assert(($DamageArea as Area2D).connect("area_entered", self, "_on_area_entered") == OK)


func _process(delta: float):
	if target == null:
		return
	direction += (target.global_position - global_position).normalized()
	direction = direction.normalized()
	global_position += delta * bullet_data.speed * direction
	rotation_degrees = rad2deg(direction.angle())


func _on_area_entered(area: Area2D):
	var attacker = area.get_parent() as Attacker
	if attacker == null or area.name != "DamageArea":
		return
	attack(attacker)


func attack(attack_target: Attacker):
	attack_target.take_damage(bullet_data.attack)
	# TODO: play dead VFX
	queue_free()
