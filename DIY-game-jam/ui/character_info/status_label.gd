class_name StatusLabel
extends MarginContainer


export var status_name: String setget set_name
export var status_value: int setget set_value
onready var name_label: Label = $VBoxContainer/Name
onready var value_label: Label = $VBoxContainer/MarginContainer/Value


func set_name(new_name: String):
	print('Set name: ', new_name)
	status_name = new_name
	name_label.text = "%s:" % status_name


func set_value(new_value: int):
	print('Set value: ', new_value)
	status_value = new_value
	value_label.text = String(status_value)
