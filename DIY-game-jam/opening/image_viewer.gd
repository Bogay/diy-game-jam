class_name ImageViewer
extends Node

signal play_finished
signal clicked


export(String, DIR) var image_dir_path
# MAGIC
export(float) var scale = 0.75
onready var sprite: Sprite = $Sprite

func _ready():
	if not image_dir_path.ends_with("/"):
		image_dir_path += "/"
	sprite.set_scale(Vector2(scale, scale))
		

func play():
	var image_dir = Directory.new()
	image_dir.open(image_dir_path)
	image_dir.list_dir_begin()
	while true:
		var image_name = image_dir.get_next()
		if image_name == "":
			break
		if image_name.ends_with(".png"):
			print(image_name)
			var image = load(image_dir_path + image_name)
			sprite.texture = image
			yield(self, "clicked")
	print("End of image view")
	emit_signal("play_finished")


func _unhandled_input(_event: InputEvent):
	if Input.is_action_pressed('click'):
		emit_signal("clicked")
