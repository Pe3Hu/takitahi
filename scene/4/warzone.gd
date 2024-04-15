extends MarginContainer


#region vars
@onready var zones = $VBox/Zones

var planet = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	
	init_basic_setting()


func init_basic_setting() -> void:
	fill_zones()


func fill_zones() -> void:
	while zones.get_child_count() < Global.num.warzone.n:
		add_zone()


func add_zone() -> void:
	var input = {}
	input.warzone = self
	input.rank = 4

	var zone = Global.scene.zone.instantiate()
	zones.add_child(zone)
	zone.set_attributes(input)
#endregion
