extends Area3D

@onready var mesh :MeshInstance3D = $ring_mesh
@onready var wallorder

func send_meal():
	wallorder.send_meal()
