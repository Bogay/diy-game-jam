class_name Attacker
extends Node2D

enum State {
	IDLE,
	HOVERD,
	SELECTED,
	PRESSED,
	OCCUPIED,
}

export(Resource) var attacker_data = null
var racial: String
var max_hp: Buffable
var hp: int
var animated_hp: float = 0
var attack: Buffable
var defense: Buffable
var magic_attack: Buffable
var magic_defense: Buffable
var attack_distance: Buffable
var detect_distance: Buffable
var speed: Buffable
var speed_buff: float = 1.0
var speed_nerf: float = 1.0
var offset = 0
var skillCD = 0
var path: PathFollow2D = null
var path_offset: Vector2 = Vector2.ZERO
var capture = false
var showHP = false
var isBoss = false
var usingSkill = false
onready var attack_area: Area2D = $Attacker/AttackArea
onready var detect_area: Area2D = $Attacker/DetectArea
onready var attack_shape: CollisionShape2D = $Attacker/AttackArea/CollisionShape2D
onready var detect_shape: CollisionShape2D = $Attacker/DetectArea/CollisionShape2D
onready var animated_sprite: AnimatedSprite = $Attacker/AnimatedSprite
onready var tween = $Attacker/Tween
onready var bar: Control = $Attacker/LifeBar
onready var life_bar_texture: TextureProgress = $Attacker/LifeBar/LifeBar/TextureProgress
onready var boss_sign: VBoxContainer = $Attacker/LifeBar/Boss_sign
onready var fire_sign = $Attacker/fireSign
onready var buff_sign = $Attacker/buffSign
onready var nerf_sign = $Attacker/nerfSign

var mouse_state: Array = [State.IDLE]

func _ready():
	# assert(attacker_data is AttackerData)
	racial = attacker_data.racial
	max_hp = Buffable.new(attacker_data.max_hp)
	hp = max_hp.value()
	attack = Buffable.new(attacker_data.attack)
	defense = Buffable.new(attacker_data.defense)
	magic_attack = Buffable.new(attacker_data.magic_attack)
	magic_defense = Buffable.new(attacker_data.magic_defense)
	speed = Buffable.new(attacker_data.speed)
	animated_sprite.frames = attacker_data.animation
	animated_sprite.animation = "walk"
	# Setup collision
	attack_distance = Buffable.new(attacker_data.attack_distance)
	(attack_shape.shape as CircleShape2D).radius = attack_distance.value()
	detect_distance = Buffable.new(attacker_data.detect_distance)
	(detect_shape.shape as CircleShape2D).radius = detect_distance.value()
	# FIXME: It's not a good idea to hard-code the radius value
	path_offset = get_path_offset(15)
	print("Path offset: ", path_offset)
	
	# TODO: Make this a static variable or mathod.
	# 	Anyway, give it a consitent way to check whether it is a attacker
	add_to_group("attacker")
	
	# Init life bar
	bar.hide()
	life_bar_texture.max_value = max_hp.value()
	update_health(max_hp.value())
	

func _process(_delta):
	if Player.atkPause:
		animated_sprite.stop()
	else:
		animated_sprite.play()
		animated_sprite.speed_scale = Player.speed_mode
	life_bar_texture.value = round(animated_hp)
	
	on_buff_sign()
	
#	if isBoss:
	if racial == "knight" and not usingSkill:
		skillCD += 1 * Player.speed_mode
		if skillCD >= 500:
			on_skill()
			knight_skill()
#			robot_skill()
			skillCD = int(skillCD)%500
		

func _physics_process(delta):
	if not Player.atkPause and not usingSkill:
		if path == null:
			return
		# Captured attackers can not move
		if capture == true:
			return
		var old_pos = global_position
		# Update offset
		offset += speed.value() * delta * Player.speed_mode * speed_buff
		path.offset = offset
		global_position = path.global_position + path_offset
		# Check filp
		var is_left = (global_position - old_pos).x < 0
		animated_sprite.flip_h = is_left


func get_path_offset(radius: float = 1) -> Vector2:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var angle = rng.randf_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)) * radius


# FIXME: Maybe let `Attacker` extends `Aera2D` is better
static func is_damage_area(area: Area2D):
	if area.name != "DamageArea":
		return false
	var attacker = area.get_parent()
	if attacker == null:
		return false
	attacker = attacker.get_parent() as Attacker
	if attacker == null:
		return false
	return attacker


func take_damage(damage: int):
	var def_value = defense.value()
	var dmg_decrease = def_value / (def_value + 100)
	damage *= (1 - dmg_decrease)
	hp -= damage
	
	if not showHP:
		bar.show()
		if isBoss: boss_sign.show()
		showHP = true
	update_health(hp)
	
	if hp <= 0:
		die()


func die():
	print(name, ": I am die QAQ")
	Player.mana += attacker_data.drop_mana
	
#	var start_color = Color(1.0, 1.0, 1.0, 1.0)
#	var end_color = Color(1.0, 1.0, 1.0, 0.0)
#	tween.interpolate_property(self, "modulate", start_color, end_color, 0.3)
	queue_free()

func set_boss():
	isBoss = true

func update_health(new_value):
	tween.interpolate_property(self, "animated_hp", animated_hp, new_value, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()


func _input(event):
	if mouse_state.has(State.HOVERD) and event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_action_pressed("click"):
			mouse_state += [State.PRESSED]
		if mouse_state.find(State.PRESSED) and event.button_index == BUTTON_LEFT and event.is_action_released("click"):
			Player.selected_character = attacker_data
			mouse_state += [State.SELECTED]


func _on_DamageArea_mouse_entered():
	if mouse_state.has(State.IDLE):
		mouse_state = [State.HOVERD]


func _on_DamageArea_mouse_exited():
	mouse_state = [State.IDLE]

func buff(s:float):
	speed_buff = s
	
func on_fire():
	fire_sign.show()
	yield(get_tree().create_timer(1.0/Player.speed_mode), "timeout")
	fire_sign.hide()
	
func on_buff_sign():
	if speed_buff > speed_nerf:
		nerf_sign.hide()
		buff_sign.show()
	elif speed_buff < speed_nerf:
		buff_sign.hide()
		nerf_sign.show()
	else:
		buff_sign.hide()
		nerf_sign.hide()

func knight_skill():
	for atkers in get_tree().get_nodes_in_group("attacker"):
		if atkers.racial != "knight":
			atkers.speed_buff = 2.5
	yield(get_tree().create_timer(3.0/Player.speed_mode), "timeout")
	for atkers in get_tree().get_nodes_in_group("attacker"):
		if atkers.racial != "knight":
			atkers.speed_buff = 1
	

func robot_skill():
	Player.defPause = true
	yield(get_tree().create_timer(3/Player.speed_mode), "timeout")
	Player.defPause = false

func on_skill():
	usingSkill = true
	animated_sprite.animation = "skill"
#	animated_sprite.play()

func _on_animation_finished():
	if usingSkill:
		usingSkill = false
		animated_sprite.animation = "walk"
