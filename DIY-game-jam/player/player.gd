extends Node

signal selection_changed(character)
signal mana_changed(new_mana)
signal player_died
signal show_result_signal

export(int) var max_hp = 20
export(int) var init_mana = 15
export(float) var init_speed_mode = 1
var selected_character = null setget change_selection
var hp: int = max_hp setget set_hp
var mana: int = init_mana setget set_mana
var atkPause: bool = false setget set_atkpause
var defPause: bool = false setget set_defpause
var speed_mode: float = init_speed_mode setget set_speed_mode
var can_win: bool = true

func reset():
	self.selected_character = null
	self.hp = max_hp
	self.mana = init_mana
	self.atkPause = false
	self.defPause = false
	self.can_win = true


func change_selection(new_character):
	selected_character = new_character
	emit_signal("selection_changed", new_character)


func set_hp(new_hp: int):
	hp = new_hp
	print("Player HP: ", hp)
	if hp <= 0:
		hp = 0
		defPause = true
		atkPause = true
		Sound.play_sound("lose")
		emit_signal("show_result_signal")
		emit_signal("player_died")


func set_mana(new_mana: int):
	mana = new_mana
	print("Player mana: ", mana)
	emit_signal("mana_changed", mana)

func set_speed_mode(new_mode: float):
	speed_mode = new_mode

	
func set_atkpause(pause_state: bool):
	atkPause = pause_state


func set_defpause(pause_state: bool):
	defPause = pause_state

