extends PanelContainer

@onready var label_menu = $MarginContainer/VBoxContainer/Label
@onready var restart_button = $MarginContainer/VBoxContainer/Restart
@onready var exit_button = $MarginContainer/VBoxContainer/Exit
# Called when the node enters the scene tree for the first time.
func _ready():
	label_menu.text = "Paused"

func _input(event):
	if (event is InputEventKey) and Input.is_action_just_pressed("escape") and GameState.gameover != true:
		show_menu()

func show_menu():
	if get_tree().paused:
		get_tree().paused = false
		GameState.menu.visible = false
		GameState.player.capture_mouse()
	else:
		get_tree().paused = true
		GameState.menu.visible = true
		GameState.player.release_mouse()



func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	


func _on_exit_pressed():
	get_tree().quit()
