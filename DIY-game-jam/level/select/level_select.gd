class_name LevelSelect
extends Node

onready var story_btn: BaseButton = $UIRoot/VSplitContainer/VBoxContainer/StoryButton
onready var level1_btn: BaseButton = $UIRoot/LevelSelectButtons/level1/level1
onready var level2_btn: BaseButton = $UIRoot/LevelSelectButtons/level2/level2


func _ready():
	assert(story_btn.connect("pressed", self, "load_story_select") == OK)
	var save: GameSave = GameSaveManager.current_save
	if "level1" in save.levels:
		level1_btn.disabled = false
		assert(level1_btn.connect("pressed", self, "load_level1") == OK)
	if "level2" in save.levels:
		level2_btn.disabled = false
		assert(level2_btn.connect("pressed", self, "load_level2") == OK)


func load_level1():
	Game.change_scene("level0")


func load_level2():
	Game.change_scene("level1")


func load_story_select():
	Game.change_scene("story_select")
