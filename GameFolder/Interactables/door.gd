extends Node3D

var playback = AnimationNodeStateMachinePlayback
var is_open := false

func _ready() -> void:
	playback = $"AnimationTree".get("parameters/playback")

func _on_door_handle_interacted(body: Variant) -> void:
	is_open = not is_open
	
	if is_open:
		$AudioStreamPlayer3D.play()
		playback.travel("open")
	else:
		$AudioStreamPlayer3D.play()
		playback.travel("close")
