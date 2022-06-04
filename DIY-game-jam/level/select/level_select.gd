class_name LevelSelect
extends Node

onready var story_btn: BaseButton = $UIRoot/VSplitContainer/VBoxContainer/StoryButton
onready var level1_btn: BaseButton = $UIRoot/VBoxContainer/LevelSelectButtons/level1/level1
onready var level2_btn: BaseButton = $UIRoot/VBoxContainer/LevelSelectButtons/level2/level2
onready var level3_btn: BaseButton = $UIRoot/VBoxContainer/LevelSelectButtons/level3/level3
onready var level4_btn: BaseButton = $UIRoot/VBoxContainer/LevelSelectButtons/level4/level4
onready var level5_btn: BaseButton = $UIRoot/VBoxContainer/LevelSelectButtons2/level5/level5
onready var level6_btn: BaseButton = $UIRoot/VBoxContainer/LevelSelectButtons2/level6/level6
onready var level7_btn: BaseButton = $UIRoot/VBoxContainer/LevelSelectButtons2/level7/level7
onready var level8_btn: BaseButton = $UIRoot/VBoxContainer/LevelSelectButtons2/level8/level8
onready var option_btn: BaseButton = $UIRoot/AspectRatioContainer/Settings

func _ready():
	assert(story_btn.connect("pressed", self, "load_story_select") == OK)
	assert(option_btn.connect("pressed", self, "show_popup") == OK)
	var save: GameSave = GameSaveManager.current_save
	if "level1" in save.levels:
		level1_btn.disabled = false
		assert(level1_btn.connect("pressed", self, "load_level1") == OK)
	if "level2" in save.levels:
		level2_btn.disabled = false
		assert(level2_btn.connect("pressed", self, "load_level2") == OK)
	if "level3" in save.levels:
		level3_btn.disabled = false
		assert(level3_btn.connect("pressed", self, "load_level3") == OK)
	if "level4" in save.levels:
		level4_btn.disabled = false
		assert(level4_btn.connect("pressed", self, "load_level4") == OK)
	if "level5" in save.levels:
		level5_btn.disabled = false
		assert(level5_btn.connect("pressed", self, "load_level5") == OK)
	if "level6" in save.levels:
		level6_btn.disabled = false
		assert(level6_btn.connect("pressed", self, "load_level6") == OK)
	if "level7" in save.levels:
		level7_btn.disabled = false
		assert(level7_btn.connect("pressed", self, "load_level7") == OK)
	if "level8" in save.levels:
		level8_btn.disabled = false
		assert(level8_btn.connect("pressed", self, "load_level8") == OK)


func load_level1():
	Game.change_scene("level0")

func load_level2():
	Game.change_scene("level1")
		
func load_level3():
	Game.change_scene("level2")
	
func load_level4():
	Game.change_scene("level3")

func load_level5():
	Game.change_scene("level4")

func load_level6():
	Game.change_scene("level5")

func load_level7():
	Game.change_scene("level6")

func load_level8():
	Game.change_scene("level7")

func load_story_select():
	Game.change_scene("story_select")


func show_popup():
	get_tree().quit()
