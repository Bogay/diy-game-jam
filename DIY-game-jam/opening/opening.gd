extends Node


func _ready():
	var video_player: VideoPlayer = $VideoPlayer
	yield(video_player, "finished")
	video_player.hide()
	print("Finish video")
	var image_viewer: ImageViewer = $ImageViewer
	image_viewer.play()
	yield(image_viewer, "play_finished")
	Game.change_scene("level_select")
