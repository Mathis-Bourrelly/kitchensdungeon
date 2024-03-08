class_name Potato extends Item

@onready var mesh :MeshInstance3D = $food_ingredient_potato
@onready var cooked_state = "res://scenes/instances/items/cooked/potato_chopped.tscn"

func _ready():
	super._ready()
	var root = get_node(".")
	root.add_to_group("cuttable")
