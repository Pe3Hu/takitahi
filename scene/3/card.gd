extends MarginContainer


#region vars
@onready var bg = $BG
@onready var creature = $Creature

var proprietor = null
var title = null
var area = null
var selected = false
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	for key in input_:
		set(key, input_[key])
	
	init_basic_setting()


func init_basic_setting() -> void:
	#custom_minimum_size = Global.vec.size.card.market
	init_creature()
	#init_bg()


func init_creature() -> void:
	var input = {}
	input.proprietor = self
	input.type = "reasonable"
	input.race = Global.dict.race.title.keys().pick_random()
	var totems = {}
	
	for order in Global.dict.race.title[input.race].totem:
		var totem = Global.dict.race.title[input.race].totem[order]
		
		match order:
			"primary":
				totems[totem] = 4
			"secondary":
				totems[totem] = 1
	
	input.totem = Global.get_random_key(totems)
	
	creature.set_attributes(input)


func init_bg() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)
	set_selected(false)


func advance_area() -> void:
	var cardstack = null
	
	if area == null:
		area = Global.dict.area.next[area]
		advance_area()
	else:
		cardstack = proprietor.get(area)
		cardstack.cards.remove_child(self)
	
		area = Global.dict.area.next[area]
		cardstack = proprietor.get(area)
		cardstack.cards.add_child(self)


func set_deck_as_proprietor(deck_: MarginContainer) -> void:
	var cardstack = proprietor.get(area)
	var market = false
	
	if cardstack == null:
		cardstack = proprietor
		market = true
	
	cardstack.cards.remove_child(self)
	proprietor = deck_
	area = "discharged"
	
	cardstack = proprietor.get(area)
	cardstack.cards.add_child(self)
	
	#cost.visible = false
	#custom_minimum_size = Global.vec.size.card.deck
	#size = Global.vec.size.card.deck
	#set_selected(false)
	
	if !market:
		advance_area()


func set_selected(selected_: bool) -> void:
	selected = selected_
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.card.selected[selected_]
#endregion
