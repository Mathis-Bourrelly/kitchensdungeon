class_name Item extends Node3D

@onready var snap_point:Marker3D = $SnapPoint

var is_taken:bool = false
var slot

func _ready():
	
	var root = get_node(".")
	root.mass = 0.35
	root.add_to_group("item")
	root.add_to_group("highlightable")
	
	root.set_collision_layer_value(1,false)
	root.set_collision_layer_value(3,true)
	
	root.set_collision_mask_value(1,true)
	root.set_collision_mask_value(2,true)
	root.set_collision_mask_value(3,true)
	root.set_collision_mask_value(4,true)
