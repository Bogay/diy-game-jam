class_name LevelSelect
extends Node

onready var story_btn: BaseButton = $UIRoot/VSplitContainer/VBoxContainer/StoryButton


func _ready():
	assert(story_btn.connect("pressed", self, "load_story_select") == OK)


func load_level1():
	Game.change_scene("level0")


func load_level2():
	Game.change_scene("level1")


func load_story_select():
	Game.change_scene("story_select")
