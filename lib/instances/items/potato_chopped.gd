class_name PotatoChopped extends Item

@onready var mesh :MeshInstance3D = $food_ingredient_potato_chopped
@onready var cooked_state = null

func _ready():
	super._ready()
	var root = get_node(".")
	root.add_to_group("step_potato")
	root.add_to_group("step")
