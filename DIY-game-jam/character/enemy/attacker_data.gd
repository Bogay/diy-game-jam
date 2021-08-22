class_name AttackerData
extends Resource


export(String, FILE) var attacker_scene
export(Texture) var preview
export(Resource) var animation
export(int) var max_hp
export(int) var attack
export(int) var defense
export(int) var magic_attack
export(int) var magic_defense
export(int) var attack_distance
export(int) var detect_distance
export(float) var speed


func _ready():
	assert(animation is SpriteFrames)


func instance():
	var ins = (load(attacker_scene) as PackedScene).instance()
	ins.attacker_data = self
	return ins
