class_name RackBowl extends StaticBody3D

@onready var mesh :MeshInstance3D = $rack_bowl
@onready var item_to_spawn = "res://scenes/bowl_stew.tscn"

func _ready():
	var root = get_node(".")
	root.add_to_group("rack")
	root.add_to_group("highlightable")
	
	root.set_collision_layer_value(1,false)
	root.set_collision_layer_value(4,true)
	
	root.set_collision_mask_value(1,true)
	root.set_collision_mask_value(2,true)
	root.set_collision_mask_value(3,true)
	root.set_collision_mask_value(4,true)
	

func spawn_item(item_to_spawn):
	var new_item = load(item_to_spawn).instantiate()
	new_item.set_global_position(global_position + Vector3(0.0,2.0,0.0))
	GameState.current_level.add_child(new_item)
	return new_item
