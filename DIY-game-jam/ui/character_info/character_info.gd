class_name CharacterInfo
extends GridContainer

const status = {
	"hp": "hp",
	"dex": "speed",
	"atk": "attack",
	"rng": "attack_distance",
	"def": "defense",
	"type": "type",
}
var character = null setget set_character
onready var labels = get_tree().get_nodes_in_group("status_label")


func _ready():
	self.character = null


func set_character(new_character):
	print("Set character: ", new_character)
	character = new_character
	if character == null:
		clear_character()
	else:
		sync_status()


func clear_character():
	var idx = 0
	for status_name in status:
		var label: StatusLabel = labels[idx]
		update_label(label, status_name, 0)
		print("Update ", label.status_name, " ", label.status_value)
		idx += 1


func sync_status():
	var idx = 0
	for status_name in status:
		var label: StatusLabel = labels[idx]
		update_label(label, status_name, character.get(status_name, 0))
		print("Update ", label.status_name, " ", label.status_value)
		idx += 1


func update_label(label: StatusLabel, name: String, value: int):
	label.status_name = name
	label.status_value = value