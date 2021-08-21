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
onready var sprite: TextureRect = $HBoxContainer/PreviewBG/PreviewSprite

func _ready():
	self.character = null
	assert(Player.connect("selection_changed", self, "set_character") == OK)

func set_character(new_character):
	print("Set character: ", new_character)
	character = new_character
	update_sprite()
	if character == null:
		clear_character()
	else:
		sync_status()


func clear_character():
	var idx = 0
	for status_name in status:
		var label: StatusLabel = labels[idx]
		update_label(label, status_name, 0)
		idx += 1


func sync_status():
	var idx = 0
	for status_name in status:
		var label: StatusLabel = labels[idx]
		var label_value = character.get(status[status_name])
		if label_value == null:
			label_value = 0
		update_label(label, status_name, label_value)
		idx += 1


func update_sprite():
	if character == null:
		sprite.texture = null
	elif not character is Node:
		sprite.texture = character.preview
	else:
		var data = character.get("attacker_data")
		if data == null:
			data = character.get("defender_data")
		sprite.texture = data.preview


func update_label(label: StatusLabel, name: String, value):
	if value is Buffable:
		value = value.value()
	label.status_name = name
	label.status_value = value
