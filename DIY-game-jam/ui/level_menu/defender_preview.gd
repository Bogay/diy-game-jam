class_name DefenderPreview
extends Button

export(Resource) var defender_data = null setget set_defender
onready var sprite: TextureRect = $Sprite
onready var cost: Label = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	assert(connect("pressed", self, "set_selection") == OK)
	add_to_group("defender_preview")


func set_defender(new_defender: DefenderData):
	defender_data = new_defender
	if defender_data != null:
		disabled = false
		sprite.texture = defender_data.get("preview")
		cost.text = String(defender_data.cost)
		cost.show()
	else:
		disabled = true
		sprite.texture = null
		cost.hide()


func set_selection():
	Player.selected_character = defender_data
