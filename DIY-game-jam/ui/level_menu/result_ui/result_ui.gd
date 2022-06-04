extends Control

signal level_completed

onready var winlose: TextureRect = $ResultPanel/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	Player.connect("player_died", self, "_on_player_died")
	winlose.texture = load("res://ui/level_menu/result_ui/win.png")

func _on_comfirm_pressed():
	Sound.play_sound("opening")
	Game.change_scene("level_select")

func _on_player_died():
	winlose.texture = load("res://ui/level_menu/result_ui/lose.png")
