class_name Bullet
extends Node2D

export(Resource) var bullet_data = null
var target: Node2D
var direction: Vector2


func _ready():
	assert(bullet_data is BulletData)


func _process(delta: float):
	if target == null:
		return
	direction += (target.global_position - global_position).normalized()
	direction = direction.normalized()
	global_position += delta * bullet_data.speed * direction
	rotation_degrees = rad2deg(direction.angle())
