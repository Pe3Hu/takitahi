extends MarginContainer


#region vars
@onready var trap = $HBox/Styles/Trap
@onready var range = $HBox/Styles/Range
@onready var melee = $HBox/Styles/Melee
@onready var health = $HBox/Indicators/Health
@onready var stamina = $HBox/Indicators/Stamina
@onready var dimension = $HBox/Penalties/Dimension
@onready var agility = $HBox/Penalties/Agility

var proprietor = null
var type = null
var race = null
var totem = null
var styles = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	for key in input_:
		set(key, input_[key])
	
	init_basic_setting()


func init_basic_setting() -> void:
	#custom_minimum_size = Global.vec.size.card.market
	init_limtis()
	init_styles()


func init_limtis() -> void:
	var keys = ["indicator", "penalty"]
	#var types = {}
	#types["indicator"] = "indicators"
	#types["penalty"] = "penalties"
	
	for key in keys:
		for subtype in Global.arr[key]:
			var token = get(subtype)
			var input = {}
			input.proprietor = self
			input.type = "aspect"
			input.subtype = subtype
			#var type = types[key]
			
			match type:
				"reasonable":
					input.value = Global.dict.race.title[race][key][subtype]
				"unreasonable":
					input.value = 1
			
			token.set_attributes(input)


func init_styles() -> void:
	match type:
		"reasonable":
			var tools = {}
			
			for tool in Global.arr.tool:
				tools[tool] = Global.dict.race.title[race].tool[tool] + Global.dict.totem.title[totem].tool[tool]
			
			for style in Global.arr.style:
				if Global.dict.race.title[race].style.has(style):
					var token = get(style)
					var tool = Global.get_random_key(tools)
					var input = {}
					input.proprietor = self
					input.type = "aspect"
					input.subtype = Global.dict.style.tool[style][tool]
					input.value = Global.dict.race.title[race].style[style] + Global.dict.totem.title[totem].style[style]
					
					token.set_attributes(input)
					token.visible = true
					styles[style] = token
		"unreasonable":
			for style in Global.arr.style:
				var token = get(style)
				var tool = Global.arr.tool.pick_random()
				var input = {}
				input.proprietor = self
				input.type = "aspect"
				input.subtype = Global.dict.style.tool[style][tool]
				input.value = 0
				
				token.set_attributes(input)
				token.visible = true
				styles[style] = token
			
			var total = int(proprietor.rank * 10)
			
			while total > 0:
				var style = styles.keys().pick_random()
				var value = Global.rng.randi_range(Global.num.style.min, Global.num.style.max)
				value = min(value, total)
				styles[style].change_value(value)
				total -= value
