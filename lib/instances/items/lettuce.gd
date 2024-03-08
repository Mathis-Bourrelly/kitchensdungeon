class_name Lettuce extends Item

@onready var mesh :MeshInstance3D = $food_ingredient_lettuce
@onready var cooked_state = "res://scenes/instances/items/cooked/lettuce_chopped.tscn"

func _ready():
	super._ready()
	var root = get_node(".")
	root.add_to_group("cuttable")
