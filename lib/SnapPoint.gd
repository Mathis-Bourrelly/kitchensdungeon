extends Node3D

var is_occupied:bool = false
var snapped_item = null
var parent = null

func add_item_to_slot(item_to_add):
	snapped_item = item_to_add
	is_occupied = true
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(snapped_item,"position",self.global_position - snapped_item.snap_point.position,0.2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(snapped_item,"rotation",self.global_rotation - snapped_item.snap_point.rotation,0.2).set_ease(Tween.EASE_OUT)
	tween.connect("finished", on_tween_finished)
	
func on_tween_finished():
	if snapped_item != null:
		snapped_item.set_freeze_enabled(true)
		snapped_item.slot = self
	
func remove_item_to_slot(snapped_item):
	pass
	#TODO sortir unfreeze de player
func action():
	parent.action()
