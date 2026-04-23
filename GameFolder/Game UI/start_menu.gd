class_name StartMenu
extends Control


@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton as Button
@onready var controls_button = $MarginContainer/HBoxContainer/VBoxContainer/ControlsButton as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/ExitButton as Button
@onready var margin_container = $MarginContainer as MarginContainer
@onready var control_menu = $OptionMenu as ControlsMenu

@onready var start_level = preload("res://Levels/Maze_1.tscn") as PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handle_connecting_signals()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	start_button.focus_mode = Control.FOCUS_ALL
	controls_button.focus_mode = Control.FOCUS_ALL
	exit_button.focus_mode = Control.FOCUS_ALL
	start_button.grab_focus()



func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_options_pressed() -> void:
	control_menu.open_menu()
	margin_container.visible = false 
	control_menu.set_process(true) 
	control_menu.visible = true 
	control_menu.grab_focus()

func on_exit_controls_menu() -> void:
	margin_container.visible = true
	control_menu.visible = false
	start_button.grab_focus()

func on_exit_pressed() -> void:
	get_tree().quit()

func handle_connecting_signals() -> void:
	start_button.pressed.connect(on_start_pressed)
	controls_button.pressed.connect(on_options_pressed)
	exit_button.pressed.connect(on_exit_pressed)
	control_menu.exit_controls_menu.connect(on_exit_controls_menu)
