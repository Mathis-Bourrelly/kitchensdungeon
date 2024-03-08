class_name Bowl extends Item

@onready var mesh :MeshInstance3D = $bowl_mesh
@onready var audio = $AudioStreamPlayer


func _ready():
	super._ready()
	var root = get_node(".")
	root.add_to_group("bowl")
	root.add_to_group("tool")

func _on_body_entered(body):
	if not is_taken:
		audio.play()

