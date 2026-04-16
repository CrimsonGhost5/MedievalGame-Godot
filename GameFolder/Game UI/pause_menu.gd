extends CanvasLayer

@onready var start_menu =  preload("res://Game UI/start_menu.tscn")
@onready var gamma_slider = $CenterContainer/VBoxContainer/GammaSlider
@onready var gamma_overlay = $GammaOverlay
@onready var menu_ui = $CenterContainer
@onready var pause_bg = $BackGround
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_ui.visible = false
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_ALWAYS

	gamma_slider.value = 1.0
	gamma_slider.connect("value_changed", _on_gamma_changed)
	
func _on_gamma_changed(value: float) -> void:
	var material = gamma_overlay.material
	if material:
		material.set_shader_parameter("gamma", value)
		
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			menu_ui.visible = false
			get_tree().paused = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			menu_ui.visible = true
			get_tree().paused = true


func _on_resume_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	menu_ui.visible = false
	get_tree().paused = false

func _on_restart_pressed() -> void:
	GameState.set_value("health", 100)
	GameState.set_value("hunger", 100)
	GameState.set_value("food", 0)
	PlayerManager.starting_hunger_timer = 180
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Game UI/start_menu.tscn")
