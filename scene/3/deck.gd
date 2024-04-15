extends MarginContainer


#region vars
@onready var available = $Cards/Available
@onready var discharged = $Cards/Discharged
@onready var broken = $Cards/Broken
@onready var hand = $Cards/Hand

var proprietor = null
var type = null
var role = null
var capacity = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	type = input_.type
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	#custom_minimum_size = Global.vec.size.deck
	capacity.current = 6
	capacity.base = 6
	input_.deck = self
	
	match type:
		"god":
			role = "striker"
		"warzone":
			role = "defender"
	
	#var roles = {}
	#roles["god"] = "striker"
	#roles["warzone"] = "defender"
	
	init_cards()
	
	for key in Global.dict.area.next:
		if key != null:
			input_.type = key
			var cardstack = get(key)
			cardstack.set_attributes(input_)


func init_cards() -> void:
	for _i in Global.num.deck.n:
		add_card()


func add_card() -> void:
	var input = {}
	input.proprietor = self
	input.area = "discharged"

	var card = Global.scene.card.instantiate()
	discharged.cards.add_child(card)
	card.set_attributes(input)
	card.set_deck_as_proprietor(self)
#endregion


func refill_hand() -> void:
	var cardstack = get(Global.dict.area.prior[hand.type])
	
	while hand.cards.get_child_count() < capacity.current:
		var card = cardstack.advance_random_card()
		proprietor.banner.creatures.append(card.creature)
	
	proprietor.banner.update_styles()


func discard_hand() -> void:
	hand.advance_all_cards()
	proprietor.banner.reset_styles()
