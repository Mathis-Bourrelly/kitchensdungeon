class_name BowlStew extends Item

@onready var mesh :MeshInstance3D = $bowl_mesh
@onready var audio = $AudioStreamPlayer
@onready var step_lettuce = $stew_step_lettuce
@onready var step_potato = $stew_step_potato
@onready var step_tomato = $stew_step_tomato
@onready var step_carrot = $stew_step_carrot
@onready var step_onion = $stew_step_onion
var accepted_step = ["step_lettuce","step_potato","step_tomato","step_carrot","step_onion"]

var step_state = {
	"step_lettuce":false,
	"step_potato":false,
	"step_tomato":false,
	"step_carrot":false,
	"step_onion":false,
}

func _ready():
	super._ready()
	var root = get_node(".")
	root.add_to_group("bowl")
	root.add_to_group("tool")

func _on_body_entered(body):
	if not is_taken:
		audio.play()

		
func add_step(step_name):
	var current_step_mesh = get_node("stew_"+str(step_name.get_groups()[2]))
	if current_step_mesh != null:
		if not current_step_mesh.visible:
			current_step_mesh.visible = true
			step_state[str(step_name.get_groups()[2])] = true
			return true
	return false
	
