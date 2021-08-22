class_name Bullet
extends Node2D

export(Resource) var bullet_data = null
var target: Node2D
var last_target_pos: Vector2 = Vector2.ZERO
var direction: Vector2


func _ready():
	assert(bullet_data is BulletData)
	assert(($DamageArea as Area2D).connect("area_entered", self, "_on_area_entered") == OK)


func _process(delta: float):
	if target == null:
		if move_to(last_target_pos, delta):
			queue_free()
	else:
		move_to(target.global_position, delta)


func move_to(target_pos: Vector2, delta: float):	
	direction += (target_pos - global_position).normalized()
	direction = direction.normalized()
	var move_vec = delta * bullet_data.speed * direction
	var collide = false
	if (target_pos - global_position).length() <= move_vec.length():
		collide = true
	global_position += move_vec
	rotation_degrees = rad2deg(direction.angle())
	return collide


func _on_area_entered(area: Area2D):
	var attacker = Attacker.is_damage_area(area)
	if not attacker is Attacker:
		return
	if target != null and attacker != target:
		print("You are not my target, ", attacker.name)
		return
	attack(attacker)


func attack(attack_target: Attacker):
	attack_target.take_damage(bullet_data.attack)
	# TODO: play dead VFX
	queue_free()


func _on_target_exiting():
	last_target_pos = target.global_position
	target = null
