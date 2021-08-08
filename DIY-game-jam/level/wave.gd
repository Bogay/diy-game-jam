class_name Wave
extends Resource

# Dict[str, str]
# Key is the id for attacher
# Value is the resource path
export(Dictionary) var attackers
export(String, FILE, '*.json') var wave_json_path
# Serialized wave data (from json)
var wave_data: Array

class SubWave:
	func _init():
		pass

	static func cmp(a: SubWave, b: SubWave):
		return true

func load_json(path: String) -> JSONParseResult:
	var f = File.new()
	f.open(path, File.READ)
	var ret = f.get_as_text()
	f.close()
	return JSON.parse(ret)

func setup():
	wave_data = load_json(wave_json_path).result
	for key in attackers:
		var attacker = load(attackers[key])
		assert(attacker is PackedScene)
		attackers[key] = attacker
