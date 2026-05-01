extends CanvasLayer

@onready var restart_button: Button = $Panel/BoxContainer/VBoxContainer2/VBoxContainer/RestartButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#So the player can see and interact with the gameover screen
func show_gameover():
	if visible == false:
		restart_button.grab_focus()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$AudioStreamPlayer3D.play()
		visible = true


#Reset everything on player starts over
func _on_restart_button_pressed() -> void:
	GameState.set_value("health", 100)
	GameState.set_value("hunger", 100)
	GameState.set_value("food", 0)
	PlayerManager.starting_hunger_timer = 60
	get_tree().reload_current_scene()
	GameState.set_value("door key", false)
	


func _on_quit_button_pressed() -> void:
	GameState.set_value("health", 100)
	GameState.set_value("hunger", 100)
	GameState.set_value("food", 0)
	GameState.set_value("door key", false)
	get_tree().change_scene_to_file("res://Game UI/start_menu.tscn")
