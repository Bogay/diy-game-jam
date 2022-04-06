extends Node

signal play_finished
signal scene_finished

func _ready():
	var video_player: VideoPlayer = $VideoPlayer
	#yield(video_player, "finished")
	video_player.hide()
	print("Finish video")
	#var image_viewer: ImageViewer = $ImageViewer
	#image_viewer.play()
	#yield(image_viewer, "play_finished")
	emit_signal("play_finished")
	emit_signal("scene_finished")
