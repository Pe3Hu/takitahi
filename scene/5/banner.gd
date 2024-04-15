extends MarginContainer


#region vars
@onready var trap = $Styles/Trap
@onready var range = $Styles/Range
@onready var melee = $Styles/Melee

var proprietor = null
var styles = {}
var creatures = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	for key in input_:
		set(key, input_[key])
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_styles()


func init_styles() -> void:
	for style in Global.arr.style:
		var token = get(style)
		var input = {}
		input.proprietor = self
		input.type = "aspect"
		input.subtype = style
		input.value = 0
		
		token.set_attributes(input)
		styles[style] = token


func reset_styles() -> void:
	for style in Global.arr.style:
		var token = get(style)
		token.set_value(0)


func update_styles() -> void:
	reset_styles()
	
	for creature in creatures:
		for style in creature.styles:
			var value = creature.styles[style].get_value()
			styles[style].change_value(value)
#endregion
