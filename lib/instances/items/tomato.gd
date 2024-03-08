class_name Tomato extends Item

@onready var mesh :MeshInstance3D = $food_ingredient_tomato
@onready var cooked_state = "res://scenes/instances/items/cooked/tomato_slices.tscn"

func _ready():
	super._ready()
	var root = get_node(".")
	root.add_to_group("cuttable")
