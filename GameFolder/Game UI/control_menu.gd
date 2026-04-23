class_name ControlsMenu
extends Control

@onready var exit_button = $MarginContainer/VBoxContainer/ExitButton as Button

signal exit_controls_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit_button.pressed.connect(on_exit_pressed)
	set_process(false)
	exit_button.focus_mode = Control.FOCUS_ALL

func open_menu() -> void:
	set_process(true)
	visible = true
	exit_button.grab_focus()

func on_exit_pressed() -> void:
	exit_controls_menu.emit()
	set_process(false)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit_text"):
		exit_controls_menu.emit()
		set_process(false)
