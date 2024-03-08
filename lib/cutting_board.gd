extends StaticBody3D

var is_occupied:bool = false

@onready var cutting_sound = $AudioStreamPlayer
@onready var snapped_item_1 = $Slot1.snapped_item
@onready var snap_box_1 = $Slot1/place1
@onready var label_alert = $Label3D
@onready var label_alert_timer = $Label3D/Timer

func _ready():
	GameState.player.connect("droped_on_slot",_on_item_droped)
	$Slot1.parent = self

func _on_item_droped(item_to_snap):
	#if snapped_item_1 == null:	 TODO ???
		if item_to_snap.is_in_group("cuttable"):
			item_to_snap.slot.add_item_to_slot(item_to_snap)
			snapped_item_1 = $Slot1.snapped_item


func _on_place_1_body_entered(body):
	if not $Slot1.is_occupied:
		if snapped_item_1 == null:	
			if body.is_in_group("cuttable"):
				body.slot = $Slot1
				if not body.is_taken:
					$Slot1.snapped_item = body
					snapped_item_1 = body
					if not body.is_taken:
						$Slot1.add_item_to_slot(body)
						snapped_item_1 = $Slot1.snapped_item


func _on_place_1_body_exited(body):
	if $Slot1.snapped_item == body:
		$Slot1.snapped_item = null
		snapped_item_1 = null
		$Slot1.is_occupied = false
	body.slot = null


func action():
	if snapped_item_1 != null:
		if GameState.player.current_tool != null:
			if GameState.player.current_tool.is_in_group("cutting_board"):
			#TODO bug knife pas dans le goupe 
				if snapped_item_1.cooked_state != null:
					cutting_sound.play()
					var tween = get_tree().create_tween()
					tween.tween_property(GameState.player.current_tool,"rotation:z",15,0.2)
					tween.connect("finished", on_tween_cutting_finished)
				else:
					label_alert.text ="Cannot be cut !"
					label_alert.visible = true
					label_alert_timer.start(1)
			else:
				label_alert.text ="Wrong tool !"
				label_alert.visible = true
				label_alert_timer.start(1)
		else:
			label_alert.text ="Tool needed !"
			label_alert.visible = true
			label_alert_timer.start(1)
			
	
	
	
func on_tween_cutting_finished():
	var cooked_item = load(snapped_item_1.cooked_state).instantiate()
	cooked_item.set_global_position(snapped_item_1.global_position)
	snapped_item_1.queue_free()
	GameState.current_level.add_child(cooked_item)
	snapped_item_1 = cooked_item


func _on_timer_timeout():
	label_alert.visible = false
