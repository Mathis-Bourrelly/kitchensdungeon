class_name Level extends Node3D

@export var key:String

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.gameover = false
	$Barbarian/AnimationPlayer.play("Cheer")
	$Knight/AnimationPlayer.play("Use_Item")
	$Mage/AnimationPlayer.play("Idle")
	$Rogue/AnimationPlayer.play("Interact")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_audio_stream_player_3d_finished():
	$AudioStreamPlayer3D.play()




func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
