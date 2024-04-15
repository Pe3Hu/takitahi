extends MarginContainer


#region vars
@onready var bg = $BG
@onready var creature = $HBox/Creature
@onready var banner = $HBox/Banner

var warzone = null
var rank = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	warzone = input_.warzone
	rank = input_.rank
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	#custom_minimum_size = Global.vec.size.card.zone
	var input = {}
	input.proprietor = self
	banner.set_attributes(input)
	input.type = "unreasonable"
	creature.set_attributes(input)
	banner.creatures.append(creature)
	banner.update_styles()
#endregion
