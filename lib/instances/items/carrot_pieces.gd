class_name CarrotPieces extends Item

@onready var mesh :MeshInstance3D = $food_ingredient_carrot_pieces
@onready var cooked_state = null

func _ready():
	super._ready()
	var root = get_node(".")
	root.add_to_group("step_carrot")
	root.add_to_group("step")
