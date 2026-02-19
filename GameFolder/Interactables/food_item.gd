extends Interactable




func _on_interacted(body: Variant) -> void:
	$AudioStreamPlayer3D.play()
	GameState.set_value("food", GameState.get_value("food") + 1)
	queue_free()
