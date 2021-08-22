class_name End
extends Area2D

signal attacker_reached(attacker)


export(int) var distance = 10
var attackers = []


func _ready():
	assert(self.connect("area_entered", self, "_on_area_entered") == OK)


func _process(_delta):
	attackers = self.filter(attackers, funcref(self, "is_valid_node"))
	for attacker in attackers:
		var diff = attacker.global_position - global_position
		if diff.length() <= distance:
			emit_signal("attacker_reached", attacker)
			attacker.queue_free()


func _on_area_entered(area: Area2D):
	var attacker = Attacker.is_damage_area(area)
	if not attacker is Attacker:
		return
	print("New attacker is coming")
	attackers.append(attacker)


# TODO: Move these to a util class, if need
static func filter(arr: Array, predict: FuncRef):
	var ret = []
	for elem in arr:
		if predict.call_func(elem):
			ret.append(elem)
	return ret


static func is_valid_node(node: Node):
	if node == null:
		return false
	return node.is_inside_tree()
