class_name StorySelect
extends Node


onready var opening_btn: BaseButton = $UIRoot/StorySelectButtons/opening/button
onready var level1_btn: BaseButton = $UIRoot/StorySelectButtons/level1/button
onready var level2_btn: BaseButton = $UIRoot/StorySelectButtons/level2/button
onready var back_btn: BaseButton = $UIRoot/AspectRatioContainer/Back


func _ready():
	assert(opening_btn.connect("pressed", self, "go_opening") == OK)
	assert(level1_btn.connect("pressed", self, "go_level1") == OK)
	assert(level2_btn.connect("pressed", self, "go_level2") == OK)
	assert(back_btn.connect("pressed", self, "go_back") == OK)


func go_opening():
	Game.change_scene("opening", "story_select")


func go_level1():
	Game.change_scene("level1_win", "story_select")


func go_level2():
	Game.change_scene("level2_win", "story_select")


func go_back():
	Game.change_scene("level_select")
