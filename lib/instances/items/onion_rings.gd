class_name OnionRings extends Item

@onready var mesh :MeshInstance3D = $food_ingredient_onion_rings
@onready var cooked_state = null

func _ready():
	super._ready()
	var root = get_node(".")
	root.add_to_group("step_onion")
	root.add_to_group("step")
