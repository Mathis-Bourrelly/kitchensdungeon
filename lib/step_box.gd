extends StaticBody3D

@onready var snapped_item_1 = $Slot1.snapped_item
@onready var snapped_item_2 = $Slot2.snapped_item
@onready var snapped_item_3 = $Slot3.snapped_item
@onready var snapped_item_4 = $Slot4.snapped_item

@onready var snap_box_1 = $Slot1/place1
@onready var snap_box_2 = $slot2/place2
@onready var snap_box_3 = $Slot3/place3
@onready var snap_box_4 = $slot4/place4


func _ready():
	GameState.player.connect("droped_on_slot",_on_item_droped)
	$Slot1.parent = self
	$Slot2.parent = self
	$Slot3.parent = self
	$Slot4.parent = self

func _on_item_droped(item_to_snap):
	#if snapped_item_1 == null:	 TODO ???
		if item_to_snap.is_in_group("step"):
			item_to_snap.slot.add_item_to_slot(item_to_snap)


func _on_place_1_body_entered(body):
	if not $Slot1.is_occupied:
		if snapped_item_1 == null:	
			if body.is_in_group("step"):
				body.slot = $Slot1
				if not body.is_taken:
					$Slot1.snapped_item = body
					snapped_item_1 = body
					if not body.is_taken:
						$Slot1.add_item_to_slot(body)

func _on_place_2_body_entered(body):
	if not $Slot2.is_occupied:
		if snapped_item_2 == null:	
			if body.is_in_group("step"):
				body.slot = $Slot2
				if not body.is_taken:
					$Slot2.snapped_item = body
					snapped_item_2 = body
					if not body.is_taken:
						$Slot2.add_item_to_slot(body)

func _on_place_3_body_entered(body):
	if not $Slot3.is_occupied:
		if snapped_item_3 == null:	
			if body.is_in_group("step"):
				body.slot = $Slot3
				if not body.is_taken:
					$Slot3.snapped_item = body
					snapped_item_3 = body
					if not body.is_taken:
						$Slot3.add_item_to_slot(body)
						
func _on_place_4_body_entered(body):
	if not $Slot4.is_occupied:
		if snapped_item_4 == null:	
			if body.is_in_group("step"):
				body.slot = $Slot4
				if not body.is_taken:
					$Slot4.snapped_item = body
					snapped_item_4 = body
					if not body.is_taken:
						$Slot4.add_item_to_slot(body)

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

func _on_place_3_body_exited(body):
	if $Slot3.snapped_item == body:
		$Slot3.snapped_item = null
		snapped_item_3 = null
		$Slot3.is_occupied = false
	body.slot = null

func _on_place_4_body_exited(body):
	if $Slot4.snapped_item == body:
		$Slot4.snapped_item = null
		snapped_item_4 = null
		$Slot4.is_occupied = false
	body.slot = null
	
func action():
	pass
