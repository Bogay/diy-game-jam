class_name DefenderPreview
extends Button

export(Resource) var defender_data = null setget set_defender
onready var sprite: TextureRect = $Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	assert(connect("pressed", self, "set_selection") == OK)
	add_to_group("defender_preview")


func set_defender(new_defender: DefenderData):
	defender_data = new_defender
	if defender_data != null:
		sprite.texture = defender_data.get("preview")
	# Disable if no defender binded
	disabled = defender_data == null


func set_selection():
	Player.selected_character = defender_data
