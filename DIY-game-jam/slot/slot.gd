class_name Slot
extends Node2D

enum State {
	IDLE,
	HOVERD,
	SELECTED,
	PRESSED,
	OCCUPIED,
}

export(DefenderData.DefenderType) var allowed_type = DefenderData.DefenderType.REMOTE
export(NodePath) var area2d_path = @"Area2D"
var state = State.IDLE setget set_state
var was_select = false
onready var area2d: Area2D = get_node(area2d_path)
onready var sprite: Sprite = $Sprite

func _ready():
	assert(area2d.connect("mouse_entered", self, "_on_mouse_entered") == OK)
	assert(area2d.connect("mouse_exited", self, "_on_mouse_exited") == OK)
	assert(area2d.connect("input_event", self, "_on_input") == OK)

	
func set_state(new_state):
	print('New state', new_state)
	state = new_state
	# TODO: process event
	if state == State.SELECTED:
		_on_selected()
		state = State.OCCUPIED
		

func _on_selected():
	if not spawn_defender():
		print("Spawn defender error")
		return
	sprite.hide()


func spawn_defender() -> bool:
	var selection = Player.selected_character
	if not selection is DefenderData:
		print("Selection is not defedner data, can not spawn")
		return false
	if selection.type != allowed_type:
		print("Selected defedner is not allowed to spawn at this slot")
		return false
	if selection.cost > Player.mana:
		print("Not enough mana (req: %d, own: %d)" % [selection.cost, Player.mana])
		return false
	Player.mana -= selection.cost
	var defender_ins: Defender = selection.instance()
	add_child(defender_ins)
	Player.selected_character = defender_ins
	return true


func _on_input(_viewport, _event, _shape_id):
	if Input.is_action_just_pressed("click"):
		if state in [State.HOVERD, State.SELECTED]:
			# Save last state
			was_select = state == State.SELECTED
			self.state = State.PRESSED
	elif Input.is_action_just_released("click"):
		if state == State.PRESSED:
			self.state = [
				State.SELECTED,
				State.HOVERD,
			][int(was_select)]


func _on_mouse_entered():
	if state == State.IDLE:
		self.state = State.HOVERD
	print("I am in!")


func _on_mouse_exited():
	if state in [State.HOVERD, State.PRESSED]:
		self.state = State.IDLE
	print("I am out!")
