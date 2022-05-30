extends Resource
class_name DefenderData

enum DefenderType {
	MELEE,
	REMOTE,
	SUP,
	AREA,
}

export(String, FILE) var defender_scene
export(DefenderType) var type = DefenderType.REMOTE
export(String) var defender_name
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
export(int) var cost = 1


# TODO: Resource don't have `_ready` method
func _ready():
	assert(bullet_data is BulletData)
	assert(animation is SpriteFrames)


func instance():
	var ins = (load(defender_scene) as PackedScene).instance()
	ins.defender_data = self
	return ins
