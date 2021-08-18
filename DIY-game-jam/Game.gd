class_name Game
extends Node2D

var start_menu = preload("res://start_menu/start_menu.tscn")
var opening = preload("res://opening/opening.tscn")
var level0 = preload("res://level/level0/level0.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var menu_ins: StartMenu = change_scene(start_menu)
	yield(menu_ins, "game_started")
	var image_viewer: ImageViewer = change_scene(opening).get_node("ImageViewer")
	yield(image_viewer, "play_finished")
	change_scene(level0)


func change_scene(scene):
	if get_child_count() != 0:
		var current_scene = get_child(0)
		remove_child(current_scene)
		current_scene.queue_free()
	if scene is String:
		scene = load(scene)
	assert(scene is PackedScene)
	var next_scene = scene.instance()
	add_child(next_scene)
	return next_scene

