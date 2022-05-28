extends Node

var start_menu = preload("res://start_menu/start_menu.tscn")
var opening = preload("res://story/opening/opening.tscn")
var level_select = preload("res://level/select/level_select.tscn")
var level0 = preload("res://level/level0/level0.tscn")
var level1 = preload("res://level/level1/level1.tscn")
var story_select = preload("res://story/select/story_select.tscn")
var level1_win = preload("res://story/level1_win/level1_win.tscn")
var level2_win = preload("res://story/level2_win/level2_win.tscn")
var current_scene = null
var the_next_scene = null


func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


func change_scene(scene, future_scene = null):
	call_deferred("defered_change_scene", scene, future_scene)


func defered_change_scene(scene, future_scene = null):
	current_scene.free()
	if scene is String:
		scene = get_scene(scene)
		assert(scene is PackedScene)
	var next_scene = scene.instance()
	if future_scene != null:
		the_next_scene = future_scene
		assert(next_scene.connect("scene_finished", self, "change_to_future_scene") == OK)
	get_tree().get_root().add_child(next_scene)
	current_scene = next_scene
	return next_scene


# FIXME: Hard-coded ID is bad
func get_scene(scene: String):
	if not scene.begins_with("res://"):
		var loaded_scene: PackedScene = self.get(scene)
		assert(loaded_scene != null, "Can not found scene with id %s" % scene)
		return loaded_scene
	return load(scene)


func change_to_future_scene():
	Game.change_scene(the_next_scene)
