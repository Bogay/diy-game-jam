extends Node

var start_menu = preload("res://start_menu/start_menu.tscn")
var opening = preload("res://opening/opening.tscn")
var level0 = preload("res://level/level0/level0.tscn")
var current_scene = null


func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func change_scene(scene):
	call_deferred("defered_change_scene", scene)


func defered_change_scene(scene):
	current_scene.free()
	scene = get_scene(scene)
	assert(scene is PackedScene)
	var next_scene = scene.instance()
	get_tree().get_root().add_child(next_scene)
	current_scene = next_scene
	return next_scene


# FIXME: Hard-coded ID is bad
func get_scene(scene: String):
	if not scene.begins_with("res://"):
		if scene == "opening":
			return opening
		elif scene == "level_select":
			return null
	return load(scene)
