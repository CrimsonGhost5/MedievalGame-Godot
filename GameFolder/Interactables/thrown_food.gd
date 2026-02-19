extends Interactable


@onready var timer = $Timer

func _on_interacted(body: Variant) -> void:
	$AudioStreamPlayer3D.play()
	GameState.set_value("food", GameState.get_value("food") + 1)
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		timer.start()
		

func _on_timer_timeout() -> void:
	queue_free()
