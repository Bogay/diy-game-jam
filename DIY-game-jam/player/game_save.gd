class_name GameSave
extends Resource


export(Dictionary) var defenders = {}
export(Array, String) var levels = []
export(Array, String) var boss = []
export(Array, String) var stories = []
export(Dictionary) var captures = {}
export(int) var volume = 0


# FIXME: Find a better place to define these IDs
func _init():
	# We have a lv. 1 tentacle initially
	defenders = {
		"cactus": 1,
		"cherry": 1,
		"lily": 1,
	}
	stories = ["opening"]
	levels = ["level1"]
	boss = ["beastman", "human-soldier", "elf", "yusha"]
	volume = 0
