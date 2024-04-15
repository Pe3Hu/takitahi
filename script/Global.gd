extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()
	init_font()


func init_arr() -> void:
	arr.resource = ["gold", "power"]
	arr.indicator = ["health"]
	arr.action = ["hide", "reveal", "alert"]
	arr.role = ["defender", "striker"]
	arr.style = ["trap", "range", "melee"]
	arr.tool = ["steel", "mana"]
	arr.indicator = ["health", "stamina"]
	arr.penalty = ["dimension", "agility"]


func init_num() -> void:
	num.index = {}
	num.index.card = 0
	
	num.warzone = {}
	num.warzone.n = 4
	
	num.deck = {}
	num.deck.n = 12
	
	num.style = {}
	num.style.min = 2
	num.style.max = 8


func init_dict() -> void:
	init_neighbor()
	init_season()
	init_area()
	
	init_totem()
	init_race()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]



func init_season() -> void:
	dict.season = {}
	dict.season.phase = {}
	dict.season.phase["spring"] = ["incoming"]
	dict.season.phase["summer"] = ["selecting", "outcoming"]
	dict.season.phase["autumn"] = ["wounding"]
	dict.season.phase["winter"] = ["wilting", "sowing"]
	
	dict.style = {}
	dict.style.tool = {}
	dict.style.tool["trap"] = {}
	dict.style.tool["trap"]["steel"] = "chain"
	dict.style.tool["trap"]["mana"] = "seal"
	dict.style.tool["range"] = {}
	dict.style.tool["range"]["steel"] = "ball"
	dict.style.tool["range"]["mana"] = "spell"
	dict.style.tool["melee"] = {}
	dict.style.tool["melee"]["steel"] = "blade"
	dict.style.tool["melee"]["mana"] = "rune"


func init_area() -> void:
	dict.area = {}
	dict.area.next = {}
	dict.area.next[null] = "discharged"
	dict.area.next["discharged"] = "available"
	dict.area.next["available"] = "hand"
	dict.area.next["hand"] = "discharged"
	dict.area.next["broken"] = "discharged"
	
	dict.area.prior = {}
	dict.area.prior["available"] = "discharged"
	dict.area.prior["hand"] = "available"


func init_totem() -> void:
	dict.totem = {}
	dict.totem.title = {}
	
	var exceptions = ["title", "terrain"]
	var path = "res://asset/json/takitahi_totem.json"
	var array = load_data(path)
	
	for totem in array:
		var data = {}
		data.terrain = totem.terrain
		data.style = {}
		data.tool = {}
		
		for key in totem:
			if !exceptions.has(key):
				if arr.style.has(key):
					data.style[key] = totem[key]
				if arr.tool.has(key):
					data.tool[key] = totem[key]
			
			dict.totem.title[totem.title] = data


func init_race() -> void:
	dict.race = {}
	dict.race.title = {}
	
	var exceptions = ["title", "terrain"]
	var path = "res://asset/json/takitahi_race.json"
	var array = load_data(path)
	var keys = ["style", "tool", "indicator", "penalty"]
	
	for race in array:
		var data = {}
		data.terrain = race.terrain
		data.totem = {}
		
		for key in race:
			if !exceptions.has(key):
				var words = key.split(" ")
				
				if words.size() > 1:
					data[words[1]][words[0]] = race[key]
				else:
					
					for _key in keys:
						if arr[_key].has(key):
							if !data.has(_key):
								data[_key] = {}
								
							data[_key][key] = race[key]
			
			dict.race.title[race.title] = data


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.token = load("res://scene/0/token.tscn")
	
	scene.pantheon = load("res://scene/1/pantheon.tscn")
	scene.god = load("res://scene/1/god.tscn")
	
	scene.planet = load("res://scene/2/planet.tscn")
	scene.area = load("res://scene/2/area.tscn")
	
	scene.card = load("res://scene/3/card.tscn")
	
	scene.zone = load("res://scene/4/zone.tscn")


func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	vec.size.number = Vector2(vec.size.sixteen)
	
	vec.size.token = Vector2(48, 48)
	#vec.size.card = {}
	#vec.size.card.market = Vector2(vec.size.token.x * 2, vec.size.token.y)
	#vec.size.card.deck = Vector2(vec.size.token.x, vec.size.token.y)
	vec.size.bar = Vector2(128, 16)
	#vec.size.deck = Vector2(vec.size.token.x * 6, vec.size.token.y * 5)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.card = {}
	color.card.selected = {}
	color.card.selected[true] = Color.from_hsv(160 / h, 0.4, 0.7)
	color.card.selected[false] = Color.from_hsv(60 / h, 0.2, 0.9)
	
	color.indicator = {}
	color.indicator.health = {}
	color.indicator.health.fill = Color.from_hsv(0 / h, 0.9, 0.7)
	color.indicator.health.background = Color.from_hsv(0 / h, 0.5, 0.9)
	color.indicator.endurance = {}
	color.indicator.endurance.fill = Color.from_hsv(270 / h, 0.9, 0.7)
	color.indicator.endurance.background = Color.from_hsv(270 / h, 0.5, 0.9)


func init_font():
	dict.font = {}
	dict.font.size = {}
	#dict.font.size["resource"] = 24
	#dict.font.size["card"] = 24
	dict.font.size["season"] = 18
	dict.font.size["phase"] = 18
	dict.font.size["moon"] = 18


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var _parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null


func get_all_constituents_based_on_limit(array_: Array, limit_: int) -> Dictionary:
	var constituents = {}
	constituents[0] = []
	constituents[1] = []
	
	for child in array_:
		constituents[0].append(child)
		
		if child.value <= limit_:
			constituents[1].append([child])
	
	for _i in array_.size()-2:
		set_constituents_based_on_size_and_limit(constituents, _i+2, limit_)
	
	var value = 0
	
	for constituent in array_:
		value += constituent.value
	
	if value <= limit_:
		constituents[array_.size()] = [constituents[0]]
	
	constituents.erase(0)
	
	for _i in range(constituents.keys().size()-1,-1,-1):
		var key = constituents.keys()[_i]
		
		if constituents[key].is_empty():
			constituents.erase(key)
	
	return constituents


func set_constituents_based_on_size_and_limit(constituents_: Dictionary, size_:int, limit_: int) -> void:
	var parents = constituents_[size_-1]
	constituents_[size_] = []
	
	for parent in parents:
		var value = 0
		
		for constituent in parent:
			value += constituent.value
		
		for child in constituents_[0]:
			if !parent.has(child) and value + child.value <= limit_:
				var constituent = []
				constituent.append_array(parent)
				constituent.append(child)
				constituent.sort_custom(func(a, b): return constituents_[0].find(a) < constituents_[0].find(b))
				
				if !constituents_[size_].has(constituent):
					constituents_[size_].append(constituent)
