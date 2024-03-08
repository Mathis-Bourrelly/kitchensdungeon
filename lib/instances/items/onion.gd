class_name Onion extends Item

@onready var mesh :MeshInstance3D = $food_ingredient_onion
@onready var cooked_state = "res://scenes/instances/items/cooked/onion_rings.tscn"

func _ready():
	super._ready()
	var root = get_node(".")
	root.add_to_group("cuttable")
