extends CanvasLayer
class_name LevelMenu


var level setget set_level
onready var btn_spawn: Button = $ViewportContainer/Panel/VBoxContainer/LevelInfo/Waves/Spawn


func set_level(curr_level):
	level = curr_level
	register_event_listener()


func register_event_listener():
	assert(btn_spawn.connect("pressed", level, "spawn_next_wave") == OK)

