extends Interactable

var collected = false
@onready var timer = $Timer

func _on_interacted(body: Variant) -> void:
	if not collected:
		collected = true
		$FoodCollectSFX.play()
		GameState.set_value("food", GameState.get_value("food") + 1)
		$CollisionShape3D.visible = false

func _on_food_collect_sfx_finished() -> void:
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		timer.start()
		print("Gone!!")
	else:
		return
	
	

func _on_timer_timeout() -> void:
	queue_free()
