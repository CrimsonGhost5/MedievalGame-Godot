extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#So the player can see and interact with the gameover screen
func show_gameover():
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


#Reset everything on player starts over
func _on_restart_button_pressed() -> void:
	print("Is pressed")
	GameState.set_value("health", 100)
	GameState.set_value("hunger", 100)
	GameState.set_value("food", 0)
	PlayerManager.starting_hunger_timer = 60
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	print("Is pressed")
	GameState.set_value("food", 0)
	get_tree().change_scene_to_file("res://Game UI/start_menu.tscn")
