extends Node3D


@onready var icons = [
	$step_1,
	$step_2,
	$step_3
	]
var rng = RandomNumberGenerator.new()

var step_state

func _ready():
	roll_menu()
		
func roll_menu():
	step_state = {
	"step_lettuce":false,
	"step_potato":false,
	"step_tomato":false,
	"step_carrot":false,
	"step_onion":false,
	}
	var step_pool = [0,1,2,3,4]
	for i in range(3):
		print(step_pool)
		var chosen_step = step_pool.pick_random()
		print(chosen_step)
		var current_step = step_state.keys()[chosen_step]
		step_pool.erase(chosen_step)
		step_state[current_step] = true
		print(current_step)
		icons[i].material.albedo_texture = load("res://assets/icons/"+str(current_step)+".png")

func _to_string():
	var menu_step:String = ""
	for step in step_state:
		if step_state[step]:
			menu_step = menu_step + str(step) + "\n"
	return menu_step

