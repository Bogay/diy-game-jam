class_name Level
extends Node2D

# Store pathes in this level
export(Array, NodePath) var paths
# Array of attackers' waves
export(Array, Resource) var waves
var wave_idx = 0

func prepare_paths() -> void:
	if paths.size() == 0:
		paths = get_tree().get_nodes_in_group('attacker_path')
		# No group found
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


func _ready():
	prepare_paths()
	for wave in waves:
		wave.setup()


func spawn_wave(wave):
	var follow = PathFollow2D.new()
	paths[0].add_child(follow)
	var attacker = wave.attackers["test"].instance()
	attacker.path = follow
	add_child(attacker)


func _on_next_wave():
	if wave_idx >= waves.size():
		emit_signal("level_completed")
		return
	spawn_wave(waves[wave_idx])
	wave_idx += 1
