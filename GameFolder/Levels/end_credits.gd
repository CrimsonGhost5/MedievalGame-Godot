extends Control

@onready var exit_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ExitButton

@onready var start_menu = preload("res://Game UI/start_menu.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	exit_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_packed(start_menu)
