class_name Defender
extends Node2D

enum State {
	IDLE,
	HOVERD,
	SELECTED,
	PRESSED,
	OCCUPIED,
}

export(Resource) var defender_data = null setget set_defender_data
var type = DefenderData.DefenderType.REMOTE
var defender_name: String
var max_hp: Buffable
var hp: int
var attack: Buffable
var attack_buf: float = 1.0
var defense: Buffable
var magic_attack: Buffable
var magic_defense: Buffable
var attack_distance: Buffable
# Attack speed
var speed: Buffable
var speed_buf: float = 1.0
var detected_attackers = {}
var sup_defenders = {}
var can_attack = 1
var original_muzzle_x: float = 0
onready var muzzle: Node2D = $Muzzle
onready var attack_area: Area2D = $AttackArea
onready var attack_shape: CollisionShape2D = $AttackArea/CollisionShape2D
onready var animated_sprite: AnimatedSprite = $AnimatedSprite

var mouse_state: Array = [State.IDLE]

func _ready():
	assert(defender_data != null)
	assert(defender_data is DefenderData)
	animated_sprite.frames = defender_data.animation
	animated_sprite.animation = "idle"
	var shape = CircleShape2D.new()
	shape.radius = attack_distance.value()
	attack_shape.shape = shape
	assert(attack_distance.connect("value_changed", self, "_on_attack_distance_changed") == OK)
	assert(attack_area.connect("area_entered", self, "_on_area_entered") == OK)
	assert(attack_area.connect("area_exited", self, "_on_area_exited") == OK)
	original_muzzle_x = muzzle.position.x
	add_to_group("defender")
	Player.selected_character = self


func _process(_delta: float):
	# FIXME: Use a general API to process defender behavior
	update_direction()
	if type == DefenderData.DefenderType.REMOTE:
		try_shoot()
	elif type == DefenderData.DefenderType.MELEE:
		bomb()
	elif type == DefenderData.DefenderType.AREA:
		area_attack()
	else:
		refresh_defenders()
		support()


func set_defender_data(new_data: DefenderData):
	print("Set defender data")
	defender_data = new_data
	defender_name = defender_data.defender_name
	type = defender_data.type
	max_hp = Buffable.new(defender_data.max_hp)
	hp = max_hp.value()
	attack = Buffable.new(defender_data.attack)
	defense = Buffable.new(defender_data.defense)
	magic_attack = Buffable.new(defender_data.magic_attack)
	magic_defense = Buffable.new(defender_data.magic_defense)
	speed = Buffable.new(defender_data.speed)
	attack_distance = Buffable.new(defender_data.attack_distance)


func update_direction():
	var target = get_target_attacker()
	if target == null:
		return
	var is_left = (target.global_position - global_position).x < 0
	animated_sprite.flip_h = is_left
	muzzle.position.x = -original_muzzle_x if is_left else original_muzzle_x


func try_shoot():
	if not detected_attackers.empty():
		if not can_attack:
			return
		shoot()


func shoot() -> void:
	# TODO: read bullet from defender data
	var bullet_scene = preload("res://battle/test.tscn") as PackedScene
	var bullet = bullet_scene.instance() as Bullet
	var target = get_target_attacker()
	assert(target.connect("tree_exiting", bullet, "_on_target_exiting") == OK)
	bullet.target = target
	bullet.set_animation(defender_name)
	add_child(bullet)
	bullet.global_position = muzzle.global_position
	play_attack_animation()
	can_attack = 0
	yield(get_tree().create_timer(1 / (speed.value() * Player.speed_mode * speed_buf ) ), "timeout")
	can_attack = 1


func play_attack_animation():
	animated_sprite.animation = "attack"
	animated_sprite.speed_scale = Player.speed_mode
	#assert(animated_sprite.connect("animation_finished", self, "attack_animation_callback") == OK)
	

func attack_animation_callback():
	animated_sprite.disconnect("animation_finished", self, "attack_animation_callback")
	animated_sprite.animation = "idle"


func get_target_attacker():
	if not len(detected_attackers):
		return null
	var id = detected_attackers.keys()[0]
	return detected_attackers[id]


func bomb():
	for id in detected_attackers:
		var attacker = detected_attackers[id]
		attacker.capture = true
	if detected_attackers.size() >= 3:
		for id in detected_attackers:
			if defender_name=="cherry":
				detected_attackers[id].take_damage(attack.value() + attack_buf)
				var attacker = detected_attackers[id]
				attacker.capture = false
		queue_free()


func _on_attack_distance_changed(dis):
	(attack_shape.shape as CircleShape2D).radius = dis


func _on_area_entered(area: Area2D):
	var attacker = Attacker.is_damage_area(area)
	if not attacker is Attacker:
		return
	enqueue_attacker(attacker)


func enqueue_attacker(attacker: Attacker):
	var attacker_id = attacker.get_instance_id()
	assert(not attacker_id in detected_attackers)
	# FIXME: I can't find a way to get the exited node id,
	#   so I need to scan whole the dictionary to remove attacker.
	#assert(attacker.connect("tree_exited", self, "refresh_attackers") == OK)
	detected_attackers[attacker_id] = attacker
	print("Got you: ", attacker.name)
	
func enqueue_defender(defender: Defender):
	var defender_id = defender.get_instance_id()
	# FIXME: I can't find a way to get the exited node id,
	#   so I need to scan whole the dictionary to remove attacker.
	if not defender_id in sup_defenders:
		sup_defenders[defender_id] = defender
		print("Got you: ", defender.name)


func _on_area_exited(area: Area2D):
	var attacker = Attacker.is_damage_area(area)
	if not attacker is Attacker:
		return
	dequeue_attacker(attacker)


func dequeue_attacker(attacker: Attacker):
	var attacker_id = attacker.get_instance_id()
	assert(attacker_id in detected_attackers)
	attacker.buff(1.0)
	detected_attackers.erase(attacker_id)
	print("Good bye: ", attacker.name)


func refresh_attackers():
	var will_remove = []
	for id in detected_attackers:
		var attacker =  detected_attackers[id]
		if not attacker.is_inside_tree():
			will_remove.append(id)
	for id in will_remove:
		detected_attackers.erase(id)
		
func _input(event):
	if mouse_state.has(State.HOVERD) and event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_action_pressed("click"):
			mouse_state += [State.PRESSED]
		if mouse_state.find(State.PRESSED) and event.button_index == BUTTON_LEFT and event.is_action_released("click"):
			Player.selected_character = defender_data
			mouse_state += [State.SELECTED]

func refresh_defenders():
	for a in attack_area.get_overlapping_areas():
		var defender_supp = a.get_parent() as Defender
		if defender_supp != null and defender_supp.type != DefenderData.DefenderType.SUP:
			enqueue_defender(defender_supp)
		
func support():
	if not sup_defenders.empty():
		for id in sup_defenders:
			if sup_defenders[id].type !=DefenderData.DefenderType.MELEE: 
				if defender_name=="sakura":
					sup_defenders[id].buff(speed_buf,float(attack.value()))
				elif defender_name=="lily":
					sup_defenders[id].buff(speed.value() ,attack_buf)


func area_attack():
	if not detected_attackers.empty():
		if not can_attack:
			return
		for id in detected_attackers:
			if defender_name=="stonegarlic":
				detected_attackers[id].take_damage(attack.value() + attack_buf)
			elif defender_name=="salix":
				detected_attackers[id].buff(0.5)
		if defender_name=="stonegarlic":
			can_attack = 0
			yield(get_tree().create_timer(1 / (speed.value() * Player.speed_mode * speed_buf) ), "timeout")
			can_attack = 1
func _on_Area2D_mouse_entered():
	if mouse_state.has(State.IDLE):
		mouse_state = [State.HOVERD]


func _on_Area2D_mouse_exited():
	mouse_state = [State.IDLE]

func buff(s:float, a:float):
	speed_buf = s
	attack_buf = a
