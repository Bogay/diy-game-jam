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
		"tentacle_shooter": 1,
	}
	stories = ["opening"]
	levels = ["level1"]
