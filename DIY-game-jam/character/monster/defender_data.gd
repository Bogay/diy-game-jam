extends Resource
class_name DefenderData

enum DefenderType {
	MELEE,
	REMOTE,
}

export(DefenderType) var type = DefenderType.REMOTE
export(Resource) var bullet_data
export(Resource) var animation
export(Texture) var preview
export(int) var max_hp
export(int) var attack
export(int) var defense
export(int) var magic_attack
export(int) var magic_defense
export(int) var attack_distance
# Attack speed
export(float) var speed

func _ready():
	assert(bullet_data is BulletData)
	assert(animation is SpriteFrames)
