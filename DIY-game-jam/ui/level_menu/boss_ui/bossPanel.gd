extends Control

onready var bossPanel = $"."
onready var bossInfo = $bossInfo
onready var bossTitle = $bossTitle
onready var bossImg = $bossImg

var dict = {
	"knight":[
		"Speed up attacker for 3 seconds",
		"the Kinght",
		"res://ui/level_menu/boss_ui/boss_img/knight.jpg"
	],
	"robot":[
		"Stop defender for 3 seconds",
		"Time Controller",
		"res://ui/level_menu/boss_ui/boss_img/robot.jpg"
	]
}

func _ready():
	pass

func show_boss(racial):
	bossInfo.text = dict[racial][0]
	bossTitle.text = "BOSS:\n" + dict[racial][1]
	bossImg.texture = load(dict[racial][2])
	
	Player.atkPause = true
	Player.defPause = true
	bossPanel.show()
	yield(get_tree().create_timer(3/Player.speed_mode), "timeout")
	bossPanel.hide()
	Player.atkPause = false
	Player.defPause = false
