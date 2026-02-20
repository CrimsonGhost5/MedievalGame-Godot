extends CanvasLayer

@onready var start_menu =  preload("res://Game UI/start_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			visible = false
			get_tree().paused = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			visible = true
			get_tree().paused = true


func _on_resume_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = false
	get_tree().paused = false

func _on_restart_pressed() -> void:
	GameState.set_value("health", 100)
	GameState.set_value("hunger", 100)
	GameState.set_value("food", 0)
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Game UI/start_menu.tscn")
