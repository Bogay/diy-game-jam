class_name StartMenu
extends Node2D


onready var start_button: Button = $Start

func _ready():
	assert(start_button.connect("pressed", self, "game_start") == OK)


func game_start():
	print("Are you ready?")
	Game.change_scene("opening")
