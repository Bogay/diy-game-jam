class_name Wave
extends Resource

# Dict[str, str]
# Key is the id for attacher
# Value is the resource path
export(Dictionary) var attackers
export(String, FILE, '*.json') var wave_json_path
# Serialized wave data (from json)
var sub_waves: Array = []


class SubWave:
	var time: float = 0
	var groups: Array = []

	func _init(_time: float, _groups: Array):
		time = _time
		groups = _groups

	static func cmp(a: SubWave, b: SubWave):
		return a.time < b.time

	static func from_dict(obj: Dictionary) -> SubWave:
		return SubWave.new(obj["time"], obj["groups"])


func setup():
	sub_waves = load_wave(wave_json_path)
	attackers = load_attacker(attackers)


func load_wave(path: String) -> Array:
	var parse_result = load_json(path).result
	assert(parse_result is Array)
	var tmp_sub_waves = []
	for elem in parse_result:
		tmp_sub_waves.append(SubWave.from_dict(elem))
	# Sort by time
	tmp_sub_waves.sort_custom(SubWave, "cmp")
	return tmp_sub_waves


func load_json(path: String) -> JSONParseResult:
	var f = File.new()
	f.open(path, File.READ)
	var ret = f.get_as_text()
	f.close()
	return JSON.parse(ret)


func load_attacker(_attackers: Dictionary) -> Dictionary:
	var tmp_attackers = {}
	for key in attackers:
		var attacker = load(attackers[key])
		assert(attacker is PackedScene)
		tmp_attackers[key] = attacker
	return tmp_attackers
