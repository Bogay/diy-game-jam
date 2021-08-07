extends Reference

class_name Buffable

var base: int
var buffs: Array

func _init(val):
	base = val

func value() -> int:
	return base
