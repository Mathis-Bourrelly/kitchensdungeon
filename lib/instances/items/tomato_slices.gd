class_name TomatoSlices extends Item

@onready var mesh :MeshInstance3D = $food_ingredient_tomato_slices
@onready var cooked_state = null

func _ready():
	super._ready()
	var root = get_node(".")
	root.add_to_group("step_tomato")
	root.add_to_group("step")
