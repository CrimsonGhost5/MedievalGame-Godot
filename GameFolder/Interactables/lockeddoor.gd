extends Node3D

var playback = AnimationNodeStateMachinePlayback
var is_open := false

func _ready() -> void:
	playback = $"AnimationTree".get("parameters/playback")

func _on_door_handle_interacted(body: Variant) -> void:
	if not is_open and GameState.get_value("key") > 0 or GameState.get_value("door key") == true:
		is_open = true
		$AudioStreamPlayer3D.play()
		playback.travel("open")
		GameState.set_value("key", GameState.get_value("key") - 1)
		GameState.set_value("door key", false)
