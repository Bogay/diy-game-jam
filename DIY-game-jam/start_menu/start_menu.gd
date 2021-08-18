class_name StartMenu
extends Node2D

signal game_started


onready var start_button: Button = $Start

func _ready():
	assert(start_button.connect("pressed", self, "game_start") == OK)


func game_start():
	print("Are you ready?")
	emit_signal("game_started")
