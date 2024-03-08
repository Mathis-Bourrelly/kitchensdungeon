extends StaticBody3D

@export var time_at_start = 90

@onready var snapped_item_1 = $Slot1.snapped_item
@onready var snap_box_1 = $Slot1/place1
@onready var menu = $IconMenu
@onready var ring_audio = $Ring/AudioStreamPlayer3D
@onready var alarm_audio = $ClockLabel3D/AudioStreamPlayer3D
@onready var coin_audio = $Ring/CoinAudio
@onready var icon_coin = $Ring/coin

@onready var valid_icon = $ValidIconLabel3D
@onready var clock_label = $ClockLabel3D
@onready var timer = $ClockLabel3D/Timer
var is_meal_valid = false
var is_alarm_running = false

func _ready():
	GameState.player.connect("droped_on_slot",_on_item_droped)
	$Slot1.parent = self
	$Ring.wallorder = self
	timer.start(time_at_start)
	
func _process(delta):
	clock_label.text = "%d:%02d" % [floor(timer.time_left / 60), int(timer.time_left) % 60]
	if timer.time_left < 30:
		if not is_alarm_running:
			alarm_audio.play()
			clock_label.modulate = Color(1,0,0)
			is_alarm_running = true

func _on_item_droped(item_to_snap):
	#if snapped_item_1 == null:	 TODO ???
		if item_to_snap.is_in_group("bowl"):
			item_to_snap.slot.add_item_to_slot(item_to_snap)
			check_menu(item_to_snap)

func _on_place_1_body_entered(body):
	if not $Slot1.is_occupied:
		if snapped_item_1 == null:	
			if body.is_in_group("bowl"):
				body.slot = $Slot1
				if not body.is_taken:
					$Slot1.snapped_item = body
					snapped_item_1 = body
					if not body.is_taken:
						$Slot1.add_item_to_slot(body)
						check_menu(body)

func _on_place_1_body_exited(body):
	valid_icon.text = ""
	if $Slot1.snapped_item == body:
		$Slot1.snapped_item = null
		snapped_item_1 = null
		$Slot1.is_occupied = false
		valid_icon.modulate = Color(1,1,1)
	body.slot = null

func check_menu(body):
	print("menu = "+str(menu.step_state))
	print("body = "+str(body.step_state))
	for menuvar in menu.step_state:
		if menu.step_state[menuvar] == body.step_state[menuvar] :
			valid_icon.text = "✔"
			valid_icon.modulate = Color(0,1,0)
			is_meal_valid = true
		else:
			valid_icon.text = "❌"
			valid_icon.modulate = Color(1,0,0)
			is_meal_valid = false
			return

func send_meal():
	ring_audio.play()
	
	if is_meal_valid:
		snapped_item_1.queue_free()
		is_meal_valid = false
		menu.roll_menu()
		GameState.coin_count = GameState.coin_count + 15
		coin_audio.play()
		move_image()
		timer.start(timer.time_left+30)
		alarm_audio.stop()
		clock_label.modulate = Color(1,1,1)
		is_alarm_running = false

func action():
	pass

func move_image():
	icon_coin.visible = true
	var tween = get_tree().create_tween()
	var target_position = Vector2(1800,50)
	tween.tween_property(icon_coin, "position", target_position, 0.5)
	tween.connect("finished", on_tween_coin_finished)

func on_tween_coin_finished():
	icon_coin.visible = false
	var restart_position = Vector2(900,500)
	icon_coin.position = restart_position

func _on_timer_timeout():
	GameState.gameover = true
	GameState.menu.label_menu.text = "Game Over !"
	GameState.menu.show_menu()
