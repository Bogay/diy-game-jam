extends Control

var opening = preload("res://sound/opening_sound.mp3")
var win = preload("res://sound/win_sound.mp3")
var lose = preload("res://sound/lose_sound.mp3")
var battle = preload("res://sound/battle_sound.mp3")
var cur_sound = ""

onready var soundplayer = $soundplayer

# Called when the node enters the scene tree for the first time.
func _ready():
	var save: GameSave = GameSaveManager.current_save
	soundplayer.volume_db = save.volume

func play_sound(sound):
	if cur_sound != sound:
		if sound == "opening":
			soundplayer.stream = opening
		elif sound == "win":
			soundplayer.stream = win
		elif sound == "lose":
			soundplayer.stream = lose
		elif sound == "battle":
			soundplayer.stream = battle
	soundplayer.play()
