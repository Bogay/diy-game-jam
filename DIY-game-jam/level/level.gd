class_name Level
extends Node2D

# Store pathes in this level
export(Array, NodePath) var paths
# Array of attackers' waves
export(Array, Resource) var waves
var level_menu: PackedScene = preload("res://ui/level_menu.tscn")
var wave_idx = 0
var attacker_cnt = 0

func setup_paths() -> void:
	if paths.size() == 0:
		paths = get_tree().get_nodes_in_group('attacker_path')
		# No path found in group
		if paths.size() == 0:
			for child in get_children():
				if child is Path2D:
					paths.append(child)
	else:
		# Convert NodePath to Node (Path2D)
		for i in paths.size():
			paths[i] = get_node(paths[i])
	assert(paths.size() != 0)
	# Check type
	for path in paths:
		assert(path is Path2D)

# Instantiate level menu and connect signal callback
func setup_menu():
	var level_menu_ins: LevelMenu = level_menu.instance()
	add_child(level_menu_ins)
	assert(level_menu_ins.btn_spawn.connect("pressed", self, "_on_next_wave") == OK)


func _ready():
	setup_paths()
	setup_menu()
	for wave in waves:
		wave.setup()


func spawn_wave(wave):
	for _i in range(2):
		var attacker = wave.attackers["test"].instance()
		spawn_attacker(attacker)
		yield(get_tree().create_timer(0.6), "timeout")


func spawn_attacker(attacker: Attacker):
	attacker_cnt += 1
	assert(attacker.connect("tree_exiting", self, "_on_attacker_exiting") == OK)
	var follow = PathFollow2D.new()
	paths[0].add_child(follow)
	attacker.path = follow
	add_child(attacker)


func _on_attacker_exiting():
	attacker_cnt -= 1
	assert(attacker_cnt >= 0)
	if attacker_cnt == 0 and wave_idx >= waves.size():
		emit_signal("level_completed")
		print("level completed!")


func _on_next_wave():
	if wave_idx >= waves.size():
		return
	spawn_wave(waves[wave_idx])
	wave_idx += 1
