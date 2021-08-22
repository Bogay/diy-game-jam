class_name ImageViewer
extends CanvasLayer

signal play_finished
signal scene_finished
signal clicked


export(String, DIR) var image_dir_path
# MAGIC
export(float) var _scale = 0.75
onready var sprite: Sprite = $Sprite


func _ready():
	if not image_dir_path.ends_with("/"):
		image_dir_path += "/"
	sprite.set_scale(Vector2(_scale, _scale))
	# HACK
	if get_parent().name != "Opening":
		play()


func play():
	var image_dir = Directory.new()
	image_dir.open(image_dir_path)
	image_dir.list_dir_begin()
	while true:
		var image_name = image_dir.get_next()
		if image_name == "":
			break
		# Use .import to make it work at exported application
		# See https://github.com/godotengine/godot/issues/14562 for more detail
		if image_name.ends_with(".import"):
			image_name = image_name.replace(".import", "")
			print(image_name)
			var image = load(image_dir_path + image_name)
			sprite.texture = image
			yield(self, "clicked")
	print("End of image view")
	end()


func _unhandled_input(_event: InputEvent):
	if Input.is_action_pressed('click'):
		emit_signal("clicked")


func end():
	emit_signal("play_finished")
	emit_signal("scene_finished")
