extends StaticBody3D

@onready var snapped_item_1 = $Slot1.snapped_item
@onready var snapped_item_2 = $Slot2.snapped_item

@onready var snap_box_1 = $Slot1/place1
@onready var snap_box_2 = $slot2/place2
#@onready var slot1:Marker3D = $Slot1
#@onready var slot2:Marker3D = $Slot2



func _ready():
	GameState.player.connect("droped_on_slot",_on_item_droped)
	$Slot1.parent = self
	$Slot2.parent = self

func _on_item_droped(item_to_snap):
	#if snapped_item_1 == null:	 TODO ???
		if item_to_snap.is_in_group("knife"):
			item_to_snap.slot.add_item_to_slot(item_to_snap)


func _on_place_1_body_entered(body):
	if not $Slot1.is_occupied:
		if snapped_item_1 == null:	
			if body.is_in_group("knife"):
				body.slot = $Slot1
				if not body.is_taken:
					$Slot1.snapped_item = body
					snapped_item_1 = body
					if not body.is_taken:
						$Slot1.add_item_to_slot(body)

func _on_place_2_body_entered(body):
	if not $Slot2.is_occupied:
		if snapped_item_2 == null:	
			if body.is_in_group("knife"):
				body.slot = $Slot2
				if not body.is_taken:
					$Slot2.snapped_item = body
					snapped_item_2 = body
					if not body.is_taken:
						$Slot2.add_item_to_slot(body)


func _on_place_1_body_exited(body):
	if $Slot1.snapped_item == body:
		$Slot1.snapped_item = null
		snapped_item_1 = null
		$Slot1.is_occupied = false
	body.slot = null


func _on_place_2_body_exited(body):
	if $Slot2.snapped_item == body:
		$Slot2.snapped_item = null
		snapped_item_2 = null
		$Slot2.is_occupied = false
	body.slot = null


func action():
	pass
