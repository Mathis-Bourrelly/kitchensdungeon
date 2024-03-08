class_name Carrot extends Item

@onready var mesh :MeshInstance3D = $food_ingredient_carrot
@onready var cooked_state = "res://scenes/instances/items/cooked/carrot_pieces.tscn"

func _ready():
	super._ready()
	var root = get_node(".")
	root.add_to_group("cuttable")
