extends Node

signal selection_changed(character)

var selected_character = null setget change_selection


func change_selection(new_character):
	selected_character = new_character
	emit_signal("selection_changed", new_character)
