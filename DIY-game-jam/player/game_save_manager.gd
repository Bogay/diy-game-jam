extends Node


const save_path = "user://game_save.tres"
const tentacle_shooter = preload("res://character/monster/tentacle_shooter/tentacle_shooter.tres")
const beastman = preload("res://character/monster/beastman/beastman.tres")
# FIXME: Find a better place to define these IDs
const defenders = {
	"tentacle_shooter": tentacle_shooter,
	"beastman": beastman,
}
const stories = [
	"opening",
	"level1",
	"level2",
]
export(Resource) var current_save = null


func _ready():
	if not File.new().file_exists(save_path):
		current_save = GameSave.new()
		assert(ResourceSaver.save(save_path, current_save) == OK)
	else:
		current_save = load(save_path)
