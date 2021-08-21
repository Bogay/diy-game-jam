class_name DefenderPreview
extends Button

export(Resource) var defender_data = null setget set_defender
onready var sprite: TextureRect = $Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("defender_preview")
	

func set_defender(new_defender: DefenderData):
	defender_data = new_defender
	sprite.texture = defender_data.preview
	
