class_name Level
extends Node2D


signal level_completed
signal wave_changed(wave_idx, max_wave)
signal next_wave_availability_changed(is_avaliable)


# Store pathes in this level
export(Array, NodePath) var paths
# Array of attackers' waves
export(Array, Resource) var waves
export(String) var level_name
export(String) var next_level_name
var level_menu: PackedScene = preload("res://ui/level_menu/level_menu.tscn")
var current_wave: Wave = null
var wave_idx = 0
var sub_wave_idx = 0
var attacker_cnt = 0
onready var attackers = $Entities/Attackers


func _ready():
	Player.reset()
	setup_paths()
	setup_menu()
	assert(connect("level_completed", self, "_on_level_completed") == OK)
	assert(Player.connect("player_died", self, "go_to_level_select") == OK)
	emit_signal("wave_changed", 1, len(waves))


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
	level_menu_ins.level = self


func spawn_wave(wave: Wave):
	wave.setup()
	current_wave = wave
	sub_wave_idx = 0
	emit_signal("next_wave_availability_changed", false)
	for sub_wave in wave.sub_waves:
		yield(get_tree().create_timer(sub_wave.time), "timeout")
		assert(len(sub_wave.groups) <= len(paths))
		for path_idx in range(len(sub_wave.groups)):
			var group = sub_wave.groups[path_idx]
			for id in group:
				var attacker = wave.attackers[id]
				for _i in range(group[id]):
					spawn_attacker(attacker.instance(), path_idx)
		sub_wave_idx += 1
		if wave_idx < len(waves) and progress() >= 0.5:
			emit_signal("next_wave_availability_changed", true)


func spawn_attacker(attacker: Attacker, path_idx: int):
	attacker_cnt += 1
	assert(attacker.connect("tree_exiting", self, "_on_attacker_exiting") == OK)
	var follow = PathFollow2D.new()
	paths[path_idx].add_child(follow)
	attacker.path = follow
	attackers.add_child(attacker)


func _on_attacker_exiting():
	attacker_cnt -= 1
	assert(attacker_cnt >= 0)
	if attacker_cnt > 0:
		return
	if wave_idx >= waves.size():
		emit_signal("level_completed")
	else:
		spawn_next_wave()


func _on_level_completed():
	var save: GameSave = GameSaveManager.current_save
	if next_level_name != "" and not next_level_name in save.levels:
		save.levels.append(next_level_name)
	if not level_name in save.stories:
		save.stories.append(level_name)
		# Play story at first unlock
		Game.change_scene("%s_win" % level_name, "level_select")
	else:
		Game.change_scene("level_select")
	# HACK: Add beastman into players defender
	GameSaveManager.save()
	print("Level [%s] completed!" % level_name)


func spawn_next_wave():
	if wave_idx >= waves.size():
		print("Last wave has beed spawned")
		return
	# Check progress
	if progress() < 0.5:
		print("Progress not enough to spawn next wave: ", progress())
		return
	spawn_wave(waves[wave_idx])
	wave_idx += 1
	emit_signal("wave_changed", wave_idx, len(waves))


func progress() -> float:
	if current_wave == null:
		return 1.0
	return float(sub_wave_idx) / len(current_wave.sub_waves)
