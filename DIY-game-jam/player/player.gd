extends Node

signal selection_changed(character)
signal mana_changed(new_mana)
signal player_died

export(int) var max_hp = 20
export(int) var init_mana = 15
var selected_character = null setget change_selection
var hp: int = max_hp setget set_hp
var mana: int = init_mana setget set_mana


func reset():
	self.selected_character = null
	self.hp = max_hp


func change_selection(new_character):
	selected_character = new_character
	emit_signal("selection_changed", new_character)


func set_hp(new_hp: int):
	hp = new_hp
	print("Player HP: ", hp)
	if hp <= 0:
		emit_signal("player_died")


func set_mana(new_mana: int):
	mana = new_mana
	print("Player mana: ", mana)
	emit_signal("mana_changed", mana)
