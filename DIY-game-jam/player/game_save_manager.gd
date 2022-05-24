extends Node


const save_path = "user://game_save.tres"
const cactus = preload("res://character/monster/cactus/cactus.tres")
const cherry = preload("res://character/monster/cherry/cherry.tres")
const dandelion = preload("res://character/monster/dandelion/dandelion.tres")
const fire_flower = preload("res://character/monster/fire_flower/fire_flower.tres")
const lily = preload("res://character/monster/lily/lily.tres")
const salix = preload("res://character/monster/salix/salix.tres")
const sakura = preload("res://character/monster/sakura/sakura.tres")
const stonegarlic = preload("res://character/monster/stonegarlic/stonegarlic.tres")
# FIXME: Find a better place to define these IDs
const defenders = {
	"cactus": cactus,
	"cherry": cherry,
	"dandelion": dandelion,
	"fire_flower": fire_flower,
	"stonegarlic": stonegarlic,
	"lily": lily,
	"sakura": sakura,
	"salix": salix,
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
		
	current_save.defenders["cactus"] = 1
	current_save.defenders["cherry"] = 1
	current_save.defenders["dandelion"] = 1
	current_save.defenders["fire_flower"] = 1
	current_save.defenders["stonegarlic"] = 1
	current_save.defenders["lily"] = 1
	current_save.defenders["sakura"] = 1
	current_save.defenders["salix"] = 1


func save():
	assert(ResourceSaver.save(save_path, current_save) == OK)
