class_name GameSave
extends Resource


export(Dictionary) var defenders = {}
export(Array, String) var levels = []
export(Array, String) var stories = []
export(Dictionary) var captures = {}


# FIXME: Find a better place to define these IDs
func _init():
	# We have a lv. 1 tentacle initially
	defenders = {
		"dandelion": 1,
		"fire_flower": 1,
		"cactus": 1,
		"cherry": 1,
		"stonegarlic": 1,
		"salix": 1,
		"lily": 1,
		"sakura": 1,
	}
	stories = ["opening"]
	levels = ["level1"]
