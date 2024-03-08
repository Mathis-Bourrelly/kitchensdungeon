class_name Knife extends Item

@onready var mesh :MeshInstance3D = $knife_mesh
@onready var audio = $AudioStreamPlayer



func _ready():
	super._ready()
	var root = get_node(".")
	root.add_to_group("tool")
	root.add_to_group("knife")
	root.add_to_group("cutting_board")
	



func _on_body_entered(body):
	if not is_taken:
		audio.play()
