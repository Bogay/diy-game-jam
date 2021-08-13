class_name Slot
extends Node2D

enum State {
	IDLE,
	HOVERD,
	SELECTED,
	PRESSED,
}

export(NodePath) var area2d_path = @"Area2D"
var state = State.IDLE setget set_state
var was_select = false
onready var area2d = get_node(area2d_path)


func _ready():
	assert(area2d is Area2D)
	print('Slot init')
	area2d.connect("mouse_entered", self, "_on_mouse_entered")
	area2d.connect("mouse_exited", self, "_on_mouse_exited")
	area2d.connect("input_event", self, "_on_input")

	
func set_state(new_state):
	print('New state', new_state)
	state = new_state


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
