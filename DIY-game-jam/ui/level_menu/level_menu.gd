extends CanvasLayer
class_name LevelMenu


var level setget set_level
onready var btn_spawn: Button = $ViewportContainer/Panel/VBoxContainer/LevelInfo/Waves/Spawn

# Just for test
var tentacle_shooter: DefenderData = preload("res://character/monster/tentacle_shooter/tentacle_shooter.tres")
var beastman: DefenderData = preload("res://character/monster/beastman/beastman.tres")


func set_level(curr_level):
	level = curr_level
	setup_spawn_buttons()
	register_event_listener()


func setup_spawn_buttons():
	var previews = get_tree().get_nodes_in_group("defender_preview")
	for preview in previews:
		preview = preview as DefenderPreview
		assert(preview != null)
		preview.defender_data = tentacle_shooter


func register_event_listener():
	assert(btn_spawn.connect("pressed", level, "spawn_next_wave") == OK)

