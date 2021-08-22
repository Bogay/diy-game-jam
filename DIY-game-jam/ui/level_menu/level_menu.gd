extends CanvasLayer
class_name LevelMenu


var level setget set_level
onready var btn_spawn: Button = $ViewportContainer/Panel/VBoxContainer/LevelInfo/Waves/Spawn
onready var wave_label: Label = $ViewportContainer/Panel/VBoxContainer/LevelInfo/Waves/Label

# Just for test
var tentacle_shooter: DefenderData = preload("res://character/monster/tentacle_shooter/tentacle_shooter.tres")
var beastman: DefenderData = preload("res://character/monster/beastman/beastman.tres")


func set_level(curr_level):
	level = curr_level
	setup_spawn_buttons()
	register_event_listener()


func setup_spawn_buttons():
	var previews = get_tree().get_nodes_in_group("defender_preview")
	for i in range(len(previews)):
		var preview: DefenderPreview = previews[i]
		assert(preview != null)
		if i % 2:
			preview.defender_data = tentacle_shooter
		else:
			preview.defender_data = beastman


func register_event_listener():
	assert(btn_spawn.connect("pressed", level, "spawn_next_wave") == OK)
	assert(level.connect("wave_changed", self, "update_wave_label") == OK)
	assert(level.connect("next_wave_availability_changed", self, "_on_next_wave_availability_changed") == OK)


func update_wave_label(curr_idx: int, wave_cnt: int):
	wave_label.text = "%d / %d" % [curr_idx, wave_cnt]


func _on_next_wave_availability_changed(is_avaliable: bool):
	btn_spawn.disabled = not is_avaliable
