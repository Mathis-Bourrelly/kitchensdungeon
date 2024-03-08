extends Node3D

@onready var coin_count_label = $MarginContainer/HBoxContainer6/CoinCount

# Called when the node enters the scene tree for the first time.
func _ready():
	coin_count_label.text = str(GameState.coin_count)
	GameState.player = $Player
	_enter_level("default", "level_2", "SpawnPoint")
	GameState.menu = $Menu
	
func _process(delta):
	coin_count_label.text = str(GameState.coin_count)

func _enter_level(from:String, to:String, use_spawn_point:String):
		if (GameState.current_level != null): GameState.current_level.queue_free()
		GameState.current_level = load("res://levels/"+to+".tscn").instantiate()
		GameState.current_level_key = to
		add_child(GameState.current_level)
		if (use_spawn_point):
			for spawnpoint:SpawnPoint in GameState.current_level.find_children("","SpawnPoint"):
				if (spawnpoint.key == from):
					GameState.player.position = spawnpoint.position
					
