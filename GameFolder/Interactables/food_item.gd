extends Interactable

var collected = false



func _on_interacted(body: Variant) -> void:
	if not collected:
		collected = true
		$FoodCollectSFX.play()
		GameState.set_value("food", GameState.get_value("food") + 1)
		$CollisionShape3D.visible = false
	


func _on_food_collect_sfx_finished() -> void:
	queue_free()
