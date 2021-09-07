class_name Buffable
extends Reference

signal value_changed(new_val)

var base: float setget set_base
var buffs: Array

func _init(val):
	base = val


func set_base(new_base):
	base = new_base
	emit_signal("value_changed", value())


func value() -> float:
	return base
